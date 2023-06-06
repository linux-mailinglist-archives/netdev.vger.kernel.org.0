Return-Path: <netdev+bounces-8299-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B149D7238AB
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:17:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24FE71C20E4D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1C5A5685;
	Tue,  6 Jun 2023 07:12:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D024C5681
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373EAC433A1;
	Tue,  6 Jun 2023 07:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686035569;
	bh=+x5l76jEigP+jfedcLp5qK2IoJnrnOHNChSi6eV9RfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrgKQQpqxIZrCMsUIkh3jIwC0AgzFWUqmt68RTr11pmhbycnT26ekJsgkShOXWcPV
	 DqjKOpQzjzJjgqSDmPRjjOjcs3TAFHI3QnhVtS9Xg9Ni3f0ynzOcwTKr7pnB1+LjW5
	 qCBIntCuZyWVr7ByCFTTkjOu/qe8S5tmplkb4NgJNu3bVu0WIneOqSrnRjZxdB3z2Q
	 4JsrTHIG0WK1WDwFlMfKwCwpHPmwPOLA+s553vIrcq/Kb0Eir29i3k2W+UJ0sNks16
	 chSspSehQgDlx/kixzh6bmwBCjBQU1FR7CK8OZ/CGW8WwGYdy1lpCVpv5YIrOpq+1P
	 5P9ve7/YF1e8w==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org
Subject: [net-next 15/15] net/mlx5e: simplify condition after napi budget handling change
Date: Tue,  6 Jun 2023 00:12:19 -0700
Message-Id: <20230606071219.483255-16-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606071219.483255-1-saeed@kernel.org>
References: <20230606071219.483255-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

Since recent commit budget can't be 0 here.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
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


