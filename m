Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A443C5453C6
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 20:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345174AbiFISL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 14:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiFISL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 14:11:56 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EDFEBA89;
        Thu,  9 Jun 2022 11:11:55 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id w20so17576468lfa.11;
        Thu, 09 Jun 2022 11:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wa5+7Ua+o1gsnunSmNIYAMm6Jg9lLaYkR4rgU6BaP74=;
        b=gyS/q+Ndb+nVDe4qMwR01ny3c0CwbotAbR8WzWWTiRTU+dI0xvcLlNcdo9W8DKldbN
         xIZzvY9H7TL5LihL2SaN4Dme0knRtLU0ascZZxUQzH0hNaUDAd1ZBil3Oi0SS8Oc/3mI
         qhly9sIogMShRAuZHao2pMS3wvcej9HQDWp1dJppE1RJHYyBlDkzbjH2jGIcvtIGuLb+
         8QGCTMxZoHTZp02VLdsZdr0lBD9aQx4hNkPT+gD7r8pFL3xGMkTK7s926balR+mT13/O
         Oh/JkzQslIF7He7WdMqCer7Kvp4Sy1CNiVFN8CjJxNYKfa4nEnabPAw35yBZM2taGVzA
         zZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wa5+7Ua+o1gsnunSmNIYAMm6Jg9lLaYkR4rgU6BaP74=;
        b=aZh0J+H/9pAVSb8jVDGa9ivpRbIq2uZV0edPFS5b+cgUzycCjoQxy9ztaMeDdhfv6X
         NTfv38W1MO2cM5zpSpFLJJGBXRboZKPOVJ3hvq6+6dP+6XFGS45MsgAsDh3LVoMiEG06
         FVHEAgSaTOcQEw2yZKHlhNOOMsq/S8OuGk/Wdm6G0LHp4cg1BPVZUGSHYK6uaOyGFMUg
         R6aS4PhGFFMzrTTl8g7lHC7AyqLEcJTXUKO9b7mjYXNgw034NuqKyFT8bWZmE+rob/7N
         3nEOaC0tjZQd34KtYZErrParzEuvNyib8gzP2mGmjW0aiUFIHmHZ6nzJnGNUMQnWUDnc
         FNFQ==
X-Gm-Message-State: AOAM533nMAoBf30Dh4gSyWPnrpUPCCEFEr2ohmcucWHV40rvip14wJox
        6zoJkXZQoc0QsGvtbrDtOaBiu2MgLYlWx9LlKfc65xlHolM=
X-Google-Smtp-Source: ABdhPJzATVkjnSUu7Exdv94wsFS5xYaIBAzIfK2YdLU94NNSCHpegCGreT/e9JkUL0anRMP8sHjXa0O+sRWABw3plEg=
X-Received: by 2002:a05:6512:2296:b0:479:5805:6f05 with SMTP id
 f22-20020a056512229600b0047958056f05mr10801238lfu.302.1654798313751; Thu, 09
 Jun 2022 11:11:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220609062829.293217-1-james.hilliard1@gmail.com>
In-Reply-To: <20220609062829.293217-1-james.hilliard1@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Jun 2022 11:11:42 -0700
Message-ID: <CAEf4BzaNBcW8ZDWcH5USd9jFshFF78psAjn2mqZp6uVGn0ZK+g@mail.gmail.com>
Subject: Re: [PATCH 1/1] libbpf: replace typeof with __typeof__ for -std=c17 compatibility
To:     James Hilliard <james.hilliard1@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 11:28 PM James Hilliard
<james.hilliard1@gmail.com> wrote:
>
> Fixes errors like:
> error: expected specifier-qualifier-list before 'typeof'
>    14 | #define __type(name, val) typeof(val) *name
>       |                           ^~~~~~
> ../src/core/bpf/socket_bind/socket-bind.bpf.c:25:9: note: in expansion of macro '__type'
>    25 |         __type(key, __u32);
>       |         ^~~~~~
>
> Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> ---

If you follow DPDK link you gave me ([0]), you'll see that they ended up doing

#ifndef typeof
#define typeof __typeof__
#endif

It's way more localized. Let's do that.

But also I tried to build libbpf-bootstrap with -std=c17 and
immediately ran into issue with asm, so we need to do the same with
asm -> __asm__. Can you please update your patch and fix both issues?

  [0] https://patches.dpdk.org/project/dpdk/patch/2601191342CEEE43887BDE71AB977258213F3012@irsmsx105.ger.corp.intel.com/
  [1] https://github.com/libbpf/libbpf-bootstrap


>  tools/lib/bpf/bpf_core_read.h   | 16 ++++++++--------
>  tools/lib/bpf/bpf_helpers.h     |  4 ++--
>  tools/lib/bpf/bpf_tracing.h     | 24 ++++++++++++------------
>  tools/lib/bpf/btf.h             |  4 ++--
>  tools/lib/bpf/libbpf_internal.h |  6 +++---
>  tools/lib/bpf/usdt.bpf.h        |  6 +++---
>  tools/lib/bpf/xsk.h             | 12 ++++++------
>  7 files changed, 36 insertions(+), 36 deletions(-)
>

[...]
