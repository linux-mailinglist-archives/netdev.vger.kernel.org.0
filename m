Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC3DA8EA16
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 13:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbfHOLTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 07:19:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46671 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfHOLTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 07:19:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so1867933wru.13
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 04:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=K+AddC0f4TzCVivmVVvaoZjB4jEBV9n992khci1VXSY=;
        b=qWnikG0U8TKragDOdz5ukNSHg1e90VHJS5xjhvwwLcuCXhHGevO3sYiNaKItbOzKiT
         SCpD+gcqRF5DsS7MNshUNn+TqBIlsPNgx1HuRxbiHN54MRFOxQZwMrxm94DX+Vj8WHua
         zA2u2c0O2eQalsl2r1tP46oGKm2OHufubFLXzqDFARiF4mnWzlYL5QE0WAfXhNn0t8bo
         RCVsQBddA+CahHpq7s6jkBwN54N+qnD/8mkXoDTljW1/v/j8+V2h4vdQO9HiIoLfT0Au
         sx4o73NAvdKiDJsVw5PYZWuo6fDUvhyoWsu5rLWGApcZsAFzXD6dH+9SB9b34xvjb8K+
         zAiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=K+AddC0f4TzCVivmVVvaoZjB4jEBV9n992khci1VXSY=;
        b=TnlhndZ9ExdNtt0Cwo8bMLE0e/J94ej7nRPIFqh/xS8cqhun5GlxLMAbdb1V/t73rb
         zbquawOMMXLBPaxWtFanq28R6pfgiNIMiuxKGMcPYz/8xl6jtefFoXpt+7qWdKnPKW8v
         ST/AzrWpGZsoTeFc68TUjUvnf81iuu9Li1cVJV8ySxDh4QvFMw7ajVCq62jUgLroHpvn
         z0jLoUjt392QY8AuTMsCX5ON+NCHbiFHYryFEcXkTLmofl9Zg+xmFddtcFgyPkj+8OIr
         pMbMVB2aamHdVixdz3FGkQLx1JgijiMc6wwF6SvvGTs3PAeVwwimsDNLh8IvW6TG8uMY
         GJig==
X-Gm-Message-State: APjAAAUAuYfj7mb/78ksOpImyUdNSl9KWVgd24c0ipj7oqGQ0DwyJP/D
        fgK7wUjNqrZ29D5azBgNBFDa04IS
X-Google-Smtp-Source: APXvYqynnP9L9orvwJDkrF2Yvgv8zdwcyVFtD3jGLV9bqyAhNtCNtEgI8Ubj6V2oDG+af09s1/uzGw==
X-Received: by 2002:adf:bace:: with SMTP id w14mr3614777wrg.283.1565867969488;
        Thu, 15 Aug 2019 04:19:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:b8fa:18d8:f880:513c? (p200300EA8F2F3200B8FA18D8F880513C.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:b8fa:18d8:f880:513c])
        by smtp.googlemail.com with ESMTPSA id f6sm2993931wrh.30.2019.08.15.04.19.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 04:19:28 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: swphy: emulate register MII_ESTATUS
Message-ID: <25690798-5122-d5a2-7d2b-c166b8649a2e@gmail.com>
Date:   Thu, 15 Aug 2019 13:19:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the genphy driver binds to a swphy it will call
genphy_read_abilites that will try to read MII_ESTATUS if BMSR_ESTATEN
is set in MII_BMSR. So far this would read the default value 0xffff
and 1000FD and 1000HD are reported as supported just by chance.
Better add explicit support for emulating MII_ESTATUS.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/swphy.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/swphy.c b/drivers/net/phy/swphy.c
index dad22481d..53c214a22 100644
--- a/drivers/net/phy/swphy.c
+++ b/drivers/net/phy/swphy.c
@@ -22,6 +22,7 @@ struct swmii_regs {
 	u16 bmsr;
 	u16 lpa;
 	u16 lpagb;
+	u16 estat;
 };
 
 enum {
@@ -48,6 +49,7 @@ static const struct swmii_regs speed[] = {
 	[SWMII_SPEED_1000] = {
 		.bmsr  = BMSR_ESTATEN,
 		.lpagb = LPA_1000FULL | LPA_1000HALF,
+		.estat = ESTATUS_1000_TFULL | ESTATUS_1000_THALF,
 	},
 };
 
@@ -56,11 +58,13 @@ static const struct swmii_regs duplex[] = {
 		.bmsr  = BMSR_ESTATEN | BMSR_100HALF,
 		.lpa   = LPA_10HALF | LPA_100HALF,
 		.lpagb = LPA_1000HALF,
+		.estat = ESTATUS_1000_THALF,
 	},
 	[SWMII_DUPLEX_FULL] = {
 		.bmsr  = BMSR_ESTATEN | BMSR_100FULL,
 		.lpa   = LPA_10FULL | LPA_100FULL,
 		.lpagb = LPA_1000FULL,
+		.estat = ESTATUS_1000_TFULL,
 	},
 };
 
@@ -112,6 +116,7 @@ int swphy_read_reg(int reg, const struct fixed_phy_status *state)
 {
 	int speed_index, duplex_index;
 	u16 bmsr = BMSR_ANEGCAPABLE;
+	u16 estat = 0;
 	u16 lpagb = 0;
 	u16 lpa = 0;
 
@@ -125,6 +130,7 @@ int swphy_read_reg(int reg, const struct fixed_phy_status *state)
 	duplex_index = state->duplex ? SWMII_DUPLEX_FULL : SWMII_DUPLEX_HALF;
 
 	bmsr |= speed[speed_index].bmsr & duplex[duplex_index].bmsr;
+	estat |= speed[speed_index].estat & duplex[duplex_index].estat;
 
 	if (state->link) {
 		bmsr |= BMSR_LSTATUS | BMSR_ANEGCOMPLETE;
@@ -151,6 +157,8 @@ int swphy_read_reg(int reg, const struct fixed_phy_status *state)
 		return lpa;
 	case MII_STAT1000:
 		return lpagb;
+	case MII_ESTATUS:
+		return estat;
 
 	/*
 	 * We do not support emulating Clause 45 over Clause 22 register
-- 
2.22.0

