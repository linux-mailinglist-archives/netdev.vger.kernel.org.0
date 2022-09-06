Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CB25AE58F
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 12:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbiIFKlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 06:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbiIFKli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 06:41:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC245C94B;
        Tue,  6 Sep 2022 03:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662460897; x=1693996897;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H2/llq43t0iCNS2WA+NLgdFQif6zklVbnwQ9Nwqzh+c=;
  b=sstFlK3B6+ztCZv5ivbXMZUgWKvB2va4E1fvcFTTZHDTdmRVbNskh71P
   vl1hELeROLfPRs+scid68pINU5sA679/H3EwOUzclTEFy6H0/ygX4eY+x
   GeJuZiw+9WyV5InT5VXNYljIvZPYpOEUNduCnIxBaL299xzBZ8aQ+6jXB
   rkUYe/Mg0hYtiB2Pt4utVUmxgRoqXpZbGRUckFwNCelU8DkPgkqPe1g+x
   743IvzgduYlPAe8o7C9X2ajyFjnC0bZKCgMSljbgyzqvLE6Qv4NEbFXRL
   ttDGDx6RI8najMNgOCicrMtaTvbNMgn+5LJFP8Ga6YZanycdzOzuuOMxz
   A==;
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="175794265"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Sep 2022 03:41:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Sep 2022 03:41:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 6 Sep 2022 03:41:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eeozr28WK/8UcjVckYPE5AJLkfDk5nTnBMt87Ag7KTJLAFefrzvdi4Bep1yD0xrJHzbCF/X62LiQ+km59jI3mpSpaVzxZN/1BZr19+p+QEENTp+QGkmX4TouCdQXJDU/l9lZEnpUUJJ3jmYM15AM88OhZ3NaEGT1+4BcPkC2VIf/FteARjeIGAqdmji/UResFERzY31VysXUn3bLhZs7T2988DsGT0JzmbMznygSUQA6+d6LPAWJzRnCxJ8CiACQbWG1ueHzvnIpsi61FpfGP+C/Aya83IQY1lcqc36eM/0Zs3u3or8vJQTfY6LLWL15TtcGD4tW/dppjHcFD5mNzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GO1Zh+ElEDbmEs/zjbPhG6PvCjkcNeryeyxGhH7Sdtg=;
 b=W2dC5uoDB4YBSvFyQu3bnJx2vztVrg6Sy4NvIxBWXQPsAIIkyjIz+Dn6vfqFts2zVzY6q6wvKQ5weBdeL5zVU0dewYOBLQw66s6FnylUnxKnrY4ViquZmK9PpWOD99r7sIWaCjkq1kfDBOh7Z2nFtncXWF+pHuguo/ztMVRabKftbR9RPUce1pINfX/s+di2rMmqQiJDBteq8pucnFg41kObsjPhEcnuQQX4vizRIzrzlgsKPNkeB7y/cTj+/BPVH6UQfAio0ZgMdPOpSVD/LjSl86XkoxFHauTfL8mfJVhJyx8RI/BF4hbMkxjbCv7I5y45UZsIgYEJCGNY6VWfFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GO1Zh+ElEDbmEs/zjbPhG6PvCjkcNeryeyxGhH7Sdtg=;
 b=eed7RjfeaWWtcdquFZKxBS6LxZE3gGu1t8SYCTMcmYg2zNGoxkfXxGwL4vQiSY3ZCSBZiECjjZG8/WeKCYF6Zz2heRkKyPRV5dZ07L/sOiF7Z6t0Ok1+t7HMg5Qguy/f3qfJbPazCHZptPgsqpvMotRHUSlYSTi87i4BmKD+8+I=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MN0PR11MB6133.namprd11.prod.outlook.com (2603:10b6:208:3cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Tue, 6 Sep
 2022 10:41:33 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::955:c58c:4696:6814]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::955:c58c:4696:6814%3]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 10:41:33 +0000
From:   <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH v2 net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Thread-Topic: [PATCH v2 net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Thread-Index: AQHYwRDJNV3vhZ/TwE6+oYymZqWFva3Qz3OAgAFkqpA=
Date:   Tue, 6 Sep 2022 10:41:33 +0000
Message-ID: <CO1PR11MB47712E1FAE109EEF5E502C5FE27E9@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220905101730.29951-1-Divya.Koppera@microchip.com>
 <YxX1I6wBFjzID2Ls@lunn.ch>
In-Reply-To: <YxX1I6wBFjzID2Ls@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26e8b9ba-c9eb-468f-5cda-08da8ff45da7
x-ms-traffictypediagnostic: MN0PR11MB6133:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +F8qo+7L2wJY0A3PTZ/WBJqGYrQXeK9JYhcgCCDDtIEOUN/T+Wxyz3nnifNeUyGjfqSCFqick7azctMhyysgeB63S3Yu3wXs6euBXXpcGZkuKTSaxZVURNEwtFvaYG/WE33AAZ8wRieIRS8SF0eDczmLznnYtycECg3clHc68ByiSDx7Iv6hzKadObeZmZoSZ/AVkvUcTu7HiX9TL3vJJ1gr8o4tKfQ9//GRSccJtW4xEnpsgmF6gKfH6PxTpRa8u2mQsuVBWi+yEMFsPTJgENCb5Wuva3guEkdYdUwqIFXjKlN7+Q1MX9QG3732svgyKpAqCM0ctCKP4Uy2gVWbhnhNukr96m7sxvnGfMvxOqxFlx4CUPD+LygAAHHjYLaU/ttJVprK/Vp0yMwinKUeNuvMJ/Zs37Rs6mFiblB6i+nbexSpZ1IrIq24nGMtAqexMVH5b9pqwmOXL6u9o78eJ31pIQz0eCcx8OaoJm2GSq0NkK/Z4BjjmywE6Rq/FN91YwXnIIdipaeGjmKgkxonkBFpm7gXUrrgUJmC8W4lqL5osay2FfiI0JXPfr3Fi3RDJemgVXPEkmVzsX3jff5qi+tha+hikVo1U7o2/AhRmkb//C0kO06bI2n3Rji48MWbffFRtW1L6E//T1bp7xBozNAWZyxUTq/BH4BrozBION+ZhU5Ut15IgEMSr1ZwOeyJ7UB3fFpNvTMfaLJ1OqXuabz+4RGVWydW9q06qjSoQ/ycoNdcrOrrzaEKFPhCqGqQX2fzXQZT9HBjMyD2lQxJHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(136003)(396003)(376002)(366004)(5660300002)(86362001)(33656002)(186003)(8936002)(41300700001)(52536014)(26005)(107886003)(6506007)(53546011)(9686003)(2906002)(38100700002)(76116006)(38070700005)(54906003)(55016003)(7696005)(66946007)(122000001)(478600001)(6916009)(83380400001)(64756008)(71200400001)(4326008)(66446008)(8676002)(66556008)(316002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?am7PQ8rvVFVZfusXEYoE0MM1s6RQU6Mi5go4icm6I0UjkfDWuSZj1l9QPGBj?=
 =?us-ascii?Q?QnOtEZlDxR2lleWnTRBPjXVC0KXKS9JSJoQoocvrBuBpdJ7Krs7Xg8414LMA?=
 =?us-ascii?Q?ndNQ4H5tvr3dVyjaUdDvh4oXfBlfDT+86VenI3TW1LOrLSxjE+YxnI3UrvDw?=
 =?us-ascii?Q?sCJQXPJkX+KNmj7aRslenn13I16HY7MCWSldsyRxdsZUUyz33xAZNs/P3wSa?=
 =?us-ascii?Q?xM7EbFpEdpzWjplumw4+nXXyHuIgl16DT68cDETRAmAvbhe/kAInv//7oK1b?=
 =?us-ascii?Q?drPRxxC2ySWYjSfyiJHyerqUvuEl0w/KcNSlcpez/30wc/jhGLTsGcUzIEzs?=
 =?us-ascii?Q?SkZ/VKdCNPX3biMK2+XWi9oz1BmAbwLxBvJpWK48SeqiOGyooOjs2AQM8Den?=
 =?us-ascii?Q?WS+Nyinoyd6vqMj02ddtVay1+HJZScq49xm9PVcLhuCL/PcHW6PTPXOzyzPh?=
 =?us-ascii?Q?6ULW47MPhyp7Z93HVkFY3aU33fPDSuT6kMiypRYRQGFWAoZ4DsDpkCHZigs8?=
 =?us-ascii?Q?QG/QpkEXALXmgz4US2VksuvRKnyyPFW1or4LxsnU8O1w60mHnoJGM/RnAdGW?=
 =?us-ascii?Q?w1WSTiWYiybdRhAbl9reNYVN0sMPecJnyG0csQq6HXbZf85i8TjgtwMdP9x3?=
 =?us-ascii?Q?/71sIxILMFtzUUqrVroPqS6QWYpkM06YRPhYhR7hZblNWerM072K/rpElewx?=
 =?us-ascii?Q?EuhDMG6F8Tss4yHkWfL9ZHACn/t46aG3OdRD9DvlMv+f6dymOneKwngD2OwO?=
 =?us-ascii?Q?cOOx/gPfmX6cVfbx/DtOvLwn9UBqufb2ytDBumOSwMbNJIqgw3UrvXC4Vux/?=
 =?us-ascii?Q?NyltQIJByTGf4Vv68yVOl+wSDwVVwbNSGl+HBb7TyQuK4js7l5k5PKN8+HPZ?=
 =?us-ascii?Q?wTaTBIXGp3GLto9CbzpcG0EapV45lSu+5m7JmXC8lpfkEwqe/XMVPD65IO1i?=
 =?us-ascii?Q?mJuAJYBXXhwhc30fKalkHsCpuUyLVPcYW0yxG8T4ITP7Nk468UKth77B8qju?=
 =?us-ascii?Q?pPpJogrECPPvU2D6TgCkGs4KfqT8wwJNUwmAMTdGphTzSHNl//yG1m0xNTwT?=
 =?us-ascii?Q?dyIOtJpHnx5HeZ6V41yWKKuFDn4URLHSO/xmtt6TtxwMRouT625iMWOI//pY?=
 =?us-ascii?Q?3PooMiOJvF5/opvCB44e7kjaJ+gSnv+phhwef2HTcF53Uut5BiquPmxyERqX?=
 =?us-ascii?Q?VlcNhSZZeNCaCC8EIPtb6EEr4huIccHVrk6sX8C1F2H7WY8pfWnFV7ZRlXyI?=
 =?us-ascii?Q?U8+ThmrP5ZSutid1NZ5QtJfDh+popHlOzLDF/D86LL2YANoFC8XhX9QzCGvA?=
 =?us-ascii?Q?SfrGHq7DGbFzYZO2aJJfP8K3k7fNkj3DPKup2MOcBTsXe4ok7viAdemGzvJS?=
 =?us-ascii?Q?mlvP1zAoZgDDJPG5s4xMNRamkNNPHM+rVKajiYWwLreQJV6GGqhdNvnJlhUM?=
 =?us-ascii?Q?/eXImxK/q32ePyfE2RtkUXBAcJ/lZyPRCFnB2TnujSP6vyaHSZ/SK8ENZEC/?=
 =?us-ascii?Q?B76ipDTuTntp1g2UUE5R5Yuzz8NbYYnD7Wk2ccW9qYUfrnQz9q3i81Z+Outd?=
 =?us-ascii?Q?3FyQ4wvidmN6jMsZ0QVz7z/puaazNFbM1V2BJaAEvLolex7b2j1HceP69BE3?=
 =?us-ascii?Q?+Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26e8b9ba-c9eb-468f-5cda-08da8ff45da7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 10:41:33.2231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KIof0ZEAOkVK5Rs7ogBZtO+UViQeSabpQj0pNQoB0Ci5fM6rLdxAEw0bafZ2/1/T+1L6tVbKw8zG9yJGP6S/Cww3O4t7sBb0vkss/IbrKbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6133
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, September 5, 2022 6:40 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: hkallweit1@gmail.com; linux@armlinux.org.uk; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH v2 net-next] net: phy: micrel: Adding SQI support for
> lan8814 phy
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Mon, Sep 05, 2022 at 03:47:30PM +0530, Divya Koppera wrote:
> > Supports SQI(Signal Quality Index) for lan8814 phy, where it has SQI
> > index of 0-7 values and this indicator can be used for cable integrity
> > diagnostic and investigating other noise sources. It is not supported
> > for 10Mbps speed
> >
> > Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> > ---
> > v1 -> v2
> > - Given SQI support for all pairs of wires in 1000/100 base-T phy's
> >   uAPI may run through all instances in future. At present returning
> >   only first instance as uAPI supports for only 1 pair.
> > - SQI is not supported for 10Mbps speed, handled accordingly.
>=20
> I would prefer you solve the problem of returning all pairs.
>=20

I will try to improve uAPI.=20

The other way I can try is the point you mentioned below to write helper wi=
th pair number and having function cal with pair 0.


> I'm not sure how useful the current implementation is, especially at
> 100Mbps, where pair 0 could actually be the transmit pair. Does it give a
> sensible value in that case?
>=20

We do have SQI support for 100Mbps to pair 0 only. For other pairs SQI valu=
es are invalid values.

> > +static int lan8814_get_sqi(struct phy_device *phydev) {
> > +     int ret, val, pair;
> > +     int sqi_val[4];
> > +
> > +     if (phydev->speed =3D=3D SPEED_10)
> > +             return -EOPNOTSUPP;
> > +
> > +     for (pair =3D 0; pair < 4; pair++) {
> > +             val =3D lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_CTRL)=
;
> > +             if (val < 0)
> > +                     return val;
> > +
> > +             val &=3D ~LAN8814_DCQ_CTRL_CHANNEL_MASK;
> > +             val |=3D pair;
> > +             val |=3D LAN8814_DCQ_CTRL_READ_CAPTURE_;
> > +             ret =3D lanphy_write_page_reg(phydev, 1, LAN8814_DCQ_CTRL=
, val);
> > +             if (ret < 0)
> > +                     return ret;
> > +
> > +             ret =3D lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_SQI);
> > +             if (ret < 0)
> > +                     return ret;
> > +
> > +             sqi_val[pair] =3D FIELD_GET(LAN8814_DCQ_SQI_VAL_MASK, ret=
);
> > +     }
> > +
> > +     return *sqi_val;
>=20
> How is this going to work in the future? sqi_val is on the stack. You can=
not
> return a pointer to it. So this function is going to need modifications.
>=20
> If you really want to prepare for a future implementation which could ret=
urn
> all four, i would probably make this a helper which takes a pair number. =
And
> then have a function call it once for pair 0.
>=20

I Will go for resolving this if I couldn't resolve that 4 pair issue in uAP=
I.

>      Andrew

Thanks,
Divya
