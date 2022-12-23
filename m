Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB143654B28
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 03:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbiLWCh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 21:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLWCh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 21:37:27 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8801F62A;
        Thu, 22 Dec 2022 18:37:26 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NdWYK3cgSz5PkHg;
        Fri, 23 Dec 2022 10:37:25 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
        by mse-fl1.zte.com.cn with SMTP id 2BN2bJbl067460;
        Fri, 23 Dec 2022 10:37:19 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Fri, 23 Dec 2022 10:37:21 +0800 (CST)
Date:   Fri, 23 Dec 2022 10:37:21 +0800 (CST)
X-Zmail-TransId: 2b0463a51461ffffffffe8784f89
X-Mailer: Zmail v1.0
Message-ID: <202212231037210142246@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <aspriel@gmail.com>
Cc:     <franky.lin@broadcom.com>, <hante.meuleman@broadcom.com>,
        <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <sha-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0XSBicmNtODAyMTE6IHVzZSBzdHJzY3B5KCkgdG8gaW5zdGVhZCBvZiBzdHJuY3B5KCk=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2BN2bJbl067460
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 63A51465.000 by FangMail milter!
X-FangMail-Envelope: 1671763045/4NdWYK3cgSz5PkHg/63A51465.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63A51465.000/4NdWYK3cgSz5PkHg
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
That's now the recommended way to copy NUL-terminated strings.

Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c
index b7df576bb84d..66336c87b0d9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c
@@ -584,8 +584,7 @@ struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 		      rxextheadroom, nrxpost, rxoffset, txregbase, rxregbase);

 	/* make a private copy of our callers name */
-	strncpy(di->name, name, MAXNAMEL);
-	di->name[MAXNAMEL - 1] = '\0';
+	strscpy(di->name, name, MAXNAMEL);

 	di->dmadev = core->dma_dev;

-- 
2.15.2
