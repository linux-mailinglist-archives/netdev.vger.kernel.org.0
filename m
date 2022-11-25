Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D3863830C
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 05:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiKYEKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 23:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiKYEKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 23:10:00 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF10A21E01;
        Thu, 24 Nov 2022 20:09:58 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4BA125C0091;
        Thu, 24 Nov 2022 23:09:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 24 Nov 2022 23:09:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm2; t=1669349398; x=1669435798; bh=D3Ya00IOWjUA1ivuUsjZGbNXc
        ZeyrlBHGNEb6dsajtE=; b=UXdwXGKAF1tggqSoC9xdc8x9EFnrS2kqK6Dndv8Dw
        oshbPm9LyEJLctobNy8qnyMhYQGI3iS3CtHRKPODavPOHXZI20zf+7+Z33c5qmR9
        7cIJwMCvpgy0eaFbqLDombMR3qnFCquvESic0bHG1YbmveeKI2/zdUyL7mHh7xKd
        57GpaibRDfxebwtZmPabNaafW8DT3Ynit5mnlyC4Ynysj+OoL90LcmF3D+ozy19u
        VjK+s2jmUp8YWXZUJ5vxAY5fmVZOI2gFR7fqd+tliUwBo3aj7dlTH+SfUDneZ3WZ
        YC3yH1kbk+ZZMeZWwgYFll7wWMIhR0nEqKx9Neb3Gl3jA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1669349398; x=1669435798; bh=D3Ya00IOWjUA1ivuUsjZGbNXcZeyrlBHGNE
        b6dsajtE=; b=gktYQczL23IV9BHSpfkZ0yd+HIKORKwM4ZyR+MU4uIoLLwvTgZr
        Eu2/rOtuK06tnJsMWSm3iSihg40d8BxpgHy9cFl1YhhrHjciwrtwD6LhXIdxM1lv
        BvB/GTpzUv6TwYWcxyp3E1o31Ql/Ozcz0VWN8NG9e1IkXOMeVSYS2MOsHGzCWYyp
        gUNZQahDazMNRExHavef2f7wrxLC/fr9ugqr8iaBfqgbe9cA9EQxALHBRlXjv0lK
        sPN7JDzA3RgRtiFSZJ2FEOw0ePH8469InPoMfLbkHf8clQrtNRP/YhLKgEdHLFzH
        uj9Jy4m4L+XCuN7PzS88H/aiNbQ06oMSbaQ==
X-ME-Sender: <xms:FUCAY13E_sL18ztmSwfGt5to5aUZ9AKUqemsQqQWbRBXcZi3bI_cVw>
    <xme:FUCAY8FFl97ldpYB-iW8Qzw7u6nz9e0iX8wLdWf7MxOINV_AgZ37T41AuRaxNm1Pc
    CFlqsceE9HR9vxiTA>
X-ME-Received: <xmr:FUCAY15xYFJBpsHw6FT8k3BzTV_6l_iFg6kQ9DiNdyU_FSLxj5hKpG8lYzRTkPg3mprfgSzYzG2T_Oe2CBufJTW61Si6b3WoZdpZlc2ov-a_zSO6XLrhW9x1hQKH4UlS5d5Qlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrieeggdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgvlhcu
    jfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtffrrg
    htthgvrhhnpeekveelhfejueelleetvdejvdeffeetgeelheeujeffhefgffefkeehhffh
    keekgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hsrghmuhgvlhesshhhohhllhgrnhgurdhorhhg
X-ME-Proxy: <xmx:FUCAYy0ldgTP84TT3G4FrKUKIXeHqI7DlFNT1nFn1DuRxxN4E66WeQ>
    <xmx:FUCAY4EGdJPckBPvcKZXy44NwgAGpkPa7OVoHFvTnK01_8dWA7ubUw>
    <xmx:FUCAYz9HEWTVG3osiZwzKOsG8UQ1Jhv6QaVytjsnMMK1RBZeWyEL6A>
    <xmx:FkCAY-H4XAD0nGfOwU3Z97ttnxHPEWZ9TvswaupLlsCl-P3_uKmbcg>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Nov 2022 23:09:57 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Holland <samuel@sholland.org>,
        Rob Herring <robh@kernel.org>,
        Alistair Francis <alistair@alistair23.me>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2] dt-bindings: net: realtek-bluetooth: Add RTL8723DS
Date:   Thu, 24 Nov 2022 22:09:56 -0600
Message-Id: <20221125040956.18648-1-samuel@sholland.org>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8723DS is another variant of the RTL8723 WiFi + Bluetooth chip. It is
already supported by the hci_uart/btrtl driver. Document the compatible.

Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Alistair Francis <alistair@alistair23.me>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---

Changes in v2:
 - Adjust patch title
 - Collect Acked-by/Reviewed-by

 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
index e329ef06e10f..143b5667abad 100644
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
2.37.4

