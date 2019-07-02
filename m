Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F365D224
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfGBOxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:53:55 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46615 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfGBOxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 10:53:55 -0400
Received: by mail-lj1-f193.google.com with SMTP id v24so17190591ljg.13
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 07:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VO8pR2/an5Oq6niuIP4M7IveolwKJiGkaroUhVkNCRo=;
        b=ktvipVQziu6nomkCeYJwZ2EAY63BDxUFbsUhizFEcRAKqZK1mkTAqhJPsf6JPDEH0i
         FHeG1+3Rk80TQoV3vOuNs/NJUzwMZwUu4dOKPGndLQqfhaXzeVrupkvC0vdhaTkb9+4B
         9eCErwGIZhzSUe++i2539Lotm9hi3h5JeEPLS6B7wB3FqsUzYjiN5VPDes3ij1ll21tv
         bgBH1Md6lXqOTClMFTAWi1K6J5SK0ly2taZiZ8Xmr/bGqefGNFnF73B4w3eE8GqGI36w
         0p5BIvvXoUfIUWnmRhIyf0NNazAm4cwWhRPKthHc7Xt3sutociJCIOkQEtTRZeA72jvu
         dvkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=VO8pR2/an5Oq6niuIP4M7IveolwKJiGkaroUhVkNCRo=;
        b=sSyRiGvel+FDX1OI21K3WL7PwQvrpz0Edj2D6DTOqvXp8TntLzzh2FOrAopRbmBq6L
         WYSs+V1wLhtmDK7XKSjhK+TARaeHYRomQ1W2DlpUcF+oUYxkixSqbGMm9ZBfTiTy7SL6
         pS5xE5nDeosRFFCM4lYWGxIH7KO9f0/pQb2aJRM1ePFE1sXEiGotw7ZYU57if8bcBzsf
         S4DXjnncWV29cW9Ab919jNU65kPEa5T0hWUyTB5aklgjCLqKd7y2DTahmcR5IKxM3ug9
         j0R38u9AR/33INTUXkb8fP9APlpYuY4aGieDMftzrMAn9OrsXCG7CqYjleo6RwQ5y8+A
         XR1w==
X-Gm-Message-State: APjAAAXxJ3cJoc0jTBx47hHwDpvAWsAQbLxoBAhozeAYDxgRe7fsNmDz
        Kb99JTOO5TOi1XZNaBbx1oUdXw==
X-Google-Smtp-Source: APXvYqxm0HlBl+Hqt+ZUkf1MUdhdZhD9bNWCUbSe76bo0TTJdsqXFjz+IH73Kcea6wHtCChmlyPZWA==
X-Received: by 2002:a2e:9758:: with SMTP id f24mr1339104ljj.58.1562079233461;
        Tue, 02 Jul 2019 07:53:53 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id s7sm3861715lje.95.2019.07.02.07.53.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 07:53:52 -0700 (PDT)
Date:   Tue, 2 Jul 2019 17:53:50 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH v5 net-next 1/6] xdp: allow same allocator usage
Message-ID: <20190702145349.GE4510@khorivan>
Mail-Followup-To: Jesper Dangaard Brouer <brouer@redhat.com>,
        grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
References: <20190630172348.5692-1-ivan.khoronzhuk@linaro.org>
 <20190630172348.5692-2-ivan.khoronzhuk@linaro.org>
 <20190701134059.71757892@carbon>
 <20190702102700.GA4510@khorivan>
 <20190702164648.56ff0761@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190702164648.56ff0761@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 04:46:48PM +0200, Jesper Dangaard Brouer wrote:
>On Tue, 2 Jul 2019 13:27:07 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> On Mon, Jul 01, 2019 at 01:40:59PM +0200, Jesper Dangaard Brouer wrote:
>> >
>> >I'm very skeptical about this approach.
>> >
>> >On Sun, 30 Jun 2019 20:23:43 +0300
>> >Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>> >
>> >> XDP rxqs can be same for ndevs running under same rx napi softirq.
>> >> But there is no ability to register same allocator for both rxqs,
>> >> by fact it can same rxq but has different ndev as a reference.
>> >
>> >This description is not very clear. It can easily be misunderstood.
>> >
>> >It is an absolute requirement that each RX-queue have their own
>> >page_pool object/allocator. (This where the performance comes from) as
>> >the page_pool have NAPI protected array for alloc and XDP_DROP recycle.
>> >
>> >Your driver/hardware seems to have special case, where a single
>> >RX-queue can receive packets for two different net_device'es.
>> >
>> >Do you violate this XDP devmap redirect assumption[1]?
>> >[1] https://github.com/torvalds/linux/blob/v5.2-rc7/kernel/bpf/devmap.c#L324-L329
>> Seems that yes, but that's used only for trace for now.
>> As it runs under napi and flush clear dev_rx i must do it right in the
>> rx_handler. So next patchset version will have one patch less.
>>
>> Thanks!
>>
>> >
>> >
>> >> Due to last changes allocator destroy can be defered till the moment
>> >> all packets are recycled by destination interface, afterwards it's
>> >> freed. In order to schedule allocator destroy only after all users are
>> >> unregistered, add refcnt to allocator object and schedule to destroy
>> >> only it reaches 0.
>> >
>> >The guiding principles when designing an API, is to make it easy to
>> >use, but also make it hard to misuse.
>> >
>> >Your API change makes it easy to misuse the API.  As it make it easy to
>> >(re)use the allocator pointer (likely page_pool) for multiple
>> >xdp_rxq_info structs.  It is only valid for your use-case, because you
>> >have hardware where a single RX-queue delivers to two different
>> >net_devices.  For other normal use-cases, this will be a violation.
>> >
>> >If I was a user of this API, and saw your xdp_allocator_get(), then I
>> >would assume that this was the normal case.  As minimum, we need to add
>> >a comment in the code, about this specific/intended use-case.  I
>> >through about detecting the misuse, by adding a queue_index to
>> >xdp_mem_allocator, that can be checked against, when calling
>> >xdp_rxq_info_reg_mem_model() with another xdp_rxq_info struct (to catch
>> >the obvious mistake where queue_index mismatch).
>>
>> I can add, but not sure if it has or can have some conflicts with another
>> memory allocators, now or in future. Main here to not became a cornerstone
>> in some not obvious use-cases.
>>
>> So, for now, let it be in this way:
>>
>> --- a/include/net/xdp_priv.h
>> +++ b/include/net/xdp_priv.h
>> @@ -19,6 +19,7 @@ struct xdp_mem_allocator {
>>         struct delayed_work defer_wq;
>>         unsigned long defer_warn;
>>         unsigned long refcnt;
>> +       u32 queue_index;
>>  };
>>
>>  #endif /* __LINUX_NET_XDP_PRIV_H__ */
>> diff --git a/net/core/xdp.c b/net/core/xdp.c
>> index a44621190fdc..c4bf29810f4d 100644
>> --- a/net/core/xdp.c
>> +++ b/net/core/xdp.c
>> @@ -324,7 +324,7 @@ static bool __is_supported_mem_type(enum xdp_mem_type type)
>>         return true;
>>  }
>>
>> -static struct xdp_mem_allocator *xdp_allocator_get(void *allocator)
>> +static struct xdp_mem_allocator *xdp_allocator_find(void *allocator)
>>  {
>>         struct xdp_mem_allocator *xae, *xa = NULL;
>>         struct rhashtable_iter iter;
>> @@ -336,7 +336,6 @@ static struct xdp_mem_allocator *xdp_allocator_get(void *allocator)
>>
>>                 while ((xae = rhashtable_walk_next(&iter)) && !IS_ERR(xae)) {
>>                         if (xae->allocator == allocator) {
>> -                               xae->refcnt++;
>>                                 xa = xae;
>>                                 break;
>>                         }
>> @@ -386,9 +385,13 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>>                 }
>>         }
>>
>> -       xdp_alloc = xdp_allocator_get(allocator);
>> +       xdp_alloc = xdp_allocator_find(allocator);
>>         if (xdp_alloc) {
>> +               if (xdp_alloc->queue_index != xdp_rxq->queue_index)
>> +                       return -EINVAL;
>> +
>>                 xdp_rxq->mem.id = xdp_alloc->mem.id;
>> +               xdp_alloc->refcnt++;
>
>This is now adjusted outside lock, not good.

In final it serves:

From f43a0b85838f75814cc93e5a724c4c7e5615f936 Mon Sep 17 00:00:00 2001
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Fri, 28 Jun 2019 03:17:24 +0300
Subject: [PATCH] xdp: allow same allocator usage

XDP rxqs can be same for ndevs running under same rx napi softirq.
But there is no ability to register same allocator for both rxqs,
by fact it can same rxq but has different ndev as a reference.

Due to last changes allocator destroy can be defered till the moment
all packets are recycled by destination interface, afterwards it's
freed. In order to schedule allocator destroy only after all users are
unregistered, add refcnt to allocator object and schedule to destroy
only it reaches 0.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 include/net/xdp_priv.h |  2 ++
 net/core/xdp.c         | 52 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
index 6a8cba6ea79a..9858a4057842 100644
--- a/include/net/xdp_priv.h
+++ b/include/net/xdp_priv.h
@@ -18,6 +18,8 @@ struct xdp_mem_allocator {
 	struct rcu_head rcu;
 	struct delayed_work defer_wq;
 	unsigned long defer_warn;
+	unsigned long refcnt;
+	u32 queue_index;
 };
 
 #endif /* __LINUX_NET_XDP_PRIV_H__ */
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 829377cc83db..090f26e4f793 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -98,6 +98,18 @@ static bool __mem_id_disconnect(int id, bool force)
 		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
 		return true;
 	}
+
+	/* to avoid calling hash lookup twice, decrement refcnt here till it
+	 * reaches zero, then it can be called from workqueue afterwards.
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
@@ -312,6 +324,30 @@ static bool __is_supported_mem_type(enum xdp_mem_type type)
 	return true;
 }
 
+static struct xdp_mem_allocator *xdp_allocator_find(void *allocator)
+{
+	struct xdp_mem_allocator *xae, *xa = NULL;
+	struct rhashtable_iter iter;
+
+	rhashtable_walk_enter(mem_id_ht, &iter);
+	do {
+		rhashtable_walk_start(&iter);
+
+		while ((xae = rhashtable_walk_next(&iter)) && !IS_ERR(xae)) {
+			if (xae->allocator == allocator) {
+				xa = xae;
+				break;
+			}
+		}
+
+		rhashtable_walk_stop(&iter);
+
+	} while (xae == ERR_PTR(-EAGAIN));
+	rhashtable_walk_exit(&iter);
+
+	return xa;
+}
+
 int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 			       enum xdp_mem_type type, void *allocator)
 {
@@ -347,6 +383,20 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 		}
 	}
 
+	mutex_lock(&mem_id_lock);
+	xdp_alloc = xdp_allocator_find(allocator);
+	if (xdp_alloc) {
+		/* One allocator per queue is supposed only */
+		if (xdp_alloc->queue_index != xdp_rxq->queue_index)
+			return -EINVAL;
+
+		xdp_rxq->mem.id = xdp_alloc->mem.id;
+		xdp_alloc->refcnt++;
+		mutex_unlock(&mem_id_lock);
+		return 0;
+	}
+	mutex_unlock(&mem_id_lock);
+
 	xdp_alloc = kzalloc(sizeof(*xdp_alloc), gfp);
 	if (!xdp_alloc)
 		return -ENOMEM;
@@ -360,6 +410,8 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 	xdp_rxq->mem.id = id;
 	xdp_alloc->mem  = xdp_rxq->mem;
 	xdp_alloc->allocator = allocator;
+	xdp_alloc->refcnt = 1;
+	xdp_alloc->queue_index = xdp_rxq->queue_index;
 
 	/* Insert allocator into ID lookup table */
 	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);

>
>>                 return 0;
>>         }
>>
>> @@ -406,6 +409,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>>         xdp_alloc->mem  = xdp_rxq->mem;
>>         xdp_alloc->allocator = allocator;
>>         xdp_alloc->refcnt = 1;
>> +       xdp_alloc->queue_index = xdp_rxq->queue_index;
>>
>>         /* Insert allocator into ID lookup table */
>>         ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);
>>
>> Jesper, are you Ok with this version?
>
>Please see my other patch, this is based on our first refcnt attempt.
>I think that other patch is a better way forward.
XDP patch serves it better and can prevent not only obj deletion but also
pool flush. So I propose use 2 patches.

-- 
Regards,
Ivan Khoronzhuk
