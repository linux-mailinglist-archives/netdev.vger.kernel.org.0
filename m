Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1288E2A6539
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730120AbgKDNb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:31:58 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60777 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730015AbgKDNbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:31:53 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C73875C0046;
        Wed,  4 Nov 2020 08:31:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=XSUqLAg08Ev7loOqMlr3tkAoaW8hlIVBSLnMk6TB+tI=; b=UZ4HcOS7
        R43JHi7ZyC5AgAho/pFHek2j88p0kjDkc7ZA9cwTQa2DVY7XHvwZ+7ePqD9Ou3W+
        p8dJl/ZSWo34VlQFkLB+X3hxkY4gvctviXpnpdaGlIRPbnn9GbCzldirZBN7nKqc
        2ksJDjlZnvHXy2FujftUNH2c6+PuzHolfDEy2Zz7GGYbGtXCZvUzUxPsXlhhko7j
        hNGMXvzJ1q9tfBwbvcKfJnu8i+QfGA0wtRV1r/nATmpO5YZOF6bEtn+eRnOdSNXD
        vmtoIndSmWb45+OsHRNGjmoFujhuhlBM9sWjbPFbMWHmkJuR6VW8mMsx0ZbIsxCc
        hqt5Vr26dYpw2A==
X-ME-Sender: <xms:R62iXwQ1ACo9wXVuFtLD7MacR9y7o3InZacUUhJG7y2hBZhdfUldrw>
    <xme:R62iX9xGXrEIwynDT2Yr0PaNNSM3-cMiKCJw4Xy4LBb0ZVQQaZLdxRgOpU4u7fXP5
    F6-vh-En85l5LQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:R62iX90r_krTGyEkzD1Hm7ODWjmZUf405cr3HKfd6nYLRZ28wQwK4g>
    <xmx:R62iX0CnQKRCz2yeblAk2WnnDsLjFLlsMYmeR1APMxm4XqWKCG1PbA>
    <xmx:R62iX5h6DvE3GVqdfWpMGvbMTJD6xpwEWkfwV7UOxcwsKEscG1UlwA>
    <xmx:R62iX-vbIiMWybl9r9VXHbb6jtLYZf3CGS6uW63EO7TD55_XmEoUdg>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id 641483064610;
        Wed,  4 Nov 2020 08:31:50 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/18] nexthop: Emit a notification when a nexthop group is replaced
Date:   Wed,  4 Nov 2020 15:30:30 +0200
Message-Id: <20201104133040.1125369-9-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/nexthop.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 4e9d0395f959..3f43693498ee 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1050,13 +1050,17 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
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

