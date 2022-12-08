Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4070D646F0F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiLHLxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiLHLxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:53:17 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78108C683;
        Thu,  8 Dec 2022 03:52:14 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NSXZN5zWlz4y0vY;
        Thu,  8 Dec 2022 19:52:12 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
        by mse-fl2.zte.com.cn with SMTP id 2B8Bq0sw020241;
        Thu, 8 Dec 2022 19:52:00 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp04[null])
        by mapi (Zmail) with MAPI id mid14;
        Thu, 8 Dec 2022 19:52:03 +0800 (CST)
Date:   Thu, 8 Dec 2022 19:52:03 +0800 (CST)
X-Zmail-TransId: 2b066391cfe33482c21d
X-Mailer: Zmail v1.0
Message-ID: <202212081952034833496@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <christopher.lee@cspi.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHRdIG5ldDogZXRoZXJuZXQ6IHVzZSBzdHJzY3B5KCkgdG8gaW5zdGVhZCBvZiBzdHJuY3B5KCnCoA==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2B8Bq0sw020241
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.13.novalocal with ID 6391CFEC.000 by FangMail milter!
X-FangMail-Envelope: 1670500332/4NSXZN5zWlz4y0vY/6391CFEC.000/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6391CFEC.000/4NSXZN5zWlz4y0vY
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
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 9063e2e22cd5..8073d7a90a26 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -552,8 +552,7 @@ myri10ge_validate_firmware(struct myri10ge_priv *mgp,
 	}

 	/* save firmware version for ethtool */
-	strncpy(mgp->fw_version, hdr->version, sizeof(mgp->fw_version));
-	mgp->fw_version[sizeof(mgp->fw_version) - 1] = '\0';
+	strscpy(mgp->fw_version, hdr->version, sizeof(mgp->fw_version));

 	sscanf(mgp->fw_version, "%d.%d.%d", &mgp->fw_ver_major,
 	       &mgp->fw_ver_minor, &mgp->fw_ver_tiny);
-- 
2.15.2
