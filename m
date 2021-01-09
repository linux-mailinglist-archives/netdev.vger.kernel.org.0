Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2D42F0243
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 18:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbhAIR3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 12:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbhAIR2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 12:28:48 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA77C0617B1
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 09:27:41 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id cm17so14483181edb.4
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 09:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0reHTgeA6uUXSGgmhIjkpBPzkJXmAfi9+BfDtKYO0M0=;
        b=T1l0K0tJXBAmg00fFgY/VbFQIxiu222QJYPwYx1oEQc3nYMBCGFKJDIShcgsxgDXyQ
         WA1mE/dV1bpOBv7EVh1OsgDmaXXpa9T+cTIzvyBlBplaWgwF0ucVlEJ/NBjLzTRfIiBZ
         iXwKaP564vyfPIn+fo1Dkgfx+DYQYnfIkZGBgsELjMe18laGltwld/u6CIWglyW0uNpE
         OiAgHlVodc9tRpu9tJ3rvEywgARybDtog2wGAWml8ZmRIgHOv6UoDJmiloRB/juu94yK
         NwS+c6v/vOyx5gyHD3f8csTepimoUHgcVm5h1jVjmQ8KxMKJw4/tBeYlxl5WLcL2YGj1
         quIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0reHTgeA6uUXSGgmhIjkpBPzkJXmAfi9+BfDtKYO0M0=;
        b=apUHgeXQRn/N7TrToXHYZORCRAz4o+8Gfpzaqm5Wnw78T6oWN1UtGpg1XfYVpv4C3x
         o9HQJYkfmQgcOhpyN5O+CFhEwygnLW4zSxuhHPrau3LQ8A3XhMvwfqhQz5pXIJomGMrS
         ZfQref+GPFCSf+6VXNw+0qSAJQ0+YsFxnmMXSywMZH7BbcPUgM3vszw/yrFlfOEkvkic
         rtzitGxXxPaf8Hun9cg4TD5Mnt/gjN6lPJPryLKg5dHLVv0Nsh43DjMFadUL92Mk+MzZ
         dz1o3YsMq2Pueg4/dYmeCYWLdAZuTTQ2r/khp0SRDsc58H02YqZwUFNCBS6roRj4XaX6
         Bgbw==
X-Gm-Message-State: AOAM530YzUmRZvSqa+XnXLzrTsf/hjRcNfJY6iq2f3zOzesAmhbiOsdZ
        Qwu7UpwEOPNZNLWW5KCq3/M=
X-Google-Smtp-Source: ABdhPJwnfzPOfr254LlsTqe0CwzKwJD4W7P44aKOu/bv7awPI5dn7L42zgiEn1rt9FGa4hYQjfZLcg==
X-Received: by 2002:a50:b5c5:: with SMTP id a63mr9125638ede.227.1610213260387;
        Sat, 09 Jan 2021 09:27:40 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h16sm4776714eji.110.2021.01.09.09.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 09:27:39 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v6 net-next 12/15] net: openvswitch: ensure dev_get_stats can sleep
Date:   Sat,  9 Jan 2021 19:26:21 +0200
Message-Id: <20210109172624.2028156-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109172624.2028156-1-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is an effort to convert .ndo_get_stats64 to sleepable context, and
for that to work, we need to prevent callers of dev_get_stats from using
atomic locking.

The OVS vport driver calls ovs_vport_get_stats from
ovs_vport_cmd_fill_info, a function with 7 callers: 5 under ovs_lock() and
2 under rcu_read_lock(). The RCU-protected callers are the doit and
dumpit callbacks of the OVS_VPORT_CMD_GET genetlink event. Things have
been this way ever since the OVS introduction in commit ccb1352e76cf
("net: Add Open vSwitch kernel components."), probably so that
OVS_PORT_CMD_GET doesn't have to serialize with all the others through
ovs_mutex. Sadly, now they do have to, otherwise we don't have
protection while accessing the datapath and vport structures.

Convert all callers of ovs_vport_cmd_fill_info to assume ovs_mutex
protection. This means that we can get rid of the gfp argument, since
all callers are now sleepable, we can just use GFP_KERNEL for memory
allocation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v6:
None.

Changes in v5:
None.

Changes in v4:
Patch is new.

 net/openvswitch/datapath.c | 38 ++++++++++++++++++--------------------
 net/openvswitch/vport.c    |  2 +-
 2 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 160b8dc453da..318caa8f12c2 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1957,10 +1957,10 @@ static struct genl_family dp_datapath_genl_family __ro_after_init = {
 	.module = THIS_MODULE,
 };
 
-/* Called with ovs_mutex or RCU read lock. */
+/* Called with ovs_mutex */
 static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 				   struct net *net, u32 portid, u32 seq,
-				   u32 flags, u8 cmd, gfp_t gfp)
+				   u32 flags, u8 cmd)
 {
 	struct ovs_header *ovs_header;
 	struct ovs_vport_stats vport_stats;
@@ -1981,7 +1981,7 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (!net_eq(net, dev_net(vport->dev))) {
-		int id = peernet2id_alloc(net, dev_net(vport->dev), gfp);
+		int id = peernet2id_alloc(net, dev_net(vport->dev), GFP_KERNEL);
 
 		if (nla_put_s32(skb, OVS_VPORT_ATTR_NETNSID, id))
 			goto nla_put_failure;
@@ -2029,8 +2029,7 @@ struct sk_buff *ovs_vport_cmd_build_info(struct vport *vport, struct net *net,
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-	retval = ovs_vport_cmd_fill_info(vport, skb, net, portid, seq, 0, cmd,
-					 GFP_KERNEL);
+	retval = ovs_vport_cmd_fill_info(vport, skb, net, portid, seq, 0, cmd);
 	BUG_ON(retval == -EMSGSIZE);
 	if (retval)
 		return ERR_PTR(retval);
@@ -2038,7 +2037,7 @@ struct sk_buff *ovs_vport_cmd_build_info(struct vport *vport, struct net *net,
 	return skb;
 }
 
-/* Called with ovs_mutex or RCU read lock. */
+/* Called with ovs_mutex */
 static struct vport *lookup_vport(struct net *net,
 				  const struct ovs_header *ovs_header,
 				  struct nlattr *a[OVS_VPORT_ATTR_MAX + 1])
@@ -2177,7 +2176,7 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
+				      OVS_VPORT_CMD_NEW);
 	BUG_ON(err == -EMSGSIZE);
 	if (err)
 		goto exit_unlock_free;
@@ -2240,7 +2239,7 @@ static int ovs_vport_cmd_set(struct sk_buff *skb, struct genl_info *info)
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_SET, GFP_KERNEL);
+				      OVS_VPORT_CMD_SET);
 	BUG_ON(err == -EMSGSIZE);
 	if (err)
 		goto exit_unlock_free;
@@ -2282,7 +2281,7 @@ static int ovs_vport_cmd_del(struct sk_buff *skb, struct genl_info *info)
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_DEL, GFP_KERNEL);
+				      OVS_VPORT_CMD_DEL);
 	BUG_ON(err == -EMSGSIZE);
 	if (err)
 		goto exit_unlock_free;
@@ -2324,23 +2323,23 @@ static int ovs_vport_cmd_get(struct sk_buff *skb, struct genl_info *info)
 	if (!reply)
 		return -ENOMEM;
 
-	rcu_read_lock();
+	ovs_lock();
 	vport = lookup_vport(sock_net(skb->sk), ovs_header, a);
 	err = PTR_ERR(vport);
 	if (IS_ERR(vport))
 		goto exit_unlock_free;
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_GET, GFP_ATOMIC);
+				      OVS_VPORT_CMD_GET);
 	BUG_ON(err == -EMSGSIZE);
 	if (err)
 		goto exit_unlock_free;
-	rcu_read_unlock();
+	ovs_unlock();
 
 	return genlmsg_reply(reply, info);
 
 exit_unlock_free:
-	rcu_read_unlock();
+	ovs_unlock();
 	kfree_skb(reply);
 	return err;
 }
@@ -2352,25 +2351,24 @@ static int ovs_vport_cmd_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	int bucket = cb->args[0], skip = cb->args[1];
 	int i, j = 0;
 
-	rcu_read_lock();
-	dp = get_dp_rcu(sock_net(skb->sk), ovs_header->dp_ifindex);
+	ovs_lock();
+	dp = get_dp(sock_net(skb->sk), ovs_header->dp_ifindex);
 	if (!dp) {
-		rcu_read_unlock();
+		ovs_unlock();
 		return -ENODEV;
 	}
 	for (i = bucket; i < DP_VPORT_HASH_BUCKETS; i++) {
 		struct vport *vport;
 
 		j = 0;
-		hlist_for_each_entry_rcu(vport, &dp->ports[i], dp_hash_node) {
+		hlist_for_each_entry(vport, &dp->ports[i], dp_hash_node) {
 			if (j >= skip &&
 			    ovs_vport_cmd_fill_info(vport, skb,
 						    sock_net(skb->sk),
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
 						    NLM_F_MULTI,
-						    OVS_VPORT_CMD_GET,
-						    GFP_ATOMIC) < 0)
+						    OVS_VPORT_CMD_GET) < 0)
 				goto out;
 
 			j++;
@@ -2378,7 +2376,7 @@ static int ovs_vport_cmd_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		skip = 0;
 	}
 out:
-	rcu_read_unlock();
+	ovs_unlock();
 
 	cb->args[0] = i;
 	cb->args[1] = j;
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index e66c949fd97a..ba1a52addff2 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -265,7 +265,7 @@ void ovs_vport_del(struct vport *vport)
  *
  * Retrieves transmit, receive, and error stats for the given device.
  *
- * Must be called with ovs_mutex or rcu_read_lock.
+ * Must be called with ovs_mutex.
  */
 int ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
 {
-- 
2.25.1

