Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8394850EF6
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbfFXOsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:48:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44328 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbfFXOsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:48:15 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hfQGE-0004Fe-Bl; Mon, 24 Jun 2019 14:47:58 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] 6lowpan: fix off-by-one comparison of index id with LOWPAN_IPHC_CTX_TABLE_SIZE
Date:   Mon, 24 Jun 2019 15:47:57 +0100
Message-Id: <20190624144757.1285-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The WARN_ON_ONCE check on id is off-by-one, it should be greater or equal
to LOWPAN_IPHC_CTX_TABLE_SIZE and not greater than. Fix this.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/6lowpan/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/6lowpan/debugfs.c b/net/6lowpan/debugfs.c
index 1c140af06d52..a510bed8165b 100644
--- a/net/6lowpan/debugfs.c
+++ b/net/6lowpan/debugfs.c
@@ -170,7 +170,7 @@ static void lowpan_dev_debugfs_ctx_init(struct net_device *dev,
 	struct dentry *root;
 	char buf[32];
 
-	WARN_ON_ONCE(id > LOWPAN_IPHC_CTX_TABLE_SIZE);
+	WARN_ON_ONCE(id >= LOWPAN_IPHC_CTX_TABLE_SIZE);
 
 	sprintf(buf, "%d", id);
 
-- 
2.20.1

