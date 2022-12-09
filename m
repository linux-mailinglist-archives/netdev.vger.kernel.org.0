Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86830647EA1
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiLIHdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiLIHde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:33:34 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028B7DC8;
        Thu,  8 Dec 2022 23:33:31 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NT2nQ36GHz8R039;
        Fri,  9 Dec 2022 15:33:30 +0800 (CST)
Received: from szxlzmapp04.zte.com.cn ([10.5.231.166])
        by mse-fl2.zte.com.cn with SMTP id 2B97XNdM002470;
        Fri, 9 Dec 2022 15:33:23 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp04[null])
        by mapi (Zmail) with MAPI id mid14;
        Fri, 9 Dec 2022 15:33:25 +0800 (CST)
Date:   Fri, 9 Dec 2022 15:33:25 +0800 (CST)
X-Zmail-TransId: 2b066392e4c554cc8088
X-Mailer: Zmail v1.0
Message-ID: <202212091533253334827@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <salil.mehta@huawei.com>
Cc:     <yisen.zhuang@huawei.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <brianvv@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0IHYyXSBobnM6IHVzZSBzdHJzY3B5KCkgdG8gaW5zdGVhZCBvZiBzdHJuY3B5KCk=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2B97XNdM002470
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 6392E4CA.000 by FangMail milter!
X-FangMail-Envelope: 1670571210/4NT2nQ36GHz8R039/6392E4CA.000/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6392E4CA.000/4NT2nQ36GHz8R039
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Panda <xu.panda@zte.com.cn>

The implementation of strscpy() is more robust and safer.
That's now the recommended way to copy NUL terminated strings.

Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com>
---
change for v2
 - change the prefix and subject: replace ethtool with hns,
and replace linux-next with net-next.
---
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index 54faf0f2d1d8..b54f3706fb97 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -644,18 +644,15 @@ static void hns_nic_get_drvinfo(struct net_device *net_dev,
 {
 	struct hns_nic_priv *priv = netdev_priv(net_dev);

-	strncpy(drvinfo->version, HNAE_DRIVER_VERSION,
+	strscpy(drvinfo->version, HNAE_DRIVER_VERSION,
 		sizeof(drvinfo->version));
-	drvinfo->version[sizeof(drvinfo->version) - 1] = '\0';

-	strncpy(drvinfo->driver, HNAE_DRIVER_NAME, sizeof(drvinfo->driver));
-	drvinfo->driver[sizeof(drvinfo->driver) - 1] = '\0';
+	strscpy(drvinfo->driver, HNAE_DRIVER_NAME, sizeof(drvinfo->driver));

-	strncpy(drvinfo->bus_info, priv->dev->bus->name,
+	strscpy(drvinfo->bus_info, priv->dev->bus->name,
 		sizeof(drvinfo->bus_info));
-	drvinfo->bus_info[ETHTOOL_BUSINFO_LEN - 1] = '\0';

-	strncpy(drvinfo->fw_version, "N/A", ETHTOOL_FWVERS_LEN);
+	strscpy(drvinfo->fw_version, "N/A", ETHTOOL_FWVERS_LEN);
 	drvinfo->eedump_len = 0;
 }

-- 
2.15.2
