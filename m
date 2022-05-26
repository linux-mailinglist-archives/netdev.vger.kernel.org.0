Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D8B534B7B
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346783AbiEZIQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346672AbiEZIQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:16:42 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85DB4EA37
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:16:20 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id t14-20020a65608e000000b003fa321e8ea3so533869pgu.18
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2cafqgyvMaG8pnmb2DwUPLH+NwqexHFaoGplVLqjY6c=;
        b=Qhvec8EM5waM3couwB4Dum8OsNReKnA1EIAEV8LpsepiAu+NTnpIDd6zPzvaScyoHi
         joLxHL0NnhEkyS300O8xI9N1fgEmoiNW+tHhgRg+C3VgA1m7nuIAVZgpAAN0SCoZaXb3
         HEB/SDIh21LxIk12AKALJ8PaTt3HoxW0TucqgFk8I+2nWe8sV+SOqE/1qyqqfeteZr3g
         EufhH6H9hKX80HxUrjS4SaCSZY+0yU4qfhVpbOF9hKztCUUvRR36MTpKRlzF3fXGT8kL
         xXPgN+vDeTbaZIcJj1bpAuXYJV78EUX8wvpAl/KOGx8ob/jDmnzqVjFH+adTvCIPzWq4
         hKpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2cafqgyvMaG8pnmb2DwUPLH+NwqexHFaoGplVLqjY6c=;
        b=FmGcNziWLbkrsQ7HUGUIXUvAkSI7IU0pxod7mOHNWE8mEvx+WpIlGZuQHP3nacYM9C
         e9DVPQU2pGjDzbGTV3HnH4xlU53ATBX6P40bfNziXOGUU0DfMhYbXRCY3igBnhkOnCis
         cn21Rc1TowsNH4W0QdXFrd6AUsGMY3X5sZgk7zm7J6Wv3sqMmW/w+/ioDwHIoDC4uPT8
         puOi27W3oeoEOI0/VarDptf6OVuJBXP3DYqWhkpurm/Zl4j+sFfBfbCwcmECVTEoJyjr
         QQYXpxeLK/2wgG76CeUmTX3CaQ3EPbVLfZpsp4fgRPKmhuML/prh4bDABqP7Xc9ltKGi
         B13A==
X-Gm-Message-State: AOAM531JRj0R9x2Xd7jzYb0FiN4R+LUK7nqwMtXi7SpEckRKsfRrbg5g
        Ov4WMeSyUmB7d8g82phk+aq1BzaQAgkrsUg=
X-Google-Smtp-Source: ABdhPJyinReesiUqDbMmyw2id5J+MedifDe6OonBttcETpmdQGcuAvMkhqslxCFm255z4G73O9ROU101o9oWZy4=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:ff1f:a3b7:b6de:d30f])
 (user=saravanak job=sendgmr) by 2002:a17:902:7004:b0:161:f216:4f3f with SMTP
 id y4-20020a170902700400b00161f2164f3fmr30173525plk.98.1653552980455; Thu, 26
 May 2022 01:16:20 -0700 (PDT)
Date:   Thu, 26 May 2022 01:15:48 -0700
In-Reply-To: <20220526081550.1089805-1-saravanak@google.com>
Message-Id: <20220526081550.1089805-10-saravanak@google.com>
Mime-Version: 1.0
References: <20220526081550.1089805-1-saravanak@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [RFC PATCH v1 9/9] driver core: Delete driver_deferred_probe_check_state()
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        John Stultz <jstultz@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function is no longer used. So delete it.

Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/base/dd.c             | 30 ------------------------------
 include/linux/device/driver.h |  1 -
 2 files changed, 31 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index af8138d44e6c..789b0871dc45 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -274,42 +274,12 @@ static int __init deferred_probe_timeout_setup(char *str)
 }
 __setup("deferred_probe_timeout=", deferred_probe_timeout_setup);
 
-/**
- * driver_deferred_probe_check_state() - Check deferred probe state
- * @dev: device to check
- *
- * Return:
- * * -ENODEV if initcalls have completed and modules are disabled.
- * * -ETIMEDOUT if the deferred probe timeout was set and has expired
- *   and modules are enabled.
- * * -EPROBE_DEFER in other cases.
- *
- * Drivers or subsystems can opt-in to calling this function instead of directly
- * returning -EPROBE_DEFER.
- */
-int driver_deferred_probe_check_state(struct device *dev)
-{
-	if (!IS_ENABLED(CONFIG_MODULES) && initcalls_done) {
-		dev_warn(dev, "ignoring dependency for device, assuming no driver\n");
-		return -ENODEV;
-	}
-
-	if (!driver_deferred_probe_timeout && initcalls_done) {
-		dev_warn(dev, "deferred probe timeout, ignoring dependency\n");
-		return -ETIMEDOUT;
-	}
-
-	return -EPROBE_DEFER;
-}
-EXPORT_SYMBOL_GPL(driver_deferred_probe_check_state);
-
 static void deferred_probe_timeout_work_func(struct work_struct *work)
 {
 	struct device_private *p;
 
 	fw_devlink_drivers_done();
 
-	driver_deferred_probe_timeout = 0;
 	driver_deferred_probe_trigger();
 	flush_work(&deferred_probe_work);
 
diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
index 700453017e1c..7c245d269feb 100644
--- a/include/linux/device/driver.h
+++ b/include/linux/device/driver.h
@@ -241,7 +241,6 @@ driver_find_device_by_acpi_dev(struct device_driver *drv, const void *adev)
 
 extern int driver_deferred_probe_timeout;
 void driver_deferred_probe_add(struct device *dev);
-int driver_deferred_probe_check_state(struct device *dev);
 void driver_init(void);
 
 /**
-- 
2.36.1.124.g0e6072fb45-goog

