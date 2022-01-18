Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E439492E4A
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 20:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348670AbiARTSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 14:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348538AbiARTR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 14:17:56 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64B7C06161C
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 11:17:56 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id u26so285269qva.7
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 11:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=XLdOdrMhGx+uWKyGybpz2Ct3QQEBAUUynbEFITHgPLY=;
        b=eqv3DAHBk+Hy73moYerjN9BAfZaKoSsxduKm5/A3uOEeVXd4K+fBAqeukoaBam4xMe
         jpvd9jYkFSO8zxC5sGg1BTH6C8kch//t5eYUcvjYP6cnh3O61jqBS9IzQgGTbEri6aRv
         2HiAnUw4WVgh70N/97NoOPdhmIub7SiY116iHt+tdQdFRLshMx7+B/qYOlEo2viw+kzM
         FQFlk1E4Y5De/equbwCndPWUs8m45zdSWr6r7Wjd0EodoExdxRRC+zs/QG7asATRRpxD
         BdWTEhi3UTRJycTiLMY/+iO943kr8qPscgMKYHTPuD0sy9jEQogCET9iyqSScPFg+bG4
         SKPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=XLdOdrMhGx+uWKyGybpz2Ct3QQEBAUUynbEFITHgPLY=;
        b=ZPQUDCzzes5W8LmTacrUz5UCKKQUQOuJvBqcaUsZebuN+WTuCBudFLOyAIxhYVawwO
         tJYh22z1X7nLqNxAhnc2U6AcyGBYN6abf47zWH4iv+VLWk5NtGQh+Hc13gT/GgZIjPwe
         1BUNfCqWS/ooSOpjrb8BIXKUwI8jNP2O/y3hCndkJhVz4jC88wlpd1WW3+mmM654RgUm
         h4TPWm9aYQJRBYjc57RJa6PRXpl+2DBGfi7JwwjnYrE4lVv0SXlH7KtQ4NIixfGjpM6N
         RED5Hf6mreT2V8CSPhHveuPzc5yUeG29UNpH1OywNNYr/ZOmo9xQ92Xqwjyfo2KO4HKr
         SOZQ==
X-Gm-Message-State: AOAM531hudo3OxwkRZ8sOeAcExzVNRsbIbIbwAUj/y2v56AFoWJZ7RET
        fnZmjm40zFmGyo6VJKTNRbwMOg==
X-Google-Smtp-Source: ABdhPJx0iU9ep14OW8wdAZo0YFqi2HrSMQgSkFQiKRB2JmWQ0LMsSBdMRLAtUti744cRpbkirBetUg==
X-Received: by 2002:ad4:4ea2:: with SMTP id ed2mr24831618qvb.128.1642533475885;
        Tue, 18 Jan 2022 11:17:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id s10sm11405313qko.104.2022.01.18.11.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 11:17:55 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1n9tzO-0012Oy-6w; Tue, 18 Jan 2022 15:17:54 -0400
Date:   Tue, 18 Jan 2022 15:17:54 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Praveen Kannoju <praveen.kannoju@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Message-ID: <20220118191754.GG8034@ziepe.ca>
References: <1642517238-9912-1-git-send-email-praveen.kannoju@oracle.com>
 <53D98F26-FC52-4F3E-9700-ED0312756785@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D98F26-FC52-4F3E-9700-ED0312756785@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 04:48:43PM +0000, Santosh Shilimkar wrote:
> 
> > On Jan 18, 2022, at 6:47 AM, Praveen Kannoju <praveen.kannoju@oracle.com> wrote:
> > 
> > This patch aims to reduce the number of asynchronous workers being spawned
> > to execute the function "rds_ib_flush_mr_pool" during the high I/O
> > situations. Synchronous call path's to this function "rds_ib_flush_mr_pool"
> > will be executed without being disturbed. By reducing the number of
> > processes contending to flush the mr pool, the total number of D state
> > processes waiting to acquire the mutex lock will be greatly reduced, which
> > otherwise were causing DB instance crash as the corresponding processes
> > were not progressing while waiting to acquire the mutex lock.
> > 
> > Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
> > —
> > 
> […]
> 
> > diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> > index 8f070ee..6b640b5 100644
> > +++ b/net/rds/ib_rdma.c
> > @@ -393,6 +393,8 @@ int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
> > 	 */
> > 	dirty_to_clean = llist_append_to_list(&pool->drop_list, &unmap_list);
> > 	dirty_to_clean += llist_append_to_list(&pool->free_list, &unmap_list);
> > +	WRITE_ONCE(pool->flush_ongoing, true);
> > +	smp_wmb();
> > 	if (free_all) {
> > 		unsigned long flags;
> > 
> > @@ -430,6 +432,8 @@ int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
> > 	atomic_sub(nfreed, &pool->item_count);
> > 
> > out:
> > +	WRITE_ONCE(pool->flush_ongoing, false);
> > +	smp_wmb();
> > 	mutex_unlock(&pool->flush_lock);
> > 	if (waitqueue_active(&pool->flush_wait))
> > 		wake_up(&pool->flush_wait);
> > @@ -507,8 +511,17 @@ void rds_ib_free_mr(void *trans_private, int invalidate)
> > 
> > 	/* If we've pinned too many pages, request a flush */
> > 	if (atomic_read(&pool->free_pinned) >= pool->max_free_pinned ||
> > -	    atomic_read(&pool->dirty_count) >= pool->max_items / 5)
> > -		queue_delayed_work(rds_ib_mr_wq, &pool->flush_worker, 10);
> > +	    atomic_read(&pool->dirty_count) >= pool->max_items / 5) {
> > +		smp_rmb();
> You won’t need these explicit barriers since above atomic and write once already
> issue them.

No, they don't. Use smp_store_release() and smp_load_acquire if you
want to do something like this, but I still can't quite figure out if
this usage of unlocked memory accesses makes any sense at all.

Jason
