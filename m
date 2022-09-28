Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AA75EE1E2
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbiI1Q3o convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 12:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234471AbiI1Q3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:29:38 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C66E3684
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:29:30 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-swYBXqOBNhC4AmYlNf0Gbg-1; Wed, 28 Sep 2022 12:29:19 -0400
X-MC-Unique: swYBXqOBNhC4AmYlNf0Gbg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC6441C06EC9;
        Wed, 28 Sep 2022 16:29:18 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 005D4C5092A;
        Wed, 28 Sep 2022 16:29:17 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 12/12] macsec: remove validate_add_rxsc
Date:   Wed, 28 Sep 2022 18:29:03 +0200
Message-Id: <fe35af9629b7202ec8a03afaadd9230db1a14b5e.1664379352.git.sd@queasysnail.net>
In-Reply-To: <cover.1664379352.git.sd@queasysnail.net>
References: <cover.1664379352.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not doing much anymore.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 863e5ae6e75e..4d457b7211e3 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1838,14 +1838,6 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-static bool validate_add_rxsc(struct nlattr **attrs)
-{
-	if (!attrs[MACSEC_RXSC_ATTR_SCI])
-		return false;
-
-	return true;
-}
-
 static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net_device *dev;
@@ -1863,7 +1855,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	if (parse_rxsc_config(attrs, tb_rxsc))
 		return -EINVAL;
 
-	if (!validate_add_rxsc(tb_rxsc))
+	if (!tb_rxsc[MACSEC_RXSC_ATTR_SCI])
 		return -EINVAL;
 
 	rtnl_lock();
@@ -2458,7 +2450,7 @@ static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
 	if (parse_rxsc_config(attrs, tb_rxsc))
 		return -EINVAL;
 
-	if (!validate_add_rxsc(tb_rxsc))
+	if (!tb_rxsc[MACSEC_RXSC_ATTR_SCI])
 		return -EINVAL;
 
 	rtnl_lock();
-- 
2.37.3

