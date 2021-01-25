Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F38A303094
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbhAYXxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbhAYXwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 18:52:03 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F2DC06174A;
        Mon, 25 Jan 2021 15:51:21 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id e206so2782718ybh.13;
        Mon, 25 Jan 2021 15:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qZvwvmKLspAExS2kwmTTz9/DNwWIFqV/R4BI9mcKzX4=;
        b=tl5UpclauFBd1JetlUKe42cfMkBDF2Tg5NRIlicYWlOgaYAb62nk7yEdyR4/lSGwE2
         eC9VKlfKrkqdj87OtXPOobJdB2u3N5umKsAIoU/Kk54tOzKzxa3fZYr6yCeRmQRQRwnJ
         0UFN0W0/tI1l6XflhEpJLy50wVYCDAR8oS/zSRGhsuXBDZB/K+lBz7TKn9ikBhtXZnx8
         429A4SBQXJI4M1QE+HgHmaJI/SbMeIteOJPINlOIGenQ90vadX/D1ofjotUiIkgQqcQp
         LipsIsZil6Ox1SRjJy7PGnsdK1JKdxm0EAiKPcOMpzdd8YdOxL3n7aGR9GoJ+toXRpUS
         4QRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qZvwvmKLspAExS2kwmTTz9/DNwWIFqV/R4BI9mcKzX4=;
        b=ofRkm4KpF/hm4sU/zp6s7bqPuRkcXOXu98H8Ln7c1JKojDSutKTWu2MvukiPmiI+cd
         U4pGuFUki6ouet8/acETXmDXYcZWLIxDNwb/0C6cll3Ikc0EiFkUarohaEEmgufCYB1S
         lwEdIpQcSvwcCUS6AkwfmhscgHARoETf/rYcW1o11oEDQQmlSHIQqw2XelbUzPbgQpyE
         ElNVAUTwVOv26YlTlpzJmS6a4alIMn3yJUyEL5HHyQpYSSpnc2VokAYZkSSaVsiFQzMC
         XbEVHpyu7CpUR92/FKU+jAZuVBm/onjJTkgt2mLxM9rbF2mr6KzjkhODdzvLUT6zBeyi
         aquA==
X-Gm-Message-State: AOAM5338dr6C/TubeTJMu8CMXHp07rCcaxKplf+WT6PNhJdEw3R2L17q
        NcrIrUjXc0VFjrw9x6a3v542HK3SNj00PxEg0mY=
X-Google-Smtp-Source: ABdhPJzLwdlN8XUSoocavs0qXYzkNT5XHy9fhp0/ISEXKqAPRdPYbgN6b6ymo+swubUCoDaHVhOUPrZxKBWC5hiFURY=
X-Received: by 2002:a25:ad91:: with SMTP id z17mr4671269ybi.260.1611618680667;
 Mon, 25 Jan 2021 15:51:20 -0800 (PST)
MIME-Version: 1.0
References: <20210124221519.219750-1-jolsa@kernel.org> <20210124221519.219750-3-jolsa@kernel.org>
In-Reply-To: <20210124221519.219750-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Jan 2021 15:51:08 -0800
Message-ID: <CAEf4BzaKMb-qxnWAMNL94+tseNaJCh3g1NBU4BTwh9ZQ_JVUjg@mail.gmail.com>
Subject: Re: [PATCH 2/2] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 2:18 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> For very large ELF objects (with many sections), we could
> get special value SHN_XINDEX (65535) for symbol's st_shndx.
>
> This patch is adding code to detect the optional extended
> section index table and use it to resolve symbol's section
> index.
>
> Adding elf_symtab__for_each_symbol_index macro that returns
> symbol's section index and usign it in collect functions.
>
> Tested by running pahole on kernel compiled with:
>   make KCFLAGS="-ffunction-sections -fdata-sections" -j$(nproc) vmlinux
>
> and ensure FUNC records are generated and match normal
> build (without above KCFLAGS).
>
> Also bpf selftest passed and generated kernel BTF,
> is same as without the patch.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>


>  btf_encoder.c | 33 +++++++++++++++++----------------
>  elf_symtab.c  | 41 +++++++++++++++++++++++++++++++++++++++--
>  elf_symtab.h  | 29 +++++++++++++++++++++++++++++
>  3 files changed, 85 insertions(+), 18 deletions(-)
>

[...]
