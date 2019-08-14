Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099938C880
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbfHNCQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728727AbfHNCQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:16:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C0F420843;
        Wed, 14 Aug 2019 02:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748987;
        bh=aCcaF41kxT3VQhGRRPMf3R15/dqODMKM6cnjPf8pLqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYJdncpgXFh4b4vbnncIwycFmvDZ5hqsee/TYkwKCP80XxEvOu3wGIh5SbnG0OkoW
         Y1spoGsVefRIJ7/b6IJDpxlwIZHojLBD+UnB+v0gqquWnp7/M+75LdrAvtV6zaodZJ
         CaAOj7yhiUZdvuLwaQ0HU78xToJ9cyqO6TtwuFlk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Kalderon <michal.kalderon@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 22/68] qed: RDMA - Fix the hw_ver returned in device attributes
Date:   Tue, 13 Aug 2019 22:15:00 -0400
Message-Id: <20190814021548.16001-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 81af04b432fdfabcdbd2c06be2ee647e3ca41a22 ]

The hw_ver field was initialized to zero. Return the chip revision.
This is relevant for rdma driver.

Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 13802b825d65a..909422d939033 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -442,7 +442,7 @@ static void qed_rdma_init_devinfo(struct qed_hwfn *p_hwfn,
 	/* Vendor specific information */
 	dev->vendor_id = cdev->vendor_id;
 	dev->vendor_part_id = cdev->device_id;
-	dev->hw_ver = 0;
+	dev->hw_ver = cdev->chip_rev;
 	dev->fw_ver = (FW_MAJOR_VERSION << 24) | (FW_MINOR_VERSION << 16) |
 		      (FW_REVISION_VERSION << 8) | (FW_ENGINEERING_VERSION);
 
-- 
2.20.1

