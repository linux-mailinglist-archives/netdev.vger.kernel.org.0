Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458082F023D
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 18:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbhAIR2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 12:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbhAIR2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 12:28:46 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589D1C0617AB
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 09:27:38 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id p22so14382038edu.11
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 09:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y5075XoRq/naKOi0oQrgK3T4us5KSR/CqJIewrlagG8=;
        b=c3eh4ZHcPMmvJtwfHel61WjMp7CRfQwd7teHI/qwPOAHr7YUhhX+cb52NMcqB3BG9N
         99ku3n57isB8odv1eaudISH8nc+MIDaWfqeZ+etSFcVYIqpL8q2045aNwSQfS6rUXkPj
         ItokeRGxrpQ6DCmPG+qrYSEPb3lA8my71EoJHrKO4PSkth1ggoJEEHliEBkaJbx9PHS8
         T8bJkdhZ2NJPrjA+CLiVk6hI9YOZGrtX45h9YNPaplemtZqMGUELKoOf4nT8QPrgyjf1
         VeKU6zANGBth8T+23VxuHiP5HvsBeGgv8YkkSBGqEzWRSad+fdsvVuSFyDvBk1D8dFYu
         wBZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y5075XoRq/naKOi0oQrgK3T4us5KSR/CqJIewrlagG8=;
        b=T1ZL3dBZBqqjXYtONFcwDOmt+Mxtoz33JyW7hTJxORAs40ROXMrLX4brfpr/hdCimf
         dphGaZbNj/w2Gfcc9opDRQHhPtcCdXaLTsWxDvFz+S+X76HhwifN0FIvcV3McUJcTUsc
         wasdlryXdNB2TrALT1hYIqHKT8/XE8WWjhcscJJNoHaLGbuibO9wPtBeUcn4i/tgc7D3
         hfrl9bQKvKAKI5WLYiXkltACD3htK4cBT0DbpZmDHbN2gbDJt/aLdJ4wt/udzaMEbQZP
         67TVB0kyUvYS6rADTvMvcGqeHBz/6Ku2HkCQrKVhCytIZf1NdRvqJtpP3l1gQbpcj0Bm
         8NHA==
X-Gm-Message-State: AOAM533Z8YfNIS7jIC/OaCKgiTj4XI7/QN5YsDf/5kxKF+cc2FcUn8kw
        vKnzcHYMtSjZayYU9q+Fl0k=
X-Google-Smtp-Source: ABdhPJzi9Md1EHX932E8Q9jwrNUuvWw7ko291sQK90a0sS+B793COtII1PXScrAzYdzJDxq6d1AOdw==
X-Received: by 2002:a05:6402:318f:: with SMTP id di15mr9072932edb.237.1610213257079;
        Sat, 09 Jan 2021 09:27:37 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h16sm4776714eji.110.2021.01.09.09.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 09:27:36 -0800 (PST)
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
Subject: [PATCH v6 net-next 10/15] net: openvswitch: propagate errors from dev_get_stats
Date:   Sat,  9 Jan 2021 19:26:19 +0200
Message-Id: <20210109172624.2028156-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109172624.2028156-1-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
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
Changes in v6:
None.

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

