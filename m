Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3078959A835
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239849AbiHSWQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239686AbiHSWQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:16:25 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A77C04D0
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 15:16:23 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id kb4-20020a17090ae7c400b001f783657496so5492699pjb.6
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 15:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=BQSSVea5wmDrGG7Dc55xjQCbKa6Vwa11xoA5juoPq98=;
        b=m/w4VOnW+B6hFTGwigf+fYXoDEJW13olaVPFGBtgeL1hEtlqKKVCxTfQ9m5XcRiaIP
         1rU1aOfA4hVzZN4ktFIgo02PwC457k0BiPqJAjQdBCLECZTjC3N0U+rJNb1RA5Xy5rB1
         SRMGYHo9B4A05CZ4wmE6tAPMFVNFuEkTFRv9ORDih1ztXI17gefsQR8Hp4GMgh0/dFjI
         45riHlDzcS/a1UF2P4EZRRNUrkaYCrC6DCKrVYRPbqbCEsuAoKVcYY5ez6bS/f6tgOoY
         DW8w+AJN+ksKbDtbDBbKnGOuwE6Vk9iibf6y0FMmZflAss8jby5psI/la1+FUIZ/hAMi
         gf/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=BQSSVea5wmDrGG7Dc55xjQCbKa6Vwa11xoA5juoPq98=;
        b=RsC0vES/WH/m/zmSMvHtyVxxgAjUVdsayTJjUC6F5gewvjHweAY5hGg9Fe/6axNttK
         O0VIcXWG7I8v/619MKmuTPhHn2UEwDCVQCWutNs3Q0lCCApPnfkjVCmoqQ0mebui9n7x
         Yvf4NBEnluxe9zf2XufddtvcbRSrxFKQvKRN8Kgi/JYt17J/CDEfgo1HDcBiwQOHBQgr
         BuTourPn7cToVgfQR1juNs2jVivYs47jHK2BhEz7MJi/EGgisUKeioYppHJeilz28Y/w
         e3NyXzFyjPzRhg7/ymRvW/0YRDHOLW5c3C/7ASbyaqUpOCfHtfEv/KB+LXj/6fB7oCDK
         22AA==
X-Gm-Message-State: ACgBeo1ZnlWptacr/hHSqSZX7Hi7PfhCapWJVvzo150ZPTQJroAgHmL9
        Jm7x3lPwT6CQs+yfZurZd4adEsr9rHs9lhM=
X-Google-Smtp-Source: AA6agR7xwTgSkhZeDgc7JiOTwdyn5CbJ3ZccHxXmsRpvvOVKOPZZvDSX+KrQWlDF+37Zyf2SqjoLeOhqTbYapE0=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:f93e:7b61:ce3d:5b06])
 (user=saravanak job=sendgmr) by 2002:a17:902:720c:b0:172:a1ff:8c21 with SMTP
 id ba12-20020a170902720c00b00172a1ff8c21mr9292292plb.159.1660947382648; Fri,
 19 Aug 2022 15:16:22 -0700 (PDT)
Date:   Fri, 19 Aug 2022 15:16:11 -0700
In-Reply-To: <20220819221616.2107893-1-saravanak@google.com>
Message-Id: <20220819221616.2107893-2-saravanak@google.com>
Mime-Version: 1.0
References: <20220819221616.2107893-1-saravanak@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 1/4] Revert "driver core: Delete driver_deferred_probe_check_state()"
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saravana Kannan <saravanak@google.com>
Cc:     Peng Fan <peng.fan@nxp.com>, Luca Weiss <luca.weiss@fairphone.com>,
        Doug Anderson <dianders@chromium.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Tony Lindgren <tony@atomide.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Philippe Brucker <jpb@kernel.org>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux.dev,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 9cbffc7a59561be950ecc675d19a3d2b45202b2b.

There are a few more issues to fix that have been reported in the thread
for the original series [1]. We'll need to fix those before this will work.
So, revert it for now.

[1] - https://lore.kernel.org/lkml/20220601070707.3946847-1-saravanak@google.com/

Fixes: 9cbffc7a5956 ("driver core: Delete driver_deferred_probe_check_state()")
Reviewed-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tony Lindgren <tony@atomide.com>
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
2.37.1.595.g718a3a8f04-goog

