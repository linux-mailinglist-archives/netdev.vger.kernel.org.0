Return-Path: <netdev+bounces-6027-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 216AC714653
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:35:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 533FB1C209E7
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DBC9812;
	Mon, 29 May 2023 08:35:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF107C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:35:06 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-16.smtpout.orange.fr [80.12.242.16])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1279A4
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 01:35:04 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id 3YLEqMBiidqvJ3YLEqNSes; Mon, 29 May 2023 10:35:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1685349302;
	bh=AugTDYeUrgYVPU+UhwnDyYDQ1NS0yzyFbGk6wtykwr8=;
	h=From:To:Cc:Subject:Date;
	b=Fy9a4XVTNFNs6Oz3bZxhAdqcmQ3HJaQc8jhkHb31k1p2J0kMFRF9y51tPBkti4Me/
	 UwJ4GLS63q9pb/md+lydpgA/Cekhiu0HHY9lv2ig8OcsW1e9WHbpq9MrMhYRNf+5wE
	 BUcE0/+6wrp3BvFsm07/p+EprzX68DAFWLw8ayglqEXTFV3gIkCewyVJqi0sw9ZFMi
	 16qpwnYrtprS7MRvMYweOwi+8q6yqBLBFv/Ud0NQMGYYAJwIpTspccE2o2WHda/V4O
	 krXzPyZQ6kW0cu/gSYxMzrc1lM6ndVvi9/J33kqxDbue6MJIGwBHrAr4Vf5h/VLRKt
	 v7TD8aFYZABdw==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 29 May 2023 10:35:02 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next] net/mlx5e: Remove a useless function call
Date: Mon, 29 May 2023 10:34:59 +0200
Message-Id: <fc535be629990acef5e2a3dfecd64a5f9661fd25.1685349266.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

'handle' is known to be NULL here. There is no need to kfree() it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
index 0290e0dea539..4e923a2874ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -112,10 +112,8 @@ mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *po
 	int err;
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-	if (!handle) {
-		kfree(handle);
+	if (!handle)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	post_attr->chain = 0;
 	post_attr->prio = 0;
-- 
2.34.1


