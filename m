Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E9C244D58
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 19:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgHNRL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 13:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgHNRLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 13:11:55 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C37C061384;
        Fri, 14 Aug 2020 10:11:54 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x2so5543837ybf.12;
        Fri, 14 Aug 2020 10:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mglcVhzuzbD5iqytmy0ojvWdCDVMQ7Jg6r35q9ohuQg=;
        b=QERHGCA0vwz4s3O8jukMthQqaizlhaP4rs13uvD0cKQsBVG+/f5MilgpPL1Gf+z8dg
         UPMcwVWaNpUPCbxnEgZrMCVo402/clnyZcMoZA3vNThOOka9RVsbJziSruRvVF3/Uz2f
         adQyDFRPzGmErSwl0v6OSCioSKC8igEzwUygzZR8T4Nk/pPPrO8ap7DWSJUB25kWZLS5
         vQJ1WCSeeQryrynpttpy6VEuyGJ9PITfaMMWiiQu39vuA8u7Ha0YxISOyQH2lzzhzFjB
         hYiA8H6tfHiEcyPekOrMX+/xJg/HbS9zuagXGPuqvCvsfLOv/ErLidXhUt/iqZz+BsD3
         5/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mglcVhzuzbD5iqytmy0ojvWdCDVMQ7Jg6r35q9ohuQg=;
        b=CkFr9CWx7nfSbg29YqaoEyeXhFiNl1PErSOr5hsBPHLGmVs/AZ/xoqlXhZY4+fDyVs
         j25ejdbm+L3JEDekRMz+rzd/DfGo1vSE2LDtsw80EKIo5RNM24q656MX7rJRDmnNYqMH
         6JhI5fGkVcfhe3rw6FJBPiwjdSz0DZLAdeFjif0EQbpWZitjMGSczUZ7nWQ0BPvnR4RU
         LzL2wB1Sp4FzD+wLtygznoJzHY3t6/5jTMavTdfJJgdR5vCrYvvOOGB0V4uKlnNw8LMB
         ei/MCjlFv/a/mybaYz5KHCM9N4BF+gQsNhNLQfhtn7ubDzzmuBJRWJUfwcyQoSs4TLBT
         KIYg==
X-Gm-Message-State: AOAM532GRMP7/crHAwVptnJBtqHKzMorhf7yyTVwTKANRuGc2F6xpdpn
        EOlFyfTHVnRK7EpxgM1diAPz24i5/u1MwZUdYr4=
X-Google-Smtp-Source: ABdhPJzZBf60mp6s8Y3MItoqoiwvgalrmw45dcofiQIfr+7AzgE/kEueXkevQYpFU4EzR77VC2C69/DvwzYto4uY4r8=
X-Received: by 2002:a25:bc50:: with SMTP id d16mr4679058ybk.230.1597425114113;
 Fri, 14 Aug 2020 10:11:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200814091615.21821-1-linmiaohe@huawei.com>
In-Reply-To: <20200814091615.21821-1-linmiaohe@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Aug 2020 10:11:43 -0700
Message-ID: <CAEf4BzYyEurfj8SoXBcG1EY1eOS2yHgpZteON2Ff1E+rPVrh9g@mail.gmail.com>
Subject: Re: [PATCH] bpf: Convert to use the preferred fallthrough macro
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 14, 2020 at 2:58 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>
> Convert the uses of fallthrough comments to fallthrough macro.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  kernel/bpf/cgroup.c   | 2 +-
>  kernel/bpf/cpumap.c   | 2 +-
>  kernel/bpf/syscall.c  | 2 +-
>  kernel/bpf/verifier.c | 6 +++---
>  4 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 83ff127ef7ae..e21de4f1754c 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1794,7 +1794,7 @@ static bool cg_sockopt_is_valid_access(int off, int size,
>                         return prog->expected_attach_type ==
>                                 BPF_CGROUP_GETSOCKOPT;
>                 case offsetof(struct bpf_sockopt, optname):
> -                       /* fallthrough */
> +                       fallthrough;

this fallthrough is not event necessary, let's drop it instead?

>                 case offsetof(struct bpf_sockopt, level):
>                         if (size != size_default)
>                                 return false;

[...]
