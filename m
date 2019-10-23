Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35CDCE1DBE
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 16:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404096AbfJWOLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 10:11:32 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34149 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732167AbfJWOLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 10:11:31 -0400
Received: by mail-io1-f68.google.com with SMTP id q1so25132549ion.1
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 07:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7mTLchMz27yHE3v+HYqAFC8C62BOeIbxUWkxLK3+HgE=;
        b=wz5fAXRBiidu/z5ytS9ZYzs2p/f54ji1X/VUt1S6dvsdeizi+TGuiAKEwvYGaLPL+r
         AGH588kL/XUwIsKjL2jv4s+B+mklp2HceTbU5gVv29XMQ7hLhxNVgM+WZwxCqnL/kB6W
         9S2F+4FcrsZ+WFLU8B7FoJ4GHK2y4auXPe+2E+L4lHBbjyFCo0n7n5vs+oetDQSEmKJd
         Sx02iGMm6a74v0mlzw7HpoZmpJ0jCQtdAGtStSCN2yPp3eqNCbqS5gDnffiiVraBHgZ5
         qsdcvKnY5fmm7DMPKUIcd57u87UEU0AXNSxlTtfnmvSq2znf/ZUAU6mWI0NUofY4bUzw
         TZmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7mTLchMz27yHE3v+HYqAFC8C62BOeIbxUWkxLK3+HgE=;
        b=ZNT7sx1tFut48/xPeSNbf9XKJpR1cKsT2uU8fWxG5zr8nr5yptRfD7fKic+npwBdvp
         FPwLL7hwxu3Wa3m0CTfXHBKJrncTUowRldjee8eag04+69xqhSBiHkAXauX+GHU1xPny
         vmAboc2bqIa/xzfkp4fTfIT8pTt8a2ZOfvpznEvqzFCXi2gdPdgHgIVUlnXip8vop0FQ
         BhW47UhIWWe+bd2kbwgEBMjwrwia6LCdAON7U1vycnccFeNzKocPzZVbkTMvWaQSConx
         mRfIJiIpVtdA4ANop4u+0uor2imgC8niVeZwpnk+vpXF0/QpqTSSmHgC6BRqxAqBZpQV
         N3CQ==
X-Gm-Message-State: APjAAAVHmRVYzI7ypX8V8AzTRBeDyZsMclHVIQBW6DjA0lBUFRsQF11d
        62lwtEMWY9IqdH6Z0pete6LoHA==
X-Google-Smtp-Source: APXvYqzXSqJpybvFZImqCY3p1LdZnsNbk/MXtCsS6dh/u0592dO/rmk/bmILZWsaXLAyTeTec0xS6Q==
X-Received: by 2002:a02:19c1:: with SMTP id b184mr9607390jab.54.1571839889615;
        Wed, 23 Oct 2019 07:11:29 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id j74sm5898001ila.55.2019.10.23.07.11.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 07:11:27 -0700 (PDT)
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
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
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <1c794797-db6f-83a7-30b4-aa864f798e5b@mojatatu.com>
Date:   Wed, 23 Oct 2019 10:11:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Sorry - didnt read every detail of this thread so i may
be missing something.

On 2019-10-22 12:54 p.m., John Fastabend wrote:
> Toshiaki Makita wrote:
>> On 2019/10/19 0:22, John Fastabend wrote:
>>> Toshiaki Makita wrote:
>>>> This is a PoC for an idea to offload flow, i.e. TC flower and nftables,
>>>> to XDP.
>>>>

> 
> I don't know who this "someone" is that wants to use XDP through TC
> flower or nftables transparently. TC at least is not known for a
> great uapi. 


The uapi is netlink. You may be talking about lack of a friendly
application library that abstracts out concepts?

> It seems to me that it would be a relatively small project
> to write a uapi that ran on top of a canned XDP program to add
> flow rules. This could match tc cli if you wanted but why not take
> the opportunity to write a UAPI that does flow management well.
> 

Disagreement:
Unfortunately legacy utilities and apps cant just be magically wished
away. There's a lot of value in transparently making them work with
new infrastructure. My usual exaggerated pitch: 1000 books have been
written on this stuff, 100K people have RH certificates which entitle
them to be "experts"; dinasour kernels exist in data centres and
(/giggle) "enteprise". You cant just ignore all that.

Summary: there is value in what Toshiaki is doing.

I am disappointed that given a flexible canvas like XDP, we are still
going after something like flower... if someone was using u32 as the
abstraction it will justify it a lot more in my mind.
Tying it to OVS as well is not doing it justice.

Agreement:
Having said that I dont think that flower/OVS should be the interface
that XDP should be aware of. Neither do i agree that kernel "real
estate" should belong to Oneway(TM) of doing things (we are still stuck
with netfilter planting the columbus flag on all networking hooks).
Let 1000 flowers bloom.
So: couldnt Toshiaki's requirement be met with writting a user space
daemon that trampolines flower to "XDP format" flow transforms? That way
in the future someone could add a u32->XDP format flow definition and we
are not doomed to forever just use flower.

>> To some extent yes, but not completely. Flow insertion from userspace
>> triggered by datapath upcall is necessary regardless of whether we use
>> TC or not.
> 
> Right but these are latency involved with OVS architecture not
> kernel implementation artifacts. Actually what would be an interesting
> metric would be to see latency of a native xdp implementation.
> 
> I don't think we should add another implementation to the kernel
> that is worse than what we have.
> 
> 
>   xdp_flow  TC        ovs kmod
>   --------  --------  --------
>   22ms      6ms       0.6ms
> 
> TC is already order of magnitude off it seems :(
> 
 >
> If ovs_kmod is .6ms why am I going to use something that is 6ms or
> 22ms. 

I am speculating having not read Toshiaki's code.
The obvious case for the layering is for policy management.
As you go upwards hw->xdp->tc->userspace->remote control
your policies get richer and the resolved policies pushed down
are more resolved. I am guessing the numbers we see above are
for that first packet which is used as a control packet.
An automonous system like this is of course susceptible to
attacks.

The workaround would be to preload the rules, but even then
you will need to deal with resource constraints. Comparison
would be like hierarchies of cache to RAM: L1/2/3 before RAM.
To illustrate: Very limited fastest L1 (aka NIC offload),
Limited faster L2 (XDP algorithms), L3 being tc and RAM being
the user space resolution.

>I expect a native xdp implementation using a hash map to be
> inline with ovs kmod if not better.

Hashes are good for datapath use cases but not when you consider
a holistic access where you have to worry about control aspect.

cheers,
jamal
