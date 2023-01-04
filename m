Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2311065DC99
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 20:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbjADTOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 14:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239706AbjADTOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 14:14:05 -0500
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E55833D71;
        Wed,  4 Jan 2023 11:14:02 -0800 (PST)
Received: by mail-qv1-f51.google.com with SMTP id o17so20095354qvn.4;
        Wed, 04 Jan 2023 11:14:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6+8kPCEsUSb2bBJ15EiYWrXjPXISRwI++7HMXMqIZ9g=;
        b=HjHdbmO5KGYULZDpIoCrOtVJ6HLio8xASp1OUcCErWIOo0cEqab1GnX50yfenYtdhP
         bj+zfd/HOoPy5g8ozS62Fvomjhdiy4VVVSYQIwSkl/+HEIHrI0Y2DsD6yNyRxUYRfHBG
         GEGLBOgsSpkBLYBNj0PeNan+9eDgXxQY2PzwHy/D/BRVTAmtys3la1dlafF/pWM1Ks7I
         vKG41upBG3emoS/AWAKOkoGGR7hLS7ZiuXhl0dF1/EDaj1zhdFvQismvuJPCpFe6mUv/
         7McEdQEcjINF+kzJNzujUXKzZL/W5sN3Voz3QDXskuw1w0puslvo3VpvBLYqGguGhKyL
         ghnQ==
X-Gm-Message-State: AFqh2kqRHTx/UXJ2RLRFCAmWqL7ZcCGBrYc54aFr7EYmWxgqXaj8etRp
        LPAmAdLJzRPDLpD2pi3qMn8=
X-Google-Smtp-Source: AMrXdXvrPJ4ezY6swvzPBFT7Pavc4ANVgwKJ7xnYaIwylnGeh0DgLtmBfyhfVFtC1sXRxujeZH7nbA==
X-Received: by 2002:ad4:458e:0:b0:531:28c3:7d65 with SMTP id x14-20020ad4458e000000b0053128c37d65mr48430405qvu.39.1672859640331;
        Wed, 04 Jan 2023 11:14:00 -0800 (PST)
Received: from maniforge.lan ([2620:10d:c091:480::1:7c6c])
        by smtp.gmail.com with ESMTPSA id h19-20020a05620a245300b006f9e103260dsm24500758qkn.91.2023.01.04.11.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 11:13:59 -0800 (PST)
Date:   Wed, 4 Jan 2023 13:13:59 -0600
From:   David Vernet <void@manifault.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, tirthendu.sarkar@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next v2 11/15] selftests/xsk: get rid of built-in XDP
 program
Message-ID: <Y7XP9924wTevHcBT@maniforge.lan>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
 <20230104121744.2820-12-magnus.karlsson@gmail.com>
 <Y7XCEPFUCUNZqtAY@maniforge.lan>
 <CAKH8qBt1HVcpxUMV0+gWN7eptr2+V899TRk39yYZwcoYMgkYCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBt1HVcpxUMV0+gWN7eptr2+V899TRk39yYZwcoYMgkYCg@mail.gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 10:19:37AM -0800, Stanislav Fomichev wrote:
> On Wed, Jan 4, 2023 at 10:14 AM David Vernet <void@manifault.com> wrote:
> >
> > On Wed, Jan 04, 2023 at 01:17:40PM +0100, Magnus Karlsson wrote:
> > > From: Magnus Karlsson <magnus.karlsson@intel.com>
> > >
> > > Get rid of the built-in XDP program that was part of the old libbpf
> > > code in xsk.c and replace it with an eBPF program build using the
> > > framework by all the other bpf selftests. This will form the base for
> > > adding more programs in later commits.
> > >
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > ---
> > >  tools/testing/selftests/bpf/Makefile          |  2 +-
> > >  .../selftests/bpf/progs/xsk_xdp_progs.c       | 19 ++++
> > >  tools/testing/selftests/bpf/xsk.c             | 88 ++++---------------
> > >  tools/testing/selftests/bpf/xsk.h             |  6 +-
> > >  tools/testing/selftests/bpf/xskxceiver.c      | 72 ++++++++-------
> > >  tools/testing/selftests/bpf/xskxceiver.h      |  7 +-
> > >  6 files changed, 88 insertions(+), 106 deletions(-)
> > >  create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > > index 205e8c3c346a..a0193a8f9da6 100644
> > > --- a/tools/testing/selftests/bpf/Makefile
> > > +++ b/tools/testing/selftests/bpf/Makefile
> > > @@ -240,7 +240,7 @@ $(OUTPUT)/flow_dissector_load: $(TESTING_HELPERS)
> > >  $(OUTPUT)/test_maps: $(TESTING_HELPERS)
> > >  $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
> > >  $(OUTPUT)/xsk.o: $(BPFOBJ)
> > > -$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o
> > > +$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o $(OUTPUT)/xsk_xdp_progs.skel.h
> >
> > Hi Magnus,
> >
> > This seems to break the selftests build for clang:
> >
> > $ pwd
> > <redacted>/bpf-next/tools/testing/selftests/bpf
> >
> > $ make LLVM=1 CC=clang
> >   MKDIR    libbpf
> >   HOSTCC  /home/void/upstream/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/fixdep.o
> >   HOSTLD  /home/void/upstream/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/fixdep-in.o
> >   LINK    /home/void/upstream/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/fixdep
> >
> > ...
> >
> >   GEN-SKEL [test_progs-no_alu32] test_static_linked.skel.h
> >   LINK-BPF [test_progs-no_alu32] test_usdt.bpf.o
> >   GEN-SKEL [test_progs-no_alu32] linked_vars.skel.h
> >   GEN-SKEL [test_progs-no_alu32] linked_funcs.skel.h
> >   EXT-COPY [test_progs-no_alu32] urandom_read bpf_testmod.ko liburandom_read.so xdp_synproxy sign-file ima_setup.sh verify_sig_setup.sh btf_dump_test_case_bitfields.c btf_dump_test_case_multidim.c btf_dump_test_case_namespacing.c btf_dump_test_case_ordering.c btf_dump_test_case_packing.c btf_dump_test_case_padding.c btf_dump_test_case_syntax.c
> >   GEN-SKEL [test_progs-no_alu32] linked_maps.skel.h
> >   GEN-SKEL [test_progs-no_alu32] test_subskeleton.skel.h
> >   BINARY   xskxceiver
> >   BINARY   bench
> >   GEN-SKEL [test_progs-no_alu32] test_subskeleton_lib.skel.h
> >   GEN-SKEL [test_progs-no_alu32] test_usdt.skel.h
> > clang-15: error: cannot specify -o when generating multiple output files
> > make: *** [Makefile:171: /home/void/upstream/bpf-next/tools/testing/selftests/bpf/xskxceiver] Error 1
> > make: *** Waiting for unfinished jobs....
> > make[1]: Nothing to be done for 'docs'.
> > $
> >
> > It's also broken on CI: https://github.com/kernel-patches/bpf/actions/runs/3837984934/jobs/6533917001
> >
> > Could you please look into this?
> 
> Ugh, that's the same issue I'm getting for my xdp_hw_metadata binary.
> And I'm still at loss on how to reproduce it locally. (I've tried 'apt
> install clang-16 in ubuntu latest docker container' and it's still
> fine).

I was able to reproduce this issue locally:

[void@maniforge bpf]$ make -j LLVM=1 CC=clang
  GEN-SKEL [test_progs] pyperf600.skel.h
  GEN-SKEL [test_progs] test_verif_scale2.skel.h
  LINK-BPF [test_progs] test_static_linked.bpf.o
  LINK-BPF [test_progs] linked_funcs.bpf.o

...

  LINK-BPF [test_progs-no_alu32] test_usdt.bpf.o
  EXT-COPY [test_progs-no_alu32] urandom_read bpf_testmod.ko liburandom_read.so xdp_synproxy sign-file ima_setup.sh verify_sig_setup.sh btf_dump_test_case_bitfields.c btf_dump_test_case_multidim.c btf_dump_test_case_namespacing.c btf_dump_test_case_ordering.c btf_dump_test_case_packing.c btf_dump_test_case_padding.c btf_dump_test_case_syntax.c
  GEN-SKEL [test_progs-no_alu32] linked_funcs.skel.h
  BINARY   bench
  GEN-SKEL [test_progs-no_alu32] test_subskeleton.skel.h
  BINARY   xdp_hw_metadata
  GEN-SKEL [test_progs-no_alu32] test_subskeleton_lib.skel.h
  GEN-SKEL [test_progs-no_alu32] test_usdt.skel.h
clang-15: error: cannot specify -o when generating multiple output files
make: *** [Makefile:171: /home/void/upstream/bpf-next/tools/testing/selftests/bpf/xdp_hw_metadata] Error 1
make: *** Waiting for unfinished jobs....
make[1]: Nothing to be done for 'docs'.

Here's the actual clang command being executed:

[void@maniforge bpf]$ make LLVM=1 --dry-run xdp_hw_metadata
printf '  %-8s%s %s%s\n' "BINARY" "" "xdp_hw_metadata" "";
clang --target=x86_64-linux-gnu -fintegrated-as -g -O0 -rdynamic -Wall -Werror -DHAVE_GENHDR  -I/home/void/upstream/bpf-next/tools/testing/selftests/bpf -I/home/void/upstream/bpf-next/tools/testing/selftests/bpf/tools/include -I/home/void/upstream/bpf-next/include/generated -I/home/void/upstream/bpf-next/tools/lib -I/home/void/upstream/bpf-next/tools/include -I/home/void/upstream/bpf-next/tools/include/uapi -I/home/void/upstream/bpf-next/tools/testing/selftests/bpf -Wno-unused-command-line-argument     -static  xdp_hw_metadata.c /home/void/upstream/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/libbpf.a /home/void/upstream/bpf-next/tools/testing/selftests/bpf/xsk.o /home/void/upstream/bpf-next/tools/testing/selftests/bpf/xdp_hw_metadata.skel.h /home/void/upstream/bpf-next/tools/testing/selftests/bpf/network_helpers.o -lelf -lz -lrt -lpthread -o /home/void/upstream/bpf-next/tools/testing/selftests/bpf/xdp_hw_metadata

and the output using --debug=j

[void@maniforge bpf]$ make LLVM=1 --debug=j xdp_hw_metadata
Putting child 0x55cc78cd6670 (/home/void/upstream/bpf-next/tools/testing/selftests/bpf/xdp_hw_metadata) PID 693804 on the chain.
Live child 0x55cc78cd6670 (/home/void/upstream/bpf-next/tools/testing/selftests/bpf/xdp_hw_metadata) PID 693804
  BINARY   xdp_hw_metadata
Reaping winning child 0x55cc78cd6670 PID 693804
Live child 0x55cc78cd6670 (/home/void/upstream/bpf-next/tools/testing/selftests/bpf/xdp_hw_metadata) PID 693805
clang-15: error: cannot specify -o when generating multiple output files
Reaping losing child 0x55cc78cd6670 PID 693805
make: *** [Makefile:171: /home/void/upstream/bpf-next/tools/testing/selftests/bpf/xdp_hw_metadata] Error 1
Removing child 0x55cc78cd6670 PID 693805 from chain.

make is taking the xdp_hw_metadata.skel.h file and providing it as an
input to clang. So I believe what's going on here is that the clang
command above is actually creating two output files:

1. xdp_hw_metadata
2. The precompiled header generated from xdp_hw_metadata.skel.h

and the error is clang reasonably saying: "I don't know which output
file you're referring to with -o". I'm surprised that gcc doesn't
complain about this, but I assume that it's doing the far more
non-intuitive thing of first outputting the precompiled header as
xdp_hw_metadata, and then immediately overwriting it with the actual
xdp_hw_metadata binary.

> Any pointers on how to debug those github actions locally?
> 
> > Thanks,
> > David
