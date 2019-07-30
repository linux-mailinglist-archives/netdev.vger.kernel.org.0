Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99BF279D8B
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 02:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbfG3Ari (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 20:47:38 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:45989 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728845AbfG3Ari (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 20:47:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id D3E0419F0;
        Mon, 29 Jul 2019 20:47:36 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute4.internal (MEProxy); Mon, 29 Jul 2019 20:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm3; bh=eUppwzne5DrVof21J5/gklNPyLRad5M
        JnS92CT4MQOE=; b=Z+4FES9iZq1wf2GBvACLZOc8FlD2Ry8UqaydVs/XfE+JfS6
        glicnxZYi8fePwRUzXQclQ98Yy1n/t2gPumBGaYmTtzjdDQzjp7SpM7EQfjR3+ly
        7bw1TLwcCET0wWieAEyZaw/GNvjCPJ/yXyjvEFpeKF6NK0JV7g1PSnOVA1ou3Cmj
        0rW0lIbSfqhPXAp1PZApFDtQ4Cnm4CBH6Fzdih1GDY6i9plrpa1IhQ2fVQyKQkSm
        RVqYGHwqeyXFuxH0FoLDp4A9BxcbyfddKcRC3n6BDSfaafmzq+zk8ri0MdwmH7AM
        H7Ana0pmzF1Oid8QQ2c6/xMrdFlT4bEE2fZHksA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eUppwz
        ne5DrVof21J5/gklNPyLRad5MJnS92CT4MQOE=; b=dnRyJRVysc2TF41LsiKd5S
        9Eb4WiB0ID8ucuIpmdGU1FCf+ci0FzLmnOULTDWELW2VjtlIu4MyzNvjoPm8sgNM
        8djVrb6ZTw9/oUymjNTD2PdJl9uE2zOQtlITkMQqHC2IwgJtUk2WqjlLqREkikYn
        gEVHok7Wy6r/UoweHEMhLjGcQaAfR591Gwc6fDgDndP2h4ZntSyGfs8eH9B+fd4i
        KR4VjnO9cYeH42tS3EaVuU1PfQNUUaxllGFEvFw19dk/B/LjQ8lnegIH7z61kBQx
        wSHcrHDYSfORvB2jpJtPZfd4/kgT1nviraXUz/gc+9DYzA+cBUoHLkDSSr/djq4Q
        ==
X-ME-Sender: <xms:p5M_XYeeyupD3J5_5KWldWAV-qiI5dVjhBqwRrkdR_ASWHwBSboCtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledvgdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedftehnughr
    vgifucflvghffhgvrhihfdcuoegrnhgurhgvfiesrghjrdhiugdrrghuqeenucffohhmrg
    hinhepuggvvhhitggvthhrvggvrdhorhhgpdihrghmlhdrshhonecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegrnhgurhgvfiesrghjrdhiugdrrghunecuvehluhhsthgvrhfuihiivg
    eptd
X-ME-Proxy: <xmx:p5M_XWiTqOaYUTqA1PGLB65cdzifr64QqVXJWLQCSuM0n07EJIH7Xw>
    <xmx:p5M_XbLVC3idbXEsHfXft6bBExbJ5wmEqjxXf2AU6AEja0QF3VrMZA>
    <xmx:p5M_XbGnZGT_rbDW28gpoiQDJbWYgUeX0ILwBR6I1HQrDbMHJovh3g>
    <xmx:qJM_XUeFCUMGKDa2bmdah8Qx6-RmcGHZASrFWU_GKCEjBmWHneFx8A>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E72F8E00A2; Mon, 29 Jul 2019 20:47:34 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.6-736-gdfb8e44-fmstable-20190718v2
Mime-Version: 1.0
Message-Id: <097bdf8e-4409-4c23-8c4c-d50e16d952dc@www.fastmail.com>
In-Reply-To: <CAL_JsqLytwfsoyS6TSnpPgTjRTOR0TeQwroX21AHqj3A1mPJ5Q@mail.gmail.com>
References: <20190729043926.32679-1-andrew@aj.id.au>
 <20190729043926.32679-2-andrew@aj.id.au>
 <CAL_JsqLytwfsoyS6TSnpPgTjRTOR0TeQwroX21AHqj3A1mPJ5Q@mail.gmail.com>
Date:   Tue, 30 Jul 2019 10:17:54 +0930
From:   "Andrew Jeffery" <andrew@aj.id.au>
To:     "Rob Herring" <robh+dt@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David Miller" <davem@davemloft.net>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Joel Stanley" <joel@jms.id.au>, "Andrew Lunn" <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        devicetree@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-aspeed@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] dt-bindings: net: Add aspeed,ast2600-mdio binding
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Tue, 30 Jul 2019, at 09:07, Rob Herring wrote:
> On Sun, Jul 28, 2019 at 10:39 PM Andrew Jeffery <andrew@aj.id.au> wrote:
> >
> > The AST2600 splits out the MDIO bus controller from the MAC into its own
> > IP block and rearranges the register layout. Add a new binding to
> > describe the new hardware.
> >
> > Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
> > ---
> >  .../bindings/net/aspeed,ast2600-mdio.yaml     | 61 +++++++++++++++++++
> >  1 file changed, 61 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> > new file mode 100644
> > index 000000000000..fa86f6438473
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> > @@ -0,0 +1,61 @@
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/aspeed,ast2600-mdio.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: ASPEED AST2600 MDIO Controller
> > +
> > +maintainers:
> > +  - Andrew Jeffery <andrew@aj.id.au>
> > +
> > +description: |+
> > +  The ASPEED AST2600 MDIO controller is the third iteration of ASPEED's MDIO
> > +  bus register interface, this time also separating out the controller from the
> > +  MAC.
> > +
> 
> Should have a:
> 
> allOf:
>   - $ref: "mdio.yaml#"

Ack.

> 
> > +properties:
> > +  compatible:
> > +    const: aspeed,ast2600-mdio
> > +  reg:
> > +    maxItems: 1
> > +    description: The register range of the MDIO controller instance
> 
> > +  "#address-cells":
> > +    const: 1
> > +  "#size-cells":
> > +    const: 0
> 
> Then you can drop these 2.

Great.

> 
> > +
> > +patternProperties:
> > +  "^ethernet-phy@[a-f0-9]$":
> > +    properties:
> > +      reg:
> > +        description:
> > +          The MDIO bus index of the PHY
> 
> And this.
> 
> > +      compatible:
> > +        enum:
> > +          - ethernet-phy-ieee802.3-c22
> > +          - ethernet-phy-ieee802.3-c45
> 
> This isn't specific to ASpeed either and is already covered by
> ethernet-phy.yaml.
> 
> So that means none of the child node schema is needed here.

Bah, I'd developed the patches on v5.2 while waiting for v5.3-rc1 to come
out.

> 
> > +    required:
> > +      - reg
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - "#address-cells"
> > +  - "#size-cells"
> > +
> > +examples:
> > +  - |
> > +    mdio0: mdio@1e650000 {
> > +            compatible = "aspeed,ast2600-mdio";
> > +            reg = <0x1e650000 0x8>;
> > +            #address-cells = <1>;
> > +            #size-cells = <0>;
> > +
> > +            status = "okay";
> 
> Don't show status in examples.

Sorry, copy/paste at fault.

Thanks for the feedback.

Andrew

> 
> > +
> > +            ethphy0: ethernet-phy@0 {
> > +                    compatible = "ethernet-phy-ieee802.3-c22";
> > +                    reg = <0>;
> > +            };
> > +    };
> > --
> > 2.20.1
> >
>
