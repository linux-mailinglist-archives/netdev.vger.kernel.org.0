Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED59F22ADFD
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgGWLnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbgGWLnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:23 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96C4B208E4;
        Thu, 23 Jul 2020 11:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504603;
        bh=aPIbWRipdLXBvkKEbdaOSrT7iqjKdC8nUoNQ8nKtwVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxcCyqGV44sMZ32byy7TY2JpystyTrNeKQeQTPZU5Mf6W+kY/Uyt+qW5sXDwRHNyx
         jV5CeYtVIJc1wAc+k8nRWwYyOjTzDGsxuPEDH0MMu+Y9KbH2PRpBMQa7jxqRINwKd4
         r1pDTq6ow3/WO2yltpqcKHrC6flTJ4OzplEYzQFM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 07/22] net: bnxt: initialize mb bit in xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:19 +0200
Message-Id: <6f93f56197a9ecb03100ddd740b5bd3ec53c4664.1595503780.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 5e3b4a3b69ea..615d95cf4629 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -139,6 +139,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 	xdp.data_end = *data_ptr + *len;
 	xdp.rxq = &rxr->xdp_rxq;
 	xdp.frame_sz = PAGE_SIZE; /* BNXT_RX_PAGE_MODE(bp) when XDP enabled */
+	xdp.mb = 0;
 	orig_data = xdp.data;
 
 	rcu_read_lock();
-- 
2.26.2

