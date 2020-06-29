Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590CE20E40A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388789AbgF2VUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbgF2Sws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:52:48 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF6FC031C57;
        Mon, 29 Jun 2020 10:36:37 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t6so8635774pgq.1;
        Mon, 29 Jun 2020 10:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0fKzFmJ6swEgieVUVWwiawhKzRLACyYFxC8XDxv8xYs=;
        b=R0fJ45LcAzqMEfB6noKVYodLWFah632V2+qcF0G9d0sHUN7n7MwsjReJlbHyOxFAgQ
         Pyqf1TrIb5+jNNbE7Gu2zh7Pev/OIpQYVhr0G06pAc4EvZ3QZti8JaDPPh9JprJ6lqM7
         tqLA5emrcXMH/+DvgiCyb8A/ClsuRUzKMnIbaTWBxp5GGslGGiGr9HKCHUy1PbvqS24j
         60bvSOJ0Nj3W6JRhbdP6caRjgWiAIuXtyAUuqOPa4jCa9O05I1sFDK5lLIaDCRcZodQs
         B0eEZH4anwaspISF1wAL0KJ23fKcs6Ri+fuakGDCBPHZtFTJikMOeCKnC+N8ARzFsldc
         kSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0fKzFmJ6swEgieVUVWwiawhKzRLACyYFxC8XDxv8xYs=;
        b=smNUO9Kknl4aB+epcEO3OvhfpqOYEzSnukU5Y8FOsTbHqEuOK4HUSAH0sOaZMol3pa
         ZbysRAum9pevIeu/RoBsdy6BbPHkZyR42OHuxaP9QUwNOD25FvWkDCwkc5RlK1eFLw4z
         Kor1VVJ4XEYoAiVX6paPq1xzU23BI3mcXrSuyd4ffz+QSct3XvpRExS9wCZ23vcv54/R
         nfZRdR3zISxQcG86iCF/2rTUykT54JoOGM83r+vhE0TQ8yW3hH0al4uoY2AryDCGvna/
         XTmadXJEMgbqbqq1uda6WxGElKIWiFAn5dcHKBJHgoxxqT99SwaC0i/fxrYTzNdaLsWj
         7u3g==
X-Gm-Message-State: AOAM530e5uElo1NSZYLHCxCvqMzR4Z8WAMgh1xVR78o8N1WD73djtKQ9
        fZ16qRwMH0Dv8mblDvltrI0=
X-Google-Smtp-Source: ABdhPJzX3W9pUE3rQzyWQqNZmLpVSpw6IGMNuc9exvw210citymSwYDDB32iKOYKjCaB5XfOf1cKHw==
X-Received: by 2002:a63:4915:: with SMTP id w21mr5651899pga.134.1593452196587;
        Mon, 29 Jun 2020 10:36:36 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id k23sm331461pgb.92.2020.06.29.10.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 10:36:36 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v2 4/4] vt6655/device_main.c: use generic power management
Date:   Mon, 29 Jun 2020 23:04:59 +0530
Message-Id: <20200629173459.262075-5-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629173459.262075-1-vaibhavgupta40@gmail.com>
References: <20200629173459.262075-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers should not use legacy power management as they have to manage power
states and related operations, for the device, themselves. This driver was
handling them with the help of PCI helper functions like
pci_save/restore_state(), pci_enable/disable_device(), etc.

With generic PM, all essentials will be handled by the PCI core. Driver
needs to do only device-specific operations.

The driver was also using pci_enable_wake(...,..., 0) to disable wake. Use
device_wakeup_disable() instead.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 41cbec4134b0..76de1fd568eb 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1766,48 +1766,37 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 
 /*------------------------------------------------------------------*/
 
-#ifdef CONFIG_PM
-static int vt6655_suspend(struct pci_dev *pcid, pm_message_t state)
+static int __maybe_unused vt6655_suspend(struct device *dev_d)
 {
-	struct vnt_private *priv = pci_get_drvdata(pcid);
+	struct vnt_private *priv = dev_get_drvdata(dev_d);
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	pci_save_state(pcid);
-
 	MACbShutdown(priv);
 
-	pci_disable_device(pcid);
-
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	pci_set_power_state(pcid, pci_choose_state(pcid, state));
-
 	return 0;
 }
 
-static int vt6655_resume(struct pci_dev *pcid)
+static int __maybe_unused vt6655_resume(struct device *dev_d)
 {
-	pci_set_power_state(pcid, PCI_D0);
-	pci_enable_wake(pcid, PCI_D0, 0);
-	pci_restore_state(pcid);
+	device_wakeup_disable(dev_d);
 
 	return 0;
 }
-#endif
 
 MODULE_DEVICE_TABLE(pci, vt6655_pci_id_table);
 
+static SIMPLE_DEV_PM_OPS(vt6655_pm_ops, vt6655_suspend, vt6655_resume);
+
 static struct pci_driver device_driver = {
 	.name = DEVICE_NAME,
 	.id_table = vt6655_pci_id_table,
 	.probe = vt6655_probe,
 	.remove = vt6655_remove,
-#ifdef CONFIG_PM
-	.suspend = vt6655_suspend,
-	.resume = vt6655_resume,
-#endif
+	.driver.pm = &vt6655_pm_ops,
 };
 
 module_pci_driver(device_driver);
-- 
2.27.0

