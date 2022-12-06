Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6D5643C00
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 04:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbiLFDzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 22:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiLFDzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 22:55:03 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BE815807;
        Mon,  5 Dec 2022 19:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670298901; x=1701834901;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=smhFXqjzLDvtAWCOhL9K5FcMQMyL2lwxH5K5IwxAgXg=;
  b=cyYwbg3BWRxORYBh3PiE4oYj4UduFne8oa19TXpzLOr36N9h2U6YbAKj
   mAvNQ4Zrsa2rjC0IrXc1k6zK4yFPMnHBnP+D8ZqTSH+27hCnZhQ7uAOzp
   attEAfIET5tqQiXDTOF5I3uK/1hm232Csjhrwkj6/cFSw+bpgj4Na1vmT
   0ebgUNws4CL8flcWm6Ol2gjHGTfLNtvFPB0Io8XEWbRtQ70I1PzHMtRQ4
   oy7w/z6lz1flSF+DS8V12bhBQVAsHkOpwJA57s46+pFnBdgsxJ03zDL7m
   wY+7eTSfilv/q+XFqWTxJMTlcVwTOmB9Q6Nd3zArvyFklghMc/NL22Ulg
   A==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="126652084"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2022 20:55:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 5 Dec 2022 20:54:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 5 Dec 2022 20:54:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6j4pkcBkn/dTVWcHqnT/RFJyjr+C3IIlTxFHbPqvreQKT/lg30njfftlwtixGAHtiCBQnzZjmicSF7NmhWxEhddMRq0KBxe/QA8Lo1yn+XLQF2HW8LIgifppVsjzrcp23fsaWfw1XMisKieWTVdnPDA7HjY9I7z45ID+WCDghwzYFsF8zivENajJji2Ny7Lt370MCkTimlwJiMHZUZmLffbRBDfJCRpGA/upukBHla3gpiVlXMdbDZD0xu/iqNEQJqRYehnUCmRYaVDC1GuXJjKlS1LTQ+NNU6ig0HK5DKuo0jCQZVdAtk9oCwvgk06ldHo1PoQZqnNX+Wzc3yvNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50QIt3Wu9fYP3l5f9ZgljknlIDWaQq3bx4QQTp+XD/g=;
 b=g20wYoBaWogYnHf2d22N1MFSNA/h3RWJ6qj7Z7RwcPqZSI1ADP0Th+y6q9BWg8nELRgSx/vOeUnmnC9vRo/QjDeh9jkGBPqaPaUOiOzhTLgzyHjZ7AGn8z3L37LHUHqS9e6MbsKxyVTdXRqO1eRF8zrznFX3H6zolUJRIexjKB461u6GNwSwnAkvY4cDY1D5DOVNh3ebtxkbmxsNq3Q+vxtf8R7KLkmKgxVaLXJSfgXkf8nNnGyigrp4HYR/kM4GypUODJtVU6b6O6JgeB7/hmGDi2hvuRGlBBgU0Z6TXSYdNLjc7YMsLmnOpEzDmWkFwnPp5XMufXldt74O8vImpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50QIt3Wu9fYP3l5f9ZgljknlIDWaQq3bx4QQTp+XD/g=;
 b=P5YeXEAEIgf8sxQGSOEhsv5nPAlRnnM+LIlcr/ayKOIwyU3REt4xpYZJvPWIbrvnOCaHh5Hu2s4F33EMBQsTBDE2piZxvEETCeqB3BK2a0Rwf0etq7o6BcffG3eqPYFhYK4lz6GglQNXsxMlYYXXfIJpRjYM5tDk+DHKcHXTOZU=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by CH3PR11MB7819.namprd11.prod.outlook.com (2603:10b6:610:125::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 03:54:57 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::97f3:ca9:1e8f:b1e1]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::97f3:ca9:1e8f:b1e1%5]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 03:54:57 +0000
From:   <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: RE: [PATCH v4 net-next 2/2] net: phy: micrel: Fix warn: passing zero
 to PTR_ERR
Thread-Topic: [PATCH v4 net-next 2/2] net: phy: micrel: Fix warn: passing zero
 to PTR_ERR
Thread-Index: AQHZCJVv3bBjy+j6lE2XjF4N4A7sva5fTaGAgADtbyA=
Date:   Tue, 6 Dec 2022 03:54:57 +0000
Message-ID: <CO1PR11MB477119863F77DCC9198D0947E21B9@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20221205103550.24944-1-Divya.Koppera@microchip.com>
 <20221205103550.24944-3-Divya.Koppera@microchip.com>
 <Y431PXknftwxwX3f@lunn.ch>
In-Reply-To: <Y431PXknftwxwX3f@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4771:EE_|CH3PR11MB7819:EE_
x-ms-office365-filtering-correlation-id: 733d7e8a-c97e-4658-08e0-08dad73da40d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O211Y5EKm/ss6PzorgIof7frd3SuahyHSrOdiGrjq1iZd2VFPf0nO7sCHFuQDd+YKR1bQf0W36LRBNAiE/zaNnokfnYCcLc8qAyYk9DEUTf4PTiMUs2lu3qxE34LF/atD2cZ2C1miSuryYDyha60PXAXdAl2+OXMyQ44R6ftT8jWkGVdDEWOsm1q6hqpl0DfeXEMkE2rczHwXvzBtp0ogMogLYJVC179gFJKNih2yv6DWDM6u1Wjl2v61kLjSPz/QG+su+wAjhVp3f6gu0UztOW7sRWZ4wYGuYzuInVyTpxQCbhFfDR/Ob1biF12/dn1bwBlDHQutsykkz+In47scQC0oTaPKfhaRv685b4AUDceAfHsg2XF5Ro4RrglnHjM4ZPyb14RxIJcHlVEwr7DgdbvRhXOyfpsED7rE2SKxuebySOM156K00ystwnVoppNipJJIg5KCCJ1D6CR2kx0MXncCW2D3vegY+cuWsmUmumcI5F4lfKfUm5AkTDXq4SEOeLPe8y2/XY7I7LNHlNePIbJdl2gjZoew+t8ftZf6ZrT8jeDSveMiKHgffLgKz8bcZZYmm4dudi2ukI5JbXNHF7iKAGbe80ic2gey5UGs9tMV5CmnJaXLSy7tfwU0BchRkDkpSIkoQHcwZkaqn83vae2eY4V2fidgTvw4WFBTbSeOsqO1v54BtVAlm2J4nkED5dsAOPCa67audh/Lf7yNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199015)(122000001)(83380400001)(33656002)(86362001)(5660300002)(38070700005)(7416002)(8936002)(2906002)(41300700001)(4326008)(478600001)(8676002)(52536014)(55016003)(26005)(53546011)(186003)(7696005)(64756008)(6506007)(9686003)(107886003)(316002)(6916009)(66946007)(66446008)(54906003)(66556008)(66476007)(76116006)(71200400001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jM/5aqQ3YK1/PTOCKk4jQ6nNngVdW2AeT76RSMhxH6yEcGvLCb83NbwFmcR1?=
 =?us-ascii?Q?lZ81IDZVAG1SCWfppWS6XJXN/7irRdsw9J6Ihm19YZs8mahhlleUtwH28iYJ?=
 =?us-ascii?Q?Sfk3BUI7L1uhDIUwtdeMH45foRi5qV4hBbIDqaI+pd82qGNjA9yIUmA/HcF9?=
 =?us-ascii?Q?rpqnBXqtPZec48sLROU63jTI6OgLR6vcRPajw54ifpSTN0gT1eVz6tb3aNbM?=
 =?us-ascii?Q?Cx+f0dDmEZcTLnWb+ZeZlpD2o3ssOtmH9iX8/OJ9GJgg/Xk6TwJUnzZVQZim?=
 =?us-ascii?Q?jo+i/rFzLuVNpJcq1LDZfh+AkuOx0QuZ7z/a2QjQ7CSm/yG+FrwdrfX4q1oR?=
 =?us-ascii?Q?up475I7pR7g8onL3LWc0xWhPexNPzauB8WjZKvK8CguYp0fkdCLGKOsXfHe4?=
 =?us-ascii?Q?NpKaFKBM1kBgsG+4ZaXGnat28xLeMBUlhN2wzQRYLhC3VveStbRFKS6m89oz?=
 =?us-ascii?Q?WH0fjnoEn6TP8748eo2dOT0Kn/q88+GtlT+ou8uWv/TI8k+xZEbyLEPwYzGU?=
 =?us-ascii?Q?uYiNyrO9iWGhAULF8vph2/9j4DA/IVbpKAtdF7Zqg75IYl0A++KeOkco3qD0?=
 =?us-ascii?Q?HOQC4BBp6ww+tfZh6D1XF9krH02s22xCkqFaodFPJMPy1/10AtkBUiJFeqYA?=
 =?us-ascii?Q?EW+5BS503GkE3INs4rjbc7Wi14ICtvgAcwEJTbafH7JtoTTyEzBCFsZ/do03?=
 =?us-ascii?Q?HAjbWr9MiFsw1eMlmpErK9X7dtgL4lt8o5cnXsm+Q9pIsL7XA6GNW2pIVnB0?=
 =?us-ascii?Q?Z2U3zvcUiYJgD4pvD2JJ4x8kbJFJPpelfKWXpBazjwWt9DMCRUbBD71WKfFD?=
 =?us-ascii?Q?u0tOTd+IEtmnXHhJKpq7az/K9JsrcX2m2Y+pnUgdbEfJRjpMmGSiG0zNUuiZ?=
 =?us-ascii?Q?VmQkhC4xwmfBWm09RojdBRUMIfed2E2fyi9tSTy1rWOJ3GVQ5noDUTtkXUEt?=
 =?us-ascii?Q?54xPiQFSoA87ESfHN1XrIKW2iry3/iSbMZmAvk9/eGRwywCYSZuaViq9NgTX?=
 =?us-ascii?Q?kbZb7k4azQKMO1L73ZAzs1NbofV7q4AZYuc3TUtBlzvdirNgXFGPSGgCy7Yb?=
 =?us-ascii?Q?38SaO79HluxF8fER5CeFXYunZKzf2fwDz47UpRdJ5HkxbVr6L9WEoL7jnCdN?=
 =?us-ascii?Q?PJU1z2RNPzXMq2wlDCzF7uDFHYHgZDdjgl/cYSF74QDLQaMC7sptbdvt/zo6?=
 =?us-ascii?Q?snDUiguht5tXn13tEctG/7TzdAAByabuTn+FF9V4OhzWHVEsBs2cRuKy+pic?=
 =?us-ascii?Q?dSsTd24bzFJQ4OIlZexFdz+OVwK73rveI7/24Ey3DLc/TYnBwA/kklvX2Lx8?=
 =?us-ascii?Q?bzDrU3MMhrr2VYwRi/+j86PSVoYpFpyu9jvAQ/+2f94sF7M9upAqxNEDOXLd?=
 =?us-ascii?Q?eJP9lF3y8Q/Do0ZG9O6BtE12t+aM6xgS2Xirado2G5Udxex99hFeqa2fasYz?=
 =?us-ascii?Q?ofN5jqjxho6Ne5HHL+xcgWou3lbu4tQ751/AYLZ5dxx3LX6en6ARvsD5NbgY?=
 =?us-ascii?Q?augQQUlEqYeC45xeSGnd5DqZbw2rAzTdoRTi4gx4OemXWv92vbhMjzZpRvWv?=
 =?us-ascii?Q?5m7BP/FblsOiVb5cVPNfJSb0WPx8AKOz3n5FDSnLrvwQ+vkjitEZJHmApmZD?=
 =?us-ascii?Q?Bw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 733d7e8a-c97e-4658-08e0-08dad73da40d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 03:54:57.1016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oy7adR9Gnv0ZVEVA0OtP7Ju0s3OvWYwGxK0rqPMtB0l5r2/n2Y4h4z48d4ynaQWxpO2DTrqqifRz9HiU4Rg4ij8kauRXmbYNiF1bnud7DHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7819
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, December 5, 2022 7:12 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: hkallweit1@gmail.com; linux@armlinux.org.uk; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> richardcochran@gmail.com; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>; Madhuri Sripada - I34878
> <Madhuri.Sripada@microchip.com>
> Subject: Re: [PATCH v4 net-next 2/2] net: phy: micrel: Fix warn: passing =
zero
> to PTR_ERR
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Mon, Dec 05, 2022 at 04:05:50PM +0530, Divya Koppera wrote:
> > Handle the NULL pointer case
> >
> > Fixes New smatch warnings:
> > drivers/net/phy/micrel.c:2613 lan8814_ptp_probe_once() warn: passing
> zero to 'PTR_ERR'
> >
> > vim +/PTR_ERR +2613 drivers/net/phy/micrel.c
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
> > Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> > ---
> > v3 -> v4:
> > - Split the patch for different warnings
> > - Renamed variable from shared_priv to shared.
> >
> > v2 -> v3:
> > - Changed subject line from net to net-next
> > - Removed config check for ptp and clock configuration
> >   instead added null check for ptp_clock
> > - Fixed one more warning related to initialisaton.
> >
> > v1 -> v2:
> > - Handled NULL pointer case
> > - Changed subject line with net-next to net
> > ---
> >  drivers/net/phy/micrel.c | 15 ++++++++-------
> >  1 file changed, 8 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c index
> > 1bcdb828db56..0399f3830700 100644
> > --- a/drivers/net/phy/micrel.c
> > +++ b/drivers/net/phy/micrel.c
> > @@ -2971,12 +2971,13 @@ static int lan8814_config_intr(struct
> > phy_device *phydev)
> >
> >  static void lan8814_ptp_init(struct phy_device *phydev)  {
> > +     struct lan8814_shared_priv *shared =3D phydev->shared->priv;
> >       struct kszphy_priv *priv =3D phydev->priv;
> >       struct kszphy_ptp_priv *ptp_priv =3D &priv->ptp_priv;
> >       u32 temp;
> >
> > -     if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> > -         !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> > +     /* Check if PHC support is missing at the configuration level */
> > +     if (!shared->ptp_clock)
> >               return;
>=20
> Can you somehow keep the IS_ENABLED() ? It gets evaluated at compile time=
.
> The optimizer can see the function will always return here, and all the c=
ode
> that follows is pointless, and so remove it. By turning this into a runti=
me test,
> you have made the image bigger.
>=20

Thanks, will change this.

>      Andrew
/Divya
