Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DCD488E7C
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238047AbiAJB4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238082AbiAJB4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:56:45 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1F3C061757
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 17:56:45 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so5058548pja.1
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 17:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=EZ6RgLpWtgGnruALOHCEedt9zDkc8BHEfu2UAftW5h9dzF/wCOZQUyi1rAwRBux4hO
         cTGCOUWQ/AlCLVw3DFb0RLhtjbHjmIqkWFKH6q9PFxlj8Gt7PIQJIIIJviQ1ugnF+RCA
         Nw6m4N/7krFxKbrRrS/LLIeNCQsNeZwPs24Dk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=K7DgkkDTt/GY1LrpOFckEAtLCe7mRLyeEg+l6jQIHxxJvawCdaEXYWhHXzfjD3DW4R
         KXcSTKCRQUdN1UYxeFzLpZfLoqp322PeQLE/ndtBrp2uVlzd/foLEn7VpTfj7VeWLgu0
         0r/OjafEXfs4vJtUIM7PJezeeSHvLJxNaOylm5j6TTqPBUNZL0dhbeKMZkdf3fQIad8o
         XpmIu8rYnVwtKOp0TvU3pxR27VLOMR0JXY1P/ZCZJdtssl/bBQPZ69+5HWqRVrUcitPh
         XkhNlb7cIqJBblg32q1eRXC2WF9Lci/Eek5QgCVCYqa06lA6FCKqO7I1zuG5QeiAdIMz
         K34A==
X-Gm-Message-State: AOAM532I/wXjHZUwGw7oBL62b/BPXbPbUispSxMFbcBI5Z8h3smz/FMj
        ckoXO5ywkFm0P7bTr7IGNfJDl+t26NsHLw==
X-Google-Smtp-Source: ABdhPJxQfg0oOuq/CxIKvGQ0Y0p4v+wJYzr1E9jQt27uwESIH+Ln6EPGoeeLeVGA2UoRxyaj1TewrA==
X-Received: by 2002:a17:902:ced2:b0:149:2f04:e00c with SMTP id d18-20020a170902ced200b001492f04e00cmr71851567plg.13.1641779804702;
        Sun, 09 Jan 2022 17:56:44 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id rm3sm6909535pjb.8.2022.01.09.17.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 17:56:44 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v6 5/8] net/funeth: devlink support
Date:   Sun,  9 Jan 2022 17:56:33 -0800
Message-Id: <20220110015636.245666-6-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220110015636.245666-1-dmichail@fungible.com>
References: <20220110015636.245666-1-dmichail@fungible.com>
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

