Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8AA8568A09
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiGFNuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbiGFNuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:50:50 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E484240A9;
        Wed,  6 Jul 2022 06:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657115448; x=1688651448;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2mYCckx+Sv5EPZOxpPFYyrg57MRKQ3Jw5hfg89nuyck=;
  b=E5wAzwppWKlGxtTc4AVe5I7SLlWpHbiDKhlbxnZ0LY1Dv+OtCEr0Iuye
   KB2ftkJr10PeSQNa+ftMHjO7xAu3ufbcf41v+RChHTckRkfm87FKnBVJI
   KlzFPXQ4zulpbGOonmV9MOt974zgxSC0CYxLzse71vhLbevlzA+0sEtiF
   YZqclCaln6+ojvNQlDeJekuB3yXinQ8zVuUiokZcBN+X0msfNBn6tztJa
   0VHE4GssPQs6196zEe8PjJhhKmvqzltfgH10nKGKQvZaL1WFzfPeCm3UE
   LwdXip1sTJEVKIA29H66Vyln8/RTHaacSvLJchGxlgEOq7SSmnmPzKLWY
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="284486898"
X-IronPort-AV: E=Sophos;i="5.92,250,1650956400"; 
   d="scan'208";a="284486898"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 06:50:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,250,1650956400"; 
   d="scan'208";a="735572237"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jul 2022 06:50:41 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 266DodPT015358;
        Wed, 6 Jul 2022 14:50:39 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: Re: [xdp-hints] Re: [PATCH RFC bpf-next 00/52] bpf, xdp: introduce and use Generic Hints/metadata
Date:   Wed,  6 Jul 2022 15:50:23 +0200
Message-Id: <20220706135023.1464979-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <87pmij75r1.fsf@toke.dk>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com> <62bbedf07f44a_2181420830@john.notmuch> <87iloja8ly.fsf@toke.dk> <20220704154440.7567-1-alexandr.lobakin@intel.com> <87a69o94wz.fsf@toke.dk> <20220705154120.22497-1-alexandr.lobakin@intel.com> <87pmij75r1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        PP_MIME_FAKE_ASCII_TEXT,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Tue, 05 Jul 2022 20:51:14 +0200

> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> 
> [... snipping a bit of context here ...]
> 
> >> >> Yeah, I'd agree this kind of configuration is something that can be
> >> >> added later, and also it's sort of orthogonal to the consumption of the
> >> >> metadata itself.
> >> >> 
> >> >> Also, tying this configuration into the loading of an XDP program is a
> >> >> terrible interface: these are hardware configuration options, let's just
> >> >> put them into ethtool or 'ip link' like any other piece of device
> >> >> configuration.
> >> >
> >> > I don't believe it fits there, especially Ethtool. Ethtool is for
> >> > hardware configuration, XDP/AF_XDP is 95% software stuff (apart from
> >> > offload bits which is purely NFP's for now).
> >> 
> >> But XDP-hints is about consuming hardware features. When you're
> >> configuring which metadata items you want, you're saying "please provide
> >> me with these (hardware) features". So ethtool is an excellent place to
> >> do that :)
> >
> > With Ethtool you configure the hardware, e.g. it won't strip VLAN
> > tags if you disable rx-cvlan-stripping. With configuring metadata
> > you only tell what you want to see there, don't you?
> 
> Ah, I think we may be getting closer to identifying the disconnect
> between our way of thinking about this!
> 
> In my mind, there's no separate "configuration of the metadata" step.
> You simply tell the hardware what features you want (say, "enable
> timestamps and VLAN offload"), and the driver will then provide the
> information related to these features in the metadata area
> unconditionally. All XDP hints is about, then, is a way for the driver
> to inform the rest of the system how that information is actually laid
> out in the metadata area.
> 
> Having a separate configuration knob to tell the driver "please lay out
> these particular bits of metadata this way" seems like a totally
> unnecessary (and quite complicated) feature to have when we can just let
> the driver decide and use CO-RE to consume it?

Magnus (he's currently on vacation) told me it would be useful for
AF_XDP to enable/disable particular metadata, at least from perf
perspective. Let's say, just fetching of one "checksum ok" bit in
the driver is faster than walking through all the descriptor words
and driver logics (i.e. there's several hundred locs in ice which
just parse descriptor data and build an skb or metadata from it).
But if we would just enable/disable corresponding features through
Ethtool, that would hurt XDP_PASS. Maybe it's a bad example, but
what if I want to have only RSS hash in the metadata (and don't
want to spend cycles on parsing the rest), but at the same time
still want skb path to have checksum status to not die at CPU
checksum calculation?

> 
> >> > I follow that way:
> >> >
> >> > 1) you pick a program you want to attach;
> >> > 2) usually they are written for special needs and usecases;
> >> > 3) so most likely that program will be tied with metadata/driver/etc
> >> >    in some way;
> >> > 4) so you want to enable Hints of a particular format primarily for
> >> >    this program and usecase, same with threshold and everything
> >> >    else.
> >> >
> >> > Pls explain how you see it, I might be wrong for sure.
> >> 
> >> As above: XDP hints is about giving XDP programs (and AF_XDP consumers)
> >> access to metadata that is not currently available. Tying the lifetime
> >> of that hardware configuration (i.e., which information to provide) to
> >> the lifetime of an XDP program is not a good interface: for one thing,
> >> how will it handle multiple programs? What about when XDP is not used at
> >
> > Multiple progs is stuff I didn't cover, but will do later (as you
> > all say to me, "let's start with something simple" :)). Aaaand
> > multiple XDP progs (I'm not talking about attaching progs in
> > differeng modes) is not a kernel feature, rather a libpf feature,
> > so I believe it should be handled there later...
> 
> Right, but even if we don't *implement* it straight away we still need
> to take it into consideration in the design. And expecting libxdp to
> arbitrate between different XDP programs' metadata formats sounds like a
> royal PITA :)
> 
> >> all but you still want to configure the same features?
> >
> > What's the point of configuring metadata when there are no progs
> > attached? To configure it once and not on every prog attach? I'm
> > not saying I don't like it, just want to clarify.
> 
> See above: you turn on the features because you want the stack to
> consume them.
> 
> > Maybe I need opinions from some more people, just to have an
> > overview of how most of folks see it and would like to configure
> > it. 'Cause I heard from at least one of the consumers that
> > libpf API is a perfect place for Hints to him :)
> 
> Well, as a program author who wants to consume hints, you'd use
> lib{bpf,xdp} APIs to do so (probably in the form of suitable CO-RE
> macros)...
> 
> >> In addition, in every other case where we do dynamic data access (with
> >> CO-RE) the BPF program is a consumer that modifies itself to access the
> >> data provided by the kernel. I get that this is harder to achieve for
> >> AF_XDP, but then let's solve that instead of making a totally
> >> inconsistent interface for XDP.
> >
> > I also see CO-RE more fitting and convenient way to use them, but
> > didn't manage to solve two things:
> >
> > 1) AF_XDP programs, so what to do with them? Prepare patches for
> >    LLVM to make it able to do CO-RE on AF_XDP program load? Or
> >    just hardcode them for particular usecases and NICs? What about
> >    "general-purpose" programs?
> 
> You provide a library to read the fields. Jesper actually already
> implemented this, did you look at his code?
> 
> https://github.com/xdp-project/bpf-examples/tree/master/AF_XDP-interaction
> 
> It basically builds a lookup table at load-time using BTF information
> from the kernel, keyed on BTF ID and field name, resolving them into
> offsets. It's not quite the zero-overhead of CO-RE, but it's fairly
> close and can be improved upon (CO-RE for userspace being one way of
> doing that).

Aaaah, sorry, I completely missed that. I thought of something
similar as well, but then thought "variable field offsets, that
would annihilate optimization and performance", and our Xsk team
is super concerned about performance hits when using Hints.

> 
> >    And if hardcode, what's the point then to do Generic Hints at
> >    all? Then all it needs is making driver building some meta in
> >    front of frames via on-off button and that's it? Why BTF ID in
> >    the meta then if consumers will access meta hardcoded (via CO-RE
> >    or literally hardcoded, doesn't matter)?
> 
> You're quite right, we could probably implement all the access to
> existing (fixed) metadata without using any BTF at all - just define a
> common struct and some flags to designate which fields are set. In my
> mind, there are a couple of reasons for going the BTF route instead:
> 
> - We can leverage CO-RE to get close to optimal efficiency in field
>   access.
> 
> and, more importantly:
> 
> - It's infinitely extensible. With the infrastructure in place to make
>   it really easy to consume metadata described by BTF, we lower the bar
>   for future innovation in hardware offloads. Both for just adding new
>   fixed-function stuff to hardware, but especially for fully
>   programmable hardware.

Agree :) That libxdp lookup translator fixed lots of stuff in my
mind.

> 
> > 2) In-kernel metadata consumers? Also do CO-RE? Otherwise, with no
> >    generic metadata structure they won't be able to benefit from
> >    Hints. But I guess we still need to provide kernel with meta?
> >    Or no?
> 
> In the short term, I think the "generic structure" approach is fine for
> leveraging this in the stack. Both your and Jesper's series include
> this, and I think that's totally fine. Longer term, if it turns out to
> be useful to have something more dynamic for the stack consumption as
> well, we could extend it to be CO-RE based as well (most likely by
> having the stack load a "translator" BPF program or something along
> those lines).

Oh, that translator prog sounds nice BTW!

> 
> >> I'm as excited as you about the prospect of having totally programmable
> >
> > But I mostly care about current generation with no programmable
> > Hints...
> 
> Well, see above; we should be able to support both :)
> 
> -Toke

Thanks,
Olek
