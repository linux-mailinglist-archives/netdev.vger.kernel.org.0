Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C180B65E6EF
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjAEIii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjAEIih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:38:37 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F184C717;
        Thu,  5 Jan 2023 00:38:36 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id u19so88449021ejm.8;
        Thu, 05 Jan 2023 00:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+8xeEYZVKn58+C4NC2Fr2u9sUd2mC0FIQGRQdKj9Ibw=;
        b=nMGzSrcRFdfnY6Wa4lHpmmUbWBWVyucYIygEhW26gK9M2qhCQ5WBv98dp5HkvgQWDs
         xhim5FZDT0BNRF0xgu9kCt5hFvCo4Q1CsI5GD7OGuwttWspeWBtUGNsuBcVFNQEbJ2qs
         9QZuAVAqeCJ/dSY8lF19Rdhjt+TGfKTX5I9c1PAIVWTJHRbVzG8zE2uauFK+7FQ0G2TR
         sexUKc2+Q/A3ipGxdbcmPaiQkyKOmjUEpCeuYOS92QetS+Pxpr92m72lSsLWCkUBIlUo
         1YASHYJCox3T/22yVb5JfVhDyjS5laemv5/8VJEUlu7I7xFPKK4PV103BgjyRAjyZnuB
         iKmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+8xeEYZVKn58+C4NC2Fr2u9sUd2mC0FIQGRQdKj9Ibw=;
        b=yGLJT8DxRkw1jUXydWzXzlX2kOAsssXXOnr3xiXbJFgOA81u4wzr6ha9Lh6lUhgUcZ
         pB0u9P4KVEum7bd5eZTb/CvHudjvP/fdjy1CGH72z2ygEP6/7UZVFiG+M4JVzJwiO84Q
         TfbqHUIAHpsvY02PD9iJ2M2vhyKQLaXLBZ2msh3cgvGETJO7rP/pABBBi6SvviYQrisD
         BXk33EqsohYgLzduG4w7iixE+pCVuL+PwhwRT9f8Kr6bJUXGobd7aEXxN+4KO3czJsqj
         X7Tg1vLyHBX+EIS+cwRpBgvLi2jFDQX+gV84xm2pkyqDWSLBsLNAHVUOPJrhGoTOsUK6
         fPUw==
X-Gm-Message-State: AFqh2kpXqgGPsb1sgWhlJYlvMTWSYxeDkQwdQfBvRsRkM7R8yqOqFg4M
        50CotU1tSCn11u3BEA41PWMKcV9awWHFiFq9eDc=
X-Google-Smtp-Source: AMrXdXsId2nApFSWCct5D1Spcy7auVmjlo+cMEKsVKFUQPTxYMz4lQLukSnZn8gb7SaLV0OgQ11nt3LXf3RR+GKuCos=
X-Received: by 2002:a17:906:71d0:b0:7ad:b45c:dbca with SMTP id
 i16-20020a17090671d000b007adb45cdbcamr5718963ejk.388.1672907914707; Thu, 05
 Jan 2023 00:38:34 -0800 (PST)
MIME-Version: 1.0
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
 <20230104121744.2820-12-magnus.karlsson@gmail.com> <Y7XCEPFUCUNZqtAY@maniforge.lan>
In-Reply-To: <Y7XCEPFUCUNZqtAY@maniforge.lan>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 5 Jan 2023 09:38:22 +0100
Message-ID: <CAJ8uoz03bLb7Xc29bRjD+QNy73XtjA2XEszZ8xnzqS2Y7QCsTg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 11/15] selftests/xsk: get rid of built-in XDP program
To:     David Vernet <void@manifault.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 4, 2023 at 7:14 PM David Vernet <void@manifault.com> wrote:
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

Thanks for spotting this David. Will fix it in the v3.

> Thanks,
> David
