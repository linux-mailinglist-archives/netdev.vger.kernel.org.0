Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8ED397BC9
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 23:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhFAVfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 17:35:54 -0400
Received: from mail-oi1-f177.google.com ([209.85.167.177]:43892 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbhFAVfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 17:35:53 -0400
Received: by mail-oi1-f177.google.com with SMTP id x196so363646oif.10;
        Tue, 01 Jun 2021 14:34:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vCRZODBEDwRSj5Y4MjRIeKum+fRvWUZtlNREx03Eovs=;
        b=EikFpxQuDwzOuLs58Ar1zBh/aA0jYufdhijl7W3Zv1/Q8NSIyj3sY4ZhneHEK5oNOC
         uqBmA87361sMHtk+TPRaogwFgXdkvIHoWJYien+sJYSMpLbRyOucuYy82v1lH3NgajeL
         T2DB9JrDBmRI42fmVxCXWRNbiLxFUWAMuOmY9wwbs5r9VNls/f1wjqyaxtJTX6ljBQWw
         mgi+rOcxEc8Ya716AOzodCf9IplqncQId+RtkEvTof59IF2FnOkQ9vyVKEYD29Ri3jFO
         fwKFIlJPFcYgi7lBuBgUjrBI35XWG732PCHxIc5XRilK2qg1QraG56r+jgNITljL8xPg
         isTA==
X-Gm-Message-State: AOAM533px1yoXsUNpyTGO4IXG/FAEag++Lko8jwhf9m7yzmTCSOg8BJi
        trMsfu4UNQiR+rt9bqzMPYyiFwZ+bw==
X-Google-Smtp-Source: ABdhPJynVMGbHPi+5o+/L1ae1BVEkx3m0bLmHi6nLXdMSWfSNeYbnhXRS0/x2nEI2hm/d6eVUso6WQ==
X-Received: by 2002:aca:c488:: with SMTP id u130mr19477551oif.0.1622583250396;
        Tue, 01 Jun 2021 14:34:10 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id c32sm3897897otu.13.2021.06.01.14.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 14:34:09 -0700 (PDT)
Received: (nullmailer pid 1092629 invoked by uid 1000);
        Tue, 01 Jun 2021 21:34:09 -0000
Date:   Tue, 1 Jun 2021 16:34:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: sja1105: convert to YAML
 schema
Message-ID: <20210601213409.GA1031105@robh.at.kernel.org>
References: <20210531234735.1582031-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531234735.1582031-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 02:47:35AM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The following issues exist with the device-specific sja1105,role-mac and
> sja1105,role-phy:
> 
> (a) the "sja1105" is not a valid vendor prefix and should probably have
>     been "nxp", but
> (b) as per the discussion with Florian here:
>     https://lore.kernel.org/netdev/20210201214515.cx6ivvme2tlquge2@skbuf/
>     more phy-mode values similar to "revmii" can be added which denote
>     that the port is in the role of a PHY (such as "revrmii"), making
>     the sja1105,role-phy redundant. Because there are no upstream users
>     (or any users at all, to my knowledge) of these properties, they
>     could even be removed in a future commit as far as I am concerned.
> (c) when I force-add sja1105,role-phy to a device tree for testing, the
>     patternProperties matching does not work, it results in the following
>     error:
> 
> ethernet-switch@2: ethernet-ports:port@1: 'sja1105,role-phy' does not match any of the regexes: 'pinctrl-[0-9]+'
>         From schema: Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml

I believe that would be from 'additionalProperties: false' under 
"^(ethernet-)?port@[0-9]+$" in dsa.yaml. If additional properties need 
to be allowed, then it needs to be changed to 'true'. But if the 
properties aren't really used, just removing them would be better. But 
maybe there's other DSA users with custom properties.

> 
> But what's even more interesting is that if I remove the
> "additionalProperties: true" that dsa.yaml has, I get even more
> validation errors coming from patternProperties not matching either,
> from spi-controller.yaml:

Why would you do that?

> 
> ethernet-switch@2: 'compatible', 'mdio', 'reg', 'spi-cpol', 'spi-max-frequency' do not match any of the regexes: '^(ethernet-)?ports$', 'pinctrl-[0-9]+'
> 
> So... it is probably broken. Rob Herring says here:
> https://lore.kernel.org/linux-spi/20210324181037.GB3320002@robh.at.kernel.org/
> 
>   I'm aware of the issue, but I don't have a solution for this situation.
>   It's a problem anywhere we have a parent or bus binding defining
>   properties for child nodes. For now, I'd just avoid it in the examples
>   and we'll figure out how to deal with actual dts files later.

That was mainly in reference to vendor specific SPI master properties. 

For 'spi-cpol', that generally shouldn't be needed. A given device 
generally only supports 1 mode and the driver should know that. IOW, it 
can be implied from the compatible. There's of course some exceptions.

For 'spi-max-frequency', just add 'spi-max-frequency: true' (or provide 
some constraints as to what the max is.

Rob
