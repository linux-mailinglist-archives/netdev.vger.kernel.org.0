Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA89960E1C8
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiJZNQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiJZNQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:16:37 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27CC87085;
        Wed, 26 Oct 2022 06:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666790196; x=1698326196;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SZraRyM7DZleVZcuBicugzAwWfORdbPbN+RhQtnWZ+c=;
  b=Yy6Jurd1G+5PuVFvg87d3TfPLMvJuQdJkQs0Qc7iZGYioj30LSxiNHx9
   f5SyReOTX0J+iYi2hN68qgl7Bx87SSJ0p1tLfaFi/5KWDFVtxLuTCmH0T
   502Xm9/xOBX/pjTZu9BZrNI0i+XyOFcS3kRJzfcfFVivANF30rPTg4NTs
   MUty3laK0vfokZguG174gaJg3rq9iCdnWvKU7ORHZbLKGtorOic13thuu
   xy7wREcTF6GDlUSbrD71Dt1lwz2VZYn0kIXVPFGJQ3prUg/lpI2hVsYMM
   mBslZn1740sCAYvrV8XTKA9DpRlqhMdBI+jN0DA+4yqSdKRK084XtbKo3
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661810400"; 
   d="scan'208";a="26988471"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 26 Oct 2022 15:16:31 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 26 Oct 2022 15:16:31 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 26 Oct 2022 15:16:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666790191; x=1698326191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SZraRyM7DZleVZcuBicugzAwWfORdbPbN+RhQtnWZ+c=;
  b=bxJFbnSHUHAVIw6Ud7sc0xIgs2fxUXz60xwsj6VVdyN6zDf6tPCP8NSk
   baon64StCZvSWTltBrb5UtB3HjXaxSJ2gnHgXOdIaX9JcKzxbj1FBHHrM
   GyTJBu1B261V/S979rb6438CiTcaIxEltvXiJXz9GFpaCt6irKEUnGnBo
   QrHEAy0J4VAvlC0oPtDBDY5E37DgtDr8V9/UEUrYzqaWv+Bxsva6EUvp4
   8sp1nJqg778KyuJZvJy27N0TySSwpCMZmX4uvrPtRjkfVanqH+pxTv5wZ
   UWKEnKvyvZQi4FQ921CZbza+eTYiikcH/xcS0cFdqGdH8RWceRYtd3UtX
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661810400"; 
   d="scan'208";a="26988470"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 26 Oct 2022 15:16:31 +0200
Received: from localhost.localdomain (SCHIFFERM-M2.tq-net.de [10.121.49.14])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 7212E280056;
        Wed, 26 Oct 2022 15:16:30 +0200 (CEST)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux@ew.tq-group.com,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [RFC 2/5] wireless: mwifiex: signal firmware readiness using notify-device
Date:   Wed, 26 Oct 2022 15:15:31 +0200
Message-Id: <5d5e1e4b2f4d6c8abc4332f8664f911f26b18878.1666786471.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1666786471.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1666786471.git.matthias.schiffer@ew.tq-group.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 14 ++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index da2e6557e684..92176e90b11e 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -5,6 +5,7 @@
  * Copyright 2011-2020 NXP
  */
 
+#include <linux/notify-device.h>
 #include <linux/suspend.h>
 
 #include "main.h"
@@ -661,6 +662,16 @@ static int _mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	mwifiex_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);
 	mwifiex_dbg(adapter, MSG, "driver_version = %s\n", fmt);
 	adapter->is_up = true;
+
+	adapter->notify_dev = notify_device_create(adapter->dev, "firmware-notifier");
+	if (IS_ERR(adapter->notify_dev)) {
+		/* This error is not fatal */
+		mwifiex_dbg(adapter, ERROR,
+			    "cannot create firmware notify device: %d\n",
+			    PTR_ERR(adapter->notify_dev));
+		adapter->notify_dev = NULL;
+	}
+
 	goto done;
 
 err_add_intf:
@@ -1482,6 +1493,9 @@ static void mwifiex_uninit_sw(struct mwifiex_adapter *adapter)
 		rtnl_unlock();
 	}
 
+	notify_device_destroy(adapter->notify_dev);
+	adapter->notify_dev = NULL;
+
 	wiphy_unregister(adapter->wiphy);
 	wiphy_free(adapter->wiphy);
 	adapter->wiphy = NULL;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 63f861e6b28a..b28e90db3128 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -870,6 +870,7 @@ struct mwifiex_adapter {
 	int winner;
 	struct device *dev;
 	struct wiphy *wiphy;
+	struct device *notify_dev;
 	u8 perm_addr[ETH_ALEN];
 	unsigned long work_flags;
 	u32 fw_release_number;
-- 
2.25.1

