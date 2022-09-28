Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19EA55EE1CE
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbiI1Q2Z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 12:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiI1Q2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:28:24 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C424DB69
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:28:22 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-CBpVKG3eNXK8ESUG4JYhDA-1; Wed, 28 Sep 2022 12:28:20 -0400
X-MC-Unique: CBpVKG3eNXK8ESUG4JYhDA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21490857FAC;
        Wed, 28 Sep 2022 16:28:19 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60B4BC50928;
        Wed, 28 Sep 2022 16:28:18 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 10/12] macsec: replace custom checks for IFLA_MACSEC_* flags with NLA_POLICY_MAX
Date:   Wed, 28 Sep 2022 18:27:57 +0200
Message-Id: <89e3d9f99e525491055c14be9e2660b3ff712f17.1664379352.git.sd@queasysnail.net>
In-Reply-To: <cover.1664379352.git.sd@queasysnail.net>
References: <cover.1664379352.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Those are all off/on flags.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 3171a84e6900..81027941bc5b 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3654,12 +3654,12 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_CIPHER_SUITE] = NLA_POLICY_VALIDATE_FN(NLA_U64, validate_cipher_suite),
 	[IFLA_MACSEC_WINDOW] = { .type = NLA_U32 },
 	[IFLA_MACSEC_ENCODING_SA] = { .type = NLA_U8 },
-	[IFLA_MACSEC_ENCRYPT] = { .type = NLA_U8 },
-	[IFLA_MACSEC_PROTECT] = { .type = NLA_U8 },
-	[IFLA_MACSEC_INC_SCI] = { .type = NLA_U8 },
-	[IFLA_MACSEC_ES] = { .type = NLA_U8 },
-	[IFLA_MACSEC_SCB] = { .type = NLA_U8 },
-	[IFLA_MACSEC_REPLAY_PROTECT] = { .type = NLA_U8 },
+	[IFLA_MACSEC_ENCRYPT] = NLA_POLICY_MAX(NLA_U8, 1),
+	[IFLA_MACSEC_PROTECT] = NLA_POLICY_MAX(NLA_U8, 1),
+	[IFLA_MACSEC_INC_SCI] = NLA_POLICY_MAX(NLA_U8, 1),
+	[IFLA_MACSEC_ES] = NLA_POLICY_MAX(NLA_U8, 1),
+	[IFLA_MACSEC_SCB] = NLA_POLICY_MAX(NLA_U8, 1),
+	[IFLA_MACSEC_REPLAY_PROTECT] = NLA_POLICY_MAX(NLA_U8, 1),
 	[IFLA_MACSEC_VALIDATION] = NLA_POLICY_MAX(NLA_U8, MACSEC_VALIDATE_MAX),
 	[IFLA_MACSEC_OFFLOAD] = NLA_POLICY_MAX(NLA_U8, MACSEC_OFFLOAD_MAX),
 };
@@ -4121,7 +4121,6 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 {
 	u64 csid = MACSEC_DEFAULT_CIPHER_ID;
 	u8 icv_len = MACSEC_DEFAULT_ICV_LEN;
-	int flag;
 	bool es, scb, sci;
 
 	if (!data)
@@ -4150,15 +4149,6 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 			return -EINVAL;
 	}
 
-	for (flag = IFLA_MACSEC_ENCODING_SA + 1;
-	     flag < IFLA_MACSEC_VALIDATION;
-	     flag++) {
-		if (data[flag]) {
-			if (nla_get_u8(data[flag]) > 1)
-				return -EINVAL;
-		}
-	}
-
 	es  = data[IFLA_MACSEC_ES] ? nla_get_u8(data[IFLA_MACSEC_ES]) : false;
 	sci = data[IFLA_MACSEC_INC_SCI] ? nla_get_u8(data[IFLA_MACSEC_INC_SCI]) : false;
 	scb = data[IFLA_MACSEC_SCB] ? nla_get_u8(data[IFLA_MACSEC_SCB]) : false;
-- 
2.37.3

