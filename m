Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77FA918E7BE
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 10:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgCVJJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 05:09:34 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35461 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgCVJJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 05:09:33 -0400
Received: by mail-lj1-f195.google.com with SMTP id u12so11182707ljo.2
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 02:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:in-reply-to:originaldate:originalfrom
         :original:date:to:cc:subject:from:message-id;
        bh=6N1PewsqX7bxn4cNlKsJJ2jMwwLZDPNv5uU0i+2HQAo=;
        b=oQkWJ6gkx/xU1ds4yrCPVzhx5iq6+OiXEuh/PC7G7dnvgCzCwCpCh+oaJhObu0CawM
         ZedQByP4mG+PERJojGDOxBSvpXVq4JeDBPPcFYFwvdgk4jBsfT3yl0XPFQGQXjP5wMO1
         16N3e284ATPOH+ci4bFf6HdlXPK0viMCHtwg9+/iKbpP4vczpLCXRTpx/EzUdBgVZf7Y
         TvdCsEE4CyoX/VxZir6YUdVcKxCKU8tOITG+2YFnjY/Q8fb2jcy0b6uA2tkcHFSPOh26
         Wa2/zlaGbeEkSkzEwWArewBVMThaDzPS9IFq5OIpJfxA4q+pRtt6JChMi7JIzSFi/sHU
         dNzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:in-reply-to
         :originaldate:originalfrom:original:date:to:cc:subject:from
         :message-id;
        bh=6N1PewsqX7bxn4cNlKsJJ2jMwwLZDPNv5uU0i+2HQAo=;
        b=rJqnv5d2gRnaGqbicKbhSkF3GRLRz70dNipwbsaHjXG1K1V2Ib4zekzK0MTB7riKvo
         uzrA9s4gVe5aJxvHI7ZPKOu5AiZsDScqkyQbnXuzki0TDn/kstQZ1NfwDlx9qNM7Qfg+
         JzuzNIKCS7sa0kw0s0D9RdfkgeVGJXRVFBr9r8mBuDIhdUnWjddmnpC0oEBjkiGE7roE
         NA9GZ3IPVktZwRZSCAtODhddDpv+cgHcFsysOZeKPh2iCkMt9csd6uld8QOWAtbihnHp
         gVY4CpCXd9bF7qdOHWbWexNyPZTYo+DQj1oSSgj9GwwMiKbi3vmB1rwGJ74rDg/ncCJ6
         Pmmg==
X-Gm-Message-State: ANhLgQ0YwDKr9LY5Wvbe/45yqmQw3iOu5W50S/uD5zmkG6cVOUf13q+D
        RC7Z7x74CQUMRcBpzi/hipEu5lXsOXojiQ==
X-Google-Smtp-Source: ADFU+vtN8YagwYhKrQ7munflZRExsaO+eOyr8Ek0+mnv5gApHGcJv+FjGAN3rpLcqRSs7m2Yn9FxDA==
X-Received: by 2002:a2e:b88b:: with SMTP id r11mr10496183ljp.116.1584868169837;
        Sun, 22 Mar 2020 02:09:29 -0700 (PDT)
Received: from localhost (h-50-180.A259.priv.bahnhof.se. [155.4.50.180])
        by smtp.gmail.com with ESMTPSA id n17sm836160ljc.76.2020.03.22.02.09.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 02:09:29 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20200322074006.GB64528@kroah.com>
Originaldate: Sun Mar 22, 2020 at 8:40 AM
Originalfrom: "Greg KH" <gregkh@linuxfoundation.org>
Original: =?utf-8?q?On_Sat,_Mar_21,_2020_at_09:24:43PM_+0100,_Tobias_Waldekranz_wro?= =?utf-8?q?te:=0D=0A>_An_MDIO_controller_present_on_development_boards_for?= =?utf-8?q?_Marvell_switches=0D=0A>_from_the_Link_Street_(88E6xxx)_family.?= =?utf-8?q?=0D=0A>_=0D=0A>_Using_this_module,_you_can_use_the_following_se?= =?utf-8?q?tup_as_a_development=0D=0A>_platform_for_switchdev_and_DSA_rela?= =?utf-8?q?ted_work.=0D=0A>_=0D=0A>____.-------.______.-----------------.?= =?utf-8?q?=0D=0A>____|______USB----USB________________|=0D=0A>____|__SoC_?= =?utf-8?q?_|______|__88E6390X-DB__ETH1-10=0D=0A>____|______ETH----ETH0___?= =?utf-8?q?____________|=0D=0A>____'-------'______'-----------------'=0D?= =?utf-8?q?=0A>_=0D=0A>_Signed-off-by:_Tobias_Waldekranz_<tobias@waldekran?= =?utf-8?q?z.com>=0D=0A>_---=0D=0A>_=0D=0A>_Hi_linux-usb,=0D=0A>_=0D=0A>_T?= =?utf-8?q?his_is_my_first_ever_USB_driver,_therefore_I_would_really_appre?= =?utf-8?q?ciate=0D=0A>_it_if_someone_could_have_a_look_at_it_from_a_USB_p?=
 =?utf-8?q?erspective_before_it=0D=0A>_is_(hopefully)_pulled_into_net-next?=
 =?utf-8?q?.=0D=0A=0D=0AFrom_a_USB_point_of_view,_it_looks_sane,_only_one_?=
 =?utf-8?q?question:=0D=0A=0D=0A>_+static_int_mvusb=5Fmdio=5Fprobe(struct_?=
 =?utf-8?q?usb=5Finterface_*interface,=0D=0A>_+=09=09=09____const_struct_u?=
 =?utf-8?q?sb=5Fdevice=5Fid_*id)=0D=0A>_+{=0D=0A>_+=09struct_device_*dev_?=
 =?utf-8?q?=3D_&interface->dev;=0D=0A>_+=09struct_mvusb=5Fmdio_*mvusb;=0D?=
 =?utf-8?q?=0A>_+=09struct_mii=5Fbus_*mdio;=0D=0A>_+=0D=0A>_+=09mdio_=3D_d?=
 =?utf-8?q?evm=5Fmdiobus=5Falloc=5Fsize(dev,_sizeof(*mvusb));=0D=0A=0D=0AY?=
 =?utf-8?q?ou_allocate_a_bigger_buffer_here_than_the_original_pointer_thin?=
 =?utf-8?q?ks_it_is=0D=0Apointing_to=3F=0D=0A=0D=0A>_+=09if_(!mdio)=0D=0A>?=
 =?utf-8?q?_+=09=09return_-ENOMEM;=0D=0A>_+=0D=0A>_+=09mvusb_=3D_mdio->pri?=
 =?utf-8?q?v;=0D=0A=0D=0AAnd_then_you_set_this_pointer_here=3F=0D=0A=0D=0A?=
 =?utf-8?q?If_that's_the_way_this_is_supposed_to_work,_that's_fine,_just_f?=
 =?utf-8?q?eels_like=0D=0Athe_math_is_wrong_somewhere...=0D=0A=0D=0Athanks?=
 =?utf-8?q?,=0D=0A=0D=0Agreg_k-h=0D=0A?=
Date:   Sun, 22 Mar 2020 10:09:28 +0100
To:     "Greg KH" <gregkh@linuxfoundation.org>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] net: phy: add marvell usb to mdio controller
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
Message-Id: <C1H8VLGMUEEC.3BCHVI0HO90KD@wkz-x280>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun Mar 22, 2020 at 8:40 AM, Greg KH wrote:
> From a USB point of view, it looks sane, only one question:

Great, thanks for the review.

> > +static int mvusb_mdio_probe(struct usb_interface *interface,
> > +			    const struct usb_device_id *id)
> > +{
> > +	struct device *dev =3D &interface->dev;
> > +	struct mvusb_mdio *mvusb;
> > +	struct mii_bus *mdio;
> > +
> > +	mdio =3D devm_mdiobus_alloc_size(dev, sizeof(*mvusb));
>
>=20
> You allocate a bigger buffer here than the original pointer thinks it is
> pointing to?

Yes. I've seen this pattern in a couple of places in the kernel,
e.g. alloc_netdev also does this. The object is extended with the
requested size, and the offset is stored somewhere for later use by
the driver.

> > +	if (!mdio)
> > +		return -ENOMEM;
> > +
> > +	mvusb =3D mdio->priv;
>
>=20
> And then you set this pointer here?

...in this case in the priv member.

https://code.woboq.org/linux/linux/drivers/net/phy/mdio_bus.c.html#143

Thanks

