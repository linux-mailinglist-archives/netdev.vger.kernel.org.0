Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89841EEEAA
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 02:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgFEAJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 20:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgFEAJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 20:09:21 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCC6C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 17:09:21 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id g7so5137631oti.13
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 17:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wGbGndFSM6zd2fJSWXT0CC8ZG6W0tkE1Bztj0LoETRI=;
        b=l2Mcl+DslLA1ipadM4ebhDv7S5svEgoM/TI1RwDNFtfRjG/MSbCmwUDii1eSFqrk0z
         qZa/s2Gj0SAXjTxHuh1spcCy5vrKSieQtjhuttj8q/MokziUusFWdk6+C8JsEVw3MJIO
         8z0aTrvTqpjJ62IN88NVR9vIOtV9qiQV6A5ylvke/etRsTnPSXtKue0o+9RnHUuNwYkh
         V5vvNRyDP4mQ3t9RubTXiIshILN9cB8tuHYbg7dYlL3oy44rd7tp5FreTGfrjABszfAo
         s0lJgMRpmmiCUlBDFMg6RipvmQKjTyYyIpfR8NvvIWaq8gVk7SPI9OJeeM6AEXChfNaN
         0lZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wGbGndFSM6zd2fJSWXT0CC8ZG6W0tkE1Bztj0LoETRI=;
        b=qzansPO0S2cd4xEw7gX7vMXCzN+yFUENxQf4xRWlG42yIRQsOXhDsFKblWUtdP7jLY
         rSlgORkpqo5hv9YPsQ5ZIV46/jDdqb5LQ6Q56ngxBrWXW2ezuogZe7aAzlaIW4TPcjd0
         T5dMmkrsg5JUQzEQwYJUYPIhYoUUj4PvQTSxUIiuHH9MlvwmZqit/nxrg6XDeY2OMu3d
         pqy20wqadUe4stEgcqnxt9EU+lVSomYURKHgu6wwgb/7Jsx7fswMQphhN8X11776Ehsj
         zHunKdlNzJ/PB+S881zbJQ+I5mKBOa3X37zOThO8YZJuYVpo+SYYtThXxnQvIJ+BMzXs
         +XFw==
X-Gm-Message-State: AOAM532nUaC2oqUY8J6tE7lbPyJfFAklygejct5rbqFRC/NIMgT+y7jl
        h16QmU4i5UliDp85kAgrEVCDJZRcFdI=
X-Google-Smtp-Source: ABdhPJyK7lN6AuojKEiejEUfK00X23RwAKSVdJWx9YtCnLWixpG/Rb0oO3oc16zkHtGraQfOsRCelw==
X-Received: by 2002:a9d:7087:: with SMTP id l7mr5505024otj.271.1591315760243;
        Thu, 04 Jun 2020 17:09:20 -0700 (PDT)
Received: from proxmox.local.lan ([2605:6000:1b0c:4825:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id g10sm1603289otn.34.2020.06.04.17.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 17:09:19 -0700 (PDT)
From:   Tom Seewald <tseewald@gmail.com>
To:     netdev@vger.kernel.org
Cc:     tseewald@gmail.com, Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] cxgb4: Fix 'defined but not used' warning for cxgb4_uld_in_use()
Date:   Thu,  4 Jun 2020 19:07:48 -0500
Message-Id: <20200605000748.31442-1-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only user of cxgb4_uld_in_use() is cxgb4_set_ktls_feature() which is
only available when CONFIG_CHELSIO_TLS_DEVICE=y. To avoid this compiler
warning when CONFIG_CHELSIO_TLS_DEVICE=n, place cxgb4_uld_in_use() behind
the same ifdef.

Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 0307e9c69a47..ac6c06cfd9be 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -663,6 +663,11 @@ static int uld_attach(struct adapter *adap, unsigned int uld)
 	return 0;
 }
 
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+/* cxgb4_set_ktls_feature: request FW to enable/disable ktls settings.
+ * @adap: adapter info
+ * @enable: 1 to enable / 0 to disable ktls settings.
+ */
 static bool cxgb4_uld_in_use(struct adapter *adap)
 {
 	const struct tid_info *t = &adap->tids;
@@ -670,11 +675,6 @@ static bool cxgb4_uld_in_use(struct adapter *adap)
 	return (atomic_read(&t->conns_in_use) || t->stids_in_use);
 }
 
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
-/* cxgb4_set_ktls_feature: request FW to enable/disable ktls settings.
- * @adap: adapter info
- * @enable: 1 to enable / 0 to disable ktls settings.
- */
 int cxgb4_set_ktls_feature(struct adapter *adap, bool enable)
 {
 	int ret = 0;
-- 
2.20.1

