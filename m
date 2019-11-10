Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6590FF6943
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfKJOGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:06:32 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45620 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:06:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BZHkLAdbGISRT2rZpa613pY+imb9OIZBZSeQRDEAx3w=; b=ZpbYz5NC07Lx4G8vf9dWcp41i9
        YedlhmZ4qjSCDIC9enmw1NP3t1iZY4zo4YQGglofzdnq0h2dr1tuzW5PwJguQQaQ7VU4U2ZmE2xaK
        EXSdyna2Lwz0wBdnRycGbZoUcFErEaDTdOFgI/CTrRCKRg1O0emqebDAH8jST96WpDhvMBTeKpnRh
        dQaVrBBUHWTvTmQX6tn470bgF+4Ymy37mKdx8cNarq5LbjttknMhljHsIl6SpxPmMrc49/UIy36wg
        jWVJDAWqtYZGuf4b9rO4O0oBUtnEM5YapbseTmBdQsBaKf4EYJgCv7GM99hd0rz7vyCs1Q5PAG5Vm
        ATWrB+Jw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:53626 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrF-0007dP-95; Sun, 10 Nov 2019 14:06:25 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrD-00059f-Iz; Sun, 10 Nov 2019 14:06:23 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 03/17] net: sfp: rename sfp_sm_ins_next() as
 sfp_sm_mod_next()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnrD-00059f-Iz@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:06:23 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sfp_sm_ins_next() modifies the module state machine.  Change it's name
to reflect this.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 47f204b227e8..f56a19b26924 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1182,7 +1182,7 @@ static void sfp_sm_next(struct sfp *sfp, unsigned int state,
 	sfp_sm_set_timer(sfp, timeout);
 }
 
-static void sfp_sm_ins_next(struct sfp *sfp, unsigned int state,
+static void sfp_sm_mod_next(struct sfp *sfp, unsigned int state,
 			    unsigned int timeout)
 {
 	sfp->sm_mod_state = state;
@@ -1506,22 +1506,22 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 	default:
 		if (event == SFP_E_INSERT && sfp->attached) {
 			sfp_module_tx_disable(sfp);
-			sfp_sm_ins_next(sfp, SFP_MOD_PROBE, T_PROBE_INIT);
+			sfp_sm_mod_next(sfp, SFP_MOD_PROBE, T_PROBE_INIT);
 		}
 		break;
 
 	case SFP_MOD_PROBE:
 		if (event == SFP_E_REMOVE) {
-			sfp_sm_ins_next(sfp, SFP_MOD_EMPTY, 0);
+			sfp_sm_mod_next(sfp, SFP_MOD_EMPTY, 0);
 		} else if (event == SFP_E_TIMEOUT) {
 			int val = sfp_sm_mod_probe(sfp);
 
 			if (val == 0)
-				sfp_sm_ins_next(sfp, SFP_MOD_PRESENT, 0);
+				sfp_sm_mod_next(sfp, SFP_MOD_PRESENT, 0);
 			else if (val > 0)
-				sfp_sm_ins_next(sfp, SFP_MOD_HPOWER, val);
+				sfp_sm_mod_next(sfp, SFP_MOD_HPOWER, val);
 			else if (val != -EAGAIN)
-				sfp_sm_ins_next(sfp, SFP_MOD_ERROR, 0);
+				sfp_sm_mod_next(sfp, SFP_MOD_ERROR, 0);
 			else
 				sfp_sm_set_timer(sfp, T_PROBE_RETRY);
 		}
@@ -1529,7 +1529,7 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 
 	case SFP_MOD_HPOWER:
 		if (event == SFP_E_TIMEOUT) {
-			sfp_sm_ins_next(sfp, SFP_MOD_PRESENT, 0);
+			sfp_sm_mod_next(sfp, SFP_MOD_PRESENT, 0);
 			break;
 		}
 		/* fallthrough */
@@ -1537,7 +1537,7 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 	case SFP_MOD_ERROR:
 		if (event == SFP_E_REMOVE) {
 			sfp_sm_mod_remove(sfp);
-			sfp_sm_ins_next(sfp, SFP_MOD_EMPTY, 0);
+			sfp_sm_mod_next(sfp, SFP_MOD_EMPTY, 0);
 		}
 		break;
 	}
-- 
2.20.1

