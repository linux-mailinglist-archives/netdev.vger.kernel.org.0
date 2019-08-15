Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D718E350
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 05:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbfHODq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 23:46:29 -0400
Received: from mga04.intel.com ([192.55.52.120]:56749 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729479AbfHODqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 23:46:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 20:46:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,387,1559545200"; 
   d="scan'208";a="352124063"
Received: from arch-p28.jf.intel.com ([10.166.187.31])
  by orsmga005.jf.intel.com with ESMTP; 14 Aug 2019 20:46:23 -0700
From:   Sridhar Samudrala <sridhar.samudrala@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        sridhar.samudrala@intel.com, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Subject: [PATCH bpf-next 5/5] xdpsock_user: Add skip_bpf option
Date:   Wed, 14 Aug 2019 20:46:23 -0700
Message-Id: <1565840783-8269-6-git-send-email-sridhar.samudrala@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com>
References: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
---
 samples/bpf/xdpsock_user.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 93eaaf7239b2..509fc6a18af9 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -123,6 +123,9 @@ static void print_benchmark(bool running)
 	if (opt_poll)
 		printf("poll() ");
 
+	if (opt_xdp_bind_flags & XDP_SKIP_BPF)
+		printf("skip-bpf ");
+
 	if (running) {
 		printf("running...");
 		fflush(stdout);
@@ -352,6 +355,7 @@ static struct option long_options[] = {
 	{"zero-copy", no_argument, 0, 'z'},
 	{"copy", no_argument, 0, 'c'},
 	{"frame-size", required_argument, 0, 'f'},
+	{"skip-bpf", no_argument, 0, 's'},
 	{0, 0, 0, 0}
 };
 
@@ -372,6 +376,7 @@ static void usage(const char *prog)
 		"  -z, --zero-copy      Force zero-copy mode.\n"
 		"  -c, --copy           Force copy mode.\n"
 		"  -f, --frame-size=n   Set the frame size (must be a power of two, default is %d).\n"
+		"  -s, --skip-bpf       Skip running bpf program.\n"
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE);
 	exit(EXIT_FAILURE);
@@ -430,6 +435,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'f':
 			opt_xsk_frame_size = atoi(optarg);
 			break;
+		case 's':
+			opt_xdp_bind_flags |= XDP_SKIP_BPF;
+			break;
 		default:
 			usage(basename(argv[0]));
 		}
-- 
2.20.1

