Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6A120BAB0
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgFZUxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFZUxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:53:50 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA1BC03E979;
        Fri, 26 Jun 2020 13:53:50 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id o38so8515186qtf.6;
        Fri, 26 Jun 2020 13:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mxcyMm7JBj93gJinroz3hDVgZv/8ciunH7mozYt+4hU=;
        b=vBN1uw2GNtct8AG5j6IZkjggV9dHSOTu+ms/jOrFy5tJ1Cxa3Jkyr+BWmCn7+mmm6i
         zNdp9b4RngoX9G8PkjHpQcjFnPjkY2LvmBCioVqjeyL0DISsEwNcNYY1gJ0fKRgQ2Ysd
         +EsNLjueJiIJC1rEVq0zE/13BA7jVk23+QfPbzExqKTYJ/WYzc8vosfZ2HO9rz0Bn+7m
         DhFGQ5noi7yOv3cVDai17JwdzKTwNQYad4oQI1WcSn+uIwqrb3MugJ7Ir7yoyCYVANbA
         y4hyytkeMg9ICnGJ+rBUmahx9KnIPDNT8v828qHUhGOUm/NnQpy8l2Bks+bnvZ1WhuE2
         qThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mxcyMm7JBj93gJinroz3hDVgZv/8ciunH7mozYt+4hU=;
        b=OPCoOUvN31i/fdGlkqCSFUqdgJaJ1IQ2hdMWSJMgfflObB+8aR2/BRHRwzM46tUWzj
         GtZAVwWM7oGQX5Fnyx0pAvt3qhAh97EQIwEDKSe8PrNxbixu4rP7S1AgRZBy6ujvH07h
         jLRgajtlIqIKl74q2bo8aARV+hTbPDVdJXNmwB86AhEuBsa68VMaNq2v1u0/yrHa5mzX
         CFvoRAhAbH6fBMyTG4SiCqWZnym93oEpVmafnC+KU8S3sDfhLaKiH/IIkoX5vZdQyM7N
         8EFDdL3u9XiCMC5Kvl+BGf3ewWKX+7EEluBeK7/uwA8yzzHoOTgesfDJAwu8zDR32FeU
         BC4A==
X-Gm-Message-State: AOAM532l5eSWiG/Q+bXtyzNbOUB8wZ3I/LqH26GJwX1LAC0+sv3FLM1q
        c9acdU9c2dzCUsMA0AJI/N8TWLiLlwM7IjHcy5o=
X-Google-Smtp-Source: ABdhPJz7cc3iGXzM1A4EhpOI/TjIxNKA6kJ0TSdZnFVoXUCRVeuuDIpK4FkUbai4eyBmo/fl5AMUrqdVgKoFcEYNvAM=
X-Received: by 2002:ac8:2bba:: with SMTP id m55mr4720657qtm.171.1593204829569;
 Fri, 26 Jun 2020 13:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-2-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 13:53:38 -0700
Message-ID: <CAEf4BzZTwQFeoc=bFAFuX4WJCd8cK8L3ohaMrmCv-xy-Tdt8fQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 01/14] bpf: Add resolve_btfids tool to resolve
 BTF IDs in ELF object
To:     Jiri Olsa <jolsa@kernel.org>
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

On Thu, Jun 25, 2020 at 4:48 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The resolve_btfids tool scans elf object for .BTF_ids section
> and resolves its symbols with BTF ID values.
>
> It will be used to during linking time to resolve arrays of BTF
> ID values used in verifier, so these IDs do not need to be
> resolved in runtime.
>
> The expected layout of .BTF_ids section is described in btfid.c
> header. Related kernel changes are coming in following changes.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/bpf/resolve_btfids/Build    |  26 ++
>  tools/bpf/resolve_btfids/Makefile |  76 ++++
>  tools/bpf/resolve_btfids/main.c   | 716 ++++++++++++++++++++++++++++++
>  3 files changed, 818 insertions(+)
>  create mode 100644 tools/bpf/resolve_btfids/Build
>  create mode 100644 tools/bpf/resolve_btfids/Makefile
>  create mode 100644 tools/bpf/resolve_btfids/main.c
>

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
