Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F00281AA9
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 20:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388369AbgJBSMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 14:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBSMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 14:12:07 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2118C0613D0;
        Fri,  2 Oct 2020 11:12:05 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id v60so1778936ybi.10;
        Fri, 02 Oct 2020 11:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KHnjjxWWXP25/T5knyIvyYEhuAgEECCkZrbrZYl8bHQ=;
        b=LXg3vur1SkuiV1SeSjwnxJyAENSplbmbSk8y00eUTJKD4CASBXjjRBRjAwG5TZy6Rh
         /NYPdSqr1mx12y+rit7vtcDObdiUnTyqYGNKA1FzskjYm/M3YRQ8otyAkWtYD7JhOeiR
         NLcC9a4n2tBd40aXtbkXaJHZoNHgNOQicqGMTurBXbgEntSySsjIM0azVb5Z07JEpqWW
         RZ0PkdJKiEYTYS1z/wgwYssIEZmzw4birQ7Qtqf4eO/hJbIhoNEDEv8uMwAy20GMRIIt
         /5eusAw8FTvHm23qxKRWT5bqYY2tfk1rgW4GtTWSSVHvJnaUGBijF/Ah3A8Hgo3uf/N3
         /XSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KHnjjxWWXP25/T5knyIvyYEhuAgEECCkZrbrZYl8bHQ=;
        b=AOy4kxKX7ybZXT9+oKcAvkvYNMHGOdk/1YcF8G4VrC0P4aljQtbOnSMWiJdJ9yDLfZ
         YroKjxdcVYywCYxdTtzy2AEh36c7XM2I0VY0ckeWVMPVizQ6rBKWr4DJMAfUSFDmMjOj
         4UV799e4JM9CiFTebmLgchuOIv9kwyDjbDQ3lrqRhIEMayAVrmQrAoMH84db5LlObp3R
         9+J/vKXIt7w1CBH2VN3umsjLiLSdJ7WVW0+cToa9vlPHkoFlBy9y/7Ub5v1h60pCdci2
         Lr0amTyQTygqMw5Z2AGLp0hiSxdPk/Ae+o2i7UijXT+LEYVwu9g8fQL4pM5dmBStgBR9
         Mp0A==
X-Gm-Message-State: AOAM531O4eY0fwZHLzbMLcDDoq5lOroQy5aLYCUVzn2e8f3psZ81PqKu
        GHyjdraT+x6OAmR4oa9iZG2rWOtEObv8w6FKQ3E=
X-Google-Smtp-Source: ABdhPJxbiCdtLwUtQqsk5Me5RXBkAaTD8zmtlckz399vyY/R6XIbXmxw5GEei38U0KAPEOIp8LewNKS2dN6v5kzqLgE=
X-Received: by 2002:a25:2596:: with SMTP id l144mr4238271ybl.510.1601662325155;
 Fri, 02 Oct 2020 11:12:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201002075750.1978298-1-liuhangbin@gmail.com>
In-Reply-To: <20201002075750.1978298-1-liuhangbin@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 2 Oct 2020 11:11:54 -0700
Message-ID: <CAEf4BzZTBxCKp2JT0yuwBwWX-EuqdSAOM7Duz7ifkRzeYKbKJw@mail.gmail.com>
Subject: Re: [PATCH libbpf] libbpf: check if pin_path was set even map fd exist
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 12:58 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Say a user reuse map fd after creating a map manually and set the
> pin_path, then load the object via libbpf.
>
> In libbpf bpf_object__create_maps(), bpf_object__reuse_map() will
> return 0 if there is no pinned map in map->pin_path. Then after
> checking if map fd exist, we should also check if pin_path was set
> and do bpf_map__pin() instead of continue the loop.
>
> Fix it by creating map if fd not exist and continue checking pin_path
> after that.
>
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c | 75 +++++++++++++++++++++---------------------
>  1 file changed, 37 insertions(+), 38 deletions(-)
>

Please add a selftests that validates the logic you are going to rely on.

> +                                       targ_map = map->init_slots[j];
> +                                       fd = bpf_map__fd(targ_map);
> +                                       err = bpf_map_update_elem(map->fd, &j, &fd, 0);
> +                                       if (err) {
> +                                               err = -errno;
> +                                               pr_warn("map '%s': failed to initialize slot [%d] to map '%s' fd=%d: %d\n",
> +                                                       map->name, j, targ_map->name,
> +                                                       fd, err);

I just noticed that we don't zclose(map->fd) here, can you please fix
it with a separate patch along these changes? Thanks!

> +                                               goto err_out;
> +                                       }
> +                                       pr_debug("map '%s': slot [%d] set to map '%s' fd=%d\n",
> +                                               map->name, j, targ_map->name, fd);
> +                               }
> +                               zfree(&map->init_slots);
> +                               map->init_slots_sz = 0;

Let's move this slot initting logic into a helper function
(init_map_slots() or something like that? doesn't have to use
"bpf_object__" prefix as it is internal static function), that will
simplify overall flow.

> +                       }
> +               } else {
> +                       pr_debug("map '%s': skipping creation (preset fd=%d)\n",
> +                                map->name, map->fd);

to make diff a bit smaller, maybe let's keep the original order, but
do if/else instead of continuing:

if (map->fd >= 0) {
    pr_debug("skipping...");
} else {
   /* do the creation here */
}

/* pinning logic here */

>                 }
>
>                 if (map->pin_path && !map->pinned) {
> --
> 2.25.4
>
