Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F303532D3A
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 17:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238806AbiEXPWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 11:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238825AbiEXPWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 11:22:09 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E48555211;
        Tue, 24 May 2022 08:22:05 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id l13so24734110lfp.11;
        Tue, 24 May 2022 08:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=aX8AH42eGAdZF8m84i0MALMiO5+cbaAZiyI29p+eK+s=;
        b=P8JM1WosL3j5gYhj9AH840o2NLQ8nwmAJd0HGrcuSsqH5Qacxf4BPjD7VS/lqmxY77
         Ey1VcoAICHNocGLOnRx8KNTfYF2gKnvslxG7waSZlJvQzEoXY2YHLvFnvprqKZNBE5zF
         TCGPZJiX8l/XGLwhMiP58Drb2FKEYRREp+3vVq0cBNe1HrQC13RZv7fUnXP7foLbaXyO
         VBMtFOAqCHUWw3mZfsA0ExjFLPjrjMtIU0k9/0XLBOE8sutQupm2TtaMZvt1ZHjlL9AB
         icwS05NuOHfnD6daGIwAhDdS8QZCbpA9cs+UgQbpoTvjvkMzMUjU5e5VjLdxcnwp4kz7
         eW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=aX8AH42eGAdZF8m84i0MALMiO5+cbaAZiyI29p+eK+s=;
        b=NM4I2PL3A42y7ggC/gWAI0rlG4XPuerNT752r8H/x/yG+N72+5teEAwQNggZ1lIvtB
         SJ1hFcC61NY1kvsTcY/ScQvhU9lPHGwtsiYKt0u9FM+fzFMNUMmsoAtbldr0c2aUiDf6
         ypmxp0OuzROxphdlQVC3AkI5JQsQqmNdzScvXaQBG7KlQQnbGTR8FvAr9NZ2CWl6eS3G
         bcdLQW//a8vGPmq2zd9kGQdecDril7kClfWYyLpvE5ul7Ch02j1tifu2dVJ0btnanELx
         Xfp7sBGbBtmmr1Sr0pB+QcyO1ocRlgBm9sUifW87ypfoltlpL2Xagln55hh7IlD6kC/w
         kwzg==
X-Gm-Message-State: AOAM531n3WY6MWdmUjxXYi/o8QD8qk2UqnbryFlWwpejbW2/DgduXQIg
        DdnxWr6XTdnWbVf1iLkx6IU=
X-Google-Smtp-Source: ABdhPJxNCEK+KI+zb8fvMJbHu0/L/a076Ob2wEvbSabFe4aAC5SwVww9jfIe+B7NTD5tzhGwBij2Tw==
X-Received: by 2002:a05:6512:10d0:b0:477:ce0a:8e9d with SMTP id k16-20020a05651210d000b00477ce0a8e9dmr17566392lfg.420.1653405723520;
        Tue, 24 May 2022 08:22:03 -0700 (PDT)
Received: from wse-c0127.westermo.com (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id d22-20020a2e3316000000b00253deeaeb3dsm2441404ljc.131.2022.05.24.08.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 08:22:03 -0700 (PDT)
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
Subject: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent locked port feature
Date:   Tue, 24 May 2022 17:21:41 +0200
Message-Id: <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
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

Add an intermediate state for clients behind a locked port to allow for
possible opening of the port for said clients. This feature corresponds
to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
latter defined by Cisco.
Locked FDB entries will be limited in number, so as to prevent DOS
attacks by spamming the port with random entries. The limit will be
a per port limit as it is a port based feature and that the port flushes
all FDB entries on link down.

Only the kernel can set this FDB entry flag, while userspace can read
the flag and remove it by deleting the FDB entry.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 include/uapi/linux/neighbour.h |  1 +
 net/bridge/br_fdb.c            | 11 +++++++++++
 net/bridge/br_if.c             |  1 +
 net/bridge/br_input.c          | 11 ++++++++++-
 net/bridge/br_private.h        |  7 ++++++-
 5 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index 39c565e460c7..76d65b481086 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -53,6 +53,7 @@ enum {
 #define NTF_ROUTER	(1 << 7)
 /* Extended flags under NDA_FLAGS_EXT: */
 #define NTF_EXT_MANAGED	(1 << 0)
+#define NTF_EXT_LOCKED	(1 << 1)
 
 /*
  *	Neighbor Cache Entry States.
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e7f4fccb6adb..6b83e2d6435d 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -105,6 +105,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 	struct nda_cacheinfo ci;
 	struct nlmsghdr *nlh;
 	struct ndmsg *ndm;
+	u32 ext_flags = 0;
 
 	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
 	if (nlh == NULL)
@@ -125,11 +126,16 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 		ndm->ndm_flags |= NTF_EXT_LEARNED;
 	if (test_bit(BR_FDB_STICKY, &fdb->flags))
 		ndm->ndm_flags |= NTF_STICKY;
+	if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags))
+		ext_flags |= NTF_EXT_LOCKED;
 
 	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
 		goto nla_put_failure;
 	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
 		goto nla_put_failure;
+	if (nla_put_u32(skb, NDA_FLAGS_EXT, ext_flags))
+		goto nla_put_failure;
+
 	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
 	ci.ndm_confirmed = 0;
 	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
@@ -171,6 +177,7 @@ static inline size_t fdb_nlmsg_size(void)
 	return NLMSG_ALIGN(sizeof(struct ndmsg))
 		+ nla_total_size(ETH_ALEN) /* NDA_LLADDR */
 		+ nla_total_size(sizeof(u32)) /* NDA_MASTER */
+		+ nla_total_size(sizeof(u32)) /* NDA_FLAGS_EXT */
 		+ nla_total_size(sizeof(u16)) /* NDA_VLAN */
 		+ nla_total_size(sizeof(struct nda_cacheinfo))
 		+ nla_total_size(0) /* NDA_FDB_EXT_ATTRS */
@@ -319,6 +326,9 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
 	if (test_bit(BR_FDB_STATIC, &f->flags))
 		fdb_del_hw_addr(br, f->key.addr.addr);
 
+	if (test_bit(BR_FDB_ENTRY_LOCKED, &f->flags) && !test_bit(BR_FDB_OFFLOADED, &f->flags))
+		atomic_dec(&f->dst->locked_entry_cnt);
+
 	hlist_del_init_rcu(&f->fdb_node);
 	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
 			       br_fdb_rht_params);
@@ -1086,6 +1096,7 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		modified = true;
 
 	set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
+	clear_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags);
 
 	fdb->used = jiffies;
 	if (modified) {
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 47fcbade7389..0ca04cba5ebe 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -429,6 +429,7 @@ static struct net_bridge_port *new_nbp(struct net_bridge *br,
 	p->priority = 0x8000 >> BR_PORT_BITS;
 	p->port_no = index;
 	p->flags = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
+	p->locked_entry_cnt.counter = 0;
 	br_init_port(p);
 	br_set_state(p, BR_STATE_DISABLED);
 	br_stp_port_timer_init(p);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 68b3e850bcb9..0280806cf980 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -110,8 +110,17 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
 
 		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
-		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
+		    test_bit(BR_FDB_LOCAL, &fdb_src->flags) ||
+		    test_bit(BR_FDB_ENTRY_LOCKED, &fdb_src->flags)) {
+			if (!fdb_src && atomic_read(&p->locked_entry_cnt) < BR_LOCKED_ENTRIES_MAX) {
+				unsigned long flags = 0;
+
+				__set_bit(BR_FDB_ENTRY_LOCKED, &flags);
+				br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, flags);
+				atomic_inc(&p->locked_entry_cnt);
+			}
 			goto drop;
+		}
 	}
 
 	nbp_switchdev_frame_mark(p, skb);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 06e5f6faa431..be17c99efe65 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -31,6 +31,8 @@
 #define BR_MULTICAST_QUERY_INTVL_MIN msecs_to_jiffies(1000)
 #define BR_MULTICAST_STARTUP_QUERY_INTVL_MIN BR_MULTICAST_QUERY_INTVL_MIN
 
+#define BR_LOCKED_ENTRIES_MAX	64
+
 #define BR_HWDOM_MAX BITS_PER_LONG
 
 #define BR_VERSION	"2.3"
@@ -251,7 +253,8 @@ enum {
 	BR_FDB_ADDED_BY_EXT_LEARN,
 	BR_FDB_OFFLOADED,
 	BR_FDB_NOTIFY,
-	BR_FDB_NOTIFY_INACTIVE
+	BR_FDB_NOTIFY_INACTIVE,
+	BR_FDB_ENTRY_LOCKED,
 };
 
 struct net_bridge_fdb_key {
@@ -414,6 +417,8 @@ struct net_bridge_port {
 	u16				backup_redirected_cnt;
 
 	struct bridge_stp_xstats	stp_xstats;
+
+	atomic_t			locked_entry_cnt;
 };
 
 #define kobj_to_brport(obj)	container_of(obj, struct net_bridge_port, kobj)
-- 
2.30.2

