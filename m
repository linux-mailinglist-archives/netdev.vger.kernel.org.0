Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1BA71A0F
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390512AbfGWOP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:15:58 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41550 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfGWOP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 10:15:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so19232634pff.8;
        Tue, 23 Jul 2019 07:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6XuO6jEdHx05hNaMYchqxtP9rqz8cu9SXAHKmnHPUW4=;
        b=tpe1MlDJlx/KgrsWcpqqIwwTnisGHOpqlym5XovKwNxt6Z9O5WJT2J8+uuZnol2LFL
         u7AP6re6/9qe5/3jhH3Zfj1+zy4JJV+c7LqVW97Xs7AaFSW3/aUNyueF0uM5nwzALxW9
         La0GD+KmifTDqYaP/yhMrXHqSgF7wqZs3fAeZg0qzNd39JyZe80prH49hPS3jl+qrECE
         bBEw574vJbzyzbweja65ehqrV/ZQ4KsclI+nd2AO3T8qQgXsm4iCmLmLO/w8uSFg/mnY
         cqoR4DERi2T2zLlUtZVQfdpMNSstyUmuCBukeXYKpPSW8w/hxROGEjLwCzDuZl5pTSE6
         X7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6XuO6jEdHx05hNaMYchqxtP9rqz8cu9SXAHKmnHPUW4=;
        b=O4NID7vU8iYH5Yl6um+ui5jVGlaDEpSRp0V3+NDdT4lknVrTHWFbj7ALfCZgosDmtT
         YUkLmS60LyPwfEEF0yYT+9N/adbTkfEDf9kGN1PSVLrgcGAlEVlh8oRevgB1MCCKJdCu
         1z+j6oLwcEKRnl/7TvXCrtT5wGyNp9TTXYySyUti/EpkRaZ8DUq6EiGqKHNsHSK5GnKX
         0ECJhrE1wqEsNN4Y38ny2pTpkiH3b8WzDogRTukyUlsqPgTkL93X5otJ5LNQw9iiVpBJ
         rUwqWn2Y76IeYbckfSEvJG0XFEbxsYzlfmHGijGOpCf55J5TElQWbd0Yvsv/qKEdg1vx
         BWzw==
X-Gm-Message-State: APjAAAUze7J97dOkyvrcAf7B6QG8E5UXP4tnBwGOGhSDwDFr+E/B2PKq
        aqI1Yk59rKaGAiypw5lYa4A=
X-Google-Smtp-Source: APXvYqyU9NQxgncgw/8atoKL9rXa7a2GeD9SYhC5Gww4rgeqRIDg5WSXdJqcQVA0+7+avG6/x8p0ig==
X-Received: by 2002:a63:e907:: with SMTP id i7mr75605559pgh.84.1563891357278;
        Tue, 23 Jul 2019 07:15:57 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id m4sm53994904pgs.71.2019.07.23.07.15.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 07:15:56 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] i40e: Use dev_get_drvdata
Date:   Tue, 23 Jul 2019 22:15:51 +0800
Message-Id: <20190723141551.5857-1-hslester96@gmail.com>
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
 drivers/net/ethernet/intel/i40e/i40e_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 9ebbe3da61bb..44da407e0bf9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
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

