Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7DC17294D
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 21:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgB0ULQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 15:11:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729767AbgB0ULP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 15:11:15 -0500
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEE36246A8;
        Thu, 27 Feb 2020 20:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582834275;
        bh=/V4ZNPA2xQ5WZrglexcKZ3ryVlngSvod+ozNFnSABns=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ry73YYDUU6a+qu0m24PnHNQMMyTm/Oqisoy1gIbMyQ4S/gXRFk/lX32mG+o0GoGLy
         U/LUPngfIivXkoI3MJgTXxPYwCExt03l0fj7L4mmrLrsGDNIc/p2hWpP0ciio6yRxs
         grtF67saFYGzJ8sJg8k7EsMktmwhX9nWAFAdzIwI=
Received: by mail-qv1-f43.google.com with SMTP id o18so238297qvf.1;
        Thu, 27 Feb 2020 12:11:14 -0800 (PST)
X-Gm-Message-State: APjAAAU/kuIY+3Ka5xphGZ+lSmIUpPYlfufHsb6HLbL+ca7UXJeuow7Y
        l/ebg5lnRjPRHzZo++clT73BNeylxyUH2tiPvg==
X-Google-Smtp-Source: APXvYqw10L9aPY3JHOtOEWA+l413/PApGVC/bA/DbQT+3DNmSeNQPxk/mNpXUrWF2+Y6tEQzIey+4KphOmczloyeAYU=
X-Received: by 2002:a05:6214:11ac:: with SMTP id u12mr659969qvv.85.1582834274034;
 Thu, 27 Feb 2020 12:11:14 -0800 (PST)
MIME-Version: 1.0
References: <20200227095159.GJ25745@shell.armlinux.org.uk> <E1j7FqO-0003sv-Ho@rmk-PC.armlinux.org.uk>
 <CAL_JsqK9SLJKZfGjWu3RCk9Wiof+YdUaMziwOrCw5ZxjMZAq_Q@mail.gmail.com>
 <20200227172608.GO25745@shell.armlinux.org.uk> <20200227173636.GE5245@lunn.ch>
In-Reply-To: <20200227173636.GE5245@lunn.ch>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 27 Feb 2020 14:11:02 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKPR7XpTZ=Sc=0OdD=b64xssE3F=QvpZs_NvQdBkuJLBQ@mail.gmail.com>
Message-ID: <CAL_JsqKPR7XpTZ=Sc=0OdD=b64xssE3F=QvpZs_NvQdBkuJLBQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: add dt bindings for
 marvell10g driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 11:36 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > > +    allOf:
> > > > +      - $ref: /schemas/types.yaml#/definitions/uint16-array
> > > > +      - minItems: 1
> > > > +        maxItems: 4
> > > > +
> > > > +examples:
> > > > +  - |
> > > > +    ethernet-phy@0 {
> > > > +        reg = <0>;
> > >
> > > This needs to be under an 'mdio' node with #address-cells and
> > > #size-cells set correctly.
> >
> > I wish these things were documented somewhere... I'm pretty sure this
> > passed validation when I wrote it.
>
> Documentation/devicetree/bindings/net/mdio.yaml
>
> Rob, is there a way to express the hierarchy between yaml files and
> properties? Can we say that a phy, as defined by ethernet-phy.yaml
> should always be inside an MDIO bus as defined in mdio.yaml?

We can link a child schema into a parent schema, but not the other way
around. So you can do something like this in mdio.yaml:

  "^ethernet-phy@[0-9a-f]+$":
    type: object
    allOf:
      - $ref: ethernet-phy.yaml#

That happens to work in this case since there's a common compatible
string for ethernet phys, but doesn't scale in the general case. Note
that ethernet-phy.yaml would need a couple of changes too. Also, this
should also be expanded to other possible node names like 'switch'.

I've had some thoughts of defining a pseudo property '$parent' or
something to be able to express constraints such as to what bus a
device has to be on. Currently, we rely on the overlap of the bus
schemas checking the bus specific aspects of the bus child nodes. I'm
also not really convinced that putting say an I2C device under a SPI
bus node is a problem we need to check for.


I'm not sure how any of this would help on examples compiling and
validating correctly. In example-schema.yaml, it mentions all the
problems I see: dtc fails, validation fails, bus node requirements,
and include file requirements:

  # Examples are now compiled with dtc and validated against the schemas
  #
  # Examples have a default #address-cells and #size-cells value of 1. This can
  # be overridden or an appropriate parent bus node should be shown (such as on
  # i2c buses).
  #
  # Any includes used have to be explicitly included.

Rob
