Return-Path: <netdev+bounces-7898-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A10722098
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94DA21C20B5D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F60B11CBA;
	Mon,  5 Jun 2023 08:09:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BC5F9E7
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1994C4339B;
	Mon,  5 Jun 2023 08:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685952597;
	bh=xa71jcxFeXsxIrHGWRjmew1bHs+dcsG82jxVdJhhK88=;
	h=From:To:Cc:Subject:Date:From;
	b=jWUJOygSwCXZtM5y7HmrRyMrDRlxWG0phPCMBmMIz5XQfbNspAAK2eqgfld14GCaD
	 XSQ83Nli97aupxz6oL/JJaGl+TzSzMp3C49Qn9YBBU1M8Zev/BlPPfiONd4NX08BGd
	 G5Rioh1fWfTx6njM5vYqNg2YQjvjy19Vo7zFusoxoYtpiZXfFJMDpm2Er2xxELw2hG
	 dhYEVGWemdPl3dhf+vArAHnbq5IzpdjCFszk4rOpsIKbcF3utS2skcnLZ8NCceMTW0
	 7cqESWsIJLCUqvw97i5s9v0PVQzoqrrM7w+r7FvT7+stJObwpLTJEWNmknmAKtQDT8
	 Xh9EEMcNCNYtg==
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Raed Salem <raeds@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net 0/4] Fix mixing atomic/non-atomic contexts in mlx5 IPsec code
Date: Mon,  5 Jun 2023 11:09:48 +0300
Message-Id: <cover.1685950599.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This series fixes mistakes in mixing atomic/non-atomic contexts in
mlx5 IPsec code.

Thanks

Leon Romanovsky (3):
  net/mlx5e: Don't delay release of hardware objects
  net/mlx5e: Drop XFRM state lock when modifying flow steering
  net/mlx5e: Fix scheduling of IPsec ASO query while in atomic

Patrisious Haddad (1):
  net/mlx5e: Fix ESN update kernel panic

 .../mellanox/mlx5/core/en_accel/ipsec.c       | 22 ++++++++++++++-----
 .../mlx5/core/en_accel/ipsec_offload.c        | 17 +++++++++++---
 2 files changed, 30 insertions(+), 9 deletions(-)

-- 
2.40.1


