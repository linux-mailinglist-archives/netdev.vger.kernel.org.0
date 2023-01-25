Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1041167B402
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbjAYOOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235613AbjAYOOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:14:30 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F40A58963
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:23 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id rl14so44664503ejb.2
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hYRioMuki2XpZGPa3NNQf+RgL8arPjVFB6Ed0d4nKQA=;
        b=P0oFD37saiZD0KB7D38TxVzX9wfsv9XuDBPAfuihVYIM9/JRb4YwiEau/pXowgwDn2
         FblcShXf7o2NbPxV+peaw94nWjNN5ltDYrZiI/fzT+NwHRIcyGlacjh+ZyDuKN9CfUDQ
         wU6/xlqqOy6JdsAAoCGizewPtXUN2wWFayuWcPpBM3kpLcmyX7Td18xD2FcydBaLfvvl
         CfvVWnJbwkDXafKA9wKAwPuUqnfooENXUX+9XagKqimQkc9DkDUTDDmBOxrKOlYOk2cZ
         fiiSEs/jyazBmP61P9iqzVwe+wo4Dn//Dkop5JtxweoZh8h85fMvVxl2YG+3b91zsxkC
         vlOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hYRioMuki2XpZGPa3NNQf+RgL8arPjVFB6Ed0d4nKQA=;
        b=RtsZrZ83i+EKc67/IF0ULIlBPSWTctZB6uXMlp6Elnq23HFqIDf9rFFLtdwCT7m9MH
         ccDXeewihnp0ZHsWuul4vUeZJUtDqbN/aPfj5WQYVzdVOK4XrV2/0Ee2nJ/07X/FTzvT
         skf/lyyWX2I57XJPjPFk48t9vkF6SQCR1iBoDi4N8Q7eIsFlfGqduRcaAF+s98wFpYdz
         anyoOQxFcP8yboaRW7yma5r5MUYKUDH1gRebMBM6cfJFqOwq62+Eml8mbi6c3JF84uca
         7dBxOOzbbIrWCkMVkllxQ9Qp7JwrDID7IuRaX3yyG2oifNiqZAOdqDG7CUyxwGqcaguN
         Yzdg==
X-Gm-Message-State: AFqh2kpdtfh3IkgPc0WWM6ntx+tUM70E00/SNrcEeR9IXzboflWES2LF
        5zyhjokJjffRuIGjziE+axyd7V7LHum7ZyKivOA=
X-Google-Smtp-Source: AMrXdXuTOn2nf8w9P883wRmfM/+GLiqjeg6WUn4Nsy5CQVu1ke7+SlG2Zs6HavM849MN6LU8FSLStw==
X-Received: by 2002:a17:906:744:b0:877:9eab:118c with SMTP id z4-20020a170906074400b008779eab118cmr20624291ejb.68.1674656062389;
        Wed, 25 Jan 2023 06:14:22 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id rn13-20020a170906d92d00b007be301a1d51sm2400903ejb.211.2023.01.25.06.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:14:21 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        aelior@marvell.com, manishc@marvell.com, jacob.e.keller@intel.com,
        gal@nvidia.com, yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: [patch net-next 03/12] devlink: make devlink_param_register/unregister static
Date:   Wed, 25 Jan 2023 15:14:03 +0100
Message-Id: <20230125141412.1592256-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230125141412.1592256-1-jiri@resnulli.us>
References: <20230125141412.1592256-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

There is no user outside the devlink code, so remove the export and make
the functions static. Move them before callers to avoid forward
declarations.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h  |  4 --
 net/devlink/leftover.c | 90 +++++++++++++++++-------------------------
 2 files changed, 37 insertions(+), 57 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 608a0c198be8..cf74b6391896 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1773,10 +1773,6 @@ int devlink_params_register(struct devlink *devlink,
 void devlink_params_unregister(struct devlink *devlink,
 			       const struct devlink_param *params,
 			       size_t params_count);
-int devlink_param_register(struct devlink *devlink,
-			   const struct devlink_param *param);
-void devlink_param_unregister(struct devlink *devlink,
-			      const struct devlink_param *param);
 int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value *init_val);
 int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 74621287f4e5..b1216b8f0acc 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -10793,6 +10793,43 @@ static int devlink_param_verify(const struct devlink_param *param)
 		return devlink_param_driver_verify(param);
 }
 
+static int devlink_param_register(struct devlink *devlink,
+				  const struct devlink_param *param)
+{
+	struct devlink_param_item *param_item;
+
+	WARN_ON(devlink_param_verify(param));
+	WARN_ON(devlink_param_find_by_name(&devlink->param_list, param->name));
+
+	if (param->supported_cmodes == BIT(DEVLINK_PARAM_CMODE_DRIVERINIT))
+		WARN_ON(param->get || param->set);
+	else
+		WARN_ON(!param->get || !param->set);
+
+	param_item = kzalloc(sizeof(*param_item), GFP_KERNEL);
+	if (!param_item)
+		return -ENOMEM;
+
+	param_item->param = param;
+
+	list_add_tail(&param_item->list, &devlink->param_list);
+	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
+	return 0;
+}
+
+static void devlink_param_unregister(struct devlink *devlink,
+				     const struct devlink_param *param)
+{
+	struct devlink_param_item *param_item;
+
+	param_item =
+		devlink_param_find_by_name(&devlink->param_list, param->name);
+	WARN_ON(!param_item);
+	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_DEL);
+	list_del(&param_item->list);
+	kfree(param_item);
+}
+
 /**
  *	devlink_params_register - register configuration parameters
  *
@@ -10844,59 +10881,6 @@ void devlink_params_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_params_unregister);
 
-/**
- * devlink_param_register - register one configuration parameter
- *
- * @devlink: devlink
- * @param: one configuration parameter
- *
- * Register the configuration parameter supported by the driver.
- * Return: returns 0 on successful registration or error code otherwise.
- */
-int devlink_param_register(struct devlink *devlink,
-			   const struct devlink_param *param)
-{
-	struct devlink_param_item *param_item;
-
-	WARN_ON(devlink_param_verify(param));
-	WARN_ON(devlink_param_find_by_name(&devlink->param_list, param->name));
-
-	if (param->supported_cmodes == BIT(DEVLINK_PARAM_CMODE_DRIVERINIT))
-		WARN_ON(param->get || param->set);
-	else
-		WARN_ON(!param->get || !param->set);
-
-	param_item = kzalloc(sizeof(*param_item), GFP_KERNEL);
-	if (!param_item)
-		return -ENOMEM;
-
-	param_item->param = param;
-
-	list_add_tail(&param_item->list, &devlink->param_list);
-	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_param_register);
-
-/**
- * devlink_param_unregister - unregister one configuration parameter
- * @devlink: devlink
- * @param: configuration parameter to unregister
- */
-void devlink_param_unregister(struct devlink *devlink,
-			      const struct devlink_param *param)
-{
-	struct devlink_param_item *param_item;
-
-	param_item =
-		devlink_param_find_by_name(&devlink->param_list, param->name);
-	WARN_ON(!param_item);
-	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_DEL);
-	list_del(&param_item->list);
-	kfree(param_item);
-}
-EXPORT_SYMBOL_GPL(devlink_param_unregister);
-
 /**
  *	devlink_param_driverinit_value_get - get configuration parameter
  *					     value for driver initializing
-- 
2.39.0

