Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4740A565FC5
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 01:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiGDXxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 19:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGDXxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 19:53:21 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031AFA19B;
        Mon,  4 Jul 2022 16:53:18 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 8CF495C0058;
        Mon,  4 Jul 2022 19:53:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 04 Jul 2022 19:53:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1656978796; x=
        1657065196; bh=hRtV2tmxTGHWgaE1iVcT0zpQrqZDg6gyLKB2wVgW0vo=; b=T
        vhe3/lISntp8F4XP10zGlS+kat7MmJH/hcrB1wPhiXE2yPbUq3AUBkplSOAAzYKu
        OAKNvFBynSC0pnA1X4KBFVc/Q+g9SU80G+bolLDkBslrWSd/TkBiZMwedh/wiUMk
        sYttwA3KodMA+mgu2GNkgvNPxyf5q9c7s2ufaT1uk4DtLREkxL/ZZ4DaOMT/Vkvz
        frev+0D9JTxhhfL+towmLTOTQ2g2urWbTjtvgVU0RD43AW8shxIubjEy1zZbP6Ic
        QFdGUTIaKejzyoUbwUAYDVbJXyiPg6zLhuSPEnarJK6D64CxR3zHDn9TEsECEJ87
        gtAK2lYaAoJQlJcEnSjBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1656978796; x=
        1657065196; bh=hRtV2tmxTGHWgaE1iVcT0zpQrqZDg6gyLKB2wVgW0vo=; b=j
        X610wJ0G2bO43nBljf1hmO06Mn4aR3fOwFPm99EJzjr34y8T4/S/YtIhvGFQxL/i
        jP6i6EvYgwPL7Vl0LL4RkG2o7Ib6o412GO0ZidVeDu1rsDtOAu1tU/3bSsmcDYmC
        C+mMW6I9hJVtJE52k1JXDEyjovJMKwdaaYME354ktbOvin0JF0B+vRqF5UN/6buN
        pYCsyxlLbLqiLwSk/+2Eu+eEDHSErVwFw87qZ2LT7t/G7yTq3JAsA9F+zrDoSc8h
        pNrUo3O4v6kkIzKy6y8fuMqnuCq0tWNRqBjHHMrll6s+CbCUqUZvN8zApXWQE8yY
        4j1fvpowiL85gzAy3f89w==
X-ME-Sender: <xms:bH3DYqD0bLia9ca-mTcv-wDabTy0hD7sTEWuqCtoQ77MG_03wU-Kkw>
    <xme:bH3DYkgEovVE12p5tHBhDKhlPxERzkQg5zUymkaDQYrGjmS0RsLhMBUvJAya40XUn
    rEbERk6hZtVoQctkw>
X-ME-Received: <xmr:bH3DYtnalH8DVwiEKcU0jL_tnEA52T-1R17_NxQszlVPwem_8wIn3IJfZnC1y1dR2O_LWrQyqfVDbKumU_mW-GoRXvfkw-Nr6gkxlKxTIxrPkk1U8p6eXEFHTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeitddgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepuffvvehfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghm
    uhgvlhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenuc
    ggtffrrghtthgvrhhnpefftdevkedvgeekueeutefgteffieelvedukeeuhfehledvhfei
    tdehudfhudehhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhg
X-ME-Proxy: <xmx:bH3DYoyQ70HyDHpizunZF_V6yfKDZuOVes9evuJwjTuH6dLfY1u5ew>
    <xmx:bH3DYvQXMjRtHUzHU_--LXfFvDRkqonl3FGFmnblCSXUgEu9KamYPQ>
    <xmx:bH3DYjYHsGhSQLWcu9XUe0bmr5x1KbB7FZ-tyN42-jlNzHQTdl0k6g>
    <xmx:bH3DYtC3M8W4qfl0raLoFOPsTYKch2tTcY4HA_op_db5-nWCMGFw8Q>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Jul 2022 19:53:15 -0400 (EDT)
Subject: Re: [PATCH v12 1/7] dt-bindings: arm: sunxi: Add H616 EMAC compatible
To:     Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <20220701112453.2310722-1-andre.przywara@arm.com>
 <20220701112453.2310722-2-andre.przywara@arm.com>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <b2661412-5fce-a20d-c7c4-6df58efdb930@sholland.org>
Date:   Mon, 4 Jul 2022 18:53:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20220701112453.2310722-2-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/22 6:24 AM, Andre Przywara wrote:
> The Allwinner H616 contains an "EMAC" Ethernet MAC compatible to the A64
> version.
> 
> Add it to the list of compatible strings.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml       | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> index 6a4831fd3616c..87f1306831cc9 100644
> --- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> +++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> @@ -22,6 +22,7 @@ properties:
>            - enum:
>                - allwinner,sun20i-d1-emac
>                - allwinner,sun50i-h6-emac
> +              - allwinner,sun50i-h616-emac

The H616 manual has register fields for an internal PHY, like H3. Are these not
hooked up for either EMAC?

Regards,
Samuel

>            - const: allwinner,sun50i-a64-emac
>  
>    reg:
> 

