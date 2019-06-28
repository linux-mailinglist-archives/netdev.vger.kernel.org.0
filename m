Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA67A5967F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 10:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfF1Ixd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 04:53:33 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42511 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfF1Ixc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 04:53:32 -0400
Received: by mail-lj1-f195.google.com with SMTP id t28so5173836lje.9
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 01:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9E0E93XxeCSyu3wDmx8dtieb34P1C5zJl3CaudNwVa8=;
        b=vgJOh/iP+OUr9C1XTwB8TfEvrLboKNWgrNbicYnftcsnYxTa8ODof53WDXBbWfTTaU
         AQrnJk/9x3YyCsKaPeljUMOAwx5XMgHm9dVDlTkztq0cpbQK39oZTmRmFSL3c1dhWo3v
         wjICJUbAsHsIoXxHoq1B9ZkLvTTgGzeueniKMOHHP3lWmnXS3w71q6Qmp6ZlSEXcshyq
         oiIyfETXspLOTf4V1N6DjhzyUefCUoGbRVOoD3xjcc8lqp6lZL7jz9GvP2nl/AqMXhye
         Hiu/diU807QvsCIxmib9iAviqIgVqYQKXO1W6bcBePnVSHkzQRThCFC0X71oiXWJY2GH
         qQPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=9E0E93XxeCSyu3wDmx8dtieb34P1C5zJl3CaudNwVa8=;
        b=ZYdclMqxb+eN39+5+Duw0b/BlnjRnZVI8VLdFi3zJPiW/ITK5iurnu6PwjwMbu0L4b
         0ONscYvrcicDvfAwOPTKw1Xz5pVKkVRmFjfJpY5nP4DQB8iqLB/g3xUFolrEUvP+zVM8
         z2S1DF4Q07YWyDBX05gc1eUrq9cRi7ionj26FPEYkZQdY2RbHHGGzP2Zq9AoOkKaMsrD
         kml7UM5Jw2jvGgmy/T9x+y+FVBoQSGqre9q5PDHbTNWwQ0WG8wuL/MrL3iYbQqWIY7LX
         MzTwyGh9YDBud8Z9IIpG0FpE15/IUJUu+PhSBb+XCcdfKkkjEDxQke0eggdluxp1Tu2Y
         UV5Q==
X-Gm-Message-State: APjAAAXXGAcUmupbhK2s+8Zt4b2XCeKRxZtrDokIynEGD8tmKyDwgu4O
        YDFmA5vTSEkFOVNNY+PxzsVxSA==
X-Google-Smtp-Source: APXvYqx+UfOhCshbm6Vgy/3EvXVlzzq5rRsn0Z706cJ2Qa0EUEqVNnfktpteKZenWR2qPmZUbJYI0w==
X-Received: by 2002:a2e:98d7:: with SMTP id s23mr5393648ljj.179.1561712009652;
        Fri, 28 Jun 2019 01:53:29 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id s24sm507093lje.58.2019.06.28.01.53.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Jun 2019 01:53:29 -0700 (PDT)
Date:   Fri, 28 Jun 2019 11:53:26 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     davem@davemloft.net, grygorii.strashko@ti.com, saeedm@mellanox.com,
        leon@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
Subject: Re: [PATCH v4 net-next 1/4] net: core: page_pool: add user cnt
 preventing pool deletion
Message-ID: <20190628085325.GA2795@khorivan>
Mail-Followup-To: Jesper Dangaard Brouer <brouer@redhat.com>,
        davem@davemloft.net, grygorii.strashko@ti.com, saeedm@mellanox.com,
        leon@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
References: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org>
 <20190625175948.24771-2-ivan.khoronzhuk@linaro.org>
 <20190627214317.237e5926@carbon>
 <20190627220245.GA3269@khorivan>
 <20190628083520.4203cb41@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190628083520.4203cb41@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 08:35:20AM +0200, Jesper Dangaard Brouer wrote:
>On Fri, 28 Jun 2019 01:02:47 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> Hi Jesper, thanks you remember about it.
>>
>> >
>> >I don't think that "create" and "free" routines paring looks "more
>> >correct" together.
>> >
>> >Maybe we can scale back your solution(?), via creating a page_pool_get()
>> >and page_pool_put() API that can be used by your driver, to keep the
>> >page_pool object after a xdp_rxq_info_unreg() call.  Then you can use
>> >it for two xdp_rxq_info structs, and call page_pool_put() after you
>> >have unregistered both.
>> >
>> >The API would basically be:
>> >
>> >diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> >index b366f59885c1..691ddacfb5a6 100644
>> >--- a/net/core/page_pool.c
>> >+++ b/net/core/page_pool.c
>> >@@ -357,6 +357,10 @@ static void __warn_in_flight(struct page_pool *pool)
>> > void __page_pool_free(struct page_pool *pool)
>> > {
>> >        WARN(pool->alloc.count, "API usage violation");
>> >+
>> >+       if (atomic_read(&pool->user_cnt) != 0)
>> >+               return;
>> >+
>> >        WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
>> >
>> >        /* Can happen due to forced shutdown */
>> >@@ -372,6 +376,19 @@ void __page_pool_free(struct page_pool *pool)
>> > }
>> > EXPORT_SYMBOL(__page_pool_free);
>> >
>> >+void page_pool_put(struct page_pool *pool)
>> >+{
>> >+       if (!atomic_dec_and_test(&pool->user_cnt))
>> >+               __page_pool_free(pool);
>> >+}
>> >+EXPORT_SYMBOL(page_pool_put);
>> >+
>> >+void page_pool_get(struct page_pool *pool)
>> >+{
>> >+       atomic_inc(&pool->user_cnt);
>> >+}
>> >+EXPORT_SYMBOL(page_pool_get);
>> >+
>>
>> I have another solution that doesn't touch page pool and adds modifications
>> to xdp allocator. As for me it looks better and work wider, I don't need to
>> think about this in the driver also.
>>
>> It's supposed allocator works as before, no any changes to mlx5 and
>> page_pool API and its usage and seems like fits your requirements.
>> It still supposes that allocator runs under same napi softirq but allows
>> to reuse allocator.
>>
>> I have not verified yet, but looks like:
>>
>> diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
>> index 6a8cba6ea79a..995b21da2f27 100644
>> --- a/include/net/xdp_priv.h
>> +++ b/include/net/xdp_priv.h
>> @@ -18,6 +18,7 @@ struct xdp_mem_allocator {
>>  	struct rcu_head rcu;
>>  	struct delayed_work defer_wq;
>>  	unsigned long defer_warn;
>> +	unsigned long refcnt;
>>  };
>>
>>  #endif /* __LINUX_NET_XDP_PRIV_H__ */
>> diff --git a/net/core/xdp.c b/net/core/xdp.c
>> index f98ab6b98674..6239483e3793 100644
>> --- a/net/core/xdp.c
>> +++ b/net/core/xdp.c
>> @@ -98,6 +98,12 @@ static bool __mem_id_disconnect(int id, bool force)
>>  		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
>>  		return true;
>>  	}
>> +
>> +	if (--xa->refcnt) {
>> +		mutex_unlock(&mem_id_lock);
>> +		return true;
>
>This doesn't work.  This function __mem_id_disconnect() can be called
>multiple times. E.g. if there are in-flight packets.
Yes, it was draft. I still have not completely verify it due
to several changes in cpsw and holiday in my side, second draft
looks like:

Subject: [PATCH] net: core: xdp: allow same allocator for rxq

XDP rxq can be same for ndevs running under same rx napi softirq.
But there is no ability to register same allocator for both rxqs,
by fact it's same rxq but has different ndev as a reference.

Due to last changes allocator destroy can be defered till the moment
all packets are recycled by destination interface, afterwards it's
freed. In order to schedule allocator destroy only after all users are
unregistered, add refcnt to allocator object and start to destroy
only it reaches 0.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 include/net/xdp_priv.h |  1 +
 net/core/xdp.c         | 46 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

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
index f98ab6b98674..7b0185eec124 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -98,6 +98,18 @@ static bool __mem_id_disconnect(int id, bool force)
 		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
 		return true;
 	}
+
+	/* to avoid hash lookup twice do refcnt dec here, but not when
+	 * it's 0 as it can be called from workqueue aftewards
+	 */
+	if (xa->refcnt)
+		xa->refcnt--;
+
+	if (xa->refcnt) {
+		mutex_unlock(&mem_id_lock);
+		return true;
+	}
+
 	xa->disconnect_cnt++;
 
 	/* Detects in-flight packet-pages for page_pool */
@@ -312,6 +324,33 @@ static bool __is_supported_mem_type(enum xdp_mem_type type)
 	return true;
 }
 
+static struct xdp_mem_allocator *xdp_allocator_get(void *allocator)
+{
+	struct xdp_mem_allocator *xae, *xa = NULL;
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
@@ -347,6 +386,12 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 		}
 	}
 
+	xdp_alloc = xdp_allocator_get(allocator);
+	if (xdp_alloc) {
+		xdp_rxq->mem.id = xdp_alloc->mem.id;
+		return 0;
+	}
+
 	xdp_alloc = kzalloc(sizeof(*xdp_alloc), gfp);
 	if (!xdp_alloc)
 		return -ENOMEM;
@@ -360,6 +405,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 	xdp_rxq->mem.id = id;
 	xdp_alloc->mem  = xdp_rxq->mem;
 	xdp_alloc->allocator = allocator;
+	xdp_alloc->refcnt = 1;
 
 	/* Insert allocator into ID lookup table */
 	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);

-- 
Regards,
Ivan Khoronzhuk
