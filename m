Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486853FA54C
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbhH1LJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbhH1LJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:22 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AEFC0613D9
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:32 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a25so19651396ejv.6
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lT9JvyrdvnM/eoCLoXdcjMOrdoJgyMWFCyFc+y+oquo=;
        b=y2JnQ6t4k1xXQquDPJsB1mq3hEYtsxEnspzCJ1+F34PGvmuPHPsGu+df2ig4LPTR6Q
         7SmpWAjl0WiuqsU3hgSUN2NC7KTVPv6xb87aVVQqH4ZY4WIFW32A7vDvhxQtv2b6+gh3
         lUumu4FA1tFu7RMNjXK5WC1VzpKk4NgoGXuCco5GKAjQ7FOrpbI70HwNerRNMMwMxCne
         EXf+gBXqU0ANNIAY4YAFctEEUXj4n7a10A50I7rWZAbZuZBw/J2/NQX2WGdUYUNIuBcZ
         3hw/6DWYPqu/BoRQd22BrSYYf+1Va6/uSK5UxKy4baUnP+P5fuJ+/02RLcXes5Ui4W1D
         wBHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lT9JvyrdvnM/eoCLoXdcjMOrdoJgyMWFCyFc+y+oquo=;
        b=gOrBKbboLShhqVpu4784UZfsRpRdcte7ri5SbEwVKCSjME6/fAMi3ysUKJ6mPU141F
         AepIzRStXP2p2EWMyJ5/LGW84ZSrne1Ega3+y6Vc2fbl6VWxhSaHcWtw+GFBMs9q5smp
         WpXZLNnsPfW4DYpa5QKF9NcOk+8zrB3dyRCmdrTpvt2fFstmvZWh+NpOGyo0g2kSvs7H
         T/Eyrddruxikn0jhuIgXFeBCsD6OXsdzJsFWFOKyCI8MWMztIOJP3SOTsUkPGIs4GPlc
         yiMD80SZhHazltxGqdACXBlmzSqhJJmIEVEmZ3awMnoF3k/2S5eL0javlyScIMcWnzQ5
         U8pA==
X-Gm-Message-State: AOAM531dhAYeGX9TiLaZwyJDVdOO5j8p5mtSCn4JmjFkFGMpMiCz+C4C
        HBJX2SGi6W6C4TtwGTMOlKtWzGMEHW0JV2mE
X-Google-Smtp-Source: ABdhPJxHgVTwWo0rfl13UPi7cMh6CbE+G8ha7YSdYaFbcf60r/FLBXDh8ZmJgJ6h5ZgvehmUoNt/ag==
X-Received: by 2002:a17:907:78cf:: with SMTP id kv15mr9561876ejc.422.1630148910703;
        Sat, 28 Aug 2021 04:08:30 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:30 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 15/19] bridge: vlan: add global mcast_query_interval option
Date:   Sat, 28 Aug 2021 14:08:01 +0300
Message-Id: <20210828110805.463429-16-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_query_interval
option which controls the interval between queries sent by the bridge
after the end of the startup phase. To be consistent with the same
bridge-wide option the value is reported with USER_HZ granularity and
the same granularity is expected when setting it.
Syntax:
 $ bridge vlan global set dev bridge vid 1 mcast_query_interval 13000

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: adjust help msg alignment to fit in 100 columns

 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 |  9 ++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 5494dd15c76e..d7fb27ea752a 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -47,6 +47,7 @@ static void usage(void)
 		"                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
 		"                      [ mcast_membership_interval MEMBERSHIP_INTERVAL ]\n"
 		"                      [ mcast_querier_interval QUERIER_INTERVAL ]\n"
+		"                      [ mcast_query_interval QUERY_INTERVAL ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -466,6 +467,14 @@ static int vlan_global_option_set(int argc, char **argv)
 			addattr64(&req.n, 1024,
 				  BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL,
 				  val64);
+		} else if (strcmp(*argv, "mcast_query_interval") == 0) {
+			NEXT_ARG();
+			if (get_u64(&val64, *argv, 0))
+				invarg("invalid mcast_query_interval",
+				       *argv);
+			addattr64(&req.n, 1024,
+				  BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL,
+				  val64);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -844,6 +853,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 			     "mcast_querier_interval %llu ",
 			     rta_getattr_u64(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL];
+		print_lluint(PRINT_ANY, "mcast_query_interval",
+			     "mcast_query_interval %llu ",
+			     rta_getattr_u64(vattr));
+	}
 	print_nl();
 	close_json_object();
 }
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index f5c72ec83f93..cb1170f8d5c9 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -173,7 +173,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B mcast_membership_interval
 .IR MEMBERSHIP_INTERVAL " ] [ "
 .B mcast_querier_interval
-.IR QUERIER_INTERVAL " ]"
+.IR QUERIER_INTERVAL " ] [ "
+.B mcast_query_interval
+.IR QUERY_INTERVAL " ]"
 
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
@@ -981,6 +983,11 @@ after this delay has passed, the bridge will start to send its own queries
 .BI mcast_querier
 was enabled).
 
+.TP
+.BI mcast_query_interval " QUERY_INTERVAL "
+interval between queries sent by the bridge after the end of the
+startup phase.
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

