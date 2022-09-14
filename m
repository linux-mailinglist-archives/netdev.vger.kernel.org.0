Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27005B837A
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 10:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiINI51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 04:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiINI5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 04:57:00 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCB2754B1;
        Wed, 14 Sep 2022 01:56:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663145755; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=drNCMGnpaC1O37wVgp0Xcj2fLvoJG6WtISIPFVBgUFu+EfM7j6kmXmKSPDt9tOP7d5W1LG0XWaDQhnB8Zez74AanYcZZ4bhHl09kCF/FUuCJt5/a/DDyHbFV863D+b2Lx6YR7e1EaSeHXywU8IMUF6z8GmTmEb0A4gWrIjfA6V8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663145755; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=cN/vVpd4kMo1dSKFcVUlYwkahGokSNXVTYI2UGNTrT8=; 
        b=S+WXaArXB6gBrMvUlgGZhNILYDWedLz6iofh0M4Uf8E97EI0VP5TlIm7NjRiYlaozIYzWkQuGXE1lzlLPJyKllq4RZaCFGLILkmVOgd7vb2tX1jWjfXlKEz9ydkm/UmI0mHUpk5tLB5mp9cnwEqrKNByu4JQ4juB0ET9A3kR3j4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663145755;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=cN/vVpd4kMo1dSKFcVUlYwkahGokSNXVTYI2UGNTrT8=;
        b=MdOzQnoHOS3Cp0dljo2jMIBss584fLWC2inX5ArH+RWOhjOj1BzvLoaxrcMtdsGz
        yHPd3XapxmBU465Ndd1iBcmr1CO2Kv/U4y6ZoGnWhnd9NQ2PkzHeRdYFTy3zl58dBq5
        oGEoyrvnhfljUy3e9InHFmD0O7Kz4EUERk7tgWds=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663145753702140.0435409651668; Wed, 14 Sep 2022 01:55:53 -0700 (PDT)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        erkin.bozoglu@xeront.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH 09/10] mips: dts: ralink: mt7621: fix external phy on GB-PC2
Date:   Wed, 14 Sep 2022 11:54:50 +0300
Message-Id: <20220914085451.11723-10-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914085451.11723-1-arinc.unal@arinc9.com>
References: <20220914085451.11723-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The address of the external phy on the mdio bus is 5. Update the devicetree
for GB-PC2 accordingly.

Fixes: 5bc148649cf3 ("staging: mt7621-dts: fix GB-PC2 devicetree")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
index 2e534ea5bab7..5f52193a4c37 100644
--- a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
+++ b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
@@ -83,12 +83,12 @@ &pcie {
 
 &gmac1 {
 	status = "okay";
-	phy-handle = <&ethphy7>;
+	phy-handle = <&ethphy5>;
 };
 
 &mdio {
-	ethphy7: ethernet-phy@7 {
-		reg = <7>;
+	ethphy5: ethernet-phy@5 {
+		reg = <5>;
 		phy-mode = "rgmii-rxid";
 	};
 };
-- 
2.34.1

