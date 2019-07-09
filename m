Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458B963656
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfGINBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:01:32 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([85.215.255.132]:34479 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfGINBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 09:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1562677289;
        s=strato-dkim-0002; d=jm0.eu;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=bX6h2dEc1Oib+bn+pE8hwTCogDIhlMmJSWopm0fvebY=;
        b=s8bm7NLGC2AzzVRERfSrIlALBMo/8oGymYZ22HmDy2mODWhES1xzml2+o7roR32H1/
        qQOCcZisnCWwOBHNRdKgufHoOoNRIbRlIA0rToKSzmyQz3/ZWGsgVt0gpC58spVjcIQO
        21s8Dm0QWkhhGGFxITBuQUbeiM+sDGNDtX0BpOu6qy6JKQfU9LFcSwSkE/lTH+htg7sj
        iI8KfUabaKySI5kl1KeQuMp1xioFHFDL6fAEennPb6j5fqG07/YtJFrVFBcMDPISMwyE
        HpM4SC04cFaAuNumi/NIqebVNYX9s/xK5H6G331OMq2J8aZdE2UVbNlS68xhLn9l3FlV
        olEg==
X-RZG-AUTH: ":JmMXYEHmdv4HaV2cbPh7iS0wbr/uKIfGM0EPWe8EZQbw/dDJ/fVPBaXaSiaF5/mu26zWKwNU"
X-RZG-CLASS-ID: mo05
Received: from linux-1tvp.lan
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id h0a328v69D1MEg9
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 9 Jul 2019 15:01:22 +0200 (CEST)
From:   josua@solid-run.com
To:     netdev@vger.kernel.org
Cc:     Josua Mayer <josua@solid-run.com>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 2/4] net: mvmdio: allow up to four clocks to be specified for orion-mdio
Date:   Tue,  9 Jul 2019 15:00:59 +0200
Message-Id: <20190709130101.5160-3-josua@solid-run.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190709130101.5160-1-josua@solid-run.com>
References: <20190706151900.14355-1-josua@solid-run.com>
 <20190709130101.5160-1-josua@solid-run.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josua Mayer <josua@solid-run.com>

Allow up to four clocks to be specified and enabled for the orion-mdio
interface, which are required by the Armada 8k and defined in
armada-cp110.dtsi.

Fixes a hang in probing the mvmdio driver that was encountered on the
Clearfog GT 8K with all drivers built as modules, but also affects other
boards such as the MacchiatoBIN.

Cc: stable@vger.kernel.org
Fixes: 96cb43423822 ("net: mvmdio: allow up to three clocks to be specified for orion-mdio")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Josua Mayer <josua@solid-run.com>
---
 drivers/net/ethernet/marvell/mvmdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index c5dac6bd2be4..e17d563e97a6 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -64,7 +64,7 @@
 
 struct orion_mdio_dev {
 	void __iomem *regs;
-	struct clk *clk[3];
+	struct clk *clk[4];
 	/*
 	 * If we have access to the error interrupt pin (which is
 	 * somewhat misnamed as it not only reflects internal errors
-- 
2.16.4

