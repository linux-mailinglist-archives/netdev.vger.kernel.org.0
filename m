Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA5872D81
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfGXL1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:27:45 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44837 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbfGXL1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:27:45 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so21089079pgl.11;
        Wed, 24 Jul 2019 04:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7IR+uM+j5koIPBW7Xm8FY732aVxv1FIX3BlElSJL8Ys=;
        b=WYT46Etclh2BRTLLlTCKaJz2sGvVnXzruG+odXhQVXIP3TB/nCW4zE4muSr1Ooypxw
         VkfEtU3W2UqgH5se/CJ4OsknHNDvrtuJxSwgYdOinDJytVvuMgLJiMJTJtNklC8DWQ2s
         eomxXn/7JAVADbtY4+KdUmRcJLcQrgQOxvrNYyobdEFddBO9I6jCrmH2T1eS/3pcBN6W
         taK5i//Ks7WA1vjzmLT3ep1VJc28sPR6CYvMchwkqeC3cQehnCUqRlCG+yzikuUNlEko
         pCQxAJ1TN8hUZBLF3CBNeYfqitid28xNF6o2gpKtOSB44RsakGKvM85XU53l1lIS7bfz
         ahyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7IR+uM+j5koIPBW7Xm8FY732aVxv1FIX3BlElSJL8Ys=;
        b=FB0Ji0A46OOGX0kzASb+K0Y65UltBGYtwOfDfPtuSQoK23xMr+fgU2jFHvhB8djKTA
         X05Pk3x+Z8fri0vBxZrxY9bmn2JKFb3d98ruTHEPGTrbT6sRhPvzATr48NZc0wTF9pim
         MqBSYqkT5uXvksLBWEQyMnIfxK8TDYd2cqJvSwKIs1B8Y8Ow7i9hYWchugwzgdvGRlbq
         UV3KaWzMTnrHs9HzM9JadOtGm8WzrU2nOaxLWicSLqFBYzLZU4PwmEan2ceu1H6pPQqU
         Vcr2nqXM8gLe4XGWmecduvD8lcUFaURFjg3iJarp1OGggrQlFXh+aLJIZRRr51KiU+5E
         cexA==
X-Gm-Message-State: APjAAAUbx7w0uKPdQRN0BVx2fvR7ceJe8WX8xR43KYwU1R7+taW3QS6x
        a72+sKCDztN8GvbF4G90VDM=
X-Google-Smtp-Source: APXvYqz6sN2JwpXp26sb8CBgIE5le7DadChkZCVYYMfhfmyDHN/y5tSMhuPY4RW4VWNSDY6xfLPZAQ==
X-Received: by 2002:a63:2744:: with SMTP id n65mr67926788pgn.277.1563967664643;
        Wed, 24 Jul 2019 04:27:44 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id v185sm52804086pfb.14.2019.07.24.04.27.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 04:27:44 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next 07/10] iwlwifi: Use dev_get_drvdata where possible
Date:   Wed, 24 Jul 2019 19:27:38 +0800
Message-Id: <20190724112738.13457-1-hslester96@gmail.com>
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
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index ea2a03d4bf55..fe76e1540d39 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1248,8 +1248,7 @@ int iwl_pci_fw_exit_d0i3(struct iwl_trans *trans)
 #ifdef CONFIG_IWLWIFI_PCIE_RTPM
 static int iwl_pci_runtime_suspend(struct device *device)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_trans *trans = pci_get_drvdata(pdev);
+	struct iwl_trans *trans = dev_get_drvdata(device);
 	int ret;
 
 	IWL_DEBUG_RPM(trans, "entering runtime suspend\n");
@@ -1269,8 +1268,7 @@ static int iwl_pci_runtime_suspend(struct device *device)
 
 static int iwl_pci_runtime_resume(struct device *device)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_trans *trans = pci_get_drvdata(pdev);
+	struct iwl_trans *trans = dev_get_drvdata(device);
 	enum iwl_d3_status d3_status;
 
 	IWL_DEBUG_RPM(trans, "exiting runtime suspend (resume)\n");
@@ -1285,8 +1283,7 @@ static int iwl_pci_runtime_resume(struct device *device)
 
 static int iwl_pci_system_prepare(struct device *device)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_trans *trans = pci_get_drvdata(pdev);
+	struct iwl_trans *trans = dev_get_drvdata(device);
 
 	IWL_DEBUG_RPM(trans, "preparing for system suspend\n");
 
@@ -1308,8 +1305,7 @@ static int iwl_pci_system_prepare(struct device *device)
 
 static void iwl_pci_system_complete(struct device *device)
 {
-	struct pci_dev *pdev = to_pci_dev(device);
-	struct iwl_trans *trans = pci_get_drvdata(pdev);
+	struct iwl_trans *trans = dev_get_drvdata(device);
 
 	IWL_DEBUG_RPM(trans, "completing system suspend\n");
 
-- 
2.20.1

