Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06726B3172
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCIWxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 17:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjCIWxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 17:53:41 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0602211C;
        Thu,  9 Mar 2023 14:53:03 -0800 (PST)
Received: from localhost.localdomain (unknown [39.45.15.64])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 2BF716602FA9;
        Thu,  9 Mar 2023 22:52:37 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1678402361;
        bh=UbpO6Jn9dro3cJAuyDklcDJVca+wQ5DOLjgvsxCmB3k=;
        h=From:To:Cc:Subject:Date:From;
        b=ILDHMEFbQoZQA5pFSSPt7XyulkZLitsl0ZKD026XA/PgrT2RXVxK28xdfTgNTvQ9b
         9+oc96wVTputNYxYjZtBGDFS8QWJswZd5TalA8yhvzPHVD+rfyjvH2Lur8eg0+y6yX
         MqFcTGZ7uQmf56FEaDDFPgiC8jRAGdLplPQ3M4GVUq/IU8VLDSbZerQM7KwgWblzIq
         ho2LbFP0xrT1VK43VLlXNiuyVsypjoDicU7OzvS9NhHNY3npU3sQXDpBT5qQAo4lxB
         pmhjKQFe/sWiA+dNyceOvmgYzEk1d+F2h3B7TCVZCBq7Yh4IQehSUQ3Q4R3Cn7txEQ
         6FmYmVLP0crxA==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com, kernel-janitors@vger.kernel.org,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3] qede: remove linux/version.h and linux/compiler.h
Date:   Fri, 10 Mar 2023 03:52:05 +0500
Message-Id: <20230309225206.2473644-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

make versioncheck reports the following:
./drivers/net/ethernet/qlogic/qede/qede.h: 10 linux/version.h not needed.
./drivers/net/ethernet/qlogic/qede/qede_ethtool.c: 7 linux/version.h not needed.

So remove linux/version.h from both of these files. Also remove
linux/compiler.h while at it as it is also not being used.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
Changes since v2:
- Correct subject and check patch application on net-next

Changes since v1:
- Remove linux/compiler.h as well
---
 drivers/net/ethernet/qlogic/qede/qede.h         | 2 --
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index f90dcfe9ee68..f9931ecb7baa 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -6,8 +6,6 @@
 
 #ifndef _QEDE_H_
 #define _QEDE_H_
-#include <linux/compiler.h>
-#include <linux/version.h>
 #include <linux/workqueue.h>
 #include <linux/netdevice.h>
 #include <linux/interrupt.h>
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 8034d812d5a0..374a86b875a3 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -4,7 +4,6 @@
  * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-- 
2.39.2

