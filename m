Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C201416CCE
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244365AbhIXH3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:29:34 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:39801 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244332AbhIXH3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 03:29:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 12D74580F3B;
        Fri, 24 Sep 2021 03:28:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 24 Sep 2021 03:28:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=LrL/waN/SgT3V
        TwhPg9YFJlylmLY/yInMq39GRXzfHc=; b=wRl6gTgNdkkpkmljMq/il/PsUjN8J
        F9L30b/ZftTb196XabAL62VYxMlU7cnFe/JbrWXY6im4mvNGAKGv0d9Ysr7Ma1BU
        l31xAf6XYk6NgyPRWThuWGPjkPA5K6g1RFoTAv6gYiH5B21f/loGje6BCDxziRO2
        WlSl7eCrAn1nmA8TgylNo5vjyXJs136VOlwFs8AGJFVnesVruSp3CcEbbkN4qwN6
        YGEr4k21YV7YcS9YscEs8PjMQmM28A7HT/m4jEeo3BAfvDrurMWTUUyHkHcS4M7r
        RhNnC9/5mW2ECnT9z4WVV2P2AcCSoVvnk48lHYg+Gt7io+h5IVwO9hOQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=LrL/waN/SgT3VTwhPg9YFJlylmLY/yInMq39GRXzfHc=; b=OEfUBfx5
        x18QXXK0ib45TBQQvQbkyKXrQNVGAFPFbjZjzqJl6jS2JbQKSQkg04cF7XuCfz6n
        yrzRIaK4zZ69ZPew2e5v2jEuzmmRtUiAX1DxFVIF8SMMFWEcnF7MjxPt4iSBSmzR
        tLw91q86q7jLT+0pvMRzrfwA8uWdQe+MRxOfPKhUzLFlWLkw+mLVw99+QuRCwCUI
        4BAJsJogXMKW2/bweL0r/YYjbRdfseZQA2naFCii2nxMEuIzAbkD59m59mO8z+Id
        JCw0DksESaSUaM1+MyvyKiQGh68kmLHXjKMqtFbXKy02nV67jZtt0VxAscFu36eX
        uVvPHp7VkdZlhg==
X-ME-Sender: <xms:_31NYdTCtglCHHb6G9DE_aHaXijw1-HIQ-7G-RNfj3XsOhz83d98YQ>
    <xme:_31NYWyIQRGQaAda1YHDLBHl3n2JS2pnyNR43tBcrfWk7vYJgL4fWSKe2rT-81SYN
    fVU698lP3m71d1AoCY>
X-ME-Received: <xmr:_31NYS12aJx8sr3OwSWeSn13e_MIiTB8iXZAp_AKOvCbdR1aSFhoP6i-3lhz37Pf8DjuDas7mg3tEBEJEqpUu1cq3zthOOtG3OSl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudejtddguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepofgrgihi
    mhgvucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrg
    htthgvrhhnpedvkeelveefffekjefhffeuleetleefudeifeehuddugffghffhffehveev
    heehvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:_31NYVArBq-MD-V0QXJ_baI-vJvzFr0e5eSlz48i82VbP4xbZbgQNA>
    <xmx:_31NYWgVjpqsOSojoezSXd6Zz_RP8A_FzBcUgpovQJcJAaqD9Nxhew>
    <xmx:_31NYZopgeIx0V3mc4d24r88H0mRW_RqqwM1pcgKe38n_q5Qbz7LIg>
    <xmx:AH5NYXba8fxRsq37LICaHcUD4vbmep3p0nI1iwgMkXp2E6VqIUGyYg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Sep 2021 03:27:59 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-sunxi@lists.linux.dev,
        Alistair Francis <alistair@alistair23.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [RESEND v2 2/4] dt-bindings: bluetooth: realtek: Add missing max-speed
Date:   Fri, 24 Sep 2021 09:27:54 +0200
Message-Id: <20210924072756.869731-2-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924072756.869731-1-maxime@cerno.tech>
References: <20210924072756.869731-1-maxime@cerno.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

additionalProperties prevent any property not explicitly defined in the
binding to be used. Yet, some serial properties like max-speed are valid
and validated through the serial/serial.yaml binding.

Even though the ideal solution would be to use unevaluatedProperties
instead, it's not pratical due to the way the bus bindings have been
described. Let's add max-speed to remove the warning.

Cc: Alistair Francis <alistair@alistair23.me>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Vasily Khoruzhick <anarsoul@gmail.com>
Reviewed-by: Alistair Francis <alistair@alistair23.me>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
---
 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
index 0634e69dd9a6..157d606bf9cb 100644
--- a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
@@ -34,6 +34,8 @@ properties:
     maxItems: 1
     description: GPIO specifier, used to wakeup the host processor
 
+  max-speed: true
+
 required:
   - compatible
 
-- 
2.31.1

