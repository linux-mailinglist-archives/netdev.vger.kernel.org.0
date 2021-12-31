Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51084822E9
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 10:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhLaJIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 04:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhLaJIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 04:08:42 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AA7C061574
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 01:08:42 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id g22so23379402pgn.1
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 01:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=jxo7Z3r7D3rru7KcCEmRofnhn7McFdbXl6MnWTJYdr2q1OK6EffxhiD1vNV/rqzHRW
         pL9OqnW+p/sonP75jnFew+DHNSy1gMrWzSteKdwXUIAGMZQGuv8d8kYee/kwEwV1EUfB
         TQjzNLRoG4BhEDSavpNRzZL8VlCVCmklcpFpM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=xZj7xoT/PYSXBsp/FOHWzkevlz7XfQuY8dkQJnk0sYXsydBwoN5lA6F27DFTwZ0/MG
         +Md7Ki2Mn1mRSolHRiHYHA1C3JS9BZNcwtBwFk0NJIdfCxaEbJInTPGBP7UVwDgvLYlr
         FJzOdiC9O8EtrhZbaqbn00XuiiKW3C56C6qq82I/PxjtG8HjQTS8eVMfx+mP5jj2BWpC
         Ugxce9GgY5fhvGlBKNu37AV6zJlpR5WJi40gknSmqwkX2hyU7R4QyVzqDI4Ytcp2Cn7U
         EB5gfE4QsqcoW1QGni60wkCZcr1QPg6yjIbwV1zh2posKovh5EwyJYigMru2j+ikH0rZ
         7oLg==
X-Gm-Message-State: AOAM530j95cTMPTmbLX3zpzLuOe1DlytpQj+MLPspyLx1b6ymnG1JKUr
        MpPW4dbocFlUH0s1iyRoPEUfkNqpGuvfOA==
X-Google-Smtp-Source: ABdhPJwiSJt36HdvVTj4OVUQxRHh+8YfwGwfAJgKcFp+1dEhE/tYh3+mOzxitE8rrXkc4p4UNW+oUA==
X-Received: by 2002:a05:6a00:a94:b0:44c:ecb2:6018 with SMTP id b20-20020a056a000a9400b0044cecb26018mr35132840pfl.57.1640941721588;
        Fri, 31 Dec 2021 01:08:41 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id t31sm19875192pfg.184.2021.12.31.01.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Dec 2021 01:08:40 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v2 5/8] net/funeth: devlink support
Date:   Fri, 31 Dec 2021 01:08:30 -0800
Message-Id: <20211231090833.98977-6-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211231090833.98977-1-dmichail@fungible.com>
References: <20211231090833.98977-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink part, which is minimal at this time giving just the driver
name.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../ethernet/fungible/funeth/funeth_devlink.c | 40 +++++++++++++++++++
 .../ethernet/fungible/funeth/funeth_devlink.h | 13 ++++++
 2 files changed, 53 insertions(+)
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_devlink.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_devlink.h

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_devlink.c b/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
new file mode 100644
index 000000000000..a849b3c6b01f
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_devlink.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
+#include "funeth.h"
+#include "funeth_devlink.h"
+
+static int fun_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
+			   struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static const struct devlink_ops fun_dl_ops = {
+	.info_get = fun_dl_info_get,
+};
+
+struct devlink *fun_devlink_alloc(struct device *dev)
+{
+	return devlink_alloc(&fun_dl_ops, sizeof(struct fun_ethdev), dev);
+}
+
+void fun_devlink_free(struct devlink *devlink)
+{
+	devlink_free(devlink);
+}
+
+void fun_devlink_register(struct devlink *devlink)
+{
+	devlink_register(devlink);
+}
+
+void fun_devlink_unregister(struct devlink *devlink)
+{
+	devlink_unregister(devlink);
+}
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_devlink.h b/drivers/net/ethernet/fungible/funeth/funeth_devlink.h
new file mode 100644
index 000000000000..e40464d57ff4
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_devlink.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+
+#ifndef __FUNETH_DEVLINK_H
+#define __FUNETH_DEVLINK_H
+
+#include <net/devlink.h>
+
+struct devlink *fun_devlink_alloc(struct device *dev);
+void fun_devlink_free(struct devlink *devlink);
+void fun_devlink_register(struct devlink *devlink);
+void fun_devlink_unregister(struct devlink *devlink);
+
+#endif /* __FUNETH_DEVLINK_H */
-- 
2.25.1

