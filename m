Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1EA57401C
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 01:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiGMXkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 19:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbiGMXkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 19:40:49 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC934528A5;
        Wed, 13 Jul 2022 16:40:47 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x18-20020a17090a8a9200b001ef83b332f5so6374924pjn.0;
        Wed, 13 Jul 2022 16:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rvr6j7UaN5VGV3LHJmM0Oblok56ZT0nZGaQ8H5yP6gw=;
        b=e6DKHKzpwAs/7f9mhdiQ870XsKSagrYyVl9qYpIxr4Ejw1SLMtatqeoiY+Sm2zVx9o
         q72Qp2RDXrZpjax1LiaJfbKLAP679L+mL4HQmBb/xOigj2ctUP5jYwFxWrnlrbSU5duZ
         jaFZgySMTFPZ9Jxo5B3vsOJsjRkg+Ld6rvrvVDINRqrZeJytXSRWzlSywEcv1Mw+PPv5
         O/IGcNOFQ21PNCGMpoIzU+z6LfvdJONyiQXFT6/bmnR+Al25LcgAOd8YnI+EoZTtcjHC
         hfnIqcdD7cAEDW/zQyqzCOsXi8f/SDqgRtcBLZLfaQJsZVFGVZXlTo8CdTj0a3hBBTCO
         2v3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rvr6j7UaN5VGV3LHJmM0Oblok56ZT0nZGaQ8H5yP6gw=;
        b=p2SPiYow8slK7lD/3T7cxfpuM7rQAb5Bf0flyJmdWZ+rTZcQVDD9k8tKd/biidTqJ6
         MrScuDT7NJYZA8V64MFHTd02fR9PNczOAg005/RTn/yMD/GFC9XgO9Cf/REKLxZqIG9p
         mlJAZuNH5aXJasG/GWUmpWP7FGTIxhqcFUTusze//PCWrkOQXTYmzKiXzM+/FBxUiZt2
         KE1aIpdLuiZBW63tpI1PJ64JehJYvp6s4tniI0D3HJq6MKPynec5fOKlGu/RljQiil3+
         aAwMsFOOee6BzN3tJjNlPDjPw/I9GKNBothxQrxNG4ePPA2avcVcJIOe/+mVvDpYTPbJ
         OBtw==
X-Gm-Message-State: AJIora/C1Zxm4yRjFgxGS8Q7mNgfKDb9fshabir59RDhyxFWI0/td3um
        5Tz9kdEF4W/lVdN3XBuQLjVLelQ/7u0cO7NnWiY=
X-Google-Smtp-Source: AGRyM1v+9qWneCOZM+owxR4yA8hvmWMHcmKy3dtpz/i21W/dCe+TP3H/Imvsfn8nTgNnW/0DaqUKlQ==
X-Received: by 2002:a17:90b:4c48:b0:1ef:c839:c68c with SMTP id np8-20020a17090b4c4800b001efc839c68cmr6356141pjb.233.1657755647046;
        Wed, 13 Jul 2022 16:40:47 -0700 (PDT)
Received: from localhost.localdomain ([64.141.80.140])
        by smtp.gmail.com with ESMTPSA id 188-20020a6216c5000000b005286a4ca9c8sm87653pfw.211.2022.07.13.16.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 16:40:46 -0700 (PDT)
From:   Jaehee Park <jhpark1013@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        dsahern@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, linux-kernel@vger.kernel.org,
        aajith@arista.com, roopa@nvidia.com, roopa.prabhu@gmail.com,
        aroulin@nvidia.com, sbrivio@redhat.com, jhpark1013@gmail.com
Subject: [PATCH v3 net-next 2/3] net: ipv6: new accept_untracked_na option to accept na only if in-network
Date:   Wed, 13 Jul 2022 16:40:48 -0700
Message-Id: <56d57be31141c12e9034cfa7570f2012528ca884.1657755189.git.jhpark1013@gmail.com>
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

This patch adds a third knob, '2', which extends the
accept_untracked_na option to learn a neighbor only if the src ip is
in the same subnet as an address configured on the interface that
received the neighbor advertisement. This is similar to the arp_accept
configuration for ipv4.

Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
Suggested-by: Roopa Prabhu <roopa@nvidia.com>
---
 Documentation/networking/ip-sysctl.rst | 51 +++++++++++++++-----------
 net/ipv6/addrconf.c                    |  2 +-
 net/ipv6/ndisc.c                       | 29 ++++++++++++---
 3 files changed, 55 insertions(+), 27 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 5c017fc1e24d..722ec4f491db 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2483,27 +2483,36 @@ drop_unsolicited_na - BOOLEAN
 
 	By default this is turned off.
 
-accept_untracked_na - BOOLEAN
-	Add a new neighbour cache entry in STALE state for routers on receiving a
-	neighbour advertisement (either solicited or unsolicited) with target
-	link-layer address option specified if no neighbour entry is already
-	present for the advertised IPv6 address. Without this knob, NAs received
-	for untracked addresses (absent in neighbour cache) are silently ignored.
-
-	This is as per router-side behaviour documented in RFC9131.
-
-	This has lower precedence than drop_unsolicited_na.
-
-	This will optimize the return path for the initial off-link communication
-	that is initiated by a directly connected host, by ensuring that
-	the first-hop router which turns on this setting doesn't have to
-	buffer the initial return packets to do neighbour-solicitation.
-	The prerequisite is that the host is configured to send
-	unsolicited neighbour advertisements on interface bringup.
-	This setting should be used in conjunction with the ndisc_notify setting
-	on the host to satisfy this prerequisite.
-
-	By default this is turned off.
+accept_untracked_na - INTEGER
+	Define behavior for accepting neighbor advertisements from devices that
+	are absent in the neighbor cache:
+
+	- 0 - (default) Do not accept unsolicited and untracked neighbor
+	  advertisements.
+
+	- 1 - Add a new neighbor cache entry in STALE state for routers on
+	  receiving a neighbor advertisement (either solicited or unsolicited)
+	  with target link-layer address option specified if no neighbor entry
+	  is already present for the advertised IPv6 address. Without this knob,
+	  NAs received for untracked addresses (absent in neighbor cache) are
+	  silently ignored.
+
+	  This is as per router-side behavior documented in RFC9131.
+
+	  This has lower precedence than drop_unsolicited_na.
+
+	  This will optimize the return path for the initial off-link
+	  communication that is initiated by a directly connected host, by
+	  ensuring that the first-hop router which turns on this setting doesn't
+	  have to buffer the initial return packets to do neighbor-solicitation.
+	  The prerequisite is that the host is configured to send unsolicited
+	  neighbor advertisements on interface bringup. This setting should be
+	  used in conjunction with the ndisc_notify setting on the host to
+	  satisfy this prerequisite.
+
+	- 2 - Extend option (1) to add a new neighbor cache entry only if the
+	  source IP address is in the same subnet as an address configured on
+	  the interface that received the neighbor advertisement.
 
 enhanced_dad - BOOLEAN
 	Include a nonce option in the IPv6 neighbor solicitation messages used for
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 88becb037eb6..6ed807b6c647 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7042,7 +7042,7 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.data		= &ipv6_devconf.accept_untracked_na,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec,
 		.extra1		= (void *)SYSCTL_ZERO,
 		.extra2		= (void *)SYSCTL_ONE,
 	},
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index cd84cbdac0a2..98453693e400 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -967,6 +967,25 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 		in6_dev_put(idev);
 }
 
+static int accept_untracked_na(struct net_device *dev, struct in6_addr *saddr)
+{
+	struct inet6_dev *idev = __in6_dev_get(dev);
+
+	switch (idev->cnf.accept_untracked_na) {
+	case 0: /* Don't accept untracked na (absent in neighbor cache) */
+		return 0;
+	case 1: /* Create new entries from na if currently untracked */
+		return 1;
+	case 2: /* Create new entries from untracked na only if saddr is in the
+		 * same subnet as an address configured on the interface that
+		 * received the na
+		 */
+		return !!ipv6_chk_prefix(saddr, dev);
+	default:
+		return 0;
+	}
+}
+
 static void ndisc_recv_na(struct sk_buff *skb)
 {
 	struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
@@ -1061,11 +1080,11 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	 * Note that we don't do a (daddr == all-routers-mcast) check.
 	 */
 	new_state = msg->icmph.icmp6_solicited ? NUD_REACHABLE : NUD_STALE;
-	if (!neigh && lladdr &&
-	    idev && idev->cnf.forwarding &&
-	    idev->cnf.accept_untracked_na) {
-		neigh = neigh_create(&nd_tbl, &msg->target, dev);
-		new_state = NUD_STALE;
+	if (!neigh && lladdr && idev && idev->cnf.forwarding) {
+		if (accept_untracked_na(dev, saddr)) {
+			neigh = neigh_create(&nd_tbl, &msg->target, dev);
+			new_state = NUD_STALE;
+		}
 	}
 
 	if (neigh && !IS_ERR(neigh)) {
-- 
2.30.2

