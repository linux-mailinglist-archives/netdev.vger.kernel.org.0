Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36901E8E11
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 07:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgE3FzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 01:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgE3FzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 01:55:00 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDB6C08C5C9;
        Fri, 29 May 2020 22:54:57 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z26so826965pfk.12;
        Fri, 29 May 2020 22:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D961zIEOC0lUAS+NHn7BVv/6REjy7Yg3HyU+EPpP0iI=;
        b=Y/wxovXDgCVauht1gpYce1A8pNaIhaQGjzdODmu6S16ETMAHZ9A/bFRVEIQWWalMrq
         xqtfV92tdzWK10tOMDknxNEJ+8o8ccxDxEqS0ifk4KxRY/7ur9nsy+MNVM3UiFYZFGWS
         ca3kWyXIKw6WFB2exdhrGGZin7eDbMpKioMnORTYwxbspYc1ggGoJGOkQ2Qja4WERPpT
         YLw3K0+DB3npUx0evfjU+sEavPQ4UHg+TtQmYfU8cAVRn9Zzbez9x9XNCmnMEEHkcrrC
         OINYEs5OzlxT2kUZBkYp0keC+ogZmujkWF4uvWLu2+MacjF/Fj38kR/fBTAUm5lKpObY
         Cj0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D961zIEOC0lUAS+NHn7BVv/6REjy7Yg3HyU+EPpP0iI=;
        b=TdCCmXBbEuklhPnaQNe83eL7bt2SKxNOwdhRpGmU172ScEAGr9TKQWKzHKNs8t2NLg
         4koLENAimpgSq32wXhJLDwaWuTC1r2aJhX6ikwolqA12o4RuGC7fregozUTSK57B76jD
         2HmkDAOdhKjkSuSH/dOKMVtSrf4sG+dsTK9HuB7zkQdCtFk2DdESTlkNFfrUxd67I8TA
         SneG9KvdnKJkkXVV3z5vEn+G/gy7oVwAaIWvl+tXhMosTBH/p/wTw8bOm0eA3jZnu/t1
         DWCGjwxdYjh+o5BaGgfaXqKkh1GMgsn7eYUYCbIVW+qPT7S2eKX2Nn9gNOeI4uiQ7Tu4
         vYnA==
X-Gm-Message-State: AOAM531ekyl6nD0eSSdGR7bXNyaqA9itbHue4w0B+3pQPr/6e23ua4Lt
        lzJl0r85ueh1GZUIl7XFrjk=
X-Google-Smtp-Source: ABdhPJxJFBxnkDimGIi5MyryL51l4bNMaS1hC0e6YONOUlNDVwwMN6BkB+MfxPIXqog8j2HYcNFMjA==
X-Received: by 2002:aa7:95bd:: with SMTP id a29mr783647pfk.57.1590818097115;
        Fri, 29 May 2020 22:54:57 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id k14sm7833550pgn.94.2020.05.29.22.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 22:54:56 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH net-next] mlx5: Restore err assignment in mlx5_mdev_init
Date:   Fri, 29 May 2020 22:54:48 -0700
Message-Id: <20200530055447.1028004-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.27.0.rc0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:6: warning: variable
'err' is used uninitialized whenever 'if' condition is true
[-Wsometimes-uninitialized]
        if (!priv->dbg_root) {
            ^~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/main.c:1303:9: note:
uninitialized use occurs here
        return err;
               ^~~
drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:2: note: remove the
'if' if its condition is always false
        if (!priv->dbg_root) {
        ^~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/main.c:1259:9: note: initialize
the variable 'err' to silence this warning
        int err;
               ^
                = 0
1 warning generated.

This path previously returned -ENOMEM, restore that error code so that
it is not uninitialized.

Fixes: 810cbb25549b ("net/mlx5: Add missing mutex destroy")
Link: https://github.com/ClangBuiltLinux/linux/issues/1042
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index df46b1fce3a7..ac68445fde2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1277,6 +1277,7 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 					    mlx5_debugfs_root);
 	if (!priv->dbg_root) {
 		dev_err(dev->device, "mlx5_core: error, Cannot create debugfs dir, aborting\n");
+		err = -ENOMEM;
 		goto err_dbg_root;
 	}
 

base-commit: c0cc73b79123e67b212bd537a7af88e52c9fbeac
-- 
2.27.0.rc0

