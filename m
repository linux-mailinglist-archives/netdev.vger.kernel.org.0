Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31CB57401B
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 01:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiGMXks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 19:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiGMXkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 19:40:47 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A30509C1;
        Wed, 13 Jul 2022 16:40:46 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso597165pjk.3;
        Wed, 13 Jul 2022 16:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wCM0UDHUVihBgY7YWogvcLCrLbNF9p6xLuztOGFMvkI=;
        b=NRoJ+UDhRHy76a4NDta3han9YBZ/XI48D458cpbWyqf78sPEzf7J11OD2gxerrpeIH
         u0ew6cdFtZ/kpyL0J7FgaGDETdPeNXDLFGnm3Barq78fwAMDo45SQxXO/rP3v8I5nKAJ
         RdXhvR40A/vJYjM/JHb9rfGuKOi3RZd/SqIKqlURToGI5c4t32lF3zXcg/8nRt9uIAYY
         7GrYLhjWMRmPxZ1ATrayMdkSF4nHkJzm8yEdn8ZEH2D5Xnj+PlMQXPaZZKghirEr8/IG
         u8a5RrUm6LLcbWmp7iyXGW4WdHIS/3eNsOVRpPt+Ds2KV65XwOVwykUn/3u+FyVLiTNH
         0+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wCM0UDHUVihBgY7YWogvcLCrLbNF9p6xLuztOGFMvkI=;
        b=55bjfnGa9F+btT5xXY7ManCJcDWhmEPiQSqkp/jFvERahiCayiPqyIUvBqdT7dCXYZ
         KlcYXF4vVslpHmNYqMZ1PqFS8AHKeUMDmvxLmyXDnm50n0Csteox+hacpERdp4UNWrW5
         +Kny1STuKI9MDQ9Iuq/ic5tqWYEuW0B5vJzKF8tB8TocP9JzIdBTx3titky8HH9oZDnH
         avru4fLeEdHbf5lPpeUay+1kELKznh4vqB9l3kE6iwlDa2fNpAHvsagnovceDfezIsNU
         owEKaa8FIosi9op2t9fUQvWTzmweKLaQuIWERt5jqYUPxUYKuhG8+VzD5cyRjPxbAS2/
         X86Q==
X-Gm-Message-State: AJIora/rxcqp8cNTJxViScZgsJChpglLR/3ElI1fJEb3DMMSMl3rMJEg
        LHY6ha5A0R3aCthSnqeY0BZ0ZXOXtkZH/jrNDTI=
X-Google-Smtp-Source: AGRyM1vxMiPvZqkn2A8ffZQTH6vgXFh3gLcPVtDqEqjmO8KcOngWL/INdw62fpEVTVakBqwNasBDwg==
X-Received: by 2002:a17:902:7d92:b0:16c:54a4:bb2f with SMTP id a18-20020a1709027d9200b0016c54a4bb2fmr5828227plm.158.1657755645829;
        Wed, 13 Jul 2022 16:40:45 -0700 (PDT)
Received: from localhost.localdomain ([64.141.80.140])
        by smtp.gmail.com with ESMTPSA id 188-20020a6216c5000000b005286a4ca9c8sm87653pfw.211.2022.07.13.16.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 16:40:45 -0700 (PDT)
From:   Jaehee Park <jhpark1013@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        dsahern@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, linux-kernel@vger.kernel.org,
        aajith@arista.com, roopa@nvidia.com, roopa.prabhu@gmail.com,
        aroulin@nvidia.com, sbrivio@redhat.com, jhpark1013@gmail.com
Subject: [PATCH v3 net-next 1/3] net: ipv4: new arp_accept option to accept garp only if in-network
Date:   Wed, 13 Jul 2022 16:40:47 -0700
Message-Id: <93cfe14597ec1205f61366b9902876287465f1cd.1657755189.git.jhpark1013@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1657755188.git.jhpark1013@gmail.com>
References: <cover.1657755188.git.jhpark1013@gmail.com>
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

