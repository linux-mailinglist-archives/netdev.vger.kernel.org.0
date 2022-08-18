Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7245983A9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244873AbiHRNA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244404AbiHRNAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:00:50 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC54647D8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:00:49 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gb36so3068053ejc.10
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=QxBeqW2Zs3D42dOk1H+4v0ECrd4LauaTQntluiG28Uc=;
        b=fYaE9oVGcM5AhZNvi63uW8rLjRXX384RnmJrWYUWpZBivwxBMpscjvoFgxTxZ8Y+Ec
         mMd4V9yQI81jlVUHwglmlBHaCvym0WlL8UcGKPwC6bJ2ftEAl1Sjrde2ANX2Ej9F2D14
         UksOtafU4LeNrZVSMLSWpYVnBMtPestdyi7CFUIc6251Yb/5OrhozbcnmUIrLhOlxhW/
         J8nH6UgIuCv+ZsMrWAh5cU5uvWlMsSLM8USRVc2Y6Lfj7tzfZ6WWUmM3/i51zSw3iwNj
         UMTDpOCPYrhxjcI4mhCSkIjO8ce6fgb7Ruzlxqjwf8YhwG95+iBp3CLlYXvUWVdsiHyI
         ZEJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=QxBeqW2Zs3D42dOk1H+4v0ECrd4LauaTQntluiG28Uc=;
        b=2fxtZhE0ROJiLed4mSAJPTn2LYWCzeLo+QKtrNJkCZkfal6y47lIi/MQZA0itjp7d7
         0LLoeintxh+VW6tA6hSOSZk3bNCYgo812zrU7H3MV8FzmI+wPOLDtM9eMsaw9kiH0Ygd
         8/CvfX3zjrnraiMIlBLnPLSo4BDWTFcpWA05CWDNewJEO3D0NypR3iv6ufCDSZRVrTnY
         JAQAme1u/F/PNBcph+qE5YIcCx5tfdvMMtetA5QXVhkpvQIwwFJ2AtVxOrQsbIKSsUyL
         GJtyIYCl9Iz3i7hu0OmrtDlK5Y7zt/XpuvLXcfRlqdH4VEQmP3kpdix7oACtKXYsJ+Z2
         eC/g==
X-Gm-Message-State: ACgBeo0s2GFvLZyDE9sMkEe8yJqgcliIcjVJsoSvWx4/Seat96FbY1i6
        OHCdoITDUvS2H78Gil7ljmFj/mVHXxCI2hC+
X-Google-Smtp-Source: AA6agR5+1vZokPOpLcJyPisnq40TZgxZygw8z/Cz6o8QEOo3z87i2c6o38kUXSpiy6FfhTWJx5OEvA==
X-Received: by 2002:a17:906:9b09:b0:730:c38c:e11c with SMTP id eo9-20020a1709069b0900b00730c38ce11cmr1786043ejc.684.1660827647691;
        Thu, 18 Aug 2022 06:00:47 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id gg23-20020a170906e29700b00732a5b339afsm828301ejb.92.2022.08.18.06.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 06:00:47 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next 3/4] netdevsim: expose version of default flash target
Date:   Thu, 18 Aug 2022 15:00:41 +0200
Message-Id: <20220818130042.535762-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220818130042.535762-1-jiri@resnulli.us>
References: <20220818130042.535762-1-jiri@resnulli.us>
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

Add version named "fw" to represent version of default flash target.

Example:

$ devlink dev info
netdevsim/netdevsim10:
  driver netdevsim
  versions:
      running:
        fw.mgmt 10.20.30
        fw 11.22.33
      flash_components:
        fw.mgmt

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index cea130490dea..97281b6aa41f 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -990,8 +990,12 @@ static int nsim_dev_info_get(struct devlink *devlink,
 	if (err)
 		return err;
 
-	return devlink_info_version_running_put_ext(req, "fw.mgmt", "10.20.30",
-						    DEVLINK_INFO_VERSION_TYPE_COMPONENT);
+	err = devlink_info_version_running_put_ext(req, "fw.mgmt", "10.20.30",
+						   DEVLINK_INFO_VERSION_TYPE_COMPONENT);
+	if (err)
+		return err;
+
+	return devlink_info_version_running_put(req, "fw", "11.22.33");
 }
 
 #define NSIM_DEV_FLASH_SIZE 500000
-- 
2.37.1

