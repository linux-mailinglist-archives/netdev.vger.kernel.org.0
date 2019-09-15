Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267FEB2EB9
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 08:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfIOGsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 02:48:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54593 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726488AbfIOGs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 02:48:28 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B7B2C210AC;
        Sun, 15 Sep 2019 02:48:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 15 Sep 2019 02:48:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=1UKK4kcXQzKCmtlmUe6wknELNTIex+U8LJVush1JgiU=; b=qm5xx/s6
        PQZdjVgQLKEJbZXgvG6GhYoewPELckPCDj3jcrAF//PZB0/uEHR2GNMGiL/Y4sIU
        1m/hvW8hLNN9sGs2NYwXbSv7Gw3k6DJl/DmKusKqfY0yGI82iCK4YRlQX6dxinFc
        /3vQPvJsyg2E71TfXFI8maicaVZFyquyyshmlxVMHwLawzKPI2wWwF1LbftqKcGA
        BZG4wz06xvMjc95aBs7spnCFKxjp26Ih9v3PkbMg16iyuPubNlurRjvhuhMarzMv
        bzeNwU8/mSr3dOxjaua/79/eaIpsBuffuQ8SU5np1f+d1EcPneVEdB2OzOffVuAE
        8hBeAONBrpi4ZA==
X-ME-Sender: <xms:u959XVhQkzDsctLAWSgDW1xZscR7_-w28iVMyIbxqnsLsHdUJbJhrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:u959Xfqup5a0PEpIVIQMlq_u7WKlmjZ5ApjJbx-sCH_XOcde-OhPPA>
    <xmx:u959XdLR6RxJneTy008LG7xDG4p79BeU--KZLX_VvuYbHDQCdtPkrg>
    <xmx:u959XS_d-DmjrjR3PwoUxzPczuznIqd0giD49jOIfwDhFonYQnTSDA>
    <xmx:u959XXC1Mg4081kZX5lkzZfb6KDSMYGaCiietVxxOqfco8lNqktZ-w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F7B380062;
        Sun, 15 Sep 2019 02:48:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, nhorman@tuxdriver.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/2] netdevsim: Set offsets to various protocol layers
Date:   Sun, 15 Sep 2019 09:46:35 +0300
Message-Id: <20190915064636.6884-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190915064636.6884-1-idosch@idosch.org>
References: <20190915064636.6884-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The driver periodically generates "trapped" UDP packets that it then
passes on to devlink. Set the offsets to the various protocol layers.

This is a prerequisite to the next patch, where drop monitor is taught
to check that the offset to the MAC header was set.

Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/netdevsim/dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 7fba7b271a57..56576d4f34a5 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -374,12 +374,14 @@ static struct sk_buff *nsim_dev_trap_skb_build(void)
 		return NULL;
 	tot_len = sizeof(struct iphdr) + sizeof(struct udphdr) + data_len;
 
+	skb_reset_mac_header(skb);
 	eth = skb_put(skb, sizeof(struct ethhdr));
 	eth_random_addr(eth->h_dest);
 	eth_random_addr(eth->h_source);
 	eth->h_proto = htons(ETH_P_IP);
 	skb->protocol = htons(ETH_P_IP);
 
+	skb_set_network_header(skb, skb->len);
 	iph = skb_put(skb, sizeof(struct iphdr));
 	iph->protocol = IPPROTO_UDP;
 	iph->saddr = in_aton("192.0.2.1");
@@ -392,6 +394,7 @@ static struct sk_buff *nsim_dev_trap_skb_build(void)
 	iph->check = 0;
 	iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
 
+	skb_set_transport_header(skb, skb->len);
 	udph = skb_put_zero(skb, sizeof(struct udphdr) + data_len);
 	get_random_bytes(&udph->source, sizeof(u16));
 	get_random_bytes(&udph->dest, sizeof(u16));
-- 
2.21.0

