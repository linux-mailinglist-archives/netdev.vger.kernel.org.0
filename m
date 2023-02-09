Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B7F690D66
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjBIPoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbjBIPnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:43:55 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA98611C9
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:43:31 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id dr8so7506284ejc.12
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 07:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2j7izrLQS/3wwxbZ0AOP8xYWibSrF399ZiXullspJXg=;
        b=fOyZFwuh0Q9wYRuvRjRGvjqKKAEy8ZfmkbQtYvJSprMSvncXEBdLFKDJlXK1UgjSBv
         XqK0+4VFKyT2oqwppnZzVfs546Z7R1h7WbN4bjY+CFdrXCyrfPoVM6f9/1E43qQW9tiU
         JMM0hCUKBRhWDzxhanmzoCts8siWRDaySt+fldbMCOtH3ZnFL49dc4jcv+DUgNtdpDRR
         59yneU2wdnk7udlHaCzCuMmpc3mdg6buyCKnIgVqQHlb32gwnWvlamHAcwTr2emmdSPy
         1PGXk1SkJR7eUcF+lKYBUw9sMhci5p05K3FL1CDWOVBjl0cnZaMg7clq1EO+9SFY7qG0
         ddJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2j7izrLQS/3wwxbZ0AOP8xYWibSrF399ZiXullspJXg=;
        b=B6dKpg0+eduMiOtC2kQfnKwX8grd3Rt46jUzeZCY3pYsbaDgc8Z7nELECCgdxi4Fno
         DBJPtL4p3ARwrGmchy6Eb2+NLWPHxtE8R48IkOmwYoUPyxleCh+/iF3VSEQIgL/dsFUU
         AD5TSciN7sQ+59S4mDpm2wVFuR1n3pflU7KJgtbBVMHdEc+Ifxx+g/27gFHrQCUz9/Ip
         qC5nQusivTpPI+OHeX9flcJyTIH7ef2Eg0eMlOcqYIZPm8r9Bv9PV00MZ1EeZYnRGB4S
         EcgmXC6jYv9XMppW1U5WdHjSZbcwkdiOq4trHb+A52yje0tGNGy631slMpDlZpaEAH24
         khYQ==
X-Gm-Message-State: AO0yUKUa7cu9r9QTNbBfZs8Xvi3prknwVVJq8z1XsFl//25s3L5sofr0
        /ScaC3sdV8XfSNAuWjcVZvza1H6ByVjU55H5ld4=
X-Google-Smtp-Source: AK7set8zf1kKTgG+Mgwvh1m0gpc/FjMS7Nligm7AXZ2jF4nqhJhQChMT75oBGyfxERq/aldIIdOpnw==
X-Received: by 2002:a17:907:3f93:b0:82e:a57b:cc9b with SMTP id hr19-20020a1709073f9300b0082ea57bcc9bmr9501611ejc.24.1675957398298;
        Thu, 09 Feb 2023 07:43:18 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id a23-20020a1709063a5700b0087bcda2b07bsm983310ejf.202.2023.02.09.07.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 07:43:17 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com
Subject: [patch net-next 3/7] devlink: fix the name of value arg of devl_param_driverinit_value_get()
Date:   Thu,  9 Feb 2023 16:43:04 +0100
Message-Id: <20230209154308.2984602-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209154308.2984602-1-jiri@resnulli.us>
References: <20230209154308.2984602-1-jiri@resnulli.us>
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

Probably due to copy-paste error, the name of the arg is "init_val"
which is misleading, as the pointer is used to point to struct where to
store the current value. Rename it to "val" and change the arg comment
a bit on the way.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h  | 2 +-
 net/devlink/leftover.c | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8ed960345f37..6a942e70e451 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1784,7 +1784,7 @@ void devlink_params_unregister(struct devlink *devlink,
 			       const struct devlink_param *params,
 			       size_t params_count);
 int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
-				    union devlink_param_value *init_val);
+				    union devlink_param_value *val);
 void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 				     union devlink_param_value init_val);
 void devl_param_value_changed(struct devlink *devlink, u32 param_id);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 6c4c95c658c7..1db45aeff764 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -9626,13 +9626,14 @@ EXPORT_SYMBOL_GPL(devlink_params_unregister);
  *
  *	@devlink: devlink
  *	@param_id: parameter ID
- *	@init_val: value of parameter in driverinit configuration mode
+ *	@val: pointer to store the value of parameter in driverinit
+ *	      configuration mode
  *
  *	This function should be used by the driver to get driverinit
  *	configuration for initialization after reload command.
  */
 int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
-				    union devlink_param_value *init_val)
+				    union devlink_param_value *val)
 {
 	struct devlink_param_item *param_item;
 
@@ -9652,7 +9653,7 @@ int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 						      DEVLINK_PARAM_CMODE_DRIVERINIT)))
 		return -EOPNOTSUPP;
 
-	*init_val = param_item->driverinit_value;
+	*val = param_item->driverinit_value;
 
 	return 0;
 }
-- 
2.39.0

