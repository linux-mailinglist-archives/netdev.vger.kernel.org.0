Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F6F1B4E65
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 22:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgDVUdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 16:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgDVUdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 16:33:07 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BBEC03C1AB
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 13:33:06 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g6so1673387pgs.9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 13:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pMZgWl7gaqwxky4xlW6XJbmApvfvRuOxXJn93EkCWVo=;
        b=LEbaRv0dypc5e5Wc7a84Kw/SbMBDatTaHXbP6iCorD9zGzR1nVNn357pTZEPJbSGH8
         DO6J+hGiFfATe4XvgoRwKD/iyt+vOghi0A+9lXjvJKQSSngW7mtkvUKJRtMFXag3XuGi
         kS1lvfmsj1CAadjzqIYzXXp3EGdkoP2Vb3RtgOpOrpr9uGeAie7EZkyNnSjLFFB/VIX+
         cN/PSUP9+7xo5gVqezBN8MHq4yT+hnWXekDCIk3KvZ8RWPcHzzx5WEr2650WPRMUN3Sz
         od9S/oDQyg22NNcbzi4ErXcO0GuJt9RE4qxMlIr7y0GU4oeBhtj10hVFiTQCWHBjJ7SA
         00qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pMZgWl7gaqwxky4xlW6XJbmApvfvRuOxXJn93EkCWVo=;
        b=LXWn6FJHWd3dJ2x6VGaxEXaSvJHOHsqRxGh/5GNsRLZZTnuPhGtXxxDT/w25F5oRlo
         3pUrV+C3VtyswL1rhL7Y6noEB8iFR9K1lOYB7Z3LHf27Ef2QB0WjSQGC2hMdhmmDR+AY
         YsDJf2V/o+THmKqXKcMlqvabX1ArMZznSPPO6VYAdnyqoRq01kVMf2nduJlf/j2upV/4
         oRCSNgYEWAVrw9/lz6fiLCtato5GwyndG97zhZqvCWv7IkLZus7ZFebAt/pwVpAW/g55
         NEt3OcEGEwF4opXL12NNFijdhCgkhroP/Af7EbZGoSWAcghGIplA5rXlXP3VO6yzyIcm
         UZWw==
X-Gm-Message-State: AGi0Puavgd7eNSb5U2Xn+07KOgKA0Uf2Zih09QLxDGQ3jOIh/hrFjjNp
        3b5k3xlGtqt20UUbB4Gsgnnkiw==
X-Google-Smtp-Source: APiQypIk7f8O7AVplXsto40VZokGnKKYUx0F+SKxFkELYuo0ol20r/CNbNqbITXVgN8Ro9fNiSWIaA==
X-Received: by 2002:a63:ef4b:: with SMTP id c11mr760981pgk.400.1587587585769;
        Wed, 22 Apr 2020 13:33:05 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id b24sm360292pfd.175.2020.04.22.13.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 13:33:05 -0700 (PDT)
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
Subject: [PATCH v3 3/3] driver core: Ensure wait_for_device_probe() waits until the deferred_probe_timeout fires
Date:   Wed, 22 Apr 2020 20:32:45 +0000
Message-Id: <20200422203245.83244-4-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422203245.83244-1-john.stultz@linaro.org>
References: <20200422203245.83244-1-john.stultz@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit c8c43cee29f6 ("driver core: Fix
driver_deferred_probe_check_state() logic"), we set the default
driver_deferred_probe_timeout value to 30 seconds to allow for
drivers that are missing dependencies to have some time so that
the dependency may be loaded from userland after initcalls_done
is set.

However, Yoshihiro Shimoda reported that on his device that
expects to have unmet dependencies (due to "optional links" in
its devicetree), was failing to mount the NFS root.

In digging further, it seemed the problem was that while the
device properly probes after waiting 30 seconds for any missing
modules to load, the ip_auto_config() had already failed,
resulting in NFS to fail. This was due to ip_auto_config()
calling wait_for_device_probe() which doesn't wait for the
driver_deferred_probe_timeout to fire.

This patch tries to fix the issue by creating a waitqueue
for the driver_deferred_probe_timeout, and calling wait_event()
to make sure driver_deferred_probe_timeout is zero in
wait_for_device_probe() to make sure all the probing is
finished.

The downside to this solution is that kernel functionality that
uses wait_for_device_probe(), will block until the
driver_deferred_probe_timeout fires, regardless of if there is
any missing dependencies.

However, the previous patch reverts the default timeout value to
zero, so this side-effect will only affect users who specify a
driver_deferred_probe_timeout= value as a boot argument, where
the additional delay would be beneficial to allow modules to
load later during boot.

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
 drivers/base/dd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 9c88afa5c74a..94037be7f5d7 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -226,6 +226,7 @@ DEFINE_SHOW_ATTRIBUTE(deferred_devs);
 
 int driver_deferred_probe_timeout;
 EXPORT_SYMBOL_GPL(driver_deferred_probe_timeout);
+static DECLARE_WAIT_QUEUE_HEAD(probe_timeout_waitqueue);
 
 static int __init deferred_probe_timeout_setup(char *str)
 {
@@ -275,6 +276,7 @@ static void deferred_probe_timeout_work_func(struct work_struct *work)
 
 	list_for_each_entry_safe(private, p, &deferred_probe_pending_list, deferred_probe)
 		dev_info(private->device, "deferred probe pending");
+	wake_up(&probe_timeout_waitqueue);
 }
 static DECLARE_DELAYED_WORK(deferred_probe_timeout_work, deferred_probe_timeout_work_func);
 
@@ -649,6 +651,9 @@ int driver_probe_done(void)
  */
 void wait_for_device_probe(void)
 {
+	/* wait for probe timeout */
+	wait_event(probe_timeout_waitqueue, !driver_deferred_probe_timeout);
+
 	/* wait for the deferred probe workqueue to finish */
 	flush_work(&deferred_probe_work);
 
-- 
2.17.1

