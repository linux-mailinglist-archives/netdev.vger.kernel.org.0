Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C9322AE16
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgGWLn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgGWLn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:58 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D49192080D;
        Thu, 23 Jul 2020 11:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504638;
        bh=2h2OyRLKTitD1++J9u+1ak8yC5jbPokRST8L++FMjlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpq1XVzZRTUvdZgdvxPIi+1nikuJSZ5/Bl9vABxBJtqTAENR+9m0LZXOb3gO2FUpL
         AkSy3ZHXgNgjG77wnS6Pd1VklKX8qdOpBDHOmFC3Ni743/I92Sw26fcF5lbV4E9VGJ
         tLP9eDOJ/qvjExxj7qRZuH6f0TFYzSUJROOP4xHo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 19/22] net: ice: initialize mb bit in xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:31 +0200
Message-Id: <4eebf0f961d4ad79795cdc00b7359e031c79c85d.1595503780.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/intel/ice/ice_txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index abdb137c8bb7..90453b3ffa2c 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1098,6 +1098,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 #if (PAGE_SIZE < 8192)
 	xdp.frame_sz = ice_rx_frame_truesize(rx_ring, 0);
 #endif
+	xdp.mb = 0;
 
 	/* start the loop to process Rx packets bounded by 'budget' */
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
-- 
2.26.2

