Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1C85F0571
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 09:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiI3HAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 03:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbiI3HAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 03:00:35 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC62F883C7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 00:00:28 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id c7so3409842pgt.11
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 00:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=u+8Ju2TSo+YCt3KTNcBWL095PXCJRQkdfWbpW5r38LQ=;
        b=N7vDUScev/JhLO9wfMysKyQ3vgf+AWN3rweYeMX1N81YfIiQZWFvndRMSYkYZHHMk7
         vBte/symRCGYjwuaZXF4DjlyTDN2Bb+A6/kByEeG8kdcunxgSG9m5P/WZLSsJM1ykMjs
         C/Rz0aOamF1VjfbmBAy6nayyEg9rr2UTi09SBIlOmRCxm12BX/KPiSrLX09HajAvPcnS
         mgQnqZeAhSg+ezIBW1KG/mrIHoZecTnvVMFfF+MQKXXJVOCNEcGQuD+nDax2pXjZArQN
         DsSVzhTyYgE5NA+5QK6J2dY73QXwOAgVTCFyjBEpRw2mTUtheNmSFBPzvV75oPVYxGaU
         xErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=u+8Ju2TSo+YCt3KTNcBWL095PXCJRQkdfWbpW5r38LQ=;
        b=SGUFQ/BrkzLOvZpUl/J3qXuLJiDmrv2gow3NhGvVq1HCeC5mNMHim89cevG2gMSuh2
         YwLqvK0PKNxv27T4DyWC8SiUr9FaV5DmS+/v0frHwyH31u0s6MxCj/kax2hmGOg0SZ6k
         YTgCDSfieuL3yNm0YQhlpkCQw7wqrvDEMzdw+mipUF8bbZ2yuiAHbg7jyRJWTXnt/wju
         ifGirqNtOVepibqAs+C970Uoo5rlDvBwmYinfJzQk5RlHuh2si3Wr9kDMc5IYzEIfREO
         ///R98LH3/iHaMCk9l96MHqRG4Kwit7UKzH339PS9WL6GGcGtbYXtiSuqBvgwqra/hXY
         kb2A==
X-Gm-Message-State: ACrzQf1NaQsR81aOxNgNAenIoKkvLqXLd7sVEOmxSw6dHDW/V8vGNspI
        5pWq6LpdMjllRM3J6QxAPDuRLqf8hj9Bnw==
X-Google-Smtp-Source: AMsMyM5buFjdW0ujWvEPFergJoEijLqikFzTRo2pnJ3x8mADoWDdwWuJ9zf8XgVSVJigAwArNG1lJg==
X-Received: by 2002:a05:6a00:4c91:b0:543:646e:9 with SMTP id eb17-20020a056a004c9100b00543646e0009mr7734069pfb.40.1664521227434;
        Fri, 30 Sep 2022 00:00:27 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j13-20020a63594d000000b0041c0c9c0072sm998268pgm.64.2022.09.30.00.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 00:00:26 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv4 net-next 4/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link
Date:   Fri, 30 Sep 2022 14:59:57 +0800
Message-Id: <20220930065957.694263-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220930065957.694263-1-liuhangbin@gmail.com>
References: <20220930065957.694263-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch use the new helper unregister_netdevice_many_notify() for
rtnl_delete_link(), so that the kernel could reply unicast when userspace
 set NLM_F_ECHO flag to request the new created interface info.

At the same time, the parameters of rtnl_delete_link() need to be updated
since we need nlmsghdr and pid info.

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/rtnetlink.h        | 2 +-
 net/core/rtnetlink.c           | 7 ++++---
 net/openvswitch/vport-geneve.c | 2 +-
 net/openvswitch/vport-gre.c    | 2 +-
 net/openvswitch/vport-netdev.c | 2 +-
 net/openvswitch/vport-vxlan.c  | 2 +-
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index bf8bb3357825..1a152993caef 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -186,7 +186,7 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 				    const struct rtnl_link_ops *ops,
 				    struct nlattr *tb[],
 				    struct netlink_ext_ack *extack);
-int rtnl_delete_link(struct net_device *dev);
+int rtnl_delete_link(struct net_device *dev, struct nlmsghdr *nlh, u32 pid);
 int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm);
 
 int rtnl_nla_parse_ifla(struct nlattr **tb, const struct nlattr *head, int len,
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 935209a1284b..d3279b844e02 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3110,7 +3110,7 @@ static int rtnl_group_dellink(const struct net *net, int group)
 	return 0;
 }
 
-int rtnl_delete_link(struct net_device *dev)
+int rtnl_delete_link(struct net_device *dev, struct nlmsghdr *nlh, u32 pid)
 {
 	const struct rtnl_link_ops *ops;
 	LIST_HEAD(list_kill);
@@ -3120,7 +3120,7 @@ int rtnl_delete_link(struct net_device *dev)
 		return -EOPNOTSUPP;
 
 	ops->dellink(dev, &list_kill);
-	unregister_netdevice_many(&list_kill);
+	unregister_netdevice_many_notify(&list_kill, nlh, pid);
 
 	return 0;
 }
@@ -3130,6 +3130,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
+	u32 pid = NETLINK_CB(skb).portid;
 	struct net *tgt_net = net;
 	struct net_device *dev = NULL;
 	struct ifinfomsg *ifm;
@@ -3171,7 +3172,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 	}
 
-	err = rtnl_delete_link(dev);
+	err = rtnl_delete_link(dev, nlh, pid);
 
 out:
 	if (netnsid >= 0)
diff --git a/net/openvswitch/vport-geneve.c b/net/openvswitch/vport-geneve.c
index 89a8e1501809..0e11ff8ee5ce 100644
--- a/net/openvswitch/vport-geneve.c
+++ b/net/openvswitch/vport-geneve.c
@@ -91,7 +91,7 @@ static struct vport *geneve_tnl_create(const struct vport_parms *parms)
 
 	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
-		rtnl_delete_link(dev);
+		rtnl_delete_link(dev, NULL, 0);
 		rtnl_unlock();
 		ovs_vport_free(vport);
 		goto error;
diff --git a/net/openvswitch/vport-gre.c b/net/openvswitch/vport-gre.c
index e6b5e76a962a..3a299383fca0 100644
--- a/net/openvswitch/vport-gre.c
+++ b/net/openvswitch/vport-gre.c
@@ -57,7 +57,7 @@ static struct vport *gre_tnl_create(const struct vport_parms *parms)
 
 	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
-		rtnl_delete_link(dev);
+		rtnl_delete_link(dev, NULL, 0);
 		rtnl_unlock();
 		ovs_vport_free(vport);
 		return ERR_PTR(err);
diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index 2f61d5bdce1a..1bead7854593 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -172,7 +172,7 @@ void ovs_netdev_tunnel_destroy(struct vport *vport)
 	 * if it's not already shutting down.
 	 */
 	if (vport->dev->reg_state == NETREG_REGISTERED)
-		rtnl_delete_link(vport->dev);
+		rtnl_delete_link(vport->dev, NULL, 0);
 	netdev_put(vport->dev, &vport->dev_tracker);
 	vport->dev = NULL;
 	rtnl_unlock();
diff --git a/net/openvswitch/vport-vxlan.c b/net/openvswitch/vport-vxlan.c
index 188e9c1360a1..dae8eb1a6e7a 100644
--- a/net/openvswitch/vport-vxlan.c
+++ b/net/openvswitch/vport-vxlan.c
@@ -120,7 +120,7 @@ static struct vport *vxlan_tnl_create(const struct vport_parms *parms)
 
 	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
-		rtnl_delete_link(dev);
+		rtnl_delete_link(dev, NULL, 0);
 		rtnl_unlock();
 		ovs_vport_free(vport);
 		goto error;
-- 
2.37.2

