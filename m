Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2E31BC6F1
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 19:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgD1RnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 13:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgD1RnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 13:43:23 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12078C03C1AB;
        Tue, 28 Apr 2020 10:43:23 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id z17so34191063oto.4;
        Tue, 28 Apr 2020 10:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IGiu43HMKFFPXvkdYpMi3N0FOwselucEcJEG/zdPDIw=;
        b=EOGYYCPyUxYi3CwmYRd2effYWgPrmBdgkKzFQluCdCfIoDXgQv6oAdWIhGySlV1fS5
         AriuaRXQ2PM9DKWacyBl/OfZvf6iqhnsyUzj0q6kwFwwYfufsC92qV/w2X+AVWvsnDxl
         bpjvShQ9MWMQsVrFMJJasvD0wJ4DpcwO0JjGOYg2Q/3U8QGvjOdN9Jj+7ljO6/2+sK2d
         qInmQh6BczaDf9VFpRZXJdq3B/yoDfQ+cxZZsCAr5xyu439BHIMH4B7jOLLRnQek9zAj
         AJFZXERkGXaBSGIBlBJ7nyPkHz+W/gnn7DUYpasYgxF4okOup5kpqp6tnfNEV1r3V6OH
         0Akg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IGiu43HMKFFPXvkdYpMi3N0FOwselucEcJEG/zdPDIw=;
        b=HLqUln7bbtY/XOocW0MlSbt7J6zL3FP6c+waWWjiWXBKUndGWNL0jBoMiy6ZukYo6q
         mGPTI7GvCjloY9fcQ+kP0euT+jUna2WzUh6Q/1JdNzZIbF1wmtKm1SmaOH3gmNZFCdZd
         UJppjL/cOeTMagpxPMYjEbdjGg7jhB04kNXkeQs/YOd6YnMoWIRzG+or4LZ1Fqmu9CPn
         iK+6dP3xlfzQM3PRjDS8mQLztkzlX+GSYallL9H1V9hwkKcaAAJcGfViyJPnBjodlXbM
         LjtoajjeufhNywd7hFyZQCZxS2y8fDRhseH98SOUNx84g3jbQ2QCNujO7EYzJHrCRH5e
         rBgA==
X-Gm-Message-State: AGi0PuZGgnE5tJ/r+ujesexmYN1YEBpf0Ut8RETJj0fzVe6uGiejyaPZ
        /ekCw6JfZL68XH+8eornWSo=
X-Google-Smtp-Source: APiQypK4LoLRl8YzMSA9bWTbhsMIwjUgUTmLicx2SZiCNxH5S4Y33qFmwlAEBIeSlo+M/77ekf4QEg==
X-Received: by 2002:a05:6808:28b:: with SMTP id z11mr3803400oic.135.1588095802295;
        Tue, 28 Apr 2020 10:43:22 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id w24sm5134900oor.47.2020.04.28.10.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 10:43:21 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] dpaa2-eth: Use proper division helper in dpaa2_dbg_ch_show
Date:   Tue, 28 Apr 2020 10:42:22 -0700
Message-Id: <20200428174221.2040849-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building arm32 allmodconfig:

ERROR: modpost: "__aeabi_uldivmod"
[drivers/net/ethernet/freescale/dpaa2/fsl-dpaa2-eth.ko] undefined!

frames and cdan are both of type __u64 (unsigned long long) so we need
to use div64_u64 to avoid this issues.

Fixes: 460fd830dd9d ("dpaa2-eth: add channel stat to debugfs")
Link: https://github.com/ClangBuiltLinux/linux/issues/1012
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 80291afff3ea..0a31e4268dfb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -139,7 +139,7 @@ static int dpaa2_dbg_ch_show(struct seq_file *file, void *offset)
 			   ch->stats.dequeue_portal_busy,
 			   ch->stats.frames,
 			   ch->stats.cdan,
-			   ch->stats.frames / ch->stats.cdan,
+			   div64_u64(ch->stats.frames, ch->stats.cdan),
 			   ch->buf_count);
 	}
 

base-commit: 0fd02a5d3eb7020a7e1801f8d7f01891071c85e4
-- 
2.26.2

