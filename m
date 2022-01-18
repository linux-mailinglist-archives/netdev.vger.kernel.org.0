Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB9B4915CB
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345689AbiARCbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:31:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37908 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245286AbiARCZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:25:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7569B81243;
        Tue, 18 Jan 2022 02:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B324C36AE3;
        Tue, 18 Jan 2022 02:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472713;
        bh=LmPaX7zldt4EKMoSEVIJLQiC2qrMN8IKsWAukZL/DfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VF+M80OAR2j0IRLSqaG537Sp/LXgMeuUtKOHeYbDTAQh78lTyuc9fHYAYSd8tDzU+
         hXCJ5pCFVfrfpnnFJ7z0+K1R4YiTpqfXM4SHwhAnFwrmFWw42Bucggu0QFRDg54pVy
         hWq+9LS5RLdKlIbOBga0ODdQnmQmag42zHDDVbCjN9J6EWJ8V1NKjRs8DUIDlfYCCI
         PdbfqE/k+xjGIFgkqG8moU0DtIKPeQBcNlbRYVfnNuoKLz+8zesAxU/xAlE8cAeU65
         EkcK5YE0Eau0JaAI8xrJ9rzmXtxdE1Wwy5pJe8o0tbI2TvIr7bAAGr/isfpDOJNYGc
         QjA58Lz5GUdpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 108/217] net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
Date:   Mon, 17 Jan 2022 21:17:51 -0500
Message-Id: <20220118021940.1942199-108-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Foster <colin.foster@in-advantage.com>

[ Upstream commit 49af6a7620c53b779572abfbfd7778e113154330 ]

Existing felix devices all have an initialized pcs array. Future devices
might not, so running a NULL check on the array before dereferencing it
will allow those future drivers to not crash at this point

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f1a05e7dc8181..221440a61e17e 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -823,7 +823,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
-	if (felix->pcs[port])
+	if (felix->pcs && felix->pcs[port])
 		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
 }
 
-- 
2.34.1

