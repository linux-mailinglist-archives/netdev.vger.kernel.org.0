Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C955E72C8
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 06:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiIWEUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 00:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiIWEUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 00:20:14 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361C2AB1A1
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 21:20:13 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id e5so11286079pfl.2
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 21:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=205dLX8y2q2+b6YRDogu2BeRc4V1RfS3f4+K+opL0C8=;
        b=MaLxC07xiQFv1rxLH6K0CYalOwcz/wG/2N093r0Ci0zI3qzixDAKlS1QLIplydd0bZ
         iQjknnwXljao1IWi0JDRba7fIqoESjvFYDU4k2/QusNOU2lkzok4Ec8/3FZyYab+Dlqw
         2Cp1A6ohOHFSuLazRfvoFOMPpaO4fE0J3JVn0npQ4z2o5cDg0lcbm5KmY3AF4WIrVCRN
         2EfkN5CNQECOX8y/OqnE6mQqakI/zUzfF/D9OkpOFOU6WzuiJqx5uEuGm/QNSed1l8xf
         Ul3dRijcuSOyHHIdWl0Lssm3rj0siIFW67VVBqMopmNk9N4cd93alo29p6Ilu0swzMQh
         HigQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=205dLX8y2q2+b6YRDogu2BeRc4V1RfS3f4+K+opL0C8=;
        b=14NbujQY0FEWpCIblXWU+dAqeMcrXCxRjaL7dZjn5Uyu8ay6bxlrxwImruvtNbyYyp
         YRVRzS2dwCt5RupAKVe9xtg+hs64+SPfB1kd39hg+qOcqV439bQ77ibmZAIHDjGnZw3Q
         /6wexvhYybgON97gIjEHC2TqdhlmjCyLBG04ChYqHoHlhoT12/f4TYCy5icmeBZ6KDw4
         9rAOwxbfVY9Am2EqM0Bd/Uzk/h8cfsnt173BDWDGf0VLxDv2xNdajzAGJ0W1fDxhFsV8
         7VEP0xK5NRLTxqozPPTw6tGPYl2Iyzj5gOGnrgWqglq/APDcICRuobOycUsNFqA6VRTs
         z3Cg==
X-Gm-Message-State: ACrzQf39FiG52omHtuH0zle/KRg1IbX+pUGWDPZxd443iYR3cgzTCBrr
        RORKGombn7JEO4JMWiXuAkSIiepqMQ/rBQ==
X-Google-Smtp-Source: AMsMyM5Hdu3/tYno99LGaf8us21Y19suQD6AX9GhGfVlXieu4UaFzauUiOmYgzJ8vKQ0rcugxQUvwg==
X-Received: by 2002:a63:ff4f:0:b0:439:61d6:197 with SMTP id s15-20020a63ff4f000000b0043961d60197mr5867993pgk.67.1663906812502;
        Thu, 22 Sep 2022 21:20:12 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d185-20020a621dc2000000b00540b979c493sm5144787pfd.55.2022.09.22.21.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 21:20:12 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2-next] rtnetlink: add new function rtnl_echo_talk()
Date:   Fri, 23 Sep 2022 12:20:00 +0800
Message-Id: <20220923042000.602250-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new function rtnl_echo_talk() that could be used when the
sub-component supports NLM_F_ECHO flag. With this function we can
remove the redundant code added by commit b264b4c6568c7 ("ip: add
NLM_F_ECHO support").

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/libnetlink.h |  4 ++++
 include/utils.h      |  1 -
 ip/ipaddress.c       | 24 +-----------------------
 ip/iplink.c          | 20 +-------------------
 ip/ipnexthop.c       | 23 +----------------------
 ip/iproute.c         | 24 +-----------------------
 ip/iprule.c          | 24 +-----------------------
 lib/libnetlink.c     | 31 +++++++++++++++++++++++++++++++
 8 files changed, 40 insertions(+), 111 deletions(-)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index a7b0f352..e9125f04 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -44,6 +44,7 @@ struct ipstats_req {
 };
 
 extern int rcvbuf;
+extern int echo_request;
 
 int rtnl_open(struct rtnl_handle *rth, unsigned int subscriptions)
 	__attribute__((warn_unused_result));
@@ -171,6 +172,9 @@ int rtnl_dump_filter_errhndlr_nc(struct rtnl_handle *rth,
 #define rtnl_dump_filter_errhndlr(rth, filter, farg, errhndlr, earg) \
 	rtnl_dump_filter_errhndlr_nc(rth, filter, farg, errhndlr, earg, 0)
 
+int rtnl_echo_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
+		   int (*print_info)(struct nlmsghdr *n, void *arg))
+	__attribute__((warn_unused_result));
 int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
 	      struct nlmsghdr **answer)
 	__attribute__((warn_unused_result));
diff --git a/include/utils.h b/include/utils.h
index 2eb80b3e..eeb23a64 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -36,7 +36,6 @@ extern int max_flush_loops;
 extern int batch_mode;
 extern int numeric;
 extern bool do_all;
-extern int echo_request;
 
 #ifndef CONFDIR
 #define CONFDIR		"/etc/iproute2"
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 986cfbc3..89acfeaa 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -2422,11 +2422,6 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 	__u32 preferred_lft = INFINITY_LIFE_TIME;
 	__u32 valid_lft = INFINITY_LIFE_TIME;
 	unsigned int ifa_flags = 0;
-	struct nlmsghdr *answer;
-	int ret;
-
-	if (echo_request)
-		req.n.nlmsg_flags |= NLM_F_ECHO | NLM_F_ACK;
 
 	while (argc > 0) {
 		if (strcmp(*argv, "peer") == 0 ||
@@ -2608,24 +2603,7 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 		return -1;
 	}
 
-	if (echo_request)
-		ret = rtnl_talk(&rth, &req.n, &answer);
-	else
-		ret = rtnl_talk(&rth, &req.n, NULL);
-
-	if (ret < 0)
-		return -2;
-
-	if (echo_request) {
-		new_json_obj(json);
-		open_json_object(NULL);
-		print_addrinfo(answer, stdout);
-		close_json_object();
-		delete_json_obj();
-		free(answer);
-	}
-
-	return 0;
+	return rtnl_echo_talk(&rth, &req.n, print_addrinfo);
 }
 
 int do_ipaddr(int argc, char **argv)
diff --git a/ip/iplink.c b/ip/iplink.c
index ad22f2d7..2b8602e4 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1073,16 +1073,12 @@ static int iplink_modify(int cmd, unsigned int flags, int argc, char **argv)
 		.n.nlmsg_type = cmd,
 		.i.ifi_family = preferred_family,
 	};
-	struct nlmsghdr *answer;
 	int ret;
 
 	ret = iplink_parse(argc, argv, &req, &type);
 	if (ret < 0)
 		return ret;
 
-	if (echo_request)
-		req.n.nlmsg_flags |= NLM_F_ECHO | NLM_F_ACK;
-
 	if (type) {
 		struct link_util *lu;
 		struct rtattr *linkinfo;
@@ -1127,23 +1123,9 @@ static int iplink_modify(int cmd, unsigned int flags, int argc, char **argv)
 		return -1;
 	}
 
-	if (echo_request)
-		ret = rtnl_talk(&rth, &req.n, &answer);
-	else
-		ret = rtnl_talk(&rth, &req.n, NULL);
-
-	if (ret < 0)
+	if(rtnl_echo_talk(&rth, &req.n, print_linkinfo) < 0)
 		return -2;
 
-	if (echo_request) {
-		new_json_obj(json);
-		open_json_object(NULL);
-		print_linkinfo(answer, stdout);
-		close_json_object();
-		delete_json_obj();
-		free(answer);
-	}
-
 	/* remove device from cache; next use can refresh with new data */
 	ll_drop_by_index(req.i.ifi_index);
 
diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 59f8f2fb..6da44414 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -921,10 +921,6 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 	};
 	struct nlmsghdr *answer;
 	__u32 nh_flags = 0;
-	int ret;
-
-	if (echo_request)
-		req.n.nlmsg_flags |= NLM_F_ECHO | NLM_F_ACK;
 
 	while (argc > 0) {
 		if (!strcmp(*argv, "id")) {
@@ -1004,24 +1000,7 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 
 	req.nhm.nh_flags = nh_flags;
 
-	if (echo_request)
-		ret = rtnl_talk(&rth, &req.n, &answer);
-	else
-		ret = rtnl_talk(&rth, &req.n, NULL);
-
-	if (ret < 0)
-		return -2;
-
-	if (echo_request) {
-		new_json_obj(json);
-		open_json_object(NULL);
-		print_nexthop_nocache(answer, (void *)stdout);
-		close_json_object();
-		delete_json_obj();
-		free(answer);
-	}
-
-	return 0;
+	return rtnl_echo_talk(&rth, &req.n, print_nexthop_nocache);
 }
 
 static int ipnh_get_id(__u32 id)
diff --git a/ip/iproute.c b/ip/iproute.c
index 4774aac0..aefc884b 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -1123,7 +1123,6 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 	};
 	char  mxbuf[256];
 	struct rtattr *mxrta = (void *)mxbuf;
-	struct nlmsghdr *answer;
 	unsigned int mxlock = 0;
 	char  *d = NULL;
 	int gw_ok = 0;
@@ -1134,7 +1133,6 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 	int raw = 0;
 	int type_ok = 0;
 	__u32 nhid = 0;
-	int ret;
 
 	if (cmd != RTM_DELROUTE) {
 		req.r.rtm_protocol = RTPROT_BOOT;
@@ -1142,9 +1140,6 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 		req.r.rtm_type = RTN_UNICAST;
 	}
 
-	if (echo_request)
-		req.n.nlmsg_flags |= NLM_F_ECHO | NLM_F_ACK;
-
 	mxrta->rta_type = RTA_METRICS;
 	mxrta->rta_len = RTA_LENGTH(0);
 
@@ -1591,24 +1586,7 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 	if (!type_ok && req.r.rtm_family == AF_MPLS)
 		req.r.rtm_type = RTN_UNICAST;
 
-	if (echo_request)
-		ret = rtnl_talk(&rth, &req.n, &answer);
-	else
-		ret = rtnl_talk(&rth, &req.n, NULL);
-
-	if (ret < 0)
-		return -2;
-
-	if (echo_request) {
-		new_json_obj(json);
-		open_json_object(NULL);
-		print_route(answer, (void *)stdout);
-		close_json_object();
-		delete_json_obj();
-		free(answer);
-	}
-
-	return 0;
+	return rtnl_echo_talk(&rth, &req.n, print_route);
 }
 
 static int iproute_flush_cache(void)
diff --git a/ip/iprule.c b/ip/iprule.c
index af77e62c..67058b9b 100644
--- a/ip/iprule.c
+++ b/ip/iprule.c
@@ -787,11 +787,6 @@ static int iprule_modify(int cmd, int argc, char **argv)
 		.frh.family = preferred_family,
 		.frh.action = FR_ACT_UNSPEC,
 	};
-	struct nlmsghdr *answer;
-	int ret;
-
-	if (echo_request)
-		req.n.nlmsg_flags |= NLM_F_ECHO | NLM_F_ACK;
 
 	if (cmd == RTM_NEWRULE) {
 		if (argc == 0) {
@@ -1021,24 +1016,7 @@ static int iprule_modify(int cmd, int argc, char **argv)
 	if (!table_ok && cmd == RTM_NEWRULE)
 		req.frh.table = RT_TABLE_MAIN;
 
-	if (echo_request)
-		ret = rtnl_talk(&rth, &req.n, &answer);
-	else
-		ret = rtnl_talk(&rth, &req.n, NULL);
-
-	if (ret < 0)
-		return -2;
-
-	if (echo_request) {
-		new_json_obj(json);
-		open_json_object(NULL);
-		print_rule(answer, stdout);
-		close_json_object();
-		delete_json_obj();
-		free(answer);
-	}
-
-	return 0;
+	return rtnl_echo_talk(&rth, &req.n, print_rule);
 }
 
 int do_iprule(int argc, char **argv)
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index c27627fe..00feb69b 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -42,7 +42,9 @@
 #define MIN(a, b) ((a) < (b) ? (a) : (b))
 #endif
 
+int json;
 int rcvbuf = 1024 * 1024;
+int echo_request = 0;
 
 #ifdef HAVE_LIBMNL
 #include <libmnl/libmnl.h>
@@ -1139,6 +1141,35 @@ static int __rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
 	return __rtnl_talk_iov(rtnl, &iov, 1, answer, show_rtnl_err, errfn);
 }
 
+int rtnl_echo_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
+		   int (*print_info)(struct nlmsghdr *n, void *arg))
+{
+	struct nlmsghdr *answer;
+	int ret;
+
+	if (echo_request)
+		n->nlmsg_flags |= NLM_F_ECHO | NLM_F_ACK;
+
+	if (echo_request)
+		ret = rtnl_talk(rtnl, n, &answer);
+	else
+		ret = rtnl_talk(rtnl, n, NULL);
+
+	if (ret < 0)
+		return -2;
+
+	if (echo_request) {
+		new_json_obj(json);
+		open_json_object(NULL);
+		print_info(answer, stdout);
+		close_json_object();
+		delete_json_obj();
+		free(answer);
+	}
+
+	return 0;
+}
+
 int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
 	      struct nlmsghdr **answer)
 {
-- 
2.37.2

