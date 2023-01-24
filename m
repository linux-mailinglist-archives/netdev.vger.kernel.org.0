Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D268679192
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 08:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbjAXHHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 02:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbjAXHHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 02:07:02 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE74D3BD92
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 23:07:01 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id jm10so13822325plb.13
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 23:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tu8uF0sIvdJH1X4pmLZGQdlr7nT0GaxQgUrNBqH+YlI=;
        b=m8uSZj4Z6qfEwNKT93uNAsFUeTrPrrtwXWYCnJhN4xTSL1/ZYPQ7XXJ0Fz07wFHFWe
         v58q9BSMYaHR5VmqmRfBLRWYMPknkpwDPceZGbKzcn6vXAr2lb2Qwy2gHxOpDzhtid9n
         Mjvoyu6PyOPp0U65w2lZ5lPz3dwxitcQ57PX6WSqCZa6Z42HT3kArq45zpLFP8pD3hna
         3WrgN5oXuMCCZ2z76hqhrqQiRa1NkPXvyBAE7QozNaRGna4k6VrPZgUJbYRROF+Zuhyy
         MzyFfvdY2yFtl5x06NGBZNpYbwFzGhfKVaZRgDZgOJyvChAYQGj5ckD1saRtRa+sqFeL
         iuJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tu8uF0sIvdJH1X4pmLZGQdlr7nT0GaxQgUrNBqH+YlI=;
        b=YEHKTqIVXHDX33DxV8JBUkUs7QQIaNEmexszJAHkJAcqRVFWTpe8F2GWBs2DTcWk1X
         /x/Y1hk9ZG5qbT30vNg2Goyw5Vncmbg7XvVWhcKlNNRlb2gbSZ/zBWwQWhnX+BmoRziW
         DIU2bwBLPh3IMvhhT5oWT61ZfD2NR+lwR0A0hLfa945GqIN4GJvry1JEwQn3QsvnKvyG
         /2h5urKnNgyN0+c6qtif36oGhNbmkilzyQRbmiEk4xYTqBCULIME9WQVUOsbjL+VjL/T
         bXUSj43LYAe4CAIqvV7L0raqbPCJafFuMS6FI3Gg1boioF2ZlNkU28kKb9BVNXqb4OqM
         f8uQ==
X-Gm-Message-State: AFqh2kqcYubBrFhebJGCE53FGl7CU6OEu50gh835fzgHG9fJqldRext5
        L/zofoOscIjhmCvwQbPPzu+PvPE2AwtRew==
X-Google-Smtp-Source: AMrXdXuEnsI1kKsqdbIIs99GgMTyTbgnlqHBOUA03awggSDmwRrwnwQlwOXlC1nw6JLjLi5h/GWheA==
X-Received: by 2002:a17:903:40ce:b0:194:d09b:7986 with SMTP id t14-20020a17090340ce00b00194d09b7986mr18863227pld.23.1674544021181;
        Mon, 23 Jan 2023 23:07:01 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id a26-20020aa794ba000000b00580cc63dce8sm776835pfl.77.2023.01.23.23.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 23:07:00 -0800 (PST)
Date:   Wed, 25 Jan 2023 01:06:45 +0900
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Christoph Lameter <cl@gentwo.de>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, penberg@kernel.org,
        vbabka@suse.cz, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH RFC] mm+net: allow to set kmem_cache create flag for
 SLAB_NEVER_MERGE
Message-ID: <Y9ACFZzn2Pse0rKG@hyeyoo>
References: <167396280045.539803.7540459812377220500.stgit@firesoul>
 <36f5761f-d4d9-4ec9-a64-7a6c6c8b956f@gentwo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36f5761f-d4d9-4ec9-a64-7a6c6c8b956f@gentwo.de>
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 03:54:34PM +0100, Christoph Lameter wrote:
> On Tue, 17 Jan 2023, Jesper Dangaard Brouer wrote:
> 
> > When running different network performance microbenchmarks, I started
> > to notice that performance was reduced (slightly) when machines had
> > longer uptimes. I believe the cause was 'skbuff_head_cache' got
> > aliased/merged into the general slub for 256 bytes sized objects (with
> > my kernel config, without CONFIG_HARDENED_USERCOPY).
> 
> Well that is a common effect that we see in multiple subsystems. This is
> due to general memory fragmentation. Depending on the prior load the
> performance could actually be better after some runtime if the caches are
> populated avoiding the page allocator etc.
> 
> The merging could actually be beneficial since there may be more partial
> slabs to allocate from and thus avoiding expensive calls to the page
> allocator.
> 
> I wish we had some effective way of memory defragmentation.

If general memory fragmentation is actual cause of this problem, 
it may be worsening by [1] due to assumption that all allocations
are done in the same order as s->oo, when accounting and limiting the number
of percpu slabs.

[1] https://lore.kernel.org/linux-mm/76c63237-c489-b942-bdd9-5720042f52a9@suse.cz
