Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA43F1A6D7A
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 22:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388523AbgDMUnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 16:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388510AbgDMUnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 16:43:06 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9E7C008749
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 13:43:05 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b72so5043851pfb.11
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 13:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qou+3DHiFyCOtLsGQReefr67dF1uugnjJ0cGHULWluA=;
        b=coykwgBIjHG5yqhbB92pLtYlavZqUPgMd8wp5wB4N0ep3Pf5b4P28noLdtnsX6vzhh
         DNUJhUpz04+jf0QCaP7dfox9eLLytpEK81PCZueXMA+BucEzHpYf0u3Cv57GZ4spGJbY
         galRVU88OpWrtJovA8bUMMqkROLS1K5zKlCn6vYohvCPK4l1nGyCUzDqgrLL3Y6DjoTs
         U51qY0k4hzI8u9eow/McGhyhcWEwrRuGWaA993blXxW1b5Lk0dLMcCYF/JrX3R3lMLCt
         cXpDakv1GwPUri1c4OcZlJdyrCXgJQDFlSriV1eJcSQW+7yFRU2sz5sVj6wR6oQH2Wix
         MQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qou+3DHiFyCOtLsGQReefr67dF1uugnjJ0cGHULWluA=;
        b=AM7hQJPZ60BtePK6TJ8AuYOPsgQ4rzylCO71h3TuuWBqZMcrJwwdZXS+pc6NQUoq+J
         lSLJQjFBoRKPWdtUib/igmdhjIB0YpNi8VSbo8MivF0Kv/iONHHZowAR/VZHvOVK4YK6
         20UAVFpqR6AmIYf13PoaIA8jFminAx2FTAmzqVpOk4oeAsfgVWw1L5MVG6PX5z2/KVMJ
         bfErd5rekxbZj3xWmO3dEpmCBkXbkeMuTYvoWcqbjlYVV4XKILTRWzflErpyUPTz/28F
         w7HIDbVwIHxePv6cyLmz3GErTuDoB/fx3Ecns3EZiCkkarMc1+mxi830ZtWA/md8qN3W
         iGnQ==
X-Gm-Message-State: AGi0PuYWpN1xUBkRb7AnihwpLw7xr+Vt45ZdBVyH0263Bh/E6VO4YqB0
        ZrXXYIxN0REIfpyxbfl+2p7Atw==
X-Google-Smtp-Source: APiQypJbtAPo9CTtu89LDakkWDTpSdCWzy+mxaFrJgxd2ZgwfWY8+YwpvcEqMFAUQXrj8uIZ2KTUVA==
X-Received: by 2002:a62:ee10:: with SMTP id e16mr19444743pfi.247.1586810584668;
        Mon, 13 Apr 2020 13:43:04 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id o21sm4763340pjr.37.2020.04.13.13.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 13:43:04 -0700 (PDT)
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
Subject: [PATCH v2 1/2] driver core: Revert default driver_deferred_probe_timeout value to 0
Date:   Mon, 13 Apr 2020 20:42:52 +0000
Message-Id: <20200413204253.84991-2-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200413204253.84991-1-john.stultz@linaro.org>
References: <20200413204253.84991-1-john.stultz@linaro.org>
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

