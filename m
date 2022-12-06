Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D836D643F5D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbiLFJJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbiLFJJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:09:01 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACE52AC9;
        Tue,  6 Dec 2022 01:09:01 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id ay14-20020a05600c1e0e00b003cf6ab34b61so13798786wmb.2;
        Tue, 06 Dec 2022 01:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O23XHz16kQsggrfAT5R5+VpQORNxeVkJc7shnnA68O8=;
        b=Qq9cgHxBsmvRwLNKZpRsSI+EN2xjAiGtaSDMB/26fL3N9nJLniHm5S+qurO1mpIO3M
         qFAYtwkpmJ5jLhBifG+oQc+Om7iD+bQxe1A84EiUplbK357Bvw7IQRWY1vX10JR/AUwD
         TFaIRn0/dSQuyjE6FA4PMhdVUgrwpJqb7wN7cjhQkKWKwNaU4PV8THN51CmK+4j3SwwX
         ts+gwibB28JDgbwOidIy7gMpUFgo1TPH4vP3BdoDYi5/XJbtuupayWJuWPkYvFnVskpo
         huFj4XqZGFSIdu+OuRkiVADOYhefLAnM6xYTi3bVmGSOOltM4bHrCCEeGvHHqKZ9uTa5
         v55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O23XHz16kQsggrfAT5R5+VpQORNxeVkJc7shnnA68O8=;
        b=KuYlIfw16sQ5sl3cfxqQ9uvDfmgUDvOVYXZcjx/LXFJWj+GplVZGWsxrkbv9MV2hFZ
         hxO04LSI6fQQzsjh5o8OPHSgPWAKUXzdG9L5KvIYtMaxbA6aoZrgW2fBmqxr2A2Lz8zb
         zFfnnyNyZ0i98jDdROlW+VbQXkHFHawUDxI0P0UNbFXuJbnL45HqrzVKDYgnSdMwocNr
         yPLZAfUL+dcZGbfoow17qMm2jFSs88p6xx65OD6r/G1lewHAN3HZzCxskwIwL3xp/Ssv
         jhpUY9ikRqC8e+ctWJMGWQDzrV6HLNMZxyLODt40GkaZoGcwHNDOZEvAJy2wboE/LSc1
         gJdQ==
X-Gm-Message-State: ANoB5plBERu95QOGO2JwtvIup7K92oBh7B2+ESCTF4FfpIPpCILc7b3t
        1JJ2qtlJVvYFDfP5iMt6lLI=
X-Google-Smtp-Source: AA0mqf6U+TIJsGA0Vcqw9MSKIsotCU50KKw1BalzTHLr69nOLktDwpYPOxTbok6vIJwtHYlDHVqlrQ==
X-Received: by 2002:a7b:c3c9:0:b0:3cf:5442:bbe with SMTP id t9-20020a7bc3c9000000b003cf54420bbemr67153962wmj.2.1670317739429;
        Tue, 06 Dec 2022 01:08:59 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.08.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:08:58 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 02/15] selftests/xsk: do not close unused file descriptors
Date:   Tue,  6 Dec 2022 10:08:13 +0100
Message-Id: <20221206090826.2957-3-magnus.karlsson@gmail.com>
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

Do not close descriptors that have never been used. File descriptor
fields that are not in use are erroneously marked with the number 0,
which is a valid fd. Mark unused fds with -1 instead and do not close
these when deleting the socket.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xsk.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
index 39d349509ba4..5e4a6552ed37 100644
--- a/tools/testing/selftests/bpf/xsk.c
+++ b/tools/testing/selftests/bpf/xsk.c
@@ -35,6 +35,8 @@
 #include "xsk.h"
 #include "bpf_util.h"
 
+#define FD_NOT_USED (-1)
+
 #ifndef SOL_XDP
  #define SOL_XDP 283
 #endif
@@ -583,6 +585,9 @@ static void xsk_delete_bpf_maps(struct xsk_socket *xsk)
 {
 	struct xsk_ctx *ctx = xsk->ctx;
 
+	if (ctx->xsks_map_fd == FD_NOT_USED)
+		return;
+
 	bpf_map_delete_elem(ctx->xsks_map_fd, &ctx->queue_id);
 	close(ctx->xsks_map_fd);
 }
@@ -941,6 +946,9 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
 	ctx->umem = umem;
 	ctx->queue_id = queue_id;
 	bpf_strlcpy(ctx->ifname, ifname, IFNAMSIZ);
+	ctx->prog_fd = FD_NOT_USED;
+	ctx->link_fd = FD_NOT_USED;
+	ctx->xsks_map_fd = FD_NOT_USED;
 
 	ctx->fill = fill;
 	ctx->comp = comp;
@@ -1221,8 +1229,9 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 
 	if (ctx->refcount == 1) {
 		xsk_delete_bpf_maps(xsk);
-		close(ctx->prog_fd);
-		if (ctx->has_bpf_link)
+		if (ctx->prog_fd != FD_NOT_USED)
+			close(ctx->prog_fd);
+		if (ctx->has_bpf_link && ctx->link_fd != FD_NOT_USED)
 			close(ctx->link_fd);
 	}
 
-- 
2.34.1

