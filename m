Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20383628FCA
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 03:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiKOCOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 21:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiKOCOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 21:14:31 -0500
Received: from mail.nfschina.com (unknown [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B6536437;
        Mon, 14 Nov 2022 18:14:30 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 593011E80DAD;
        Tue, 15 Nov 2022 10:11:32 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tE6_o7KRDhP3; Tue, 15 Nov 2022 10:11:29 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zeming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 6B0961E80DAC;
        Tue, 15 Nov 2022 10:11:29 +0800 (CST)
From:   Li zeming <zeming@nfschina.com>
To:     jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li zeming <zeming@nfschina.com>
Subject: [PATCH] ax25: af_ax25: Remove unnecessary (void*) conversions
Date:   Tue, 15 Nov 2022 10:14:24 +0800
Message-Id: <20221115021424.3367-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The valptr pointer is of (void *) type, so other pointers need not be
forced to assign values to it.

Signed-off-by: Li zeming <zeming@nfschina.com>
---
 net/ax25/af_ax25.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 6b4c25a92377..d8da400cb4de 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -723,7 +723,7 @@ static int ax25_getsockopt(struct socket *sock, int level, int optname,
 	if (maxlen < 1)
 		return -EFAULT;
 
-	valptr = (void *) &val;
+	valptr = &val;
 	length = min_t(unsigned int, maxlen, sizeof(int));
 
 	lock_sock(sk);
@@ -785,7 +785,7 @@ static int ax25_getsockopt(struct socket *sock, int level, int optname,
 			length = 1;
 		}
 
-		valptr = (void *) devname;
+		valptr = devname;
 		break;
 
 	default:
-- 
2.18.2

