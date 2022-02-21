Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5BC4BEB82
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiBUUBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:01:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiBUUBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:01:36 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2488922BD6;
        Mon, 21 Feb 2022 12:01:13 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id q5so12078424oij.6;
        Mon, 21 Feb 2022 12:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6pzKBa3wjo/GJPKZsQ/polHNRWOW8HKl2pEaJ8tCqjE=;
        b=p0NT9fJ6vpbGel6GlLbHiHJcnPzqpGXbVN23G2+CHxQ96SstHA0hTR+2sLBnmpu1WE
         R9FUV8wlKeUh7e8giAZCMcTXs/7iiWa2Rdzb9WMuXYoRiJX3lnEX7b6ymr+wZsJuPEj3
         WpHFXVWCE8/NMa04QxhjvvVeuFZaexSVxGVbIYvI86yd1HbcNqRON5MnFJjxBvx1uETo
         ar7342fPKMd0oiBtptM+NK7Eu38vVUedqvP2DtGvnPe7w9HfJcoS9wGwQO0EVgLV83Mb
         C6fZX1GTGE9WdlYp/zqKHFLLRe2rF+BSoT4W+8jLXsS5ihC8iVPwmHKs7SzQJmUwJnqb
         Ommg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6pzKBa3wjo/GJPKZsQ/polHNRWOW8HKl2pEaJ8tCqjE=;
        b=HkWQ/kHf/HWM4vf/UkzvnOUmLbm9WhvJLFbs+hmWh9qielYKu5XHMFsIzNQiKtjdqd
         KrajXUA9rsKCVgwv+BBCksguFCjc6nmRJRY4BzOtoa8mm4m6O3yAfwjIDnWlSC2WbYF3
         35NVocRB4BK7ixVoshF/srwvLpC7hHIm1DAtgZA7MISY+BGtej9ERdBq3lWinianJcqg
         wamVI148AE88IJ4LrRolwuEUzx8wV9elccn9mjBXsY/bV3u82QRg0RS1wS8fkGavXasw
         pgMBjIADB7TIDbFlV6sHL0LTJ06AHUSzs4ebyGo2tZSGxuzZVfl3AC6l+rkAsfx9U70N
         93+w==
X-Gm-Message-State: AOAM533959jyPNO8VoKvhTcNNAyQdK9nvQ5zloVRyXdtB7I8zGA4hfGq
        m0Av0dDW5r9CNnfbF4L1psHlMeXet+E1bw==
X-Google-Smtp-Source: ABdhPJxAonxJSHMLb+ZJBNadcvNI6YVfxJ0Od/thqnWj3cB/pwF8DGpghFriRhMoONE66pMPf2Qcfw==
X-Received: by 2002:a05:6808:f0a:b0:2cd:453:eb45 with SMTP id m10-20020a0568080f0a00b002cd0453eb45mr319648oiw.71.1645473672096;
        Mon, 21 Feb 2022 12:01:12 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id l19sm15938933oao.12.2022.02.21.12.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 12:01:11 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     devicetree@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH v3 1/2] dt-bindings: net: dsa: add new mdio property
Date:   Mon, 21 Feb 2022 17:01:02 -0300
Message-Id: <20220221200102.6290-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The optional mdio property will be used by dsa switch to configure
slave_mii_bus when the driver does not allocate it during setup.

Some drivers already offer/require a similar property but, in some
cases, they rely on a compatible string to identify the mdio bus node.
Each subdriver might decide to keep existing approach or migrate to this
new common property.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index b9d48e357e77..f9aa09052785 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -32,6 +32,12 @@ properties:
       (single device hanging off a CPU port) must not specify this property
     $ref: /schemas/types.yaml#/definitions/uint32-array
 
+  mdio:
+    unevaluatedProperties: false
+    description:
+      Container of PHY and devices on the switches MDIO bus.
+    $ref: /schemas/net/mdio.yaml#
+
 patternProperties:
   "^(ethernet-)?ports$":
     type: object
-- 
2.35.1

