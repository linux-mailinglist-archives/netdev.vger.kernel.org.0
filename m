Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABF422AE03
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgGWLnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbgGWLnc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:32 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09EF72080D;
        Thu, 23 Jul 2020 11:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504612;
        bh=PRAJbgGBy9uI9xx0z3xw4LO3+xzSOqkNUv9MizzokYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXNJBUNIyvLL9mBkNdn2oKNYKq60fwazi4xOy7WGn+MyOpcUnprNa3ko0oJELTiao
         DddwfjrOq6adi7K3gqxZkwomOcmDHpwTUIvDhoXuxrfcYvOB0s/UfNMjHLqU+oTn16
         RPzSMOW0x551Uqdgr0wTvUQzV1yWtYn3vEW3x+dw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 10/22] net: nfp: initialize mb bit in xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:22 +0200
Message-Id: <31f5d7d2d3dd50829593d4ac80abf23b71e2b024.1595503780.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1595503780.git.lorenzo@kernel.org>
References: <cover.1595503780.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize multi-buffer bit (mb) to 0 in xdp_buff data structure.
This is a preliminary patch to enable xdp multi-buffer support.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 44608873d3d9..c6998c34e552 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1824,6 +1824,7 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 	true_bufsz = xdp_prog ? PAGE_SIZE : dp->fl_bufsz;
 	xdp.frame_sz = PAGE_SIZE - NFP_NET_RX_BUF_HEADROOM;
 	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp.mb = 0;
 	tx_ring = r_vec->xdp_ring;
 
 	while (pkts_polled < budget) {
-- 
2.26.2

