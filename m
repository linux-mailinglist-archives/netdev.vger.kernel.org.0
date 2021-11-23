Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A500545AD26
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 21:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240259AbhKWURl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 15:17:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239466AbhKWURk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 15:17:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637698471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+zh0Aqq3sqwl6izl6X4VNrnfbw5s+66sYTta5y0ASmM=;
        b=AtMbWCjdNIGqptXkCGF0OGm6+lEyuWwNjwzan4xxvkLc4oJPQWj7Efl7fYT4j2rUoVHIj7
        0k9fS3AouBZ3XBsWwzdtTvT29YroD1dlOIwJuYkqaXQ8bDdV0lz/R1NdjhZedXGkhoEpji
        PDSDSD2vdQX6kSCJAYxX70NKQjFaO40=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-415-16Th40i7NHOmsPy89vReUw-1; Tue, 23 Nov 2021 15:14:30 -0500
X-MC-Unique: 16Th40i7NHOmsPy89vReUw-1
Received: by mail-ed1-f70.google.com with SMTP id r16-20020a056402019000b003e6cbb77ed2so8025edv.10
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 12:14:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+zh0Aqq3sqwl6izl6X4VNrnfbw5s+66sYTta5y0ASmM=;
        b=Hhxp2TS1h+5+D7e86KVWOfDwdCQ7yRqdq1LHYBykeCoZXta8qYsQAUtNVUm3MIKsup
         68sgenJZ5Gws6srsCqFpJLgupJqKLPIKkQilPlUkqPIR55N7wxcao62haUkzrFnj2aWz
         GETtxu+eL/E6GyCzy4VHP6+rzpg2t17+XQTgEki+T8XeTIJb+YmHvXaqU/H/Gj+e0+X6
         LHtNDGTgCBiwfEQHUy/bl40q+GY680RXCLJ33RqQ4b0f1Dl8Vay+oSLisAnlF3UFCFp9
         d4t8tuEpYFT+l97Mqdnacw1o1uOXVlHrOHWyyPeu4dta9ZUpwtHqSWGC+NEL9bbI9GLo
         qgdg==
X-Gm-Message-State: AOAM531phtAxhPYhhreH53tDZGgZmhZ5kVQsGXMMD5gBzXVmsfzL2huX
        1G2DIeVwFxyupDKegv5Zthtm43lU0DKX/F3j3Viyqn73qVhFQj/Hl3ydk4BuemMW8XZpGAjmCeV
        GUJYbDW4oC4HSLsf2
X-Received: by 2002:a05:6402:350b:: with SMTP id b11mr13743918edd.212.1637698468555;
        Tue, 23 Nov 2021 12:14:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx4eE8T+jNhs9zPO2Qxn3W1NWlg8/Hi0IvTAd56u1eRwzt0KYDmqxVPu7BiaAyRC70KY6V7WQ==
X-Received: by 2002:a05:6402:350b:: with SMTP id b11mr13743847edd.212.1637698468164;
        Tue, 23 Nov 2021 12:14:28 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id jg32sm6198604ejc.43.2021.11.23.12.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 12:14:27 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BA99018029C; Tue, 23 Nov 2021 21:14:26 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH iproute2-next] tc: Add support for ce_threshold_value/mask in fq_codel
Date:   Tue, 23 Nov 2021 21:13:27 +0100
Message-Id: <20211123201327.86219-1-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking for subset
of traffic") added support in fq_codel for setting a value and mask that
will be applied to the diffserv/ECN byte to turn on the ce_threshold
feature for a subset of traffic.

This adds support to tc for setting these values. The parameter is
called ce_threshold_selector and takes a value followed by a
slash-separated mask. Some examples:

 # apply ce_threshold to ECT(1) traffic
 tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x1/0x3

 # apply ce_threshold to ECN-capable traffic marked as diffserv AF22
 tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x50/0xfc

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tc/q_fq_codel.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tc/q_fq_codel.c b/tc/q_fq_codel.c
index 300980652243..b7552e294fd0 100644
--- a/tc/q_fq_codel.c
+++ b/tc/q_fq_codel.c
@@ -55,6 +55,7 @@ static void explain(void)
 					"[ target TIME ] [ interval TIME ]\n"
 					"[ quantum BYTES ] [ [no]ecn ]\n"
 					"[ ce_threshold TIME ]\n"
+					"[ ce_threshold_selector VALUE/MASK ]\n"
 					"[ drop_batch SIZE ]\n");
 }
 
@@ -69,6 +70,8 @@ static int fq_codel_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	unsigned int quantum = 0;
 	unsigned int ce_threshold = ~0U;
 	unsigned int memory = ~0U;
+	__u8 ce_threshold_mask = 0;
+	__u8 ce_threshold_selector = 0xFF;
 	int ecn = -1;
 	struct rtattr *tail;
 
@@ -109,6 +112,24 @@ static int fq_codel_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 				fprintf(stderr, "Illegal \"ce_threshold\"\n");
 				return -1;
 			}
+		} else if (strcmp(*argv, "ce_threshold_selector") == 0) {
+			char *sep;
+
+			NEXT_ARG();
+			sep = strchr(*argv, '/');
+			if (!sep) {
+				fprintf(stderr, "Missing mask for \"ce_threshold_selector\"\n");
+				return -1;
+			}
+			*sep++ = '\0';
+			if (get_u8(&ce_threshold_mask, sep, 0)) {
+				fprintf(stderr, "Illegal mask for \"ce_threshold_selector\"\n");
+				return -1;
+			}
+			if (get_u8(&ce_threshold_selector, *argv, 0)) {
+				fprintf(stderr, "Illegal \"ce_threshold_selector\"\n");
+				return -1;
+			}
 		} else if (strcmp(*argv, "memory_limit") == 0) {
 			NEXT_ARG();
 			if (get_size(&memory, *argv)) {
@@ -152,6 +173,10 @@ static int fq_codel_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	if (ce_threshold != ~0U)
 		addattr_l(n, 1024, TCA_FQ_CODEL_CE_THRESHOLD,
 			  &ce_threshold, sizeof(ce_threshold));
+	if (ce_threshold_selector != 0xFF) {
+		addattr8(n, 1024, TCA_FQ_CODEL_CE_THRESHOLD_MASK, ce_threshold_mask);
+		addattr8(n, 1024, TCA_FQ_CODEL_CE_THRESHOLD_SELECTOR, ce_threshold_selector);
+	}
 	if (memory != ~0U)
 		addattr_l(n, 1024, TCA_FQ_CODEL_MEMORY_LIMIT,
 			  &memory, sizeof(memory));
@@ -172,6 +197,8 @@ static int fq_codel_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt
 	unsigned int ecn;
 	unsigned int quantum;
 	unsigned int ce_threshold;
+	__u8 ce_threshold_selector = 0;
+	__u8 ce_threshold_mask = 0;
 	unsigned int memory_limit;
 	unsigned int drop_batch;
 
@@ -211,6 +238,19 @@ static int fq_codel_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt
 		print_string(PRINT_FP, NULL, "ce_threshold %s ",
 			     sprint_time(ce_threshold, b1));
 	}
+	if (tb[TCA_FQ_CODEL_CE_THRESHOLD_SELECTOR] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_CODEL_CE_THRESHOLD_SELECTOR]) >= sizeof(__u8))
+		ce_threshold_selector = rta_getattr_u8(tb[TCA_FQ_CODEL_CE_THRESHOLD_SELECTOR]);
+	if (tb[TCA_FQ_CODEL_CE_THRESHOLD_MASK] &&
+	    RTA_PAYLOAD(tb[TCA_FQ_CODEL_CE_THRESHOLD_MASK]) >= sizeof(__u8))
+		ce_threshold_mask = rta_getattr_u8(tb[TCA_FQ_CODEL_CE_THRESHOLD_MASK]);
+	if (ce_threshold_mask || ce_threshold_selector) {
+		print_hhu(PRINT_ANY, "ce_threshold_selector", "ce_threshold_selector %#x",
+			  ce_threshold_selector);
+		print_hhu(PRINT_ANY, "ce_threshold_mask", "/%#x ",
+			  ce_threshold_mask);
+	}
+
 	if (tb[TCA_FQ_CODEL_INTERVAL] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_CODEL_INTERVAL]) >= sizeof(__u32)) {
 		interval = rta_getattr_u32(tb[TCA_FQ_CODEL_INTERVAL]);
-- 
2.34.0

