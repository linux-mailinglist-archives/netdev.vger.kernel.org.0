Return-Path: <netdev+bounces-6653-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50ED8717372
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 04:01:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AEE81C20DE1
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E64F9111D;
	Wed, 31 May 2023 02:00:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338D410E1
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 02:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CE8C433D2;
	Wed, 31 May 2023 02:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685498454;
	bh=vpf5GHRuTkRgje/pdZ/PNrbSprujCPA5/fGPPtdXbR8=;
	h=From:To:Cc:Subject:Date:From;
	b=bFi3rW/DlrIPYZ/Cb6DDFD0YLG2eMSdrTyCmuMnz3uUt0911o68YDwINZKN06ZAof
	 DJH1Y8Xaahu4tdh74SjvtP8vxiYUPN6PpnVUbsMZr6Iu8fwLPsO4ThkNkDqVlFAv7O
	 H0GI7GchTJywZ7rGIkcquMN1glknvTCWazA5+Km0KOYq+9b48HUKxtI+yDwYA4dTq4
	 4c3c/I4Fs9+qWYopEAmyS8Ff5Wqw1J0x56f9ENMYDHfy8/5rkDXTfQGD13G3TbzNdJ
	 9gs4hAohVMVC3VVeSxXa38O4y+cHtbRKo0Rkd1a6cpa/3YrVYleAnsq3AGgoHqJ1X5
	 2VCSUIcqbT7xQ==
From: Jakub Kicinski <kuba@kernel.org>
To: saeedm@nvidia.com
Cc: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net/mlx5e: simplify condition after napi budget handling change
Date: Tue, 30 May 2023 19:00:51 -0700
Message-Id: <20230531020051.52655-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since recent commit budget can't be 0 here.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
pw-bot: au

 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index fbb2d963fb7e..a7d9b7cb4297 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -207,7 +207,7 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		}
 		ch_stats->aff_change++;
 		aff_change = true;
-		if (budget && work_done == budget)
+		if (work_done == budget)
 			work_done--;
 	}
 
-- 
2.40.1


