Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAF75A437A
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 09:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiH2HBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 03:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiH2HBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:01:00 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D662846DB9;
        Mon, 29 Aug 2022 00:00:58 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MGLpm2KH0z1N7dl;
        Mon, 29 Aug 2022 14:57:20 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 15:00:56 +0800
Message-ID: <012b98b7-dd8f-2df6-6b78-a0da6dd8065a@huawei.com>
Date:   Mon, 29 Aug 2022 15:00:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next] net: sched: remove redundant NULL check in
 change hook function
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <toke@toke.dk>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <stephen@networkplumber.org>,
        <cake@lists.bufferbloat.net>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20220827014910.215062-1-shaozhengchao@huawei.com>
 <YwxQQOzw/dGKJKyB@pop-os.localdomain>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <YwxQQOzw/dGKJKyB@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/8/29 13:36, Cong Wang wrote:
> On Sat, Aug 27, 2022 at 09:49:10AM +0800, Zhengchao Shao wrote:
>> Currently, the change function can be called by two ways. The one way is
>> that qdisc_change() will call it. Before calling change function,
>> qdisc_change() ensures tca[TCA_OPTIONS] is not empty. The other way is
>> that .init() will call it. The opt parameter is also checked before
>> calling change function in .init(). Therefore, it's no need to check the
>> input parameter opt in change function.
>>
> 
> Right.. but the one below:
> 
>> diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
>> index c50a0853dcb9..e23d3dbb7272 100644
>> --- a/net/sched/sch_gred.c
>> +++ b/net/sched/sch_gred.c
>> @@ -413,9 +413,6 @@ static int gred_change_table_def(struct Qdisc *sch, struct nlattr *dps,
>>   	bool red_flags_changed;
>>   	int i;
>>   
>> -	if (!dps)
>> -		return -EINVAL;
>> -
> 
> I don't think anyone checks tb[TCA_GRED_DPS]. What you intended to patch
> is gred_change(), right?
> 
> Thanks.

Hi Wang:
	Thank you for your reply. You are right. I will send v2.

Zhengchao Shao
