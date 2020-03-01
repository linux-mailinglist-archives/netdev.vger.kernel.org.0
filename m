Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 781D2174DC4
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgCAOp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgCAOp1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:27 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D080F24680;
        Sun,  1 Mar 2020 14:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073927;
        bh=9KtukmZijRId5kiusFi5hitm4NG8edEvNEd26bj3bBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zw72cCDa0zknjOpYLG6PRt/ozVjQIKp/A9+OmsXjde0KQ7kHARKtnAF8SVO+90kDN
         ZAStzf4/qaopChRLxwbPaq5XHA4FDFW5wwrp9CL/4rF9OzXH1QaFDiLIbxjvcPcb+S
         A1U4KqT/NYwjl5ySKw1ql+msyRRljyBEoqLJbrgE=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>, netdev@vger.kernel.org,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 09/23] net/chelsio: Don't set N/A for not available FW
Date:   Sun,  1 Mar 2020 16:44:42 +0200
Message-Id: <20200301144457.119795-10-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200301144457.119795-1-leon@kernel.org>
References: <20200301144457.119795-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

There is no need to set N/A if FW is not available.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index f3acdce74d43..2cf35696b1c4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -174,9 +174,7 @@ static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 		sizeof(info->bus_info));
 	info->regdump_len = get_regs_len(dev);
 
-	if (!adapter->params.fw_vers)
-		strcpy(info->fw_version, "N/A");
-	else
+	if (adapter->params.fw_vers)
 		snprintf(info->fw_version, sizeof(info->fw_version),
 			 "%u.%u.%u.%u, TP %u.%u.%u.%u",
 			 FW_HDR_FW_VER_MAJOR_G(adapter->params.fw_vers),
-- 
2.24.1

