Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1547164275A
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiLELTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiLELTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:19:08 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896F117599;
        Mon,  5 Dec 2022 03:19:02 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NQgzT1CFWz5BNRf;
        Mon,  5 Dec 2022 19:19:01 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.40.50])
        by mse-fl2.zte.com.cn with SMTP id 2B5BIrxN064224;
        Mon, 5 Dec 2022 19:18:53 +0800 (+08)
        (envelope-from ye.xingchen@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Mon, 5 Dec 2022 19:18:56 +0800 (CST)
Date:   Mon, 5 Dec 2022 19:18:56 +0800 (CST)
X-Zmail-TransId: 2af9638dd3a0ffffffffe4ece7e0
X-Mailer: Zmail v1.0
Message-ID: <202212051918564721658@zte.com.cn>
Mime-Version: 1.0
From:   <ye.xingchen@zte.com.cn>
To:     <edumazet@google.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <richardbgobert@gmail.com>, <iwienand@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0XSBuZXQ6IGV0aGVybmV0OiB1c2Ugc3lzZnNfZW1pdCgpIHRvIGluc3RlYWQgb2Ygc2NucHJpbnRmKCk=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2B5BIrxN064224
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 638DD3A5.000 by FangMail milter!
X-FangMail-Envelope: 1670239141/4NQgzT1CFWz5BNRf/638DD3A5.000/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<ye.xingchen@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 638DD3A5.000/4NQgzT1CFWz5BNRf
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the
value to be returned to user space.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 net/ethernet/eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index e02daa74e833..2edc8b796a4e 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -398,7 +398,7 @@ EXPORT_SYMBOL(alloc_etherdev_mqs);

 ssize_t sysfs_format_mac(char *buf, const unsigned char *addr, int len)
 {
-	return scnprintf(buf, PAGE_SIZE, "%*phC\n", len, addr);
+	return sysfs_emit(buf, "%*phC\n", len, addr);
 }
 EXPORT_SYMBOL(sysfs_format_mac);

-- 
2.25.1
