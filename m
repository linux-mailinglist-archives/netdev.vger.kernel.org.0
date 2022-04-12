Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21DE04FCD82
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 06:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345258AbiDLEUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 00:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbiDLEUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 00:20:04 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C741E3F1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 21:17:48 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id z128so16061930pgz.2
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 21:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i8XS5vIuTcAnyfdIHu7m1YLfzmAqgSKYdbBW+1Ul0iI=;
        b=Ag4NENkqfNGzIJHhrp0B0gJFB4YN9MhxKrkGMr1MeVqPH8kFz7/AkOo/oYPKFdLkv8
         9SINyyvqMMgbLS18Wvt46ie0lhrI94k9kHnt3EIBfPY9TPkU+/5eVf5z+6C3g/pIy2w0
         uBg2y+Jwwty5JvZB3XzlwwKEgWzusMhMpCPLk6iVFa4VugIgkg6+wGGbwS+sqODgV52S
         RTju09kAMdgU4Ia447uEpwP//A7WTWlybgMkeJGFkabbNTtmNtL55rcGhGdM2arfjrAc
         uR/VcJXyXs8MYJJQbw3gZoK2lCRZQjB9TSJBSw/IcqfO4mDCb/pHTlP+5fFhPAsS23+S
         KyuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i8XS5vIuTcAnyfdIHu7m1YLfzmAqgSKYdbBW+1Ul0iI=;
        b=OgYjRuXQjbAef9xzHnsH9X4yGWs5oG88GSDkShm+HPxFk1ajVAOq5Lri14UpzT/Wp6
         bXuvD5gqWrPPwRj2EPOh5DybDktGbPIT5atdwfXmy9GfIlnrCIXOOfTaWnEHGOWTQEEA
         Mw9f+/tLMc36+iCW2CuNT3e0DxnhHycrQ20iXgn1SVTXUtbaPuMNku2WRx13sc+ERF3j
         iV4JA85zS97zLHeF+xW/ljIQFSSNrU+/DkefTXeAJVWF+yt2E2PPFQ7+l/gngFQCccYk
         P7R9Mrv/HHwuqYf2+PYYcpWn+Ot0Ea9++BxqPPw0U52QXXkQrGepmj6D94KPrqQECN9e
         tH0A==
X-Gm-Message-State: AOAM533HiMht+lBCkS5+GKKW0BNj/CFauJm1bOjdeNrlqbNTVI998cQs
        Gq35CkXUqlS7/nGfUC/jVNxCItxFbHI=
X-Google-Smtp-Source: ABdhPJz+5R7/IUDy+Uwc1543vDWr1BsXotxEzD3b22d0IYKtUJPT45eCI0SmoTzE67O4ndPIrG960g==
X-Received: by 2002:a65:4188:0:b0:39d:2197:13b5 with SMTP id a8-20020a654188000000b0039d219713b5mr11241791pgq.368.1649737067828;
        Mon, 11 Apr 2022 21:17:47 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f4-20020aa79d84000000b00505f920ffb8sm858745pfq.179.2022.04.11.21.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 21:17:47 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2-next] iplink: bond_slave: add per port prio support
Date:   Tue, 12 Apr 2022 12:17:37 +0800
Message-Id: <20220412041737.2410062-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412041322.2409558-1-liuhangbin@gmail.com>
References: <20220412041322.2409558-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add per port priority support for bonding. A higher number means
higher priority. This option is only valid for active-backup(1),
balance-tlb (5) and balance-alb (6) mode.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 ip/iplink_bond_slave.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/ip/iplink_bond_slave.c b/ip/iplink_bond_slave.c
index d488aaab..7a4d89ff 100644
--- a/ip/iplink_bond_slave.c
+++ b/ip/iplink_bond_slave.c
@@ -19,7 +19,7 @@
 
 static void print_explain(FILE *f)
 {
-	fprintf(f, "Usage: ... bond_slave [ queue_id ID ]\n");
+	fprintf(f, "Usage: ... bond_slave [ queue_id ID ] [ prio PRIORITY ]\n");
 }
 
 static void explain(void)
@@ -120,6 +120,12 @@ static void bond_slave_print_opt(struct link_util *lu, FILE *f, struct rtattr *t
 			  "queue_id %d ",
 			  rta_getattr_u16(tb[IFLA_BOND_SLAVE_QUEUE_ID]));
 
+	if (tb[IFLA_BOND_SLAVE_PRIO])
+		print_int(PRINT_ANY,
+			  "prio",
+			  "prio %d ",
+			  rta_getattr_s32(tb[IFLA_BOND_SLAVE_PRIO]));
+
 	if (tb[IFLA_BOND_SLAVE_AD_AGGREGATOR_ID])
 		print_int(PRINT_ANY,
 			  "ad_aggregator_id",
@@ -151,6 +157,7 @@ static int bond_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 				struct nlmsghdr *n)
 {
 	__u16 queue_id;
+	int prio;
 
 	while (argc > 0) {
 		if (matches(*argv, "queue_id") == 0) {
@@ -158,6 +165,11 @@ static int bond_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 			if (get_u16(&queue_id, *argv, 0))
 				invarg("queue_id is invalid", *argv);
 			addattr16(n, 1024, IFLA_BOND_SLAVE_QUEUE_ID, queue_id);
+		} else if (strcmp(*argv, "prio") == 0) {
+			NEXT_ARG();
+			if (get_s32(&prio, *argv, 0))
+				invarg("prio is invalid", *argv);
+			addattr32(n, 1024, IFLA_BOND_SLAVE_PRIO, prio);
 		} else {
 			if (matches(*argv, "help") != 0)
 				fprintf(stderr,
-- 
2.35.1

