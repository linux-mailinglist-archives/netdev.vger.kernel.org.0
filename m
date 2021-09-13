Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A655940894B
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 12:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbhIMKpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 06:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238610AbhIMKpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 06:45:19 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534F0C061574;
        Mon, 13 Sep 2021 03:44:04 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id kt8so19968132ejb.13;
        Mon, 13 Sep 2021 03:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+NnCNALJ2/5oW+pu5k0q6dGcKqbC4aKJxWqtF3jB1mU=;
        b=nx3tcWUag5qYGc/gPGaYz3QxxKbVF13ihLPiRQ6uhOuvIrRIzma4NiJVJZG1oT+HEs
         7TTgCkzKbIF1Xo8Cm+RZqzFN8HR7H1f9KCyUucNSd3C2lO13vHQi07DTY34jsi9s5dqV
         DI1xo5SL63Uen6AeWiRXuOHZgR9UVjNYkmX14dr0vTLDdbGKB9o2KYho1z/KKBDFWelT
         iwO94NvEu/gX5kdECyecNfcrOMXbx8Bvn2QRRMMPMg6RIVnDvPRYWibRZ95jqaclrNnL
         CDCXyHCbQRuLDMg5qF9UKW9eyeZ/aIbE+NbrAIiOgRN37Hf0M7DeuaDALgyGAHqrQKdr
         OEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+NnCNALJ2/5oW+pu5k0q6dGcKqbC4aKJxWqtF3jB1mU=;
        b=Ka/1BKuO8UuNxYbvtxQZBhVTF2rjcL0KVQsKL1tC0c4TsihKt6Pdzw6HzWsizXV0Av
         2F9wBTFsEeNSbWarAkp2QaTUn+ZZ0YUOe6FkBNFS9nwAyI543N/6w8QB+mwhegCUGq0L
         YCcBAAffGXmW+GF4AlKuaqplLQ9aXHqEZISceglWSZvHLFnH6oxsYZ4IkOdiQk7ATB8l
         WUDo3v3eU23AZFH+lWN3Gek0Avw99GJAKUoqwUcZcnJyTBh1tBaYbyGx5mYIv/7xVPdV
         xh64fUFj5tVuzQoN+tD6Q6gds3VMTB754038pNbh+FRzj1nuaiDJY3ux+poexsiLJdJz
         yUfQ==
X-Gm-Message-State: AOAM532YtgkFssDKtBWfaIlnOHUYG+v42HgLpRKAlr1UI8Sx3DmK4V68
        1TAu4rqtIpaBhEzXw/E1WfTSIZqiUHs=
X-Google-Smtp-Source: ABdhPJwbL9RssbTf10VUSEYDfwDbh+GwPcuxtpj5sQIQ716/1ZZLd2IaswFumW82iJ2c3S+zyaffqA==
X-Received: by 2002:a17:907:7785:: with SMTP id ky5mr11980891ejc.247.1631529842903;
        Mon, 13 Sep 2021 03:44:02 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id l22sm1874449eds.58.2021.09.13.03.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 03:44:02 -0700 (PDT)
Date:   Mon, 13 Sep 2021 13:44:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <20210913104400.oyib42rfq5x2vc56@skbuf>
References: <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
 <2b316d9f-1249-9008-2901-4ab3128eed81@gmail.com>
 <5b899bb3-ed37-19ae-8856-3dabce534cc6@gmx.de>
 <20210909225457.figd5e5o3yw76mcs@skbuf>
 <35466c02-16da-0305-6d53-1c3bbf326418@gmail.com>
 <YTtG3NbYjUbu4jJE@lunn.ch>
 <20210910145852.4te2zjkchnajb3qw@skbuf>
 <53f2509f-b648-b33d-1542-17a2c9d69966@gmx.de>
 <20210912202913.mu3o5u2l64j7mpwe@skbuf>
 <trinity-e5b95a34-015c-451d-bbfc-83bfb0bdecad-1631529134448@3c-app-gmx-bs55>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-e5b95a34-015c-451d-bbfc-83bfb0bdecad-1631529134448@3c-app-gmx-bs55>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 12:32:14PM +0200, Lino Sanfilippo wrote:
> Hi,
> 
> > Gesendet: Sonntag, 12. September 2021 um 22:29 Uhr
> > Von: "Vladimir Oltean" <olteanv@gmail.com>
> > An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>
> > Cc: "Andrew Lunn" <andrew@lunn.ch>, "Florian Fainelli" <f.fainelli@gmail.com>, "Saravana Kannan" <saravanak@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, p.rosenberger@kunbus.com, woojung.huh@microchip.com, UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
> > Betreff: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
> >
> > On Sun, Sep 12, 2021 at 10:19:24PM +0200, Lino Sanfilippo wrote:
> > >
> > > Hi,
> > >
> > > On 10.09.21 at 16:58, Vladimir Oltean wrote:
> > > > On Fri, Sep 10, 2021 at 01:51:56PM +0200, Andrew Lunn wrote:
> > > >>> It does not really scale but we also don't have that many DSA masters to
> > > >>> support, I believe I can name them all: bcmgenet, stmmac, bcmsysport, enetc,
> > > >>> mv643xx_eth, cpsw, macb.
> > > >>
> > > >> fec, mvneta, mvpp2, i210/igb.
> > > >
> > > > I can probably double that list only with Freescale/NXP Ethernet
> > > > drivers, some of which are not even submitted to mainline. To name some
> > > > mainline drivers: gianfar, dpaa-eth, dpaa2-eth, dpaa2-switch, ucc_geth.
> > > > Also consider that DSA/switchdev drivers can also be DSA masters of
> > > > their own, we have boards doing that too.
> > > >
> > > > Anyway, I've decided to at least try and accept the fact that DSA
> > > > masters will unregister their net_device on shutdown, and attempt to do
> > > > something sane for all DSA switches in that case.
> > > >
> > > > Attached are two patches (they are fairly big so I won't paste them
> > > > inline, and I would like initial feedback before posting them to the
> > > > list).
> > > >
> > > > As mentioned in those patches, the shutdown ordering guarantee is still
> > > > very important, I still have no clue what goes on there, what we need to
> > > > do, etc.
> > > >
> > >
> > > I tested these patches with my 5.10 kernel (based on Gregs 5.10.27 stable
> > > kernel) and while I do not see the message "unregister_netdevice: waiting
> > > for eth0 to become free. Usage count = 2." any more the shutdown/reboot hangs, too.
> > > After a few attempts without any error messages on the console I was able to get a
> > >  stack trace. Something still seems to go wrong in bcm2835_spi_shutdown() (see attachment).
> > > I have not had the time yet to investigate this further (or to test the patches
> > >  with a newer kernel).
> >
> > Could you post the full kernel output? The picture you've posted is
> > truncated and only shows a WARN_ON in rpi_firmware_transaction and is
> > probably a symptom and not the issue (which is above and not shown).
> >
> 
> Unfortunately I dont see anything in the kernel log. The console output is all I get,
> thats why I made the photo.

To clarify, are you saying nothing above this line gets printed? Because
the part of the log you've posted in the picture is pretty much
unworkable:

[   99.375389] [<bf0dc56c>] (bcm2835_spi_shutdown [spi_bcm2835]) from [<c0863ca0>] (platform_drv_shutdown+0x2c/0x30)

How do you access the device's serial console? Use a program with a
scrollback buffer like GNU screen or something.
