Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3C75B8372
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 10:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiINI5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 04:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiINI4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 04:56:45 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B53C74DCC;
        Wed, 14 Sep 2022 01:56:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663145743; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=GjnD/y1nylC/ssjzFpVpPgdfXJVt4IOmCh4dphXfnj1utdaw0Y5tZeUvKcrkoWrnzqtUibI/Z6DQwrNPZCPGHbvaN9XGc86T4cFIkAWjFXiWPyaR9x8R4n3xkKYD9rJ6/4//9APerL8OAL7gJDZwfqrUUUYyYBTw+Ni1EtB6rcE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663145743; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=R4ALxyq+RBO+GV4tDQQ/4ssUEgJ4SrRXCbUkyXnabqQ=; 
        b=ZzI6c/QZK60dvXNtj+mJtMSP5z4Rl4zsYvPDN7MZo/slVfN4cCXcT0VkeIyUpwzn8PR+EMpIQhUTjI4ruzv+6rHvnLP6UnzHQ/eg0FxCvRVWT4nNWTpEHlt89rgg630T3bOj1UeqDs99UhLrMqD8x2L3bOIKTClutF2COiAU2k8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663145743;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=R4ALxyq+RBO+GV4tDQQ/4ssUEgJ4SrRXCbUkyXnabqQ=;
        b=VPs+Zc6RO2GsjBVWKHAqCOqXgRK8rB77QUJ289Xy0zX7RZhXSdVqAE7EPTI9iGKd
        dfO8w//p0+cgI+FKhViuOr2FcwElL5zCRdQsfIIKK20EhWEmK+LP9kE0hQ9D9jHiupW
        p0+W9Iaz/80cLz8eLrvuf3G1eAg4EbPtQ7WVywaI=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663145742438887.9640433477236; Wed, 14 Sep 2022 01:55:42 -0700 (PDT)
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
Subject: [PATCH 07/10] mips: dts: ralink: mt7621: change phy-mode of gmac1 to rgmii
Date:   Wed, 14 Sep 2022 11:54:48 +0300
Message-Id: <20220914085451.11723-8-arinc.unal@arinc9.com>
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

Change phy-mode of gmac1 to rgmii on mt7621.dtsi. Same code path is
followed for delayed rgmii and rgmii phy-mode on mtk_eth_soc.c.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 arch/mips/boot/dts/ralink/mt7621.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/ralink/mt7621.dtsi b/arch/mips/boot/dts/ralink/mt7621.dtsi
index e9203fec3fdf..50799bb1cc5d 100644
--- a/arch/mips/boot/dts/ralink/mt7621.dtsi
+++ b/arch/mips/boot/dts/ralink/mt7621.dtsi
@@ -331,7 +331,7 @@ gmac1: mac@1 {
 			compatible = "mediatek,eth-mac";
 			reg = <1>;
 			status = "disabled";
-			phy-mode = "rgmii-rxid";
+			phy-mode = "rgmii";
 		};
 
 		mdio: mdio-bus {
-- 
2.34.1

