Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5657C66B927
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 09:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjAPIjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 03:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjAPIje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 03:39:34 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2077.outbound.protection.outlook.com [40.107.249.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5943FCC02;
        Mon, 16 Jan 2023 00:39:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQMurB8BeXtXY033t9HuWYY7zGlfUjQyJ8Hjwf6Cu5tat0fvx9nCeXqM8UEBnS/V2nmcjbpFTQQsDqXBlKMquXCNDsxm525Ae6ePwInmSlVxI0usdS8QqUozL2YMBOGLQXvzH8PHjLAzyScreUwfFUHGVLAGFD5uMP4pY3Kv3+xl8yrHUQruZKr76DV2Sbgx7hHjfXFQuEdvX/aOf03EWWVXGH4GnRspQwo5PQ4dX37iRGKO0l5RnkPf6/gm99jTjRkMDGJrjSf/rYEa9YoNApaSMz++x1rgI+WKcKyiDM40BtXMhq/ZIkKQCUaqQPJh+SxA/k7om7MdUW6OgIFncA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDRdpkDfTv0th2SEMJjAF398ifU5N2KsqVfl0Dq9R4Y=;
 b=Is40OQQYDp4G/v5oSbgbc9mLRsc9dMZrubgOZIO7dEkZ2wkzhpILzK5du2g6U7+jzCrddaCGh6FhTv59QtFg/SZdgYowQ4L1HtFTYaJ13po0Jqwgx8kOkdqDNFjtxwOYrMZgOjOr5LLSO19okV9OpIMVn/02G9hAINtP8v1blt1qH9eNqiFTspxpiINePaEKt7sLTfM5iZLmHIhcqvFmDHZOFjFHsHijtrDJjH6/PH/WU2dmFcnIwLOKNUPbclecpLgczT5YKEar81UcSaVMVm1tspJJk2bSitQscA/N3XqSSryOuGbc0D9/nF6msiHFZ4diRhi9FQEL0R8/0je1HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FDRdpkDfTv0th2SEMJjAF398ifU5N2KsqVfl0Dq9R4Y=;
 b=n1JgmRf6xzBb6g70HjFs+PgOADL0fNikaZ9M28LXB6iwFTLbOinYM1SCUSVdzNBthAaTFS1eB9sKsOafRCx0KT1qZJOaVkyfib7LJVU4CVNrRpMaLYQa22Wf8qUvv8ATWI2JnS22l+a2lSKoDj+Eyy3Dnsf7CMlCqZLhenb3/aVwJi2JwIAUGlD974s1dJjxRHmaPF77TLS0f2CICwwogO6hvB8at6VSv8tUcH6yPyenr8lEFB4ZS8rAHzJ1EkER9oVe6yPCB0kdREiFecmjNYXPqybCFPFPnx+vFe1ZZzPZm4GRV33EbQD5bnB45UF1flmEvXmVPu3ZgCbV6mARsA==
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by DU2PR08MB7374.eurprd08.prod.outlook.com (2603:10a6:10:2f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 16 Jan
 2023 08:39:31 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 08:39:31 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     Andrew Lunn <andrew@lunn.ch>, Lars-Peter Clausen <lars@metafoo.de>
CC:     Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Topic: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Index: AQHZKPvgQPO0npisDkSvgN3jEdgJF66fthyAgABQ/YCAACCdgIAAkkGo
Date:   Mon, 16 Jan 2023 08:39:31 +0000
Message-ID: <AM6PR08MB43767C522EDAAF962B3AA73AFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch> <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
 <Y8SSb+tJsfJ3/DvH@lunn.ch>
In-Reply-To: <Y8SSb+tJsfJ3/DvH@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR08MB4376:EE_|DU2PR08MB7374:EE_
x-ms-office365-filtering-correlation-id: 28e3f583-290d-4a87-fb5a-08daf79d2fd8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ADkvKRo/2keWJl9q1L0RwhKsIygO6vhkyy62CRXMCV4e0j5DmcfAd2+OPRRc75VX/wPQBqA1+t+NcTzmp1zaOvsfKJOpoUfLe/EpzcHtgFoaKZhxkddq2I90myRcnopb/DCy2oH0Ksd+9FZvJ/FbtWeULDKyuJ+zApynQUPvsk90n+QW6+b5n8/vluqnkZeSEhEpJIbxrZPLgk89+odaofsst0zAW1NepbGP4nIs55BOvqfCI6WHH2eNl6LVKKJcfUFpqIZwcWmKQIzMgWDDY5xwWx5PGUGCU7gu66ltKFcpMGVdCCyiv75DhQ40dAjZ2jj6KsC1XUMdqlqigKkFd5wS8+m27zlASzwCsi1Ma2lXyBXz70kNsDdx2d1W8DCGC9MquHQTjMDghpJuNwKavYho2idXhfH38sp3Mf+NXUBrBql5IAYMamT/3Eb5V173GzSjBFQlUFztGMaKvC2vCKm9FeAB/RS/l72bBVNlVyvFeXycMnUfDh1u2GkH6ID0w+uBFxRgn5oJMvetJj62mcvmDDyMsO4RKCfl9P1Xjp4N9BSY4NT8AZXRSkX/cNttKVXPyVxBZ7+Fhgw0qwV8bbyZwA1oNPLeDkZRMGlt4Hp8fPc1tWjk46j0ld8wEGnKODq0Z9oAL2i6pEI5vBZ73p1r2grhH05Qj0uNZYc7J2f11tGuhJIwO24DFrWACPtRas5T74KQxmq5tcEFbB1FE2sE8pctWz+aQ2O6KyOztuo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39840400004)(366004)(376002)(346002)(396003)(451199015)(38070700005)(4326008)(7696005)(8676002)(8936002)(66946007)(76116006)(66556008)(52536014)(2906002)(7416002)(5660300002)(33656002)(122000001)(66476007)(86362001)(66446008)(83380400001)(64756008)(71200400001)(478600001)(966005)(54906003)(91956017)(110136005)(316002)(38100700002)(55016003)(9686003)(41300700001)(53546011)(6506007)(186003)(26005)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?DVxui2Q94Nuv1dqMbxJMpcxAWgPWV84jik70Afs8OcIQOBgw0gUtxP5o/Q?=
 =?iso-8859-1?Q?DZio+ogpGIYAGjBK1fYCA3EQEqYcwQIlEe1cSx8rELiLhcW56C7ObF6OzW?=
 =?iso-8859-1?Q?YPrgqgq+5VK+RsqbmCh9CRBOKCE+md8OOkQyaMceh8UR3dYxEFpky9q7HZ?=
 =?iso-8859-1?Q?ghQAHaJxnI/jIoU0z2bnZ3zaarhrHbUP4Z5WvTYzFIbXljy+juxsRiqTO7?=
 =?iso-8859-1?Q?mV46Mc2pQjIuuNlPBFiRtTbuwb7JLSJu5Br4zxMThA+jpM2oN3TRw3lIEk?=
 =?iso-8859-1?Q?uN0EBuMXaZpClswRO7LVWZMQLMsO98jmwOVfyZmBvc17jyd3W/ELApEpzi?=
 =?iso-8859-1?Q?t2qoju7w2tspX/C5m2MyfUUPguX6v3kpzQ5dXT3DdVV16n5zuoQTMtCiKu?=
 =?iso-8859-1?Q?prTr/8N7ahA9BHDuQRvHRN8ic5oeTpRezJxHw9w6yZxd0wQDWtr/g1z2E3?=
 =?iso-8859-1?Q?L8L+f5PD6nzt1vxU+uQhBShEEmLUJZGCVqQwg5T4pC6B8gnmlCndnVdkVP?=
 =?iso-8859-1?Q?i+iPcTAU4alNRWPH7o3i1vEGmyZYbEKXie6aQgE8bYzlpbGR5TfVCaUOvi?=
 =?iso-8859-1?Q?uT3201TMetE2GJMpVQBaZl2+IbtP1aKmpWNmgEIqKON/qXyeAkbbG8EBr9?=
 =?iso-8859-1?Q?puq4lK8U8DRwuXGTGMayuUBVhXsvU7EJLDU6aZOTlYLLk/IamzKzlliK+h?=
 =?iso-8859-1?Q?lRiVmDLPU8XILEXQD3v/PCLFuqTq6cMS3s/h6ClNnNJqQlXmWFGxbIda9k?=
 =?iso-8859-1?Q?9iOxXy7wjylDuXVZ22EuBZczcwGSlf0Ofs72gO4q+jelFtYsqKi9UFmu65?=
 =?iso-8859-1?Q?XbBpm27a7wd9ZYqZksycfT6b24Od/PM3C6hYMqz16sG+ahki93KCF/RVgw?=
 =?iso-8859-1?Q?vVPNEAokgjVVXjUfBvJAgDYxlAEAwkoMedt6KbIrxm/euRAjAQZo5wwucv?=
 =?iso-8859-1?Q?7zU8NIYCzF1N05gOzza0hHpbWBXZOANGCdNzRCUDBAlqA0Of28TV3dAfSR?=
 =?iso-8859-1?Q?g3OI4y9w2xiDxTLEmn1M9iVZGShqcQefxh06M97Z3YPNg9ltf/FRZ5MrGB?=
 =?iso-8859-1?Q?6dneAEueMOYBm/yncB3Rn3qWOhfB4Pbld3yFJWXfxc0nrhM5NTbc22I3TY?=
 =?iso-8859-1?Q?+WJGEHG+4VH7cEcVSKl0DbmXGRxUfTJrEmZ54XDv+h3QWvWbFIBHFO6V12?=
 =?iso-8859-1?Q?kJ6kBkoW7CBBIsDoqwZcYvzjdN4MZhj4EpqXV/saORoJZvB2GQy8/fsEDH?=
 =?iso-8859-1?Q?yCucPDG9kQ8i0w5gsBn5cAveaTb18i/8JHwDTN4QFFURb/kWl7DmqoTJSM?=
 =?iso-8859-1?Q?tiZwy145WOaJb8kByCHIT78SZQ2i0nmilgXoADt1m3ddqXvGHXR4zAspHm?=
 =?iso-8859-1?Q?L7zHQNL9MsPqkssPfIRIeqViow73bo7RQwG5aAYc3bIRooEk4mYjY/Jwbl?=
 =?iso-8859-1?Q?isk9KMG3WD4UlEagZpOcE5kAGn56lo2Osv3sEVtdZjZ16SIJzx4MiLT0+J?=
 =?iso-8859-1?Q?+OHWa1xIEai7FAiac5K4HBanliwR+1jIHV/JbcTuhPDrGGR4Ncoy9IecrF?=
 =?iso-8859-1?Q?xPux+cCCk+s6KLeY4AFwy21XOU06qpqQjfth82yjEnuV++ro5MuRKXBKue?=
 =?iso-8859-1?Q?1egNfNe69Xc55xAqh7HdPOkqnhFAo+XCk2?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28e3f583-290d-4a87-fb5a-08daf79d2fd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 08:39:31.0553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cgHWUm0qP5A+b6UYkaWdbD80ujo2Ac6MnSAXe1n+Iqk7J3Qk1Rt0ygZedT7WU8tmEF0xRC5oooze/QGI7zUtCW2nlvR8hUG/2ATBybEx/kI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB7374
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 12:55 AM Andrew Lunn <andrew@lunn.ch> wrote:=0A=
> > Specifying the ID as part of the compatible string works for clause 22 =
PHYs,=0A=
> > but for clause 45 PHYs it does not work. The code always wants to read =
the=0A=
> > ID from the PHY itself. But I do not understand things well enough to t=
ell=0A=
> > whether that's a fundamental restriction of C45 or just our implementat=
ion=0A=
> > and the implementation can be changed to fix it.=0A=
> >=0A=
> > Do you have some thoughts on this?=0A=
>=0A=
> Do you have more details about what goes wrong? Which PHY driver is=0A=
> it? What compatibles do you put into DT for the PHY?=0A=
>=0A=
We use both AR8033 and ADIN1300: these are 10/100/1000 PHYs.=0A=
They are both probed after the MDIO bus, but skipped if the reset was=0A=
asserted while probing the MDIO bus.=0A=
However, for iMX6UL and iMX7 we use C22, not C45.=0A=
>=0A=
> To some extent, the ID is only used to find the driver. A C45 device=0A=
> has a lot of ID registers, and all of them are used by phy_bus_match()=0A=
> to see if a driver matches. So you need to be careful which ID you=0A=
> pick, it needs to match the driver.=0A=
>=0A=
> It is the driver which decides to use C22 or C45 to talk to the PHY.=0A=
> However, we do have:=0A=
>=0A=
> static int phy_probe(struct device *dev)=0A=
> {=0A=
> ...=0A=
>         else if (phydev->is_c45)=0A=
>                 err =3D genphy_c45_pma_read_abilities(phydev);=0A=
>         else=0A=
>                 err =3D genphy_read_abilities(phydev);=0A=
>=0A=
> so it could be a C45 PHY probed using an ID does not have=0A=
> phydev->is_c45 set, and so it looks in the wrong place for the=0A=
> capabilities. Make sure you also have the compatible=0A=
> "ethernet-phy-ieee802.3-c45" which i think should cause is_c45 to be=0A=
> set.=0A=
>=0A=
> There is no fundamental restriction that i know of here, it probably=0A=
> just needs somebody to debug it and find where it goes wrong.=0A=
>=0A=
> Ah!=0A=
>=0A=
> int fwnode_mdiobus_register_phy(struct mii_bus *bus,=0A=
>                                 struct fwnode_handle *child, u32 addr)=0A=
> {=0A=
> ...=0A=
>         rc =3D fwnode_property_match_string(child, "compatible",=0A=
>                                           "ethernet-phy-ieee802.3-c45");=
=0A=
>         if (rc >=3D 0)=0A=
>                 is_c45 =3D true;=0A=
>=0A=
>         if (is_c45 || fwnode_get_phy_id(child, &phy_id))=0A=
>                 phy =3D get_phy_device(bus, addr, is_c45);=0A=
>         else=0A=
>                 phy =3D phy_device_create(bus, addr, phy_id, 0, NULL);=0A=
>=0A=
>=0A=
> So compatible "ethernet-phy-ieee802.3-c45" results in is_c45 being set=0A=
> true. The if (is_c45 || is then true, so it does not need to call=0A=
> fwnode_get_phy_id(child, &phy_id) so ignores whatever ID is in DT and=0A=
> asks the PHY.=0A=
>=0A=
> Try this, totally untested:=0A=
>=0A=
> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdi=
o.c=0A=
> index b782c35c4ac1..13be23f8ac97 100644=0A=
> --- a/drivers/net/mdio/fwnode_mdio.c=0A=
> +++ b/drivers/net/mdio/fwnode_mdio.c=0A=
> @@ -134,10 +134,10 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus=
,=0A=
>         if (rc >=3D 0)=0A=
>                 is_c45 =3D true;=0A=
>=0A=
> -       if (is_c45 || fwnode_get_phy_id(child, &phy_id))=0A=
> +       if (fwnode_get_phy_id (child, &phy_id))=0A=
>                 phy =3D get_phy_device(bus, addr, is_c45);=0A=
>         else=0A=
> -               phy =3D phy_device_create(bus, addr, phy_id, 0, NULL);=0A=
> +               phy =3D phy_device_create(bus, addr, phy_id, is_c45, NULL=
);=0A=
>         if (IS_ERR(phy)) {=0A=
>                 rc =3D PTR_ERR(phy);=0A=
>                 goto clean_mii_ts;=0A=
>=0A=
>=0A=
>      Andrew=0A=
Unfortunately the above doesn't change the condition: this problem is not C=
45 specific.=0A=
The call fwnode_get_phy_id just parses the device tree and always passes.=
=0A=
This is a sample device tree=0A=
https://github.com/varigit/linux-imx/blob/5.15-2.0.x-imx_var01/arch/arm64/b=
oot/dts/freescale/imx8qm-var-spear.dtsi#L168-L219=
