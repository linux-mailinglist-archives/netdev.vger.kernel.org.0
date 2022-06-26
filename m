Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7288D55B101
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 12:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbiFZKGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 06:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiFZKGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 06:06:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A434B4AE;
        Sun, 26 Jun 2022 03:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ETSXXR3XzgEhkm6ZhG3jzrQ5JVh23r2tv8xELktbMK0=; b=2VxIh+rLvtGkW1BMXzrLQTbgJh
        b0gPCfkzwwu5a0FknvqBQ2ICpc60iHlAnYvw68oXbqo6ZYV0xRLxBI/lggAVjMvhHutBCgh3cH/oK
        qrkGjqA7YjIK+Hy2sTNd4zD7FvnjAlkxGOZXJ/d5uKKiPeEXy+AI5RalhXZKxbqWBtRk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o5P9W-008Hgp-AH; Sun, 26 Jun 2022 12:06:02 +0200
Date:   Sun, 26 Jun 2022 12:06:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, devicetree@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, gerhard@engleder-embedded.com,
        geert+renesas@glider.be, joel@jms.id.au, stefan.wahren@i2se.com,
        wellslutw@gmail.com, geert@linux-m68k.org, robh+dt@kernel.org,
        d.michailidis@fungible.com, stephen@networkplumber.org,
        l.stelmach@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [net-next 2/2] dt-bindings: net: adin1110: Add docs
Message-ID: <YrgvimyFdPVhL6hF@lunn.ch>
References: <20220624200628.77047-1-alexandru.tachici@analog.com>
 <20220624200628.77047-3-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624200628.77047-3-alexandru.tachici@analog.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +patternProperties:
> +  "^phy@[0-1]$":
> +    description: |
> +      ADIN1100 PHY that is present on the same chip as the MAC.
> +    type: object
> +
> +    properties:
> +      reg:
> +        items:
> +          maximum: 1
> +
> +    allOf:
> +      - if:
> +          properties:
> +            compatible:
> +              contains:
> +                const: adi,adin1110
> +        then:
> +          properties:
> +            compatible:
> +              const: ethernet-phy-id0283.bc91
> +        else:
> +          properties:
> +            compatible:
> +              const: ethernet-phy-id0283.bca1
> +
> +    required:
> +      - compatible
> +      - reg

Why is any of this needed? You register an MDIO bus and then use the
PHY at address 0 or 1. phylib should find the PHY and read its ID
register to load the driver. So i don't think there is anything useful
here.

	Andrew
