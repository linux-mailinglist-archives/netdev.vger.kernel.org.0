Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA0C3B8A65
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 00:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbhF3WZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 18:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232459AbhF3WZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 18:25:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BB2561421;
        Wed, 30 Jun 2021 22:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625091757;
        bh=su7ua1fCTQ4Y+MxlJkwBXz1YcZptO1fJSDGHqWT11/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2H9bgwd9W7HkBeyyyL/nfdWqXydpE08/JloSOMz7HjB3JvC3y+RrvdVCW73RrrAG
         UzlLNfU3MEncfcMuCcgTqxvSrorH0PlxH+0taYrq+mddq9+OLxUWhy1te+9VkjH/TO
         KHQQojx8k4MCblh0m0XRdoSAZ3culoSh1c9/oqNQzDFra/awnk3UFvGJbwfVs9R/fR
         skAfVz6OJj7vuQAORhqFgbbcxOAwi9ferPI3ZUBbnDWTeTID7qtTDFCAJBdE2uv/RV
         dO0d7B/K9Doy+teyr83NDacBqALbkde2TZPeGjT/C4nU2RvTAoo+sDsgT1oTSfGHFh
         LuH+WW9hWrHXQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 1/6] net: dsa: mv88e6xxx: enable .port_set_policy() on Topaz
Date:   Thu,  1 Jul 2021 00:22:26 +0200
Message-Id: <20210630222231.2297-2-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630222231.2297-1-kabel@kernel.org>
References: <20210630222231.2297-1-kabel@kernel.org>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

