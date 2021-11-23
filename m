Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0FA459D36
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 08:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbhKWH6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 02:58:16 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60273 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234274AbhKWH6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 02:58:16 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 776315C026D;
        Tue, 23 Nov 2021 02:55:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 23 Nov 2021 02:55:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=mCf6Q7SwdGal2v1zLcXeARkjKlV7vDCkZU5y2Swp4/U=; b=KWdHt/t6
        73dufmyH/h+HE1+J84yAKcx4zo5bAv5efPOYMN/0h1gD5HfU4uNMnb9CnXtx76V1
        cjI/3S9AvxdRBZ3aP++fYvIS/M/iK9terJt9zmSAtmN1oKpgVQqgF92r/0+C0+Pd
        yVOmeaKxfbSdMeGDYQtx70POHMhGPU8TkcfGy2G5MZjM/3UcAflAHJRRU6ehO2Fw
        4X4KlQ8Xt4Tr9PGiV2xmDYRFtrPsbb8OrSj5c2cCZ6ts7v5jXfOmvRhqVgBdzCT6
        4Ki0g1a6LMs6qRJSqRioYLqC72yClK1EABxwn02ck65UyyRxXyv91V+WIMDOwKe+
        alq04K8bDIOlAA==
X-ME-Sender: <xms:XJ6cYcOM2_S7R7V0WIUD9uCSp9Si_hnb2Ld8-lqo8JywZeQfnNraBw>
    <xme:XJ6cYS89rKdHRVcTtvMKvwcPQORb3I4LeO--kReJQxAhThqS5Od9FB0iHwyWvYtyi
    d4cBJQocnYfluQ>
X-ME-Received: <xmr:XJ6cYTSfAkRw8DRVGrqz8v_fn6hrvFetYrqHe-PG9QbawiNUhNy6EdTg-4ituFyytBFzYlu1V2X0w58mX-qShMAU1NlVIiHJl1oEkECkCl-I7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeehgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeduteeiveffffevleekleejffekhfekhefgtdfftefhledvjefggfehgfevjeek
    hfenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:XJ6cYUvt-XAZ0DDug3jZ3A2oluRDaNEU_smCnxHqv_ydZmWaNEdrhQ>
    <xmx:XJ6cYUcvA61l-NmAMvi81ehRGtqpUJsUwBqIHTfVWWGGJsSHujinZQ>
    <xmx:XJ6cYY2HLy9h6JdyYs8r3fCd9JyzZTwwoB50h1GnsxaxpfsUTD5djQ>
    <xmx:XJ6cYT4oPTH7jyrMY2G2Aa3Iyk4jRXOrHNBZNSLJuQuakVnBEtRKqA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 02:55:06 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/2] mlxsw: spectrum_router: Remove deadcode in mlxsw_sp_rif_mac_profile_find
Date:   Tue, 23 Nov 2021 09:54:46 +0200
Message-Id: <20211123075447.3083579-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123075447.3083579-1-idosch@idosch.org>
References: <20211123075447.3083579-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

The function idr_for_each_entry() already checks that the next entry in
the IDR is not NULL.

Therefore, checking that again in every iteration leads to deadcode.

Remove the unnecessary check in order to avoid that.

Addresses-Coverity: ("Logically dead code")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 217e3b351dfe..98df6e8fa45f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8369,9 +8369,6 @@ mlxsw_sp_rif_mac_profile_find(const struct mlxsw_sp *mlxsw_sp, const char *mac)
 	int id;
 
 	idr_for_each_entry(&router->rif_mac_profiles_idr, profile, id) {
-		if (!profile)
-			continue;
-
 		if (ether_addr_equal_masked(profile->mac_prefix, mac,
 					    mlxsw_sp->mac_mask))
 			return profile;
-- 
2.31.1

