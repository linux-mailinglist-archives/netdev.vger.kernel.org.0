Return-Path: <netdev+bounces-3868-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E8F57094D6
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 12:33:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61A8E281C79
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E123D3AA;
	Fri, 19 May 2023 10:33:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CC820EA
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 10:33:19 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9178D10C9
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 03:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JxW94pbbU6VDdXwBNAAXOi1JKDDu5tmTHWP0UkOB968=; b=THtDYUPnwJSp3MxntABtObX0Bg
	fua9tKLULbDOsKc61nAGCboBZ7hQFe+A0X6r9Y9pNeAtUCNfGHE+FwKfvzeBi4FVc+ueCtLYycfO3
	oyKqZu258+/s9koo7RiHlmNHkOK7dsOGHAWbJVmGJJzTrPo0Eq3UV3Sk8iF0sug5fW9EZE76yNSPT
	zYE2pOvVgjziOKIZ9pDbCXN4ZX95fX2nAL1YhtOMJRlMIiSNdcGEyEe9FLOXt0aoGKYrnq58spibO
	Grlf+uOpWufObOUgPjeyffCni5mMTnHq2l/qjLmuLJwZm8PypoIpITIkXBMxPmwdMjuUL6octQNmL
	tfc6QCVA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48948 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pzxQ1-0002dz-GW; Fri, 19 May 2023 11:33:05 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pzxQ0-0062IU-Ql; Fri, 19 May 2023 11:33:04 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Joyce Ooi <joyce.ooi@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next] net: altera: tse: remove mac_an_restart() function
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pzxQ0-0062IU-Ql@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 19 May 2023 11:33:04 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The mac_an_restart() method will only be called if the driver sets
legacy_pre_march2020, which the altera tse driver does not do.
Therefore, providing a stub is unnecessary.

Fixes: fef2998203e1 ("net: altera: tse: convert to phylink")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/altera/altera_tse_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 66e3af73ec41..190ff1bcd94e 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1036,10 +1036,6 @@ static struct net_device_ops altera_tse_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
-static void alt_tse_mac_an_restart(struct phylink_config *config)
-{
-}
-
 static void alt_tse_mac_config(struct phylink_config *config, unsigned int mode,
 			       const struct phylink_link_state *state)
 {
@@ -1096,7 +1092,6 @@ static struct phylink_pcs *alt_tse_select_pcs(struct phylink_config *config,
 }
 
 static const struct phylink_mac_ops alt_tse_phylink_ops = {
-	.mac_an_restart = alt_tse_mac_an_restart,
 	.mac_config = alt_tse_mac_config,
 	.mac_link_down = alt_tse_mac_link_down,
 	.mac_link_up = alt_tse_mac_link_up,
-- 
2.30.2


