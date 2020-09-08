Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C411D260E6E
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgIHJNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:13:01 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:49383 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729094AbgIHJLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:46 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 82FC94F3;
        Tue,  8 Sep 2020 05:11:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=bSIL9oJYaMQcZehJ0kZRPX/fKgW308C+wQt/ogy2RiA=; b=uoWzhrjx
        SSka5bMBqoY76+SedvEMdMJjDGbCFrhSuFN4DgRsvU6rlM/r45cpetBktcZs0xB9
        rcRztvnGRCyBebzXE9qjOPRcF6jrdVFH/LXiK0Td55ngn8l35wn9iQBW4/x/xN+z
        U0ShZBF8yXHrVbvvY4quIqZI3VIDJnob7a6QxmbNueuWgpYGET1tta2l8Q+PNE7r
        RC3Zz3Jgr2SztDz/fW577lDOhAIUsOpFYTYL2NGR+hobDwALQ8zsv+eHOYFPyG5D
        tmwMoO8cCHQ4PeIlVdbS3dLVfKt7fOW8vE5dZ21h3oRtK7bPsg/9Fkh27VXpc46k
        9xCOL7elxN4vZw==
X-ME-Sender: <xms:0UpXX0a8J5oEu0PfyojOeIrcPMtuIyrNKNJYIc2_98kkAo6faHfPfg>
    <xme:0UpXX_YpkOJra8ZrX-jiXNm2ubc6Qj8Rnf9dVb2xSyu-RJVz4m8GrOP_7CaHq_bGW
    hnVBiUso4j03WQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:0UpXX-85PfdpO8hMYl6SvxnXfRwT70o1xy4ApwJ_2qea-vRzNqnRFQ>
    <xmx:0UpXX-rQVTbdhrwBAAH1wEtlu_AEjyMUQNwwtV-pwsGpWZVGwl2LlA>
    <xmx:0UpXX_rzN_wDQ42TPH17RU_Mdzm_lJg0ChKE_8NXFQ2RzRgG5WF1vg>
    <xmx:0UpXX-Vz5HPEKf1onGnn-_ei-hxwO5DU_3YUwIvx9Erb1AvWAmigGw>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id C25563064680;
        Tue,  8 Sep 2020 05:11:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 13/22] nexthop: Emit a notification when a single nexthop is replaced
Date:   Tue,  8 Sep 2020 12:10:28 +0300
Message-Id: <20200908091037.2709823-14-idosch@idosch.org>
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
index a60a519a5462..b8a4abc00146 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1099,12 +1099,22 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
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

