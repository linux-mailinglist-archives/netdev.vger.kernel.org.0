Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A302A6536
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgKDNbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:31:53 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37725 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730005AbgKDNbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:31:50 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CD8A45C005B;
        Wed,  4 Nov 2020 08:31:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=SXwxnZ5gvClpbbTiz5CzGoDSBqiCJdKCxk7o1mqeUj8=; b=r+lchLOy
        1U8WyXc4Dc+lbb8UW4yFMOuWA20enErHfDqorobJeXuy12BEqnlP2T107FfwIgVT
        vj9hpik84YIYVxvSX8894f/tpBT4L+jxKsmF3PWVT1vB9Dn002EJMm+kDYqqoBZx
        ae9IkYcleTzS5itSzkD/MEq5FNY2djlm/Iml3ibYPs2sHyob/qX5vddHM0dwLbmV
        b1x6gqdgnz/HVq34oyDbczRQkMbBrqTX2TEKjD0nu1aL4xzqt2Bp3mwSNJuWNRU1
        GbUGhHKlr5QtDElhOefWkqK6gGWyCeWf764NpEqhyiMUkMiqv83jwFFSjcKL2xkr
        MzDGY0smbfesyg==
X-ME-Sender: <xms:RK2iXzZ1sCYqYG5qTgs0dy1_TeAW8A6IuvdmJqST5jHWvDc4r9k3qg>
    <xme:RK2iXyaILizz86mybJ1R4Hb4DT7LA3PRcbiIJrYCG298ZMqFaGtFgLHJnjlClUTby
    kmxZHTdVEEIpXo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:RK2iX190igyLJwR7uC79nQxZ-XOq4bgF2ZP-bfT_-vZRuJBc3HAMBw>
    <xmx:RK2iX5pS-KkQ5X2cDhpJJgn1rupHq2hVDJOf2feln6kyBu47jcjTKA>
    <xmx:RK2iX-pLLWdEi5OJ3KarjtiU5cpwjKhAe_UKAYKlC0aBcvQMxuMMLQ>
    <xmx:RK2iXxV7O1I4Eqf1GuYc96Z5mpKMFy7F2jS9wLqpECyjDJh3yXM4sA>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id 68FE13064610;
        Wed,  4 Nov 2020 08:31:47 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/18] nexthop: Allow setting "offload" and "trap" indications on nexthops
Date:   Wed,  4 Nov 2020 15:30:28 +0200
Message-Id: <20201104133040.1125369-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add a function that can be called by device drivers to set "offload" or
"trap" indication on nexthops following nexthop notifications.

Changes since RFC:
* s/nexthop_hw_flags_set/nexthop_set_hw_flags/

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/nexthop.h |  1 +
 net/ipv4/nexthop.c    | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 4a17b040b502..aa7ac12c35e2 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -145,6 +145,7 @@ struct nh_notifier_info {
 
 int register_nexthop_notifier(struct net *net, struct notifier_block *nb);
 int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
+void nexthop_set_hw_flags(struct net *net, u32 id, bool offload, bool trap);
 
 /* caller is holding rcu or rtnl; no reference taken to nexthop */
 struct nexthop *nexthop_find_by_id(struct net *net, u32 id);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 1d66f2439063..d1a1600aee18 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2081,6 +2081,27 @@ int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_nexthop_notifier);
 
+void nexthop_set_hw_flags(struct net *net, u32 id, bool offload, bool trap)
+{
+	struct nexthop *nexthop;
+
+	rcu_read_lock();
+
+	nexthop = nexthop_find_by_id(net, id);
+	if (!nexthop)
+		goto out;
+
+	nexthop->nh_flags &= ~(RTNH_F_OFFLOAD | RTNH_F_TRAP);
+	if (offload)
+		nexthop->nh_flags |= RTNH_F_OFFLOAD;
+	if (trap)
+		nexthop->nh_flags |= RTNH_F_TRAP;
+
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(nexthop_set_hw_flags);
+
 static void __net_exit nexthop_net_exit(struct net *net)
 {
 	rtnl_lock();
-- 
2.26.2

