Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA42585ABF
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 16:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbiG3O1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 10:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiG3O1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 10:27:47 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B60CE06;
        Sat, 30 Jul 2022 07:27:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1659191212; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=SAUGBqtTPPsBVHkBh7EoelJATuSg1N7cqwnqy5Z7YBLMdTcqdmzYarUFVC237VeFKLG8+AnxBZSkWjKTqYxYcJIWpaB0RzNHYLi6SxJIU0EON7ILGxexFbe2O7xHicsTFO8wgiWj6OIZqmDolmrLMpSMrdMZfnYiLJnitFQxJrk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1659191212; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=5UYaQfx7z0yBiGs6s5UW81nUMgZe1dH+iL0ZD0KuhhI=; 
        b=cdKctPWY2yJQnzf2ZR02VVd9MfaZpUhZmEJQZpb9F7cwbSCS4ZrJrrk6H9piBMeNDyXAyq1XRcZ2PG7drihb1lY7/hVTBIsnYTQCOGEJgFS2q6oRAt5GMOkqEEyCsaxTu14d3y9bgngzlgJAS/nCngJcl80FvGoIPV8dmPThMSc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1659191212;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=5UYaQfx7z0yBiGs6s5UW81nUMgZe1dH+iL0ZD0KuhhI=;
        b=FY8DNQtUB587XaroZ04z2bQAOwuKA5Jm1EDr8xgbqfIdLV3aM8uccPhHU7Ae+D80
        ShtvEobEDTvHWRDFoAsFnemNV6hPzdhdi4Fa30vuY9UeLaE4DoVG/5INj0cy9ezy/b/
        iEqmGAsjjRjoo8JMtDoPZ786hfR0Vdd1pempKzqQ=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1659191208836227.26789536942294; Sat, 30 Jul 2022 07:26:48 -0700 (PDT)
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
Subject: [PATCH 0/4] completely rework mediatek,mt7530 binding
Date:   Sat, 30 Jul 2022 17:26:23 +0300
Message-Id: <20220730142627.29028-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
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

Hello.

This patch series brings complete rework of the mediatek,mt7530 binding.

The binding is checked with "make dt_binding_check
DT_SCHEMA_FILES=mediatek,mt7530.yaml".

If anyone knows the GIC bit for interrupt for multi-chip module MT7530 in
MT7623AI SoC, let me know. I'll add it to the examples.

If anyone got a Unielec U7623 or another MT7623AI board, please reach out.

Arınç ÜNAL (4):
  dt-bindings: net: dsa: mediatek,mt7530: make trivial changes
  dt-bindings: net: dsa: mediatek,mt7530: update examples
  dt-bindings: net: dsa: mediatek,mt7530: update binding description
  dt-bindings: net: dsa: mediatek,mt7530: update json-schema

 .../bindings/net/dsa/mediatek,mt7530.yaml       | 1006 +++++++++++++-----
 1 file changed, 764 insertions(+), 242 deletions(-)


