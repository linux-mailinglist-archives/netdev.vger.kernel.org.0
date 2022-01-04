Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0CC4839A4
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiADBJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiADBJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:09:44 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D47CC061792
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 17:09:43 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id c3so12734315pls.5
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 17:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=gq3zbf8O9QZsQJtAASX5zkl9m0I8RRqPVdjiM7fa8d5GlAJwkkksbdXwCHDB08+Y4z
         P3uaSweFDOyJikPR/TWNmufN/TwdtHx+NKJwp3mafbU2q7Qkx81WttDZREWvkK1gJnN3
         4YNDzEWlthC3AKA1AzIDenKmaPD/bLQdKZKX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=SAIEghuEISrDAsO8l1RsesmxjqQ55fwXThRR0AJd/pzvQbCI83TZbvaiFJPdcrXNc7
         sncOc3l8ElDwztOLPHkHEZvzOdd3Pxj0jWm6fCBA/1dRNMmzHQ+1xwRfYFimA+3IhRWt
         /VRXRSpKqgGA1OdOWpFCI9cj07yekFFiifXro5VeAtS+/av4AOpKAFQnv6RYQjjg2fYY
         7kopHUK7Ekdw7cS6NSXWS+SO+Af1OlwZHldUKMzeT9BLukdxFs4RBdJ7udHQATVnrf98
         R1W7jgmLczofjMmSxy/qGvdG1dZmprftoL8+ar1HzIoBjGgYro4Jh+6vljFkBDJ0hfX0
         aiqA==
X-Gm-Message-State: AOAM531iIVprW1SAzeY4kuphei8O+HIwrThGTFyWFPj15Nk1thrfvA7q
        jUDk9vx9E0z1BrF7KtvT2G5qGg==
X-Google-Smtp-Source: ABdhPJwDTod0MLxaOFAaumPSFEd/l8p81s5ph5m/6sExzV7COurjvVEEYwQWPdTL422ZRRkXdOrZhg==
X-Received: by 2002:a17:902:d385:b0:149:9fb2:8633 with SMTP id e5-20020a170902d38500b001499fb28633mr23006130pld.42.1641258583069;
        Mon, 03 Jan 2022 17:09:43 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id v10sm39208654pjr.11.2022.01.03.17.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:09:42 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v3 5/8] net/funeth: devlink support
Date:   Mon,  3 Jan 2022 17:09:30 -0800
Message-Id: <20220104010933.1770777-6-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104010933.1770777-1-dmichail@fungible.com>
References: <20220104010933.1770777-1-dmichail@fungible.com>
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

