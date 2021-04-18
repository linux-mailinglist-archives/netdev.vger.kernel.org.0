Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FECF3634F4
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 14:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhDRMDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 08:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhDRMDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 08:03:34 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB830C061760
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:04 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h4so22058948wrt.12
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aX1JtiuKoA7JI8C3Gss56MOs3H4KZoZy+yqmEJ2hMLY=;
        b=r7nu6MLCaLTnRw85lWKjir8JUUy76RwuGt6QCdZ7ahknDjT07N5L0TWGo/vZsd1fU3
         j87Cb2PErI07VkMJENHLt11oPb0KjSHUPWBBfB9+a1mnRhhoOPrRad7rLEFyOgrPISjt
         OVYbpYX/KN6du+VvFQ1nB2MEQdU1XB1YF6DMQFZepwxDGdxj+DdQDtpzM/bPg/5tpO2q
         V8x2xtXrTknE3E1E7AXGLFY5YRkT7ENxWCygjsHr6BKZ4SNv4XhNtT05kK4+e/C0iAp3
         MF3OshFr/35EDBCXjSjyK2QP8bz8xTzKARwIY2IL8GKtuoRqfSzIL7DKskS2LQbaTrmW
         nvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aX1JtiuKoA7JI8C3Gss56MOs3H4KZoZy+yqmEJ2hMLY=;
        b=t7hWsGtT8vXSqYrnZNGe6fH7tUaWgHofb1awDc+GcvK0nMCBnpZlPogVul4SHzG7cM
         G9u2tHPzmchd4lTWKw88fGm6aGzG2CyCokkB3TmqDQZCDSm4O/igHQ32sE8nWiP3GGC4
         R4OkjV9bAxhxKE1fF4S9mFNhKTTEEman8xCZAbg1rcTRxFswbinLOLpQnrrVHKVXg1nr
         vhB33kajXeA0Kw5goTrfqd6cCfRuvp+VV2nUDJ73qBJp7eXfPcNHbLDvtbtghTsZD9aF
         dI4DZwirjR/4UYNfub8kntvL6CDe1djg7Ihknz2FNqRCPXfVkzl1Y5+78G/Xon8VkGi1
         ihyw==
X-Gm-Message-State: AOAM532TZqLhedxlIhMM6k2nnRnPY10yueaL7P1ebHkPBn52Vf6P3asz
        GghyiTz9vy9fBUea/uUPPWG05Dn6Y/vcgYDA
X-Google-Smtp-Source: ABdhPJz3trNwWSubjd9YK0wT0aihM8sjiKVuRSZWOEe31aVYK7ZMyNyElKQUU2f8b+/SCgYIw53m3w==
X-Received: by 2002:adf:fecd:: with SMTP id q13mr8897001wrs.7.1618747383209;
        Sun, 18 Apr 2021 05:03:03 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x25sm16584763wmj.34.2021.04.18.05.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 05:03:02 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 1/6] bridge: rename and export print_portstate
Date:   Sun, 18 Apr 2021 15:01:32 +0300
Message-Id: <20210418120137.2605522-2-razor@blackwall.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418120137.2605522-1-razor@blackwall.org>
References: <20210418120137.2605522-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Rename print_portstate to print_stp_state in preparation for use by vlan
code as well (per-vlan state), and export it. To be in line with the new
naming rename also port_states to stp_states as they'll be used for
vlans, too.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/br_common.h |  1 +
 bridge/link.c      | 14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/bridge/br_common.h b/bridge/br_common.h
index b5798da300e8..e3f46765ab89 100644
--- a/bridge/br_common.h
+++ b/bridge/br_common.h
@@ -10,6 +10,7 @@ void print_vlan_info(struct rtattr *tb, int ifindex);
 int print_linkinfo(struct nlmsghdr *n, void *arg);
 int print_mdb_mon(struct nlmsghdr *n, void *arg);
 int print_fdb(struct nlmsghdr *n, void *arg);
+void print_stp_state(__u8 state);
 
 int do_fdb(int argc, char **argv);
 int do_mdb(int argc, char **argv);
diff --git a/bridge/link.c b/bridge/link.c
index d88c469db78e..a8cfa1814986 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -19,7 +19,7 @@
 
 static unsigned int filter_index;
 
-static const char *port_states[] = {
+static const char *stp_states[] = {
 	[BR_STATE_DISABLED] = "disabled",
 	[BR_STATE_LISTENING] = "listening",
 	[BR_STATE_LEARNING] = "learning",
@@ -68,11 +68,11 @@ static void print_link_flags(FILE *fp, unsigned int flags, unsigned int mdown)
 	close_json_array(PRINT_ANY, "> ");
 }
 
-static void print_portstate(__u8 state)
+void print_stp_state(__u8 state)
 {
 	if (state <= BR_STATE_BLOCKING)
 		print_string(PRINT_ANY, "state",
-			     "state %s ", port_states[state]);
+			     "state %s ", stp_states[state]);
 	else
 		print_uint(PRINT_ANY, "state",
 			     "state (%d) ", state);
@@ -96,7 +96,7 @@ static void print_protinfo(FILE *fp, struct rtattr *attr)
 		parse_rtattr_nested(prtb, IFLA_BRPORT_MAX, attr);
 
 		if (prtb[IFLA_BRPORT_STATE])
-			print_portstate(rta_getattr_u8(prtb[IFLA_BRPORT_STATE]));
+			print_stp_state(rta_getattr_u8(prtb[IFLA_BRPORT_STATE]));
 
 		if (prtb[IFLA_BRPORT_PRIORITY])
 			print_uint(PRINT_ANY, "priority",
@@ -161,7 +161,7 @@ static void print_protinfo(FILE *fp, struct rtattr *attr)
 			print_on_off(PRINT_ANY, "isolated", "isolated %s ",
 				     rta_getattr_u8(prtb[IFLA_BRPORT_ISOLATED]));
 	} else
-		print_portstate(rta_getattr_u8(attr));
+		print_stp_state(rta_getattr_u8(attr));
 }
 
 
@@ -359,12 +359,12 @@ static int brlink_modify(int argc, char **argv)
 		} else if (strcmp(*argv, "state") == 0) {
 			NEXT_ARG();
 			char *endptr;
-			size_t nstates = ARRAY_SIZE(port_states);
+			size_t nstates = ARRAY_SIZE(stp_states);
 
 			state = strtol(*argv, &endptr, 10);
 			if (!(**argv != '\0' && *endptr == '\0')) {
 				for (state = 0; state < nstates; state++)
-					if (strcasecmp(port_states[state], *argv) == 0)
+					if (strcasecmp(stp_states[state], *argv) == 0)
 						break;
 				if (state == nstates) {
 					fprintf(stderr,
-- 
2.30.2

