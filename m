Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18846213CD7
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 17:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgGCPkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 11:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgGCPkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 11:40:10 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21435C061794
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 08:40:10 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id 9so37456826ljv.5
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 08:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=itQU4C1FHAvFBtRZda2nWjvM8DnF58nCgqWt9pDOHkk=;
        b=W6A7tx8hK4uj12Z9E9rRa6w9PUUCrWNEFCRaNQeTP31Q5eLUtparViORugcAGtfNu/
         Tt4XTtnM+TxTuZTYBM0yx9+UWdh6oUH1dKY7Pe3kpB49ZV9Diua74oT3cDjB+dD5952C
         vNeE7StfPnPl5gkC2KmmQ7iHu9N+WRW+xP0ZtFOuiiuWPlbXZZcuYi7WtJzZGHNrqM4C
         r3wmAoSd9+TskerVgkAQrHbhLX3z0OMRxU3BYYNG+32AajI9aO9qq7YLHRdNlQ1x5jkb
         cYeoeB3ZpaifXliN1d7zl4equU8Ulwg0YP+T5MfVs1hGC4urcuFFou78AAznJOj5I5SL
         qAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=itQU4C1FHAvFBtRZda2nWjvM8DnF58nCgqWt9pDOHkk=;
        b=m1v7jz73rJGhD0e1pMdTR+oFK4frXjYGn1It1HiofrnwFnsAmGEHGcO8rF7zx9qz5x
         oCn2XvfPiPRBR+R/aU3+z9RIXJnMhS0hM+KEl7jFKO0bXgXYMVxr8JjTS0R8mPlTqRDU
         Hv9lt8AYOE8sieqFR+xVZ9K8BPOduCH8F1H/SKrXYDgqoPSSHAL4BK7ZzXqleXtTrvY4
         GwFYUZ2QCSurPcQVrEAzPEGGNPW1Za5JwpthfffYDciV/C0UkuO8M0YxdnCejYzYLg65
         60mGMwikLnC8giTxevsqAF/1yRUhclHOnY/pjViGFQkbQx4mvnzDKzpjLol2vEuuhgqa
         m5Lw==
X-Gm-Message-State: AOAM530umTjIzALzjWKi8atZUZeTa4VWD33qDSFdM/ZJEYfXksfWEnyk
        3Pllg4n+Tfcq1Z92HM+bwcTwAl6SRJM=
X-Google-Smtp-Source: ABdhPJxDmzvfXpnmxAZw+eeksJqXKQy2m4ZK93GxLqvajF1tuBRbNWl+e7deC/WsNen9oJrwpvhClA==
X-Received: by 2002:a2e:b5d0:: with SMTP id g16mr19273408ljn.246.1593790808266;
        Fri, 03 Jul 2020 08:40:08 -0700 (PDT)
Received: from dau-pc-work.sunlink.ru ([87.244.6.228])
        by smtp.googlemail.com with ESMTPSA id y24sm4215943ljy.91.2020.07.03.08.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 08:40:07 -0700 (PDT)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Anton Danilov <littlesmilingcloud@gmail.com>
Subject: [PATCH iproute2 v3] tc: improve the qdisc show command
Date:   Fri,  3 Jul 2020 18:39:22 +0300
Message-Id: <20200703153921.9312-1-littlesmilingcloud@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618151702.24c33261@hermes.lan>
References: <20200618151702.24c33261@hermes.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before can be possible show only all qeueue disciplines on an interface.
There wasn't a way to get the qdisc info by handle or parent, only full
dump of the disciplines with a following grep/sed usage.

Now new and old options work as expected to filter a qdisc by handle or
parent.

Full syntax of the qdisc show command:

tc qdisc { show | list } [ dev STRING ] [ QDISC_ID ] [ invisible ]
  QDISC_ID := { root | ingress | handle QHANDLE | parent CLASSID }

This change doesn't require any changes in the kernel.

Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
---
v2:
- Fix the coding style
v3:
- Make the parameters checking more simple
---
 man/man8/tc.8 |  8 +++--
 tc/tc_qdisc.c | 91 ++++++++++++++++++++++++++++++++-------------------
 2 files changed, 64 insertions(+), 35 deletions(-)

diff --git a/man/man8/tc.8 b/man/man8/tc.8
index 235216b6..305bc569 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -77,9 +77,13 @@ tc \- show / manipulate traffic control settings
 .B tc
 .RI "[ " OPTIONS " ]"
 .RI "[ " FORMAT " ]"
-.B qdisc show [ dev
+.B qdisc { show | list } [ dev
 \fIDEV\fR
-.B ]
+.B ] [ root | ingress | handle
+\fIQHANDLE\fR
+.B | parent
+\fICLASSID\fR
+.B ] [ invisible ]
 .P
 .B tc
 .RI "[ " OPTIONS " ]"
diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index 181fe2f0..8eb08c34 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -35,11 +35,12 @@ static int usage(void)
 		"       [ ingress_block BLOCK_INDEX ] [ egress_block BLOCK_INDEX ]\n"
 		"       [ [ QDISC_KIND ] [ help | OPTIONS ] ]\n"
 		"\n"
-		"       tc qdisc show [ dev STRING ] [ ingress | clsact ] [ invisible ]\n"
+		"       tc qdisc { show | list } [ dev STRING ] [ QDISC_ID ] [ invisible ]\n"
 		"Where:\n"
 		"QDISC_KIND := { [p|b]fifo | tbf | prio | cbq | red | etc. }\n"
 		"OPTIONS := ... try tc qdisc add <desired QDISC_KIND> help\n"
-		"STAB_OPTIONS := ... try tc qdisc add stab help\n");
+		"STAB_OPTIONS := ... try tc qdisc add stab help\n"
+		"QDISC_ID := { root | ingress | handle QHANDLE | parent CLASSID }\n");
 	return -1;
 }
 
@@ -212,6 +213,8 @@ static int tc_qdisc_modify(int cmd, unsigned int flags, int argc, char **argv)
 }
 
 static int filter_ifindex;
+static __u32 filter_parent;
+static __u32 filter_handle;
 
 int print_qdisc(struct nlmsghdr *n, void *arg)
 {
@@ -235,6 +238,12 @@ int print_qdisc(struct nlmsghdr *n, void *arg)
 	if (filter_ifindex && filter_ifindex != t->tcm_ifindex)
 		return 0;
 
+	if (filter_handle && filter_handle != t->tcm_handle)
+		return 0;
+
+	if (filter_parent && filter_parent != t->tcm_parent)
+		return 0;
+
 	parse_rtattr_flags(tb, TCA_MAX, TCA_RTA(t), len, NLA_F_NESTED);
 
 	if (tb[TCA_KIND] == NULL) {
@@ -344,21 +353,55 @@ int print_qdisc(struct nlmsghdr *n, void *arg)
 
 static int tc_qdisc_list(int argc, char **argv)
 {
-	struct tcmsg t = { .tcm_family = AF_UNSPEC };
+	struct {
+		struct nlmsghdr n;
+		struct tcmsg t;
+		char buf[256];
+	} req = {
+		.n.nlmsg_type = RTM_GETQDISC,
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg)),
+		.t.tcm_family = AF_UNSPEC,
+	};
+
 	char d[IFNAMSIZ] = {};
 	bool dump_invisible = false;
+	__u32 handle;
 
 	while (argc > 0) {
 		if (strcmp(*argv, "dev") == 0) {
 			NEXT_ARG();
 			strncpy(d, *argv, sizeof(d)-1);
+		} else if (strcmp(*argv, "root") == 0) {
+			if (filter_parent)
+				invarg("parent is already specified", *argv);
+			else if (filter_handle)
+				invarg("handle is already specified", *argv);
+			filter_parent = TC_H_ROOT;
 		} else if (strcmp(*argv, "ingress") == 0 ||
-			   strcmp(*argv, "clsact") == 0) {
-			if (t.tcm_parent) {
-				fprintf(stderr, "Duplicate parent ID\n");
-				usage();
-			}
-			t.tcm_parent = TC_H_INGRESS;
+				strcmp(*argv, "clsact") == 0) {
+			if (filter_parent)
+				invarg("parent is already specified", *argv);
+			else if (filter_handle)
+				invarg("handle is already specified", *argv);
+			filter_parent = TC_H_INGRESS;
+		} else if (matches(*argv, "parent") == 0) {
+			if (filter_parent)
+				invarg("parent is already specified", *argv);
+			else if (filter_handle)
+				invarg("handle is already specified", *argv);
+			NEXT_ARG();
+			if (get_tc_classid(&handle, *argv))
+				invarg("invalid parent ID", *argv);
+			filter_parent = handle;
+		} else if (matches(*argv, "handle") == 0) {
+			if (filter_parent)
+				invarg("parent is already specified", *argv);
+			else if (filter_handle)
+				invarg("handle is already specified", *argv);
+			NEXT_ARG();
+			if (get_qdisc_handle(&handle, *argv))
+				invarg("invalid handle ID", *argv);
+			filter_handle = handle;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
 		} else if (strcmp(*argv, "invisible") == 0) {
@@ -374,32 +417,18 @@ static int tc_qdisc_list(int argc, char **argv)
 	ll_init_map(&rth);
 
 	if (d[0]) {
-		t.tcm_ifindex = ll_name_to_index(d);
-		if (!t.tcm_ifindex)
+		req.t.tcm_ifindex = ll_name_to_index(d);
+		if (!req.t.tcm_ifindex)
 			return -nodev(d);
-		filter_ifindex = t.tcm_ifindex;
+		filter_ifindex = req.t.tcm_ifindex;
 	}
 
 	if (dump_invisible) {
-		struct {
-			struct nlmsghdr n;
-			struct tcmsg t;
-			char buf[256];
-		} req = {
-			.n.nlmsg_type = RTM_GETQDISC,
-			.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg)),
-		};
-
-		req.t.tcm_family = AF_UNSPEC;
-
 		addattr(&req.n, 256, TCA_DUMP_INVISIBLE);
-		if (rtnl_dump_request_n(&rth, &req.n) < 0) {
-			perror("Cannot send dump request");
-			return 1;
-		}
+	}
 
-	} else if (rtnl_dump_request(&rth, RTM_GETQDISC, &t, sizeof(t)) < 0) {
-		perror("Cannot send dump request");
+	if (rtnl_dump_request_n(&rth, &req.n) < 0) {
+		perror("Cannot send request");
 		return 1;
 	}
 
@@ -427,10 +456,6 @@ int do_qdisc(int argc, char **argv)
 		return tc_qdisc_modify(RTM_NEWQDISC, NLM_F_REPLACE, argc-1, argv+1);
 	if (matches(*argv, "delete") == 0)
 		return tc_qdisc_modify(RTM_DELQDISC, 0,  argc-1, argv+1);
-#if 0
-	if (matches(*argv, "get") == 0)
-		return tc_qdisc_get(RTM_GETQDISC, 0,  argc-1, argv+1);
-#endif
 	if (matches(*argv, "list") == 0 || matches(*argv, "show") == 0
 	    || matches(*argv, "lst") == 0)
 		return tc_qdisc_list(argc-1, argv+1);
-- 
2.26.2

