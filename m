Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF621E3344
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404519AbgEZW4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:56:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34720 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404359AbgEZW4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:56:54 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jdiV7-0003WM-HL; Tue, 26 May 2020 22:56:49 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mlxsw: spectrum_router: remove redundant initialization of pointer br_dev
Date:   Tue, 26 May 2020 23:56:49 +0100
Message-Id: <20200526225649.64257-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer br_dev is being initialized with a value that is never read
and is being updated with a new value later on. The initialization
is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 71aee4914619..8f485f9a07a7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7572,11 +7572,12 @@ static struct mlxsw_sp_fid *
 mlxsw_sp_rif_vlan_fid_get(struct mlxsw_sp_rif *rif,
 			  struct netlink_ext_ack *extack)
 {
-	struct net_device *br_dev = rif->dev;
+	struct net_device *br_dev;
 	u16 vid;
 	int err;
 
 	if (is_vlan_dev(rif->dev)) {
+
 		vid = vlan_dev_vlan_id(rif->dev);
 		br_dev = vlan_dev_real_dev(rif->dev);
 		if (WARN_ON(!netif_is_bridge_master(br_dev)))
-- 
2.25.1

