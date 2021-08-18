Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946433F0354
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhHRMIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235981AbhHRMIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 08:08:23 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16710C06179A
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:07:49 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n5so2452873pjt.4
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dPJJmxsVnbJuWsaYefx+5ABSk3S/ct0HfhPILPNJBeY=;
        b=Il0dp2rPVUCBMX9KFhOtzGkP3WKDoZ1ZKEgN6kb2agZ8E5jDQdBcduO5z6+043hYpd
         Ufi8v00bjhHrLaYO9v2rUWDcl6NeckWKR50ZAjIC4vGPqrrZlcIMPniKBTLz+M0Ac2wW
         lvt2CQw2pwEwtNNuWnZO45Lx2NonUj7axKrI0LbgxlcXYK2MJA/2Yj/CJqtxZihF5DCw
         5ze/wh02hcvuQ7d/Huk7Si32RAeQhRmnTq9PC//bqKcyMAfDvauBXt0nHLNbXlQDNDnQ
         4Dsqf33aSduXN3Dv/itwrQsG8YwGNPtTScyWKAk0xLEiH1aFKpXXhY26VsmpguruySKm
         AP3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dPJJmxsVnbJuWsaYefx+5ABSk3S/ct0HfhPILPNJBeY=;
        b=aDTe+C3CfZ8weyvXD21NG5mcvw1TbKb+yMyuSEaBHQ7w/DyWh9gK1ID8pnRVgiBYzR
         cxQaSzEoIkL6IVb/IeV+zUtOHYjRN7zQBtjkZutI0WIbMmSY2L0l82juTfp2d7T4UyAM
         0Lw+sPzM2QqnmWqMv7+6WNbv7Uy4RXoolE7HH9Dm4spLRVzugH3nGI/nvZq2tkvzD2N2
         dZMwxcgbXSrvkqlsf7a/fb8lbA6woFo/4Xs5D2pz8xvbprIMLtPfbsjYcGqwMqbyVnhc
         BmPCLqk4jnuTyxmotdOfNB3Q05nY2wIvcAR5Dexa+gCwMUN9xhGxRoxjDLaEkHPnl8Ci
         nDHA==
X-Gm-Message-State: AOAM531x/Hjok58mB6Zgx35ea3i1fk/9zfPn7Do/RCWq1j7MJ9lP4ZfO
        CfPu5+XdOYhnN4hT2/+7BQIf
X-Google-Smtp-Source: ABdhPJwcXSEuwzRnGhI2y+Q5IbLvbn5O9K+BcqEVJ6ubab8h4kSTKekrk2aFvZ2U2B+Ykcq6j6DPIA==
X-Received: by 2002:a17:90b:378c:: with SMTP id mz12mr8802850pjb.187.1629288468662;
        Wed, 18 Aug 2021 05:07:48 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id c15sm5205386pjr.22.2021.08.18.05.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 05:07:48 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v11 01/12] iova: Export alloc_iova_fast() and free_iova_fast()
Date:   Wed, 18 Aug 2021 20:06:31 +0800
Message-Id: <20210818120642.165-2-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120642.165-1-xieyongji@bytedance.com>
References: <20210818120642.165-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export alloc_iova_fast() and free_iova_fast() so that
some modules can make use of the per-CPU cache to get
rid of rbtree spinlock in alloc_iova() and free_iova()
during IOVA allocation.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/iommu/iova.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index b6cf5f16123b..3941ed6bb99b 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -521,6 +521,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
 
 	return new_iova->pfn_lo;
 }
+EXPORT_SYMBOL_GPL(alloc_iova_fast);
 
 /**
  * free_iova_fast - free iova pfn range into rcache
@@ -538,6 +539,7 @@ free_iova_fast(struct iova_domain *iovad, unsigned long pfn, unsigned long size)
 
 	free_iova(iovad, pfn);
 }
+EXPORT_SYMBOL_GPL(free_iova_fast);
 
 #define fq_ring_for_each(i, fq) \
 	for ((i) = (fq)->head; (i) != (fq)->tail; (i) = ((i) + 1) % IOVA_FQ_SIZE)
-- 
2.11.0

