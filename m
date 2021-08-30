Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8410D3FB7F4
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 16:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbhH3OWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 10:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbhH3OWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 10:22:52 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D40DC061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 07:21:58 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id m26so12360755pff.3
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 07:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9VYKP4BtY52G/QfxOL4ci9LsSwqIuUiAxga6ojIUWhM=;
        b=rX/n04t3hwSmIEK5sY0o788rpIpjsNj/ric5w+RL9Y5fd/jrKYfgCowq9OT4EPJXpk
         WSehnR/Xk3PPjq51bpOHzx0/XcgTsukhRVdAIRbRcmIJAPf8qutfloXIY/3jQ53FkcVL
         uwGwFmQP21tYDGlvAxMdHr7T41mY372Mjmfup9xPngYq8Z43+grlgY7MS7s1iD4/p0Te
         +8mY7L2idpk4uVCt/dNg0r1w6tzsrVR+1eRlwcIdxQ3ekrh6djsf+qArQ9r5h2HE9vv5
         jsSLq/DZd1qxkCzIjIlZR4dqRACGMiEOp+BtamDSNL5nugEl97bDkHPo0M8LPanXAhNC
         JTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9VYKP4BtY52G/QfxOL4ci9LsSwqIuUiAxga6ojIUWhM=;
        b=e/nKbvU9scolQikXxSSb6CqalPlYANRWgk5DStrfIFnRDRvm2R2/vPvIVCj7Dwhnvf
         rapf337hucOMlL/UF/pIJYSkXgtC8ecwh52v3iLAHaT0c2xXNghhvH+nFSowRqlWC2kh
         ApyoWakEMXmf77a6kxw0DryZk0pyd48aGH28z84xNhZ6PpBDRipUQKoZO7w5fVzpRYfQ
         ij/fhkHepYAFt6icxSqy9TPpKdtjkIbHL1cLImFmrrolOECDSDypCWhkgs4FB6wKtO2h
         FNuFWjv3eEIHqNmB8SnuJ1BbGYjNNse0+Yl19VLOvOL6x+D/km3nGATdWzfz3+y8FRBg
         4gQA==
X-Gm-Message-State: AOAM530vHE4o4ArvdMKxu1z54/fBGgXFj6IAs5ut8sgUZKBP2deBlYAv
        hxFmvnDzj8slQsWbQCC2rVBr
X-Google-Smtp-Source: ABdhPJxsbkcgJHKC9l8Nzp6aGuWpGOLQSR5SX63hdPPAsp+Np9TJgCk3tFS4YemV8vWYWRm1YrsWxw==
X-Received: by 2002:a63:4cd:: with SMTP id 196mr22087854pge.239.1630333317896;
        Mon, 30 Aug 2021 07:21:57 -0700 (PDT)
Received: from localhost ([139.177.225.237])
        by smtp.gmail.com with ESMTPSA id gc20sm10539505pjb.17.2021.08.30.07.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 07:21:57 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        will@kernel.org, john.garry@huawei.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 01/13] iova: Export alloc_iova_fast() and free_iova_fast()
Date:   Mon, 30 Aug 2021 22:17:25 +0800
Message-Id: <20210830141737.181-2-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210830141737.181-1-xieyongji@bytedance.com>
References: <20210830141737.181-1-xieyongji@bytedance.com>
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
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Will Deacon <will@kernel.org>
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

