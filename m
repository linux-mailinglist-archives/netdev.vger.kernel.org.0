Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36884FB0F3
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 02:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbiDKASO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 20:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbiDKASM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 20:18:12 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EDB1704D;
        Sun, 10 Apr 2022 17:16:00 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0BE0B5C0170;
        Sun, 10 Apr 2022 20:15:57 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute3.internal (MEProxy); Sun, 10 Apr 2022 20:15:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=dXHAm3z4tHh0Mh9DCwiFQXs0dDzLplgovQi8uT
        MwfCo=; b=S8vxj8OPWf6SGtbLLFubtaYn6pEuq8jgI7De51ASehkIYH1X2DOqav
        35x+Qq63Pi0USpZQw3+Mj/fSrQ+suiiQ6Xye+Byr4zHqj2Aoxr4LJWrW3u1ywHHt
        k3jzV0S73f1CCL/my5YXrpOPr6iXGde6bNXzfT/GvNavkCc/WQmXXN3bAsgnua9v
        aBYJ4pxmL2muJiPtyVDoQVijIbZL99J/4bsoEDdZN5/X3a/FG4+xRUhoxhc+zz9n
        w2vrFSVO5g/JvNPQqALOQ+OfDIg7QmYu+4f+HrCdfb2BWFtAdszxuUattwRbCCcO
        72to41T1GN/TACfEZ1FHII3fB7dUIqYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dXHAm3z4tHh0Mh9DC
        wiFQXs0dDzLplgovQi8uTMwfCo=; b=eL9SkB6aSP3VvVWAtHSve0LtgDqy6guq+
        cq+unj2ZcoE7JdAziBx33SMlBgt5vO0btc332b4W+jftz9ptEsT63vtZ2dKn1Sln
        T+g5h5b84vq2OtONLN7OUF9RsDZvSuTUaL49Gt8+OyON+p70mOn/e5pKk+w6SPjb
        ZvLaux6HLb6pnvmbFzywZzKWYZz1oMh/6z5qCtO2hc8zVB8CtkiqhFaRt5WEPC6f
        QlOoVkIEHFyHRcQCvSPyI0GlebHcrALseV0QZ5bOuhTlEdQEj2v2QzKEUKICL8HD
        lZ3T3VDK/1x4yQwzUwF7mr3DNR3AFE8SADu1r3olZem+Q5YHerhMQ==
X-ME-Sender: <xms:PHNTYjXvumB48-XHUf8RktCZ7hW5IjC2Vk5YPwHCrPpM7rXEKdNJuQ>
    <xme:PHNTYrmTU-VkCTgLO9Of22i01BV25VTo-rfKVIh9tTif0qzsTbV1jsP9dvaaHgfHn
    MGU4z6FJ4xGeDELkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekhedgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdetnhgu
    rhgvficulfgvfhhfvghrhidfuceorghnughrvgifsegrjhdrihgurdgruheqnecuggftrf
    grthhtvghrnhephefhfeekgfekudevheffheeihedujeefjeevjeefudfgfeeutdeuvdeh
    hfevueffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvgifsegrjhdrihgurdgruh
X-ME-Proxy: <xmx:PHNTYvZzOk_XZqRSL1dq7pl9EiVDKF3NXhGIfuf_vYHDleBDU7ez6w>
    <xmx:PHNTYuXPvb_FyNPv_X2NFeZXfz0L3js9LLFEYQGq_mnLXHRWZ1p7bA>
    <xmx:PHNTYtkG-aWJApj1Q8aGUtJM9YaqI04HgA497iwTRQfmVs-ocVBrfA>
    <xmx:PXNTYi_0nkeCzyYbQid88OAoZh7YIm9qjOhjgsvMflq4_epZm4s_-w>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 040DF15A005F; Sun, 10 Apr 2022 20:15:55 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-386-g4174665229-fm-20220406.001-g41746652
Mime-Version: 1.0
Message-Id: <41242dce-15e6-471e-bb44-bf8659175045@www.fastmail.com>
In-Reply-To: <20220407075734.19644-2-dylan_hung@aspeedtech.com>
References: <20220407075734.19644-1-dylan_hung@aspeedtech.com>
 <20220407075734.19644-2-dylan_hung@aspeedtech.com>
Date:   Mon, 11 Apr 2022 09:45:23 +0930
From:   "Andrew Jeffery" <andrew@aj.id.au>
To:     "Dylan Hung" <dylan_hung@aspeedtech.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Joel Stanley" <joel@jms.id.au>, "Andrew Lunn" <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "Russell King" <linux@armlinux.org.uk>,
        "David Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, pabeni@redhat.com,
        "Philipp Zabel" <p.zabel@pengutronix.de>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Cc:     BMC-SW@aspeedtech.com, "Krzysztof Kozlowski" <krzk@kernel.org>
Subject: Re: [PATCH RESEND v3 1/3] dt-bindings: net: add reset property for aspeed,
 ast2600-mdio binding
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dylan,

On Thu, 7 Apr 2022, at 17:27, Dylan Hung wrote:
> The AST2600 MDIO bus controller has a reset control bit and must be
> deasserted before manipulating the MDIO controller. By default, the
> hardware asserts the reset so the driver only need to deassert it.
>
> Regarding to the old DT blobs which don't have reset property in them,
> the reset deassertion is usually done by the bootloader so the reset
> property is optional to work with them.
>
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  .../devicetree/bindings/net/aspeed,ast2600-mdio.yaml         | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git 
> a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml 
> b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> index 1c88820cbcdf..7f43b4fe86a3 100644
> --- a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> @@ -20,10 +20,14 @@ allOf:
>  properties:
>    compatible:
>      const: aspeed,ast2600-mdio
> +
>    reg:
>      maxItems: 1
>      description: The register range of the MDIO controller instance
> 
> +  resets:
> +    maxItems: 1
> +
>  required:
>    - compatible
>    - reg
> @@ -39,6 +43,7 @@ examples:
>              reg = <0x1e650000 0x8>;
>              #address-cells = <1>;
>              #size-cells = <0>;
> +            resets = <&syscon 35>;

This is just the example but we should probably have it do the 
canonical thing and use ASPEED_RESET_MII from 
include/dt-bindings/clock/ast2600-clock.h

Andrew
