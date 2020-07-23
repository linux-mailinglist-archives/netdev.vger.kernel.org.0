Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E10722AE18
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgGWLoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgGWLoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:44:00 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86311208E4;
        Thu, 23 Jul 2020 11:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504640;
        bh=7YTp6wRSGYTK40Lq0oa6GYTw86MrP8ScAVbWCWILBr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MqgPLdYEYs5RetqEtN2tVTIX7xy7hnCmn9lSd5oQpyjpoPaFzmyqNxAErDxUWsm3o
         gOJA94FpORraSsXHgQM3AnBloOokQEyYZCkOirO0NGrej5nlCJ6gwZzXJQjxaEeUVH
         T3/wjP7uuOGc0LtptmwHtg+eYwfi0ScwcuSMybpA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 20/22] net: i40e: initialize mb bit in xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:32 +0200
Message-Id: <bd639b8a62d93a230db6ad3488362588448d5081.1595503780.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 3e5c566ceb01..7d5a8afa8a4c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2324,6 +2324,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 	xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, 0);
 #endif
 	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp.mb = 0;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		struct i40e_rx_buffer *rx_buffer;
-- 
2.26.2

