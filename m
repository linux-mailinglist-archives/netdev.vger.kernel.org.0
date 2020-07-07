Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7965121631E
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 02:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgGGAq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 20:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgGGAqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 20:46:24 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4647C061755;
        Mon,  6 Jul 2020 17:46:24 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id r22so36665147qke.13;
        Mon, 06 Jul 2020 17:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2/4R2TDVsfWcU2NIIZ17CBxJ/c2A5FC8g6oh4b2GAr0=;
        b=Pxz+Qg/WOQuAwDhBVfWKWMnmjNNq1c8svFffZPP/8t5dJMri8w1cciLNffZRK0PTpZ
         Fs/Z15E0E96V8oioHp4KESBJ1Vc9+/ZHwjMgJu4RwVmixXJg7kPl2Q5KIKzNo56hfXps
         OxWWi96ItGCUFi/DjofYE2/2bbRPuc0yjxGXS2tIyoO/1tNp3T7FLUGRm9ub9/SyI760
         yAcAhFM+icqSUeK1HeQhYrYbk8s1suykvZCdaB1y1FVValxhk4/Y6LKSyueyEAWY4nvV
         4UavpwRIKlcsq/mePATrpHvnd7n1Ou54hklVLP4tEi2FYXwpyuN8gn1YViQNsctTXpKM
         Nqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2/4R2TDVsfWcU2NIIZ17CBxJ/c2A5FC8g6oh4b2GAr0=;
        b=a61jh9xf7EzYXsbD4U/2Ki3IkhvmmK1n5em2N8UXX+A4ZpPDgLkcq/j6X6Ym9b+9UT
         r3/GZv58dM2+1UGiFPiRqP/cbMD28JRok8ewsPWzLDCHqku3fPbJPjPQ4otIMzjwMxQg
         23lP8A2lkHPaRAiT13sCl2DJL8P7pFvFCSo8/Elgti83SMvEIRPOGLKwSIvorcal0Fr7
         M5TeCOh997tY3YlNxYSGlinbCOv1waltdNvLrADXwvub7zppVUooL8vhHdvqT8SCumgK
         xP952m9BkVDntmwen8TWplFwJKzWbDWjSwrobqiOIOphqieTqtzh9rNU5No1yJhKZnGE
         GsYw==
X-Gm-Message-State: AOAM532yvOVvvRE4dp1N4TUejfm72oR+qFCF24mYJkTvZR0560LJ+Z3k
        CVw6/WxK8z7KqezSLUR49x34Mh7k4W87ORR2blM=
X-Google-Smtp-Source: ABdhPJyHKU5hZAhgIFMiVc5tmzr8RcO7cbu/XH8kLwx1i/TG69+iamdMQ3K+0AzRysN8UqVIOGU0FDEBKrACSLNKLDk=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr51607880qkn.36.1594082783964;
 Mon, 06 Jul 2020 17:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200703095111.3268961-1-jolsa@kernel.org> <20200703095111.3268961-6-jolsa@kernel.org>
In-Reply-To: <20200703095111.3268961-6-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 17:46:12 -0700
Message-ID: <CAEf4BzbsB9zzGeq08vAX5xt+C8VtnPuXry8o6ErWJw2iy+8DwQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 5/9] bpf: Remove btf_id helpers resolving
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

On Fri, Jul 3, 2020 at 2:52 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Now when we moved the helpers btf_id arrays into .BTF_ids section,
> we can remove the code that resolve those IDs in runtime.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/btf.c | 89 +++---------------------------------------------
>  1 file changed, 5 insertions(+), 84 deletions(-)
>

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 4c3007f428b1..71140b73ae3c 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4079,96 +4079,17 @@ int btf_struct_access(struct bpf_verifier_log *log,
>         return -EINVAL;
>  }
>

[...]
