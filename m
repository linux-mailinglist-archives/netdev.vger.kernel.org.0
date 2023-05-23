Return-Path: <netdev+bounces-4540-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C05770D347
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:44:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A6001C20C40
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 020661C762;
	Tue, 23 May 2023 05:43:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE91B1C742
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D590C433A1;
	Tue, 23 May 2023 05:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684820578;
	bh=AGhbaYLrfRB0EPo6MQc+MLrlzWi8suGVIlZfvKF7cd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8R/OQhrWRN8Df85Hjq6/aD+NlzKVDGhTEDfOYmpfsPdDOah6ZWr7luYOagrAl608
	 8sQ77FCuVgvNv6hTGQPOI2zYWjo+KqRxufcTQyNkl51bKlPCbRTt0fRAwmMyZR3fnD
	 yHohwdJ6U2GqvMOwU1I4N1KvZoVJl9T1lxlaRj5qtnslHI0bPsqmxiRZGw1rXD3uU6
	 vd6LAQqNXgFxLToEhlAQQPDfiNFHHplCNE3H4Y1rnqhlmYgxLNHoixzRBshO4KS1f8
	 9OlzkLXJJ0ibMCtu1WNeiWhZyK0Anwb9qZy+CRoy+lBHFp2OfbST+Psze91Vv5qRvf
	 gOSO/OdmEL1pw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net 06/15] net/mlx5: Fix error message when failing to allocate device memory
Date: Mon, 22 May 2023 22:42:33 -0700
Message-Id: <20230523054242.21596-7-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230523054242.21596-1-saeed@kernel.org>
References: <20230523054242.21596-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

Fix spacing for the error and also the correct error code pointer.

Fixes: c9b9dcb430b3 ("net/mlx5: Move device memory management to mlx5_core")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 995eb2d5ace0..a7eb65cd0bdd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1049,7 +1049,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 
 	dev->dm = mlx5_dm_create(dev);
 	if (IS_ERR(dev->dm))
-		mlx5_core_warn(dev, "Failed to init device memory%d\n", err);
+		mlx5_core_warn(dev, "Failed to init device memory %ld\n", PTR_ERR(dev->dm));
 
 	dev->tracer = mlx5_fw_tracer_create(dev);
 	dev->hv_vhca = mlx5_hv_vhca_create(dev);
-- 
2.40.1


