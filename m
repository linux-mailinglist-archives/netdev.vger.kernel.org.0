Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C7F22ADFB
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgGWLnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbgGWLnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:21 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D70322B47;
        Thu, 23 Jul 2020 11:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504601;
        bh=D9LURMY6QhNvXrtQTcDScEC9ufStkgARe7amVtSXPVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2Ek87az/HPM16vhw0E9gd8oNSmlWf30Ms83SjOPscy9N/4+uQs0Dv9batzop4Je7
         uMMSqS5wYS50a7whT0kJb9Tr3UU9/pVJAtoIg9cwCeXKxg1XKewhA2I35umg+ouYdC
         Y9Q+vyPljOrzi2VAH6E+4hNE3ydi1gNCCFhzRvWg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 06/22] net: hv_netvsc: initialize mb bit of xdp_buff to 0
Date:   Thu, 23 Jul 2020 13:42:18 +0200
Message-Id: <b974b617c54122f90a9e8a6f63b93960543477b7.1595503780.git.lorenzo@kernel.org>
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
 drivers/net/hyperv/netvsc_bpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index 8e4141552423..e26c60413128 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -50,6 +50,7 @@ u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
 	xdp->data_end = xdp->data + len;
 	xdp->rxq = &nvchan->xdp_rxq;
 	xdp->frame_sz = PAGE_SIZE;
+	xdp->mb = 0;
 
 	memcpy(xdp->data, data, len);
 
-- 
2.26.2

