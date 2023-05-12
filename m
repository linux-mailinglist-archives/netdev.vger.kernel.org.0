Return-Path: <netdev+bounces-2086-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 279BD700399
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:23:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 414A11C21165
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF74ED310;
	Fri, 12 May 2023 09:21:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE60BE52;
	Fri, 12 May 2023 09:21:34 +0000 (UTC)
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F02DDB9;
	Fri, 12 May 2023 02:21:33 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3063d724cb9so1086901f8f.1;
        Fri, 12 May 2023 02:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683883291; x=1686475291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wVzU4CYKPvYQzMZIhoUqDlJ8u9n8xhP0XTy1Blk9Qn0=;
        b=eIdI8loTrSWoWSvvmQD8x764z67r0UEQQnWTCNrPZ1mA6SPn9WBwKzQVR7erl1gSuQ
         lfQW+kBTNkyOJeGOyfQQqTICk9D2q4YA5ZRZwlQbU03/DRiZPdpcNS5MYW79q6ihNSga
         83NkXa8v8T1TiyltvLEvTieAwjx+XvoVJxJq5e8BscZIPKrPAAZOmyjeWMNich4u9pAb
         5vLbRI2w/WReNfJmE5vXvEyYbQ4Qw7I1y4ec1EJ+DkKiLR9PHlLDWuLfnAsWQhAwhXtN
         4n41HigJ/DQwsFv4pA0tsiJP4HuoJuYhDP/5C7CiyZIWBv+c9Yhr17XWkauSTDKjoVuz
         93nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683883291; x=1686475291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wVzU4CYKPvYQzMZIhoUqDlJ8u9n8xhP0XTy1Blk9Qn0=;
        b=SobBpMUEQvf2yD0vVpkQAq22qyOZw95WUNbU90sK6Awh5QUArCxm2Ex8Bb9ppl7wgw
         l3jPy11hiGBYIg2WJysd6oXwrif7Xn6M9NZJpNIYEHd46aOv8FE0isqBIXPRN6jnKPsc
         YhUpILnn0fzy92v+vjImeqO3wNyN8HaukV0QxPuH1fhmUQ3jvRrIZ/F9sq6oG1L+BXNh
         hcmcZpu3bWr2g2DXQRopHJELjViq73DVpCdwYbd0J1vJBWk9RfdXx+5zrosSPlSWE4E0
         db/m4hdxRO0ePOv4o17WaUR+BOR6nZ1PFdcbPoxHtdw8+oq5PKtYI+lgnIMEYrck647o
         SpXA==
X-Gm-Message-State: AC+VfDwtnpYDang9FxaPSQGPx+uUCKrz8N13Yb12AB3Ejl4ggVzY5JtD
	EzWGwYrE+uB7ZLteMNa1rss=
X-Google-Smtp-Source: ACHHUZ6dx/N05gSNEpEfBmAPBp02LN2t3ReCCGxvKIDNZw9im6jRBc1zID8gFfHOE0DIzgNtsLYKFA==
X-Received: by 2002:a5d:6401:0:b0:2f7:dc6a:9468 with SMTP id z1-20020a5d6401000000b002f7dc6a9468mr14141014wru.3.1683883291242;
        Fri, 12 May 2023 02:21:31 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id i14-20020a5d558e000000b003079f2c2de7sm11467789wrv.112.2023.05.12.02.21.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 May 2023 02:21:30 -0700 (PDT)
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
Subject: [PATCH bpf-next 04/10] selftests/xsk: dump packet at error
Date: Fri, 12 May 2023 11:20:37 +0200
Message-Id: <20230512092043.3028-5-magnus.karlsson@gmail.com>
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

Dump the content of the packet when a test finds that packets are
received out of order, the length is wrong, or some other packet
error. Use the already existing pkt_dump function for this and call it
when the above errors are detected. Get rid of the command line option
for dumping packets as it is not useful to print out thousands of
good packets followed by the faulty one you would like to see.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh  | 10 +---------
 tools/testing/selftests/bpf/xskxceiver.c | 20 ++++++++------------
 tools/testing/selftests/bpf/xskxceiver.h |  1 -
 3 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 377fb157a57c..c2ad50f26b63 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -68,9 +68,6 @@
 # Run with verbose output:
 #   sudo ./test_xsk.sh -v
 #
-# Run and dump packet contents:
-#   sudo ./test_xsk.sh -D
-#
 # Set up veth interfaces and leave them up so xskxceiver can be launched in a debugger:
 #   sudo ./test_xsk.sh -d
 #
@@ -81,11 +78,10 @@
 
 ETH=""
 
-while getopts "vDi:d" flag
+while getopts "vi:d" flag
 do
 	case "${flag}" in
 		v) verbose=1;;
-		D) dump_pkts=1;;
 		d) debug=1;;
 		i) ETH=${OPTARG};;
 	esac
@@ -157,10 +153,6 @@ if [[ $verbose -eq 1 ]]; then
 	ARGS+="-v "
 fi
 
-if [[ $dump_pkts -eq 1 ]]; then
-	ARGS="-D "
-fi
-
 retval=$?
 test_status $retval "${TEST_NAME}"
 
diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 818b7130f932..0a8231ed6626 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -275,7 +275,6 @@ static bool ifobj_zc_avail(struct ifobject *ifobject)
 static struct option long_options[] = {
 	{"interface", required_argument, 0, 'i'},
 	{"busy-poll", no_argument, 0, 'b'},
-	{"dump-pkts", no_argument, 0, 'D'},
 	{"verbose", no_argument, 0, 'v'},
 	{0, 0, 0, 0}
 };
@@ -286,7 +285,6 @@ static void usage(const char *prog)
 		"  Usage: %s [OPTIONS]\n"
 		"  Options:\n"
 		"  -i, --interface      Use interface\n"
-		"  -D, --dump-pkts      Dump packets L2 - L5\n"
 		"  -v, --verbose        Verbose output\n"
 		"  -b, --busy-poll      Enable busy poll\n";
 
@@ -310,7 +308,7 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:Dvb", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:vb", long_options, &option_index);
 		if (c == -1)
 			break;
 
@@ -332,9 +330,6 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
 
 			interface_nb++;
 			break;
-		case 'D':
-			opt_pkt_dump = true;
-			break;
 		case 'v':
 			opt_verbose = true;
 			break;
@@ -714,7 +709,7 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 
 	if (!pkt) {
 		ksft_print_msg("[%s] too many packets received\n", __func__);
-		return false;
+		goto error;
 	}
 
 	if (len < MIN_PKT_SIZE || pkt->len < MIN_PKT_SIZE) {
@@ -725,22 +720,23 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 	if (pkt->len != len) {
 		ksft_print_msg("[%s] expected length [%d], got length [%d]\n",
 			       __func__, pkt->len, len);
-		return false;
+		goto error;
 	}
 
 	pkt_data = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
 	seqnum = pkt_data >> 16;
 
-	if (opt_pkt_dump)
-		pkt_dump(data, len);
-
 	if (pkt->pkt_nb != seqnum) {
 		ksft_print_msg("[%s] expected seqnum [%d], got seqnum [%d]\n",
 			       __func__, pkt->pkt_nb, seqnum);
-		return false;
+		goto error;
 	}
 
 	return true;
+
+error:
+	pkt_dump(data, len);
+	return false;
 }
 
 static void kick_tx(struct xsk_socket_info *xsk)
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 91022c4876eb..5e0be9685557 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -85,7 +85,6 @@ enum test_type {
 	TEST_TYPE_MAX
 };
 
-static bool opt_pkt_dump;
 static bool opt_verbose;
 
 struct xsk_umem_info {
-- 
2.34.1


