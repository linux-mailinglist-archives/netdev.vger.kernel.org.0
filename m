Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7FF639095
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 21:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiKYUUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 15:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiKYUUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 15:20:12 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25593554C0;
        Fri, 25 Nov 2022 12:20:12 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 946A15C0065;
        Fri, 25 Nov 2022 15:20:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 25 Nov 2022 15:20:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm2; t=1669407610; x=1669494010; bh=SH21Yn2SJRMLTVtT3dx346JtA
        Jb7CcIUzlp8Ja9h9EI=; b=BKah3F8Ovr6QQ1SkfSXVuvdvdhkeWDbcfgUH9Fn1i
        k7hk+AzbiuXhP+v88R8+RlXewbQXt5Pat4qwTLaddY2SRQVlsPbcr4tVdjSQNuKw
        FU7EFnweQNL3uqqPRO9QaCLYSFf+cjRKdL0gsDV8ij0K+ukeXSRnx2MLwlDIF5y9
        9w+HtziE7LHCRBwCjtDl0xS6jRjo+druGmknOa1xY8A3w8lOA/63j76T4joJyIRd
        KAQR78srjPqpXtrkPDHtm+9ScvwTSxfFoIk16Yl47zauuErWTDIQOW3RJ8jBwABd
        spz9q51kjFS/wHyCIoy3BUn2SJGZfHrOZTqaFK5JxWLGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1669407610; x=1669494010; bh=SH21Yn2SJRMLTVtT3dx346JtAJb7CcIUzlp
        8Ja9h9EI=; b=FYaOC6iMmsjxKF9AbljnfYZzMXlJi6U4AOqZ+l0UIxM1esAWW1O
        KdCUUdx0Rsa7j5lNzrNssycUqRC2k/7DwONdshSZgZRPrt4bGw2ukV8hx1lUgGaM
        msiixEr1mCaQAXVjTx/x/rReKr62O7Yoev+5xwyWJXIRxq6bGMsNVlpYudAZglTy
        AnPZw3R8CCOic9hi9pSbnkDvdBnsk3YUyE09X//LOJ0BtH2WnX1fKzgs8hao2lkY
        1DPtsO3uujmmHHrSG0WBIUsqfNDa5lpEgN4N+HREc0S95PNfBwGgkEDLROYnpYRt
        f/YJLgfVZmwUFGKleDYcdwiSV9d94gCEbOQ==
X-ME-Sender: <xms:eiOBY5OWCMAQMqq2Uv1FsPXJTf59jgpfzn3y7DkqTF6tPIBData1MQ>
    <xme:eiOBY79KagxL3BfN9VqRnmyFFvwm6A1SvDXLwLSqEJy8RrC1qcT0J6O8J6sz41Vr3
    IC5c0n_ez0-mITePQ>
X-ME-Received: <xmr:eiOBY4TF3Ukg8Sb-4pKzJxR0DDViARokjvH3lGARFhjMb9Z5Hw_rBPzC2SXLZjUiozntl26FGY8bbeH3NounZg7MYNWlYVdY2O2NBayjQqi8AmingIOWZd86-jCOn_WYSKixtA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrieehgddufeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepkeevlefhjeeuleeltedvjedvfeefteegleehueejffehgffffeekhefh
    hfekkeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epshgrmhhuvghlsehshhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:eiOBY1sddYWZMcnazNwtwGC0u3rmGRp2BPIwKHOrS4FVxugEPLqFKw>
    <xmx:eiOBYxcGZUEMu7WVyaRkiab0IgRj6d7p_inedIOqhKCjsYkPLX3Www>
    <xmx:eiOBYx3elquxkRuxAB2cPnjuMhl0rbF4gg3bANw0rZH9kdIUYQzs6A>
    <xmx:eiOBY81sqmpkOHHch0KCyEqVLp9Yv7yR4qrdQbg1KKN0PyC3UVo_fg>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Nov 2022 15:20:09 -0500 (EST)
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
Subject: [PATCH 0/3] dt-bindings: net: sunxi: Fix binding validation issues
Date:   Fri, 25 Nov 2022 14:20:05 -0600
Message-Id: <20221125202008.64595-1-samuel@sholland.org>
X-Mailer: git-send-email 2.37.4
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

These patches fix issues found when running `make dtbs_check` on sunxi
boards. I am not 100% sure about the change in the first two patches,
but I think I understand what is happening, and the change has the
desired effect. It fixes errors of the form:

  arch/arm/boot/dts/sun6i-a31s-colorfly-e708-q1.dtb: ethernet@1c30000:
  Unevaluated properties are not allowed ('mdio', 'reset-names',
  'resets', 'snps,fixed-burst', 'snps,force_sf_dma_mode', 'snps,pbl'
  were unexpected)

where all of the listed properties are defined in snps,dwmac.yaml.

The third patch fixes an unrelated omission in the sun8i-emac binding.


Samuel Holland (3):
  dt-bindings: net: sun7i-gmac: Fix snps,dwmac.yaml inheritance
  dt-bindings: net: sun8i-emac: Fix snps,dwmac.yaml inheritance
  dt-bindings: net: sun8i-emac: Add phy-supply property

 .../devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml   | 5 ++---
 .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml  | 6 +++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.37.4

