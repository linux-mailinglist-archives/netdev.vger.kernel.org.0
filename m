Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5996054E0
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 03:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiJTBS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 21:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiJTBRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 21:17:50 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2135.outbound.protection.outlook.com [40.107.114.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2208BB87;
        Wed, 19 Oct 2022 18:17:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2Fb63QGaIQkGRPXolgLFiKJowLvMBuqg/kbA1ugHlMwiG6gdWi7r6K5g2JAjz7nbazSvbJGWgNuTyihqmLqIIcln1PRznH5B2xvjljRLxl3MdaYn05u2fgrboEu8+VnrjsH4iefc2pJMppqMrciHpL7I47rMoH4XklXK7T7El4UTJDvhSdPcj4FW5O6NjFcJ9fRoN4xmAFDJh1i8cVMu6gkYDm54mvmNQ1yMSp3p8hoCIuHv+oTt25c9CnezPWZipmYILrWBEEqLFSbnVMvmiWFq14+2vEjD7hgYmjSo/DTeTq+2hUg5HGLIG7o2pr3jgBOJRZdWCygNUNr+u+ARQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ilsjnn6bEzuHIaoj66paODVidTb3KQZjpuT+Du45p6Y=;
 b=i/OQqmdZE+zsYqZCM7zt/tfpOs3oxhvuZqleHVI6upzSTcrDvyB13inVH/g3ULkL/IJd5DRg1IUhjRy/KzN9S7Onj16AZqngS3iyxtYzhmJDc39CE5BWQpeAunSssO4gZKfR2GY3Wg0/OGCb9c87oP8WBBEWGKOqCtWUt4f9kt0U4WqiTawDqFKVUQipk6pVhBymFOmSN3rpjCtyclLtJoLaOnd7LGYig6YA1oUG5o4l63yXmgk8drgmxCJa24pmYa6CjRaWF0eAjBVcReILQ35ve8NNyplmPyavPRUVwhBQCbPWFCfXeMy1ju3oOdw6plqjI2tsgP1F+ef0vZPVhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ilsjnn6bEzuHIaoj66paODVidTb3KQZjpuT+Du45p6Y=;
 b=IEVXyTDh95i24jlrXRTTcru3OjfGT6zQ5MCv4BX3cwuqXQY1oDoU+N6KXS0TeQ/RbwcL+2CHNcBDT1G5+8AttQQ5R6y6wfg1Jm7SsQ0A0W2mWks9NQrGj3FB1oZaJCXlKXxM/5e2fFUPdF1uURq/b3i5jMw730iNmAmban51fUw=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYAPR01MB5483.jpnprd01.prod.outlook.com
 (2603:1096:404:8038::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 01:15:53 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4%3]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 01:15:53 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH RFC 2/3] net: phy: marvell10g: Add host interface speed
 configuration
Thread-Topic: [PATCH RFC 2/3] net: phy: marvell10g: Add host interface speed
 configuration
Thread-Index: AQHY45fw9fp0Ss0XrE+szQ/ICWWuea4ViYGAgADwXlA=
Date:   Thu, 20 Oct 2022 01:15:53 +0000
Message-ID: <TYBPR01MB534181BF14DFF7485C500C61D82A9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
        <20221019085052.933385-3-yoshihiro.shimoda.uh@renesas.com>
 <20221019124839.33ad3458@dellmb>
In-Reply-To: <20221019124839.33ad3458@dellmb>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYAPR01MB5483:EE_
x-ms-office365-filtering-correlation-id: 3c7c2c4b-f3ef-46f9-a404-08dab238a21c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sj2381ezGYS9kdizfYfLxR9Pxw6Y5z9QjGo0eixl3BnMPGbRlKEh4G0I1TeMP1ZqzwzhAHkipEMD+gRDc47TUkUfkOSUrF6Lx29Koz8ffOkXnLqfR95sRWUkw5LKXYFqPsX7KylEMSA/4JkieFoXxLXhrUU7iy2mXcNUGysa/rMX3TWH2IvhbomB9GIrFdsgsblps9NbAp7qLcKcOILj1uGf1YenQIe6biZEw+J8Ubz9LVSMm+l97aEs3E/0XLwFSsp7XF3x9jDCq9EFyVnrntU1g5C7MZ6VJTw+K0KUUCOw7R13FZlNT3ZthWJvXJGfF3vjw5v3YmZjy3hg1oN55tQVgP1zB8A/twfzdx3sup4+2VGWhwPCLtrFDMy8vBdWbqORZ5E4qbCsgW35Ga5vRIwyqFYMZJ+UW18+WlCAz9cXpluQVHl87pG+bE8M5n/t1l8WrmeWeNEgyQaIIzHH3Hvfz4OkWKCrpU8mQ1bqGpfZiA1RPlo6fCe7L1z0C2njq8DciBRa9PFDJ18pDajjlep1Az9KTsk0RBrDoCzVaFHa+dr5vCTB4SPAy+rYDaKZisMyLLqpRHYGhMu47A1p2krVKUc1uye/RbtTvi6geGaoEPZyfZRBHvaLiGUU+apaq7AAdWETOc69r6pVJETZdthlNVJm+LgCBP2MavkdtDVD90qmkJYoS8gl6WvAAsv1u4GpF98riqkIA9Lq5Ump5A6wvXNNfnXZ8YNeWaPqpoSSdRIiLffp2Pskw5F+t91awpvCnZGeP/ELYtS7oveUzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199015)(33656002)(86362001)(38100700002)(38070700005)(122000001)(2906002)(7696005)(55016003)(7416002)(5660300002)(9686003)(186003)(6506007)(83380400001)(66574015)(6916009)(66446008)(71200400001)(478600001)(316002)(54906003)(8676002)(76116006)(66556008)(66946007)(41300700001)(66476007)(4326008)(8936002)(52536014)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?F8CKxklcyPGVvRLI0kT/zgoVwss+kpWPJlYp2Qg97hHS7+UTvraY4uBK0q?=
 =?iso-8859-1?Q?hT+gi5/+MuysFWf7rd9PrI0NvlvrUOgL93ptTx/3yMZD1kU3aOfI6YQx38?=
 =?iso-8859-1?Q?Eb4rLIXJ7EGGgaTgztM+/GTO5dHdR2e97hS/QRpwmP9ZoXiqdPBPlS1PXS?=
 =?iso-8859-1?Q?mpEvF6BY+p2ydnoXwbbAPxrMkcBnpX1IFMgEt0XRa88k6PAcQq5Bkp9rtV?=
 =?iso-8859-1?Q?41upNchxgNUPhPAzTxvR0POCNqnZb+hrunERxenCzgeywSImN88XhaclZJ?=
 =?iso-8859-1?Q?CJq6eVkEJhqzIiyRr/n5OpkvBRpF99UD+sQ2ERPGwpdOBy5IMonqP3+tUD?=
 =?iso-8859-1?Q?kiEfG3wR5YrjkDHzHBifUTElUakdOMDHbeCwu9F7PjJYcWn9JrZAuALrps?=
 =?iso-8859-1?Q?6TDT+Q7gByYBXJrRluzxIwbX54BOHgNa89Jd65tjqUazJnIcWPNr+/NLFm?=
 =?iso-8859-1?Q?lkxfonPsujRBR1cbPr4yufqMvfuswMMSmiSmcFkYMkdgIpDwMePCcicBhg?=
 =?iso-8859-1?Q?YZl8CH5Ic4fnJdIO/6Ng4sb1cbCgKM1zUYEvGeIhVwaRhtePvUghfts/2p?=
 =?iso-8859-1?Q?upI5abK/8qKF50IvykT8OQ5o0yh4BWiaQscK+b9ZuaQoHSvyFgarfM07s0?=
 =?iso-8859-1?Q?3rXb+rCizE6lLK5MvdbwLx2nqyoWSpbwswisjw5OOFfA2LByBPdRmMxL/K?=
 =?iso-8859-1?Q?gaeOEAkvlNej/YzniR5lnP7bGs7rOKfFa7yVHk1k4iKqGVYGp8sf8bgVYV?=
 =?iso-8859-1?Q?DpoHoxTSEZYw9cYpCuKNrnz8wsTs6AKmHSJX09ka7sTMPazB5ayjxCHi0S?=
 =?iso-8859-1?Q?x+/6tDF5uxeTxQmQeimxhYW2FljRWz2B9NV5yqb4wJ95AqbMYe7mmxB+Pp?=
 =?iso-8859-1?Q?OwTgn871rlLACHw1ZC3V4zptmnZpAQC5GsgW7ooVfGPbbpAHOKIH80jU26?=
 =?iso-8859-1?Q?TDI9wWD4HbsJ3dwKs8/6xCZCTaprM+uddhEVIyUe3aDMfzYOVFhpW3L999?=
 =?iso-8859-1?Q?fW9r/lwANoriA7Xwz4526S1vDUle61N5JBQTBGHm0ja0156Svi1nWBavbF?=
 =?iso-8859-1?Q?gs+jRI0GEPAOTZUt1nP/MtUexMrg0Y0m1cnyhc8zCHKthtpK/Upi2HdKUe?=
 =?iso-8859-1?Q?ERs4FO/f9KDa7PnJmpuZdnjfWc8dcfequV3FAaPTlMVlBE8H7byib8ko9w?=
 =?iso-8859-1?Q?Y2QRsOeYd4trD+aumhpTJu2QW2aJ0p3AS2KZy8riQeqy+Px5GCWUmBOTjQ?=
 =?iso-8859-1?Q?5ty8FnR4CzkleI2VKIGTW119O3XCEUk/nJvtwKNIcHahOw10k2W9XSzZ7x?=
 =?iso-8859-1?Q?+ded/K89TuZ2hwr4grbnSkdAn+p5S/jjcbKDAfcbvZeNroy1fiB24CUK6k?=
 =?iso-8859-1?Q?TqZFqH8uGGOVpJlR6rM4OpN/O/oB1NkJU4zTwmrR4oBftl9Qjl6YWcwjqo?=
 =?iso-8859-1?Q?vBmnYFQ3JWzmjOlqOTSIffbbhRHHNvbtb7WpatmcoAexyMtASKoQGTxreb?=
 =?iso-8859-1?Q?hOuF22bT9w/rRtY7v4lN2Cokc4y8L1QsVDkDA55JVzzMxFsr3TWs2c6F+X?=
 =?iso-8859-1?Q?gm4WRQZhkW8KAcPFrQyx0j0YjRMAUaWUuJoMgZZgPr7OItMtEZsf2AuM5l?=
 =?iso-8859-1?Q?vI/jz7e5PRgVrJwCHvuG/rJAhwryHa996qWlc2zBPCYQYahZEpASPyD/cA?=
 =?iso-8859-1?Q?vMjmvfzWXLI857P7vI12Pr1PZP9ykLH2K2YOf7iY/C2Me3PejEIHlqbmK6?=
 =?iso-8859-1?Q?/UKw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c7c2c4b-f3ef-46f9-a404-08dab238a21c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 01:15:53.3732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sJwGMGJQ6UISqJrdtdeo+ZcCuZzT3OP6cLBRvVOrOxTbbHt+KmFeL1ozzsu3MvgLTV9LSHgjzDGdYW3HYmQDYexru/kem2Lkwfj22TZNBw2k0jifbJYhd0kvWqQiTmUz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5483
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

> From: Marek Beh=FAn, Sent: Wednesday, October 19, 2022 7:49 PM
>=20
> On Wed, 19 Oct 2022 17:50:51 +0900
> Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:
>=20
> > Add support for selecting host speed mode. For now, only support
> > 1000M bps.
> >
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  drivers/net/phy/marvell10g.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> >
> > diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.=
c
> > index 383a9c9f36e5..daf3242c6078 100644
> > --- a/drivers/net/phy/marvell10g.c
> > +++ b/drivers/net/phy/marvell10g.c
> > @@ -101,6 +101,10 @@ enum {
> >  	MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS	=3D BIT(13),
> >  	MV_AN_21X0_SERDES_CTRL2_RUN_INIT	=3D BIT(15),
> >
> > +	MV_MOD_CONF		=3D 0xf000,
> > +	MV_MOD_CONF_SPEED_MASK	=3D 0x00c0,
> > +	MV_MOD_CONF_SPEED_1000	=3D BIT(7),
> > +
>=20
> Where did you get these values from? My documentation says:
>   Mode Configuration
>   Device 31, Register 0xF000
>   Bits
>   7:6   Reserved  R/W  0x3  This must always be 11.

Hmm, that's true. The register description said that.
But, "loopback control" in the functional description said
"default MAC interface Speed". (I don't use loopback mode though...)

> >  	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
> >  	 * registers appear to set themselves to the 0x800X when AN is
> >  	 * restarted, but status registers appear readable from either.
> > @@ -147,6 +151,7 @@ struct mv3310_chip {
> >  	int (*get_mactype)(struct phy_device *phydev);
> >  	int (*set_mactype)(struct phy_device *phydev, int mactype);
> >  	int (*select_mactype)(unsigned long *interfaces);
> > +	int (*set_macspeed)(struct phy_device *phydev, int macspeed);
> >  	int (*init_interface)(struct phy_device *phydev, int mactype);
> >
> >  #ifdef CONFIG_HWMON
> > @@ -644,6 +649,16 @@ static int mv2110_select_mactype(unsigned long *in=
terfaces)
> >  		return -1;
> >  }
> >
> > +static int mv2110_set_macspeed(struct phy_device *phydev, int macspeed=
)
> > +{
> > +	if (macspeed !=3D SPEED_1000)
> > +		return -EOPNOTSUPP;
> > +
> > +	return phy_modify_mmd(phydev, MDIO_MMD_VEND2, MV_MOD_CONF,
> > +			      MV_MOD_CONF_SPEED_MASK,
> > +			      MV_MOD_CONF_SPEED_1000);
> > +}
>=20
> Why not also support other speeds, if we are doing this already?

The register seems to support other speeds: 10, 100 Mbps and "speed control=
led by
other register". I'll update this function if acceptable...
# I'm thinking this is not acceptable because the register description said=
 "Reserved"
# as you mentioned.

Best regards,
Yoshihiro Shimoda

