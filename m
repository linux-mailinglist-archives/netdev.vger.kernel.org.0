Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B312EF5DD
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbhAHQdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728092AbhAHQdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:40 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7756C0612A5
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:35 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id d17so15258686ejy.9
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZD9IDARfyDQAfyn8rtiOrhgy3CFrtxmODytn6yLlrbk=;
        b=KN216R5AczqiSIVIBS2LKw93x5U+0mjmySlOiqpwFX9SVu2mnKRnmF2NJpOrli7fcF
         4iMrATULZsh+LTJFLmX6DOVifGnn7DOb38g70Tqaxbw7hgemEbKieV4LAnOlOtJGxhNo
         RoznfjKPP4pAUgBlrDXEwKNhKcfrJ5yJEGZT78S8EfzdwUz2r10KRo3JDxDxb4xXnGMX
         FEMQloFy5c/aEkm2YwPKowZZjrX2X9iyiDWpn/wHhMxya7b8iCziIvVwhhIn0woLnCiZ
         8/Q5GWBawXDo2xryIKcl/TK+82bdQsR15GDvhmua/8Tx/1kA1rBci83/opC1e4CjNvmV
         Eekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZD9IDARfyDQAfyn8rtiOrhgy3CFrtxmODytn6yLlrbk=;
        b=tIKqMG2i6vbHqAcL4LEAqNBDC8L96lSB91rN16p4QlX2/vYn6Oo7qfU9zD1Wp3pG7v
         GOaHTC00AGT+D1LAdDgal2Bgnrc11NCmdBM4x4QiHZcgAVVyeJZlt0TmlpVu6dM4VeHA
         UvWqmJ1XkOaqzXoXtmubwRq6SC0ulXu/6t0oBv3yMb4oHHA3qU4bLLZtnWgc5ZtZKVH9
         OO6UoL/fAnkuAUFMs9EsdEMFzrT1bjgkoLfX/uE/Dh1QwX+eaQA6Gkd+UFA2UMDYbReu
         v0N3VOPLzD4VA721WNunwJgEVQHw03SKiqN6jaMuIA8SFc2ixY6dt8dOLoiygwINTrN9
         gSog==
X-Gm-Message-State: AOAM533hBBH2Vy/14Fto8Zevc2BCv8yDuSLaVDlZG8oBGTQG2+2Xv4pX
        XGixUVhs0y2p/PsVYq1b0wU=
X-Google-Smtp-Source: ABdhPJxIP9nkmlXPaZ23g8dkFkpmBG3t8QKvWdSr7wd+IrIPthBdY+Qq5nwZfHqxJWDXbS2+25jkKw==
X-Received: by 2002:a17:906:1f8e:: with SMTP id t14mr3232503ejr.350.1610123554359;
        Fri, 08 Jan 2021 08:32:34 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:33 -0800 (PST)
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
Subject: [PATCH v5 net-next 10/16] net: openvswitch: propagate errors from dev_get_stats
Date:   Fri,  8 Jan 2021 18:31:53 +0200
Message-Id: <20210108163159.358043-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108163159.358043-1-olteanv@gmail.com>
References: <20210108163159.358043-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The dev_get_stats function can now return an error code, so the code
that retrieves vport statistics and sends them through netlink needs to
propagate that error code.

Modify the drastic BUG_ON checks to operate only on the -EMSGSIZE error
code (the only error code previously possible), and not crash the kernel
in case dev_get_stats fails. This is in line with what rtnetlink.c does.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
Still keeping the BUG_ON condition except for the output of
ovs_vport_get_stats.

Changes in v4:
Patch is new (Eric's suggestion).

 net/openvswitch/datapath.c | 25 +++++++++++++++++++------
 net/openvswitch/vport.c    | 10 ++++++++--
 net/openvswitch/vport.h    |  2 +-
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 9d6ef6cb9b26..160b8dc453da 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1987,7 +1987,10 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 			goto nla_put_failure;
 	}
 
-	ovs_vport_get_stats(vport, &vport_stats);
+	err = ovs_vport_get_stats(vport, &vport_stats);
+	if (err)
+		goto error;
+
 	if (nla_put_64bit(skb, OVS_VPORT_ATTR_STATS,
 			  sizeof(struct ovs_vport_stats), &vport_stats,
 			  OVS_VPORT_ATTR_PAD))
@@ -2028,7 +2031,9 @@ struct sk_buff *ovs_vport_cmd_build_info(struct vport *vport, struct net *net,
 
 	retval = ovs_vport_cmd_fill_info(vport, skb, net, portid, seq, 0, cmd,
 					 GFP_KERNEL);
-	BUG_ON(retval < 0);
+	BUG_ON(retval == -EMSGSIZE);
+	if (retval)
+		return ERR_PTR(retval);
 
 	return skb;
 }
@@ -2173,6 +2178,9 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
 				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
+	BUG_ON(err == -EMSGSIZE);
+	if (err)
+		goto exit_unlock_free;
 
 	new_headroom = netdev_get_fwd_headroom(vport->dev);
 
@@ -2181,7 +2189,6 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	else
 		netdev_set_rx_headroom(vport->dev, dp->max_headroom);
 
-	BUG_ON(err < 0);
 	ovs_unlock();
 
 	ovs_notify(&dp_vport_genl_family, reply, info);
@@ -2234,7 +2241,9 @@ static int ovs_vport_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
 				      OVS_VPORT_CMD_SET, GFP_KERNEL);
-	BUG_ON(err < 0);
+	BUG_ON(err == -EMSGSIZE);
+	if (err)
+		goto exit_unlock_free;
 
 	ovs_unlock();
 	ovs_notify(&dp_vport_genl_family, reply, info);
@@ -2274,7 +2283,9 @@ static int ovs_vport_cmd_del(struct sk_buff *skb, struct genl_info *info)
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
 				      OVS_VPORT_CMD_DEL, GFP_KERNEL);
-	BUG_ON(err < 0);
+	BUG_ON(err == -EMSGSIZE);
+	if (err)
+		goto exit_unlock_free;
 
 	/* the vport deletion may trigger dp headroom update */
 	dp = vport->dp;
@@ -2321,7 +2332,9 @@ static int ovs_vport_cmd_get(struct sk_buff *skb, struct genl_info *info)
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
 				      OVS_VPORT_CMD_GET, GFP_ATOMIC);
-	BUG_ON(err < 0);
+	BUG_ON(err == -EMSGSIZE);
+	if (err)
+		goto exit_unlock_free;
 	rcu_read_unlock();
 
 	return genlmsg_reply(reply, info);
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 215a818bf9ce..e66c949fd97a 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -267,11 +267,15 @@ void ovs_vport_del(struct vport *vport)
  *
  * Must be called with ovs_mutex or rcu_read_lock.
  */
-void ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
+int ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
 {
 	struct rtnl_link_stats64 dev_stats;
+	int err;
+
+	err = dev_get_stats(vport->dev, &dev_stats);
+	if (err)
+		return err;
 
-	dev_get_stats(vport->dev, &dev_stats);
 	stats->rx_errors  = dev_stats.rx_errors;
 	stats->tx_errors  = dev_stats.tx_errors;
 	stats->tx_dropped = dev_stats.tx_dropped;
@@ -281,6 +285,8 @@ void ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
 	stats->rx_packets = dev_stats.rx_packets;
 	stats->tx_bytes	  = dev_stats.tx_bytes;
 	stats->tx_packets = dev_stats.tx_packets;
+
+	return 0;
 }
 
 /**
diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
index 1eb7495ac5b4..8927ba5c491b 100644
--- a/net/openvswitch/vport.h
+++ b/net/openvswitch/vport.h
@@ -30,7 +30,7 @@ void ovs_vport_del(struct vport *);
 
 struct vport *ovs_vport_locate(const struct net *net, const char *name);
 
-void ovs_vport_get_stats(struct vport *, struct ovs_vport_stats *);
+int ovs_vport_get_stats(struct vport *, struct ovs_vport_stats *);
 
 int ovs_vport_set_options(struct vport *, struct nlattr *options);
 int ovs_vport_get_options(const struct vport *, struct sk_buff *);
-- 
2.25.1

