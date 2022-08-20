Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CCC59AC6F
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 10:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245373AbiHTIIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 04:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiHTIIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 04:08:47 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77B92AC6D;
        Sat, 20 Aug 2022 01:08:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660982888; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Do4/0bKH2TLQt23fEbxQeWdNNRPu5G9ElmZ+hJQUxk4BjzxxyoiOJAuLgOGwxqlRU3g2VFT/J01b3Z/U/S6h3AGjkIfwulFClx0EzAc+mHfaIJjPtkPokeNz7VTDeOH3EoqG32rmcQkV2NQCoSXkHyON9sANAV9F4ywa+kTAAeQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660982888; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=NeRoVH6YC+bOoPXLzZ/zHt1qQTsqVmbHTKnjSX+8XSQ=; 
        b=Dvehy5nM+pLU8nUfOPCusyYb0akpPYUOUW3qzRkB0lderFkOqBXPQB/UFmVkVUAN5oIo+PSV9nETc10p5iPvbu0nfZiSq2CtTwZm3AhIF+XhIpN3zWQJULUtzxaEoDSWgZoHuWRaiZ2o/vvM51VfUWxF9ASNVRZG16oGLjWrvr0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660982888;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=NeRoVH6YC+bOoPXLzZ/zHt1qQTsqVmbHTKnjSX+8XSQ=;
        b=FLgMImQ/DHgfxVRjJtEQTWm4Bz0LmhOGwJEUEoq5+bfs8lWSMjz6MpBHFbkSzs3H
        BZYSD4KvDJCX/7C0tEXoZehBW7tO2pXFCKeThlt84WDZeOF6Cd52yS3TfKyUbubwbnQ
        OyhH4Pm38StiQO62buSvGicXJ6+AvB/ajBP3lo4k=
Received: from arinc9-PC.lan (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1660982886821459.07285493323946; Sat, 20 Aug 2022 01:08:06 -0700 (PDT)
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
Subject: [PATCH v4 0/6] completely rework mediatek,mt7530 binding
Date:   Sat, 20 Aug 2022 11:07:52 +0300
Message-Id: <20220820080758.9829-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
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

Hello.

This patch series brings complete rework of the mediatek,mt7530 binding.

The binding is checked with "make dt_binding_check
DT_SCHEMA_FILES=mediatek,mt7530.yaml".

If anyone knows the GIC bit for interrupt for multi-chip module MT7530 in
MT7623AI SoC, let me know. I'll add it to the examples.

If anyone got a Unielec U7623 or another MT7623AI board, please reach out.

v4:
- Define reg property on $defs as it's the same for all switch models.

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

 .../bindings/net/dsa/mediatek,mt7530.yaml       | 677 +++++++++++++++----
 1 file changed, 542 insertions(+), 135 deletions(-)


