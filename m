Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72231E1414
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389417AbgEYS0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:26:19 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:44954 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389294AbgEYS0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:26:16 -0400
Received: by mail-ej1-f66.google.com with SMTP id x20so21290395ejb.11;
        Mon, 25 May 2020 11:26:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cTkeVh1JeKZCZ25CUvY4TadYKZCO3Tcb6SZa4hMT8IQ=;
        b=ErZDhe/nw0VBHNE09tJiYT8HuuFIU8OF9d7KmDSDeh6OPhx9NfzI7GEZwtHgNIuIAo
         z3Rug+PKmlFi0LSz53Y93viq4cKqJtIOZ3IATi1eJYnREu2hKEtuQmJzhI8G139ldjju
         vtCJ+MwBw7G8La7TV0d1NqHwgK+0uY5A7k9Au2sTNX47qMtSbx4OSU6yf9ICZLA/O+OY
         Ym36uvgEcDO8haC2zthQacXTgXVP4NeNF4/GN791QAkOCuGrzKxZMytch9ZnqJOdoCz7
         rhgJstt5PA9Mn7nA2K3zway34GTCnPxeeb98i1+kiYEO+VIXfGbT0HwN2SeFX7s6EC5t
         bZYg==
X-Gm-Message-State: AOAM532QuPXqEBi3DCayGz3Xlt/5sh2THPMGZY1oVGCw30m+nSq8s+c4
        mEd+uBa7D8vwh3WA0/KXFsU=
X-Google-Smtp-Source: ABdhPJwJ72EePelVfvR4GiaP04Cb7Af4MA+NTBXjPW6AogUELMABp0aGx0/LBvMTHK50C97aqq0rIg==
X-Received: by 2002:a17:906:ae93:: with SMTP id md19mr19856282ejb.4.1590431173903;
        Mon, 25 May 2020 11:26:13 -0700 (PDT)
Received: from workstation.lan ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id n15sm15555707ejs.10.2020.05.25.11.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 11:26:13 -0700 (PDT)
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
Subject: [PATCH 2/8] ACPI: PM: Use the new device_to_pm() helper to access struct dev_pm_ops
Date:   Mon, 25 May 2020 18:26:02 +0000
Message-Id: <20200525182608.1823735-3-kw@linux.com>
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
 drivers/acpi/device_pm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index 5832bc10aca8..b98a32c48fbe 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -1022,9 +1022,10 @@ static bool acpi_dev_needs_resume(struct device *dev, struct acpi_device *adev)
 int acpi_subsys_prepare(struct device *dev)
 {
 	struct acpi_device *adev = ACPI_COMPANION(dev);
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 
-	if (dev->driver && dev->driver->pm && dev->driver->pm->prepare) {
-		int ret = dev->driver->pm->prepare(dev);
+	if (pm && pm->prepare) {
+		int ret = pm->prepare(dev);
 
 		if (ret < 0)
 			return ret;
-- 
2.26.2

