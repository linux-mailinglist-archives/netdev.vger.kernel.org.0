Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BED344A07
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhCVQAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:23 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57863 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231243AbhCVP7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:59:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5F1A25C01CA;
        Mon, 22 Mar 2021 11:59:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 22 Mar 2021 11:59:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=XYI45CbMZMOHRlE2jMXzVdQnDoUbVmZsMSpVclmNlaM=; b=OzHXhJ6G
        SF7oiMEWh/u2GUoLRqFnV0LwRqTo1lUu69WhJ/BaZ83lefL9cbtvYxt2BcbCFAIF
        5SmWnusbuRC/0Uvf5bYtl/5Y7So+dPMFF6O5DgDBUorehKloIvPx3Badp2XL2BTH
        BnVAosgkY/OndR+wEnauOpm5mfS0MPHbcbpquYmUtoBxbqFws2pyWMpXpo+tuG9c
        T9UT9w2V/2as0CODQDf9O5zRa5qKlQK9SMyMgSe5j2/I9zD61+KpBOWlCzXr6h/v
        zhJlBLlV+gYwTeZjWVOC2noQhhlUpJycn2IbVJNwO6HKAOOnAA03g3u2FCTJQkny
        Q21lLfEKgy5pDA==
X-ME-Sender: <xms:675YYAhkznNDAc6rc7gpGVPFmTHwb0gsn54WKYObMz9nFL3OS2i2PQ>
    <xme:675YYJDjFSxd2FF3OyGDR1rhIsIz6QEc64ywX7LR6df9H4RZhXrR0843YHtMxkWHU
    cj8K6x2bMPK3vg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:675YYIGc5Q9uAd21WHQFAh7QXukYvkD85V97fVCWJceBcAL3R7jPgg>
    <xmx:675YYBT1LnkmGVmp3l9EfpGqE3LxF5oiQWvM1NAJutk-5B-Rc4NSpw>
    <xmx:675YYNwV4ksLiHDTdXnES1CDxu7-wfp0Y2Iv40nTiL27TNNTIaJMPA>
    <xmx:675YYPszVubVI1zZR6DQYTm5DUuM3gK8I07ywTsOCdKDP0UclBqxug>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 491591080066;
        Mon, 22 Mar 2021 11:59:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/14] mlxsw: spectrum_router: Remove RTNL assertion
Date:   Mon, 22 Mar 2021 17:58:42 +0200
Message-Id: <20210322155855.3164151-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Remove the RTNL assertion in the nexthop notifier block. The assertion
is not needed given RTNL is never assumed to be taken.

This is a preparation for future patches where mlxsw will start handling
nexthop events that are not always sent with RTNL held.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index eda99d82766a..0e0b40e97783 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4699,8 +4699,6 @@ static int mlxsw_sp_nexthop_obj_event(struct notifier_block *nb,
 
 	mutex_lock(&router->lock);
 
-	ASSERT_RTNL();
-
 	switch (event) {
 	case NEXTHOP_EVENT_REPLACE:
 		err = mlxsw_sp_nexthop_obj_new(router->mlxsw_sp, info);
-- 
2.29.2

