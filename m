Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AFB1E141B
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389541AbgEYS0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:26:24 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46901 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389339AbgEYS0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:26:20 -0400
Received: by mail-ed1-f67.google.com with SMTP id f13so15097900edr.13;
        Mon, 25 May 2020 11:26:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vks0hIgL1NwjWUU2xJ9iHtmVGdxZKzV+xbSUPqXCfwA=;
        b=LEo9fgX+z93XCPxtZSv4U/aKOUbDnDTtBoqZfzlugxY222bvkXsGvTqSoRX1/97aI+
         dTMjuLSZv1dtVyedOqLsI8JydUy0tq14TPWw01aN4PfNRcc2tJOOZtJLJtAVjTmSrNTY
         tAkbQvRgUAwB6yYjkqNhn/aEUleNcyyW2TTRqvBmqPm7Q7iErv4Io9VFKeffDBRMhacA
         66iLNA/HExgrkbhbd4v6z+vUkgysEuNzZcpmgjCmbaMq5XgIwWvL5BUjm6t8qOZQ12hs
         bQgGKDPe0uQRAlDYksyHLFSIfnTcr3VopYpXHOv6ctKqm32S/fgs7kY3WuNmSThQsfG4
         hdcQ==
X-Gm-Message-State: AOAM532GazrAOglUcU6mnKLV+GUU7POZv8HIPvPlf2sa8yKKomJUSs0i
        xGWM9g4OdxFaZAiQMqib78E=
X-Google-Smtp-Source: ABdhPJxpk17hj32HQlVxuKMrJl9fav78GF8tiYkjJ3OmXfQxm5boXKtzfcrmijAtVvsY76ZoDX8sKQ==
X-Received: by 2002:aa7:c3cb:: with SMTP id l11mr15735650edr.364.1590431177072;
        Mon, 25 May 2020 11:26:17 -0700 (PDT)
Received: from workstation.lan ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id n15sm15555707ejs.10.2020.05.25.11.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 11:26:16 -0700 (PDT)
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
Subject: [PATCH 4/8] scsi: pm: Use the new device_to_pm() helper to access struct dev_pm_ops
Date:   Mon, 25 May 2020 18:26:04 +0000
Message-Id: <20200525182608.1823735-5-kw@linux.com>
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
 drivers/scsi/scsi_pm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 5f0ad8b32e3a..8f40b60d3383 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -53,7 +53,7 @@ static int do_scsi_restore(struct device *dev, const struct dev_pm_ops *pm)
 static int scsi_dev_type_suspend(struct device *dev,
 		int (*cb)(struct device *, const struct dev_pm_ops *))
 {
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 	int err;
 
 	/* flush pending in-flight resume operations, suspend is synchronous */
@@ -72,7 +72,7 @@ static int scsi_dev_type_suspend(struct device *dev,
 static int scsi_dev_type_resume(struct device *dev,
 		int (*cb)(struct device *, const struct dev_pm_ops *))
 {
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 	int err = 0;
 
 	err = cb(dev, pm);
@@ -232,7 +232,7 @@ static int scsi_bus_restore(struct device *dev)
 
 static int sdev_runtime_suspend(struct device *dev)
 {
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 	struct scsi_device *sdev = to_scsi_device(dev);
 	int err = 0;
 
@@ -262,7 +262,7 @@ static int scsi_runtime_suspend(struct device *dev)
 static int sdev_runtime_resume(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 	int err = 0;
 
 	blk_pre_runtime_resume(sdev->request_queue);
-- 
2.26.2

