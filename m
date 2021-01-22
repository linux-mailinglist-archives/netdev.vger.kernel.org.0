Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7D83009C2
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbhAVR2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbhAVPtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:49:03 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3702BC0612F2;
        Fri, 22 Jan 2021 07:47:44 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id h7so8147512lfc.6;
        Fri, 22 Jan 2021 07:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JlfeYn4HFiJpHf15ex05CldQ0EQy4DxuxZ0ZzVxDhNs=;
        b=QGkhk7XXtOrVW13j51U8Ff2bD0QJk7+enN2gaT54pqsrIhn+nyjL3WirTTk1f/lpWd
         +E2qUghgVtRVJYHV2iXYM7ToNpZxzvoJHV+TLeOz2ZAZsHxmUCQVKob0c7k+6pD7wBld
         5QDdPrakED1mprib7mkSmCdw+2IxhGD50BKyw6IpyKDLxSBLCIdib4q0Q68epysQBz1J
         eMfPQEii9Z5VszT3ppFkwU0+qiMvIoKt1CwxHgzyWH+m4EN87FlMNXo02jl3zZS9ts0D
         ov0Jve/q0s6cP1NZvytjjyvRO5fBH+MEqTsbBvK3IVVfd14HOSUPgnuQb9zMN78uwUTb
         6dIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JlfeYn4HFiJpHf15ex05CldQ0EQy4DxuxZ0ZzVxDhNs=;
        b=dOU21RVDxU1bBk5z68vJHoCA62L1mqh7US6wgM4L2a0IL07t+kj5TebzB/Ue6p3ye9
         oBO4xdEcFAR7eL5H/aRsiJlhA5gL5IWl5cWXuJFB+whLQoy60WA9a3/EIxiUbYThqW15
         8oZc9AtR9V3p1YvJ7mOfEcnL++2kjbQRLzXJNa/CgMDy4Rfntp4971JI2CA75sUHC+bu
         4ev4u3BgEkZQ/Hie+/LMeSbS6no0PaFQzcosMjVRhnuB6Gn7K9VmVotLHk/BG/Ah6c2v
         Ss2wSZf8G/8MK9PMm7tLd3+HEeEDJY70zP33avzbQ3/Q7CFTmfKLFQHul+ezySj6u/kD
         gkIg==
X-Gm-Message-State: AOAM5314IOutTmJPeS8VjKeiUvgWCX0DpFAuEKSU8mTgVv40UtXLfL5m
        ntZngaxhpMuUnYFBSQSZuIE=
X-Google-Smtp-Source: ABdhPJyXPxnlLv2Nv4R22XP8efR/6zlut0Kju7/TOvNhqbn5Ilzx6hYRZfNdcc23lGt62rQecnhqzQ==
X-Received: by 2002:a05:6512:b1b:: with SMTP id w27mr979300lfu.10.1611330462780;
        Fri, 22 Jan 2021 07:47:42 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w17sm928589lft.52.2021.01.22.07.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:47:42 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 09/12] selftests/bpf: define local variables at the beginning of a block
Date:   Fri, 22 Jan 2021 16:47:22 +0100
Message-Id: <20210122154725.22140-10-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210122154725.22140-1-bjorn.topel@gmail.com>
References: <20210122154725.22140-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Use C89 rules for variable definition.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 993ce9b7aa76..34bdcae9b908 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -567,9 +567,11 @@ static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
 	}
 
 	for (i = 0; i < rcvd; i++) {
-		u64 addr = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx)->addr;
-		(void)xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++)->len;
-		u64 orig = xsk_umem__extract_addr(addr);
+		u64 addr, orig;
+
+		addr = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx)->addr;
+		xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++);
+		orig = xsk_umem__extract_addr(addr);
 
 		addr = xsk_umem__add_offset_to_addr(addr);
 		pkt_node_rx = malloc(sizeof(struct pkt) + PKT_SIZE);
@@ -905,6 +907,8 @@ static void *worker_testapp_validate(void *arg)
 
 static void testapp_validate(void)
 {
+	struct timespec max_wait = { 0, 0 };
+
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, THREAD_STACK);
 
@@ -929,8 +933,6 @@ static void testapp_validate(void)
 			exit_with_error(errno);
 	}
 
-	struct timespec max_wait = { 0, 0 };
-
 	if (clock_gettime(CLOCK_REALTIME, &max_wait))
 		exit_with_error(errno);
 	max_wait.tv_sec += TMOUT_SEC;
-- 
2.27.0

