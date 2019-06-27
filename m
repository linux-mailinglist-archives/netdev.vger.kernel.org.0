Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F083158D86
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfF0WCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:02:53 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46698 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfF0WCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:02:53 -0400
Received: by mail-lf1-f65.google.com with SMTP id z15so2561732lfh.13
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xbbnXWKXuliO2NCc1GKxfyiq/MrUoansylKG3BGiB8o=;
        b=skNHewgwM3928cMU3mhcyZ3kWO66KLPjH6Ty8Ai3Elkhe2r/kM1I+OtZXwNMEH2MM+
         1cSOjNOe3MymhoU6/SqxWZCc81i+EhbG8N0qCAkR5Y9srAXg6QoHl/drVslq+D6MA9xc
         bJorDAfBdBXmJ3P4Ualbzbk/s6ybNr5FrAWKyaMI9SqGpy/aYgc06YBnbvZ4J9SyGlIt
         V3aVth6uQT7QNUscQPFgCFxn5PXAQD9lV6wbcgqYqKFwk8ECD4Ifz/lq1IDRkXBlEvVh
         iW0fzBIa4QDChx2LFBcmsE7y0b8RkRFBrI63H9ioL/1UMynbj8Hv7sFZlDVJz+58Fk1V
         V29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=xbbnXWKXuliO2NCc1GKxfyiq/MrUoansylKG3BGiB8o=;
        b=W5pAeGaYXlMPkJT8+vlBDPLEsYeZl2Wg3MGq9K+U5lYsHadvsGBNPs5F1Xd7faYeMs
         m1mT9qjqkmMyd6xtxlbzFQfX6+EDt1dl1rudZMwZOXo43vg63RH95L6PXPjdjqiMayaN
         CXhGJdlZ6ZM1/lT4yUd7FGR8XcmGa9buEIPwjqnZz9H7wLLyUGPtvpv6pRluAnddxRSZ
         fFCStWGHsDVIr9x9krHJ/X+St8yubJCSnwauDFlQ+UMeahpjlALTmQq0HXeuNtPcuWg8
         7JeA2z6g2dCADv76+KP9yclue+kKjVFdVcJoy/rweA9Cy1zllQWKeOKrpL7rpfq+wpsK
         iYrw==
X-Gm-Message-State: APjAAAUYkg+SCblzhNNRRgH0GPFb4hrM5EAkUhjWNbYCcON4EcsT0ctA
        l5yxGWniwFg0TVYkEI9t30i2sA==
X-Google-Smtp-Source: APXvYqzZdcbD4SJLz/gtjo5rwBKiASsxtaTefT1ggkl9S07BUMU3dGPwkCq0gQLyROnWa7aFbWu+LA==
X-Received: by 2002:ac2:514b:: with SMTP id q11mr3322299lfd.33.1561672970365;
        Thu, 27 Jun 2019 15:02:50 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id v86sm70673lje.74.2019.06.27.15.02.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Jun 2019 15:02:49 -0700 (PDT)
Date:   Fri, 28 Jun 2019 01:02:47 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     davem@davemloft.net, grygorii.strashko@ti.com, saeedm@mellanox.com,
        leon@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
Subject: Re: [PATCH v4 net-next 1/4] net: core: page_pool: add user cnt
 preventing pool deletion
Message-ID: <20190627220245.GA3269@khorivan>
Mail-Followup-To: Jesper Dangaard Brouer <brouer@redhat.com>,
        davem@davemloft.net, grygorii.strashko@ti.com, saeedm@mellanox.com,
        leon@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
References: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org>
 <20190625175948.24771-2-ivan.khoronzhuk@linaro.org>
 <20190627214317.237e5926@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190627214317.237e5926@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper, thanks you remember about it.

>
>I don't think that "create" and "free" routines paring looks "more
>correct" together.
>
>Maybe we can scale back your solution(?), via creating a page_pool_get()
>and page_pool_put() API that can be used by your driver, to keep the
>page_pool object after a xdp_rxq_info_unreg() call.  Then you can use
>it for two xdp_rxq_info structs, and call page_pool_put() after you
>have unregistered both.
>
>The API would basically be:
>
>diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>index b366f59885c1..691ddacfb5a6 100644
>--- a/net/core/page_pool.c
>+++ b/net/core/page_pool.c
>@@ -357,6 +357,10 @@ static void __warn_in_flight(struct page_pool *pool)
> void __page_pool_free(struct page_pool *pool)
> {
>        WARN(pool->alloc.count, "API usage violation");
>+
>+       if (atomic_read(&pool->user_cnt) != 0)
>+               return;
>+
>        WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
>
>        /* Can happen due to forced shutdown */
>@@ -372,6 +376,19 @@ void __page_pool_free(struct page_pool *pool)
> }
> EXPORT_SYMBOL(__page_pool_free);
>
>+void page_pool_put(struct page_pool *pool)
>+{
>+       if (!atomic_dec_and_test(&pool->user_cnt))
>+               __page_pool_free(pool);
>+}
>+EXPORT_SYMBOL(page_pool_put);
>+
>+void page_pool_get(struct page_pool *pool)
>+{
>+       atomic_inc(&pool->user_cnt);
>+}
>+EXPORT_SYMBOL(page_pool_get);
>+

I have another solution that doesn't touch page pool and adds modifications
to xdp allocator. As for me it looks better and work wider, I don't need to
think about this in the driver also.

It's supposed allocator works as before, no any changes to mlx5 and
page_pool API and its usage and seems like fits your requirements.
It still supposes that allocator runs under same napi softirq but allows
to reuse allocator.

I have not verified yet, but looks like:

diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
index 6a8cba6ea79a..995b21da2f27 100644
--- a/include/net/xdp_priv.h
+++ b/include/net/xdp_priv.h
@@ -18,6 +18,7 @@ struct xdp_mem_allocator {
 	struct rcu_head rcu;
 	struct delayed_work defer_wq;
 	unsigned long defer_warn;
+	unsigned long refcnt;
 };
 
 #endif /* __LINUX_NET_XDP_PRIV_H__ */
diff --git a/net/core/xdp.c b/net/core/xdp.c
index f98ab6b98674..6239483e3793 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -98,6 +98,12 @@ static bool __mem_id_disconnect(int id, bool force)
 		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
 		return true;
 	}
+
+	if (--xa->refcnt) {
+		mutex_unlock(&mem_id_lock);
+		return true;
+	}
+
 	xa->disconnect_cnt++;
 
 	/* Detects in-flight packet-pages for page_pool */
@@ -312,6 +318,33 @@ static bool __is_supported_mem_type(enum xdp_mem_type type)
 	return true;
 }
 
+static struct xdp_mem_allocator *xdp_allocator_get(void *allocator)
+{
+	struct xdp_mem_allocator *xae, *xa == NULL;
+	struct rhashtable_iter iter;
+
+	mutex_lock(&mem_id_lock);
+	rhashtable_walk_enter(mem_id_ht, &iter);
+	do {
+		rhashtable_walk_start(&iter);
+
+		while ((xae = rhashtable_walk_next(&iter)) && !IS_ERR(xae)) {
+			if (xae->allocator == allocator) {
+				xae->refcnt++;
+				xa = xae;
+				break;
+			}
+		}
+
+		rhashtable_walk_stop(&iter);
+
+	} while (xae == ERR_PTR(-EAGAIN));
+	rhashtable_walk_exit(&iter);
+	mutex_unlock(&mem_id_lock);
+
+	return xa;
+}
+
 int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 			       enum xdp_mem_type type, void *allocator)
 {
@@ -347,6 +380,9 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 		}
 	}
 
+	if (xdp_allocator_get(allocator))
+		return 0;
+
 	xdp_alloc = kzalloc(sizeof(*xdp_alloc), gfp);
 	if (!xdp_alloc)
 		return -ENOMEM;
@@ -360,6 +396,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 	xdp_rxq->mem.id = id;
 	xdp_alloc->mem  = xdp_rxq->mem;
 	xdp_alloc->allocator = allocator;
+	xdp_alloc->refcnt = 1;
 
 	/* Insert allocator into ID lookup table */
 	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);


-- 
Regards,
Ivan Khoronzhuk
