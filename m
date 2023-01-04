Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E5465DC02
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 19:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235381AbjADSUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 13:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235374AbjADSTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 13:19:51 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBC618E35
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 10:19:50 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n12so24057713pjp.1
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 10:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2UBRdkbukGLGSmLHpD8Nkm3e65VD32XpQi61fhS5Jg=;
        b=HGEfL5G5Gjl9Y6ziosYadAK+aCixYnwLb3+n3P4oHvrgaqlZhnPtVt684CPonnftvj
         sMWHsAjhw4Cep0lwWR+a/S3qSedHGyyxRcm5RT0Oez3MHep3LsDQH+2OHo0fwoefsNiJ
         3sbVQljlUGvcfkiv2fAUm+VKAEnqSVMFvqH3xg7DcJmoOnvDuxFBMso08tC9HBFQXvav
         gL8xHzSkUJPqpSoBH+y6iqp66OHgjgsh2grkH9FVDdBaNmycHx2Pc4Vx2r7JSFQiIUC8
         Y6P9uonXyGL2ts12pBVeZ07lEFLAnpfWunydM4STncPR6BMiZf70blTil5r1tMjxVRvH
         kSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I2UBRdkbukGLGSmLHpD8Nkm3e65VD32XpQi61fhS5Jg=;
        b=CYrlu75AU/VNo9b0jN64/Uy/a/argF/qZ1m37craG/lSnkxFcAQOepTfQWOVY8Kc36
         cXtL5xWhQQj9gxF6S6H/6dROxynHOMKFb1PLmQ6GINj58FVrG6FabbLUADYVbas1HOME
         NDNxVBQvahEQ1fZlJNYdAwJqvIdpqtc6xzf9/c+0Y6sWEGG5FE9V0XPWLkbntEd8W8PD
         nQyqfrpZxWcl5vzkze5MVv7cWDyVEbML5QBI0PIe06o5OiB1XOcT6dyFj3Z8Lwun7cKj
         eSk4KEV8Cqw1/lBjiQmTqVzTvn6vMTSHW/jxWIUdRiLW2cWEOYVLgUK4GREnJHvXdqpJ
         x0YQ==
X-Gm-Message-State: AFqh2kp/Mk1UXnaNtN5oU94lzCiHe3lac7zgQj8rT/Bu3TS233DLHfsX
        au3ZgclVLmoJyn45grPN2XkgqpL/uUNEwvINSjaUCQ==
X-Google-Smtp-Source: AMrXdXvx9BYtki7wDiaE6L4cTP14GUiDQsjpCukxnfnWA6luFkvtDFZKG6V93wNtbPr96OiOD3ShJCgf2lpk31oRiqM=
X-Received: by 2002:a17:90a:5296:b0:219:fbc:a088 with SMTP id
 w22-20020a17090a529600b002190fbca088mr4579474pjh.162.1672856389658; Wed, 04
 Jan 2023 10:19:49 -0800 (PST)
MIME-Version: 1.0
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
 <20230104121744.2820-12-magnus.karlsson@gmail.com> <Y7XCEPFUCUNZqtAY@maniforge.lan>
In-Reply-To: <Y7XCEPFUCUNZqtAY@maniforge.lan>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 4 Jan 2023 10:19:37 -0800
Message-ID: <CAKH8qBt1HVcpxUMV0+gWN7eptr2+V899TRk39yYZwcoYMgkYCg@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 4, 2023 at 10:14 AM David Vernet <void@manifault.com> wrote:
>
> On Wed, Jan 04, 2023 at 01:17:40PM +0100, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Get rid of the built-in XDP program that was part of the old libbpf
> > code in xsk.c and replace it with an eBPF program build using the
> > framework by all the other bpf selftests. This will form the base for
> > adding more programs in later commits.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/testing/selftests/bpf/Makefile          |  2 +-
> >  .../selftests/bpf/progs/xsk_xdp_progs.c       | 19 ++++
> >  tools/testing/selftests/bpf/xsk.c             | 88 ++++---------------
> >  tools/testing/selftests/bpf/xsk.h             |  6 +-
> >  tools/testing/selftests/bpf/xskxceiver.c      | 72 ++++++++-------
> >  tools/testing/selftests/bpf/xskxceiver.h      |  7 +-
> >  6 files changed, 88 insertions(+), 106 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selft=
ests/bpf/Makefile
> > index 205e8c3c346a..a0193a8f9da6 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -240,7 +240,7 @@ $(OUTPUT)/flow_dissector_load: $(TESTING_HELPERS)
> >  $(OUTPUT)/test_maps: $(TESTING_HELPERS)
> >  $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
> >  $(OUTPUT)/xsk.o: $(BPFOBJ)
> > -$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o
> > +$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o $(OUTPUT)/xsk_xdp_progs.skel.h
>
> Hi Magnus,
>
> This seems to break the selftests build for clang:
>
> $ pwd
> <redacted>/bpf-next/tools/testing/selftests/bpf
>
> $ make LLVM=3D1 CC=3Dclang
>   MKDIR    libbpf
>   HOSTCC  /home/void/upstream/bpf-next/tools/testing/selftests/bpf/tools/=
build/libbpf/fixdep.o
>   HOSTLD  /home/void/upstream/bpf-next/tools/testing/selftests/bpf/tools/=
build/libbpf/fixdep-in.o
>   LINK    /home/void/upstream/bpf-next/tools/testing/selftests/bpf/tools/=
build/libbpf/fixdep
>
> ...
>
>   GEN-SKEL [test_progs-no_alu32] test_static_linked.skel.h
>   LINK-BPF [test_progs-no_alu32] test_usdt.bpf.o
>   GEN-SKEL [test_progs-no_alu32] linked_vars.skel.h
>   GEN-SKEL [test_progs-no_alu32] linked_funcs.skel.h
>   EXT-COPY [test_progs-no_alu32] urandom_read bpf_testmod.ko liburandom_r=
ead.so xdp_synproxy sign-file ima_setup.sh verify_sig_setup.sh btf_dump_tes=
t_case_bitfields.c btf_dump_test_case_multidim.c btf_dump_test_case_namespa=
cing.c btf_dump_test_case_ordering.c btf_dump_test_case_packing.c btf_dump_=
test_case_padding.c btf_dump_test_case_syntax.c
>   GEN-SKEL [test_progs-no_alu32] linked_maps.skel.h
>   GEN-SKEL [test_progs-no_alu32] test_subskeleton.skel.h
>   BINARY   xskxceiver
>   BINARY   bench
>   GEN-SKEL [test_progs-no_alu32] test_subskeleton_lib.skel.h
>   GEN-SKEL [test_progs-no_alu32] test_usdt.skel.h
> clang-15: error: cannot specify -o when generating multiple output files
> make: *** [Makefile:171: /home/void/upstream/bpf-next/tools/testing/selft=
ests/bpf/xskxceiver] Error 1
> make: *** Waiting for unfinished jobs....
> make[1]: Nothing to be done for 'docs'.
> $
>
> It's also broken on CI: https://github.com/kernel-patches/bpf/actions/run=
s/3837984934/jobs/6533917001
>
> Could you please look into this?

Ugh, that's the same issue I'm getting for my xdp_hw_metadata binary.
And I'm still at loss on how to reproduce it locally. (I've tried 'apt
install clang-16 in ubuntu latest docker container' and it's still
fine).
Any pointers on how to debug those github actions locally?

> Thanks,
> David
