Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F236D5697
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjDDCLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjDDCLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:11:39 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC091728;
        Mon,  3 Apr 2023 19:11:19 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VfJXedw_1680574263;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VfJXedw_1680574263)
          by smtp.aliyun-inc.com;
          Tue, 04 Apr 2023 10:11:04 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        saeedm@nvidia.com, leon@kernel.org, simon.horman@corigine.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH net-next v2] net/mlx5e: Remove NULL check before dev_{put, hold}
Date:   Tue,  4 Apr 2023 10:11:02 +0800
Message-Id: <20230404021102.25122-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:35:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:734:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:769:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4667
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---

change in v2:
--According to Simon's suggestion, add the one in mlx5e_set_int_port_tunnel().

 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 20c2d2ecaf93..2cb2ba857155 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -32,9 +32,7 @@ static int mlx5e_set_int_port_tunnel(struct mlx5e_priv *priv,
 						&attr->action, out_index);
 
 out:
-	if (route_dev)
-		dev_put(route_dev);
-
+	dev_put(route_dev);
 	return err;
 }
 
@@ -730,8 +728,7 @@ static int mlx5e_set_vf_tunnel(struct mlx5_eswitch *esw,
 	}
 
 out:
-	if (route_dev)
-		dev_put(route_dev);
+	dev_put(route_dev);
 	return err;
 }
 
@@ -765,8 +762,7 @@ static int mlx5e_update_vf_tunnel(struct mlx5_eswitch *esw,
 	mlx5e_tc_match_to_reg_mod_hdr_change(esw->dev, mod_hdr_acts, VPORT_TO_REG, act_id, data);
 
 out:
-	if (route_dev)
-		dev_put(route_dev);
+	dev_put(route_dev);
 	return err;
 }
 
-- 
2.20.1.7.g153144c

