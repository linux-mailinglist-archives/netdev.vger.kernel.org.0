Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1D158E1E9
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 23:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiHIVjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 17:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiHIVjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 17:39:18 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43656A4BF
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 14:39:17 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id x10so12537202plb.3
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 14:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=rF4XDG8tyrPGqqZ4RKoed57RUFZZihREpxOFrKxRRu8=;
        b=bDznElEZlD+nIYAKWUNsYImgL+Kl9X8P9LJBS9C+xgjABdJCJ2jNUSxU1sbWSvPicu
         BzuwUjU38COVlBebqdVG79d9DHGIXXaEwuX2dD2+NmrbLvaZWlC9luR0kPe97sHFrVia
         sJpaZzh6y3q5Ns4kpwBTVAERfhSWGCBAexJ01npMHI3GYhYP33BUqYLb3G4yw91IWxIm
         9Ql4i3qrJMdQXUwbIDc3kk8NyYDGAqcxctgn0FH7G5QqISLWRxaOqiiiqv6piKNrwIqH
         W/K2oei6p4IrbU4P8nVG1t9jK8a3IC2eM+sBHMsaJYn83n5OcuyVbrbcmbN1iqDIAHI0
         nZig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=rF4XDG8tyrPGqqZ4RKoed57RUFZZihREpxOFrKxRRu8=;
        b=eaDPcN4mfEurBky4UPJyst92n4+9x269PzGbX87gTKGmXYf9lebF9j7NRgzP79ahtt
         x1DfO/EZhhRFC5Sna4JljCodD1M0s6DaK6vuHnfp8D1TGyCKrvKaB0Ke6zX5LsIqcUyT
         loD88z6P46kCom4RQt7HYZe77bMHFOQJBq3VSSMvF2J4MsLDCQxNMZNo0tb08FPrRClh
         eLDDzj/hLZ9TDYgL0pBNJV9+f3TDMURcKtWf5zqXulpe951LKTn02f5+GyoRu2YcDNtB
         RusAv0/oYUQnV6s+vlSqRKYZT202OwSZwnsJkQJdVepxt5gAssGv2OErH4sv3IN71Zl4
         opXQ==
X-Gm-Message-State: ACgBeo20N4dyuXzWevOcsyRnuuckU3+lvEWHNI0w8KdJdz5A6xgW6fux
        asz9TOxIwQrqmySafpCFaCuV5OnhsuPpLsQYmDqK7Q==
X-Google-Smtp-Source: AA6agR7x8AAt/ed5LntyIcI7abkzB5Of6n0xQWxpLcmXDr8CSY6JQUY7ncFe45xnFzwMzhhMB3SZS3RWQOTf37TDnMY=
X-Received: by 2002:a17:902:694c:b0:16d:cc5a:8485 with SMTP id
 k12-20020a170902694c00b0016dcc5a8485mr25092652plt.90.1660081157352; Tue, 09
 Aug 2022 14:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com> <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local> <20220808214522.GQ17705@kitsune.suse.cz>
 <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com> <20220809213146.m6a3kfex673pjtgq@pali>
In-Reply-To: <20220809213146.m6a3kfex673pjtgq@pali>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 9 Aug 2022 14:39:05 -0700
Message-ID: <CAJ+vNU3bFNRiyhV_w_YWP+sjMTpU28PsX=BTkT7_Q=79=yR1gg@mail.gmail.com>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 9, 2022 at 2:31 PM Pali Roh=C3=A1r <pali@kernel.org> wrote:
>
> On Tuesday 09 August 2022 16:48:23 Sean Anderson wrote:
> > On 8/8/22 5:45 PM, Michal Such=C3=A1nek wrote:
> > > On Mon, Aug 08, 2022 at 02:38:35PM -0700, Stephen Hemminger wrote:
> > >> On Mon, 8 Aug 2022 23:09:45 +0200
> > >> Michal Such=C3=A1nek <msuchanek@suse.de> wrote:
> > >>
> > >> > On Mon, Aug 08, 2022 at 03:57:55PM -0400, Sean Anderson wrote:
> > >> > > Hi Tim,
> > >> > >
> > >> > > On 8/8/22 3:18 PM, Tim Harvey wrote:
> > >> > > > Greetings,
> > >> > > >
> > >> > > > I'm trying to understand if there is any implication of 'ether=
net<n>'
> > >> > > > aliases in Linux such as:
> > >> > > >         aliases {
> > >> > > >                 ethernet0 =3D &eqos;
> > >> > > >                 ethernet1 =3D &fec;
> > >> > > >                 ethernet2 =3D &lan1;
> > >> > > >                 ethernet3 =3D &lan2;
> > >> > > >                 ethernet4 =3D &lan3;
> > >> > > >                 ethernet5 =3D &lan4;
> > >> > > >                 ethernet6 =3D &lan5;
> > >> > > >         };
> > >> > > >
> > >> > > > I know U-Boot boards that use device-tree will use these alias=
es to
> > >> > > > name the devices in U-Boot such that the device with alias 'et=
hernet0'
> > >> > > > becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux =
it
> > >> > > > appears that the naming of network devices that are embedded (=
ie SoC)
> > >> > > > vs enumerated (ie pci/usb) are always based on device registra=
tion
> > >> > > > order which for static drivers depends on Makefile linking ord=
er and
> > >> > > > has nothing to do with device-tree.
> > >> > > >
> > >> > > > Is there currently any way to control network device naming in=
 Linux
> > >> > > > other than udev?
> > >> > >
> > >> > > You can also use systemd-networkd et al. (but that is the same k=
ind of mechanism)
> > >> > >
> > >> > > > Does Linux use the ethernet<n> aliases for anything at all?
> > >> > >
> > >> > > No :l
> > >> >
> > >> > Maybe it's a great opportunity for porting biosdevname to DT based
> > >> > platforms ;-)
> > >>
> > >> Sorry, biosdevname was wrong way to do things.
> > >> Did you look at the internals, it was dumpster diving as root into B=
IOS.
> > >
> > > When it's BIOS what defines the names then you have to read them from
> > > the BIOS. Recently it was updated to use some sysfs file or whatver.
> > > It's not like you would use any of that code with DT, anyway.
> > >
> > >> Systemd-networkd does things in much more supportable manner using e=
xisting
> > >> sysfs API's.
> > >
> > > Which is a dumpster of systemd code, no thanks.
> > >
> > > I want my device naming independent of the init system, especially if
> > > it's systemd.
> >
> > Well, there's always nameif...
> >
> > That said, I have made [1] for people using systemd-networkd.
> >
> > --Sean
> >
> > [1] https://github.com/systemd/systemd/pull/24265
>
> Hello!
>
> In some cases "label" DT property can be used also as interface name.
> For example this property is already used by DSA kernel driver.
>
> I created very simple script which renames all interfaces in system to
> their "label" DT property (if there is any defined).
>
> #!/bin/sh
> for iface in `ls /sys/class/net/`; do
>         for of_node in of_node device/of_node; do
>                 if test -e /sys/class/net/$iface/$of_node/; then
>                         label=3D`cat /sys/class/net/$iface/$of_node/label=
 2>/dev/null`
>                         if test -n "$label" && test "$label" !=3D "$iface=
"; then
>                                 echo "Renaming net interface $iface to $l=
abel..."
>                                 up=3D$((`cat /sys/class/net/$iface/flags =
2>/dev/null || echo 1` & 0x1))
>                                 if test "$up" !=3D "0"; then
>                                         ip link set dev $iface down
>                                 fi
>                                 ip link set dev $iface name "$label" && i=
face=3D$label
>                                 if test "$up" !=3D "0"; then
>                                         ip link set dev $iface up
>                                 fi
>                         fi
>                         break
>                 fi
>         done
> done
>
> Maybe it would be better first to use "label" and then use ethernet alias=
?

I've been wondering the same as well which made me wonder what the
history of the 'aliases' node is and why its not used in most cases in
Linux. I know for the SOC's I work with we've always defined aliases
for ethernet<n>, gpio<n>, serial<n>, spi<n>, i2c<n>, mmc<n> etc. Where
did this practice come from and why are we putting that in Linux dts
files it if it's not used by Linux?

Best Regards,

Tim
