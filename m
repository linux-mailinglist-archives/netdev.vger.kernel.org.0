Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E3722CAC3
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 18:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgGXQP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 12:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGXQP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 12:15:26 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E11C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 09:15:26 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a9so5513118pjd.3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 09:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rCKvskBWlKSd9ZLSq+qhNnYRB+661+QDTxozyOU5BKk=;
        b=WaKGEroB7laoR8ac3ZMFZohZEUZvECYVzKuwryj+lpo5rEE0cFCMB/e0/ovuQFudyv
         jffQQJ8OoCUdo5bjCvUonm3P6fjW5yqmukGV8MJ1tyOcHDcrquHF4kdZDyIDgcKk2h6Z
         FScgzhdGjmbSe9II0yE0aI3ejVp9sOU7//e4KezGoCwwvSdjnIFkFhyV+bhvhzmJzMGQ
         VOBVtO9T0SYMt48b63FXJDwborKrZiGHkeKAQ632Qms9pIn4jAm2aSeUJ6EP9SwUNYny
         wocun5hPPqgmZnSPfFjiyLYtyMF3VQPSkVlTfGBXP1+eJGTBzB5ksx5+c/IoB6yMUGNE
         2VwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rCKvskBWlKSd9ZLSq+qhNnYRB+661+QDTxozyOU5BKk=;
        b=uaULVLLNm5uEDr0q2CUASOCNgbMpIcRFqmNsHE5zbwSNqMAkiBULYfp6dCUNmXXe3w
         +tgxtVtDSCxrOue6CDBwCk8yegNhmJjuDYQla/lja/tVZwb99Beqd2JcceIJC3C6/a1i
         FJlXO0eBAeCpNWBtKcnCeYtx0qkUBh6iIgE1qpEWhUWHJKcw1yqpUX8iinkpXaRNypUt
         3lvUTPPE49pQ5bR8d3WJxqPopCFQNSAPjFldRVTbvoPHEABBxj9/gtsF8911ifdbBU5N
         eGT4lReqaTKbyXMIh5dKGOLG1YqaH4qEclgfeY8ZjVs70k1K3X2l4ijdley4qzWNvlYK
         ERoQ==
X-Gm-Message-State: AOAM531hXd4h+1/7KBkh/5fof1JszkU+OQSbJn6KyglW6Sw4Lzc5qQDu
        GA3xnJS86k2korfnnJ6RxaxDuN1qk2JOIQ==
X-Google-Smtp-Source: ABdhPJyBZ+Xg8YfWDTE0iBBlu6J+WbcqsVCvRBXC9gPHfVkVGw8MCC88NVB0Pfxqcvp7Gx4Lf0dIVQ==
X-Received: by 2002:a17:902:c211:: with SMTP id 17mr8751354pll.302.1595607325590;
        Fri, 24 Jul 2020 09:15:25 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 141sm7058333pfw.72.2020.07.24.09.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 09:15:25 -0700 (PDT)
Date:   Fri, 24 Jul 2020 09:15:17 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     George Shuklin <amarao@servers.com>
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@resnulli.us, amarao@servers.com
Subject: [RFT iproute2] iplink_bridge: scale all time values by USER_HZ
Message-ID: <20200724091517.7f5c2c9c@hermes.lan>
In-Reply-To: <869fed82-bb31-589f-bd26-591ccfa976ed@servers.com>
References: <869fed82-bb31-589f-bd26-591ccfa976ed@servers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The bridge portion of ip command was not scaling so the
values were off.

The netlink API's for setting and reading timers all conform
to the kernel standard of scaling the values by USER_HZ (100).

Fixes: 28d84b429e4e ("add bridge master device support")
Fixes: 7f3d55922645 ("iplink: bridge: add support for IFLA_BR_MCAST_MEMBERSHIP_INTVL")
Fixes: 10082a253fb2 ("iplink: bridge: add support for IFLA_BR_MCAST_LAST_MEMBER_INTVL")
Fixes: 1f2244b851dd ("iplink: bridge: add support for IFLA_BR_MCAST_QUERIER_INTVL")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---

Compile tested only.


 ip/iplink_bridge.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index 3e81aa059cb3..48495a08c484 100644
--- a/ip/iplink_bridge.c
+++ b/ip/iplink_bridge.c
@@ -24,6 +24,7 @@
 
 static unsigned int xstats_print_attr;
 static int filter_index;
+static unsigned int hz;
 
 static void print_explain(FILE *f)
 {
@@ -85,19 +86,22 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
 {
 	__u32 val;
 
+	if (!hz)
+		hz = get_user_hz();
+
 	while (argc > 0) {
 		if (matches(*argv, "forward_delay") == 0) {
 			NEXT_ARG();
 			if (get_u32(&val, *argv, 0))
 				invarg("invalid forward_delay", *argv);
 
-			addattr32(n, 1024, IFLA_BR_FORWARD_DELAY, val);
+			addattr32(n, 1024, IFLA_BR_FORWARD_DELAY, val * hz);
 		} else if (matches(*argv, "hello_time") == 0) {
 			NEXT_ARG();
 			if (get_u32(&val, *argv, 0))
 				invarg("invalid hello_time", *argv);
 
-			addattr32(n, 1024, IFLA_BR_HELLO_TIME, val);
+			addattr32(n, 1024, IFLA_BR_HELLO_TIME, val * hz);
 		} else if (matches(*argv, "max_age") == 0) {
 			NEXT_ARG();
 			if (get_u32(&val, *argv, 0))
@@ -109,7 +113,7 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
 			if (get_u32(&val, *argv, 0))
 				invarg("invalid ageing_time", *argv);
 
-			addattr32(n, 1024, IFLA_BR_AGEING_TIME, val);
+			addattr32(n, 1024, IFLA_BR_AGEING_TIME, val * hz);
 		} else if (matches(*argv, "stp_state") == 0) {
 			NEXT_ARG();
 			if (get_u32(&val, *argv, 0))
@@ -266,7 +270,7 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
 				       *argv);
 
 			addattr64(n, 1024, IFLA_BR_MCAST_LAST_MEMBER_INTVL,
-				  mcast_last_member_intvl);
+				  mcast_last_member_intvl * hz);
 		} else if (matches(*argv, "mcast_membership_interval") == 0) {
 			__u64 mcast_membership_intvl;
 
@@ -276,7 +280,7 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
 				       *argv);
 
 			addattr64(n, 1024, IFLA_BR_MCAST_MEMBERSHIP_INTVL,
-				  mcast_membership_intvl);
+				  mcast_membership_intvl * hz);
 		} else if (matches(*argv, "mcast_querier_interval") == 0) {
 			__u64 mcast_querier_intvl;
 
@@ -286,7 +290,7 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
 				       *argv);
 
 			addattr64(n, 1024, IFLA_BR_MCAST_QUERIER_INTVL,
-				  mcast_querier_intvl);
+				  mcast_querier_intvl * hz);
 		} else if (matches(*argv, "mcast_query_interval") == 0) {
 			__u64 mcast_query_intvl;
 
@@ -296,7 +300,7 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
 				       *argv);
 
 			addattr64(n, 1024, IFLA_BR_MCAST_QUERY_INTVL,
-				  mcast_query_intvl);
+				  mcast_query_intvl * hz);
 		} else if (!matches(*argv, "mcast_query_response_interval")) {
 			__u64 mcast_query_resp_intvl;
 
@@ -306,7 +310,7 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
 				       *argv);
 
 			addattr64(n, 1024, IFLA_BR_MCAST_QUERY_RESPONSE_INTVL,
-				  mcast_query_resp_intvl);
+				  mcast_query_resp_intvl * hz);
 		} else if (!matches(*argv, "mcast_startup_query_interval")) {
 			__u64 mcast_startup_query_intvl;
 
@@ -316,7 +320,7 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
 				       *argv);
 
 			addattr64(n, 1024, IFLA_BR_MCAST_STARTUP_QUERY_INTVL,
-				  mcast_startup_query_intvl);
+				  mcast_startup_query_intvl * hz);
 		} else if (matches(*argv, "mcast_stats_enabled") == 0) {
 			__u8 mcast_stats_enabled;
 
@@ -407,29 +411,32 @@ static void bridge_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 	if (!tb)
 		return;
 
+	if (!hz)
+		hz = get_user_hz();
+
 	if (tb[IFLA_BR_FORWARD_DELAY])
 		print_uint(PRINT_ANY,
 			   "forward_delay",
 			   "forward_delay %u ",
-			   rta_getattr_u32(tb[IFLA_BR_FORWARD_DELAY]));
+			   rta_getattr_u32(tb[IFLA_BR_FORWARD_DELAY]) / hz);
 
 	if (tb[IFLA_BR_HELLO_TIME])
 		print_uint(PRINT_ANY,
 			   "hello_time",
 			   "hello_time %u ",
-			   rta_getattr_u32(tb[IFLA_BR_HELLO_TIME]));
+			   rta_getattr_u32(tb[IFLA_BR_HELLO_TIME]) / hz);
 
 	if (tb[IFLA_BR_MAX_AGE])
 		print_uint(PRINT_ANY,
 			   "max_age",
 			   "max_age %u ",
-			   rta_getattr_u32(tb[IFLA_BR_MAX_AGE]));
+			   rta_getattr_u32(tb[IFLA_BR_MAX_AGE]) / hz);
 
 	if (tb[IFLA_BR_AGEING_TIME])
 		print_uint(PRINT_ANY,
 			   "ageing_time",
 			   "ageing_time %u ",
-			   rta_getattr_u32(tb[IFLA_BR_AGEING_TIME]));
+			   rta_getattr_u32(tb[IFLA_BR_AGEING_TIME]) / hz);
 
 	if (tb[IFLA_BR_STP_STATE])
 		print_uint(PRINT_ANY,
@@ -605,37 +612,37 @@ static void bridge_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		print_lluint(PRINT_ANY,
 			     "mcast_last_member_intvl",
 			     "mcast_last_member_interval %llu ",
-			     rta_getattr_u64(tb[IFLA_BR_MCAST_LAST_MEMBER_INTVL]));
+			     rta_getattr_u64(tb[IFLA_BR_MCAST_LAST_MEMBER_INTVL]) / hz);
 
 	if (tb[IFLA_BR_MCAST_MEMBERSHIP_INTVL])
 		print_lluint(PRINT_ANY,
 			     "mcast_membership_intvl",
 			     "mcast_membership_interval %llu ",
-			     rta_getattr_u64(tb[IFLA_BR_MCAST_MEMBERSHIP_INTVL]));
+			     rta_getattr_u64(tb[IFLA_BR_MCAST_MEMBERSHIP_INTVL]) / hz);
 
 	if (tb[IFLA_BR_MCAST_QUERIER_INTVL])
 		print_lluint(PRINT_ANY,
 			     "mcast_querier_intvl",
 			     "mcast_querier_interval %llu ",
-			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERIER_INTVL]));
+			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERIER_INTVL]) / hz);
 
 	if (tb[IFLA_BR_MCAST_QUERY_INTVL])
 		print_lluint(PRINT_ANY,
 			     "mcast_query_intvl",
 			     "mcast_query_interval %llu ",
-			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERY_INTVL]));
+			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERY_INTVL]) / hz);
 
 	if (tb[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL])
 		print_lluint(PRINT_ANY,
 			     "mcast_query_response_intvl",
 			     "mcast_query_response_interval %llu ",
-			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL]));
+			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL]) / hz);
 
 	if (tb[IFLA_BR_MCAST_STARTUP_QUERY_INTVL])
 		print_lluint(PRINT_ANY,
 			     "mcast_startup_query_intvl",
 			     "mcast_startup_query_interval %llu ",
-			     rta_getattr_u64(tb[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]));
+			     rta_getattr_u64(tb[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]) / hz);
 
 	if (tb[IFLA_BR_MCAST_STATS_ENABLED])
 		print_uint(PRINT_ANY,
-- 
2.27.0

