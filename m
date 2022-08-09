Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C104558E1D3
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 23:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiHIVgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 17:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiHIVgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 17:36:07 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4436565E
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 14:36:05 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 73so12527314pgb.9
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 14:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=btK9ujXz2UFmMeaamNi6iHGGSOFJ8Sflo726PZh9VVg=;
        b=gnoYoVogxaolmIygqXn8KQQIy7MPINiYj8E4pW0CSks/p40eGScdiF4hxo0ELnbE/q
         ILWmQ2D2bVfUqTJWux49JDS+A1wFWU2oneUym41hAqqNpCuqUbkmsySMxQiLo5KoJQXT
         Onpj5JXeF+Qje8xsn3xcHlNQnlx7G01RzWhNWnb1f4lDh7tgWjjBZKzpHBD+2dj2qTLu
         AO7WlXcIrmuFDn0gbEHY4rPlOoSDdoZXrHz4yv7/UDRN5sA+6jkYH+KgzuHQZPy9bfFg
         93yctPxTMaF8UZqyAzapbM5eFC4D0RWpXTlPVb2edcjiV7ZtJ2+FrX8TQAMMtgFeaWeV
         71Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=btK9ujXz2UFmMeaamNi6iHGGSOFJ8Sflo726PZh9VVg=;
        b=CKsBLGP82EyxOTm/MwVlErdUQeIz5OUNj8t3KAKRwWkubYnxGFD75T7E3lAbbveON/
         3dMgQ/3pQUDEQ9PU2MKEBg9GDxmesteQqoEB8k+ITZYg3QAO4dF27vDzl/Z8nGqlqYY9
         SEC8hCl7AJREBmZMztQ4P5ZtAuc6MFteG9W4nS28eQmujxmkrHmK6RfIQ/GXhRhG6VqV
         xGtYKxAAbQACAu64dY+7CttESsyxqg8k3+ifRfvIOoCmDnExqhlDLsmFGgg5EIPkWBz/
         bj3uOB0DCTSxav7QZhw+U9NFUQxgTWmU7TcEWGu6K6AxSbBUFGaglIcqK+yd5RZyOxOS
         75nQ==
X-Gm-Message-State: ACgBeo3c+3yCa6khiUJ4YKAEtnLfwQJvUTYhMpG3QaEdvtu1Z+PGpxgn
        xp1H+LfEofi3eLJebkx4J5xxKpPynOqpjJqIORI3hQqX//M=
X-Google-Smtp-Source: AA6agR6cyBOe/1Helo81awA3n1vcSRcrnVq0UgAImSuhd6yoXmhjRrKanqCfXd6R1xnzoJ8Wgf8J2KtBoZBR8ZyMddk=
X-Received: by 2002:a63:fd0b:0:b0:415:f76b:a2cd with SMTP id
 d11-20020a63fd0b000000b00415f76ba2cdmr20431258pgh.440.1660080965098; Tue, 09
 Aug 2022 14:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com> <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local> <20220808214522.GQ17705@kitsune.suse.cz>
 <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
In-Reply-To: <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 9 Aug 2022 14:35:53 -0700
Message-ID: <CAJ+vNU2KwKYiTbPvsSufrjVsHw0JVfQRog__HZZ8qb+gG0HehA@mail.gmail.com>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>,
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

On Tue, Aug 9, 2022 at 1:48 PM Sean Anderson <sean.anderson@seco.com> wrote=
:
>
>
>
> On 8/8/22 5:45 PM, Michal Such=C3=A1nek wrote:
> > On Mon, Aug 08, 2022 at 02:38:35PM -0700, Stephen Hemminger wrote:
> >> On Mon, 8 Aug 2022 23:09:45 +0200
> >> Michal Such=C3=A1nek <msuchanek@suse.de> wrote:
> >>
> >> > On Mon, Aug 08, 2022 at 03:57:55PM -0400, Sean Anderson wrote:
> >> > > Hi Tim,
> >> > >
> >> > > On 8/8/22 3:18 PM, Tim Harvey wrote:
> >> > > > Greetings,
> >> > > >
> >> > > > I'm trying to understand if there is any implication of 'etherne=
t<n>'
> >> > > > aliases in Linux such as:
> >> > > >         aliases {
> >> > > >                 ethernet0 =3D &eqos;
> >> > > >                 ethernet1 =3D &fec;
> >> > > >                 ethernet2 =3D &lan1;
> >> > > >                 ethernet3 =3D &lan2;
> >> > > >                 ethernet4 =3D &lan3;
> >> > > >                 ethernet5 =3D &lan4;
> >> > > >                 ethernet6 =3D &lan5;
> >> > > >         };
> >> > > >
> >> > > > I know U-Boot boards that use device-tree will use these aliases=
 to
> >> > > > name the devices in U-Boot such that the device with alias 'ethe=
rnet0'
> >> > > > becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux it
> >> > > > appears that the naming of network devices that are embedded (ie=
 SoC)
> >> > > > vs enumerated (ie pci/usb) are always based on device registrati=
on
> >> > > > order which for static drivers depends on Makefile linking order=
 and
> >> > > > has nothing to do with device-tree.
> >> > > >
> >> > > > Is there currently any way to control network device naming in L=
inux
> >> > > > other than udev?
> >> > >
> >> > > You can also use systemd-networkd et al. (but that is the same kin=
d of mechanism)
> >> > >
> >> > > > Does Linux use the ethernet<n> aliases for anything at all?
> >> > >
> >> > > No :l
> >> >
> >> > Maybe it's a great opportunity for porting biosdevname to DT based
> >> > platforms ;-)
> >>
> >> Sorry, biosdevname was wrong way to do things.
> >> Did you look at the internals, it was dumpster diving as root into BIO=
S.
> >
> > When it's BIOS what defines the names then you have to read them from
> > the BIOS. Recently it was updated to use some sysfs file or whatver.
> > It's not like you would use any of that code with DT, anyway.
> >
> >> Systemd-networkd does things in much more supportable manner using exi=
sting
> >> sysfs API's.
> >
> > Which is a dumpster of systemd code, no thanks.
> >
> > I want my device naming independent of the init system, especially if
> > it's systemd.
>
> Well, there's always nameif...
>
> That said, I have made [1] for people using systemd-networkd.
>
> --Sean
>
> [1] https://github.com/systemd/systemd/pull/24265

Sean,

That looks very promising. Linux is definitely flipping eth0/eth1
between fec/eqos for me when booting an Ubuntu rootfs telling me that
the netdev registration between those two drivers is racy.

Can you give me an example udev rule that shows how to invoke the new
naming scheme your adding here?

Best Regards,

Tim
