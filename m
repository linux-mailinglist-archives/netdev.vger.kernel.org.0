Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4FD607A29
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiJUPKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiJUPJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:09:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A9548CA2;
        Fri, 21 Oct 2022 08:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6rqIsGiuGIbdm1Qj9PHgbZHxsJ3BDKwgjZR6ybGW1JM=; b=b1DHpi7denXfkIoftwNCnml+8R
        d7lceXL58JRZOfp7r2sTm3I+y2ZSnhMwOW/5xu65wUcq5apkdWbwb0V85pszS07yVHZFyGKDfRc+b
        C2W3ksc7R8rdrx3WB9Ejrn2HiFo7DdmB7AqDcdSxLH5hkNBvLoCnhqACQR0qTb1nzBa5uClD2oW6q
        SuMoXknP9b+N/6cSG5tzcnEpDQrZ6tkuL76GxkKvXhmWGrnw80eL5C8wJUNYBrOlS4C6MonqMSCrp
        Jzb3arUUnafqaaqmxrgq+BrVMZuHoG8/Ko/HRnVDKtejo+cq3U5PODgcRNNqWOdjjF1/YuKs/SMTV
        4Aj100Ww==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60366 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oltef-0000MU-Pl; Fri, 21 Oct 2022 16:09:49 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oltef-00Fwwz-3t; Fri, 21 Oct 2022 16:09:49 +0100
In-Reply-To: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
References: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH net-next 3/7] net: sfp: ignore power level 2 prior to SFF-8472
 Rev 10.2
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oltef-00Fwwz-3t@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 21 Oct 2022 16:09:49 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Power level 2 was introduced by SFF-8472 revision 10.2. Ignore
the power declaration bit for modules that are not compliant with
at least this revision.

This should remove any spurious indication of 1.5W modules.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index f7ad4d5d9041..a7635b02524a 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1761,7 +1761,8 @@ static int sfp_module_parse_power(struct sfp *sfp)
 	u32 power_mW = 1000;
 	bool supports_a2;
 
-	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
+	if (sfp->id.ext.sff8472_compliance >= SFP_SFF8472_COMPLIANCE_REV10_2 &&
+	    sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
 		power_mW = 1500;
 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
 		power_mW = 2000;
-- 
2.30.2

