Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065A4689B58
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbjBCOQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbjBCOQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:16:36 -0500
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DDC1E5C8;
        Fri,  3 Feb 2023 06:15:52 -0800 (PST)
Received: from robin.home.jannau.net (p579ad32f.dip0.t-ipconnect.de [87.154.211.47])
        by soltyk.jannau.net (Postfix) with ESMTPSA id 1EA7626F702;
        Fri,  3 Feb 2023 14:56:33 +0100 (CET)
From:   Janne Grunau <j@jannau.net>
Subject: [PATCH RFC 0/3] dt-bindings: net: Add network-class.yaml schema
Date:   Fri, 03 Feb 2023 14:56:25 +0100
Message-Id: <20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIkS3WMC/x2OzQrCMBCEX6Xs2YX8QFu9Cj6AV/GQZtd2UdKSD
 SqUvrupxw9mvpkVlLOwwqlZIfNbVOZUwR4aiFNII6NQZXDGeeOMRyo4SCJJo2Li8pnzE+MrqGL
 v246J2u5IDmp/CMo45JDitBuMMUh1IXLJzFh6a1217ckl80O+/xc3uF7OcN+2H67Qr46aAAAA
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?utf-8?q?J=C3=A9r=C3=B4me_Pouiller?= <jerome.pouiller@silabs.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Janne Grunau <j@jannau.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2135; i=j@jannau.net;
 h=from:subject:message-id; bh=OyjiYcL5gloli8dGEKyGMwu4GJoVIhGXxdEvMCrHIM8=;
 b=owGbwMvMwCG2UNrmdq9+ahrjabUkhuS7QhOif7TdVFU9tO/djdrEmQq6x5wmCdx6MtPlFD/3a
 q9Vk4w0OkpZGMQ4GGTFFFmStF92MKyuUYypfRAGM4eVCWQIAxenAEzkVD4jw7zZ86qao5f/2Lf/
 +/veuqt3f0qs45jLyL2+o/k/R6Lcp2iG/ynl5d1Vuh3rJnmf7eT5cb1W+b3WhXtZW6vbU2ZtlOY
 O4AEA
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
address-size of 48 bits is already in the ethernet-controller.yaml
schema so move those over.
I think the only commonly used values for address-size are 48 and 64
bits (EUI-48 and EUI-64). Unfortunately I was not able to restrict the
mac-address size based on the address-size. This seems to be an side
effect of the array definition and I was not able to restrict "minItems"
or "maxItems" based on the address-size value in an "if"-"then"-"else"
block.
An easy way out would be to restrict address-size to 48-bits for now.

I've ignored "max-frame-size" since the description in
ethernet-controller.yaml claims there is a contradiction in the
Devicetree specification. I suppose it is describing the property
"max-frame-size" with "Specifies maximum packet length ...".

My understanding from the dt-schema README is that network-class.yaml
should live in the dt-schema repository since it describes properties
from the Devicetree specification. How is the synchronization handled in
this case? The motivation for this series is to fix dtbs_check failures
for Apple silicon devices both in the tree and upcoming ones.

Signed-off-by: Janne Grunau <j@jannau.net>
---
Janne Grunau (3):
      dt-bindings: net: Add network-class schema for mac-address properties
      dt-bindings: wireless: bcm4329-fmac: Use network-class.yaml schema
      dt-bindings: wireless: silabs,wfx: Use network-class.yaml

 .../bindings/net/ethernet-controller.yaml          | 18 +---------
 .../devicetree/bindings/net/network-class.yaml     | 40 ++++++++++++++++++++++
 .../bindings/net/wireless/brcm,bcm4329-fmac.yaml   |  5 ++-
 .../bindings/net/wireless/silabs,wfx.yaml          |  5 +--
 4 files changed, 46 insertions(+), 22 deletions(-)
---
base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
change-id: 20230203-dt-bindings-network-class-8367edd679d2

Best regards,
-- 
Janne Grunau <j@jannau.net>

