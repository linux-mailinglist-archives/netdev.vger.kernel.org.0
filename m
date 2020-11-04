Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4212A6538
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgKDNb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:31:57 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53229 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730005AbgKDNby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:31:54 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4F46F5C0051;
        Wed,  4 Nov 2020 08:31:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Qqv3SVVpCv0OM+UcHpV9qAPXR3Oio39zXvZarI3gZRk=; b=MDC1WSD7
        Si2Ow7lEXiO0e2FLW0M/f2YkkShtN+R9fb3aeJsEuLxAfe7Ex86SsLLKF4oOFw2F
        e8WLImF8ci7oDS33vvN+NrRZQzTWNYLaDAWDDIl4CtXw3u1ztCkqFCh6Lw8Hp4V3
        DgZy77ZJmU2pHENXRw9kOu/PKLl2xKpGNr6LhmFkEPjHMCYIwDNsxj5sPHoN2Nmi
        rNyF3AL4ZI7bQ/JDMTg/QmUqZ9pfUu+t7EZgzmHuMmq3Xh0vQXfFKKfeHqwsFi4o
        0ZVfpHI9XFtp1Ew7tMMONEi3bnsah9Z9W+7n1HYmFxDNXOgs+WfruSSIqPSx9iIu
        GYGyMyZNbNSUdA==
X-ME-Sender: <xms:Sa2iX-LmIW3TY87p1OM0Ay5Vj-Vcp_cImYRjVCHH0_G1_0sxMFWRTw>
    <xme:Sa2iX2J2LAn66hCnEKjIkaDKPshfNBNiEJRfDegIiPb8CzEwRb-o0K1apqAXVeF8a
    Yf0mMZmmbfRo2M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Sa2iX-vLAvCStuN-QfyOznCo6JB4MMjF3ZCc90kdzksFO6U3jgdyNg>
    <xmx:Sa2iXzZh7b_FDnZPu3BCyglLz-tiwB6labixjyL48-fm8ttKHTIhHA>
    <xmx:Sa2iX1asdKu_zgb9nmgZ3YVK-FAfE96Kdt2bgI-f3ectpXwJ-3OP8w>
    <xmx:Sa2iX5HUhi0aJoyVI9ImWVCXldmMxS-h3oM3aj1klXGrKdjisPOtmA>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id DACB4306467D;
        Wed,  4 Nov 2020 08:31:51 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/18] nexthop: Emit a notification when a single nexthop is replaced
Date:   Wed,  4 Nov 2020 15:30:31 +0200
Message-Id: <20201104133040.1125369-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The notification is emitted after all the validation checks were
performed, but before the new configuration (i.e., 'struct nh_info') is
pointed at by the old shell (i.e., 'struct nexthop'). This prevents the
need to perform rollback in case the notification is vetoed.

The next patch will also emit a replace notification for all the nexthop
groups in which the nexthop is used.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 3f43693498ee..11bfb1eb7f84 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1100,12 +1100,22 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 				  struct netlink_ext_ack *extack)
 {
 	struct nh_info *oldi, *newi;
+	int err;
 
 	if (new->is_group) {
 		NL_SET_ERR_MSG(extack, "Can not replace a nexthop with a nexthop group.");
 		return -EINVAL;
 	}
 
+	err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new, extack);
+	if (err)
+		return err;
+
+	/* Hardware flags were set on 'old' as 'new' is not in the red-black
+	 * tree. Therefore, inherit the flags from 'old' to 'new'.
+	 */
+	new->nh_flags |= old->nh_flags & (RTNH_F_OFFLOAD | RTNH_F_TRAP);
+
 	oldi = rtnl_dereference(old->nh_info);
 	newi = rtnl_dereference(new->nh_info);
 
-- 
2.26.2

