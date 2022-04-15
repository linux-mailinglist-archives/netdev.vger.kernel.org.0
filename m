Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D20502041
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 03:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348544AbiDOCAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 22:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243450AbiDOCAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 22:00:48 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED03BB18A0;
        Thu, 14 Apr 2022 18:58:20 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.41:45858.1005876200
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-123.150.8.42 (unknown [10.64.8.41])
        by 189.cn (HERMES) with SMTP id D152B100213;
        Fri, 15 Apr 2022 09:58:18 +0800 (CST)
Received: from  ([123.150.8.42])
        by gateway-153622-dep-749df8664c-mvcg4 with ESMTP id 8d21f9a5c5c543a7be347287fe62d021 for daniel@iogearbox.net;
        Fri, 15 Apr 2022 09:58:19 CST
X-Transaction-ID: 8d21f9a5c5c543a7be347287fe62d021
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 123.150.8.42
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
Message-ID: <7b6e0e08-4440-f1aa-8e94-068e2e129aac@189.cn>
Date:   Fri, 15 Apr 2022 09:58:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 0/1] sample: bpf: introduce irqlat
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendan.d.gregg@gmail.com
References: <1649927240-18991-1-git-send-email-chensong_2000@189.cn>
 <2e6ee265-903c-2b5c-aefd-ec24f930c999@iogearbox.net>
 <ac371d36-2624-cdd8-0c15-62ccf53bed81@189.cn>
 <f4267d24-28ca-bd99-100e-6fa4ee84cc50@iogearbox.net>
From:   Song Chen <chensong_2000@189.cn>
In-Reply-To: <f4267d24-28ca-bd99-100e-6fa4ee84cc50@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bcc and bpftrace should be able to match my requirement, I will look 
into them, many thanks.

BR

Song

在 2022/4/14 23:32, Daniel Borkmann 写道:
> Hi Song,
> 
> On 4/14/22 1:25 PM, Song Chen wrote:
>> hi Daniel,
>>
>> Thanks for liking the idea.
>>
>> My target is embedded devices, that's why i get started from ebpf 
>> C.bcc and bpftrace is a good idea, but i prefer taking one thing at a 
>> time, what's more, i'm not familiar with python, it might take longer.
>>
>> Once C code is accepted, i will move myself to bcc and bpftrace. Is it 
>> ok for you?
> 
> The libbpf-based tools from the mentioned link in BCC are all C, not 
> Python. Also bpftrace
> has guidelines for building it more portably that would be suitable for 
> embedded devices [2].
> I'd presume these should still match your requirements?
> 
> Right now samples/bpf/ is a bit of a dumping ground of random things, 
> some BPF samples better
> maintained than others, but generally samples/bpf/ is a bit of a mess. 
> BPF has a huge ecosystem
> outside of kernel in its various areas it covers, so it has outgrown the 
> few samples in there
> long ago, and you'll find many resources on how to get started in the wild.
> 
> Adding this as a samples/bpf/ will have little value to others, since 
> people may not be aware
> of them, and if they are they need to manually build/ship it, etc. If 
> you upstream and can improve
> the tools in bpftrace/bcc as pointed out, then a lot more people will be 
> able to consume them
> and benefit from it, and you get the shipping via distros for free.
> 
>    [2] 
> https://github.com/iovisor/bpftrace/blob/master/docs/embedded_builds.md
> 
> Thanks again,
> Daniel
> 
>> BR
>>
>> Song
>>
>>
>> 在 2022/4/14 17:47, Daniel Borkmann 写道:
>>> On 4/14/22 11:07 AM, Song Chen wrote:
>>>> I'm planning to implement a couple of ebpf tools for preempt rt,
>>>> including irq latency, preempt latency and so on, how does it sound
>>>> to you?
>>>
>>> Sounds great, thanks! Please add these tools for upstream inclusion 
>>> either to bpftrace [0] or
>>> bcc [1], then a wider range of users would be able to benefit from 
>>> them as well as they are
>>> also shipped as distro packages and generally more widely used 
>>> compared to kernel samples.
>>>
>>> Thanks Song!
>>>
>>>    [0] https://github.com/iovisor/bpftrace/tree/master/tools
>>>    [1] https://github.com/iovisor/bcc/tree/master/libbpf-tools
>>>
>>>> Song Chen (1):
>>>>    sample: bpf: introduce irqlat
>>>>
>>>>   samples/bpf/.gitignore    |   1 +
>>>>   samples/bpf/Makefile      |   5 ++
>>>>   samples/bpf/irqlat_kern.c |  81 ++++++++++++++++++++++++++++++
>>>>   samples/bpf/irqlat_user.c | 100 
>>>> ++++++++++++++++++++++++++++++++++++++
>>>>   4 files changed, 187 insertions(+)
>>>>   create mode 100644 samples/bpf/irqlat_kern.c
>>>>   create mode 100644 samples/bpf/irqlat_user.c
>>>>
>>>
>>>
> 
> 
