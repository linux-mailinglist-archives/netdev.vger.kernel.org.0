Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812EC56230D
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 21:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbiF3TZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 15:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiF3TZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 15:25:22 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0800377FF;
        Thu, 30 Jun 2022 12:25:20 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id k20so128372edj.13;
        Thu, 30 Jun 2022 12:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/4h1kWzi2Rq+Pv619m3vuzpCBmokzGDwSLu2Jrb6OMI=;
        b=YAG4CUrXLfugX9MnKNziNXvpcdD/ERny9vQfwNm7PNk8pAiuPC0PFuLGGzfD029HTp
         foHXSKywAsE0VfREaaM6sLSxP/xtMAT9g2TYSaNuDhbAy+7b+KtN/Lus0VIYqFYa61EU
         IjABBmaj5iPnmhqiA4m576w+GgvkrsbZTHkVTqOvVD6z7s0wY/VJG/5MuMcB58xpbC7z
         g9xBOGYYte4wlhDCDQBKE/wj2K04+lmEz4TgRJWYCfVupSKGWE3FX86yiXmX+2Bh717n
         QSyvlEjDUzXv0ZaZCCLeoUWkRCLV0rNKxUeKwkeBaEvLViXuAw2jUW7Ky7so4Xpdl7h3
         +RNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/4h1kWzi2Rq+Pv619m3vuzpCBmokzGDwSLu2Jrb6OMI=;
        b=hiET5rgj4Ecb9TkSnsDq5hi42QYa37lGORrHGQFHH2uB8HJhxfisxOXj/S5pKA51c9
         dXHXZc44pn26t1nDMZkhkrHQ1Y99F81UihmjYIjNDyKtfCdATvATNTIGql9u+RPWkc6j
         EE7qaCqpP0eEc5voVqkiIdGEYqqT7YkGje8ZBnegKC0/2IUhq9OfEAkaXmJ1wXR3s4I8
         D7zSzIfJoxh3AEIdEkuM6Tx2uch0MoSBUcJbnSUrcwvGneom69yduVmeYpEcw3ydIm0g
         75ITDuRRVvuLjV65uX2UI0gm2owr/ykYOp6EdljGoDGYk980CuxPcmHkLPcIq8xdz6hM
         8yhA==
X-Gm-Message-State: AJIora9IXHQ5BQE+3tOhNRFuBN3TrOdgzFmwrSz9J/jXvr7diqey1v/O
        Vi++KwvIOUXND0vqo1ZI80fu4vBKno09lR4118o=
X-Google-Smtp-Source: AGRyM1say/Qf64tjtG5GehfkwczzBCkewYdD8OncDHxUGllvZi27Fqj7KaYbGIP8EM/MJgaYRxF76JMUu19z0vTwn+Y=
X-Received: by 2002:a05:6402:3514:b0:435:f24a:fbad with SMTP id
 b20-20020a056402351400b00435f24afbadmr13191088edd.311.1656617119178; Thu, 30
 Jun 2022 12:25:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220629143951.74851-1-quentin@isovalent.com>
In-Reply-To: <20220629143951.74851-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Jun 2022 12:25:07 -0700
Message-ID: <CAEf4BzY3Zh_fgg5j7CeZtN5vUEXdBPio2PS71dULrE3UBEsFvw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: Allow disabling features at compile time
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 7:40 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Some dependencies for bpftool are optional, and the associated features
> may be left aside at compilation time depending on the available
> components on the system (libraries, BTF, clang version, etc.).
> Sometimes, it is useful to explicitly leave some of those features aside
> when compiling, even though the system would support them. For example,
> this can be useful:
>
>     - for testing bpftool's behaviour when the feature is not present,
>     - for copmiling for a different system, where some libraries are
>       missing,
>     - for producing a lighter binary,
>     - for disabling features that do not compile correctly on older
>       systems - although this is not supposed to happen, this is
>       currently the case for skeletons support on Linux < 5.15, where
>       struct bpf_perf_link is not defined in kernel BTF.
>
> For such cases, we introduce, in the Makefile, some environment
> variables that can be used to disable those features: namely,
> BPFTOOL_FEATURE_NO_LIBBFD, BPFTOOL_FEATURE_NO_LIBCAP, and
> BPFTOOL_FEATURE_NO_SKELETONS.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/Makefile | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index c19e0e4c41bd..b3dd6a1482f6 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -93,8 +93,24 @@ INSTALL ?= install
>  RM ?= rm -f
>
>  FEATURE_USER = .bpftool
> -FEATURE_TESTS = libbfd disassembler-four-args zlib libcap \
> -       clang-bpf-co-re
> +FEATURE_TESTS := disassembler-four-args zlib

as an aside, zlib is not really optional, libbpf depends on it and
bpftool depends on libbpf, so... what's the point of a feature test?

> +
> +# Disable libbfd (for disassembling JIT-compiled programs) by setting
> +# BPFTOOL_FEATURE_NO_LIBBFD
> +ifeq ($(BPFTOOL_FEATURE_NO_LIBBFD),)
> +  FEATURE_TESTS += libbfd
> +endif
> +# Disable libcap (for probing features available to unprivileged users) by
> +# setting BPFTOOL_FEATURE_NO_LIBCAP
> +ifeq ($(BPFTOOL_FEATURE_NO_LIBCAP),)
> +  FEATURE_TESTS += libcap
> +endif
> +# Disable skeletons (e.g. for profiling programs or showing PIDs of processes
> +# associated to BPF objects) by setting BPFTOOL_FEATURE_NO_SKELETONS
> +ifeq ($(BPFTOOL_FEATURE_NO_SKELETONS),)
> +  FEATURE_TESTS += clang-bpf-co-re
> +endif
> +
>  FEATURE_DISPLAY = libbfd disassembler-four-args zlib libcap \
>         clang-bpf-co-re
>
> --
> 2.34.1
>
