Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3883007D9
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbhAVPxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729241AbhAVPso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:48:44 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317AEC0617AB;
        Fri, 22 Jan 2021 07:47:38 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id o10so8101873lfl.13;
        Fri, 22 Jan 2021 07:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GhUpAzrFKl9HvT53tqAGb4Rhe5tD4IBo+hhshfGNg4U=;
        b=icIYpGj/CuKsO5Vh2vXQJhE8ghPCvw4ei5twvMnmXLbLZOhohk/mUe8cJJV362oexn
         mtaWYdB06b0Nx0JQNZmlySTUtSAx8vvtcD+17GE1Y73EuRofWUR76MwYZU0u1yO9Oz6u
         qAM8+s0nsS1NJawY9eSvjZ+pDVZWAlfhXD9ElNeO/Q1zHgvXivxKC/JI+REIHpz/HxdQ
         Nrv0Ze1wcOwEwJ7Azi2H+HO74bzmVHQBW/rXIJFrouSHasjBrN1+WLBoEWCZ2Kvmr2fi
         sO+/Kvg5i0/gPRYZoJ1uWHL8TiOYK0bVl+iTa8pRjW8HpqBTQ9/xqF9RcFTrc1DnLgu7
         iFkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GhUpAzrFKl9HvT53tqAGb4Rhe5tD4IBo+hhshfGNg4U=;
        b=kMCWW44zpP96N5hItigPEra46x4o2jzL/9xG6dmFHAEySub1NhlmpTy0Mit69mrNxO
         OsDIuuV1EDkxP9ulPEBCEBgrCZ5pCY7xPwmaCZPpczmWP8jJTVx1SDpAbf1oSDBXIt+v
         E3iGhj8TvL5FWSX59TCTr6c/pWtW3RA+II6T3eWYP29gno8Ek5XBntyiTCdjEZPWG+NI
         YGa4KK1kjquzV+hg/Iidn2ElyqjW3MYHc6c8zoEIZ8yakgrAzPab6LRXeAG2xMa0CkZO
         kuN59D7atq6+c2/9sgGfqvCY/DsUNytfENU6GRsjUNc3Czpwb55HLiOx/lVoHyx7/Zbt
         +HoA==
X-Gm-Message-State: AOAM531FsbtoXSUPZB90oAnHkrjcNYz6g3fWgnbqE+vMWXuwYj84+13+
        zGn8sXR7u+ZJ/xco6hkjhbmDrkCEHMUI6Q==
X-Google-Smtp-Source: ABdhPJywc489JSoov+oO84GF1UeqVMeKnPBoPCyCHxrqLxq+0ZqT8vT0ndkpxbOVrkGpnzknESKZfw==
X-Received: by 2002:a05:6512:398e:: with SMTP id j14mr29081lfu.9.1611330456742;
        Fri, 22 Jan 2021 07:47:36 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w17sm928589lft.52.2021.01.22.07.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:47:36 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 05/12] selftests/bpf: improve readability of xdpxceiver/worker_pkt_validate()
Date:   Fri, 22 Jan 2021 16:47:18 +0100
Message-Id: <20210122154725.22140-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210122154725.22140-1-bjorn.topel@gmail.com>
References: <20210122154725.22140-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Introduce a local variable to get rid of lot of casting. Move common
code outside the if/else-clause.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 29 ++++++++++--------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 9f40d310805a..ab2ed7b85f9e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -726,16 +726,17 @@ static void worker_pkt_dump(void)
 static void worker_pkt_validate(void)
 {
 	u32 payloadseqnum = -2;
+	struct iphdr *iphdr;
 
 	while (1) {
 		pkt_node_rx_q = TAILQ_LAST(&head, head_s);
 		if (!pkt_node_rx_q)
 			break;
+
+		iphdr = (struct iphdr *)(pkt_node_rx_q->pkt_frame + sizeof(struct ethhdr));
+
 		/*do not increment pktcounter if !(tos=0x9 and ipv4) */
-		if ((((struct iphdr *)(pkt_node_rx_q->pkt_frame +
-				       sizeof(struct ethhdr)))->version == IP_PKT_VER) &&
-		    (((struct iphdr *)(pkt_node_rx_q->pkt_frame + sizeof(struct ethhdr)))->tos ==
-			IP_PKT_TOS)) {
+		if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
 			payloadseqnum = *((uint32_t *)(pkt_node_rx_q->pkt_frame + PKT_HDR_SIZE));
 			if (debug_pkt_dump && payloadseqnum != EOT) {
 				pkt_obj = (struct pkt_frame *)malloc(sizeof(struct pkt_frame));
@@ -757,24 +758,18 @@ static void worker_pkt_validate(void)
 				ksft_exit_xfail();
 			}
 
-			TAILQ_REMOVE(&head, pkt_node_rx_q, pkt_nodes);
-			free(pkt_node_rx_q->pkt_frame);
-			free(pkt_node_rx_q);
-			pkt_node_rx_q = NULL;
 			prev_pkt = payloadseqnum;
 			pkt_counter++;
 		} else {
 			ksft_print_msg("Invalid frame received: ");
-			ksft_print_msg("[IP_PKT_VER: %02X], [IP_PKT_TOS: %02X]\n",
-				       ((struct iphdr *)(pkt_node_rx_q->pkt_frame +
-							 sizeof(struct ethhdr)))->version,
-				       ((struct iphdr *)(pkt_node_rx_q->pkt_frame +
-							 sizeof(struct ethhdr)))->tos);
-			TAILQ_REMOVE(&head, pkt_node_rx_q, pkt_nodes);
-			free(pkt_node_rx_q->pkt_frame);
-			free(pkt_node_rx_q);
-			pkt_node_rx_q = NULL;
+			ksft_print_msg("[IP_PKT_VER: %02X], [IP_PKT_TOS: %02X]\n", iphdr->version,
+				       iphdr->tos);
 		}
+
+		TAILQ_REMOVE(&head, pkt_node_rx_q, pkt_nodes);
+		free(pkt_node_rx_q->pkt_frame);
+		free(pkt_node_rx_q);
+		pkt_node_rx_q = NULL;
 	}
 }
 
-- 
2.27.0

