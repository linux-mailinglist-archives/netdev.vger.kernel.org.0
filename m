Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AC622ADFE
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgGWLn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbgGWLn0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:26 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E379522B49;
        Thu, 23 Jul 2020 11:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504606;
        bh=DiNiBmNFFH2wqy7X6kPmJT0swH3hKs24YLSHKDOojSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlpomG0gNOonPedpzNPSSWXn+anXcKIDh6KenzVHSFp56r/lnam8SbCllurdgwi7B
         y6RVy1DteevlpKsqom9WbcMemHJdVMX63RuMTbXg/rkTEexHOc+adE+8qLw4cr3t9Q
         +FLHwz5O+H8rT53TcZgdufGytmJql7k0IY+9PPOc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 08/22] net: dpaa2: initialize mb bit in xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:20 +0200
Message-Id: <fd1bf172591aac0cff5c619eed0812a876a48bc4.1595503780.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index c1bea9132f50..fc37099675c8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -361,6 +361,7 @@ static u32 run_xdp(struct dpaa2_eth_priv *priv,
 
 	xdp.frame_sz = DPAA2_ETH_RX_BUF_RAW_SIZE -
 		(dpaa2_fd_get_offset(fd) - XDP_PACKET_HEADROOM);
+	xdp.mb = 0;
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 
-- 
2.26.2

