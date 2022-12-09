Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDB2647EAD
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiLIHjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiLIHjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:39:08 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3818345090;
        Thu,  8 Dec 2022 23:39:07 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NT2vs60Wnz5BNS0;
        Fri,  9 Dec 2022 15:39:05 +0800 (CST)
Received: from szxlzmapp04.zte.com.cn ([10.5.231.166])
        by mse-fl2.zte.com.cn with SMTP id 2B97cv5J009991;
        Fri, 9 Dec 2022 15:38:57 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp04[null])
        by mapi (Zmail) with MAPI id mid14;
        Fri, 9 Dec 2022 15:38:59 +0800 (CST)
Date:   Fri, 9 Dec 2022 15:38:59 +0800 (CST)
X-Zmail-TransId: 2b066392e613190d3cc0
X-Mailer: Zmail v1.0
Message-ID: <202212091538591375035@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <salil.mehta@huawei.com>
Cc:     <yisen.zhuang@huawei.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <brianvv@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0XSBuZXQ6IGhuczM6IHVzZSBzdHJzY3B5KCkgdG8gaW5zdGVhZCBvZiBzdHJuY3B5KCk=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2B97cv5J009991
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 6392E619.002 by FangMail milter!
X-FangMail-Envelope: 1670571545/4NT2vs60Wnz5BNS0/6392E619.002/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6392E619.002/4NT2vs60Wnz5BNS0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
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
 - change the subject, replace linux-next with net-next.
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index cdf76fb58d45..55306fe8a540 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -639,13 +639,11 @@ static void hns3_get_drvinfo(struct net_device *netdev,
 		return;
 	}

-	strncpy(drvinfo->driver, dev_driver_string(&h->pdev->dev),
+	strscpy(drvinfo->driver, dev_driver_string(&h->pdev->dev),
 		sizeof(drvinfo->driver));
-	drvinfo->driver[sizeof(drvinfo->driver) - 1] = '\0';

-	strncpy(drvinfo->bus_info, pci_name(h->pdev),
+	strscpy(drvinfo->bus_info, pci_name(h->pdev),
 		sizeof(drvinfo->bus_info));
-	drvinfo->bus_info[ETHTOOL_BUSINFO_LEN - 1] = '\0';

 	fw_version = priv->ae_handle->ae_algo->ops->get_fw_version(h);

-- 
2.15.2
