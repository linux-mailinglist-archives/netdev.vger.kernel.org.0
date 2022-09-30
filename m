Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328FF5F07EA
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 11:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiI3JqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 05:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiI3Jpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 05:45:35 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301A37A515
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:45:31 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id w2so3818187pfb.0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=I88Bhp8kgoRmaZpJv0N7/N0eraEpryMtGD+fFBFRO6w=;
        b=LZRMR/gWxFgdhXdxpYUdUPIsJ7vgdszV6zt7xDSOtcK5WcNzRHX6lexqsuJXjQ7AkB
         M945h3fjmEY105vM5Yw0KswsZvL0fTGYNxw4h5OezdXsngH/yWKtZXbrKHjGwPfZM2lM
         R9dg0m5kcE5AbdCWB+O5FZBHLAXi9Nwu9CWRZTPlg6dwWec8+lF9FCwosV1NNFmN1u7p
         VnkQA2o7kkIX4SPX/njvY6Dh8aKmJvTl7/uceUAP8jEXidqF3PfO13a08hjoeE9U3RD3
         OC4N/IcerV/6WaRtnvH85tINrEDAPdJyNog9YrlpOZTvPrA9wAWOSg2aZtMN3LPrUAsS
         T1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=I88Bhp8kgoRmaZpJv0N7/N0eraEpryMtGD+fFBFRO6w=;
        b=UhEr7WoMGFlbhelZkX1N83xYd56KLNoJ7pTFgDZCAkAY17lQUT8AecWGqAUaL+izNW
         WVbyj7hNBnDtmkXr2dQci4c7P7xnarqWaMCOwFKLcEDZx0ctJ4LoL53nQD0HYcKqsnqg
         JhsZ2uQjYrwa2mUBPph85ZTRCtNVEVA8GGHl0GMEm5Eb9Hu5CqyFGmYoMudp4DYfPyIf
         S5kc7tOlB641vCHu8sgnU+TDXhCRgh1mzA0wZqumILBXm0ami80sZD7yTsz0NHbrH3vz
         O6nU5vR7I+QZw0E3L3ysro2PVjctuD0O+rIRAH9GAKoNals5BaOsI8fHiL4ASxMAXa72
         SKdw==
X-Gm-Message-State: ACrzQf0H8C7ShIXpPVAA4/73h1m82Kb4kTQ1SeP4Wvv3gMTD89sgh8Jb
        gzNvznc2ph88wlcvEQPmqymDTsGC1hvA2A==
X-Google-Smtp-Source: AMsMyM4slJguPw19Yr1OH3cXqDzL5SLs9074DjHoAFmO3DpCtkGKJznc4ab3eBW0q5WyACIaKN5AVA==
X-Received: by 2002:a62:1dc5:0:b0:540:d8a4:a4ca with SMTP id d188-20020a621dc5000000b00540d8a4a4camr7994800pfd.77.1664531130336;
        Fri, 30 Sep 2022 02:45:30 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c28-20020aa7953c000000b0054d1a2ee8cfsm1305187pfp.103.2022.09.30.02.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 02:45:30 -0700 (PDT)
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
Subject: [PATCHv5 net-next 4/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link
Date:   Fri, 30 Sep 2022 17:45:06 +0800
Message-Id: <20220930094506.712538-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220930094506.712538-1-liuhangbin@gmail.com>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
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
index da9a6fd156d8..3144ec7324b9 100644
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

