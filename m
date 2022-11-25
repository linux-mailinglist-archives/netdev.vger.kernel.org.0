Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F89A63909D
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 21:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiKYUUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 15:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiKYUUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 15:20:16 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB3B55ABC;
        Fri, 25 Nov 2022 12:20:15 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id BF1645C0065;
        Fri, 25 Nov 2022 15:20:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 25 Nov 2022 15:20:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1669407614; x=1669494014; bh=lO
        fNHybtknTjw+K3iU0INR/sKAaWBha0aC/eE2fjc4A=; b=qIXgTqGROEliLPq3Gk
        vbkiYULLGQi4/wMiLekhCC9EqrT+qFMUu14ljQffjBiwSBFBmxFPHcKNS2InAtZY
        bKwfuSgOZB/U9Nrr3rAeJ8+mA1FQqJBZpb62U5mLPw8zx4vNdXWsKHyScgjA5Dk3
        JRCkd1+Qg3ywQKpkEXQXLCkg80yX2wT2Opy9wUlCZIiYpdgKIrPpo5iDVTFx0eqW
        r+ounTV6TVri53jTJkjqseu2ZEve48zuV2H375cTBwZqvOeBTbpJa7SOa9HgIfBf
        Z+Eh0WSHzF2a3sCDaMil0rwL9rhYNb9zVQn8NnIZ6IFcK0lZoLdmu8iTABtH9AzV
        9m+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1669407614; x=1669494014; bh=lOfNHybtknTjw
        +K3iU0INR/sKAaWBha0aC/eE2fjc4A=; b=XKKkFCmagehapuhX9kHF3e1BO/xTP
        U13n7WmfBnakSp06JRWgN2U6RgYPJNSbatvI51VbkSLTWMkCIpvfeYebQC+FhDQK
        I1OCYDyBomSAQZwyUWc+vUkMsfw1FqpjL0xIfpfzkOR+IFBCdOzZUPSLyPhxJeh4
        Hw0Gp3BP/WfU6bxHmgd/llHqzBL+f+nT56OermQ0JJ2aeUPhbcyVDJh4/sQu9CPU
        Vr6+Xm1CvMlaxJ5Xq1BNGalK+Dpr0T4x1/rA7nT2mbdIDR/G03zUzikxWeqw/7/X
        Fik9859AxurwXa5k+ENE4AyLtaAssX2pGk0LmPuTeHRg7VGXjm5twvMqQ==
X-ME-Sender: <xms:fiOBY36olIWoaiUYfvIeBcWf_fd4DmZgcZgOVGSqgkuzPMT9MDzYUQ>
    <xme:fiOBY84Ny0_YpN-PmtNVjV2unC0PGe3Ia02JxNM1VDmlyCZdDuXOcNSgIfqhr47dr
    inUV6xx0rP_YnH_kA>
X-ME-Received: <xmr:fiOBY-dMJL3Z2aYCeLn5XlCGAVh1rYI3WgjN9ZUlcn-toS-fp9Yk0uQnpLcB8tDXhsbcdHKMuqfWFZ0BZYy9NSapQ8eV5ZpqWZX8dYShBC_09-FIyVd48YL5Jnh7zwgNSJO64g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrieehgddufeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhu
    vghlucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecugg
    ftrfgrthhtvghrnhepudekteeuudehtdelteevgfduvddvjefhfedulefgudevgeeghefg
    udefiedtveetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepshgrmhhuvghlsehshhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:fiOBY4K0Y6E0VGCUkHkNNOu0qLRYH6OyRVknWTrrfm9gkZECyTxn_Q>
    <xmx:fiOBY7JrvKtROgkHy68CQppiXYjFuuU4wm8bF7g4Thi4HcH41T7Pgw>
    <xmx:fiOBYxxj-oyQFjRiLTbLep_iYR8tv-7N-r2XHBDYC1zzN4WQ8NHh7A>
    <xmx:fiOBY9hZ5lQZ6Uyeq2E6K00I5g97pvueTF25FTiWWcRsbKqSMOJh7w>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Nov 2022 15:20:13 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Samuel Holland <samuel@sholland.org>,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        Maxime Ripard <mripard@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
Subject: [PATCH 3/3] dt-bindings: net: sun8i-emac: Add phy-supply property
Date:   Fri, 25 Nov 2022 14:20:08 -0600
Message-Id: <20221125202008.64595-4-samuel@sholland.org>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221125202008.64595-1-samuel@sholland.org>
References: <20221125202008.64595-1-samuel@sholland.org>
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

This property has always been supported by the Linux driver; see
commit 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i"). In fact, the
original driver submission includes the phy-supply code but no mention
of it in the binding, so the omission appears to be accidental. In
addition, the property is documented in the binding for the previous
hardware generation, allwinner,sun7i-a20-gmac.

Document phy-supply in the binding to fix devicetree validation for the
25+ boards that already use this property.

Fixes: 0441bde003be ("dt-bindings: net-next: Add DT bindings documentation for Allwinner dwmac-sun8i")
Signed-off-by: Samuel Holland <samuel@sholland.org>
---

 .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml     | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
index 34a47922296d..4f671478b288 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
@@ -42,6 +42,9 @@ properties:
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

