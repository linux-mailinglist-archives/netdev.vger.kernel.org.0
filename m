Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD7C166035
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgBTO7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgBTO7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:14 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE1F3206F4;
        Thu, 20 Feb 2020 14:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210754;
        bh=8WdzDejFLVIXTaQSyllfHhlIJqMh2J+chMaYVK1ObrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ung9EJJqDaelHhhU4TQtuG3PKpgqHOjr8vIehsEit4/wgwgoHCEU2H6IXdzADRC4M
         FaENSdBg6lF9nR5uIx39KNtscAhUMarKRMfq1x9AHoIZgZ7RxF7YL5V9MCApxVQnvB
         4Cp9vT4Lr4gWzmihYeSDSByScGXCPLs+Ucjgukm0=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 05/16] net/aeroflex: Clean ethtool_info struct assignments
Date:   Thu, 20 Feb 2020 16:58:44 +0200
Message-Id: <20200220145855.255704-6-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220145855.255704-1-leon@kernel.org>
References: <20200220145855.255704-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

If FW version is not available, it is enough to leave that field as
empty, there is no need to write N/A.

The driver version is replaced in favor of generally available
in-tree variant.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/aeroflex/greth.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 2a9f8643629c..bf546118dbc6 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1114,9 +1114,7 @@ static void greth_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *in

 	strlcpy(info->driver, dev_driver_string(greth->dev),
 		sizeof(info->driver));
-	strlcpy(info->version, "revision: 1.0", sizeof(info->version));
 	strlcpy(info->bus_info, greth->dev->bus->name, sizeof(info->bus_info));
-	strlcpy(info->fw_version, "N/A", sizeof(info->fw_version));
 }

 static void greth_get_regs(struct net_device *dev, struct ethtool_regs *regs, void *p)
--
2.24.1

