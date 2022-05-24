Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A186532D43
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 17:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238836AbiEXPWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 11:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbiEXPWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 11:22:11 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4895F55353;
        Tue, 24 May 2022 08:22:07 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id p22so31358976lfo.10;
        Tue, 24 May 2022 08:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=vzMtcD9pHVLI43F+btkmnpc3m8QPN+J/xH5CJZ3HJKk=;
        b=qJyMORyAD4liaf6/eFamHLowy+VN7viOwEkGNClY0X8YuwrCbmFqyi9EezgBu17MXi
         dvWQVZF1vmbFr1QGogcVMcNkqb5qGzFzEu6TFbVfFB11/zqbkG8ifWOu1Rat6N9IHfAl
         Jw67xsJZcK0Ty4SzXrE+B7pOP99pjyZ7JMQxtOiuFw9zDQ1vF5j/GfyX61fqSMu/VsJq
         PuYTWEInhL0u3j/XmEbXCKsLYGWRdzohWdWxRHvINdcOrwHyO/Cyss5ikrCX/U2U42J5
         tX6d9B3W3VFtH2PV88SvvLu036le46J7aYingyBWlnfaaH/2Jlsux1eIAVo0JHSQjjFZ
         56FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=vzMtcD9pHVLI43F+btkmnpc3m8QPN+J/xH5CJZ3HJKk=;
        b=mltNPW6dI7ua+6qlUO4MPba0sFV1FgWFvuMZaYlfB0R6uLj5YxFQsyO5hHkfSkS1Nw
         AMLmDbbUqhs60hFBAbB/MWDu15JCL19chHo5kOYp4W1PrmbwW8kFDjc4xkEGckv1whfc
         pweoOuIclFgtZZ8u07ekESmnXBuy3abowIVx7JtI7yG9IaQyYeEuCcJp7/O4Y3xCdvo/
         E4b9RYqI59gUWHASqFAuiLgaSmDxzTPhoYCTNd4wKqUtAwBsnY2Axpxn/Dbcz1RdnbOl
         gMsb7ZFKSW/tTV/2j2DEd6X6Dn4KHer3Qsagvzgy6pQHan7f4cVkKHWPQQ/kmr0tA5DT
         mNJw==
X-Gm-Message-State: AOAM532i0eKRPyU/lQrgJzpymsHtN8gOubLektEIR8UkmSrv3894XDJx
        UonoAJBodLJfUQpir9+XO7w=
X-Google-Smtp-Source: ABdhPJzoPEkjJ/htt2xeg04iTaS9VKTN+o0NgDeHwP+mYRcF2x3RwSMuVaiRHtcHiGalri0sFdYsdw==
X-Received: by 2002:a05:6512:3e0f:b0:478:97be:bc75 with SMTP id i15-20020a0565123e0f00b0047897bebc75mr1314274lfv.534.1653405726072;
        Tue, 24 May 2022 08:22:06 -0700 (PDT)
Received: from wse-c0127.westermo.com (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id d22-20020a2e3316000000b00253deeaeb3dsm2441404ljc.131.2022.05.24.08.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 08:22:05 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH V3 net-next 2/4] net: switchdev: add support for offloading of fdb locked flag
Date:   Tue, 24 May 2022 17:21:42 +0200
Message-Id: <20220524152144.40527-3-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Used for Mac-auth/MAB feature in the offloaded case.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 include/net/dsa.h       | 6 ++++++
 include/net/switchdev.h | 3 ++-
 net/bridge/br.c         | 3 ++-
 net/bridge/br_fdb.c     | 7 +++++--
 net/bridge/br_private.h | 2 +-
 5 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 14f07275852b..a5a843b2d67d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -330,6 +330,12 @@ struct dsa_port {
 	/* List of VLANs that CPU and DSA ports are members of. */
 	struct mutex		vlans_lock;
 	struct list_head	vlans;
+
+	/* List and maintenance of locked ATU entries */
+	struct mutex		locked_entries_list_lock;
+	struct list_head	atu_locked_entries_list;
+	atomic_t		atu_locked_entry_cnt;
+	struct delayed_work	atu_work;
 };
 
 /* TODO: ideally DSA ports would have a single dp->link_dp member,
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index aa0171d5786d..62f4f7c9c7c2 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -245,7 +245,8 @@ struct switchdev_notifier_fdb_info {
 	u16 vid;
 	u8 added_by_user:1,
 	   is_local:1,
-	   offloaded:1;
+	   offloaded:1,
+	   locked:1;
 };
 
 struct switchdev_notifier_port_obj_info {
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 96e91d69a9a8..12933388a5a4 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -166,7 +166,8 @@ static int br_switchdev_event(struct notifier_block *unused,
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
 		fdb_info = ptr;
 		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
-						fdb_info->vid, false);
+						fdb_info->vid, false,
+						fdb_info->locked);
 		if (err) {
 			err = notifier_from_errno(err);
 			break;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6b83e2d6435d..92469547283a 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1135,7 +1135,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 					   "FDB entry towards bridge must be permanent");
 			return -EINVAL;
 		}
-		err = br_fdb_external_learn_add(br, p, addr, vid, true);
+		err = br_fdb_external_learn_add(br, p, addr, vid, true, false);
 	} else {
 		spin_lock_bh(&br->hash_lock);
 		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
@@ -1365,7 +1365,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
 
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-			      bool swdev_notify)
+			      bool swdev_notify, bool locked)
 {
 	struct net_bridge_fdb_entry *fdb;
 	bool modified = false;
@@ -1385,6 +1385,9 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (!p)
 			flags |= BIT(BR_FDB_LOCAL);
 
+		if (locked)
+			flags |= BIT(BR_FDB_ENTRY_LOCKED);
+
 		fdb = fdb_create(br, p, addr, vid, flags);
 		if (!fdb) {
 			err = -ENOMEM;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index be17c99efe65..88913e6a59e1 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -815,7 +815,7 @@ int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
 void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-			      bool swdev_notify);
+			      bool swdev_notify, bool locked);
 int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
 			      bool swdev_notify);
-- 
2.30.2

