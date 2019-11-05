Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63638F0848
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbfKEV03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:26:29 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39050 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730043AbfKEV02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:26:28 -0500
Received: by mail-lf1-f67.google.com with SMTP id 195so16248307lfj.6
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ntL4uatTRbnY67/sLj/DREGDlFaiypirnHXcXmNPRlI=;
        b=rEZzZvOspn1/wN8PkVjQUbuUVth7C3bZuZAPvQN42Uy1E7Wm6mED+AbhPZ3fr5wsON
         1rds9QB/cTUepXYfXylWiYWUQUVWcwlmpNC31DYtlwVswlXMncA4CSow5SfKtbHzCwX2
         UN5dZVe5+XPW64/1jsBVlL2zOdqAOffr/agcDc/VE3TvmvhUAlyiwabk5fp+mA+dDc1y
         zVoetT+IBxb+CvsQK5H69HeKPWmAtS/HTNqDW5TIQVAVtcSsEVjNniiEUUkf+oUIwPV/
         VtrzJUEAauTD4/twFaizIWbvxKvz8mIWoMIGvPMUW6+AAES5RG4H+xStwW34SGeelZVi
         Wcqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ntL4uatTRbnY67/sLj/DREGDlFaiypirnHXcXmNPRlI=;
        b=KCZMmdwbautt3B1NFopTsJ6sg7edlQKvoinnB2cO+AHK59stiSfVWX06zQvy2GOnRJ
         zYuOySTwn26e/XbangKP99sbsl02qK4F00BWAjBo4V5liuFPQXZ3M4dyL5N+gwel+qM3
         NdREm88WaREp4zkKqLKTkZ7wrxMwZE0cMWY4yH70EjvV33gzKz2T10uP5B15GB0Ru9Xl
         71oj97dl00O1jXFZV2ffBN+FYh+/YpyR2s9Kd/qZ66HmdtNKTkWrJWge0P9qZ4EZ3BVA
         LiXsLy2WHBrF85byg6AmHfq1oudC5S2P9LbcZMErqm4xxAvKBdcez1rtxMO3RjmZzSVg
         1q4A==
X-Gm-Message-State: APjAAAV13MzK6ITtb24oBYuIPFZj3K0gz0868ZzI22R0N13NWgI7RgcL
        AMZsrG7/cdCh1BjiRNAQDOfuNw==
X-Google-Smtp-Source: APXvYqx3ERKVHHTcr8J5AU1numqfRL61EyM42oJxXYwEgZamtlMiVjVgdpvxhkoPkGNsItMrsV/Grg==
X-Received: by 2002:a19:520b:: with SMTP id m11mr21567666lfb.77.1572989184684;
        Tue, 05 Nov 2019 13:26:24 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v1sm9319601lji.89.2019.11.05.13.26.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 13:26:24 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 1/2] netdevsim: drop code duplicated by a merge
Date:   Tue,  5 Nov 2019 13:26:11 -0800
Message-Id: <20191105212612.10737-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105212612.10737-1-jakub.kicinski@netronome.com>
References: <20191105212612.10737-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like the port adding loop makes a re-appearance on net-next
after net was merged back into it (even though it doesn't feature
in the merge diff).

The ports are already added in nsim_dev_create() so when we try
to add them again get EEXIST, and see:

netdevsim: probe of netdevsim0 failed with error -17

in the logs. When we remove the loop again the nsim_dev_probe()
and nsim_dev_remove() become a wrapper of nsim_dev_create() and
nsim_dev_destroy(). Remove this layer of indirection.

Fixes: d31e95585ca6 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/netdevsim/dev.c | 47 +++++++------------------------------
 1 file changed, 8 insertions(+), 39 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e59a8826f36d..3da96c7e8265 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -753,7 +753,7 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	return err;
 }
 
-static struct nsim_dev *nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
+int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 {
 	struct nsim_dev *nsim_dev;
 	struct devlink *devlink;
@@ -761,7 +761,7 @@ static struct nsim_dev *nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 
 	devlink = devlink_alloc(&nsim_dev_devlink_ops, sizeof(*nsim_dev));
 	if (!devlink)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	devlink_net_set(devlink, nsim_bus_dev->initial_net);
 	nsim_dev = devlink_priv(devlink);
 	nsim_dev->nsim_bus_dev = nsim_bus_dev;
@@ -773,6 +773,8 @@ static struct nsim_dev *nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
 	nsim_dev->test1 = NSIM_DEV_TEST1_DEFAULT;
 
+	dev_set_drvdata(&nsim_bus_dev->dev, nsim_dev);
+
 	err = nsim_dev_resources_register(devlink);
 	if (err)
 		goto err_devlink_free;
@@ -818,7 +820,7 @@ static struct nsim_dev *nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 		goto err_bpf_dev_exit;
 
 	devlink_params_publish(devlink);
-	return nsim_dev;
+	return 0;
 
 err_bpf_dev_exit:
 	nsim_bpf_dev_exit(nsim_dev);
@@ -841,7 +843,7 @@ static struct nsim_dev *nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 	devlink_resources_unregister(devlink, NULL);
 err_devlink_free:
 	devlink_free(devlink);
-	return ERR_PTR(err);
+	return err;
 }
 
 static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
@@ -858,8 +860,9 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 }
 
-static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
+void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 {
+	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
 	nsim_dev_reload_destroy(nsim_dev);
@@ -873,40 +876,6 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 	devlink_free(devlink);
 }
 
-int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
-{
-	struct nsim_dev *nsim_dev;
-	int i;
-	int err;
-
-	nsim_dev = nsim_dev_create(nsim_bus_dev);
-	if (IS_ERR(nsim_dev))
-		return PTR_ERR(nsim_dev);
-	dev_set_drvdata(&nsim_bus_dev->dev, nsim_dev);
-
-	mutex_lock(&nsim_dev->port_list_lock);
-	for (i = 0; i < nsim_bus_dev->port_count; i++) {
-		err = __nsim_dev_port_add(nsim_dev, i);
-		if (err)
-			goto err_port_del_all;
-	}
-	mutex_unlock(&nsim_dev->port_list_lock);
-	return 0;
-
-err_port_del_all:
-	mutex_unlock(&nsim_dev->port_list_lock);
-	nsim_dev_port_del_all(nsim_dev);
-	nsim_dev_destroy(nsim_dev);
-	return err;
-}
-
-void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
-{
-	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
-
-	nsim_dev_destroy(nsim_dev);
-}
-
 static struct nsim_dev_port *
 __nsim_dev_port_lookup(struct nsim_dev *nsim_dev, unsigned int port_index)
 {
-- 
2.23.0

