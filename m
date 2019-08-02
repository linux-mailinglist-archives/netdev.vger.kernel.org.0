Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848E97FD23
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 17:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbfHBPNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 11:13:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57246 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730060AbfHBPNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 11:13:20 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1htZF6-0007Y0-Da; Fri, 02 Aug 2019 15:13:16 +0000
From:   Colin King <colin.king@canonical.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][net-next][V2] net/mlx5: remove self-assignment on esw->dev
Date:   Fri,  2 Aug 2019 16:13:16 +0100
Message-Id: <20190802151316.16011-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a self assignment of esw->dev to itself, clean this up by
removing it. Also make dev a const pointer.

Addresses-Coverity: ("Self assignment")
Fixes: 6cedde451399 ("net/mlx5: E-Switch, Verify support QoS element type")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: make dev const

---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index f4ace5f8e884..de0894b695e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1413,7 +1413,7 @@ static int esw_vport_egress_config(struct mlx5_eswitch *esw,
 
 static bool element_type_supported(struct mlx5_eswitch *esw, int type)
 {
-	struct mlx5_core_dev *dev = esw->dev = esw->dev;
+	const struct mlx5_core_dev *dev = esw->dev;
 
 	switch (type) {
 	case SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR:
-- 
2.20.1

