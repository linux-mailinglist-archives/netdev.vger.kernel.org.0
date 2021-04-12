Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3670135C787
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 15:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241585AbhDLN1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 09:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241174AbhDLN1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 09:27:03 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0EDC061574;
        Mon, 12 Apr 2021 06:26:45 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id r5so2797465ilb.2;
        Mon, 12 Apr 2021 06:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6stQHJumAX9IpA85olnqPlMQgoZlJcV7yJSibxNhYxs=;
        b=X19LBFEsB1YnZMaWEbOi6vt3YH2OPYgoFt2C4nGduZa3A+Um+0hSqPyzqgAL7ynixu
         Rf0wz+Y0nyOqBK7YOtPIiDiOTAasprbs0huCE7RoxI7J1kaZTcVFfR7JhnsjcNqWC0xV
         e4vBcNCUajiqnVILmfZMC3PEZ/h3uoURn7dfxhUme1u71owUli9HJFlnFT/dIhzFRLy2
         OOz2rZaLiIiOSSqRtYnWxUFjJ/PKR9dyRwf53wbtyLiT9MFujn/AhhJQUVDX3l/Y7GK2
         xe6wG2E2RzplzBmgvl+7khwc4o+69aI0428kt36I3drvK+3+yH4xvk0Wy4FkxCXYaeFz
         VFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6stQHJumAX9IpA85olnqPlMQgoZlJcV7yJSibxNhYxs=;
        b=MrgDC4U+w3niR5W6G7XDGMoLTDGh7zUA8MkIOraAXPY4bXjK+FuehI15Vs2/2Vvm5r
         t8bAm8LSJzlL7i9OHDHPm9C0/t7Kozm+Uvj1xd1jqADk+0f9U24s6ky/3ybBEk5g5loy
         1Nq34+1i+XFh0jxf1yKLASua7/1TB/VZeWFpKtTcLSJPefByTTd7GjKRJXO+E/vYjMLO
         Lfhtw1R3K2CTABapNbPq9UpGXjWZxBMscwTbTHhzIN6ClFX5R+dX7PgiVvHb+2B0VHJ1
         4EghO1cx3vYzRB+F6XLHgK7PoWwitWRbdqWO8w2LJ8D5P2iFyLEeuMUCxGQaapIDDZnL
         cU+w==
X-Gm-Message-State: AOAM533ertiW7CKGfQT9JgPElWEorVUfnEXRRYd/5iQ4UgW0Y5kzokl3
        jRAZjmZTQjOfzSSYNNFAH04n8C6xa+EEWg==
X-Google-Smtp-Source: ABdhPJxtXtVnD7jBbjK3qjQXDL4WhomCCX93LmqBxwKN1LTRZd4YKlh0yxvMXD26py3wHojzVix+qA==
X-Received: by 2002:a92:ca06:: with SMTP id j6mr5323636ils.234.1618234004657;
        Mon, 12 Apr 2021 06:26:44 -0700 (PDT)
Received: from aford-OptiPlex-7050.logicpd.com ([174.46.170.158])
        by smtp.gmail.com with ESMTPSA id x8sm5261118iov.7.2021.04.12.06.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 06:26:44 -0700 (PDT)
From:   Adam Ford <aford173@gmail.com>
To:     netdev@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V4 2/2] net: ethernet: ravb: Enable optional refclk
Date:   Mon, 12 Apr 2021 08:26:19 -0500
Message-Id: <20210412132619.7896-2-aford173@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210412132619.7896-1-aford173@gmail.com>
References: <20210412132619.7896-1-aford173@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For devices that use a programmable clock for the AVB reference clock,
the driver may need to enable them.  Add code to find the optional clock
and enable it when available.

Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

---
V4:  Eliminate the NULL check when disabling refclk, and add a line
     to disable the refclk if there is a failure after it's been
     initialized.

V3:  Change 'avb' to 'AVB'
     Remove unnessary else statement and pointer maniupluation when
     enabling the refclock.
     Add disable_unprepare call in remove funtion.

V2:  The previous patch to fetch the fclk was dropped.  In its place
     is code to enable the refclk

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index cb47e68c1a3e..86a1eb0634e8 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -993,6 +993,7 @@ struct ravb_private {
 	struct platform_device *pdev;
 	void __iomem *addr;
 	struct clk *clk;
+	struct clk *refclk;
 	struct mdiobb_ctrl mdiobb;
 	u32 num_rx_ring[NUM_RX_QUEUE];
 	u32 num_tx_ring[NUM_TX_QUEUE];
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index eb0c03bdb12d..1409ae986aa2 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2148,6 +2148,13 @@ static int ravb_probe(struct platform_device *pdev)
 		goto out_release;
 	}
 
+	priv->refclk = devm_clk_get_optional(&pdev->dev, "refclk");
+	if (IS_ERR(priv->refclk)) {
+		error = PTR_ERR(priv->refclk);
+		goto out_release;
+	}
+	clk_prepare_enable(priv->refclk);
+
 	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
 	ndev->min_mtu = ETH_MIN_MTU;
 
@@ -2244,6 +2251,7 @@ static int ravb_probe(struct platform_device *pdev)
 	if (chip_id != RCAR_GEN2)
 		ravb_ptp_stop(ndev);
 out_release:
+	clk_disable_unprepare(priv->refclk);
 	free_netdev(ndev);
 
 	pm_runtime_put(&pdev->dev);
@@ -2260,6 +2268,8 @@ static int ravb_remove(struct platform_device *pdev)
 	if (priv->chip_id != RCAR_GEN2)
 		ravb_ptp_stop(ndev);
 
+	clk_disable_unprepare(priv->refclk);
+
 	dma_free_coherent(ndev->dev.parent, priv->desc_bat_size, priv->desc_bat,
 			  priv->desc_bat_dma);
 	/* Set reset mode */
-- 
2.17.1

