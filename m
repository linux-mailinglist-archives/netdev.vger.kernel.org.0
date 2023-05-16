Return-Path: <netdev+bounces-2948-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E02A1704AB6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12AE72815B6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3076E1F170;
	Tue, 16 May 2023 10:31:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2178621090;
	Tue, 16 May 2023 10:31:50 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBAD199C;
	Tue, 16 May 2023 03:31:26 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f42b429290so16462995e9.0;
        Tue, 16 May 2023 03:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684233085; x=1686825085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wVzU4CYKPvYQzMZIhoUqDlJ8u9n8xhP0XTy1Blk9Qn0=;
        b=XTMHi7ttmOp3lTUZfgWEsEv4qciloXBGD+I/gU7oMt4+qbKuQ0xGaSrUOFOLKAaSt3
         +M72jlK0p0dWIviGXRdSgelFY3SC1H9GgMuTSNsPKT7ljOCS8WiRwT27GUpXUWXUq04F
         NXjpYCoPJwwnZjmxPXXnk5hpUWFUi67z7tCkSqkJtXCNoTDZDn7PrqTSIQooS0RymDPB
         eVezitajoLcnQ7AuCcYNNZi9qwSPmykZeZExy5rqR/tdZqhxqO8CbBriALYa9oAGDkWy
         hZuybJqTUURCcuhFMa7sUHFe+0ncPGN62cKwPEovxXdkZoJKnDeHogXdg+htGYM0NG9I
         86Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684233085; x=1686825085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wVzU4CYKPvYQzMZIhoUqDlJ8u9n8xhP0XTy1Blk9Qn0=;
        b=eQ9jyLdv3cdmq2Yk6pgBQpyJNAVOu7JYXWCK63RjQEOzkgh1lyYGeOrqPcwJHhg1xW
         R+FzuPPmWN8Ue61yRblYdqIfMJbcRm4Cg+gpJtvvxt/VVtWueJ7MyndpNQxvDaTjqKZS
         YNlcCQDKKVYrZxrgfTIy8sDu3bRjMUqcqWlFjJPKIUtobpGnvIveAV6mNTDoM/UwY1zh
         j6tzNP6nPoSto/wVHDWD16JJkX+RNwPiWdtgbooyMDksU4VquxrDVnzHkJyQmzfdbdb2
         GA+kTychap3YfO5FFBcCKn/de0Xzra7gKMH5h3uW8LKXlzZphIuvaVpGgac+qyZqSrfL
         9ONw==
X-Gm-Message-State: AC+VfDyOOgYE6LALvbB5cy0l3feAFQvvqJUYZv1Sy1BfSVt7Al9eVQQZ
	hs+GTAznRwq6LUmhCOuaKA4=
X-Google-Smtp-Source: ACHHUZ4UVrF/5PPIQ5Lu3MLinU9wBFl1gRBY1/EfCgC0trQKpUjXUYoVCcjcaY20C8tSS78crE4HJw==
X-Received: by 2002:a05:600c:198d:b0:3f4:26ce:e7be with SMTP id t13-20020a05600c198d00b003f426cee7bemr1848500wmq.3.1684233084843;
        Tue, 16 May 2023 03:31:24 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id u25-20020a7bc059000000b003f32f013c3csm1888402wmc.6.2023.05.16.03.31.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2023 03:31:24 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 04/10] selftests/xsk: dump packet at error
Date: Tue, 16 May 2023 12:31:03 +0200
Message-Id: <20230516103109.3066-5-magnus.karlsson@gmail.com>
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


