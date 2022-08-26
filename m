Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55005A23DD
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245753AbiHZJLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245712AbiHZJLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:11:39 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D847DD6B94;
        Fri, 26 Aug 2022 02:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661505096; x=1693041096;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9yTwzK9t3A0wZuuZA+3g6/A08/EzSxE7dpvE8sw11Mo=;
  b=Sjt1JYeSdo0MrLQI/rGVSJe7eYghgdah/qrLFJnAYgQogd6aGJzdC5TF
   lDaBXqOnN9waucdVS0ZjwG/iAUnZTLIkEQQzH45WoVjEsNMdEOUM0Rwoe
   7yJ1rs9IhyEPQOejr0CIP71JN8tl8FgPsX+zbnBkzI5QumNYhdUX6nEWD
   M7bL16U72XrkpVNozQd04iTOEKWSp7MvFQAHgfO1brw2yyTf3c3xUXmTZ
   KaDXTBuicp+xccoysYL+wMKd7dAN37MNcivjLnOpmSOdfYFpVUx/InsEZ
   6yxPxWp+LQQgtB1s0tax3G2ur9176okWZX2ytJ5p2loiGGaAAaljiQz4u
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="110871102"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Aug 2022 02:11:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 26 Aug 2022 02:11:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 26 Aug 2022 02:11:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFM+LeMyX9Y3Wh9fcEt5QsCu1HfMBi8wn+fFo7koqQbcoc6+JyWoYCedxD9Hkau44pev8kyK7zGHNQyEgqzS59rFhR26YTPZmT14hIfTLYNXtV/8B4K+ILLoviqce/1OIpy2dZh4qJ4izsS8Dh+2loQeA4tKLB3sem/ZJxykTCvCTz9LhhldkhZFEISkV61/lzJ+99AEB/l+RtmTjJseiIIgK9XeJyMqvODFhIiQLAOlZSZYFT7xnl/QKC1XJ96Ujn74dO2OVotby15j2LoAQE9uJkoKh8ZUQeldwnW9vTXwcQRkpTwioWOM/8Rprg5cq0mt9KrdkpO2DLNThmfIiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnB123PgN/4keO1ZlkUiN3gSmJvifEh4dybjmhIAWHA=;
 b=AweL1NmhsfaLMcDlfclpdZ4CDdy41TwM0TTL/Gk91c5Q3U3WWsKZakmFQBhPFL8OXaRAWbyELMOUssKzXbH3f/euYQTSsLxuxWSkrhAM+bXFFXWDClCy5q3qkmzKdlnUxT/jWlY+a6XpufChPea2EFPJpNYPqq8AHAOF46x+qD9xn/JHs+roj8ZiXy9fqKeD+2VZIBStmwHqcoT9KDkqogXVxF+KPIWiUCen1Di4yj+DMV8w6cL6MPSEiBmjW9Za6wrRiooNSlm2Sknwo7ddsjza9PcZw0d6duJuQcelnwq4L3rQCeyPvs36gPiH0nJ9XcZ2lkNl53DSfnOr6s3D7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnB123PgN/4keO1ZlkUiN3gSmJvifEh4dybjmhIAWHA=;
 b=tVLSJ3AODZbBPDHhkohBr/07WP4SvgH9kfXg5sRfWlKZiSwI8CSSjBobQoqW23CIHix7M4KqyLj+ofjG2fFhV5oy8FZn6M8UjpyrA5yc4QG3yAM28J196oJSguOocKl8D1eu83rFhIrpmGqb49XCcmFdLJJ6vzF1YesDxsB0vPo=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by DM5PR11MB1660.namprd11.prod.outlook.com (2603:10b6:4:4::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.21; Fri, 26 Aug 2022 09:11:21 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::40d2:83d0:b217:63bc]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::40d2:83d0:b217:63bc%9]) with mapi id 15.20.5546.024; Fri, 26 Aug 2022
 09:11:21 +0000
From:   <Divya.Koppera@microchip.com>
To:     <michael@walle.cc>
CC:     <UNGLinuxDriver@microchip.com>, <andrew@lunn.ch>,
        <davem@davemloft.net>, <edumazet@google.com>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: RE: [PATCH net-next] net: phy: micrel: Adding SQI support for lan8814
 phy
Thread-Topic: [PATCH net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Thread-Index: AQHYuFmMgzj2knw/J0+AGHw88JSECa3A3vGAgAACdoA=
Date:   Fri, 26 Aug 2022 09:11:21 +0000
Message-ID: <CO1PR11MB477162C762EF35B0E115B952E2759@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220825080549.9444-1-Divya.Koppera@microchip.com>
 <20220826084249.1031557-1-michael@walle.cc>
In-Reply-To: <20220826084249.1031557-1-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a204ad2-be42-43de-eca0-08da8742f17b
x-ms-traffictypediagnostic: DM5PR11MB1660:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xkrBuiX8qXBj+XsVZ+/gWwncUmo9NZriNKBUhRtlb6EOzWu3q19699z5Pt1PsPIZ3do8zYcXgtwchlLHd9+8KEMXr9jIvkRGNhlw1LsVKoslAfmbOK468yRYIOkr34U4LOcogy2ZhL+8kpWevgItpzZaSxq447B4HbMSoKDTEFw0GLwfgPO6eZcQBGdgUT1xhmx93mSF1I1OLRMBNZ+gM3El/VL9kMvoH2DYV2vcI+5FoHzBdHWUXT+LB5glgcOa1JWYN6Um1LJmt22uz1shiYC/V8zPu1tOqSo3TrlNf8NstFH1Kn1BoOq8Pi7D5SOhHt+vcFcagZFyY6a3nO9b/gepVVk6M5kqt0Y0hGL9NLKe2kWFyTgJmg25G0h27uV0VvFwBEPnTr60we07phhdKpcily9SjAbSIIh0ek0CF2RitRyfoGKEvI7Xwz9yGC2BRxHsqszG7odnteF2tTFgimFQh2wFGwQTzsqXdbG/k2PfLetQrviVDvlrixLuNd1LVsLKsA8o+YP1p404ymkF00FdamJrFxu4LtJLrdrvLUIafY4HyLpqX2Y3M/Cahw6q127ZmpxoFDWo5QtVxlyqeUksYwIDi7QLzNiLE7PprGsI16aXMKVC6rG7DAXw4hkVP8IbWeWuzyAQiJbMsveAj6sDQ+crHFNt/AG6r0yY1k2ThPZN9Epz1o7MOXqGii4qszIqAM9E43vnKs+CifcYhOtKANX0NThqWqpwl5CB8RqbHWkn9QCPTVYElREt+GiRqbq+JBItkr51Iz4g1/RsTXc0sd96RGhh3KHlE0Y4kvQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(376002)(136003)(39860400002)(396003)(86362001)(53546011)(186003)(55016003)(66446008)(7696005)(64756008)(76116006)(8676002)(4326008)(122000001)(66556008)(6506007)(66946007)(9686003)(966005)(71200400001)(41300700001)(66476007)(26005)(33656002)(478600001)(54906003)(6916009)(38100700002)(83380400001)(316002)(8936002)(7416002)(2906002)(38070700005)(5660300002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QoU12Poe/x/grWGUHYhRX7sQvF07fxPGhuMsEvVRiovGYjgilKvFG/sty/Fh?=
 =?us-ascii?Q?2I0ugeOvFOD/lxLC5MsAl67pF9jq1W1KTsV8RoXdbbVwtRztHjHJp+xVmNRw?=
 =?us-ascii?Q?6B8GNR6umIQ0Ra0j/0Fm5B1TK8lk15Yn5+R90+9N1k2THiQHmczCEZE7lY3P?=
 =?us-ascii?Q?22miXEpg8o5kIZmXIuUcfSFjtE43EE8BRyooa7oW+trPct07P9JHCXxmuwDf?=
 =?us-ascii?Q?sJWxIcilrRE8GduE4mOpA13/FWqRCVOtMbcj8bi/4cUkvRBk12VyMdSjr6nb?=
 =?us-ascii?Q?VH2PBn1n2W7T24Qm6ESOPscd4W7OBehM1mYsqzGG8CfvwEgi2XEk6iTbmj8b?=
 =?us-ascii?Q?zo/uyrcQ6bFPY+x3X51qo5Pf9f8nf5H3R4xnIcZPROVH2GsHc1zjiLPEB3li?=
 =?us-ascii?Q?xQAhzc2B47JQd1LpgMFz6Q7TtIq5S1r39y2mIyfVpFi6TFZSRlys+2odox9m?=
 =?us-ascii?Q?6ouObRhQ6ryD90vLbw6pMA/m/Qn8lIex74EjKubm1f1iF1bI+M+ok1OUcHp7?=
 =?us-ascii?Q?TBWgx4Hb2oh+Vkd+s2cdqSg8aNPPw1TsMFrbuYDLS9cCWiP31wfg2TH+82v4?=
 =?us-ascii?Q?oiM5AnU8zUUdmxdid43tEU+zOg7saaIA8pCgNamcqbMZOEXZmnKbNiUUAZaA?=
 =?us-ascii?Q?Qtjhp93uxb562x2S958JYSFkXnYQII2tvTukVBpW0YQ9O57vyROhqNweRJdC?=
 =?us-ascii?Q?b6fQLTvYUXWfY5e0/ODSJuUasYC91v6r6pZOcMcOkqdrk9+Mymqu87/Pn2d2?=
 =?us-ascii?Q?kaDo4Djvj/9yQRus9iATxOTscLdpTcgtnExy3JU8quhVAqm+Qr/X9smCKTRX?=
 =?us-ascii?Q?SoYQWzZVA57NwUbHK9RTFK4w73IWu1pGasK5ZTAbYUnKBnQd95Ba9QMvkWud?=
 =?us-ascii?Q?yBfW7G1+o4kjaoS+gdc+1x5YuglCsXdkAF6xOj4rOATHXp9qi1NTZOSKIpy3?=
 =?us-ascii?Q?B8ixUfcZYHoD+yKW4DPeYwjKP/DDQVg8xQM7Rwh1gErGg2VBfZV9ntxekm5o?=
 =?us-ascii?Q?JsxkJcPCCJ3ygtVr8LZIbYCa8HIktYucQbOes3iBmXt+7cXDFxsTv9BDPLub?=
 =?us-ascii?Q?3eGWjGvwbwMOILypKhVjjRJkfAxuSBFZXnT21DVVey/dJkn3rOqt1Kr8jOpJ?=
 =?us-ascii?Q?5XruvTlY3qechPTFezh/83CaOcREBOz0eMhf2DpozjAMFFMiwIvzVZ84IcMu?=
 =?us-ascii?Q?0bRjTy20R26fLTNIkUTcSrE6Q/SK9z01gsi8NxkHSGECI3/L7ZUNcGmg09+B?=
 =?us-ascii?Q?XUEJOq/dWfFnrk1kH0AVR+Y71ls3sZ27vzvHzCdatOSKjiQwjmo1YInNmQ0x?=
 =?us-ascii?Q?TaxUuld21hcVrmiFnNEflixj4c5u4uYIO92nfxjw8BqUz1mrSE92G/J4SJZ9?=
 =?us-ascii?Q?lbYQf5adjXd0LizqoP/k9b5GZNFhdoGJhxUOf/L5lkHCKuF3lMaOxz7naMES?=
 =?us-ascii?Q?S9AcTgMdWnywjO23w7f2rr8khKlAqrUL7rqx7Mt8wjm5xO/ix3GOOGnZPBgp?=
 =?us-ascii?Q?xqi0Y7yvhkT4de4agG7aYbmjQt/e129OHb15a3JNDUfsorGPktDUJOXJruNW?=
 =?us-ascii?Q?Ovi8tdr1KPOUgGNgauBkcd+TknIQTEEojijaHonyfLH2d0C9MzzM0+paluCx?=
 =?us-ascii?Q?Bw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a204ad2-be42-43de-eca0-08da8742f17b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 09:11:21.5055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mlAPqqRkhkNMU+mv7gVrcL0YOMKnFPxXqx5uqZvK0mxZb9Ofn6CWt9Kni5w1Q9cvx2Uc6uANx+5xpRyzDqVHA7oico+ueffrpDJHt0fgl0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1660
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

> -----Original Message-----
> From: Michael Walle <michael@walle.cc>
> Sent: Friday, August 26, 2022 2:13 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: UNGLinuxDriver <UNGLinuxDriver@microchip.com>; andrew@lunn.ch;
> davem@davemloft.net; edumazet@google.com; hkallweit1@gmail.com;
> kuba@kernel.org; linux-kernel@vger.kernel.org; linux@armlinux.org.uk;
> netdev@vger.kernel.org; pabeni@redhat.com; Michael Walle
> <michael@walle.cc>
> Subject: Re: [PATCH net-next] net: phy: micrel: Adding SQI support for
> lan8814 phy
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> Hi,
>=20
> > Supports SQI(Signal Quality Index) for lan8814 phy, where it has SQI
> > index of 0-7 values and this indicator can be used for cable integrity
> > diagnostic and investigating other noise sources.
> >
> > Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> > ---
> >  drivers/net/phy/micrel.c | 35 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> >
> > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c index
> > e78d0bf69bc3..3775da7afc64 100644
> > --- a/drivers/net/phy/micrel.c
> > +++ b/drivers/net/phy/micrel.c
> > @@ -1975,6 +1975,13 @@ static int ksz886x_cable_test_get_status(struct
> phy_device *phydev,
> >  #define LAN8814_CLOCK_MANAGEMENT                     0xd
> >  #define LAN8814_LINK_QUALITY                         0x8e
> >
> > +#define LAN8814_DCQ_CTRL                             0xe6
> > +#define LAN8814_DCQ_CTRL_READ_CAPTURE_                       BIT(15)
>=20
> Why does it end with an underscore?
>=20

All LAN8814 Macros that carries bit numbers are ending with _ in this drive=
r. So following same.

> > +#define LAN8814_DCQ_CTRL_CHANNEL_MASK                        GENMASK(1=
,
> 0)
> > +#define LAN8814_DCQ_SQI                                      0xe4
> > +#define LAN8814_DCQ_SQI_MAX                          7
> > +#define LAN8814_DCQ_SQI_VAL_MASK                     GENMASK(3, 1)
> > +
> >  static int lanphy_read_page_reg(struct phy_device *phydev, int page,
> > u32 addr)  {
> >       int data;
> > @@ -2927,6 +2934,32 @@ static int lan8814_probe(struct phy_device
> *phydev)
> >       return 0;
> >  }
> >
> > +static int lan8814_get_sqi(struct phy_device *phydev) {
> > +     int rc, val;
> > +
> > +     val =3D lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_CTRL);
> > +     if (val < 0)
> > +             return val;
> > +
> > +     val &=3D ~LAN8814_DCQ_CTRL_CHANNEL_MASK;
>=20
> I do have a datasheet for this PHY, but it doesn't mention 0xe6 on EP1.

This register values are present in GPHY hard macro as below

4.2.225	DCQ Control Register
Index (In Decimal):	EP 1.230	Size:	16 bits

Can you give me the name of the datasheet which you are following, so that =
I'll check and let you know the reason.

> So I can only guess that this "channel mask" is for the 4 rx/tx pairs on =
GbE?

Yes channel mask is for wire pair.

> And you only seem to evaluate one of them. Is that the correct thing to d=
o
> here?
>=20

I found in below link is that, get_SQI returns sqi value for 100 base-t1 ph=
y's
https://lore.kernel.org/netdev/20200519075200.24631-2-o.rempel@pengutronix.=
de/T/

In lan8814 phy only channel 0 is used for 100base-tx. So returning SQI valu=
e for channel 0.

> -michael
>=20
>=20
> > +     val |=3D LAN8814_DCQ_CTRL_READ_CAPTURE_;
> > +     rc =3D lanphy_write_page_reg(phydev, 1, LAN8814_DCQ_CTRL, val);
> > +     if (rc < 0)
> > +             return rc;
> > +
> > +     rc =3D lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_SQI);
> > +     if (rc < 0)
> > +             return rc;
> > +
> > +     return FIELD_GET(LAN8814_DCQ_SQI_VAL_MASK, rc); }
