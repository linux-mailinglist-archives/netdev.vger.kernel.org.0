Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE46A59C48B
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbiHVRC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbiHVRCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:02:54 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1063ECEB
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:02:53 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b16so14772441edd.4
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ULgK/+IvHR+/TIq9zz1K/UnUR2EFOOBHKxTWq4NsMkw=;
        b=TCdb87gTo6vazNKn32b3aFC3crRj/jxDcdk8UcqquxAw0tc7R3NP7UApfJRk3NG0oQ
         5DYsmOHDIrA2hzAklkxNt9fevbvc+PbBbdLYSHjkE0gniT+NklYAGd0seiFWa70RczWB
         Hxg8LCkbdb9zINVvcrSLRuhkGGbyCXNfFR4edEnCYW92cBCrcLeACerISXpFWGNkPE8n
         eOMqgqq68DhRvRWTe9J+UNf5pduMzQ7TiaxJrUKow1dDrvEPS8wbmcJCGXTvzdzj6WDJ
         /4s9/wymXIY2kc5KRAzEWhyaWziUZAVXtgwz3FOoNCpHt2165ZJYRQFS5Kp81fw+dPjK
         lNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ULgK/+IvHR+/TIq9zz1K/UnUR2EFOOBHKxTWq4NsMkw=;
        b=kN91gwUarPKFWxq1e/bT0EWAokjrhFWaUoVFo38XVt8WmeXaWN4FHvoFFSux0YUVAY
         a8euEBMeX+sjldmLmwuQaBcaAxDHaK/9ZmkK/UiNHWin0ltmGcESbq+MAwwNXDtuRnEq
         7erZ4Qa+/L5Jp+KMIaVI2oU0OzqAtxbRUcBEMnKfMJDv+GR1JcAlcpEhMcpgoMWbv0N4
         XXwSWSyJ3sIPvcbGXz0WZrT7XlmHvBYsIe9CaaSMQbywjBFgfVfW2Gx08JIfufQKwgCC
         2Mj7K6O7RnUHAfsAji2ZUPZ95Pqv5fDdf5yKH6Kj4Ha6crc5SZewxzNW0s27Gahjmkyy
         SNEg==
X-Gm-Message-State: ACgBeo1xtdU7mtp0ntieLBg47WPo/Z+RpnSBFp0+x1fRbFgXjAOpDoZ1
        P4IuTROiafiBfqo/otn0Az68NKNffHEquzGx
X-Google-Smtp-Source: AA6agR4pQ6f9kMf9cGmsbht56f6+MfnvfiIQbMOKruXeSAUGet1TKk9+zA3otKKDfebrwjAQHASTAg==
X-Received: by 2002:a05:6402:524a:b0:43d:aa71:33d8 with SMTP id t10-20020a056402524a00b0043daa7133d8mr104632edd.33.1661187771895;
        Mon, 22 Aug 2022 10:02:51 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g34-20020a056402322200b0043df40e4cfdsm14465eda.35.2022.08.22.10.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 10:02:51 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next v2 2/4] netdevsim: add version fw.mgmt info info_get() and mark as a component
Date:   Mon, 22 Aug 2022 19:02:45 +0200
Message-Id: <20220822170247.974743-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220822170247.974743-1-jiri@resnulli.us>
References: <20220822170247.974743-1-jiri@resnulli.us>
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

Fix the only component user which is netdevsim. It uses component named
"fw.mgmt" in selftests. So add this version to info_get() output with
version type component.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- split from v1 patch "net: devlink: extend info_get() version put to
  indicate a flash component", no code changes
---
 drivers/net/netdevsim/dev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e88f783c297e..97fc17ffff93 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -984,7 +984,14 @@ static int nsim_dev_info_get(struct devlink *devlink,
 			     struct devlink_info_req *req,
 			     struct netlink_ext_ack *extack)
 {
-	return devlink_info_driver_name_put(req, DRV_NAME);
+	int err;
+
+	err = devlink_info_driver_name_put(req, DRV_NAME);
+	if (err)
+		return err;
+
+	return devlink_info_version_running_put_ext(req, "fw.mgmt", "10.20.30",
+						    DEVLINK_INFO_VERSION_TYPE_COMPONENT);
 }
 
 #define NSIM_DEV_FLASH_SIZE 500000
-- 
2.37.1

