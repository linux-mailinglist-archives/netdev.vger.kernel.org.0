Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D9E439C75
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbhJYRDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234251AbhJYRCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:02:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B824360F70;
        Mon, 25 Oct 2021 17:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181232;
        bh=zymw0Cd5SrCynRtyeFd4YXZw31nviPLgRFKiy/lGjyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNrsXHDPqFEcKXBDgpEUsldDFVsRW7yI3wFsvfnma7ZnDoOp++uPLaSrId+k6kZRB
         1pGZ76eRnNkBMYYN670OjPS9/y6YhUE3KFWEfvRfXjaXL1UZVjbr1L2dQAi/Iw0vnT
         HjBon/Rms5fajOccCiD8/B7XSAwTvfDDyiblm965FI5XaZpRSpkj9rOckrWTQEimav
         qq81dfAlgdwLTrkXbLJf3dIWew+g2Yesknv0dZsscKWqiv6e0Q0h5ujL0tXGpfMNza
         ebznzK/Z+bsyuIvUe4UJOtDf8lhZVnhRFXKjNfND/FIU7nypoHsoHpWhroiZy+/jp8
         VUUGR2OyCEcQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/13] cavium: Return negative value when pci_alloc_irq_vectors() fails
Date:   Mon, 25 Oct 2021 13:00:13 -0400
Message-Id: <20211025170023.1394358-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170023.1394358-1-sashal@kernel.org>
References: <20211025170023.1394358-1-sashal@kernel.org>
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

