Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4480229B15
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732635AbgGVPM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:12:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41683 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgGVPM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:12:28 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jyGPt-0001rA-Ha; Wed, 22 Jul 2020 15:12:21 +0000
From:   Colin King <colin.king@canonical.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] lan743x: remove redundant initialization of variable current_head_index
Date:   Wed, 22 Jul 2020 16:12:21 +0100
Message-Id: <20200722151221.957972-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable current_head_index is being initialized with a value that
is never read and it is being updated later with a new value.  Replace
the initialization of -1 with the latter assignment.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index f6479384dc4f..de93cc6ebc1a 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2046,14 +2046,13 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 {
 	struct skb_shared_hwtstamps *hwtstamps = NULL;
 	int result = RX_PROCESS_RESULT_NOTHING_TO_DO;
+	int current_head_index = *rx->head_cpu_ptr;
 	struct lan743x_rx_buffer_info *buffer_info;
 	struct lan743x_rx_descriptor *descriptor;
-	int current_head_index = -1;
 	int extension_index = -1;
 	int first_index = -1;
 	int last_index = -1;
 
-	current_head_index = *rx->head_cpu_ptr;
 	if (current_head_index < 0 || current_head_index >= rx->ring_size)
 		goto done;
 
-- 
2.27.0

