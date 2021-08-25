Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9CA3F71F9
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239975AbhHYJjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239930AbhHYJjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:39:06 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F79C0613A3;
        Wed, 25 Aug 2021 02:38:17 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id m2so2934025wmm.0;
        Wed, 25 Aug 2021 02:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JcRVqLzHeSEWPjvqu7NmOVLbnG/CtRpAiVX3Or4n/E0=;
        b=Ckw1Wt0nIOh5Q3L8TEDGZNLf3pDioly7UHn18B754/5CwM80ghVs7pa8coLlj1xwHR
         NXViyUajssshs3QQvUeDDyAiLBvYY/4KrAtMmN4KE0BjFitgWFjaFnQjjTwhnTpxmDbm
         +y22yVHBr7ZQHowjBmaS3aL14g00+PmVDiZ1nJFbpzPx6//1bYNtrjt7YWOwfizhdhmY
         CVoJ/uwwhYyxhx5NHOa4WXsz/yzuGbdEJUi8qwuReKc37jsWj+B7UAjAwzBLPy6dQ8aw
         WQHE2R0e4Vp58dC5y4JeFzANo4xuM8Lx9BKwhdcau+OriQc10eg+Gj8wpTxm8WDjTFog
         +tNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JcRVqLzHeSEWPjvqu7NmOVLbnG/CtRpAiVX3Or4n/E0=;
        b=Y0PvORwRrQusztTubEJ5vxct8T62ESahFiwa4jCc77MMgkxNwQWa5+M8LI22YoPdaH
         5C3qOT3nLOQeMx2HDJBAO2HtvrPLAeW0TbpiXvhY9u4MSu85k7MWsfp9ZeYCT3vOZNFz
         qn/v2cA9+X46CEX9Ubb9c9QEoM/qG+U7o7rd9V90QvF5aLjhC3V1VmlJ36EnQWs9esEm
         C/CCpkfGh44Gqt/FoqjPDGT4B5sdzgf3ipmyMS4BI+0Wl6kaRBQuBMI9nu+sDHomSGYi
         C6Su5VOnRljsUNiiyVP0WEUY7wfzsiX6fgi0XNZ30SFUewp50B7eURGXPYNOx/qf3BP3
         /BpA==
X-Gm-Message-State: AOAM533UVTcCPf+6jDzhmH1esVh2gIlfAIP1+aRXP2AzuxuD2EN89Bp5
        av/AU1F/mKRNPK/3sbumFFM=
X-Google-Smtp-Source: ABdhPJyEXiTJo/KSsm8gPhYnCH9tEAD9o5ozMzGxhs4gdku+K1tDvpVtj27XMIGSws18HLdAfxeFcw==
X-Received: by 2002:a05:600c:ac7:: with SMTP id c7mr8164537wmr.40.1629884295588;
        Wed, 25 Aug 2021 02:38:15 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.38.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:38:15 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 16/16] selftests: xsk: preface options with opt
Date:   Wed, 25 Aug 2021 11:37:22 +0200
Message-Id: <20210825093722.10219-17-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
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
index 0c7b40d5f4b6..f53ce2683f8d 100644
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
@@ -517,7 +517,7 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, const struct xdp_desc *d
 	if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
 		u32 seqnum = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
 
-		if (debug_pkt_dump && test_type != TEST_TYPE_STATS)
+		if (opt_pkt_dump && test_type != TEST_TYPE_STATS)
 			pkt_dump(data, PKT_SIZE);
 
 		if (pkt->len != desc->len) {
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 582af3505c15..7e49b9fbe25e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -69,12 +69,12 @@ enum stat_test_type {
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

