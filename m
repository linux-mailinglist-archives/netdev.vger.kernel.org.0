Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E344D4A11
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240286AbiCJOcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244391AbiCJO2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:28:53 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296FDCD314;
        Thu, 10 Mar 2022 06:23:53 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id 17so5826399lji.1;
        Thu, 10 Mar 2022 06:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=da086JP55rsZQrttnyPrbRnmSrzYkA4tf6FDeCXSGn8=;
        b=Z+e/z3T6tUfk0NmKVo9IgGfkkQIJNRFPGXu0FwCgDeGEQdiRVmwo1YlmzAs9EcKpKK
         mwzIyqPAJ/dhq9T1RooeYxJ2bgH12WcOwGWhb/yqwRTRN2ow5MAIgke1G8KciqjbyP3+
         en3jlZTxKH3jD1DjO/4KweqtdXmJLuXZOd+qiNaX+MeBldeRNffR9n7B2i3m0WHhqtrc
         8QQ98NQbaQRS+W1LU7UUeUo8lTnU4kTEn0QK2vFVGePkXUcIzpne/9F8Xws4YhaGjqq2
         tJ1FK/LCVfR10eZrYIhlTVh8pKHOc/ooJxiCBxH2Vhxqr0XowN3+K0ndPtyfxahH0LQZ
         t9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=da086JP55rsZQrttnyPrbRnmSrzYkA4tf6FDeCXSGn8=;
        b=uwv4iicb48BIBkJwukH3xKeQ0dzKasPF5KNsXcyOdO7dfVqPnGQiMGjpGr1KKNmJbN
         3wkJvXvDR9YyJPPR8/tYRfBkcdmT5Gje+PvF729RRmyxNJ+ajfGDKa7g1gWtayGcypQc
         faR6NvPexBrS7+3kLp8usIt0qpx8C+d7K0DS5dhJf4CC6QhTIne0Xw/xou9Tsqd/aPNB
         loQTh4rF4FU44733NoOjmZzrqw+4VzYmxX1zdIF1cio0gMJgxt6ROnl4j2ye+QTZ1OMX
         bYo32gA4DTNiibSISSIjx7iD4KBb9r5L6k+gkA9hRYlw6tChw6yruRjWPMhRCp7lPCAW
         uMeg==
X-Gm-Message-State: AOAM532/qn7pfXLlyzh+j5W6BePqAMPP1J7/2RoZpe6hgzY8FXiU50SX
        cZslK3w18xLeDLFfEEv2Rmk=
X-Google-Smtp-Source: ABdhPJydcEuj+KQu43Z12hPJB7OUldKO5vUPTvL0Um7ak/OLihpqkhUy+9vw1rwez9WWNvOuxAk+Ow==
X-Received: by 2002:a2e:9cd:0:b0:244:d41d:69ef with SMTP id 196-20020a2e09cd000000b00244d41d69efmr3040304ljj.386.1646922224990;
        Thu, 10 Mar 2022 06:23:44 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id 10-20020a2e080a000000b00247f82bbc6fsm1088932lji.54.2022.03.10.06.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 06:23:44 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: [PATCH net-next 1/3] net: bridge: add fdb flag to extent locked port feature
Date:   Thu, 10 Mar 2022 15:23:18 +0100
Message-Id: <20220310142320.611738-2-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
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

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 include/uapi/linux/neighbour.h |  1 +
 net/bridge/br_fdb.c            |  6 ++++++
 net/bridge/br_input.c          | 11 ++++++++++-
 net/bridge/br_private.h        |  3 ++-
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index db05fb55055e..83115a592d58 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -208,6 +208,7 @@ enum {
 	NFEA_UNSPEC,
 	NFEA_ACTIVITY_NOTIFY,
 	NFEA_DONT_REFRESH,
+	NFEA_LOCKED,
 	__NFEA_MAX
 };
 #define NFEA_MAX (__NFEA_MAX - 1)
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6ccda68bd473..396dcf3084cf 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -105,6 +105,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 	struct nda_cacheinfo ci;
 	struct nlmsghdr *nlh;
 	struct ndmsg *ndm;
+	u8 ext_flags = 0;
 
 	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
 	if (nlh == NULL)
@@ -125,11 +126,16 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
 		ndm->ndm_flags |= NTF_EXT_LEARNED;
 	if (test_bit(BR_FDB_STICKY, &fdb->flags))
 		ndm->ndm_flags |= NTF_STICKY;
+	if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags))
+		ext_flags |= 1 << NFEA_LOCKED;
 
 	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
 		goto nla_put_failure;
 	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
 		goto nla_put_failure;
+	if (nla_put_u8(skb, NDA_FDB_EXT_ATTRS, ext_flags))
+		goto nla_put_failure;
+
 	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
 	ci.ndm_confirmed = 0;
 	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index e0c13fcc50ed..897908484b18 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -75,6 +75,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	struct net_bridge_mcast *brmctx;
 	struct net_bridge_vlan *vlan;
 	struct net_bridge *br;
+	unsigned long flags = 0;
 	u16 vid = 0;
 	u8 state;
 
@@ -94,8 +95,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
 
 		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
-		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
+		    test_bit(BR_FDB_LOCAL, &fdb_src->flags)) {
+			if (!fdb_src) {
+				set_bit(BR_FDB_ENTRY_LOCKED, &flags);
+				br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, flags);
+			}
 			goto drop;
+		} else {
+			if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb_src->flags))
+				goto drop;
+		}
 	}
 
 	nbp_switchdev_frame_mark(p, skb);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 48bc61ebc211..f5a0b68c4857 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -248,7 +248,8 @@ enum {
 	BR_FDB_ADDED_BY_EXT_LEARN,
 	BR_FDB_OFFLOADED,
 	BR_FDB_NOTIFY,
-	BR_FDB_NOTIFY_INACTIVE
+	BR_FDB_NOTIFY_INACTIVE,
+	BR_FDB_ENTRY_LOCKED,
 };
 
 struct net_bridge_fdb_key {
-- 
2.30.2

