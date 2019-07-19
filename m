Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E6A6E49F
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 13:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfGSLAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 07:00:41 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36068 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727592AbfGSLAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 07:00:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so31885267wrs.3
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 04:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8evSUy0dBlJ7c371pw942gWe7sJQyZhDyFsfVrBrLX4=;
        b=V2+ZlMW2WydhC+EpkAeYc/Zgid/TEjoYWU/Okst1afmuCpNt56yym53FmtEsgI2Kvu
         fr83zeK315ndubMKPMKAMXVr4YBh3C/+qfA4ze9vfpN7F4apok699OfTlzRyNbgCEfTT
         1/WHKnzRkD8KSN+AszsTRSZjlzdbPpu6rlPDo0BQ4j02mPD4lMkWJsE8K1Q8z9vZv0T1
         NpVu+Qez/noK8DsAyBF1aSDAGJPO0MAZ9b2Ia5O0uY221KvZjQ3toJDZn62soXenhhRT
         NY3QKqrSAX3I/RIWR+EVFu8MgdkrMLphP2HOFdriYWCFYHgYHkWZa2B1Dz3U4AtfFLVo
         Wulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8evSUy0dBlJ7c371pw942gWe7sJQyZhDyFsfVrBrLX4=;
        b=bc6iKFh4x2xA806Akfl3c3OiAgFcYrIKEwHB10//Hy4YgYka94AK2Rz74If2fVGozD
         rr9FB1vaGelItQQb1ap9GimhFgxrba9vf2pcWXBRO8FMDuuXEvCdjUulcH00BOAddrRv
         FSk6JouuhN6UT9TvSRnWpYQEMZ9TSLD7GxNu4/nHTJ6T+z6A2jxvDv6QcfIpNmwfjFrj
         1Xr+GNIY5cx876VISC/4I796GxfMnG+JVxnEaqIeiR9mafwnXZL/7Gqs9t91VhaHug2B
         5fTdoTUdApAIg2EExBeH8KU6/rEupF0D7xNCaxX4VcnzmeC6gJC5ja7pFOWne/k3SaRx
         FExQ==
X-Gm-Message-State: APjAAAUgfsg3nIigg/Vx0UMS+FeizUWpZbtl7mhgs2eiazxOs7bEhnEV
        Vc+hUpNVD+GUL0swWBYikegJbm+i
X-Google-Smtp-Source: APXvYqy4t9YyaMFDOTd++RGZN+d4/mJK1i1QKLxFBmWBNj2JWsPkjXpqPFy35EHLpyFI9eXOk2zghQ==
X-Received: by 2002:a5d:4087:: with SMTP id o7mr12615582wrp.277.1563534034495;
        Fri, 19 Jul 2019 04:00:34 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id p6sm29576111wrq.97.2019.07.19.04.00.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 04:00:34 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next rfc 4/7] net: rtnetlink: put alternative names to getlink message
Date:   Fri, 19 Jul 2019 13:00:26 +0200
Message-Id: <20190719110029.29466-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719110029.29466-1-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Extend exiting getlink info message with list of alternative names.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/if_link.h |  2 ++
 net/core/rtnetlink.c         | 41 ++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 92268946e04a..038361f9847b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -168,6 +168,8 @@ enum {
 	IFLA_MIN_MTU,
 	IFLA_MAX_MTU,
 	IFLA_ALT_IFNAME_MOD, /* Alternative ifname to add/delete */
+	IFLA_ALT_IFNAME_LIST, /* nest */
+	IFLA_ALT_IFNAME, /* Alternative ifname */
 	__IFLA_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 7a2010b16e10..f11a2367037d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -980,6 +980,18 @@ static size_t rtnl_xdp_size(void)
 	return xdp_size;
 }
 
+static size_t rtnl_alt_ifname_list_size(const struct net_device *dev)
+{
+	struct netdev_name_node *name_node;
+	size_t size = nla_total_size(0);
+
+	if (list_empty(&dev->name_node->list))
+		return 0;
+	list_for_each_entry(name_node, &dev->name_node->list, list)
+		size += nla_total_size(ALTIFNAMSIZ);
+	return size;
+}
+
 static noinline size_t if_nlmsg_size(const struct net_device *dev,
 				     u32 ext_filter_mask)
 {
@@ -1027,6 +1039,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4)  /* IFLA_CARRIER_DOWN_COUNT */
 	       + nla_total_size(4)  /* IFLA_MIN_MTU */
 	       + nla_total_size(4)  /* IFLA_MAX_MTU */
+	       + rtnl_alt_ifname_list_size(dev)
 	       + 0;
 }
 
@@ -1584,6 +1597,31 @@ static int rtnl_fill_link_af(struct sk_buff *skb,
 	return 0;
 }
 
+static int rtnl_fill_alt_ifnames(struct sk_buff *skb,
+				 const struct net_device *dev)
+{
+	struct netdev_name_node *name_node;
+	struct nlattr *alt_ifname_list;
+
+	if (list_empty(&dev->name_node->list))
+		return 0;
+
+	alt_ifname_list = nla_nest_start_noflag(skb, IFLA_ALT_IFNAME_LIST);
+	if (!alt_ifname_list)
+		return -EMSGSIZE;
+
+	list_for_each_entry(name_node, &dev->name_node->list, list)
+		if (nla_put_string(skb, IFLA_ALT_IFNAME, name_node->name))
+			goto nla_put_failure;
+
+	nla_nest_end(skb, alt_ifname_list);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, alt_ifname_list);
+	return -EMSGSIZE;
+}
+
 static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			    struct net_device *dev, struct net *src_net,
 			    int type, u32 pid, u32 seq, u32 change,
@@ -1697,6 +1735,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 		goto nla_put_failure_rcu;
 	rcu_read_unlock();
 
+	if (rtnl_fill_alt_ifnames(skb, dev))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.21.0

