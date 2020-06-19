Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4141FFF62
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 02:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgFSAkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 20:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgFSAkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 20:40:46 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B967EC06174E;
        Thu, 18 Jun 2020 17:40:44 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f18so7521408qkh.1;
        Thu, 18 Jun 2020 17:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z4CyF9VpPvsJa6rNrAKTTU05ZhFvpQhQT1j9KVSHvC0=;
        b=MSZ5/XcfxaU6QYf4fz/u+QHOEUVIkMvJiCh9TC0OpGJ0OVtyf1zbGSki4zpunVujq8
         bY6Txd1KiJAVYJnuO+DBvHhpztrIjBXnTDzJl77t48yhEx4tel/wP+YXACb5aFx7OzPU
         GFpyEPgVHeYZLLJVtHyYLdmbur6NXwBdVJanSv6mRFYUdtPOr6I6iyFX/vkaL+Y6QXIg
         3nb4Iclau+FZoEULqWwYnvs/y+gEjJHlATTY6RquQmQX5Au6S96p9bti6Mye3R9ZsL+9
         brN8sLjpo9+Ym+brwlOLMv0kPhytgA8eijMJoU0dR0YDhH4xkd5cJXfHhhkzzruyZbOL
         FRUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z4CyF9VpPvsJa6rNrAKTTU05ZhFvpQhQT1j9KVSHvC0=;
        b=lBcyKiNeL1rlTwNk3JG5U5Sgku5QrtaXGGADRZ9kOyt2PYbFFOKpzUWUpyZaJzPuwj
         UVH5CmLQbaEckUZYETeV/q5sBwx5LouBAGit7e1AkBbc6bWMlZEYSeM3l24flBB8Adq3
         yYuLVcWjMpCFOtwatb3DxTpWo7/uYAGaGCu//MV4h5rbF8X6uZq4A6GIpetFa/SCdLXf
         O/A51Pu4f1mdQLunV+MJ2ok6/IZcnIKik8neaAyny101oJXbRymg4KzI79uXYC9bBpqt
         cVnJrA2Rsuo1J4dqn7hX9LBudAlKHSowWYJ7iazGtI9hi1Xa705svyadziqMwbgLUN2/
         LpAg==
X-Gm-Message-State: AOAM533MLCmCXKh/ptW6hLHWWEVh3xNP2PF41e+mTV/d/IGJezHmjSEm
        yqYhNEwPl2BGEwhXRrhh8Vz5W1S2DSkQEchp1qU=
X-Google-Smtp-Source: ABdhPJwvFPqIQWPcaHhjBrezimUpYdI6a3nwcLCrzxoM5unVXsKRxJ2Drx1/mArid/PxpO/qojB3qx6yYi0FERf/DTQ=
X-Received: by 2002:a05:620a:b84:: with SMTP id k4mr1161804qkh.39.1592527244020;
 Thu, 18 Jun 2020 17:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-3-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 17:40:32 -0700
Message-ID: <CAEf4BzaL3bc8Hmm20Y-qEqfr7kZS2s8-KeE8M6Mz9ni81CSu4w@mail.gmail.com>
Subject: Re: [PATCH 02/11] bpf: Compile btfid tool at kernel compilation start
To:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 3:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The btfid tool will be used during the vmlinux linking,
> so it's necessary it's ready for it.
>

Seeing troubles John runs into, I wonder if it maybe would be better
to add it to pahole instead? It's already a dependency for anything
BTF-related in the kernel. It has libelf, libbpf linked and set up.
WDYT? I've cc'ed Arnaldo as well for an opinion.

> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  Makefile           | 22 ++++++++++++++++++----
>  tools/Makefile     |  3 +++
>  tools/bpf/Makefile |  5 ++++-
>  3 files changed, 25 insertions(+), 5 deletions(-)
>

[...]
