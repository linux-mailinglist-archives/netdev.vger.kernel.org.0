Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5612B3B1D
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 02:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgKPBJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 20:09:21 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:16652 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727524AbgKPBJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 20:09:21 -0500
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 2F77D5C1E63;
        Mon, 16 Nov 2020 09:09:10 +0800 (CST)
Subject: Re: [PATCH v10 net-next 3/3] net/sched: act_frag: add implict packet
 fragment support.
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn>
 <1605151497-29986-4-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpUu7feBGrunNPqn8FhEhgvfB_c854uEEuo5MQYcEvP_bg@mail.gmail.com>
 <459a1453-8026-cca1-fb7c-ded0890992cf@ucloud.cn>
 <81ce3451-a40b-ae54-fb7b-420d5557e839@mojatatu.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <b05a0040-9013-3836-6789-3329f659307d@ucloud.cn>
Date:   Mon, 16 Nov 2020 09:09:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <81ce3451-a40b-ae54-fb7b-420d5557e839@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGR5DGUxPH0IaTR9DVkpNS05PQ0NCTktOSkxVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NxQ6TAw4NT06Pj4oTS8uTDgV
        Nj9PCQ5VSlVKTUtOT0NDQk5LTEtLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFIT0lNNwY+
X-HM-Tid: 0a75ce993cb72087kuqy2f77d5c1e63
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/16/2020 12:26 AM, Jamal Hadi Salim wrote:
> This nagged me:
> What happens if all the frags dont make it out?
> Should you at least return an error code(from tcf_fragment?)
> and get the action err counters incremented?
Thanks, Will do.
>
> cheers,
> jamal
>
> On 2020-11-15 8:05 a.m., wenxu wrote:
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
>>
>> All the operations in the act_frag  are single L3 action.
>>
>> So we put in a single module. to keep it as isolated/contained as possible
>>
>> Maybe put this in a single file is better than a module? Buildin in the tc core code or not.
>>
>> Enable this feature in Kconifg with NET_ACT_FRAG?
>>
>> +config NET_ACT_FRAG
>> +    bool "Packet fragmentation"
>> +    depends on NET_CLS_ACT
>> +    help
>> +         Say Y here to allow fragmenting big packets when outputting
>> +         with the mirred action.
>> +
>> +      If unsure, say N.
>>
>>
>>>
>
>
