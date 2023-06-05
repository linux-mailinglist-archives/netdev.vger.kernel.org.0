Return-Path: <netdev+bounces-7950-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD69272231E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:14:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 679FA2811BB
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD396156EE;
	Mon,  5 Jun 2023 10:14:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901755684
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CC4C433EF;
	Mon,  5 Jun 2023 10:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685960052;
	bh=Zy7F8g5Z2TeY0mKknBJU4ExG8y5dcguFh9LlLAlh+Pk=;
	h=From:To:Cc:Subject:Date:From;
	b=XSO0HxdFSe0laVAjCG6+Bc+fRWM38yXCxIYJtou5sPcLKjdPnj6OjbwftGpmIXezL
	 wHJN3eQln4Zg+3ZP68eLM5jQrd2hKdhmW4jHKAsM7kQicrKorXcItrj0S6EBp1Ljs8
	 0Z3opamSxw6u2X9DW2MJwrfeu0rLYa1vv1xio+Cv0zRtU5/HNR6jBgZu32ZGYqocIo
	 j/5tSqgjXlteQEVbalAF7W4gfm18rc3I096RqhzP0ZmaEQy3HMEpMdRjIPm/KZqNrl
	 5olqyoDRByLUy9+CGBZoBs2bPVNJsVFAC/D//5sIKTQBkkpZStzZJ0b7x+iOqrYYtF
	 jEvLJVr5N1jzA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next v2 0/4] Handle FW failures to destroy QP/RQ objects
Date: Mon,  5 Jun 2023 13:14:03 +0300
Message-Id: <cover.1685953497.git.leon@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v2:
 * Reworked DCT patch
v1: https://lore.kernel.org/all/cover.1678973858.git.leon@kernel.org
 * Dropped EQ changes
v0: https://lore.kernel.org/all/cover.1649139915.git.leonro@nvidia.com
-----------------------------------------------------------------------

Hi,

This series from Patrisious extends mlx5 driver to convey FW failures
back to the upper layers and allow retry to delete these hardware
resources.

Thanks

Leon Romanovsky (1):
  RDMA/mlx5: Reduce QP table exposure

Patrisious Haddad (3):
  net/mlx5: Nullify qp->dbg pointer post destruction
  RDMA/mlx5: Handle DCT QP logic separately from low level QP interface
  RDMA/mlx5: Return the firmware result upon destroying QP/RQ

 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  1 +
 drivers/infiniband/hw/mlx5/qp.h               | 12 ++-
 drivers/infiniband/hw/mlx5/qpc.c              | 93 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/debugfs.c |  6 +-
 include/linux/mlx5/driver.h                   | 10 --
 5 files changed, 69 insertions(+), 53 deletions(-)

-- 
2.40.1


