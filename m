Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916D93FA54D
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbhH1LJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbhH1LJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:23 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3831EC061796
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:33 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u3so19574413ejz.1
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dt1a/WlIFyW5VTFVG6w4NhMp+2geq96Q/2tjj7O5Ugw=;
        b=F4O/BvA5CKAmOsCQIA168zL9+/7FKlFXfFoRfGq15Wkn7kRdwVYfdnjrZY8wJoEtMa
         zgDY8+BqmQTMSkZm9RGSauZn5zO/eVDmke9cLDu5eypJ4PULFW8Wf+FEBt0BttomHmtc
         iRMeDAaDXkUy7bbb7YwCc425HhZRaOKtPW0mCSrpZVT/oQAOhcREPJ+iKZCCeAkPfQZP
         ALXIRqtGf6598eZhfzuXguMUTSuGhCvTKqpZJHGo0kszhi9BU3DQZdHMOtr/R0BewMj0
         NfSn9oi+KawsKQnGMMHDvPPZ+ig3fQMoNYvVU7uVwdNXcbE51m6UF1FiMBSc1UB+SSeL
         NFlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dt1a/WlIFyW5VTFVG6w4NhMp+2geq96Q/2tjj7O5Ugw=;
        b=IBjLpt6LHmMbUedmNbt3gC8JQu+ouDHFsyljlEsffOBScD4PfCC+0KD9MY87fkS91J
         JRpocu58dTb83O5kQ1tzHztpL1rClCFSbfzIpjLK2JNuK4GNYc2Mct6sM2QBac7sbQwv
         oDNSSRN09jjHfx5HiDjENurck9pbS1VEWfU0JqWPxAlfzL8ZWrx+DVzJ42yCElBog/4Y
         LHKkvM6UL4iwmBUkrabya6ayXvfQBP/Ymf2G+gCg9p9ab3dzYfZndUcmRL91GpV5TimH
         UvsgKZPS6o1FVraLTXed9+FDsO80tQAV1N2TLoCwP3DaLD64YTC/x9YA/9gEbd5F3jvx
         BsGw==
X-Gm-Message-State: AOAM533QiWRK0NZ+gWcUFfYjWgU+551U0/Z9iCGzYuGuGYvw4oQLVjlN
        dSsJekWwlJ2dn0XLa6ZlhOqva3gjIoX9z93A
X-Google-Smtp-Source: ABdhPJxXFzJTzPDSYBuBKNq4HNcXaJ/qlVqCKKejF2vSm8h2yK4J47d+LM6wLTBiCTen0u9kpgQUHw==
X-Received: by 2002:a17:906:3708:: with SMTP id d8mr15301345ejc.310.1630148911603;
        Sat, 28 Aug 2021 04:08:31 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:31 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 16/19] bridge: vlan: add global mcast_query_response_interval option
Date:   Sat, 28 Aug 2021 14:08:02 +0300
Message-Id: <20210828110805.463429-17-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
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
v2: adjust help msg alignment to fit in 100 columns

 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 |  9 ++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index d7fb27ea752a..7f6845158bf0 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -48,6 +48,7 @@ static void usage(void)
 		"                      [ mcast_membership_interval MEMBERSHIP_INTERVAL ]\n"
 		"                      [ mcast_querier_interval QUERIER_INTERVAL ]\n"
 		"                      [ mcast_query_interval QUERY_INTERVAL ]\n"
+		"                      [ mcast_query_response_interval QUERY_RESPONSE_INTERVAL ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -475,6 +476,14 @@ static int vlan_global_option_set(int argc, char **argv)
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
@@ -859,6 +868,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
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

