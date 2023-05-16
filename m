Return-Path: <netdev+bounces-2954-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 965A5704AD5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:37:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 433D3281766
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AFFB28C03;
	Tue, 16 May 2023 10:32:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F52B23D77;
	Tue, 16 May 2023 10:32:08 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4BE6587;
	Tue, 16 May 2023 03:31:38 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f42b429290so16463325e9.0;
        Tue, 16 May 2023 03:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684233095; x=1686825095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nSYtRNfYONts4GRJ8UW9ZMF1+6UseePukNUkitiAmyw=;
        b=VaAN5Y93PO+JPXvy1OmFTAVDRchvET/1N9rJR+HmSHE19OYCzjQXJSpncSCsClBq4U
         z8+ds/QXtQGcwSRekJb1RaHL2l0zKBxk8/0ddnHCnB5dPRrbnud4ZioNx1J9xJ/bBx+u
         7OoAX9JrIkuimyBL4sOT07fCV/9qI+FIhgw3ALrvTpjD0FpbFibnApwsM+me0++MsbAb
         L02L14HQZWtYYpuLqnANvJsYTCb66mhZ28Klaw78fipidlzTgefHDEKreSXTHHldvMH1
         1ZSnzyLPAjnz+713n9SBeJ17Lw3UdohrmnqgluAk4L085NX3qyvrUEuKGdwfEZdjvl+/
         Wnew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684233095; x=1686825095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nSYtRNfYONts4GRJ8UW9ZMF1+6UseePukNUkitiAmyw=;
        b=dKRy0mzkjjjnIERuX7ASVCs2B/N5V8NsOKcp1xfJL/vLAWGJXspZbmI1H2HgaHfgiA
         ZzKjrP1j9B69tZNx1dgr8CSZLv/IfqWIst8bsE7PlxasFZ/rPBNxg+Om4xXfUQTKZWW+
         Znul919vZnjmH+d0KMjlaXzIM1gkFd//Y3twA7Vj+Y0e4MVeNWPBC/wg2567/vH3tgad
         bcqfWHx8w3tQr8FOPb2LPhzrAMfA3Dg6qt7Mgxz/JnaMIr5npfRt4pdXA1IOmq209TCJ
         qHMnn8rSDnJu7cZBkXUrPc//9d2nzd8A+78honsrWNSs0+1zfVuR+88ITO/9sIGNIThC
         ZF+g==
X-Gm-Message-State: AC+VfDwK2vjBZPV578MErlbwNJ2f+Pl98E8N1uQIR2hRu12krchLR+cQ
	PtCSv5PXW2ZGUhsJFQRNTAZzWRyu4daS775zX7k=
X-Google-Smtp-Source: ACHHUZ4TSa2F87TZl15s7MK31f8WU40KFcOFSrpOWQccn07vGBQVMbAUQx5u0HiFeByW44dEKpHxOQ==
X-Received: by 2002:a05:600c:198d:b0:3f4:26ce:e7be with SMTP id t13-20020a05600c198d00b003f426cee7bemr1848888wmq.3.1684233094763;
        Tue, 16 May 2023 03:31:34 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id u25-20020a7bc059000000b003f32f013c3csm1888402wmc.6.2023.05.16.03.31.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2023 03:31:34 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 09/10] selftests/xsk: generate data for multi-buffer packets
Date: Tue, 16 May 2023 12:31:08 +0200
Message-Id: <20230516103109.3066-10-magnus.karlsson@gmail.com>
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

Add the ability to generate data in the packets that are correct for
multi-buffer packets. The ethernet header should only go into the
first fragment followed by data and the others should only have
data. We also need to modify the pkt_dump function so that it knows
what fragment has an ethernet header so it can print this.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 70 +++++++++++++++---------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index c54f25dcf134..b48017611499 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -142,12 +142,14 @@ static void report_failure(struct test_spec *test)
  * 16-bits and a intra packet data sequence number in the lower 16 bits. So the 3rd packet's
  * 5th word of data will contain the number (2<<16) | 4 as they are numbered from 0.
  */
-static void write_payload(void *dest, u32 val, u32 size)
+static void write_payload(void *dest, u32 pkt_nb, u32 start, u32 size)
 {
 	u32 *ptr = (u32 *)dest, i;
 
-	for (i = 0; i < size / sizeof(*ptr); i++)
-		ptr[i] = htonl(val << 16 | i);
+	start /= sizeof(*ptr);
+	size /= sizeof(*ptr);
+	for (i = 0; i < size; i++)
+		ptr[i] = htonl(pkt_nb << 16 | (i + start));
 }
 
 static void gen_eth_hdr(struct ifobject *ifobject, struct ethhdr *eth_hdr)
@@ -563,8 +565,10 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 		exit_with_error(ENOMEM);
 
 	for (i = 0; i < nb_pkts; i++) {
-		pkt_set(umem, &pkt_stream->pkts[i], 0, pkt_len);
-		pkt_stream->pkts[i].pkt_nb = i;
+		struct pkt *pkt = &pkt_stream->pkts[i];
+
+		pkt_set(umem, pkt, 0, pkt_len);
+		pkt->pkt_nb = i;
 	}
 
 	return pkt_stream;
@@ -626,19 +630,24 @@ static u64 pkt_get_addr(struct pkt *pkt, struct xsk_umem_info *umem)
 	return pkt->offset + umem_alloc_buffer(umem);
 }
 
-static void pkt_generate(struct ifobject *ifobject, struct pkt *pkt, u64 addr)
+static void pkt_generate(struct ifobject *ifobject, u64 addr, u32 len, u32 pkt_nb,
+			 u32 bytes_written)
 {
-	struct ethhdr *eth_hdr;
-	void *data;
+	void *data = xsk_umem__get_data(ifobject->umem->buffer, addr);
 
-	if (!pkt->valid || pkt->len < MIN_PKT_SIZE)
+	if (len < MIN_PKT_SIZE)
 		return;
 
-	data = xsk_umem__get_data(ifobject->umem->buffer, addr);
-	eth_hdr = data;
+	if (!bytes_written) {
+		gen_eth_hdr(ifobject, data);
+
+		len -= PKT_HDR_SIZE;
+		data += PKT_HDR_SIZE;
+	} else {
+		bytes_written -= PKT_HDR_SIZE;
+	}
 
-	gen_eth_hdr(ifobject, eth_hdr);
-	write_payload(data + PKT_HDR_SIZE, pkt->pkt_nb, pkt->len - PKT_HDR_SIZE);
+	write_payload(data, pkt_nb, bytes_written, len);
 }
 
 static void __pkt_stream_generate_custom(struct ifobject *ifobj,
@@ -681,27 +690,33 @@ static void pkt_print_data(u32 *data, u32 cnt)
 	}
 }
 
-static void pkt_dump(void *pkt, u32 len)
+static void pkt_dump(void *pkt, u32 len, bool eth_header)
 {
 	struct ethhdr *ethhdr = pkt;
-	u32 i;
+	u32 i, *data;
 
-	/*extract L2 frame */
-	fprintf(stdout, "DEBUG>> L2: dst mac: ");
-	for (i = 0; i < ETH_ALEN; i++)
-		fprintf(stdout, "%02X", ethhdr->h_dest[i]);
+	if (eth_header) {
+		/*extract L2 frame */
+		fprintf(stdout, "DEBUG>> L2: dst mac: ");
+		for (i = 0; i < ETH_ALEN; i++)
+			fprintf(stdout, "%02X", ethhdr->h_dest[i]);
 
-	fprintf(stdout, "\nDEBUG>> L2: src mac: ");
-	for (i = 0; i < ETH_ALEN; i++)
-		fprintf(stdout, "%02X", ethhdr->h_source[i]);
+		fprintf(stdout, "\nDEBUG>> L2: src mac: ");
+		for (i = 0; i < ETH_ALEN; i++)
+			fprintf(stdout, "%02X", ethhdr->h_source[i]);
+
+		data = pkt + PKT_HDR_SIZE;
+	} else {
+		data = pkt;
+	}
 
 	/*extract L5 frame */
 	fprintf(stdout, "\nDEBUG>> L5: seqnum: ");
-	pkt_print_data(pkt + PKT_HDR_SIZE, PKT_DUMP_NB_TO_PRINT);
+	pkt_print_data(data, PKT_DUMP_NB_TO_PRINT);
 	fprintf(stdout, "....");
 	if (len > PKT_DUMP_NB_TO_PRINT * sizeof(u32)) {
 		fprintf(stdout, "\n.... ");
-		pkt_print_data(pkt + PKT_HDR_SIZE + len - PKT_DUMP_NB_TO_PRINT * sizeof(u32),
+		pkt_print_data(data + len / sizeof(u32) - PKT_DUMP_NB_TO_PRINT,
 			       PKT_DUMP_NB_TO_PRINT);
 	}
 	fprintf(stdout, "\n---------------------------------------\n");
@@ -772,7 +787,7 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 	return true;
 
 error:
-	pkt_dump(data, len);
+	pkt_dump(data, len, true);
 	return false;
 }
 
@@ -959,9 +974,10 @@ static int __send_pkts(struct ifobject *ifobject, struct pollfd *fds, bool timeo
 
 		tx_desc->addr = pkt_get_addr(pkt, ifobject->umem);
 		tx_desc->len = pkt->len;
-		if (pkt->valid)
+		if (pkt->valid) {
 			valid_pkts++;
-		pkt_generate(ifobject, pkt, tx_desc->addr);
+			pkt_generate(ifobject, tx_desc->addr, tx_desc->len, pkt->pkt_nb, 0);
+		}
 	}
 
 	pthread_mutex_lock(&pacing_mutex);
-- 
2.34.1


