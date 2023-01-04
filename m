Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B6665DD14
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 20:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240229AbjADTrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 14:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240287AbjADTrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 14:47:12 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7E21C902
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 11:47:08 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id c2-20020a17090a020200b00226c762ed23so997032pjc.5
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 11:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1+ZxaLqo6czTJixfvj4dJy4us36huKKjG3N4a2kAExA=;
        b=ZOPAsW88NhVEW6Jj+wbDU76yp1N1s1DJOl2aeNw5FLl3F+86FvIsGVqsZ9Dm9DJ6sX
         LV5kj9upMi1a5CPpJGBbvPkvSp2Qu+vYI/z1ng8IeOjjcz9JtvJ6eDBZCmFDTi4lYa1t
         htUcd+2f60c8gdNzoOyBwjk/3nTvgJQiZlDSow3N3cmgKh/dnTBHRD1X8PT0106sDMFe
         RCUQyLEhhvyvjGjtmnI20BklzH4EpwO5mGC5Avnx/ULMnJqrxlVWwGaZGdH6NFZs14rw
         2EA3Aj+gS9UdfYLPQvL3g9beZq7vANxrqZ+isqfdaJzMygZp2rSx3uJR4ACrV+ErRjG8
         Ws+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1+ZxaLqo6czTJixfvj4dJy4us36huKKjG3N4a2kAExA=;
        b=J4pXFmdFuTqRnFQ5lEXimqiokToudXdxMvLJDViMC5Xaiv5oHvcC0OKDaCtvD8adHz
         xYmVebcVtDoywDyGdO3paBMv0z4KryTx5eXLAOGa0ofVbYh6YaS0j5sbIirsnzChUukC
         Fi30lrorKFoKCKXHzmPOEHVPn+RBez3FjnRiz3c/aWdRCm+gwrojku9x5VDnThFfDxax
         YdJE2PZ9IZnK25wtv//Ant6YGXzLc28OxWqsdRiK+m/youHIZ2ow74r8nKizVg2a1ZOv
         eIAhPCZwGI8pDg5M5lKFmF7MNXViMkFniyVDW7s1ZiwDVUQJ0OlgIpEL8YdSQ8Y3Vf2L
         LsYQ==
X-Gm-Message-State: AFqh2kqNHfLDSQmkNhV3KxnhR9m3XLfNF0Zf1pT+eknBtdJALLwwaYz6
        G5Al2VYVGkkmznTiAK6khjGSJ8oROUS51SxB3AU8jw==
X-Google-Smtp-Source: AMrXdXveWslLDalTitJJ3BDq3DfcLlfJfsMV1ge/fg/u2xBECYH8xpwO+b/Hh2wPB2PYad5xQIl4y52BdQkFEMy/8VM=
X-Received: by 2002:a17:90a:5296:b0:219:fbc:a088 with SMTP id
 w22-20020a17090a529600b002190fbca088mr4602380pjh.162.1672861627821; Wed, 04
 Jan 2023 11:47:07 -0800 (PST)
MIME-Version: 1.0
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
 <20230104121744.2820-12-magnus.karlsson@gmail.com> <Y7XCEPFUCUNZqtAY@maniforge.lan>
 <CAKH8qBt1HVcpxUMV0+gWN7eptr2+V899TRk39yYZwcoYMgkYCg@mail.gmail.com> <Y7XP9924wTevHcBT@maniforge.lan>
In-Reply-To: <Y7XP9924wTevHcBT@maniforge.lan>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 4 Jan 2023 11:46:56 -0800
Message-ID: <CAKH8qBuypCkTZYoSPHH1rbeAd3yRB_n2PidS4KN5CGfCpQTMtA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 11/15] selftests/xsk: get rid of built-in XDP program
To:     David Vernet <void@manifault.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, tirthendu.sarkar@intel.com,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 4, 2023 at 11:14 AM David Vernet <void@manifault.com> wrote:
>
> On Wed, Jan 04, 2023 at 10:19:37AM -0800, Stanislav Fomichev wrote:
> > On Wed, Jan 4, 2023 at 10:14 AM David Vernet <void@manifault.com> wrote=
:
> > >
> > > On Wed, Jan 04, 2023 at 01:17:40PM +0100, Magnus Karlsson wrote:
> > > > From: Magnus Karlsson <magnus.karlsson@intel.com>
> > > >
> > > > Get rid of the built-in XDP program that was part of the old libbpf
> > > > code in xsk.c and replace it with an eBPF program build using the
> > > > framework by all the other bpf selftests. This will form the base f=
or
> > > > adding more programs in later commits.
> > > >
> > > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > > ---
> > > >  tools/testing/selftests/bpf/Makefile          |  2 +-
> > > >  .../selftests/bpf/progs/xsk_xdp_progs.c       | 19 ++++
> > > >  tools/testing/selftests/bpf/xsk.c             | 88 ++++-----------=
----
> > > >  tools/testing/selftests/bpf/xsk.h             |  6 +-
> > > >  tools/testing/selftests/bpf/xskxceiver.c      | 72 ++++++++-------
> > > >  tools/testing/selftests/bpf/xskxceiver.h      |  7 +-
> > > >  6 files changed, 88 insertions(+), 106 deletions(-)
> > > >  create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_progs=
.c
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/s=
elftests/bpf/Makefile
> > > > index 205e8c3c346a..a0193a8f9da6 100644
> > > > --- a/tools/testing/selftests/bpf/Makefile
> > > > +++ b/tools/testing/selftests/bpf/Makefile
> > > > @@ -240,7 +240,7 @@ $(OUTPUT)/flow_dissector_load: $(TESTING_HELPER=
S)
> > > >  $(OUTPUT)/test_maps: $(TESTING_HELPERS)
> > > >  $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
> > > >  $(OUTPUT)/xsk.o: $(BPFOBJ)
> > > > -$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o
> > > > +$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o $(OUTPUT)/xsk_xdp_progs.skel=
.h
> > >
> > > Hi Magnus,
> > >
> > > This seems to break the selftests build for clang:
> > >
> > > $ pwd
> > > <redacted>/bpf-next/tools/testing/selftests/bpf
> > >
> > > $ make LLVM=3D1 CC=3Dclang
> > >   MKDIR    libbpf
> > >   HOSTCC  /home/void/upstream/bpf-next/tools/testing/selftests/bpf/to=
ols/build/libbpf/fixdep.o
> > >   HOSTLD  /home/void/upstream/bpf-next/tools/testing/selftests/bpf/to=
ols/build/libbpf/fixdep-in.o
> > >   LINK    /home/void/upstream/bpf-next/tools/testing/selftests/bpf/to=
ols/build/libbpf/fixdep
> > >
> > > ...
> > >
> > >   GEN-SKEL [test_progs-no_alu32] test_static_linked.skel.h
> > >   LINK-BPF [test_progs-no_alu32] test_usdt.bpf.o
> > >   GEN-SKEL [test_progs-no_alu32] linked_vars.skel.h
> > >   GEN-SKEL [test_progs-no_alu32] linked_funcs.skel.h
> > >   EXT-COPY [test_progs-no_alu32] urandom_read bpf_testmod.ko liburand=
om_read.so xdp_synproxy sign-file ima_setup.sh verify_sig_setup.sh btf_dump=
_test_case_bitfields.c btf_dump_test_case_multidim.c btf_dump_test_case_nam=
espacing.c btf_dump_test_case_ordering.c btf_dump_test_case_packing.c btf_d=
ump_test_case_padding.c btf_dump_test_case_syntax.c
> > >   GEN-SKEL [test_progs-no_alu32] linked_maps.skel.h
> > >   GEN-SKEL [test_progs-no_alu32] test_subskeleton.skel.h
> > >   BINARY   xskxceiver
> > >   BINARY   bench
> > >   GEN-SKEL [test_progs-no_alu32] test_subskeleton_lib.skel.h
> > >   GEN-SKEL [test_progs-no_alu32] test_usdt.skel.h
> > > clang-15: error: cannot specify -o when generating multiple output fi=
les
> > > make: *** [Makefile:171: /home/void/upstream/bpf-next/tools/testing/s=
elftests/bpf/xskxceiver] Error 1
> > > make: *** Waiting for unfinished jobs....
> > > make[1]: Nothing to be done for 'docs'.
> > > $
> > >
> > > It's also broken on CI: https://github.com/kernel-patches/bpf/actions=
/runs/3837984934/jobs/6533917001
> > >
> > > Could you please look into this?
> >
> > Ugh, that's the same issue I'm getting for my xdp_hw_metadata binary.
> > And I'm still at loss on how to reproduce it locally. (I've tried 'apt
> > install clang-16 in ubuntu latest docker container' and it's still
> > fine).
>
> I was able to reproduce this issue locally:

Damn, I was missing LLVM=3D1, that does make it reproduce for me, thanks!

> [void@maniforge bpf]$ make -j LLVM=3D1 CC=3Dclang
>   GEN-SKEL [test_progs] pyperf600.skel.h
>   GEN-SKEL [test_progs] test_verif_scale2.skel.h
>   LINK-BPF [test_progs] test_static_linked.bpf.o
>   LINK-BPF [test_progs] linked_funcs.bpf.o
>
> ...
>
>   LINK-BPF [test_progs-no_alu32] test_usdt.bpf.o
>   EXT-COPY [test_progs-no_alu32] urandom_read bpf_testmod.ko liburandom_r=
ead.so xdp_synproxy sign-file ima_setup.sh verify_sig_setup.sh btf_dump_tes=
t_case_bitfields.c btf_dump_test_case_multidim.c btf_dump_test_case_namespa=
cing.c btf_dump_test_case_ordering.c btf_dump_test_case_packing.c btf_dump_=
test_case_padding.c btf_dump_test_case_syntax.c
>   GEN-SKEL [test_progs-no_alu32] linked_funcs.skel.h
>   BINARY   bench
>   GEN-SKEL [test_progs-no_alu32] test_subskeleton.skel.h
>   BINARY   xdp_hw_metadata
>   GEN-SKEL [test_progs-no_alu32] test_subskeleton_lib.skel.h
>   GEN-SKEL [test_progs-no_alu32] test_usdt.skel.h
> clang-15: error: cannot specify -o when generating multiple output files
> make: *** [Makefile:171: /home/void/upstream/bpf-next/tools/testing/selft=
ests/bpf/xdp_hw_metadata] Error 1
> make: *** Waiting for unfinished jobs....
> make[1]: Nothing to be done for 'docs'.
>
> Here's the actual clang command being executed:
>
> [void@maniforge bpf]$ make LLVM=3D1 --dry-run xdp_hw_metadata
> printf '  %-8s%s %s%s\n' "BINARY" "" "xdp_hw_metadata" "";
> clang --target=3Dx86_64-linux-gnu -fintegrated-as -g -O0 -rdynamic -Wall =
-Werror -DHAVE_GENHDR  -I/home/void/upstream/bpf-next/tools/testing/selftes=
ts/bpf -I/home/void/upstream/bpf-next/tools/testing/selftests/bpf/tools/inc=
lude -I/home/void/upstream/bpf-next/include/generated -I/home/void/upstream=
/bpf-next/tools/lib -I/home/void/upstream/bpf-next/tools/include -I/home/vo=
id/upstream/bpf-next/tools/include/uapi -I/home/void/upstream/bpf-next/tool=
s/testing/selftests/bpf -Wno-unused-command-line-argument     -static  xdp_=
hw_metadata.c /home/void/upstream/bpf-next/tools/testing/selftests/bpf/tool=
s/build/libbpf/libbpf.a /home/void/upstream/bpf-next/tools/testing/selftest=
s/bpf/xsk.o /home/void/upstream/bpf-next/tools/testing/selftests/bpf/xdp_hw=
_metadata.skel.h /home/void/upstream/bpf-next/tools/testing/selftests/bpf/n=
etwork_helpers.o -lelf -lz -lrt -lpthread -o /home/void/upstream/bpf-next/t=
ools/testing/selftests/bpf/xdp_hw_metadata
>
> and the output using --debug=3Dj
>
> [void@maniforge bpf]$ make LLVM=3D1 --debug=3Dj xdp_hw_metadata
> Putting child 0x55cc78cd6670 (/home/void/upstream/bpf-next/tools/testing/=
selftests/bpf/xdp_hw_metadata) PID 693804 on the chain.
> Live child 0x55cc78cd6670 (/home/void/upstream/bpf-next/tools/testing/sel=
ftests/bpf/xdp_hw_metadata) PID 693804
>   BINARY   xdp_hw_metadata
> Reaping winning child 0x55cc78cd6670 PID 693804
> Live child 0x55cc78cd6670 (/home/void/upstream/bpf-next/tools/testing/sel=
ftests/bpf/xdp_hw_metadata) PID 693805
> clang-15: error: cannot specify -o when generating multiple output files
> Reaping losing child 0x55cc78cd6670 PID 693805
> make: *** [Makefile:171: /home/void/upstream/bpf-next/tools/testing/selft=
ests/bpf/xdp_hw_metadata] Error 1
> Removing child 0x55cc78cd6670 PID 693805 from chain.
>
> make is taking the xdp_hw_metadata.skel.h file and providing it as an
> input to clang. So I believe what's going on here is that the clang
> command above is actually creating two output files:
>
> 1. xdp_hw_metadata
> 2. The precompiled header generated from xdp_hw_metadata.skel.h
>
> and the error is clang reasonably saying: "I don't know which output
> file you're referring to with -o". I'm surprised that gcc doesn't
> complain about this, but I assume that it's doing the far more
> non-intuitive thing of first outputting the precompiled header as
> xdp_hw_metadata, and then immediately overwriting it with the actual
> xdp_hw_metadata binary.

Hm, I'm a bit surprised that clang can't handle .h as an extra input.
GCC seems to be doing the right thing; the headers compile to nothing
-> use that nothing as an extra input and don't complain..
Seems like the way to go is to explicitly have a '$(CC) xxx' rule that
filters it out. Will try.

> > Any pointers on how to debug those github actions locally?
> >
> > > Thanks,
> > > David
