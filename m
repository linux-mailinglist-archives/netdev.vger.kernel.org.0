Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A3C4F3C29
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbiDEMFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355415AbiDELOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 07:14:47 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126234C792;
        Tue,  5 Apr 2022 03:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649154872; x=1680690872;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UTD9oe2pef3Z84hPGqQnOjRJpiHk0wcvpWnMnU5moJo=;
  b=bu/JViFnT33N1Vvgq9Gdkmhd0X8GObKDaZzQvnhTXRKihTWXkw5099Z4
   5LFQVGbdZXuRDjUQMiVAr9B09lgVY7KYI1C/M1sggJB7K5NBwoVHes3nf
   Ik5P0ujproIsBO+NBWYYUBT8zngyBUHjCqe/RMFncfG3Qr2vqYFjCFZ+A
   1SSJzkKf9Yr3cuvmOQaC161OFwqnONJvABklcXIbIRa8+p1WYofOZkL5+
   dSc7hJf4sdQGnPVkiASrG8Pppbj7tKAbrLD8OH4or/NbRF5GA8vTb4iEo
   UPwHNonYAd7milViz5vl2IB3k4c0ktZox1RBZyhHnFKC0dMlYD53k0AxU
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="258301832"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="258301832"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 03:34:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="549005815"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 05 Apr 2022 03:34:27 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 235AYPjg012310;
        Tue, 5 Apr 2022 11:34:25 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next] samples: bpf: fix linking xdp_router_ipv4 after migration
Date:   Tue,  5 Apr 2022 12:32:14 +0200
Message-Id: <20220405103214.3526290-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAEf4BzbEQeq-_BhrKLSHW2xObQPtzGA7Hw-hTbfLZZ_S4gfVmg@mail.gmail.com>
References: <20220404115451.1116478-1-alexandr.lobakin@intel.com> <CAEf4BzbEQeq-_BhrKLSHW2xObQPtzGA7Hw-hTbfLZZ_S4gfVmg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 4 Apr 2022 14:45:43 -0700

> On Mon, Apr 4, 2022 at 4:57 AM Alexander Lobakin
> <alexandr.lobakin@intel.com> wrote:
> >
> > Users of the xdp_sample_user infra should be explicitly linked
> > with the standard math library (`-lm`). Otherwise, the following
> > happens:
> >
> > /usr/bin/ld: xdp_sample_user.c:(.text+0x59fc): undefined reference to `ceil'
> > /usr/bin/ld: xdp_sample_user.c:(.text+0x5a0d): undefined reference to `ceil'
> > /usr/bin/ld: xdp_sample_user.c:(.text+0x5adc): undefined reference to `floor'
> > /usr/bin/ld: xdp_sample_user.c:(.text+0x5b01): undefined reference to `ceil'
> > /usr/bin/ld: xdp_sample_user.c:(.text+0x5c1e): undefined reference to `floor'
> > /usr/bin/ld: xdp_sample_user.c:(.text+0x5c43): undefined reference to `ceil
> > [...]
> 
> I actually don't get these, but applied to bpf-next anyway.

Depends on the compiler/linker I guess. They appear on `make LLVM=1`
on my setup.
Thanks!

> 
> >
> > That happened previously, so there's a block of linkage flags in the
> > Makefile. xdp_router_ipv4 has been transferred to this infra quite
> > recently, but hasn't been added to it. Fix.
> >
> > Fixes: 85bf1f51691c ("samples: bpf: Convert xdp_router_ipv4 to XDP samples helper")
> > Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> > ---
> >  samples/bpf/Makefile | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > index b4fa0e69aa14..342a41a10356 100644
> > --- a/samples/bpf/Makefile
> > +++ b/samples/bpf/Makefile
> > @@ -219,6 +219,7 @@ TPROGLDLIBS_xdp_redirect    += -lm
> >  TPROGLDLIBS_xdp_redirect_cpu   += -lm
> >  TPROGLDLIBS_xdp_redirect_map   += -lm
> >  TPROGLDLIBS_xdp_redirect_map_multi += -lm
> > +TPROGLDLIBS_xdp_router_ipv4    += -lm
> >  TPROGLDLIBS_tracex4            += -lrt
> >  TPROGLDLIBS_trace_output       += -lrt
> >  TPROGLDLIBS_map_perf_test      += -lrt
> > --
> > 2.35.1

Al
