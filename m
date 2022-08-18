Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A955980B4
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237238AbiHRJRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiHRJRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:17:31 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D2367CA7;
        Thu, 18 Aug 2022 02:17:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660814199; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=USXBYp2MxaiuDHGWU5W4eTLantEidntEZ8iCdnHk6M3ctHr1EFg/JSPl9CjVy8LWnFXXxo1lZ919QZSqM8HScTrTroB4JCq6X0ic8GiHMXWu6DHE8Gfj6cQrCNkbpGFIE+Lq8QecvqyjOwTctPYGLpfKKjIYUkOvjEr4liDx4hc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660814199; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=r2yFPxeJOW4FSx26rqzEDXZD6XX1GgOaFnrmsBkM89Y=; 
        b=JuBycRjfQCsne9NV697b4UJuqzp7TqQ4dsrb41e56q6FX3l67Y9m2fCfWMXbyW8SuUM91bf9pFXsar7HedVOZK3Sv3S59BNga3Ui5Dk0o73mTS0qFH39TXo+qby885GywPHWeW6iqFgPXKxvp7nx0vuF2MsebBeUqnDZ2zI/wh0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660814199;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=r2yFPxeJOW4FSx26rqzEDXZD6XX1GgOaFnrmsBkM89Y=;
        b=YfauaA1pzQgStKULF51J08iaNkprUoc07njXNwtD2NWTdF4UoECdHCRrotXKmfz5
        MdeEz9Hm6C1ignB1OgYiFEZb1K2nR87ZvCf2KalgtFUIOedweqHOg9g/ETSl3Mucw3H
        nQUgNRXfIIyRF3VKllU60iDwodXYmAVVHz+h5rBw=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1660814196048527.2976968417031; Thu, 18 Aug 2022 02:16:36 -0700 (PDT)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH v3 0/6] completely rework mediatek,mt7530 binding
Date:   Thu, 18 Aug 2022 12:16:21 +0300
Message-Id: <20220818091627.51878-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

This patch series brings complete rework of the mediatek,mt7530 binding.

The binding is checked with "make dt_binding_check
DT_SCHEMA_FILES=mediatek,mt7530.yaml".

If anyone knows the GIC bit for interrupt for multi-chip module MT7530 in
MT7623AI SoC, let me know. I'll add it to the examples.

If anyone got a Unielec U7623 or another MT7623AI board, please reach out.

v3:
- Add Rob's Reviewed-by: to first patch.
- Explain why to invalidating reset-gpios and mediatek,mcm.
- Do not change ethernet-ports to ports on examples.
- Remove platform and, when possible, ethernet nodes from examples.
- Remove pinctrl binding from examples.
- Combine removing unnecesary lines patch with relocating port binding.
- Define $defs of mt7530 and mt7531 port binding and refer to them in each
compatible device.
- Remove allOf: for cases where there's only a single if:.
- Use else: for cpu port 6 which simplifies the binding.
- State clearly that the DSA driver does not support the MT7530 switch in
MT7620 SoCs.

v2:
- Change the way of adding descriptions for each compatible string.
- Split the patch for updating the json-schema.
- Make slight changes on the patch for the binding description.

Arınç ÜNAL (6):
  dt-bindings: net: dsa: mediatek,mt7530: make trivial changes
  dt-bindings: net: dsa: mediatek,mt7530: fix reset lines
  dt-bindings: net: dsa: mediatek,mt7530: update examples
  dt-bindings: net: dsa: mediatek,mt7530: define port binding per switch
  dt-bindings: net: dsa: mediatek,mt7530: define phy-mode for switch models
  dt-bindings: net: dsa: mediatek,mt7530: update binding description

 .../bindings/net/dsa/mediatek,mt7530.yaml       | 680 +++++++++++++++----
 1 file changed, 545 insertions(+), 135 deletions(-)


