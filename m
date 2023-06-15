Return-Path: <netdev+bounces-11074-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC2B731714
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:39:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 321BB281560
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE56134AA;
	Thu, 15 Jun 2023 11:39:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC63F12B69
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBC4C433CC;
	Thu, 15 Jun 2023 11:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686829173;
	bh=gOlwZNLr8Saa3uQulc+67b8HfRPJx8sctzYSPSUTjig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEM+8DzkY30uIZSvnS7MeFvrkF1aUVK33Td1h83wi9y3OsHaQXck/e9GJ3jcIq7oC
	 m1hGpkJMSVcEiA5B/ZeDYRdqyCY/zZI2U2tR5P9cvRm6mMAovuLdorHII0/rQgcPGR
	 CyCBSZfN1Akhim+3SMLMg8e4zUjb3wVW2IB483e2VSe7z5V8/72obRxpOUb2tXYi+G
	 qRaGhLL0QKU7UbQj9orefnqLlNLJn7nhGR1yrZfVC3UH7ApBW0f0si2h2HXBi+SOF+
	 BLzcGO16YTQOG10XPBHdC1NIDiZxCDa1gVha0fNayTLdfXzjMRtoc3GaPsi0e6SoEh
	 +f90R6gSlNP1Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Osama Muhammad <osmtendev@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S . Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	krzysztof.kozlowski@linaro.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 7/9] nfcsim.c: Fix error checking for debugfs_create_dir
Date: Thu, 15 Jun 2023 07:39:15 -0400
Message-Id: <20230615113917.649505-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230615113917.649505-1-sashal@kernel.org>
References: <20230615113917.649505-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.184
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


