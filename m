Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89686598CE1
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244882AbiHRTv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234438AbiHRTv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:51:57 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DC5AB183;
        Thu, 18 Aug 2022 12:51:56 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id kb8so5158327ejc.4;
        Thu, 18 Aug 2022 12:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=hJQEc74fhcb/IA4FjfVIxRsmkNGKKuU8/s6b05HKDVw=;
        b=H3XqHBnTsowEj35kTeZMzczYvTj/qwZKg02AuUot3sIpeFGcR9rytnrUuM8Q4tEO1t
         moQh+s6MpBEYbcErUYZEgIJwtKwax1HsBVI7dNdaeny2Vzv76NvMjgu0gQRSBGU/DCUo
         QMfJqxJz+SQmLPQX3VQMRXWY1KHt0tFiC4D9b2hk2/yvuo0xvXo/WyapelfmX2c2AsEf
         Yn6qZBMtxAqgzBcX00Rq4OGLC+CkXYbD0jS6Efw6FymdFD/NNGUURAPzId0MmD/zX5pI
         Xp1gxWPGdCnsFHo0/TKkN1oH3ndxIlF9EE18uFpPtyCKD4n0AGM4DK263dsrB6gKvuyb
         MyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=hJQEc74fhcb/IA4FjfVIxRsmkNGKKuU8/s6b05HKDVw=;
        b=UE4WwTfN78HqHqG9c0NINw23+gn5D8vu64gDD9z9PC1QM5L5GhEu2k3HhQba0ahggQ
         EAvKEotzK46JruIp1/p8TBOnolNCXlXXxe0XFiesaFRH7xUQafqgb3CXohSkJESyP21L
         Y7ko22X9ElmUuYFU7axuhqKQE/jIN6kEDHAS0ceHjLFZBjp+IskIHa+DQ3bLujj8p/VH
         VNrzUPHiukfvyEP0HYYcuDadQjo029pF0FjGzXHUItCuExwz0IjKSIt8dsrUoDWa2wCy
         g1ljBAXxA9aFLGd4ND/gr8aRQWLZ2DwcMepxt+3qX6Afl6gJ5tmd+PIbzrh3wrJeUEcs
         +vEQ==
X-Gm-Message-State: ACgBeo2onzAnOvYAh0ttHSR2xNtghjidF+oH2fWKam49sARWQ2OQ4j83
        Zw/DlVtvo2GcijP1Vm3/drvPLjk9q14=
X-Google-Smtp-Source: AA6agR7SjEliTbXNOzNZVuLEGKA10UdE5Izsy+pOAEeZo7pC7l5MrZHQBt9tetDeJpgHegsDC6ieCg==
X-Received: by 2002:a17:907:6d12:b0:731:8595:9784 with SMTP id sa18-20020a1709076d1200b0073185959784mr2736646ejc.323.1660852314497;
        Thu, 18 Aug 2022 12:51:54 -0700 (PDT)
Received: from skbuf ([188.25.231.137])
        by smtp.gmail.com with ESMTPSA id jw12-20020a17090776ac00b00730fd9ccf84sm1244751ejc.90.2022.08.18.12.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 12:51:53 -0700 (PDT)
Date:   Thu, 18 Aug 2022 22:51:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/11] net: phy: Add 1000BASE-KX interface mode
Message-ID: <20220818195151.3aeaib54xjdhk3ch@skbuf>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <20220725153730.2604096-3-sean.anderson@seco.com>
 <20220818165303.zzp57kd7wfjyytza@skbuf>
 <8a7ee3c9-3bf9-cfd1-67ab-bb11c1a0c82a@seco.com>
 <35779736-8787-f4cb-4160-4ff35946666d@seco.com>
 <20220818171255.ntfdxasulitkzinx@skbuf>
 <cfe3d910-adee-a3bf-96e2-ce1c10109e58@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfe3d910-adee-a3bf-96e2-ce1c10109e58@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 01:28:19PM -0400, Sean Anderson wrote:
> That's not what's documented:
> 
> > ``PHY_INTERFACE_MODE_10GBASER``
> >     This is the IEEE 802.3 Clause 49 defined 10GBASE-R protocol used with
> >     various different mediums. Please refer to the IEEE standard for a
> >     definition of this.
> > 
> >     Note: 10GBASE-R is just one protocol that can be used with XFI and SFI.
> >     XFI and SFI permit multiple protocols over a single SERDES lane, and
> >     also defines the electrical characteristics of the signals with a host
> >     compliance board plugged into the host XFP/SFP connector. Therefore,
> >     XFI and SFI are not PHY interface types in their own right.
> > 
> > ``PHY_INTERFACE_MODE_10GKR``
> >     This is the IEEE 802.3 Clause 49 defined 10GBASE-R with Clause 73
> >     autonegotiation. Please refer to the IEEE standard for further
> >     information.
> > 
> >     Note: due to legacy usage, some 10GBASE-R usage incorrectly makes
> >     use of this definition.
> 
> so indeed you get a new phy interface mode when you add c73 AN. The
> clarification only applies to *incorrect* usage.

I challenge you to the following thought experiment. Open clause 73 from
IEEE 802.3, and see what is actually exchanged through auto-negotiation.
You'll discover that the *use* of the 10GBase-KR operating mode is
*established* through clause 73 AN (the Technology Ability field).

So what sense does it make to define 10GBase-KR as "10Base-R with clause 73 AN"
as the document you've quoted does? None whatsoever. The K in KR stands
for bacKplane, and typical of this type of PMD are the signaling and
link training procedures described in the previous clause, 72.
Clause 73 AN is not something that is a property of 10GBase-KR, but
something that exists outside of it.

So if clause 73 *establishes* the use of 10GBase-KR (or 1000Base-KX or
others) through autonegotiation, then what sense does it have to put
phy-mode = "1000base-kx" in the device tree? Does it mean "use C73 AN",
or "don't use it, I already know what operating mode I want to use"?

If it means "use C73 AN", then what advertisement do you use for the
Technology Ability field? There's a priority resolution function for
C73, just like there is one for C28/C40 for the twisted pair medium (aka
that thing that allows you to fall back to the highest supported common
link speed). So why would you populate just one bit in Technology
Ability based on DT, if you can potentially support multiple operating
modes? And why would you even create your advertisement based on the
device tree, for that matter? Twisted pair PHYs don't do this.
