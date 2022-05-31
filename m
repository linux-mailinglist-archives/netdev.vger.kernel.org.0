Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24247538B75
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 08:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244198AbiEaGhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 02:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbiEaGhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 02:37:37 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618C423BF5
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 23:37:36 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gd1so4692212pjb.2
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 23:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+G1Pw7dUF9gnBVsOpFHbdOhZrSabsAV7r6ABiWgFZRE=;
        b=YeUG8u9zU6qrb/Ej/N37uZlBq8VSzP6GV0EPU/93mYSaf8Aw8OQsq3BkUEDnKz75/C
         Mw+kiGLn3a3cBtUDDh2lDIRf0huQUi4W+MhLpNli1+3PPDLcSeAuZ5CSMX5ym0x6+Cc5
         Y5wGy3DBlPFNT/jFXZcrsMCP/y+qk1vKS//vlLhRO1zQVyo4JtkHkKNf/+bmN369rGCO
         ya3KdoFS9sxuwqrf6WzPNgIBZ1ui6PaxNPZYvP/6roejcXfBrLTBdO8Y0eoNF7yQ2njh
         5aequxdPXrBF2oycQAfw0A+EtjBXi+lvCnRvj0TFxvE0s/j5ZrbGMtrq2QBJJus1luPt
         putA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+G1Pw7dUF9gnBVsOpFHbdOhZrSabsAV7r6ABiWgFZRE=;
        b=NQH5ve5W45xdinuJxblVf7vhGoXJ+zesNIsoOTxokgJcVLlabEIsqIj9eGJBAF2v1y
         KZqHFt3wCVUiMg9MG1YopdlcuuIPPtZKVgEfR7tKVjbTMPqssCaNqO0aA/7Wyrg5XEkA
         xn8X6d+Z1GRWBesekORtfD6891hZeiSL5/NecbZlEW1BNddScWBWf67tocmVmLjB+OQW
         vUvJmrOuuute0VvHVY1WVY9bLDiQ9AhtI/U95JnIj+c1/8TiJEpJoIEUvONAv2ZKkxEl
         XHufN1NkRAa1IWK+dLjkxjtW7uIJbQc7Z1EyiHE8+TJLVQsNgQTVt/5+43W+X8coa52q
         KqWw==
X-Gm-Message-State: AOAM533SpxZ1l/vlgmblhVpDDv0K4vpEeCu+U5M1BS1SxBTnjKbQHKVr
        cYCtPp+HM26i/xRESi+v3lBNW1r6A/FnzZ3j
X-Google-Smtp-Source: ABdhPJwVL1UGfegHnCJ5ISns8dFJDJvRnJP1BBJGrHbcA/rAKqX2YTEQcPwsDPPxIXCasb+OK5djRQ==
X-Received: by 2002:a17:903:1c6:b0:161:9fbc:5a6 with SMTP id e6-20020a17090301c600b001619fbc05a6mr59553662plh.65.1653979055662;
        Mon, 30 May 2022 23:37:35 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v62-20020a626141000000b0051b6091c452sm1949879pfb.70.2022.05.30.23.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 23:37:34 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net] bonding: guard ns_targets by CONFIG_IPV6
Date:   Tue, 31 May 2022 14:37:27 +0800
Message-Id: <20220531063727.224043-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Guard ns_targets in struct bond_params by CONFIG_IPV6, which could save
256 bytes if IPv6 not configed. Also add this protection for function
bond_is_ip6_target_ok() and bond_get_targets_ip6().

Remove the IS_ENABLED() check for bond_opts[] as this will make
BOND_OPT_NS_TARGETS uninitialized if CONFIG_IPV6 not enabled. Add
a dummy bond_option_ns_ip6_targets_set() for this situation.

Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: return -EPERM for bond_option_ns_ip6_targets_set if IPv6 disabled
---
 drivers/net/bonding/bond_main.c    |  2 ++
 drivers/net/bonding/bond_options.c | 10 ++++++----
 include/net/bonding.h              |  6 ++++++
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 3b7baaeae82c..f85372adf042 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -6159,7 +6159,9 @@ static int bond_check_params(struct bond_params *params)
 		strscpy_pad(params->primary, primary, sizeof(params->primary));
 
 	memcpy(params->arp_targets, arp_target, sizeof(arp_target));
+#if IS_ENABLED(CONFIG_IPV6)
 	memset(params->ns_targets, 0, sizeof(struct in6_addr) * BOND_MAX_NS_TARGETS);
+#endif
 
 	return 0;
 }
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 64f7db2627ce..1f8323ad5282 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -34,10 +34,8 @@ static int bond_option_arp_ip_target_add(struct bonding *bond, __be32 target);
 static int bond_option_arp_ip_target_rem(struct bonding *bond, __be32 target);
 static int bond_option_arp_ip_targets_set(struct bonding *bond,
 					  const struct bond_opt_value *newval);
-#if IS_ENABLED(CONFIG_IPV6)
 static int bond_option_ns_ip6_targets_set(struct bonding *bond,
 					  const struct bond_opt_value *newval);
-#endif
 static int bond_option_arp_validate_set(struct bonding *bond,
 					const struct bond_opt_value *newval);
 static int bond_option_arp_all_targets_set(struct bonding *bond,
@@ -299,7 +297,6 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.flags = BOND_OPTFLAG_RAWVAL,
 		.set = bond_option_arp_ip_targets_set
 	},
-#if IS_ENABLED(CONFIG_IPV6)
 	[BOND_OPT_NS_TARGETS] = {
 		.id = BOND_OPT_NS_TARGETS,
 		.name = "ns_ip6_target",
@@ -307,7 +304,6 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.flags = BOND_OPTFLAG_RAWVAL,
 		.set = bond_option_ns_ip6_targets_set
 	},
-#endif
 	[BOND_OPT_DOWNDELAY] = {
 		.id = BOND_OPT_DOWNDELAY,
 		.name = "downdelay",
@@ -1254,6 +1250,12 @@ static int bond_option_ns_ip6_targets_set(struct bonding *bond,
 
 	return 0;
 }
+#else
+static int bond_option_ns_ip6_targets_set(struct bonding *bond,
+					  const struct bond_opt_value *newval)
+{
+	return -EPERM;
+}
 #endif
 
 static int bond_option_arp_validate_set(struct bonding *bond,
diff --git a/include/net/bonding.h b/include/net/bonding.h
index b14f4c0b4e9e..cb904d356e31 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -149,7 +149,9 @@ struct bond_params {
 	struct reciprocal_value reciprocal_packets_per_slave;
 	u16 ad_actor_sys_prio;
 	u16 ad_user_port_key;
+#if IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr ns_targets[BOND_MAX_NS_TARGETS];
+#endif
 
 	/* 2 bytes of padding : see ether_addr_equal_64bits() */
 	u8 ad_actor_system[ETH_ALEN + 2];
@@ -503,12 +505,14 @@ static inline int bond_is_ip_target_ok(__be32 addr)
 	return !ipv4_is_lbcast(addr) && !ipv4_is_zeronet(addr);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static inline int bond_is_ip6_target_ok(struct in6_addr *addr)
 {
 	return !ipv6_addr_any(addr) &&
 	       !ipv6_addr_loopback(addr) &&
 	       !ipv6_addr_is_multicast(addr);
 }
+#endif
 
 /* Get the oldest arp which we've received on this slave for bond's
  * arp_targets.
@@ -746,6 +750,7 @@ static inline int bond_get_targets_ip(__be32 *targets, __be32 ip)
 	return -1;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static inline int bond_get_targets_ip6(struct in6_addr *targets, struct in6_addr *ip)
 {
 	int i;
@@ -758,6 +763,7 @@ static inline int bond_get_targets_ip6(struct in6_addr *targets, struct in6_addr
 
 	return -1;
 }
+#endif
 
 /* exported from bond_main.c */
 extern unsigned int bond_net_id;
-- 
2.35.1

