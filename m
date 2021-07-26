Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0262A3D65EB
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhGZQ76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbhGZQ7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 12:59:49 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAB3C0613D3
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 10:40:16 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id l11so9751315iln.4
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 10:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=igk/eHhWUPu9afoObyctlRd1/zpW6sRE3pcaziGyfBE=;
        b=SXEYKbo2WkONf7MIIa6qH5ZvPXdhBAWA2/mKCH/HBoyc9OoapZk4hDdOvNmXSh5crZ
         UkgzMAKZOQOqzxd1si3opZW91wJ+NvZ9AZtaW7ynQH57CC8JL8Bibt7Ps9MeN2NCsQVP
         aPBRun/tCJf8/2VqBF3PM4hc1ZUeXiSE/lzzwu5Xpp9/mX8qyhiboVihM/R/BYKV/By7
         5PDe6OQAvxWtsGaaPC/DASkAoSwO0f5nH7Dc3MJvLQrb+lc7gL8rkA5fPFuRUazSpcpZ
         Vs6K7saq/eC5i5BYC8biezs1HpueLDurDkPHxCGjXl8/cYgaKazOeQw/bCrWe835fssp
         04Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=igk/eHhWUPu9afoObyctlRd1/zpW6sRE3pcaziGyfBE=;
        b=aZrqEb8qITsvhGXdDJbSp7oIOURPLn3xnJ1dG7r9Cj5uOxYGcFYVHEOqmxeqFXRPXm
         O0r127+AayMRfXiLuxjD+FgrQF1VT0TvkCJUMmzy5fSH95maxIYASir2VnCFwReYW8wm
         XHnz1LhnJGLoiNOrUGuPh/d+tVvY8Lxi8eJvwSdp4A1N+q/UEX5EuJ8yYyD1QYxSnIJk
         NcIfD79AjYjfNkbVu6MPBBl7oFiOfpYlmFb3XYpYsnCXNbPw06sob9ChOL6wMhH986+N
         DVLSqlIDYWdB/pgddPtyC9yS3IXwGa6V97bLd9yFrkgKlWgd95uLIC39QbHNhu+/nFpa
         wK8A==
X-Gm-Message-State: AOAM533WYC+6/b4GcjppAwL3VdnS9MBJ4Tdw3/iyEOZQi4FUh8J1vDOQ
        1TrRRiGt6g4SgipixOCXkBaAfA==
X-Google-Smtp-Source: ABdhPJxKEVsUew/wG5ET94CSEdMVHiZaS+T7m9vgbnQ2XspBBvMnfyLWPhEcrfw963U7Heapz9Rljw==
X-Received: by 2002:a05:6e02:13e2:: with SMTP id w2mr13952711ilj.308.1627321216302;
        Mon, 26 Jul 2021 10:40:16 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l4sm202721ilh.41.2021.07.26.10.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 10:40:16 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     leon@kernel.org, bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] net: ipa: kill the remaining conditional validation code
Date:   Mon, 26 Jul 2021 12:40:09 -0500
Message-Id: <20210726174010.396765-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726174010.396765-1-elder@linaro.org>
References: <20210726174010.396765-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are only a few remaining spots that validate IPA code
conditional on whether a symbol is defined at compile time.
The checks are not expensive, so just build them always.

This completes the removal of all CONFIG_VALIDATE/CONFIG_VALIDATION
IPA code.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile       |  3 ---
 drivers/net/ipa/gsi.c          |  2 --
 drivers/net/ipa/gsi_trans.c    |  4 ----
 drivers/net/ipa/ipa_cmd.c      |  3 ---
 drivers/net/ipa/ipa_cmd.h      | 11 -----------
 drivers/net/ipa/ipa_main.c     |  2 --
 drivers/net/ipa/ipa_resource.c |  3 +--
 7 files changed, 1 insertion(+), 27 deletions(-)

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index 506f8d5cd4eeb..75435d40b9200 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -1,6 +1,3 @@
-# Un-comment the next line if you want to validate configuration data
-#ccflags-y		+=	-DIPA_VALIDATE
-
 obj-$(CONFIG_QCOM_IPA)	+=	ipa.o
 
 ipa-y			:=	ipa_main.o ipa_clock.o ipa_reg.o ipa_mem.o \
diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 427c68b2ad8f3..3de67ba066a68 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1964,7 +1964,6 @@ static void gsi_evt_ring_init(struct gsi *gsi)
 static bool gsi_channel_data_valid(struct gsi *gsi,
 				   const struct ipa_gsi_endpoint_data *data)
 {
-#ifdef IPA_VALIDATION
 	u32 channel_id = data->channel_id;
 	struct device *dev = gsi->dev;
 
@@ -2010,7 +2009,6 @@ static bool gsi_channel_data_valid(struct gsi *gsi,
 			channel_id, data->channel.event_count);
 		return false;
 	}
-#endif /* IPA_VALIDATION */
 
 	return true;
 }
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 8c795a6a85986..6127370facee5 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -90,14 +90,12 @@ int gsi_trans_pool_init(struct gsi_trans_pool *pool, size_t size, u32 count,
 {
 	void *virt;
 
-#ifdef IPA_VALIDATE
 	if (!size)
 		return -EINVAL;
 	if (count < max_alloc)
 		return -EINVAL;
 	if (!max_alloc)
 		return -EINVAL;
-#endif /* IPA_VALIDATE */
 
 	/* By allocating a few extra entries in our pool (one less
 	 * than the maximum number that will be requested in a
@@ -140,14 +138,12 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 	dma_addr_t addr;
 	void *virt;
 
-#ifdef IPA_VALIDATE
 	if (!size)
 		return -EINVAL;
 	if (count < max_alloc)
 		return -EINVAL;
 	if (!max_alloc)
 		return -EINVAL;
-#endif /* IPA_VALIDATE */
 
 	/* Don't let allocations cross a power-of-two boundary */
 	size = __roundup_pow_of_two(size);
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index bda8677eae88d..8900f91509fee 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -207,8 +207,6 @@ bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem, bool route)
 	return true;
 }
 
-#ifdef IPA_VALIDATE
-
 /* Validate the memory region that holds headers */
 static bool ipa_cmd_header_valid(struct ipa *ipa)
 {
@@ -343,7 +341,6 @@ bool ipa_cmd_data_valid(struct ipa *ipa)
 	return true;
 }
 
-#endif /* IPA_VALIDATE */
 
 int ipa_cmd_pool_init(struct gsi_channel *channel, u32 tre_max)
 {
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index ea723419c826b..69cd085d427db 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -68,8 +68,6 @@ struct ipa_cmd_info {
 bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
 			    bool route);
 
-#ifdef IPA_VALIDATE
-
 /**
  * ipa_cmd_data_valid() - Validate command-realted configuration is valid
  * @ipa:	- IPA pointer
@@ -78,15 +76,6 @@ bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
  */
 bool ipa_cmd_data_valid(struct ipa *ipa);
 
-#else /* !IPA_VALIDATE */
-
-static inline bool ipa_cmd_data_valid(struct ipa *ipa)
-{
-	return true;
-}
-
-#endif /* !IPA_VALIDATE */
-
 /**
  * ipa_cmd_pool_init() - initialize command channel pools
  * @channel:	AP->IPA command TX GSI channel pointer
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 9810c61a03202..ff5f3fab640d6 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -612,7 +612,6 @@ MODULE_DEVICE_TABLE(of, ipa_match);
  * */
 static void ipa_validate_build(void)
 {
-#ifdef IPA_VALIDATE
 	/* At one time we assumed a 64-bit build, allowing some do_div()
 	 * calls to be replaced by simple division or modulo operations.
 	 * We currently only perform divide and modulo operations on u32,
@@ -646,7 +645,6 @@ static void ipa_validate_build(void)
 	BUILD_BUG_ON(!ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY));
 	BUILD_BUG_ON(ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY) >
 			field_max(AGGR_GRANULARITY_FMASK));
-#endif /* IPA_VALIDATE */
 }
 
 static bool ipa_version_valid(enum ipa_version version)
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index 3b2dc216d3a68..e3da95d694099 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -29,7 +29,6 @@
 static bool ipa_resource_limits_valid(struct ipa *ipa,
 				      const struct ipa_resource_data *data)
 {
-#ifdef IPA_VALIDATION
 	u32 group_count;
 	u32 i;
 	u32 j;
@@ -65,7 +64,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 			if (resource->limits[j].min || resource->limits[j].max)
 				return false;
 	}
-#endif /* !IPA_VALIDATION */
+
 	return true;
 }
 
-- 
2.27.0

