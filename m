Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB02508E4D
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 19:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355747AbiDTRVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 13:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbiDTRVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 13:21:06 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F60E45AF4;
        Wed, 20 Apr 2022 10:18:20 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id t202so2173807vst.8;
        Wed, 20 Apr 2022 10:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E8pbstQIKMU8n6W0382loX5SA213a1sxeL3uH3Qg3JI=;
        b=k3XSeJBNpwXtCKAiE6JPyVsJWnTxJ4iqv54j9tbN8FuaqK46ZMp4gtSFZCjKfonLPE
         R/cnoFlLe7QKfuwRT9aYsfaMsGKOets5M+f+K9PmO09ISJssgjjb52fl+KGPKvKJOdks
         FYpMcjAmjLbc8HeOPo6IiJ1qSx1KwtuP4hStjQ48xQbeH2F/YNOSCVUEwjNItGkzQ2lf
         8WBUkXWJOTK9mXA0qLglRkFXFzxbf1t1YRo3No1Y6xRmw7sEBSY6xxuOuHoOuzHR4Yk3
         e5Z5bS3okR3eq8MWMu5cq91aUu191A6fSfCRx7XiR9Nm4CoAYk+UVlYzPRle/M1JzMJr
         DTuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E8pbstQIKMU8n6W0382loX5SA213a1sxeL3uH3Qg3JI=;
        b=pzOQzXzzadA7KMuQTcn9m9y0awaElFzr18a/kvmqdlpOrO6nVT7k8dTM64HItfKOMU
         bSocJW9eL2kWZ4+7wDRWR/eiN1zxpTiVAodqI62b2QyfltUXcxNoSK5giJIN8+a2ns0Q
         yQyX5cz+FS7gBTUaEE7rzthdqSGqpOZV6nYmiddVbqFhh+G5lbVgvnxNHPOBLUyKaBwd
         A5PQsEsd1G/iWhL6NaDEnIUqE+/2cpFLQoL6+8EA5+ol44d8ugCJDmiubU4LKqT83jTT
         2ao/KJ47iO98ff+OouQaPDUNYpfDxXOU1bUQ7QkPgxyzFlIvzjhSiWKvvsHKUwd12CjX
         mLhA==
X-Gm-Message-State: AOAM530GpNG7b4LEQtoPmkhQHZXcRDTLyngTPi1YXXld15RFO7fBCMmz
        sQILDIrFUN4s8ucBwUh2qlp2gyT5e++FEKxnwew=
X-Google-Smtp-Source: ABdhPJwcuJYCkBW10RtqOqWTejiFdCLoEZrniTSO/MDyY/NMI4lGYtijRlZqeNR9qXFnkLnvS8yvyDGcgoCFEdKHVDY=
X-Received: by 2002:a67:f80b:0:b0:32a:17d6:7fb2 with SMTP id
 l11-20020a67f80b000000b0032a17d67fb2mr6263197vso.40.1650475099231; Wed, 20
 Apr 2022 10:18:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-9-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-9-alobakin@pm.me>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Apr 2022 10:18:08 -0700
Message-ID: <CAEf4BzZVohaHdCTz_KFVdEus2pndLTZvg=BHfujpgt29qbio3Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 08/11] samples: bpf: fix shifting unsigned long
 by 32 positions
To:     Alexander Lobakin <alobakin@pm.me>, Yonghong Song <yhs@fb.com>
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
        Song Liu <songliubraving@fb.com>,
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
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 3:46 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> On 32 bit systems, shifting an unsigned long by 32 positions
> yields the following warning:
>
> samples/bpf/tracex2_kern.c:60:23: warning: shift count >= width of type [-Wshift-count-overflow]
>         unsigned int hi = v >> 32;
>                             ^  ~~
>

long is always 64-bit in BPF, but I suspect this is due to
samples/bpf/Makefile still using this clang + llc combo, where clang
is called with native target and llc for -target bpf. Not sure if we
are ready to ditch that complicated combination. Yonghong, do we still
need that or can we just use -target bpf in samples/bpf?


> The usual way to avoid this is to shift by 16 two times (see
> upper_32_bits() macro in the kernel). Use it across the BPF sample
> code as well.
>
> Fixes: d822a1926849 ("samples/bpf: Add counting example for kfree_skb() function calls and the write() syscall")
> Fixes: 0fb1170ee68a ("bpf: BPF based latency tracing")
> Fixes: f74599f7c530 ("bpf: Add tests and samples for LWT-BPF")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  samples/bpf/lathist_kern.c      | 2 +-
>  samples/bpf/lwt_len_hist_kern.c | 2 +-
>  samples/bpf/tracex2_kern.c      | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>

[...]
