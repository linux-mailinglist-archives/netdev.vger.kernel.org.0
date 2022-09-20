Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECE85BEBFA
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 19:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiITR15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 13:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiITR1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 13:27:52 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2CA6E882;
        Tue, 20 Sep 2022 10:27:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663694840; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=RJuyl7+w0Zfr4UcIJq1U2uiJbejf+/Q0e4JpiPfmnKJCeN3aTeX4+keTWjN0EuBY7nhFHrl37mmWBdA0vnRpjq0EaoPS93qSi3niR0Q2Ni5Xtrac3lrNL0XYXTuwCi1wT2t/aRcZgylESyOAwsdfUELoZaj4+bE/qfT8YZBAaDU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663694840; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=+Ytz3zd2XzWPu+nFAbpA/0laCkm3lri72QZtfgCT9tw=; 
        b=RjAhd+7Indr44ljvFkRYw0ax7CRp7c/EJVa7ALdcFwhcKy7ejWPcP2RoNUKGj/getRny5XC/571/+sD89t40jJ67ijWnRA58mqpwc2p9IbKGVyn5a2VkKeXG+rrxG1yTfNDrEkaUMerg0shxz/tsU+HO5MPBGvKI8dUKea2lgIA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663694840;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=+Ytz3zd2XzWPu+nFAbpA/0laCkm3lri72QZtfgCT9tw=;
        b=Rlzv1ewdb7UFgWR6QtVeyNLvW7RObvQeucq4FH24IEdHNsc/AJDtYlhkZB/8VUK0
        snWoAFWvu0a2ubEUp0pWbtWKXukyasYxauhU8ZzGK23mPX/2UDT+cvo9xV3fStYJIoX
        zJ/khEqz1yZ0cVl0KPms64JXLtb9bXv0N6oEnFIo=
Received: from arinc9-Xeront.fusolab.local (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663694839331119.58991385266972; Tue, 20 Sep 2022 10:27:19 -0700 (PDT)
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
Subject: [PATCH v4 net-next 07/10] mips: dts: ralink: mt7621: change phy-mode of gmac1 to rgmii
Date:   Tue, 20 Sep 2022 20:25:53 +0300
Message-Id: <20220920172556.16557-8-arinc.unal@arinc9.com>
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

Change phy-mode of gmac1 to rgmii on mt7621.dtsi. Same code path is
followed for delayed rgmii and rgmii phy-mode on mtk_eth_soc.c.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
---
 arch/mips/boot/dts/ralink/mt7621.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/ralink/mt7621.dtsi b/arch/mips/boot/dts/ralink/mt7621.dtsi
index bcedb84e1618..edb7dd8b34da 100644
--- a/arch/mips/boot/dts/ralink/mt7621.dtsi
+++ b/arch/mips/boot/dts/ralink/mt7621.dtsi
@@ -333,7 +333,7 @@ gmac1: mac@1 {
 			compatible = "mediatek,eth-mac";
 			reg = <1>;
 			status = "disabled";
-			phy-mode = "rgmii-rxid";
+			phy-mode = "rgmii";
 		};
 
 		mdio: mdio-bus {
-- 
2.34.1

