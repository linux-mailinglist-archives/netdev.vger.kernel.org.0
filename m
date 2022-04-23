Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987B850CA75
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 15:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbiDWNR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 09:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbiDWNRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 09:17:39 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEF51DD225
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 06:14:41 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u7so1411895plg.13
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 06:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=date:message-id:from:to:cc:subject:content-transfer-encoding
         :mime-version;
        bh=tZUrl8zLKA5D27ChnNocJe50cIVDD1SSEejUzU+DrrI=;
        b=i8TV0Ww6bdfK6ykIROfAsZnjEnJS3ZqNeUmA+qBRONVVVWSA6HP7wmhLSMJ/1ajzS2
         1o/dWYH5BLqrzbKnSTDQqcrQCb5aeZybM4qBk3u2gZY8g1LlaHKf0YZiWtSH+lfjbLuU
         dE6kSOCKlwFPt7rMjY1dKGKkMnqPq4cy3zBkWrQXJQNiQ1cJ3fASGNc87w97yg7wN2hJ
         VFdh4FsAiuXCwepwqOzSv3BwVpgTL33i5n1qahZpnvEcrfiS9QWYPGuI/hPFHJlVljJc
         QjGgo4FUYb8oRQQvhcY+OtCjLsH3iRfmoUz258vD/GURt1qy3KVAv5K2lxgwc4YoBdwr
         JVEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:from:to:cc:subject
         :content-transfer-encoding:mime-version;
        bh=tZUrl8zLKA5D27ChnNocJe50cIVDD1SSEejUzU+DrrI=;
        b=bpDtGtBH33L71hBs1452j8S/DWw8/jo345LUQhxP8yQzuQfts5aROjtwg6DPFJqYmX
         NU3aCRdTp/addo0+Dr+bsWEHGYHCRNN/vGiJn0if8P77CNzuR0yJzE9/55CaGOXi5ESO
         QgosxK+kcmDSWtpaWgHqEi6wquziOK2c5jDlUIHlcI036EopkLjF7TOppWDhBbgfp8W8
         095ah05jjrdWMkQmWOj/ADoxm1SHp2j6h6P3WRYnimV7yZ3yvYOU3nzMg0BKRfpb38dX
         PgQIKVMhflgpXbH1JFpJGXwTdUtJbb5jbAIm4qJLskMEGFBtIvJ6LyRqcszFrvLOu6ao
         DolQ==
X-Gm-Message-State: AOAM5334V07BSqvxTuYKfgJFYLiOo+XDzWaqIFneSAs5wxXu6jSsXcUm
        sWE29BZR/zF4jc029yQwP4BSkw==
X-Google-Smtp-Source: ABdhPJzvdhfEGUXSzxlB9k8D2vR5vqIHv5iTi//MSitWGnSl/f7S28O/LHFKUDRMmL7GEWmFRCicZw==
X-Received: by 2002:a17:902:e94f:b0:14f:1636:c8a8 with SMTP id b15-20020a170902e94f00b0014f1636c8a8mr9338301pll.130.1650719680802;
        Sat, 23 Apr 2022 06:14:40 -0700 (PDT)
Received: from [127.0.1.1] (117-20-68-98.751444.bne.nbn.aussiebb.net. [117.20.68.98])
        by smtp.gmail.com with UTF8SMTPSA id w7-20020a63a747000000b003991d7d3728sm5103337pgo.74.2022.04.23.06.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 06:14:40 -0700 (PDT)
Date:   Sat, 23 Apr 2022 13:14:27 +0000
Message-Id: <20220423131427.237160-1-nathan@nathanrossi.com>
From:   Nathan Rossi <nathan@nathanrossi.com>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Nathan Rossi <nathan@nathanrossi.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: [PATCH 1/2] dt-bindings: net: dsa: marvell: Add single-chip-address property
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some Marvell DSA devices can be accessed in a single chip addressing
mode. This is currently configured by setting the address of the switch
to 0. However switches in this configuration do not respond to address
0, only responding to higher addresses (fixed addressed based on the
switch model) for the individual ports/etc. This is a feature to allow
for other phys to exist on the same mdio bus.

This change defines a 'single-chip-address' property in order to
explicitly define that the chip is accessed in this mode. This allows
for a switch to have an address defined other than 0, so that address
0 can be used for another mdio device.

Signed-off-by: Nathan Rossi <nathan@nathanrossi.com>
---
 Documentation/devicetree/bindings/net/dsa/marvell.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt b/Documentation/devicetree/bindings/net/dsa/marvell.txt
index 2363b41241..5c7304274c 100644
--- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
+++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
@@ -46,6 +46,8 @@ Optional properties:
 - mdio?		: Container of PHYs and devices on the external MDIO
 			  bus. The node must contains a compatible string of
 			  "marvell,mv88e6xxx-mdio-external"
+- single-chip-address	: Device is configured to use single chip addressing
+			  mode.
 
 Example:
 
---
2.35.2
