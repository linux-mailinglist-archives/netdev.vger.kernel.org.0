Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921FF439D15
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbhJYRLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234299AbhJYRD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:03:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D117F61050;
        Mon, 25 Oct 2021 17:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181284;
        bh=s+9bTljS9y6leYPbe4rvFcnuMjm4iGZNTbc+xPqEjE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yw15SZTWx+MIZokSR+pZXug7cvXgPRN+LvbwBB1MXsWkD1kp8z7VoaaotEU5zMbQx
         qaX+QF7fTdvZCktH1fXqYy0ouly7apGHsRA8y7FkLCFClwaK6kzKyw4OQGmr8eH+V3
         LZ/Zi8pvWMvn0fzdjHZolhSIgTemoGH1+yEs7yt2DAk9p9lyMtIGUl7/AFFYWZCfHL
         hl947GT7ZZgtSrcPWqmevu8Qg4e24V4F4Ej06RKlzAdnSBc+M3tEKmNEzB8L/w+d8c
         7aSaCbXbIKFiTf9sQtNMmhgz+6U6ClRaLhv5v/3i8bIyfPBq8HG38gAXzc7gexZdw/
         psiO8or+QV+tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 2/7] cavium: Return negative value when pci_alloc_irq_vectors() fails
Date:   Mon, 25 Oct 2021 13:01:15 -0400
Message-Id: <20211025170120.1394792-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170120.1394792-1-sashal@kernel.org>
References: <20211025170120.1394792-1-sashal@kernel.org>
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
index 819f38a3225d..7f8ea16ad0d0 100644
--- a/drivers/net/ethernet/cavium/thunder/nic_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nic_main.c
@@ -1128,7 +1128,7 @@ static int nic_register_interrupts(struct nicpf *nic)
 		dev_err(&nic->pdev->dev,
 			"Request for #%d msix vectors failed, returned %d\n",
 			   nic->num_vec, ret);
-		return 1;
+		return ret;
 	}
 
 	/* Register mailbox interrupt handler */
-- 
2.33.0

