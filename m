Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C995726EA5A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgIRBNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgIRBNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:13:37 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4551C061756
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:13:37 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id s14so3534827pju.1
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mg4x1zKHQaEJ9xIwr+qUTCmFnuxBqX1ZD/Fgc+4z4Lc=;
        b=QZX9igkJ2n4gk0h0LVcU9FScQB5NZdP6xdKV1WpqKA4rEE/bcLyeQxJd/f02ZG9nvi
         4nwUjZlzG17MoY4kSOrxmf7plp2d0v7DP2tjszpMw9ti8Hd4D66Y63hIMDlryzauhn/1
         tMXTffu0Mx8HE7NM6CSVK+LFz/nJY5G7zl+JA4rDn1JrqySCF3BP9hTM31Q9P+MmGswQ
         W1beA9t8vs2UQJCtFT6OYsU6B80N0BbwayAtgxN/SBlFOnzhLLBmqDwk2S9dTS0ntJeg
         hlHEr77Oc24Gr1P5yiCP7mI/S81cH39cz4G2AtbrCZUNGUgwvZm4NM7eSUX5fYrWwOW6
         NxcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mg4x1zKHQaEJ9xIwr+qUTCmFnuxBqX1ZD/Fgc+4z4Lc=;
        b=Fre3EHWSqI5eSJJ+6CGmviWA8yIRuKGqJrgI6XRECLUpvnZ6STP0MoG9HipndTrneH
         foV4qVQU72DzYlDvQ0K3jL5PEjZqLZP/qGQiGrOe+UYXvDUVLEYAYlIKTh9NWHucF7O2
         4o0NpbyhCZmpoviVjafr7GPuzJg2pBTtbm5n1kiqI3SXs35qZ35NzrI2ygw5AtFomrz8
         HDbCTIX3nP3DPxIS80d0uzT63O5B86YS2wyb29SciR7ZSmfce7Cuk+YUYkAW5agP+uIH
         Z5NZA9gCdgzdo5YvOmfDltCG77/E5lOS4T0BnblsdBxbFKByimXShvV0CYWaG1wQLdtG
         xddw==
X-Gm-Message-State: AOAM5328H5IPYtA+WkDN0gO0Bf60V8Re0Pbwsvl+sctt+NoAsUymz4+O
        elZGVvmQb6n7PrNcqh0hRhq87Y2FK/veJQ==
X-Google-Smtp-Source: ABdhPJzqgKh25OTZcLs7VsfeXylC7wIA6wOyhIcmVO/6QvimvP8T2Il2/qbepJP6/33nriQodhr7ew==
X-Received: by 2002:a17:90a:8044:: with SMTP id e4mr11381970pjw.50.1600391616983;
        Thu, 17 Sep 2020 18:13:36 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id e19sm955701pfl.135.2020.09.17.18.13.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 18:13:36 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v5 net-next 3/5] netdevsim: devlink flash timeout message
Date:   Thu, 17 Sep 2020 18:13:25 -0700
Message-Id: <20200918011327.31577-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200918011327.31577-1-snelson@pensando.io>
References: <20200918011327.31577-1-snelson@pensando.io>
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
index 32f339fedb21..e41f85c75699 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -768,6 +768,8 @@ static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
 						   component,
 						   NSIM_DEV_FLASH_SIZE,
 						   NSIM_DEV_FLASH_SIZE);
+		devlink_flash_update_timeout_notify(devlink, "Flash select",
+						    component, 81);
 		devlink_flash_update_status_notify(devlink, "Flashing done",
 						   component, 0, 0);
 		devlink_flash_update_end_notify(devlink);
-- 
2.17.1

