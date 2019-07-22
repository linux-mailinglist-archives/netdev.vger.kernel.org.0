Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E69708A8
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbfGVSdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:33:25 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:48143 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726236AbfGVSdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:33:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0E2182120;
        Mon, 22 Jul 2019 14:33:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Jul 2019 14:33:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=oumIawjw22yg3IErEQR79W9IYFK7MjMaFCMCrmx1ScA=; b=erdP/AgE
        4I7HNI+TNgO/Y1wuUkf8uPAe+IxjWJWz6OssaVXV3ev0QFUycYqYu7+2aXUk0ssB
        cB54IHVhbOd/cqHfeKnMSPAXsG72W1uV0hM/L9L51ZJRihbzYhJtNA/iN0q/pVM3
        HSwCMkDpmcBp2I3pxbRHlH2W+v22VVKbp+lArmlVM2JXH8RKV2YEq8KW4V80Bvx6
        s0YgG5x7GzE3l9vBK3n+XlCttXhNEykWrjvxBdVumpMAcxwAqqfdtNwI7xyRhugv
        1OcRa8XqdMiCIlNRpkgtZonA7j66/5O2qOiDrHpAa9Y/ZoBJyPoTEVELWORQ64qV
        e/ZTADHzJywOjQ==
X-ME-Sender: <xms:cQE2XR0n80pmlmm-pJqxs8wCv3sJqlEsFNSuBlUuazZ_7eExBGuDYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:cQE2XevOAt_wAuwKFh2lfw21K-UA3x6YYkmdbfJn0vlPX0LaVztoHA>
    <xmx:cQE2XZAp-3hMxWQsij5dhvRYxkWlI36vEvutNdR6j5Oyer-buf6olA>
    <xmx:cQE2XbzprqbWzR0HRAlmSz6UdvnzBCln3NdJytFI_FpL7s4CE141bA>
    <xmx:cgE2XTr7ofpM5NxEWZ5Jz1E3pApJrdfSs4gieZ-eQJ3DiV4RXAgn8g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 833578005B;
        Mon, 22 Jul 2019 14:33:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 01/12] drop_monitor: Use correct error code
Date:   Mon, 22 Jul 2019 21:31:23 +0300
Message-Id: <20190722183134.14516-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190722183134.14516-1-idosch@idosch.org>
References: <20190722183134.14516-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The error code 'ENOTSUPP' is reserved for use with NFS. Use 'EOPNOTSUPP'
instead.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 4ea4347f5062..dcb4d2aeb2a8 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -298,7 +298,7 @@ static int set_all_monitor_traces(int state)
 static int net_dm_cmd_config(struct sk_buff *skb,
 			struct genl_info *info)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 static int net_dm_cmd_trace(struct sk_buff *skb,
@@ -311,7 +311,7 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
 		return set_all_monitor_traces(TRACE_OFF);
 	}
 
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 static int dropmon_net_event(struct notifier_block *ev_block,
-- 
2.21.0

