Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622E451E8CA
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 19:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446700AbiEGRJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 13:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386496AbiEGRIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 13:08:43 -0400
Received: from mxout3.routing.net (mxout3.routing.net [IPv6:2a03:2900:1:a::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75FC1BE82;
        Sat,  7 May 2022 10:04:56 -0700 (PDT)
Received: from mxbox4.masterlogin.de (unknown [192.168.10.79])
        by mxout3.routing.net (Postfix) with ESMTP id 6399660561;
        Sat,  7 May 2022 17:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1651943095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kQGjAPgxXMx5RZIrcI5ogphC8uWLFPFwvCvXcCVMHqU=;
        b=vfTBcOixxCyFGCW3s4UB5MOixwOFWza8wERUoyzoelsajfTMzb7GRxILn+lultvdyiJ8sB
        dg+FsWw6tgO/efLBgvlVvCjSGN3V8TkokygxUwZcCPYWuXiFTdCa16KBas85ZrvNMTIjIx
        lPFlmKSlwTOH6Ydvhy1VbgG4TAdBEX4=
Received: from localhost.localdomain (fttx-pool-80.245.74.2.bambit.de [80.245.74.2])
        by mxbox4.masterlogin.de (Postfix) with ESMTPSA id 4D04F800E7;
        Sat,  7 May 2022 17:04:54 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>
Subject: [PATCH v3 5/6] dt-bindings: net: dsa: make reset optional and add rgmii-mode to mt7531
Date:   Sat,  7 May 2022 19:04:39 +0200
Message-Id: <20220507170440.64005-6-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220507170440.64005-1-linux@fw-web.de>
References: <20220507170440.64005-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: 1f6b5a5f-c8a8-429e-acae-3c548684f78b
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

Make reset optional as driver already supports it, allow port 5 as
cpu-port and phy-mode rgmii for mt7531 cpu-port.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml          | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index a7696d1b4a8c..d02faed41b2a 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -55,6 +55,7 @@ description: |
     On mt7531:
       - "1000base-x"
       - "2500base-x"
+      - "rgmii"
       - "sgmii"
 
 
@@ -159,9 +160,6 @@ allOf:
       required:
         - resets
         - reset-names
-    else:
-      required:
-        - reset-gpios
 
   - if:
       required:
-- 
2.25.1

