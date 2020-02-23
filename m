Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9941694F2
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgBWCWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:22:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727166AbgBWCWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:22:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DAE9214DB;
        Sun, 23 Feb 2020 02:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424544;
        bh=uaI06Q+VT+zupIXMyse4ElXQfxh08km6yMMEEHSyq+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ge80xUU5BgEi3aVsAbSGpRVWL7TP7OWJeAjCD3oLv7vekhjIjd5KkhDQZzlZMkc6i
         a4ZD+HNwVQE+MJVFRewR8q/9lo7QzLFvWqLNM7DHs/bpq2003q4aDTAIvvSdIwpgzx
         oSX7yIK6QXuo0I+yZ49lsaKtUHaCNVU1IFt1rjn4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 53/58] net: hns3: add management table after IMP reset
Date:   Sat, 22 Feb 2020 21:21:14 -0500
Message-Id: <20200223022119.707-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit d0db7ed397517c8b2be24a0d1abfa15df776908e ]

In the current process, the management table is missing after the
IMP reset. This patch adds the management table to the reset process.

Fixes: f5aac71c0327 ("net: hns3: add manager table initialization for hardware")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 13dbd249f35fa..bfdb08572f0cc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9821,6 +9821,13 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 		return ret;
 	}
 
+	ret = init_mgr_tbl(hdev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"failed to reinit manager table, ret = %d\n", ret);
+		return ret;
+	}
+
 	ret = hclge_init_fd_config(hdev);
 	if (ret) {
 		dev_err(&pdev->dev, "fd table init fail, ret=%d\n", ret);
-- 
2.20.1

