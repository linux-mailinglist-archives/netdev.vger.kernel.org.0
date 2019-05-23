Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 861772799D
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbfEWJpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:45:30 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41603 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730028AbfEWJp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:45:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id u16so1619791wrn.8
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 02:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B0xXqUfMIkHJAVwfzBBQcq55nGXB64HULTsUX85Tw7M=;
        b=qBJTYEKt4NhuqOGa0YtnqKyAgWsvBazpq4wueTg46nljGZjZToQlh/E/JaKvbKP86i
         umKcW7/2opBEnLwxbgewl4usnv70IXOLjm9+hT/zYagEk08Bpv+u+9eMdXONlR/pd/0/
         2prxzNwxvgYA+5LjX+pmQyW27+KqrVeBfmQuf/xnxuQLT2wWyJ75XmAcIPdF8eTbZOjh
         wTi36KtsSBA9sIViAKzeMP2I+zymie3uFofKLaxe+SF6KaTQs1kujQjF5s2rfooP0ubx
         pFURj6alUuUEiU3zCOwqkHkqS5ImJOaekkuZP72dEmoA+b3vkHCBW7kXewwWgAmX0JsS
         LTZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B0xXqUfMIkHJAVwfzBBQcq55nGXB64HULTsUX85Tw7M=;
        b=FXqrM1VyJZch+4yUyO1HC6Lsed+I1gP8A1z3wk8UWPYt6v2r7T1oa3kXFEBLX9wDKI
         BObhog1EyYEVZpmGxbbSwRsbLvMfiCQ+/LnQ6DGxeuooO6QgFYCruJOXU91ocmkgCG2a
         hBs1S6y7pUUjmhCyTw7xGX4qDM3Sqn/gobI9XNSomQbSqtipUZ3DIhmPz5MeDKyDOGrj
         TXDB44ltfizoW1YoasxyC+v8lXHtmN3uYhJJw7IDqNZVvRqUwn/PgLGtPZ99yPuxhDs5
         KKrjh0xBA+Lb08AjQyBH5LtUfgDgSAgNOhVhlaQWFrtFfJPQ3Nj/lZS5Dvco0a0mJDsH
         sW3g==
X-Gm-Message-State: APjAAAXe3FS5DN5WQXZMOLcH+KsN6VWJl1Ft2v8Mn4H+jbm/Dbj2WRMW
        ZyP9d4UDqZC1WNlbnyijXpZ1JSG18y4=
X-Google-Smtp-Source: APXvYqyM3YpGx6PVykWacFhw3d9zAOP9p8FOSIyI2ZEedzUwsfCmVeqCeO6RbIet/+QZiFW+9KHFjw==
X-Received: by 2002:a5d:6710:: with SMTP id o16mr28730774wru.173.1558604727493;
        Thu, 23 May 2019 02:45:27 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id o8sm22747759wrx.50.2019.05.23.02.45.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 02:45:27 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org
Subject: [patch net-next 7/7] netdevsim: implement fake flash updating with notifications
Date:   Thu, 23 May 2019 11:45:10 +0200
Message-Id: <20190523094510.2317-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190523094510.2317-1-jiri@resnulli.us>
References: <20190523094510.2317-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index b509b941d5ca..c15b86f9cd2b 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -220,8 +220,43 @@ static int nsim_dev_reload(struct devlink *devlink,
 	return 0;
 }
 
+#define NSIM_DEV_FLASH_SIZE 500000
+#define NSIM_DEV_FLASH_CHUNK_SIZE 1000
+#define NSIM_DEV_FLASH_CHUNK_TIME_MS 10
+
+static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
+				 const char *component,
+				 struct netlink_ext_ack *extack)
+{
+	int i;
+
+	devlink_flash_update_begin_notify(devlink);
+
+	devlink_flash_update_status_notify(devlink, "Preparing to flash",
+					   component, 0, 0);
+	for (i = 0; i < NSIM_DEV_FLASH_SIZE / NSIM_DEV_FLASH_CHUNK_SIZE; i++) {
+		devlink_flash_update_status_notify(devlink, "Flashing",
+						   component,
+						   i * NSIM_DEV_FLASH_CHUNK_SIZE,
+						   NSIM_DEV_FLASH_SIZE);
+		msleep(NSIM_DEV_FLASH_CHUNK_TIME_MS);
+	}
+	devlink_flash_update_status_notify(devlink, "Flashing",
+					   component,
+					   NSIM_DEV_FLASH_SIZE,
+					   NSIM_DEV_FLASH_SIZE);
+
+	devlink_flash_update_status_notify(devlink, "Flashing done",
+					   component, 0, 0);
+
+	devlink_flash_update_end_notify(devlink);
+
+	return 0;
+}
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.reload = nsim_dev_reload,
+	.flash_update = nsim_dev_flash_update,
 };
 
 static struct nsim_dev *
-- 
2.17.2

