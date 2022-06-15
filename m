Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E7254CE48
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354788AbiFOQPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354769AbiFOQNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:13:46 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EE43C73C;
        Wed, 15 Jun 2022 09:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655309598; x=1686845598;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/SCh8xIVt+EA815S+rIiK7ApSTujGLO77jE80fN6j7s=;
  b=lGz+bnFoVHNGoI5lYiVlqtIgQShImCvurtxdTdVhwR0QceBXyw0QJvWT
   yCFoZ5JDxeU8n+Vmbttl7f/kGD9svJ8YhuFSKG21+xGdafIOCLa66JKw5
   0PXRTl++gdLyZw1fN82PafwbB4i2kEgIazxTrDNFLVo4wVqmSmjCxPUZ3
   mq8GyWpKZCj754XIUC85HVQUo7WkKEsT/1oE6kLybXdSZNS0vMiGV2fmX
   9Kj6wcBAIaHVlfnMjwujKpB60fmaxoHAE6Em9lAQI9yw9HIyovN7W1qyr
   otEpBERXdT43OjV/RNzjfwVw3Pb/cQr0nH+AJ9H9JHAD2Lmg1a0cTejbj
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="280050209"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="280050209"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 09:11:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="713005403"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 15 Jun 2022 09:11:20 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 10/11] selftests: xsk: remove struct xsk_socket_info::outstanding_tx
Date:   Wed, 15 Jun 2022 18:10:40 +0200
Message-Id: <20220615161041.902916-11-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220615161041.902916-1-maciej.fijalkowski@intel.com>
References: <20220615161041.902916-1-maciej.fijalkowski@intel.com>
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

