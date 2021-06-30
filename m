Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE343B87DF
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhF3Rpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232878AbhF3Rpm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 13:45:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B06246147D;
        Wed, 30 Jun 2021 17:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625074993;
        bh=1NMT37tIEAwnlnQPbYtOPqMFT9Dwst6kKmCeMq/pXP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUfC71N9GR0cceKlX08lxI4qT2ksVcZgPfbJvbL8uGfFUKAKGEWFSuEMCUPkOEmKk
         fMzUHRjFpGszFEJLL1iclVDy03dPNuvoFWGU+LCqpXVv/2Exuu6Tmhb4BFSrGUIS8x
         LQcbCurtSzbzo2pYBal/HONo4mb0ys+tOsnO3ErGxXsPeDCN+JDyNhGG79rAyLi4mr
         RgqUctoQUR2DkKYDfMYi+JGx/4sQGasRjIgSqGKTlqoznXAnzqzobzRYWrJmk+Gw5B
         bGSFdri07zPXXeLVLe8qrUsF1bbPEgdYxGCPKGhyZp/6VTCIoPgyStlPz1/4N6P2Pz
         fo/EkujFKLTfQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 1/6] net: dsa: mv88e6xxx: enable .port_set_policy() on Topaz
Date:   Wed, 30 Jun 2021 19:43:03 +0200
Message-Id: <20210630174308.31831-2-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630174308.31831-1-kabel@kernel.org>
References: <20210630174308.31831-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit f3a2cd326e44 ("net: dsa: mv88e6xxx: introduce .port_set_policy")
introduced .port_set_policy() method with implementation for several
models, but forgot to add Topaz, which can use the 6352 implementation.

Use the 6352 implementation of .port_set_policy() on Topaz.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: f3a2cd326e44 ("net: dsa: mv88e6xxx: introduce .port_set_policy")
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 961fa6b75cad..6bcee3e012d4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3583,6 +3583,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_set_speed_duplex = mv88e6341_port_set_speed_duplex,
 	.port_max_speed_mode = mv88e6341_port_max_speed_mode,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
@@ -4383,6 +4384,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_set_speed_duplex = mv88e6341_port_set_speed_duplex,
 	.port_max_speed_mode = mv88e6341_port_max_speed_mode,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
-- 
2.31.1

