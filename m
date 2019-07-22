Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C50708AC
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbfGVSdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:33:32 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:39887 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726770AbfGVSda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:33:30 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 45F3323A7;
        Mon, 22 Jul 2019 14:33:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Jul 2019 14:33:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=/V6AduhS5OGySHZ0IXPttUadE1/bibpyWuKAPhTnbcI=; b=USW4cqKI
        rB5isIbE6a7+d5yZo577frJiWmQ9BdgqjiKo0vmeOTIpqwNZENpWv7yWcl5vC8Qx
        kwKixeEMet5O0l+p4o4WVUQO8ClwvLGflNi9T8sgepoWQtu3nFjRKXWghEArcJiY
        NV5bbQKeJHk6e8q88f8vE/fVEPjM2jLdR//JlT8o5/5oN6s8rqtsh1LZP1m7uCm5
        Xu9lhSNuxBHVGSIKzCdoGDwFoXbj4pl3bmNlm2V2SbxLv09NkIbX2aJWR/Nhu4L2
        4xhjxaIdKabD6XRbYWcr3c0UGq3g/A/rW2padHP5sUVYyZj2K5U7hb9B0AZxDwwH
        lYJsHQ2GMH9qmQ==
X-ME-Sender: <xms:eQE2XY7Qkn-AdjDZoSxfMEF3L-IUjlGFp9-vJszhMJGDDJNsyxsIEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:eQE2Xb98rsFTG_FVmFH4bjfUvuasNXIBE3MoT4Aslz6wePVqIf_5aA>
    <xmx:eQE2XX9sFKgb4oDj1OtTvt48pTxXxBG5r73xHfj3gWWgi7qB7MKXZg>
    <xmx:eQE2XR7_bovHi1dKJqhWxTDljnvXELar5FF8iygjjsXqgA2qcMdvpA>
    <xmx:eQE2XR7ZcvwgBH46L5Mkh3HxRL4LFF1p_lStsYW2EBmjMojG4DV-OA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C6FFF80060;
        Mon, 22 Jul 2019 14:33:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 04/12] drop_monitor: Avoid multiple blank lines
Date:   Mon, 22 Jul 2019 21:31:26 +0300
Message-Id: <20190722183134.14516-5-idosch@idosch.org>
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

Remove multiple blank lines which are visually annoying and useless.

This suppresses the "Please don't use multiple blank lines" checkpatch
messages.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 35d31b007da4..9080e62245b9 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -300,7 +300,6 @@ static int set_all_monitor_traces(int state)
 	return rc;
 }
 
-
 static int net_dm_cmd_config(struct sk_buff *skb,
 			struct genl_info *info)
 {
@@ -427,7 +426,6 @@ static int __init init_net_drop_monitor(void)
 		reset_per_cpu_data(data);
 	}
 
-
 	goto out;
 
 out_unreg:
-- 
2.21.0

