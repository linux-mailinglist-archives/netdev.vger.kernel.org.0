Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493E53FD7C9
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236252AbhIAKjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235782AbhIAKjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:39:19 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0455CC061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 03:38:23 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id u19so3126353edb.3
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 03:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0qbAjndh2+jmxHkbpCy1/hG88MHkSdQ6vCKeHXY4Lw0=;
        b=zldFIW9Rh54R9CVqGp7ZlMMZZeyjw+LhnlOGs+R6bTD8pcqbkPGJbp3wzg40zrloh1
         d0O2wF4DUGpuVG/HK9gFlk8WZseIPp3/PJXC9qTPwQeQLKOQDgbL0Bj/VNGiiu7N6DGA
         F3VjjCtKwm3cxtK+5H95rAeXodxc0aLsYWvmSk5qz7POsay553uvnmgk7BhePxUsmAg8
         q/cl1mHqRmR1f0lrP39k/Sfwxuh02GgoN69oMh8hsH2dI09U3rSjNUDfI++hXtc9SBeI
         nXW91fS+muscvdj9TUX6mCTShV1PW93gAFr2AbsStw2efO91oGYxza8mEL2FJkVxNwDU
         e+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0qbAjndh2+jmxHkbpCy1/hG88MHkSdQ6vCKeHXY4Lw0=;
        b=Xq1oJwwV5qRe5/u6aFIJeQam4BS6RQHcag6PH2UYsLe/QuMxre+Uew//V5B11S7zaT
         SJ3fuEEy84SH67iBnjNxTS0DJeprdEWjEyLBbixuY/jYwrfjaQ2GxPj6XPGuyiY+hg7/
         3ohxAmdRGMIpSpUl43UlPLYbNe47ONiW2xcQGfS1cmz8ymeCJFGvtqGuPU6kCLRAAKzG
         kMdGLmX5TgmoBWc0HzKeTI60ZDg2ZbV9GV4B5Lz4+t+okq97P7UjBYAIL43uj7KJf5BF
         nZhBJhZjkcbF1pHnBY+xqROTmNxmCc2Fs1EPOBJoUPIffurqyIqV3E0ElSFnd1KwPtfu
         cuDw==
X-Gm-Message-State: AOAM5310cOEFEXasm0ETYfwpj22bcas8b2kJvqiZLfD2Qxz/FKIvuHf5
        u4gfl1k+4mrgRgojRcykMFaJuUF7eckpR4be
X-Google-Smtp-Source: ABdhPJyI6vfkV5cXgQi/B9UVClx5SKxkMgBwaw0wlPyEbeXXskjR5bOWELizHzqVoc+mnkAMu+SzTQ==
X-Received: by 2002:a05:6402:705:: with SMTP id w5mr34960520edx.344.1630492701327;
        Wed, 01 Sep 2021 03:38:21 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id y23sm9580527ejp.115.2021.09.01.03.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 03:38:20 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 2/2] bridge: vlan: add support for mcast_router option
Date:   Wed,  1 Sep 2021 13:38:16 +0300
Message-Id: <20210901103816.1163765-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901103816.1163765-1-razor@blackwall.org>
References: <20210901103816.1163765-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for setting and dumping per-vlan/interface mcast_router
option. It controls the mcast router mode of a vlan/interface pair.
For bridge devices only modes 0 - 2 are allowed. The possible modes
are:
 0 - disabled
 1 - automatic router presence detection (default)
 2 - permanent router
 3 - temporary router (available only for ports)

Example:
 # mark port ens16 as a permanent mcast router for vlan 100
 $ bridge vlan set dev ens16 vid 100 mcast_router 2
 # disable mcast router for port ens16 and vlan 200
 $ bridge vlan set dev ens16 vid 200 mcast_router 0
 $ bridge -d vlan show
 port              vlan-id
 ens16             1 PVID Egress Untagged
                     state forwarding mcast_router 1
                   100
                     state forwarding mcast_router 2
                   200
                     state forwarding mcast_router 0

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c     | 17 ++++++++++++++++-
 man/man8/bridge.8 | 29 ++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 48365bca4c4a..8300f353f1a7 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -36,6 +36,7 @@ static void usage(void)
 		"                                                     [ pvid ] [ untagged ]\n"
 		"                                                     [ self ] [ master ]\n"
 		"       bridge vlan { set } vid VLAN_ID dev DEV [ state STP_STATE ]\n"
+		"                                               [ mcast_router MULTICAST_ROUTER ]\n"
 		"       bridge vlan { show } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan global { set } vid VLAN_ID dev DEV\n"
@@ -334,6 +335,15 @@ static int vlan_option_set(int argc, char **argv)
 			}
 			addattr8(&req.n, sizeof(req), BRIDGE_VLANDB_ENTRY_STATE,
 				 state);
+		} else if (strcmp(*argv, "mcast_router") == 0) {
+			__u8 mcast_router;
+
+			NEXT_ARG();
+			if (get_u8(&mcast_router, *argv, 0))
+				invarg("invalid mcast_router", *argv);
+			addattr8(&req.n, sizeof(req),
+				 BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
+				 mcast_router);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -942,7 +952,7 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 
 static void print_vlan_opts(struct rtattr *a, int ifindex)
 {
-	struct rtattr *vtb[BRIDGE_VLANDB_ENTRY_MAX + 1];
+	struct rtattr *vtb[BRIDGE_VLANDB_ENTRY_MAX + 1], *vattr;
 	struct bridge_vlan_xstats vstats;
 	struct bridge_vlan_info *vinfo;
 	__u16 vrange = 0;
@@ -1006,6 +1016,11 @@ static void print_vlan_opts(struct rtattr *a, int ifindex)
 	print_nl();
 	print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s    ", "");
 	print_stp_state(state);
+	if (vtb[BRIDGE_VLANDB_ENTRY_MCAST_ROUTER]) {
+		vattr = vtb[BRIDGE_VLANDB_ENTRY_MCAST_ROUTER];
+		print_uint(PRINT_ANY, "mcast_router", "mcast_router %u ",
+			   rta_getattr_u8(vattr));
+	}
 	print_nl();
 	if (show_stats)
 		__print_one_vlan_stats(&vstats);
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 76d2fa09d5bc..c3c4ae48aaed 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -145,7 +145,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B vid
 .IR VID " [ "
 .B state
-.IR STP_STATE " ] "
+.IR STP_STATE " ] [ "
+.B mcast_router
+.IR MULTICAST_ROUTER " ]"
 
 .ti -8
 .BR "bridge vlan" " [ " show " | " tunnelshow " ] [ "
@@ -915,6 +917,31 @@ is used during the STP election process. In this state, the vlan will only proce
 STP BPDUs.
 .sp
 
+.TP
+.BI mcast_router " MULTICAST_ROUTER "
+configure this vlan and interface's multicast router mode, note that only modes
+0 - 2 are available for bridge devices.
+A vlan and interface with a multicast router will receive all multicast traffic.
+.I MULTICAST_ROUTER
+may be either
+.sp
+.B 0
+- to disable multicast router.
+.sp
+
+.B 1
+- to let the system detect the presence of routers (default).
+.sp
+
+.B 2
+- to permanently enable multicast traffic forwarding on this vlan and interface.
+.sp
+
+.B 3
+- to temporarily mark this vlan and port as having a multicast router, i.e.
+enable multicast traffic forwarding. This mode is available only for ports.
+.sp
+
 .SS bridge vlan show - list vlan configuration.
 
 This command displays the current VLAN filter table.
-- 
2.31.1

