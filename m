Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB9D60548B
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 02:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiJTAkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 20:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJTAkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 20:40:20 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2104.outbound.protection.outlook.com [40.107.113.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FE332D9C;
        Wed, 19 Oct 2022 17:40:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfK6ZWb1nvxBZ2i/7obkGXPLoidIaYzM0WuYplx2/jKLDk7dzCUj1khmSKSMMy3BCPPxrB3FsXIxg4mWuynY3lL2LQ/61GW5Og3J/VCdfpyGJ2Em73fGPdMW8smtI2orzECNgBJGCF4IGLoW8wBdHrwsiaAvhofeAc5BPtaHgrLy0DBNFYOCgUnZt6xCIwWf6VBj+enN41fCpmNSPxGKAcCvN0ifVo39EXUxuaNxBci53/MZfENewzbL+RavxnsHhA9XJvwbqMQ69u2LroeVOHM7bJTdDNJlMLSyhqvPoPfiPxt8lR/4CcNrtJ3KpBbj7hjX2D8FSgv20hZoBSvFzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r0/X3P/B9Wwp00roju2q/2B8wy5Zgl1YNKrYeURg41Y=;
 b=IVlYZ8DX8ZeMyQ2cH64KhavqBird/jIJ7rwVGrH4CmD2PMzZkZjT3J1YUcgSmT/LZbYhW7JUVG34VpWAv1b+8BLytPNv2BygUdM+blctj93hO13VN+TIZSSw2PvBU3zSsDR6bg9WIrG438KbPxpHGiuy4SuNgFeY2DH3n4yUwgQucthQi7NwQETNMfzMDcsSL/DRJY83zm1+/3n8w27T9RmnFsOsi6pO5MEAzYmPX2mfYdiD/eyDE6bPWCmXGZjC157hUczAiUxS+uP/Uh9EPeftwG10Iodc21WjlxcaQsBpiP1AmG95Jk7xnuNYDDCF/bTK7BeZ3kUS4UIC7Ep8vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0/X3P/B9Wwp00roju2q/2B8wy5Zgl1YNKrYeURg41Y=;
 b=GWj3sR4Jeo9s/WvJYTAFcvoMrlUELYvh6YL7BmZnlq0zlGclztHIgUGnNCvsI726U1SN8lizlOOC4ERBJhA7wcCw4Gdadh+lIq4V9bph26y6Lw09o9ICb2zUryWZPjf773PNEqD+FJLx0N+d5wu1n5J7CBdZywbNA7xXoG1uS9g=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYCPR01MB5645.jpnprd01.prod.outlook.com
 (2603:1096:400:b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 00:40:15 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4%3]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 00:40:15 +0000
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
Subject: RE: [PATCH RFC 3/3] net: renesas: rswitch: Pass host parameters to
 phydev
Thread-Topic: [PATCH RFC 3/3] net: renesas: rswitch: Pass host parameters to
 phydev
Thread-Index: AQHY45fxZcxBb81100yIMNCQyuXE8a4Vh14AgADp/sA=
Date:   Thu, 20 Oct 2022 00:40:14 +0000
Message-ID: <TYBPR01MB53417E452421A54E73F8C965D82A9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
        <20221019085052.933385-4-yoshihiro.shimoda.uh@renesas.com>
 <20221019124100.41c9bbaf@dellmb>
In-Reply-To: <20221019124100.41c9bbaf@dellmb>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYCPR01MB5645:EE_
x-ms-office365-filtering-correlation-id: f9cf898e-d1f3-4766-a443-08dab233a786
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G9iqPiOwYw4e2Kb5eWDMErviTmHlwtPINEqGbskZPpHdBlZVTKbOFSvIYvBJM31kT0/tglv89yBO47kKGEzEPCirI4tozMB9tkfOFCp+kIek1nWqAJj9K0913LJPA5CN+9LXc142QB4hGTyJumuu0r6vgETKK1yA/vuIKQ7aKNP+r0RAwjQfgVef1fZbTcLiaLDtIrxNGIWuAR3LDwj4GYcehO+jwBhAPhvXjPB3zlTAES9aBtd8AOjyT9/VYIv2yMoXmRXgSdWVScF1zSSJPAXZJlt1h7dNn0eDs5Fcc6VXTySof4/nGMDTQ4JFfKNqH8aZGTrhPgGOs1UAtTinQK9TQCGXLYjpRitRrteNsEymHUMCDDkPX2WjmBDL2jbMvanq8gJsDon7y/VvYcZW0N+oGtJlmImrtXiXYwL26LK7vmxDNFbIv0+Yvz1T6JzAmqR9MeU4NaP3ijsNHw7+J/LcJo+tlT1wGmvVFda0BQmGllcZVXwO/Yn6cu4mFhZGijHLGHTfVuGmZCD/Y9wT7+u4D1ez6iYZQIpq58nARDK5Nz2clxQRWoWZepKcYHEI7XVUltjz7Bg8exKLZM78oMDZXUVec2aikPdirAmk1cm+A6kVL2TiIQupUXzqfwXa/tzKTljtzC9n90wW3tEdFeS/0lYT/K2ubASN0irVmZMGq0VEx5ZAc/g7oCJGhGspCmrYvtjjrSO0ZDRWkbSbIGpFvE+imzG6sYl2TExISMwBoCRviVki197oMpePNir7P9uVMa6t8lD7iN8byAlj8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199015)(122000001)(38100700002)(41300700001)(6506007)(54906003)(7696005)(9686003)(66946007)(76116006)(6916009)(66476007)(66446008)(64756008)(66556008)(8676002)(71200400001)(316002)(33656002)(86362001)(2906002)(478600001)(4326008)(55016003)(38070700005)(186003)(5660300002)(7416002)(83380400001)(8936002)(52536014)(66574015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?PE0QKjPm7/5ngVMsEdhkgdWPYtb92/UIOwBJ9qqgBd7CgM/Vzo73CyCZWr?=
 =?iso-8859-1?Q?37mQJMc7vrQZCmXt18Iu5pHQR9EIMW5ojD4yvE7bNE+nTBKaw6SYQ2jFBb?=
 =?iso-8859-1?Q?2BfWv2EeLCpt/DvHjcefIDDTIlRh1CdDk2Lz9cotspUYAdnGfAl5mfMdmp?=
 =?iso-8859-1?Q?QU2Mmv7m2DXf+5fJ75bWSgScAxQzKw8Mq56l7QT05Vz08PMOcvUiBoVVsL?=
 =?iso-8859-1?Q?7PMEIPh/1luwgmYrS4r5c1RRgaAmv9T5Eg538wbeoa9ys0lkAq0bIY0+Lh?=
 =?iso-8859-1?Q?6xEz9orBCFq0zreLBi++c3aUhbCXDUWP7ePGG097/r4hWss5UBKxw2E2Ve?=
 =?iso-8859-1?Q?DTMgs95epK9syjqJ6zEFBlKr23n07Wdp66JUno0/XGJaqh7H04EKukrPSK?=
 =?iso-8859-1?Q?JV3laF7Em9EmitYx4LuLYM1ukHL11sGViOYRn4NVmGG92SMV4il+KU8D0X?=
 =?iso-8859-1?Q?2E2XbiCbjqguatAVeZZeWyIMOgfgcsIo51e70hc0Ms9yrZjt9WH96/oOfE?=
 =?iso-8859-1?Q?OTAXdyRlxzWy4bzoV3KEG3Gnh5K7XzxvyN4uUgKjgdZG+LkTuQw6hJjNin?=
 =?iso-8859-1?Q?CvYrzKgUcJTJSQnX4hEETlRcbQ4MHDgXkLZQPCB6WwbRMMwLNjeRhdqfMI?=
 =?iso-8859-1?Q?zjW7E3sI7oJM0Qz3iObc4KwesMJQMS20lrOYESlZ12mFJynSb+XMX+Gfas?=
 =?iso-8859-1?Q?rhodv2JsfzXCPw4NLfUknjqBzPUCV5dG4LjYW+I0srQChBGmExB/9hKCgr?=
 =?iso-8859-1?Q?ExYMZ/VEqA2Pdz04Ful6FjDJxFjbHQ2dPocfd+Jew6j7aXVK/X6qNfr2ku?=
 =?iso-8859-1?Q?aTTg6YUPsBDqKcMEGZjpBjY5ZsmLhLvsI+MfxWCODRJUXlZOm3xZYOh67j?=
 =?iso-8859-1?Q?g0qE+oHytTf40dWS/XRXzUD0gYYwsjCqto32qntcKQlUtV9Ky+7bZYnE8I?=
 =?iso-8859-1?Q?vohymF8f6MUW9g05NBoxcvHtclwDoBJ/cTVwVto+o0s942kSaOLtbKLNfQ?=
 =?iso-8859-1?Q?l6tVDE1cgYOGwEX65UnX5xrL803M3zuwPuedDZWzr3yFWyELcD7UKsO3vJ?=
 =?iso-8859-1?Q?bxwbpzfKtAAcgeinAO+X5MCKgq6RLvCPda1Wdzf30o+E9dDDXHKlGJxk3K?=
 =?iso-8859-1?Q?q8RIFJEfXt00UWiP/OVlJ/VoKQOyd36+xNDs6cElaPM13lIYlnPk5tKVHF?=
 =?iso-8859-1?Q?zS9wgeJ4iOtHn0ZL6LV0F60HB40G0sTN4X9uy/fYE+xqr/MOzEsVJ7t+4r?=
 =?iso-8859-1?Q?MSP4LJ8g2vDNeT3HivrcnU8g6lsEtBhd6Fkmxsgs23hRNyrwM/2XpftI7M?=
 =?iso-8859-1?Q?CpNlo7c7p04Q8O35bP2EjPXd2033IymMRScSuyOi1nctrRCejFlcPna5D7?=
 =?iso-8859-1?Q?YOT83dkmqnAhxNvQb0vmwsfSfLrxZ8lO0dMtS5SJ0Ig2ec5W2xFjxa2YQA?=
 =?iso-8859-1?Q?tmDPWyeXFiUvrOtBAErItvKdTsSow0CZM/ZRku2LT+dwTUiDuZfYSRk54d?=
 =?iso-8859-1?Q?jZenHUj5ZcxDinmt++3TkOCXV5rxkU1rRzhncNNWsTdEiajrvCJYiB8sE7?=
 =?iso-8859-1?Q?qg7e9RH2mieyiDpnYhA0e8rn7bujG70pUN6brqjrGBUUDqzaDbRSzfO14T?=
 =?iso-8859-1?Q?279R4PuMYzIbAz2xJ1caf+AK9BRO2NXObhG80LEpbi/FQiN/UMZJyZZep7?=
 =?iso-8859-1?Q?frCyn1zaK4VHtiTg17IXmTbY/s7f83N2n5pBV0v3c7Qe5PHB736A9LjIIw?=
 =?iso-8859-1?Q?znHA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9cf898e-d1f3-4766-a443-08dab233a786
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 00:40:14.9729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F21B/avxNIIJ/eVdqFNxRPr5nAoauRdzDtZkIAqkFTx2up7OTsaLwZd/dKvyngjKKyIf2Jg2QprGmralS/9H5JXd+Dc8XKhDF+3vZqZz9g9kl6F4TTIDThpHW6mMQsRr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB5645
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

> From: Marek Beh=FAn, Sent: Wednesday, October 19, 2022 7:41 PM
>=20
> On Wed, 19 Oct 2022 17:50:52 +0900
> Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:
>=20
> > Use of_phy_connect_with_host_params() to pass host parameters to
> > phydev. Otherwise, connected PHY cannot work correctly.
> >
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  drivers/net/ethernet/renesas/rswitch.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ether=
net/renesas/rswitch.c
> > index c604331bfd88..bb2f1e667210 100644
> > --- a/drivers/net/ethernet/renesas/rswitch.c
> > +++ b/drivers/net/ethernet/renesas/rswitch.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/of_irq.h>
> >  #include <linux/of_mdio.h>
> >  #include <linux/of_net.h>
> > +#include <linux/phy.h>
> >  #include <linux/phy/phy.h>
> >  #include <linux/pm_runtime.h>
> >  #include <linux/slab.h>
> > @@ -1234,11 +1235,19 @@ static void rswitch_phy_remove_link_mode(struct=
 rswitch_device *rdev,
> >
> >  static int rswitch_phy_init(struct rswitch_device *rdev, struct device=
_node *phy)
> >  {
> > +	DECLARE_PHY_INTERFACE_MASK(host_interfaces);
> >  	struct phy_device *phydev;
> >  	int err =3D 0;
> >
> > -	phydev =3D of_phy_connect(rdev->ndev, phy, rswitch_adjust_link, 0,
> > -				rdev->etha->phy_interface);
> > +	phy_interface_zero(host_interfaces);
> > +	if (rdev->etha->phy_interface =3D=3D PHY_INTERFACE_MODE_SGMII)
> > +		__set_bit(PHY_INTERFACE_MODE_SGMII, host_interfaces);
> > +
> > +	phydev =3D of_phy_connect_with_host_params(rdev->ndev, phy,
> > +						 rswitch_adjust_link, 0,
> > +						 rdev->etha->phy_interface,
> > +						 host_interfaces,
> > +						 rdev->etha->speed);
> >  	if (!phydev) {
> >  		err =3D -ENOENT;
> >  		goto out;
>=20
> NAK. There already is API for doing this: phylink. Adding new, and so
> much specific function for this is a waste. Just convert the rswitch
> driver to phylink.
>=20
> Please look at the documentation at
>   Documentation/networking/sfp-phylink.rst

Thank you for your comments! I'll try to convert the rswitch driver to phyl=
ink.

Best regards,
Yoshihiro Shimoda

> Marek
