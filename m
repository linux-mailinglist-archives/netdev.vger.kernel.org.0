Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DED1402402
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239596AbhIGHVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239140AbhIGHVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:04 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6FAC061757;
        Tue,  7 Sep 2021 00:19:58 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n7-20020a05600c3b8700b002f8ca941d89so805600wms.2;
        Tue, 07 Sep 2021 00:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=obBkzebWL7uuIG+0NdExWZj3JRncqJP+NsVPCtUWNb8=;
        b=eXu2KqOU9SXfugljnwe96hWF2t/i27sNj7AOcQqLW2MW4ZOLHgLt0pPygQj36MvsVu
         J1986NVOGK3b4MdlQuFskh90Gri/7prrpIbdYb5cv2ILYoNV0BeB4H+/wIqMNGZs7anP
         yS9MGQbz6swcpFQojN+wvZ6opA/ZsPypEZD9CF4BL7ptpkQ4GpQg4bGJXucMrsgpDlS6
         M2gxl9u4e9TxivrJafqChqcEE34qwBoPBOjOu0wpRL3AYHS23syPJOKNdw4Bi/KT2o6J
         KAGaMgF2pfn6YukqttodTdDyjk6rHAoQtKGGdEd2YGy/CcyMuyf9S6NNdTFmFNSYKi5R
         bUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=obBkzebWL7uuIG+0NdExWZj3JRncqJP+NsVPCtUWNb8=;
        b=jL/9bpZbhM6OFDBFM9+NpvDJ5Q98pjuN7Wgz57Hw4NQb7hy42HQjGNoCm1olta+/KQ
         BwblIP6VH8HWqSPNx0ibHEQ0SebkJrR1u9C7B2S6dOEUwLTynHNr+Vgm8S1hMteMX9Yp
         nMuX7eorUm5brgqNfpFRnCr7iu2CpjnaSZj3bdsbX7X9OjYUBZedqXPlqe1AQxDAB/wl
         UxqU6UlkefpNCe7X0er8qfkvXAUYjlQBNJY890BTkblado8Nn0fTQXkunb5vx5BaXc8K
         eGW8f/ltIZskWwCouP/H4i21ZcBqpHM7b2iHSZDYuSGz0oPmk/xEVf7jT1sZIpk3hXyN
         TJfA==
X-Gm-Message-State: AOAM530o5rm00AF8TDleFgh36Nw6CwWCOPGpK4XKsQP6ANzx4SKwciav
        f1fG8UviGmE2VdD5w4yUysI=
X-Google-Smtp-Source: ABdhPJyUSzBofsla/BMPaY5YYOldOQdp8Rjy+libeHfQks2j+VXPHWepXO8q5r3llW4rqWrdJ9QQpQ==
X-Received: by 2002:a7b:cb8c:: with SMTP id m12mr2323604wmi.77.1630999196966;
        Tue, 07 Sep 2021 00:19:56 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.19.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:19:56 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 05/20] selftests: xsk: move rxqsize into xsk_socket_info
Date:   Tue,  7 Sep 2021 09:19:13 +0200
Message-Id: <20210907071928.9750-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Move the global variable rxqsize to struct xsk_socket_info as it
describes the size of a ring in that struct. By default, it is set to
the size dictated by libbpf.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 9 +++------
 tools/testing/selftests/bpf/xdpxceiver.h | 2 +-
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 56ee03fda2b3..28bf62c56190 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -276,7 +276,7 @@ static int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_inf
 	struct xsk_ring_prod *txr;
 
 	xsk->umem = umem;
-	cfg.rx_size = rxqsize;
+	cfg.rx_size = xsk->rxqsize;
 	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
 	cfg.libbpf_flags = 0;
 	cfg.xdp_flags = xdp_flags;
@@ -407,6 +407,7 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 			memset(&ifobj->umem_arr[j], 0, sizeof(ifobj->umem_arr[j]));
 			memset(&ifobj->xsk_arr[j], 0, sizeof(ifobj->xsk_arr[j]));
 			ifobj->umem_arr[j].num_frames = DEFAULT_PKT_CNT / 4;
+			ifobj->xsk_arr[j].rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 		}
 	}
 
@@ -988,16 +989,13 @@ static void testapp_stats(struct test_spec *test)
 		test_spec_reset(test);
 		stat_test_type = i;
 
-		/* reset defaults */
-		rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
-
 		switch (stat_test_type) {
 		case STAT_TEST_RX_DROPPED:
 			test->ifobj_rx->umem->frame_headroom = XSK_UMEM__DEFAULT_FRAME_SIZE -
 				XDP_PACKET_HEADROOM - 1;
 			break;
 		case STAT_TEST_RX_FULL:
-			rxqsize = RX_FULL_RXQSIZE;
+			test->ifobj_rx->xsk->rxqsize = RX_FULL_RXQSIZE;
 			break;
 		case STAT_TEST_TX_INVALID:
 			continue;
@@ -1040,7 +1038,6 @@ static void run_pkt_test(struct test_spec *test, int mode, int type)
 	xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 	second_step = 0;
 	stat_test_type = -1;
-	rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 
 	configured_mode = mode;
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 0d93a9e6c4f3..09e4e015b1bf 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -79,7 +79,6 @@ static bool opt_verbose;
 static u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static u32 xdp_bind_flags = XDP_USE_NEED_WAKEUP | XDP_COPY;
 static int stat_test_type;
-static u32 rxqsize;
 
 struct xsk_umem_info {
 	struct xsk_ring_prod fq;
@@ -96,6 +95,7 @@ struct xsk_socket_info {
 	struct xsk_umem_info *umem;
 	struct xsk_socket *xsk;
 	u32 outstanding_tx;
+	u32 rxqsize;
 };
 
 struct flow_vector {
-- 
2.29.0

