Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932466B64B0
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 11:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjCLKBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 06:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjCLKA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 06:00:58 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594E73757D;
        Sun, 12 Mar 2023 03:00:04 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id l12so485984wrm.10;
        Sun, 12 Mar 2023 03:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678615160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F/eUf+U6VJsU72zpkAHAR/G+9W+06JthKevGiP5LF44=;
        b=mQjD7qOx7ex1pHGWyQeUg0YqTmCHy1WTTDhdvfcblgD/O1BEmOllQOhb+WykNhIjZJ
         8fABaAKSlHCX8WjL7ecmWEiu0afJm49LiQgrU5P3uvtEvjGEpPvoO7j8dghtH9yB888L
         HCvBJoyz+jBZK/OH4h0rkBdLpQgxskFHjLxJKzZvU/LYcoYJYRGamZUo6R8rp+kaw/P5
         9Sr9zUgOhCFMx8UDPSwTM1pnHDgf60/Et0uMd8VCzatob3+VhJvJcfqal/9xtFZQM0C+
         ptVF/C9NDptX9W5XaKpi5Qjssag5XtJADn60tuPiS9xen4hjcQy9fJnpldX5GgdwflXP
         3vAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678615160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/eUf+U6VJsU72zpkAHAR/G+9W+06JthKevGiP5LF44=;
        b=VlH8iKieHIF7LUQvK/CGxgCg9ArV6GYNL8PHGyuxkQ1advI5CNuy8BFubSamajuhca
         Iem7H13gKp+TqeL5CIwsv7KUlf3HLodLO6eFsvleuPkazkWe0WuoruKeS5EppxeNS04i
         h3WMzRlPt8f9/kw4+c921B1hKtf77nYuNvBINPi1Surino5WqnKIQ5Hp8nDkMpEjYpS7
         g1XKNQxZ9sCV7bB0OJMoi0s/25OoTyDCgNMeHO9xzpbFSku3B5C5/nE+rmTKUimNnqDH
         sqBSxHZYs1qvM6JKhfNJNZI6CSZDMVpkoyAuflcrxom1jtkU5RCqJiBTsslx793AGaQt
         nH5A==
X-Gm-Message-State: AO0yUKXiUXe47csHxy1Gde/KpVseUZYFB/c8l7aatigt4sXc+ADc69xH
        /dlJy7jfUObtqNaNYExcccEIdyCIxcVvcQ==
X-Google-Smtp-Source: AK7set8l8/lXKE5CTcpAn0qTvK8Gp5PAdyHglSBceQJL8ZQLKfrUOQl3w3Kww9Ks9mqp+kEuNQe/1Q==
X-Received: by 2002:a05:6000:181:b0:2ce:aa2e:b864 with SMTP id p1-20020a056000018100b002ceaa2eb864mr1211615wrx.27.1678615159553;
        Sun, 12 Mar 2023 01:59:19 -0800 (PST)
Received: from kernel.org ([46.120.23.99])
        by smtp.gmail.com with ESMTPSA id z10-20020a5d654a000000b002ceaa0e6aa5sm1753461wrv.73.2023.03.12.01.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 01:59:19 -0800 (PST)
Date:   Sun, 12 Mar 2023 11:59:15 +0200
From:   Mike Rapoport <mike.rapoport@gmail.com>
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
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 7/7] mm/slab: document kfree() as allowed for
 kmem_cache_alloc() objects
Message-ID: <ZA2ic9JYXGVzps1+@kernel.org>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-8-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310103210.22372-8-vbabka@suse.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 11:32:09AM +0100, Vlastimil Babka wrote:
> This will make it easier to free objects in situations when they can
> come from either kmalloc() or kmem_cache_alloc(), and also allow
> kfree_rcu() for freeing objects from kmem_cache_alloc().
> 
> For the SLAB and SLUB allocators this was always possible so with SLOB
> gone, we can document it as supported.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Neeraj Upadhyay <quic_neeraju@quicinc.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> ---
>  Documentation/core-api/memory-allocation.rst | 15 +++++++++++----
>  include/linux/rcupdate.h                     |  6 ++++--
>  mm/slab_common.c                             |  5 +----
>  3 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
> index 5954ddf6ee13..f9e8d352ed67 100644
> --- a/Documentation/core-api/memory-allocation.rst
> +++ b/Documentation/core-api/memory-allocation.rst
> @@ -170,7 +170,14 @@ should be used if a part of the cache might be copied to the userspace.
>  After the cache is created kmem_cache_alloc() and its convenience
>  wrappers can allocate memory from that cache.
>  
> -When the allocated memory is no longer needed it must be freed. You can
> -use kvfree() for the memory allocated with `kmalloc`, `vmalloc` and
> -`kvmalloc`. The slab caches should be freed with kmem_cache_free(). And
> -don't forget to destroy the cache with kmem_cache_destroy().
> +When the allocated memory is no longer needed it must be freed. Objects

I'd add a line break before Objects                               ^

> +allocated by `kmalloc` can be freed by `kfree` or `kvfree`.
> +Objects allocated by `kmem_cache_alloc` can be freed with `kmem_cache_free`
> +or also by `kfree` or `kvfree`, which can be more convenient as it does

Maybe replace 'or also by' with a coma:

Objects allocated by `kmem_cache_alloc` can be freed with `kmem_cache_free`,
`kfree` or `kvfree`, which can be more convenient as it does


> +not require the kmem_cache pointed.

                             ^ pointer.

> +The rules for _bulk and _rcu flavors of freeing functions are analogical.

Maybe 

The same rules apply to _bulk and _rcu flavors of freeing functions.

> +
> +Memory allocated by `vmalloc` can be freed with `vfree` or `kvfree`.
> +Memory allocated by `kvmalloc` can be freed with `kvfree`.
> +Caches created by `kmem_cache_create` should be freed with
> +`kmem_cache_destroy` only after freeing all the allocated objects first.
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 094321c17e48..dcd2cf1e8326 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -976,8 +976,10 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
>   * either fall back to use of call_rcu() or rearrange the structure to
>   * position the rcu_head structure into the first 4096 bytes.
>   *
> - * Note that the allowable offset might decrease in the future, for example,
> - * to allow something like kmem_cache_free_rcu().
> + * The object to be freed can be allocated either by kmalloc() or
> + * kmem_cache_alloc().
> + *
> + * Note that the allowable offset might decrease in the future.
>   *
>   * The BUILD_BUG_ON check must not involve any function calls, hence the
>   * checks are done in macros here.
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 1522693295f5..607249785c07 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -989,12 +989,9 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller);
>  
>  /**
>   * kfree - free previously allocated memory
> - * @object: pointer returned by kmalloc.
> + * @object: pointer returned by kmalloc() or kmem_cache_alloc()
>   *
>   * If @object is NULL, no operation is performed.
> - *
> - * Don't free memory not originally allocated by kmalloc()
> - * or you will run into trouble.
>   */
>  void kfree(const void *object)
>  {
> -- 
> 2.39.2
> 

-- 
Sincerely yours,
Mike.
