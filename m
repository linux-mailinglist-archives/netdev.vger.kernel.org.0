Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5B05EF010
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235299AbiI2IKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235473AbiI2IKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:10:25 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07E3A5739
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:10:23 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d24so630039pls.4
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=cFH8tVwoZ17yJCWicMSLuqeNIkBHFXypsDXaQAS6xVY=;
        b=mWuMNJLQ0Jg+7rkIeHI6qPvLR19jvjEVRZG38abDES23cW6VSgLIvm2eYs4TzRubgR
         JnEiBtcDl1NExtQFh/sTC8zqJowLnoKK2ls+5VY+ZPy2O7dH9Fvze7zV1IATAg0BOmOT
         FlVNxlmzUOiVSjwzC/EA5ZqanXx/EBQfLJNJTZwNzBAvZXAP6vkwujXWVkb1MGc3srDh
         DZ/c5OtZPuUVAXqx3fFoxSGN4BZKTAJIkmb+UXXyPJk/0krOWKQ/ZGhWc3z3IGpyefYI
         gtjG7u/GZ14LfRKtzV/I5YvKowcpsRiF4E3rxZcgbquAZS7LLRmaT8yGddIxx/VowRot
         7Kmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=cFH8tVwoZ17yJCWicMSLuqeNIkBHFXypsDXaQAS6xVY=;
        b=d/3S3wzaMAARjPWXVFOeMEeDHKU+Pzv0GpSHliVk1C3DmhmuPP7gOUfhfGBn7N07Be
         pIDI4sc5c4mFQHPDa0sb5pfNKcwuqiVI4vBaAtQMI8Ayr0wudK0ZNJUJuDngX8QNUU6n
         lcXZgmpkAY8UPabuX1r3t4+4YF7cOfOXmGreLgEdYsRN/nHNr0oYQ7QdEMq8TNo/QDyW
         5xIg98osH+u3FkcfNJjpZ8rxjuoSPKpDUl9/Tn+Sg26niNlgyGfgiPsipTfkbPzJmkfq
         HZJfNXbZhajgcd6H/XSZEcvzRssvIO0LG4gbPKWMi/ARfo4CQdwRS6tKHh8aG8P4Y0LD
         zjog==
X-Gm-Message-State: ACrzQf2wnvitM0f36SBGkd8gDU67T9ZN30c1uOGK4ZJbyOfmvFCevIrD
        URTl8ZVynMZbIvUUwHUb6kqB5nXFolfrSw==
X-Google-Smtp-Source: AMsMyM6r0DZSpC87s6FCCkYe0H+xbvdQwXsh3/IQDgWftwCjoRYAD9YeWCfwp3AQQCkfgF78TJ1wCQ==
X-Received: by 2002:a17:903:22c2:b0:178:3c7c:18af with SMTP id y2-20020a17090322c200b001783c7c18afmr2288743plg.134.1664439022551;
        Thu, 29 Sep 2022 01:10:22 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t18-20020a17090340d200b0017315b11bb8sm5145316pld.213.2022.09.29.01.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 01:10:21 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 iproute2-next] rtnetlink: add new function rtnl_echo_talk()
Date:   Thu, 29 Sep 2022 16:10:16 +0800
Message-Id: <20220929081016.479323-1-liuhangbin@gmail.com>
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
v3: no need to use 'else' if we can return directly
v2: only handle echo_request code in helper rtnl_echo_talk()
---
 include/libnetlink.h |  3 +++
 ip/ipaddress.c       | 23 ++---------------------
 ip/iplink.c          | 19 +++----------------
 ip/ipnexthop.c       | 23 ++---------------------
 ip/iproute.c         | 23 ++---------------------
 ip/iprule.c          | 23 ++---------------------
 lib/libnetlink.c     | 22 ++++++++++++++++++++++
 7 files changed, 36 insertions(+), 100 deletions(-)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index a7b0f352..1b8d29bd 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -171,6 +171,9 @@ int rtnl_dump_filter_errhndlr_nc(struct rtnl_handle *rth,
 #define rtnl_dump_filter_errhndlr(rth, filter, farg, errhndlr, earg) \
 	rtnl_dump_filter_errhndlr_nc(rth, filter, farg, errhndlr, earg, 0)
 
+int rtnl_echo_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n, int json,
+		   int (*print_info)(struct nlmsghdr *n, void *arg))
+	__attribute__((warn_unused_result));
 int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
 	      struct nlmsghdr **answer)
 	__attribute__((warn_unused_result));
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 986cfbc3..456545bb 100644
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
@@ -2609,23 +2604,9 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 	}
 
 	if (echo_request)
-		ret = rtnl_talk(&rth, &req.n, &answer);
-	else
-		ret = rtnl_talk(&rth, &req.n, NULL);
-
-	if (ret < 0)
-		return -2;
+		return rtnl_echo_talk(&rth, &req.n, json, print_addrinfo);
 
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
+	return rtnl_talk(&rth, &req.n, NULL);
 }
 
 int do_ipaddr(int argc, char **argv)
diff --git a/ip/iplink.c b/ip/iplink.c
index ad22f2d7..173f149d 100644
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
@@ -1128,21 +1124,12 @@ static int iplink_modify(int cmd, unsigned int flags, int argc, char **argv)
 	}
 
 	if (echo_request)
-		ret = rtnl_talk(&rth, &req.n, &answer);
+		ret = rtnl_echo_talk(&rth, &req.n, json, print_linkinfo);
 	else
 		ret = rtnl_talk(&rth, &req.n, NULL);
 
-	if (ret < 0)
-		return -2;
-
-	if (echo_request) {
-		new_json_obj(json);
-		open_json_object(NULL);
-		print_linkinfo(answer, stdout);
-		close_json_object();
-		delete_json_obj();
-		free(answer);
-	}
+	if (ret)
+		return ret;
 
 	/* remove device from cache; next use can refresh with new data */
 	ll_drop_by_index(req.i.ifi_index);
diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 59f8f2fb..c87e847f 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -919,12 +919,7 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 		.n.nlmsg_type = cmd,
 		.nhm.nh_family = preferred_family,
 	};
-	struct nlmsghdr *answer;
 	__u32 nh_flags = 0;
-	int ret;
-
-	if (echo_request)
-		req.n.nlmsg_flags |= NLM_F_ECHO | NLM_F_ACK;
 
 	while (argc > 0) {
 		if (!strcmp(*argv, "id")) {
@@ -1005,23 +1000,9 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 	req.nhm.nh_flags = nh_flags;
 
 	if (echo_request)
-		ret = rtnl_talk(&rth, &req.n, &answer);
-	else
-		ret = rtnl_talk(&rth, &req.n, NULL);
-
-	if (ret < 0)
-		return -2;
+		return rtnl_echo_talk(&rth, &req.n, json, print_nexthop_nocache);
 
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
+	return rtnl_talk(&rth, &req.n, NULL);
 }
 
 static int ipnh_get_id(__u32 id)
diff --git a/ip/iproute.c b/ip/iproute.c
index 4774aac0..8b2d1fbe 100644
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
 
@@ -1592,23 +1587,9 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 		req.r.rtm_type = RTN_UNICAST;
 
 	if (echo_request)
-		ret = rtnl_talk(&rth, &req.n, &answer);
-	else
-		ret = rtnl_talk(&rth, &req.n, NULL);
+		return rtnl_echo_talk(&rth, &req.n, json, print_route);
 
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
+	return rtnl_talk(&rth, &req.n, NULL);
 }
 
 static int iproute_flush_cache(void)
diff --git a/ip/iprule.c b/ip/iprule.c
index af77e62c..8f750425 100644
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
@@ -1022,23 +1017,9 @@ static int iprule_modify(int cmd, int argc, char **argv)
 		req.frh.table = RT_TABLE_MAIN;
 
 	if (echo_request)
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
+		return rtnl_echo_talk(&rth, &req.n, json, print_rule);
 
-	return 0;
+	return rtnl_talk(&rth, &req.n, NULL);
 }
 
 int do_iprule(int argc, char **argv)
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index c27627fe..07047bc7 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -1139,6 +1139,28 @@ static int __rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
 	return __rtnl_talk_iov(rtnl, &iov, 1, answer, show_rtnl_err, errfn);
 }
 
+int rtnl_echo_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n, int json,
+		   int (*print_info)(struct nlmsghdr *n, void *arg))
+{
+	struct nlmsghdr *answer;
+	int ret;
+
+	n->nlmsg_flags |= NLM_F_ECHO | NLM_F_ACK;
+
+	ret = rtnl_talk(rtnl, n, &answer);
+	if (ret)
+		return ret;
+
+	new_json_obj(json);
+	open_json_object(NULL);
+	print_info(answer, stdout);
+	close_json_object();
+	delete_json_obj();
+	free(answer);
+
+	return 0;
+}
+
 int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
 	      struct nlmsghdr **answer)
 {
-- 
2.37.2

