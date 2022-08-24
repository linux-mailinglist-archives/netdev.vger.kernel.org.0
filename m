Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A6259F9B2
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiHXMUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237184AbiHXMUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:20:18 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F061EEFA
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:20:17 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gt3so20729318ejb.12
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=vQnl5YjRf+KfqredliCAVuQyc46b4bvT5okXrAgMRd4=;
        b=L0zctd/B6bplcGEpTmj8SjtgBStIO8KXHDF8hLAng40UfX8bkCqSvvsB4x2CbyrcDV
         TUfJL5oNBaJDhp4FbjAuKyavSNXrZA+IGS03ffIp8uuZAUFdEIJ7TpTWQCfNJOodDCCS
         C8CGruicSnc58KnSmgb9Hsatx/5oM66ebl5C2mqNKj1Wl1EFFkAmjl3z8WV+DbF3OnNA
         buAS00LYRzUsYfU2dRXP+5ybvitQBeAYYMckWIEDO2LS/VW5pkfqoseo6VD22HeQg8iM
         AeVMA+Z3yNrpLIsvFiBbIxXbjZXf3WbEM20yk++7dDcR1H7b7RO12Ad1+rORJWvLKb/O
         snzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=vQnl5YjRf+KfqredliCAVuQyc46b4bvT5okXrAgMRd4=;
        b=8PsgwDc8aoxorBedSDG96a/rZ5T5y1G1gUP5M3UF7smjXK3OF+RM3wDJGayrE+hgHF
         zj4UTiX0C50KMezq8QHxUUBrbUibmyoGtBDDG4DlHclBggTTcfcUatpRuGOMUZ/JP1tx
         U4tR5dhWqg5HftMvqAyNRc1kUQzux2Jn/8VXr0RT+Pz5Ib2+i8aVQzgVAUSR4QNvjVTG
         hT9Bqm8rcR2qZt/clsOgY/QAVd9lbvwmtQguXUgKj5KtO6n0/QGNLlcbFTMmO11VSeEZ
         TGSoFYAxp5FnQYBxd5Fa/b2lvkM/sMyAXhi8U+l3y7Z4/sKubThnjgqqnRXULhenkoSF
         kWHw==
X-Gm-Message-State: ACgBeo0Kg/JYfwh+bbB8RqL/MaOalMWceEFNJ5G2QZmjRMw8Rqs4XD2T
        /y53aWKO5g/1YPNQraLxhix2jFfDEmo9AgD/
X-Google-Smtp-Source: AA6agR5lDS4rycIO+gyAzZI/Oqh4jNaH60pFRfDoVKIAhqzo7sqEjwWn93XiMhUXFr7SLkSSyxOJRg==
X-Received: by 2002:a17:906:844f:b0:73d:56b6:7e3d with SMTP id e15-20020a170906844f00b0073d56b67e3dmr2795930ejy.545.1661343615786;
        Wed, 24 Aug 2022 05:20:15 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 7-20020a170906300700b0073d71587fe5sm1155990ejz.10.2022.08.24.05.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 05:20:15 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next v3 2/3] netdevsim: add version fw.mgmt info info_get() and mark as a component
Date:   Wed, 24 Aug 2022 14:20:10 +0200
Message-Id: <20220824122011.1204330-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220824122011.1204330-1-jiri@resnulli.us>
References: <20220824122011.1204330-1-jiri@resnulli.us>
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
v2->v3:
- added "stored" version
v1->v2:
- split from v1 patch "net: devlink: extend info_get() version put to
  indicate a flash component", no code changes
---
 drivers/net/netdevsim/dev.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e88f783c297e..d6938faf6c8b 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -984,7 +984,17 @@ static int nsim_dev_info_get(struct devlink *devlink,
 			     struct devlink_info_req *req,
 			     struct netlink_ext_ack *extack)
 {
-	return devlink_info_driver_name_put(req, DRV_NAME);
+	int err;
+
+	err = devlink_info_driver_name_put(req, DRV_NAME);
+	if (err)
+		return err;
+	err = devlink_info_version_stored_put_ext(req, "fw.mgmt", "10.20.30",
+						  DEVLINK_INFO_VERSION_TYPE_COMPONENT);
+	if (err)
+		return err;
+	return devlink_info_version_running_put_ext(req, "fw.mgmt", "10.20.30",
+						    DEVLINK_INFO_VERSION_TYPE_COMPONENT);
 }
 
 #define NSIM_DEV_FLASH_SIZE 500000
-- 
2.37.1

