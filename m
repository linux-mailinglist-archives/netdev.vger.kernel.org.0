Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89B03F8863
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242645AbhHZNKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242583AbhHZNKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:23 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64312C0612E7
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:33 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id i21so6198553ejd.2
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rh7b2Wwkbp6esgEZ9J931WL5wtmpsrFSUK5at9Uty1o=;
        b=jcdF7ZWiZqI4imWAHWOYdOnKaa/k9SMBpgxMrlgOG8kUObAIhD8AHkrDfQ8EPudT2L
         ViOLh+VuuOVcdYKZziytaBOY6LITyVHB+koKvh0fKxwPbKgNIVdvAvzn9lbNaa91xu38
         VVuDsfugb00tvMLBZuIiXA3YHytorlgagpYgbXFE0rr/jfmxqF8u3WL4rGZ+Ytdrhk/T
         KX/IX0a8VR8g+Q+pQdquMxIDLsC317ajj7h1VjrRLRJ88SfuFcidv+qyiuPqxKcyP61F
         TatF2Wz+JypXiBWVnHTWhgnClNh0RJdh5ZccbvxPrtXo+f06MilOvqUzvqt9baZ7SmZ5
         Tf8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rh7b2Wwkbp6esgEZ9J931WL5wtmpsrFSUK5at9Uty1o=;
        b=tMsuCt3OY/ibd02Vkp3K7GUlZLl4RP3TN+t/mw6XWsUHaykXpsBJOxDA2AgYMRnhJG
         BpEc4i25fHNB6OER8jSW3+MyUV/icDxoptZSOIx7aIq/E0wraQefHsC4OWtRwAdDHuZc
         5Rf+OlQokT7ZFzbNeBn1X9b28wzH7dQ8YKrYh/NnhW+7weD9P/XawEK5biRFm4EFwZ5p
         TrSrnODZYZ7uNi+FXify5bOJdQ/Wn0QdN9MtTCkf1ZXR4q2rB0acjUf9FXnZixJ1y5mR
         2g/0mRlumqdc4vMSG7s5J+2ECodqxOsJ6hqxxsxF9uvcE7dfqVSUhXU27sK4ekplnd+/
         Ph0A==
X-Gm-Message-State: AOAM530T34uPxNwJRP4028ZCFaRxwhWIkU7kHlKAI2PKVLQoHpjnf1yO
        KpZrgrjb74c4ZH2x6jWZEAHJvu2NfZkyXIyO
X-Google-Smtp-Source: ABdhPJzhbirsYnGYpSyJA7Yp4ZZ8Rq3DQPQkdOo65wicgpvh7BLuHUDu0NSf0fMJK5k4m5UTwZPNTA==
X-Received: by 2002:a17:906:f207:: with SMTP id gt7mr4096742ejb.380.1629983371739;
        Thu, 26 Aug 2021 06:09:31 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:31 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 14/17] bridge: vlan: add global mcast_query_response_interval option
Date:   Thu, 26 Aug 2021 16:05:30 +0300
Message-Id: <20210826130533.149111-15-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_query_response_interval
option which sets the Max Response Time/Maximum Response Delay for IGMP/MLD
queries sent by the bridge. To be consistent with the same bridge-wide
option the value is reported with USER_HZ granularity and the same
granularity is expected when setting it.
Syntax:
 $ bridge vlan global set dev bridge vid 1 mcast_query_response_interval 13000

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 |  9 ++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 206cbdea10cb..0f6d8849843f 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -47,6 +47,7 @@ static void usage(void)
 		"                                                      [ mcast_membership_interval MEMBERSHIP_INTERVAL ]\n"
 		"                                                      [ mcast_querier_interval QUERIER_INTERVAL ]\n"
 		"                                                      [ mcast_query_interval QUERY_INTERVAL ]\n"
+		"                                                      [ mcast_query_response_interval QUERY_RESPONSE_INTERVAL ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -474,6 +475,14 @@ static int vlan_global_option_set(int argc, char **argv)
 			addattr64(&req.n, 1024,
 				  BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL,
 				  val64);
+		} else if (strcmp(*argv, "mcast_query_response_interval") == 0) {
+			NEXT_ARG();
+			if (get_u64(&val64, *argv, 0))
+				invarg("invalid mcast_query_response_interval",
+				       *argv);
+			addattr64(&req.n, 1024,
+				  BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL,
+				  val64);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -858,6 +867,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 			     "mcast_query_interval %llu ",
 			     rta_getattr_u64(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL];
+		print_lluint(PRINT_ANY, "mcast_query_response_interval",
+			     "mcast_query_response_interval %llu ",
+			     rta_getattr_u64(vattr));
+	}
 	print_nl();
 	close_json_object();
 }
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index cb1170f8d5c9..e9cd5f9f4fe6 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -175,7 +175,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B mcast_querier_interval
 .IR QUERIER_INTERVAL " ] [ "
 .B mcast_query_interval
-.IR QUERY_INTERVAL " ]"
+.IR QUERY_INTERVAL " ] [ "
+.B mcast_query_response_interval
+.IR QUERY_RESPONSE_INTERVAL " ]"
 
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
@@ -988,6 +990,11 @@ was enabled).
 interval between queries sent by the bridge after the end of the
 startup phase.
 
+.TP
+.BI mcast_query_response_interval " QUERY_RESPONSE_INTERVAL "
+set the Max Response Time/Maximum Response Delay for IGMP/MLD
+queries sent by the bridge.
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

