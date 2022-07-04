Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB54565A50
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 17:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiGDPpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 11:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbiGDPpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 11:45:40 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CC3D5C;
        Mon,  4 Jul 2022 08:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656949539; x=1688485539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=97us1Wg8YPEG78YCQn2QKkztQ+Gqk22Wyxqdxk8EExE=;
  b=P7EVpyi7VwdHSRp/7MkX40uBmlEGSU4PBrBcZtV7vf606GVW36xr652D
   n15eIYBkKFrdXiI5mluN6QYqusfeyNdxSkj6DBAnVZjBpOf+LL/bH64bQ
   F47eCsvTVZvi4MH9ofCHIqP9CsTXrfm6E9n6k5o8QvD9b6Z70eHmWKNDo
   kNV5oj5XoZd3yJC+eU78B31F+3vGY2lhd6kj6XH7wOEMly8hZja7Ye8mq
   AamsjLezwthoJcAkoOHr8evMVA/syq6XGBOUDl4aJplIHsgc6Iu7NLxai
   +WbcqzxSLOFx1s5XZshY00TiWVRGP4DooQP3IiEuw+pD4ts9d3HAwDatJ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="271931043"
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="271931043"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 08:45:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="695366981"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 04 Jul 2022 08:45:12 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 264FjB08028332;
        Mon, 4 Jul 2022 16:45:11 +0100
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
Date:   Mon,  4 Jul 2022 17:44:40 +0200
Message-Id: <20220704154440.7567-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <87iloja8ly.fsf@toke.dk>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com> <62bbedf07f44a_2181420830@john.notmuch> <87iloja8ly.fsf@toke.dk>
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
Date: Wed, 29 Jun 2022 15:43:05 +0200

> John Fastabend <john.fastabend@gmail.com> writes:
> 
> > Alexander Lobakin wrote:
> >> This RFC is to give the whole picture. It will most likely be split
> >> onto several series, maybe even merge cycles. See the "table of
> >> contents" below.
> >
> > Even for RFC its a bit much. Probably improve the summary
> > message here as well I'm still not clear on the overall
> > architecture so not sure I want to dig into patches.
> 
> +1 on this, and piggybacking on your comment to chime in on the general
> architecture.
> 
> >> Now, a NIC driver, or even a SmartNIC itself, can put those params
> >> there in a well-defined format. The format is fixed, but can be of
> >> several different types represented by structures, which definitions
> >> are available to the kernel, BPF programs and the userland.
> >
> > I don't think in general the format needs to be fixed.
> 
> No, that's the whole point of BTF: it's not supposed to be UAPI, we'll
> use CO-RE to enable dynamic formats...
> 
> [...]
> 
> >> It is fixed due to it being almost a UAPI, and the exact format can
> >> be determined by reading the last 10 bytes of metadata. They contain
> >> a 2-byte magic ID to not confuse it with a non-compatible meta and
> >> a 8-byte combined BTF ID + type ID: the ID of the BTF where this
> >> structure is defined and the ID of that definition inside that BTF.
> >> Users can obtain BTF IDs by structure types using helpers available
> >> in the kernel, BPF (written by the CO-RE/verifier) and the userland
> >> (libbpf -> kernel call) and then rely on those ID when reading data
> >> to make sure whether they support it and what to do with it.
> >> Why separate magic and ID? The idea is to make different formats
> >> always contain the basic/"generic" structure embedded at the end.
> >> This way we can still benefit in purely generic consumers (like
> >> cpumap) while providing some "extra" data to those who support it.
> >
> > I don't follow this. If you have a struct in your driver name it
> > something obvious, ice_xdp_metadata. If I understand things
> > correctly just dump the BTF for the driver, extract the
> > struct and done you can use CO-RE reads. For the 'fixed' case
> > this looks easy. And I don't think you even need a patch for this.
> 
> ...however as we've discussed previously, we do need a bit of
> infrastructure around this. In particular, we need to embed the embed
> the BTF ID into the metadata itself so BPF can do runtime disambiguation
> between different formats (and add the right CO-RE primitives to make
> this easy). This is for two reasons:
> 
> - The metadata might be different per-packet (e.g., PTP packets with
>   timestamps interleaved with bulk data without them)
> 
> - With redirects we may end up processing packets from different devices
>   in a single XDP program (in devmap or cpumap, or on a veth) so we need
>   to be able to disambiguate at runtime.
> 
> So I think the part of the design that puts the BTF ID into the end of
> the metadata struct is sound; however, the actual format doesn't have to
> be fixed, we can use CO-RE to pick out the bits that a given BPF program
> needs; we just need a convention for how drivers report which format(s)
> they support. Which we should also agree on (and add core infrastructure
> around) so each driver doesn't go around inventing their own
> conventions.
> 
> >> The enablement of this feature is controlled on attaching/replacing
> >> XDP program on an interface with two new parameters: that combined
> >> BTF+type ID and metadata threshold.
> >> The threshold specifies the minimum frame size which a driver (or
> >> NIC) should start composing metadata from. It is introduced instead
> >> of just false/true flag due to that often it's not worth it to spend
> >> cycles to fetch all that data for such small frames: let's say, it
> >> can be even faster to just calculate checksums for them on CPU
> >> rather than touch non-coherent DMA zone. Simple XDP_DROP case loses
> >> 15 Mpps on 64 byte frames with enabled metadata, threshold can help
> >> mitigate that.
> >
> > I would put this in the bonus category. Can you do the simple thing
> > above without these extra bits and then add them later. Just
> > pick some overly conservative threshold to start with.
> 
> Yeah, I'd agree this kind of configuration is something that can be
> added later, and also it's sort of orthogonal to the consumption of the
> metadata itself.
> 
> Also, tying this configuration into the loading of an XDP program is a
> terrible interface: these are hardware configuration options, let's just
> put them into ethtool or 'ip link' like any other piece of device
> configuration.

I don't believe it fits there, especially Ethtool. Ethtool is for
hardware configuration, XDP/AF_XDP is 95% software stuff (apart from
offload bits which is purely NFP's for now).
I follow that way:

1) you pick a program you want to attach;
2) usually they are written for special needs and usecases;
3) so most likely that program will be tied with metadata/driver/etc
   in some way;
4) so you want to enable Hints of a particular format primarily for
   this program and usecase, same with threshold and everything
   else.

Pls explain how you see it, I might be wrong for sure.

> 
> >> The RFC can be divided into 8 parts:
> >
> > I'm missing something why not do the simplest bit of work and
> > get this running in ice with a few smallish driver updates
> > so we can all see it. No need for so many patches.
> 
> Agreed. This incremental approach is basically what Jesper's
> simultaneous series makes a start on, AFAICT? Would be nice if y'all
> could converge the efforts :)

I don't know why at some point Jesper decided to go on his own as he
for sure was using our tree as a base for some time, dunno what
happened then. Regarding these two particular submissions, I didn't
see Jesper's RFC when sending mine, only after when I went to read
some stuff.

> 
> [...]
> 
> > I really think your asking questions that are two or three
> > jumps away. Why not do the simplest bit first and kick
> > the driver with an on/off switch into this mode. But
> > I don't understand this cpumap use case so maybe explain
> > that first.
> >
> > And sorry didn't even look at your 50+ patches. Figure lets
> > get agreement on the goal first.
> 
> +1 on both of these :)

I just thought most of parts were already discussed previously and
the reason I marked it "RFC" was that there are lots of changes and
not everyone may agree with them... Like "here's overview of what
was discussed and what we decided previously, let's review it to see
if there are any questionable/debatable stuff and agree on those 3
questions, then I'll split it according to my taste or to how the
maintainers see it and apply it slow'n'steady".

> 
> -Toke

Thanks,
Olek
