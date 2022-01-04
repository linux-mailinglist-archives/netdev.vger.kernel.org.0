Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883E3483C08
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 07:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbiADGrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 01:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiADGrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 01:47:07 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498A7C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 22:47:07 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 8so31918909pgc.10
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 22:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=MNTrxtxEaGvesQlD/OSXLfIWw4FYfByJrknJSe0+7Le9EE6XmVA6PRR5NV0yFYbjs+
         Pc+NOJfsJGzF2k+IOROpGkQWDh1dIsYuurMi8ta7Nn6vgZFt+jI5LO/r+KHSbbrnllhc
         cYUK/GxLkdumzfg5gFo7p9xK9LENOLqDaeXa0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=N/3QOHLbB8bCFAjUXtsVBTv2myIEfKeLuXCmMvhAhJcJQyBEqCRLonCotc4uJuYfmG
         aSVaBXv2CcfrpMdHTkPgVy5wbQ2rG7SSfRkt/FFKYtHyn23xhf2iPMPPDFbhoIzxX+Mh
         SETju7wVZ35wD6JlARUiZks7ulNgLdTtUhrdOD1jxpewnxtKNXXs+xMmqx6Yu2nwZFZN
         C8n2bJAe0EFIHi6gsfvlH/20RROnYkGxuSagE/+6l7UrehUYTNuRkTvi2DaMSRXB+bEE
         h7iD8vq56PmduxkVUeiqcSm9oJo9hXanm9zv4n/y9d777zvcAalO3ZSFHqq1zch+xiQu
         AOpA==
X-Gm-Message-State: AOAM532NEZy9eRtd16uoHKNHUp3g8chJZW44fpFL5thT2naI3H2Msmzg
        Zwx4yglX8m4HhNjoOQpPwaZs4g==
X-Google-Smtp-Source: ABdhPJxbIwTjWwS+l52WpQvXbMk3LurA4bkK9jbBLlfvueTUo1GLf0ONnwjrYv9Ogp+kPKQVyMSCUA==
X-Received: by 2002:a62:6342:0:b0:4bc:c4f1:2abf with SMTP id x63-20020a626342000000b004bcc4f12abfmr3859886pfb.77.1641278826857;
        Mon, 03 Jan 2022 22:47:06 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id 93sm40424090pjo.26.2022.01.03.22.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 22:47:06 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v4 5/8] net/funeth: devlink support
Date:   Mon,  3 Jan 2022 22:46:54 -0800
Message-Id: <20220104064657.2095041-6-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104064657.2095041-1-dmichail@fungible.com>
References: <20220104064657.2095041-1-dmichail@fungible.com>
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

