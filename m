Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B286D9116
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbjDFIC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236044AbjDFICd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:02:33 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FA37ED3;
        Thu,  6 Apr 2023 01:02:28 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n10-20020a05600c4f8a00b003ee93d2c914so24735741wmq.2;
        Thu, 06 Apr 2023 01:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680768147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aA5NdqluYyuyJgpU2xMc4bklKNQ4+NDybzhpsjIzUzo=;
        b=lV/QZB18CxFfmJKB4mKWpBOCfPvrpEhyZ6LkZPtrlnwqSJ8zhP2DRZoju2VW/Oy0UN
         thhs5LDM/CKa2MMn9r74RUEiIQLMRwEaxKL1pwZqDEpm2XxygHkH8Y101yBkkhYERijF
         nXT5IicjEujXwoGBWLdp7yIZAnmdZO4/JdVuOagei4jFms9+e9zLEedXEE3m4RcpECj9
         ZuG4F0JncgjSr5pvapi1MmP410E/svBGd0lzGUuSSZzYMIwvD3N9JV/seTJ7rfixquDg
         xktnfAmSD3z35x+I7Q3amTffZwdgllldRnCvNKwd+bK1RMXOhrQawdom8c3X0SWkSF3J
         piMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680768147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aA5NdqluYyuyJgpU2xMc4bklKNQ4+NDybzhpsjIzUzo=;
        b=q23QVhC8wf5yaQEphX/5rMULnyNsRgtH4h94VpYhrOAWEmQbD1TvOYcpDgrOrKpFgX
         +1kkSGBu3a8wYrWfQ0l87FVcFcl5cN9srNXB/5t19h4Ex2DeZ4whcrvw3VkmeFjb371+
         V2uskKzZk/bom/CGbpvd9edPcHPUlEe4ji7yvlnLeP2J1UyCIpMUbFEcPqj+0U9yH82k
         ViNkjI1FJBrlWXgdTlywnNirl8/8RAj4In1wUpIesdtAiX1bK5zzILL7154J9prUWA+I
         6UL5ttgyJbCEnmpU29Qd/Krnr2dcjN7t+f1HGO/gq1/1lQbuRjuZYpHhk7Rd1kLwUKjF
         9VUw==
X-Gm-Message-State: AAQBX9fMqV/v1NMxoOEDRXTrI8CshHI4F2lnA726pLo3RMVuKJ+2H6rP
        YWeAqoC1hIkb1qcMIpJz+0E=
X-Google-Smtp-Source: AKy350bzZPnNNXqxUTt+rQdFAAXBkweS3uWiUyTfUHfxuieEJ7GOxGxGgDDmv9vTnksNwhu8CxQDMg==
X-Received: by 2002:a05:600c:301:b0:3e2:19b0:887d with SMTP id q1-20020a05600c030100b003e219b0887dmr6579110wmd.25.1680768146933;
        Thu, 06 Apr 2023 01:02:26 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id s9-20020a7bc389000000b003ef64affec7sm826993wmj.22.2023.04.06.01.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:02:26 -0700 (PDT)
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
Subject: [PATCH 7/7] dt-bindings: net: dsa: mediatek,mt7530: allow mediatek,mcm on MT7531
Date:   Thu,  6 Apr 2023 11:01:41 +0300
Message-Id: <20230406080141.22924-7-arinc.unal@arinc9.com>
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

Allow mediatek,mcm on MT7531. There's code specific to MT7531 that checks
if the switch is part of an MCM.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 0095b7fcef72..b1dc1600f0dc 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -312,7 +312,6 @@ allOf:
       $ref: "#/$defs/mt7531-dsa-port"
       properties:
         gpio-controller: false
-        mediatek,mcm: false
 
   - if:
       properties:
-- 
2.37.2

