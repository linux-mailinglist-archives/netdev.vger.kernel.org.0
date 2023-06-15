Return-Path: <netdev+bounces-11072-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BBD57316F4
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:38:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACEE71C20E50
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6042125D4;
	Thu, 15 Jun 2023 11:38:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E3B9471
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A81C433C9;
	Thu, 15 Jun 2023 11:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686829123;
	bh=Jb2eDNzb5clEgaqpLLm/ZuGYk4VLgm9j+GK5focns5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1L2gTUaiJc05eLHGg1UHvkrrA1qHGJfyvc4FFyFZ/D4vxdZ6iKOOiI7KhKJ+96WF
	 87qlqFdFHcHk14m38FtRG6ddfknXxguC/iVVdaOc8ECQBMCqTZlGzIc99Se576CuFD
	 JLmOfVj7a2/4yr2f6b2b5Ox9DS/ofXR+uK4S32CEs4/ufMzH9jM+vlskOO/2dUQoEL
	 wZ0DbB0QC02pURIphHTiYYNi8+bGx1HlfdsQ1OT2yLDxoDUIOBqvlW7pev27O3YKag
	 DjbDFwhAWF3mu9UwnK6i/KkRL7ydcfHUOlYdZXAqQ6qRJqOIocAUklLeq9ZJwgDbfI
	 Fa61ncCBpB5fw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Osama Muhammad <osmtendev@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S . Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	krzysztof.kozlowski@linaro.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 10/16] nfcsim.c: Fix error checking for debugfs_create_dir
Date: Thu, 15 Jun 2023 07:38:10 -0400
Message-Id: <20230615113816.649135-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230615113816.649135-1-sashal@kernel.org>
References: <20230615113816.649135-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.34
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
index 85bf8d586c707..0f6befe8be1e2 100644
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


