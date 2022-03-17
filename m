Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E641B4DC30E
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiCQJkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbiCQJkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:40:37 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5FC185962;
        Thu, 17 Mar 2022 02:39:20 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id w12so7998330lfr.9;
        Thu, 17 Mar 2022 02:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=c4q1aukNB19Ywn0yhrK5YppHN0nN9ZnWCosl/BOVje8=;
        b=HBcQdLeyekvttOcqJyw/c2RfIJxEBHgYmtgQ3kD1Xz3683ZUW4Jw/KOKUVwlroPElG
         5pDByd9XOH/i5ZMoYANS4jS4pP9mrMVS7G47zk8KaWVoHvSthe7mHHXvQUkyF3aCESBH
         x09n0Nid2fsa8RCqAShcyHR01JqSdFESXgzUcBhrb+QkYTgHJ68TnVfuO6+4q56JUoDH
         lxpqApIUbHTlc+9iMYXHRw5kK0teaRUsJ1STRRsgWdv27ygQy6nJJK8dAtqBuhIEFsJA
         qQKcS21luVzhyRr8UEBQs/KsUp111+G7zevtkBdtwFjmtB2NLV3y2L5MGJonrAuKoKEJ
         0hPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=c4q1aukNB19Ywn0yhrK5YppHN0nN9ZnWCosl/BOVje8=;
        b=v39XRQ4NEVPE/bnGmu8otanLcIG3rc9GosFzm+Yjbf9JfsonK2rCsTc3t3cVcBSKLM
         UgNdivJCmsLpUlLwJR4bRm/QzfBbJQBmw246ol17+K7ZbyWgwL5iXQMuNw2OlLzAXV63
         bmiDxrd/Uh7NpVyfc/LTaSVyhgT5c1Y6nxV0owqabmde9jCEpwoVjNb5ogfc22mqUCs3
         BfZhqn9NbZXzMA5/8B7zHm8OjekJJaegAAlpbpgDG3Iexbzs4q22OfU+DVtSFwwYh1qn
         XW3oZ8dq6xRpnXu9Qtydpvh2LhMGwyFO/YVNDOZZJPGiwTAEX1WskxBDIlDS29EoVK5J
         aUiA==
X-Gm-Message-State: AOAM5321qSj+poZ0EUhc+1chkVrc815mtR+B1kOFMEuKqyWMmsXK7USp
        ET/agpjWXBcB/UiDQ+FiRGU=
X-Google-Smtp-Source: ABdhPJykJl4mFrePipnjHt0TpvxaENudHa6jNxkNkOf6DYzLxpODUqNfms27hDJoydvENM6tME91+w==
X-Received: by 2002:a05:6512:2214:b0:449:f68c:b4e4 with SMTP id h20-20020a056512221400b00449f68cb4e4mr1505255lfu.289.1647509958750;
        Thu, 17 Mar 2022 02:39:18 -0700 (PDT)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id w13-20020a2e998d000000b002496199495csm113479lji.55.2022.03.17.02.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 02:39:18 -0700 (PDT)
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
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v2 net-next 1/4] net: bridge: add fdb flag to extent locked port feature
Date:   Thu, 17 Mar 2022 10:38:59 +0100
Message-Id: <20220317093902.1305816-2-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
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
Only the kernel can set this FDB entry flag, while userspace can read
the flag and remove it by deleting the FDB entry.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 include/uapi/linux/neighbour.h |  1 +
 net/bridge/br_fdb.c            |  6 ++++++
 net/bridge/br_input.c          | 10 +++++++++-
 net/bridge/br_private.h        |  3 ++-
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index db05fb55055e..a2df3b9b2f68 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -51,6 +51,7 @@ enum {
 #define NTF_ROUTER	(1 << 7)
 /* Extended flags under NDA_FLAGS_EXT: */
 #define NTF_EXT_MANAGED	(1 << 0)
+#define NTF_EXT_LOCKED	(1 << 1)
 
 /*
  *	Neighbor Cache Entry States.
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6ccda68bd473..57ec559a85a7 100644
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
+		ext_flags |= NTF_EXT_LOCKED;
 
 	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
 		goto nla_put_failure;
 	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
 		goto nla_put_failure;
+	if (nla_put_u8(skb, NDA_FLAGS_EXT, ext_flags))
+		goto nla_put_failure;
+
 	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
 	ci.ndm_confirmed = 0;
 	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index e0c13fcc50ed..5ef25a496806 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -94,8 +94,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
 
 		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
-		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
+		    test_bit(BR_FDB_LOCAL, &fdb_src->flags) ||
+		    test_bit(BR_FDB_ENTRY_LOCKED, &fdb_src->flags)) {
+			if (!fdb_src) {
+				unsigned long flags = 0;
+
+				set_bit(BR_FDB_ENTRY_LOCKED, &flags);
+				br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, flags);
+			}
 			goto drop;
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

