Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2961F65A75B
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 23:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiLaWFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Dec 2022 17:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLaWFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Dec 2022 17:05:50 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4122DFB;
        Sat, 31 Dec 2022 14:05:49 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9BEDF5C00AB;
        Sat, 31 Dec 2022 17:05:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 31 Dec 2022 17:05:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1672524348; x=1672610748; bh=LoY9Qc1RJY42iNhRIwKRgBqok
        CfDwWxod+ozHmfkbdU=; b=yRMbEphJ7Rd2u5M98NWIk9FsQSYx8O593jxWmzSnc
        nTTa+w1X2GYGLW52SrBX9rPlJgJN5JE2upOZ6/HRueX6oBsyHQPpf5vtOqXx0vZO
        UMiuwVVq3H5lg/JiBNizhO76V+hlSDZAwKoaTxjn1uz4qtAoqfC4Es5FVm3SoCvx
        8zmVt8ZJ71RBult4GEWknqrmgHRLxlBWJOJ35ytqpjfH2EXuZ0+u8S6JGiIkHIk2
        qOAg4awjdHD315s7dAlm5u2PFdHtoD6MIgWmbodeScS2x0+v7lJ4mSibFKh/oAyQ
        5muEkyKgiC2PLdXYGuxt9oJ2Rp+Db7bWfUxCZsle6/deQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1672524348; x=1672610748; bh=LoY9Qc1RJY42iNhRIwKRgBqokCfDwWxod+o
        zHmfkbdU=; b=q9gtJ7S41rjwqMuxT5sLT0D72JXB1h5O04VLea6mKOrkom746D2
        9uNqdqwto5wqH0aB9rHP648utOacDVJTLVm2Ou7PXR39n8fjCS13Zrq+2xgveyL/
        xlP8Qnp1sZCHVVrtx2/zVX4j7o+6slVd1aGXmsjAiiCs0WWzrAuukkkIiA9YqWiq
        ARjQ7HLe16jeJSDt5Wzb8YTxOtbgThMa2k6UbLmfQkiBuvMWi0oWBcyyjRFCtIAX
        mS1VpJPO8/oNIY/IL6KSNiBkSM2sTnH1DxlYrmcmZnpkCSRCv72MbR5v6fB6zgJf
        P3RrpCgvKhn5ODFk49qeEGl6UQu1EHY95zg==
X-ME-Sender: <xms:PLKwY_sBG_hIWF9XdXQDvr6zdlJ_aW8ImqWFRYXufc-ZH8mxyUCyLQ>
    <xme:PLKwYwd2oaw9GiE-Ka5Of8Nd1asepuz_Ul2SFp6EJmnyEJ3Wx0-RMu7vf8ULHI1Jw
    A8KgIgv7xhpghfRbg>
X-ME-Received: <xmr:PLKwYyzjnWi_9cAoql0sb4LlgR0-cMNmuc2cQBE2h5mh8rMgqbDEOSvaC5QnJgNPVMVbtRgC7A9oO37DzKyhXAFkcMzz2l0l6cgtFbO7cw4BY7mUD2CcVvOed-Hi_BAk3cAmiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrieekgdduheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepkeevlefhjeeuleeltedvjedvfeefteegleehueejffehgffffeekhefh
    hfekkeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epshgrmhhuvghlsehshhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:PLKwY-Otxj5ndpVF5B0IQIZmjzRJryT3JbNLr5HTlT7rSkLWoJ8D_A>
    <xmx:PLKwY_-_WZ5lZlrFH6gFuJ9bqfTu_1MPvCCi7nQrJyEgo5vfIESIfA>
    <xmx:PLKwY-V1sLC-vPS1TuV7ZhA54rfPDnUikxT-lDOP0aeNAowPq03gdg>
    <xmx:PLKwY3P75Yl3lkpznuJAt2vouDuMAr7pBhfOIqzhIju9WqjxuiHs5A>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 31 Dec 2022 17:05:47 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Samuel Holland <samuel@sholland.org>,
        Rob Herring <robh@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
Subject: [RESEND PATCH net v2] dt-bindings: net: sun8i-emac: Add phy-supply property
Date:   Sat, 31 Dec 2022 16:05:46 -0600
Message-Id: <20221231220546.1188-1-samuel@sholland.org>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This property has always been supported by the Linux driver; see
commit 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i"). In fact, the
original driver submission includes the phy-supply code but no mention
of it in the binding, so the omission appears to be accidental. In
addition, the property is documented in the binding for the previous
hardware generation, allwinner,sun7i-a20-gmac.

Document phy-supply in the binding to fix devicetree validation for the
25+ boards that already use this property.

Fixes: 0441bde003be ("dt-bindings: net-next: Add DT bindings documentation for Allwinner dwmac-sun8i")
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
Resending with "net" explicitly in the subject.

Changes in v2:
 - Drop the rest of the series, which was obsoleted by the dt-schema fix
 - Add Acked-by/Reviewed-by tags

 .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml     | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
index 1432fda3b603..47bc2057e629 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
@@ -40,6 +40,9 @@ properties:
   clock-names:
     const: stmmaceth
 
+  phy-supply:
+    description: PHY regulator
+
   syscon:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
-- 
2.37.4

