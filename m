Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C9AED3C
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 01:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbfD2XQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 19:16:48 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40529 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729024AbfD2XQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 19:16:38 -0400
Received: by mail-io1-f68.google.com with SMTP id m9so4169558iok.7
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 16:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iZhAzzypnr5pSmhBAHysbTdoqXf903caMqUB/gjm1Y8=;
        b=wQWewxzkcr6/FBAvPiu4jEG9aFsEOoiimbD06g+4dq00ulWJ3XvYjozj1j3VT3Cs15
         FxHkt+rgWMARyL89n6URflNslAc4qOWc95SVaaj8QJcmXN3QytFNyrp/zkTjIrognDWQ
         GJaSYWwtf4ClYmvNTafRnFIkXdawQut+esWHUFdiKTYHra2+oXILCzRDlI1fjRkeXD2c
         3ytfgaEtm46ee5pOc198rga9hqpigcooEP/+xnuSe+62H9lnilWFJahFhqLLSWLwTxPD
         dx7qmiqlakjc27H5XdCShooSLAYfogYBAhS1PX7w4ZTouAVRXTkY6fMK1kjvqKmmlmTh
         y0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iZhAzzypnr5pSmhBAHysbTdoqXf903caMqUB/gjm1Y8=;
        b=Rf+c51uT8ZyimROlHEVIJDEH9HxjcXJlRJKCDTckEe35fq1ZJni16yn3TPr06N+TCX
         3AlL5OG7hWnrGmGfqwUAe5gAt6WGttNoW3fwPkEHMv1ferT8f/ZY7bg+ZbkjH3Zb6D6H
         YuxziIwbBMSTRHIIARcBd5m1Y59U0Zn2a5yO6eO4Kpu+m2jvsHGQlfsKqbOjP5AIvl70
         O9D4XdKJN/chvkaBbwiW+miZ3f8KnvldGhlIIFjGeIvIUi3Abp/0yDVfqZj3yCmV1wZO
         IF8ODVr4zJdtmqgwCGO0DPNdAlxFVATHltxzwIeCTPIlqsEKKtdkTAmmK0CYaGvSdQ3x
         WLaA==
X-Gm-Message-State: APjAAAWCkfyS2RM9XIacV/PYN2XYUWwg1pIkZaz7/W5HgJsWO5T/RYvC
        DuFihB6hAzdyvANZxQDG0EwMYg==
X-Google-Smtp-Source: APXvYqw7NUOzhoAnTwKnuEUUBSUYXLF3wzluW9PVyFsbKyt4Ob1zoPi59soKY9fMTSJy70bFwsZJ8g==
X-Received: by 2002:a6b:c8d1:: with SMTP id y200mr9169850iof.225.1556579797371;
        Mon, 29 Apr 2019 16:16:37 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id s7sm8547686ioo.17.2019.04.29.16.16.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 16:16:36 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v9 net-next 4/6] exthdrs: Add TX parameters
Date:   Mon, 29 Apr 2019 16:16:18 -0700
Message-Id: <1556579780-1603-5-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556579780-1603-1-git-send-email-tom@quantonium.net>
References: <1556579780-1603-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define a number of transmit parameters for TLV Parameter table
definitions. These will be used for validating TLVs that are set
on a socket.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/net/ipv6.h         | 26 ++++++++++++++++++++-
 include/uapi/linux/in6.h   |  8 +++++++
 net/ipv6/exthdrs.c         |  2 +-
 net/ipv6/exthdrs_common.c  | 17 ++++++++++++++
 net/ipv6/exthdrs_options.c | 57 ++++++++++++++++++++++++++++++++++++++++++----
 5 files changed, 104 insertions(+), 6 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index bb667ed..4cebc48 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -390,8 +390,26 @@ struct tlv_ops {
 	bool	(*func)(unsigned int class, struct sk_buff *skb, int offset);
 };
 
+struct tlv_rx_params {
+	unsigned char class : 3;
+};
+
+struct tlv_tx_params {
+	unsigned char admin_perm : 2;
+	unsigned char user_perm : 2;
+	unsigned char class : 3;
+	unsigned char align_mult : 4;
+	unsigned char align_off : 4;
+	unsigned char data_len_mult : 4;
+	unsigned char data_len_off : 4;
+	unsigned char min_data_len;
+	unsigned char max_data_len;
+	unsigned char preferred_order;
+};
+
 struct tlv_params {
-	unsigned char rx_class : 3;
+	struct tlv_rx_params r;
+	struct tlv_tx_params t;
 };
 
 struct tlv_proc {
@@ -417,6 +435,12 @@ struct tlv_param_table {
 
 extern struct tlv_param_table ipv6_tlv_param_table;
 
+/* Preferred TLV ordering (placed by increasing order) */
+#define TLV_PREF_ORDER_HAO		10
+#define TLV_PREF_ORDER_ROUTERALERT	20
+#define TLV_PREF_ORDER_JUMBO		30
+#define TLV_PREF_ORDER_CALIPSO		40
+
 int tlv_set_proc(struct tlv_param_table *tlv_param_table,
 		 unsigned char type, const struct tlv_proc *proc);
 int tlv_unset_proc(struct tlv_param_table *tlv_param_table, unsigned char type);
diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
index 8b9ac7f..6a99ee1 100644
--- a/include/uapi/linux/in6.h
+++ b/include/uapi/linux/in6.h
@@ -307,4 +307,12 @@ struct in6_flowlabel_req {
 #define IPV6_TLV_CLASS_ANY_DSTOPT      (IPV6_TLV_CLASS_FLAG_RTRDSTOPT | \
 					IPV6_TLV_CLASS_FLAG_DSTOPT)
 
+/* TLV permissions values */
+enum {
+	IPV6_TLV_PERM_NONE,
+	IPV6_TLV_PERM_WITH_CHECK,
+	IPV6_TLV_PERM_NO_CHECK,
+	IPV6_TLV_PERM_MAX = IPV6_TLV_PERM_NO_CHECK
+};
+
 #endif /* _UAPI_LINUX_IN6_H */
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 71a12a7..92a777f 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -166,7 +166,7 @@ static bool ip6_parse_tlv(unsigned int class, struct sk_buff *skb,
 				goto bad;
 
 			curr = tlv_get_proc(&ipv6_tlv_param_table, nh[off]);
-			if ((curr->params.rx_class & class) && curr->ops.func) {
+			if ((curr->params.r.class & class) && curr->ops.func) {
 				/* Handler will apply additional checks to
 				 * the TLV
 				 */
diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
index 0c0e32d..cda4fb8 100644
--- a/net/ipv6/exthdrs_common.c
+++ b/net/ipv6/exthdrs_common.c
@@ -155,6 +155,14 @@ static void tlv_param_table_release(struct rcu_head *rcu)
 
 /* Default (unset) values for TLV parameters */
 static const struct tlv_proc tlv_default_proc = {
+	.params.t = {
+		.preferred_order = 0,
+		.admin_perm = IPV6_TLV_PERM_NO_CHECK,
+		.user_perm = IPV6_TLV_PERM_NONE,
+		.align_mult = (4 - 1), /* Default alignment: 4n + 2 */
+		.align_off = 2,
+		.max_data_len = 255,
+	},
 };
 
 static size_t tlv_param_table_size(unsigned char count)
@@ -373,10 +381,13 @@ int exthdrs_init(struct tlv_param_table *tlv_param_table,
 		 const struct tlv_proc_init *tlv_init_params,
 		 int num_init_params)
 {
+	unsigned long check_map[BITS_TO_LONGS(256)];
 	struct tlv_param_table_data *tpt;
 	size_t tsize;
 	int i;
 
+	memset(check_map, 0, sizeof(check_map));
+
 	tsize = tlv_param_table_size(num_init_params + 1);
 
 	tpt = kvmalloc(tsize, GFP_KERNEL);
@@ -390,6 +401,7 @@ int exthdrs_init(struct tlv_param_table *tlv_param_table,
 
 	for (i = 0; i < num_init_params; i++) {
 		const struct tlv_proc_init *tpi = &tlv_init_params[i];
+		unsigned int order = tpi->proc.params.t.preferred_order;
 		struct tlv_proc *tp = &tpt->procs[i + 1];
 
 		if (WARN_ON(tpi->type < 2)) {
@@ -403,6 +415,11 @@ int exthdrs_init(struct tlv_param_table *tlv_param_table,
 			return -EINVAL;
 		}
 
+		if (order) {
+			WARN_ON(test_bit(order, check_map));
+			set_bit(order, check_map);
+		}
+
 		*tp = tpi->proc;
 		tpt->entries[tpi->type] = i + 1;
 	}
diff --git a/net/ipv6/exthdrs_options.c b/net/ipv6/exthdrs_options.c
index eb3ae2a..7251229 100644
--- a/net/ipv6/exthdrs_options.c
+++ b/net/ipv6/exthdrs_options.c
@@ -181,26 +181,75 @@ static const struct tlv_proc_init tlv_init_params[] __initconst = {
 		.type = IPV6_TLV_HAO,
 
 		.proc.ops.func = ipv6_dest_hao,
-		.proc.params.rx_class = IPV6_TLV_CLASS_FLAG_DSTOPT,
+
+		.proc.params.r.class = IPV6_TLV_CLASS_FLAG_DSTOPT,
+
+		.proc.params.t = {
+			.preferred_order = TLV_PREF_ORDER_HAO,
+			.admin_perm = IPV6_TLV_PERM_NO_CHECK,
+			.user_perm = IPV6_TLV_PERM_NONE,
+			.class = IPV6_TLV_CLASS_FLAG_DSTOPT,
+			.align_mult = (8 - 1), /* Align to 8n + 6 */
+			.align_off = 6,
+			.min_data_len = 16,
+			.max_data_len = 16,
+		},
 	},
 #endif
 	{
 		.type = IPV6_TLV_ROUTERALERT,
 
 		.proc.ops.func = ipv6_hop_ra,
-		.proc.params.rx_class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+
+		.proc.params.r.class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+
+		.proc.params.t = {
+			.preferred_order = TLV_PREF_ORDER_ROUTERALERT,
+			.admin_perm = IPV6_TLV_PERM_NO_CHECK,
+			.user_perm = IPV6_TLV_PERM_NONE,
+			.class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+			.align_mult = (2 - 1), /* Align to 2n */
+			.min_data_len = 2,
+			.max_data_len = 2,
+		},
+
 	},
 	{
 		.type = IPV6_TLV_JUMBO,
 
 		.proc.ops.func	= ipv6_hop_jumbo,
-		.proc.params.rx_class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+
+		.proc.params.r.class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+
+		.proc.params.t = {
+			.preferred_order = TLV_PREF_ORDER_JUMBO,
+			.admin_perm = IPV6_TLV_PERM_NO_CHECK,
+			.user_perm = IPV6_TLV_PERM_NONE,
+			.class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+			.align_mult = (4 - 1), /* Align to 4n + 2 */
+			.align_off = 2,
+			.min_data_len = 4,
+			.max_data_len = 4,
+		},
 	},
 	{
 		.type = IPV6_TLV_CALIPSO,
 
 		.proc.ops.func = ipv6_hop_calipso,
-		.proc.params.rx_class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+		.proc.params.r.class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+
+		.proc.params.t = {
+			.preferred_order = TLV_PREF_ORDER_CALIPSO,
+			.admin_perm = IPV6_TLV_PERM_NO_CHECK,
+			.user_perm = IPV6_TLV_PERM_NONE,
+			.class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+			.align_mult = (4 - 1), /* Align to 4n + 2 */
+			.align_off = 2,
+			.min_data_len = 8,
+			.max_data_len = 252,
+			.data_len_mult = (4 - 1),
+					/* Length is multiple of 4 */
+		},
 	},
 };
 
-- 
2.7.4

