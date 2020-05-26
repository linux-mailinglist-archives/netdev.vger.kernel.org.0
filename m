Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19E31E1CDA
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 10:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731533AbgEZIFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 04:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbgEZIFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 04:05:00 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9950C03E97E;
        Tue, 26 May 2020 01:04:59 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id z15so4563016pjb.0;
        Tue, 26 May 2020 01:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jUN7Z5XSVYvGRqKnsaDJyJI44CO7kk2ydcRogwW0g9A=;
        b=DZ24zU2kzBS10KM1oPqihig3W3Vzqz1C2+panFVc7mJDCLfPTOfPj2XQ1p8SPHrSbf
         p3w5XWU822itPLD5+ikGpsY0k0LBjfX7TxUAi//EqbvSTfv+wp6JGplQS8PL1DLzX0GL
         7YhJ5fmejEB0lw7B0QpejvATbBc97S9JlsEge5g6/YO/duz4OV5s/ondkAiF2YY6A0nZ
         mUXEG2Ij/+9giVkfHI2C5gdKtAx0F3mJs3tAE8eKZ8vwcXhPOaIXJd0BiiDdgUlOZbmS
         jr0Di9woJFL0xaqhNrvfWjbBMt/w4JFPrq2lKCliOAxVcxZ6ZEeeB8e7i9ettKzjEBCc
         ggwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jUN7Z5XSVYvGRqKnsaDJyJI44CO7kk2ydcRogwW0g9A=;
        b=CQCquP6ZkXgzWzaDDGQMRGgRoEA409wMRrWJc7Zp0uhVj6bUBT13EBE8lp2U03eCpZ
         HcYn73ID2z2XMRMuUOPutKAXOhLIhofR+CZ59WIBDbWyETksC7g3ej0juHQtIFQa77KN
         GjGpnJlM1saz2sbMR3Y0vr0mgSMNiAdaBzpJl4qSdsofaEdyzKF8zEEaEDf0DB1daSWM
         huJyY3YbfcMRvu345d5MSuqVlE+2iHaLMkvR978jSKhmWzDENq/sQCmpTSYgOKWw9OUl
         ewYqQ1majYhmTT3Zc9u0/mlxQhoisJ5Vp4zTj715z96BRA/XhNkEwaqL2ShiMqQ1lXRp
         xDVg==
X-Gm-Message-State: AOAM531xM72jj6sbcg2EzrsmvAvGiw1hMPziiabpWFHoFrfG4P1i0bB3
        RT0imkOevHxF22+Qk5IP+fl9rG6wTsyIqg==
X-Google-Smtp-Source: ABdhPJw+WiWEIFxfAR2QfArjGdBo9QVw2y9nKBsz4PzBM1D5S9VNTZie6OeSTo4FFpdNH2d2r0BxnA==
X-Received: by 2002:a17:90a:f098:: with SMTP id cn24mr25039148pjb.201.1590480299286;
        Tue, 26 May 2020 01:04:59 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.209])
        by smtp.gmail.com with ESMTPSA id fa19sm8614477pjb.18.2020.05.26.01.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 01:04:58 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Don Fry <pcnet32@frontier.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [RFC PATCH v1 1/3] pcnet32: Convert to generic power management
Date:   Tue, 26 May 2020 13:33:22 +0530
Message-Id: <20200526080324.69828-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526080324.69828-1-vaibhavgupta40@gmail.com>
References: <20200526080324.69828-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

compile-tested only

Remove legacy PM callbacks and use generic operations. With legacy code,
drivers were responsible for handling PCI PM operations like
"pci_save_state()". In generic code, all these handled by PCI core.

The generic "suspend()" and "resume()" are called at the same point the
legacy ones were called. Thus, it does not affect the normal functioning of
the driver.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/amd/pcnet32.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index 07e8211eea51..d32f54d760e7 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -2913,30 +2913,27 @@ static void pcnet32_watchdog(struct timer_list *t)
 	mod_timer(&lp->watchdog_timer, round_jiffies(PCNET32_WATCHDOG_TIMEOUT));
 }
 
-static int pcnet32_pm_suspend(struct pci_dev *pdev, pm_message_t state)
+static int pcnet32_pm_suspend(struct device *device_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(device_d);
 
 	if (netif_running(dev)) {
 		netif_device_detach(dev);
 		pcnet32_close(dev);
 	}
-	pci_save_state(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
 	return 0;
 }
 
-static int pcnet32_pm_resume(struct pci_dev *pdev)
+static int pcnet32_pm_resume(struct device *device_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
+	struct net_device *dev = dev_get_drvdata(device_d);
 
 	if (netif_running(dev)) {
 		pcnet32_open(dev);
 		netif_device_attach(dev);
 	}
+
 	return 0;
 }
 
@@ -2957,13 +2954,16 @@ static void pcnet32_remove_one(struct pci_dev *pdev)
 	}
 }
 
+static SIMPLE_DEV_PM_OPS(pcnet32_pm_ops, pcnet32_pm_suspend, pcnet32_pm_resume);
+
 static struct pci_driver pcnet32_driver = {
 	.name = DRV_NAME,
 	.probe = pcnet32_probe_pci,
 	.remove = pcnet32_remove_one,
 	.id_table = pcnet32_pci_tbl,
-	.suspend = pcnet32_pm_suspend,
-	.resume = pcnet32_pm_resume,
+	.driver = {
+		.pm = &pcnet32_pm_ops,
+	},
 };
 
 /* An additional parameter that may be passed in... */
-- 
2.26.2

