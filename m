Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8490D2A6545
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbgKDNbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:31:52 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54583 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729971AbgKDNbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:31:47 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D03D75C0101;
        Wed,  4 Nov 2020 08:31:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=1xSTu5ohS6ND6m3p9dVKPOzCI2fflg07T3jOVyPMhxI=; b=kVW5JJrL
        lxIFJb6SKKopoNXDWhJL3T6nabMqg+cprbiyLWdtAgvJlXsanemO3d3h8kL/ADtc
        gI8McDJsVxd1DLSx+sG0z7/FKvt9enhkG+wlmzSZzQG4u2gLuIpUnv7U0IkeAowp
        uzjtdBr1qg+z+pH/k3e4ahOSpH6nTlFIHpMSx2y13Jd7/8XrIy9t1BWBRJe5lRZ/
        5pP93rrPz8m1Jg9/jeQS4HSW4fqy8qzGLsRFp3rImsVNWIE2LTJUdTIul2M156hi
        MblKzyRIvpmnQsHkyuDS+d2Z9bjC7L3MwKobHyA0ZgIFQzZdUHsut56+LEdqkX4W
        0IYeD31/E3z0Aw==
X-ME-Sender: <xms:Qa2iX0GXeNUy-e5I2za1-_tJ5hqXTtlWV8M8rHDnkeV7IL7xtv-ogA>
    <xme:Qa2iX9XoHlJ6YUXhK-hsHBP4fVECee341ROwt-lM7mkAuwCFFBEx5d7GzY0K5Fipc
    gb2aPhuQbDANtk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Qa2iX-LYFA7yMq1bFazB01aYys8QKzubCM__e6tFcPCWLCYwEPm0zg>
    <xmx:Qa2iX2HQ9urFR2808PIatFDoAafrEBq4J5mReY-uR-3FYmpg2XOWFg>
    <xmx:Qa2iX6Wj_T0aXDsXktLJBmjnDWXtAB37W8MzlZ2OWC1MRPWFGy4IPg>
    <xmx:Qa2iX5QsFFIWegGBb3--AejT_pcsakCQC4M7JR94JScA9g_t4p47SQ>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6ACFD3064684;
        Wed,  4 Nov 2020 08:31:44 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/18] nexthop: vxlan: Convert to new notification info
Date:   Wed,  4 Nov 2020 15:30:26 +0200
Message-Id: <20201104133040.1125369-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Convert the sole listener of the nexthop notification chain (the VXLAN
driver) to the new notification info.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/vxlan.c | 9 +++++++--
 net/ipv4/nexthop.c  | 2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 876679af6f7c..b9db20b4ebfd 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4684,9 +4684,14 @@ static void vxlan_fdb_nh_flush(struct nexthop *nh)
 static int vxlan_nexthop_event(struct notifier_block *nb,
 			       unsigned long event, void *ptr)
 {
-	struct nexthop *nh = ptr;
+	struct nh_notifier_info *info = ptr;
+	struct nexthop *nh;
+
+	if (event != NEXTHOP_EVENT_DEL)
+		return NOTIFY_DONE;
 
-	if (!nh || event != NEXTHOP_EVENT_DEL)
+	nh = nexthop_find_by_id(info->net, info->id);
+	if (!nh)
 		return NOTIFY_DONE;
 
 	vxlan_fdb_nh_flush(nh);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 85a595883222..1d66f2439063 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -151,7 +151,7 @@ static int call_nexthop_notifiers(struct net *net,
 	}
 
 	err = blocking_notifier_call_chain(&net->nexthop.notifier_chain,
-					   event_type, nh);
+					   event_type, &info);
 	nh_notifier_info_fini(&info);
 
 	return notifier_to_errno(err);
-- 
2.26.2

