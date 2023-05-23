Return-Path: <netdev+bounces-4634-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 860DF70DA11
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0F1C281337
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D21B31EA6A;
	Tue, 23 May 2023 10:15:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33C21E501
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:15:59 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED4294
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Uutt3/rq7pMdSy42gjEdE/JJVI/CgBkB45HKaZ/TqtY=; b=d/zrV3m+R8yI+3a899J7RRMfQi
	tp3eHeB3I4QFuxug+DbCplPgVXmD1dA/eRR0SuJPok43SHY+ApNFq2B/GwefAegmDRbKXdTZX3Sbh
	zsQ4ntqhqOzsnmZMkAXjCRshA5ekJeUSSfOmc7BwrKe7f6Gub8LW1VtDmE4oAJ9K2TtaFfz5TXyDk
	Rc3l6Q/JznyOgtNMMZ4vSa5l+tcFoXzy7RO4/MzQqojFVOySy4v9yma/uJoD5wmRCNDDPfPE8FOW8
	PihJoujxzUrm3OHL/Ppae/FNSNSrnhg8p2a0Fpb/HaXLSBvPs2dPYk8Z2g1+x0qq92O9OjQxicyG3
	zbVdo2WA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52370 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q1P3Z-00006I-Sm; Tue, 23 May 2023 11:15:53 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q1P3Z-007E8b-9I; Tue, 23 May 2023 11:15:53 +0100
In-Reply-To: <ZGyR/jDyYTYzRklg@shell.armlinux.org.uk>
References: <ZGyR/jDyYTYzRklg@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 2/9] net: phylink: remove duplicated linkmode pause
 resolution
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q1P3Z-007E8b-9I@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 23 May 2023 11:15:53 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Phylink had two chunks of code virtually the same for resolving the
negotiated pause modes. Factor this down to one function.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 093b7b6e0263..d68015db0f2f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -977,11 +977,10 @@ static void phylink_apply_manual_flow(struct phylink *pl,
 		state->pause = pl->link_config.pause;
 }
 
-static void phylink_resolve_flow(struct phylink_link_state *state)
+static void phylink_resolve_an_pause(struct phylink_link_state *state)
 {
 	bool tx_pause, rx_pause;
 
-	state->pause = MLO_PAUSE_NONE;
 	if (state->duplex == DUPLEX_FULL) {
 		linkmode_resolve_pause(state->advertising,
 				       state->lp_advertising,
@@ -1193,7 +1192,8 @@ static void phylink_get_fixed_state(struct phylink *pl,
 	else if (pl->link_gpio)
 		state->link = !!gpiod_get_value_cansleep(pl->link_gpio);
 
-	phylink_resolve_flow(state);
+	state->pause = MLO_PAUSE_NONE;
+	phylink_resolve_an_pause(state);
 }
 
 static void phylink_mac_initial_config(struct phylink *pl, bool force_restart)
@@ -3215,7 +3215,6 @@ static const struct sfp_upstream_ops sfp_phylink_ops = {
 static void phylink_decode_c37_word(struct phylink_link_state *state,
 				    uint16_t config_reg, int speed)
 {
-	bool tx_pause, rx_pause;
 	int fd_bit;
 
 	if (speed == SPEED_2500)
@@ -3234,13 +3233,7 @@ static void phylink_decode_c37_word(struct phylink_link_state *state,
 		state->link = false;
 	}
 
-	linkmode_resolve_pause(state->advertising, state->lp_advertising,
-			       &tx_pause, &rx_pause);
-
-	if (tx_pause)
-		state->pause |= MLO_PAUSE_TX;
-	if (rx_pause)
-		state->pause |= MLO_PAUSE_RX;
+	phylink_resolve_an_pause(state);
 }
 
 static void phylink_decode_sgmii_word(struct phylink_link_state *state,
-- 
2.30.2


