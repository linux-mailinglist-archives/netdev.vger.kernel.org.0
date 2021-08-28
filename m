Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AEE3FA548
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbhH1LJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbhH1LJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:15 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067F1C0617A8
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:25 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id dm15so13824147edb.10
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZPvX4xvAYuHDrdy/StfRSGZZ9Dqb5yZIKAfBkMsrUAY=;
        b=gZwNv+qCQFcGEqFVRekbgU8htPKI7CHBURc4DAH1Qf1NWV/mGIsN5H6GLul7P3DjQg
         cDtzd7ioIOmDJpq0SG8fkm9U35M7C/kPGVtxIgI6A4Hp4Pt2IQKf7ayDPX9jsbtoMMVL
         ORxBCfS3Doe8xsndPyiNg3mSKDSVhpqdBfU5hMAOaU+hPizYFLMTOJpWftmg80IH3utf
         A63dShm4vjGS53Xua44K722OhH++8yLzIdumDkBdqIi7mSwwiyCzYDmXGS4Fx7hihoDP
         K+UO4JZ9KPLDd929aT4icvelUnu3VNMnQIIUW6b5/2HiUpg5BbnW6zBw4gos3UvI1Isq
         8aMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZPvX4xvAYuHDrdy/StfRSGZZ9Dqb5yZIKAfBkMsrUAY=;
        b=LmGEXdvGInQ87srJbvHTSb2n6wyQvx/xWQuPWNvT7JiJQxxd7NrckbVqt1tSVgUtw/
         dVef87nTJ9mg+FWNXW1veqVPnTPqXjGtR5PLnV0OqT6RJ5Uia7ROI8HXlCtfRqbI5NF9
         QaAfgyrZKeDvVWQhWfyHJLAOXmjne9iUL38s8dqSbV02rYB5aHkMV8hi4qJ9coK5gbhW
         f/VcRpVAU284mEK/njDqP4PcjT1rFdKBlQDLV3c8k2CCtToV3xMU3OiNgAYDb/xIoBwW
         IxGDVodq/lgUIKGkBS0k9dz+vqYfJW/O2g5PfQEfIWQpPtAYfPrw4hOkq1ByLzkUo8X8
         Uhzw==
X-Gm-Message-State: AOAM533ufoYcX6xOVUb4PQ2ofFyrg1AiUCHN89iGqFWt6PIcQabJSqEx
        dXlB1kEcV9D9Mn+MhWfc7uG/v0OJFEHcc+iI
X-Google-Smtp-Source: ABdhPJxx1N5mtJl1WnOjB8/jkfVsXLYB12RiV/eh+zR9+hdomRAkKHKiC30FseszF6n/MVE3AA9QKg==
X-Received: by 2002:a50:f0d5:: with SMTP id a21mr563661edm.244.1630148903255;
        Sat, 28 Aug 2021 04:08:23 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:22 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 08/19] bridge: vlan: add global mcast_igmp_version option
Date:   Sat, 28 Aug 2021 14:07:54 +0300
Message-Id: <20210828110805.463429-9-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_igmp_version option
which controls the IGMP version on the vlan (default 2).
Syntax: $ bridge vlan global set dev bridge vid 1 mcast_igmp_version 3

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: adjust help msg alignment to fit in 100 columns

 bridge/vlan.c     | 12 ++++++++++++
 man/man8/bridge.8 |  8 +++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index b1a8cfc4a362..5b97f4a167bd 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -40,6 +40,7 @@ static void usage(void)
 		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan global { set } vid VLAN_ID dev DEV\n"
 		"                      [ mcast_snooping MULTICAST_SNOOPING ]\n"
+		"                      [ mcast_igmp_version IGMP_VERSION ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -406,6 +407,12 @@ static int vlan_global_option_set(int argc, char **argv)
 				invarg("invalid mcast_snooping", *argv);
 			addattr8(&req.n, 1024,
 				 BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING, val8);
+		} else if (strcmp(*argv, "mcast_igmp_version") == 0) {
+			NEXT_ARG();
+			if (get_u8(&val8, *argv, 0))
+				invarg("invalid mcast_igmp_version", *argv);
+			addattr8(&req.n, 1024,
+				 BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION, val8);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -744,6 +751,11 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 		print_uint(PRINT_ANY, "mcast_snooping", "mcast_snooping %u ",
 			   rta_getattr_u8(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION];
+		print_uint(PRINT_ANY, "mcast_igmp_version",
+			   "mcast_igmp_version %u ", rta_getattr_u8(vattr));
+	}
 	print_nl();
 	close_json_object();
 }
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index d894289b2dc2..224647b49843 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -159,7 +159,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B vid
 .IR VID " [ "
 .B mcast_snooping
-.IR MULTICAST_SNOOPING " ]"
+.IR MULTICAST_SNOOPING " ] [ "
+.B mcast_igmp_version
+.IR IGMP_VERSION " ]"
 
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
@@ -931,6 +933,10 @@ turn multicast snooping for VLAN entry with VLAN ID on
 or off
 .RI ( MULTICAST_SNOOPING " == 0). Default is on. "
 
+.TP
+.BI mcast_igmp_version " IGMP_VERSION "
+set the IGMP version. Default is 2.
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

