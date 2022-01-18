Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8E04919A8
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345698AbiARCzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:55:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33002 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347660AbiARCmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:42:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09D15612CF;
        Tue, 18 Jan 2022 02:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B782C36AEB;
        Tue, 18 Jan 2022 02:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473750;
        bh=2jpEybxBN1EULydrABOW6r9c6zDuLxJNF0zG9IbXOCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVG+sRj/VlWNA1Ltb/kiCAdresf8AdPBQ+dqYYjskeotWF/I8DJ2WUUUVVhtucjA1
         Q75SsEU8Ofz5XQfD8UZba1481aZQIC94eImpOYXNoTRcryOiRuliRnF+f7nLDWX0nZ
         jdzPTAPIeLES/kc7UTsYSEOYe7iU1HURo26UP1SMCoMvEorUjxcq3eyxHxIhc6TXvo
         /HFqbTmZVE5w2rdj/3CxxdQIi/LUjiLJdzmgRcLnEdvqcdg+UfI9Zelmddu1kiBJE/
         6460+iwCFeTS3hQptun0ixrQYoprW3w0cNR3FybGUZLppdYX5UFTW3h7FTlgsHXrVe
         C0B4McRFg3eNw==
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
Subject: [PATCH AUTOSEL 5.10 052/116] net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
Date:   Mon, 17 Jan 2022 21:39:03 -0500
Message-Id: <20220118024007.1950576-52-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 4e53464411edf..c1105bd7cf67b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -204,7 +204,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
-	if (felix->pcs[port])
+	if (felix->pcs && felix->pcs[port])
 		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
 }
 
-- 
2.34.1

