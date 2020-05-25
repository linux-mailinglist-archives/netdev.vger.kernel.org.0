Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2064C1E141F
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389790AbgEYS02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:26:28 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36104 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389294AbgEYS0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:26:22 -0400
Received: by mail-ed1-f67.google.com with SMTP id b91so15737219edf.3;
        Mon, 25 May 2020 11:26:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0zGvHrt9YYoiSjZrnFb35ZKjC/21ugPMkpe0HjhFbIE=;
        b=Sgyj9hjtZEyafbSMpSpYXef8HDKL+AA2+eocPQkxlmHJrAnuAcC8h5KDypURCdOBWH
         6UveCF8AECP8ooKg83e8ksIYVNWqOX9HOSkPWTZqgA5WAUzaM+GkbcQ7CNsexU0AY6/l
         rERvxO+n7FugolWQqpNtzMA1yx+br3Nn/EmCUkJnGBLttiNV8Ei+e+mUiHSzQLk4R4l0
         elNtXzuS44aBbTs8jyHoZZzr7Ekh9oRQNQhMJbuf3F5cw+651Hspertztb3UeXiBfjcE
         otdAsOJbNd3aBwM1x/BiuKnzkgExiqZx9jJl9FMdM/Q8TMglwj9cbV4/jXm1KD74SPvr
         R9UQ==
X-Gm-Message-State: AOAM531fSHVFjrktTfvrlO/b5SxVEz3m6KiK8TH5S1YOU9eHGUfqHR0W
        Gil1zS6O2xwAUqltQk8mZDcTlzxJkslCAX4o
X-Google-Smtp-Source: ABdhPJxu8xj7ETus6I8qz75XV9UcGoEOmg3ZGJLGe0YSg2hAMRNpcfMS5lnkyWZC+sphielpDh7PsA==
X-Received: by 2002:a05:6402:948:: with SMTP id h8mr15890575edz.127.1590431178687;
        Mon, 25 May 2020 11:26:18 -0700 (PDT)
Received: from workstation.lan ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id n15sm15555707ejs.10.2020.05.25.11.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 11:26:18 -0700 (PDT)
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
Subject: [PATCH 5/8] usb: phy: fsl: Use the new device_to_pm() helper to access struct dev_pm_ops
Date:   Mon, 25 May 2020 18:26:05 +0000
Message-Id: <20200525182608.1823735-6-kw@linux.com>
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
 drivers/usb/phy/phy-fsl-usb.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index b451f4695f3f..3b9ad5db8380 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -460,6 +460,7 @@ int fsl_otg_start_host(struct otg_fsm *fsm, int on)
 	struct device *dev;
 	struct fsl_otg *otg_dev =
 		container_of(otg->usb_phy, struct fsl_otg, phy);
+	const struct dev_pm_ops *pm;
 	u32 retval = 0;
 
 	if (!otg->host)
@@ -479,8 +480,9 @@ int fsl_otg_start_host(struct otg_fsm *fsm, int on)
 		else {
 			otg_reset_controller();
 			VDBG("host on......\n");
-			if (dev->driver->pm && dev->driver->pm->resume) {
-				retval = dev->driver->pm->resume(dev);
+			pm = driver_to_pm(dev->driver);
+			if (pm && pm->resume) {
+				retval = pm->resume(dev);
 				if (fsm->id) {
 					/* default-b */
 					fsl_otg_drv_vbus(fsm, 1);
@@ -504,8 +506,9 @@ int fsl_otg_start_host(struct otg_fsm *fsm, int on)
 		else {
 			VDBG("host off......\n");
 			if (dev && dev->driver) {
-				if (dev->driver->pm && dev->driver->pm->suspend)
-					retval = dev->driver->pm->suspend(dev);
+				pm = driver_to_pm(dev->driver);
+				if (pm && pm->suspend)
+					retval = pm->suspend(dev);
 				if (fsm->id)
 					/* default-b */
 					fsl_otg_drv_vbus(fsm, 0);
-- 
2.26.2

