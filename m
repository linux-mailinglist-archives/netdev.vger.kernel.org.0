Return-Path: <netdev+bounces-1918-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D80D06FF853
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:22:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 939F128185E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B68A947B;
	Thu, 11 May 2023 17:21:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5E89472
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 17:21:25 +0000 (UTC)
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B5B8A4A;
	Thu, 11 May 2023 10:21:23 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 6a1803df08f44-61b58b6e864so77544956d6.3;
        Thu, 11 May 2023 10:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683825682; x=1686417682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SabCXeVjik/SQe8lEZKTulGkwrKo1Wd7M5yO8zFFbD4=;
        b=KVrpGiKK9kahGnyXBq9oEXMDboWTQfOgu8/459WM56vuFQ/HDXQ+87Hyn7QUUwDZ4U
         5n1Vygst+XHVPKZ/PmYi/wRHDHzpK+AWuxvb41w5vtHpWMPKZR7+x9tSJaUz46JboDj2
         OArx6ofpcLM0aweQMEHQF03JX80OlIaQ8Pe2UDBVL94td7BUNgHPuMlZoFgg/F6FtAt0
         1SmWSnop15jb0xwtln7CVqZB1VZbd3U/EYtfwWgL/tkEIv3eIJ/lHKD863dFXPuA/jEW
         8SfUrYX6oS389IGnLeeagAm+e2qcyDNL4X4YOsWOwKmIyP+Y3bsgVdu03RQBDEdDVle1
         GhMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683825682; x=1686417682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SabCXeVjik/SQe8lEZKTulGkwrKo1Wd7M5yO8zFFbD4=;
        b=gxbNT65d7J9TqqjBcMQ9yHwp8d8kX5YYNJ4rNJhDU7IPdmummLB/4MlrvkNmBpLCcN
         2LPdGAOzXJOJVLqkIw4j5Z8kktOba+wzt6YIoq8YJIZmDQ7SDdY25BjMeUj2E0IubFz6
         sf/u3sZPf26JDV3vg9hRJTLJQuboR5u5CyJOfmuTJP9N0Uio2Irp5vZQ1oH52GjW+3vl
         srrlSVm/eGoUiXXcW6h9JBN9YfVfzO5hEQz/tm/iII8uuJ3z7SnTNROU4N09ugRLzfHX
         YM2A9sSrLJDoMk6tSbh8cK1am+m5+k+uOifHEmTrb+evxfTTfZgjA7qdkT9sOI5BdySR
         ToMA==
X-Gm-Message-State: AC+VfDw3/3OthjakL7KRCnnYxD4QtrSh56N/dnLOwyPdZJkVtD1gQ0FQ
	v7ShbaLYNZKw21ys7Hni3DINOIzLdmE=
X-Google-Smtp-Source: ACHHUZ5414xAke2CWHd7H2AOAq1hZf2XDZplwb8S8lTVZuRwYevZUnLFRKY1JntsXwWblMQ0Y3XQEA==
X-Received: by 2002:a05:6214:1243:b0:5c5:1a25:edf0 with SMTP id r3-20020a056214124300b005c51a25edf0mr34929330qvv.26.1683825682330;
        Thu, 11 May 2023 10:21:22 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j7-20020a0ce007000000b0062168714c8fsm462822qvk.120.2023.05.11.10.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 10:21:21 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Peter Geis <pgwipeout@gmail.com>,
	Frank <Frank.Sae@motor-comm.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v3 3/3] net: bcmgenet: Add support for PHY-based Wake-on-LAN
Date: Thu, 11 May 2023 10:21:10 -0700
Message-Id: <20230511172110.2243275-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230511172110.2243275-1-f.fainelli@gmail.com>
References: <20230511172110.2243275-1-f.fainelli@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If available, interrogate the PHY to find out whether we can use it for
Wake-on-LAN. This can be a more power efficient way of implementing
that feature, especially when the MAC is powered off in low power
states.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 3a4b6cb7b7b9..7a41cad5788f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -42,6 +42,12 @@ void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct device *kdev = &priv->pdev->dev;
 
+	if (dev->phydev) {
+		phy_ethtool_get_wol(dev->phydev, wol);
+		if (wol->supported)
+			return;
+	}
+
 	if (!device_can_wakeup(kdev)) {
 		wol->supported = 0;
 		wol->wolopts = 0;
@@ -63,6 +69,14 @@ int bcmgenet_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct device *kdev = &priv->pdev->dev;
+	int ret;
+
+	/* Try Wake-on-LAN from the PHY first */
+	if (dev->phydev) {
+		ret = phy_ethtool_set_wol(dev->phydev, wol);
+		if (ret != -EOPNOTSUPP)
+			return ret;
+	}
 
 	if (!device_can_wakeup(kdev))
 		return -ENOTSUPP;
-- 
2.34.1


