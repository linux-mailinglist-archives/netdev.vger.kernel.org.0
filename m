Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C15505FC6
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 00:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbiDRWbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 18:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiDRWbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 18:31:44 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF0A2AC51
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 15:29:03 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w4so20081150wrg.12
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 15:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d5beLmj5AkW1uzECw07VcK6x4av7qpBuoy2CxSyhUAs=;
        b=SVkpQYmHJrhzP1y57i0t7z4owvbzK6qMLso26vQzgdqaimeVyOYfExn2WcJOMEpNnR
         fXBblrxD5Ne2drpQ+pBgkNunr3b4qkJbIcjvlzr1ZVPoRfw0DCT+muYXWPEdNWKm1i1n
         v9HoGRB59QUHD2vzb7Yu7EosbvfZY4OezDzv6uUYKn8+G1RRfNtNdrDyZcVvBRB4a2vg
         49a/qN/xz9SRKfqBbAJ7olm06ATKQ+S166tSMVUTGu0YYu6M0ms5tBsWPEaTMlSSUGUJ
         yEwkT3J9t3H6lqv3jy6K9zmpu5/5Ehp7DkaQ2zhVsg4Gq1VxK/RDx+aMG7LQ9/gQdZQ7
         CM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d5beLmj5AkW1uzECw07VcK6x4av7qpBuoy2CxSyhUAs=;
        b=Xy3kqCWSpX5374oPwkx5axuf+0eHA96jcHJLhNYZzPWPWkuYE8SXhVsQoKLqj3Yvx3
         EniAlLu73/MV0AUpHXVNuMrNY32EOWExNiCUrnTRUvRadUE33aihnViQxnjcG+t0H5+L
         0/EnJDJjM/LIpkzZ4i9ySagEj0eZyZyGWqfeUAm2llqRXKxGOK81YGq7UNJ2TgPrWh/n
         GySsbYFWz3+W83NgYzqRAzIMnbvOGerPmiMlU+T0jdVc7Y1pcdmFW23p8ZCA+ik3iIsS
         VebfDrbCcRFfl5KqOpR++mlzEu5xvBPDc+eKYDB2Pp23tYkZ8FZPbzA4P2hRIn4afFIF
         0OPQ==
X-Gm-Message-State: AOAM5337Fkarmi4A6Ytv+1fBXO4Wt/fAm//0dKWUh03lIq7i2TNU09Ga
        72D9amlIl2AkAfuID7waMG/tKije8lw=
X-Google-Smtp-Source: ABdhPJzXAyFwZI2SRaO6FQdQViIX+9+nIx49qr5DzmnEAPZOCKbpkknqmvjXe4BZB2dQqFu8YXLwqQ==
X-Received: by 2002:a05:6000:1842:b0:207:9b57:6bbf with SMTP id c2-20020a056000184200b002079b576bbfmr9245075wri.336.1650320942064;
        Mon, 18 Apr 2022 15:29:02 -0700 (PDT)
Received: from localhost.localdomain (82-64-45-45.subs.proxad.net. [82.64.45.45])
        by smtp.googlemail.com with ESMTPSA id y11-20020a056000168b00b0020a919422ccsm5042656wrd.109.2022.04.18.15.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 15:29:01 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Baligh Gasmi <gasmibal@gmail.com>
Subject: [PATCH v3] ip/iplink_virt_wifi: add support for virt_wifi
Date:   Tue, 19 Apr 2022 00:28:59 +0200
Message-Id: <20220418222859.2324-1-gasmibal@gmail.com>
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
index ee189abc..ec3cc429 100644
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
+.BR virt_wifi
+- rtnetlink wifi simulation device
 .in -8
 
 .TP
-- 
2.25.1

