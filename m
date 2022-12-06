Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E492F643F63
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbiLFJJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiLFJJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:09:15 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B651DA48;
        Tue,  6 Dec 2022 01:09:08 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id w15so22504196wrl.9;
        Tue, 06 Dec 2022 01:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8sTJzD04XRe7x3AbvBKK3ZmowNuoy4S5LkUB6nexLbI=;
        b=KD4siY5nH6pgquYsSMWXpPBtS2ScIqyw+9bP++IYGX7OYL7xyxmPIYqXjPr4lGCCyv
         hSs/NZZFNyjQvBjcNa89fDasNrqRwuawb1B73TXq8PhmfDWl978fVn3IYyrdnjVYorFM
         9D1TyISy7tpcJpI899bHHz4JIZlUsda6VCwQSjfc1B5317zGlcwnw2J+AVYfewJ0L+6V
         c9u9O+R5gtxHL0yuDln0TfFqp/3KbUCyeuW2B5r4Ub0wQXfjaW2HNFXZ/VauaUKfhNU2
         EE9xaFSQ//bG5vw1ASJZj2FD0tvs/nbCXr5SaOwyAbKHAzkQ8JmSLVSo6XZeQNUPkOH3
         CI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8sTJzD04XRe7x3AbvBKK3ZmowNuoy4S5LkUB6nexLbI=;
        b=TtsXOC0BOXPJuQU/U1y6+uvB6YQXY1lHQHBPvBJpqaTkVfhZbGmhMxkMp7xeJwCWEq
         e0woEUyiGPUb/+uSKHfWCO97bl2IBHv9wxziVIFxPY1d6h1aHmNSRoaq8miNeMNN5Anp
         Oa/VjilPJ9Hhay9z0YpWuLdSvJv/EOEA3AQjgMxcLILIqyY8fBupkB9T8atCe0MDXhUO
         KDCKuDuRDi7NUOHII/vmsegnjMpnAqcMseET9MTNiRFKYTMeEU43qic7qrWpAP1oWnJn
         javQuGOD/XTVInuVt2D3CCoCZzkiVVQjTQQGZpQJoAZXH3pH5IkdhS+RQbVg4ZAXKEDV
         JcSQ==
X-Gm-Message-State: ANoB5pnl4IONKNn2L3MLWeSHoa6mYopfdJLXDwzpqzyQM8ZkbvlIu1pt
        Nl2O1JBhqgw2OMdrw+0TiYM=
X-Google-Smtp-Source: AA0mqf63ciT6xKz1PepdOzI4RiHwuQRmP9JsBTccUjXaZlybMUL4TOEUJFTvNaQLRqWh6fto0aogsQ==
X-Received: by 2002:a05:6000:1b8a:b0:241:e737:2d7c with SMTP id r10-20020a0560001b8a00b00241e7372d7cmr37622939wru.523.1670317746810;
        Tue, 06 Dec 2022 01:09:06 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.09.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:09:06 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 05/15] selftests/xsk: remove unused variable outstanding_tx
Date:   Tue,  6 Dec 2022 10:08:16 +0100
Message-Id: <20221206090826.2957-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206090826.2957-1-magnus.karlsson@gmail.com>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Remove the unused variable outstanding_tx.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xsk.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
index 5e4a6552ed37..b166edfff86d 100644
--- a/tools/testing/selftests/bpf/xsk.c
+++ b/tools/testing/selftests/bpf/xsk.c
@@ -86,7 +86,6 @@ struct xsk_ctx {
 struct xsk_socket {
 	struct xsk_ring_cons *rx;
 	struct xsk_ring_prod *tx;
-	__u64 outstanding_tx;
 	struct xsk_ctx *ctx;
 	struct xsk_socket_config config;
 	int fd;
@@ -1021,7 +1020,6 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	if (err)
 		goto out_xsk_alloc;
 
-	xsk->outstanding_tx = 0;
 	ifindex = if_nametoindex(ifname);
 	if (!ifindex) {
 		err = -errno;
-- 
2.34.1

