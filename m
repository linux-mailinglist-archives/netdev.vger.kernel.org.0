Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8699A26FB10
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgIRK6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgIRK6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:58:17 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DCBC06174A
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:16 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id i1so5704083edv.2
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TQIQa0gS3WPmmxwptczUkgj44MFbqm0AWi5fXpLCy60=;
        b=JH1+12xyyf6hW+NsK6HFSMuJ9Jir+C8K4xXkmsq2n1YgKHKSTkAiJsxBCTnot3g2mY
         sWCKaX7IjMcjkOcaR0IKNRVmoNBZAayssfe4igValyPF1uQmNmSCe6PAb0ANpT4IiJkA
         Op/WvCB9Fler6UUyHW0uJkwa4lbP564gi9QJUZUQb8LJUfSmkwJ71ouJif0dNcxlg4UZ
         VtUi2tKxdkAuIPp1kkaitHG+7GCC2X5qq2/V4elKo4or1R3xC8yIjc9Vm7g41SwgKfFH
         ICztOvnLcPuYvqB+SCMZDWMWtXvRfPSoaJTTDffXPfF2Soul/h5NvFYsh03SyJGIqagd
         NzUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TQIQa0gS3WPmmxwptczUkgj44MFbqm0AWi5fXpLCy60=;
        b=KGDKJJB8qOWxPl41tTU23Zkbj4EAKNdHQTignXzzswCz6vTH4Ena8cE0Yba8o6uTlL
         jCkDUjpyvZ3C5ArLfTvT5chpDYz1TQffi6NJxJ1qWjyPSPEbI1xV66yBviibLFUTRwOA
         Ma5n3GXjfYLxv7clCuX5pIHqCvO+xXX6SCipj/ahFx+lKz9aP1UggiRn2HNMUGU1XVt7
         Oa+PHKCXxwJXQDPl9APvdV7iDMh7PZRyzsc0OvrHq3uCMUbdBZMbfIUBFbobO5KYl3Zv
         PNo171LrJkCAbSNC5TqNadVCdTWsJadEplZq8lC/4mwcyLRwW5TtSceRHjpBp5kYEeml
         K6yA==
X-Gm-Message-State: AOAM532MAa8ajOngzIdRJUJQVBUvkLkbFx4JGqycdbdMyI38iRojSjnf
        Lpj6JwsYSGRxyk/+XONEMyM=
X-Google-Smtp-Source: ABdhPJwCBYeSgbzF0G1o8VtTm1Dty3V4jWLcf3pOBPEQ3XxZUmp2o00uki4a6EhgDhfgM4fIxWglyA==
X-Received: by 2002:a05:6402:1515:: with SMTP id f21mr38914042edw.175.1600426695511;
        Fri, 18 Sep 2020 03:58:15 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k1sm1995086eji.20.2020.09.18.03.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:58:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net-next 11/11] net: dsa: seville: build as separate module
Date:   Fri, 18 Sep 2020 13:57:53 +0300
Message-Id: <20200918105753.3473725-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918105753.3473725-1-olteanv@gmail.com>
References: <20200918105753.3473725-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Seville does not need to depend on PCI or on the ENETC MDIO controller.
There will also be other compile-time differences in the future.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/Kconfig           | 22 ++++++++++++--------
 drivers/net/dsa/ocelot/Makefile          |  6 +++++-
 drivers/net/dsa/ocelot/felix.c           | 26 ------------------------
 drivers/net/dsa/ocelot/felix.h           |  2 --
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  6 +++++-
 drivers/net/dsa/ocelot/seville_vsc9953.c |  6 +++++-
 6 files changed, 29 insertions(+), 39 deletions(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index e19718d4a7d4..c110e82a7973 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -10,11 +10,17 @@ config NET_DSA_MSCC_FELIX
 	select FSL_ENETC_MDIO
 	select PCS_LYNX
 	help
-	  This driver supports network switches from the Vitesse /
-	  Microsemi / Microchip Ocelot family of switching cores that are
-	  connected to their host CPU via Ethernet.
-	  The following switches are supported:
-	  - VSC9959 (Felix): embedded as a PCIe function of the NXP LS1028A
-	    ENETC integrated endpoint.
-	  - VSC9953 (Seville): embedded as a platform device on the
-	    NXP T1040 SoC.
+	  This driver supports the VSC9959 (Felix) switch, which is embedded as
+	  a PCIe function of the NXP LS1028A ENETC RCiEP.
+
+config NET_DSA_MSCC_SEVILLE
+	tristate "Ocelot / Seville Ethernet switch support"
+	depends on NET_DSA
+	depends on NET_VENDOR_MICROSEMI
+	depends on HAS_IOMEM
+	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_TAG_OCELOT
+	select PCS_LYNX
+	help
+	  This driver supports the VSC9953 (Seville) switch, which is embedded
+	  as a platform device on the NXP T1040 SoC.
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index ec57a5a12330..f6dd131e7491 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -1,7 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_MSCC_FELIX) += mscc_felix.o
+obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
 
 mscc_felix-objs := \
 	felix.o \
-	felix_vsc9959.o \
+	felix_vsc9959.o
+
+mscc_seville-objs := \
+	felix.o \
 	seville_vsc9953.o
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index fb1b3e117c78..5f395d4119ac 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -788,29 +788,3 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.cls_flower_stats	= felix_cls_flower_stats,
 	.port_setup_tc		= felix_port_setup_tc,
 };
-
-static int __init felix_init(void)
-{
-	int err;
-
-	err = pci_register_driver(&felix_vsc9959_pci_driver);
-	if (err)
-		return err;
-
-	err = platform_driver_register(&seville_vsc9953_driver);
-	if (err)
-		return err;
-
-	return 0;
-}
-module_init(felix_init);
-
-static void __exit felix_exit(void)
-{
-	pci_unregister_driver(&felix_vsc9959_pci_driver);
-	platform_driver_unregister(&seville_vsc9953_driver);
-}
-module_exit(felix_exit);
-
-MODULE_DESCRIPTION("Felix Switch driver");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index d0b2043e0ccb..cc3ec83a600a 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -42,8 +42,6 @@ struct felix_info {
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
-extern struct pci_driver felix_vsc9959_pci_driver;
-extern struct platform_driver seville_vsc9953_driver;
 
 /* DSA glue / front-end for struct ocelot */
 struct felix {
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 38e0fba6bca8..79ddc4ba27a3 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1328,9 +1328,13 @@ static struct pci_device_id felix_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, felix_ids);
 
-struct pci_driver felix_vsc9959_pci_driver = {
+static struct pci_driver felix_vsc9959_pci_driver = {
 	.name		= "mscc_felix",
 	.id_table	= felix_ids,
 	.probe		= felix_pci_probe,
 	.remove		= felix_pci_remove,
 };
+module_pci_driver(felix_vsc9959_pci_driver);
+
+MODULE_DESCRIPTION("Felix Switch driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 23f66bb1ab4e..650f7c0e6e6a 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1110,7 +1110,7 @@ static const struct of_device_id seville_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, seville_of_match);
 
-struct platform_driver seville_vsc9953_driver = {
+static struct platform_driver seville_vsc9953_driver = {
 	.probe		= seville_probe,
 	.remove		= seville_remove,
 	.driver = {
@@ -1118,3 +1118,7 @@ struct platform_driver seville_vsc9953_driver = {
 		.of_match_table	= of_match_ptr(seville_of_match),
 	},
 };
+module_platform_driver(seville_vsc9953_driver);
+
+MODULE_DESCRIPTION("Seville Switch driver");
+MODULE_LICENSE("GPL v2");
-- 
2.25.1

