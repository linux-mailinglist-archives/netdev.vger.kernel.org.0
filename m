Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D91DCED26
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 01:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfD2XEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 19:04:53 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34892 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729684AbfD2XEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 19:04:52 -0400
Received: by mail-io1-f66.google.com with SMTP id r18so10558139ioh.2
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 16:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iZhAzzypnr5pSmhBAHysbTdoqXf903caMqUB/gjm1Y8=;
        b=uaK1C2v3OZgRylgPHmBEacmIjZswebR/mVNya6jFFs1DfZv1mKa6eTmV5dX/RVRQUf
         FyHzAselME3TB0oGds+3rnfe+5CVyRl94RjotRea5tj7CyzuyCJitaHPzURSuDCHH+nb
         990vLPAsY/YT3uP0dFaUMETByaDXqI1c/waPhV9V/8MklwzGRroI1f8YhWM6oD47R3ho
         PP5QDo1aW9ewNgzuL2sCAryAFtCNwWcuoorSbsMAggy6FmmDnF4LwotcxAboF8MJtqnE
         7nyGOyhF65O5gnyiV/q3ZOVi6I24V1yLA//mjEDhYEJzCHKDhGbGs9BOzHg2y/+g36LV
         36yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iZhAzzypnr5pSmhBAHysbTdoqXf903caMqUB/gjm1Y8=;
        b=VKlnmuBqH6TETkhZldaT0p6qkIIHX6ywI4Ob+yM6clFZy36qd2c1dFVqSh95uyi2yI
         e3Fy3oxacNpLGbW8SCe9P+wG/RiOO4K31txGR9wwD3dFBLuszM47pl/D6Gaa/zZVO5Gd
         mV8MZg4BDXpuBnZuARGWgGax0nCvUp2wA9+4WL5+/OjDq6N4Fs78HJBcCnrRHGgU0Wit
         1jWZXIyzMbvyQ0AYHdw5ibiGBGZM83nE9lLnBFH8eHWI7VNrkHv09ZvsI4R5HUxtsmtz
         OL4HT+wjZCoiU4cmcK52+aPap0rvMo+t9ePjcZg3Z7FJGnr7sp8BunXlJdk/xp71pBKk
         XBDA==
X-Gm-Message-State: APjAAAXvxuIzeLkTLwaIDCy5m/S/leM1v/frv9aklez/tHHlU1dX2sHP
        7T03wKzLGxvEk9keXGpCbVnrdl2kCwQ=
X-Google-Smtp-Source: APXvYqxUlXfvKYYLNxP+ipph/m2qeGksmd4msHRlOaJPacb61YqH5V51jfXq7RYnYGrhHLulDMFOVQ==
X-Received: by 2002:a6b:c842:: with SMTP id y63mr211372iof.304.1556579091271;
        Mon, 29 Apr 2019 16:04:51 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id y62sm340626itg.13.2019.04.29.16.04.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 16:04:50 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v8 net-next 3/8] exthdrs: Add TX parameters
Date:   Mon, 29 Apr 2019 16:04:18 -0700
Message-Id: <1556579063-1367-4-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556579063-1367-1-git-send-email-tom@quantonium.net>
References: <1556579063-1367-1-git-send-email-tom@quantonium.net>
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

