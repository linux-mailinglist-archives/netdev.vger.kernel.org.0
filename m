Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5163402417
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242441AbhIGHWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240507AbhIGHVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:20 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40355C061757;
        Tue,  7 Sep 2021 00:20:13 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id k5-20020a05600c1c8500b002f76c42214bso992614wms.3;
        Tue, 07 Sep 2021 00:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hbt0Mg2tvtnST2dzdC4XVYXjIBjQHSXwsVrLWYPs1i4=;
        b=Yr/BlTbBy57qfkEmv9XIE1UCZ80i7wS94iHyYQRz1h2Dq2JilXP39l8J7SeSPsoC9S
         ble/K+6V9RAnzMnDqJcC5Yt9zPTSU226eeZKicbrdITuFvrm91zLqmntkm6gbOmBqka/
         noOscdlenCNEyzO+qW4rg+d9trAMY+eR7cIeHWwgWwhyFf65Nd5pxO+np0TMo1I/WAh1
         V1JQB2LIwOaEkfLokJaJNOgD+HyKRyNC/fPbK289JVgN7fpuerGwnRDHON0EMCAQuwHW
         GbIpMfRYS30P6jvSv3tYKawCzQOMIDFY7FmtuqCXISpF++QzSfDC68ITSpUapYL6gceP
         c5DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hbt0Mg2tvtnST2dzdC4XVYXjIBjQHSXwsVrLWYPs1i4=;
        b=siREny9AGMfs9gJRxqDISx1tuRJqfTi4V4/ijKtTFSndjo4Ulsnc0BuyoAB4qciKGP
         LbIqfhnknN0u2sdJ0YgMY2uMpH+m60HT/HCwCrdo+GaUDtcGh25mjPcCYCxpKmrPhQTy
         2JCE4M0zKKfKsxYxPwF0X2UPLJ18mQ5Y+h4fQdb4R4FXcs7Pk7E8ZDkKnA8jVqNF7cMl
         VMb5cvzagA+ul3LS9jf/mRiSLCTw9qycLDpG4qUCIw6NdOZvNReQN3FbP+2jB8nqF1os
         kudIpwZRPItLn/TVzT+18FJ5eomaI8MG6ypRVqShYyKxKyZMuTCNss9qxl3dMPdDmM1J
         CqPQ==
X-Gm-Message-State: AOAM530sdMPt7LI4yDCsylInFOHYRPrhRhj7v+LMilkjGmxhL07qJjsC
        M5G8l/VrXx+CLEFp9qPliWg=
X-Google-Smtp-Source: ABdhPJybEDwtzhYjX0Go/apM0x4s3iB2VmErlaZ4QYoQ5lMTxgeOScNqG+jSy4Aw6CCMC9JwX6Mv8w==
X-Received: by 2002:a7b:c192:: with SMTP id y18mr2355511wmi.163.1630999211895;
        Tue, 07 Sep 2021 00:20:11 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.20.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:20:11 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 15/20] selftests: xsk: allow for invalid packets
Date:   Tue,  7 Sep 2021 09:19:23 +0200
Message-Id: <20210907071928.9750-16-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Allow for invalid packets to be sent. These are verified by the Rx
thread not to be received. Or put in another way, if they are
received, the test will fail. This feature will be used to eliminate
an if statement for a stats test and will also be used by other tests
in later patches. The previous code could only deal with valid
packets.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 16 ++++++++++------
 tools/testing/selftests/bpf/xdpxceiver.h |  1 +
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 0fb5cae974de..09d2854c10e6 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -473,6 +473,11 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size;
 		pkt_stream->pkts[i].len = pkt_len;
 		pkt_stream->pkts[i].payload = i;
+
+		if (pkt_len > umem->frame_size)
+			pkt_stream->pkts[i].valid = false;
+		else
+			pkt_stream->pkts[i].valid = true;
 	}
 
 	return pkt_stream;
@@ -658,7 +663,7 @@ static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *
 static u32 __send_pkts(struct ifobject *ifobject, u32 pkt_nb)
 {
 	struct xsk_socket_info *xsk = ifobject->xsk;
-	u32 i, idx;
+	u32 i, idx, valid_pkts = 0;
 
 	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE)
 		complete_pkts(xsk, BATCH_SIZE);
@@ -673,14 +678,13 @@ static u32 __send_pkts(struct ifobject *ifobject, u32 pkt_nb)
 		tx_desc->addr = pkt->addr;
 		tx_desc->len = pkt->len;
 		pkt_nb++;
+		if (pkt->valid)
+			valid_pkts++;
 	}
 
 	xsk_ring_prod__submit(&xsk->tx, i);
-	if (stat_test_type != STAT_TEST_TX_INVALID)
-		xsk->outstanding_tx += i;
-	else if (xsk_ring_prod__needs_wakeup(&xsk->tx))
-		kick_tx(xsk);
-	complete_pkts(xsk, i);
+	xsk->outstanding_tx += valid_pkts;
+	complete_pkts(xsk, BATCH_SIZE);
 
 	return i;
 }
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 1e9a563380c8..c5baa7c5f560 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -96,6 +96,7 @@ struct pkt {
 	u64 addr;
 	u32 len;
 	u32 payload;
+	bool valid;
 };
 
 struct pkt_stream {
-- 
2.29.0

