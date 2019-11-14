Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04EAFFC3BC
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfKNKLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:11:45 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40153 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfKNKLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:11:45 -0500
Received: by mail-pg1-f195.google.com with SMTP id 15so3461750pgt.7;
        Thu, 14 Nov 2019 02:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HffFdVjmwEs9ZOtDod+7zZx3yqjMlEqkq4943CeHBYw=;
        b=LRFXF/y3MlOziXBXy+gznC/sQeGuK6RPW1sc8T+MhLE1aooRpm5l9ve4J4dTwbgGMF
         41CITp1XSPoF702jv5lbOHL9ScLjKOYwW+ecw2DpHYaJ4+vB+sYqtC/m2a3RCTpBx2HQ
         6Q16CC/1FdI2ZUHJY3vM3+u6zhgSii9+aLiFubm1TLGcqssMuCKZpCMS26jBE4MJPy/E
         FA3SwuhtCAeK4UJwxU3bRsMd9CSA1mUjivGhwNXsCG7fCmQfsG0FtMrjCOngGD62HuJH
         wHqRN/bLfBl/Y2EADoYw+DFfzrBEIJuJoHRHEex8PqxrWXijsgirPEqRDcfBNjd/H8fu
         uLwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HffFdVjmwEs9ZOtDod+7zZx3yqjMlEqkq4943CeHBYw=;
        b=DqOkdaz5m2E3EepTnU7e0viQWU2YPkbS5u1Doc4IgRJ4frwqEY+5tE3l/U8wdycwLI
         iqnPLD63zGoe771Ty7/RxLcGZdhkItXqykvNUWbrutTUBVBX7VPc8s2V4oCrCAnVdqcT
         /kREieZKrfYguBed4pUCY+d3H9R6IHluXcgc3B2QviZBSGO2yac9G7gLR3twCSdeu8sH
         74NDm9Sa/pvS4tep6kLGcvKI9o6zc71p6Kfgsb+Y8Itgko64GppL1N+GmCvF21tY+HPZ
         O05VXDoUPRr0uoHDrAyOwddfpgmIG2SeJfrVOb8lXhl7/Y9io7c+fYE58THJv2LoluP0
         bLqQ==
X-Gm-Message-State: APjAAAWsJL4+bhD0qZ8OVGhKU7Vg280wC345Hv86Pxh5aOYtt2YwTk3J
        oBhXd/B18unTt2zaBMxputQ=
X-Google-Smtp-Source: APXvYqzx0TsofFXQQKZorTOo3Pw2KOiByTz2iqBUKNqkYfn3CPMtBqFwsm6v/LMnYfw4xHdinvNNEQ==
X-Received: by 2002:a62:b607:: with SMTP id j7mr6416156pff.39.1573726303895;
        Thu, 14 Nov 2019 02:11:43 -0800 (PST)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id m67sm5412557pje.32.2019.11.14.02.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 02:11:43 -0800 (PST)
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
 <87blthox30.fsf@toke.dk>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <c1b7ff64-6574-74c7-cd6b-5aa353ec80ce@gmail.com>
Date:   Thu, 14 Nov 2019 19:11:36 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87blthox30.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/11/13 1:53, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>
>> Hi Toke,
>>
>> Sorry for the delay.
>>
>> On 2019/10/31 21:12, Toke Høiland-Jørgensen wrote:
>>> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>>
>>>> On 2019/10/28 0:21, Toke Høiland-Jørgensen wrote:
>>>>> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>>>>>> Yeah, you are right that it's something we're thinking about. I'm not
>>>>>>> sure we'll actually have the bandwidth to implement a complete solution
>>>>>>> ourselves, but we are very much interested in helping others do this,
>>>>>>> including smoothing out any rough edges (or adding missing features) in
>>>>>>> the core XDP feature set that is needed to achieve this :)
>>>>>>
>>>>>> I'm very interested in general usability solutions.
>>>>>> I'd appreciate if you could join the discussion.
>>>>>>
>>>>>> Here the basic idea of my approach is to reuse HW-offload infrastructure
>>>>>> in kernel.
>>>>>> Typical networking features in kernel have offload mechanism (TC flower,
>>>>>> nftables, bridge, routing, and so on).
>>>>>> In general these are what users want to accelerate, so easy XDP use also
>>>>>> should support these features IMO. With this idea, reusing existing
>>>>>> HW-offload mechanism is a natural way to me. OVS uses TC to offload
>>>>>> flows, then use TC for XDP as well...
>>>>>
>>>>> I agree that XDP should be able to accelerate existing kernel
>>>>> functionality. However, this does not necessarily mean that the kernel
>>>>> has to generate an XDP program and install it, like your patch does.
>>>>> Rather, what we should be doing is exposing the functionality through
>>>>> helpers so XDP can hook into the data structures already present in the
>>>>> kernel and make decisions based on what is contained there. We already
>>>>> have that for routing; L2 bridging, and some kind of connection
>>>>> tracking, are obvious contenders for similar additions.
>>>>
>>>> Thanks, adding helpers itself should be good, but how does this let users
>>>> start using XDP without having them write their own BPF code?
>>>
>>> It wouldn't in itself. But it would make it possible to write XDP
>>> programs that could provide the same functionality; people would then
>>> need to run those programs to actually opt-in to this.
>>>
>>> For some cases this would be a simple "on/off switch", e.g.,
>>> "xdp-route-accel --load <dev>", which would install an XDP program that
>>> uses the regular kernel routing table (and the same with bridging). We
>>> are planning to collect such utilities in the xdp-tools repo - I am
>>> currently working on a simple packet filter:
>>> https://github.com/xdp-project/xdp-tools/tree/xdp-filter
>>
>> Let me confirm how this tool adds filter rules.
>> Is this adding another commandline tool for firewall?
>>
>> If so, that is different from my goal.
>> Introducing another commandline tool will require people to learn
>> more.
>>
>> My proposal is to reuse kernel interface to minimize such need for
>> learning.
> 
> I wasn't proposing that this particular tool should be a replacement for
> the kernel packet filter; it's deliberately fairly limited in
> functionality. My point was that we could create other such tools for
> specific use cases which could be more or less drop-in (similar to how
> nftables has a command line tool that is compatible with the iptables
> syntax).
> 
> I'm all for exposing more of the existing kernel capabilities to XDP.
> However, I think it's the wrong approach to do this by reimplementing
> the functionality in eBPF program and replicating the state in maps;
> instead, it's better to refactor the existing kernel functionality to it
> can be called directly from an eBPF helper function. And then ship a
> tool as part of xdp-tools that installs an XDP program to make use of
> these helpers to accelerate the functionality.
> 
> Take your example of TC rules: You were proposing a flow like this:
> 
> Userspace TC rule -> kernel rule table -> eBPF map -> generated XDP
> program
> 
> Whereas what I mean is that we could do this instead:
> 
> Userspace TC rule -> kernel rule table
> 
> and separately
> 
> XDP program -> bpf helper -> lookup in kernel rule table

Thanks, now I see what you mean.
You expect an XDP program like this, right?

int xdp_tc(struct xdp_md *ctx)
{
	int act = bpf_xdp_tc_filter(ctx);
	return act;
}

But doesn't this way lose a chance to reduce/minimize the program
to only use necessary features for this device?

Toshiaki Makita
