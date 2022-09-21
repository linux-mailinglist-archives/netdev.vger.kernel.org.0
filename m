Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E5F5BF6A1
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 08:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiIUGtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 02:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiIUGtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 02:49:16 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1987B80F6B;
        Tue, 20 Sep 2022 23:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663742952; x=1695278952;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XvJlyL80JLZnEc+bjIFF0TCqLMy+6F2Rp19h955AzVQ=;
  b=lAfiRd7V75Kc1/tiu9ro/Ng/C8zO2y1yJkIQj5SLHrOQUBlpyDojVsIm
   amZg8q7H8gklwF4C1wK1B8YG6j/dsfF9gJXxEO6e7BA6gL3kGcXBa030a
   D49O9bRkcZKWkYqor2eC36rYpYisQk5HvtmRMKxxIf54JPmIKRjjHV7Hv
   XfCCkRSEEzI4KA0AaTYxuQVG8RORJxMZZh+0ntlZZvmsPpraOckhvsOV+
   2ENd8atiSLnZHMIWL5Yr1EHNeFXk2G4MZK7z6hMzgWweY6XMDwVH5NFxn
   Q96hvB4V784GW+XaJHvsKD/GRX+3Yz/iT0v9e3t4XSYxg33SFcYQSI9KC
   A==;
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="114682904"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2022 23:49:11 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 20 Sep 2022 23:49:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 20 Sep 2022 23:49:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjRESbjf9SJyLVX34xmu76xwih8JT1hzqJE5FHepZAhm607gAuVYJMcvs/U7ysfKVmw7qY02Ia/7ONUPRiGuDFz4OeL+w0nnzsL1GUzAvPMVGpUFilHElHOG9deSnEWL5brBOWhBP/MBvytyOnSRZmJ3rCdSuJfxXVlczWLZi6GMnf889RgjyNS1bUiqkyeKMh88RNNKs9DPtDB4h7fHCvnnc0/r8Z2HrNGSokDaNlrHCkWAaQm8ybfgBIP4vtjqirOIKyjW7L2AKnWqjiB2xG63hHVgc8yqvTfHZYWojvqKUvcZ3ACHi6/qrKXT/tGV8IFc/HRbOrMfDbnQ0h7XPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1W97rG8x6FwkUp645ZQv/CYlHWflDOlRERFI9SWoX4=;
 b=l0t4GNH6xl2w0och0qjtQe8mr7eKacHk61/F7cpkCBx6ldOuXKs9lEVChEcIhdVA+y9FEqQIADKjKuJjB2yEA3YSwWGhxd37nHNoNLeQ8W29B97GNvVVo6M34mMCOMEBhFe+Vek0PRSVE7nokct0dH416xDZ3IFjhLEZYRxNleZwE0+ZyZXElI/IH8eJRu8+HKZxpS7rs4GCZTzVPUQLhFD3w1EFvh3fvjq877wCy9wKJWtarb6A5uUwaBydpcW6CvFV0UNVdF2OVjHcGz/+wnJqzF88NDay30eFV2Y85eqpAUH5xt+w/VDWxUEmBBQ1j3hKddP1IpbvzDqDt3ft8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1W97rG8x6FwkUp645ZQv/CYlHWflDOlRERFI9SWoX4=;
 b=k2Q9nsXYEwh8sl0BIIeTJJ0Pr4Hgpjblko13bsAdvuteDPHYQRE6C3f6UXUDZPoPsy370y9P0LrSECSUgAva0C79uJFOL8F1QtHxFrhxrw0VQdO199eE9intEgrJEO24pDKJgZUZbENkZ8k/f4Yb9TcDBWL9rkH6fUj37gg6HuI=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by SJ0PR11MB5614.namprd11.prod.outlook.com (2603:10b6:a03:300::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 06:49:04 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5c17:f27f:fd3:430c]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5c17:f27f:fd3:430c%4]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 06:49:04 +0000
From:   <Divya.Koppera@microchip.com>
To:     <michael@walle.cc>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Horatiu.Vultur@microchip.com>
Subject: RE: [PATCH net] net: phy: micrel: fix shared interrupt on LAN8814
Thread-Topic: [PATCH net] net: phy: micrel: fix shared interrupt on LAN8814
Thread-Index: AQHYzPue4/MKFNRLiU2mnzSUPXO8m63pcdJw
Date:   Wed, 21 Sep 2022 06:49:04 +0000
Message-ID: <CO1PR11MB47714260208C48DDCF5855CEE24F9@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220920141619.808117-1-michael@walle.cc>
In-Reply-To: <20220920141619.808117-1-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4771:EE_|SJ0PR11MB5614:EE_
x-ms-office365-filtering-correlation-id: 6c3d3519-32b9-49dc-67fe-08da9b9d5fc2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wNJEBajb2e6b4uLQ4btvVU39pXDwRcxkqER/ifv4b8VtiCPoqH7x22lCeyL67E0+dEhGIfdBPE3+W0qEg6NYGvLUK6p70I9nfuWvgF9FfKI7aoGftW9V24aiDwnsZT2IiAqs3OxJpBB7hAPrED1Z66d3ayYKGE9VnMVN/k4PswD04RZOCfuqjwua3wbVA0xBv8WfxEgNYWCYOWTdhRtPk7uwg5PZrDNJrNJr8l+jkip6b+dTaK5DPTtTYwF1N+fgi4csG+7MASc9cTpw9GP7pIiKKH5VDfnOES3W85D7RFe+5joxFtx1KZBxTcmAuVRvHjdrDWeEUnZmIQQLhJf+ClXj2sM5NL/jrl5weCxv+A4TOgAwvU/Uj0z3fTKtin4ZPEtJdq+8ExGd56tgKdfMLqhKWWkgXkSWhTmLHutVouzkUy5p+IO2hpwqcd77vHxmO5E5GO4WYn6GQNrvu88I9xNX8sLbvrbfQvtRYTFHlZHXXaJyx+iLDcM1aLdSyvzkl0A6Dkf39Qb+uFPZgMujIWrvMUyMi3Zy8lL3F1va7UM00yzZjB9OPPKy50q8KTi6iDO9L8OGc2nerAAs7FjJQkknkl12S85LfwNZR4OkLmMYyMLC3vaniEhA+SxKN8Wg4ZW/pLss26ssVNAfO/SXeQcgSrZdZvjBCwRwPCFk85vujkRxxIY7H/kNRNvPsysdMrt9TkZPadF3/polqckRtewft5+FmwKLxBhGF4RmF13JoZGZ+U+AohvXFkRGavoTMEy/X/GyKwOIVA+5fcqzjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199015)(7696005)(6506007)(107886003)(71200400001)(9686003)(53546011)(26005)(38070700005)(64756008)(66446008)(66476007)(66556008)(110136005)(4326008)(54906003)(66946007)(8676002)(76116006)(41300700001)(86362001)(33656002)(55016003)(122000001)(38100700002)(83380400001)(186003)(478600001)(2906002)(316002)(5660300002)(7416002)(8936002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sS0BhfgwxkrIXiax0Zw1CZa/Ud49u7eokfx8a8/mIoYuO+Oey+i5W5c6Jn0+?=
 =?us-ascii?Q?a0i/nQ+9H4R+aaBJ7pjvhBj5NmkAmk9EX2UO8sdR50o22XrrwfmpC5fvTCut?=
 =?us-ascii?Q?YkpTEYXHCe+2BG1jm0dU9Gu1VyN5fMM0Al1UxyiMNQxBHua+l8WYxyDPzvRd?=
 =?us-ascii?Q?l9n16PRxNOvAZXP8800RKJZ8/7+c7IXrelEYUMA0CweYchg5kKKVj9UsxKzC?=
 =?us-ascii?Q?OYt8dFgpRh5VdgXf+Y9gKUAm/Bbo6ZeGZcS2IQbLzvB0dm3Nz4IuhSlNGii/?=
 =?us-ascii?Q?bPRvA1hrJgLQTJI7m3BU0u6gbezDQtgyghj9Q0/FlfvCgtpzIHG3eUlUSQTE?=
 =?us-ascii?Q?IUWSq7X0fJe+3p510JAQbCUPsxPfsZCAt/MZ3MXeYiukEz0r2hLZVCCuA0Eu?=
 =?us-ascii?Q?1gsqDfitPF9C2qESiqT4GmvyFbedSXjdGBValAcpAgpd9yGsY/JmDnKkpGcX?=
 =?us-ascii?Q?YYtOLoH20gncArHkOtBpV9AlCevvPwNsXRo+GYfAfa32x8/rBiDZYc0bZ/Qk?=
 =?us-ascii?Q?aeMUU/jZcTl1ox1LhmFNuCBhDOac8bHuxzWNcGYTZMlko0/BGtcU796ZAM6l?=
 =?us-ascii?Q?7Vcbj9lOyj000KjCSNSlsNO/P2quPA+z4CcHE28o6xdREZLXUZSyqUbtKfbb?=
 =?us-ascii?Q?nykTlbuIICv1ArmT6QYKwycCSMXxdHdaezJabx0FdlmIK6A77iv1whDl+iOm?=
 =?us-ascii?Q?E2B0XneOkJJ4pG83s+TFT3pe7ktZ8lGli3L9TCv7wsqntCFRKrOUd9ZHuVON?=
 =?us-ascii?Q?3mEgG9ruZjx5/zxdBSZ2OzGupon4crKNR/S+FTOMZDQFfDtf2KQwL+Y2gbEs?=
 =?us-ascii?Q?uFfDIJfB/g+9zWI3dLo1KvSTqKF+I1gPetRQ3CpAiki5I2It3uZa325JzENK?=
 =?us-ascii?Q?Xa8WLdP1viZYDQH/1nTtQ72eJFaAIp3tPk7Te++vt0sl9/vLBCotn+CQQ75q?=
 =?us-ascii?Q?D/ikIz79CYK0AEECX9OcAMSNgXPC6KkaHYVGSorqNMKqd8/zluHAnizp7Xle?=
 =?us-ascii?Q?3ts9gnj03tyW0G2wJvww+GznAFPvjx/Xu1Ei+1WH/CCsSOXZSzzV+TRx4Bb4?=
 =?us-ascii?Q?T9ZIpSR95KM202n/qGe+2a2pcB8PGdp4oXpRZcl9ie4VATV6ykGR6XiUxJNM?=
 =?us-ascii?Q?wsEp6KjkIEE2m6W3ZZHm3jzobL5bTAtgm4N7ik4rxKb13WcVcovQxEbhKyNQ?=
 =?us-ascii?Q?mnXfetAAq0uNhN1w8+R3T0Pt+Yu9rrHApawU88DFfPfmfh6gIx1YCw90N8QS?=
 =?us-ascii?Q?o3fDJbGjQ01i7rvncqpX/WOBE3q8VmJauNORd5LVjVIsQQY96ELnlwqqNJSW?=
 =?us-ascii?Q?9DN0TJAkSjC8m8EkxVhBIpIPxoeNpOn98uewO//Oeky+V8KB8GU2y1+SdF4g?=
 =?us-ascii?Q?jye+aAXCMkG1KBUsNiOG0/Pg7nkWOk+DJrTxxFYBUgOmSmihQQ0bTf2OAtya?=
 =?us-ascii?Q?7EwHA4zypMipY2+tAWFBXhtmOTH5xD+sVPw5VFPO8OXu5Dv5J+rxaTKz2MM9?=
 =?us-ascii?Q?HcnQAYeGFI5uAfyVPhfZbwc0qS8krEdC8xqs+HnuLdiyvp9HQAhCHP6zE5U9?=
 =?us-ascii?Q?W5z8l9qfj3P2Ws5nypfPb0AktmzyOmlnSGXnouhPFwFzXdXFgwwGqVwjt5+3?=
 =?us-ascii?Q?cw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c3d3519-32b9-49dc-67fe-08da9b9d5fc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 06:49:04.4468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 38Cofb6I2tIpYC9/s1MEhvyiwNG+fxmjZPNvqzQ091YcD+09s6p3ghO6SzVSZfmuUQeaEKr/rUtc286oZxp9dyG7M2IPmGBUW6iQ6uzRKo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5614
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Michael Walle <michael@walle.cc>
> Sent: Tuesday, September 20, 2022 7:46 PM
> To: Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit
> <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>; David S .
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Cc: Divya Koppera - I30481 <Divya.Koppera@microchip.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Horatiu Vultur -
> M31836 <Horatiu.Vultur@microchip.com>; Michael Walle
> <michael@walle.cc>
> Subject: [PATCH net] net: phy: micrel: fix shared interrupt on LAN8814
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> Since commit ece19502834d ("net: phy: micrel: 1588 support for LAN8814
> phy") the handler always returns IRQ_HANDLED, except in an error case.
> Before that commit, the interrupt status register was checked and if it w=
as
> empty, IRQ_NONE was returned. Restore that behavior to play nice with the
> interrupt line being shared with others.
>=20
> Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/phy/micrel.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c index
> 98e9bc101d96..21b6facf6e76 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -2732,16 +2732,19 @@ static int lan8804_config_intr(struct phy_device
> *phydev)  static irqreturn_t lan8814_handle_interrupt(struct phy_device
> *phydev)  {
>         int irq_status, tsu_irq_status;
> +       int ret =3D IRQ_NONE;
>=20
>         irq_status =3D phy_read(phydev, LAN8814_INTS);
> -       if (irq_status > 0 && (irq_status & LAN8814_INT_LINK))
> -               phy_trigger_machine(phydev);
> -
>         if (irq_status < 0) {
>                 phy_error(phydev);
>                 return IRQ_NONE;
>         }
>=20
> +       if (irq_status & LAN8814_INT_LINK) {
> +               phy_trigger_machine(phydev);
> +               ret =3D IRQ_HANDLED;
> +       }
> +
>         while (1) {
>                 tsu_irq_status =3D lanphy_read_page_reg(phydev, 4,
>                                                       LAN8814_INTR_STS_RE=
G); @@ -2750,12 +2753,15
> @@ static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
>                     (tsu_irq_status & (LAN8814_INTR_STS_REG_1588_TSU0_ |
>                                        LAN8814_INTR_STS_REG_1588_TSU1_ |
>                                        LAN8814_INTR_STS_REG_1588_TSU2_ |
> -                                      LAN8814_INTR_STS_REG_1588_TSU3_)))
> +
> + LAN8814_INTR_STS_REG_1588_TSU3_))) {
>                         lan8814_handle_ptp_interrupt(phydev);
> -               else
> +                       ret =3D IRQ_HANDLED;
> +               } else {
>                         break;
> +               }
>         }
> -       return IRQ_HANDLED;
> +
> +       return ret;
>  }
>=20
>  static int lan8814_ack_interrupt(struct phy_device *phydev)
> --
> 2.30.2

Reviewed-by: Divya Koppera <Divya.Koppera@microchip.com>
