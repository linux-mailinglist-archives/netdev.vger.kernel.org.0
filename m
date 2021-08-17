Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B0A3EE9DC
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbhHQJaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239569AbhHQJ3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:53 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49FCC061796;
        Tue, 17 Aug 2021 02:29:18 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so1672413wmb.5;
        Tue, 17 Aug 2021 02:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q7jjebgrGKxQlkniIjuOP2zuL7hbAju2h5FZddpCTD0=;
        b=J2k0UJWYVmIIqCFwOIdHDQBEjFP0qeB2BvhphjIBkHysJ32V6olGBa9RjKuSeBhggP
         V+JPeazVMZZ8m8c4078VG6KDJ2PFLeuHOKnwKa2ykjzqVHaNxAqlGt92zugu7in8S4EW
         5zoAMMKppDuLG1d18GAVpWaTkz/Qnupjxw2LxPH5zj/MyChSHcDywsutuLanpNyUiwbR
         1AsAX1VEH+89i5kieNh85YVd6BHekFvuy+rFYTDhcsIW4YkOOlCpK7D20iRvDYOKjf/A
         /UG+xrDCvfziVvW6PcnvfKgKYTcrkJHVLdqCi12ff1T9F1gvNZJLtp7oe+QxqFbFrkDp
         fGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q7jjebgrGKxQlkniIjuOP2zuL7hbAju2h5FZddpCTD0=;
        b=ic5tUj9xiwwQEXTnFxMu6eXlz2lYFA7BBHWZislHqE83fwouS4fGxLW93k7NQjHf7e
         8qwnI1tLMZJHVK6mUL4gL9/cYZZKxblcab2jQg+DlPMRR+0V6Rz6AvJL3iY8gATU8raI
         ucCi0B2p6YN1/1fjgbh33WETb5ALdrFVMzq7bYAQnIWbjdj7fl9Fg7xLiIfeCX4/D1Lp
         5muoF/Utvmd97SqunZZ6Hfw/9njUfGQI5NNjtj0ppdgHffXnLEOqKJjvHxWOdNMrZORT
         3Kbm/3AFxGPCupq4totKI5ZhIY5cNQ6yyN0A4vkCAEWQgS19M/l7IEnC0+32mk3gxwUS
         5pIg==
X-Gm-Message-State: AOAM531kGOjNs2m7U5n7BwVytYqw+XTuXhKWFhg1gxkR0XXOfKjc+770
        RDmqRvDAYpLWV6/eDRYf3Zo=
X-Google-Smtp-Source: ABdhPJyF5xTGyyu4Au30QXYhp1p8st4dl9COwJ3c2bcX5mlvEreDHHijSvo9UDl+JfpX/QD7y/E/Wg==
X-Received: by 2002:a05:600c:378d:: with SMTP id o13mr2307530wmr.156.1629192557382;
        Tue, 17 Aug 2021 02:29:17 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.29.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:29:16 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 16/16] selftests: xsk: preface options with opt
Date:   Tue, 17 Aug 2021 11:27:29 +0200
Message-Id: <20210817092729.433-17-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Preface all options with opt_ and make them booleans.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 6 +++---
 tools/testing/selftests/bpf/xdpxceiver.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 3c41dc23b97e..2c1da060f832 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -395,10 +395,10 @@ static void parse_command_line(int argc, char **argv)
 			interface_index++;
 			break;
 		case 'D':
-			debug_pkt_dump = 1;
+			opt_pkt_dump = true;
 			break;
 		case 'v':
-			opt_verbose = 1;
+			opt_verbose = true;
 			break;
 		default:
 			usage(basename(argv[0]));
@@ -505,7 +505,7 @@ static bool pkt_validate(struct pkt *pkt, void *buffer, const struct xdp_desc *d
 	if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
 		u32 seqnum = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
 
-		if (debug_pkt_dump && test_type != TEST_TYPE_STATS)
+		if (opt_pkt_dump && test_type != TEST_TYPE_STATS)
 			pkt_dump(data, PKT_SIZE);
 
 		if (pkt->len != desc->len) {
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 309a580fd1c5..664b74ac2233 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -68,12 +68,12 @@ enum stat_test_type {
 };
 
 static int configured_mode;
-static u8 debug_pkt_dump;
+static bool opt_pkt_dump;
 static u32 num_frames = DEFAULT_PKT_CNT / 4;
 static bool second_step;
 static int test_type;
 
-static u8 opt_verbose;
+static bool opt_verbose;
 
 static u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static u32 xdp_bind_flags = XDP_USE_NEED_WAKEUP | XDP_COPY;
-- 
2.29.0

