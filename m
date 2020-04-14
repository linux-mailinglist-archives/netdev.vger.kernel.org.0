Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1751A83F4
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391188AbgDNP62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732405AbgDNP55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 11:57:57 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C88F52075E;
        Tue, 14 Apr 2020 15:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586879876;
        bh=I96PS4avC4yHbTbjbIG2KuiRcDUhH6NazFphAS0e4MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPcSY3xElAsmHsD5hKMYR5jMeo/aYx9gm+U/ZWYLaoCjDSuYEwPI+y0FgZT9tuwFU
         eGyKPtdXzBDt8Ok/tNoXzmyjLYDceNkXNTtBztCtvruquNBkmejCMTlr4o0mh03D60
         NCc5+KDfRyr7RQ90nGu2bJ4YrmvMzZRyl1ClnR6s=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Borislav Petkov <bp@suse.de>, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: [PATCH net-next 3/4] net/nfp: Update driver to use global kernel version
Date:   Tue, 14 Apr 2020 18:57:31 +0300
Message-Id: <20200414155732.1236944-4-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200414155732.1236944-1-leon@kernel.org>
References: <20200414155732.1236944-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Change nfp driver to use globally defined kernel version.

Reported-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c        | 3 ---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 4d282fc56009..7ff2ccbd43b0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -14,7 +14,6 @@
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/firmware.h>
-#include <linux/vermagic.h>
 #include <linux/vmalloc.h>
 #include <net/devlink.h>
 
@@ -31,7 +30,6 @@
 #include "nfp_net.h"
 
 static const char nfp_driver_name[] = "nfp";
-const char nfp_driver_version[] = VERMAGIC_STRING;
 
 static const struct pci_device_id nfp_pci_device_ids[] = {
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP6000,
@@ -920,4 +918,3 @@ MODULE_FIRMWARE("netronome/nic_AMDA0099-0001_1x10_1x25.nffw");
 MODULE_AUTHOR("Netronome Systems <oss-drivers@netronome.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("The Netronome Flow Processor (NFP) driver.");
-MODULE_VERSION(UTS_RELEASE);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 2779f1526d1e..a5aa3219d112 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -203,8 +203,6 @@ nfp_get_drvinfo(struct nfp_app *app, struct pci_dev *pdev,
 	char nsp_version[ETHTOOL_FWVERS_LEN] = {};
 
 	strlcpy(drvinfo->driver, pdev->driver->name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, nfp_driver_version, sizeof(drvinfo->version));
-
 	nfp_net_get_nspinfo(app, nsp_version);
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%s %s %s %s", vnic_version, nsp_version,
-- 
2.25.2

