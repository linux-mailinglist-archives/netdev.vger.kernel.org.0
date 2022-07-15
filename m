Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E16576726
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiGOTJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiGOTJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:09:21 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4AA3DBD2
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 12:09:18 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-31cf1adbf92so55950197b3.4
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 12:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bpg96p9CI9yLaQw3VjuOVFIoT69AC7E3OsyVn7VvpkQ=;
        b=fawt43s9lWKSGEk4xJU0OI7i1mjn821E5ZvRrpLHMKajZfiWvU/QaXMR7zmawKrJsD
         ToIrGV1QMzqRimiwaWZMiIHBttDe3IJFC1VvFLODmZagp7jIq4Ye2CZh+Wvb3Be+TVdx
         k4hmorXYWxsu5HeWyRaRCRxd9/G2xSMI+Gwz3OPlHGChS2FtWWaR7t+t2dmGJWnEdPnI
         n5CvmbVJkgshfYYCRi6niHpx3IAR9wrNEK5EkEoaKGqEE3B+pC7E8EW36aH+LDJUd9tR
         v4xeVx7wqniEscy3iBlGJ83ceqBjdtlslH3hZeEtdl/zsdscb+G9S4UM2R97ux4yRm4s
         MpBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bpg96p9CI9yLaQw3VjuOVFIoT69AC7E3OsyVn7VvpkQ=;
        b=MhvHxWGzZH4wAB6nlqmC2SjS2ydSbz9xRnvfHK0BuzWvt/x61LpkZ3WzlII/n/Zarf
         v9a49DNX7z/2vj8BI5+eH5a4ybcK9d716IvXcq8rbd2sK+we12c9j9Np7iFi3EpoPJA2
         FKLQ9oUpx0QMIx/GOdWIm0YxAHEsVD832pvtllER3LPcc6nKzWMESLrWjk2tZqtfmEyh
         biVCbJOBX4/EE8I/gn3SgHS4V0WtQ8NspeYhtyIVd7DWwbzczM9VcjiEmBYeqHHbe9Us
         exCZhIyKYNouUAuDjvq7UpvyIyQpAshEWoS91Ou2GJZG8THMs94Fu/YXngV4R8hMK1lp
         n4mQ==
X-Gm-Message-State: AJIora8GkqJgTA1eo7CnqY63EfyKkAY0Y3DH1fvEIbKFwOX//E1vo3qC
        2Qa8Z4MWktOE6F0czhIo9VBpdnnQCJgNgq7VEL3m0Q==
X-Google-Smtp-Source: AGRyM1vN2LqHTDjMlYuo3H+Q7AhUL4oobllgeOabaBsvYfExZr1oaQmkTvS6Saay4e+jN/u3yvJyWjfGeKwXxqNWouU=
X-Received: by 2002:a81:17ca:0:b0:31c:9a75:1f2b with SMTP id
 193-20020a8117ca000000b0031c9a751f2bmr18251239ywx.83.1657912157915; Fri, 15
 Jul 2022 12:09:17 -0700 (PDT)
MIME-Version: 1.0
References: <1656618906-29881-1-git-send-email-radhey.shyam.pandey@amd.com>
 <Yr66xEMB/ORr0Xcp@lunn.ch> <MN0PR12MB59531DFD084FA947084D91B6B7819@MN0PR12MB5953.namprd12.prod.outlook.com>
 <CAGETcx_BUR3EPDLgp9v0Uk9N=8BtYRjFyhpJTQa9kEMHtkgdwQ@mail.gmail.com> <MN0PR12MB59539E587A8B46FDC190FB7AB78B9@MN0PR12MB5953.namprd12.prod.outlook.com>
In-Reply-To: <MN0PR12MB59539E587A8B46FDC190FB7AB78B9@MN0PR12MB5953.namprd12.prod.outlook.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 15 Jul 2022 12:08:42 -0700
Message-ID: <CAGETcx9dh1hfqoFSRwNf3fGbH5Wsdhah8RT5R-JrGOS-rDFX3g@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
To:     "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 12:00 PM Pandey, Radhey Shyam
<radhey.shyam.pandey@amd.com> wrote:
>
> > -----Original Message-----
> > From: Saravana Kannan <saravanak@google.com>
> > Sent: Wednesday, July 6, 2022 12:28 AM
> > To: Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> > Cc: Andrew Lunn <andrew@lunn.ch>; nicolas.ferre@microchip.com;
> > claudiu.beznea@microchip.com; davem@davemloft.net;
> > edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> > hkallweit1@gmail.com; linux@armlinux.org.uk;
> > gregkh@linuxfoundation.org; rafael@kernel.org; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; git (AMD-Xilinx) <git@amd.com>
> > Subject: Re: [PATCH net-next v2] net: macb: In shared MDIO usecase make
> > MDIO producer ethernet node to probe first
> >
> > On Tue, Jul 5, 2022 at 11:49 AM Pandey, Radhey Shyam
> > <radhey.shyam.pandey@amd.com> wrote:
> > >
> > > > -----Original Message-----
> > > > From: Andrew Lunn <andrew@lunn.ch>
> > > > Sent: Friday, July 1, 2022 2:44 PM
> > > > To: Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> > > > Cc: nicolas.ferre@microchip.com; claudiu.beznea@microchip.com;
> > > > davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> > > > pabeni@redhat.com; hkallweit1@gmail.com; linux@armlinux.org.uk;
> > > > gregkh@linuxfoundation.org; rafael@kernel.org;
> > saravanak@google.com;
> > > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; git
> > > > (AMD-Xilinx) <git@amd.com>
> > > > Subject: Re: [PATCH net-next v2] net: macb: In shared MDIO usecase
> > > > make MDIO producer ethernet node to probe first
> > > >
> > > > On Fri, Jul 01, 2022 at 01:25:06AM +0530, Radhey Shyam Pandey wrote:
> > > > > In shared MDIO suspend/resume usecase for ex. with MDIO producer
> > > > > (0xff0c0000) eth1 and MDIO consumer(0xff0b0000) eth0 there is a
> > > > > constraint that ethernet interface(ff0c0000) MDIO bus producer has
> > > > > to be resumed before the consumer ethernet interface(ff0b0000).
> > > > >
> > > > > However above constraint is not met when GEM0(ff0b0000) is resumed
> > first.
> > > > > There is phy_error on GEM0 and interface becomes non-functional on
> > > > resume.
> > > > >
> > > > > suspend:
> > > > > [ 46.477795] macb ff0c0000.ethernet eth1: Link is Down [
> > > > > 46.483058] macb ff0c0000.ethernet: gem-ptp-timer ptp clock
> > unregistered.
> > > > > [ 46.490097] macb ff0b0000.ethernet eth0: Link is Down [
> > > > > 46.495298] macb ff0b0000.ethernet: gem-ptp-timer ptp clock
> > unregistered.
> > > > >
> > > > > resume:
> > > > > [ 46.633840] macb ff0b0000.ethernet eth0: configuring for
> > > > > phy/sgmii link mode macb_mdio_read -> pm_runtime_get_sync(GEM1)
> > it
> > > > > return -
> > > > EACCES error.
> > > > >
> > > > > The suspend/resume is dependent on probe order so to fix this
> > > > > dependency ensure that MDIO producer ethernet node is always
> > > > > probed first followed by MDIO consumer ethernet node.
> > > > >
> > > > > During MDIO registration find out if MDIO bus is shared and check
> > > > > if MDIO producer platform node(traverse by 'phy-handle' property)
> > > > > is bound. If not bound then defer the MDIO consumer ethernet node
> > probe.
> > > > > Doing it ensures that in suspend/resume MDIO producer is resumed
> > > > > followed by MDIO consumer ethernet node.
> > > >
> > > > I don't think there is anything specific to MACB here. There are
> > > > Freescale boards which have an MDIO bus shared by two interfaces etc.
> > > >
> > > > Please try to solve this in a generic way, not specific to one MAC
> > > > and MDIO combination.
> > >
> > > Thanks for the review.  I want to get your thoughts on the outline of
> > > the generic solution. Is the current approach fine and we can extend
> > > it for all shared MDIO use cases/ or do we see any limitations?
> > >
> > > a) Figure out if the MDIO bus is shared.  (new binding or reuse
> > > existing)
> > > b) If the MDIO bus is shared based on DT property then figure out if
> > > the MDIO producer platform device is probed. If not, defer MDIO
> > > consumer MDIO bus registration.
> >
> > Radhey,
> >
> > I think Andrew added me because he's pointing you towards fw_devlink.
> >
> > Andrew,
> >
> > I have intentionally not added phy-handle support to fw_devlink because it
> > would also prevent the generic driver from binding/cause issues with DSA. I
> > have some high level ideas on fixing that but haven't gotten around to it yet.
>
> Thanks, just want to understand on implementation when phy-handle support is
> added to fw_devlink. Does it ensure that supplier node is probed first? Or it uses
> device_link framework to specify suspend/resume dependency and don't care
> on consumer/producer probe order.

fw_devlink will enforce probe ordering and suspend/resume ordering.
Btw, fw_devlink uses device links underneath. It just used the
firmware (Eg: DT) to figure out the dependencies. That's why it's
called fw_devlink.

-Saravana
