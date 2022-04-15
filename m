Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB231503390
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356497AbiDOX1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356483AbiDOX10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:27:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FAF27B26;
        Fri, 15 Apr 2022 16:24:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 790F6B83131;
        Fri, 15 Apr 2022 23:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A869C385A9;
        Fri, 15 Apr 2022 23:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650065093;
        bh=ve8zcTJK3ne1EGkyC8vWulpuyQc5Xh6ZoQ+EsFt9Deo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=f8MNQheziBEXQrO0FxkqhOwkyp/nfmv5VcI4MCAXbtxdywRrg4Ok8nWhPn7wnT4oV
         26uaqET1A13eL0c9fwo6GD4/3E9bDIC+UNd9r0LRGbHfZFieNHO9c9Sjx8unQMLC/B
         RJzlVMWW6Q+LMn4uXY0lXXd0xDM/7AG9fsf7NxG7MdOpr+dJmdU7s9vT67drUqHt2n
         tKxC1kfAcoPvCBqZFnjQDPWv+L5diPtMUG0ASR2oGSCytsKVHR5Ag5fEnRR1jlcbjt
         Dvx7A0V6tFZEtxwnuBazxUbSi2L1vVGNJ2Y1Kv91zDp7oIDOm4dv/5FAVL/u29w0Mk
         5Pveg8OiZwA0Q==
Received: by mail-yb1-f173.google.com with SMTP id p65so16609188ybp.9;
        Fri, 15 Apr 2022 16:24:53 -0700 (PDT)
X-Gm-Message-State: AOAM532C1lvTx90fXMcgZrMExT8KvNC0cqYIk6gOh66aZKuHxnAUk94u
        KdJY3YCZbEWbI8p0AZVuohMMCDaBu7hR5AHmgQ8=
X-Google-Smtp-Source: ABdhPJy7qY8jdimtSi+WscUV67jjwPF27xZeL7M2caaxM31nPgf3vJcWAjTfoqUC0w9w5k4HE68MfI3InHS6lHUjQn8=
X-Received: by 2002:a05:6902:1506:b0:63e:4f1b:40ae with SMTP id
 q6-20020a056902150600b0063e4f1b40aemr1399464ybu.322.1650065092238; Fri, 15
 Apr 2022 16:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-3-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-3-alobakin@pm.me>
From:   Song Liu <song@kernel.org>
Date:   Fri, 15 Apr 2022 16:24:41 -0700
X-Gmail-Original-Message-ID: <CAPhsuW42Sv2EkMzVoh2+i=2NN2yMRHOqDN8wmXGPax2-cz8ynA@mail.gmail.com>
Message-ID: <CAPhsuW42Sv2EkMzVoh2+i=2NN2yMRHOqDN8wmXGPax2-cz8ynA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/11] bpf: always emit struct bpf_perf_link BTF
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

On Thu, Apr 14, 2022 at 3:45 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> When building bpftool with !CONFIG_PERF_EVENTS:
>
> skeleton/pid_iter.bpf.c:47:14: error: incomplete definition of type 'struct bpf_perf_link'
>         perf_link = container_of(link, struct bpf_perf_link, link);
>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:74:22: note: expanded from macro 'container_of'
>                 ((type *)(__mptr - offsetof(type, member)));    \
>                                    ^~~~~~~~~~~~~~~~~~~~~~
> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:68:60: note: expanded from macro 'offsetof'
>  #define offsetof(TYPE, MEMBER)  ((unsigned long)&((TYPE *)0)->MEMBER)
>                                                   ~~~~~~~~~~~^
> skeleton/pid_iter.bpf.c:44:9: note: forward declaration of 'struct bpf_perf_link'
>         struct bpf_perf_link *perf_link;
>                ^
>
> &bpf_perf_link is being defined and used only under the ifdef.
> Move it out of the block and explicitly emit a BTF to fix
> compilation.
>
> Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Similar to v1, this fix is weird to me. I hope we have can fix it in user
space.
