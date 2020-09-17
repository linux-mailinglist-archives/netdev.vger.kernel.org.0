Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D84926D175
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 05:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgIQDIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 23:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgIQDIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 23:08:06 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47674C06121C
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:02:17 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m15so340552pls.8
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VESNo/2OJz/Sp8yXsIXxgqMsPsVudyZ4n86jws0CmLQ=;
        b=I0u4Yv3szXahKg0W+sFtoLebtewtNlyhaxlEq9HLv7hSB8tsmN0TE/8EUfMpRgr1Z3
         CTCo+PNo/lE/R+8LC8m9YtZapBxaocjFMxtCdIULm06QVIm3vp3SX+fDD0kiQot6bN4I
         WyztwDXU02+5t+/XDgov3Cz7Wfmbq05LSLBAMPHukMgK9n6xNzneOuwrtMNDtxKTER+/
         UPbrIzsezIIV11ZsLKi6kPokpVKGw2qRDHuP68Sgmt1KIGENCdW04maJu8jyOVeb4hbT
         5Nm3X6tn3ByMv0wsafuKPVU4KDb8SEgVTX5E4+hs0hLksZ0YeqzhN9Ydr9yqpNDGjnu8
         V1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VESNo/2OJz/Sp8yXsIXxgqMsPsVudyZ4n86jws0CmLQ=;
        b=G8teCIPuycDuzcW+YpuZd6aMV6y3quvVTIg1NkqZoz/B33I7FU3AnSsH/aklJoFFZB
         kInKDttZvCy5VPROwRRleM2UnGzaGQskc+TU5b9sX1k6qnNeOk+ZGKTDs/LAxH01IrR4
         7h8SvMPWuUXLwHSCOIoFHmCc9kHLiLBhjVoOXmBCDdBej8Jn66viq4kmGaSuX9QiF4zP
         Y/V9CVUH/qU7+7frBRq/9YH70WsWQe3RBP6h0lW96IDZM9Q89RkCzB5tdWgOSxlRl8Wa
         KUo8CAKqrK8ImfBgKNEi9nsxXCVjalEhbBdo33+44/nP9TSzu5zk40vJ1hDUQoZp9oD+
         8pRw==
X-Gm-Message-State: AOAM530g2SY/9mKQIo0j50huYFV7vQdwZS0W5MwL4vpkJ/jT6Z1uD3wM
        m7lHSDWbhuKQVRucx+mdkkumkeg7hR1jYQ==
X-Google-Smtp-Source: ABdhPJywVSoyUI4zFpbVqd0YKnaDv+DCfvMmSY9ShVyhQpk8zLvaIeS8tibkKxNmI81mZ1GEAELMgw==
X-Received: by 2002:a17:902:8602:b029:d1:e5e7:be65 with SMTP id f2-20020a1709028602b02900d1e5e7be65mr8999996plo.63.1600311736590;
        Wed, 16 Sep 2020 20:02:16 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id b2sm12072498pfp.3.2020.09.16.20.02.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 20:02:15 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 3/5] netdevsim: devlink flash timeout message
Date:   Wed, 16 Sep 2020 20:02:02 -0700
Message-Id: <20200917030204.50098-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200917030204.50098-1-snelson@pensando.io>
References: <20200917030204.50098-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a simple devlink flash timeout message to exercise
the message mechanism.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/netdevsim/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 32f339fedb21..4123550e3f6e 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -768,6 +768,8 @@ static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
 						   component,
 						   NSIM_DEV_FLASH_SIZE,
 						   NSIM_DEV_FLASH_SIZE);
+		devlink_flash_update_timeout_notify(devlink, "Flash timeout",
+						    component, 81);
 		devlink_flash_update_status_notify(devlink, "Flashing done",
 						   component, 0, 0);
 		devlink_flash_update_end_notify(devlink);
-- 
2.17.1

