Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1744A2B93FD
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgKSN5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:57:52 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:37601 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727153AbgKSN5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:57:51 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id D7F45CF6;
        Thu, 19 Nov 2020 08:57:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 19 Nov 2020 08:57:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=YR6YbOZY4IqLLoT/63dZxuEVbr9wewwTRhSgWQexwYU=; b=dJSdHiYu
        4+QxDPqEsTdZUDJpLURTmQ0ypA3qvuEjSZM/4+4tJQslYoaFBhXZzwaonRfCeB2m
        tOoBShZWUGvbc4FAaxHOtVZ09S6xf0XP0sNcjRLB35BsoDPUwEtvfvGVuvV3bdBL
        Ju5s4pis3A0240QhVgCfKKJe+O2t7adZ1W7+Q4vlRZmlkJ2dma15osWkQnuZj1SK
        kGHd0g0DmTIdJ7bkuAWGRKst/ZmipGJkClJrqoBjzYTweGmr0KtbfxXqF4LV7vei
        8V59M1X/x0w6/GnEU0t7+anyWFe+g+bdaMkKl2o8Hm6EfEQ5UWOzl94CAVEKmi4a
        hehgVjRUE85s6w==
X-ME-Sender: <xms:3nm2X1hLdHRK-atCEdmhByAUZ4m5op4QiTXshyYRKQ7NnQOQZnFg-A>
    <xme:3nm2X6BASx4dr87mF6Qs6tZBuX4ns-8Fbdt87WdHqxKzdsLmyb8GQTEc-vUKyMqB3
    QXKxyRB8AbG3uE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefjedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:3nm2X1Gc-sxSxNVgwxUeTLrSXxFHMGUKB_Iiy4YGjlo1-DWyrBkFUA>
    <xmx:3nm2X6TAtAy0r7Yl8T4DrQ35qv1pzfLTLcrWVyDO7ku8CnNDLGGaYg>
    <xmx:3nm2XywifdmHW-ukWWnaMwUgnnSWfUaCC2Kcbi5GpTf3yDxWhNVltw>
    <xmx:3nm2X3q8_bWVC6Pos0xkMWMtS0AyybR92pj8siy236Rh_jyphRYIRQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0C8CA3280063;
        Thu, 19 Nov 2020 08:57:48 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 1/2] ip route: Print "trap" nexthop indication
Date:   Thu, 19 Nov 2020 15:57:30 +0200
Message-Id: <20201119135731.410986-2-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201119135731.410986-1-idosch@idosch.org>
References: <20201119135731.410986-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The kernel can now signal that a nexthop is trapping packets instead of
forwarding them. Print the flag to help users understand the offload
state of each nexthop.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/iproute.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ip/iproute.c b/ip/iproute.c
index 05ec2c296579..ebb5f160fc44 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -362,6 +362,8 @@ void print_rt_flags(FILE *fp, unsigned int flags)
 		print_string(PRINT_ANY, NULL, "%s ", "pervasive");
 	if (flags & RTNH_F_OFFLOAD)
 		print_string(PRINT_ANY, NULL, "%s ", "offload");
+	if (flags & RTNH_F_TRAP)
+		print_string(PRINT_ANY, NULL, "%s ", "trap");
 	if (flags & RTM_F_NOTIFY)
 		print_string(PRINT_ANY, NULL, "%s ", "notify");
 	if (flags & RTNH_F_LINKDOWN)
-- 
2.28.0

