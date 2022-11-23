Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80149634F2C
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbiKWEt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235267AbiKWEty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:49:54 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFE82AC74
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:49:53 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 130so16295324pfu.8
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3QtBMsfY2t6Zs6sJB2qT1rMuYHCLpoFJIJYRFr5JHU0=;
        b=MVUqG/fP4RAaPqERUg6lyip2tYArOcKA3lmeEryBQ0v2bkGfczz5A737JNpQtqy4se
         TPswCeUAZCfOizGJI8AfZrh4uaJTd+YAaSAODYoGjabCtRrnuyI1PbQjl2M4gE/k//9/
         Fs3nTu82tAJLCbKs3awoegI9apSG4l7GYJ95CjfRvOVQ/xOkYXs5TOA8QEOlJAF4bFlR
         Ub+YDJMIdIq3wb2QrwajbIKnGyH3JYNH1zQghGVzzyHAGP/35SKHfctQoS1UryHGw5Cq
         HRRFK+w9yUIPGR/LRr6U4Qrwn2eBzHZTpwO5YaYNwCRHR9OwsE9lXGKI0E0ywyUIrdI+
         aQ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3QtBMsfY2t6Zs6sJB2qT1rMuYHCLpoFJIJYRFr5JHU0=;
        b=eMMe+rCHHeD3v7OXdKGtVJB6J1ipV50EVmS0dvyPbrvC/OR786naZyAjulomVDKAMV
         ZLVUkUoJmD5P3u7+5cMvA5ONbygOn4nR7yxuKQkjC7IqCSXB2xAeA0Vnr8WXuksTfPJq
         oGcSDoMxNDfU5OvTyJM/SDftSMuQhKhMLGb4oLL3J4h1g4iCkSSnbMjoGFQSGsRjje1M
         1bpwJ7DcBM3lHkNK+SYTj17yre4ZOO/yqr9DavGhzZgM5pwsc8RsRAlRZ3+sLld3Z6ko
         Hs8wHyL7NZdU7t7/9yncAtcvdhoxiyW/7TbYoOv51k80/4RQaXcEVu1JI7ZjQRH9986c
         /DeQ==
X-Gm-Message-State: ANoB5pk5HkNtkLbH5y9Oh2R5LwyqYiqCC8XB8INqvaKhsQFQtw9JzZ7l
        E64MLYb3hlV4Z6V/+zc8bP43pZ/eh4db9cpC
X-Google-Smtp-Source: AA0mqf4gn2bd0cJywrkNQK+S3VOq/0PBbHWfjSfDlFvJLNDJ0IdJ0BD/B2BSd61AjCcrJxnyXP0JtA==
X-Received: by 2002:a62:5281:0:b0:574:329b:19ad with SMTP id g123-20020a625281000000b00574329b19admr3582154pfb.13.1669178992439;
        Tue, 22 Nov 2022 20:49:52 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d65-20020a621d44000000b0056bb6dc882fsm11499862pfd.130.2022.11.22.20.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 20:49:51 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] tc: add json support to size table
Date:   Tue, 22 Nov 2022 20:49:49 -0800
Message-Id: <20221123044949.4785-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the JSON output if size addaption table is used.

Example:
[ {
        "kind": "fq_codel",
        "handle": "1:",
        "dev": "enp2s0",
        "root": true,
        "refcnt": 2,
        "options": {
            "limit": 10240,
            "flows": 1024,
            "quantum": 1514,
            "target": 4999,
            "interval": 99999,
            "memory_limit": 33554432,
            "ecn": true,
            "drop_batch": 64
        },
        "stab": {
            "overhead": 30,
            "mpu": 68,
            "mtu": 2047,
            "tsize": 512
        }
    } ]

Remove fixed prefix arg and no longer needed fp arg.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/tc_common.h |  2 +-
 tc/tc_qdisc.c  |  2 +-
 tc/tc_stab.c   | 22 ++++++++++++++--------
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/tc/tc_common.h b/tc/tc_common.h
index 58dc9d6a6c4f..f1561d80a43b 100644
--- a/tc/tc_common.h
+++ b/tc/tc_common.h
@@ -16,7 +16,7 @@ int print_action(struct nlmsghdr *n, void *arg);
 int print_filter(struct nlmsghdr *n, void *arg);
 int print_qdisc(struct nlmsghdr *n, void *arg);
 int print_class(struct nlmsghdr *n, void *arg);
-void print_size_table(FILE *fp, const char *prefix, struct rtattr *rta);
+void print_size_table(struct rtattr *rta);
 
 struct tc_estimator;
 int parse_estimator(int *p_argc, char ***p_argv, struct tc_estimator *est);
diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index b79029d96202..33a6665eaac0 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -329,7 +329,7 @@ int print_qdisc(struct nlmsghdr *n, void *arg)
 	print_nl();
 
 	if (show_details && tb[TCA_STAB]) {
-		print_size_table(fp, " ", tb[TCA_STAB]);
+		print_size_table(tb[TCA_STAB]);
 		print_nl();
 	}
 
diff --git a/tc/tc_stab.c b/tc/tc_stab.c
index c61ecfd200ca..06dc1b134d85 100644
--- a/tc/tc_stab.c
+++ b/tc/tc_stab.c
@@ -103,7 +103,7 @@ int parse_size_table(int *argcp, char ***argvp, struct tc_sizespec *sp)
 	return 0;
 }
 
-void print_size_table(FILE *fp, const char *prefix, struct rtattr *rta)
+void print_size_table(struct rtattr *rta)
 {
 	struct rtattr *tb[TCA_STAB_MAX + 1];
 
@@ -117,17 +117,23 @@ void print_size_table(FILE *fp, const char *prefix, struct rtattr *rta)
 		memcpy(&s, RTA_DATA(tb[TCA_STAB_BASE]),
 				MIN(RTA_PAYLOAD(tb[TCA_STAB_BASE]), sizeof(s)));
 
-		fprintf(fp, "%s", prefix);
+		print_string(PRINT_FP, NULL, " ", NULL);
+
 		if (s.linklayer)
-			fprintf(fp, "linklayer %s ",
-					sprint_linklayer(s.linklayer, b1));
+			print_string(PRINT_ANY, "linklayer",
+				     "linklayer %s ",
+				     sprint_linklayer(s.linklayer, b1));
 		if (s.overhead)
-			fprintf(fp, "overhead %d ", s.overhead);
+			print_int(PRINT_ANY, "overhead",
+				  "overhead %d ", s.overhead);
 		if (s.mpu)
-			fprintf(fp, "mpu %u ", s.mpu);
+			print_uint(PRINT_ANY, "mpu",
+				   "mpu %u ", s.mpu);
 		if (s.mtu)
-			fprintf(fp, "mtu %u ", s.mtu);
+			print_uint(PRINT_ANY, "mtu",
+				   "mtu %u ", s.mtu);
 		if (s.tsize)
-			fprintf(fp, "tsize %u ", s.tsize);
+			print_uint(PRINT_ANY, "tsize",
+				   "tsize %u ", s.tsize);
 	}
 }
-- 
2.35.1

