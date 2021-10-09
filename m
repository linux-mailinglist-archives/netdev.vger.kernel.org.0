Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F66A427C8F
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhJISQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhJISQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:16:42 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9D3C061570;
        Sat,  9 Oct 2021 11:14:45 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id d9so25279439edh.5;
        Sat, 09 Oct 2021 11:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NB/NbO2pnzp8rCJeSeD4fOtiBWghV++U+S27/Xc8iw0=;
        b=En3bOU2gWXENrRPQgcBG5LZinOcpsx9+nrwow4EU5VR2dUu+mmmq1TiG+srtQxbnO0
         VfiK2cs4QmrNLrcSzL7FwotkFcUOttwll1hSleJ/hvB1vampzEvAfAx1+A9G8iLaBGkf
         U0xCIm7uWS8PBooiRcaWLByRqcEQOvXrv73SCfkT+3SAiBWEyVJb1SIlLQgBQ244J45d
         UrRrKIQMmps/heRmg+NRS9xSDWqQX9FnxdP2eeSbYIbjAEjvaof1w+AMFSEAAvUxJTiY
         IFAMENH3OylatZUP481gI9zwo/WkhumCL2gyQu+6hwiAML66HFeEG9mbQNFWDwO5Yrcw
         ZZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NB/NbO2pnzp8rCJeSeD4fOtiBWghV++U+S27/Xc8iw0=;
        b=nwWQneGdO8rHZ0xFzRmhKxVopHpn4d3Q2XF+CYiT8dSVAqM56uEeyZE0RmCv9BbhN2
         1V021VfiOqMVNW4v1HQu4/hGGbf599vKhbO7GPJFOVbMN/D7pB0RY22Ru8fGhaBx7uLa
         Jz/S6GpQs4PjkBaAKRHjAHr5Zcp+eeClpqACmZhSDyYjo4+Fg3FLFfwvYHhIzJqjCGXH
         Jtw0eFM4/WUJ+Gr9BKPfMy+HChnCklfKxUI1BuOM3Q0LqTHIePLAyTohqZj3Imfr3Lze
         OG++H/r/6UXQ7Tpf9xE1ofgk+2+MVAb2Q71TMJj06tLmL0HE4SOBX2DgqYhZ5mF7dIFl
         wKBw==
X-Gm-Message-State: AOAM530hbkHa/D8bfFw5Tz6szxetD5qwiuTfgKhm/ZfrCX3DRo/dawTn
        GA/p2Sa+JZUIjYbomUBdPxE=
X-Google-Smtp-Source: ABdhPJyL02etfR/VvFSZ7cwwu5dfOCfx2MwDZ3qjoyr9gCSfVVV8xN1PRO0CxRk+8iJVhy4M9yyZGw==
X-Received: by 2002:a17:906:b1d5:: with SMTP id bv21mr13128042ejb.346.1633803283771;
        Sat, 09 Oct 2021 11:14:43 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id h8sm1256257ejj.22.2021.10.09.11.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:14:43 -0700 (PDT)
Date:   Sat, 9 Oct 2021 20:14:40 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 11/15] dt-bindings: net: dsa: qca8k: Document
 qca,sgmii-enable-pll
Message-ID: <YWHcEFKzgjE4Ikj2@Ansuel-xps.localdomain>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-12-ansuelsmth@gmail.com>
 <YWHN1iDSelFQTPUC@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWHN1iDSelFQTPUC@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 07:13:58PM +0200, Andrew Lunn wrote:
> On Fri, Oct 08, 2021 at 02:22:21AM +0200, Ansuel Smith wrote:
> > Document qca,sgmii-enable-pll binding used in the CPU nodes to
> > enable SGMII PLL on MAC config.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > index 208ee5bc1bbb..b9cccb657373 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > @@ -50,6 +50,12 @@ A CPU port node has the following optional node:
> >                            managed entity. See
> >                            Documentation/devicetree/bindings/net/fixed-link.txt
> >                            for details.
> > +- qca,sgmii-enable-pll  : For SGMII CPU port, explicitly enable PLL, TX and RX
> > +                          chain along with Signal Detection.
> > +                          This should NOT be enabled for qca8327.
> 
> So how about -EINVAL for qca8327, and document it is not valid then.
>

I would also add a warning. With all the ported device we found pll
needed only qca8337. I will add the error but also report the reason as
we really don't know if it does exist a qca8327 device that needs pll.
In theory not but who knows.

> > +                          This can be required for qca8337 switch with revision 2.
> 
> Maybe add a warning if enabled with revision < 2? I would not make it
> an error, because there could be devices manufactured with a mixture
> or v1 and v2 silicon. Do you have any idea how wide spread v1 is?
> 

No idea about the revision and can't be recovered from the switch data
print on the chip. Will add a warning and put in the documentation that
we warn when an uncorrect revision is detected.

> > +                          With CPU port set to sgmii and qca8337 it is advised
> > +                          to set this unless a communication problem is observed.
> 
>   Andrew

-- 
	Ansuel
