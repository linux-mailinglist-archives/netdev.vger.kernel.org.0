Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E671F5788E
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfF0Acp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbfF0Aco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:32:44 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6410A2083B;
        Thu, 27 Jun 2019 00:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595563;
        bh=O5KTkT4vc0D4rJd7tdvjPusn+yjaygrsf6kjYXsCrz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdbYfOk5VkuXywKtUovW4bzHivW1QFDxz5CUohxzc1E/FOuClD1r7M6cApOOqkd0P
         8DQTLPiRx6LPGlgm24bjsvanfIs+A54omj9EDK6qpj+30rNvGPuCK/GkjkZboT3ozL
         eVlcpKF2LpV/qje4XultTQF/xRlnHTpelGPGqj7s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Estevam <festevam@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 41/95] can: flexcan: Remove unneeded registration message
Date:   Wed, 26 Jun 2019 20:29:26 -0400
Message-Id: <20190627003021.19867-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit eb503004a7e563d543c9cb869907156de7efe720 ]

Currently the following message is observed when the flexcan
driver is probed:

flexcan 2090000.flexcan: device registered (reg_base=(ptrval), irq=23)

The reason for printing 'ptrval' is explained at
Documentation/core-api/printk-formats.rst:

"Pointers printed without a specifier extension (i.e unadorned %p) are
hashed to prevent leaking information about the kernel memory layout. This
has the added benefit of providing a unique identifier. On 64-bit machines
the first 32 bits are zeroed. The kernel will print ``(ptrval)`` until it
gathers enough entropy."

Instead of passing %pK, which can print the correct address, simply
remove the entire message as it is not really that useful.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 1c66fb2ad76b..05e5609f87f8 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1583,9 +1583,6 @@ static int flexcan_probe(struct platform_device *pdev)
 			dev_dbg(&pdev->dev, "failed to setup stop-mode\n");
 	}
 
-	dev_info(&pdev->dev, "device registered (reg_base=%p, irq=%d)\n",
-		 priv->regs, dev->irq);
-
 	return 0;
 
  failed_register:
-- 
2.20.1

