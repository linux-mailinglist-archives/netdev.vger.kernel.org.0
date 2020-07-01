Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F98A210B94
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730880AbgGANC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730869AbgGANCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:02:24 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0B5C03E979;
        Wed,  1 Jul 2020 06:02:24 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d4so11686900pgk.4;
        Wed, 01 Jul 2020 06:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QuyL93xGAaaNSghhFPwjm3/FQ7kS7DpgB2p+k7g93Fg=;
        b=D4s+UYVZA96sz7qG2a7gtK+XPagC4WM2AccRFw6CMHKGes1MyHUkkYcTF2usP4Vset
         9NsbguawkQTDeKFp/Rl1M8sMu2Qc0sDs8QYTBOojynhk2Axjx5+3WgGM85UN15GMkIJP
         q/Pj5wjET5NwoXTRPsVVS8sy7KJJdkYdqNVTAMyrUMwveSWbDnkfzu5Tk/tp9gmR6yhG
         iUf4hYIXBCLdN9p3sHcJ0me2N6B03fpi6RDc3/MC2nqUOKfXY3duukVJvYEiyvGrFo2f
         lvCJk3BSmqZE6y3yNfsEc37dIOLpvKUYMNxB+GqA9H9osw0pJl1kafTWJS1+IpdBKEgq
         pMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QuyL93xGAaaNSghhFPwjm3/FQ7kS7DpgB2p+k7g93Fg=;
        b=uQ1iEB9VwQTl49gy9FttSiOpGD69g6a67itEy1r6S6x9Mgkmo4V3Uj/qDJnAiNUMKk
         cTjj1AOx8aXp+sNRb4QgeYffusZ3CQwlojqqr4SoB/V2mc4Hf1EO5Uu9gfMnQMt67Q6k
         ROB/7gKxCX6q+eYvUdoMlSvSn/jTOm52qXox0O0bQxxko8+5uesePc/tLmnhnphH03Y2
         LgFcvosuI6ZC4haGQLQ+xRPKS/qwHlkqCVDknGADIfsYS4/YTDVwqt0X2tpXtR/OPW0h
         ztSR08x+0ctqnKSlHsgTRph82iKwOP6zTCedMaJjy3V+vbN+229axOgpW5YJ+c8AyJXG
         niIQ==
X-Gm-Message-State: AOAM5323+2IiIOC04woQEmhAsZxSgtVsi5KvsdGRyW8qI6BD77EE/1gg
        CDv/3AZU+uo/PStHlTKOPsA=
X-Google-Smtp-Source: ABdhPJzOtW/9dzY5b1f2uQ8Nb9Zt/5//oXKxniFX0fZk92rZffn5R/fsjPwyM3X7YN5JuHzAo82zJQ==
X-Received: by 2002:a65:6714:: with SMTP id u20mr19854694pgf.121.1593608543490;
        Wed, 01 Jul 2020 06:02:23 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id d9sm6070908pgv.45.2020.07.01.06.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 06:02:22 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Dillow <dave@thedillows.org>,
        Ion Badulescu <ionut@badula.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jon Mason <jdmason@kudzu.us>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 03/11] starfire: use generic power management
Date:   Wed,  1 Jul 2020 18:29:30 +0530
Message-Id: <20200701125938.639447-4-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
References: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM, drivers themselves were responsible for managing the
device's power states and takes care of register states.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

Thus, there is no need to call the PCI helper functions like
pci_save/restore_sate() and pci_set_power_state().

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/adaptec/starfire.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index a64191fc2af9..ba0055bb1614 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -1984,28 +1984,21 @@ static int netdev_close(struct net_device *dev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int starfire_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused starfire_suspend(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 
 	if (netif_running(dev)) {
 		netif_device_detach(dev);
 		netdev_close(dev);
 	}
 
-	pci_save_state(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev,state));
-
 	return 0;
 }
 
-static int starfire_resume(struct pci_dev *pdev)
+static int __maybe_unused starfire_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 
 	if (netif_running(dev)) {
 		netdev_open(dev);
@@ -2014,8 +2007,6 @@ static int starfire_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
-
 
 static void starfire_remove_one(struct pci_dev *pdev)
 {
@@ -2040,15 +2031,13 @@ static void starfire_remove_one(struct pci_dev *pdev)
 	free_netdev(dev);			/* Will also free np!! */
 }
 
+static SIMPLE_DEV_PM_OPS(starfire_pm_ops, starfire_suspend, starfire_resume);
 
 static struct pci_driver starfire_driver = {
 	.name		= DRV_NAME,
 	.probe		= starfire_init_one,
 	.remove		= starfire_remove_one,
-#ifdef CONFIG_PM
-	.suspend	= starfire_suspend,
-	.resume		= starfire_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= &starfire_pm_ops,
 	.id_table	= starfire_pci_tbl,
 };
 
-- 
2.27.0

