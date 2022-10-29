Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51232612538
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 22:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJ2U0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 16:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiJ2UZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 16:25:54 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E905788C;
        Sat, 29 Oct 2022 13:25:50 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m29-20020a05600c3b1d00b003c6bf423c71so8552604wms.0;
        Sat, 29 Oct 2022 13:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWYKLHUi9DBEWoGp4cSf1c/vBlKmNBjR2+DNGEQs3vI=;
        b=FqGS9uORdWAWhV+Y/EkpgEng/SMmGlsMBPVwBs4ysX8wAQ1BCQay8ZxiUiOSXtJk6L
         xtYIdN7tii+tIYIgoOw+ASpg1K3O9wq7pkktgt0A8jKjWUC2KszGsjY3d3PpOTe8DO6o
         H4NSV2xCtQJ0UKvXTEZBgRspYBBUyey1wo2dGVP8qmx0Tq+7xhL7CQCqoE4yEaOC5Gz2
         WyFSo6HXtTCNw7sSCJnjPGAGne5Mygb+fbUw5uMHQ8eJ0smpB9sOvkWhUStpOo9rZcyd
         XPJXtP+e/edCDKyRVpvf38iFY0IkjXuWIaMr8X57FvC1HIH3VdblSVKyAnEu4u0KGS2L
         Mtjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TWYKLHUi9DBEWoGp4cSf1c/vBlKmNBjR2+DNGEQs3vI=;
        b=GfouCQ3T7W/RcYExzgAYL3UfESXASdBUj1uOc/GaYKalSQyvtYqRmRlH7Y4iU3ugH0
         Q4q5QEkO9107YLr1krloCsNRp3xjoZJSp6mWawok0tjeQvhG4av+KrQC70vtMQVbCruW
         FNYmZXxWGdesTmHFu1p/MYvA48bs14YSGtZTtZ/NhW7qjIBykt05NGfrX9aJ9iDLqgrB
         3QJWLJ3cb/BfhydCd7hYF+ByQ2Hy0VT4jEsW+vXNr3N4gJoHoHgHGXuNOqsARKMkbbtz
         KE3tdJJn+o8WXKLw52iTr5MWfL8fr9Hq/JYwMFYCNhhaCtuvBX//t0Zaukdufbr8IVRm
         9XtA==
X-Gm-Message-State: ACrzQf1kOsgHJc9Hfmnlzyeicyi6dOS8qNG3tgfXrhVhV9f0a36ZpZiQ
        qx2IV2GJWRr1v5LTDt5x4S8=
X-Google-Smtp-Source: AMsMyM7t/LivG7yF8j0MFjRFtVzY9CTTkWYLXaxgKaej/InMieQE7DJ2dO5+g8iNbNXGn+TZMxILcg==
X-Received: by 2002:a7b:cb87:0:b0:3cf:6af4:c509 with SMTP id m7-20020a7bcb87000000b003cf6af4c509mr550343wmi.140.1667075149168;
        Sat, 29 Oct 2022 13:25:49 -0700 (PDT)
Received: from osgiliath.lan (201.ip-51-68-45.eu. [51.68.45.201])
        by smtp.gmail.com with ESMTPSA id k3-20020a05600c1c8300b003c6b7f5567csm16654829wms.0.2022.10.29.13.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 13:25:48 -0700 (PDT)
From:   Ismael Ferreras Morezuelas <swyterzone@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        luiz.von.dentz@intel.com, quic_zijuhu@quicinc.com,
        hdegoede@redhat.com, swyterzone@gmail.com
Cc:     linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 3/3] Bluetooth: btusb: Add a parameter to let users disable the fake CSR force-suspend hack
Date:   Sat, 29 Oct 2022 22:24:54 +0200
Message-Id: <20221029202454.25651-3-swyterzone@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221029202454.25651-1-swyterzone@gmail.com>
References: <20221029202454.25651-1-swyterzone@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few users have reported that their cloned Chinese dongle doesn't
work well with the hack Hans de Goede added, that tries this
off-on mechanism as a way to unfreeze them.

It's still more than worthwhile to have it, as in the vast majority
of cases it either completely brings dongles to life or just resets
them harmlessly as it already happens during normal USB operation.

This is nothing new and the controllers are expected to behave
correctly. But yeah, go figure. :)

For that unhappy minority we can easily handle this edge case by letting
users disable it via our «btusb.disable_fake_csr_forcesuspend_hack=1» kernel option.

I believe this is the most generic way of doing it, given the constraints
and by still having a good out-of-the-box experience.

No clone left behind.

Cc: stable@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
---
 drivers/bluetooth/btusb.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 8f34bf195bae..d31d4f925463 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -34,6 +34,7 @@ static bool force_scofix;
 static bool enable_autosuspend = IS_ENABLED(CONFIG_BT_HCIBTUSB_AUTOSUSPEND);
 static bool enable_poll_sync = IS_ENABLED(CONFIG_BT_HCIBTUSB_POLL_SYNC);
 static bool reset = true;
+static bool disable_fake_csr_forcesuspend_hack;
 
 static struct usb_driver btusb_driver;
 
@@ -2171,7 +2172,7 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 		is_fake = true;
 
 	if (is_fake) {
-		bt_dev_warn(hdev, "CSR: Unbranded CSR clone detected; adding workarounds and force-suspending once...");
+		bt_dev_warn(hdev, "CSR: Unbranded CSR clone detected; adding workarounds...");
 
 		/* Generally these clones have big discrepancies between
 		 * advertised features and what's actually supported.
@@ -2215,21 +2216,24 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 		 * apply this initialization quirk to every controller that gets here,
 		 * it should be harmless. The alternative is to not work at all.
 		 */
-		pm_runtime_allow(&data->udev->dev);
+		if (!disable_fake_csr_forcesuspend_hack) {
+			bt_dev_warn(hdev, "CSR: Unbranded CSR clone detected; force-suspending once...");
+			pm_runtime_allow(&data->udev->dev);
 
-		ret = pm_runtime_suspend(&data->udev->dev);
-		if (ret >= 0)
-			msleep(200);
-		else
-			bt_dev_warn(hdev, "CSR: Couldn't suspend the device for our Barrot 8041a02 receive-issue workaround");
+			ret = pm_runtime_suspend(&data->udev->dev);
+			if (ret >= 0)
+				msleep(200);
+			else
+				bt_dev_warn(hdev, "CSR: Couldn't suspend the device for our Barrot 8041a02 receive-issue workaround");
 
-		pm_runtime_forbid(&data->udev->dev);
+			pm_runtime_forbid(&data->udev->dev);
 
-		device_set_wakeup_capable(&data->udev->dev, false);
+			device_set_wakeup_capable(&data->udev->dev, false);
 
-		/* Re-enable autosuspend if this was requested */
-		if (enable_autosuspend)
-			usb_enable_autosuspend(data->udev);
+			/* Re-enable autosuspend if this was requested */
+			if (enable_autosuspend)
+				usb_enable_autosuspend(data->udev);
+		}
 	}
 
 	kfree_skb(skb);
@@ -4312,6 +4316,9 @@ MODULE_PARM_DESC(enable_autosuspend, "Enable USB autosuspend by default");
 module_param(reset, bool, 0644);
 MODULE_PARM_DESC(reset, "Send HCI reset command on initialization");
 
+module_param(disable_fake_csr_forcesuspend_hack, bool, 0644);
+MODULE_PARM_DESC(disable_fake_csr_forcesuspend_hack, "Don't indiscriminately force-suspend Chinese-cloned CSR dongles trying to unfreeze them");
+
 MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
 MODULE_DESCRIPTION("Generic Bluetooth USB driver ver " VERSION);
 MODULE_VERSION(VERSION);
-- 
2.38.1

