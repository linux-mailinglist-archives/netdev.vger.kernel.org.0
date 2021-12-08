Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A75A46D387
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 13:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhLHMtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 07:49:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54240 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229496AbhLHMtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 07:49:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638967539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=sOKBnKeqcwgBlHhhMzZCXJjFEwrdVPgc9GSS3HkuoeY=;
        b=aKKEXip6EESk018AVyfLkpqpDi4YEQnTd2+bRSJLYeVoo8yrf3bGId78Iswd0BZM642U/B
        DI4C2gKiB6URQGMo+OjO6tchxCBWDOMh/d3RHE8VuKRGESpiMDAYqvenBeqtuFxgKqfzh1
        UDaGq+MAZJCw0vBdBsZcY4TnBdM/Zzw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-sJtmIKRNOa2sF4x3XettuQ-1; Wed, 08 Dec 2021 07:45:38 -0500
X-MC-Unique: sJtmIKRNOa2sF4x3XettuQ-1
Received: by mail-ed1-f69.google.com with SMTP id v22-20020a50a456000000b003e7cbfe3dfeso2017458edb.11
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 04:45:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sOKBnKeqcwgBlHhhMzZCXJjFEwrdVPgc9GSS3HkuoeY=;
        b=MEkT/QQGFdbnliEz/WLSdNrT1L5fn3NT+Cy2hKnEArm2CFeTj5Lt1F/+b537oT8+xw
         FUDai5u8sTScfeHlXk65cHIjPlhO4LhAhMNgPAb22wlR6Mh4lqAhYFYkhup5lwAvIdXM
         KWKQkrtuqW2TuGZAh4VzNhUYV52c5kwx5bvGBmk6FSlu7ie+CTnbtjvkR0sZQQJ2YWAO
         WQYYIfJPmnoobE1eEz4eV1MrfuCLPHoeJjd46QUVc9SLGcydgncqnB8BqmVV7QMcxM+P
         MdAcpDFXj/tcV8uTkhtgP9A1Q+e+lfceTGukOmxjZoug3eIGL7+x8yQNFySFHoBjvQfx
         4frw==
X-Gm-Message-State: AOAM530Y3uoQ14jUa3UsBCc2ScVH+gwrf4X/ydeXrSCxa1RfwxqNgF+R
        u69g6/+hszgvajKcBZeEQb0QmqS7/3y230jhlGWgU0C8gSC87COScjG6Bl+Q1Fetme96uQytpoJ
        eG1zYEhglvSgWIRBZ
X-Received: by 2002:a17:907:608b:: with SMTP id ht11mr6987362ejc.479.1638967536395;
        Wed, 08 Dec 2021 04:45:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyU7yiy4c8IqYivMn+yIXbWjdSkPV8FHj+NhNzyTQ+CaRs/YI6dR8PL3R45iIycnwsxpG1xbw==
X-Received: by 2002:a17:907:608b:: with SMTP id ht11mr6987314ejc.479.1638967535926;
        Wed, 08 Dec 2021 04:45:35 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id gt18sm1458134ejc.88.2021.12.08.04.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 04:45:34 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 21577180441; Wed,  8 Dec 2021 13:45:33 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH iproute2-next v2] tc: Add support for ce_threshold_value/mask in fq_codel
Date:   Wed,  8 Dec 2021 13:45:17 +0100
Message-Id: <20211208124517.10687-1-toke@redhat.com>
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

This adds support to iproute for setting these values. The parameter is
called ce_threshold_selector and takes a value followed by a
slash-separated mask. Some examples:

 # apply ce_threshold to ECT(1) traffic
 tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x1/0x3

 # apply ce_threshold to ECN-capable traffic marked as diffserv AF22
 tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x50/0xfc

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v2:
- Also update man page

 man/man8/tc-fq_codel.8 | 11 +++++++++++
 tc/q_fq_codel.c        | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/man/man8/tc-fq_codel.8 b/man/man8/tc-fq_codel.8
index 7ee6c269ed42..84340fe57498 100644
--- a/man/man8/tc-fq_codel.8
+++ b/man/man8/tc-fq_codel.8
@@ -20,6 +20,8 @@ BYTES ] [
 ] [
 .B ce_threshold
 TIME ] [
+.B ce_threshold_selector
+VALUE/MASK ] [
 .B memory_limit
 BYTES ]
 
@@ -89,6 +91,15 @@ sets a threshold above which all packets are marked with ECN Congestion
 Experienced. This is useful for DCTCP-style congestion control algorithms that
 require marking at very shallow queueing thresholds.
 
+.SS ce_threshold_selector
+sets a filter so that the
+.B ce_threshold
+feature is applied to only a subset of the traffic seen by the qdisc. If set, the MASK value
+will be applied as a bitwise AND to the diffserv/ECN byte of the IP header, and only if the
+result of this masking equals VALUE, will the
+.B ce_threshold
+logic be applied to the packet.
+
 .SH EXAMPLES
 #tc qdisc add   dev eth0 root fq_codel
 .br
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

