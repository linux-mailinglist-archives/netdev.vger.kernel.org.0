Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEAE211140
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732771AbgGAQx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732569AbgGAQxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:53:55 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7D2C08C5C1;
        Wed,  1 Jul 2020 09:53:55 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id f16so893959pjt.0;
        Wed, 01 Jul 2020 09:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kPREycfu6FufAZszREhE/oVuVmbyYHJrTGXZmdD6YwE=;
        b=Uf2vE3SmZc9GDVQCb0LGYBDd9C/ZEqHmMOm+FhErGlLpILmyNio9Plvi8QJHQmi6X5
         Sg7NsCkSlUR+ZxegJXP/X6yDrK2P5fp4eymAqGOyNaSla1rtz6Y9BpLAMVGj8BGn7+7N
         480aTbRVwBRDCLz4lgYqVxQZ0NIjqhe+MUgQ00zTvtNLgiZxV4PAIRQMFIh8+xhcRuj2
         Wjf9vG+S8qXfiqFcXtCvOwXU6vEq2voi5iztWeXkX+09NXrbGb3mpElKeert43+zV4g6
         /oFwRarRUe1hSVOI12H3/srj12SRn+khQHGeWY8zrl27tTHNps1hgGIn2QtxSqEyAFBg
         8KdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kPREycfu6FufAZszREhE/oVuVmbyYHJrTGXZmdD6YwE=;
        b=XqpSXNjmAntHEIT3asUy/OuxUlQm48dziMLMJqt98HHsBpvhRJqsTORisPz6eL4QxS
         43s9eibmeAdgyCYCQOhMZTmAN/OVpyj7h/neMFruNgReE5YaHSUMkrxZ9Sasoy+pTilH
         RePuPw+VbtDzXBXCPJsVT1jDUtyz3D35f/FEDXzAYpfHurVyaWUCOxwmj94ZEeBjyLQ2
         liEKv/mTDJ/SY0zGMv6XdJPZeYM6ukQ9z1WiSg8vZpHzmHDBSApdlteyNmAjJaFyadEI
         AAxVip1CXC6+6aL/yS+nE+MxRhU79DcMr4/RKNzIncidgSjZOSASZCMj/mB91VhnmQR+
         IaXA==
X-Gm-Message-State: AOAM530R7JEWoOnxIosUJP1eskYd3pTvDXzww6SE6w1TjHpi4mK3psLW
        /cm91XVuqP8hibpHkVKPzRY=
X-Google-Smtp-Source: ABdhPJw1ftgqNuQY9U7LsN0c1RPpFh/kWQx1H8nkaFDTO+wGI7aJwU3zf78geMQzXK3YDxQ4akBWKQ==
X-Received: by 2002:a17:90b:194f:: with SMTP id nk15mr14517024pjb.189.1593622434777;
        Wed, 01 Jul 2020 09:53:54 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id g140sm6297437pfb.48.2020.07.01.09.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 09:53:54 -0700 (PDT)
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
Subject: [PATCH v2 10/11] vxge: use generic power management
Date:   Wed,  1 Jul 2020 22:20:56 +0530
Message-Id: <20200701165057.667799-11-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
References: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
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

Use "struct dev_pm_ops" variable to bind the callbacks.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 9b63574b6202..5de85b9e9e35 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3999,12 +3999,11 @@ static void vxge_print_parm(struct vxgedev *vdev, u64 vpath_mask)
 	}
 }
 
-#ifdef CONFIG_PM
 /**
  * vxge_pm_suspend - vxge power management suspend entry point
  *
  */
-static int vxge_pm_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused vxge_pm_suspend(struct device *dev_d)
 {
 	return -ENOSYS;
 }
@@ -4012,13 +4011,11 @@ static int vxge_pm_suspend(struct pci_dev *pdev, pm_message_t state)
  * vxge_pm_resume - vxge power management resume entry point
  *
  */
-static int vxge_pm_resume(struct pci_dev *pdev)
+static int __maybe_unused vxge_pm_resume(struct device *dev_d)
 {
 	return -ENOSYS;
 }
 
-#endif
-
 /**
  * vxge_io_error_detected - called when PCI error is detected
  * @pdev: Pointer to PCI device
@@ -4796,15 +4793,14 @@ static const struct pci_error_handlers vxge_err_handler = {
 	.resume = vxge_io_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(vxge_pm_ops, vxge_pm_suspend, vxge_pm_resume);
+
 static struct pci_driver vxge_driver = {
 	.name = VXGE_DRIVER_NAME,
 	.id_table = vxge_id_table,
 	.probe = vxge_probe,
 	.remove = vxge_remove,
-#ifdef CONFIG_PM
-	.suspend = vxge_pm_suspend,
-	.resume = vxge_pm_resume,
-#endif
+	.driver.pm = &vxge_pm_ops,
 	.err_handler = &vxge_err_handler,
 };
 
-- 
2.27.0

