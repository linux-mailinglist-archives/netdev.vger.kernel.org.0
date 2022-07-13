Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EA6573FA8
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237261AbiGMWhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237169AbiGMWhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:37:18 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233DD12D37;
        Wed, 13 Jul 2022 15:37:17 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so6080527pjl.5;
        Wed, 13 Jul 2022 15:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wCM0UDHUVihBgY7YWogvcLCrLbNF9p6xLuztOGFMvkI=;
        b=eV5m75sqAFnxepzIK8VLkfPhxD4p+KPRRpfvA2DYLoWAS+ZPSNM7gcKMdEkJcrV7n+
         iSWv7AOzPFr6txsjFrpftnxXpn+qeOQunSe/oqynkZNOKga7Jd2pj4J2YPr65SMzD2ol
         tJhROGIjKyuCjp3LQATq1AgTXj9N4jhzvcBeANAAo6D9OxO+hlT0gok+r/vrRGv9BgYj
         zvzH882xXa0D0J9OWr2O8P2WJ3kqPpifI/b3fjTG5Tg/2MH7Nma6C65B9yILrkfJzfmV
         V6AKcPZGYcFZ4ciejkFAY9RmoCUbT6ET34hbI28ENHt7YIa+EoI4mcn08klYl0bEOK1Y
         IvdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wCM0UDHUVihBgY7YWogvcLCrLbNF9p6xLuztOGFMvkI=;
        b=Mrm8+bkpr5J30dPZom2bHYZElk1wN9PMsQ/OJgmcA18F41fvffT5tUpFxgcADnpg7X
         UDzJ7W2qCmRDO6SvQXhr8oU+HXTZWLuiV3PEH3d66qLavRpyxLHLq5byArIIZzmPTWXA
         ybSdbS/iK37VjQJy1vSfVmZGOckirVoxjbceNnIt2cafCDZ8Veqp7j7774IRy4/Zwqaw
         Dozjgj7oOLu0M/+OBz/T0JoXSuhiLVHSzIDlQ8nO1zRK5+mA9qVULCJxfIjx7WTxqOQ9
         y5hvhZhByODBNsX9e7in0SkhiasZFF/nS16c7+1u/92RKspnGZ+6GQmLYuFpsxRgJR0B
         Vtmw==
X-Gm-Message-State: AJIora+9BNdsQljh0KsA3+pNxYrcYnD8Icmo18ZLw/DTLKj+Vez84htc
        9szz4vAfuCJ2tv9aM6z7lz/KJKF/1NfZXyxRhb4=
X-Google-Smtp-Source: AGRyM1tOa8OeT+pA1jmPBaIK1AweL/xm29HNIZcuZIjrCD7/FkUl9EiZKX62m/uN6TT6yOHbWghpsA==
X-Received: by 2002:a17:902:a413:b0:156:15b:524a with SMTP id p19-20020a170902a41300b00156015b524amr5369620plq.106.1657751836372;
        Wed, 13 Jul 2022 15:37:16 -0700 (PDT)
Received: from localhost.localdomain ([64.141.80.140])
        by smtp.gmail.com with ESMTPSA id b18-20020aa78ed2000000b00525302fe9c4sm38639pfr.190.2022.07.13.15.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 15:37:15 -0700 (PDT)
From:   Jaehee Park <jhpark1013@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        dsahern@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, linux-kernel@vger.kernel.org,
        aajith@arista.com, roopa@nvidia.com, roopa.prabhu@gmail.com,
        aroulin@nvidia.com, sbrivio@redhat.com, jhpark1013@gmail.com
Subject: [PATCH v2 net-next 1/3] net: ipv4: new arp_accept option to accept garp only if in-network
Date:   Wed, 13 Jul 2022 15:37:17 -0700
Message-Id: <93cfe14597ec1205f61366b9902876287465f1cd.1657750543.git.jhpark1013@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1657750543.git.jhpark1013@gmail.com>
References: <cover.1657750543.git.jhpark1013@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In many deployments, we want the option to not learn a neighbor from
garp if the src ip is not in the same subnet as an address configured
on the interface that received the garp message. net.ipv4.arp_accept
sysctl is currently used to control creation of a neigh from a
received garp packet. This patch adds a new option '2' to
net.ipv4.arp_accept which extends option '1' by including the subnet
check.

Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
Suggested-by: Roopa Prabhu <roopa@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst |  9 ++++++---
 include/linux/inetdevice.h             |  2 +-
 net/ipv4/arp.c                         | 24 ++++++++++++++++++++++--
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 4c8bbf5acfd1..5c017fc1e24d 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1633,12 +1633,15 @@ arp_notify - BOOLEAN
 	     or hardware address changes.
 	 ==  ==========================================================
 
-arp_accept - BOOLEAN
-	Define behavior for gratuitous ARP frames who's IP is not
-	already present in the ARP table:
+arp_accept - INTEGER
+	Define behavior for accepting gratuitous ARP (garp) frames from devices
+	that are not already present in the ARP table:
 
 	- 0 - don't create new entries in the ARP table
 	- 1 - create new entries in the ARP table
+	- 2 - create new entries only if the source IP address is in the same
+	  subnet as an address configured on the interface that received the
+	  garp message.
 
 	Both replies and requests type gratuitous arp will trigger the
 	ARP table to be updated, if this setting is on.
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index ead323243e7b..ddb27fc0ee8c 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -131,7 +131,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
 	IN_DEV_ORCONF((in_dev), IGNORE_ROUTES_WITH_LINKDOWN)
 
 #define IN_DEV_ARPFILTER(in_dev)	IN_DEV_ORCONF((in_dev), ARPFILTER)
-#define IN_DEV_ARP_ACCEPT(in_dev)	IN_DEV_ORCONF((in_dev), ARP_ACCEPT)
+#define IN_DEV_ARP_ACCEPT(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_ACCEPT)
 #define IN_DEV_ARP_ANNOUNCE(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_ANNOUNCE)
 #define IN_DEV_ARP_IGNORE(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_IGNORE)
 #define IN_DEV_ARP_NOTIFY(in_dev)	IN_DEV_MAXCONF((in_dev), ARP_NOTIFY)
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index af2f12ffc9ca..87c7e3fc5197 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -429,6 +429,26 @@ static int arp_ignore(struct in_device *in_dev, __be32 sip, __be32 tip)
 	return !inet_confirm_addr(net, in_dev, sip, tip, scope);
 }
 
+static int arp_accept(struct in_device *in_dev, __be32 sip)
+{
+	struct net *net = dev_net(in_dev->dev);
+	int scope = RT_SCOPE_LINK;
+
+	switch (IN_DEV_ARP_ACCEPT(in_dev)) {
+	case 0: /* Don't create new entries from garp */
+		return 0;
+	case 1: /* Create new entries from garp */
+		return 1;
+	case 2: /* Create a neighbor in the arp table only if sip
+		 * is in the same subnet as an address configured
+		 * on the interface that received the garp message
+		 */
+		return !!inet_confirm_addr(net, in_dev, sip, 0, scope);
+	default:
+		return 0;
+	}
+}
+
 static int arp_filter(__be32 sip, __be32 tip, struct net_device *dev)
 {
 	struct rtable *rt;
@@ -868,12 +888,12 @@ static int arp_process(struct net *net, struct sock *sk, struct sk_buff *skb)
 	n = __neigh_lookup(&arp_tbl, &sip, dev, 0);
 
 	addr_type = -1;
-	if (n || IN_DEV_ARP_ACCEPT(in_dev)) {
+	if (n || arp_accept(in_dev, sip)) {
 		is_garp = arp_is_garp(net, dev, &addr_type, arp->ar_op,
 				      sip, tip, sha, tha);
 	}
 
-	if (IN_DEV_ARP_ACCEPT(in_dev)) {
+	if (arp_accept(in_dev, sip)) {
 		/* Unsolicited ARP is not accepted by default.
 		   It is possible, that this option should be enabled for some
 		   devices (strip is candidate)
-- 
2.30.2

