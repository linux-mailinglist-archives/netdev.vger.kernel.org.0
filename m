Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CB558CFCC
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 23:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244513AbiHHVij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 17:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244313AbiHHVii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 17:38:38 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A2D1149
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 14:38:37 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id f30so8801948pfq.4
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 14:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zz8kiYSatQgY9tT99NzUrQ7DcijbybOWLRkr13aOxuk=;
        b=KTRhzP+wvhVd45fwQMOikTFddkItYjQCwJ35FXIUt5/J2uxwy9ffmg2gXeiU12IqWI
         9Jt4K3dgnrUFEr7sQjlvtdm/3reBLRNoiBHaA0PlZ5VCX98HbU+TTTZangvFMKn4KyQU
         Ya56eaJ+Tg5BzfmlqTYUEYPGsaewj0hEEhqzVHw4ZiI1Iql4U1DKrfnYNl4E70ebdqFu
         +LPtBo33/VRXzh1NFuxZA2ZOqTon0hH/ieVzegWbufdQiDQjBLF+hdpHSvtK+ZYaismp
         6i9fuSJ0mugfIj13cB32Dc5cZq1695/NSdjv8+2j+8KjEfsAdjfJnosp1n27H+vwQ3by
         ftoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zz8kiYSatQgY9tT99NzUrQ7DcijbybOWLRkr13aOxuk=;
        b=V6A5jdaZzEg1LJJeKjzBdCyjYCuRSQcu+OVsWNNrVyciEoL0vzrtw8BIZzhT3g0mtu
         IgRFeYv2WzlQHwMADC/G8hJ4Vq5kii/FzELqwbVAeckFwygfUlVV4L0FK35nzSUKAOFC
         abLXIml1aMI+0tbiY/KJEnPYpBvidoybm9kFhL6/MBreG6UVOoPFam84SuYXXnvqhdkI
         /L09FOIqhcoRXKjLZruOZEFX/Uc6gVPbsmU9nHapB0JWjU5BXwxDbK1JeDX92s5lWkGC
         J5vhN6er7rLQEJ2MtFkFuZvEvAeDBzIzbxNW73OERN/I1n2jTmEFniFut3bwfNgYMasA
         dYOg==
X-Gm-Message-State: ACgBeo3D/mtQmYk/gRPyBLvnyHv2M9pbBr7Vhep9jyJX0V4zX5t8yOS2
        hC+CcdupOi+1mzDmCGP7Am/GVICpfu6xzQ==
X-Google-Smtp-Source: AA6agR7kOibBeEJB2eheY9mMxYDLmXrv07UCg+re6gr7A0DGnuucCoP4OdcRsLWtjp1hAE4kpnQmag==
X-Received: by 2002:a63:d703:0:b0:41a:8d7a:eb3d with SMTP id d3-20020a63d703000000b0041a8d7aeb3dmr17650667pgg.59.1659994717317;
        Mon, 08 Aug 2022 14:38:37 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a170903230700b0016bdc98730bsm9352942plh.151.2022.08.08.14.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 14:38:37 -0700 (PDT)
Date:   Mon, 8 Aug 2022 14:38:35 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
Message-ID: <20220808143835.41b38971@hermes.local>
In-Reply-To: <20220808210945.GP17705@kitsune.suse.cz>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
        <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
        <20220808210945.GP17705@kitsune.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Aug 2022 23:09:45 +0200
Michal Such=C3=A1nek <msuchanek@suse.de> wrote:

> On Mon, Aug 08, 2022 at 03:57:55PM -0400, Sean Anderson wrote:
> > Hi Tim,
> >=20
> > On 8/8/22 3:18 PM, Tim Harvey wrote: =20
> > > Greetings,
> > >=20
> > > I'm trying to understand if there is any implication of 'ethernet<n>'
> > > aliases in Linux such as:
> > >         aliases {
> > >                 ethernet0 =3D &eqos;
> > >                 ethernet1 =3D &fec;
> > >                 ethernet2 =3D &lan1;
> > >                 ethernet3 =3D &lan2;
> > >                 ethernet4 =3D &lan3;
> > >                 ethernet5 =3D &lan4;
> > >                 ethernet6 =3D &lan5;
> > >         };
> > >=20
> > > I know U-Boot boards that use device-tree will use these aliases to
> > > name the devices in U-Boot such that the device with alias 'ethernet0'
> > > becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux it
> > > appears that the naming of network devices that are embedded (ie SoC)
> > > vs enumerated (ie pci/usb) are always based on device registration
> > > order which for static drivers depends on Makefile linking order and
> > > has nothing to do with device-tree.
> > >=20
> > > Is there currently any way to control network device naming in Linux
> > > other than udev? =20
> >=20
> > You can also use systemd-networkd et al. (but that is the same kind of =
mechanism)
> >  =20
> > > Does Linux use the ethernet<n> aliases for anything at all? =20
> >=20
> > No :l =20
>=20
> Maybe it's a great opportunity for porting biosdevname to DT based
> platforms ;-)

Sorry, biosdevname was wrong way to do things.
Did you look at the internals, it was dumpster diving as root into BIOS.

Systemd-networkd does things in much more supportable manner using existing
sysfs API's.

