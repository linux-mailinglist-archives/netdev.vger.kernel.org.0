Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5823FA54A
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbhH1LJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234070AbhH1LJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:20 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8ADC0613D9
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:30 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id lc21so19673996ejc.7
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YAFMtbvJRGK1GmJcd8X6BZDwj6sFH8EQY+S8GCuya80=;
        b=AbZXJnRhvCg4mOIAqtFl60xKHecP9IspbZaimUeREnHGzpBJ6qaCTcitvqna5VIbYf
         21CJwCOmfWNj1rXv0l4TXChFnbtMmwniql7HNkng0uv+1MrP3PgYnnRi+OYJP8cpvwFO
         IgKABYs3cPKJ9mGahsXozIpMcKWHK6OKqO4as5X2iP70F0lFCGBHlPuKh5QNz4mDSKYi
         WvRP4wWSbJMGBG1SM8G1n5F7FuWkGTtHIbQHbJpBzasl4kz38Sb0x5LZvGqONavZtZE7
         ylBC78Jz5jA4v8ZRSxjDq48DPMNI+vSQU6HqizeKM7PRzhENQtpNpoiSq6D3G9UWrN4O
         5R7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YAFMtbvJRGK1GmJcd8X6BZDwj6sFH8EQY+S8GCuya80=;
        b=QQD6xL0yQy3vfauKlUTnou41JlMpWCDSIX3S9uzasrCTdPAhVxtr1nfWSBbUPlTvfI
         OpVkUIIjL0P3cGWforY306XenIdd+7VKuaeXprG/Lbwz5ZIW4XJJ/pQSHgBuF7510EFQ
         mTg6tp1PJ6Ixjzcg2zsrmlf9+ltAB5ygI6seg99y42RBtVopSqKSytLItpKhinoiE0ia
         sz6dwMVp0Ou5AEU83X3tRPIVdcvxOrJQQAq8j+SAiR2oIlxAHSTHmIHG3YAqAqvTXjp5
         HYbX9u6UTqYTVOif8sPS/saf0jBLWcIKZQx81K23QIZnGArT8y6l6VowFNyQKw7tBxr7
         Fp9A==
X-Gm-Message-State: AOAM532CRC4l/mKBlbrQw5vQIH2gslvZ7hhtOQvKp9HRAYaDVpu+r9kt
        Wt8luoW+BtkuN5HFsEd7DpmQdMl7ioynIwVr
X-Google-Smtp-Source: ABdhPJzqxYRtjL1fOUWW63R9yhtz7YVE8uZQXxnj3FiJIvx3j6e+on/mLhupZfficnLDKZPLdHuHNg==
X-Received: by 2002:a17:906:d20a:: with SMTP id w10mr15401584ejz.426.1630148908826;
        Sat, 28 Aug 2021 04:08:28 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:28 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 13/19] bridge: vlan: add global mcast_membership_interval option
Date:   Sat, 28 Aug 2021 14:07:59 +0300
Message-Id: <20210828110805.463429-14-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_membership_interval
option which controls the interval after which the bridge will leave a
group if no reports have been received for it. To be consistent with the
same bridge-wide option the value is reported with USER_HZ granularity and
the same granularity is expected when setting it.
The default is 26000 (260 seconds).
Syntax:
 $ bridge vlan global set dev bridge vid 1 mcast_membership_interval 13000

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: adjust help msg alignment to fit in 100 columns

 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 |  9 ++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 2a3dffdbac44..acdbb4a1b562 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -45,6 +45,7 @@ static void usage(void)
 		"                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
 		"                      [ mcast_last_member_interval LAST_MEMBER_INTERVAL ]\n"
 		"                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
+		"                      [ mcast_membership_interval MEMBERSHIP_INTERVAL ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -448,6 +449,14 @@ static int vlan_global_option_set(int argc, char **argv)
 			addattr64(&req.n, 1024,
 				  BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL,
 				  val64);
+		} else if (strcmp(*argv, "mcast_membership_interval") == 0) {
+			NEXT_ARG();
+			if (get_u64(&val64, *argv, 0))
+				invarg("invalid mcast_membership_interval",
+				       *argv);
+			addattr64(&req.n, 1024,
+				  BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL,
+				  val64);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -814,6 +823,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 			   "mcast_startup_query_count %u ",
 			   rta_getattr_u32(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL];
+		print_lluint(PRINT_ANY, "mcast_membership_interval",
+			     "mcast_membership_interval %llu ",
+			     rta_getattr_u64(vattr));
+	}
 	print_nl();
 	close_json_object();
 }
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 0d973a9db0e0..a026ca16f89a 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -169,7 +169,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B mcast_last_member_interval
 .IR LAST_MEMBER_INTERVAL " ] [ "
 .B mcast_startup_query_count
-.IR STARTUP_QUERY_COUNT " ]"
+.IR STARTUP_QUERY_COUNT " ] [ "
+.B mcast_membership_interval
+.IR MEMBERSHIP_INTERVAL " ]"
 
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
@@ -964,6 +966,11 @@ after a "leave" message is received.
 .BI mcast_startup_query_count " STARTUP_QUERY_COUNT "
 set the number of queries to send during startup phase. Default is 2.
 
+.TP
+.BI mcast_membership_interval " MEMBERSHIP_INTERVAL "
+delay after which the bridge will leave a group,
+if no membership reports for this group are received.
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

