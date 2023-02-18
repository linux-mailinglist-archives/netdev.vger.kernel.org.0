Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430D769B87F
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 08:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjBRHYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 02:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjBRHYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 02:24:23 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB88A4FA9F;
        Fri, 17 Feb 2023 23:24:21 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id eq13so793379edb.11;
        Fri, 17 Feb 2023 23:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yAD1DxvAYMRKEHrkkSuKbgeC08TTOx9gNI3h2o70G54=;
        b=R0RlR19heuvvC52611xkEkfa8RQ5ZjtJsn9GwQWeN/fzEEEf8jW5GDKSQUlIarCyIO
         cpT4PS1qOXQhUmbucngge08OiXT2rM6F9SWhKtBMVUrJFowwcTYe53+dosEBpIf21kpx
         1xtw7CRM7uD6WAyfR6H9WgzIpxXWZfh5Qlla2DmADPOKAy93T9tszBtABHgxeXDb/xw/
         ehTe9+PjY2Y+DjK7r3Dk/oNKfJXLfQca1QaQ5qOqdjdrSAZHbCm9mwO8ELbc7CD2ku1o
         tvcIfXzghxWWDGotSqEpg3k500FeiJAi9+BMtM7Tmx5TVeIs/R4WZxRVHS5k0mS9JwOz
         /jhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yAD1DxvAYMRKEHrkkSuKbgeC08TTOx9gNI3h2o70G54=;
        b=4ZWigyvfQTAnfZNdDbjanA3r3QMtc5byGraU5+UWlxU7ye6UbUOfsBqcaFBX6H+erM
         jidhkodAVifC7yMnXMWCXRdMtc7XhqYQCY4st/Js7v14h3Pef24kUbFiyoI1Zkpzd+6N
         qSD82/tjcREhVCLyNPT733G+34in5mfjYlZPvN33CkRvl4BMWaexl9D0nTJb1pm72La8
         mi8e+8hdit3v4RyaMIuUcmZi1kNK/rGW8oBE3Sk6AlPJvOIvsBbHT5rVfiK1DAAHu56J
         tVj6QIBSZCOZbSIHEZX+K8/xwFzzJmRBSfsT543Wree7k/8Nl7iOBzd8r2q05e1YnKLa
         GEBQ==
X-Gm-Message-State: AO0yUKVlYGJFS4HSv35Nj/WJ52ndt/G220WUQcxLPsX2eV+kSmeOBX57
        EwaIlK0xHj+dlX5AV/W7UoLtwhuBGhU7NGjPJZk=
X-Google-Smtp-Source: AK7set8XPgEIrp2vK5mCbMOHZUOzh1DHe8UKj5u++Uf314ibQLpn6ofnSQjkMsbCj8yiPfIows8UkQ==
X-Received: by 2002:aa7:d552:0:b0:4ad:5950:3f49 with SMTP id u18-20020aa7d552000000b004ad59503f49mr7842961edr.7.1676705060321;
        Fri, 17 Feb 2023 23:24:20 -0800 (PST)
Received: from arinc9-PC.lan ([37.120.152.236])
        by smtp.gmail.com with ESMTPSA id k7-20020a50ce47000000b004acb38eea1csm3179536edj.28.2023.02.17.23.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 23:24:19 -0800 (PST)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com
Subject: [PATCH] dt-bindings: net: dsa: mediatek,mt7530: change some descriptions to literal
Date:   Sat, 18 Feb 2023 10:23:48 +0300
Message-Id: <20230218072348.13089-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

The line endings must be preserved on gpio-controller, io-supply, and
reset-gpios properties to look proper when the YAML file is parsed.

Currently it's interpreted as a single line when parsed. Change the style
of the description of these properties to literal style to preserve the
line endings.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml        | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 449ee0735012..5ae9cd8f99a2 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -93,7 +93,7 @@ properties:
 
   gpio-controller:
     type: boolean
-    description:
+    description: |
       If defined, LED controller of the MT7530 switch will run on GPIO mode.
 
       There are 15 controllable pins.
@@ -112,7 +112,7 @@ properties:
     maxItems: 1
 
   io-supply:
-    description:
+    description: |
       Phandle to the regulator node necessary for the I/O power.
       See Documentation/devicetree/bindings/regulator/mt6323-regulator.txt for
       details for the regulator setup on these boards.
@@ -124,7 +124,7 @@ properties:
       switch is a part of the multi-chip module.
 
   reset-gpios:
-    description:
+    description: |
       GPIO to reset the switch. Use this if mediatek,mcm is not used.
       This property is optional because some boards share the reset line with
       other components which makes it impossible to probe the switch if the
-- 
2.37.2

