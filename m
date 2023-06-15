Return-Path: <netdev+bounces-11077-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39624731731
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94BC6281708
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90747134C0;
	Thu, 15 Jun 2023 11:40:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C31125DA
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DAFC433AB;
	Thu, 15 Jun 2023 11:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686829225;
	bh=iH5sptddWZcnlTxUPs2tB+BDolK9udB4DIFGmPbcGAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8iqZt8lHBeA5ebylMgG9n9qu3Bgk6Wgm60Q3gRztqU4EaGHVlT+4XNcJNCi4Iw8x
	 eticxk6oecYFD8uavTpIRCZUrMujR8ok7gELQwSRJNdyaEjDud4XTMH9FQodOLvhue
	 0/fd1UWNnysKLSXylxIR+JKmenqbTwre7bf/DnJZxqFgTeypZH3fq+3FmzhDKC1tsq
	 0ZHrpqHh6VbAaOnp89WIKLBjHpfOsIlcIK6jWlCQi21kTFc3fuVcMdpFy0zgWXK+78
	 KsTVexVwHFGRwg5Ew5kGvjw9cUEejfIkLLB2JyW+nIabCWhbCHOJ/rLg50o9VmXd4g
	 n0sfo5c/bz4og==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Osama Muhammad <osmtendev@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S . Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	krzysztof.kozlowski@linaro.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/6] nfcsim.c: Fix error checking for debugfs_create_dir
Date: Thu, 15 Jun 2023 07:40:12 -0400
Message-Id: <20230615114016.649846-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230615114016.649846-1-sashal@kernel.org>
References: <20230615114016.649846-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 4.14.318
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
index 533e3aa6275cd..cf07b366500e9 100644
--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -345,10 +345,6 @@ static struct dentry *nfcsim_debugfs_root;
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


