Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE6016947F
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgBWCay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:30:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728699AbgBWCXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:23:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 310F2227BF;
        Sun, 23 Feb 2020 02:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424612;
        bh=fsPvjRYgB4pv7V5kfZoupwdYyArfFebXqtBGXqlzQ+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmTfIVg9jLBGSqts0Dii1gLsE7lMCDrFnWCxmxTEciSqRv5oakdQ0XcivLMt3tCUU
         Fs1VOCmR48Z5/nOXOJQBKRNsjTONO9jXqAkgRDwbw+D/+Qx78AtBKImidw8iCTfIjE
         0XKa6ENpM53n9M6Vs5Uz3EoDgObHui/PXOqQNjCo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 46/50] net: hns3: add management table after IMP reset
Date:   Sat, 22 Feb 2020 21:22:31 -0500
Message-Id: <20200223022235.1404-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022235.1404-1-sashal@kernel.org>
References: <20200223022235.1404-1-sashal@kernel.org>
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
index 162881005a6df..0c3c63aed2c06 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9437,6 +9437,13 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
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

