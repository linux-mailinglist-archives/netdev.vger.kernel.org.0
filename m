Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8064F33D8C5
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbhCPQKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:10:33 -0400
Received: from casper.infradead.org ([90.155.50.34]:41316 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhCPQKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:10:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Uc+inoe77xDeXckYX3n+V6DmwCQOACdS2a3bOR17+1w=; b=YEZD3YRFaNVvjqaNt0KraCvjqN
        ucCUN6pUH4GT22GZ2CRDACauBZqaMdq74H/CXf6e11hLrUQmTq3rcYE1lPBHwbUXFZJpZl3u6mgWG
        OFKiTty0vesPVerD//4atA40MRDpVEHuGp2ZXSUBKbPqPnh9+DGHG5hKGbGjX92lZS2gGoEtRdsVy
        tprFfygVjS7s5pkLddfXRtv2sfLGkv7vCoKz4jwU8HPtQ3uzAybhRqm/9bkaLfEL7uCAXMMj3OdqI
        BibBACyen3XP54ye1UrgBcb/GH57IiS5xUZH/RX8dA0mVWYjtdukjSEgKnuWPcVFp6gsIYQGhZ4mM
        O82ZJhZQ==;
Received: from 089144199244.atnat0008.highway.a1.net ([89.144.199.244] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMCFv-000Hml-4m; Tue, 16 Mar 2021 16:09:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Li Yang <leoyang.li@nxp.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 12/18] iommu: remove DOMAIN_ATTR_PAGING
Date:   Tue, 16 Mar 2021 16:38:18 +0100
Message-Id: <20210316153825.135976-13-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316153825.135976-1-hch@lst.de>
References: <20210316153825.135976-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DOMAIN_ATTR_PAGING is never used.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Li Yang <leoyang.li@nxp.com>
---
 drivers/iommu/iommu.c | 5 -----
 include/linux/iommu.h | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b212bf0261820b..9a4cda390993e6 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2668,7 +2668,6 @@ int iommu_domain_get_attr(struct iommu_domain *domain,
 			  enum iommu_attr attr, void *data)
 {
 	struct iommu_domain_geometry *geometry;
-	bool *paging;
 	int ret = 0;
 
 	switch (attr) {
@@ -2676,10 +2675,6 @@ int iommu_domain_get_attr(struct iommu_domain *domain,
 		geometry  = data;
 		*geometry = domain->geometry;
 
-		break;
-	case DOMAIN_ATTR_PAGING:
-		paging  = data;
-		*paging = (domain->pgsize_bitmap != 0UL);
 		break;
 	default:
 		if (!domain->ops->domain_get_attr)
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 840864844027dc..180ff4bd7fa7ef 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -108,7 +108,6 @@ enum iommu_cap {
 
 enum iommu_attr {
 	DOMAIN_ATTR_GEOMETRY,
-	DOMAIN_ATTR_PAGING,
 	DOMAIN_ATTR_NESTING,	/* two stages of translation */
 	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
 	DOMAIN_ATTR_IO_PGTABLE_CFG,
-- 
2.30.1

