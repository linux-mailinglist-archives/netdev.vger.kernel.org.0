Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9085859ED10
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 22:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbiHWUGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 16:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbiHWUFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 16:05:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B9CA1A69;
        Tue, 23 Aug 2022 12:21:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1AD7FCE1F45;
        Tue, 23 Aug 2022 19:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE89C433C1;
        Tue, 23 Aug 2022 19:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661282505;
        bh=CWHh1QZldxjCFIn4PpRMmBZZNRsAzrp5IaIO8wkjMU0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=F807u6tKGb3A2PD960Q0r+zMKGNpvCvK8hXLjq/2FfWAiIr4xneLFywnifJVpk7bj
         lkGFTG0Ar96nzBx0b7TQembfUXYcB7I6JTbMFmAJ8Z1+XrhWS7cXnv+CbZCcaQEwoF
         g2UY9HlZj0Bd0vkQku/Au98ci0AVF9jauHkoDV7+KmhTR0Ujl9NQWQXyDXE4zUF0eo
         rJch8sSmOgSRo1xXKwv/tASe/7SlQeoYwLeCGZXsH+6pTHPpHpWvRvbDUgwNEZ8yl5
         fVS7ylAcqsf1mHJYpG8EBayVTligYvpX+T7c+0h8LGL10K1ga5x5uVtMBDWQtsmxwx
         hZ+x6wWERZpow==
Received: by mail-vs1-f46.google.com with SMTP id o123so15454569vsc.3;
        Tue, 23 Aug 2022 12:21:45 -0700 (PDT)
X-Gm-Message-State: ACgBeo3F6rU/iCqL7OICG/L0i5lrDZvecfF7Kz/aXNjEjp/gjvwXCLMP
        bOjZdhOQjI7enoN0eDgDDVHEqwdqDNgnbp8FBQ==
X-Google-Smtp-Source: AA6agR7D0lfjtErHgbCg12y65obMTagY4QnB6Si+CyOIM5QHjnbVmsY82B7gQtsZkIxcEUgV3k4cdDHVU1zX+9ebpGY=
X-Received: by 2002:a05:6102:292c:b0:390:8bf5:7406 with SMTP id
 cz44-20020a056102292c00b003908bf57406mr1209456vsb.6.1661282504388; Tue, 23
 Aug 2022 12:21:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com> <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local> <20220808214522.GQ17705@kitsune.suse.cz>
 <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com> <20220809213146.m6a3kfex673pjtgq@pali>
 <CAJ+vNU3bFNRiyhV_w_YWP+sjMTpU28PsX=BTkT7_Q=79=yR1gg@mail.gmail.com>
In-Reply-To: <CAJ+vNU3bFNRiyhV_w_YWP+sjMTpU28PsX=BTkT7_Q=79=yR1gg@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 23 Aug 2022 14:21:33 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJMKTHHTh2LTbkycmm5SpORGNOibScE_attkOHU_sB3sw@mail.gmail.com>
Message-ID: <CAL_JsqJMKTHHTh2LTbkycmm5SpORGNOibScE_attkOHU_sB3sw@mail.gmail.com>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 9, 2022 at 4:39 PM Tim Harvey <tharvey@gateworks.com> wrote:
>
> On Tue, Aug 9, 2022 at 2:31 PM Pali Roh=C3=A1r <pali@kernel.org> wrote:
> >
> > On Tuesday 09 August 2022 16:48:23 Sean Anderson wrote:
> > > On 8/8/22 5:45 PM, Michal Such=C3=A1nek wrote:
> > > > On Mon, Aug 08, 2022 at 02:38:35PM -0700, Stephen Hemminger wrote:
> > > >> On Mon, 8 Aug 2022 23:09:45 +0200
> > > >> Michal Such=C3=A1nek <msuchanek@suse.de> wrote:
> > > >>
> > > >> > On Mon, Aug 08, 2022 at 03:57:55PM -0400, Sean Anderson wrote:
> > > >> > > Hi Tim,
> > > >> > >
> > > >> > > On 8/8/22 3:18 PM, Tim Harvey wrote:
> > > >> > > > Greetings,
> > > >> > > >
> > > >> > > > I'm trying to understand if there is any implication of 'eth=
ernet<n>'
> > > >> > > > aliases in Linux such as:
> > > >> > > >         aliases {
> > > >> > > >                 ethernet0 =3D &eqos;
> > > >> > > >                 ethernet1 =3D &fec;
> > > >> > > >                 ethernet2 =3D &lan1;
> > > >> > > >                 ethernet3 =3D &lan2;
> > > >> > > >                 ethernet4 =3D &lan3;
> > > >> > > >                 ethernet5 =3D &lan4;
> > > >> > > >                 ethernet6 =3D &lan5;
> > > >> > > >         };
> > > >> > > >
> > > >> > > > I know U-Boot boards that use device-tree will use these ali=
ases to
> > > >> > > > name the devices in U-Boot such that the device with alias '=
ethernet0'
> > > >> > > > becomes eth0 and alias 'ethernet1' becomes eth1 but for Linu=
x it
> > > >> > > > appears that the naming of network devices that are embedded=
 (ie SoC)
> > > >> > > > vs enumerated (ie pci/usb) are always based on device regist=
ration
> > > >> > > > order which for static drivers depends on Makefile linking o=
rder and
> > > >> > > > has nothing to do with device-tree.
> > > >> > > >
> > > >> > > > Is there currently any way to control network device naming =
in Linux
> > > >> > > > other than udev?

Ah, the topic that will never die.

> > > >> > >
> > > >> > > You can also use systemd-networkd et al. (but that is the same=
 kind of mechanism)
> > > >> > >
> > > >> > > > Does Linux use the ethernet<n> aliases for anything at all?
> > > >> > >
> > > >> > > No :l
> > > >> >
> > > >> > Maybe it's a great opportunity for porting biosdevname to DT bas=
ed
> > > >> > platforms ;-)
> > > >>
> > > >> Sorry, biosdevname was wrong way to do things.
> > > >> Did you look at the internals, it was dumpster diving as root into=
 BIOS.
> > > >
> > > > When it's BIOS what defines the names then you have to read them fr=
om
> > > > the BIOS. Recently it was updated to use some sysfs file or whatver=
.
> > > > It's not like you would use any of that code with DT, anyway.
> > > >
> > > >> Systemd-networkd does things in much more supportable manner using=
 existing
> > > >> sysfs API's.
> > > >
> > > > Which is a dumpster of systemd code, no thanks.
> > > >
> > > > I want my device naming independent of the init system, especially =
if
> > > > it's systemd.
> > >
> > > Well, there's always nameif...
> > >
> > > That said, I have made [1] for people using systemd-networkd.
> > >
> > > --Sean
> > >
> > > [1] https://github.com/systemd/systemd/pull/24265
> >
> > Hello!
> >
> > In some cases "label" DT property can be used also as interface name.
> > For example this property is already used by DSA kernel driver.
> >
> > I created very simple script which renames all interfaces in system to
> > their "label" DT property (if there is any defined).
> >
> > #!/bin/sh
> > for iface in `ls /sys/class/net/`; do
> >         for of_node in of_node device/of_node; do
> >                 if test -e /sys/class/net/$iface/$of_node/; then
> >                         label=3D`cat /sys/class/net/$iface/$of_node/lab=
el 2>/dev/null`
> >                         if test -n "$label" && test "$label" !=3D "$ifa=
ce"; then
> >                                 echo "Renaming net interface $iface to =
$label..."
> >                                 up=3D$((`cat /sys/class/net/$iface/flag=
s 2>/dev/null || echo 1` & 0x1))
> >                                 if test "$up" !=3D "0"; then
> >                                         ip link set dev $iface down
> >                                 fi
> >                                 ip link set dev $iface name "$label" &&=
 iface=3D$label
> >                                 if test "$up" !=3D "0"; then
> >                                         ip link set dev $iface up
> >                                 fi
> >                         fi
> >                         break
> >                 fi
> >         done
> > done
> >
> > Maybe it would be better first to use "label" and then use ethernet ali=
as?
>
> I've been wondering the same as well which made me wonder what the
> history of the 'aliases' node is and why its not used in most cases in
> Linux. I know for the SOC's I work with we've always defined aliases
> for ethernet<n>, gpio<n>, serial<n>, spi<n>, i2c<n>, mmc<n> etc. Where
> did this practice come from and why are we putting that in Linux dts
> files it if it's not used by Linux?

It's not 'Linux dts files', but dts files that happen to be hosted in
the Linux kernel. Many are sync'd to u-boot and other places.

While ethernetN is not used by the kernel, the rest are I think.
Personally, I'd do away with gpio, i2c and spi at least, but that ship
has sailed. Then we have some non-standard ones that crept in from
downstream I think (i.MX is the worst).

'label' is supposed to reflect the sticker on a user accessible
port/connector on device. As long as nothing is looking for particular
values of label, it's okay by me to use.

Rob
