Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E212F2CE9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 11:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391676AbhALKc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 05:32:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729786AbhALKc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 05:32:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610447459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=bZX7T/GcITpvaqudzgsvakBtyTR9G2iobjByWtn7UhQ=;
        b=VaJQcnYb9JPF+0ZXnF2cuQhJ8vKPAnqikv550bFpiTip+x99USN6PrBqP4FDHGit5NTSTb
        5b4gheemdP0DgakUS/9wNVj1K4462kJabHNiNmXIDRX7B9uVY1yQDkIccFwPbkAZCO4ekv
        XF8zKiQ0jOYlM/77ALovlEOuJ1X52Q0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-MKLXKUYQPYebpQx6RsG9gg-1; Tue, 12 Jan 2021 05:30:57 -0500
X-MC-Unique: MKLXKUYQPYebpQx6RsG9gg-1
Received: by mail-wr1-f71.google.com with SMTP id b8so930232wrv.14
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 02:30:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=bZX7T/GcITpvaqudzgsvakBtyTR9G2iobjByWtn7UhQ=;
        b=BDEOFFCGeAWvoLeJBvW9fluqaEzwwkTQm3p5ThCjQz3QiCbMdqECgxTsjFj96f2eI0
         cIxa2InMyV1raCdGgd804XFLUQ/03IFtO9uNrG5Sf3Xb/kAX6VHBNHxijqSFq0o+fCif
         vrH4bVGuOpW137x6n+1fiPvJp5XoL8EaDsg9tYHRqd/hcjIowVKDslyr0XY3I8CScvTY
         NX+WepjvVIlXVArH+/IFbw2QmaRBTEOoSEvqQSiX8gRrGxCpUky7ncaozfMH2pEqYCzr
         H14otbQ2PQOyTr/etODi0rPLJARRkHp92nQpH/uXfMcKgdqj/bDxpQ/aVvJnMaRI4voy
         fIXQ==
X-Gm-Message-State: AOAM533V2zojX/5KokmLQFBtXuW5sHSCNRPIIFxN6eSfY6Lu39WJUuCG
        gKjYXqewmk52FdfqxAXkqMlIbBzs55n0a4J+Xg03wyYbeZHp9ppK3IP7wgWhK53cXCfeUq0l9l3
        y1fJl7XNXnofMVoOz
X-Received: by 2002:a1c:7c03:: with SMTP id x3mr2930493wmc.17.1610447456314;
        Tue, 12 Jan 2021 02:30:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnRRUKBmFtSwDXie6RaQOmofUAd0MFxvnB44WY3qqegqPZNjbymUECAk3oGmvVeQUAyxNCHA==
X-Received: by 2002:a1c:7c03:: with SMTP id x3mr2930478wmc.17.1610447456144;
        Tue, 12 Jan 2021 02:30:56 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id e15sm3572440wrg.72.2021.01.12.02.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 02:30:55 -0800 (PST)
Date:   Tue, 12 Jan 2021 11:30:53 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 iproute2] tc: flower: fix json output with mpls lse
Message-ID: <d183b144526b1638e4069fdc0c5cbe311a543142.1610445956.git.gnault@redhat.com>
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
v1 -> v2: simple rebase on top of iproute2 tree (v1 was lost in
patchwork).

 tc/f_flower.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 9b278f3c..1fe0ef42 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -2470,7 +2470,7 @@ static void flower_print_u32(const char *name, struct rtattr *attr)
 	print_uint(PRINT_ANY, name, namefrm, rta_getattr_u32(attr));
 }
 
-static void flower_print_mpls_opt_lse(const char *name, struct rtattr *lse)
+static void flower_print_mpls_opt_lse(struct rtattr *lse)
 {
 	struct rtattr *tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX + 1];
 	struct rtattr *attr;
@@ -2487,7 +2487,8 @@ static void flower_print_mpls_opt_lse(const char *name, struct rtattr *lse)
 		     RTA_PAYLOAD(lse));
 
 	print_nl();
-	open_json_array(PRINT_ANY, name);
+	print_string(PRINT_FP, NULL, "    lse", NULL);
+	open_json_object(NULL);
 	attr = tb[TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH];
 	if (attr)
 		print_hhu(PRINT_ANY, "depth", " depth %u",
@@ -2505,10 +2506,10 @@ static void flower_print_mpls_opt_lse(const char *name, struct rtattr *lse)
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
@@ -2517,11 +2518,12 @@ static void flower_print_mpls_opts(const char *name, struct rtattr *attr)
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
@@ -2644,7 +2646,7 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 	flower_print_ip_attr("ip_ttl", tb[TCA_FLOWER_KEY_IP_TTL],
 			    tb[TCA_FLOWER_KEY_IP_TTL_MASK]);
 
-	flower_print_mpls_opts("  mpls", tb[TCA_FLOWER_KEY_MPLS_OPTS]);
+	flower_print_mpls_opts(tb[TCA_FLOWER_KEY_MPLS_OPTS]);
 	flower_print_u32("mpls_label", tb[TCA_FLOWER_KEY_MPLS_LABEL]);
 	flower_print_u8("mpls_tc", tb[TCA_FLOWER_KEY_MPLS_TC]);
 	flower_print_u8("mpls_bos", tb[TCA_FLOWER_KEY_MPLS_BOS]);
-- 
2.21.3

