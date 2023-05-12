Return-Path: <netdev+bounces-2085-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61DF1700391
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:22:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C8E4281A24
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D22FD2F2;
	Fri, 12 May 2023 09:21:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77062BE52;
	Fri, 12 May 2023 09:21:33 +0000 (UTC)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F17100D2;
	Fri, 12 May 2023 02:21:31 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-3064056fa4eso1338489f8f.1;
        Fri, 12 May 2023 02:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683883289; x=1686475289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ADrLIudJEqa2KFDZWadIt2+wacBHhNnK2QOQzGO9tEM=;
        b=USVZFRr6rRXasoG7Uy6utlwOuiZ0M97JAXdf7jti2zuCv0tmKP3L+Qc2LveeF045f8
         jhofYOkMX7j3U7ixpd7nYSR6h6j2vJaobO6KpDuCqic3tZV9btn3zNjG4wJCyna6ZLLF
         /P97avuy36BbhfDKi08M/rKTQb5kQ3cUq0+KpZdODIshCzvNCRfRzKqRno+NKQA9ocTi
         gjgajapqi8MDiesZ1vx0hIMU241McilctZ0sBVV5hvH5pZa0oKL+WsaLNyULnl2WzCQM
         uzcJalXYcmtRChXyWBXfjEyRgGP5jU1FTDI6n+qKmL3uO6ezT0aOryQdajSclWR3nsQm
         6U3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683883289; x=1686475289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ADrLIudJEqa2KFDZWadIt2+wacBHhNnK2QOQzGO9tEM=;
        b=I7cw/5hcmOTzMB7FSbpeQXWzDFauBXTV3SSVy9ix1VxEqxfQc4kJ007X3CNCG21JT+
         4t+aT1Qmh9HRXm7i1jMJs2pASOp5dCqlitLD+XDUDGHun/mZps/32w4XvUMH8ruKHYq1
         /bIQh5tkgewP7s6hewP/bvza6fuWOEGS69cl+dZTFRbBQ7UWA/Jqqim/4u5PJoLbCBSC
         rIxvJKt5hvluM743qxNr0psVGagsvij6JJZFmjozdRKUtvq4k9pEOcgTtTsP2c93tivE
         ScceTabGAYBqLDaHPVBCvvtiD1tz0+4oIpK9od0RdZXayyjiw/45Bca2BjWKezQNadIw
         mCpQ==
X-Gm-Message-State: AC+VfDz33IpUbAtgQCzJxijzusz2x7/sGF266vF1qMHo4ZdMVKaul2zn
	FUM7+K550pt2UfCkxLOa6Mo=
X-Google-Smtp-Source: ACHHUZ7TOOX30ukfqbrmDRFChlQxW2hJB/kvsJVcpRwL/WF3jR23oVz0gQ+ntuxZk8jBq0H4WDwfsA==
X-Received: by 2002:a05:6000:1250:b0:306:2707:35dc with SMTP id j16-20020a056000125000b00306270735dcmr12432153wrx.5.1683883289341;
        Fri, 12 May 2023 02:21:29 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id i14-20020a5d558e000000b003079f2c2de7sm11467789wrv.112.2023.05.12.02.21.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 May 2023 02:21:28 -0700 (PDT)
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
Subject: [PATCH bpf-next 03/10] selftests/xsk: add varying payload pattern within packet
Date: Fri, 12 May 2023 11:20:36 +0200
Message-Id: <20230512092043.3028-4-magnus.karlsson@gmail.com>
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

Add a varying payload pattern within the packet. Instead of having
just a packet number that is the same for all words in a packet, make
each word different in the packet. The upper 16-bits are set to the
packet number and the lower 16-bits are the sequence number of the
words in this packet. So the 3rd packet's 5th 32-bit word of data will
contain the number (2<<32) | 4 as they are numbered from 0.

This will make it easier to detect fragments that are out of order
when starting to test multi-buffer support.

The member payload in the packet is renamed pkt_nb to reflect that it
is now only a pkt_nb, not the real payload as seen above.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 68 ++++++++++++++++--------
 tools/testing/selftests/bpf/xskxceiver.h |  3 +-
 2 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index c13478875fb1..818b7130f932 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -138,15 +138,16 @@ static void report_failure(struct test_spec *test)
 	test->fail = true;
 }
 
-static void memset32_htonl(void *dest, u32 val, u32 size)
+/* The payload is a word consisting of a packet sequence number in the upper
+ * 16-bits and a intra packet data sequence number in the lower 16 bits. So the 3rd packet's
+ * 5th word of data will contain the number (2<<16) | 4 as they are numbered from 0.
+ */
+static void write_payload(void *dest, u32 val, u32 size)
 {
-	u32 *ptr = (u32 *)dest;
-	int i;
+	u32 *ptr = (u32 *)dest, i;
 
-	val = htonl(val);
-
-	for (i = 0; i < (size & (~0x3)); i += 4)
-		ptr[i >> 2] = val;
+	for (i = 0; i < size / sizeof(*ptr); i++)
+		ptr[i] = htonl(val << 16 | i);
 }
 
 static void gen_eth_hdr(struct ifobject *ifobject, struct ethhdr *eth_hdr)
@@ -532,7 +533,7 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 	for (i = 0; i < nb_pkts; i++) {
 		pkt_set(umem, &pkt_stream->pkts[i], (i % umem->num_frames) * umem->frame_size,
 			pkt_len);
-		pkt_stream->pkts[i].payload = i;
+		pkt_stream->pkts[i].pkt_nb = i;
 	}
 
 	return pkt_stream;
@@ -603,7 +604,7 @@ static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
 	eth_hdr = data;
 
 	gen_eth_hdr(ifobject, eth_hdr);
-	memset32_htonl(data + PKT_HDR_SIZE, pkt_nb, pkt->len - PKT_HDR_SIZE);
+	write_payload(data + PKT_HDR_SIZE, pkt_nb, pkt->len - PKT_HDR_SIZE);
 
 	return pkt;
 }
@@ -621,7 +622,7 @@ static void __pkt_stream_generate_custom(struct ifobject *ifobj,
 	for (i = 0; i < nb_pkts; i++) {
 		pkt_stream->pkts[i].addr = pkts[i].addr + ifobj->umem->base_addr;
 		pkt_stream->pkts[i].len = pkts[i].len;
-		pkt_stream->pkts[i].payload = i;
+		pkt_stream->pkts[i].pkt_nb = i;
 		pkt_stream->pkts[i].valid = pkts[i].valid;
 	}
 
@@ -634,10 +635,24 @@ static void pkt_stream_generate_custom(struct test_spec *test, struct pkt *pkts,
 	__pkt_stream_generate_custom(test->ifobj_rx, pkts, nb_pkts);
 }
 
-static void pkt_dump(void *pkt)
+static void pkt_print_data(u32 *data, u32 cnt)
+{
+	u32 i;
+
+	for (i = 0; i < cnt; i++) {
+		u32 seqnum, pkt_nb;
+
+		seqnum = ntohl(*data) & 0xffff;
+		pkt_nb = ntohl(*data) >> 16;
+		fprintf(stdout, "%u:%u ", pkt_nb, seqnum);
+		data++;
+	}
+}
+
+static void pkt_dump(void *pkt, u32 len)
 {
 	struct ethhdr *ethhdr = pkt;
-	u32 payload, i;
+	u32 i;
 
 	/*extract L2 frame */
 	fprintf(stdout, "DEBUG>> L2: dst mac: ");
@@ -649,10 +664,15 @@ static void pkt_dump(void *pkt)
 		fprintf(stdout, "%02X", ethhdr->h_source[i]);
 
 	/*extract L5 frame */
-	payload = ntohl(*((u32 *)(pkt + PKT_HDR_SIZE)));
-
-	fprintf(stdout, "\nDEBUG>> L5: payload: %d\n", payload);
-	fprintf(stdout, "---------------------------------------\n");
+	fprintf(stdout, "\nDEBUG>> L5: seqnum: ");
+	pkt_print_data(pkt + PKT_HDR_SIZE, PKT_DUMP_NB_TO_PRINT);
+	fprintf(stdout, "....");
+	if (len > PKT_DUMP_NB_TO_PRINT * sizeof(u32)) {
+		fprintf(stdout, "\n.... ");
+		pkt_print_data(pkt + PKT_HDR_SIZE + len - PKT_DUMP_NB_TO_PRINT * sizeof(u32),
+			       PKT_DUMP_NB_TO_PRINT);
+	}
+	fprintf(stdout, "\n---------------------------------------\n");
 }
 
 static bool is_offset_correct(struct xsk_umem_info *umem, struct pkt_stream *pkt_stream, u64 addr,
@@ -678,9 +698,9 @@ static bool is_metadata_correct(struct pkt *pkt, void *buffer, u64 addr)
 	void *data = xsk_umem__get_data(buffer, addr);
 	struct xdp_info *meta = data - sizeof(struct xdp_info);
 
-	if (meta->count != pkt->payload) {
+	if (meta->count != pkt->pkt_nb) {
 		ksft_print_msg("[%s] expected meta_count [%d], got meta_count [%d]\n",
-			       __func__, pkt->payload, meta->count);
+			       __func__, pkt->pkt_nb, meta->count);
 		return false;
 	}
 
@@ -690,7 +710,7 @@ static bool is_metadata_correct(struct pkt *pkt, void *buffer, u64 addr)
 static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 {
 	void *data = xsk_umem__get_data(buffer, addr);
-	u32 seqnum;
+	u32 seqnum, pkt_data;
 
 	if (!pkt) {
 		ksft_print_msg("[%s] too many packets received\n", __func__);
@@ -708,13 +728,15 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 		return false;
 	}
 
-	seqnum = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
+	pkt_data = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
+	seqnum = pkt_data >> 16;
+
 	if (opt_pkt_dump)
-		pkt_dump(data);
+		pkt_dump(data, len);
 
-	if (pkt->payload != seqnum) {
+	if (pkt->pkt_nb != seqnum) {
 		ksft_print_msg("[%s] expected seqnum [%d], got seqnum [%d]\n",
-			       __func__, pkt->payload, seqnum);
+			       __func__, pkt->pkt_nb, seqnum);
 		return false;
 	}
 
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 8b094718629d..91022c4876eb 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -48,6 +48,7 @@
 #define UMEM_HEADROOM_TEST_SIZE 128
 #define XSK_UMEM__INVALID_FRAME_SIZE (XSK_UMEM__DEFAULT_FRAME_SIZE + 1)
 #define HUGEPAGE_SIZE (2 * 1024 * 1024)
+#define PKT_DUMP_NB_TO_PRINT 16
 
 #define print_verbose(x...) do { if (opt_verbose) ksft_print_msg(x); } while (0)
 
@@ -111,7 +112,7 @@ struct xsk_socket_info {
 struct pkt {
 	u64 addr;
 	u32 len;
-	u32 payload;
+	u32 pkt_nb;
 	bool valid;
 };
 
-- 
2.34.1


