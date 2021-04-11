Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5B135B5C7
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 17:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbhDKPET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 11:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbhDKPET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 11:04:19 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8668AC061574;
        Sun, 11 Apr 2021 08:04:02 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h10so11961221edt.13;
        Sun, 11 Apr 2021 08:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lgxZt4qmUinPpQwAqhqlCDZULXlHFnKBwRrbCmMUAGA=;
        b=Kox88v6eK8fD7zmIONpE+adu5p0RZIXQ/Xce7UP+XLsgRdBcVuPCWHTcvBvUXIH6U4
         ljvL4f6vQvR/VWfqWY0b8H0PWos5KopMSgVhC5s3N9qtz0Nja0UetGPJYAFecXYgcWqS
         iNR+izJoY7TfkNnnqd7EMairnUi2S+LVIlPZZ9ZSOxDUaL88fvUsbclcuc6CRYwfSM4Z
         rlXw9sbV/atoPiYU5jFdLPBbf1msdykvvqMkJMWRNMi1ffbb5dF/tBOSbB5x82n2HfRJ
         zipQgB9QVT99+k7klOtBLxsqk0YIXkxbq0HWLIDKCg4efr6Luk+vNLkjcXQw2/sVRXRm
         MqOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lgxZt4qmUinPpQwAqhqlCDZULXlHFnKBwRrbCmMUAGA=;
        b=DNTBkPIspLQOXLpKZPwPsln2B1Zh8+1SiCWsnTHW/RgmUc1If+upB0ABwPOIzdc9J8
         US6iomvXPxBb3VG4gUWN4h8OU4SNaA9jzAlLx4OupkXRQqXsAZQXBkkkCYpLrmfYzR/r
         qtM3kpLI33foN2ZBOsxJNzFyUddH5X4V/nbYUPQB8r5ELI80S+Njaez41W7ohWVsTGb7
         YPtWAKw7QNiagszpBpLCJi+v87zK2vyrbHamzs00ZYPaeIvLJRoHn3SRWbGnSb/X39cb
         QdKAwrBu5sIzVk2HofGYqcPDmQ9kgyOFgPocJxenSjqkL22X+UvQRh/aCHXc8Wfx23CC
         qQGQ==
X-Gm-Message-State: AOAM5328AiADS9KhgrdpnohE79ub4Ll4+NBOZ9X0p22jsoOjLjbbNhFp
        XWZS5B2prQ5K/s4Vf8/jX+c2Px1VNSRpaA==
X-Google-Smtp-Source: ABdhPJzpOK3bXAu7N4W0TVcg/QZR71efp6cbARnC6KWGEji++LH34vGZyV3Wdfpkdurxh4hYlI4oZA==
X-Received: by 2002:a05:6402:350f:: with SMTP id b15mr25464285edd.6.1618153440843;
        Sun, 11 Apr 2021 08:04:00 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-95-239-254-7.retail.telecomitalia.it. [95.239.254.7])
        by smtp.googlemail.com with ESMTPSA id l15sm4736146edb.48.2021.04.11.08.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 08:04:00 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC net-next 2/3] net: add ndo for setting the iflink property
Date:   Sat, 10 Apr 2021 15:34:48 +0200
Message-Id: <20210410133454.4768-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210410133454.4768-1-ansuelsmth@gmail.com>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>

In DSA the iflink value is used to report to which CPU port a given
switch port is connected to. Since we want to support multi-CPU DSA, we
want the user to be able to change this value.

Add ndo_set_iflink method into the ndo strucutre to be a pair to
ndo_get_iflink. Also create dev_set_iflink and call this from the
netlink code, so that userspace can change the iflink value.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 include/linux/netdevice.h |  5 +++++
 net/core/dev.c            | 15 +++++++++++++++
 net/core/rtnetlink.c      |  7 +++++++
 3 files changed, 27 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 87a5d186faff..76054182c288 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1225,6 +1225,8 @@ struct netdev_net_notifier {
  *	TX queue.
  * int (*ndo_get_iflink)(const struct net_device *dev);
  *	Called to get the iflink value of this device.
+ * int (*ndo_set_iflink)(struct net_device *dev, int iflink);
+ *	Called to set the iflink value of this device.
  * void (*ndo_change_proto_down)(struct net_device *dev,
  *				 bool proto_down);
  *	This function is used to pass protocol port error state information
@@ -1456,6 +1458,8 @@ struct net_device_ops {
 						      int queue_index,
 						      u32 maxrate);
 	int			(*ndo_get_iflink)(const struct net_device *dev);
+	int			(*ndo_set_iflink)(struct net_device *dev,
+						  int iflink);
 	int			(*ndo_change_proto_down)(struct net_device *dev,
 							 bool proto_down);
 	int			(*ndo_fill_metadata_dst)(struct net_device *dev,
@@ -2845,6 +2849,7 @@ void dev_add_offload(struct packet_offload *po);
 void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
+int dev_set_iflink(struct net_device *dev, int iflink);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
 struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
 				      unsigned short mask);
diff --git a/net/core/dev.c b/net/core/dev.c
index 0f72ff5d34ba..9e5ddcf6d401 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -822,6 +822,21 @@ int dev_get_iflink(const struct net_device *dev)
 }
 EXPORT_SYMBOL(dev_get_iflink);
 
+/**
+ *	dev_set_iflink - set 'iflink' value of an interface
+ *	@dev: target interface
+ *	@iflink: new value
+ *
+ *	Change the interface to which this interface is linked to.
+ */
+int dev_set_iflink(struct net_device *dev, int iflink)
+{
+	if (dev->netdev_ops && dev->netdev_ops->ndo_set_iflink)
+		return dev->netdev_ops->ndo_set_iflink(dev, iflink);
+
+	return -EOPNOTSUPP;
+}
+
 /**
  *	dev_fill_metadata_dst - Retrieve tunnel egress information.
  *	@dev: targeted interface
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1bdcb33fb561..629b7685f942 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2718,6 +2718,13 @@ static int do_setlink(const struct sk_buff *skb,
 		status |= DO_SETLINK_MODIFIED;
 	}
 
+	if (tb[IFLA_LINK]) {
+		err = dev_set_iflink(dev, nla_get_u32(tb[IFLA_LINK]));
+		if (err)
+			goto errout;
+		status |= DO_SETLINK_MODIFIED;
+	}
+
 	if (tb[IFLA_CARRIER]) {
 		err = dev_change_carrier(dev, nla_get_u8(tb[IFLA_CARRIER]));
 		if (err)
-- 
2.30.2

