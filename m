Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258309FA8B
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfH1Gb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:31:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:49892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725951AbfH1Gb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 02:31:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C9510B12E;
        Wed, 28 Aug 2019 06:31:24 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, SteveM <swm@swm1.com>
Subject: [PATCH] sky2: Disable MSI on yet another ASUS boards (P6Xxxx)
Date:   Wed, 28 Aug 2019 08:31:19 +0200
Message-Id: <20190828063119.22248-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A similar workaround for the suspend/resume problem is needed for yet
another ASUS machines, P6X models.  Like the previous fix, the BIOS
doesn't provide the standard DMI_SYS_* entry, so again DMI_BOARD_*
entries are used instead.

Reported-and-tested-by: SteveM <swm@swm1.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/net/ethernet/marvell/sky2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index c2e00bb587cd..5f56ee83e3b1 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4931,6 +4931,13 @@ static const struct dmi_system_id msi_blacklist[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "P6T"),
 		},
 	},
+	{
+		.ident = "ASUS P6X",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "P6X"),
+		},
+	},
 	{}
 };
 
-- 
2.16.4

