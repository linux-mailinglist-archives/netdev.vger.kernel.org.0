Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3A215C8EF
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgBMQzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 11:55:42 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40175 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727705AbgBMQzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 11:55:42 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so7558551wmi.5
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 08:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cDryonWZY2uim0kUcOdklU9kJxiT6lt/ZLusCbe9Vu0=;
        b=DHGr2qvezyDarMsNQHvPJBLE9+ZuhDdSi66fIAK7hnupVSI08lkphHNhKwGXlGtDng
         ZIW3yijKM8BA11jRT3oIQouP9KLJcP/rzsa89VOqFsZVxrYb3j8kIKKjRfAe+1SzgTox
         yRHxT/V7m1/15NG+O2Rf3fJWH16LNIEaRZVQW7OCHTet9wCxvtJcCU5bFdo9OIdZRD2D
         pqanPcXYCSOH8XMF8mkKtQvqY8gNTBLTXQRNwJWQj34fZZYu3CaQDxcxbj9V82Gxw+dw
         wB6AGrsPZJ5o0VNtvR12DotsuoKxo5P7ATxQnTPlxpRD6NdaUvT/PssRXGc/ehVdCEQr
         rA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cDryonWZY2uim0kUcOdklU9kJxiT6lt/ZLusCbe9Vu0=;
        b=pAxMbvz2NTni8BlpAZrNXqCXrE4httXoIYPS/kTYmrCen6HXG8Jz7QexTLpXEn2QiC
         HV9GPz8LqX8khZINvRLvRHhywyxJ8zEP/UhD4d7u33RI6Zyby4j0jXZJfi+0csyrMSNc
         ZwT3jA9pktVRLn32mNu4wv4kimsB1MnYNCGIA1Luhw7ctr6RQGgyT0decjiNtUj0SvJ7
         3EE9hMOlN2d7ad1tscUFbrfeRskgrIx9D0iaPz7OLjXn9Re76eTF3vGE2fKq5Ypak6lJ
         ieZt4qAy/31g6YXaCoCUOoiwCiNFbJwo5IYDnKhA4LRCiix1Jqy7tBYdRtgwYliplxLb
         DT1g==
X-Gm-Message-State: APjAAAU4WjPmL8POiTNDZbhrF3oq11rnbINaRtutSGejwRqHZPXb9rlc
        FpMJCqo2zgHKtOfK/y1iaT47ROaT23pW1wPntFdDpQ==
X-Google-Smtp-Source: APXvYqwimIhKs4gIgr9ijKaFK6snXU78BQ5LHnIoORhGIghYDeqh0awPtRevCb3gABPCKCXE2inQMFbtysaRKXpqTMY=
X-Received: by 2002:a1c:4857:: with SMTP id v84mr6719784wma.8.1581612939441;
 Thu, 13 Feb 2020 08:55:39 -0800 (PST)
MIME-Version: 1.0
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com> <20200212184115.127c17c6b0f9dab6fcae56c2@linux-foundation.org>
In-Reply-To: <20200212184115.127c17c6b0f9dab6fcae56c2@linux-foundation.org>
From:   Arjun Roy <arjunroy@google.com>
Date:   Thu, 13 Feb 2020 08:55:28 -0800
Message-ID: <CAOFY-A2NitFW72XKfGuw-mZ6zWvTqxTpQYHLKr5K02v5aypbAA@mail.gmail.com>
Subject: Re: [PATCH resend mm,net-next 1/3] mm: Refactor insert_page to
 prepare for batched-lock insert.
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The addition of page_has_type() looks good to me, thanks!

-Arjun


On Wed, Feb 12, 2020 at 6:41 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon, 27 Jan 2020 18:59:56 -0800 Arjun Roy <arjunroy.kdev@gmail.com> wrote:
>
> > Add helper methods for vm_insert_page()/insert_page() to prepare for
> > vm_insert_pages(), which batch-inserts pages to reduce spinlock
> > operations when inserting multiple consecutive pages into the user
> > page table.
> >
> > The intention of this patch-set is to reduce atomic ops for
> > tcp zerocopy receives, which normally hits the same spinlock multiple
> > times consecutively.
>
> I tweaked this a bit for the addition of page_has_type() to
> insert_page().  Please check.
>
>
>
> From: Arjun Roy <arjunroy.kdev@gmail.com>
> Subject: mm: Refactor insert_page to prepare for batched-lock insert.
>
> From: Arjun Roy <arjunroy@google.com>
>
> Add helper methods for vm_insert_page()/insert_page() to prepare for
> vm_insert_pages(), which batch-inserts pages to reduce spinlock
> operations when inserting multiple consecutive pages into the user
> page table.
>
> The intention of this patch-set is to reduce atomic ops for
> tcp zerocopy receives, which normally hits the same spinlock multiple
> times consecutively.
>
> Link: http://lkml.kernel.org/r/20200128025958.43490-1-arjunroy.kdev@gmail.com
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/memory.c |   39 ++++++++++++++++++++++++---------------
>  1 file changed, 24 insertions(+), 15 deletions(-)
>
> --- a/mm/memory.c~mm-refactor-insert_page-to-prepare-for-batched-lock-insert
> +++ a/mm/memory.c
> @@ -1430,6 +1430,27 @@ pte_t *__get_locked_pte(struct mm_struct
>         return pte_alloc_map_lock(mm, pmd, addr, ptl);
>  }
>
> +static int validate_page_before_insert(struct page *page)
> +{
> +       if (PageAnon(page) || PageSlab(page) || page_has_type(page))
> +               return -EINVAL;
> +       flush_dcache_page(page);
> +       return 0;
> +}
> +
> +static int insert_page_into_pte_locked(struct mm_struct *mm, pte_t *pte,
> +                       unsigned long addr, struct page *page, pgprot_t prot)
> +{
> +       if (!pte_none(*pte))
> +               return -EBUSY;
> +       /* Ok, finally just insert the thing.. */
> +       get_page(page);
> +       inc_mm_counter_fast(mm, mm_counter_file(page));
> +       page_add_file_rmap(page, false);
> +       set_pte_at(mm, addr, pte, mk_pte(page, prot));
> +       return 0;
> +}
> +
>  /*
>   * This is the old fallback for page remapping.
>   *
> @@ -1445,26 +1466,14 @@ static int insert_page(struct vm_area_st
>         pte_t *pte;
>         spinlock_t *ptl;
>
> -       retval = -EINVAL;
> -       if (PageAnon(page) || PageSlab(page) || page_has_type(page))
> +       retval = validate_page_before_insert(page);
> +       if (retval)
>                 goto out;
>         retval = -ENOMEM;
> -       flush_dcache_page(page);
>         pte = get_locked_pte(mm, addr, &ptl);
>         if (!pte)
>                 goto out;
> -       retval = -EBUSY;
> -       if (!pte_none(*pte))
> -               goto out_unlock;
> -
> -       /* Ok, finally just insert the thing.. */
> -       get_page(page);
> -       inc_mm_counter_fast(mm, mm_counter_file(page));
> -       page_add_file_rmap(page, false);
> -       set_pte_at(mm, addr, pte, mk_pte(page, prot));
> -
> -       retval = 0;
> -out_unlock:
> +       retval = insert_page_into_pte_locked(mm, pte, addr, page, prot);
>         pte_unmap_unlock(pte, ptl);
>  out:
>         return retval;
> _
>
