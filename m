Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46E9ADFA3
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 21:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbfIITuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 15:50:37 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:46249 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731163AbfIITuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 15:50:37 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MfYc4-1ieHb10Yrw-00g3kw; Mon, 09 Sep 2019 21:50:27 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH net-next 1/2] mlx5: steering: use correct enum type
Date:   Mon,  9 Sep 2019 21:50:08 +0200
Message-Id: <20190909195024.3268499-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:AK8QWmjsuWG4HEmhOqIpwd62ajWhj3F/CeXNzG050S7ptBNBv9G
 MqdkIwNGTfgOBb3ihKsasKEJrDoJT5Zpo74b2oTeKv2BSP+ZrVQCtd2Ta064gRzZTKDPm2K
 ijG6Qr8EmM6OgvYdfR/XW+NjnKJuh154KGpE67ARZl7J65uI9gvZpKtETCzORYzrENT1wEP
 TO5yy6EB2HYEIANJ/FMgA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Jvrju6h+dAo=:zHHY9sOoxpwZQ26Vvkc4if
 RPOyP48VcYi5WypqyVisjktfO79V97C6398/UTLF/+cgby1Pri2mSa0bvDZ9St/aBze/2+8VR
 DFJ86ThQP66LHMLZlV63Z4DadH+Gd+fiptytjrrBS3OEchEcoqc9t5PgXg+FRzz4vgEZGl/as
 6pDheKbt1dQtYMRmqi53hSCNEwHJa9HcqZAVLJT62U70OMEY0uLlvWJJL4U4esVzz0ipjkR5O
 Y8gVh61/ik6/tdbvLFYThYf5XMSp7rfFz87PV6Aj/seTudbvsS3CdM8ZJrutSAlY3lF5i4nmK
 8biTKWNB+Iw92WcfLEnYpMeOF1PFwN+Lg01hmv8PF70bZjoEBeh4COkVNqJS3Pl2/AGPYHI7i
 sYOtwSW3hVVzwivdit9efMiKY9lnQdtwxH6fy4f1mub3eFnN4mkE/JilEHb268Zk5t/wQpOnx
 2wrJKux5yK2X52EP4AhNVbTKsHBNzAMjpOvjlDwJASk8z5eIsiTV4VHnI63VokYZLOdcmED+o
 5S5OacwomwXgjmWYIebaLek2YtxqX3YS5YGHe76vlWSNL2hMhX06+HNbmMduM3hu5nlTPpHxf
 d7L6YSc6WwZ47ugS/0bg+Ekz2Tmtxuf8g3dXnwSY7cK8Rg66hR3YV0WrhTv3U4kXy2O0F6gc2
 4uixBzq3PQaj6uZmNxsWpfOAHGWjZWq1FT3wjHOLoKQXnV+v2qjrT3X36vt/NeR+2bzkwB6yD
 uqgRZmMNbp+aj+j7aKQNobYTCNQ6z/KSgZuar84PapThwn6T6+qCw+GgUTHov5RzQAEu9x2Kt
 KDamc3El9U5lc/xO6sFzdgkN8O90y9irglwY4Su0ehosjr+j0s=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The newly added code triggers a harmless warning with
clang:

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1080:9: error: implicit conversion from enumeration type 'enum mlx5_reformat_ctx_type' to different enumeration type 'enum mlx5dr_action_type' [-Werror,-Wenum-conversion]
                        rt = MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL;
                           ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1084:51: error: implicit conversion from enumeration type 'enum mlx5dr_action_type' to different enumeration type 'enum mlx5_reformat_ctx_type' [-Werror,-Wenum-conversion]
                ret = mlx5dr_cmd_create_reformat_ctx(dmn->mdev, rt, data_sz, data,
                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            ^~

Change it to use mlx5_reformat_ctx_type instead of mlx5dr_action_type.

Fixes: 9db810ed2d37 ("net/mlx5: DR, Expose steering action functionality")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index a02f87f85c17..7d81a7735de5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1074,7 +1074,7 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 	case DR_ACTION_TYP_L2_TO_TNL_L2:
 	case DR_ACTION_TYP_L2_TO_TNL_L3:
 	{
-		enum mlx5dr_action_type rt;
+		enum mlx5_reformat_ctx_type rt;
 
 		if (action->action_type == DR_ACTION_TYP_L2_TO_TNL_L2)
 			rt = MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL;
-- 
2.20.0

