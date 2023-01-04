Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABD365DBF5
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 19:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235171AbjADSOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 13:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbjADSOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 13:14:43 -0500
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C82D17E2B;
        Wed,  4 Jan 2023 10:14:42 -0800 (PST)
Received: by mail-qt1-f169.google.com with SMTP id c11so27832196qtn.11;
        Wed, 04 Jan 2023 10:14:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FVsRxQjJfhqUCKD22B/7QWal+i1XgIailtIcRsdWfsY=;
        b=XxmmyVscUy+zn331tzO0ml+KEjn0QcHP5FYm7VSWOwdM8ZERUmw0s2s1xu8VNCXMme
         iI37cwkmBKJpUSv4+raQPHhfr/a6e51WAR6P04KwMXlOZxLWu9jhBrbXwq1XAVfT6cIy
         cRg3oK7tdPsxSnPutpQs0DEzX11VSmYatR6ZEEBSvjmkqKA8HlHR0itD5J9fn1kUDsUf
         409U7qU//9ArK69gNEQ5Yuln76FsoMbl55ekbL71F3Y/ugE2EFFhSI02hJyvNziMLZTK
         5puk6Xx/+uBD8Sil1+wzTKO8jJL33qTvbRWIPRjCxWQfp3kvK0Bb23QIHS3ATx55y7li
         GQAg==
X-Gm-Message-State: AFqh2koB9l6qt6XRMQl75C0edFnra2LnvqwGkIrBjThnwoLPotuF+wCt
        lRgbMHdmmtXqoLWdHiBWJBo=
X-Google-Smtp-Source: AMrXdXskLaQ0HIlCQH3C+H14WSAUUbA44sT4P8AyxSWWi8mfco/KN1+K8H/HqDnRx6WV/hRx+BTLTw==
X-Received: by 2002:ac8:4705:0:b0:3ab:5a62:453b with SMTP id f5-20020ac84705000000b003ab5a62453bmr62073525qtp.53.1672856081393;
        Wed, 04 Jan 2023 10:14:41 -0800 (PST)
Received: from maniforge.lan ([2620:10d:c091:480::1:7c6c])
        by smtp.gmail.com with ESMTPSA id bp20-20020a05622a1b9400b003a591194221sm20334266qtb.7.2023.01.04.10.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 10:14:40 -0800 (PST)
Date:   Wed, 4 Jan 2023 12:14:40 -0600
From:   David Vernet <void@manifault.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next v2 11/15] selftests/xsk: get rid of built-in XDP
 program
Message-ID: <Y7XCEPFUCUNZqtAY@maniforge.lan>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
 <20230104121744.2820-12-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104121744.2820-12-magnus.karlsson@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 01:17:40PM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Get rid of the built-in XDP program that was part of the old libbpf
> code in xsk.c and replace it with an eBPF program build using the
> framework by all the other bpf selftests. This will form the base for
> adding more programs in later commits.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/Makefile          |  2 +-
>  .../selftests/bpf/progs/xsk_xdp_progs.c       | 19 ++++
>  tools/testing/selftests/bpf/xsk.c             | 88 ++++---------------
>  tools/testing/selftests/bpf/xsk.h             |  6 +-
>  tools/testing/selftests/bpf/xskxceiver.c      | 72 ++++++++-------
>  tools/testing/selftests/bpf/xskxceiver.h      |  7 +-
>  6 files changed, 88 insertions(+), 106 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 205e8c3c346a..a0193a8f9da6 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -240,7 +240,7 @@ $(OUTPUT)/flow_dissector_load: $(TESTING_HELPERS)
>  $(OUTPUT)/test_maps: $(TESTING_HELPERS)
>  $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
>  $(OUTPUT)/xsk.o: $(BPFOBJ)
> -$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o
> +$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o $(OUTPUT)/xsk_xdp_progs.skel.h

Hi Magnus,

This seems to break the selftests build for clang:

$ pwd
<redacted>/bpf-next/tools/testing/selftests/bpf

$ make LLVM=1 CC=clang
  MKDIR    libbpf
  HOSTCC  /home/void/upstream/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/fixdep.o
  HOSTLD  /home/void/upstream/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/fixdep-in.o
  LINK    /home/void/upstream/bpf-next/tools/testing/selftests/bpf/tools/build/libbpf/fixdep

...

  GEN-SKEL [test_progs-no_alu32] test_static_linked.skel.h
  LINK-BPF [test_progs-no_alu32] test_usdt.bpf.o
  GEN-SKEL [test_progs-no_alu32] linked_vars.skel.h
  GEN-SKEL [test_progs-no_alu32] linked_funcs.skel.h
  EXT-COPY [test_progs-no_alu32] urandom_read bpf_testmod.ko liburandom_read.so xdp_synproxy sign-file ima_setup.sh verify_sig_setup.sh btf_dump_test_case_bitfields.c btf_dump_test_case_multidim.c btf_dump_test_case_namespacing.c btf_dump_test_case_ordering.c btf_dump_test_case_packing.c btf_dump_test_case_padding.c btf_dump_test_case_syntax.c
  GEN-SKEL [test_progs-no_alu32] linked_maps.skel.h
  GEN-SKEL [test_progs-no_alu32] test_subskeleton.skel.h
  BINARY   xskxceiver
  BINARY   bench
  GEN-SKEL [test_progs-no_alu32] test_subskeleton_lib.skel.h
  GEN-SKEL [test_progs-no_alu32] test_usdt.skel.h
clang-15: error: cannot specify -o when generating multiple output files
make: *** [Makefile:171: /home/void/upstream/bpf-next/tools/testing/selftests/bpf/xskxceiver] Error 1
make: *** Waiting for unfinished jobs....
make[1]: Nothing to be done for 'docs'.
$

It's also broken on CI: https://github.com/kernel-patches/bpf/actions/runs/3837984934/jobs/6533917001

Could you please look into this?

Thanks,
David
