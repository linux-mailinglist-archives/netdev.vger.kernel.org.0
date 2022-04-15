Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97734503325
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242328AbiDOXzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiDOXy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:54:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750A4954B6;
        Fri, 15 Apr 2022 16:52:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B8D7B831BC;
        Fri, 15 Apr 2022 23:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B715AC385B0;
        Fri, 15 Apr 2022 23:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650066745;
        bh=errT7JCib6AzTkVoGPltwDcZINvMpoIAWe1b0AzmVjQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qNxv7R7kwGBplr4pFmyq+iyauWnfSUOQxiEV1D253Qu6QckwiUPoV8kS8B7hDvkIF
         8r/h9C9qoQH1xiKBFuj/MwKoZ2yrwUVOzdx0QQqGQdu6eIJ91rZ6zdZ3AFGmkUJLMx
         QeEhdcIHd+4kyqWYYERVkKlTGUBe8Tt33vmkE34mBM0rlflT0tTIeqCHkAPYy2m/Yi
         XL8JHpBzufzAHD7Lh80CX6Zg+a/JNDywq9F5odVU9gXMoiEOWmSle+Uqx/Gq0yrHeM
         Rzwu6FWkxKLl9ptrE4BaqBMNgBwR02nEefskx1y9zRueUrC/vgsuzK78JSe9f3Tzpm
         GAMzI5xhgbiwA==
Received: by mail-yb1-f181.google.com with SMTP id p65so16676882ybp.9;
        Fri, 15 Apr 2022 16:52:25 -0700 (PDT)
X-Gm-Message-State: AOAM531dF0jGOBsvuwFNiY8RNx9TS51fVO9REBpJg3c7yXIo+Nw4U4Mj
        gxt0cn8ndAp3aRtIEYKnrCsk2QLkQrbQ1XhSgFo=
X-Google-Smtp-Source: ABdhPJx72bmk61XUaqJvL+i1XHxlM70OjJc/9IRT4lbbDvxH0qPpB5kgaRzVhtGK/RofPmCZoqlatSkJeo/Au/tdM30=
X-Received: by 2002:a25:8b81:0:b0:629:17d5:68c1 with SMTP id
 j1-20020a258b81000000b0062917d568c1mr1296810ybl.449.1650066744755; Fri, 15
 Apr 2022 16:52:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-8-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-8-alobakin@pm.me>
From:   Song Liu <song@kernel.org>
Date:   Fri, 15 Apr 2022 16:52:13 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7FuAKX0fJ1XPfFWWwRS+wTW0qA49V-iQVzxv4jOb47MA@mail.gmail.com>
Message-ID: <CAPhsuW7FuAKX0fJ1XPfFWWwRS+wTW0qA49V-iQVzxv4jOb47MA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/11] samples: bpf: fix uin64_t format literals
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

On Thu, Apr 14, 2022 at 3:46 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> There's a couple places where uin64_t is being passed as an %ld
> format argument, which is incorrect (should be %lld). Fix them.

This will cause some warning on some 64-bit compiler, no?

Song

>
> Fixes: 51570a5ab2b7 ("A Sample of using socket cookie and uid for traffic monitoring")
> Fixes: 00f660eaf378 ("Sample program using SO_COOKIE")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  samples/bpf/cookie_uid_helper_example.c | 12 ++++++------
>  samples/bpf/lwt_len_hist_user.c         |  4 ++--
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/samples/bpf/cookie_uid_helper_example.c b/samples/bpf/cookie_uid_helper_example.c
> index f0df3dda4b1f..1b98debb6019 100644
> --- a/samples/bpf/cookie_uid_helper_example.c
> +++ b/samples/bpf/cookie_uid_helper_example.c
> @@ -207,9 +207,9 @@ static void print_table(void)
>                         error(1, errno, "fail to get entry value of Key: %u\n",
>                                 curN);
>                 } else {
> -                       printf("cookie: %u, uid: 0x%x, Packet Count: %lu,"
> -                               " Bytes Count: %lu\n", curN, curEntry.uid,
> -                               curEntry.packets, curEntry.bytes);
> +                       printf("cookie: %u, uid: 0x%x, Packet Count: %llu, Bytes Count: %llu\n",
> +                              curN, curEntry.uid, curEntry.packets,
> +                              curEntry.bytes);
>                 }
>         }
>  }
> @@ -265,9 +265,9 @@ static void udp_client(void)
>                 if (res < 0)
>                         error(1, errno, "lookup sk stat failed, cookie: %lu\n",
>                               cookie);
> -               printf("cookie: %lu, uid: 0x%x, Packet Count: %lu,"
> -                       " Bytes Count: %lu\n\n", cookie, dataEntry.uid,
> -                       dataEntry.packets, dataEntry.bytes);
> +               printf("cookie: %llu, uid: 0x%x, Packet Count: %llu, Bytes Count: %llu\n\n",
> +                      cookie, dataEntry.uid, dataEntry.packets,
> +                      dataEntry.bytes);
>         }
>         close(s_send);
>         close(s_rcv);
> diff --git a/samples/bpf/lwt_len_hist_user.c b/samples/bpf/lwt_len_hist_user.c
> index 430a4b7e353e..4ef22571aa67 100644
> --- a/samples/bpf/lwt_len_hist_user.c
> +++ b/samples/bpf/lwt_len_hist_user.c
> @@ -44,7 +44,7 @@ int main(int argc, char **argv)
>
>         while (bpf_map_get_next_key(map_fd, &key, &next_key) == 0) {
>                 if (next_key >= MAX_INDEX) {
> -                       fprintf(stderr, "Key %lu out of bounds\n", next_key);
> +                       fprintf(stderr, "Key %llu out of bounds\n", next_key);
>                         continue;
>                 }
>
> @@ -66,7 +66,7 @@ int main(int argc, char **argv)
>
>         for (i = 1; i <= max_key + 1; i++) {
>                 stars(starstr, data[i - 1], max_value, MAX_STARS);
> -               printf("%8ld -> %-8ld : %-8ld |%-*s|\n",
> +               printf("%8ld -> %-8ld : %-8lld |%-*s|\n",
>                        (1l << i) >> 1, (1l << i) - 1, data[i - 1],
>                        MAX_STARS, starstr);
>         }
> --
> 2.35.2
>
>
