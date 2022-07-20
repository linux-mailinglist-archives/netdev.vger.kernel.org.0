Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8470257B001
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 06:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiGTEdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 00:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiGTEdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 00:33:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BE63B948;
        Tue, 19 Jul 2022 21:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658291593; x=1689827593;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y3ir6f9ZxnDXkki+nxWZsW0i85KDbpuRHK0BJu4A7Cs=;
  b=e76XCyVeUyl7uKUEg8qAMhrhDC64ijS2PPIwbAb5VMOj8jo5LIPNS6bB
   aKJVCIBwpxSiXlwRzg4tFQQqtX5sYvbUM2hkIAWYnuJxolK8TNWWaPUcW
   0xUFOEAlI11PExdZoxbID/cL0Kvs5tVizsOLabs2f9nd336Zr9gV2hLT/
   lw78+oaVdicsAo17wiFISLrkws0AwskB9Dp98HTxZ8Ri4iaQr94NhxBOa
   xu20rFiptjRXWG2ScmT9nRgGuUGmho1pTLDLCqKOJa6mrKq+Ku2Oz1Jka
   XZCOL0sWvHkZlKfhtFmiXDMlzIM01dgUn7Lozl3/z4UEaYeXkv/OTJsEV
   A==;
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="168647336"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jul 2022 21:33:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 19 Jul 2022 21:33:11 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 19 Jul 2022 21:33:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJQiwPiAWHEUoWZkaDiasKvqmMgcUdqsskRMcGZA/Wk1noybTT/dbNqGPXhujLzAo0PhzzbE3JfDN1yTdQJ0QI7ygUV1fAdlwgPrFzg+g/XS8TBFGp00J5KSOonQLOB6r6l0zMBoFEsCxA99yVImfGdCEYfHbjQIIkf8lzBfZaaDwy58twgmD4mrQ+zhOZcikBE3clzFxzqS80dt4+rnBUraksV+QGfV0lhFJfY/DKmTsMHwsaGi2siZ8wbbXzIVWTZeFFbxUxdX/EKjmCwziu0diy0rwVIEGjebfkUb2B2qdSk/AGmR7YwuFUxMTFcPLmy8qsLkuf4/bdNKWjqSYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=toNz+Zli6ObOjePtjLYPVyyOVFdvviW6l32VKBUxWQY=;
 b=Vdh8T9YV95J9YcaMd31P9vqJYh4mfJwNq+W+IhphNmVQGkiUVHc0enbrOqtxZ4qaysexiz0hs6QpwsSbRUFSx6bF1LMVMMgTfUxrU0uRQQO0LoxSQf4mxktuUmXr6VVvucm0iGTugB4GUZ2iQPhX0ISL/jH4v/vVrj8xICd3ITqs+1LsCMSyD2KI3+GSslq6+gn1BmXR0EwwpSpBb0KI4mY7oTyXCXdNW/6j6BrDMesFnMEkGTHAEJJy+2k5Dm5hD74XQXmN1mncZiOZSqLAlCRMTNVq3cpuSCvIJEpLeDAsKtJ5AOTvPbhuSEgAt5I6IfQBqFRRkNmUoO41aAxOhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toNz+Zli6ObOjePtjLYPVyyOVFdvviW6l32VKBUxWQY=;
 b=rVE1DmgLTCAmtKMYFfRIHIjn7ecqWjBraTmaMauTFmTtgPjqCK9gVuIZja2jvnUf7H/lxpUZRo+vG2Jh6MEC4wdb07AQIF0lgVIOnR2HLrRzNq0ioQsz3OWc5iuv6aeO3l7PFxj/Ob1c50R+7J/PFuCU0ZzX6jI9KgEvSRZn77A=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by BL0PR11MB3377.namprd11.prod.outlook.com (2603:10b6:208:66::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.13; Wed, 20 Jul
 2022 04:32:57 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5be:a24b:c331:3ddb]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5be:a24b:c331:3ddb%5]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 04:32:55 +0000
From:   <Divya.Koppera@microchip.com>
To:     <richardcochran@gmail.com>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Madhuri.Sripada@microchip.com>
Subject: RE: [PATCH v2 net] net: phy: micrel: Fix warn: passing zero to
 PTR_ERR
Thread-Topic: [PATCH v2 net] net: phy: micrel: Fix warn: passing zero to
 PTR_ERR
Thread-Index: AQHYm2dJBnESaQSQvUiimdDeatHCAq2Ft9cAgADzCiA=
Date:   Wed, 20 Jul 2022 04:32:55 +0000
Message-ID: <CO1PR11MB47715323651FBC994C4C918FE28E9@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220719120052.26681-1-Divya.Koppera@microchip.com>
 <Yta4BFfr+OkUmOhl@hoboy.vegasvil.org>
In-Reply-To: <Yta4BFfr+OkUmOhl@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98cc4fdf-2d21-4ae8-a5ef-08da6a08ea8c
x-ms-traffictypediagnostic: BL0PR11MB3377:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HDoLpgL21RlbIEoHntJWxOHhbBK+IdeHqETMXcZrkI0CyWLmXpDTcsMuBV7waQT8bXtfWNtvZXru394xMqAiaw5aJv6xzZo8huuwlH3aHKtDwW3OHMwiNXONib0SFdCFipwYV+BfnV90WkxYOQLvpyhh0mHoIV8hhO9+PuDyRJVvkVXJyyl6YhpCuSTgRlZLIIupaUdbiijCsD8y8x36PEaQ9VbKwcsCtTvXh1oiMtYRMwuZ73gvIqKTX0MBB5DSmj2GyjqBHr4/SHil1P2vNHCMneBX1mySUfNxb5R2SLUyo4AR6ycdyi11yMcaaGGRmQaiCqvTYGxxKsCJNVJI5FIDfeA/0sDe1F8kfRDaYVbKsxr4SmUgO4ABtcLib7MGt6IrIHb6DmOicB6jdNzA6DYePuOyJAUCNWd9+mlgAoo7DPE8rfvcH35IccBZvs09wV6Qfhz2OQmsOk9vr2e6BIRrvqD9B6f5yG4yv0H8/54UcQ0TvC2UVV8wH52sFFTE4y+NhN3oyQT7zINQDNcaA/ZgaZd7HvWBHi6S+sKTEj/HD4XtVoukbbwVmWOQH3MfRgD20tjb5w1O6q3B7+5y4mvcM94+PUweY1BvElH2Oy5E+glR9SYT1atKfBXz/RWU4sIWx058iNCv6HK5fIuGTnee3GKgl4fOvvgju+Fs40OZPmhCUvgm9ELcwDJKooz4XrGQ7K9d7amCPQHhW4+B9xerCBxxVMcmzYY8fZjB05vTGHstM6HU18lRaZeyK/5xP+zh5tm+ZGzHmrl2Ogv0Cyvfn0pHewp6xIrOnhq8jjTVqd6hmrsJQjQ3K2Ngz0PV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(39860400002)(136003)(366004)(396003)(53546011)(26005)(55016003)(83380400001)(71200400001)(52536014)(8936002)(7416002)(2906002)(6506007)(7696005)(41300700001)(5660300002)(33656002)(66556008)(316002)(9686003)(86362001)(186003)(38070700005)(6916009)(54906003)(478600001)(38100700002)(122000001)(76116006)(66946007)(4326008)(66446008)(66476007)(8676002)(64756008)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H5sa1uv7xhlSidQjMOYLl5ZoWRJZ1HpUOSPLkx40CI/eCBqULY9olV0F/nT/?=
 =?us-ascii?Q?cfBJ6rpABobLdJoB8yDvx04ga1ODQ4n24DPRJqNNcDrNMn+hdlivzr1D3ZZ6?=
 =?us-ascii?Q?aoNbW2C3uYLcKeRNachnkQ02uSBoXP6Fy4SwYBPnlydO+ly3hfanzdt/QNBH?=
 =?us-ascii?Q?lmculbB+U8wkxCwjeA9y26Wi097OKOugxA8ekWSUnLv0KnpGWQp4glkx65yi?=
 =?us-ascii?Q?x4xGqdXTKLZRD2Gk6SOVdVym3zAwtwUzykaq5mclwXuUH+8LmLXoHObCUM0o?=
 =?us-ascii?Q?suimmDMiGq3stKahA3/VjT8/vrBjkg/ITsLykZUkRpDxkSFAU92+oLzdvzlN?=
 =?us-ascii?Q?HsMDmJrr2SzAvtwKuk6zDfXPE7YaFaU7xKZxvfI5uGGW9RfWxXYtwMYiUvTi?=
 =?us-ascii?Q?KQJZfs+MqahdId1uJq9ARSS3Q80LJ0j2xlT3fZDN3MlGonnuOkZIn5+37Jxy?=
 =?us-ascii?Q?SKD9B77T2l2ZrBQzFL1FTp10iQ5RfmL9zi2AoyJLcPOnlBb09xMj2Ak7Srbr?=
 =?us-ascii?Q?8NygiFfrJHi0Hjs2C0KIjvRuTQTfrjmNWYqtOgTaH4FErxd2obb/A8tUhpuN?=
 =?us-ascii?Q?PRTYJg+KnYpGb+lGO82pBgHghkjyH69Xev9Ufy1nRdXqLrPRuaM+dGRv+F5y?=
 =?us-ascii?Q?MfkrYBTJiKIEKB8zkrtXpmKDpvKLkXpV2X1ZD6fMSG5M11zHKtv2jzKtBOTb?=
 =?us-ascii?Q?mKuNqM6ZtDUd0xcKv/YHGN1s53tFg2aOE+NUzgLJq4t/GLrtDSgGKqtYrpYg?=
 =?us-ascii?Q?z8w3q6zMFWaime/Jo2qdMhIciBIwjo+sNIu6XZjoekoK6VpSBynXArRMmX9t?=
 =?us-ascii?Q?zVzmYZS3BSrt9iQ4yMihf+YTjTCBUGZ7vI/Nvx9XJdSLC+djjm1TglkuFd24?=
 =?us-ascii?Q?JM25Fh6jLg6KveUIcu5QP1JuIOiCG4lX7FTlyIOw7i/HLyscXjvpTSOTU4WQ?=
 =?us-ascii?Q?RelgqYO9ZHy7G6MD9o+dH4cC9ThxjyYo9dwUAAVlShHIJ+8KQfhx2KvySg1m?=
 =?us-ascii?Q?OyaAQHud8xcDDZ373kR8XSHOZBC2ev6yZxLUdq5S/S0O/30KGvVnD90WHGCU?=
 =?us-ascii?Q?nzTXE/UgyeAJWDnlo7QO+sWDcOYcONv4wIpzNojXJTfzbcD+E8q1YbCiHm2e?=
 =?us-ascii?Q?1PKLk3HI58fxrjPuIWH2Csa3iKLrv9d603SFd67HUdr4excf8Ztbk2MQxGY8?=
 =?us-ascii?Q?j8Ou3e+ofUQ2fyjjLcT7L9xKndYDO7dQ7QArQ8+XsajdyseIQ8ASDVZpSIWc?=
 =?us-ascii?Q?rRRiYFHgtWdppbwxQ0OwOcoxfIBza4l8KWTZH33gcjhWnO2knEzUrH4KFXPR?=
 =?us-ascii?Q?J6pqdCQ6jG/2srBTj7E6CuXlTegesHeuuppq4cB8EMjLhHcUg6iByXhX/dYk?=
 =?us-ascii?Q?liY1OCRoP+OES2c05CWgdCXruOrVRabaAAU9MKEgWTSw2bUHhVaN08PA0VR7?=
 =?us-ascii?Q?8H9eF0gqvmaTRYhTblUFLWih3p2FGJstlgb6jIcsc3bBGaKmE8yyF3wQ4gAN?=
 =?us-ascii?Q?DwKTxVBDQNuBRBL5bkmw/wsdxZjfWNiFj5JHNUKO5BN3KjG/PLrrni+fzzWa?=
 =?us-ascii?Q?l/lFNUx7PoC54GRpc5WTcBnDJQzxX2lsY83fpsC7WV9p0M58N4vMfRsHVLVX?=
 =?us-ascii?Q?rg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98cc4fdf-2d21-4ae8-a5ef-08da6a08ea8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2022 04:32:55.3403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hGaXcxWu9TskHaMgKnPD28vRrvNaAoramiw8WJj1lX5WdBchrjWnBpCaHegBw3eBzM4uw/nqCvnOE8YAiMEUUBt5EfsNM4QXbzrL6I68oRM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3377
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Tuesday, July 19, 2022 7:26 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: andrew@lunn.ch; hkallweit1@gmail.com; linux@armlinux.org.uk;
> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>; Madhuri Sripada - I34878
> <Madhuri.Sripada@microchip.com>
> Subject: Re: [PATCH v2 net] net: phy: micrel: Fix warn: passing zero to
> PTR_ERR
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Tue, Jul 19, 2022 at 05:30:52PM +0530, Divya Koppera wrote:
> > Handle the NULL pointer case
> >
> > Fixes New smatch warnings:
> > drivers/net/phy/micrel.c:2613 lan8814_ptp_probe_once() warn: passing
> zero to 'PTR_ERR'
> >
> > vim +/PTR_ERR +2613 drivers/net/phy/micrel.c
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
> > Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> > ---
> > v1 -> v2:
> > - Handled NULL pointer case
> > - Changed subject line with net-next to net
>=20
> This is not a genuine bug fix, and so it should target next-next.
>=20
> > ---
> >  drivers/net/phy/micrel.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c index
> > e78d0bf69bc3..6be6ee156f40 100644
> > --- a/drivers/net/phy/micrel.c
> > +++ b/drivers/net/phy/micrel.c
> > @@ -2812,12 +2812,16 @@ static int lan8814_ptp_probe_once(struct
> > phy_device *phydev)
> >
> >       shared->ptp_clock =3D ptp_clock_register(&shared->ptp_clock_info,
> >                                              &phydev->mdio.dev);
> > -     if (IS_ERR_OR_NULL(shared->ptp_clock)) {
> > +     if (IS_ERR(shared->ptp_clock)) {
> >               phydev_err(phydev, "ptp_clock_register failed %lu\n",
> >                          PTR_ERR(shared->ptp_clock));
> >               return -EINVAL;
> >       }
> >
> > +     /* Check if PHC support is missing at the configuration level */
> > +     if (!shared->ptp_clock)
> > +             return 0;
>=20
> This is cause a NULL pointer de-reference in lan8814_ts_info() when it ca=
lls
>=20
>         info->phc_index =3D ptp_clock_index(shared->ptp_clock);
>=20

NULL case handling seems to be redundant here because at starting of the fu=
nction itself there is check for config support of ptp as below

static int lan8814_ptp_probe_once(struct phy_device *phydev)
{
        struct lan8814_shared_priv *shared =3D phydev->shared->priv;

        if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
            !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
                return 0;


So chances of getting shared-> ptp_clock to be NULL is 0.

Let me know your thoughts. I'll remove this check in next revision if it is=
 redundant.

> > +
> >       phydev_dbg(phydev, "successfully registered ptp clock\n");
> >
> >       shared->phydev =3D phydev;
> > --
> > 2.17.1
> >
>=20
> Thanks,
> Richard
