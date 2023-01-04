Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18CA65D244
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbjADMSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239189AbjADMSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:18:45 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECA93475E;
        Wed,  4 Jan 2023 04:18:42 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m26-20020a05600c3b1a00b003d9811fcaafso19738703wms.5;
        Wed, 04 Jan 2023 04:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O23XHz16kQsggrfAT5R5+VpQORNxeVkJc7shnnA68O8=;
        b=ib3JeKQmqzaVvN0guWn07x/3ueMmSxBFn7jiryw+0+aeYBWcxVsezxCaki8KFFFgQi
         VmxR0u+sYljpaI36L2VUYivjOgrH/ZzE79eh9dYK72DHv5W2jP07bbxxFKqz04zPwZDy
         We1rrOJWmnCIITPBWDlI7YOQLmUxV3xCUD5Casq+2G/tTVqfH1cTe4AUlHnteZ0ADlir
         YZURVKharL0tYKwekFlp9vuenHpccfRhOUUAtl1bZFW1zVMEd8R/Msx3uO4TjyHHvrzE
         Lmp4EycoSWj7n/O6WepPrm1I6ZDbXR6I1jtVoMcYqECiUZpgsx+hHxQvnvgat1tzQk4B
         pHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O23XHz16kQsggrfAT5R5+VpQORNxeVkJc7shnnA68O8=;
        b=nIbQHEcAe9MdGGhqDFlgfyj6JDizH67+sOvmt1CVNtkdH+PtG94V3hehWIeFi2joLd
         Itt/8tRSWBiFJ2uR84R550MDTIhMGKKY4Q+lfmZW3Nd1bN0uk2to2RjXVt2sTw6HjD3G
         2L2rYRDrZm/yidnsMbnOCtjXcXMTmBbtzbycxJSjGRmhNnwip9D80adUSaUyZ9pz8vfh
         tizV1g9XlBC91Q59uHBwttAeZS6sfOAUDPBoa4I+Ss1yz4ulBmUVIOqttzbVm5N5ovaq
         mPMNpFFbwBN8QV9KQyZbOidFgp43k9YwIYXD7/XzEIbPEvu/fIp/V6ulBCXtf8abA374
         A5og==
X-Gm-Message-State: AFqh2koQGdC9q/GmloESrwb3xdyQgXLprlrYtWT1jxWcT2GFOX/RJleT
        uEvvOvm+9YLcyMfc+UXFOlY=
X-Google-Smtp-Source: AMrXdXsmVndwOyFDsIu+7HkDVJt7b5DdnBHi8d9puutznjkfAXrKi18ixY9WRGD1LM2O0u4urtEa5A==
X-Received: by 2002:a05:600c:1f12:b0:3cf:a851:d2f2 with SMTP id bd18-20020a05600c1f1200b003cfa851d2f2mr33830611wmb.21.1672834721397;
        Wed, 04 Jan 2023 04:18:41 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003d04e4ed873sm35013749wmo.22.2023.01.04.04.18.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:18:40 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 02/15] selftests/xsk: do not close unused file descriptors
Date:   Wed,  4 Jan 2023 13:17:31 +0100
Message-Id: <20230104121744.2820-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104121744.2820-1-magnus.karlsson@gmail.com>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

