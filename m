Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570422DEB86
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 23:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgLRW1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 17:27:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725813AbgLRW1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 17:27:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608330334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=2UEg7rTwvMDl0DHk9Qkqg2wipeCmQ+4GrSnazeVy3F8=;
        b=Oc6FqPQ9MCRBD6OAUJnoL0umyfKWBsWdluDpRAPZfYk5GI6wln1QMbv5F4iUwq+u/ZrvRY
        Lr5MRxSQeIKz4htvWR0ZOkvbt/iLfBbzhfbPrl63LBzfSXUNzvb6Xt7ZrwUtb8QsjOWPPV
        8mGwRX5vD/0j+Dp0yYjEPQNvhB8uHq0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-uapyJqjMMvee-VFPDVjLzw-1; Fri, 18 Dec 2020 17:25:32 -0500
X-MC-Unique: uapyJqjMMvee-VFPDVjLzw-1
Received: by mail-wr1-f71.google.com with SMTP id j5so2074446wro.12
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 14:25:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=2UEg7rTwvMDl0DHk9Qkqg2wipeCmQ+4GrSnazeVy3F8=;
        b=OnypdsTbNfvFeRwIbQxrwK46fAZ9XX2NwbFbec/TVb6HjxcQlE0/8OadB5KlIIFiQv
         z+IabChoo9Zc+75p3gDzk+i7EiNJ1Vm8WXqgqHuPhlK6VMhE+lPM+zNDn+uGMjd7Bfy5
         T2Wt4eVN6sF9c9r7GQ0pRzZo5Zfp54C4l4fMmK/AsmqOAuxKkzZHnu1rA7JnRAwtOPLU
         SwMePV4kU9UrqPFOKslFZRxunO1XIU4fb3BVrGSTHEUwdD1t9HLWY0P7mBeQK3O+gau5
         Ds/u9ljizAr/AZiKEVnXiBbgyQPsbEkcyZx/3a7lGcgVMV/HDRt0FW72Vj8sC+fAveEu
         DQRw==
X-Gm-Message-State: AOAM532dedtlyqsain3tdewNw0e6ol0anY99XPeOCzn9stLHOAePf9Vh
        omklzBoRwbq2WFf49Qu1zPQKXZRArssbuFtcEzY7p5nvocXaAtYAmPRJf+g3+8luDGjU6zA6FNB
        /3DkgqZ2f/xWungLS
X-Received: by 2002:a5d:5387:: with SMTP id d7mr6486784wrv.417.1608330330977;
        Fri, 18 Dec 2020 14:25:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIMyH+EpjTWOnrJtbf5XGW/HHdUDdh+9qR3M/mJ/FOmVxehWTcqhwxP35HTRi14SnYKfqBkA==
X-Received: by 2002:a5d:5387:: with SMTP id d7mr6486775wrv.417.1608330330785;
        Fri, 18 Dec 2020 14:25:30 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id g184sm14217884wma.16.2020.12.18.14.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 14:25:30 -0800 (PST)
Date:   Fri, 18 Dec 2020 23:25:28 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2] tc: flower: fix json output with mpls lse
Message-ID: <1ef12e7d378d5b1dad4f056a2225d5ae9d5326cb.1608330201.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The json output of the TCA_FLOWER_KEY_MPLS_OPTS attribute was invalid.

Example:

  $ tc filter add dev eth0 ingress protocol mpls_uc flower mpls \
      lse depth 1 label 100                                     \
      lse depth 2 label 200

  $ tc -json filter show dev eth0 ingress
    ...{"eth_type":"8847",
        "  mpls":["    lse":["depth":1,"label":100],
                  "    lse":["depth":2,"label":200]]}...

This is invalid as the arrays, introduced by "[", can't contain raw
string:value pairs. Those must be enclosed into "{}" to form valid json
ojects. Also, there are spurious whitespaces before the mpls and lse
strings because of the indentation used for normal output.

Fix this by putting all LSE parameters (depth, label, tc, bos and ttl)
into the same json object. The "mpls" key now directly contains a list
of such objects.

Also, handle strings differently for normal and json output, so that
json strings don't get spurious indentation whitespaces.

Normal output isn't modified.
The json output now looks like:

  $ tc -json filter show dev eth0 ingress
    ...{"eth_type":"8847",
        "mpls":[{"depth":1,"label":100},
                {"depth":2,"label":200}]}...

Fixes: eb09a15c12fb ("tc: flower: support multiple MPLS LSE match")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tc/f_flower.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 00c919fd..27731078 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -2476,7 +2476,7 @@ static void flower_print_u32(const char *name, struct rtattr *attr)
 	print_uint(PRINT_ANY, name, namefrm, rta_getattr_u32(attr));
 }
 
-static void flower_print_mpls_opt_lse(const char *name, struct rtattr *lse)
+static void flower_print_mpls_opt_lse(struct rtattr *lse)
 {
 	struct rtattr *tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1];
 	struct rtattr *attr;
@@ -2493,7 +2493,8 @@ static void flower_print_mpls_opt_lse(const char *name, struct rtattr *lse)
 		     RTA_PAYLOAD(lse));
 
 	print_nl();
-	open_json_array(PRINT_ANY, name);
+	print_string(PRINT_FP, NULL, "    lse", NULL);
+	open_json_object(NULL);
 	attr = tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH];
 	if (attr)
 		print_hhu(PRINT_ANY, "depth", " depth %u",
@@ -2511,10 +2512,10 @@ static void flower_print_mpls_opt_lse(const char *name, struct rtattr *lse)
 	attr = tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL];
 	if (attr)
 		print_hhu(PRINT_ANY, "ttl", " ttl %u", rta_getattr_u8(attr));
-	close_json_array(PRINT_JSON, NULL);
+	close_json_object();
 }
 
-static void flower_print_mpls_opts(const char *name, struct rtattr *attr)
+static void flower_print_mpls_opts(struct rtattr *attr)
 {
 	struct rtattr *lse;
 	int rem;
@@ -2523,11 +2524,12 @@ static void flower_print_mpls_opts(const char *name, struct rtattr *attr)
 		return;
 
 	print_nl();
-	open_json_array(PRINT_ANY, name);
+	print_string(PRINT_FP, NULL, "  mpls", NULL);
+	open_json_array(PRINT_JSON, "mpls");
 	rem = RTA_PAYLOAD(attr);
 	lse = RTA_DATA(attr);
 	while (RTA_OK(lse, rem)) {
-		flower_print_mpls_opt_lse("    lse", lse);
+		flower_print_mpls_opt_lse(lse);
 		lse = RTA_NEXT(lse, rem);
 	};
 	if (rem)
@@ -2650,7 +2652,7 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 	flower_print_ip_attr("ip_ttl", tb[TCA_FLOWER_KEY_IP_TTL],
 			    tb[TCA_FLOWER_KEY_IP_TTL_MASK]);
 
-	flower_print_mpls_opts("  mpls", tb[TCA_FLOWER_KEY_MPLS_OPTS]);
+	flower_print_mpls_opts(tb[TCA_FLOWER_KEY_MPLS_OPTS]);
 	flower_print_u32("mpls_label", tb[TCA_FLOWER_KEY_MPLS_LABEL]);
 	flower_print_u8("mpls_tc", tb[TCA_FLOWER_KEY_MPLS_TC]);
 	flower_print_u8("mpls_bos", tb[TCA_FLOWER_KEY_MPLS_BOS]);
-- 
2.21.3

