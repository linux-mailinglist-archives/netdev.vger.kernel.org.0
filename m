Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF153AC8AC
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbhFRKVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:21:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50859 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbhFRKVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 06:21:38 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1luBap-0000hQ-Dn; Fri, 18 Jun 2021 10:19:19 +0000
From:   Colin King <colin.king@canonical.com>
To:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] qlcnic: remove redundant continue statement
Date:   Fri, 18 Jun 2021 11:19:19 +0100
Message-Id: <20210618101919.101934-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The continue statement at the end of a for-loop has no effect,
it is redundant and can be removed.

Addresses-Coverity: ("Continue has no effect")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 3d9028d6b942..a4fa507903ee 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -3342,9 +3342,6 @@ qlcnic_can_start_firmware(struct qlcnic_adapter *adapter)
 	do {
 		msleep(1000);
 		prev_state = QLC_SHARED_REG_RD32(adapter, QLCNIC_CRB_DEV_STATE);
-
-		if (prev_state == QLCNIC_DEV_QUISCENT)
-			continue;
 	} while ((prev_state != QLCNIC_DEV_READY) && --dev_init_timeo);
 
 	if (!dev_init_timeo) {
-- 
2.31.1

