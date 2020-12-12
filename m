Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B6B2D887C
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 18:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407632AbgLLQ5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 11:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406671AbgLLQ5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 11:57:50 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1BCC0613CF;
        Sat, 12 Dec 2020 08:57:10 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id k8so11825395ilr.4;
        Sat, 12 Dec 2020 08:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jxm7FjWLOK0LeZ5TONPRUQR10b19NPzc0gXLsmUtSk8=;
        b=L7SXmM5aaaq0mgJ+7/5AxBNsryueM9Onmbq14mL+cpuuNK6Fa4QlEwqesRlTLT6yAJ
         EHKJxfyOQlOFd27qg1+iZavvGPBnc8HkgIGVygzZKR3HLa8blBwnFEam7dXdPMtHVlN7
         5GaIAuW1W1njao8C5AMNNW0IisvO3oZtE7xZnRhUZzS0j0qwF57ZYPRQEBXYqcAvKXdL
         y3ZyuuCTCQ+hhiyVwcgWBSjbJEfQZoIod+ffxsXRgDtHSvIbBxQwT6bne26WGbgiIK4N
         dYY8dSHCLDfvXtaFfBuzSbzMeAao9sZqkiafR3FTqVZxjh91ufk2meZWopScwERPQFas
         f4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jxm7FjWLOK0LeZ5TONPRUQR10b19NPzc0gXLsmUtSk8=;
        b=iOsIkCz25W7BA0w4WunfIgRfZ4IE2/+vNTkPSY00eo6ZaGqH855Gap8PeaxsUdDXqk
         P0vCpOrlTBhfMHjUIlG8SztXPRN2gi7GEagzoVDeoNist4ld5PrUcOyQ1bDT6ebgqG2l
         n5K/nqz4VNJV/r2CIxQHIyLj5HGG2Rp1tdqbx8ybcboBLV2onYuls6uhhy1emBCAOkRz
         CU9IASy8qQ25dPx/rplsVV6+p+OjUXSGxS8OzHpKFhbqx2bznI3Nq5DHkV28afUjvjmS
         /rk4qxdvOvJ/3v4tDZy7Z5ICLGdB4Q2TZ5zjwMPQP+ZnJYIOuZ5VJntJDeZZfpcHe1rQ
         P//Q==
X-Gm-Message-State: AOAM533prmRAkKl/DB474ODx0JjnPp1QPWtDD20QX7yrk/xmtxCN6PwE
        MY08Ez7O652ii/xy+bv0fY7oT6qFVW7IOw==
X-Google-Smtp-Source: ABdhPJweNag0z8jUNTEBJfXTNWkbk9ca2ae0Kr7sLruYFI4q5hfR1er9PyJpV9gjnX8VUspYK0ghNw==
X-Received: by 2002:a92:495b:: with SMTP id w88mr22754631ila.196.1607792229218;
        Sat, 12 Dec 2020 08:57:09 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:f45d:df49:9a4c:4914])
        by smtp.gmail.com with ESMTPSA id p18sm7733201ile.27.2020.12.12.08.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Dec 2020 08:57:08 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     aford@beaconembedded.com, charles.stevens@logicpd.com,
        Adam Ford <aford173@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] ravb: Add support for optional txc_refclk
Date:   Sat, 12 Dec 2020 10:56:48 -0600
Message-Id: <20201212165648.166220-1-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SoC expects the txv_refclk is provided, but if it is provided
by a programmable clock, there needs to be a way to get and enable
this clock to operate.  It needs to be optional since it's only
necessary for those with programmable clocks.

Signed-off-by: Adam Ford <aford173@gmail.com>

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 7453b17a37a2..ddf3bc5164d2 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -994,6 +994,7 @@ struct ravb_private {
 	struct platform_device *pdev;
 	void __iomem *addr;
 	struct clk *clk;
+	struct clk *ref_clk;
 	struct mdiobb_ctrl mdiobb;
 	u32 num_rx_ring[NUM_RX_QUEUE];
 	u32 num_tx_ring[NUM_TX_QUEUE];
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index bd30505fbc57..4c3f95923ef2 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2148,6 +2148,18 @@ static int ravb_probe(struct platform_device *pdev)
 		goto out_release;
 	}
 
+	priv->ref_clk = devm_clk_get(&pdev->dev, "txc_refclk");
+	if (IS_ERR(priv->ref_clk)) {
+		if (PTR_ERR(priv->ref_clk) == -EPROBE_DEFER) {
+			/* for Probe defer return error */
+			error = PTR_ERR(priv->ref_clk);
+			goto out_release;
+		}
+		/* Ignore other errors since it's optional */
+	} else {
+		(void)clk_prepare_enable(priv->ref_clk);
+	}
+
 	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
 	ndev->min_mtu = ETH_MIN_MTU;
 
-- 
2.25.1

