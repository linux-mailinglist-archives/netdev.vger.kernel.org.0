Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9390FE9BD3
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 13:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfJ3Mup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 08:50:45 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41755 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfJ3Mup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 08:50:45 -0400
Received: by mail-pf1-f193.google.com with SMTP id p26so1512965pfq.8;
        Wed, 30 Oct 2019 05:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e/BrVROAKCsOPa46MS4js3VUUm8IwAVzchIOw9kB3Js=;
        b=oOgzHtNFEUBOiTd3TCkRuvSlRekqYrG1JdV9NRm5Z0h0qsRnDG8jQXYiwsRxlTTAMM
         AYsXYnb8R1zuXhVatvUCgbAOLKy/7ZYE9teTpn38xPYA2nRCWAD6zVddebTNPB7UIaKW
         +rKFt6zdIVUultza3Ww26dRxwXJLThYM2YbaNAnf+baeitDaQLa2Lnuc9MveAlk29SN7
         7FZOQ7JyWbhf+2W6V7cuvdl5GWLvbxB6vMHFn7/7JSJD1T4OwQmixJconmUA1OVem6cI
         64UnjLmtXYgkPHxZyYezWMPwDqYMDNzMZFS6eZ7uePAp51/ovtXSnF76oXJRcomPHY55
         jWsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e/BrVROAKCsOPa46MS4js3VUUm8IwAVzchIOw9kB3Js=;
        b=tUDgAp8vsM4VTycK5jTdA1LX78DTz8+8/2Bq2I9fDKaq2gyt14IjGZ9f2Z5HA8yIM1
         cJE3Ab0aUAoLM6UUQAFZW7x6ZpicFYimSGWXCpZ3xluwrX85nePr3d5pMHjGNjqUp3rv
         Z5WteFoKqUwHzgpNQ7zoznPWtVmX7SqgAN/UjePvtDxGeGdJ0SKxtvPi/K60xJG+csAq
         py/uYubB3Nf7lvdqrHJ1JgdcKUlWKIBDzq+D2Cl0SSVDIjfQaijJslY+lBL1R5jlfrYy
         HQQhDRsj2lYH98STIqYZAcAJStV2yZqwR88RJsCpsTPUymhw0inrdH9K5Fj4gsQ3vrV2
         hhzg==
X-Gm-Message-State: APjAAAVemxogKCx3t+8Y+Q1Fhsswrxz7p1uMtY6I5goV0ZO3kzlsiEiu
        VoPSih3tcMYW4GIQN3I4uhQ=
X-Google-Smtp-Source: APXvYqykonnEOR+IqPlpKVUbiFY02m6Ohg2mNivAAG6QmoWabtD/S0dIXVd70C+4DIL9rfS5F7bDWA==
X-Received: by 2002:a65:4d06:: with SMTP id i6mr6583527pgt.93.1572439843908;
        Wed, 30 Oct 2019 05:50:43 -0700 (PDT)
Received: from localhost.localdomain ([43.251.175.137])
        by smtp.gmail.com with ESMTPSA id 82sm3074048pfa.115.2019.10.30.05.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 05:50:43 -0700 (PDT)
From:   liupold <rohn.ch@gmail.com>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liupold <rohn.ch@gmail.com>
Subject: [PATCH] ath10k: Fixed "Failed to wake target" QCA6174
Date:   Wed, 30 Oct 2019 18:20:35 +0530
Message-Id: <20191030125035.31848-1-rohn.ch@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a issue with card about waking up during boot and from suspend
the only way to prevent it (is seems) by making pci_ps = false,
on Acer Swift 3 (ryzen 2500u).

Signed-off-by: liupold <rohn.ch@gmail.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index a0b4d265c6eb..653590342619 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3514,7 +3514,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	case QCA6164_2_1_DEVICE_ID:
 	case QCA6174_2_1_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA6174;
-		pci_ps = true;
+		pci_ps = false;
 		pci_soft_reset = ath10k_pci_warm_reset;
 		pci_hard_reset = ath10k_pci_qca6174_chip_reset;
 		targ_cpu_to_ce_addr = ath10k_pci_qca6174_targ_cpu_to_ce_addr;
-- 
2.23.0

