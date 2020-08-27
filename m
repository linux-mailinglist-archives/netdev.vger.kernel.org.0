Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63484253B53
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 03:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgH0BT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 21:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbgH0BTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 21:19:54 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD326C0617A2
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 18:19:52 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id c8so2006792lfh.9
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 18:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qr1VNGCaHREOJfJgh+HpFtWG4t0r62i9OyPJ4zGslYU=;
        b=VZVi7M5HZVbCPyzNn3OhWj/JnfoXRrXJmUVOV9saZPvSfGl9kPM21pf3WZYr+uxDAG
         YOK8e1zHxuHOOPMCFszQuSvkROJHazjQ2GY//CVZQqAyTdQepc3bGPgrLIkA0lNhd3fB
         wTjoBLRxzFX8HE737dC2R2Ln+pUNZfIa3CNuRgMsx+6UmAqbUexVwi8ACRSe1G7/N1oO
         D0aHwVyMSKPCGjao7JOTNQkKJ7K/kKJeWTCuhL5lLVJm4EX7H+hItH9woFIezVhMEgO5
         NC86WhczxtxhAH0KAVkzJfnV3+m3DMG9YXCw47THnPqHeHa8FJXm9XXd2Whby9hjR61p
         hx5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qr1VNGCaHREOJfJgh+HpFtWG4t0r62i9OyPJ4zGslYU=;
        b=mNQGhUVJu/UjffzHvdoKduVUsTYx9GvVr7ifdAibVNYoCtI6VMAMqWD8f/fopzdJLL
         MGcPmuwH8HNxB51NsMsRU8D30EPztvC8tIJ3itx4ylyxsN8+6PLiKJ2h5tsGuInGSQ+O
         sI3WJz1oKiel3z4j9WdMjlEFir8pfaoH3rn5GaWROcvrj4eNpkIUDlyjnpMC4SYsC5nZ
         iJ6lWOURaJJOivPgDiYa09SkZcVd+QgF2CGXgghXmZADTYxYDbXuFR77j/qsV4HfHFC6
         OQl2BCIQeawoxQYSTqNzXqFEEZr4VdFph/6K39vHdQZPYw9fsOCpNpTaIP9UZb2x/Ljc
         1u3A==
X-Gm-Message-State: AOAM531wxcpZ1z8Sa3bZcSvtGfwrIC1fnCjfsH/tYV6dLip+VUlojuwL
        +iil9RfH5fZqrgmmJ18IWEryEWyzvDL78vLcQvoa9A==
X-Google-Smtp-Source: ABdhPJxVpL2PQx+AgSySngZI+BlVg6NFrXTzDO1PwtIfv6Pv3OB5iSbleqV1dzuEG1n5MNZRvyfIOcLrwDdpBo0+1t8=
X-Received: by 2002:a19:4853:: with SMTP id v80mr4964941lfa.125.1598491190269;
 Wed, 26 Aug 2020 18:19:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200821150134.2581465-1-guro@fb.com> <20200821150134.2581465-5-guro@fb.com>
In-Reply-To: <20200821150134.2581465-5-guro@fb.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 26 Aug 2020 18:19:39 -0700
Message-ID: <CALvZod79Z114rHPpq7nvCJ2rkLYiV8EEH-WEMXAPB9yyAH3WEQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 04/30] bpf: refine memcg-based memory
 accounting for arraymap maps
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>, Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 8:11 AM Roman Gushchin <guro@fb.com> wrote:
>
> Include percpu arrays and auxiliary data into the memcg-based memory
> accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> ---
>  kernel/bpf/arraymap.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 8ff419b632a6..9597fecff8da 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -28,12 +28,12 @@ static void bpf_array_free_percpu(struct bpf_array *array)
>
>  static int bpf_array_alloc_percpu(struct bpf_array *array)
>  {
> +       const gfp_t gfp = GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT;
>         void __percpu *ptr;
>         int i;
>
>         for (i = 0; i < array->map.max_entries; i++) {
> -               ptr = __alloc_percpu_gfp(array->elem_size, 8,
> -                                        GFP_USER | __GFP_NOWARN);
> +               ptr = __alloc_percpu_gfp(array->elem_size, 8, gfp);
>                 if (!ptr) {
>                         bpf_array_free_percpu(array);
>                         return -ENOMEM;
> @@ -969,7 +969,7 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
>         struct bpf_array_aux *aux;
>         struct bpf_map *map;
>
> -       aux = kzalloc(sizeof(*aux), GFP_KERNEL);
> +       aux = kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT);
>         if (!aux)
>                 return ERR_PTR(-ENOMEM);
>

There are a couple other allocations in the file. Can you please
comment why those are fine without __GFP_ACCOUNT flag. One seems to be
iterator allocation which should be temporary and fine without
__GFP_ACCOUNT but what about the ones in prog_array_map_poke_track()
and bpf_event_entry_gen()?
