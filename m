Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F84EA6C
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbfD2Squ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:46:50 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40860 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729221AbfD2Sqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 14:46:47 -0400
Received: by mail-io1-f65.google.com with SMTP id m9so3534859iok.7
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 11:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pTc1uJTjMEoGLJbdbwkBVaShnW2jPuN46jy5piF84/Q=;
        b=jhnNjRFG7Puup8KoNHr7rN1ARunQ2DY9fkZmqSp0LC5JQrD605sZqrYRtwXAp4qsJT
         ZuQ5w9Iqhq39Gntcd+pibBsm/tR7EawXItD5Uop77+IUEeCz7WqY66srFyTFc2XMShkx
         OHBZJx+hZjkQ20PQWLnE1UNMojdXH7tI4jwOlpyNnUOYOWqH0z+FqJkhFjaTqkKoG6k7
         l7ht3rmhabp5xtJ9dlDsStuYJp+b2P+6wRQg76aemwT5Eq34YgxwnZ9cKE0rujwJoQ0z
         zmyHjSpSm4och6Jvh5PEHybuYDB5Y5kdRW4WEdYtba8WnsNRV7gEaRopyslLaBhHXKEM
         a/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pTc1uJTjMEoGLJbdbwkBVaShnW2jPuN46jy5piF84/Q=;
        b=a6mI2lfjIYnBdCJDE7gP7BOZMV5YdEbjoB6XrJZ1AElafDzBSqw+cQn5iln85G2BBp
         jgm5ZcGPCGFoweonEz0gvt4jATKqLIsgPz3M6iw0y99nz/Y2uw7Fp3j4AHN6ikRCm78b
         1V+E+xgL7ex7kDrQ9S9HUuMnKo/hbvMIsqOTdlWUWn32WEXnKeZKOUe/2VaZ0iyhA9Nm
         dwLGFXWD1xpawuAQDGfSkOdvgEcq6OwbemP0eM2eL7vu2HzhA2No9GPZu2GqSOwWX/jk
         nHXv/QfS+NG1RmMS9NzNzk5ODsJkIb0oEJHPi/rorGRrqTbxmdQLcUaU10Q/MCCBxbsi
         NjNg==
X-Gm-Message-State: APjAAAUN2b9VeqyGbkWhviNSwuIDuHiSo+J9nVbzy2cmB4bjxxqo7TOg
        eqNKXQkkc/+8F+d4sAcP4sZcz6WgITU=
X-Google-Smtp-Source: APXvYqxQqyo21TpC/v9RceMJ0dzoVyoaWalp2dVQdO25OUtJUlk9rR5QW5pqvVyNRHZkTz5C0pLeew==
X-Received: by 2002:a5d:9d96:: with SMTP id 22mr16457187ion.189.1556563606323;
        Mon, 29 Apr 2019 11:46:46 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id f129sm181645itf.4.2019.04.29.11.46.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 11:46:45 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v7 net-next 4/6] exthdrs: Add TX parameters
Date:   Mon, 29 Apr 2019 11:46:14 -0700
Message-Id: <1556563576-31157-5-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556563576-31157-1-git-send-email-tom@quantonium.net>
References: <1556563576-31157-1-git-send-email-tom@quantonium.net>
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
 net/ipv6/exthdrs_common.c  | 22 +++++++++++++++++-
 net/ipv6/exthdrs_options.c | 57 ++++++++++++++++++++++++++++++++++++++++++----
 5 files changed, 108 insertions(+), 7 deletions(-)

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
index 0d2aa89f..c0ccb0a 100644
--- a/net/ipv6/exthdrs_common.c
+++ b/net/ipv6/exthdrs_common.c
@@ -155,7 +155,18 @@ static void tlv_param_table_release(struct rcu_head *rcu)
 
 /* Default (unset) values for TLV parameters */
 static const struct tlv_proc tlv_default_proc = {
-	.params.rx_class = 0,
+	.params.r.class = 0,
+
+	.params.t.preferred_order = 0,
+	.params.t.admin_perm = IPV6_TLV_PERM_NO_CHECK,
+	.params.t.user_perm = IPV6_TLV_PERM_NONE,
+	.params.t.class = 0,
+	.params.t.align_mult = (4 - 1), /* Default alignment: 4n + 2 */
+	.params.t.align_off = 2,
+	.params.t.min_data_len = 0,
+	.params.t.max_data_len = 255,
+	.params.t.data_len_mult = (1 - 1), /* No default length align */
+	.params.t.data_len_off = 0,
 };
 
 static size_t tlv_param_table_size(unsigned char count)
@@ -374,10 +385,13 @@ int exthdrs_init(struct tlv_param_table *tlv_param_table,
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
@@ -391,6 +405,7 @@ int exthdrs_init(struct tlv_param_table *tlv_param_table,
 
 	for (i = 0; i < num_init_params; i++) {
 		const struct tlv_proc_init *tpi = &tlv_init_params[i];
+		unsigned int order = tpi->proc.params.t.preferred_order;
 		struct tlv_proc *tp = &tpt->procs[i + 1];
 
 		if (WARN_ON(tpi->type < 2)) {
@@ -404,6 +419,11 @@ int exthdrs_init(struct tlv_param_table *tlv_param_table,
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
index eb3ae2a..0c69d7f 100644
--- a/net/ipv6/exthdrs_options.c
+++ b/net/ipv6/exthdrs_options.c
@@ -181,26 +181,75 @@ static const struct tlv_proc_init tlv_init_params[] __initconst = {
 		.type = IPV6_TLV_HAO,
 
 		.proc.ops.func = ipv6_dest_hao,
-		.proc.params.rx_class = IPV6_TLV_CLASS_FLAG_DSTOPT,
+
+		.proc.params.r.class = IPV6_TLV_CLASS_FLAG_DSTOPT,
+
+		.proc.params.t.preferred_order = TLV_PREF_ORDER_HAO,
+		.proc.params.t.admin_perm = IPV6_TLV_PERM_NO_CHECK,
+		.proc.params.t.user_perm = IPV6_TLV_PERM_NONE,
+		.proc.params.t.class = IPV6_TLV_CLASS_FLAG_DSTOPT,
+		.proc.params.t.align_mult = (8 - 1), /* Align to 8n + 6 */
+		.proc.params.t.align_off = 6,
+		.proc.params.t.min_data_len = 16,
+		.proc.params.t.max_data_len = 16,
+		.proc.params.t.data_len_mult = (1 - 1), /* Fixed length */
+		.proc.params.t.data_len_off = 0,
 	},
 #endif
 	{
 		.type = IPV6_TLV_ROUTERALERT,
 
 		.proc.ops.func = ipv6_hop_ra,
-		.proc.params.rx_class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+
+		.proc.params.r.class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+
+		.proc.params.t.preferred_order = TLV_PREF_ORDER_ROUTERALERT,
+		.proc.params.t.admin_perm = IPV6_TLV_PERM_NO_CHECK,
+		.proc.params.t.user_perm = IPV6_TLV_PERM_NONE,
+		.proc.params.t.class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+		.proc.params.t.align_mult = (2 - 1), /* Align to 2n */
+		.proc.params.t.align_off = 0,
+		.proc.params.t.min_data_len = 2,
+		.proc.params.t.max_data_len = 2,
+		.proc.params.t.data_len_mult = (1 - 1), /* Fixed length */
+		.proc.params.t.data_len_off = 0,
+
 	},
 	{
 		.type = IPV6_TLV_JUMBO,
 
 		.proc.ops.func	= ipv6_hop_jumbo,
-		.proc.params.rx_class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+
+		.proc.params.r.class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+
+		.proc.params.t.preferred_order = TLV_PREF_ORDER_JUMBO,
+		.proc.params.t.admin_perm = IPV6_TLV_PERM_NO_CHECK,
+		.proc.params.t.user_perm = IPV6_TLV_PERM_NONE,
+		.proc.params.t.class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+		.proc.params.t.align_mult = (4 - 1), /* Align to 4n + 2 */
+		.proc.params.t.align_off = 2,
+		.proc.params.t.min_data_len = 4,
+		.proc.params.t.max_data_len = 4,
+		.proc.params.t.data_len_mult = (1 - 1), /* Fixed length */
+		.proc.params.t.data_len_off = 0,
 	},
 	{
 		.type = IPV6_TLV_CALIPSO,
 
 		.proc.ops.func = ipv6_hop_calipso,
-		.proc.params.rx_class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+		.proc.params.r.class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+
+		.proc.params.t.preferred_order = TLV_PREF_ORDER_CALIPSO,
+		.proc.params.t.admin_perm = IPV6_TLV_PERM_NO_CHECK,
+		.proc.params.t.user_perm = IPV6_TLV_PERM_NONE,
+		.proc.params.t.class = IPV6_TLV_CLASS_FLAG_HOPOPT,
+		.proc.params.t.align_mult = (4 - 1), /* Align to 4n + 2 */
+		.proc.params.t.align_off = 2,
+		.proc.params.t.min_data_len = 8,
+		.proc.params.t.max_data_len = 252,
+		.proc.params.t.data_len_mult = (4 - 1),
+					/* Length is multiple of 4 */
+		.proc.params.t.data_len_off = 0,
 	},
 };
 
-- 
2.7.4

