Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C4A41DF92
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 18:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352374AbhI3QxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 12:53:01 -0400
Received: from mail-co1nam11on2075.outbound.protection.outlook.com ([40.107.220.75]:16835
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348841AbhI3QxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 12:53:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXz92w6UhK6Ux1zyGm84HC3mdO9VYjs98B20v1TyR2zxUFCFAaDB0B2Hup+1SF6OOLuLiGNILwb0PP7qv9qGRJ/eP/cVVlEixEmWrPCIu2M4hwF1TT2/9Dmu2PR85d1fhk5/DE0mQa2oYUa0ytnHeU79qGuc3u0j4Q4nO2V38juUXWYaFEzuLSzknQqrFOAXBWDeYyMMDvWQ8pOUyVKu34gZ81gdMZ3zs940kg2srWBF8eVKzZqcicWte5ATzmK0p2tIXFE2cm0VqX7w4+67B2chN7oToMy/6AYU+DQCz2AEx1fHMBbTFgMi62bxHTHybDN0lX7jx2kLeXDIDDKGDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1Brt1fDPPt4N5kVu9ctsplROTbl64V512WvAliRfKaQ=;
 b=RDTyXvpmxT3iSyxt+G+DSVfGPnZENx7QyvJGmvKkkO+UbtmD71APNbqMmWD5zPHt0AwtiMuL76n6NTp+/GlmVQwMFQp+o7hx3CXg/JXgNkWmJ4MsbHiCL4TGW/NqbXKh8hwYsVJOqeW/OI3Al4lMJf6qFJSmDlRdacqnz+FAFLQU+qcpUxzKjUDZk6oJGBgU5VK6q6o7vXnvEW1/Oc9WQ97Ny3k/m6KYvSf2sKuA41gaVOzrfHP5zDPflVEHC/5ku5Hw0XdPgWsvDNVuG1P9rr/q4uGWvWLL7jJwGf0ClLh7qT07UcJSpHnhF0/oB5+TP1Ai88fjcHxZ9cYhpysEkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Brt1fDPPt4N5kVu9ctsplROTbl64V512WvAliRfKaQ=;
 b=KPfjET3UyGrnhSV54aGZeNLFeCWqm/39IcAfHP8kElyNypYWQd68mbcGQK8NPohXj2iSniTlDMEtEbF3abi0+U6naN0IbRDhGWQRwlSY1JI4QL0K54MFpy42uxMsfzMCpOLWYYuLpDmy7WygrrMX5WqFW833rtHpSgGz5arMzgI=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5644.namprd11.prod.outlook.com (2603:10b6:510:ef::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 16:51:15 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4544.021; Thu, 30 Sep 2021
 16:51:15 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH v7 08/24] wfx: add bus_sdio.c
Date:   Thu, 30 Sep 2021 18:51:09 +0200
Message-ID: <19731906.ZuIkq4dnIL@pc-42>
Organization: Silicon Labs
In-Reply-To: <CAPDyKFp2_41mScO=-Ev+kvYD5xjShQdLugU_2FTTmvzgCxmEWA@mail.gmail.com>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <20210920161136.2398632-9-Jerome.Pouiller@silabs.com> <CAPDyKFp2_41mScO=-Ev+kvYD5xjShQdLugU_2FTTmvzgCxmEWA@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SA9P221CA0010.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::15) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA9P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Thu, 30 Sep 2021 16:51:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5049ece1-9f55-44cf-5c67-08d9843283e1
X-MS-TrafficTypeDiagnostic: PH0PR11MB5644:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5644589A68C4F30F318CFF9393AA9@PH0PR11MB5644.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKb5yy/7IZibqKPno8ZshaLkDTQF/vZFQ4ZMC0N5ZaiD6+LH+UD8WEuW99x5CYyndhWTYU3MHD6w7aUTBhNH+svHQjmY5kLf7VOlVr9y+Onklma088prO85Wpf2tX+WqiRy4OJGCoSlRkb2epRTrU5I8+VJ7hsJsQWlEBYA/ZUrPmP99tYMx36FFLIjbi9J8MB5sFZVUvghM4CWpQiUrf1p2eWZ5mzRFysln/cYO/byO7F22kGb2XGc7NStg4WIwcaLSxrJInPIirOslp4hLUaEQ2cN9VzeQqFivHPP/d71DX2+IBNzK9L/KTOcQzB8YZ1NROeL0bGfrHe+9yuL4JZo/8XYeth7e5nL9vMxQMJjaF5rjMnrjdadDAwUpc8yKpg2/ZgeOxUzFjrt4iKCFwGbXxrMVt5ty5sQmSgf4Nwjp5196HUOAraK40KoXooLVJY0SmDm8IBOC3aV75jTccVTE+yWOSzBmYRIzesguFxz4lX53RU3V2kxJfsZarRUeWrzjFtZjJgK6KNX/hxPfIQPkySzM/yOpw4HgefgzqTdYZcgx8DBlZG7ikpM/CeqamGf1dA+v+9p7uUjoWxhBTxBTnQBaKCe4QNSt2NjUZXDbuQAwEXrwRAzkieBP1VXV3+tkD1XAChG/o+KIM6+9HzqmjkFO07MVvpUFCLQ6c3LZBjcHwBnBQRnRD1aDp3s9NPaTw7b2E3I3VwlO6b7/W801Giu5L+ejW8sy3mzhabDJKtThn2XyfXwkqurFzSWoRoGTJL/0LhiQT7ectpwHgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(52116002)(6486002)(6512007)(54906003)(6506007)(5660300002)(508600001)(316002)(66574015)(9686003)(6666004)(33716001)(966005)(2906002)(66556008)(186003)(86362001)(38100700002)(4326008)(8936002)(66946007)(8676002)(66476007)(83380400001)(6916009)(7416002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?YyP6Sz9l84Oa32OmYnsqa0W3jNawHWlroCcNKBmvQ6lkRQWo7qOko0f4Jy?=
 =?iso-8859-1?Q?+BCTvg+V81vFIQk8LgEVys7J5MGp3GuqGMUvGV7iOdvs6q7OdGHCDLnZ/W?=
 =?iso-8859-1?Q?NHbjJiPy98XA2LKHwzpZ0hh1hh+ZZpNZR7AQUY+9wjVGaCPJ5WZRH9s4Hb?=
 =?iso-8859-1?Q?+986lXLNBjcqP08VIsjH94RMiQxXfk21es+SqCp7W2xOlLfcQuslJ2gw7k?=
 =?iso-8859-1?Q?fkpb8AqdHYiJqHNvSFj+7jlEny0FGHxSzvxvXUK632ZZ1ofSx5ud6eFNbN?=
 =?iso-8859-1?Q?/1iDliW9qQyfNsu/YfQGNdJfa70pqyNt5gGpsjLeQAwu1SktBHtoVnQA0V?=
 =?iso-8859-1?Q?aau8kr4O4An8u1pITUy8ZFpP0JHyHFu+EhWQ6cX3PXMQvIGXVcHel4ha/I?=
 =?iso-8859-1?Q?ZsuxXx/g6D/b3R12TiLH3TkC4wKN6THSve4fOieHO+BFac4M4Q8b8E7fqH?=
 =?iso-8859-1?Q?ThP+80jByFzscBrzIJJdiN9B6Mr6SOBP+I4XxSAlC01Htns4jaZJtizKsG?=
 =?iso-8859-1?Q?OPS0bUotZEKBbH836CcNs849qcZnWKDjfr6P1TmPaUuj8yjkXkGDdYMA2G?=
 =?iso-8859-1?Q?yJ0pfvWwGf30aQJqrnuUyI8Zw9qPbZG0pnq7OI+qnPMrm2INZc4IxoTolD?=
 =?iso-8859-1?Q?BLBKz+VNYP6CoMYlmaWHCeITunc7DqbVntR1dXtOM7nAnsTRuAsYhqMDvo?=
 =?iso-8859-1?Q?JEESUPNEJpudCR2PmhYlGNQsJGD9v2yZ+AkiNmWIBDg+5eZ8339eeWl+30?=
 =?iso-8859-1?Q?Fplpys5d8u40gTHzapl1GJdaj30qSA/wqcJbYYTbv13q7+7etJMvT+h7no?=
 =?iso-8859-1?Q?JGGGFS371zXcgAP7uxkcXQ0w/3t53aRz//xNh4vrExbRcf360LPJhXKUl+?=
 =?iso-8859-1?Q?UgKlssyrv2IEHPSSfHWRGUw5lo3CVUw24p34UWaARduvOoxXNY6TsfidlD?=
 =?iso-8859-1?Q?OS1alsSbymnfV9Verc/7HKwvuwaIkKnpWx121fDzzrS2aZCIaZoy38at7z?=
 =?iso-8859-1?Q?9GhY92lm1f1Pcj377H6DvzKDGhkgXpnofc2O8xHvi7pwlCEBKffVsjrAhQ?=
 =?iso-8859-1?Q?dkNlZfX+elCxDxAGGfue0zMemXDXIubeODXmg5RF3xsoRPXbGyh1PpF8Oc?=
 =?iso-8859-1?Q?jlwkcl7sRoNmoYjNeH5BjWPOyQLe9Ik1YyQ7Ngqs/cGrB4k51cztLq38Bv?=
 =?iso-8859-1?Q?TZV9Hd2iHbr5uebh5o8uyBajwHXjyQI03sgHE1uYhFMUXu6UQ0EjddqC9u?=
 =?iso-8859-1?Q?M8G3E1gb3gNS6yqucf8UM62D119EfnIxIa7eiTbVzbSuPzhyCZ+rjeNfSG?=
 =?iso-8859-1?Q?9+4TVDZ6V+lm5YJKZ3zDYg/1ZZ4yjjVy/MKBuhBs5CXt5fJ10D9zSPx8dv?=
 =?iso-8859-1?Q?33Av1EF5rTW6NBoNN161U390s18AqosU5spOSJHmwjV4qzuE6UlfzCu3QL?=
 =?iso-8859-1?Q?ztTHBAYmB/C4P1qO?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5049ece1-9f55-44cf-5c67-08d9843283e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 16:51:15.0285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pzoP39Ei89GQb2qx93Y2ZzIatZ2aJMgtSF6Dx/shDjdkzaCtwy5RvRziT708ocDieyVs9iwAY3Ad+psoHSYcJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5644
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ulf,

On Thursday 30 September 2021 12:07:55 CEST Ulf Hansson wrote:
> On Mon, 20 Sept 2021 at 18:12, Jerome Pouiller
> <Jerome.Pouiller@silabs.com> wrote:
> >
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/net/wireless/silabs/wfx/bus_sdio.c | 261 +++++++++++++++++++++
> >  1 file changed, 261 insertions(+)
> >  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio.c
> >
> > diff --git a/drivers/net/wireless/silabs/wfx/bus_sdio.c b/drivers/net/w=
ireless/silabs/wfx/bus_sdio.c
>=20
> [...]
>=20
> > +
> > +static int wfx_sdio_probe(struct sdio_func *func,
> > +                         const struct sdio_device_id *id)
> > +{
> > +       struct device_node *np =3D func->dev.of_node;
> > +       struct wfx_sdio_priv *bus;
> > +       int ret;
> > +
> > +       if (func->num !=3D 1) {
> > +               dev_err(&func->dev, "SDIO function number is %d while i=
t should always be 1 (unsupported chip?)\n",
> > +                       func->num);
> > +               return -ENODEV;
> > +       }
> > +
> > +       bus =3D devm_kzalloc(&func->dev, sizeof(*bus), GFP_KERNEL);
> > +       if (!bus)
> > +               return -ENOMEM;
> > +
> > +       if (!np || !of_match_node(wfx_sdio_of_match, np)) {
> > +               dev_warn(&func->dev, "no compatible device found in DT\=
n");
> > +               return -ENODEV;
> > +       }
> > +
> > +       bus->func =3D func;
> > +       bus->of_irq =3D irq_of_parse_and_map(np, 0);
> > +       sdio_set_drvdata(func, bus);
> > +       func->card->quirks |=3D MMC_QUIRK_LENIENT_FN0 |
> > +                             MMC_QUIRK_BLKSZ_FOR_BYTE_MODE |
> > +                             MMC_QUIRK_BROKEN_BYTE_MODE_512;
>=20
> I would rather see that you add an SDIO_FIXUP for the SDIO card, to
> the sdio_fixup_methods[], in drivers/mmc/core/quirks.h, instead of
> this.

In the current patch, these quirks are applied only if the device appears
in the device tree (see the condition above). If I implement them in
drivers/mmc/core/quirks.h they will be applied as soon as the device is
detected. Is it what we want?

Note: we already have had a discussion about the strange VID/PID declared
by this device:
  https://www.spinics.net/lists/netdev/msg692577.html


[...]
> > +
> > +static const struct sdio_device_id wfx_sdio_ids[] =3D {
> > +       { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF20=
0) },
> > +       { },
> > +};
> > +MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
> > +
> > +struct sdio_driver wfx_sdio_driver =3D {
> > +       .name =3D "wfx-sdio",
> > +       .id_table =3D wfx_sdio_ids,
> > +       .probe =3D wfx_sdio_probe,
> > +       .remove =3D wfx_sdio_remove,
> > +       .drv =3D {
> > +               .owner =3D THIS_MODULE,
> > +               .of_match_table =3D wfx_sdio_of_match,
>=20
> Is there no power management? Or do you intend to add that on top?

It seems we already have had this discussion:

  https://lore.kernel.org/netdev/CAPDyKFqJf=3DvUqpQg3suDCadKrFTkQWFTY_qp=3D=
+yDK=3D_Lu9gJGg@mail.gmail.com/#r

In this thread, Kalle said:
> Many mac80211 drivers do so that the device is powered off during
> interface down (ifconfig wlan0 down), and as mac80211 does interface
> down automatically during suspend, suspend then works without extra
> handlers.


--=20
J=E9r=F4me Pouiller


