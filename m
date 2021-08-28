Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5093FA54E
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhH1LJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbhH1LJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:24 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42896C061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:34 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id n27so19709045eja.5
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VhD2Pji1SPKf/7s4zF8hjiL2wpeUroReD5vXl/QnrWA=;
        b=eS3MwcX0UqDtZAZKANxftK3ccNTkdYvq/rzNso53MjqCTESHbG9OoHUe2cmybmNxXt
         7K5XizAUo083RAzxV0QKmf1PjFnD5I3IbpCRrrj/x66ZAjbTCsDpZEq0Gy6IUBv33m6/
         6P04CRUbjRCIfnoEiaK2twXhskK6TTAJVLjm2ZN7z+bkL2Cgmoo1pGhO/5rERDLdOu8Q
         Aq0NaG2S/hYs5ZwL1MWT+ubqxmTSW9N1zL964A7b0d9KJcxQ5wzeYHqBhuqdPz5WtsqA
         L5wGONbb9/CXHouQv17WpYCARH50mtV+BoBLuuCL+aTUPrk5tZDjnc236UHbeCcVdq+e
         MF0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VhD2Pji1SPKf/7s4zF8hjiL2wpeUroReD5vXl/QnrWA=;
        b=enRjWipJTVuwjNEPy8n9bkBCROlRxQ1IkNSf7VY3+s8/JLeO61ppACx+4rcIu2pCRg
         fxSJij3f2p4F/bMdhPtYeklWOq/LHyXz3ufGjkKoGawHnZPel4ipUTS+equPazCqtEK9
         ZYsS7tI7WEQ3UPx/ZjmHkkD9JGiOOGcu+z+Ebkrxanh+JTwIOWmTMacUqCJhdJMk/lZp
         i4pnQMKc3tTKwuF7gQK/GHMx5yTOm2XrVTsTSOn6Xy15CjIHUeS0A5pWrjVS8UnH8sH9
         typgTSGslUj+h7EPWq8E8yVJCCAZCYr1+0yWvK1gvdIgxz2/Q4ZHOnluIXXV1l9/C/Dw
         KJnA==
X-Gm-Message-State: AOAM533QQ2hP1KvMB09KUzcPsouzKjmlgNP5JIq/EsMBt71lzbDp3v4n
        Dxd7jJ4DuufGL/uWHn7pVrBCi/LAc5kgypNL
X-Google-Smtp-Source: ABdhPJxgdWtnpVbV0OWtNgNnmvRUY3quEjC1G0zsdxy4ToTMrmsdp7ntOGiW4EJhudRciqXVAfNEKg==
X-Received: by 2002:a17:906:fb19:: with SMTP id lz25mr15124614ejb.162.1630148912529;
        Sat, 28 Aug 2021 04:08:32 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:32 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 17/19] bridge: vlan: add global mcast_startup_query_interval option
Date:   Sat, 28 Aug 2021 14:08:03 +0300
Message-Id: <20210828110805.463429-18-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_startup_query_interval
option which controls the interval between queries in the startup phase.
To be consistent with the same bridge-wide option the value is reported
with USER_HZ granularity and the same granularity is expected when setting
it.
Syntax:
 $ bridge vlan global set dev bridge vid 1 mcast_startup_query_interval 15000

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: adjust help msg alignment to fit in 100 columns

 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 7f6845158bf0..e8043f8574fd 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -45,6 +45,7 @@ static void usage(void)
 		"                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
 		"                      [ mcast_last_member_interval LAST_MEMBER_INTERVAL ]\n"
 		"                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
+		"                      [ mcast_startup_query_interval STARTUP_QUERY_INTERVAL ]\n"
 		"                      [ mcast_membership_interval MEMBERSHIP_INTERVAL ]\n"
 		"                      [ mcast_querier_interval QUERIER_INTERVAL ]\n"
 		"                      [ mcast_query_interval QUERY_INTERVAL ]\n"
@@ -484,6 +485,14 @@ static int vlan_global_option_set(int argc, char **argv)
 			addattr64(&req.n, 1024,
 				  BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL,
 				  val64);
+		} else if (strcmp(*argv, "mcast_startup_query_interval") == 0) {
+			NEXT_ARG();
+			if (get_u64(&val64, *argv, 0))
+				invarg("invalid mcast_startup_query_interval",
+				       *argv);
+			addattr64(&req.n, 1024,
+				  BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL,
+				  val64);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -850,6 +859,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 			   "mcast_startup_query_count %u ",
 			   rta_getattr_u32(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL];
+		print_lluint(PRINT_ANY, "mcast_startup_query_interval",
+			     "mcast_startup_query_interval %llu ",
+			     rta_getattr_u64(vattr));
+	}
 	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL]) {
 		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL];
 		print_lluint(PRINT_ANY, "mcast_membership_interval",
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index e9cd5f9f4fe6..eeceb309d219 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -170,6 +170,8 @@ bridge \- show / manipulate bridge addresses and devices
 .IR LAST_MEMBER_INTERVAL " ] [ "
 .B mcast_startup_query_count
 .IR STARTUP_QUERY_COUNT " ] [ "
+.B mcast_startup_query_interval
+.IR STARTUP_QUERY_INTERVAL " ] [ "
 .B mcast_membership_interval
 .IR MEMBERSHIP_INTERVAL " ] [ "
 .B mcast_querier_interval
@@ -972,6 +974,10 @@ after a "leave" message is received.
 .BI mcast_startup_query_count " STARTUP_QUERY_COUNT "
 set the number of queries to send during startup phase. Default is 2.
 
+.TP
+.BI mcast_startup_query_interval " STARTUP_QUERY_INTERVAL "
+interval between queries in the startup phase.
+
 .TP
 .BI mcast_membership_interval " MEMBERSHIP_INTERVAL "
 delay after which the bridge will leave a group,
-- 
2.31.1

