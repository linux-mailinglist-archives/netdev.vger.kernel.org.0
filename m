Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702C322AE0E
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbgGWLnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbgGWLnq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:46 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 050CF22B49;
        Thu, 23 Jul 2020 11:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504625;
        bh=/PV9K7BbTPUVhCMIU6AVRN0Ln/8o4LjKAAr4m6OwTL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDrG4tNgIEaT7t4UVheviGju6ROLUnlJOimbpzJ915Bp/AmVRCKq8B0dNz9h5V89Q
         ANbKIcOuLxhywAjY+eD6vsxmn7Eib1xWxu0CMmfzTKNGQ93Z3P2/n8nq05E5YwKAWv
         3T0CoeOmOs1V+Rd8HNsNz6aKqE0EBg1B1pvmNIhM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 15/22] net: cavium: thunder: initialize mb bit in xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:27 +0200
Message-Id: <4a79d56002c2f950248ae133d1108bbd13b8630b.1595503780.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 2ba0ce115e63..bd2592ddfd6d 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -553,6 +553,7 @@ static inline bool nicvf_xdp_rx(struct nicvf *nic, struct bpf_prog *prog,
 	xdp.data_end = xdp.data + len;
 	xdp.rxq = &rq->xdp_rxq;
 	xdp.frame_sz = RCV_FRAG_LEN + XDP_PACKET_HEADROOM;
+	xdp.mb = 0;
 	orig_data = xdp.data;
 
 	rcu_read_lock();
-- 
2.26.2

