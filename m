Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EC850953F
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 05:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiDUDPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 23:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiDUDO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 23:14:59 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E05411C07
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 20:12:11 -0700 (PDT)
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 05E403F1AD
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 03:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1650510730;
        bh=wwu6B8MS2wDUs4lBsnpGSszAj+Chk/M9OpzPrcRqBmk=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=uaasZUq21TkkZS7xSvAjMI7lHjDOi3COHi2LCwXaZdl2VXQu4DvKdvKZpoYAkDdJ9
         NXNQUXofhu+g3DYiblK34HNguheAfXBIeqiA5FXwl1V0Pg0Sq4jYa6+rTUK8MIJ62D
         /tvtWJqAdsEMxA6ZqUYjRlkziupVdibCO6VP1xXG2JpScNw396pPM5ydvnhKKZ9MuP
         1gAM7I96+Od9jwKdvVzEo/JaVao9twfj2wReJnymrowY95V9l0gbBmAVhbDpQqu2eN
         5uFcEoyYNXKyU32eSGA4q7C/aj2bOrnDRHrwppgcAmboAjJz8WbHgha78kBM5rZWwE
         PVZUqfqpSl99A==
Received: by mail-ot1-f70.google.com with SMTP id w10-20020a9d70ca000000b0060565127babso1203366otj.15
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 20:12:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wwu6B8MS2wDUs4lBsnpGSszAj+Chk/M9OpzPrcRqBmk=;
        b=SyDIAtBZi8wjV0LOn/HI5RPo7UCZfJFEz91Lz/zL1roMzsX/cuiRS8XXAidevlU8xg
         bJ+3fnaaqKV3wBc/54EVQRqefxzCyGKPZK5qk+emij84IPsTRukoCecYjideOYTCy3fb
         XsLdfnhP4i3eWnyfVCHb61K40D39+wfhMCjIDuIKyMAH+6z+yr8OHJa+hbshNoCF/qXH
         xQrtDzLqLkHKM+I9ENFHSv1oWqwWjaK0E/U1WgZXsa9tnqLHZfDmxLwCIf6sndhiptf7
         vh1XuV2XRcEXHyla3Ucyvb4QkrakyPmOw3voMtsvVpbXw+e/xtWBOT61dSSJr0AxeCOp
         PSFg==
X-Gm-Message-State: AOAM530l3fSQ6+rGwTJuE/lPo2cD9K2oxWOrenwApMC6IpcS2B734nZG
        09fgWdivrysiorKBRgk8QW4bpkG+sUBv3FDqYqpiIlJP1TLPPPGfqy2HNmfVT8MoRWKP/7GWZZ3
        hO6VEY4WaTlGDY3L4u6sC8DCfdYvB4IADLpBK5BfP89srt678aQ==
X-Received: by 2002:a05:6808:124c:b0:2f9:c7cf:146 with SMTP id o12-20020a056808124c00b002f9c7cf0146mr3183337oiv.54.1650510728859;
        Wed, 20 Apr 2022 20:12:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSmKZq8aKNnAYbiEmYZ9gt56/wHQgKIpbSzAsyF3hgg3Y9+Az3U65ZdpogzViIa4BZLEYDlcdjr8JYTWJuUkM=
X-Received: by 2002:a05:6808:124c:b0:2f9:c7cf:146 with SMTP id
 o12-20020a056808124c00b002f9c7cf0146mr3183325oiv.54.1650510728625; Wed, 20
 Apr 2022 20:12:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
 <20220420124053.853891-5-kai.heng.feng@canonical.com> <YmAgq1pm37Glw2v+@lunn.ch>
In-Reply-To: <YmAgq1pm37Glw2v+@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Thu, 21 Apr 2022 11:11:55 +0800
Message-ID: <CAAd53p6UAhDC2mGkz3_HgVs7kFgCwjfu2R+9FfROhToH2R6CjA@mail.gmail.com>
Subject: Re: [PATCH 4/5] net: phy: marvell: Add LED accessors for Marvell 88E1510
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 11:03 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Apr 20, 2022 at 08:40:51PM +0800, Kai-Heng Feng wrote:
> > Implement get_led_config() and set_led_config() callbacks so phy core
> > can use firmware LED as platform requested.
> >
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> >  drivers/net/phy/marvell.c | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >
> > diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> > index 2702faf7b0f60..c5f13e09b0692 100644
> > --- a/drivers/net/phy/marvell.c
> > +++ b/drivers/net/phy/marvell.c
> > @@ -750,6 +750,30 @@ static int m88e1510_config_aneg(struct phy_device *phydev)
> >       return err;
> >  }
> >
> > +static int marvell_get_led_config(struct phy_device *phydev)
> > +{
> > +     int led;
> > +
> > +     led = phy_read_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL);
> > +     if (led < 0) {
> > +             phydev_warn(phydev, "Fail to get marvell phy LED.\n");
> > +             led = 0;
> > +     }
>
> I've said this multiple times, there are three LED registers, The
> Function Control register, the Priority Control register and the Timer
> control register. It is the combination of all three that defines how
> the LEDs work. You need to save all of them.

OK, will do.

>
> And you need to make your API generic enough that the PHY driver can
> save anywhere from 1 bit to 42 bytes of configuration.

OK, I guess I'll let the implementation stays within driver callback,
so each driver can decide how many bits need to be saved.

>
> I don't know ACPI, but i'm pretty sure this is not the ACPI way of
> doing this. I think you should be defining an ACPI method, which
> phylib can call after initialising the hardware to allow the firmware
> to configure the LED.

This is not feasible.
If BIOS can define a method and restore the LED by itself, it can put
the method inside its S3 method and I don't have to work on this at
the first place.

Kai-Heng

>
>      Andrew
