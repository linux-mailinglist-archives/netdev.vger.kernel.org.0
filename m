Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E796647EA9
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiLIHhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiLIHhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:37:40 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE3B271A;
        Thu,  8 Dec 2022 23:37:37 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NT2t81pcSz8R043;
        Fri,  9 Dec 2022 15:37:36 +0800 (CST)
Received: from szxlzmapp01.zte.com.cn ([10.5.231.85])
        by mse-fl1.zte.com.cn with SMTP id 2B97bRCt037067;
        Fri, 9 Dec 2022 15:37:27 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp04[null])
        by mapi (Zmail) with MAPI id mid14;
        Fri, 9 Dec 2022 15:37:29 +0800 (CST)
Date:   Fri, 9 Dec 2022 15:37:29 +0800 (CST)
X-Zmail-TransId: 2b066392e5b9ffffffffc3dd0771
X-Mailer: Zmail v1.0
Message-ID: <202212091537298224990@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <christopher.lee@cspi.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0IHYyXSBteXJpMTBnZTogdXNlIHN0cnNjcHkoKSB0byBpbnN0ZWFkIG9mIHN0cm5jcHkoKQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2B97bRCt037067
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 6392E5C0.000 by FangMail milter!
X-FangMail-Envelope: 1670571456/4NT2t81pcSz8R043/6392E5C0.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6392E5C0.000/4NT2t81pcSz8R043
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
 - change the subject and prefix, replace linux-next with net-next.
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
