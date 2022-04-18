Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645AE506032
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbiDRX1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234935AbiDRX1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:27:54 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9562AFF
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:25:12 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r4-20020a05600c35c400b0039295dc1fc3so406919wmq.3
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VixvTH8c3s7h5TYQKY+mn+F/MBuvDA9A4on6Alw9lyk=;
        b=nYkyDTPtjLFjv/2iJxkZGNY+EWg1RaoNkqyW5zRXfTXQrqjy4w40Xdo8cy+pEe96rP
         PEnRk8JIfeFwGYRfIgUqG2glpv3oT6TfCDTDDEah3ySGGVjdJ3eJywi2GCXFDL+4Jss5
         9TgOHsndfsydavxcX75UsJlHwWooFB6Eh2uKy5zf96JXaZTC48lEFa+XukNAItTNbJTM
         YebP5eAbnS3nVtO+YSw6KnVff6OqFt0FruGdIaWbeCB+6qED3YvcewXr0TX+KPLBAwvf
         WNhnA9F3vs0Xm4h3z4QXEcPWihFGjL9BG0eIKwYJR/U+8xoqQM8sPvEsqUhcwz8ybFbK
         tAFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VixvTH8c3s7h5TYQKY+mn+F/MBuvDA9A4on6Alw9lyk=;
        b=fPE0mlBE2gmD+a3k9kldt3S0+VSXj1V+SHnYrCkIKs4uwgVUA59vgln6GwSqqpBA+v
         0nkNIfOX8jTo0tUPOw4cJ39lJwbGOUjPiXj6mXQDw+T5+SshIW3CMz8Nk7Omt9KsmoTL
         ikuRMCzM6+1Ov1mZrQdwKL8ocJ/Ha/Uh8qrsCq0D2h1CdJsaiviZhbYqorWhtgHOWWKW
         8A/fpiHffv0BYs9jMm8pHyh04nBblNooZ0lQD3cuSlB/+R44cBcgvQZFe2CdBU6rHk10
         EIWx68eTmlJS8Ye7L7WAvahzUJD5FGSNaWX2pzIzKP9yPPA318EKW6QR4F+ncqh7wYWG
         TO0g==
X-Gm-Message-State: AOAM531JeBgi2lrUxA8uDT349zcKyGeM4anFt3jV4nxF1KzKrP0pE3LR
        b+nOOxCQB4wqGjwhOhptQ+nWpOJBEVk=
X-Google-Smtp-Source: ABdhPJwxfWos4K3OA/rd9WQM5ihdW8/UcNYFqiLaKPTzW+w5px71P8xIj2495TojOm+0sjFgfsZy5A==
X-Received: by 2002:a05:600c:3d96:b0:38f:fbc6:da44 with SMTP id bi22-20020a05600c3d9600b0038ffbc6da44mr17081855wmb.93.1650324310782;
        Mon, 18 Apr 2022 16:25:10 -0700 (PDT)
Received: from localhost.localdomain (82-64-45-45.subs.proxad.net. [82.64.45.45])
        by smtp.googlemail.com with ESMTPSA id 7-20020a056000156700b0020aa549d399sm826911wrz.11.2022.04.18.16.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 16:25:10 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Baligh Gasmi <gasmibal@gmail.com>
Subject: [PATCH v4] ip/iplink_virt_wifi: add support for virt_wifi
Date:   Tue, 19 Apr 2022 01:25:07 +0200
Message-Id: <20220418232507.4047-1-gasmibal@gmail.com>
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
 ip/iplink_virt_wifi.c | 25 +++++++++++++++++++++++++
 man/man8/ip-link.8.in |  6 +++++-
 4 files changed, 32 insertions(+), 3 deletions(-)
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
index 00000000..8d3054cd
--- /dev/null
+++ b/ip/iplink_virt_wifi.c
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * iplink_virt_wifi.c  A fake implementation of cfg80211_ops that can be tacked
+ *                     on to an ethernet net_device to make it appear as a
+ *                     wireless connection.
+ *
+ * Authors:            Baligh Gasmi <gasmibal@gmail.com>
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

