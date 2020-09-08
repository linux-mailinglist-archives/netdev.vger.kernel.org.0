Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72D6260E6F
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgIHJND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:13:03 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:43801 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729081AbgIHJLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:46 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 11A4AE11;
        Tue,  8 Sep 2020 05:11:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0xx5IPcyNFHKsqnEZzak89yAu0Skg8T2PrKqPaJ3tc8=; b=dWmd4Ues
        ktdFMc4RRYgGKCO0TKDCqEQMfRLowjSbnFO2F3G7Xgo+O3SaQMEyxc32HR33j7TY
        0xG7fsaKgUsxlgU6pjIad3UVrpN6XEmm12MfVi9WFwqmHT2ovezuvhqPQtXjTnYM
        KFUxnxcjQjT+58Bur9thpVgmPgcWloJlQfwhRE72ZOmQixxfO70up8/t/NFvY/hx
        mvZNeAeRyEm/6hjBZVoZq18emxcgzQgVHVLvQUL4+9ILvKr4rc2kKnF/RE36D9LY
        FcGXocIcV/gcqpsPZ74RyIRQr8WwXMMvtoiFI/LWI6h7E0+IQ6u9kUz0k+FuI09s
        VRnZaKN0ZEuSPA==
X-ME-Sender: <xms:z0pXX6zzS7Q_WmIYh_sCMBrMux2cdRehQkaCz09YynTIjQ2uaHLN2w>
    <xme:z0pXX2RkyROlpIlZWSR7kBl-iBQXQz4JTmEIXZtZytZ7eq63U3ckZTzLS6WK9X9wy
    daJfB1ZUXdPcUI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:z0pXX8XugZilftNJ8qDF1-ECFxgtCx80eDQID-rTA2pKgo1bdSPcPw>
    <xmx:z0pXXwgUV-RepCbMtW0PHmFfFDjisNysG1GG3d4smZJZhLVbJjAcSg>
    <xmx:z0pXX8B7thhmKrFI9plAkhiB_I86VZHnKUvDAZtpDKAxIckuBdMOJg>
    <xmx:z0pXX_MCYjeaMkxaJpfEE1_VTs1tgYJywUrTS-WdrqMst-mL-Y6OsA>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 479003064605;
        Tue,  8 Sep 2020 05:11:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 12/22] nexthop: Emit a notification when a nexthop group is replaced
Date:   Tue,  8 Sep 2020 12:10:27 +0300
Message-Id: <20200908091037.2709823-13-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908091037.2709823-1-idosch@idosch.org>
References: <20200908091037.2709823-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Emit a notification in the nexthop notification chain when an existing
nexthop group is replaced.

The notification is emitted after all the validation checks were
performed, but before the new configuration (i.e., 'struct nh_grp') is
pointed at by the old shell (i.e., 'struct nexthop'). This prevents the
need to perform rollback in case the notification is vetoed.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 1fa249facd46..a60a519a5462 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1049,13 +1049,17 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
 			       struct netlink_ext_ack *extack)
 {
 	struct nh_group *oldg, *newg;
-	int i;
+	int i, err;
 
 	if (!new->is_group) {
 		NL_SET_ERR_MSG(extack, "Can not replace a nexthop group with a nexthop.");
 		return -EINVAL;
 	}
 
+	err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new, extack);
+	if (err)
+		return err;
+
 	oldg = rtnl_dereference(old->nh_grp);
 	newg = rtnl_dereference(new->nh_grp);
 
-- 
2.26.2

