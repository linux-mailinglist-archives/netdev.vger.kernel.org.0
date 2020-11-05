Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E94E2A79B4
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 09:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgKEIzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 03:55:38 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:42545 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgKEIzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 03:55:37 -0500
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 7BAD05C1D50;
        Thu,  5 Nov 2020 16:55:34 +0800 (CST)
Subject: Re: [PATCH net-next 2/2] net/sched: act_frag: add implict packet
 fragment support.
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org
References: <1604480192-25035-1-git-send-email-wenxu@ucloud.cn>
 <1604480192-25035-2-git-send-email-wenxu@ucloud.cn>
 <20201105080444.GP3837@localhost.localdomain>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <b9e9599f-7d39-2275-0677-930105890850@ucloud.cn>
Date:   Thu, 5 Nov 2020 16:55:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201105080444.GP3837@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZTEgYTRkaS0IYHUwaVkpNS09OTU1OSE9NSUtVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hPT1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MS46PAw*TD04GDoYPyswGik3
        H0MaCSNVSlVKTUtPTk1NTkhPTExDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJSE9CNwY+
X-HM-Tid: 0a75979e49a42087kuqy7bad05c1d50
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/5/2020 4:04 PM, Marcelo Ricardo Leitner wrote:
> On Wed, Nov 04, 2020 at 04:56:32PM +0800, wenxu@ucloud.cn wrote:
>
>
>
>> +
>>  static void tcf_action_goto_chain_exec(const struct tc_action *a,
>>  				       struct tcf_result *res)
>>  {
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index aba3cd8..e23bc1f 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -1541,6 +1541,8 @@ static int __init ct_init_module(void)
>>  	if (err)
>>  		goto err_register;
>>  
>> +	tcf_inc_xmit_hook();
>> +
> Considering the Kconfig is adding the "depends" already, and both can
> be compiled as modules, a request_module() loading act_frag here is
> welcomed. So that the system doesn't end up loading just act_ct (in
> which case, it would panic when outputting a packet).

Yes,  In the v2 move the tcf_xxx_xmit_hook tyoe function to the act_frag.c

So the caller modules like (act_ct) will depend on the act_frag and the act_frag

module will loading before the caller.

