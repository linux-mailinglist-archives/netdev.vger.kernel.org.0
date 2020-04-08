Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415AF1A1C94
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 09:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgDHH07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 03:26:59 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34839 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgDHH04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 03:26:56 -0400
Received: by mail-pf1-f194.google.com with SMTP id a13so2026462pfa.2
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 00:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=RR92PJz/vfU5+w5Mw1m+JK7ovH9yXMWn2/XVn86hUF4=;
        b=o9b/IpfOWX3nEWUPGPu6RG3SPuwiAKT/BMhB1+9/Kqv0fSB7vvdjWW1G+KaVsOfOgM
         r63wgBLsagQyRFpa3sML0m01aNH73sDIWQr5AZk2BUBOnjfhPmwj15A4J9269Y4eQL3A
         Aiy5PKV4bPb7xjbvqrNthovakqZ4XwH4m8acy7b+ipuIaF+yCnQ823+p4WB5HuSQTczU
         hS9RoyvPcKYjCNRfA4LDhhuNw0jrxtbeA9tcxUYpeFKJ6nQ645+j5wa2jjWRL3LhsdxQ
         sFmH767KJfS6IpcxfZ1FUM8vvbmAYo605CSd+aaSpnObNA4IR4EsC+FdYbwxWONGAjKA
         9/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RR92PJz/vfU5+w5Mw1m+JK7ovH9yXMWn2/XVn86hUF4=;
        b=mcaU5lnw87LEzCwHNpX6YPkOqDnL/oSjNnXDGZi4xd4bSj0D0xuaWFFWZ2fKEX+CZE
         vEJXIKc+erQODhLTcJNjVMeXjRJWRC6VZgJQ2XYTZ+YoCBSI/zbHengsXCaDKc6gp1yn
         bGNGlfoSuVKenkx6UHEjeJZlklRMM+hyf57pks7JPaPucwuB7bWUksQHUGpztYqbRyOC
         aj5ssnLbiu88AHXV4y6Sf6uIrWrWkno4X3xW3Uz//slN2oXVEMiVjcLek+d9bkTgBbxe
         Q9bCnqfSOmNS5p8xOzHkk93QC7PqQ9z9M8jb2zk0xn/eAjHN7nxUH6L7FgRCPBfjJgZs
         wK4A==
X-Gm-Message-State: AGi0PubvATku6kM8wi7Eivosl1UUjr/riiJrz30Z5crPFPpBkss8dlfY
        WawH/QPPNuv+AfLOK49Kp7IBgA==
X-Google-Smtp-Source: APiQypI1PwvJKIu1MMqj4sk2SnhJoHI5jNaR8zvH0OAV2wrNTN00E9sg3z8mY1eZAALQB+ttBEMrWw==
X-Received: by 2002:aa7:880c:: with SMTP id c12mr5940143pfo.77.1586330814919;
        Wed, 08 Apr 2020 00:26:54 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id e187sm15356066pfe.143.2020.04.08.00.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 00:26:54 -0700 (PDT)
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
        netdev <netdev@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: [RFC][PATCH v2 1/2] driver core: Revert default driver_deferred_probe_timeout value to 0
Date:   Wed,  8 Apr 2020 07:26:49 +0000
Message-Id: <20200408072650.1731-1-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
Cc: netdev <netdev@vger.kernel.org>
Cc: linux-pm@vger.kernel.org
Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
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

