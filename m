Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDBC2EA12C
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 00:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbhADXzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 18:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbhADXzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 18:55:14 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68724C061574;
        Mon,  4 Jan 2021 15:54:34 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id lt17so39048899ejb.3;
        Mon, 04 Jan 2021 15:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rpMFWg3dBiVyuQeZ+0x91tGNApJ/zf2FvT0VhAtAONY=;
        b=ZW2qDTYTnE+Xi64hpGrA6LFU1zletxO9Rl6g5FjGC1rZ/d/fNF0HZCElhVt7Cxbu03
         2Tzw2UUUaMaWvOvc+0VyNBxTthDnOdEwsB8EL/B9QBH8lUMwtVTKOT0moIJrQsaUEkmj
         /VylBWEZ18ZmDcKRj7eVq6TrRQjW5+Q01Ya45b+U55WVSmjWZlv+x3ATd+FoQKRsgDuq
         JUJ0UesTw3xJNw8Fj8n/79BoIlaKsFv61J8QnIM4jseDGIf1GG5JsETCJzfsrNk3iP7+
         qCuVIGxp/p+fxZVPG5NVWdA+yKC4CVzwFfveUXfxeyY6VO+dBPi7pMFN4B8kifojjITw
         2fAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rpMFWg3dBiVyuQeZ+0x91tGNApJ/zf2FvT0VhAtAONY=;
        b=F63+pX/OJdWySiOq2F1nBZ/jnANs0E/P0K1h/znQulXEEdmLfiZqgo0DGB32f1RNNQ
         V92994e+nsO1Cwom2PvkM2zR0X7Lf7nvubO5IclDKqNUVO5NWY6/x6prTDS15XNuR+Jt
         KubKJhKtqcFbmVKbSK2vzKcgTRCVT6pyWIFz1apJQh6JQTnfoh+JooRjCo6uIlATrIDa
         cwmW2aNb8nKZgfu4/W9sqFyIxW4jWunWm+xcY2BFzSMzgPLtrKDIxLI/PTgXNA5hC8AH
         rm3CYV7xVIu8i5huojUN4PZfwSfbU2D/JrrPjoITqwx2ytpWC0nVbQSRoKf/x6BLgQ1G
         YphQ==
X-Gm-Message-State: AOAM531xARCOFwH8NCmQlK5GAKKkbH93Jj/AQiS5xVOgxSnFv6qISZYk
        tBPWXL2FlIyMqUcUsis5xLP4zc1YApaerANXm6w=
X-Google-Smtp-Source: ABdhPJzwWJNpk9uggE6xpw99d1J2R0jaSsDDsG9FtwKGNKud2V5RlIquguzIqisIVen4jB218yIgtKfJJUwze/Oa5VQ=
X-Received: by 2002:a17:906:4050:: with SMTP id y16mr66519765ejj.537.1609804473217;
 Mon, 04 Jan 2021 15:54:33 -0800 (PST)
MIME-Version: 1.0
References: <20210103012544.3259029-1-martin.blumenstingl@googlemail.com>
 <20210103012544.3259029-2-martin.blumenstingl@googlemail.com>
 <X/EnSv8gyprpOWRr@lunn.ch> <CAFBinCD7cOPZf8NpkhpRG2PiuMcjtqwxu7vQQoXULpCBbTCAoA@mail.gmail.com>
 <20210104135237.064fba8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210104135237.064fba8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 5 Jan 2021 00:54:22 +0100
Message-ID: <CAFBinCBH8Kh8uykGwXad-uMXxt3snhSvQR7ksyUZOPY9tXnbkw@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: dsa: lantiq_gswip: Enable GSWIP_MII_CFG_EN also
 for internal PHYs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Hauke Mehrtens <hauke@hauke-m.de>,
        netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,


On Mon, Jan 4, 2021 at 10:52 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 3 Jan 2021 03:12:21 +0100 Martin Blumenstingl wrote:
> > Hi Andrew,
> >
> > On Sun, Jan 3, 2021 at 3:09 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Sun, Jan 03, 2021 at 02:25:43AM +0100, Martin Blumenstingl wrote:
> > > > Enable GSWIP_MII_CFG_EN also for internal PHYs to make traffic flow.
> > > > Without this the PHY link is detected properly and ethtool statistics
> > > > for TX are increasing but there's no RX traffic coming in.
> > > >
> > > > Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> > > > Cc: stable@vger.kernel.org
> > >
> > > Hi Martin
> > >
> > > No need to Cc: stable. David or Jakub will handle the backport to
> > > stable.  You should however set the subject to [PATCH net 1/2] and
> > > base the patches on the net tree, not net-next.
> > do you recommend re-sending these patches and changing the subject?
> > the lantiq_gswip.c driver is identical in -net and -net-next and so
> > the patch will apply fine in both cases
>
> Resend is pretty much always a safe bet. But since as you said trees
> are identical at the moment I made an exception applied as is :)
awesome, thank you! :-)


Best regards,
Martin
