Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483B862C6D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 01:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfGHXN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 19:13:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34527 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbfGHXN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 19:13:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so2098206wrm.1;
        Mon, 08 Jul 2019 16:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XaRXZQCNBW0FXINwm4ytAUNDCX/SiwydWSwmwt/UWuk=;
        b=aB/KHvRVnzj/KYHgRH8OpLgd97kFns5I6hoLJEjjgHmuKdI7Py8I3NmBuPChNYhSxf
         DHi4ptImpe9EaKeYf8WFkFhkbXyGkrr21UtQvRH2v7XMeaxMS2Y1jj7OIrlXg4SZEWdu
         HMxwU6xVrrKJDjS2QTvMX75569gfR4lUVhTltG9iu1OVg/cVh0E8uLwTWnePyIkeR9OG
         kbYxQc2AMWE7UIcWYVv90eW8k3Gnr5rTm8nlbkmyN1bBk1WzsG6PpgMC0mcFOCD2pj05
         jGlhIdecijQTjLHRVtQ7jo3WiKaojvBUCpcaX99wRY1/eyJmWv3SyvafNfy/ZhUhd9lc
         AO1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XaRXZQCNBW0FXINwm4ytAUNDCX/SiwydWSwmwt/UWuk=;
        b=GmPmBAY7x8zVKujG2Xk6ZXxQi/12KEqwrnDR2cZbZrB/3kr3Cp30xkFWvrmzmVKBu9
         5c0JrcGFCmHU1wm4E2frDZFDjjOj0xqE/fh6mQfXgPQoqY/ye3TvSN7UDq/SzoVYRCGN
         B0QWnfERUb4I8Wg63drGi/Zj+CNmSqLCu6TLU8mv4x/t7g1++OctHY5JCuxNFKmIZ1WD
         KQ2xB0IuHTjE0t6/D8yGPQcMF4tj8/FIr7LaWOB4+tZqlU4gPI6c/XmEe4VJEX0CmOJl
         ea5YIZ+vVBgOojkMt1ZCZTu5ZybjZMNoBDTo7badHw9iLou7MUWbQQkSZZA0lKYZsL4u
         SZig==
X-Gm-Message-State: APjAAAWVRAofNuYXdYCTnxYzs9nPq74/4KJtAMwoIZEj7OMmopOP28KW
        x72rUhpLfgqnjJG8GSxadUU=
X-Google-Smtp-Source: APXvYqzS34nlLa+QncLuO6A/Gitk0bBARc5vnefA3pHpopXXX61vnmV6tq0nyO+fK6oenaESWqqt/Q==
X-Received: by 2002:a5d:56c7:: with SMTP id m7mr21100523wrw.64.1562627634196;
        Mon, 08 Jul 2019 16:13:54 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id x16sm736653wmj.4.2019.07.08.16.13.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 16:13:53 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] net/mlx5e: Return in default case statement in tx_post_resync_params
Date:   Mon,  8 Jul 2019 16:11:55 -0700
Message-Id: <20190708231154.89969-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang warns:

drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:251:2:
warning: variable 'rec_seq_sz' is used uninitialized whenever switch
default is taken [-Wsometimes-uninitialized]
        default:
        ^~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:255:46: note:
uninitialized use occurs here
        skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
                                                    ^~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:239:16: note:
initialize the variable 'rec_seq_sz' to silence this warning
        u16 rec_seq_sz;
                      ^
                       = 0
1 warning generated.

This case statement was clearly designed to be one that should not be
hit during runtime because of the WARN_ON statement so just return early
to prevent copying uninitialized memory up into rn_be.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Link: https://github.com/ClangBuiltLinux/linux/issues/590
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 3f5f4317a22b..5c08891806f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -250,6 +250,7 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
 	}
 	default:
 		WARN_ON(1);
+		return;
 	}
 
 	skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
-- 
2.22.0

