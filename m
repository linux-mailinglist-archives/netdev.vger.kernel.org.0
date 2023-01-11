Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCF4665BE9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 13:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjAKM7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 07:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbjAKM7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 07:59:09 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAE41C4;
        Wed, 11 Jan 2023 04:59:09 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id tz12so36609270ejc.9;
        Wed, 11 Jan 2023 04:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eRmDb6MnASCSulRT3fi8JUMdCbchYa2gNuJnz0uHb/k=;
        b=fo4u7NpMztI3D6iH4IlF9kEA//Q1Xu5yE0L5w3SK3+9tSdGAAOeYt5MzvQBwLd4LNr
         n1Hh2dMb29EOawRmFwuyyEfc2FSoZLRSl7JfIQw1DFQJC3YOeVgRfu9aPC4Z4ijtjdU7
         KOeu2l1sPCqWdU2nkw7rVZ+e53zy+Tgeb3krc+gnVVkDvT5ZKPViWpdqfnsfcEm0rTvk
         +1PW+iM9xB9e4AJWz3myp1xi70VDViAHQb8M7SIRaoSg6OPwqjJyTk1NMSMJyYGHSjTG
         o9jwOKvpvYTRgiPbAOXFn/Ya2nAKGA7Z9SSFS/t2NOjPd40eaULlOJrseDpQ74/QqAaP
         g0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eRmDb6MnASCSulRT3fi8JUMdCbchYa2gNuJnz0uHb/k=;
        b=W1sQJbNNFMXOMYGjlXIeIWyWNxjb7LpuMLTN4MdDUF9VAP3n5BLAaTmsjJNnxtRZY1
         9OoTBky+CZKqKVEupjzuy7rIoJjln68C2ZXx3DxGtVHDMy82zuImKwkXnfWzZa7Ky9qc
         mL9rWi222WJfSh2YBzzyJbw4bSRKGYxdwbDDby4AHkS7hP1pTgmCqGcm3wA8USzMcbVi
         5fwT/uXq24QC6vBXi00q3pRWY4mc5aEvJCf1Z9v/j8ltbOdyPa/lyt3njaGQ/V9t0Tz4
         9Ym6MrOGhk8cBNOI8mjbc0MuHWZw/uxJ7oFOoefK4dhPcCH9IVPJ3GgjjoGZfqlTHn5T
         tGpA==
X-Gm-Message-State: AFqh2ko6RVBbvvepPNUSiXcg0vDXLmGYT0C16FK8EkzjulJnq2Vm0FUU
        ZG/BaPxmxsp7MuQdbgClLzk=
X-Google-Smtp-Source: AMrXdXuhx9eLNNpIeiI4cVc6fom2CqGdYXuZgFk614ouDSLnWZ2I1LRl70zcG2CqRNxivizJ7mZa1Q==
X-Received: by 2002:a17:907:a70b:b0:7c1:98d:a8a3 with SMTP id vw11-20020a170907a70b00b007c1098da8a3mr54765314ejc.7.1673441947633;
        Wed, 11 Jan 2023 04:59:07 -0800 (PST)
Received: from felia.fritz.box ([2a02:810d:2a40:1104:a47e:7f3e:6b25:bafb])
        by smtp.gmail.com with ESMTPSA id l9-20020a1709063d2900b0084d4a60b3ccsm3345631ejf.115.2023.01.11.04.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 04:59:07 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Dimitris Michailidis <dmichail@fungible.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Simon Horman <simon.horman@corigine.com>,
        oss-drivers@corigine.com, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net: remove redundant config PCI dependency for some network driver configs
Date:   Wed, 11 Jan 2023 13:58:55 +0100
Message-Id: <20230111125855.19020-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reviewing dependencies in some Kconfig files, I noticed the redundant
dependency "depends on PCI && PCI_MSI". The config PCI_MSI has always,
since its introduction, been dependent on the config PCI. So, it is
sufficient to just depend on PCI_MSI, and know that the dependency on PCI
is implicitly implied.

Reduce the dependencies of some network driver configs.
No functional change and effective change of Kconfig dependendencies.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 drivers/net/ethernet/freescale/enetc/Kconfig | 4 ++--
 drivers/net/ethernet/fungible/funeth/Kconfig | 2 +-
 drivers/net/ethernet/netronome/Kconfig       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index cdc0ff89388a..6f6d07324d3b 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config FSL_ENETC
 	tristate "ENETC PF driver"
-	depends on PCI && PCI_MSI
+	depends on PCI_MSI
 	select FSL_ENETC_IERB
 	select FSL_ENETC_MDIO
 	select PHYLINK
@@ -16,7 +16,7 @@ config FSL_ENETC
 
 config FSL_ENETC_VF
 	tristate "ENETC VF driver"
-	depends on PCI && PCI_MSI
+	depends on PCI_MSI
 	select FSL_ENETC_MDIO
 	select PHYLINK
 	select DIMLIB
diff --git a/drivers/net/ethernet/fungible/funeth/Kconfig b/drivers/net/ethernet/fungible/funeth/Kconfig
index c72ad9386400..e742e7663449 100644
--- a/drivers/net/ethernet/fungible/funeth/Kconfig
+++ b/drivers/net/ethernet/fungible/funeth/Kconfig
@@ -5,7 +5,7 @@
 
 config FUN_ETH
 	tristate "Fungible Ethernet device driver"
-	depends on PCI && PCI_MSI
+	depends on PCI_MSI
 	depends on TLS && TLS_DEVICE || TLS_DEVICE=n
 	select NET_DEVLINK
 	select FUN_CORE
diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
index e785c00b5845..d03d6e96f730 100644
--- a/drivers/net/ethernet/netronome/Kconfig
+++ b/drivers/net/ethernet/netronome/Kconfig
@@ -18,7 +18,7 @@ if NET_VENDOR_NETRONOME
 
 config NFP
 	tristate "Netronome(R) NFP4000/NFP6000 NIC driver"
-	depends on PCI && PCI_MSI
+	depends on PCI_MSI
 	depends on VXLAN || VXLAN=n
 	depends on TLS && TLS_DEVICE || TLS_DEVICE=n
 	select NET_DEVLINK
-- 
2.17.1

