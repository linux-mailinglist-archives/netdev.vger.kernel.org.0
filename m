Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E123822ADF7
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgGWLnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgGWLnO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:14 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D4C920825;
        Thu, 23 Jul 2020 11:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504594;
        bh=g0Kt2lrbwI/VwpPmER+LzfIw4ZFhj9jteLTsShiNHro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCKTrgMc4yWI0CUn/yRv9iL3C1EgAvlExnB7MQPsyAjmaSLVQecl87PV9uVZe3zZN
         lbmIdODrklnkVzwvHO7Glrr3ptMdGe1J0+6ypdjRPYAL5Hk18cXhSKBukBi9XLEy7k
         6Fvfgp/mmtExjP+g441gxx2W2SdACQ+vDP73+37A=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 04/22] net: xen-netfront: initialize mb bit of xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:16 +0200
Message-Id: <041e2c04a90dc2f9cb19815d523f24412164cd7e.1595503780.git.lorenzo@kernel.org>
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
 drivers/net/xen-netfront.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index ed995df19247..ce862b08bb3b 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -868,6 +868,7 @@ static u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
 	xdp->data_end = xdp->data + len;
 	xdp->rxq = &queue->xdp_rxq;
 	xdp->frame_sz = XEN_PAGE_SIZE - XDP_PACKET_HEADROOM;
+	xdp->mb = 0;
 
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
-- 
2.26.2

