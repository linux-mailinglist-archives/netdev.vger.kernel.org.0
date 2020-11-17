Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FF32B58B8
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 05:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgKQEOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 23:14:23 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:3709 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgKQEOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 23:14:22 -0500
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 03CC05C1955;
        Tue, 17 Nov 2020 12:01:42 +0800 (CST)
Subject: Re: [PATCH v10 net-next 3/3] net/sched: act_frag: add implict packet
 fragment support.
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn>
 <1605151497-29986-4-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpUu7feBGrunNPqn8FhEhgvfB_c854uEEuo5MQYcEvP_bg@mail.gmail.com>
 <459a1453-8026-cca1-fb7c-ded0890992cf@ucloud.cn>
 <CAM_iQpXDzKEEVic5SOiWsc30ipppYMHL4q0-J6mP6u0Brr1KGw@mail.gmail.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <2fe1ec73-eeeb-f32e-b006-afd135e03433@ucloud.cn>
Date:   Tue, 17 Nov 2020 12:01:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXDzKEEVic5SOiWsc30ipppYMHL4q0-J6mP6u0Brr1KGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZHxlPT0JOTEtPSkJIVkpNS05OQ05MS0hJTklVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mz46Kzo5Qz0yCD1KS0gpAQNM
        EgIaChFVSlVKTUtOTkNOTEtIT0lMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFISENDNwY+
X-HM-Tid: 0a75d45d91252087kuqy03cc05c1955
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/17/2020 3:01 AM, Cong Wang wrote:
> On Sun, Nov 15, 2020 at 5:06 AM wenxu <wenxu@ucloud.cn> wrote:
>>
>> 在 2020/11/15 2:05, Cong Wang 写道:
>>> On Wed, Nov 11, 2020 at 9:44 PM <wenxu@ucloud.cn> wrote:
>>>> diff --git a/net/sched/act_frag.c b/net/sched/act_frag.c
>>>> new file mode 100644
>>>> index 0000000..3a7ab92
>>>> --- /dev/null
>>>> +++ b/net/sched/act_frag.c
>>> It is kinda confusing to see this is a module. It provides some
>>> wrappers and hooks the dev_xmit_queue(), it belongs more to
>>> the core tc code than any modularized code. How about putting
>>> this into net/sched/sch_generic.c?
>>>
>>> Thanks.
>> All the operations in the act_frag  are single L3 action.
>>
>> So we put in a single module. to keep it as isolated/contained as possible
> Yeah, but you hook dev_queue_xmit() which is L2.
>
>> Maybe put this in a single file is better than a module? Buildin in the tc core code or not.
>>
>> Enable this feature in Kconifg with NET_ACT_FRAG?
> Sort of... If this is not an optional feature, that is a must-have
> feature for act_ct,
> we should just get rid of this Kconfig.
>
> Also, you need to depend on CONFIG_INET somewhere to use the IP
> fragment, no?
>
> Thanks.

Maybe the act_frag should rename to sch_frag and buildin kernel.

This fcuntion can be used for all tc subsystem. There is no need for

CONFIG_INET. The sched system depends on NET.

>
