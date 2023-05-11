Return-Path: <netdev+bounces-1916-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 948C86FF850
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:22:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEF981C20F94
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA84C9449;
	Thu, 11 May 2023 17:21:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC639446
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 17:21:19 +0000 (UTC)
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BA95BA9;
	Thu, 11 May 2023 10:21:18 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-7577e7a83a2so272170085a.3;
        Thu, 11 May 2023 10:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683825677; x=1686417677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bpdAEUQYYO0a7ohkNF62coLjmwkAs5glhLFErKnjy5M=;
        b=irH4Ua7z1p7h0AXa/G74HKXN+3eXVGleORwxeYmvLinFxbH342AJGEGXBUo+3O+fKF
         nBxWaaMZiAGULVAT0ip6lY1NCyKhQVeUxEMxoDUSjVYR23ub3zIw32Bco2tJOpS7G0ZT
         wJz2W5QpnxE2TPN7qsYXuZ/VMaUM+/VUiWx3GLPKg3dWex9mXI22V7usdFp/Hd/H7YB/
         V7zUkqOal9nysPBl4wNAzlwdi8+vkODnpdl8KvUSe2vQw+XZiHFEp8lvMGdz/JN8BsYQ
         LLNnSYjo53QuaRgchQmHvC2XvpZ1CglmdjpOCzjZGjKMTzB8V9e2bSLBsoCiCJJxDA/D
         G9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683825677; x=1686417677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bpdAEUQYYO0a7ohkNF62coLjmwkAs5glhLFErKnjy5M=;
        b=E+gS6TGvpsS0VvHMehbqk8NCqR+0ondLwKg0IJZCePMkz++NTtH2laSr7AhDBcrhU5
         o9jQHO/GsOwsRxJsLu3dmIiw7ywtb3j0Jd/fJbGp5U+AuLbg0m2WhGmUaC3Yo1oU7ZyN
         4yAb/vPl50t22qDriwu/fkcEZ8lXZvYvA8x9km1WCWy51UUiCzFCHayw3nq1ceGNOmB9
         cBMvVH7TnJnF+zVISE2k/UkpWzE1YLg0YzHGUvvBYsELcTKZ1+IndnMSM9v8+7MVhBBY
         zZa3yLS8Rl+X5wF6OU1X5W3DeGvCxQGEf8SVeu+eF56ZR0Vu11h96hqBfc7BwEH16IsL
         PXvg==
X-Gm-Message-State: AC+VfDxBC13lJOKH4H0IfA10Q+Rbcq1wBCdMJUbNQcBfuvqfz1AYN3Hr
	DONCuoIQsV8E2zcon6HSw7k7+oCSz+w=
X-Google-Smtp-Source: ACHHUZ5+GPpwHFAaQNdBoivhYkMjoXJcvFRZA/a/nxTVKFiM/E2Prm2eITgawCizOQQtdc670/W3ww==
X-Received: by 2002:ad4:5e88:0:b0:616:2ff9:4826 with SMTP id jl8-20020ad45e88000000b006162ff94826mr35905433qvb.18.1683825677149;
        Thu, 11 May 2023 10:21:17 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j7-20020a0ce007000000b0062168714c8fsm462822qvk.120.2023.05.11.10.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 10:21:16 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Peter Geis <pgwipeout@gmail.com>,
	Frank <Frank.Sae@motor-comm.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v3 1/3] net: phy: Allow drivers to always call into ->suspend()
Date: Thu, 11 May 2023 10:21:08 -0700
Message-Id: <20230511172110.2243275-2-f.fainelli@gmail.com>
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

A few PHY drivers are currently attempting to not suspend the PHY when
Wake-on-LAN is enabled, however that code is not currently executing at
all due to an early check in phy_suspend().

This prevents PHY drivers from making an appropriate decisions and put
the hardware into a low power state if desired.

In order to allow the PHY drivers to opt into getting their ->suspend
routine to be called, add a PHY_ALWAYS_CALL_SUSPEND bit which can be
set. A boolean that tracks whether the PHY or the attached MAC has
Wake-on-LAN enabled is also provided for convenience.

If phydev::wol_enabled then the PHY shall not prevent its own
Wake-on-LAN detection logic from working and shall not prevent the
Ethernet MAC from receiving packets for matching.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 5 +++--
 include/linux/phy.h          | 4 ++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 17d0d0555a79..8852b0c53114 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1860,9 +1860,10 @@ int phy_suspend(struct phy_device *phydev)
 	if (phydev->suspended)
 		return 0;
 
-	/* If the device has WOL enabled, we cannot suspend the PHY */
 	phy_ethtool_get_wol(phydev, &wol);
-	if (wol.wolopts || (netdev && netdev->wol_enabled))
+	phydev->wol_enabled = wol.wolopts || (netdev && netdev->wol_enabled);
+	/* If the device has WOL enabled, we cannot suspend the PHY */
+	if (phydev->wol_enabled && !(phydrv->flags & PHY_ALWAYS_CALL_SUSPEND))
 		return -EBUSY;
 
 	if (!phydrv || !phydrv->suspend)
diff --git a/include/linux/phy.h b/include/linux/phy.h
index c5a0dc829714..e0df8b3c2bdb 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -86,6 +86,7 @@ extern const int phy_10gbit_features_array[1];
 #define PHY_IS_INTERNAL		0x00000001
 #define PHY_RST_AFTER_CLK_EN	0x00000002
 #define PHY_POLL_CABLE_TEST	0x00000004
+#define PHY_ALWAYS_CALL_SUSPEND	0x00000008
 #define MDIO_DEVICE_IS_PHY	0x80000000
 
 /**
@@ -548,6 +549,8 @@ struct macsec_ops;
  * @downshifted_rate: Set true if link speed has been downshifted.
  * @is_on_sfp_module: Set true if PHY is located on an SFP module.
  * @mac_managed_pm: Set true if MAC driver takes of suspending/resuming PHY
+ * @wol_enabled: Set to true if the PHY or the attached MAC have Wake-on-LAN
+ * 		 enabled.
  * @state: State of the PHY for management purposes
  * @dev_flags: Device-specific flags used by the PHY driver.
  *
@@ -644,6 +647,7 @@ struct phy_device {
 	unsigned downshifted_rate:1;
 	unsigned is_on_sfp_module:1;
 	unsigned mac_managed_pm:1;
+	unsigned wol_enabled:1;
 
 	unsigned autoneg:1;
 	/* The most recently read link state */
-- 
2.34.1


