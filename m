Return-Path: <netdev+bounces-2953-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C9C704ACF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:36:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78C28281721
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078F631112;
	Tue, 16 May 2023 10:32:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58EE3110C;
	Tue, 16 May 2023 10:32:00 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4032365A7;
	Tue, 16 May 2023 03:31:34 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f4291ab0d1so14985915e9.1;
        Tue, 16 May 2023 03:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684233093; x=1686825093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cVFW3T86p+iUVwicCG9hOZaPA9qq7gNMi69Gl8f2m/M=;
        b=SyOLI5G3m+Zb51pdkhNTgTq0p5fftWlRxHBKIwDT8KpDLgkjhcJapF1nh4xfFt0sM2
         QwNDEAOCTpevGG5y1IdvW7RTyTihFH6tsf6DMMvMVafE4YWCOx07K+0DKYZEMed1/eGK
         Bnbg/UTPvaVWU3tDtAFrHhgepyTdM9VMJ74Kiz2Xg23odmlZMF+RZYHY8OZJTy+gK9GA
         kY/DF2LQKCqHvwLIASM/TsdomVdlHzL9ft31b8w2HJw/Gn0grwambr1bKOlk4quIQtHa
         NsFIYLDSH4AlNF7NdjXeAA3QwUU83qD7qJjjxPhnL8LdnI+3LYo9adGw7WKlLk+Qb4LG
         pl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684233093; x=1686825093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cVFW3T86p+iUVwicCG9hOZaPA9qq7gNMi69Gl8f2m/M=;
        b=hr0fyCf9yIqlTkWVuWxAtYvwCdnXV4FOv6VKVHHHVilojOS084qLxfTKQ/kmWMRz9o
         /zb+xYGgAfrfTRls3OqHlHKfvIsZoTxPUKRaTWTVEwOb0lqZrApbbscL3VSTGQur0FMN
         lgBTfys7mgedhGOtriTFcUnHkBG4yiZRz45h5TxAMtXksMlOo/C6XXC4WPs2itf11VsM
         dadgyKmnjZ6yo00j36UCjBI46nXxYYqHMdn2Bj92jdKQjA3o24VtsXqEMxYLIRSFHXUD
         IPVcOAbiRGxkqXRzVYZm3t774arkwwV2L13OG5mL+/PgfLPsSsL4UPWzzwef0UCWwOwE
         QJtw==
X-Gm-Message-State: AC+VfDzuxRtCzfzl3tlWcOhl2jrUBT/x16Xc3Q6BucOs5hjDS3kzwWE8
	pcM3Q8dGPkJDHJpsNOyTobI=
X-Google-Smtp-Source: ACHHUZ4YUOyjBtOmAj3ntNcUOnnuWRUkU3vobCVSiOh3EvSGFLezeTkEVvxhitgD1ETZzl3EehPk0A==
X-Received: by 2002:a05:600c:1d13:b0:3f4:27ec:9d12 with SMTP id l19-20020a05600c1d1300b003f427ec9d12mr1859689wms.4.1684233092667;
        Tue, 16 May 2023 03:31:32 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id u25-20020a7bc059000000b003f32f013c3csm1888402wmc.6.2023.05.16.03.31.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2023 03:31:32 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 08/10] selftests/xsk: populate fill ring based on frags needed
Date: Tue, 16 May 2023 12:31:07 +0200
Message-Id: <20230516103109.3066-9-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230516103109.3066-1-magnus.karlsson@gmail.com>
References: <20230516103109.3066-1-magnus.karlsson@gmail.com>
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
index f0d929cb730a..c54f25dcf134 100644
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


