Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB1E573501
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbiGMLM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGMLM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:12:28 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCA11005E2;
        Wed, 13 Jul 2022 04:12:27 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id a15so9909691pfv.13;
        Wed, 13 Jul 2022 04:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1b/MRvHRlr04K9YKU9yX4GmLbVKqvcAwXCZ6Wb7inMQ=;
        b=W0AAxWPcHX4waKArnjIQfPn5EvbSZ1Nk17CX5TuK01Wlh78J81p5D43+b1F+vSRG4C
         uux/QmuzikRch0+aPcd9OICrFGdiQwyetByojZx5WyjggGkU9V0yHCvnWnN4waXpok1k
         QnrdK2Oxaw7LBRl+oAlVh2HOyfUtPEENPxK8Oe4YRKTQ4mGYCiRQDg+D0qY0LSBB61tC
         2K7CkSb57BCE6xJNI2R/lbbKA6V7n7Do2cWa0YfCjdPL2Eq5hP2mKEX/RFiOFaEB1Zlg
         WwEbhQOgG/AHlICppafDHjY2YB22W8xNPYpYLaqLjBjIoFxSkyizD1j2iIOB9Vd9LSX6
         uZcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=1b/MRvHRlr04K9YKU9yX4GmLbVKqvcAwXCZ6Wb7inMQ=;
        b=UQUq73qfCmP0UoNjvPbnPYXuX0Iv7D2LCtZS3kGKrxGYjkpGqJKqPnkfXDStDiid92
         j8C6FmHRwrvXEGQPVTWNpfGGKMJ+rgFVEv7zMGFiVrsV678q3RDYbFLheLsoLeRo2C+K
         HPWEQoS47TaO5hcjo+Vvrfkwqgnvl5a4TlA0j7CNpugSdWuNITgelzpGB6DQy3lBVqJe
         oIhpXwOsCrxEWEyXrixnJOGllBlPGxyWABNg0Y3hiQG8g6aFdJYuYvSluHZrMsBHFl4E
         8LHLz1dMpop7oi6F5R+4Gbq3CVZw4qQdsGboi9CdSVzaBVzEmhC1GBUjrr1VwFKuMLGA
         3etQ==
X-Gm-Message-State: AJIora/exOf7h1haIhN49DmgSGtPGx8lZJHGbeqgtu8azqinH9tM13SN
        Eqr2fj2YFJ+Qu2/Hw7dKXZk=
X-Google-Smtp-Source: AGRyM1vR/ldtZUn+g70C68LOzooEl9N1TbXddKJsQ661WbsNhdAvYT7cnhP+pHllI6kL3hDkdyEQrw==
X-Received: by 2002:a63:5d21:0:b0:40d:d9fd:7254 with SMTP id r33-20020a635d21000000b0040dd9fd7254mr2526204pgb.353.1657710746784;
        Wed, 13 Jul 2022 04:12:26 -0700 (PDT)
Received: from localhost (220-135-95-34.hinet-ip.hinet.net. [220.135.95.34])
        by smtp.gmail.com with ESMTPSA id r30-20020aa7989e000000b00528baea53afsm8590716pfl.46.2022.07.13.04.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:12:26 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
From:   AceLan Kao <acelan.kao@canonical.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Manuel Ullmann <labre@posteo.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: atlantic: remove deep parameter on suspend/resume functions
Date:   Wed, 13 Jul 2022 19:12:23 +0800
Message-Id: <20220713111224.1535938-1-acelan.kao@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>

Below commit claims that atlantic NIC requires to reset the device on pm
op, and had set the deep to true for all suspend/resume functions.
commit 1809c30b6e5a ("net: atlantic: always deep reset on pm op, fixing up my null deref regression")
So, we could remove deep parameter on suspend/resume functions without
any functional change.

Fixes: 1809c30b6e5a ("net: atlantic: always deep reset on pm op, fixing up my null deref regression")
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
---
 .../ethernet/aquantia/atlantic/aq_pci_func.c  | 24 ++++++++-----------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 831833911a52..dbd5263130f9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -379,7 +379,7 @@ static void aq_pci_shutdown(struct pci_dev *pdev)
 	}
 }
 
-static int aq_suspend_common(struct device *dev, bool deep)
+static int aq_suspend_common(struct device *dev)
 {
 	struct aq_nic_s *nic = pci_get_drvdata(to_pci_dev(dev));
 
@@ -392,17 +392,15 @@ static int aq_suspend_common(struct device *dev, bool deep)
 	if (netif_running(nic->ndev))
 		aq_nic_stop(nic);
 
-	if (deep) {
-		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
-		aq_nic_set_power(nic);
-	}
+	aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
+	aq_nic_set_power(nic);
 
 	rtnl_unlock();
 
 	return 0;
 }
 
-static int atl_resume_common(struct device *dev, bool deep)
+static int atl_resume_common(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct aq_nic_s *nic;
@@ -415,10 +413,8 @@ static int atl_resume_common(struct device *dev, bool deep)
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
-	if (deep) {
-		/* Reinitialize Nic/Vecs objects */
-		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
-	}
+	/* Reinitialize Nic/Vecs objects */
+	aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
 
 	if (netif_running(nic->ndev)) {
 		ret = aq_nic_init(nic);
@@ -444,22 +440,22 @@ static int atl_resume_common(struct device *dev, bool deep)
 
 static int aq_pm_freeze(struct device *dev)
 {
-	return aq_suspend_common(dev, true);
+	return aq_suspend_common(dev);
 }
 
 static int aq_pm_suspend_poweroff(struct device *dev)
 {
-	return aq_suspend_common(dev, true);
+	return aq_suspend_common(dev);
 }
 
 static int aq_pm_thaw(struct device *dev)
 {
-	return atl_resume_common(dev, true);
+	return atl_resume_common(dev);
 }
 
 static int aq_pm_resume_restore(struct device *dev)
 {
-	return atl_resume_common(dev, true);
+	return atl_resume_common(dev);
 }
 
 static const struct dev_pm_ops aq_pm_ops = {
-- 
2.25.1

