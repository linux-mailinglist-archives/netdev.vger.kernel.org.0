Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F2A64A613
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 18:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbiLLRmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 12:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiLLRmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 12:42:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A7B231;
        Mon, 12 Dec 2022 09:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670866928; x=1702402928;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yakG3wzLESUydxmjREBOGDKuaMUN0jfMMsQy/xgD2TU=;
  b=19J6SjdYicnQSLW/nLith5+Y4bebT6iQkX8sqqEZUzSog3ewRLC4ZtvS
   dVxdc3ZACgte825PCCGtrtzly0btFioJThGKR+teyANpjrHQg4cBxgeXw
   3hRIGMsuhWTVEa1VFz6l4+6oMVtxvO7ukrya4dG/4VKtmchT+sEGwRRA9
   Q9gfWK9iq3pBOUpS89WoW5RXxhoFNA6oZjZW/2EYjaxBwiET7VHBfs83D
   ywz/bSGHtyNkA/TnWIcDcbimCuf/sprwAhXY0Bpt9HIYsSHH+ipNPilxJ
   DWi64WMlI9BxR+ZJ6f7mOkWw3ENoIpqJer7p3+7iUX6NTuWEzK4DMd9Ty
   g==;
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="187772330"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2022 10:42:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 10:42:06 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 10:42:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLrt4OtXcAkPgbFcfLNUlukJEJDKBwaVgRdPJ0sHAH733Fuqz/DiN2e1AlIIqhSHzOcEJamJr6gwJD/ETJqI2G+Gp6ENTa1RF5xy8f34EXHAVeJS7lPFAQoYrMoF9PxLS3x9FcwVZHElCFD2pIHA7HcsPQPbXPV4YRomtdDTrQnk4m0V6VuwIcSP8w37N0G4BjTQ8eapa6xfU6h45UWiXRfcEEgDXQcxq4UY+GMzMLi3MANNLkjucjyp2clRmTXOVQjNm6npH3qQbhhrLv3TCAiWdNIbIoDPlJDlkv4WljqErFLsGqI+BxOhVfkCT2ZsNGfNJVPhuKVwLxAJeZC3FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1x4bGYiD7YDyrUdrvVFGT0a1LPbI/GmyFveCUxaFoXw=;
 b=DpQAVKehxtYCTAauQKTfjNopX5Xw3FW4v4E2aKeq8tQTrUtIUECZWhEjc5CpGcdLMNGPzz4+LUVfPQv11P5hSp+10Jj253GRcKJAuLNsIXc+e33K4sd/y5tb2l4ElkcDfkIIiWGc/CrVZ8BqyYlOBBVKgtwbPDlo7YDLlX6Tz1kx8aLeQ6LL5jHHSaCaqlyhDr6vZNMFWiY7/Bkp0386IF5G0Bqc/pzK3h7Z8NEuMKWQPEBKQLiU5wk3ar0hlFB2kW4KnKVlaXyzfmeLzsnugBXvt592RXM7e98WbRYmAwFQuJ62rDpNkEYXufdOi5Nd/yW3VRt1CC2RlwFheqMZsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1x4bGYiD7YDyrUdrvVFGT0a1LPbI/GmyFveCUxaFoXw=;
 b=MB/c4FlvH8nxAntSsGUTXafjO9fA6SjrWpSvxQdQN2vLGaPLwFNRdjmxjUD7PoDHTrFHX650A/J6ekFVhauGh1mu4iuKJYLNEg7651NjsLe3d7L8Pq25mP4k9H9zh3YgXyEAKHno5iTLKyJNiYe952zQrCXDwgu3Y9H//DLCeTI=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by MW3PR11MB4730.namprd11.prod.outlook.com (2603:10b6:303:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 17:42:02 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%11]) with mapi id 15.20.5880.019; Mon, 12 Dec
 2022 17:42:02 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <jbe@pengutronix.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>
Subject: RE: [PATCH net-next v5 5/6] dsa: lan9303: Determine CPU port based on
 dsa_switch ptr
Thread-Topic: [PATCH net-next v5 5/6] dsa: lan9303: Determine CPU port based
 on dsa_switch ptr
Thread-Index: AQHZDCA8SY/y7YUH1UWHZfSqu6V8O65pTHcAgAE9BTA=
Date:   Mon, 12 Dec 2022 17:42:01 +0000
Message-ID: <MWHPR11MB1693284A37657C11F91ADFD0EFE29@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221209224713.19980-1-jerry.ray@microchip.com>
 <20221209224713.19980-6-jerry.ray@microchip.com>
 <20221211224608.rdlcuqg4d37f7z66@skbuf>
In-Reply-To: <20221211224608.rdlcuqg4d37f7z66@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|MW3PR11MB4730:EE_
x-ms-office365-filtering-correlation-id: 86aabcce-f8f8-4eca-0550-08dadc682d3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: krjvakN8SFgjNXKG7n7tj+e07LFyzu8cu3Yzg3YCpgYNgy36nUZvvLf8E97D3ewU+JyU08xtAowziELqphYF2ulwz44YisLZl1OCkCJDtMFXftgRgLHdbJ5Vp8DPfM0bkPrQt27OtefKtho08DN9ua44fzVZo0x74kJLFC5vIhBadh+c/EuzBQ2bHMBBe0SBV0sJpKBupAzRaOaiK20Iw4aHTd7CEWXQDjwP0EEP14G/S4yPdUAoHZnolzVYNKcg+EksvOmYIAWzFz7XGhKvOnyow0eXGRz51vv8Sb9EVhhXwTrVk6S6BEEahp/9HZvBJu0NcM+74behhgY1LRbFXZ9iq8BZa0o4ryk/tOr2dfxjCMn4vh/FIFNmT7wQbX9Z5Idb8M/0uSIFKy5nMbzk67BPJOa/m3xVDwOhJ8wh3ZJxOAtqehgiSkFqnAushMqUWdwvJDrFl8QH8HG4bdIHgX+RkpD2xjq13iE9pNhH9JmvTJVkynbDOoXohc/Gi3u/l90m6v29Ms8AXBU4a8ackk+8m4NP70AZxJLFx77ICUiNO9NGIyykLOP9Avf//2jYqPLOEQJo4xbBySD2/ALRZwv6vAyry2vTpO9MCmZSBCaXGLADqaHDPYFE0XILurpbI1w6k4V+/gFVgk5rlNHM0GC50WmQhWmUO0SunVD/Jvx/iSuvF//PdiHjuPJmHCloWOm34SdXDyInaTVkssITDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199015)(76116006)(2906002)(33656002)(83380400001)(54906003)(6916009)(86362001)(66946007)(52536014)(5660300002)(8936002)(55016003)(7416002)(38100700002)(122000001)(38070700005)(41300700001)(316002)(66556008)(4326008)(64756008)(66476007)(8676002)(66446008)(71200400001)(9686003)(186003)(6506007)(478600001)(7696005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G0E26VaDz5z3kbZWqzfBL8Pz3WvcRWQsjfSnTYOwyXiqbQu1mlUjE4Ui1Ccu?=
 =?us-ascii?Q?o1BqtOiYcPRo5OvM2tLJmKIg7ePFQJC5XgaC4+coUTI6qjiwmh/ssCeqRTrb?=
 =?us-ascii?Q?z8dTN0LPTYk/4A3TW+MX2i+TQpHfowYqhha9xO8Gv5quCSvku/4RIq1wrk8W?=
 =?us-ascii?Q?K/jbLEwJ7kpS5nenjU63npfsN7oV/yLU+uhekkiiusenmTJRmO/n+hqBd3zA?=
 =?us-ascii?Q?Lugvdq3bRZR+TfbsMj1HnMf3oQ747LJhaGHRLH00VR5oL+7V5jjRRkpC7hkb?=
 =?us-ascii?Q?HyMEDVcdiSU7PkvVRJFXmNc0LpToBORHavgeINPRerMU3oGOmMMhcfH/vMNp?=
 =?us-ascii?Q?0ehelIi9ZV1mRkzrp0Co4Y1R+z8+anctMya4djjvQkrhfZpAgqaK+HSA2Gkp?=
 =?us-ascii?Q?rU0KQPnLoXmJ6nB1fHlrQTW5u8gL2fai32cRJ5pno07edQerM5a7htaK/E0R?=
 =?us-ascii?Q?5Qz/rixpkcrHwDdI4H7N6V+PPywC2qUvshxdLmtCeVGpHDEF2m9Dod2RujTy?=
 =?us-ascii?Q?Q021GtudI+JbsvpmrleZbhOoE31gTPEtc8eFd046O1qSkhb/Jh5cbfKkInHU?=
 =?us-ascii?Q?hkD8SkeT+4bjjoh7Jt6wq1OK4uswS51VTCl6Nicjv8wEvAgHDAj86dF1RLeZ?=
 =?us-ascii?Q?op5qwL+i9Aw5pIhPgPB+ilf3YG7Wj91AWEytJe9nhOdnfBpCBrdyNBrYnQKK?=
 =?us-ascii?Q?UG8l+QLrJdVQqJPkU2Dhst4v86xqi6g4R4ENFdkkrtJy/rrY8HBXaxgRlspe?=
 =?us-ascii?Q?bIIvbVnY+bn14GMq3NhYgCTpdKLpgXS7rqQYu4ER6/LFYAQ7jnXmV/+Zh+5Q?=
 =?us-ascii?Q?lbv7fn0wQumdoRiGUjDBdnQGPfozqm2E7w7J6cnSnGgctacF336o5jnUa4ge?=
 =?us-ascii?Q?dlr1Oi0Ovet+ReeMLym3gPow9MlpGdVlUUu8Rnq2ZyHWgXXr0o8QhHFcXj8F?=
 =?us-ascii?Q?oyjc5N/9HKpPPFnpbPtZCmqiLkWdU0Qy60J6/q/ape9t4Qf/0exeOPSGZZUJ?=
 =?us-ascii?Q?cPIYDALWJQ8SC9cIVntD+0DW7RVntI+FR4Rd6Kj9ZZymfJc8yWQxDfGBrjrH?=
 =?us-ascii?Q?dJbqo2I/p7FT8BYU6F0PszD1VQCXWW/qnd9sXOHeSf1dk5nuFYrwx1yCzG2s?=
 =?us-ascii?Q?k3651TshtDZMzHO4eMcQL34nD4ayD4cOVcbDAKoGPvgWnIfbKgA1GUbmRuCe?=
 =?us-ascii?Q?+sP/TS3w+JMdpZ+9dyCqoSYzwijI5Mk9gU53wX2fh8yI5nNKQx/SPpy6EXZU?=
 =?us-ascii?Q?teRrL+U7g0kpiejq0BXK1TG5pUyEEExblYDha+UchwuHV7VUFT3dw+e//cxm?=
 =?us-ascii?Q?RK3hZ5LE8IGehVrhiZ7cLVXJrNLYby8OdWOfTygxe+uTXcWYjzF04rNArKd3?=
 =?us-ascii?Q?nEgR1Q1CTzJu6vdMdmLIR66gTK4Uzf7COckYY1Nc0h+/+FtyYZm4OkQYolLY?=
 =?us-ascii?Q?DVomFDupZ1+4yBIJaleYpJtpNZCY4R9JAbre55+24+AIeN86ddssRH1V6uju?=
 =?us-ascii?Q?bAzu+LUOL1rdRR7HhhiQsIe+P6mDVa2IpbLmYSrIi0kfLKtkShUh0IM+aid6?=
 =?us-ascii?Q?DwubAqgz8mJayeP1VrxBXJId9tGo9THV/Bntm7km?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86aabcce-f8f8-4eca-0550-08dadc682d3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 17:42:01.9848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pxi5yFD41Zuz+DVGu1Rc0iW2N0jo6tG+vI969Zx9VDu0lfgin9wg6UuDEN60RwlaghB5G48BGL+yLs7u3HarZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4730
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > In preparing to move the adjust_link logic into the phylink_mac_link_up
> > api, change the macro used to check for the cpu port.
>=20
> No justification given for why this change is made.
>

The phydev parameter being passed into phylink_mac_link_up for the CPU port
was NULL, so I have to move to something else.
=20
> As a counter argument, I could point out that DSA can support configurati=
ons
> where the CPU port is one of the 100BASE-TX PHY ports, and the MII port
> can be used as a regular user port where a PHY has been connected. Some
> people are already doing this, for example connecting a Beaglebone Black
> (can also be Raspberry Pi or what have you) over SPI to a VSC7512 switch
> evaluation board.
>=20
> The LAN9303 documentation makes it rather clear to me that such a
> configuration would be possible, because the Switch Engine Ingress Port
> Type Register allows any of the 3 switch ports to expect DSA tags. It's
> lan9303_setup_tagging() the one who hardcodes the driver configuration
> to be that where port 0 is the only acceptable CPU port (as well as the
> early check from lan9303_setup()).
>=20
> DSA's understanding of a CPU port is only that - a port which carries
> DSA-tagged traffic, and is not exposed as a net_device to user space.
> Nothing about MII vs internal PHY ports - that is a separate classificati=
on,
> and a dsa_is_cpu_port() test is simply not something relevant from
> phylink's perspective, to put it simply.
>=20
> What we see in other device drivers for phylink handling is that there
> is driver-level knowledge as to which ports have internal PHYs and which
> have xMII pins. See priv->info->supports_mii[] in sja1105, dev->info->sup=
ports_mii[]
> in the ksz drivers, mv88e6xxx_phy_is_internal() in mv88e6xxx,
> felix->info->port_modes[] in the ocelot drivers, etc etc. Hardcoding
> port number 0 is also better from my perspective than looking for the
> CPU port. That's because the switch IP was built with the idea in mind
> that port 0 is MII.
>=20
> I would very much appreciate if this driver did not make any assumptions
> that the internal PHY ports cannot carry DSA-tagged traffic. This
> assumption was true when the driver was introduced, but it changed with
> commit 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports").
> Coincidentally, that is also the commit which started prompting the
> lan9303 driver for an update, via the dmesg warnings you are seeing.
>=20
> It looks like there is potentially more code to unlock than this simple
> API change, which is something you could look at.
>

I understand your point. The LAN9303 is very flexible, supporting an I2C
method for managing the switch and allowing the xMII to operate as either
MAC or PHY.

The original driver was written targeting the primary configuration most
widely used by our customers. The host CPU has an xMII interface and the
MDIO bus is used for control. Adding in the flexibility to support other
configurations is something I will investigate as I expand the driver to
support LAN9353/LAN9354/LAN9355 devices. Adding the
private->info->supports_mii[] as was done in the ksz drivers is the most
likely approach. I see this as a separate patch series.  Would you agree?

I will hardcode for port 0 at this point rather than looking at CPU port.

Regards,
Jerry.

> >
> > Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> > ---
> >  drivers/net/dsa/lan9303-core.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-c=
ore.c
> > index 694249aa1f19..1d22e4b74308 100644
> > --- a/drivers/net/dsa/lan9303-core.c
> > +++ b/drivers/net/dsa/lan9303-core.c
> > @@ -1064,7 +1064,11 @@ static void lan9303_adjust_link(struct dsa_switc=
h *ds, int port,
> >       struct lan9303 *chip =3D ds->priv;
> >       int ctl;
> >
> > -     if (!phy_is_pseudo_fixed_link(phydev))
> > +     /* On this device, we are only interested in doing something here=
 if
> > +      * this is the CPU port. All other ports are 10/100 phys using MD=
IO
> > +      * to control there link settings.
> > +      */
> > +     if (!dsa_is_cpu_port(ds, port))
> >               return;
> >
> >       ctl =3D lan9303_phy_read(ds, port, MII_BMCR);
> > --
> > 2.17.1
> >
>
