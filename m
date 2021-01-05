Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8542EB0C3
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbhAEQ6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 11:58:50 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:9511 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728946AbhAEQ6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 11:58:49 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 105GvoDF018714;
        Tue, 5 Jan 2021 08:57:50 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net] cxgb4: advertise NETIF_F_HW_CSUM
Date:   Tue,  5 Jan 2021 22:27:49 +0530
Message-Id: <20210105165749.16920-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

advertise NETIF_F_HW_CSUM instead of protocol specific values of
NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM. This change is added long
back in other drivers. This issue is seen recently when TLS offload
made it mandatory to enable NETIF_F_HW_CSUM.

Fixes: 2ed28baa7076 ("net: cxgb4{,vf}: convert to hw_features")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7fd264a6d085..f99f43570d41 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6831,14 +6831,13 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->irq = pdev->irq;
 
 		netdev->hw_features = NETIF_F_SG | TSO_FLAGS |
-			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+			NETIF_F_HW_CSUM |
 			NETIF_F_RXCSUM | NETIF_F_RXHASH | NETIF_F_GRO |
 			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 			NETIF_F_HW_TC | NETIF_F_NTUPLE;
 
 		if (chip_ver > CHELSIO_T5) {
-			netdev->hw_enc_features |= NETIF_F_IP_CSUM |
-						   NETIF_F_IPV6_CSUM |
+			netdev->hw_enc_features |= NETIF_F_HW_CSUM |
 						   NETIF_F_RXCSUM |
 						   NETIF_F_GSO_UDP_TUNNEL |
 						   NETIF_F_GSO_UDP_TUNNEL_CSUM |
-- 
2.18.1

