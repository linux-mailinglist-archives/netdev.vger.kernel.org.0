Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D679454C033
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 05:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242205AbiFODad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 23:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242080AbiFODab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 23:30:31 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F176F4D26B
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 20:30:26 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id y13-20020a17090a154d00b001eaaa3b9b8dso814320pja.2
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 20:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=doTnAF4XQIaQ0b+nXJ4X8Rr+Aa3su899V8VQarkvoZ0=;
        b=WbMTJnn0QXbgDh8N6WitFhXsUIfrb4fMexM5glOTUQp4qEVXL44fe6rTpvkw6UM5Lq
         yUz+uElPycOBY2q55n8UwEHe5vBLr2xro4ifdt7unFKat81DbaEycJMx8rdbUweEZscb
         z745dPtxU/kxPy0nAtqFLQDcMgSSA7fbmN4viYTkwH41sK8hLR0Z6r3MYFanVpu8djkV
         YBYYAgXe18qB4SyxlS/kx36KDqdxrqL0FJskfoX3IWosHh9Iu6rISzb7lXiyYz7IkVvj
         NOQnIvSwWD3fZjUQn9BA+CNQzzgVHZZuSMWo9u/Gx3tgNp+XzUs3UhsQuXOqOrMX7Pix
         um6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=doTnAF4XQIaQ0b+nXJ4X8Rr+Aa3su899V8VQarkvoZ0=;
        b=hIqvJUvYT6+crIISC1sMQMQyrJ+ublNpwOS1MDVijIVHrlkf6V0N8o6G19ffxQfCBt
         UQpV1spL/eKYJ21xWRVbDeDkEJBN4LQIAMVqXAr29qCjFVu2S8HHfPF/88IJMD6T8zeQ
         Hc27sJL3t4/FoeaCaoxL8BiXQ8fnBXsjJ6eMwa7HcJ9MBvWKBYJr/xmo6+/Q3MSUhOQc
         mXAtpExUDPeh9TnNfl6bpK+fGQeOpWs2+Gbz09n4tLlZFHy7mpOQwsV3hWnZdmBjIMDp
         Ex3SyD5OCC6MF58CBey1BPKGcEKVGtl/mtwQALnciL+9gQ3r3LGhS+We9AtZFaSycQtT
         i6cA==
X-Gm-Message-State: AJIora/lDJSb3dXOJZFUnLcawBKCBFMdwjLWwrD+1tt/SSWLMcVdcbSb
        98ldIZ/l7I8eh+2BZWbSUVkP/C9ILkw=
X-Google-Smtp-Source: AGRyM1uF/6nHjmiO4cdI0n79ZD1eI7XhcdEKATNxQi5wE3HC+nzS8rJ8cqU9oQsQ0DWktyea2JL8lg==
X-Received: by 2002:a17:90b:1b0d:b0:1e6:847e:6448 with SMTP id nu13-20020a17090b1b0d00b001e6847e6448mr7766689pjb.125.1655263826279;
        Tue, 14 Jun 2022 20:30:26 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a21-20020a62d415000000b0051bd72bb2e6sm8358881pfh.197.2022.06.14.20.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 20:30:25 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 iproute2-next] iplink: bond_slave: add per port prio support
Date:   Wed, 15 Jun 2022 11:30:15 +0800
Message-Id: <20220615033015.2057178-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615032934.2057120-1-liuhangbin@gmail.com>
References: <20220615032934.2057120-1-liuhangbin@gmail.com>
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

Add per port priority support for active slave re-selection during
bonding failover. A higher number means higher priority.

This option is only valid for active-backup(1), balance-tlb (5) and
balance-alb (6) mode.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: update man page
---
 ip/iplink_bond_slave.c | 12 +++++++++++-
 man/man8/ip-link.8.in  |  8 ++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/ip/iplink_bond_slave.c b/ip/iplink_bond_slave.c
index d488aaab..8103704b 100644
--- a/ip/iplink_bond_slave.c
+++ b/ip/iplink_bond_slave.c
@@ -19,7 +19,7 @@
 
 static void print_explain(FILE *f)
 {
-	fprintf(f, "Usage: ... bond_slave [ queue_id ID ]\n");
+	fprintf(f, "Usage: ... bond_slave [ queue_id ID ] [ prio PRIORITY ]\n");
 }
 
 static void explain(void)
@@ -120,6 +120,10 @@ static void bond_slave_print_opt(struct link_util *lu, FILE *f, struct rtattr *t
 			  "queue_id %d ",
 			  rta_getattr_u16(tb[IFLA_BOND_SLAVE_QUEUE_ID]));
 
+	if (tb[IFLA_BOND_SLAVE_PRIO])
+		print_int(PRINT_ANY, "prio", "prio %d ",
+			  rta_getattr_s32(tb[IFLA_BOND_SLAVE_PRIO]));
+
 	if (tb[IFLA_BOND_SLAVE_AD_AGGREGATOR_ID])
 		print_int(PRINT_ANY,
 			  "ad_aggregator_id",
@@ -151,6 +155,7 @@ static int bond_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 				struct nlmsghdr *n)
 {
 	__u16 queue_id;
+	int prio;
 
 	while (argc > 0) {
 		if (matches(*argv, "queue_id") == 0) {
@@ -158,6 +163,11 @@ static int bond_slave_parse_opt(struct link_util *lu, int argc, char **argv,
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
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 6f332645..3dbcdbb6 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -2567,6 +2567,8 @@ the following additional arguments are supported:
 .B "ip link set type bond_slave"
 [
 .BI queue_id " ID"
+] [
+.BI prio " PRIORITY"
 ]
 
 .in +8
@@ -2574,6 +2576,12 @@ the following additional arguments are supported:
 .BI queue_id " ID"
 - set the slave's queue ID (a 16bit unsigned value).
 
+.sp
+.BI prio " PRIORITY"
+- set the slave's priority for active slave re-selection during failover
+(a 32bit signed value). This option only valid for active-backup(1),
+balance-tlb (5) and balance-alb (6) mode.
+
 .in -8
 
 .TP
-- 
2.35.1

