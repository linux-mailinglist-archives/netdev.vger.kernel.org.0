Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C736E22AE10
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgGWLnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbgGWLnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:49 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD665208E4;
        Thu, 23 Jul 2020 11:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504628;
        bh=MQzljx0bRPs0rhEpMTOYlyp9Bd1w9bulamPGzccxT98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6IQ6NxiqkCNxSw58PCS8dDP0944RDC/gweg3q7JAhnagTOGmpbCVI8qSgohxVFVV
         is52V/eavTCeRv795kYOPi1aHAuhhUqJ6XYAKzbV/ZJSyVh+rE3zq0cfc8XtBNokT5
         nD5FXAnAvXSaMB8O/jH+zRpPsfIunksxYRjZlo5s=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 16/22] net: socionext: initialize mb bit in xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:28 +0200
Message-Id: <76673f7e992f80826c0500b9f9c7c03d92e015cb.1595503780.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/socionext/netsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 0f366cc50b74..0c98391224bd 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -947,6 +947,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 
 	xdp.rxq = &dring->xdp_rxq;
 	xdp.frame_sz = PAGE_SIZE;
+	xdp.mb = 0;
 
 	rcu_read_lock();
 	xdp_prog = READ_ONCE(priv->xdp_prog);
-- 
2.26.2

