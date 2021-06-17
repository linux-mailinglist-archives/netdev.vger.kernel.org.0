Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B6E3AB35C
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 14:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhFQMRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 08:17:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45186 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbhFQMRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 08:17:01 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1ltqv4-0005tS-6S; Thu, 17 Jun 2021 12:14:50 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jon Mason <jdmason@kudzu.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: neterion: vxge: remove redundant continue statement
Date:   Thu, 17 Jun 2021 13:14:49 +0100
Message-Id: <20210617121449.12496-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The continue statement at the end of a for-loop has no effect,
invert the if expression and remove the continue.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 0528b8f49061..82eef4c72f01 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3678,10 +3678,9 @@ static int vxge_config_vpaths(struct vxge_hw_device_config *device_config,
 			driver_config->vpath_per_dev = 1;
 
 		for (i = 0; i < VXGE_HW_MAX_VIRTUAL_PATHS; i++)
-			if (!vxge_bVALn(vpath_mask, i, 1))
-				continue;
-			else
+			if (vxge_bVALn(vpath_mask, i, 1))
 				default_no_vpath++;
+
 		if (default_no_vpath < driver_config->vpath_per_dev)
 			driver_config->vpath_per_dev = default_no_vpath;
 
-- 
2.31.1

