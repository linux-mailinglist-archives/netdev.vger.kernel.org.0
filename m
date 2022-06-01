Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E48539DCE
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 09:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350155AbiFAHHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 03:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350001AbiFAHHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 03:07:41 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98BD92D22
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 00:07:38 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f7dbceab08so8350837b3.10
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 00:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tY5TvxF0DIguPBxrOg0QxRWiWFjmhnO2lx3Ak91D1II=;
        b=M4EmWwxIjOOqbWnNm2shyp78Wq2l0MPraPKtCJu05UC44MDEY/Exi1Buk4vleLRfA6
         hLCbl33TE6owA4cS8v+sxEWB/ZTBvCgrXwpcRGCobJTRLNsukN9VGz/Ww6c+mwiEHgOw
         oMH/tspgjYJdTeLl616r5vNsiO5BTSNjtJ/L1cEC6FISgVDncnYDpLmz6qbYmF1e4Ygv
         IWE+q1k4BlglNKziZFmSZpZFH3MnMoz4inzb4RttlTo4LIHhinoudXXBpTycxGz8DD21
         0V/8V93G71Xguwoa3fGGZ1LSkNFOEUs5nrr2JkOwhwkLnxRTkw3XIlBnLOTJyyLKf1t9
         Lz6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tY5TvxF0DIguPBxrOg0QxRWiWFjmhnO2lx3Ak91D1II=;
        b=0gadKTVjJcwOfozgq3oWLEaH6apxf88ppY6lHDYNGQMORp8rANT7Dt58b5APkWB+Qz
         tOFpML2hM3B6F3l7C9quXmZBdgW1fxL33JVpa4vFI5kXhft2zp6oke1KRloCv3/j9KU4
         dGeLm+SY/6nCjqwiYjHphJD4MmTSXa9kBYRO+4mY1z9NuzNaoNxc1DaKMglc4ED6fULn
         dbCPZ5OGWVDHhewQmukTc7hsefKQ1lEQY4gIMfPlb7X9A2PhsOrVtnSRpNFmWopselR6
         dWMb2DG6wGoorM1BUa09wG1fXa4f9Ma9kaNdVtK1walTZwwax1S47+JI2QikqE3RYwM+
         ftZg==
X-Gm-Message-State: AOAM532p5OVpRB0oQTrvoUGd0aPhmNmmdU1B/GtQmisd2WGUOMfhTq5J
        ZEpyUm96Niq+4SBMx/1DN9WL9IJ9RFA2AeA=
X-Google-Smtp-Source: ABdhPJw5KzsjeP7D/G4asa/EzIg+3xbJfCZMhZGP5r9xi1nWdASl5zxhek5FV+LNb6yC8u3L6383mSFJW0llrOc=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:f3aa:cafe:c20a:e136])
 (user=saravanak job=sendgmr) by 2002:a81:8844:0:b0:2fe:a7de:20c2 with SMTP id
 y65-20020a818844000000b002fea7de20c2mr70169556ywf.515.1654067258120; Wed, 01
 Jun 2022 00:07:38 -0700 (PDT)
Date:   Wed,  1 Jun 2022 00:07:05 -0700
In-Reply-To: <20220601070707.3946847-1-saravanak@google.com>
Message-Id: <20220601070707.3946847-10-saravanak@google.com>
Mime-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 9/9] driver core: Delete driver_deferred_probe_check_state()
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
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org
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
index 335e71d3a618..e600dd2afc35 100644
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
index 2114d65b862f..7acaabde5396 100644
--- a/include/linux/device/driver.h
+++ b/include/linux/device/driver.h
@@ -242,7 +242,6 @@ driver_find_device_by_acpi_dev(struct device_driver *drv, const void *adev)
 
 extern int driver_deferred_probe_timeout;
 void driver_deferred_probe_add(struct device *dev);
-int driver_deferred_probe_check_state(struct device *dev);
 void driver_init(void);
 
 /**
-- 
2.36.1.255.ge46751e96f-goog

