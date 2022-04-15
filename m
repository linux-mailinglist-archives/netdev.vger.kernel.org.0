Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045825033C8
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356625AbiDOX6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356571AbiDOX6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:58:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAF429813;
        Fri, 15 Apr 2022 16:55:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9FDF61BD5;
        Fri, 15 Apr 2022 23:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59405C385AB;
        Fri, 15 Apr 2022 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650066939;
        bh=YH64/o1O+cqN6mti7iSTLeA7PRyBcNLfWO/TvtuyAM8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tkijavTCh1wVpyg+GjXJWWbYnnBjhHT+VkxUTBA1yNFhK+lDbtQly03gbGjuQlecJ
         1/PdgTWTwD8+0wlBnSNAUAm4BP7J0+yg2kaBGsrMxX/GSPpgIRefw/lTXp+CWzoMrv
         AL7hKp4iQgOEehAvpQUphLN7fZSzIvDuubGXG1alsj7m3jcRTmOiW09CbmNry+O6RG
         g+vyiSgs8nBIqWtiAdbx9o7hpLwXoeBOLW4E1qsBxOIunG7UKdd/m02ollqGST2ARt
         tLYdHJBEg/wPPr3Zit8+9oiGGx6MlyFMIJbeGF/CMTG7ylRTlfQd10i1q+THVo3K2n
         xVSAa8A7lSrIQ==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-2edbd522c21so95306007b3.13;
        Fri, 15 Apr 2022 16:55:39 -0700 (PDT)
X-Gm-Message-State: AOAM531kvRrqHNq7pxRIXctyKdQzH+8cA0kfP7ijA5rC6J9Lwzzg7ILq
        bLpsvidBJcBOy9cYE7eyRWnipKVFXPo/UyfnQmo=
X-Google-Smtp-Source: ABdhPJyISR8EYC48dmNmJAW81L5Nb6ADJpA6bDXJ40TpY8Kqerl/tVZf49sPOq2grieqfsNCYMchikwY4VqrGsQb5qc=
X-Received: by 2002:a81:5087:0:b0:2ef:33c1:fccd with SMTP id
 e129-20020a815087000000b002ef33c1fccdmr1206424ywb.73.1650066938416; Fri, 15
 Apr 2022 16:55:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-10-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-10-alobakin@pm.me>
From:   Song Liu <song@kernel.org>
Date:   Fri, 15 Apr 2022 16:55:27 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7DxW-3MJKd+26eLGZ+hT_sWnV+QOW8BCy-51VzPsXKTA@mail.gmail.com>
Message-ID: <CAPhsuW7DxW-3MJKd+26eLGZ+hT_sWnV+QOW8BCy-51VzPsXKTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 09/11] samples: bpf: fix include order for
 non-Glibc environments
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Chenbo Feng <fengc@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-perf-users@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 3:47 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Some standard C library implementations, e.g. Musl, ship the UAPI
> definitions themselves to not be dependent on the UAPI headers and
> their versions. Their kernel UAPI counterparts are usually guarded
> with some definitions which the formers set in order to avoid
> duplicate definitions.
> In such cases, include order matters. Change it in two samples: in
> the first, kernel UAPI ioctl definitions should go before the libc
> ones, and the opposite story with the second, where the kernel
> includes should go later to avoid struct redefinitions.
>
> Fixes: b4b8faa1ded7 ("samples/bpf: sample application and documentation for AF_XDP sockets")
> Fixes: e55190f26f92 ("samples/bpf: Fix build for task_fd_query_user.c")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  samples/bpf/task_fd_query_user.c | 2 +-
>  samples/bpf/xdpsock_user.c       | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query_user.c
> index 424718c0872c..5d3a60547f9f 100644
> --- a/samples/bpf/task_fd_query_user.c
> +++ b/samples/bpf/task_fd_query_user.c
> @@ -9,10 +9,10 @@
>  #include <stdint.h>
>  #include <fcntl.h>
>  #include <linux/bpf.h>
> +#include <linux/perf_event.h>
>  #include <sys/ioctl.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> -#include <linux/perf_event.h>
>
>  #include <bpf/bpf.h>
>  #include <bpf/libbpf.h>
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index be7d2572e3e6..399b999fcec2 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -7,14 +7,15 @@
>  #include <linux/bpf.h>
>  #include <linux/if_link.h>
>  #include <linux/if_xdp.h>
> -#include <linux/if_ether.h>
>  #include <linux/ip.h>
>  #include <linux/limits.h>
> +#include <linux/net.h>
>  #include <linux/udp.h>
>  #include <arpa/inet.h>
>  #include <locale.h>
>  #include <net/ethernet.h>
>  #include <netinet/ether.h>
> +#include <linux/if_ether.h>
>  #include <net/if.h>
>  #include <poll.h>
>  #include <pthread.h>
> --
> 2.35.2
>
>
