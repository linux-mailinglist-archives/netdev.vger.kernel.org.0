Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2683B4D9550
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 08:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345438AbiCOHd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 03:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345457AbiCOHdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 03:33:25 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0A794B419;
        Tue, 15 Mar 2022 00:32:11 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:41014.619685907
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.38 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id B5E6A2800C7;
        Tue, 15 Mar 2022 15:32:03 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 247354070b554a989055694b5e3ceeab for j.vosburgh@gmail.com;
        Tue, 15 Mar 2022 15:32:10 CST
X-Transaction-ID: 247354070b554a989055694b5e3ceeab
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, oliver@neukum.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn, sunshouxin@chinatelecom.cn
Subject: [PATCH v2 2/4] net:ipv6:Export inet6_ifa_finish_destroy and ipv6_get_ifaddr
Date:   Tue, 15 Mar 2022 03:30:06 -0400
Message-Id: <20220315073008.17441-3-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220315073008.17441-1-sunshouxin@chinatelecom.cn>
References: <20220315073008.17441-1-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export inet6_ifa_finish_destroy and ipv6_get_ifaddr for bonding usage.

Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---
 net/ipv6/addrconf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b22504176588..6825d70c34fb 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -975,6 +975,7 @@ void inet6_ifa_finish_destroy(struct inet6_ifaddr *ifp)
 
 	kfree_rcu(ifp, rcu);
 }
+EXPORT_SYMBOL(inet6_ifa_finish_destroy);
 
 static void
 ipv6_link_dev_addr(struct inet6_dev *idev, struct inet6_ifaddr *ifp)
@@ -2037,6 +2038,7 @@ struct inet6_ifaddr *ipv6_get_ifaddr(struct net *net, const struct in6_addr *add
 
 	return result;
 }
+EXPORT_SYMBOL(ipv6_get_ifaddr);
 
 /* Gets referenced address, destroys ifaddr */
 
@@ -4217,7 +4219,7 @@ static void addrconf_dad_completed(struct inet6_ifaddr *ifp, bool bump_id,
 		ndisc_send_na(dev, &in6addr_linklocal_allnodes, &ifp->addr,
 			      /*router=*/ !!ifp->idev->cnf.forwarding,
 			      /*solicited=*/ false, /*override=*/ true,
-			      /*inc_opt=*/ true);
+			      /*inc_opt=*/ true, NULL);
 	}
 
 	if (send_rs) {
-- 
2.27.0

