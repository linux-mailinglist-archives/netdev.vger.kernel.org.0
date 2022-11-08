Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220A4620EA8
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbiKHLVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbiKHLVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:21:23 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C05348765;
        Tue,  8 Nov 2022 03:21:22 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id v1so20421282wrt.11;
        Tue, 08 Nov 2022 03:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/tAWvUh3bACKS66CbafmxHuHB+RwFUoKIkb6Nnl3VI=;
        b=pJi/X/S2VR9zzv8wA8jSY+PtBhfglW7IRRwJR5dZaE8dhCg+E4/SMK/SIXwwnkwlJV
         NvC08LsgRkdn84L9K8hhw5Osm1me8mksiOBLQixxTIpP2+3ntwTANHVaRFrHHrHsW5XJ
         4aAsA2fy8CjPnjASxqJ6cbEwhCy7VkASKF6TwhnXorb77CJE4E0rl7Jr0/7f299RmhCP
         phi6INOI2Kp84LAt7SlTIwFaD5JQXpVOwqYsoBcnDgcmNAd0H+hg1R9TYBdRX2WLjz5g
         XUyB7Ks4DeCucJjTfOSw2Z3oPGpNOHk0ZV6sPMv5mWLJBDldcdxZvEYdRV4fDmFWsPMq
         CzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z/tAWvUh3bACKS66CbafmxHuHB+RwFUoKIkb6Nnl3VI=;
        b=jIb1gu5nFEqje/23IFfxSKqcMCkRRjnWItSCQxXLJfSWJbUNoZwxT0hn3OHLIAJAA2
         PPPBiaEBpmFDDjmZQwvRDa7smVLs5iUQEx97vVgzxzv3xRjCqb6uGCyEQpKtV/zNi8N5
         MHkuN/PoUlOD2cry5CPWknn5I0mvU8vTogBYfV18nQWnZVnKK72W1zamaS7g3nh6bTkk
         0lUFrBbtiaULDx7iSLMc4UnrskThs5GC8942qZXNeZ05GuVPtbOx6zhzKTyD6CefdXUn
         koHkIWzuFdPcQcR2THdVqsDaneHu8SNU7ZUfr5lChRVT3B4QUy3/YQoPZcHqdInl+PhN
         I5jg==
X-Gm-Message-State: ACrzQf18BXjPthjEs+iMcyOhu7MU45R+KHLZMsDP8c9DOXBYkOofoDlP
        Dd+r5JPN3AfDXusg4EvfxFU=
X-Google-Smtp-Source: AMsMyM6H4m0SLm49k12JXPGxC7mjK+zWDsHKH/gL1FUohdfrq/1c3t7vw/LTGv8X3ZMrteA4FB2jOQ==
X-Received: by 2002:adf:eb04:0:b0:236:dd5e:e3a2 with SMTP id s4-20020adfeb04000000b00236dd5ee3a2mr27649822wrn.94.1667906480767;
        Tue, 08 Nov 2022 03:21:20 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id j13-20020a05600c190d00b003b47e8a5d22sm15884416wmq.23.2022.11.08.03.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 03:21:20 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns3: Fix spelling mistake "fliter" -> "filter"
Date:   Tue,  8 Nov 2022 11:21:19 +0000
Message-Id: <20221108112119.116182-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in struct member vlan_fliter_cap. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 987271da6e9b..991452f17235 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1341,7 +1341,7 @@ static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 					    HCLGE_CFG_SPEED_ABILITY_EXT_S);
 	cfg->speed_ability |= speed_ability_ext << SPEED_ABILITY_EXT_SHIFT;
 
-	cfg->vlan_fliter_cap = hnae3_get_field(__le32_to_cpu(req->param[1]),
+	cfg->vlan_filter_cap = hnae3_get_field(__le32_to_cpu(req->param[1]),
 					       HCLGE_CFG_VLAN_FLTR_CAP_M,
 					       HCLGE_CFG_VLAN_FLTR_CAP_S);
 
@@ -1607,7 +1607,7 @@ static int hclge_configure(struct hclge_dev *hdev)
 		hdev->wanted_umv_size = hdev->ae_dev->dev_specs.umv_size;
 	hdev->tx_spare_buf_size = cfg.tx_spare_buf_size;
 	hdev->gro_en = true;
-	if (cfg.vlan_fliter_cap == HCLGE_VLAN_FLTR_CAN_MDF)
+	if (cfg.vlan_filter_cap == HCLGE_VLAN_FLTR_CAN_MDF)
 		set_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps);
 
 	if (hnae3_ae_dev_fd_supported(hdev->ae_dev)) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 495b639b0dc2..d84e0891f664 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -336,7 +336,7 @@ struct hclge_tc_info {
 
 struct hclge_cfg {
 	u8 tc_num;
-	u8 vlan_fliter_cap;
+	u8 vlan_filter_cap;
 	u16 tqp_desc_num;
 	u16 rx_buf_len;
 	u16 vf_rss_size_max;
-- 
2.38.1

