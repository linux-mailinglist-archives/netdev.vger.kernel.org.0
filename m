Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E104624CA
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhK2W1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbhK2W12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:27:28 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A25C09677A;
        Mon, 29 Nov 2021 14:24:09 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id g14so78262288edb.8;
        Mon, 29 Nov 2021 14:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=pBeD8TbCNfIyFg0zKHw3mdYM3iCSv/V5RtWK8s0vRqw=;
        b=kdWMByyEFV1yrxi/NisnggSA56Ti4FlW0Cmw5AAQebDrtjWf4bxCz2hKZ1pSioMkH9
         GGOR2ST6YH8wmnMVRjNT1fjNSc5SCK+JwX6kOHN4m2NolbS2BSgGTVXs7tLtpVizxWEe
         WVFBwYBEqjGeVtp7ICKAY0TGcAng9HGktmZD+o3nA+uLFvR6D1Rg3RMa6ODYM735xvHo
         AbXYn8APmqGSXjW2jXzXwqXVvZsUqkmSy/lijaukifeQGyfd49Au6kFgoGmhoi3kizF+
         zB/GbNw72egG6xSIc1N4WYQt8ChLauedX6Eku0R+ebtppK2BO24Ub/we2kI6vSWjlXxs
         9Eig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=pBeD8TbCNfIyFg0zKHw3mdYM3iCSv/V5RtWK8s0vRqw=;
        b=w6L4YomUcSIfZQl9S4tjWPYM7q7fFdtEUNKh5b0y2oLWRn+n3ZmzrR6LDAuyxzkqbk
         dIQRNKR0sifLnWgRz9JtbVqXizawDZJysa0bqPhn6U01xROjJB86dIpW8Uyc0QFIJXuK
         kjSy25gJX0lyb5KR3ehd+h2Hmnq0mdSf29Ko8yGGOT1YvnVcX32+b6RN9G48ak6A3LPb
         EukOAs1UyVk1z+QS9O23LSOjLO2LV3WyPWM+P514He+tSrg3DX0aJkpSmyeR8L/7n2eX
         egYpgPYHoNbN004DF7mcUVbQ9ph5/m4buh+o3Qal94gUCXAdlCNIP4vddWo+ePQ37UKS
         +9yA==
X-Gm-Message-State: AOAM532B6azW4iqbWbOC3axPDgLoEong+PWoT6efQMSXh45k1nx7Gr+Z
        3JaBOGwhY8TyWnTbteUBzDqdPrC+G7Y=
X-Google-Smtp-Source: ABdhPJx8rARMCs3Fb/ChqW6L/yUPxhZNlpEft4mbg5aWGu2jZJB6qCUdAAJ0lDhfp9sTvGgJc6Hssg==
X-Received: by 2002:aa7:d748:: with SMTP id a8mr78231302eds.21.1638224648221;
        Mon, 29 Nov 2021 14:24:08 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id a13sm7139626edk.29.2021.11.29.14.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 14:24:07 -0800 (PST)
Message-ID: <61a55307.1c69fb81.313b3.ba2f@mx.google.com>
X-Google-Original-Message-ID: <YaVTA68lS/rXXz3m@Ansuel-xps.>
Date:   Mon, 29 Nov 2021 23:24:03 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: net: dsa: split generic port definition
 from dsa.yaml
References: <20211112165752.1704-1-ansuelsmth@gmail.com>
 <YaVDvuXlU64I8GL+@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaVDvuXlU64I8GL+@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 03:18:54PM -0600, Rob Herring wrote:
> On Fri, Nov 12, 2021 at 05:57:51PM +0100, Ansuel Smith wrote:
> > Some switch may require to add additional binding to the node port.
> > Move DSA generic port definition to a dedicated yaml to permit this.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  .../devicetree/bindings/net/dsa/dsa-port.yaml | 70 +++++++++++++++++++
> >  .../devicetree/bindings/net/dsa/dsa.yaml      | 54 +-------------
> >  2 files changed, 72 insertions(+), 52 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> > new file mode 100644
> > index 000000000000..258df41c9133
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> > @@ -0,0 +1,70 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/dsa/dsa-port.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Ethernet Switch port Device Tree Bindings
> > +
> > +maintainers:
> > +  - Andrew Lunn <andrew@lunn.ch>
> > +  - Florian Fainelli <f.fainelli@gmail.com>
> > +  - Vivien Didelot <vivien.didelot@gmail.com>
> > +
> > +description:
> > +  Ethernet switch port Description
> > +
> > +properties:
> > +  reg:
> > +    description: Port number
> > +
> > +  label:
> > +    description:
> > +      Describes the label associated with this port, which will become
> > +      the netdev name
> > +    $ref: /schemas/types.yaml#/definitions/string
> > +
> > +  link:
> > +    description:
> > +      Should be a list of phandles to other switch's DSA port. This
> > +      port is used as the outgoing port towards the phandle ports. The
> > +      full routing information must be given, not just the one hop
> > +      routes to neighbouring switches
> > +    $ref: /schemas/types.yaml#/definitions/phandle-array
> > +
> > +  ethernet:
> > +    description:
> > +      Should be a phandle to a valid Ethernet device node.  This host
> > +      device is what the switch port is connected to
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +
> > +  dsa-tag-protocol:
> > +    description:
> > +      Instead of the default, the switch will use this tag protocol if
> > +      possible. Useful when a device supports multiple protocols and
> > +      the default is incompatible with the Ethernet device.
> > +    enum:
> > +      - dsa
> > +      - edsa
> > +      - ocelot
> > +      - ocelot-8021q
> > +      - seville
> > +
> > +  phy-handle: true
> > +
> > +  phy-mode: true
> > +
> > +  fixed-link: true
> > +
> > +  mac-address: true
> > +
> > +  sfp: true
> > +
> > +  managed: true
> > +
> > +required:
> > +  - reg
> > +
> > +additionalProperties: true
> > +
> > +...
> > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > index 224cfa45de9a..15ea9ef3def9 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > @@ -46,58 +46,8 @@ patternProperties:
> >          type: object
> >          description: Ethernet switch ports
> >  
> > -        properties:
> > -          reg:
> > -            description: Port number
> > -
> > -          label:
> > -            description:
> > -              Describes the label associated with this port, which will become
> > -              the netdev name
> > -            $ref: /schemas/types.yaml#/definitions/string
> > -
> > -          link:
> > -            description:
> > -              Should be a list of phandles to other switch's DSA port. This
> > -              port is used as the outgoing port towards the phandle ports. The
> > -              full routing information must be given, not just the one hop
> > -              routes to neighbouring switches
> > -            $ref: /schemas/types.yaml#/definitions/phandle-array
> > -
> > -          ethernet:
> > -            description:
> > -              Should be a phandle to a valid Ethernet device node.  This host
> > -              device is what the switch port is connected to
> > -            $ref: /schemas/types.yaml#/definitions/phandle
> > -
> > -          dsa-tag-protocol:
> > -            description:
> > -              Instead of the default, the switch will use this tag protocol if
> > -              possible. Useful when a device supports multiple protocols and
> > -              the default is incompatible with the Ethernet device.
> > -            enum:
> > -              - dsa
> > -              - edsa
> > -              - ocelot
> > -              - ocelot-8021q
> > -              - seville
> > -
> > -          phy-handle: true
> > -
> > -          phy-mode: true
> > -
> > -          fixed-link: true
> > -
> > -          mac-address: true
> > -
> > -          sfp: true
> > -
> > -          managed: true
> > -
> > -        required:
> > -          - reg
> > -
> > -        additionalProperties: false
> > +        allOf:
> > +          - $ref: dsa-port.yaml#
> 
> Don't need 'allOf' here. And you need to add 'unevaluatedProperties: 
> false'. With that,
> 
> Reviewed-by: Rob Herring <robh@kernel.org>
> 
> (This needs to go in net-next to avoid conflicts, but given the 
> maintainers didn't apply it already unreviewed they probably expect I 
> will apply it.)

If you want I can push a v2 with the net-next tag.

-- 
	Ansuel
