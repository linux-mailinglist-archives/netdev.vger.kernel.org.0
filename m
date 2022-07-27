Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35FD583318
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbiG0TJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbiG0TJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:09:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C44161B33
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 11:50:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v19-20020a252f13000000b0067174f085e9so4059308ybv.1
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 11:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6PMRC4+7ETZ6O5YvP3kBSLPeIUc34qIh1gO+2nFmWRo=;
        b=STPIcS3r2zaNxA7E/SkB84p7lfSdY7kdH/9tNvpaMzSSN00NwQMg3GYOWYlnYHebEw
         dMGQ1J91PpKVadenfIq5DclEZf4jsu47mwqHouONe7IY3flpoZWcwtOuipCkUgIuZhit
         d9tl/VwTZN/CWPNwrUx1oVGm8T+biHUfabWMcje4C0ng/f+uTVzgzBY+P6pNDRHyky9K
         kqzdmm5tt3M6Tp+rfLhRO5SQbGfAr/n/qnU0fenyBvchdXCGJUm/TymA34EiXmuTozO3
         e3oiIP1EfCw1k4mCbjWkHYNKvdurnAKnXrpUFX1+Ch77LTzGUqubaU9RSw6tzBsHMZDr
         S5sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6PMRC4+7ETZ6O5YvP3kBSLPeIUc34qIh1gO+2nFmWRo=;
        b=afSM1z1A3uDHrqvi0g2DoNrxSgj8wnLwzjPrzjD7jGjs3ARpOVObgZbOz4fkIKlIUI
         v02d/xAlbIrebMMA9kEtnTxGrKT6fTw5HKc05ij8Y31iyWsRdVKIuD5rytE+V533jK31
         hgbEG8xaZUi7Gn4DNlY5NUChB2pzilDuOB5jYGgJ/ByoLU6E30gnuH+OB7JEjqV06gAM
         NfSBBdhhhWsnnehTAliOX8n7m1Iz/YhmnIOuWqiyoYwKhQk4VctNxE4+BcWdsh2KuFOv
         UtRCRrqQ0u+qNrfjd0FYlOqEbtf92iIvRC+RVG9RunKzk75BPCJyK2tY69a1Z6kG6M7e
         LwjA==
X-Gm-Message-State: AJIora/S91ZmZQGmA/TvXQRroi8B3+LWQff/N4JZXCOzrmmn49MetMS3
        vVoaZE/su2ypgOelcF7RwcvAZ1COjunVXIg=
X-Google-Smtp-Source: AGRyM1t0kGe85rVKFJazceKwp/HRO3A1D57nD2R5Pm6B9VnNjAno0gRxgXRubEdu4HVVOcO/HvgmF9kn46gj2PM=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:40ee:bae0:a4fd:c75b])
 (user=saravanak job=sendgmr) by 2002:a25:d4a:0:b0:671:6d11:d14e with SMTP id
 71-20020a250d4a000000b006716d11d14emr9175171ybn.479.1658947821364; Wed, 27
 Jul 2022 11:50:21 -0700 (PDT)
Date:   Wed, 27 Jul 2022 11:50:09 -0700
In-Reply-To: <20220727185012.3255200-1-saravanak@google.com>
Message-Id: <20220727185012.3255200-2-saravanak@google.com>
Mime-Version: 1.0
References: <20220727185012.3255200-1-saravanak@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v1 1/3] Revert "driver core: Delete driver_deferred_probe_check_state()"
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Saravana Kannan <saravanak@google.com>, naresh.kamboju@linaro.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 9cbffc7a59561be950ecc675d19a3d2b45202b2b.

There are a few more issues to fix that have been reported in the thread
for the original series [1]. We'll need to fix those before this will
work. So, revert it for now.

[1] - https://lore.kernel.org/lkml/20220601070707.3946847-1-saravanak@google.com/

Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/base/dd.c             | 30 ++++++++++++++++++++++++++++++
 include/linux/device/driver.h |  1 +
 2 files changed, 31 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 70f79fc71539..a8916d1bfdcb 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -274,12 +274,42 @@ static int __init deferred_probe_timeout_setup(char *str)
 }
 __setup("deferred_probe_timeout=", deferred_probe_timeout_setup);
 
+/**
+ * driver_deferred_probe_check_state() - Check deferred probe state
+ * @dev: device to check
+ *
+ * Return:
+ * * -ENODEV if initcalls have completed and modules are disabled.
+ * * -ETIMEDOUT if the deferred probe timeout was set and has expired
+ *   and modules are enabled.
+ * * -EPROBE_DEFER in other cases.
+ *
+ * Drivers or subsystems can opt-in to calling this function instead of directly
+ * returning -EPROBE_DEFER.
+ */
+int driver_deferred_probe_check_state(struct device *dev)
+{
+	if (!IS_ENABLED(CONFIG_MODULES) && initcalls_done) {
+		dev_warn(dev, "ignoring dependency for device, assuming no driver\n");
+		return -ENODEV;
+	}
+
+	if (!driver_deferred_probe_timeout && initcalls_done) {
+		dev_warn(dev, "deferred probe timeout, ignoring dependency\n");
+		return -ETIMEDOUT;
+	}
+
+	return -EPROBE_DEFER;
+}
+EXPORT_SYMBOL_GPL(driver_deferred_probe_check_state);
+
 static void deferred_probe_timeout_work_func(struct work_struct *work)
 {
 	struct device_private *p;
 
 	fw_devlink_drivers_done();
 
+	driver_deferred_probe_timeout = 0;
 	driver_deferred_probe_trigger();
 	flush_work(&deferred_probe_work);
 
diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
index 7acaabde5396..2114d65b862f 100644
--- a/include/linux/device/driver.h
+++ b/include/linux/device/driver.h
@@ -242,6 +242,7 @@ driver_find_device_by_acpi_dev(struct device_driver *drv, const void *adev)
 
 extern int driver_deferred_probe_timeout;
 void driver_deferred_probe_add(struct device *dev);
+int driver_deferred_probe_check_state(struct device *dev);
 void driver_init(void);
 
 /**
-- 
2.37.1.359.gd136c6c3e2-goog

