Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D742574F95
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 15:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbiGNNs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 09:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbiGNNs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 09:48:57 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B243BE31;
        Thu, 14 Jul 2022 06:48:55 -0700 (PDT)
Received: from rustam-GF63-Thin-9RCX.intra.ispras.ru (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPS id A0C3140D4004;
        Thu, 14 Jul 2022 13:48:48 +0000 (UTC)
From:   Rustam Subkhankulov <subkhankulov@ispras.ru>
To:     Christian Lamparter <chunkeey@googlemail.com>
Cc:     Rustam Subkhankulov <subkhankulov@ispras.ru>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
Subject: [PATCH v2] p54: add missing parentheses in p54_flush()
Date:   Thu, 14 Jul 2022 16:48:31 +0300
Message-Id: <20220714134831.106004-1-subkhankulov@ispras.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The assignment of the value to the variable total in the loop
condition must be enclosed in additional parentheses, since otherwise,
in accordance with the precedence of the operators, the conjunction
will be performed first, and only then the assignment.

Due to this error, a warning later in the function after the loop may
not occur in the situation when it should.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
Fixes: 0d4171e2153b ("p54: implement flush callback")
---
 drivers/net/wireless/intersil/p54/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
index a3ca6620dc0c..8fa3ec71603e 100644
--- a/drivers/net/wireless/intersil/p54/main.c
+++ b/drivers/net/wireless/intersil/p54/main.c
@@ -682,7 +682,7 @@ static void p54_flush(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
 	 * queues have already been stopped and no new frames can sneak
 	 * up from behind.
 	 */
-	while ((total = p54_flush_count(priv) && i--)) {
+	while ((total = p54_flush_count(priv)) && i--) {
 		/* waste time */
 		msleep(20);
 	}
-- 
2.25.1

