Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEEDFFEA4
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 07:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfKRGlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 01:41:11 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32991 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfKRGlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 01:41:10 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay6so9205872plb.0;
        Sun, 17 Nov 2019 22:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/qRDpTuHSaxra0ZryF9lFCE9Z9U87W8xL5zTG8OfsT4=;
        b=DkiDYZDgILlJ6gOFu122cEbhGeFIyxX+8IhDANFtDdEGWe6/v5LaCP7EE3PePPuReE
         KaDJKxXO8X+0u1ksbpgyRvlFos5gU4kCo+nEAnjnL/xaKslPhKrdLCgX6f4PnwD2aset
         3NJrknbYySCrLyhfvvYJnYISLRbQ+UKGjMc3EgJY/Cocr4/YLS67GuNW7OqEqE8I8kOm
         Amxmvb5WF/0jpVVCB8UcLWdyvPWHAQ15U0Bi6ryzi+Dcsjpv00zQH/y5dKFNq2uV4Xe/
         6Dy0EDCH0ZVU+Q6b29enBRqKz9qGUdRGUXllGedXav63MicZFZVIU7XbffN1SiZVUlrQ
         eIuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/qRDpTuHSaxra0ZryF9lFCE9Z9U87W8xL5zTG8OfsT4=;
        b=FhYOEkgMcPUOODw8vWbmPbr9BzUjwWnJPmv8D2p77OSdigLzJYfh5eQDpNg9nbJmpa
         YfTZ34Gy7l3lbWJMw8afcfgpYe52SR1guUxxO/rYMTFfQbyng30v8dH9Z8iEmlZ5HXAw
         VPKE+xkBDr91Gjlkd0MxPSqx6xRQ+666jYQmQCqSbZ8tmtayrlR3GwspZtHvDFN8Ih6K
         GSOIlJIhxRaETInSNhP8FyzGbiJ5mqxAVWQN9MUlZzTlk3b9RPcjPRJfC7RDAEb/G6Km
         ykraz0BBBDAVfVqrqeW9gqCXwXHwu2Rk1Z4lRmjLps1N1/xV2Jwpo6xXrKzh4gBkvoqk
         83Xg==
X-Gm-Message-State: APjAAAX+5yLvrWTMA8AojN5OJ6NTKvqZnQTcDtRVJOst7rXj6gbf4Wwf
        yjiANOf3wjczFh4YXkO0R6g=
X-Google-Smtp-Source: APXvYqyv+rcK04dTxwt8n0qZBR75oFs3MI+I1VfLUffw8/q6SOPmNHSygJ0OvRXqeotIL/LDTfF1BQ==
X-Received: by 2002:a17:902:760d:: with SMTP id k13mr15393744pll.28.1574059268404;
        Sun, 17 Nov 2019 22:41:08 -0800 (PST)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id r16sm16340904pgl.77.2019.11.17.22.41.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Nov 2019 22:41:07 -0800 (PST)
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
 <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
 <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com>
 <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
 <87h840oese.fsf@toke.dk>
 <5db128153c75_549d2affde7825b85e@john-XPS-13-9370.notmuch>
 <87sgniladm.fsf@toke.dk> <a7f3d86b-c83c-7b0d-c426-684b8dfe4344@gmail.com>
 <87zhhmrz7w.fsf@toke.dk> <b2ecf3e6-a8f1-cfd9-0dd3-e5f4d5360c0b@gmail.com>
 <87zhhhnmg8.fsf@toke.dk> <640418c3-54ba-cd62-304f-fd9f73f25a42@gmail.com>
 <87blthox30.fsf@toke.dk> <c1b7ff64-6574-74c7-cd6b-5aa353ec80ce@gmail.com>
 <87lfsiocj5.fsf@toke.dk>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <6e08f714-6284-6d0d-9cbe-711c64bf97aa@gmail.com>
Date:   Mon, 18 Nov 2019 15:41:00 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87lfsiocj5.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/11/14 21:41, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
> 
>> On 2019/11/13 1:53, Toke Høiland-Jørgensen wrote:
>>> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>>>
>>>> Hi Toke,
>>>>
>>>> Sorry for the delay.
>>>>
>>>> On 2019/10/31 21:12, Toke Høiland-Jørgensen wrote:
>>>>> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>>>>
>>>>>> On 2019/10/28 0:21, Toke Høiland-Jørgensen wrote:
>>>>>>> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>>>>>>>> Yeah, you are right that it's something we're thinking about. I'm not
>>>>>>>>> sure we'll actually have the bandwidth to implement a complete solution
>>>>>>>>> ourselves, but we are very much interested in helping others do this,
>>>>>>>>> including smoothing out any rough edges (or adding missing features) in
>>>>>>>>> the core XDP feature set that is needed to achieve this :)
>>>>>>>>
>>>>>>>> I'm very interested in general usability solutions.
>>>>>>>> I'd appreciate if you could join the discussion.
>>>>>>>>
>>>>>>>> Here the basic idea of my approach is to reuse HW-offload infrastructure
>>>>>>>> in kernel.
>>>>>>>> Typical networking features in kernel have offload mechanism (TC flower,
>>>>>>>> nftables, bridge, routing, and so on).
>>>>>>>> In general these are what users want to accelerate, so easy XDP use also
>>>>>>>> should support these features IMO. With this idea, reusing existing
>>>>>>>> HW-offload mechanism is a natural way to me. OVS uses TC to offload
>>>>>>>> flows, then use TC for XDP as well...
>>>>>>>
>>>>>>> I agree that XDP should be able to accelerate existing kernel
>>>>>>> functionality. However, this does not necessarily mean that the kernel
>>>>>>> has to generate an XDP program and install it, like your patch does.
>>>>>>> Rather, what we should be doing is exposing the functionality through
>>>>>>> helpers so XDP can hook into the data structures already present in the
>>>>>>> kernel and make decisions based on what is contained there. We already
>>>>>>> have that for routing; L2 bridging, and some kind of connection
>>>>>>> tracking, are obvious contenders for similar additions.
>>>>>>
>>>>>> Thanks, adding helpers itself should be good, but how does this let users
>>>>>> start using XDP without having them write their own BPF code?
>>>>>
>>>>> It wouldn't in itself. But it would make it possible to write XDP
>>>>> programs that could provide the same functionality; people would then
>>>>> need to run those programs to actually opt-in to this.
>>>>>
>>>>> For some cases this would be a simple "on/off switch", e.g.,
>>>>> "xdp-route-accel --load <dev>", which would install an XDP program that
>>>>> uses the regular kernel routing table (and the same with bridging). We
>>>>> are planning to collect such utilities in the xdp-tools repo - I am
>>>>> currently working on a simple packet filter:
>>>>> https://github.com/xdp-project/xdp-tools/tree/xdp-filter
>>>>
>>>> Let me confirm how this tool adds filter rules.
>>>> Is this adding another commandline tool for firewall?
>>>>
>>>> If so, that is different from my goal.
>>>> Introducing another commandline tool will require people to learn
>>>> more.
>>>>
>>>> My proposal is to reuse kernel interface to minimize such need for
>>>> learning.
>>>
>>> I wasn't proposing that this particular tool should be a replacement for
>>> the kernel packet filter; it's deliberately fairly limited in
>>> functionality. My point was that we could create other such tools for
>>> specific use cases which could be more or less drop-in (similar to how
>>> nftables has a command line tool that is compatible with the iptables
>>> syntax).
>>>
>>> I'm all for exposing more of the existing kernel capabilities to XDP.
>>> However, I think it's the wrong approach to do this by reimplementing
>>> the functionality in eBPF program and replicating the state in maps;
>>> instead, it's better to refactor the existing kernel functionality to it
>>> can be called directly from an eBPF helper function. And then ship a
>>> tool as part of xdp-tools that installs an XDP program to make use of
>>> these helpers to accelerate the functionality.
>>>
>>> Take your example of TC rules: You were proposing a flow like this:
>>>
>>> Userspace TC rule -> kernel rule table -> eBPF map -> generated XDP
>>> program
>>>
>>> Whereas what I mean is that we could do this instead:
>>>
>>> Userspace TC rule -> kernel rule table
>>>
>>> and separately
>>>
>>> XDP program -> bpf helper -> lookup in kernel rule table
>>
>> Thanks, now I see what you mean.
>> You expect an XDP program like this, right?
>>
>> int xdp_tc(struct xdp_md *ctx)
>> {
>> 	int act = bpf_xdp_tc_filter(ctx);
>> 	return act;
>> }
> 
> Yes, basically, except that the XDP program would need to parse the
> packet first, and bpf_xdp_tc_filter() would take a parameter struct with
> the parsed values. See the usage of bpf_fib_lookup() in
> bpf/samples/xdp_fwd_kern.c
> 
>> But doesn't this way lose a chance to reduce/minimize the program to
>> only use necessary features for this device?
> 
> Not necessarily. Since the BPF program does the packet parsing and fills
> in the TC filter lookup data structure, it can limit what features are
> used that way (e.g., if I only want to do IPv6, I just parse the v6
> header, ignore TCP/UDP, and drop everything that's not IPv6). The lookup
> helper could also have a flag argument to disable some of the lookup
> features.

It's unclear to me how to configure that.
Use options when attaching the program? Something like
$ xdp_tc attach eth0 --only-with ipv6
But can users always determine their necessary features in advance?
Frequent manual reconfiguration when TC rules frequently changes does not sound nice.
Or, add hook to kernel to listen any TC filter event on some daemon and automatically
reload the attached program?

Another concern is key size. If we use the TC core then TC will use its hash table with
fixed key size. So we cannot decrease the size of hash table key in this way?

> 
> It would probably require a bit of refactoring in the kernel data
> structures so they can be used without being tied to an skb. David Ahern
> did something similar for the fib. For the routing table case, that
> resulted in a significant speedup: About 2.5x-3x the performance when
> using it via XDP (depending on the number of routes in the table).

I'm curious about how much the helper function can improve the performance compared to
XDP programs which emulates kernel feature without using such helpers.
2.5x-3x sounds a bit slow as XDP to me, but it can be routing specific problem.

Toshiaki Makita
