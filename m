Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F33FF6F0D
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 08:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKKHcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 02:32:17 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34851 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfKKHcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 02:32:17 -0500
Received: by mail-pg1-f196.google.com with SMTP id q22so8937245pgk.2;
        Sun, 10 Nov 2019 23:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tfah8ydTbV4Vk21leuNsBaqVuTT+p9Q97bnJKdVRE1U=;
        b=pcz3zIi1RFLVb86rSL+Lha//pWcJTdie7cEdnb4aDPledvFRDseO7QXzEfntErDL7D
         GTRNHXnY0eoZ/lZvT8p0KeJ9F1PxFcJ9d0xtUlmA4PX/SoAzcsyBlYXj5uJ8q/hykaUN
         Ho1g5jrh3aZHUuy49KC5x3QCrMQra6o8HkdheEjtcK4FVq3MWwkZ3dvcFY7RsqYRO4GJ
         LLywLSTS5sSRHUTIaodbGdSR2JtSgW0EUFkKJ20IyeFUfWu+T1NmoB4sYn0UmjH4QDXY
         vVbq6M0QAEduOxISNl5dZUv6tUVC2DUgRWt6Z3yBmBBnVdPB/XijpGurEdE+unAG5hSj
         AfWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tfah8ydTbV4Vk21leuNsBaqVuTT+p9Q97bnJKdVRE1U=;
        b=jm/nqTV//Fphu/5kgOAFoc0ou8RQb3V4ACt4pjOR5blfg7ci1Z5BxgYi/xm9A34vCG
         qpuHPtOVXKCJFEYUm+EHvn+3+co97zfOAcPzM36kdwbxYbLZD6d+p1PRBeoDI1K9rXvS
         2RPUxrW78ZcmSzD9jvSjPpaixm0p02K3MxegZ+8yK6rYRt4zOW2ZoAsEsw/RKpBckixL
         Gn/QNARE+lGnoYI2J6YNIg5/ZRX+mXDscnzIuze4hOplL23EATBqVEQ/YfUTmdcKQTBF
         al2eIrS/seXgmlZ0ImjX8Yf9WnXRHFQ9GaY6a0lQiCvX3BOoUgXVsORUofloLn22Y8f8
         m18Q==
X-Gm-Message-State: APjAAAXATeeb31ITLvzFcMF4iW/kzmgSyVXe6/PKWwFP13ea8ry/aayj
        VPkmCXqyM4Cs4ShAZi4cw2k=
X-Google-Smtp-Source: APXvYqwcZky3xdKe2nKzljJvSq4p3aGqu3RU8ApbQxT5QDsZin2TU1N21iF5AmlPXABW834z8pTL/A==
X-Received: by 2002:a63:934d:: with SMTP id w13mr26629783pgm.185.1573457536519;
        Sun, 10 Nov 2019 23:32:16 -0800 (PST)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id w7sm15677228pfb.101.2019.11.10.23.32.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Nov 2019 23:32:15 -0800 (PST)
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
 <87zhhhnmg8.fsf@toke.dk>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <640418c3-54ba-cd62-304f-fd9f73f25a42@gmail.com>
Date:   Mon, 11 Nov 2019 16:32:08 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87zhhhnmg8.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

Sorry for the delay.

On 2019/10/31 21:12, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
> 
>> On 2019/10/28 0:21, Toke Høiland-Jørgensen wrote:
>>> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>>>> Yeah, you are right that it's something we're thinking about. I'm not
>>>>> sure we'll actually have the bandwidth to implement a complete solution
>>>>> ourselves, but we are very much interested in helping others do this,
>>>>> including smoothing out any rough edges (or adding missing features) in
>>>>> the core XDP feature set that is needed to achieve this :)
>>>>
>>>> I'm very interested in general usability solutions.
>>>> I'd appreciate if you could join the discussion.
>>>>
>>>> Here the basic idea of my approach is to reuse HW-offload infrastructure
>>>> in kernel.
>>>> Typical networking features in kernel have offload mechanism (TC flower,
>>>> nftables, bridge, routing, and so on).
>>>> In general these are what users want to accelerate, so easy XDP use also
>>>> should support these features IMO. With this idea, reusing existing
>>>> HW-offload mechanism is a natural way to me. OVS uses TC to offload
>>>> flows, then use TC for XDP as well...
>>>
>>> I agree that XDP should be able to accelerate existing kernel
>>> functionality. However, this does not necessarily mean that the kernel
>>> has to generate an XDP program and install it, like your patch does.
>>> Rather, what we should be doing is exposing the functionality through
>>> helpers so XDP can hook into the data structures already present in the
>>> kernel and make decisions based on what is contained there. We already
>>> have that for routing; L2 bridging, and some kind of connection
>>> tracking, are obvious contenders for similar additions.
>>
>> Thanks, adding helpers itself should be good, but how does this let users
>> start using XDP without having them write their own BPF code?
> 
> It wouldn't in itself. But it would make it possible to write XDP
> programs that could provide the same functionality; people would then
> need to run those programs to actually opt-in to this.
> 
> For some cases this would be a simple "on/off switch", e.g.,
> "xdp-route-accel --load <dev>", which would install an XDP program that
> uses the regular kernel routing table (and the same with bridging). We
> are planning to collect such utilities in the xdp-tools repo - I am
> currently working on a simple packet filter:
> https://github.com/xdp-project/xdp-tools/tree/xdp-filter

Let me confirm how this tool adds filter rules.
Is this adding another commandline tool for firewall?

If so, that is different from my goal.
Introducing another commandline tool will require people to learn more.

My proposal is to reuse kernel interface to minimize such need for learning.

Toshiaki Makita

> For more advanced use cases (such as OVS), the application packages will
> need to integrate and load their own XDP support. We should encourage
> that, and help smooth out any rough edges (such as missing features)
> needed for this to happen.
> 
> -Toke
> 
