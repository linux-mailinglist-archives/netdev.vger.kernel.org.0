Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88007693735
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 13:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjBLMQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 07:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjBLMQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 07:16:36 -0500
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D823DE052;
        Sun, 12 Feb 2023 04:16:33 -0800 (PST)
Received: from robin.home.jannau.net (p579ad32f.dip0.t-ipconnect.de [87.154.211.47])
        by soltyk.jannau.net (Postfix) with ESMTPSA id 37C2626F76B;
        Sun, 12 Feb 2023 13:16:31 +0100 (CET)
From:   Janne Grunau <j@jannau.net>
Subject: [PATCH v2 0/4] dt-bindings: net: Add network-class.yaml schema
Date:   Sun, 12 Feb 2023 13:16:28 +0100
Message-Id: <20230203-dt-bindings-network-class-v2-0-499686795073@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJzY6GMC/42OSwrCMBCGryJZOzKZ2IeuvIe4SDtDG5UpJLEip
 Xc39QSufj74X4tJEoMkc94tJsocUpi0AO13ph+9DgKBCxtCckjogDN0QTnokEAlv6f4gP7pU4L
 W1Y0w182JyZR855NAF73249aAiMBloZccRSC31lJp25xjSHmKn9+J2Ra5/rM3W0A4ViTomooQ+
 XL3qv51KDZzW9f1C4fabxDdAAAA
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?utf-8?q?J=C3=A9r=C3=B4me_Pouiller?= <jerome.pouiller@silabs.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Ley Foon Tan <lftan@altera.com>,
        Chee Nouk Phoon <cnphoon@altera.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Janne Grunau <j@jannau.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2214; i=j@jannau.net;
 h=from:subject:message-id; bh=y7QrjK1UKfIGXPczHYVce0GeZzI5ACPm72GbLe9dHPc=;
 b=owGbwMvMwCG2UNrmdq9+ahrjabUkhuQXN+atn7qg2jhxduj922unGymYVfUGnlw5RaUwdDuTT
 aK6UHRRRykLgxgHg6yYIkuS9ssOhtU1ijG1D8Jg5rAygQxh4OIUgImIizAynGqae35x2N7/ospc
 n1dGJhTnhh5h3Hmk9uKZ/JbpYnHHbBj+Sm9y+8fyXrj49t6J4dw+cqnPxUvz1vzhYs3I2rJznZU
 qDwA=
X-Developer-Key: i=j@jannau.net; a=openpgp;
 fpr=8B336A6BE4E5695E89B8532B81E806F586338419
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Devicetree Specification, Release v0.3 specifies in section 4.3.1
a "Network Class Binding". This covers MAC address and maximal frame
size properties. "local-mac-address" and "mac-address" with a fixed
"address-size" of 48 bits are already in the ethernet-controller.yaml
schema so move those over.

Keep "address-size" fixed to 48 bits as it's unclear if network protocols
using 64-bit mac addresses like ZigBee, 6LoWPAN and others are relevant for
this binding. This allows mac address array size validation for ethernet
and wireless lan devices.

"max-frame-size" in the Devicetree Specification is written to cover the
whole layer 2 ethernet frame but actual use for this property is the
payload size. Keep the description from ethernet-controller.yaml which
specifies the property as MTU.

Signed-off-by: Janne Grunau <j@jannau.net>
---
Changes in v2:
- Added "max-frame-size" with the description from ethernet-controller.yaml
- Restrict "address-size" to 48-bits
- Fix the mac-address array size to 6 bytes
- Drop duplicate default value from "max-frame-size" description
- Fix 2 nios2 dts files which incorrectly use the ethernet frame size of 1518
- Link to v1: https://lore.kernel.org/r/20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net

---
Janne Grunau (4):
      dt-bindings: net: Add network-class schema for mac-address properties
      dt-bindings: wireless: bcm4329-fmac: Use network-class.yaml schema
      dt-bindings: wireless: silabs,wfx: Use network-class.yaml
      nios2: dts: Fix tse_mac "max-frame-size" property

 .../bindings/net/ethernet-controller.yaml          | 25 +-----------
 .../devicetree/bindings/net/network-class.yaml     | 44 ++++++++++++++++++++++
 .../bindings/net/wireless/brcm,bcm4329-fmac.yaml   |  5 ++-
 .../bindings/net/wireless/silabs,wfx.yaml          |  5 +--
 arch/nios2/boot/dts/10m50_devboard.dts             |  2 +-
 arch/nios2/boot/dts/3c120_devboard.dts             |  2 +-
 6 files changed, 52 insertions(+), 31 deletions(-)
---
base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
change-id: 20230203-dt-bindings-network-class-8367edd679d2

Best regards,
-- 
Janne Grunau <j@jannau.net>

