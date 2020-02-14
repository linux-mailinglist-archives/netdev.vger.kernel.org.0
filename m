Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560DA15DC6D
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731132AbgBNPxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731018AbgBNPxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E60424676;
        Fri, 14 Feb 2020 15:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695581;
        bh=/73/ybL08y3MfdJofkFDbGAMVH9v2eU7vMke69tEJVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=15Px0gQXGM+qHpK8cLn8h/HKWXX346C/3gjEOEwRBVBvI5RDNq4Bh7FAxH4fTDGNM
         5WRdelOew0gtS50GBGzCUj6FOnDTm8eKM28Xsf0DoCcSXYaYXsSOUKOSw5k8giboUj
         5eKuGhwYrVe8kzV8PQjWGxZk50UWQ4WwweD10do4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Wandun <chenwandun@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 191/542] enetc: remove variable 'tc_max_sized_frame' set but not used
Date:   Fri, 14 Feb 2020 10:43:03 -0500
Message-Id: <20200214154854.6746-191-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Wandun <chenwandun@huawei.com>

[ Upstream commit 6525b5ef65fdaf8a782449fb5d585195b573c2c1 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/freescale/enetc/enetc_qos.c: In function enetc_setup_tc_cbs:
drivers/net/ethernet/freescale/enetc/enetc_qos.c:195:6: warning: variable tc_max_sized_frame set but not used [-Wunused-but-set-variable]

Fixes: c431047c4efe ("enetc: add support Credit Based Shaper(CBS) for hardware offload")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 2e99438cb1bf3..9190ffc9f6b21 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -192,7 +192,6 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	u32 hi_credit_bit, hi_credit_reg;
 	u32 max_interference_size;
 	u32 port_frame_max_size;
-	u32 tc_max_sized_frame;
 	u8 tc = cbs->queue;
 	u8 prio_top, prio_next;
 	int bw_sum = 0;
@@ -250,7 +249,7 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 		return -EINVAL;
 	}
 
-	tc_max_sized_frame = enetc_port_rd(&si->hw, ENETC_PTCMSDUR(tc));
+	enetc_port_rd(&si->hw, ENETC_PTCMSDUR(tc));
 
 	/* For top prio TC, the max_interfrence_size is maxSizedFrame.
 	 *
-- 
2.20.1

