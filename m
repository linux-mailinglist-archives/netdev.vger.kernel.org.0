Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFD1535A71
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346142AbiE0Hb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239463AbiE0Hb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:31:26 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534D14BBB2
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 00:31:24 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so6430130pju.1
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 00:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G4tRmGXGBZTY1FKs0ZLTl+xBxrZfEUU1PXr/8QqRl/U=;
        b=XmyG++mkj5kGjgPxRXG1GuZXBnfkl/PtfvD0sirak+IkeQXEWykg5nAyy0z2OOCVqa
         yZc1jMVb2/jPhrWzaYQdTrPhyIEddEsuI2oEZ+JGUoZ+jOp1XWv9hDHUlu0vsQ7E3ari
         y3gMz9r++bpqmcT61jZ9LPlhy908csCzhY66ej3ec7a4JPV3+ivAXDdF5nYiK0grBQnd
         qj0xEhssNAcIZ5+aWCljoIc4yhWDgPBcw48QJAkd1MJxvqeIeqtPCbOlxG5HToUAsqkL
         AHk7TldhvljwGzlcg5DU2AjnN9nsRGyRGKitLfXf5RitsqUjtJuQWoFlPa4Enzp75+3I
         P6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G4tRmGXGBZTY1FKs0ZLTl+xBxrZfEUU1PXr/8QqRl/U=;
        b=Q2MRVTatCOHjZu9UxrfSkBtSHvdYaVJoNX8hpfMgHccJMmAc6iJEsijqo6EIZImA6b
         Ww53rEaEzE1l6JwrdDu6A4kx9ew0k/Pv51LT6q6RGkUDuNsXhKz19OH8a470HDQ7KEpO
         0ziKOHLOiwmH+gneYr7Kr4kmlmXdTdVs8AVI/95etEaBSJGLjTXZAHKqt2wgaN1S2yWt
         2Hb5SRG3FzUyY5OXnE+TmwkhFKzLgTMYpzxzkIX8FRIL4+PiZCAkFTKln8uI9aAE7jgd
         1uS9SLQyKvEVxNwny8wJ8RmdTKSEAx79EPj+nZ5mYT/hIKCgEp4wemuvAhkpkHmV9zrr
         DaXQ==
X-Gm-Message-State: AOAM530WL6UTyxaJww8YVMTW+ME+k7JLAtzJ13mtuf8RbP5kwt7scZWX
        nSk5YkA/JJLJRsHTg72cB75THRsITEv8owV2
X-Google-Smtp-Source: ABdhPJxGQuWv0hRAJF4SEBa31y/4Ie3cpAxSuj6s9l/Q1+E+7pZ85IbdFKXv4g33cygCp3BjitrGfg==
X-Received: by 2002:a17:902:7c0c:b0:161:ef0f:9da8 with SMTP id x12-20020a1709027c0c00b00161ef0f9da8mr5194041pll.147.1653636683095;
        Fri, 27 May 2022 00:31:23 -0700 (PDT)
Received: from localhost.localdomain ([49.37.162.84])
        by smtp.gmail.com with ESMTPSA id l5-20020a170902f68500b0015e8d4eb1d3sm3025632plg.29.2022.05.27.00.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 00:31:21 -0700 (PDT)
From:   Arun Ajith S <aajith@arista.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, dsahern@kernel.org,
        bagasdotme@gmail.com, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        pabeni@redhat.com, aajith@arista.com, gilligan@arista.com,
        noureddine@arista.com, gk@arista.com
Subject: [PATCH net] net/ipv6: Change accept_unsolicited_na to accept_untracked_na
Date:   Fri, 27 May 2022 07:31:11 +0000
Message-Id: <20220527073111.14336-1-aajith@arista.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 9131 changes default behavior of handling RX of NA messages when the
corresponding entry is absent in the neighbour cache. The current
implementation is limited to accept just unsolicited NAs. However, the
RFC is more generic where it also accepts solicited NAs. Both types
should result in adding a STALE entry for this case.

This change expands the current implementation to match the RFC. The
sysctl knob is also renamed to accept_untracked_na to better reflect the
implementation.

Signed-off-by: Arun Ajith S <aajith@arista.com>
---
This change updates the accept_unsolicited_na feature that merged to net-next
for v5.19 to be better compliant with the RFC. It also involves renaming the sysctl
knob to accept_untracked_na before shipping in a release.

 Documentation/networking/ip-sysctl.rst        |  18 +---
 include/linux/ipv6.h                          |   2 +-
 include/uapi/linux/ipv6.h                     |   2 +-
 net/ipv6/addrconf.c                           |   6 +-
 net/ipv6/ndisc.c                              | 101 ++++++++++--------
 .../net/ndisc_unsolicited_na_test.sh          |  23 ++--
 6 files changed, 75 insertions(+), 77 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b882d4238581..2f8a0d01a4bb 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2474,21 +2474,13 @@ drop_unsolicited_na - BOOLEAN
 
 	By default this is turned off.
 
-accept_unsolicited_na - BOOLEAN
+accept_untracked_na - BOOLEAN
 	Add a new neighbour cache entry in STALE state for routers on receiving an
-	unsolicited neighbour advertisement with target link-layer address option
-	specified. This is as per router-side behavior documented in RFC9131.
-	This has lower precedence than drop_unsolicited_na.
+	neighbour advertisement with target link-layer address option specified
+	if a corresponding entry is not already present.
+	This is as per router-side behavior documented in RFC9131.
 
-	 ====   ======  ======  ==============================================
-	 drop   accept  fwding                   behaviour
-	 ----   ------  ------  ----------------------------------------------
-	    1        X       X  Drop NA packet and don't pass up the stack
-	    0        0       X  Pass NA packet up the stack, don't update NC
-	    0        1       0  Pass NA packet up the stack, don't update NC
-	    0        1       1  Pass NA packet up the stack, and add a STALE
-	                        NC entry
-	 ====   ======  ======  ==============================================
+	This has lower precedence than drop_unsolicited_na.
 
 	This will optimize the return path for the initial off-link communication
 	that is initiated by a directly connected host, by ensuring that
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 38c8203d52cb..37dfdcfcdd54 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -61,7 +61,7 @@ struct ipv6_devconf {
 	__s32		suppress_frag_ndisc;
 	__s32		accept_ra_mtu;
 	__s32		drop_unsolicited_na;
-	__s32		accept_unsolicited_na;
+	__s32		accept_untracked_na;
 	struct ipv6_stable_secret {
 		bool initialized;
 		struct in6_addr secret;
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 549ddeaf788b..03cdbe798fe3 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -194,7 +194,7 @@ enum {
 	DEVCONF_IOAM6_ID,
 	DEVCONF_IOAM6_ID_WIDE,
 	DEVCONF_NDISC_EVICT_NOCARRIER,
-	DEVCONF_ACCEPT_UNSOLICITED_NA,
+	DEVCONF_ACCEPT_UNTRACKED_NA,
 	DEVCONF_MAX
 };
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index ca0aa744593e..1b1932502e9e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5586,7 +5586,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_IOAM6_ID] = cnf->ioam6_id;
 	array[DEVCONF_IOAM6_ID_WIDE] = cnf->ioam6_id_wide;
 	array[DEVCONF_NDISC_EVICT_NOCARRIER] = cnf->ndisc_evict_nocarrier;
-	array[DEVCONF_ACCEPT_UNSOLICITED_NA] = cnf->accept_unsolicited_na;
+	array[DEVCONF_ACCEPT_UNTRACKED_NA] = cnf->accept_untracked_na;
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -7038,8 +7038,8 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.extra2		= (void *)SYSCTL_ONE,
 	},
 	{
-		.procname	= "accept_unsolicited_na",
-		.data		= &ipv6_devconf.accept_unsolicited_na,
+		.procname	= "accept_untracked_na",
+		.data		= &ipv6_devconf.accept_untracked_na,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 254addad0dd3..adbae7a58513 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -979,7 +979,9 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	struct inet6_dev *idev = __in6_dev_get(dev);
 	struct inet6_ifaddr *ifp;
 	struct neighbour *neigh;
-	bool create_neigh;
+	u8 old_flags;
+	struct net *net;
+	u8 new_state;
 
 	if (skb->len < sizeof(struct nd_msg)) {
 		ND_PRINTK(2, warn, "NA: packet too short\n");
@@ -1000,7 +1002,6 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	/* For some 802.11 wireless deployments (and possibly other networks),
 	 * there will be a NA proxy and unsolicitd packets are attacks
 	 * and thus should not be accepted.
-	 * drop_unsolicited_na takes precedence over accept_unsolicited_na
 	 */
 	if (!msg->icmph.icmp6_solicited && idev &&
 	    idev->cnf.drop_unsolicited_na)
@@ -1041,61 +1042,67 @@ static void ndisc_recv_na(struct sk_buff *skb)
 		in6_ifa_put(ifp);
 		return;
 	}
+
+	neigh = neigh_lookup(&nd_tbl, &msg->target, dev);
+
 	/* RFC 9131 updates original Neighbour Discovery RFC 4861.
-	 * An unsolicited NA can now create a neighbour cache entry
-	 * on routers if it has Target LL Address option.
+	 * NAs with Target LL Address option without a corresponding
+	 * entry in the neighbour cache can now create a STALE neighbour
+	 * cache entry on routers.
 	 *
-	 * drop   accept  fwding                   behaviour
-	 * ----   ------  ------  ----------------------------------------------
-	 *    1        X       X  Drop NA packet and don't pass up the stack
-	 *    0        0       X  Pass NA packet up the stack, don't update NC
-	 *    0        1       0  Pass NA packet up the stack, don't update NC
-	 *    0        1       1  Pass NA packet up the stack, and add a STALE
-	 *                          NC entry
-	 * Note that we don't do a (daddr == all-routers-mcast) check.
+	 *   entry accept  fwding  solicited        behaviour
+	 * ------- ------  ------  ---------    ----------------------
+	 * present      X       X         0     Set state to STALE
+	 * present      X       X         1     Set state to REACHABLE
+	 *  absent      0       X         X     Do nothing
+	 *  absent      1       0         X     Do nothing
+	 *  absent      1       1         X     Add a new STALE entry
 	 */
-	create_neigh = !msg->icmph.icmp6_solicited && lladdr &&
-		       idev && idev->cnf.forwarding &&
-		       idev->cnf.accept_unsolicited_na;
-	neigh = __neigh_lookup(&nd_tbl, &msg->target, dev, create_neigh);
+	new_state = msg->icmph.icmp6_solicited ? NUD_REACHABLE : NUD_STALE;
+	if (!neigh && lladdr &&
+	    idev && idev->cnf.forwarding &&
+	    idev->cnf.accept_untracked_na) {
+		neigh = neigh_create(&nd_tbl, &msg->target, dev);
+		new_state = NUD_STALE;
+	}
 
-	if (neigh) {
-		u8 old_flags = neigh->flags;
-		struct net *net = dev_net(dev);
+	if (IS_ERR(neigh) || !neigh)
+		return;
 
-		if (neigh->nud_state & NUD_FAILED)
-			goto out;
+	old_flags = neigh->flags;
+	net = dev_net(dev);
+
+	if (neigh->nud_state & NUD_FAILED)
+		goto out;
+
+	/* Don't update the neighbor cache entry on a proxy NA from
+	 * ourselves because either the proxied node is off link or it
+	 * has already sent a NA to us.
+	 */
+	if (lladdr && !memcmp(lladdr, dev->dev_addr, dev->addr_len) &&
+	    net->ipv6.devconf_all->forwarding && net->ipv6.devconf_all->proxy_ndp &&
+	    pneigh_lookup(&nd_tbl, net, &msg->target, dev, 0)) {
+		/* XXX: idev->cnf.proxy_ndp */
+		goto out;
+	}
+
+	ndisc_update(dev, neigh, lladdr,
+		     new_state,
+		     NEIGH_UPDATE_F_WEAK_OVERRIDE |
+		     (msg->icmph.icmp6_override ? NEIGH_UPDATE_F_OVERRIDE : 0) |
+		     NEIGH_UPDATE_F_OVERRIDE_ISROUTER |
+		     (msg->icmph.icmp6_router ? NEIGH_UPDATE_F_ISROUTER : 0),
+		     NDISC_NEIGHBOUR_ADVERTISEMENT, &ndopts);
 
+	if ((old_flags & ~neigh->flags) & NTF_ROUTER) {
 		/*
-		 * Don't update the neighbor cache entry on a proxy NA from
-		 * ourselves because either the proxied node is off link or it
-		 * has already sent a NA to us.
+		 * Change: router to host
 		 */
-		if (lladdr && !memcmp(lladdr, dev->dev_addr, dev->addr_len) &&
-		    net->ipv6.devconf_all->forwarding && net->ipv6.devconf_all->proxy_ndp &&
-		    pneigh_lookup(&nd_tbl, net, &msg->target, dev, 0)) {
-			/* XXX: idev->cnf.proxy_ndp */
-			goto out;
-		}
-
-		ndisc_update(dev, neigh, lladdr,
-			     msg->icmph.icmp6_solicited ? NUD_REACHABLE : NUD_STALE,
-			     NEIGH_UPDATE_F_WEAK_OVERRIDE|
-			     (msg->icmph.icmp6_override ? NEIGH_UPDATE_F_OVERRIDE : 0)|
-			     NEIGH_UPDATE_F_OVERRIDE_ISROUTER|
-			     (msg->icmph.icmp6_router ? NEIGH_UPDATE_F_ISROUTER : 0),
-			     NDISC_NEIGHBOUR_ADVERTISEMENT, &ndopts);
-
-		if ((old_flags & ~neigh->flags) & NTF_ROUTER) {
-			/*
-			 * Change: router to host
-			 */
-			rt6_clean_tohost(dev_net(dev),  saddr);
-		}
+		rt6_clean_tohost(dev_net(dev),  saddr);
+	}
 
 out:
-		neigh_release(neigh);
-	}
+	neigh_release(neigh);
 }
 
 static void ndisc_recv_rs(struct sk_buff *skb)
diff --git a/tools/testing/selftests/net/ndisc_unsolicited_na_test.sh b/tools/testing/selftests/net/ndisc_unsolicited_na_test.sh
index f508657ee126..86e621b7b9c7 100755
--- a/tools/testing/selftests/net/ndisc_unsolicited_na_test.sh
+++ b/tools/testing/selftests/net/ndisc_unsolicited_na_test.sh
@@ -1,15 +1,14 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-# This test is for the accept_unsolicited_na feature to
+# This test is for the accept_untracked_na feature to
 # enable RFC9131 behaviour. The following is the test-matrix.
 # drop   accept  fwding                   behaviour
 # ----   ------  ------  ----------------------------------------------
-#    1        X       X  Drop NA packet and don't pass up the stack
-#    0        0       X  Pass NA packet up the stack, don't update NC
-#    0        1       0  Pass NA packet up the stack, don't update NC
-#    0        1       1  Pass NA packet up the stack, and add a STALE
-#                           NC entry
+#    1        X       X  Don't update NC
+#    0        0       X  Don't update NC
+#    0        1       0  Don't update NC
+#    0        1       1  Add a STALE NC entry
 
 ret=0
 # Kselftest framework requirement - SKIP code is 4.
@@ -72,7 +71,7 @@ setup()
 	set -e
 
 	local drop_unsolicited_na=$1
-	local accept_unsolicited_na=$2
+	local accept_untracked_na=$2
 	local forwarding=$3
 
 	# Setup two namespaces and a veth tunnel across them.
@@ -93,7 +92,7 @@ setup()
 	${IP_ROUTER_EXEC} sysctl -qw \
                 ${ROUTER_CONF}.drop_unsolicited_na=${drop_unsolicited_na}
 	${IP_ROUTER_EXEC} sysctl -qw \
-                ${ROUTER_CONF}.accept_unsolicited_na=${accept_unsolicited_na}
+                ${ROUTER_CONF}.accept_untracked_na=${accept_untracked_na}
 	${IP_ROUTER_EXEC} sysctl -qw ${ROUTER_CONF}.disable_ipv6=0
 	${IP_ROUTER} addr add ${ROUTER_ADDR_WITH_MASK} dev ${ROUTER_INTF}
 
@@ -144,13 +143,13 @@ link_up() {
 
 verify_ndisc() {
 	local drop_unsolicited_na=$1
-	local accept_unsolicited_na=$2
+	local accept_untracked_na=$2
 	local forwarding=$3
 
 	neigh_show_output=$(${IP_ROUTER} neigh show \
                 to ${HOST_ADDR} dev ${ROUTER_INTF} nud stale)
 	if [ ${drop_unsolicited_na} -eq 0 ] && \
-			[ ${accept_unsolicited_na} -eq 1 ] && \
+			[ ${accept_untracked_na} -eq 1 ] && \
 			[ ${forwarding} -eq 1 ]; then
 		# Neighbour entry expected to be present for 011 case
 		[[ ${neigh_show_output} ]]
@@ -179,14 +178,14 @@ test_unsolicited_na_combination() {
 	test_unsolicited_na_common $1 $2 $3
 	test_msg=("test_unsolicited_na: "
 		"drop_unsolicited_na=$1 "
-		"accept_unsolicited_na=$2 "
+		"accept_untracked_na=$2 "
 		"forwarding=$3")
 	log_test $? 0 "${test_msg[*]}"
 	cleanup
 }
 
 test_unsolicited_na_combinations() {
-	# Args: drop_unsolicited_na accept_unsolicited_na forwarding
+	# Args: drop_unsolicited_na accept_untracked_na forwarding
 
 	# Expect entry
 	test_unsolicited_na_combination 0 1 1
-- 
2.27.0

