Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6FB2496AC
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgHSHJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgHSG42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 02:56:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC1AC061342;
        Tue, 18 Aug 2020 23:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=eBdiOi8NPtkzomu53YzYl2srwsK9DIz9xkGY00o46Kk=; b=W7jp/kmQRNQmUKHIQCbWiH2UzD
        GHchOhkvpQXWR6G8uHdQkx6sUQhPxtEOypHvMit0pnMaJ96seYjUrPxSxVC6yzpyGBSOC2Nrgsh8t
        habu4qVEkcucriWPKkm9BybK9fhXZoRM6VZxHk19H4GtftcZP4mFNmDQh9R4d6euSpnVjF/IT+4VA
        fQn1gjBdhax7V48K7ChncjzQBXjHEdp34pMLA0HCN9PETDLnVwDoWAMZ6z8zDxVD+JSzcAWRs6/Yh
        jvj7ygz03LhQShxpipeKs0B45bhtyQCSewe+tNF4boY9o+jka2d5wVanpf8IakmCQfRJXxYOcqDdr
        mCnhF8Kg==;
Received: from [2001:4bb8:198:f3b2:86b6:2277:f429:37a1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8I0v-0008L8-G8; Wed, 19 Aug 2020 06:56:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, nouveau@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 03/28] drm/nouveau/gk20a: stop setting DMA_ATTR_NON_CONSISTENT
Date:   Wed, 19 Aug 2020 08:55:30 +0200
Message-Id: <20200819065555.1802761-4-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200819065555.1802761-1-hch@lst.de>
References: <20200819065555.1802761-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DMA_ATTR_NON_CONSISTENT is a no-op except on PARISC and some mips
configs, so don't set it in this ARM specific driver part.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c b/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
index 985f2990ab0dda..13d4d7ac0697b4 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
@@ -594,8 +594,7 @@ gk20a_instmem_new(struct nvkm_device *device, int index,
 
 		nvkm_info(&imem->base.subdev, "using IOMMU\n");
 	} else {
-		imem->attrs = DMA_ATTR_NON_CONSISTENT |
-			      DMA_ATTR_WEAK_ORDERING |
+		imem->attrs = DMA_ATTR_WEAK_ORDERING |
 			      DMA_ATTR_WRITE_COMBINE;
 
 		nvkm_info(&imem->base.subdev, "using DMA API\n");
-- 
2.28.0

