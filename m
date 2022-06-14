Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5BE54B812
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344962AbiFNRs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344888AbiFNRsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:48:16 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4514731532;
        Tue, 14 Jun 2022 10:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655228895; x=1686764895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/SCh8xIVt+EA815S+rIiK7ApSTujGLO77jE80fN6j7s=;
  b=HGni49e7zOP8J/rFwBnCuaHf3xT/vYrdqTc1zMhO2lagiMW0hH+7WiZ2
   4nru3qEfksLaEvafOyPDZvXDowXVbAu0a86ZtQ+ebKTGVsKYjs6AYjJ7D
   T6PSuuBqvz/pglF/sYTAIS4lqOR5d2RXS2Gwnta2u8G+Kq6SKrRDqgsM7
   o5ObbTTRToyQPvWTwQuCrDVUxa64yKqEKA2r/tzhvm0hb0b0YLiE0nf/t
   1wH83hc6TsWjrd28PEgQa+6GcUujhV7J7RnITpW9kWPjp+BTdYHB+e26E
   qUkKAKxJ+YPfXn9H3cTHfUf8/Vj3luB/mjS4dU5THvy0SBOOIN3eV8tbd
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="340356837"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="340356837"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 10:48:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="570110144"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 14 Jun 2022 10:48:10 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 09/10] selftests: xsk: remove struct xsk_socket_info::outstanding_tx
Date:   Tue, 14 Jun 2022 19:47:48 +0200
Message-Id: <20220614174749.901044-10-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220614174749.901044-1-maciej.fijalkowski@intel.com>
References: <20220614174749.901044-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous change makes xsk->outstanding_tx a dead code, so let's remove
it.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 20 +++-----------------
 tools/testing/selftests/bpf/xdpxceiver.h |  1 -
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 13a3b2ac2399..ade9d87e7a7c 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -815,7 +815,7 @@ static void kick_rx(struct xsk_socket_info *xsk)
 		exit_with_error(errno);
 }
 
-static int complete_pkts(struct xsk_socket_info *xsk, int batch_size)
+static void complete_pkts(struct xsk_socket_info *xsk, int batch_size)
 {
 	unsigned int rcvd;
 	u32 idx;
@@ -824,20 +824,8 @@ static int complete_pkts(struct xsk_socket_info *xsk, int batch_size)
 		kick_tx(xsk);
 
 	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, batch_size, &idx);
-	if (rcvd) {
-		if (rcvd > xsk->outstanding_tx) {
-			u64 addr = *xsk_ring_cons__comp_addr(&xsk->umem->cq, idx + rcvd - 1);
-
-			ksft_print_msg("[%s] Too many packets completed\n", __func__);
-			ksft_print_msg("Last completion address: %llx\n", addr);
-			return TEST_FAILURE;
-		}
-
+	if (rcvd)
 		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
-		xsk->outstanding_tx -= rcvd;
-	}
-
-	return TEST_PASS;
 }
 
 static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
@@ -955,9 +943,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
 	pthread_mutex_unlock(&pacing_mutex);
 
 	xsk_ring_prod__submit(&xsk->tx, i);
-	xsk->outstanding_tx += valid_pkts;
-	if (complete_pkts(xsk, i))
-		return TEST_FAILURE;
+	complete_pkts(xsk, i);
 
 	usleep(10);
 	return TEST_PASS;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index f364a92675f8..12b792004163 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -104,7 +104,6 @@ struct xsk_socket_info {
 	struct xsk_ring_prod tx;
 	struct xsk_umem_info *umem;
 	struct xsk_socket *xsk;
-	u32 outstanding_tx;
 	u32 rxqsize;
 };
 
-- 
2.27.0

