Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2E74871D4
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346090AbiAGEg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346075AbiAGEgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:36:21 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970EEC061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 20:36:21 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso5325486pjb.1
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 20:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=hkCfbewLU9g7vEf/5g1/DXmIfirleKvJehODPnCA91kRw57R8XHKiv18AtEvlEZ0wI
         IjLZeGeT8GNnkadEl5Z7TQROQF97Pc5BD0IOt5tmzKP1ddndj8opaKjD8LF8gDlg+Pk0
         5LDfmVIogBpyorlzJ8JbEm6FfPbOnx4kQEuZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BRKtG2RbWHWlFsCS+MbnnMvR+LS0PYZ6YNNc0vjVZ8U=;
        b=78KdxNblzQn90XBB3S7BhxRPZH8e9sNQytpNHSVzWEX84K+lwACB4KGG3+/iDFFYJ2
         Qo5nuOQlP+Zbd2vUery8VAxxZqMpY0tQ7BRlRrov7pLKWbWnN7z+aF9sxYLmE0gyPwSJ
         fLBG9g3KAxEwma6rCRArW2doqBE/ZsK2xZlRcO0NHf9Ndj95VityyJG9jkX7k1slVbAG
         ip7uXETYOKRLpKTb9AHQ6jo6aSjF8l9JMrd/TsTZU1qIhk1tJ2IhsKNhlPT0Kn5bqy74
         mL0/bZyP8q5WpjfnQTyoy5Y9rm5rzt/JRIrvubIpP+XWBIeYS/YJ/NdEVUxB23tKaAHh
         pIDg==
X-Gm-Message-State: AOAM530dixP/LelC2nwpl90AHInPZ/Gm02EhTppFH73YXDIYGdlTwrxg
        sFdXacASlfvPbBcR4q+wTddL5g==
X-Google-Smtp-Source: ABdhPJynfwmVuTwBVLIcTBd1XxaR7Z6JF6mjtxO4PKdQY89YiAXj1a+YLbUV343pudZT9EnJBLSZfQ==
X-Received: by 2002:a17:902:e5ce:b0:142:780:78db with SMTP id u14-20020a170902e5ce00b00142078078dbmr62200234plf.12.1641530181139;
        Thu, 06 Jan 2022 20:36:21 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id p12sm4297877pfo.95.2022.01.06.20.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 20:36:20 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v5 5/8] net/funeth: devlink support
Date:   Thu,  6 Jan 2022 20:36:09 -0800
Message-Id: <20220107043612.21342-6-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107043612.21342-1-dmichail@fungible.com>
References: <20220107043612.21342-1-dmichail@fungible.com>
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

