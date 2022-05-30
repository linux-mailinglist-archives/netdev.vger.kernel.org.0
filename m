Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABE153790D
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiE3KOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbiE3KOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:14:31 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BB67C146
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 03:14:29 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id a13so9925511plh.6
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 03:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kdhDMm58x5s/7UFfJZf6SmUgAhS+Yr/zFOHfXp+0uHQ=;
        b=AfvjEKwucRiOk9T1zOP2r8CfIUb57TVmjY6S5ageXy+p4604d8QTjlgpFDWCSwMLzf
         p9Lm6FB0rimoZniVcmxWyQel7eT3B01cFbRNEPuwHObfVj8bbW8xH8QxgLS3AxzgWym1
         Fc8kVUh/cIr0tFiXCkIKhEl1k6RmTMlLg5fIO9gLD+z8wtHdfFKoVboiUYyUUN3A+Ilp
         uhBpyiMdUhlH0ROnIrd3sIBmFh16LFrMCA1mHyjhiVxLayZ1+VAB60a2fHMuTfmRoSWC
         qZQ+lTuVwEbA2Hb8XhZYzy0T/ZzWqzpFZy29nszesa6E5PRqLEzs0ASddzMP5z/KWbCn
         TEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kdhDMm58x5s/7UFfJZf6SmUgAhS+Yr/zFOHfXp+0uHQ=;
        b=58FF3oLBCGCCtjLssbcMmZbPqxSY5iKe+X4l0M6lHDJpl8XAf999hdpG4LP1AqVxwc
         2lW/mIMtqNhZ5QJssOTY4wItNHLlDP4kk2TtgsusZCAaHW83kyXJnXItBJubiOuoIAbY
         Lmph4ICRKDNF5auqY3fcDgNSGVcbUlH0L5dSG9HRGfk7J38iSYE/7y+e9auUhGGJ9Q2Y
         zFkerUVFDDItoOo3PSC5uKfbcWaWiItDnnU9QAkRdgeHp6I4Byo0PwkCuKaf2s8++r9E
         PDsLBnEBOkFiRLkg01FteR6x0j1OERri9itaRaPvE7sTRPSCf888io5PPhlhAWrg+CSZ
         +4MQ==
X-Gm-Message-State: AOAM5315J2qMHGJOuNvdkKJV2hZta+DA7p9WTqbTaTI922xWMJe6LOde
        vlieXCNvmQHALYAAmPQcyFmZ3qPRO84VzbJp
X-Google-Smtp-Source: ABdhPJwTz7tYTBe0TAArza2tUWRhF3bMHHy7mbzZrv3T2NVVoBGMVXzbK1nderIDtgIM6nIgfHhyJA==
X-Received: by 2002:a17:90b:4c8f:b0:1e0:5b0e:eddc with SMTP id my15-20020a17090b4c8f00b001e05b0eeddcmr22515732pjb.23.1653905668534;
        Mon, 30 May 2022 03:14:28 -0700 (PDT)
Received: from localhost.localdomain ([49.37.162.84])
        by smtp.gmail.com with ESMTPSA id q18-20020aa79832000000b0050dc7628162sm8509378pfl.60.2022.05.30.03.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 03:14:26 -0700 (PDT)
From:   Arun Ajith S <aajith@arista.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        dsahern@kernel.org, bagasdotme@gmail.com, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, pabeni@redhat.com, prestwoj@gmail.com,
        corbet@lwn.net, justin.iurman@uliege.be, edumazet@google.com,
        shuah@kernel.org, aajith@arista.com, gilligan@arista.com,
        noureddine@arista.com, gk@arista.com
Subject: [PATCH net v3] net/ipv6: Expand and rename accept_unsolicited_na to accept_untracked_na
Date:   Mon, 30 May 2022 10:14:14 +0000
Message-Id: <20220530101414.65439-1-aajith@arista.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 9131 changes default behaviour of handling RX of NA messages when the
corresponding entry is absent in the neighbour cache. The current
implementation is limited to accept just unsolicited NAs. However, the
RFC is more generic where it also accepts solicited NAs. Both types
should result in adding a STALE entry for this case.

Expand accept_untracked_na behaviour to also accept solicited NAs to
be compliant with the RFC and rename the sysctl knob to
accept_untracked_na.

Fixes: f9a2fb73318e ("net/ipv6: Introduce accept_unsolicited_na knob to implement router-side changes for RFC9131")
Signed-off-by: Arun Ajith S <aajith@arista.com>
---
This change updates the accept_unsolicited_na feature that merged to net-next
for v5.19 to be better compliant with the RFC. It also involves renaming the sysctl
knob to accept_untracked_na before shipping in a release.

Note that the behaviour table has been modifed in the code comments,
but dropped from the Documentation. This is because the table 
documents behaviour that is not unique to the knob, and it is more
relevant to understanding the code. The documentation has been updated
to be unambiguous even without the table.

v2:
  1. Changed commit message and subject as suggested.
  2. Added Fixes tag.
  3. Used en-uk spellings consistently.
  4. Added a couple of missing comments.
  5. Refactored patch to be smaller by avoiding early return.
  6. Made the documentation more clearer.

v3:
  1. Fixed build issue. (Verified make defconfig && make && make htmldocs SPHINXDIRS=networking)

 Documentation/networking/ip-sysctl.rst        | 23 ++++------
 include/linux/ipv6.h                          |  2 +-
 include/uapi/linux/ipv6.h                     |  2 +-
 net/ipv6/addrconf.c                           |  6 +--
 net/ipv6/ndisc.c                              | 42 +++++++++++--------
 .../net/ndisc_unsolicited_na_test.sh          | 23 +++++-----
 6 files changed, 50 insertions(+), 48 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b882d4238581..04216564a03c 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2474,21 +2474,16 @@ drop_unsolicited_na - BOOLEAN
 
 	By default this is turned off.
 
-accept_unsolicited_na - BOOLEAN
-	Add a new neighbour cache entry in STALE state for routers on receiving an
-	unsolicited neighbour advertisement with target link-layer address option
-	specified. This is as per router-side behavior documented in RFC9131.
-	This has lower precedence than drop_unsolicited_na.
+accept_untracked_na - BOOLEAN
+	Add a new neighbour cache entry in STALE state for routers on receiving a
+	neighbour advertisement (either solicited or unsolicited) with target
+	link-layer address option specified if no neighbour entry is already
+	present for the advertised IPv6 address. Without this knob, NAs received
+	for untracked addresses (absent in neighbour cache) are silently ignored.
+
+	This is as per router-side behaviour documented in RFC9131.
 
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
index 254addad0dd3..b0dfe97ea4ee 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -979,7 +979,7 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	struct inet6_dev *idev = __in6_dev_get(dev);
 	struct inet6_ifaddr *ifp;
 	struct neighbour *neigh;
-	bool create_neigh;
+	u8 new_state;
 
 	if (skb->len < sizeof(struct nd_msg)) {
 		ND_PRINTK(2, warn, "NA: packet too short\n");
@@ -1000,7 +1000,7 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	/* For some 802.11 wireless deployments (and possibly other networks),
 	 * there will be a NA proxy and unsolicitd packets are attacks
 	 * and thus should not be accepted.
-	 * drop_unsolicited_na takes precedence over accept_unsolicited_na
+	 * drop_unsolicited_na takes precedence over accept_untracked_na
 	 */
 	if (!msg->icmph.icmp6_solicited && idev &&
 	    idev->cnf.drop_unsolicited_na)
@@ -1041,25 +1041,33 @@ static void ndisc_recv_na(struct sk_buff *skb)
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
+	 *
+	 *   entry accept  fwding  solicited        behaviour
+	 * ------- ------  ------  ---------    ----------------------
+	 * present      X       X         0     Set state to STALE
+	 * present      X       X         1     Set state to REACHABLE
+	 *  absent      0       X         X     Do nothing
+	 *  absent      1       0         X     Do nothing
+	 *  absent      1       1         X     Add a new STALE entry
 	 *
-	 * drop   accept  fwding                   behaviour
-	 * ----   ------  ------  ----------------------------------------------
-	 *    1        X       X  Drop NA packet and don't pass up the stack
-	 *    0        0       X  Pass NA packet up the stack, don't update NC
-	 *    0        1       0  Pass NA packet up the stack, don't update NC
-	 *    0        1       1  Pass NA packet up the stack, and add a STALE
-	 *                          NC entry
 	 * Note that we don't do a (daddr == all-routers-mcast) check.
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
+	if (neigh && !IS_ERR(neigh)) {
 		u8 old_flags = neigh->flags;
 		struct net *net = dev_net(dev);
 
@@ -1079,7 +1087,7 @@ static void ndisc_recv_na(struct sk_buff *skb)
 		}
 
 		ndisc_update(dev, neigh, lladdr,
-			     msg->icmph.icmp6_solicited ? NUD_REACHABLE : NUD_STALE,
+			     new_state,
 			     NEIGH_UPDATE_F_WEAK_OVERRIDE|
 			     (msg->icmph.icmp6_override ? NEIGH_UPDATE_F_OVERRIDE : 0)|
 			     NEIGH_UPDATE_F_OVERRIDE_ISROUTER|
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

