Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED24622AE1C
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgGWLoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:44:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgGWLoF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:44:05 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32B602086A;
        Thu, 23 Jul 2020 11:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504645;
        bh=X0Z1R2jFkhJUSkoinGq+f0fTEPc2NQ4LnVDbVcmKlN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0Vt+N4yB66ODn9Un9v4b2zZ3kUB57Si4SEqTOYQH3W/mARNidw8XjTln8iLE6Cyy
         AwwbcgpEW38kdubEmndGSCziBqHfqFCoI9Q10Njo+Nb9yXUpmUC7KSO4F95tNLEYbf
         I7DslHO117RWcTkwmGSMaDSEQwWIdZAgMIvXFuzA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 22/22] net: mlx4: initialize mb bit in xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:34 +0200
Message-Id: <58f38cdce05d1126f4a9372f0e14de7718af0a14.1595503780.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 8a10285b0e10..0d42e81a7ad8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -684,6 +684,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	xdp_prog = rcu_dereference(ring->xdp_prog);
 	xdp.rxq = &ring->xdp_rxq;
 	xdp.frame_sz = priv->frag_info[0].frag_stride;
+	xdp.mb = 0;
 	doorbell_pending = 0;
 
 	/* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
-- 
2.26.2

