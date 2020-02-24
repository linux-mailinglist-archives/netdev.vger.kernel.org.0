Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65EB916B49A
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgBXWyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:54:17 -0500
Received: from foss.arm.com ([217.140.110.172]:43928 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbgBXWyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 17:54:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88BB431B;
        Mon, 24 Feb 2020 14:54:16 -0800 (PST)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 809533F534;
        Mon, 24 Feb 2020 14:54:16 -0800 (PST)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net, andrew@lunn.ch,
        hkallweit1@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Subject: [PATCH v2 6/6] net: bcmgenet: reduce severity of missing clock warnings
Date:   Mon, 24 Feb 2020 16:54:03 -0600
Message-Id: <20200224225403.1650656-7-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224225403.1650656-1-jeremy.linton@arm.com>
References: <20200224225403.1650656-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If one types "failed to get enet clock" or similar into google
there are ~370k hits. The vast majority are people debugging
problems unrelated to this adapter, or bragging about their
rpi's. Further, the DT clock bindings here are optional.

Given that its not a fatal situation with common DT based
systems, lets reduce the severity so people aren't seeing failure
messages in everyday operation.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 412156745b5c..80feb20a2e53 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3562,7 +3562,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	priv->clk = devm_clk_get(&priv->pdev->dev, "enet");
 	if (IS_ERR(priv->clk)) {
-		dev_warn(&priv->pdev->dev, "failed to get enet clock\n");
+		dev_dbg(&priv->pdev->dev, "failed to get enet clock\n");
 		priv->clk = NULL;
 	}
 
@@ -3586,13 +3586,13 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	priv->clk_wol = devm_clk_get(&priv->pdev->dev, "enet-wol");
 	if (IS_ERR(priv->clk_wol)) {
-		dev_warn(&priv->pdev->dev, "failed to get enet-wol clock\n");
+		dev_dbg(&priv->pdev->dev, "failed to get enet-wol clock\n");
 		priv->clk_wol = NULL;
 	}
 
 	priv->clk_eee = devm_clk_get(&priv->pdev->dev, "enet-eee");
 	if (IS_ERR(priv->clk_eee)) {
-		dev_warn(&priv->pdev->dev, "failed to get enet-eee clock\n");
+		dev_dbg(&priv->pdev->dev, "failed to get enet-eee clock\n");
 		priv->clk_eee = NULL;
 	}
 
-- 
2.24.1

