Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC9F505FAE
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 00:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiDRWVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 18:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiDRWVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 18:21:38 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0E329C9C
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 15:18:58 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id q3so19445085wrj.7
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 15:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KtCf0a7G5u0Al6s9IKgoi3Lmg+sNYco6ucwfazquBRI=;
        b=pbgzS6oGbY64qQnlmYEg8JJV48WzkkD+06iB60rPFUS0rGB4aCJ46y5n9Rs9bdB79g
         XFtpUNVDXXWMqRKwYbBTRelNTTjb+7SuoSr/a5S2COLAlIdEF2vQb5NoRLputvXbE2zm
         J8Amx2q08GeN/+4zu6EEZQI7Njy49msc5NZXjFueOPsiA2xYleW989pR7TERdgJ8Rmim
         1tbHWVx0rPcoeRUBnscFAlSaBSVCiSVg2AJLADgMbuSxN0P+B18H+H91JOffSfMtoZMn
         b3GBfXbpRj+9BGTQTFZkt+lcX63yXP+iQupQ+II9ybwcHUomDSyeOXzYgaiuey74nqnL
         vr2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KtCf0a7G5u0Al6s9IKgoi3Lmg+sNYco6ucwfazquBRI=;
        b=xdn3UavuG1TlOv9NE6/yQ48n4T3BA7PZvrljaeAraoNebmYeeley9fX6jEskKY5q0s
         QkD30Td8d5zKzChqzfDm5ufRWkDeBrkcY6a5b+QrRir6E878MFTCtwSqRCzze/fG7K48
         kA/oX6EXxNFZLLjuz41gZuuA41MzJgzlnSzTkOBLc2kpUPgasf8kgFWL/i2snVBYsH07
         K765yNvppiKLNwsxNJLOAIzLMk+QqKqKuS2ODc3bte09hLRpaL6J11QEhOYtVIdfqRHg
         rbufu9vnFJvJHPGb8dm9lwLof6/b9N32pVpWUamHhwuQT+Fk41OQPLfRKr5eDWFQr+zW
         X+vQ==
X-Gm-Message-State: AOAM53175H/nTI+y4KR7P3ibsSlYoIQzoNgcyrZN8GAk33O3OxvEyfL5
        9Pa+ehPNyn6s305BiyLi1CTWxrHhWf0=
X-Google-Smtp-Source: ABdhPJwcIZyqAluOjnkeyfewf2x+J8zTK5LDVfG9HWCI6fGqBPdn6rWnDDvLi1zL5ALDvr+oKc1SYA==
X-Received: by 2002:a05:6000:100c:b0:207:a2aa:8d15 with SMTP id a12-20020a056000100c00b00207a2aa8d15mr9438609wrx.394.1650320336600;
        Mon, 18 Apr 2022 15:18:56 -0700 (PDT)
Received: from localhost.localdomain (82-64-45-45.subs.proxad.net. [82.64.45.45])
        by smtp.googlemail.com with ESMTPSA id u16-20020a05600c441000b0038ebcbadcedsm26008921wmn.2.2022.04.18.15.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 15:18:56 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Baligh Gasmi <gasmibal@gmail.com>
Subject: [PATCH v2] ip/iplink_virt_wifi: add support for virt_wifi
Date:   Tue, 19 Apr 2022 00:18:54 +0200
Message-Id: <20220418221854.1827-1-gasmibal@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220418080642.4093224e@hermes.local>
References: <20220418080642.4093224e@hermes.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for creating virt_wifi devices type.

Syntax:
$ ip link add link eth0 name wlan0 type virt_wifi

Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
---
 ip/Makefile           |  2 +-
 ip/iplink.c           |  2 +-
 ip/iplink_virt_wifi.c | 26 ++++++++++++++++++++++++++
 man/man8/ip-link.8.in |  6 +++++-
 4 files changed, 33 insertions(+), 3 deletions(-)
 create mode 100644 ip/iplink_virt_wifi.c

diff --git a/ip/Makefile b/ip/Makefile
index 0f14c609..e06a7c84 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -12,7 +12,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
     ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o ipioam6.o \
-    iplink_amt.o iplink_batadv.o iplink_gtp.o
+    iplink_amt.o iplink_batadv.o iplink_gtp.o iplink_virt_wifi.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/iplink.c b/ip/iplink.c
index 7accd378..dc76a12b 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -57,7 +57,7 @@ void iplink_types_usage(void)
 		"          macsec | macvlan | macvtap |\n"
 		"          netdevsim | nlmon | rmnet | sit | team | team_slave |\n"
 		"          vcan | veth | vlan | vrf | vti | vxcan | vxlan | wwan |\n"
-		"          xfrm }\n");
+		"          xfrm | virt_wifi }\n");
 }
 
 void iplink_usage(void)
diff --git a/ip/iplink_virt_wifi.c b/ip/iplink_virt_wifi.c
new file mode 100644
index 00000000..dce14462
--- /dev/null
+++ b/ip/iplink_virt_wifi.c
@@ -0,0 +1,26 @@
+/*
+ * iplink_virt_wifi.c	A fake implementation of cfg80211_ops that can be tacked
+ *                      on to an ethernet net_device to make it appear as a
+ *                      wireless connection.
+ *
+ * Authors:            Baligh Gasmi <gasmibal@gmail.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "utils.h"
+#include "ip_common.h"
+
+static void virt_wifi_print_help(struct link_util *lu,
+		int argc, char **argv, FILE *f)
+{
+	fprintf(f, "Usage: ... virt_wifi \n");
+}
+
+struct link_util virt_wifi_link_util = {
+	.id		= "virt_wifi",
+	.print_help	= virt_wifi_print_help,
+};
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index ee189abc..5fb4dcd3 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -244,7 +244,8 @@ ip-link \- network device configuration
 .BR netdevsim " |"
 .BR rmnet " |"
 .BR xfrm " |"
-.BR gtp " ]"
+.BR gtp " |"
+.BR virt_wifi " ]"
 
 .ti -8
 .IR ETYPE " := [ " TYPE " |"
@@ -396,6 +397,9 @@ Link types:
 .sp
 .BR gtp
 - GPRS Tunneling Protocol
+.sp
+.B virt_wifi
+- rtnetlink wifi simulation device
 .in -8
 
 .TP
-- 
2.25.1

