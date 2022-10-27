Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979F260EE3A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbiJ0DAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234090AbiJ0DAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:00:11 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D01642D2
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:00:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b11so258897pjp.2
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Lf/psRwX7p94u6q+A00cEDXXTb5ONBapMsapCfl1a4=;
        b=Vo8M0DtStVVdtdoCSFYHb+mi7DMQTD3zRz1gzMh+DTBbOY+EAvR3t0N/Mu0qoFTC8/
         zT7dHPWZPHKakf+6FgBX5agTWcuTPXa4Bh91eYj4Nons8p5NXs/2GeomgIHiYJv+I0i/
         NOoNMwBG2W6/cvxFKGuSfLMO7Ri3LkdbTQHn0bfWR3JxRdzUMXTz/0PJCrjRTR17M22U
         zuWcp8fxrYzmw7b75fswVt0q4vlOWMCLEMC+Y3m+Otxi0zaE6t4peV9mt3O8HWtVz8bh
         1+8LDvMCjXQBImi9Ca4wT0X827anDe1tKIZ1whLequ+neatndvS1ByuaW0Dl1QqNsO3I
         jGVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Lf/psRwX7p94u6q+A00cEDXXTb5ONBapMsapCfl1a4=;
        b=cTb1ricuWlHvgKPbuNNCHCmZC44tGoPFzqUcM5LV6bt9Oi7SXD2Fsk2XoexcKs9B4x
         frGXnQCdqZ/OiVYt2CFP4/MKJYEBnDjI4Bm2gHxzhZ4n568Vqo3slIBoLuzD4O2KdCCo
         JQg05kjIu2Ci8MdTOPb9G+gWkWyejCvMbAkVleFmmRTJoVBtWlJYaqn9VshrDshsZj5A
         oK5zHpLIuvl4KJZbGoK3mZ2WdaDbKjS53xaJw+lSTjIuXjh+sjRyfb+1sVYoQTX6RkFn
         4k0DgCGxHR+jPpZ5Rb2H3djYLKar4IiPrCqhhUsnlgs7DAWRQfb+EJsGBt+NnImH1YmP
         362A==
X-Gm-Message-State: ACrzQf20Njt7+XMxbeDwP4CrN+1KG66GmYB5AXSjuTqdk56Ytz8CinST
        e155l5MTNXgClYv7/y8w+gMG9btAItex3g==
X-Google-Smtp-Source: AMsMyM6U/9Cj+3F6FnuUMo5/eKPuzFQIjebcQFDHf4GW3JeWOJVvvoaVDRFbDYorXfOJoHcafCQGsw==
X-Received: by 2002:a17:90b:110c:b0:205:cfeb:cfb with SMTP id gi12-20020a17090b110c00b00205cfeb0cfbmr7728905pjb.75.1666839603723;
        Wed, 26 Oct 2022 20:00:03 -0700 (PDT)
Received: from localhost.localdomain ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ix6-20020a170902f80600b0017f756563bcsm54488plb.47.2022.10.26.20.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 20:00:03 -0700 (PDT)
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
Subject: [PATCHv6 net-next 4/4] rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link
Date:   Thu, 27 Oct 2022 10:57:26 +0800
Message-Id: <20221027025726.2138619-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221027025726.2138619-1-liuhangbin@gmail.com>
References: <20221027025726.2138619-1-liuhangbin@gmail.com>
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
since we need nlmsghdr and portid info.

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
index cd94f65dc2a9..d9076a7a430c 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -186,7 +186,7 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 				    const struct rtnl_link_ops *ops,
 				    struct nlattr *tb[],
 				    struct netlink_ext_ack *extack);
-int rtnl_delete_link(struct net_device *dev);
+int rtnl_delete_link(struct net_device *dev, u32 portid, const struct nlmsghdr *nlh);
 int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm,
 			u32 portid, const struct nlmsghdr *nlh);
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 839ff8b7eadc..d2f27548fc0b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3110,7 +3110,7 @@ static int rtnl_group_dellink(const struct net *net, int group)
 	return 0;
 }
 
-int rtnl_delete_link(struct net_device *dev)
+int rtnl_delete_link(struct net_device *dev, u32 portid, const struct nlmsghdr *nlh)
 {
 	const struct rtnl_link_ops *ops;
 	LIST_HEAD(list_kill);
@@ -3120,7 +3120,7 @@ int rtnl_delete_link(struct net_device *dev)
 		return -EOPNOTSUPP;
 
 	ops->dellink(dev, &list_kill);
-	unregister_netdevice_many(&list_kill);
+	unregister_netdevice_many_notify(&list_kill, portid, nlh);
 
 	return 0;
 }
@@ -3130,6 +3130,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
+	u32 portid = NETLINK_CB(skb).portid;
 	struct net *tgt_net = net;
 	struct net_device *dev = NULL;
 	struct ifinfomsg *ifm;
@@ -3171,7 +3172,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 	}
 
-	err = rtnl_delete_link(dev);
+	err = rtnl_delete_link(dev, portid, nlh);
 
 out:
 	if (netnsid >= 0)
diff --git a/net/openvswitch/vport-geneve.c b/net/openvswitch/vport-geneve.c
index 89a8e1501809..b10e1602c6b1 100644
--- a/net/openvswitch/vport-geneve.c
+++ b/net/openvswitch/vport-geneve.c
@@ -91,7 +91,7 @@ static struct vport *geneve_tnl_create(const struct vport_parms *parms)
 
 	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
-		rtnl_delete_link(dev);
+		rtnl_delete_link(dev, 0, NULL);
 		rtnl_unlock();
 		ovs_vport_free(vport);
 		goto error;
diff --git a/net/openvswitch/vport-gre.c b/net/openvswitch/vport-gre.c
index e6b5e76a962a..4014c9b5eb79 100644
--- a/net/openvswitch/vport-gre.c
+++ b/net/openvswitch/vport-gre.c
@@ -57,7 +57,7 @@ static struct vport *gre_tnl_create(const struct vport_parms *parms)
 
 	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
-		rtnl_delete_link(dev);
+		rtnl_delete_link(dev, 0, NULL);
 		rtnl_unlock();
 		ovs_vport_free(vport);
 		return ERR_PTR(err);
diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index 2f61d5bdce1a..903537a5da22 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -172,7 +172,7 @@ void ovs_netdev_tunnel_destroy(struct vport *vport)
 	 * if it's not already shutting down.
 	 */
 	if (vport->dev->reg_state == NETREG_REGISTERED)
-		rtnl_delete_link(vport->dev);
+		rtnl_delete_link(vport->dev, 0, NULL);
 	netdev_put(vport->dev, &vport->dev_tracker);
 	vport->dev = NULL;
 	rtnl_unlock();
diff --git a/net/openvswitch/vport-vxlan.c b/net/openvswitch/vport-vxlan.c
index 188e9c1360a1..0b881b043bcf 100644
--- a/net/openvswitch/vport-vxlan.c
+++ b/net/openvswitch/vport-vxlan.c
@@ -120,7 +120,7 @@ static struct vport *vxlan_tnl_create(const struct vport_parms *parms)
 
 	err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
 	if (err < 0) {
-		rtnl_delete_link(dev);
+		rtnl_delete_link(dev, 0, NULL);
 		rtnl_unlock();
 		ovs_vport_free(vport);
 		goto error;
-- 
2.37.3

