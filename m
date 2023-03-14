Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9456B8D13
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjCNIUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjCNIUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:20:02 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAB76EBD;
        Tue, 14 Mar 2023 01:19:32 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v21so5618551ple.9;
        Tue, 14 Mar 2023 01:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678781972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8uO2pb0aT1NnyTIVfLkUifV1o9o6G5xDatiTfXnW8OM=;
        b=QCEaXsu/OjbQKOKTYOcfuHjvGyeHK9nYJiXxfEUWECrdKCyWwPq0L0FNqeK2N9n0Ae
         EYhweA0WDiVCNFTXO/Wu2yt+0iX/rIGOjay3O9J0T5PfyRcM9Od/wAOnZeMKsTEccNB1
         kBPODFp6Fy5xfTTUhVz+KrAXlcmQwZdHP+yI41uKkVWzMoTXmLqYZGqI2hHTgzIP5M4q
         /RAASByDELA1VcinP8SU4Nnn47z78AHy+V6TX7KQ4FM3dvquhkssjsbw6ytwlZpCQ4zG
         C1OUBzTPW44akruzEoyygVQ3dj7HZ9nnKMlsFkidV34OJTbRtTmlN9/8JVCA/Jd6/d8K
         AasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678781972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8uO2pb0aT1NnyTIVfLkUifV1o9o6G5xDatiTfXnW8OM=;
        b=ZKXqVLN7cSWL7EY19nw0eWkYpnFC32F9FGF4NLn1RszeCN7NBEN1TpyKPFiuho17fB
         2MKmc9cz7HEpSYp31iLNZp88IsWBxW5UA4PrmumkoBJxitH6wjX5WfukVCvZEfQwDGTG
         mcvJSRnUwI3jlrycXEMguks9XEJfuZQpcmtErspSuyMKpKqBUaZeefWPog83cEyERn9C
         naWiie9tx98GC4C/hY4L9sXaSbeejVv+5hFsFhT5KIeaJ0r6caz6celbc18Sxbc+p6+2
         n9joBF5BRhNVeDLTRplLM8vShrgZZ+L65N0+13II2ZnpsEM85MiCzfCD+Jq855dcSMX8
         3SPA==
X-Gm-Message-State: AO0yUKWK45zEmyNuNszJCSAnmzAAUFD9hHBmnM4RoiglJYkgLXdXsT2E
        mgFwnHJByhFljaQryVN+R4Y=
X-Google-Smtp-Source: AK7set/EQKyfrynoi8fEAytH0KIk6OtEN1YHKRHZ+aytWMZMlLInWc+g/9ht3BCMiq8qdv6zEI7rTA==
X-Received: by 2002:a17:902:c407:b0:19e:7490:c93e with SMTP id k7-20020a170902c40700b0019e7490c93emr49670592plk.63.1678781971870;
        Tue, 14 Mar 2023 01:19:31 -0700 (PDT)
Received: from localhost ([2400:8902::f03c:93ff:fe27:642a])
        by smtp.gmail.com with ESMTPSA id w5-20020a170902d3c500b0019fcece6847sm1113921plb.227.2023.03.14.01.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 01:19:30 -0700 (PDT)
Date:   Tue, 14 Mar 2023 08:19:18 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 4/7] mm, pagemap: remove SLOB and SLQB from comments and
 documentation
Message-ID: <ZBAuBj0hgLK7Iqgy@localhost>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-5-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-5-vbabka@suse.cz>
X-Spam-Status: No, score=3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
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

SLUB does not overload _mapcount.

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

I think this comment could be just saying that PG_buddy is only set on
head page, not saying

_refcount is set to -1 on head page (is it even correct?)

>  	 */
>  	if (PageBuddy(page))
>  		u |= 1 << KPF_BUDDY;
> -- 
> 2.39.2
> 
