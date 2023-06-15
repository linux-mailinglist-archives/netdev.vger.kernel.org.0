Return-Path: <netdev+bounces-11075-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A15B3731716
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:39:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D22541C20E9B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61801134B3;
	Thu, 15 Jun 2023 11:39:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1C4125D4
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9747C433C8;
	Thu, 15 Jun 2023 11:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686829192;
	bh=gOlwZNLr8Saa3uQulc+67b8HfRPJx8sctzYSPSUTjig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwUTE3d2wJZR/8avD1KlZF4QwEn3FrL+JhiwsbWCvi3agjnI3HG2bJvgPvzqjS4tz
	 uzZSzy84O3MJ4Vjg5sEs2eTBE52sAuGtNrELCJD4fFCzmBKD0v26TF7EBgnJUVkC+9
	 iq5oBi/YXp794Ng6cYG6awNyhQuJbAO3eVl7033bvv3+JHJIFNgLRzOyOwKDZhOQmI
	 8gxWNhN1X1u8AJjx23JtjIs75uL3cEPQKwWHM4lSrs8HLO/QDmNFuBVSAN6gLQcOtK
	 flI50Rtlzj+yFJ4qiDdqtfgUieguqo+5lC3RtstdUbjB+g038glhFFhFsi5T7owU1e
	 cwGjrbs/oM4AA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Osama Muhammad <osmtendev@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S . Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	krzysztof.kozlowski@linaro.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 7/8] nfcsim.c: Fix error checking for debugfs_create_dir
Date: Thu, 15 Jun 2023 07:39:37 -0400
Message-Id: <20230615113938.649627-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230615113938.649627-1-sashal@kernel.org>
References: <20230615113938.649627-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.247
Content-Transfer-Encoding: 8bit

From: Osama Muhammad <osmtendev@gmail.com>

[ Upstream commit 9b9e46aa07273ceb96866b2e812b46f1ee0b8d2f ]

This patch fixes the error checking in nfcsim.c.
The DebugFS kernel API is developed in
a way that the caller can safely ignore the errors that
occur during the creation of DebugFS nodes.

Signed-off-by: Osama Muhammad <osmtendev@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nfcsim.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
index dd27c85190d34..b42d386350b72 100644
--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -336,10 +336,6 @@ static struct dentry *nfcsim_debugfs_root;
 static void nfcsim_debugfs_init(void)
 {
 	nfcsim_debugfs_root = debugfs_create_dir("nfcsim", NULL);
-
-	if (!nfcsim_debugfs_root)
-		pr_err("Could not create debugfs entry\n");
-
 }
 
 static void nfcsim_debugfs_remove(void)
-- 
2.39.2


