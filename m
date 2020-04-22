Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00D11B4E68
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 22:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgDVUdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 16:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgDVUdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 16:33:03 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A05C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 13:33:03 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id c21so579661plz.4
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 13:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tKbiuFbiZC2D1ImIHBQi0x36vK7Jcd27HL1H3KbbNwE=;
        b=jtXnZxTje+esnJi9OvNJ9lL0EfuD8nLu8pEU2HsoVZcg/CcP2zGyKA3ip87zMACuqC
         8IlyHWtGZ3RDEGhMv1ojVcGzgcQ2UzGav1z8V9DVG46RPsrPFRbAQJKI1wqNKsZ/VnLa
         g3d28TJUfTOc2mB+OAcyAD67MLfZPLhPHuZLuE4I0tNKuDK5j5se4VPIjC56kkPNukxW
         nKMInSzxn/+VkR9MDaoQqWec8Mas1GxhOcVr5cZg3aNUZJBGcm5thaecm/GrELurVIjW
         8OlM2Vqbe0pj6/rPfZGfZSokntDvKsAiIJnmF8cDaXKsHjGu82Twh55kz59Q60VlC2ct
         0XDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tKbiuFbiZC2D1ImIHBQi0x36vK7Jcd27HL1H3KbbNwE=;
        b=fRkq2nmPcMHBwB5lI0LztY6r61Di2iOgV3n+AMulXdNGKvr/S1XWVr2F9Z8E/MrjZ2
         uWjswHHyECHy2gwFeud6O6AFvuifBGmmkbg0Yuy5fzcQR3qOR9MfhmMUnzPSXALddmsl
         w+AnPucbqcDh316r5+FPmtJHmZ375L0UruNM4qbqcr2slPQl8kel2oj/QXBF7lBksaMx
         eLhd/bR0w8uPz/YmBQG6npLZwEAGYQL9BlPYvhq6dQnbY7IFhY00qjrAZpu3hma3+yxU
         wjDYRuQGfz/8ogL2PkE/u/OtV3kSfJvSFuGtTm5NW2vMd6/jsEAM+HRMyMDg8H4MQT7V
         m5DQ==
X-Gm-Message-State: AGi0PuZb03Fzk3FDG5C/1au0j1+ga9TFYSOZpsCPdka3Omr97zaQ71Fe
        VI6Ey2vfg/2z7xnW/Hk4lEAAjA==
X-Google-Smtp-Source: APiQypJU20peyuHuafIh34ajjRyIE0Frxlgkvku9w3XkjEew13yPlsFgnIJ3FqXvus+Ek2lmVgQrQg==
X-Received: by 2002:a17:902:9347:: with SMTP id g7mr432520plp.77.1587587583090;
        Wed, 22 Apr 2020 13:33:03 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id b24sm360292pfd.175.2020.04.22.13.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 13:33:02 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     lkml <linux-kernel@vger.kernel.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Ferry Toth <fntoth@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        netdev <netdev@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH v3 1/3] driver core: Revert default driver_deferred_probe_timeout value to 0
Date:   Wed, 22 Apr 2020 20:32:43 +0000
Message-Id: <20200422203245.83244-2-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422203245.83244-1-john.stultz@linaro.org>
References: <20200422203245.83244-1-john.stultz@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses a regression in 5.7-rc1+

In commit c8c43cee29f6 ("driver core: Fix
driver_deferred_probe_check_state() logic"), we both cleaned up
the logic and also set the default driver_deferred_probe_timeout
value to 30 seconds to allow for drivers that are missing
dependencies to have some time so that the dependency may be
loaded from userland after initcalls_done is set.

However, Yoshihiro Shimoda reported that on his device that
expects to have unmet dependencies (due to "optional links" in
its devicetree), was failing to mount the NFS root.

In digging further, it seemed the problem was that while the
device properly probes after waiting 30 seconds for any missing
modules to load, the ip_auto_config() had already failed,
resulting in NFS to fail. This was due to ip_auto_config()
calling wait_for_device_probe() which doesn't wait for the
driver_deferred_probe_timeout to fire.

Fixing that issue is possible, but could also introduce 30
second delays in bootups for users who don't have any
missing dependencies, which is not ideal.

So I think the best solution to avoid any regressions is to
revert back to a default timeout value of zero, and allow
systems that need to utilize the timeout in order for userland
to load any modules that supply misisng dependencies in the dts
to specify the timeout length via the exiting documented boot
argument.

Thanks to Geert for chasing down that ip_auto_config was why NFS
was failing in this case!

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Rob Herring <robh@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Basil Eljuse <Basil.Eljuse@arm.com>
Cc: Ferry Toth <fntoth@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: netdev <netdev@vger.kernel.org>
Cc: linux-pm@vger.kernel.org
Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state() logic")
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/base/dd.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 06ec0e851fa1..908ae4d7805e 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -224,16 +224,7 @@ static int deferred_devs_show(struct seq_file *s, void *data)
 }
 DEFINE_SHOW_ATTRIBUTE(deferred_devs);
 
-#ifdef CONFIG_MODULES
-/*
- * In the case of modules, set the default probe timeout to
- * 30 seconds to give userland some time to load needed modules
- */
-int driver_deferred_probe_timeout = 30;
-#else
-/* In the case of !modules, no probe timeout needed */
-int driver_deferred_probe_timeout = -1;
-#endif
+int driver_deferred_probe_timeout;
 EXPORT_SYMBOL_GPL(driver_deferred_probe_timeout);
 
 static int __init deferred_probe_timeout_setup(char *str)
@@ -266,7 +257,7 @@ int driver_deferred_probe_check_state(struct device *dev)
 		return -ENODEV;
 	}
 
-	if (!driver_deferred_probe_timeout) {
+	if (!driver_deferred_probe_timeout && initcalls_done) {
 		dev_WARN(dev, "deferred probe timeout, ignoring dependency");
 		return -ETIMEDOUT;
 	}
-- 
2.17.1

