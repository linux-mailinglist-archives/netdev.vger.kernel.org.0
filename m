Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C499A6B2C17
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjCIRdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjCIRdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:33:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956925FD6;
        Thu,  9 Mar 2023 09:33:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 434A8B81F91;
        Thu,  9 Mar 2023 17:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0F2C433D2;
        Thu,  9 Mar 2023 17:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678383178;
        bh=uiqiHQhIDw0aOs9OoPbT2HL8T0pBYxQnLuDKWp12tr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3ezjJHhqw0YyHjVMve9npPq9ivFX3VwWvCvSZI0y1R6Lzy9RmJJB39ruSRBvsz9w
         r4XMQPEWdpVFkapvX0BzXoeQ4NT8qUGai/+gj6Ci5/RFsWR36bwOMPHxiZpT2JVBZS
         M1eKwmMHvkol0o6ZjhLZWzYW+gsxLmpL4paY6G6I7v8psjv4a+1dJbNFNeM+g04HIY
         S3GYwM/QC6Mroxu6OhpmrH/VxJbrsPrXlPXGGAiebxFvpjbgGSQSdinoN01XaGuM41
         0FOvnYo9iLEBNWq01lSE2J0qLWmDZd+JcfL7WhX/1TwXHv0e1ebePCOyluj0x7F1PS
         akOVnVAZPRWGw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        lorenzo.bianconi@redhat.com, daniel@iogearbox.net
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: improve error logs in XDP compliance test tool
Date:   Thu,  9 Mar 2023 18:32:41 +0100
Message-Id: <212fc5bd214ff706f6ef1acbe7272cf4d803ca9c.1678382940.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678382940.git.lorenzo@kernel.org>
References: <cover.1678382940.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve some error logs reported in the XDP compliance test tool

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/testing/selftests/bpf/xdp_features.c | 23 +++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdp_features.c b/tools/testing/selftests/bpf/xdp_features.c
index b060a0d24e44..b449788fbd39 100644
--- a/tools/testing/selftests/bpf/xdp_features.c
+++ b/tools/testing/selftests/bpf/xdp_features.c
@@ -152,20 +152,26 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 	case 'D':
 		if (make_sockaddr(AF_INET6, arg, DUT_ECHO_PORT,
 				  &env.dut_addr, NULL)) {
-			fprintf(stderr, "Invalid DUT address: %s\n", arg);
+			fprintf(stderr,
+				"Invalid address assigned to the Device Under Test: %s\n",
+				arg);
 			return ARGP_ERR_UNKNOWN;
 		}
 		break;
 	case 'C':
 		if (make_sockaddr(AF_INET6, arg, DUT_CTRL_PORT,
 				  &env.dut_ctrl_addr, NULL)) {
-			fprintf(stderr, "Invalid DUT CTRL address: %s\n", arg);
+			fprintf(stderr,
+				"Invalid address assigned to the Device Under Test: %s\n",
+				arg);
 			return ARGP_ERR_UNKNOWN;
 		}
 		break;
 	case 'T':
 		if (make_sockaddr(AF_INET6, arg, 0, &env.tester_addr, NULL)) {
-			fprintf(stderr, "Invalid Tester address: %s\n", arg);
+			fprintf(stderr,
+				"Invalid address assigned to the Tester device: %s\n",
+				arg);
 			return ARGP_ERR_UNKNOWN;
 		}
 		break;
@@ -454,7 +460,8 @@ static int dut_run(struct xdp_features *skel)
 						   &key, sizeof(key),
 						   &val, sizeof(val), 0);
 			if (err) {
-				fprintf(stderr, "bpf_map_lookup_elem failed\n");
+				fprintf(stderr,
+					"bpf_map_lookup_elem failed (%d)\n", err);
 				goto end_thread;
 			}
 
@@ -496,7 +503,7 @@ static bool tester_collect_detected_cap(struct xdp_features *skel,
 	err = bpf_map__lookup_elem(skel->maps.stats, &key, sizeof(key),
 				   &val, sizeof(val), 0);
 	if (err) {
-		fprintf(stderr, "bpf_map_lookup_elem failed\n");
+		fprintf(stderr, "bpf_map_lookup_elem failed (%d)\n", err);
 		return false;
 	}
 
@@ -574,7 +581,8 @@ static int tester_run(struct xdp_features *skel)
 
 	sockfd = socket(AF_INET6, SOCK_STREAM, 0);
 	if (sockfd < 0) {
-		fprintf(stderr, "Failed to create tester socket\n");
+		fprintf(stderr,
+			"Failed creating tester service control socket\n");
 		return -errno;
 	}
 
@@ -584,7 +592,8 @@ static int tester_run(struct xdp_features *skel)
 	err = connect(sockfd, (struct sockaddr *)&env.dut_ctrl_addr,
 		      sizeof(env.dut_ctrl_addr));
 	if (err) {
-		fprintf(stderr, "Failed to connect to the DUT\n");
+		fprintf(stderr,
+			"Failed connecting to the Device Under Test control socket\n");
 		return -errno;
 	}
 
-- 
2.39.2

