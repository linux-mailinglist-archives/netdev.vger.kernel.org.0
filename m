Return-Path: <netdev+bounces-2090-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E6F7003B0
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:25:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E27C1C2114F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74D49DF63;
	Fri, 12 May 2023 09:21:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6731FBE45;
	Fri, 12 May 2023 09:21:42 +0000 (UTC)
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F47DDA6;
	Fri, 12 May 2023 02:21:40 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-3064056fa4eso1338525f8f.1;
        Fri, 12 May 2023 02:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683883299; x=1686475299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v+1p+CcB34K5A3SbSYATzqZcO+JoUzcf1YjpGMSniVI=;
        b=VYJk7P43ppc5MAAGG2x9X08RgmB8fWzA9C2NBrJ9VCmhr3DduEjpA31xXjzTBL2yLQ
         lklOZ2Y+daUxReFCDJ79f2BGgiQ1uaVVsBG/a6ZWKsdxDCG8W6mhn/i3F0vJQiokMHIF
         BcDorrE0BYJaz/OQcItjvmJtG75o6luJPQ9q78gNeMPg9SIO+sxdfJy+OxBtCJj4a+dD
         Y6oB2nG6UXeulFSAwzH91yHGXQ6t7aqtIIchD6EblxRrNT/DYuUEbV/XqsBtTs53Nmer
         doxJM6/99p0/D6BInVQHQUkJEBNbDZfU5lXmeN+e5ETFtUFOiGk9H9jtfeQxszlmXAu8
         /1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683883299; x=1686475299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v+1p+CcB34K5A3SbSYATzqZcO+JoUzcf1YjpGMSniVI=;
        b=dGsWTU2hOk9PXK8ysNjbPVXIKDzf8Z1XYyQIxOLic6ugdvaE8o42XsTNCyvPRD1ezh
         Onksn1S82SlkSkGxx3onJfukSFu77u9S/ogfyX3gJsdnCrWqARWf5A3h5oypwISEc/QE
         P7N9O/QEOqAepwS8Asda4a5qkH6WehI9NGTIOVjRAwrMyUW1QlLFz8wRuJTA4QkqTjkf
         gfroVAgRWM0ruOufyqYJrA01dix2CnUV8kYuDr17w9a30y2BYngITF4/iaYlgjrOPsud
         t4uKsY3IlGYERkAYpxCEacKnN5lrlemhf2boiWl+meDuIou8I12NZwVhpcrrluIgemlb
         XrhA==
X-Gm-Message-State: AC+VfDwdA9a0atBquV5xyXeGOhJSKxkbQt4WlNE//4STgK6JxzP6aRP/
	R5L5d0Y2W4aypA8dsV6qsWI=
X-Google-Smtp-Source: ACHHUZ7BKaGozzdb5J9Yk87p8NYDK6YEhnap917z1iIb36oWymQGQRPIPwhDzowQ2Azxu+OyBVcpwA==
X-Received: by 2002:a5d:440a:0:b0:2f8:15d8:e627 with SMTP id z10-20020a5d440a000000b002f815d8e627mr13056894wrq.7.1683883298994;
        Fri, 12 May 2023 02:21:38 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id i14-20020a5d558e000000b003079f2c2de7sm11467789wrv.112.2023.05.12.02.21.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 May 2023 02:21:38 -0700 (PDT)
From: Magnus Karlsson <magnus.karlsson@gmail.com>
To: magnus.karlsson@intel.com,
	bjorn@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	netdev@vger.kernel.org,
	maciej.fijalkowski@intel.com,
	bpf@vger.kernel.org,
	yhs@fb.com,
	andrii@kernel.org,
	martin.lau@linux.dev,
	song@kernel.org,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	tirthendu.sarkar@intel.com
Subject: [PATCH bpf-next 08/10] selftests/xsk: populate fill ring based on frags needed
Date: Fri, 12 May 2023 11:20:41 +0200
Message-Id: <20230512092043.3028-9-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230512092043.3028-1-magnus.karlsson@gmail.com>
References: <20230512092043.3028-1-magnus.karlsson@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Magnus Karlsson <magnus.karlsson@intel.com>

Populate the fill ring based on the number of frags a packet
needs. With multi-buffer support, a packet might require more than a
single fragment/buffer, so the function xsk_populate_fill_ring() needs
to consider how many buffers a packet will consume, and put that many
buffers on the fill ring for each packet it should receive. As we are
still not sending any multi-buffer packets, the function will only
produce one buffer per packet at the moment.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xsk.h        |  5 +++
 tools/testing/selftests/bpf/xskxceiver.c | 48 ++++++++++++++++++------
 2 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/xsk.h b/tools/testing/selftests/bpf/xsk.h
index 04ed8b544712..8da8d557768b 100644
--- a/tools/testing/selftests/bpf/xsk.h
+++ b/tools/testing/selftests/bpf/xsk.h
@@ -134,6 +134,11 @@ static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, __u32 nb)
 	__atomic_store_n(prod->producer, *prod->producer + nb, __ATOMIC_RELEASE);
 }
 
+static inline void xsk_ring_prod__cancel(struct xsk_ring_prod *prod, __u32 nb)
+{
+	prod->cached_prod -= nb;
+}
+
 static inline __u32 xsk_ring_cons__peek(struct xsk_ring_cons *cons, __u32 nb, __u32 *idx)
 {
 	__u32 entries = xsk_cons_nb_avail(cons, nb);
diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 325e73a04734..f12847aead76 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -531,6 +531,18 @@ static struct pkt_stream *__pkt_stream_alloc(u32 nb_pkts)
 	return pkt_stream;
 }
 
+static u32 ceil_u32(u32 a, u32 b)
+{
+	return (a + b - 1) / b;
+}
+
+static u32 pkt_nb_frags(u32 frame_size, struct pkt *pkt)
+{
+	if (!pkt || !pkt->valid)
+		return 1;
+	return ceil_u32(pkt->len, frame_size);
+}
+
 static void pkt_set(struct xsk_umem_info *umem, struct pkt *pkt, int offset, u32 len)
 {
 	pkt->offset = offset;
@@ -1159,9 +1171,11 @@ static void thread_common_ops_tx(struct test_spec *test, struct ifobject *ifobje
 	ifobject->umem->base_addr = 0;
 }
 
-static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream *pkt_stream)
+static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream *pkt_stream,
+				   bool fill_up)
 {
-	u32 idx = 0, i, buffers_to_fill, nb_pkts;
+	u32 rx_frame_size = umem->frame_size - XDP_PACKET_HEADROOM;
+	u32 idx = 0, filled = 0, buffers_to_fill, nb_pkts;
 	int ret;
 
 	if (umem->num_frames < XSK_RING_PROD__DEFAULT_NUM_DESCS)
@@ -1173,19 +1187,29 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream
 	if (ret != buffers_to_fill)
 		exit_with_error(ENOSPC);
 
-	for (i = 0; i < buffers_to_fill; i++) {
+	while (filled < buffers_to_fill) {
 		struct pkt *pkt = pkt_stream_get_next_rx_pkt(pkt_stream, &nb_pkts);
 		u64 addr;
+		u32 i;
+
+		for (i = 0; i < pkt_nb_frags(rx_frame_size, pkt); i++) {
+			if (!pkt) {
+				if (!fill_up)
+					break;
+				addr = filled * umem->frame_size + umem->base_addr;
+			} else if (pkt->offset >= 0) {
+				addr = pkt->offset % umem->frame_size + umem_alloc_buffer(umem);
+			} else {
+				addr = pkt->offset + umem_alloc_buffer(umem);
+			}
 
-		if (!pkt)
-			addr = i * umem->frame_size + umem->base_addr;
-		else if (pkt->offset >= 0)
-			addr = pkt->offset % umem->frame_size + umem_alloc_buffer(umem);
-		else
-			addr = pkt->offset + umem_alloc_buffer(umem);
-		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
+			*xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
+			if (++filled >= buffers_to_fill)
+				break;
+		}
 	}
-	xsk_ring_prod__submit(&umem->fq, i);
+	xsk_ring_prod__submit(&umem->fq, filled);
+	xsk_ring_prod__cancel(&umem->fq, buffers_to_fill - filled);
 
 	pkt_stream_reset(pkt_stream);
 	umem_reset_alloc(umem);
@@ -1220,7 +1244,7 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (!ifobject->rx_on)
 		return;
 
-	xsk_populate_fill_ring(ifobject->umem, ifobject->pkt_stream);
+	xsk_populate_fill_ring(ifobject->umem, ifobject->pkt_stream, ifobject->use_fill_ring);
 
 	ret = xsk_update_xskmap(ifobject->xskmap, ifobject->xsk->xsk);
 	if (ret)
-- 
2.34.1


