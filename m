Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD40FC1E67
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 11:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbfI3Jsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 05:48:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37482 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730514AbfI3Js3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 05:48:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id i1so10494321wro.4
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 02:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V+ccQabzfK8HaoGRAwsqiMGRIoktLjGAt+mVsgp4ayo=;
        b=kxyn7HGq3rt0JVukCmvFSz86MsdUyIHMRSLR1vpCBg5zNGio62chi1YITj9OnLqN6U
         2jocCIYaqi+hihRyIZWOaKQprQg5ayz/YCrRUcbf8TGJsCoPsrBTCZbqKWHmXxp/mIf1
         UuVdhHjPrdjXVapqxYQi6Yl6CmqgsNb5wSplfsOs7SIDUYLn9Vc1peSLbKbvFlK0CFw+
         trnvZ4PgHGrbsUMo00unuj6xxcsPqNDo6yjEe7ySV/3ueuaBog8K+l5AYMWZMMjG7Fpw
         M+k1efM32ZRmHH8/JHeHRDYxUq0ZMzw26Uwj8Wo/YZbV0X8lqbQq9RRa+U4//eWgcK4o
         Kl4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V+ccQabzfK8HaoGRAwsqiMGRIoktLjGAt+mVsgp4ayo=;
        b=VqUaLu1UpU90PyzJgxpu1AoxuWZn5aPnQVZe8VKvttDeNAm/9390hKukNO3ioxDhCW
         E7JT5r99aSODtsIr3tU/w07fH9G1v2pDEImYdn4ArHLon7mTUAJnSWY0sY500MuULAf9
         eUyT3l4xNS4Srdfk67aqOo8HpKn2oTdeg8Xvq4XnZWhLj6LCIVR3D6Ym/jVT9rF5ZFHy
         el+2DMqJsPUhDExhGdfzZXiRf85wZuguLKdVcU21eP1UKPREsqEXQz3XMxw1nfc9uVpf
         uZPgqxhpmdsFNfDg+/1LQKUfbFqzYHrPmRwya8Z0bBM441ScejDErr4dyCyaKZYMZTK0
         qbcw==
X-Gm-Message-State: APjAAAVOP5w0x705koqdU18axR8UBE8V4GAM8+V5YWO7xNSbjqYIrd4o
        Ydaqcbc/nukL38bP/HIq8JW9bx/+FWc=
X-Google-Smtp-Source: APXvYqzK/BYLFQuttOzHndM+aIjkaFMTegkPCaw+ih9qssf4KicOWCJg9S1JwLthEoqyXxuRvXR8rA==
X-Received: by 2002:a5d:4704:: with SMTP id y4mr11999794wrq.363.1569836906304;
        Mon, 30 Sep 2019 02:48:26 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id h125sm26973353wmf.31.2019.09.30.02.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 02:48:26 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
Subject: [patch net-next 4/7] net: rtnetlink: put alternative names to getlink message
Date:   Mon, 30 Sep 2019 11:48:17 +0200
Message-Id: <20190930094820.11281-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930094820.11281-1-jiri@resnulli.us>
References: <20190930094820.11281-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Extend exiting getlink info message with list of properties. Now the
only ones are alternative names.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
rfc->v1:
- move size initialization after early return in
  rtnl_alt_ifname_list_size()/rtnl_prop_list_size()
- converted to generic property list
---
 net/core/rtnetlink.c | 53 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index e13646993d82..c38917371b84 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -980,6 +980,19 @@ static size_t rtnl_xdp_size(void)
 	return xdp_size;
 }
 
+static size_t rtnl_prop_list_size(const struct net_device *dev)
+{
+	struct netdev_name_node *name_node;
+	size_t size;
+
+	if (list_empty(&dev->name_node->list))
+		return 0;
+	size = nla_total_size(0);
+	list_for_each_entry(name_node, &dev->name_node->list, list)
+		size += nla_total_size(ALTIFNAMSIZ);
+	return size;
+}
+
 static noinline size_t if_nlmsg_size(const struct net_device *dev,
 				     u32 ext_filter_mask)
 {
@@ -1027,6 +1040,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4)  /* IFLA_CARRIER_DOWN_COUNT */
 	       + nla_total_size(4)  /* IFLA_MIN_MTU */
 	       + nla_total_size(4)  /* IFLA_MAX_MTU */
+	       + rtnl_prop_list_size(dev)
 	       + 0;
 }
 
@@ -1584,6 +1598,42 @@ static int rtnl_fill_link_af(struct sk_buff *skb,
 	return 0;
 }
 
+static int rtnl_fill_alt_ifnames(struct sk_buff *skb,
+				 const struct net_device *dev)
+{
+	struct netdev_name_node *name_node;
+	int count = 0;
+
+	list_for_each_entry(name_node, &dev->name_node->list, list) {
+		if (nla_put_string(skb, IFLA_ALT_IFNAME, name_node->name))
+			return -EMSGSIZE;
+		count++;
+	}
+	return count;
+}
+
+static int rtnl_fill_prop_list(struct sk_buff *skb,
+			       const struct net_device *dev)
+{
+	struct nlattr *prop_list;
+	int ret;
+
+	prop_list = nla_nest_start(skb, IFLA_PROP_LIST);
+	if (!prop_list)
+		return -EMSGSIZE;
+
+	ret = rtnl_fill_alt_ifnames(skb, dev);
+	if (ret <= 0)
+		goto nest_cancel;
+
+	nla_nest_end(skb, prop_list);
+	return 0;
+
+nest_cancel:
+	nla_nest_cancel(skb, prop_list);
+	return ret;
+}
+
 static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			    struct net_device *dev, struct net *src_net,
 			    int type, u32 pid, u32 seq, u32 change,
@@ -1697,6 +1747,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 		goto nla_put_failure_rcu;
 	rcu_read_unlock();
 
+	if (rtnl_fill_prop_list(skb, dev))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.21.0

