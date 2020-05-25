Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3AF1E1433
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389878AbgEYS0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:26:40 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45603 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389535AbgEYS01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:26:27 -0400
Received: by mail-ed1-f66.google.com with SMTP id s19so15690606edt.12;
        Mon, 25 May 2020 11:26:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6WamrPQShgiTsDFapEcmGDUQvC5yr09yE8HLsYvPPjk=;
        b=XQxb+DxHoOZ+c+GE3Accdn0tG1U77du9BRJk0S1niL7Zw1/bmI+igGUL9xpFbZMftY
         UgMF6BZREB4LxwHDyUQkKKyvqJJJfONDQtj4+Tsw4sQQKb+htO0P+E3id+ocuumkoJUH
         0odrF+vB0H/vVm2tweoBH0GVc3mb0wxMwKDDzrRh5eDrgYa4T8RWo+g/u290PJL0NVNT
         te3SFvExCXyML1Wb+Wiv4mzwj6dVivWH0CYsGExr9/Vwm0cmXmpbKIdNJp5Y/hLt40wi
         mbbQifDQm212bAcaRZH9jbjWVAsXV+DUKJTiAA5eahsng6G+zlLGrgtujSPrn7UsJ1PI
         wrAw==
X-Gm-Message-State: AOAM530t8X8PqBtw7DmbEdymLbm6v97fl+BAAv3ew9pyqII2aAm0HEL/
        dyob+DKgvi4o4qJsGSKuIsU=
X-Google-Smtp-Source: ABdhPJwaQ1a3PQrLYUo66G+JvtCe5bgBlAK3z2hUCsbaw6NsBbigY5hyn9hKVKSVUbo33mXU0BIe7w==
X-Received: by 2002:aa7:cf12:: with SMTP id a18mr11182818edy.193.1590431183421;
        Mon, 25 May 2020 11:26:23 -0700 (PDT)
Received: from workstation.lan ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id n15sm15555707ejs.10.2020.05.25.11.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 11:26:22 -0700 (PDT)
From:   =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <balbi@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        greybus-dev@lists.linaro.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 8/8] net/iucv: Use the new device_to_pm() helper to access struct dev_pm_ops
Date:   Mon, 25 May 2020 18:26:08 +0000
Message-Id: <20200525182608.1823735-9-kw@linux.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525182608.1823735-1-kw@linux.com>
References: <20200525182608.1823735-1-kw@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new device_to_pm() helper to access Power Management callbacs
(struct dev_pm_ops) for a particular device (struct device_driver).

No functional change intended.

Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
---
 net/iucv/iucv.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 9a2d023842fe..1a3029ab7c1f 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -1836,23 +1836,23 @@ static void iucv_external_interrupt(struct ext_code ext_code,
 
 static int iucv_pm_prepare(struct device *dev)
 {
-	int rc = 0;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 
 #ifdef CONFIG_PM_DEBUG
 	printk(KERN_INFO "iucv_pm_prepare\n");
 #endif
-	if (dev->driver && dev->driver->pm && dev->driver->pm->prepare)
-		rc = dev->driver->pm->prepare(dev);
-	return rc;
+	return pm && pm->prepare ? pm->prepare(dev) : 0;
 }
 
 static void iucv_pm_complete(struct device *dev)
 {
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
+
 #ifdef CONFIG_PM_DEBUG
 	printk(KERN_INFO "iucv_pm_complete\n");
 #endif
-	if (dev->driver && dev->driver->pm && dev->driver->pm->complete)
-		dev->driver->pm->complete(dev);
+	if (pm && pm->complete)
+		pm->complete(dev);
 }
 
 /**
@@ -1883,6 +1883,7 @@ static int iucv_path_table_empty(void)
 static int iucv_pm_freeze(struct device *dev)
 {
 	int cpu;
+	const struct dev_pm_ops *pm;
 	struct iucv_irq_list *p, *n;
 	int rc = 0;
 
@@ -1902,8 +1903,9 @@ static int iucv_pm_freeze(struct device *dev)
 		}
 	}
 	iucv_pm_state = IUCV_PM_FREEZING;
-	if (dev->driver && dev->driver->pm && dev->driver->pm->freeze)
-		rc = dev->driver->pm->freeze(dev);
+	pm = driver_to_pm(dev->driver);
+	if (pm && pm->freeze)
+		rc = pm->freeze(dev);
 	if (iucv_path_table_empty())
 		iucv_disable();
 	return rc;
@@ -1919,6 +1921,7 @@ static int iucv_pm_freeze(struct device *dev)
  */
 static int iucv_pm_thaw(struct device *dev)
 {
+	const struct dev_pm_ops *pm;
 	int rc = 0;
 
 #ifdef CONFIG_PM_DEBUG
@@ -1938,8 +1941,9 @@ static int iucv_pm_thaw(struct device *dev)
 			/* enable interrupts on all cpus */
 			iucv_setmask_mp();
 	}
-	if (dev->driver && dev->driver->pm && dev->driver->pm->thaw)
-		rc = dev->driver->pm->thaw(dev);
+	pm = driver_to_pm(dev->driver);
+	if (pm && pm->thaw)
+		rc = pm->thaw(dev);
 out:
 	return rc;
 }
@@ -1954,6 +1958,7 @@ static int iucv_pm_thaw(struct device *dev)
  */
 static int iucv_pm_restore(struct device *dev)
 {
+	const struct dev_pm_ops *pm;
 	int rc = 0;
 
 #ifdef CONFIG_PM_DEBUG
@@ -1968,8 +1973,9 @@ static int iucv_pm_restore(struct device *dev)
 		if (rc)
 			goto out;
 	}
-	if (dev->driver && dev->driver->pm && dev->driver->pm->restore)
-		rc = dev->driver->pm->restore(dev);
+	pm = driver_to_pm(dev->driver);
+	if (pm && pm->restore)
+		rc = pm->restore(dev);
 out:
 	return rc;
 }
-- 
2.26.2

