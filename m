Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22EC1E141A
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389506AbgEYS0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:26:22 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35257 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389100AbgEYS0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:26:18 -0400
Received: by mail-ed1-f68.google.com with SMTP id be9so15716301edb.2;
        Mon, 25 May 2020 11:26:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1bL0BwD4jERke74zdsN6GWlbqAKQcOkJQVbWbDofjCc=;
        b=CoHAjtuTgZ7RKbrHFOXlqXo6a0T0ih3ZweRc7jHDv1fccdmzPVdTB48Z665vf2mDPq
         4vfKDab8lm7GuHVAMX2FsfrDxdM2rYU8eMu47gymPgZWJlJ2V7gB3PtCzNNyfZYcaiii
         +FJK74we0EI5UzE8VI8zey1ncORARQI0UCIG7d6yH5YAXcoD2VUa8yFu/vUdC122elxw
         jDFaymZx2lTr4udcolAOP5Wu1zam8TGXzviOR/6hg5lP0gFuwAU4ubhIORuGjekaIYn0
         PxrkEfOKvL1K8zzm8SNFWbmpIZuwNYqdPLcv3ieEbWjA9RQKCdbw38MNw1md4kbYmOZ4
         UlfQ==
X-Gm-Message-State: AOAM530LRNPud5BE4WiJF7vu8+7TLEoiB0vfW09lNzC/H9PukFwkEjeO
        02Q6ldMywmkcBnvZOU2axLg=
X-Google-Smtp-Source: ABdhPJwrYFIAvzGWl142jMalbOrQRtAasOCaag/9Ikx3BCjjSja4mpWvlAvCZRDWouYD7Z+QytFuXg==
X-Received: by 2002:aa7:cb8d:: with SMTP id r13mr16272548edt.12.1590431175453;
        Mon, 25 May 2020 11:26:15 -0700 (PDT)
Received: from workstation.lan ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id n15sm15555707ejs.10.2020.05.25.11.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 11:26:14 -0700 (PDT)
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
Subject: [PATCH 3/8] greybus: Use the new device_to_pm() helper to access struct dev_pm_ops
Date:   Mon, 25 May 2020 18:26:03 +0000
Message-Id: <20200525182608.1823735-4-kw@linux.com>
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
 drivers/greybus/bundle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/greybus/bundle.c b/drivers/greybus/bundle.c
index 84660729538b..d38d3a630812 100644
--- a/drivers/greybus/bundle.c
+++ b/drivers/greybus/bundle.c
@@ -108,7 +108,7 @@ static void gb_bundle_enable_all_connections(struct gb_bundle *bundle)
 static int gb_bundle_suspend(struct device *dev)
 {
 	struct gb_bundle *bundle = to_gb_bundle(dev);
-	const struct dev_pm_ops *pm = dev->driver->pm;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 	int ret;
 
 	if (pm && pm->runtime_suspend) {
@@ -135,7 +135,7 @@ static int gb_bundle_suspend(struct device *dev)
 static int gb_bundle_resume(struct device *dev)
 {
 	struct gb_bundle *bundle = to_gb_bundle(dev);
-	const struct dev_pm_ops *pm = dev->driver->pm;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 	int ret;
 
 	ret = gb_control_bundle_resume(bundle->intf->control, bundle->id);
-- 
2.26.2

