Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1169F3FA544
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhH1LJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbhH1LJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:20 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A5EC061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:29 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id u14so19576886ejf.13
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RL0Ykyepjo0ReLcdadP3sSZUjYtB0kKQ6g5gVk7UV1c=;
        b=XVA+sW+P1RTP0l15Jm68Hdgi4K8ANUlk8npENFd+otgtgTv/5Q4PFPNK8DhGnwTuIN
         DtfziNH5HDBl9gZ3N5CcBXezuw7JNsVJe0+RCvCepZn1FLwxzUbzGXhSGWsFu0EiVwfY
         AcFXL/ulvFu2fgxnBXvv824cU1QrjCZvP/AEf+QDIg+jOl4UzR+CL3lzlZHpgEJL5pae
         g0TvK/VPV5rAqpjN9JI2v55F5iFP27B/mAz/cw2j8GwpxdlP2TBToObtIJQQF1c4ZCro
         f7rHmplvVwZ1eqzePkxOHMkedkUGPR/WGLECpoqFLZcm8QEPe/cnhzziag9OVOsBkKeB
         gqPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RL0Ykyepjo0ReLcdadP3sSZUjYtB0kKQ6g5gVk7UV1c=;
        b=sVfRYR6DXyrGFl6fYt1+0cm4fDLYBFEQfPvtAjvnbWen4ze0YEFWsFz/MZigo86lXw
         1TuVuPdNJ7Od/KN1a+f9VnObrawi5dO85IZu1rdsVIX29Edw5Ceo4LVVgQh92qALbIm5
         3uWFTTydMGcvIXk4j3cHk9wYAMFUZAGgtK7AXCgt+u/hJEpnl+fT4VA/ZW+dpt3OGFdb
         dLbHD1JmydbLXp6joXkzgAllwF4zAJlnxy+QJMUjEr+1hZpp68vNGkfuIczUsLOVeRwd
         YxHEfJkozTEhBLMJ6oBIuB9K97rL/YrGWaLPOl4RhZbJgQSQZhw5qCC8efj0kyFoEvtJ
         5c/Q==
X-Gm-Message-State: AOAM531LIVVM0ZF5qxdZH8zl6JmzGCZPR5MKzhhwJWtvXLGEWQWiNW3G
        AOua5iB29qUcrgpoMmwdkpo6gmXyeIMvXgSl
X-Google-Smtp-Source: ABdhPJyoOpJhvIipupykJNdL50ob6z+Qbh5u5iJzwAOEwTiT72ZMAS8ZIrK+Oxg5gtdm6JxDhD/ZgA==
X-Received: by 2002:a17:906:c054:: with SMTP id bm20mr14715597ejb.203.1630148907851;
        Sat, 28 Aug 2021 04:08:27 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:27 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 12/19] bridge: vlan: add global mcast_last_member_interval option
Date:   Sat, 28 Aug 2021 14:07:58 +0300
Message-Id: <20210828110805.463429-13-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_last_member_interval
option which controls the interval between queries to find remaining
members of a group after a leave message. To be consistent with the same
bridge-wide option the value is reported with USER_HZ granularity and
the same granularity is expected when setting it.
The default is 100 (1 second).
Syntax:
 $ bridge vlan global set dev bridge vid 1 mcast_last_member_interval 200

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: adjust help msg alignment to fit in 100 columns

 bridge/vlan.c     | 16 ++++++++++++++++
 man/man8/bridge.8 |  7 +++++++
 2 files changed, 23 insertions(+)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 2c6ebedd2d5f..2a3dffdbac44 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -43,6 +43,7 @@ static void usage(void)
 		"                      [ mcast_igmp_version IGMP_VERSION ]\n"
 		"                      [ mcast_mld_version MLD_VERSION ]\n"
 		"                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
+		"                      [ mcast_last_member_interval LAST_MEMBER_INTERVAL ]\n"
 		"                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
@@ -361,6 +362,7 @@ static int vlan_global_option_set(int argc, char **argv)
 	short vid_end = -1;
 	char *d = NULL;
 	short vid = -1;
+	__u64 val64;
 	__u32 val32;
 	__u8 val8;
 
@@ -438,6 +440,14 @@ static int vlan_global_option_set(int argc, char **argv)
 			addattr32(&req.n, 1024,
 				  BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT,
 				  val32);
+		} else if (strcmp(*argv, "mcast_last_member_interval") == 0) {
+			NEXT_ARG();
+			if (get_u64(&val64, *argv, 0))
+				invarg("invalid mcast_last_member_interval",
+				       *argv);
+			addattr64(&req.n, 1024,
+				  BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL,
+				  val64);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -792,6 +802,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 			   "mcast_last_member_count %u ",
 			   rta_getattr_u32(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL];
+		print_lluint(PRINT_ANY, "mcast_last_member_interval",
+			     "mcast_last_member_interval %llu ",
+			     rta_getattr_u64(vattr));
+	}
 	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT]) {
 		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT];
 		print_uint(PRINT_ANY, "mcast_startup_query_count",
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 7741382321cb..0d973a9db0e0 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -166,6 +166,8 @@ bridge \- show / manipulate bridge addresses and devices
 .IR MLD_VERSION " ] [ "
 .B mcast_last_member_count
 .IR LAST_MEMBER_COUNT " ] [ "
+.B mcast_last_member_interval
+.IR LAST_MEMBER_INTERVAL " ] [ "
 .B mcast_startup_query_count
 .IR STARTUP_QUERY_COUNT " ]"
 
@@ -953,6 +955,11 @@ set multicast last member count, ie the number of queries the bridge
 will send before stopping forwarding a multicast group after a "leave"
 message has been received. Default is 2.
 
+.TP
+.BI mcast_last_member_interval " LAST_MEMBER_INTERVAL "
+interval between queries to find remaining members of a group,
+after a "leave" message is received.
+
 .TP
 .BI mcast_startup_query_count " STARTUP_QUERY_COUNT "
 set the number of queries to send during startup phase. Default is 2.
-- 
2.31.1

