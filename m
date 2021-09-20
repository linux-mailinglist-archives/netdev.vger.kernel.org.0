Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AABA410EB3
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbhITDMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbhITDLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:11:12 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0475EC061760;
        Sun, 19 Sep 2021 20:09:46 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s11so15907852pgr.11;
        Sun, 19 Sep 2021 20:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7bDxZYlLAqGmaBzkkRsMvzIqKDwv3GsHECyBJPCm0Ds=;
        b=MLs12fOeQHD/Ee1ST0MDGakbpGAGOjRJFbwTzkGzZ6QHzBkPypkoACG6amUriG/DDP
         Nnw5bOPTsbkJCNRJKS9UC4ZMzlO7lVJbJKuHjdPJOmWwo/l2W92x2nE3pdpsv05oCeAL
         NCP7F6fgOKA5P86dlbMBFV8BBDkgXbloT4ciyYwSpuzg4tvTEh0YOcE73Tcqg1eLNeLO
         s7qIhOOo/WZm2qmolljkIVSROsHm7g9aPCEtNSJ7OjGJF5fPPe4qhBKtJvxHW2yJyOYQ
         u8lzF+sgJt1FAboehTRLwUVSaeDHNZLGpLoVFtvb0dH1o4pI4Cc0RKKg9zBQXee5gb2I
         B7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7bDxZYlLAqGmaBzkkRsMvzIqKDwv3GsHECyBJPCm0Ds=;
        b=NIQVuRQsYKbVCyXz3DR6k9gZ8sr9xUqLjk5k1pHVX5xH70kOZHBu5/SZEy3BcX8EfI
         dnCEZnEveppSBCbmnM8mWLuRnQBs5vA9Ri/iqXBmYi/A/i5W7mjzBcKFexeoyKdPC1EZ
         BxZUOD92Kff+ZWlfnoCiEn6mus9b3aGyzHSrxVov/OEHA6aQ682dqEkxU34EQpUmR1Ma
         062hkC1F6GYFyPXT+IdcHe5IEvQ2Lv1HnjFZhrMX6jaaN25oeUvkqKXUQtuZRjjZgmes
         Ctypp/5LIJyc+WasD/f2DwTgI5O/gSSt2llL2Z47OS/yVcJol+lk0EoCrWLudjB8+OAv
         pzng==
X-Gm-Message-State: AOAM532daFNWHT+Onna4iCM76hrza5tK6p/UJe5WxVx25nLXylAEcu3u
        A1ZRZjBwqWE+5y1EyHQFhUmhVGCOJh6IYQx2
X-Google-Smtp-Source: ABdhPJzFSwgSnCsH+xzF6nAco18Uzjqg/G2BtyFgPaTDYFrUrsj0x81Ev+YekR1gcNL/uUecuT8fjg==
X-Received: by 2002:a62:750e:0:b0:446:d467:3620 with SMTP id q14-20020a62750e000000b00446d4673620mr9320885pfc.80.1632107385247;
        Sun, 19 Sep 2021 20:09:45 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:09:44 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 12/17] net: ipa: Add support for IPA v2.x memory map
Date:   Mon, 20 Sep 2021 08:38:06 +0530
Message-Id: <20210920030811.57273-13-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA v2.6L has an extra region to handle compression/decompression
acceleration. This region is used by some modems during modem init.

Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
---
 drivers/net/ipa/ipa_mem.c | 36 ++++++++++++++++++++++++++++++------
 drivers/net/ipa/ipa_mem.h |  5 ++++-
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 8acc88070a6f..bfcdc7e08de2 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -84,7 +84,7 @@ int ipa_mem_setup(struct ipa *ipa)
 	/* Get a transaction to define the header memory region and to zero
 	 * the processing context and modem memory regions.
 	 */
-	trans = ipa_cmd_trans_alloc(ipa, 4);
+	trans = ipa_cmd_trans_alloc(ipa, 5);
 	if (!trans) {
 		dev_err(&ipa->pdev->dev, "no transaction for memory setup\n");
 		return -EBUSY;
@@ -107,8 +107,14 @@ int ipa_mem_setup(struct ipa *ipa)
 	ipa_mem_zero_region_add(trans, IPA_MEM_AP_PROC_CTX);
 	ipa_mem_zero_region_add(trans, IPA_MEM_MODEM);
 
+	ipa_mem_zero_region_add(trans, IPA_MEM_ZIP);
+
 	ipa_trans_commit_wait(trans);
 
+	/* On IPA version <=2.6L (except 2.5) there is no PROC_CTX.  */
+	if (ipa->version != IPA_VERSION_2_5 && ipa->version <= IPA_VERSION_2_6L)
+		return 0;
+
 	/* Tell the hardware where the processing context area is located */
 	mem = ipa_mem_find(ipa, IPA_MEM_MODEM_PROC_CTX);
 	offset = ipa->mem_offset + mem->offset;
@@ -147,6 +153,11 @@ static bool ipa_mem_id_valid(struct ipa *ipa, enum ipa_mem_id mem_id)
 	case IPA_MEM_END_MARKER:	/* pseudo region */
 		break;
 
+	case IPA_MEM_ZIP:
+		if (version == IPA_VERSION_2_6L)
+			return true;
+		break;
+
 	case IPA_MEM_STATS_TETHERING:
 	case IPA_MEM_STATS_DROP:
 		if (version < IPA_VERSION_4_0)
@@ -319,10 +330,15 @@ int ipa_mem_config(struct ipa *ipa)
 	/* Check the advertised location and size of the shared memory area */
 	val = ioread32(ipa->reg_virt + ipa_reg_shared_mem_size_offset(ipa->version));
 
-	/* The fields in the register are in 8 byte units */
-	ipa->mem_offset = 8 * u32_get_bits(val, SHARED_MEM_BADDR_FMASK);
-	/* Make sure the end is within the region's mapped space */
-	mem_size = 8 * u32_get_bits(val, SHARED_MEM_SIZE_FMASK);
+	if (IPA_VERSION_RANGE(ipa->version, 2_0, 2_6L)) {
+		/* The fields in the register are in 8 byte units */
+		ipa->mem_offset = 8 * u32_get_bits(val, SHARED_MEM_BADDR_FMASK);
+		/* Make sure the end is within the region's mapped space */
+		mem_size = 8 * u32_get_bits(val, SHARED_MEM_SIZE_FMASK);
+	} else {
+		ipa->mem_offset = u32_get_bits(val, SHARED_MEM_BADDR_FMASK);
+		mem_size = u32_get_bits(val, SHARED_MEM_SIZE_FMASK);
+	}
 
 	/* If the sizes don't match, issue a warning */
 	if (ipa->mem_offset + mem_size < ipa->mem_size) {
@@ -564,6 +580,10 @@ static int ipa_smem_init(struct ipa *ipa, u32 item, size_t size)
 		return -EINVAL;
 	}
 
+	/* IPA v2.6L does not use IOMMU */
+	if (ipa->version <= IPA_VERSION_2_6L)
+		return 0;
+
 	domain = iommu_get_domain_for_dev(dev);
 	if (!domain) {
 		dev_err(dev, "no IOMMU domain found for SMEM\n");
@@ -591,6 +611,9 @@ static void ipa_smem_exit(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	struct iommu_domain *domain;
 
+	if (ipa->version <= IPA_VERSION_2_6L)
+		return;
+
 	domain = iommu_get_domain_for_dev(dev);
 	if (domain) {
 		size_t size;
@@ -622,7 +645,8 @@ int ipa_mem_init(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 	ipa->mem_count = mem_data->local_count;
 	ipa->mem = mem_data->local;
 
-	ret = dma_set_mask_and_coherent(&ipa->pdev->dev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&ipa->pdev->dev, IPA_IS_64BIT(ipa->version) ?
+					DMA_BIT_MASK(64) : DMA_BIT_MASK(32));
 	if (ret) {
 		dev_err(dev, "error %d setting DMA mask\n", ret);
 		return ret;
diff --git a/drivers/net/ipa/ipa_mem.h b/drivers/net/ipa/ipa_mem.h
index 570bfdd99bff..be91cb38b6a8 100644
--- a/drivers/net/ipa/ipa_mem.h
+++ b/drivers/net/ipa/ipa_mem.h
@@ -47,8 +47,10 @@ enum ipa_mem_id {
 	IPA_MEM_UC_INFO,		/* 0 canaries */
 	IPA_MEM_V4_FILTER_HASHED,	/* 2 canaries */
 	IPA_MEM_V4_FILTER,		/* 2 canaries */
+	IPA_MEM_V4_FILTER_AP,		/* 2 canaries (IPA v2.0) */
 	IPA_MEM_V6_FILTER_HASHED,	/* 2 canaries */
 	IPA_MEM_V6_FILTER,		/* 2 canaries */
+	IPA_MEM_V6_FILTER_AP,		/* 0 canaries (IPA v2.0) */
 	IPA_MEM_V4_ROUTE_HASHED,	/* 2 canaries */
 	IPA_MEM_V4_ROUTE,		/* 2 canaries */
 	IPA_MEM_V6_ROUTE_HASHED,	/* 2 canaries */
@@ -57,7 +59,8 @@ enum ipa_mem_id {
 	IPA_MEM_AP_HEADER,		/* 0 canaries, optional */
 	IPA_MEM_MODEM_PROC_CTX,		/* 2 canaries */
 	IPA_MEM_AP_PROC_CTX,		/* 0 canaries */
-	IPA_MEM_MODEM,			/* 0/2 canaries */
+	IPA_MEM_ZIP,			/* 1 canary (IPA v2.6L) */
+	IPA_MEM_MODEM,			/* 0-2 canaries */
 	IPA_MEM_UC_EVENT_RING,		/* 1 canary, optional */
 	IPA_MEM_PDN_CONFIG,		/* 0/2 canaries (IPA v4.0+) */
 	IPA_MEM_STATS_QUOTA_MODEM,	/* 2/4 canaries (IPA v4.0+) */
-- 
2.33.0

