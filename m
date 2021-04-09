Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8F835A04B
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 15:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhDINuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 09:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231402AbhDINuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 09:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F1C661184;
        Fri,  9 Apr 2021 13:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617976195;
        bh=8o2Bt/OdnkU0Any2YvbvhN5VXSpCLXNCewVgojWDjB0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tEhODWo5B3CGcUg0QIjayzKtSQREfa2xGdHS4iMXAHob2c1gH17v5ruox66r4O1iS
         wcD41YpL/LMqyK+Y9KAVleDL5uaKrehIcTgmwNI6I4pG/TxEQFx1IXRkOh6r27+iwG
         ZS0XaosHAST5RM8SDNieRj7GK1SrdsJ4RpRqakdBaDgTtYNWDTjl6VQ3VF8DSH67Co
         MMHx79b/hRwKimp2dNK5fGjEr+os/T4yLXWexgpKh5Q47flOP1xh44gkdoDWrJ9nKT
         f06GpTtYTduaLCIUK4T+3IjQwqk+HUIZbdZG1Q/wAZ1stMEbMuXSWn4KFpRzG8/AGq
         eCM7dqez4nDpg==
Received: by mail-ed1-f46.google.com with SMTP id h10so6617970edt.13;
        Fri, 09 Apr 2021 06:49:55 -0700 (PDT)
X-Gm-Message-State: AOAM532myNxwm8aqVl5Q+zsNZVr+5roE3AHck8QIU6H/NeuBRu3HtdP8
        4o9gUD5lcCJnHI11EDa9NFb8bRRJULECHlYsjQ==
X-Google-Smtp-Source: ABdhPJyHT7LV1ywH5OhBmdDt4Q7HUdl8a/WQ0SSEN0vMmJjh0KUPwTzoqGyithVEJWynOiqzEjUQjbWRG0QBHP2Ka2w=
X-Received: by 2002:a05:6402:84e:: with SMTP id b14mr17935095edz.194.1617976193885;
 Fri, 09 Apr 2021 06:49:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210409090711.27358-1-qiangqing.zhang@nxp.com> <20210409090711.27358-2-qiangqing.zhang@nxp.com>
In-Reply-To: <20210409090711.27358-2-qiangqing.zhang@nxp.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 9 Apr 2021 08:49:41 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKeqvC=vP+SA3i76W5jsCWxzdiNkrmHS0uU=qXUAoVq8Q@mail.gmail.com>
Message-ID: <CAL_JsqKeqvC=vP+SA3i76W5jsCWxzdiNkrmHS0uU=qXUAoVq8Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: add new properties for
 of_get_mac_address from nvmem
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 4:07 AM Joakim Zhang <qiangqing.zhang@nxp.com> wrote:
>
> From: Fugang Duan <fugang.duan@nxp.com>
>
> Currently, of_get_mac_address supports NVMEM, some platforms

What's of_get_mac_address? This is a binding patch. Don't mix Linux
things in it.

> MAC address that read from NVMEM efuse requires to swap bytes
> order, so add new property "nvmem_macaddr_swap" to specify the
> behavior. If the MAC address is valid from NVMEM, add new property
> "nvmem-mac-address" in ethernet node.
>
> Update these two properties in the binding documentation.
>
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  .../bindings/net/ethernet-controller.yaml          | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index e8f04687a3e0..c868c295aabf 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -32,6 +32,15 @@ properties:
>        - minItems: 6
>          maxItems: 6
>
> +  nvmem-mac-address:
> +    allOf:
> +      - $ref: /schemas/types.yaml#definitions/uint8-array
> +      - minItems: 6
> +        maxItems: 6
> +    description:
> +      Specifies the MAC address that was read from nvmem-cells and dynamically
> +      add the property in device node;

Why can't you use local-mac-address or mac-address? Those too can come
from some other source.

> +
>    max-frame-size:
>      $ref: /schemas/types.yaml#/definitions/uint32
>      description:
> @@ -52,6 +61,11 @@ properties:
>    nvmem-cell-names:
>      const: mac-address
>
> +  nvmem_macaddr_swap:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description:
> +      swap bytes order for the 6 bytes of MAC address

So 'nvmem-mac-address' needs to be swapped or it's swapped before
writing? In any case, this belongs in the nvmem provider.

Rob
