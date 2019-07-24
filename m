Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3662727E4
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 08:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfGXGGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 02:06:32 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46766 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 02:06:32 -0400
Received: by mail-pl1-f195.google.com with SMTP id c2so21534207plz.13;
        Tue, 23 Jul 2019 23:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3uxz/F8fAbkCDFD+nINfvnMjV4IUPu+90Frw3nw53wk=;
        b=sW/w6n2hnTKsqa3uenaBVxUGwEp2jhw3CwcJBYiFkIL1xoT2fQZnygvw28FKspmxYx
         Nz4d0TPzyoi2KUp1tHRWtd8Z3JjGfq3MmVMQQ7HjzvoGxFAApSIWhMswa0/bJwIQhWCU
         WEsall8mS76zHwYsaC73yjVP/7V1GUBKLx6m0MpT4ESx1rpO4dTL/Q0011rP9pWoz5Om
         6vk8whk+6SuNxXI60qIQwPCKTe4BXmWOYJZn05rTsRHvGCoPSm1TZ0s0lRoqisi/QbbK
         lPGwfY25QtkfmLDXBnUFPL4f0HESKSnGuEd1bEguQYY/oqHwdOQy+rJHoOqbGrbOS3x/
         V5Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3uxz/F8fAbkCDFD+nINfvnMjV4IUPu+90Frw3nw53wk=;
        b=rz1PgWcVbUK6zs7e3p4Twz+pU51IRW4NtmUH+4aUu872BTfd//GE7TL4WMMNNBxB9B
         Am6HdbmnygflyK06wtSvmPE1DbkCneAeBgBZ9JbSJ0BuynCSXVr45BXeg0inp2uOYq2C
         jgTHZg4ViYacW5B3vOGSsoY4qgARvWU61+4Lst6VUgIEF9B2guU3iJvrY/oYsTBLInId
         SMk3196lfac5VpxsGLs5Jo2cevdJFLrKXush+0bMjFCvLz7wm6N30+SXnLN/IG3SntvE
         Kg8UYjvzGn5VKMIN84E++wDbGaut+Pn4UFsNw5SjKRNMINckai0N9ySBZsIgmIW4p6W1
         2jdQ==
X-Gm-Message-State: APjAAAWcSjVCPFCIupJ6JqstlEDVY5P64qaRMda/AJ6VPgJq0sPhpHRY
        oG3EarmziPoFDyPwY7a1CLQ=
X-Google-Smtp-Source: APXvYqwNHriMH8crPUN1Wh3LKQJ2MX1rmYLWHRP5Lq3+ywwtmuQ6uSfFowasvLVuVKiEsKIJWxKtDQ==
X-Received: by 2002:a17:902:2d01:: with SMTP id o1mr86095743plb.105.1563948391700;
        Tue, 23 Jul 2019 23:06:31 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id 64sm46660992pfe.128.2019.07.23.23.06.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:06:31 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next v2 6/8] i40e: Use dev_get_drvdata
Date:   Wed, 24 Jul 2019 14:06:26 +0800
Message-Id: <20190724060626.24226-1-hslester96@gmail.com>
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
Changes in v2:
  - Change pci_set_drvdata to dev_set_drvdata
    to keep consistency.

 drivers/net/ethernet/intel/i40e/i40e_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 9ebbe3da61bb..a83198a0ba51 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14938,7 +14938,7 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (is_valid_ether_addr(hw->mac.port_addr))
 		pf->hw_features |= I40E_HW_PORT_ID_VALID;
 
-	pci_set_drvdata(pdev, pf);
+	dev_set_drvdata(&pdev->dev, pf);
 	pci_save_state(pdev);
 
 	dev_info(&pdev->dev,
@@ -15605,8 +15605,7 @@ static void i40e_shutdown(struct pci_dev *pdev)
  **/
 static int __maybe_unused i40e_suspend(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct i40e_pf *pf = pci_get_drvdata(pdev);
+	struct i40e_pf *pf = dev_get_drvdata(dev);
 	struct i40e_hw *hw = &pf->hw;
 
 	/* If we're already suspended, then there is nothing to do */
@@ -15656,8 +15655,7 @@ static int __maybe_unused i40e_suspend(struct device *dev)
  **/
 static int __maybe_unused i40e_resume(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct i40e_pf *pf = pci_get_drvdata(pdev);
+	struct i40e_pf *pf = dev_get_drvdata(dev);
 	int err;
 
 	/* If we're not suspended, then there is nothing to do */
@@ -15674,7 +15672,7 @@ static int __maybe_unused i40e_resume(struct device *dev)
 	 */
 	err = i40e_restore_interrupt_scheme(pf);
 	if (err) {
-		dev_err(&pdev->dev, "Cannot restore interrupt scheme: %d\n",
+		dev_err(dev, "Cannot restore interrupt scheme: %d\n",
 			err);
 	}
 
-- 
2.20.1

