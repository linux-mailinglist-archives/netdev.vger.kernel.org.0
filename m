Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308925A8215
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiHaPqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiHaPpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:45:53 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A381A1573F;
        Wed, 31 Aug 2022 08:44:31 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id m2so14497949pls.4;
        Wed, 31 Aug 2022 08:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=iwpRJkKob/W9LC0CLDd5HzQIdCGXjeHo185x/cTAZsI=;
        b=WdDFkJjGwcl3r9BG4R2MBx+nK0CNhsRjB59rgtAxJQ9JTqxP6Q8f8DqLmfmCiawEGF
         J857+Y4unzDMWMBqgzHaGaK2rLkckylfmy8jE6nE3dU3QGEDduq8skoalE6udvKa9H4H
         2gMnLN+aoxmXpmI+e0qi9eKYcgJxxCkXBiOwqHIEhrKkDDzPuwZYMo6oNeHol57J9UnA
         wNsakm+GVF6gKf9P5N6T2vHHW9IuXH986J0GDH64WiYy0vi8Bx1gOkW3GeevDUpe2Nmj
         AT74TfCAGqAhER5c8Rub7GElHBr2KKbkdYs+TZq5q8N7C0IaHEGN/wBjLNNsvFI1iyuG
         NSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=iwpRJkKob/W9LC0CLDd5HzQIdCGXjeHo185x/cTAZsI=;
        b=QKf/dyWOTOhCq9IWaNA0VL/Spt2R6RCQRblEGtCY3XuH7w9mQVDa+aVWJ3ulIqARcx
         9iVbl49Jlc2+jEgE6Lbg8muAr6IklkuygJ5A4PdBfkh3Hz1uzOQm5sV8I92r7uT+yW59
         d0a6CWu4F2rq0pcfBXvJOpi+lK5ha/TpU2jDkhuvKwMCVOcR8iFUZ8e7qqgkv2elCCKG
         8wdDVpoKUEcCYPwyiBEMjJ6SwlSTmmMxr0qxcGsTicsUhbYyx9Zh1ap9IvTZnSg77UEl
         qUKpR7AHeIDkibC264MlA5UsHO/85i6O4uGe1cnU41CIwpzZOd6SkzztHSzm96IuHer3
         mDjw==
X-Gm-Message-State: ACgBeo0zo1z5eA0UXV6IPemfaW2PARmCfKsWfzeWOmzoH/Y9Cz+fCr5Q
        Wuu0PTg0iZBpHYHcFIG2ayOzrbv5vow=
X-Google-Smtp-Source: AA6agR7lwMKcra5x2tcN49fEDSf5JdLaxR7O4DEwYKntwMdmcjJCV5xeS+XOjSoynJ1BYVRgNikpzg==
X-Received: by 2002:a17:902:6b42:b0:172:ed37:bc55 with SMTP id g2-20020a1709026b4200b00172ed37bc55mr25821508plt.33.1661960614823;
        Wed, 31 Aug 2022 08:43:34 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 17-20020a630311000000b0042af14719f4sm3499609pgd.51.2022.08.31.08.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 08:43:34 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com
Cc:     pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] netdevsim: remove redundant variable ret
Date:   Wed, 31 Aug 2022 15:43:29 +0000
Message-Id: <20220831154329.305372-1-cui.jinpeng2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Return value directly from nsim_dev_reload_create()
instead of getting value from redundant variable ret.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
---
 drivers/net/netdevsim/dev.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index efea94c27880..794fc0cc73b8 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -965,7 +965,6 @@ static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_actio
 			      struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
-	int ret;
 
 	if (nsim_dev->fail_reload) {
 		/* For testing purposes, user set debugfs fail_reload
@@ -976,8 +975,8 @@ static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_actio
 	}
 
 	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
-	ret = nsim_dev_reload_create(nsim_dev, extack);
-	return ret;
+
+	return nsim_dev_reload_create(nsim_dev, extack);
 }
 
 static int nsim_dev_info_get(struct devlink *devlink,
-- 
2.25.1

