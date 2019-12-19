Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B74F1271BB
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 00:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfLSXpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 18:45:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55314 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfLSXpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 18:45:42 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1ii5U7-0002w7-Lq; Thu, 19 Dec 2019 23:45:35 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ice: remove redundant assignment to variable xmit_done
Date:   Thu, 19 Dec 2019 23:45:35 +0000
Message-Id: <20191219234535.37103-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable xmit_done is being initialized with a value that is never
read and it is being updated later with a new value. The initialization
is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index cf9b8b22d24f..03c1e9bcf790 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -1019,8 +1019,8 @@ bool ice_clean_tx_irq_zc(struct ice_ring *xdp_ring, int budget)
 	s16 ntc = xdp_ring->next_to_clean;
 	struct ice_tx_desc *tx_desc;
 	struct ice_tx_buf *tx_buf;
-	bool xmit_done = true;
 	u32 xsk_frames = 0;
+	bool xmit_done;
 
 	tx_desc = ICE_TX_DESC(xdp_ring, ntc);
 	tx_buf = &xdp_ring->tx_buf[ntc];
-- 
2.24.0

