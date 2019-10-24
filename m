Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D45E2999
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 06:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406851AbfJXEii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 00:38:38 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44099 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfJXEii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 00:38:38 -0400
Received: by mail-io1-f65.google.com with SMTP id w12so27815834iol.11;
        Wed, 23 Oct 2019 21:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=10v5gV4GrYLDVmG/gd7LlxcTtwHTxG7FmsJABGIV02k=;
        b=jLscal61cxshDtz/WAINIyC8H3CRofd8Bm68/AWgFlN0lQqr5jW0IV4uu1/ZFOJtfE
         airw8+49nv6FRVza7mofiXS/HgaqVBZBQGlx9ty2iVcQCCIa5AG8raEMdGj0kYuwtlLo
         wU92WPdx+A7l1unAw2+daBRF1DeaWpYmhOeWolkr74LfjcZwWweDArXGjclxFbAVTIMV
         CDwOS3g848YZT4Ugj+mMAyptUGgdjl3oBFcpt4kVNUsbiDUSGI2LLVk4OC9s/aEwVUnZ
         8Km2FYr1ULVSKmxuVq2X4DNX/j91PSiEV7vjSTtwpGQOrQK1URFdkqCV/YSU5mjuG1M4
         4RIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=10v5gV4GrYLDVmG/gd7LlxcTtwHTxG7FmsJABGIV02k=;
        b=cdhfa0jlW1buvSCFqaOkvtO1YMWdeTRqI/nrXz8PwUYqi5IhQFpWWJS4TcbARxy546
         xL/BJrmomlDg3Mz51Co3YTl78lobbRkEspToUeNXKpd94cU9hjTNBjerkbc08PqD1hVl
         ApGzz8xl5CM7zL/lDwlaW+kp48LtwG4VVL+jeV51rMjT3teGdUYAmHWwuiva4G6QQHmE
         e4OWTgPvgHnFK2Ap1UxNidN+L2SEh/08j8jE0vH8uFyrVEpMfjGlHjyCFRoqlRtxTiUe
         U/zSXOENWSkzuUhnv+2bb6FITjhDLKkgAs4m/YUekUaxynMDxK1/JRhUc/CUgZxGZm/T
         zl/w==
X-Gm-Message-State: APjAAAXdBxBGWh2/T9h/A0WHSNLsLiMCQBjkaTE/BLalR4F9xljAwhp+
        BcgHtcnFvnj+hwAq2JSCNAL13UiXzJQlMQ==
X-Google-Smtp-Source: APXvYqyuiqSBl4yn0iWpXhp0BY0HSc2+K7wGqQLruJ2yTpP/XcVgrfHV4jLVTsgm5Up5GJSH6FIpnQ==
X-Received: by 2002:a6b:f80b:: with SMTP id o11mr7545001ioh.46.1571891915403;
        Wed, 23 Oct 2019 21:38:35 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b65sm5573196ill.85.2019.10.23.21.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 21:38:34 -0700 (PDT)
Date:   Wed, 23 Oct 2019 21:38:26 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        John Fastabend <john.fastabend@gmail.com>,
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
Message-ID: <5db12ac278d9f_549d2affde7825b85c@john-XPS-13-9370.notmuch>
In-Reply-To: <1c794797-db6f-83a7-30b4-aa864f798e5b@mojatatu.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
 <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
 <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com>
 <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
 <1c794797-db6f-83a7-30b4-aa864f798e5b@mojatatu.com>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamal Hadi Salim wrote:
> 
> Sorry - didnt read every detail of this thread so i may
> be missing something.
> 
> On 2019-10-22 12:54 p.m., John Fastabend wrote:
> > Toshiaki Makita wrote:
> >> On 2019/10/19 0:22, John Fastabend wrote:
> >>> Toshiaki Makita wrote:
> >>>> This is a PoC for an idea to offload flow, i.e. TC flower and nftables,
> >>>> to XDP.
> >>>>
> 
> > 
> > I don't know who this "someone" is that wants to use XDP through TC
> > flower or nftables transparently. TC at least is not known for a
> > great uapi. 
> 
> 
> The uapi is netlink. You may be talking about lack of a friendly
> application library that abstracts out concepts?

Correct, sorry was not entirely precise. I've written tooling on top of
the netlink API to do what is needed and it worked out just fine.

I think it would be interesting (in this context of flower vs XDP vs
u32, etc.) to build a flow API that abstracts tc vs XDP away and leverages
the correct lower level mechanics as needed. Easier said than done
of course.

> 
> > It seems to me that it would be a relatively small project
> > to write a uapi that ran on top of a canned XDP program to add
> > flow rules. This could match tc cli if you wanted but why not take
> > the opportunity to write a UAPI that does flow management well.
> > 
> 
> Disagreement:
> Unfortunately legacy utilities and apps cant just be magically wished
> away. There's a lot of value in transparently making them work with
> new infrastructure. My usual exaggerated pitch: 1000 books have been
> written on this stuff, 100K people have RH certificates which entitle
> them to be "experts"; dinasour kernels exist in data centres and
> (/giggle) "enteprise". You cant just ignore all that.

But flower itself is not so old.

> 
> Summary: there is value in what Toshiaki is doing.
> 
> I am disappointed that given a flexible canvas like XDP, we are still
> going after something like flower... if someone was using u32 as the
> abstraction it will justify it a lot more in my mind.
> Tying it to OVS as well is not doing it justice.

William Tu worked on doing OVS natively in XDP at one point and
could provide more input on the pain points. But seems easier to just
modify OVS vs adding kernel shim code to take tc to xdp IMO.

> 
> Agreement:
> Having said that I dont think that flower/OVS should be the interface
> that XDP should be aware of. Neither do i agree that kernel "real
> estate" should belong to Oneway(TM) of doing things (we are still stuck
> with netfilter planting the columbus flag on all networking hooks).
> Let 1000 flowers bloom.
> So: couldnt Toshiaki's requirement be met with writting a user space
> daemon that trampolines flower to "XDP format" flow transforms? That way
> in the future someone could add a u32->XDP format flow definition and we
> are not doomed to forever just use flower.

A user space daemon I agree would work.

> 
> >> To some extent yes, but not completely. Flow insertion from userspace
> >> triggered by datapath upcall is necessary regardless of whether we use
> >> TC or not.
> > 
> > Right but these are latency involved with OVS architecture not
> > kernel implementation artifacts. Actually what would be an interesting
> > metric would be to see latency of a native xdp implementation.
> > 
> > I don't think we should add another implementation to the kernel
> > that is worse than what we have.
> > 
> > 
> >   xdp_flow  TC        ovs kmod
> >   --------  --------  --------
> >   22ms      6ms       0.6ms
> > 
> > TC is already order of magnitude off it seems :(
> > 
>  >
> > If ovs_kmod is .6ms why am I going to use something that is 6ms or
> > 22ms. 
> 
> I am speculating having not read Toshiaki's code.
> The obvious case for the layering is for policy management.
> As you go upwards hw->xdp->tc->userspace->remote control
> your policies get richer and the resolved policies pushed down
> are more resolved. I am guessing the numbers we see above are
> for that first packet which is used as a control packet.
> An automonous system like this is of course susceptible to
> attacks.

Agree but still first packets happen and introducing latency spikes
when we have a better solution around should be avoided.

> 
> The workaround would be to preload the rules, but even then
> you will need to deal with resource constraints. Comparison
> would be like hierarchies of cache to RAM: L1/2/3 before RAM.
> To illustrate: Very limited fastest L1 (aka NIC offload),
> Limited faster L2 (XDP algorithms), L3 being tc and RAM being
> the user space resolution.

Of course.

> 
> >I expect a native xdp implementation using a hash map to be
> > inline with ovs kmod if not better.
> 
> Hashes are good for datapath use cases but not when you consider
> a holistic access where you have to worry about control aspect.

Whats the "right" data structure? We can build it in XDP if
its useful/generic. tc flower doesn't implement the saem data
structures as ovs kmod as far as I know.

Thanks!

> 
> cheers,
> jamal


