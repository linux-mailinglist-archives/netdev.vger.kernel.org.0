Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FE172D83
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfGXL1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:27:53 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43694 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbfGXL1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:27:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so20808151pfg.10;
        Wed, 24 Jul 2019 04:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iund/UB9gNsEMyB6ZwMB2lOVuWc9Eufb+ac0l5cR60E=;
        b=at5NcK2seyInJhe4u9iZiFKeIfzZQWhTWl+QhvVQcV7D9M//dLJUrKYzGFxjC0HXTi
         k4nZxcMQbMrdMEsuDie5/nVQhir0mPkiPOCqm+KYVPmhAVw2z0arLEZJBUR8lTgmlXbc
         kY2cjErIl28ZGU+CcVLQpH0ATIvHRoAuw8dkdemCUpCdN1cwmaojPUsw5/NISm761tzb
         a5rGOa8w3lqNtW12CHlo0YkMWwEQBRGcFHLTMQP3PAfZKwpI6PksHQ1b3fqBqPf1mg00
         7flTBtzDR9yjiXPEziOMiwgECAzhLpJRLU85M2jLM9DrweIx8LS/8MqdS2b2Mnsu9aFZ
         AuEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iund/UB9gNsEMyB6ZwMB2lOVuWc9Eufb+ac0l5cR60E=;
        b=rPRmI7LLWGAirx8v8+QMjVJ2BTl0OMV9P6TZrIuaMVM9YU6dwInd8Y00DgIalF24ki
         R/zgs/21KLDBdAfY2kONuSkWz0lJh9o+Y7nxAqtQkx22+qjy1uUff4heTNvbKBOxeWsb
         55CDq6KZ8pT3WewTFZVmlR+nCLTfAsg8hWTZqT/jUiVpSJETUwYs6tNoAlW6eNVHl3x4
         bt4YXUriDvjpJdPgtR5uyUswaJAiZ2Pjjnr0xyJwOcLryap8Yiyx51+FFbwgjcgAE9uA
         +AQcWnv/bmOQLVZdqbeUK6GUmj/yi+GLdCTQWIm9W8lmZoPQTnlUbvl0uOaBK7L3i0Ia
         rvOA==
X-Gm-Message-State: APjAAAUkYgIKBSC1AfOxLsUjblsdccbXhBlEFRGLxYUUbxDIdo+a9kGL
        Oo63n2LTIi7iHXF2RumO3rA=
X-Google-Smtp-Source: APXvYqzw5Y+tX9XJPPEn3RACN7m9XmWz0i+yjVNwBS+UWPXJPSUIz0iS40yEgEuMqNKxHJVvO23Wmw==
X-Received: by 2002:a17:90a:8c92:: with SMTP id b18mr85600256pjo.97.1563967672272;
        Wed, 24 Jul 2019 04:27:52 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id x9sm54902521pfn.177.2019.07.24.04.27.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 04:27:51 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next 08/10] mwifiex: pcie: Use dev_get_drvdata
Date:   Wed, 24 Jul 2019 19:27:45 +0800
Message-Id: <20190724112745.13511-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using to_pci_dev + pci_get_drvdata,
use dev_get_drvdata to make code simpler.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index b54f73e3d508..eff06d59e9df 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -150,10 +150,8 @@ static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_suspend(struct device *dev)
 {
 	struct mwifiex_adapter *adapter;
-	struct pcie_service_card *card;
-	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pcie_service_card *card = dev_get_drvdata(dev);
 
-	card = pci_get_drvdata(pdev);
 
 	/* Might still be loading firmware */
 	wait_for_completion(&card->fw_done);
@@ -195,10 +193,8 @@ static int mwifiex_pcie_suspend(struct device *dev)
 static int mwifiex_pcie_resume(struct device *dev)
 {
 	struct mwifiex_adapter *adapter;
-	struct pcie_service_card *card;
-	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pcie_service_card *card = dev_get_drvdata(dev);
 
-	card = pci_get_drvdata(pdev);
 
 	if (!card->adapter) {
 		dev_err(dev, "adapter structure is not valid\n");
-- 
2.20.1

