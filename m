Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7060957F91D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 07:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiGYFvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 01:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGYFvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 01:51:06 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35332DC1;
        Sun, 24 Jul 2022 22:51:02 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4F6275C0092;
        Mon, 25 Jul 2022 01:51:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 25 Jul 2022 01:51:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1658728262; x=1658814662; bh=69zKIkJkrsurUh1tsYk3dVN3W
        f+GthColtIIHhnoVFs=; b=Jd2BhkQLuYEXV0dbJW09eooHfpL/3DTknKNft6aW8
        /UoH9TF5FwzdRxntrJ4eq0jBybQMro1Xp7xYFDwExhKaF2eVIVv2Y5dh9W9A4/rD
        CGphoewDJ+mSpz0S+TqOH6ptObLPHKp4OSplOaZOLmyi47Tw+WUiYAp5w6ZPxT9u
        3Uj2+ahuPhV+O3kyDvpXQFy1r/deso4M78Wls+4A3KcfbNE1LCQTKto96/mYcIT9
        Dm/qFp5mWYLDbuIef456VixJaVU0cvODaJa/ppYvrarJ+Z5wntJAvElEcCQd+QZZ
        7akM3ZzkFITI7iTdFMUwyu+DWnBnWtQT769J13+iMOEUA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1658728262; x=1658814662; bh=69zKIkJkrsurUh1tsYk3dVN3Wf+GthColtI
        IHhnoVFs=; b=Wk6sJDgBtmqRlExCsXsgznTMJCsHD0VBzH5mvl79QIaCmcj2dUu
        nOZleopxLVZkCq8qRELUYGbbmULaxPGtAUiIkTWOkUp93Kn0M1DJCXWiZ4pG/wmN
        nFH7Og/uH0O3C8TR8Jd49/IurERzBKh39x5HdInqsoA6PDEWxY4tj34dWp3gbm1l
        g3gkwtOWZQi6OrxEUFr1x9goZ3KNbTEa5PcvkkbD+Xv3zOkeewkQ+vySqjz51WSw
        gSqAr61cFihUQNsvoV7Dh0gYJQQLD/DhNz7WfUzPUDaStiUnvd3l5sqIOIyVzS8g
        1viZB9ocREVN18cnmKvmdHJVKxyXvFpTQmw==
X-ME-Sender: <xms:RS_eYoVkzjUt_GHFdQPdAyZtrcMUrAahpX2A47MKXGH6eG3fPwLLVw>
    <xme:RS_eYslmwp9AzAA5CPirsSltbtRgVD3XoILvYpBWHpAMcyX_rSJUL_aSIfIG2QJun
    cu93oAFCLeo2gePFA>
X-ME-Received: <xmr:RS_eYsaxyrRMHdr3H-uLrqlnrAZhP4c9pRK_T2GYgiJ7HwdIhOtUudiJ6RGaEg61ja0Eg-rJkKdXu_rXjlN4yVM13GlmH_x_c8cbQAY3wB73N_sU5ARL4T6yLhzXIvqmlYgm1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddtjedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpeekveelhfejueelleetvdejvdeffeetgeelheeujeffhefgffefkeeh
    hffhkeekgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhg
X-ME-Proxy: <xmx:RS_eYnUBcfFBXn3abAB6imnMMuNEMlR3Sc97t95_A0IaQZ0diWsSYw>
    <xmx:RS_eYimBjF5mM9jnGzLODa5MSGQa3Ls4c54CP5NmN6fEz-F6YZGxrw>
    <xmx:RS_eYsdwkJ47XWrnCSWmZqbbXaQqvpiVmqBuF87DW5GnpS5Sf9OvQw>
    <xmx:Ri_eYn83IMOQALPn13Oluk9lAzyQVS0YfVOWgMeRmF71ZxTTcOzcGQ>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 Jul 2022 01:51:00 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-bluetooth@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>,
        Alistair Francis <alistair@alistair23.me>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] dt-bindings: net: bluetooth: realtek: Add RTL8723DS
Date:   Mon, 25 Jul 2022 00:50:59 -0500
Message-Id: <20220725055059.57498-1-samuel@sholland.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8723DS is another version of the RTL8723 WiFi + Bluetooth chip. It is
already supported by the hci_uart/btrtl driver. Document the compatible.

Signed-off-by: Samuel Holland <samuel@sholland.org>
---

 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
index 157d606bf9cb..8ac633b7e917 100644
--- a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
@@ -20,6 +20,7 @@ properties:
     enum:
       - realtek,rtl8723bs-bt
       - realtek,rtl8723cs-bt
+      - realtek,rtl8723ds-bt
       - realtek,rtl8822cs-bt
 
   device-wake-gpios:
-- 
2.35.1

