Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD3C590BDF
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 08:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbiHLGVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 02:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHLGVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 02:21:11 -0400
Received: from mail-m965.mail.126.com (mail-m965.mail.126.com [123.126.96.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73E383AB1A;
        Thu, 11 Aug 2022 23:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=JGPSn
        sJUeHGrj1k5i6Iut36C0p2uCQrpqlgvRnQxyYQ=; b=GZahsZSYES4Mhj+GgczGy
        hCWQZTGRlvAuvvMNUGNLobjyxOWkDJYngequwSKRgePB7FRJpFcuhH2o1/hdJf6e
        yvWox7IgoptrLaC8gEANBn24WN2Ih5SMIJdAmlMvwCkOtheSQelfKyUOzJeX1jd8
        Gz+QNDwVKioY7naN61gbq8=
Received: from localhost.localdomain (unknown [39.99.236.58])
        by smtp10 (Coremail) with SMTP id NuRpCgC3U4FGy_Vi57sbAA--.20935S2;
        Fri, 12 Aug 2022 11:38:47 +0800 (CST)
From:   Hongbin Wang <wh_bin@126.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        sahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ip6_tunnel: Fix the type of functions
Date:   Thu, 11 Aug 2022 23:38:33 -0400
Message-Id: <20220812033833.1872176-1-wh_bin@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NuRpCgC3U4FGy_Vi57sbAA--.20935S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cry8WF48CFy3WF4kAFyfCrg_yoW8tFWxpF
        15Ca18KF45Xw4DWF1Utr1kAry3KF42y34xX3WfGa4rK3ZrJw4rtF1Iq34kWF4YyFyfGFWf
        ZF15tr17Kr48Zr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UGtCcUUUUU=
X-Originating-IP: [39.99.236.58]
X-CM-SenderInfo: xzkbuxbq6rjloofrz/1tbi7gdboltC-N+5FwAAsE
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions ip6_tnl_change, ip6_tnl_update and ip6_tnl0_update do always
return 0, change the type of functions to void.

Signed-off-by: Hongbin Wang <wh_bin@126.com>
---
 net/ipv6/ip6_tunnel.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 3fda5634578c..79c6a827dea9 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1517,7 +1517,7 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
  *   ip6_tnl_change() updates the tunnel parameters
  **/
 
-static int
+static void
 ip6_tnl_change(struct ip6_tnl *t, const struct __ip6_tnl_parm *p)
 {
 	t->parms.laddr = p->laddr;
@@ -1531,29 +1531,25 @@ ip6_tnl_change(struct ip6_tnl *t, const struct __ip6_tnl_parm *p)
 	t->parms.fwmark = p->fwmark;
 	dst_cache_reset(&t->dst_cache);
 	ip6_tnl_link_config(t);
-	return 0;
 }
 
-static int ip6_tnl_update(struct ip6_tnl *t, struct __ip6_tnl_parm *p)
+static void ip6_tnl_update(struct ip6_tnl *t, struct __ip6_tnl_parm *p)
 {
 	struct net *net = t->net;
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
-	int err;
 
 	ip6_tnl_unlink(ip6n, t);
 	synchronize_net();
-	err = ip6_tnl_change(t, p);
+	ip6_tnl_change(t, p);
 	ip6_tnl_link(ip6n, t);
 	netdev_state_change(t->dev);
-	return err;
 }
 
-static int ip6_tnl0_update(struct ip6_tnl *t, struct __ip6_tnl_parm *p)
+static void ip6_tnl0_update(struct ip6_tnl *t, struct __ip6_tnl_parm *p)
 {
 	/* for default tnl0 device allow to change only the proto */
 	t->parms.proto = p->proto;
 	netdev_state_change(t->dev);
-	return 0;
 }
 
 static void
@@ -1667,9 +1663,9 @@ ip6_tnl_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 			} else
 				t = netdev_priv(dev);
 			if (dev == ip6n->fb_tnl_dev)
-				err = ip6_tnl0_update(t, &p1);
+				ip6_tnl0_update(t, &p1);
 			else
-				err = ip6_tnl_update(t, &p1);
+				ip6_tnl_update(t, &p1);
 		}
 		if (!IS_ERR(t)) {
 			err = 0;
@@ -2091,7 +2087,8 @@ static int ip6_tnl_changelink(struct net_device *dev, struct nlattr *tb[],
 	} else
 		t = netdev_priv(dev);
 
-	return ip6_tnl_update(t, &p);
+	ip6_tnl_update(t, &p);
+	return 0;
 }
 
 static void ip6_tnl_dellink(struct net_device *dev, struct list_head *head)
-- 
2.25.1

