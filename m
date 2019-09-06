Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C87AAB76A
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 13:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391255AbfIFLxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 07:53:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38883 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbfIFLxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 07:53:52 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i6CoG-0007oJ-PY; Fri, 06 Sep 2019 11:53:48 +0000
From:   Colin King <colin.king@canonical.com>
To:     Tariq Toukan <tariqt@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx4_en: ethtool: make array modes static const, makes object smaller
Date:   Fri,  6 Sep 2019 12:53:48 +0100
Message-Id: <20190906115348.16621-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array modes on the stack but instead make it
static const. Makes the object code smaller by 303 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
  51240	   5008	   1312	  57560	   e0d8 mellanox/mlx4/en_ethtool.o

After:
   text	   data	    bss	    dec	    hex	filename
  50937	   5008	   1312	  57257	   dfa9	mellanox/mlx4/en_ethtool.o

(gcc version 9.2.1, amd64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 94c59939a8cf..d8313e2ee600 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -639,7 +639,7 @@ static unsigned long *ptys2ethtool_link_mode(struct ptys2ethtool_config *cfg,
 #define MLX4_BUILD_PTYS2ETHTOOL_CONFIG(reg_, speed_, ...)		\
 	({								\
 		struct ptys2ethtool_config *cfg;			\
-		const unsigned int modes[] = { __VA_ARGS__ };		\
+		static const unsigned int modes[] = { __VA_ARGS__ };	\
 		unsigned int i;						\
 		cfg = &ptys2ethtool_map[reg_];				\
 		cfg->speed = speed_;					\
-- 
2.20.1

