Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E9F1E9404
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgE3Vjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729083AbgE3Vjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 17:39:36 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76885C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:39:36 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n24so5604248ejd.0
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=my7oLzM0GjZjt6u+Tl+bU1sfyvzLczH1U6Kx/1OWc38=;
        b=YZJJcLUTjFdvWCTMD57XqA4vazK4fTdCOuCr1XblAajT94o+iw9pKhQxQmw2U3sjVN
         yH9hNvfe0FXsjV9AAvo1u+q7+AHT8NDtmr40Y4Le2doqfbVcAa0fm6W2MpNFDmtRtRNq
         jBLPrLjpY5kXE2Whwg24qtMpHUR1H8VSfjLB9mRSGaymzw98OrQkY4sjyRjbCUYnkdL4
         rdPBBaJRcXmsOLhUG6MmB2HASK7IZiKocqd0OtQTEr99e8viFRwoZ2guONAW4orptLoV
         yyAlMOiVTC94OurdgWZHAaSwMiKdZZSclKyeJivg1txS6iRwA6ALMFhKPylvEiewFDpS
         tVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=my7oLzM0GjZjt6u+Tl+bU1sfyvzLczH1U6Kx/1OWc38=;
        b=GNjgnBxDl4XHUzVHyDl7F4vdZHg8vazUSGnhIaltmsYDsQTNXjfRxnOf0oSUOPHGwp
         kR9+E0sGCR3cvxuk6qrC0Y0NYCKWZ54380/Bi3UQ9P+v9jQm+ddfjUn5+bBB3LetmzNK
         TcnP0t0+a483cTNRXPqYkH1lW1sX3g/hnfTIGGlBMIpMbKTgOs2DrdPxaTVGAReF7yay
         OFzwoKBi5G8bqOE1x+23RgnXX2Ipqj7qOIywvrMzMdIS/JyeKzBRDTWjpPqK8PQuNM9g
         FBOZe2IkSz678tvhFWLP8l5SwSQeWhVNNAZC+FXK2MEpfO6IQ81fhjxh7yM53/uJxq3f
         nnCA==
X-Gm-Message-State: AOAM531i5QPD6oZV7ljipppeAmI/4xqo7W7Ad7K/7+n0cSYml9Mj0p8t
        iG8oKnrNBI/7XuxBejCy7LlZkFEiGmiMpJPp0r4=
X-Google-Smtp-Source: ABdhPJyGV5m5nxNYrKVKr8B0c83mBakz5TOWwELaLtfB1RHJzoxl1Umcen0rr34PnEKeNUQWDfoLLmRSPwgk6ZuJir4=
X-Received: by 2002:a17:906:1d56:: with SMTP id o22mr7464052ejh.406.1590874775204;
 Sat, 30 May 2020 14:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200530115142.707415-1-olteanv@gmail.com> <20200530115142.707415-7-olteanv@gmail.com>
 <3ecbfe12-e4da-238e-b999-36fd91a2de5b@gmail.com>
In-Reply-To: <3ecbfe12-e4da-238e-b999-36fd91a2de5b@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 31 May 2020 00:39:24 +0300
Message-ID: <CA+h21hrHuc+RfS8ud5Fc+Yf-4--yZ7dYcBaCOnX3Tgh5sZ2iEQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 06/13] net: dsa: felix: create a template for
 the DSA tags on xmit
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Sun, 31 May 2020 at 00:31, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/30/2020 4:51 AM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > With this patch we try to kill 2 birds with 1 stone.
> >
> > First of all, some switches that use tag_ocelot.c don't have the exact
> > same bitfield layout for the DSA tags. The destination ports field is
> > different for Seville VSC9953 for example. So the choices are to either
> > duplicate tag_ocelot.c into a new tag_seville.c (sub-optimal) or somehow
> > take into account a supposed ocelot->dest_ports_offset when packing this
> > field into the DSA injection header (again not ideal).
> >
> > Secondly, tag_ocelot.c already needs to memset a 128-bit area to zero
> > and call some packing() functions of dubious performance in the
> > fastpath. And most of the values it needs to pack are pretty much
> > constant (BYPASS=1, SRC_PORT=CPU, DEST=port index). So it would be good
> > if we could improve that.
> >
> > The proposed solution is to allocate a memory area per port at probe
> > time, initialize that with the statically defined bits as per chip
> > hardware revision, and just perform a simpler memcpy in the fastpath.
> >
> > Other alternatives have been analyzed, such as:
> > - Create a separate tag_seville.c: too much code duplication for just 1
> >   bit field difference.
>
> If this is really the only difference, we could have added a device ID
> or something that would allow tag_ocelot.c to differentiate Seville from
> Felix and just have a conditional for using the right definition.
>
> The solution proposed here is okay and scales beyond a single bit field
> difference. Maybe this will open up the door for consolidating the
> various Microchip KSZ tag implementations at some point.
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> --
> Florian

Yes, but with a check for device id in the fast path, the xmit
performance would have been slightly worse, and this way it is
slightly better. Again, not the magnitude is important here (which is
marginal either way), but the sign :)

Thanks,
-Vladimir
