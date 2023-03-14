Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61D26BA245
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 23:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjCNWSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 18:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjCNWS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 18:18:26 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9A8279BF;
        Tue, 14 Mar 2023 15:17:43 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id x22so5901612wmj.3;
        Tue, 14 Mar 2023 15:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678832188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0cgXw1zWR3UzIeNQHSkd/Pe/JYZucLUkg0+siqDji1Q=;
        b=WiWabfdsc40Hw03sHacABR/DpeHPE1ytk52ltiIHJyYU96rC0iS1lraEKpFNPMr7fC
         t88zt7gAQUBBIRqrgzPkQWQDI8IBIwbBSQ44S9GXEjINbumyhcaty1H8Wl8mk8TP7vah
         R+sSYxV3pSFKpraUvvKNT26Tl4bm9IX1cxQTO0YuTtRAf1JyKECbjwfkxjSm3C79t2zu
         WimroFz4zBdQaqQbKrHUb+k9u1UDe/t+bGf+sTOFdiO/SY1n3N2Yrx3e1ZAduqS48kT2
         rVHJ3JqaH5emYPmU4Xh0N/DVVXcX1nJMZW+nmKAVSR8mX825oNgoQNZkzjKn0xyWZeQC
         H2Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678832188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0cgXw1zWR3UzIeNQHSkd/Pe/JYZucLUkg0+siqDji1Q=;
        b=Ct1PlmvaVcbQoeH9hfGxx3WtOqbmA98mfvhdjtVZJgFxqMIhL0WoDVPrGTJVIrBjHC
         nDCGFHrt9R1F0uPSlDc8KV+AeI77VNtg5zVR4Hi15nEwJ1VbpjfJxGczoWzyjoIykye/
         ezFZLyhcW74mBDTuzOCDQbF46kKtQ7frSgqYnkQI795BKlw7Zo6CDNeDE1fWjpTkIV1N
         yzr2au/BF9Fttzhn+zrrk2c02ta3d9Os1Fs1n9dWka1aZ0GdygDZKxO4Fxw/iGzbLzSk
         rG8sBZ+1YKwEtWTC3RQf9FV+Zn0q6/syeGhRtg2ZJbp7QM8zCY0QKjVwiV1SFbJXzpXX
         aBhQ==
X-Gm-Message-State: AO0yUKXc7RD7fxrQBCEwCBBr2sPkPC81qEUilArgOjYH42IkbpRgrcHa
        mb03ZJ4ki5YpCAIG2IRJTy0=
X-Google-Smtp-Source: AK7set/LqyA4KOXjYW3gB61Tg1NOLoBdeKaWngQqOyAVUSHmnZgHB0VC+IljqkqXyulD+UybQrzJww==
X-Received: by 2002:a05:600c:1546:b0:3ed:22f2:554c with SMTP id f6-20020a05600c154600b003ed22f2554cmr8549449wmg.29.1678832188560;
        Tue, 14 Mar 2023 15:16:28 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c22c400b003e00c453447sm3977442wmg.48.2023.03.14.15.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 15:16:27 -0700 (PDT)
Date:   Tue, 14 Mar 2023 22:16:26 +0000
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 4/7] mm, pagemap: remove SLOB and SLQB from comments and
 documentation
Message-ID: <a901f00e-99df-4fed-8117-e3735ec7df59@lucifer.local>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-5-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-5-vbabka@suse.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 11:32:06AM +0100, Vlastimil Babka wrote:
> SLOB has been removed and SLQB never merged, so remove their mentions
> from comments and documentation of pagemap.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  Documentation/admin-guide/mm/pagemap.rst | 6 +++---
>  fs/proc/page.c                           | 5 ++---
>  2 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
> index b5f970dc91e7..bb4aa897a773 100644
> --- a/Documentation/admin-guide/mm/pagemap.rst
> +++ b/Documentation/admin-guide/mm/pagemap.rst
> @@ -91,9 +91,9 @@ Short descriptions to the page flags
>     The page is being locked for exclusive access, e.g. by undergoing read/write
>     IO.
>  7 - SLAB
> -   The page is managed by the SLAB/SLOB/SLUB/SLQB kernel memory allocator.
> -   When compound page is used, SLUB/SLQB will only set this flag on the head
> -   page; SLOB will not flag it at all.
> +   The page is managed by the SLAB/SLUB kernel memory allocator.
> +   When compound page is used, either will only set this flag on the head
> +   page..

I mean, perhaps the nittiest of nits but probably that '..' is unintended.

>  10 - BUDDY
>      A free memory block managed by the buddy system allocator.
>      The buddy system organizes free memory in blocks of various orders.
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 6249c347809a..1356aeffd8dc 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -125,7 +125,7 @@ u64 stable_page_flags(struct page *page)
>  	/*
>  	 * pseudo flags for the well known (anonymous) memory mapped pages
>  	 *
> -	 * Note that page->_mapcount is overloaded in SLOB/SLUB/SLQB, so the
> +	 * Note that page->_mapcount is overloaded in SLAB/SLUB, so the
>  	 * simple test in page_mapped() is not enough.
>  	 */
>  	if (!PageSlab(page) && page_mapped(page))
> @@ -166,8 +166,7 @@ u64 stable_page_flags(struct page *page)
>
>  	/*
>  	 * Caveats on high order pages: page->_refcount will only be set
> -	 * -1 on the head page; SLUB/SLQB do the same for PG_slab;
> -	 * SLOB won't set PG_slab at all on compound pages.
> +	 * -1 on the head page; SLAB/SLUB do the same for PG_slab;

Nice catch on the redundant reference to the mysterous SLQB (+ above) :)

>  	 */
>  	if (PageBuddy(page))
>  		u |= 1 << KPF_BUDDY;
> --
> 2.39.2
>

Otherwise looks good to me,

Acked-by: Lorenzo Stoakes <lstoakes@gmail.com>
