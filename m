Return-Path: <netdev+bounces-2091-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CBF57003B2
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:26:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7BB728196D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 961E410781;
	Fri, 12 May 2023 09:21:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812EEBA2B;
	Fri, 12 May 2023 09:21:44 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BE3DDA6;
	Fri, 12 May 2023 02:21:42 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-305ec9ee502so1710527f8f.0;
        Fri, 12 May 2023 02:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683883301; x=1686475301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PzWxyGNbSoBHRNSOnQ8ExEGP+OZDzRJOzFMQHBZbMm4=;
        b=lEWTirmklKR3TThN99xY58rhP/VdXuDuGJjBLcnGWYBJxc8BHzMb0KKS+2ij5nN8Sc
         bpz83wsFAwn5kP81pFx8BFWOb0lcqamfyAHTQCRDxbw1+N3Q9xrto89HYMT0RbdJEU/x
         ExriE3YbEB9lgY08Sm0NWYxXni4XARDEc0iRzZYNaczg/4UI8MG+jMcs9kjj0/O/7iaE
         ATLbfZ/57KWavCNEF4kKBJ2Qpgp0DxJSsR4PRknIpOdesaJkZ2MVO2Wn89jvXHLPsJS+
         hbWRoDom4oNknG/QZzLFTUwJMfVUHVmKU0C5FvRu01zOWEBUUnT5OFneZUqxf/MOFkfS
         fCSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683883301; x=1686475301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PzWxyGNbSoBHRNSOnQ8ExEGP+OZDzRJOzFMQHBZbMm4=;
        b=GgBbL4Q9iEdv0v+pCxqYWmUvpfY58Ak9Cqv81a+FQWtVUSBs0QYz7lcivmnX6aOqib
         NEkEuCo/VVBUr2qyfb7sEPyaH4LjTXHRLzDgmuI9GvEtMmgk9lbfCjNtU88M+qqaf2K/
         D1DZatPgASNtYdrr1GmoRsxMLCt8zQMSqrt6V7iU9bpQWbRWZ/ujzgSov0ndrUvDbJEA
         eawAQhzc//NOXAoGIxG0aIbXxgEOsjDBAdSo3O1kwWyamlA0xxGWyuscyQ1npZKW2CKl
         UERVNRLSMDV/WQfXVvTRpFT0msVyuEyYpbWje8gKpG3cXjXX1PLp9DySYfmooWgNUK2r
         Un1g==
X-Gm-Message-State: AC+VfDw7oTXh/f9EvvgkqG9VEj7dwXoqjr6+V77mbAbvA7tCnhoYXyhf
	FjvQLDCXXkGN7sA93O9Is6s=
X-Google-Smtp-Source: ACHHUZ4OWXIvsnYC/z+n6acuXu9nQEMOT9hNn/Z3/Bpl8ppHF9tP5lPfqXkPd07QkPbl8vj1uBEjFw==
X-Received: by 2002:a5d:50c5:0:b0:307:d1a4:8066 with SMTP id f5-20020a5d50c5000000b00307d1a48066mr2066265wrt.5.1683883300835;
        Fri, 12 May 2023 02:21:40 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id i14-20020a5d558e000000b003079f2c2de7sm11467789wrv.112.2023.05.12.02.21.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 May 2023 02:21:40 -0700 (PDT)
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
Subject: [PATCH bpf-next 09/10] selftests/xsk: generate data for multi-buffer packets
Date: Fri, 12 May 2023 11:20:42 +0200
Message-Id: <20230512092043.3028-10-magnus.karlsson@gmail.com>
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
index f12847aead76..c21c57a1f6e9 100644
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


