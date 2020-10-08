Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28336287860
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731562AbgJHPxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729910AbgJHPxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:30 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF07C0613D2;
        Thu,  8 Oct 2020 08:53:30 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b19so2973288pld.0;
        Thu, 08 Oct 2020 08:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sZD830WHPuHbWWSqWkAn8vXoLem9X7DQltwScbkN0g0=;
        b=s9EujuSgH4IE+Re//qCrxk4wi2YWXpnTqx7MOGcyyMMSN+2BuBpxJTLCSbTKySzyt2
         xLn+2hnv5oYX+mb1fzoynU/8qV8PggGonnE4pfZQOR3gb+7B1blf7BMUub3Zx4HaQqoB
         9cTWJcIcuzEEbk5GEvCmYk9qKFjP+T2FATeq+h+Ffx7xZBR/NCR0R2whrMts2BA81zSJ
         BP8k66VzhnDpk/is2uBm+vmVbOHkJz7+8VA1IuwlRZ0KT9gnJiCHSGsNFhHbLCX/nbZX
         z0kFIssYEV1AE1vCOBkHN4ekfr5mUD0CxCIU5b99ZkzG2tGFEhDzOIDIBKQdNdDWvT8U
         F8RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sZD830WHPuHbWWSqWkAn8vXoLem9X7DQltwScbkN0g0=;
        b=gcmHL42q1qUBTKoPRW7PIuPIncEDyB2Lnr87Smdzslre7HphV7Orm2e/jzN7XibgxB
         XcYeMDCZfzNUNV+KPstzxOTHyaYGECtHm6gop0rjBbsY6MMD+EoCuSD7cL0FP8sKcEfa
         HrmngVoHstoaSF4WkyUAWcGI98xNX0PEKrXUW1LuxNmt7Bd2Z888g9D7QXdfZk72wvJ2
         h3jIwBP61HwlxuEcv+kK51GK3AvA+dCcFlLUUdCwnCrpOqBofiWiB4VneJCqDuxGDEZI
         We+mwe+kryHCkILehxI/3Vy2WQWcHJ2+8MkdLhS+wzje9VWvmmSlOG6Qf9jFAjDu0+1x
         2U9A==
X-Gm-Message-State: AOAM5339/RcHqBzRN+IFw7aYRdTt2mXo1U+BNrh2X3wVihjHlFldkQin
        taXZW8lXw0kd5e4FuGszAQGV83xCF64=
X-Google-Smtp-Source: ABdhPJz0mA/WEhV/mD2IFjcyfoUmRc2WZYl1/CLq0hCJNxeOY2l+sg6vG9U5EcxOZi8avjSTItWPKw==
X-Received: by 2002:a17:902:8c8b:b029:d2:6356:8b43 with SMTP id t11-20020a1709028c8bb02900d263568b43mr8190362plo.34.1602172409811;
        Thu, 08 Oct 2020 08:53:29 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:29 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 022/117] netdevsim: set nsim_dev_health_break_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:34 +0000
Message-Id: <20201008155209.18025-22-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 82c93a87bf8b ("netdevsim: implement couple of testing devlink health reporters")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/netdevsim/health.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index 62958b238d50..21e2974660e7 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -261,6 +261,7 @@ static const struct file_operations nsim_dev_health_break_fops = {
 	.open = simple_open,
 	.write = nsim_dev_health_break_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink)
-- 
2.17.1

