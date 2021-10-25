Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2299F439C9A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbhJYREO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:04:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234462AbhJYRDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:03:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 722F060F9D;
        Mon, 25 Oct 2021 17:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181252;
        bh=zymw0Cd5SrCynRtyeFd4YXZw31nviPLgRFKiy/lGjyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+acq3Hle1lN5dbZdZh5S3q2Vaj7X+QrqslkPfObemZ7BmmRuKXv5tILuqYZhw02c
         FM04YoO3AhTNVO0bBkV8aAxV1FdJDseLmTWLSdW+7lIGK2uZ+wNM3ZoRkE0tfVk7NR
         jAPltOAKuFQ58ICPDmZ1x2btSLlYx/7y9YTZXOFFLhxl8Ehef4fQX3bKyjGbbPHagx
         AusxaYebc2nWMxpHSe9JijnBP6iEaaBDUPYhFRNWK89pkuINzFe9ZNkNSpaHC13K9V
         9OpEuhFegRUOh5BGJyHwS9rYeus1cCt5eR9qk4hf1Oi100wMO/DxzGSwal4jsMrjTi
         /jmFi9g4PkdsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/9] cavium: Return negative value when pci_alloc_irq_vectors() fails
Date:   Mon, 25 Oct 2021 13:00:41 -0400
Message-Id: <20211025170048.1394542-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170048.1394542-1-sashal@kernel.org>
References: <20211025170048.1394542-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit b2cddb44bddc1a9c5949a978bb454bba863264db ]

During the process of driver probing, the probe function should return < 0
for failure, otherwise, the kernel will treat value > 0 as success.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/nic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nic_main.c b/drivers/net/ethernet/cavium/thunder/nic_main.c
index 9361f964bb9b..816453a4f8d6 100644
--- a/drivers/net/ethernet/cavium/thunder/nic_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nic_main.c
@@ -1193,7 +1193,7 @@ static int nic_register_interrupts(struct nicpf *nic)
 		dev_err(&nic->pdev->dev,
 			"Request for #%d msix vectors failed, returned %d\n",
 			   nic->num_vec, ret);
-		return 1;
+		return ret;
 	}
 
 	/* Register mailbox interrupt handler */
-- 
2.33.0

