Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AF95293C3
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349741AbiEPWsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349715AbiEPWsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:48:13 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [202.36.163.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D1C4130D
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 15:48:10 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 7DE102C01C6;
        Mon, 16 May 2022 22:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1652741288;
        bh=1GS6Dpv7peXBo+oFsPrM70r4NHWXy3wXeFEEXUeukEY=;
        h=From:To:Cc:Subject:Date:From;
        b=N1xkDZA60xwb9JDZp4pIqQn3aHzQ/Ya5SG4rUD30f3qmXokILitrD1mLvVo+suvUm
         SoK9+SiC0lz17Ul4uKYFEyje7QMXXblOgDE184/X+d1VUNOF2bCWsELBdg0bazKV6S
         VSQ01Xk8f7v4wBKSvopq2XrGQANUU+6tWyqZqi3gOnPYzoNl5oCmgrlddJQznaJAur
         3XnYp0sLFGAECb9hgfdnH+uIf2QQ7bOXDhPKihb6N7fSmMX2ZLBoWo5TrIK+kakyZB
         1XvjLMVRl68+3B73pvoieAtOlZSLOe2b6eTKTQNtwuUxOq53OeheZ6wSJhzKviK0Vg
         iRHpWd/newY3Q==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6282d4a80000>; Tue, 17 May 2022 10:48:08 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 3E0FC13ED7D;
        Tue, 17 May 2022 10:48:08 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 360C92A0086; Tue, 17 May 2022 10:48:08 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        kabel@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 0/2] armada-3720-turris-mox and orion-mdio
Date:   Tue, 17 May 2022 10:47:59 +1200
Message-Id: <20220516224801.1656752-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=U+Hs8tju c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=oZkIemNP1mAA:10 a=mjDiMDIlsi9F-Tf1zcUA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up to the change that converted the orion-mdio dt-bindin=
g from
txt to DT schema format. At the time I thought the binding needed
'unevaluatedProperties: false' because the core mdio.yaml binding didn't =
handle
the DSA switches. In reality it was simply the invalid reg property causi=
ng the
downstream nodes to be unevaluated. Fixing the reg nodes means we can set
'unevaluatedProperties: true'

Marek,

I don't know if you had a change for the reg properties in flight. I didn=
't see
anything on lore/lkml so sorry if this crosses with something you've done=
.

Chris Packham (2):
  arm64: dts: armada-3720-turris-mox: Correct reg property for mdio
    devices
  dt-bindings: net: marvell,orion-mdio: Set unevaluatedProperties to
    false

 .../devicetree/bindings/net/marvell,orion-mdio.yaml  |  2 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts      | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--=20
2.36.1

