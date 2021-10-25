Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D46439CB6
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbhJYRF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234262AbhJYRDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69D2460FE8;
        Mon, 25 Oct 2021 17:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181272;
        bh=q7Q+qaHQXxKtTdLOzrU+axS9O1AHz6CsjUf1HE8HpYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtvfMiYhNZYFwI+UsgLzt1HwBX82wcu13R90/166cWK0IjhYwgeN9onKhJVTUZI8x
         JTtFKRvXk28hSof7JbDZ2A32Y5KvgZwkFPpcYDmeMQ2QSw7sFZnYTOxdS4zvICD3v8
         g2RpkY62YSVF/sKRJJf96/8GToYFLpzgsmj7SskIjIWjcRrZQZNVBTvZ0AO54BnwAt
         cHleK9ANorSeobfqsMqjgU3HOS7CKIxWf8v+YNQowk6rRJF2QxLWcaJgeUM85WtkPA
         W9gGQctIbQ+VRQ8MhGnjKdRhMXcXHAbwYhZGk/J8VMhp9UCbQ1xixYTttJrtto9HjF
         dc9qjRnWwuWFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 2/7] cavium: Return negative value when pci_alloc_irq_vectors() fails
Date:   Mon, 25 Oct 2021 13:00:57 -0400
Message-Id: <20211025170103.1394651-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170103.1394651-1-sashal@kernel.org>
References: <20211025170103.1394651-1-sashal@kernel.org>
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
index 90497a27df18..7c0a67f1f43f 100644
--- a/drivers/net/ethernet/cavium/thunder/nic_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nic_main.c
@@ -1175,7 +1175,7 @@ static int nic_register_interrupts(struct nicpf *nic)
 		dev_err(&nic->pdev->dev,
 			"Request for #%d msix vectors failed, returned %d\n",
 			   nic->num_vec, ret);
-		return 1;
+		return ret;
 	}
 
 	/* Register mailbox interrupt handler */
-- 
2.33.0

