Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E06567245
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiGEPPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiGEPPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:15:45 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55338165AF;
        Tue,  5 Jul 2022 08:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657034144; x=1688570144;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hp9+ZjKqW51mjGl+R+E35bg8BkjYNebZYZf7uvGtI7w=;
  b=RvKOz0KjeGgvkiJ1d6TBBgwb6D4wlnwPING6nZ6SJxUTwOz8tUN1ok8T
   AaMAtn3WIqvy05MchNBcjMa+JRws5e6UAFooPnoaxzuQ5rauA2VkbeWr4
   2RE6yXLhmJXzGM8YJ+HuPJCwVtf+24sMqSerSvq7DJpLyP9wVfB00QiOn
   eOa9elLA9DwJDkXKk24IFrZylEv4Q2qjKjt4w7tnDFwBHX1vHJpJJaNEi
   siEt/FgcdxFtPEWsHAs1yx8tfNG6M1G2EYfrk6sqhk+lwO3QMIJ9T5gmU
   NtAWBsugUO6ZMSQQfHbvWtUFCoPWIjkb1/p3AiSmSCMgAqwG9g/2wIPDx
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="263168612"
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="263168612"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 08:15:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="719763721"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 05 Jul 2022 08:15:39 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 265FFblx023878;
        Tue, 5 Jul 2022 16:15:37 +0100
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
Date:   Tue,  5 Jul 2022 17:15:09 +0200
Message-Id: <87a69o94wz.fsf@toke.dk>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Mon, 04 Jul 2022 19:14:04 +0200

> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> 
> > From: Toke H??iland-J??rgensen <toke@redhat.com>
> > Date: Wed, 29 Jun 2022 15:43:05 +0200
> >
> >> John Fastabend <john.fastabend@gmail.com> writes:
> >> 
> >> > Alexander Lobakin wrote:
> >> >> This RFC is to give the whole picture. It will most likely be split
> >> >> onto several series, maybe even merge cycles. See the "table of
> >> >> contents" below.
> >> >
> >> > Even for RFC its a bit much. Probably improve the summary
> >> > message here as well I'm still not clear on the overall
> >> > architecture so not sure I want to dig into patches.
> >> 
> >> +1 on this, and piggybacking on your comment to chime in on the general
> >> architecture.
> >> 
> >> >> Now, a NIC driver, or even a SmartNIC itself, can put those params
> >> >> there in a well-defined format. The format is fixed, but can be of
> >> >> several different types represented by structures, which definitions
> >> >> are available to the kernel, BPF programs and the userland.
> >> >
> >> > I don't think in general the format needs to be fixed.
> >> 
> >> No, that's the whole point of BTF: it's not supposed to be UAPI, we'll
> >> use CO-RE to enable dynamic formats...
> >> 
> >> [...]
> >> 
> >> >> It is fixed due to it being almost a UAPI, and the exact format can
> >> >> be determined by reading the last 10 bytes of metadata. They contain
> >> >> a 2-byte magic ID to not confuse it with a non-compatible meta and
> >> >> a 8-byte combined BTF ID + type ID: the ID of the BTF where this
> >> >> structure is defined and the ID of that definition inside that BTF.
> >> >> Users can obtain BTF IDs by structure types using helpers available
> >> >> in the kernel, BPF (written by the CO-RE/verifier) and the userland
> >> >> (libbpf -> kernel call) and then rely on those ID when reading data
> >> >> to make sure whether they support it and what to do with it.
> >> >> Why separate magic and ID? The idea is to make different formats
> >> >> always contain the basic/"generic" structure embedded at the end.
> >> >> This way we can still benefit in purely generic consumers (like
> >> >> cpumap) while providing some "extra" data to those who support it.
> >> >
> >> > I don't follow this. If you have a struct in your driver name it
> >> > something obvious, ice_xdp_metadata. If I understand things
> >> > correctly just dump the BTF for the driver, extract the
> >> > struct and done you can use CO-RE reads. For the 'fixed' case
> >> > this looks easy. And I don't think you even need a patch for this.
> >> 
> >> ...however as we've discussed previously, we do need a bit of
> >> infrastructure around this. In particular, we need to embed the embed
> >> the BTF ID into the metadata itself so BPF can do runtime disambiguation
> >> between different formats (and add the right CO-RE primitives to make
> >> this easy). This is for two reasons:
> >> 
> >> - The metadata might be different per-packet (e.g., PTP packets with
> >>   timestamps interleaved with bulk data without them)
> >> 
> >> - With redirects we may end up processing packets from different devices
> >>   in a single XDP program (in devmap or cpumap, or on a veth) so we need
> >>   to be able to disambiguate at runtime.
> >> 
> >> So I think the part of the design that puts the BTF ID into the end of
> >> the metadata struct is sound; however, the actual format doesn't have to
> >> be fixed, we can use CO-RE to pick out the bits that a given BPF program
> >> needs; we just need a convention for how drivers report which format(s)
> >> they support. Which we should also agree on (and add core infrastructure
> >> around) so each driver doesn't go around inventing their own
> >> conventions.
> >> 
> >> >> The enablement of this feature is controlled on attaching/replacing
> >> >> XDP program on an interface with two new parameters: that combined
> >> >> BTF+type ID and metadata threshold.
> >> >> The threshold specifies the minimum frame size which a driver (or
> >> >> NIC) should start composing metadata from. It is introduced instead
> >> >> of just false/true flag due to that often it's not worth it to spend
> >> >> cycles to fetch all that data for such small frames: let's say, it
> >> >> can be even faster to just calculate checksums for them on CPU
> >> >> rather than touch non-coherent DMA zone. Simple XDP_DROP case loses
> >> >> 15 Mpps on 64 byte frames with enabled metadata, threshold can help
> >> >> mitigate that.
> >> >
> >> > I would put this in the bonus category. Can you do the simple thing
> >> > above without these extra bits and then add them later. Just
> >> > pick some overly conservative threshold to start with.
> >> 
> >> Yeah, I'd agree this kind of configuration is something that can be
> >> added later, and also it's sort of orthogonal to the consumption of the
> >> metadata itself.
> >> 
> >> Also, tying this configuration into the loading of an XDP program is a
> >> terrible interface: these are hardware configuration options, let's just
> >> put them into ethtool or 'ip link' like any other piece of device
> >> configuration.
> >
> > I don't believe it fits there, especially Ethtool. Ethtool is for
> > hardware configuration, XDP/AF_XDP is 95% software stuff (apart from
> > offload bits which is purely NFP's for now).
> 
> But XDP-hints is about consuming hardware features. When you're
> configuring which metadata items you want, you're saying "please provide
> me with these (hardware) features". So ethtool is an excellent place to
> do that :)

With Ethtool you configure the hardware, e.g. it won't strip VLAN
tags if you disable rx-cvlan-stripping. With configuring metadata
you only tell what you want to see there, don't you?

> 
> > I follow that way:
> >
> > 1) you pick a program you want to attach;
> > 2) usually they are written for special needs and usecases;
> > 3) so most likely that program will be tied with metadata/driver/etc
> >    in some way;
> > 4) so you want to enable Hints of a particular format primarily for
> >    this program and usecase, same with threshold and everything
> >    else.
> >
> > Pls explain how you see it, I might be wrong for sure.
> 
> As above: XDP hints is about giving XDP programs (and AF_XDP consumers)
> access to metadata that is not currently available. Tying the lifetime
> of that hardware configuration (i.e., which information to provide) to
> the lifetime of an XDP program is not a good interface: for one thing,
> how will it handle multiple programs? What about when XDP is not used at

Multiple progs is stuff I didn't cover, but will do later (as you
all say to me, "let's start with something simple" :)). Aaaand
multiple XDP progs (I'm not talking about attaching progs in
differeng modes) is not a kernel feature, rather a libpf feature,
so I believe it should be handled there later...

> all but you still want to configure the same features?

What's the point of configuring metadata when there are no progs
attached? To configure it once and not on every prog attach? I'm
not saying I don't like it, just want to clarify.
Maybe I need opinions from some more people, just to have an
overview of how most of folks see it and would like to configure
it. 'Cause I heard from at least one of the consumers that
libpf API is a perfect place for Hints to him :)

> 
> In addition, in every other case where we do dynamic data access (with
> CO-RE) the BPF program is a consumer that modifies itself to access the
> data provided by the kernel. I get that this is harder to achieve for
> AF_XDP, but then let's solve that instead of making a totally
> inconsistent interface for XDP.

I also see CO-RE more fitting and convenient way to use them, but
didn't manage to solve two things:

1) AF_XDP programs, so what to do with them? Prepare patches for
   LLVM to make it able to do CO-RE on AF_XDP program load? Or
   just hardcode them for particular usecases and NICs? What about
   "general-purpose" programs?
   And if hardcode, what's the point then to do Generic Hints at
   all? Then all it needs is making driver building some meta in
   front of frames via on-off button and that's it? Why BTF ID in
   the meta then if consumers will access meta hardcoded (via CO-RE
   or literally hardcoded, doesn't matter)?
2) In-kernel metadata consumers? Also do CO-RE? Otherwise, with no
   generic metadata structure they won't be able to benefit from
   Hints. But I guess we still need to provide kernel with meta?
   Or no?

> 
> I'm as excited as you about the prospect of having totally programmable

But I mostly care about current generation with no programmable
Hints...

> hardware where you can just specify any arbitrary metadata format and
> it'll provide that for you. But that is an orthogonal feature: let's
> start with creating a dynamic interface for consuming the (static)
> hardware features we already have, and then later we can have a separate
> interface for configuring more dynamic hardware features. XDP-hints is
> about adding this consumption feature in a way that's sufficiently
> dynamic that we can do the other (programmable hardware) thing on top
> later...
> 
> -Toke

Thanks,
Olek
