Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DF5503379
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356635AbiDOX7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238226AbiDOX7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:59:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9783D29826;
        Fri, 15 Apr 2022 16:56:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E3776227C;
        Fri, 15 Apr 2022 23:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB88C385A9;
        Fri, 15 Apr 2022 23:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650066997;
        bh=6MeCF3Sbghhbx4Nc1Tx4NayNkdJXWablaTdOWyN92Sc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nZPwFrqZKGvCtPxx7/aApRjqIo3gJppWAvu4722/OF2g/TrxPiZseK7Kvd8AiE4K+
         3tsMsZ7Kd/rKRELsj9yBKqBvBtD293A9Vj/MeE5g2f96rBHdBXvw8Zxn8j78NbCGTB
         Kr7Grxe2JzW0K7OEJzOYtP0Y48bhbU+sW9NMZdsrwQ0/Mj/S9CNP/pjvgU4lVrOP4B
         FKj/KO/ASt+lzDVghuZOkmw5KtrlMdvvQL1rNUCX4snmre4TMKdgyI2j0E+0Cr1yW8
         UchkOMihSiUhKWbb51Vo4MQ5Cv4PPczPBiiMQXDsSHDD3AuPIC/z/Btex+59GpA1rl
         ERdCNZkO8d7Jw==
Received: by mail-yb1-f177.google.com with SMTP id m132so16726357ybm.4;
        Fri, 15 Apr 2022 16:56:37 -0700 (PDT)
X-Gm-Message-State: AOAM532guazdwKo333ZAoBL5VTrfGb+tTcAqAxAtIX+aQKob464EkIqm
        9rnNNYbpyHg5NPFg1hJaavNBhI+t9p441I04Ofc=
X-Google-Smtp-Source: ABdhPJyXgrsL54epueeF7YOhlez6BRY3vO4KvzuACHTCURJPUspz60IcOFcrWXrFgtwea5S6eI523ixLqfjUo8hkbfw=
X-Received: by 2002:a25:d40e:0:b0:641:1842:ed4b with SMTP id
 m14-20020a25d40e000000b006411842ed4bmr1401360ybf.257.1650066996589; Fri, 15
 Apr 2022 16:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-11-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-11-alobakin@pm.me>
From:   Song Liu <song@kernel.org>
Date:   Fri, 15 Apr 2022 16:56:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4kqcjgd=ckUDToebvGUmRUJC290ryJShbPDzv43S0kvg@mail.gmail.com>
Message-ID: <CAPhsuW4kqcjgd=ckUDToebvGUmRUJC290ryJShbPDzv43S0kvg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/11] samples: bpf: fix -Wsequence-point
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
> In some libc implementations, CPU_SET() may utilize its first
> argument several times. When combined with a post-increment, it
> leads to:
>
> samples/bpf/test_lru_dist.c:233:36: warning: operation on 'next_to_try' may be undefined [-Wsequence-point]
>   233 |                 CPU_SET(next_to_try++, &cpuset);
>       |                                    ^
>
> Split the sentence into two standalone operations to fix this.
>
> Fixes: 5db58faf989f ("bpf: Add tests for the LRU bpf_htab")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  samples/bpf/test_lru_dist.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/samples/bpf/test_lru_dist.c b/samples/bpf/test_lru_dist.c
> index be98ccb4952f..191643ec501e 100644
> --- a/samples/bpf/test_lru_dist.c
> +++ b/samples/bpf/test_lru_dist.c
> @@ -229,7 +229,8 @@ static int sched_next_online(int pid, int next_to_try)
>
>         while (next_to_try < nr_cpus) {
>                 CPU_ZERO(&cpuset);
> -               CPU_SET(next_to_try++, &cpuset);
> +               CPU_SET(next_to_try, &cpuset);
> +               next_to_try++;
>                 if (!sched_setaffinity(pid, sizeof(cpuset), &cpuset))
>                         break;
>         }
> --
> 2.35.2
>
>
