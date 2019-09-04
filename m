Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E2EA78F7
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 04:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfIDCm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 22:42:27 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38674 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727716AbfIDCmR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 22:42:17 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 20EA18269B648DA437B5;
        Wed,  4 Sep 2019 10:42:15 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 10:42:07 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>, <anna.schumaker@netapp.com>,
        <trond.myklebust@hammerspace.com>
CC:     <zhongjiang@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] sunrpc: Use kzfree rather than its implementation.
Date:   Wed, 4 Sep 2019 10:39:11 +0800
Message-ID: <1567564752-6430-3-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1567564752-6430-1-git-send-email-zhongjiang@huawei.com>
References: <1567564752-6430-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kzfree instead of memset() + kfree().

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 net/sunrpc/auth_gss/gss_krb5_keys.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_keys.c b/net/sunrpc/auth_gss/gss_krb5_keys.c
index 550fdf1..3b7f721 100644
--- a/net/sunrpc/auth_gss/gss_krb5_keys.c
+++ b/net/sunrpc/auth_gss/gss_krb5_keys.c
@@ -228,14 +228,11 @@ u32 krb5_derive_key(const struct gss_krb5_enctype *gk5e,
 	ret = 0;
 
 err_free_raw:
-	memset(rawkey, 0, keybytes);
-	kfree(rawkey);
+	kzfree(rawkey);
 err_free_out:
-	memset(outblockdata, 0, blocksize);
-	kfree(outblockdata);
+	kzfree(outblockdata);
 err_free_in:
-	memset(inblockdata, 0, blocksize);
-	kfree(inblockdata);
+	kzfree(inblockdata);
 err_free_cipher:
 	crypto_free_sync_skcipher(cipher);
 err_return:
-- 
1.7.12.4

