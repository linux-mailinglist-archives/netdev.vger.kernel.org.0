Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F49B6F0C07
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 20:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244572AbjD0ShK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 14:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243558AbjD0ShJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 14:37:09 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA32E2;
        Thu, 27 Apr 2023 11:37:07 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-b9a6869dd3cso2201891276.2;
        Thu, 27 Apr 2023 11:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682620627; x=1685212627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lFyU6RzzaWKzYQaB6d+4t8LyXp1LdQYNUdPNzYi7/h8=;
        b=HtY/DrgzGk3h4mFu2d6z33PwyHYydkJ+NBB4QlHY2snwb9ss1G8DMKOSNLZYSfMBrf
         L9HrRa7Qi91+ewz4uCqmCXi6PffsNxEgyy27JYm4IaOHWpQO1iFnJ39HPj7ADkgWhgXu
         oO783CuL8Er/66b5OhJW0YrvGmtuekT+MqSgaRTW7JXAz7wWq8YUVAH1Q43yvLQszZnf
         D1dVCT7sFkmekVAl/Jq4Ynk1RUeiK6oMDAqkk81qX2oJO5f0YuuUkuj5x4LhVtaW0r26
         oa+BqOF/W4Hub1s/EKssPZgNx3t1rhfbFZe1tRO3R1ig17jjLn1SrheUS06MwRtb8fWp
         JHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682620627; x=1685212627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lFyU6RzzaWKzYQaB6d+4t8LyXp1LdQYNUdPNzYi7/h8=;
        b=hUUVXK2N9Nu9xmXRNcxsrVmbIMk6xP4ZVYvbVGR53xci3dBKNEesHQ5H5uSF3OroMR
         bfJMaxlkq/jDgU0vS2jjqeKORNa2UJo4j1b7diqFCoU7XQvU/+442SjF+ADBMk1e2lA6
         +UNmKKwIRsN+ydvCXgfH3xwLTY+j/RMbVG5FWV0+GAuPqVfy7kzr+xH/8Mqu0R/aGQB6
         lf9fGKiQtK0MLAVu00FEfrVneODnxqvGoVc8FCbriTOZb6MDfyx1j6R5tV09U602Y9LB
         Y9TQZ2ccLL/0/K9HYWEEoEhlL/X+mCBzN8sPbvkSlDVZvLgb3Nq3MmNZ54kZh3maFWvl
         yvhg==
X-Gm-Message-State: AC+VfDytp8Nj+tXH5yhgXyTEe+ie7AmVbVK3HGT9rJx39cb1hUdRbFtC
        O/aeNxmuzV99AAiuXLU8IxMvE4Noq5I91dVvxKs=
X-Google-Smtp-Source: ACHHUZ5kfpWpgI8QLz6dJm1lPtmJAogFkq7qb2Shv4MtdtAmRW5KuuaGfUGAHEbHc0k1Nb7jmHOxyKxgQj4ClUZRznA=
X-Received: by 2002:a25:4907:0:b0:b92:2a56:bcc5 with SMTP id
 w7-20020a254907000000b00b922a56bcc5mr1589957yba.56.1682620626836; Thu, 27 Apr
 2023 11:37:06 -0700 (PDT)
MIME-Version: 1.0
References: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
 <1682535272-32249-3-git-send-email-justinpopo6@gmail.com> <20230427171625.GA3172205-robh@kernel.org>
In-Reply-To: <20230427171625.GA3172205-robh@kernel.org>
From:   Justin Chen <justinpopo6@gmail.com>
Date:   Thu, 27 Apr 2023 11:36:55 -0700
Message-ID: <CAJx26kUGs7B=v10YEPAP3jPu6FXSBTn0oBhQkfoiGY0E-PvUjA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/6] dt-bindings: net: Brcm ASP 2.0 Ethernet controller
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        bcm-kernel-feedback-list@broadcom.com, justin.chen@broadcom.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 10:16=E2=80=AFAM Rob Herring <robh@kernel.org> wrot=
e:
>
> On Wed, Apr 26, 2023 at 11:54:28AM -0700, Justin Chen wrote:
> > From: Florian Fainelli <f.fainelli@gmail.com>
> >
> > Add a binding document for the Broadcom ASP 2.0 Ethernet
> > controller.
> >
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > Signed-off-by: Justin Chen <justinpopo6@gmail.com>
> > ---
> >  .../devicetree/bindings/net/brcm,asp-v2.0.yaml     | 145 +++++++++++++=
++++++++
> >  1 file changed, 145 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0=
.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml b=
/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> > new file mode 100644
> > index 000000000000..818d91692e6e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> > @@ -0,0 +1,145 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/brcm,asp-v2.0.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Broadcom ASP 2.0 Ethernet controller
> > +
> > +maintainers:
> > +  - Justin Chen <justinpopo6@gmail.com>
> > +  - Florian Fainelli <f.fainelli@gmail.com>
> > +
> > +description: Broadcom Ethernet controller first introduced with 72165
> > +
> > +properties:
> > +  '#address-cells':
> > +    const: 1
> > +  '#size-cells':
> > +    const: 1
> > +
> > +  compatible:
> > +    enum:
> > +      - brcm,asp-v2.0
> > +      - brcm,bcm72165-asp-v2.0
> > +      - brcm,asp-v2.1
> > +      - brcm,bcm74165-asp-v2.1
>
> You have 1 SoC per version, so what's the point of versions? If you have
> more coming, then fine, but I'd expect it to be something like this:
>
> compatible =3D "brcm,bcm74165-asp-v2.1", "brcm,asp-v2.1";
>
> Also, the version in the SoC specific compatible is redundant. Just
> "brcm,bcm74165-asp" is enough.
>
> v2.1 is not compatible with v2.0? What that means is would a client/OS
> that only understands what v2.0 is work with v2.1 h/w? If so, you should
> have fallback compatible.
>
v2.1 is not compatible with v2.0 unfortunately. So no, a client/OS
that only understands v2.0 will not work with v2.1 h/w.

> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  ranges: true
> > +
> > +  interrupts:
> > +    minItems: 1
> > +    items:
> > +      - description: RX/TX interrupt
> > +      - description: Port 0 Wake-on-LAN
> > +      - description: Port 1 Wake-on-LAN
> > +
> > +  clocks:
> > +    maxItems: 1
> > +
> > +  ethernet-ports:
>
> The ethernet-switch.yaml schema doesn't work for you?
>
Technically it is not a switch. But it might work... If we use port to
reference the unimac and reg to reference the ethernet channel. I
rather not though, just cause it is not a switch, so calling it an
ethernet-switch is confusing.

> > +    type: object
> > +    properties:
> > +      '#address-cells':
> > +        const: 1
> > +      '#size-cells':
> > +        const: 0
> > +
> > +    patternProperties:
> > +      "^port@[0-9]+$":
> > +        type: object
> > +
> > +        $ref: ethernet-controller.yaml#
> > +
> > +        properties:
> > +          reg:
> > +            maxItems: 1
> > +            description: Port number
> > +
> > +          channel:
> > +            maxItems: 1
> > +            description: ASP channel number
>
> Not a standard property, so it needs a type and vendor prefix. However,
> what's the difference between channel and port? Can the port numbers
> correspond to the channels?
>
Port refers to the unimac. In our case we currently have a maximum of
2. Channel refers to the ethernet hardware channel proper, in which we
have many. So yes, you can have a port correlate to any channel.

> > +
> > +        required:
> > +          - reg
> > +          - channel
> > +
> > +    additionalProperties: false
> > +
> > +patternProperties:
> > +  "^mdio@[0-9a-f]+$":
> > +    type: object
> > +    $ref: "brcm,unimac-mdio.yaml"
>
> Drop quotes.
>
> > +
> > +    description:
> > +      ASP internal UniMAC MDIO bus
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +  - clocks
> > +  - ranges
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/irq.h>
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +
> > +    ethernet@9c00000 {
> > +        compatible =3D "brcm,asp-v2.0";
> > +        reg =3D <0x9c00000 0x1fff14>;
> > +        interrupts =3D <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
> > +        ranges;
> > +        clocks =3D <&scmi 14>;
> > +        #address-cells =3D <1>;
> > +        #size-cells =3D <1>;
> > +
> > +        mdio@c614 {
> > +            compatible =3D "brcm,asp-v2.0-mdio";
> > +            reg =3D <0xc614 0x8>;
>
> You have 1:1 ranges, is that really what you want? That means 0xc614 is
> an absolute address.
Ack, will fix.

Thanks for the review,
Justin

>
> > +            reg-names =3D "mdio";
> > +            #address-cells =3D <1>;
> > +            #size-cells =3D <0>;
> > +
> > +            phy0: ethernet-phy@1 {
> > +                reg =3D <1>;
> > +            };
> > +       };
> > +
> > +        mdio@ce14 {
> > +            compatible =3D "brcm,asp-v2.0-mdio";
> > +            reg =3D <0xce14 0x8>;
> > +            reg-names =3D "mdio";
> > +            #address-cells =3D <1>;
> > +            #size-cells =3D <0>;
> > +
> > +            phy1: ethernet-phy@1 {
> > +                reg =3D <1>;
> > +            };
> > +        };
> > +
> > +        ethernet-ports {
> > +            #address-cells =3D <1>;
> > +            #size-cells =3D <0>;
> > +
> > +            port@0 {
> > +                reg =3D <0>;
> > +                channel =3D <8>;
> > +                phy-mode =3D "rgmii";
> > +                phy-handle =3D <&phy0>;
> > +            };
> > +
> > +            port@1 {
> > +                reg =3D <1>;
> > +                channel =3D <9>;
> > +                phy-mode =3D "rgmii";
> > +                phy-handle =3D <&phy1>;
> > +            };
> > +        };
> > +    };
> > --
> > 2.7.4
> >
