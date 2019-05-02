Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E5711A71
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 15:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfEBNqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 09:46:17 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46575 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEBNqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 09:46:16 -0400
Received: by mail-io1-f67.google.com with SMTP id m14so2133728ion.13;
        Thu, 02 May 2019 06:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EEWh+28qpDYOvlHtdbYrMDDj4copt8ISMEsDc2LV22A=;
        b=RHwJWu35pNPSUgXswLwopzg/j8te7VzQvTYZt3AAF8hsRrykfRW9+VciZTO0AcjrRH
         ygx7PVb81NAvnVdDZr1eiYWhu0HoRRftBQeoCpsMHK4lQ5r1bWss5GAxxNyhoDHxDX9G
         WI3bIhbCfgudLvyNW0BX7n/iCILaSZlwpBLGi1mQHcZBoMlf2JIAXOTzBUuX2Fc0ALrQ
         o36f2izxKNN9hraLPjOdpumpGowAHgWWrYLxa80rF0lyEdlMK4YIV56jBe84hcf/8kKg
         Wv+wHLB9isf2XT1yQpjVlXKA3WDCgo8wj/0OMN4wKlEtQteYPEL4Bf5sd+A4NPn/Um0k
         unTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EEWh+28qpDYOvlHtdbYrMDDj4copt8ISMEsDc2LV22A=;
        b=IBkvVbVgy+bFlvs4SxiPRaArCN91H4L844YOB/PLUwe92QicyyIXf9nSSX+j+vA44E
         buU7QxscoPumwpGp3rIEkxW9G98d5I9pD6DsOrcEeVOHJHsU/e9peJUiTzSeU1HRd/dG
         GogGRUW8d+YhY/Nk/ShOqLofT4k2rOnomY6iJIeP5O5kWn5NnsBhDqsZXkRtI3CcWtge
         XWF2xXuKYmr9v3TV6H3TGkksYK5WHDpWT5riXhoEYwps9Jk6k/EXXQu+kkacflbOEZaa
         qeLUt6USFd3IKRK1p72NR2gtgjkZIw+fp0F1f9yXTWE9K5sqfLU31DYm1XE0ZYIa9gP4
         oR+A==
X-Gm-Message-State: APjAAAUXWxLT59rQrmacFvpjGBhwBWKOa9OXNwwMIGOyj2mrQSlaX6yL
        XW01h2iqtZLD+rDN7Ug+N9Zox82udLItzxP9jRJdFJ7/kOw=
X-Google-Smtp-Source: APXvYqwT2KaZZ1hB1kMRANZiYqS0sZ9uCQWxyDoNnpzy05ndtra8GiSaLpSdcAvTPqSbZnhPtewiNSuQI/vTrNVand0=
X-Received: by 2002:a5d:9b90:: with SMTP id r16mr2593452iom.217.1556804775838;
 Thu, 02 May 2019 06:46:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190501204032.26380-1-hch@lst.de>
In-Reply-To: <20190501204032.26380-1-hch@lst.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 2 May 2019 15:46:20 +0200
Message-ID: <CAOi1vP_kG_tshGbkb6WQGYECswYJ+BAmsBm6t9e-KHu1WSszFA@mail.gmail.com>
Subject: Re: [PATCH] ceph: remove ceph_get_direct_page_vector
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 1, 2019 at 10:43 PM Christoph Hellwig <hch@lst.de> wrote:
>
> This function is entirely unused.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/ceph/libceph.h |  4 ----
>  net/ceph/pagevec.c           | 33 ---------------------------------
>  2 files changed, 37 deletions(-)
>
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index 337d5049ff93..a3cddf5f0e60 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -299,10 +299,6 @@ int ceph_wait_for_latest_osdmap(struct ceph_client *client,
>
>  /* pagevec.c */
>  extern void ceph_release_page_vector(struct page **pages, int num_pages);
> -
> -extern struct page **ceph_get_direct_page_vector(const void __user *data,
> -                                                int num_pages,
> -                                                bool write_page);
>  extern void ceph_put_page_vector(struct page **pages, int num_pages,
>                                  bool dirty);
>  extern struct page **ceph_alloc_page_vector(int num_pages, gfp_t flags);
> diff --git a/net/ceph/pagevec.c b/net/ceph/pagevec.c
> index d3736f5bffec..64305e7056a1 100644
> --- a/net/ceph/pagevec.c
> +++ b/net/ceph/pagevec.c
> @@ -10,39 +10,6 @@
>
>  #include <linux/ceph/libceph.h>
>
> -/*
> - * build a vector of user pages
> - */
> -struct page **ceph_get_direct_page_vector(const void __user *data,
> -                                         int num_pages, bool write_page)
> -{
> -       struct page **pages;
> -       int got = 0;
> -       int rc = 0;
> -
> -       pages = kmalloc_array(num_pages, sizeof(*pages), GFP_NOFS);
> -       if (!pages)
> -               return ERR_PTR(-ENOMEM);
> -
> -       while (got < num_pages) {
> -               rc = get_user_pages_fast(
> -                   (unsigned long)data + ((unsigned long)got * PAGE_SIZE),
> -                   num_pages - got, write_page, pages + got);
> -               if (rc < 0)
> -                       break;
> -               BUG_ON(rc == 0);
> -               got += rc;
> -       }
> -       if (rc < 0)
> -               goto fail;
> -       return pages;
> -
> -fail:
> -       ceph_put_page_vector(pages, got, false);
> -       return ERR_PTR(rc);
> -}
> -EXPORT_SYMBOL(ceph_get_direct_page_vector);
> -
>  void ceph_put_page_vector(struct page **pages, int num_pages, bool dirty)
>  {
>         int i;

Applied.

Thanks,

                Ilya
