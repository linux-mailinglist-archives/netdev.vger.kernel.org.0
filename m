Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8F8514068
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354102AbiD2CAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 22:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbiD2CAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 22:00:16 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454B6BF51D
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 18:56:57 -0700 (PDT)
X-QQ-mid: bizesmtp62t1651197407tc0g5311
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 29 Apr 2022 09:56:41 +0800 (CST)
X-QQ-SSF: 01400000000000E0M000000A0000000
X-QQ-FEAT: RUa2qNdlQy9gFLfsF33WW446EZUtx6dfowP/F7KcjhQyvOoiWiQcE9hUBCHLR
        UUYdI/rq8v4KImt3IGVHMav3cWM0Obywaj/NMo+3zg+4SwnZDaAiD9oCKAkGfK5Vz5UK9fC
        Naf6gMWSjsA+hNHccfugoAO2CN/RIJY9RShv0GGZ62CGXUlKqOG5RTHObLgKhDv6NLZb8uX
        lJTtnsvxR8hJpzuBKfIkej/cFQ7MuaKYO/lUQfNCGBUBHCjXA1r1UUh9Xp+wsVjPvWhQJMN
        lIY20AMiC0IymSGJRZzDMLa0OJOUev9IzNuyOTx75L/wDL3Nexc0ih7IgpkPGQJPGQpo1bD
        vnBD7xq3dAQuEmwuLcBvZpZd/0tLg==
X-QQ-GoodBg: 1
From:   Meng Tang <tangmeng@uniontech.com>
To:     krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Meng Tang <tangmeng@uniontech.com>
Subject: [PATCH] NFC: Add error mapping for Directed Advertising DISCOVERY_TEAR_DOWN
Date:   Fri, 29 Apr 2022 09:56:40 +0800
Message-Id: <20220429015640.32537-1-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign3
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a DISCOVERY_TEAR_DOWN occurs. Since the operation is analogous
to conventional connection creation map this to the usual ENOLINK
error.

Signed-off-by: Meng Tang <tangmeng@uniontech.com>
---
 net/nfc/nci/lib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/nfc/nci/lib.c b/net/nfc/nci/lib.c
index 473323f8067b..873854c5d180 100644
--- a/net/nfc/nci/lib.c
+++ b/net/nfc/nci/lib.c
@@ -57,6 +57,9 @@ int nci_to_errno(__u8 code)
 	case NCI_STATUS_NFCEE_INTERFACE_ACTIVATION_FAILED:
 		return -ECONNREFUSED;
 
+	case  NCI_STATUS_DISCOVERY_TEAR_DOWN:
+		return -ENOLINK;
+
 	case NCI_STATUS_RF_TRANSMISSION_ERROR:
 	case NCI_STATUS_NFCEE_TRANSMISSION_ERROR:
 		return -ECOMM;
-- 
2.20.1



