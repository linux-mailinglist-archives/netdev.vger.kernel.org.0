Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90C31EB5A4
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 08:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgFBGI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 02:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgFBGI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 02:08:58 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D220C061A0E;
        Mon,  1 Jun 2020 23:08:56 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f5so1805639wmh.2;
        Mon, 01 Jun 2020 23:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NDGYSbP7uksg9+a4r1iJamlh67Acsz3aGJVeqfoyDV0=;
        b=o7YovVxEvNBhAdPPNBFaK+JmkxuBB4/xKKIT1qcpOELnjJ/YTf7DUjI3RFuu+qY2+X
         NITAv3fgVQXIKRMRHSMVeyO6ajyBkf2OOQLpHCRN9pQGs8X+gqhCjaZSxu29v1Tami3u
         MM7CY2e2hyRLnvqiV6gBifOfQAhqlSALfor+ITJr3qIPIcAJ7na+qMogYTp3rg4fgxwB
         lfte6gUwulmhd+4FLeZy0Oj1mKnQK73EdD8hRAsDdjg9EDhwHmAt8CLUoiuJ8XJ3SFQl
         f9D2jZX7IXB5zKvIj9CViLa3mJt4xvarJOhKrnqWawXJzMKY6rFXl91VnuA7v7ongqf9
         SYYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NDGYSbP7uksg9+a4r1iJamlh67Acsz3aGJVeqfoyDV0=;
        b=krwVROoxwCV9DpKHbzpHOGVHULNHRF8xnS7Qp9A4InnAZPYFRABLx2qCCsLwYNgyoc
         FndfbL1L5IR/0Ruz6WydnG40JoVDE3Rj2IT4SNvq6cOSz4awGA1968bZMDHdO8mZooPR
         pizBs56aCzfq6CbEOq/K+b0nme4HAqsHGX0KjQcpvYnUmnJlOVnSEObNMF2oJUJZ/oPj
         9E+5ziNxILhJaCBhqsHE8EpIGO9+ekv10KReCMazfRPC8FaCERbSO4soE43z+h2QrRo0
         0I9N2J+EtgKNOMGrZf2MJUxrqXtJeFlJFW1qVpQGhgSqEEdOa1UWEaEoQWm02IuWwWgE
         S9fw==
X-Gm-Message-State: AOAM533LMwqWBoDWlBLgyAnGKqpDxp8wflOA/zEkGLe5b45ARMoTc54o
        2s7LtbTK4qK3cNyoSghwnZHUPZV4KODjgc7QAP8=
X-Google-Smtp-Source: ABdhPJxbMW9gOsV6GMtEx1bIdBTWOTc6p9HlxeOtGMzSdOLfpQydLKKu4tsXYDL8918ULpDLfXZBeSLCzLSyoGzPpk8=
X-Received: by 2002:a7b:cbd9:: with SMTP id n25mr2533226wmi.30.1591078135229;
 Mon, 01 Jun 2020 23:08:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200601052633.853874-1-jhubbard@nvidia.com> <20200601052633.853874-3-jhubbard@nvidia.com>
In-Reply-To: <20200601052633.853874-3-jhubbard@nvidia.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Tue, 2 Jun 2020 08:08:44 +0200
Message-ID: <CAM9Jb+hNSWp-TaQQFg4bs5uR8rYk_POZPT23RYy5V_B9-aOcYg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] vhost: convert get_user_pages() --> pin_user_pages()
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This code was using get_user_pages*(), in approximately a "Case 5"
> scenario (accessing the data within a page), using the categorization
> from [1]. That means that it's time to convert the get_user_pages*() +
> put_page() calls to pin_user_pages*() + unpin_user_pages() calls.
>
> There is some helpful background in [2]: basically, this is a small
> part of fixing a long-standing disconnect between pinning pages, and
> file systems' use of those pages.
>
> [1] Documentation/core-api/pin_user_pages.rst
>
> [2] "Explicit pinning of user-space pages":
>     https://lwn.net/Articles/807108/
>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  drivers/vhost/vhost.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 21a59b598ed8..596132a96cd5 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1762,15 +1762,14 @@ static int set_bit_to_user(int nr, void __user *addr)
>         int bit = nr + (log % PAGE_SIZE) * 8;
>         int r;
>
> -       r = get_user_pages_fast(log, 1, FOLL_WRITE, &page);
> +       r = pin_user_pages_fast(log, 1, FOLL_WRITE, &page);
>         if (r < 0)
>                 return r;
>         BUG_ON(r != 1);
>         base = kmap_atomic(page);
>         set_bit(bit, base);
>         kunmap_atomic(base);
> -       set_page_dirty_lock(page);
> -       put_page(page);
> +       unpin_user_pages_dirty_lock(&page, 1, true);
>         return 0;
>  }

Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
