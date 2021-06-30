Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328563B8A66
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 00:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhF3WZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 18:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233072AbhF3WZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 18:25:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E3AC61483;
        Wed, 30 Jun 2021 22:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625091758;
        bh=Z+JCu0fUXWKTI7U3U6rKP9sMCqqxbMA05WT0fqnTkwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXGPRNFmOD1sarpJtrr2N7/1JPnde7O/FjCH48+3raev908VBbJgvcWPhWZAUCaXx
         W4SFH03T8MZnAv+nKgm5ZFfi77vksmUQNo7WNCubhA8bd6faCG5QiNHvTBOrilCPMq
         fKFDg33IwXn6WkewJu8iPGU4bhxl+9nVil1VyfkGZ8R4ntojxHVzWcXyh0mPETEkt6
         ZTjjVcxG/JUNs03c8hbzwCfvgfEwpAas+N4MiotaJu8FTZKJXm9xoZR37r/Tc3sOsc
         0PkdpV17iuSQhUCMR1eH1n7p6jJJ2I1lrdgXy85fxCwnsiKpcG2kr0tpG4YwfIMPC3
         NDwCdUICA1MLA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 2/6] net: dsa: mv88e6xxx: use correct .stats_set_histogram() on Topaz
Date:   Thu,  1 Jul 2021 00:22:27 +0200
Message-Id: <20210630222231.2297-3-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630222231.2297-1-kabel@kernel.org>
References: <20210630222231.2297-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 40cff8fca9e3 ("net: dsa: mv88e6xxx: Fix stats histogram mode")
introduced wrong .stats_set_histogram() method for Topaz family.

The Peridot method should be used instead.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 40cff8fca9e3 ("net: dsa: mv88e6xxx: Fix stats histogram mode")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6bcee3e012d4..b125d3227dbd 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3597,7 +3597,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
-	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
+	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,
@@ -4398,7 +4398,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
-	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
+	.stats_set_histogram = mv88e6390_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6320_stats_get_sset_count,
 	.stats_get_strings = mv88e6320_stats_get_strings,
 	.stats_get_stats = mv88e6390_stats_get_stats,
-- 
2.31.1

