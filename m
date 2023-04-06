Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C556D910E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbjDFICb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235766AbjDFIC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:02:26 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B397B7EC3;
        Thu,  6 Apr 2023 01:02:20 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id v14-20020a05600c470e00b003f06520825fso2413886wmo.0;
        Thu, 06 Apr 2023 01:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680768139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z1Dy9jILghc2oin2d9VIZqVYpUmKIJ7JSNuj8W4KgH8=;
        b=RGvP+SDZxX9ME1EKpF3ct3mhEv1ZmdaEzq63cIvihhDYWiECOzUOxAgTEaIJStyOHt
         3Q3RDWHrn9fZSiI8hOlPQYwy988GyH9GtytIjPpNwN2BccfQnKBKuCQ4DHe3eCJSFrFW
         WwrIIQ0nkdMXOQhtAkDPhZWeq2KlUIAjkgLvWyPnc/GFhXTLZtEpbhtirZRCyHhdSmEj
         c1foqVMh+QGOqph6DBFcPdVXjYV/Tm1agZgpbPdmx/h+2oVUumbHPjQZA5VgCdE2nYd0
         HZqWyWgeOQoI8FyqkkOKpHXQsviiZweeQ7TlYjjbfNCJf8/XtBxqc8w3axtSx3kOyAwz
         /n9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680768139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z1Dy9jILghc2oin2d9VIZqVYpUmKIJ7JSNuj8W4KgH8=;
        b=qLkV0sLBYKyfnrc/kfDNgfRYOoDEVgEB0qs7x/SXjx4Ah+vGTHEGgPo1bmpPGVQNMd
         GVnFCrGxcegiATUWQXINk4yvoJnstJybwLim/mpyV7fnLcjOOOCBixUccngDcOKIoMAv
         2lHyni3Fd2y8AMmwi16Q4RGfO70bMj4WpnlEZr4zomh77MHlhLlQnuBXOL9Wp5/6gEir
         n8EL7I35JhFzcaCHCbiaaJdybXfV93kyQqrWIuWg1BBcwtGbYt1WsUXbwvifxSV2qjH0
         fvw0wnbna+8i6vXdlFh8542VtyY7Dt5WYW+zRL3U81llI1DpEmD5J4j2ma7vnItgzpbo
         F/eg==
X-Gm-Message-State: AAQBX9c3BYdGb5tW8MwWSdfOTfnaq6tjdj+GMAWqBf4m5yZ8ZykWA9GD
        Tx2gEYPZ/R3Fab5Omx4OD34=
X-Google-Smtp-Source: AKy350YO5UG8gcVMQFQKFtkzSgSlc9tFvejLdwA8V7eMge/Igj8Gq/c0hD+r7klScptaKFWE9kKbNQ==
X-Received: by 2002:a1c:4b10:0:b0:3ed:de58:1559 with SMTP id y16-20020a1c4b10000000b003edde581559mr6869833wma.2.1680768139043;
        Thu, 06 Apr 2023 01:02:19 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id s9-20020a7bc389000000b003ef64affec7sm826993wmj.22.2023.04.06.01.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:02:18 -0700 (PDT)
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
        Daniel Golle <daniel@makrotopia.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 4/7] dt-bindings: net: dsa: mediatek,mt7530: allow delayed rgmii phy-modes
Date:   Thu,  6 Apr 2023 11:01:38 +0300
Message-Id: <20230406080141.22924-4-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230406080141.22924-1-arinc.unal@arinc9.com>
References: <20230406080141.22924-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

According to mt7530_mac_port_get_caps() and mt7531_mac_port_get_caps(), all
rgmii phy-modes on port 5 are supported. Add the remaining to
mt7530-dsa-ports and mt7531-dsa-ports definitions.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml        | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 605888ce2bc6..9d99f7303453 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -196,6 +196,9 @@ $defs:
                       - gmii
                       - mii
                       - rgmii
+                      - rgmii-id
+                      - rgmii-rxid
+                      - rgmii-txid
               else:
                 properties:
                   phy-mode:
@@ -234,6 +237,9 @@ $defs:
                       - 1000base-x
                       - 2500base-x
                       - rgmii
+                      - rgmii-id
+                      - rgmii-rxid
+                      - rgmii-txid
                       - sgmii
               else:
                 properties:
-- 
2.37.2

