Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7935A0DF3
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238801AbiHYKeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237443AbiHYKeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:34:07 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131A09C1EB
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:06 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id k6-20020a05600c1c8600b003a54ecc62f6so2272622wms.5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=jbadOKHsJiXw9xqfvBoy7XonB2y7MRIlK9J5e3qad3w=;
        b=VgXS5aNFO+QMf7vcB9Yak6QnFiUym/4IFMRfgS0tYM1wZvwqG6RMfKdjVz1OGGFPga
         Tsv+LmXAOzMazubdjW4d9bG2uE0wR6j2hZyhMWawuEn23kDI9fQOHbBplA3cunL74xFc
         9PWff6weKJColI9mZW6ScM4jStQUQnmgyI9T829DE/gjV1C2j79NgbkmrEyvlN1pEU0x
         NnJ+Q91E9EojJI3foDyNZVAZlymDCldbB51a/Q7VlrSPANq/ixTbSZy5vQF1QWADwhQ6
         mfR62E/FoBAzhUJUitAthkWoZzONPH0cv68lPzCjTM4npeXo6zM/OSz19cthSq3VePWn
         1mWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=jbadOKHsJiXw9xqfvBoy7XonB2y7MRIlK9J5e3qad3w=;
        b=EKwqxiJ1zjcQc3pZFrff2ASpa7xbBraUn5skH9Hvx9UMbrSmkErbb4zxeI7ikTV+pP
         IPUT2ubSSS83up5fQBMDRdrgDVofS2q4huR7Ac5yCy7PFQO3geY6s5PE9vEqUFEJJsmK
         b++Bw57U/eS6ucJF7GQJRC++K+6sxjL2Cc5Sy2kEHXXGAkGr5chTc5wl/C9P9ndRaQDN
         roR3jNFV39IZCgUOJfV02j6HCNVwu+a6kYSpP4Zk7WZsOKw6HH5RC85AN1ooVfeKQTHq
         xDVmUHP/syS6fWk1FLtSSv+voXilL2otkhdb9LInMGUMIRc4tTkOdxZ0jEEOKTUkeFlw
         Zq2g==
X-Gm-Message-State: ACgBeo20wXoh7Ve/8l0sPpSo/Nc5iABiHf4AB+RVaJr8NTWsBmIdixit
        361H1CfWSc2YFox/RpXbpVL9CE6gaG5haKnU
X-Google-Smtp-Source: AA6agR7Ug+pMhNYQELJdQbg2klYpNCEbWYsDaqBLU5F+UPGXI3/oOd3yOkcQ4vfgZgRS+OdK3E5QlA==
X-Received: by 2002:a05:600c:4591:b0:3a6:755b:8e6 with SMTP id r17-20020a05600c459100b003a6755b08e6mr7415915wmo.147.1661423644644;
        Thu, 25 Aug 2022 03:34:04 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w6-20020adfde86000000b002253d162491sm16467890wrl.52.2022.08.25.03.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 03:34:04 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next 1/7] netdevsim: don't re-create dummy region during devlink reload
Date:   Thu, 25 Aug 2022 12:33:54 +0200
Message-Id: <20220825103400.1356995-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220825103400.1356995-1-jiri@resnulli.us>
References: <20220825103400.1356995-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Follow the pattern of other drivers and do not create/destroy region for
registered devlink instance.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e88f783c297e..cd3debc9921a 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1460,13 +1460,9 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 
 	nsim_devlink_param_load_driverinit_values(devlink);
 
-	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
-	if (err)
-		return err;
-
 	err = nsim_dev_traps_init(devlink);
 	if (err)
-		goto err_dummy_region_exit;
+		return err;
 
 	nsim_dev->fib_data = nsim_fib_create(devlink, extack);
 	if (IS_ERR(nsim_dev->fib_data)) {
@@ -1507,8 +1503,6 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 err_traps_exit:
 	nsim_dev_traps_exit(devlink);
-err_dummy_region_exit:
-	nsim_dev_dummy_region_exit(nsim_dev);
 	return err;
 }
 
@@ -1648,7 +1642,6 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	nsim_dev_health_exit(nsim_dev);
 	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 	nsim_dev_traps_exit(devlink);
-	nsim_dev_dummy_region_exit(nsim_dev);
 }
 
 void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
@@ -1662,6 +1655,7 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 
 	nsim_bpf_dev_exit(nsim_dev);
 	nsim_dev_debugfs_exit(nsim_dev);
+	nsim_dev_dummy_region_exit(nsim_dev);
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 	devl_resources_unregister(devlink);
-- 
2.37.1

