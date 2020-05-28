Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951561E580F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgE1HBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgE1HBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 03:01:47 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8FFC05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 00:01:47 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id s1so2150766qkf.9
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 00:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SCpdR/0iQOdkaqJqwHJWaDAorYiGQM1kRLAZVqCqaVk=;
        b=nxa0qQwCdwYKRDVZHBBKyY1IGmSDaFvbPR7A6uZfabVMPvg03GSdV5RgRng1zc0HDj
         rvO+s+EAFaQuFhJ4CLsHXAP46N6MHQHLCpMQtDkp13q92WwfXoqHbJN0bGQZotrR/0Y5
         1MvRpTJGhZ3AozNWYeQPW8jXywcLkKKwDB88jbJMAObWHUuZnb3MtIty/Sx+3nSnIbz9
         tsBPlAHMp1p000HxN64J9QPhTI4Opg2YsSHzeHZbDv1hE0urpW6tGd/8P9l/QSZBKU8F
         7eHB53BjwhvrY5MqrzihVJbZbrsB2cp16NVaDu0X6+szCPQEjqZUsKQYdNH3TgkgAnAr
         m4Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SCpdR/0iQOdkaqJqwHJWaDAorYiGQM1kRLAZVqCqaVk=;
        b=mvWp0XZ5Ikm5HQ/Y88bme/JJai2qbdB2zCP1YqM2HhuB+MVoUbE3cl300lbG9FDGot
         n1NyocKW/gSSZnSD2wd010rBnDjqFevzzCh9/dxP4k6H4gX/oATKqID6eII2Im4uHhKY
         LK9TALDhm2fSM57sg5JhXqCSHpecwvsh5dtL004Fg6VnRuhmAPjidIElgxaqF7hpkoQl
         78ofj1uNO3+IluzPP6wq+aiUx966Z5aYPgED/gYvMqOBEjyEKpAgrWzOH3xUEnZ3YrKU
         NES16WpW/8PCHNJKb3VG3TGleeM+w6f/7PD+KDkhmBYT9vh+L+u2862yjhbsMfokdwlx
         EcUQ==
X-Gm-Message-State: AOAM530r/kAX0zK5piuZcQ4BWIUZWRnU7TG/1scXTsmTEJDcm/aVmN8y
        pPMH2FKh2KhXE9xz/Gs6NQEO8DF6mCCuEBqeQsY=
X-Google-Smtp-Source: ABdhPJyMFDE9QARLH2VooDyYNL9CL9spQ4P6kO1sBwJRs8caj+pBwzxHBqbX0EKlAvhu8rRASk3RCrYojxq/8WTFnYQ=
X-Received: by 2002:a37:6508:: with SMTP id z8mr1426940qkb.39.1590649306342;
 Thu, 28 May 2020 00:01:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200528001423.58575-1-dsahern@kernel.org> <20200528001423.58575-2-dsahern@kernel.org>
In-Reply-To: <20200528001423.58575-2-dsahern@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 May 2020 00:01:35 -0700
Message-ID: <CAEf4BzZPbndT3daoSt_z6cH=CPJSdH5yMhpR2gDbmeQUacWAyg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/5] devmap: Formalize map value as a named struct
To:     David Ahern <dsahern@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 5:15 PM David Ahern <dsahern@kernel.org> wrote:
>
> From: David Ahern <dsahern@gmail.com>
>
> Add 'struct devmap_val' to the bpf uapi to formalize the
> expected values that can be passed in for a DEVMAP.
> Update devmap code to use the struct.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  include/uapi/linux/bpf.h       |  5 ++++
>  kernel/bpf/devmap.c            | 43 ++++++++++++++++++++--------------
>  tools/include/uapi/linux/bpf.h |  5 ++++
>  3 files changed, 35 insertions(+), 18 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 54b93f8b49b8..d27302ecaa9c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3625,6 +3625,11 @@ struct xdp_md {
>         __u32 rx_queue_index;  /* rxq->queue_index  */
>  };
>
> +/* DEVMAP values */
> +struct devmap_val {
> +       __u32 ifindex;   /* device index */
> +};
> +

can DEVMAP be used outside of BPF ecosystem? If not, shouldn't this be
`struct bpf_devmap_val`, to be consistent with the rest of the type
names?

>  enum sk_action {
>         SK_DROP = 0,
>         SK_PASS,
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index a51d9fb7a359..069a50113e26 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -66,6 +66,7 @@ struct bpf_dtab_netdev {
>         struct bpf_dtab *dtab;
>         struct rcu_head rcu;
>         unsigned int idx;
> +       struct devmap_val val;
>  };
>
>  struct bpf_dtab {
> @@ -110,7 +111,8 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
>
>         /* check sanity of attributes */
>         if (attr->max_entries == 0 || attr->key_size != 4 ||
> -           attr->value_size != 4 || attr->map_flags & ~DEV_CREATE_FLAG_MASK)
> +           attr->value_size > sizeof(struct devmap_val) ||

So is 0, 1, 2, 3, and after next patch 5, 6, and 7 all allowed as
well? Isn't that a bit too permissive?

> +           attr->map_flags & ~DEV_CREATE_FLAG_MASK)
>                 return -EINVAL;
>

[...]
