Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819AE5BEBEC
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 19:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbiITR1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 13:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiITR1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 13:27:40 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D6E6CF57;
        Tue, 20 Sep 2022 10:27:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663694831; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=mWrbfMCj1fqji88vIWZITlHYhOlTWCiWVOkgFXCAfe3DKPlhM+huQTnOh2a3ay7lWysr8xyJv4m0w4puvjBi5w+Dr7jrBqZhKe4Afdnii2V0eOir5sr4oVm6oHVAyfgt5m8bAAhDOxizvbXYmIr2m/NaEvyEyxNYw39hmnt/6pc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663694831; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=JTenQONxyrR2NLUejYhZ1v1RTmEl+bc+QPc+o+Ooz3M=; 
        b=ndASbSLEchua3LPZxGYpAIbsHL3dsY8hKc0F2L6ABk+9mt1mwXHtHnq5bAiNmfqULCJ6ApTnu1/R2DcEXE/bcpnYXwqYqh6BnHP4Eff4XjfvjKqqq31wYpDnlKLF13qeeOAjCHNSWN05nvWlMufZsHKIRFGY+6MpthSEe1YmpfQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663694831;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=JTenQONxyrR2NLUejYhZ1v1RTmEl+bc+QPc+o+Ooz3M=;
        b=AgA0oCcbzbMtOOHD/eepEV2l56jX+xDofBOuu/2TYoXp2Z3CCDvqqSX6GwmHufVd
        OL8LfQSe0mhleoSfAAyS0aJ50kvVPCpCEAZJ6PDV8aT2Bv4aWPX8gEsi85PvG/Cnt8e
        PFvTkq7YxgH5B2ogSGrwmJMvUYgA3nZphtihVWQQ=
Received: from arinc9-Xeront.fusolab.local (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 166369483125052.3963724468872; Tue, 20 Sep 2022 10:27:11 -0700 (PDT)
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
Subject: [PATCH v4 net-next 06/10] mips: dts: ralink: mt7621: remove interrupt-parent from switch node
Date:   Tue, 20 Sep 2022 20:25:52 +0300
Message-Id: <20220920172556.16557-7-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220920172556.16557-1-arinc.unal@arinc9.com>
References: <20220920172556.16557-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The interrupt-parent property is inherited from the ethernet node as it's a
parent node of the switch node. Therefore, remove the unnecessary
interrupt-parent property from the switch node.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
---
 arch/mips/boot/dts/ralink/mt7621.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/boot/dts/ralink/mt7621.dtsi b/arch/mips/boot/dts/ralink/mt7621.dtsi
index 7cef1273796d..bcedb84e1618 100644
--- a/arch/mips/boot/dts/ralink/mt7621.dtsi
+++ b/arch/mips/boot/dts/ralink/mt7621.dtsi
@@ -348,7 +348,6 @@ switch0: switch@0 {
 				reset-names = "mcm";
 				interrupt-controller;
 				#interrupt-cells = <1>;
-				interrupt-parent = <&gic>;
 				interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
 
 				ports {
-- 
2.34.1

