Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495A8503440
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356671AbiDPAAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 20:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356668AbiDPAAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 20:00:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83C498F51;
        Fri, 15 Apr 2022 16:58:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7743FB831BC;
        Fri, 15 Apr 2022 23:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBDDC385AF;
        Fri, 15 Apr 2022 23:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650067086;
        bh=5uISNHkYs1nGeyc2gtdd+Tm04KE96qpSVHvbrefArMc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Jt1cEPvPZxAt277UsraKj/YntuLhptaIO0NeOoBBAJDmYF1z/mStui6jXWV0GMnqX
         dyqYf1TMHxb7PWpzyRt3oSlha9fe5zBVnyqmlGednBX8P8ko8N0HTexKDk6c3tSBB3
         6zqYAjjxPryXxFbyZorSqbmnRaq0y/GhyOhgo+j28OJ56+USX+9R9asuXC3wIvmnp6
         kQQAaz0T2BsILtv3OkI/ql1VWrXFjGpJ6m9eu//RlLL/uJv8NQj6HCHVSVeuxz4yky
         HTw0KcX6ibn7YJNAHwznAY8jC5kD2sPOO6N2ZOGx3cQooF71AT8R9zJnTj1DSKOrIU
         mHkpoX9jMejVg==
Received: by mail-yb1-f173.google.com with SMTP id g34so16776700ybj.1;
        Fri, 15 Apr 2022 16:58:06 -0700 (PDT)
X-Gm-Message-State: AOAM532Cg/Vb84C7a3lB+QOQ+68eRDpWdx+kRuKVIREfrIidwRT2FUQT
        dsHtTUmnmzjDnWzIXTsyn8gC9HQd7RHWJ1g9KuU=
X-Google-Smtp-Source: ABdhPJybxj+8d+7EJs75ezIJxY82zI1XIdOLEnfK0kcbWGxveLN8Fw6lKBxYoaZjVWq1p2nZnBaUqci3FtMl9NxCLmw=
X-Received: by 2002:a25:8546:0:b0:61e:1d34:ec71 with SMTP id
 f6-20020a258546000000b0061e1d34ec71mr1262667ybn.259.1650067085117; Fri, 15
 Apr 2022 16:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-12-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-12-alobakin@pm.me>
From:   Song Liu <song@kernel.org>
Date:   Fri, 15 Apr 2022 16:57:53 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7AV+RSqmH3WOSB6uvS2oiXH-Tgfx84H0rEC9_NyZ3SNA@mail.gmail.com>
Message-ID: <CAPhsuW7AV+RSqmH3WOSB6uvS2oiXH-Tgfx84H0rEC9_NyZ3SNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 11/11] samples: bpf: xdpsock: fix -Wmaybe-uninitialized
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
> Fix two sort-of-false-positives in the xdpsock userspace part:
>
> samples/bpf/xdpsock_user.c: In function 'main':
> samples/bpf/xdpsock_user.c:1531:47: warning: 'tv_usec' may be used uninitialized in this function [-Wmaybe-uninitialized]
>  1531 |                         pktgen_hdr->tv_usec = htonl(tv_usec);
>       |                                               ^~~~~~~~~~~~~~
> samples/bpf/xdpsock_user.c:1500:26: note: 'tv_usec' was declared here
>  1500 |         u32 idx, tv_sec, tv_usec;
>       |                          ^~~~~~~
> samples/bpf/xdpsock_user.c:1530:46: warning: 'tv_sec' may be used uninitialized in this function [-Wmaybe-uninitialized]
>  1530 |                         pktgen_hdr->tv_sec = htonl(tv_sec);
>       |                                              ^~~~~~~~~~~~~
> samples/bpf/xdpsock_user.c:1500:18: note: 'tv_sec' was declared here
>  1500 |         u32 idx, tv_sec, tv_usec;
>       |                  ^~~~~~
>
> Both variables are always initialized when @opt_tstamp == true and
> they're being used also only when @opt_tstamp == true. However, that
> variable comes from the BSS and is being toggled from another
> function. They can't be executed simultaneously to actually trigger
> undefined behaviour, but purely technically it is a correct warning.
> Just initialize them with zeroes.
>
> Fixes: eb68db45b747 ("samples/bpf: xdpsock: Add timestamp for Tx-only operation")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  samples/bpf/xdpsock_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index 399b999fcec2..1dc7ad5dbef4 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -1496,7 +1496,7 @@ static void rx_drop_all(void)
>  static int tx_only(struct xsk_socket_info *xsk, u32 *frame_nb,
>                    int batch_size, unsigned long tx_ns)
>  {
> -       u32 idx, tv_sec, tv_usec;
> +       u32 idx, tv_sec = 0, tv_usec = 0;
>         unsigned int i;
>
>         while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) <
> --
> 2.35.2
>
>
