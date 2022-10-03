Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91465F28CD
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 08:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiJCGyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 02:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiJCGxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 02:53:47 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8143FEC9;
        Sun,  2 Oct 2022 23:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664779978; x=1696315978;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=32eNzk2rDmHyC+LBY/gMofTRRxfx3PdRxeai54qgqAQ=;
  b=U6l78ATmk4dYdZLO//12idICzRYUO40X5SkMifOi+jex+BSZ+4ET6uoX
   dOYyxeCdlmCDQTUVm1/K/raN8S0f8Ol10lU7m8k9falAgkjtZOw7/+aMi
   ETzHNnKTYslXlTqlTk4pN8evtBMCy8FewZju2w/H7abgR3a9ZhJ+0ry4G
   FLUV5vUYYSN9NJHxzJIrBlGleEtI6xZuO9ILnDsDfhe6S+QEyJw8l/3bX
   1ZRD40kFSuwYBxhxcOGNzTELldcPpZpJL89+T+jNqRSTju/R386VYvwKG
   1PqaAUeFKOwT2l3XQa7Sj8ihxGYFkHGKPqttbaYj68CWhTk0Fnu7Kti9N
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="182937782"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Oct 2022 23:52:46 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 2 Oct 2022 23:52:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Sun, 2 Oct 2022 23:52:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8AGbORRGcEa5qMC9YDqAUJ0p/iniQyBpol3FkS4Xzh36sJ6MwCt/u3xmmwDdsGS6f4x4ZDmAwe3Qzv1wXWtgjvsFijdoPE1yJBqV8nSW5U0pHFsmVuP3F7ETKx59Q/IlR+ljAsFHu0VUy69RCACqJ0oWbuto83lGOc4/4InrKN2/rJ42N8vgerEvjyGH45HZ/99DNT/TC/T5QF/2gPlvgE11bGRPtevF4H4SWoEuMHv2nn9roqjr1CDnA5/QlrtpXVwht0hdd9pmMLH+5zxzy7NgJSX0d2ZdOAqI7R+boVLlxCUHAoCVzjsh3bl4MWheuyGkWDm3JStG8psJzEIIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrP29YBXnPjZa6pAiMs4OUpMXumyt17hAvorH0X/TQk=;
 b=FizkHHRhG5MPQLPb6A+nDhVRtKsuulcZLb39avf7Dj7l3WIIjOlfxSrOQJT7bqul6yk8ztoTvTjUOMc1quyzaER+5us5selQ0HVCdW8m6wX0x5E6glk3/0onXGgpZYSbmmE7SUQ45UUeUW+b4zJzQ9WE613+ext6jiWWN6CkEk6qHLWgIrVkU+rnoAjF5M/rHF3F3UEIc2jRYILIueywsMHxiPUgn4Yk8ZvGS6MO/7e2Q6UE7GWzs1VnXSe7ahd+7KUl81vWvmJ+WoWZoSejbEcPrSsJ/hW/SwAOhRR/5szrj8t88GzA/bP6QDSeFAZM/ncgmTCrx4grt10MzrS9YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrP29YBXnPjZa6pAiMs4OUpMXumyt17hAvorH0X/TQk=;
 b=bqiL83xXu+Nj0Ul7Dz2x198tRzou1cyjtrYtSKL8cI0QUHKr2TIv2CzeRerLhL3SZlIzQYUSHqpX7v9qnz49n3ezFGA39MuEsnhGx24Ti1wz3mSwDVtDak6M68dyOmZJXlqYDHnujZ4KvMVW8XFqnuWFk6+hvlkdhODes+/ZiCw=
Received: from PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Mon, 3 Oct
 2022 06:52:40 +0000
Received: from PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::782e:76ed:b02d:c99a]) by PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::782e:76ed:b02d:c99a%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 06:52:40 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 4/6] net: microchip: sparx5: add support for
 apptrust
Thread-Topic: [PATCH net-next v2 4/6] net: microchip: sparx5: add support for
 apptrust
Thread-Index: AQHY1DNZUjZtLK0dzEirZyaNJNiZ+634H/uAgAQj3gA=
Date:   Mon, 3 Oct 2022 06:52:40 +0000
Message-ID: <YzqJEESxhwkcayjs@DEN-LT-70577>
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-5-daniel.machon@microchip.com>
 <87zgegu9kq.fsf@nvidia.com>
In-Reply-To: <87zgegu9kq.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5580:EE_|PH7PR11MB7003:EE_
x-ms-office365-filtering-correlation-id: 5ac33ba4-3d5d-4de4-c8c2-08daa50bdd75
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3JtRC9PALIstT/VaSMo8+ICdRCs5nQxX2yAaLYM4XmMEgExifo5y1ouXwFmRuXBGFJD+2/BD0LSg0dZ738IvQTup5VjO7sk06qGlXehq+y1FIUhx1lcRDgVD4vD7H3jTxtDlvZbSq87PeyoWL1EpWF4bYMll8Zp9NkZuoLPzgkvJL7RGLSVUJI9Xpcb5tYeRj3dTOzQ7Hlnky4joYNW0fCQ+dhNCDBNlsDhiN/gV8/6bSAKhv2AvyahJfzOfrT/VfVQoIXr+xAIT4GG1HBsN84+KxQak9aEH40xGqzIJaG3e0eND0a2QOW2wbBYMk6U8U7yNe8TIHFdGioH8XAL11g+x1Y2lRbJrzyUyxeA2CQnrUBpB5hxOuZvB99zLpTrWqGoV6z4QZn7tyzRPxyWa8FRBTtI8E9nj0MLOOHs6hfOt6V4BKzn95tO26WEW3m5PQdTzTN6b6YXLSn3at/k6OB1i+WwKJ8aLWvrsAdJnBSYamPZZOnKMUHTC8M+y4Y+nCCOk7GD1UwoW7di1wrpvKeV2Fx7uAE8wTx3HU1+qLNpRK0Ku29s29cLClY2rCFjD8x91kIn2ik0HQkcE5E3JHg5gUIPYnZ6Rws8TLPiV0MsNRNS4tTafiIb5XcSo02FRHIoXvDGbrstF6ZYvTXpEeNV4ksTI1L87r2o7Tb7taKOwTiUZSKOPLl94sU05jniZrP6gpLwFaZzUwi/4H/bntXroMGVK/b3aNYzYw3itPi116ePEjZERFUo4rErarAPIxNYdrfEdmZodQDG41BpodA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5580.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199015)(7416002)(8936002)(5660300002)(41300700001)(54906003)(33716001)(6486002)(38070700005)(91956017)(71200400001)(9686003)(478600001)(4326008)(6512007)(76116006)(26005)(6916009)(6506007)(316002)(2906002)(64756008)(66556008)(66476007)(66446008)(8676002)(83380400001)(66946007)(186003)(86362001)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PdCDmJfpfRTkWX6vxT1JJdofJD5+c6GyatKIaFTxcWNZZFJQM+lEUQ4j06ZW?=
 =?us-ascii?Q?eiBe5D1bBl5gOkDuAZMQLldAhMaVvU0leJBVCJ6c4OGI4xG0UN27sWyq8IVF?=
 =?us-ascii?Q?6WWZEWsGTg1EjruixsoRHBHMQSSPTj3ByOgtvZch1x0bqGxS1AeDpwvplPt4?=
 =?us-ascii?Q?5ZaSrP5sHa0g3Fbn0WQcIhiRmfqMiUDN/6ZQyHlrgh78ZIgds4BpqdIaNKZx?=
 =?us-ascii?Q?d8oY3tfxUG5GJJgBZRxkEPSG4BSyXFalAhZ2LH8FwMv7qF0f+wmu3QqGBeJ2?=
 =?us-ascii?Q?2x05kUEq4AQSlXEGiCczYfyJP3FldCwEhOKtUO3KJjdv52SKUIvGQ2kQHKwq?=
 =?us-ascii?Q?ARrSdChL8Fb2FpNEntWSM/UQ4J3FHHtV4J+PDLWvsYJYIXFV8WGmJyt+X+9H?=
 =?us-ascii?Q?XQJiUFdyVoZVk6QVX3G22KjTzDraXwqgYz4cR4UC2hgDA9eRIdw+slggW8V7?=
 =?us-ascii?Q?U5OEnT1xAynPQTR7mTvtUQYTdkoI4FtLKFJNleFN2kYo0WG8V7okbK5o6Han?=
 =?us-ascii?Q?+y55tchxyUINbO4X6tWrIpSiO/jluFyq7U3X+swdLPYrOtxU6Ao/mSo4lM7M?=
 =?us-ascii?Q?iWZkPmxRtcb7ioLFxe4wJ+7iOxtIxQ+L6nuFB6zIZmXTYBQZ9W0aaWJYDrUj?=
 =?us-ascii?Q?eUby1zERymv8+nbIuHhStWBx96Ie3l2VgS9LRKDkqfxUv2Un6cC7X078ozOt?=
 =?us-ascii?Q?1ey8wc3oUSsirq/vR955H0KRuUbh/UsfLv0ZNoJSDQONCbWywC5ITYSvZw7O?=
 =?us-ascii?Q?Vk9HSHYNodfBZijQu/hsKsVaqXEzWhGfkSjxeVUv0GsRuJ6CFiZ0180GGk+F?=
 =?us-ascii?Q?zrbqicO/84v9Z2F8q+je1NOGTdt1BncSINqZgvwV1yfNvLnjPV1uDCfnA68f?=
 =?us-ascii?Q?5JXiA0jvyoYfG65HhrZzwGXisogXKJdGpPM5yXDRcalubvOUsq/FUiYboUVa?=
 =?us-ascii?Q?QH/bDY39awJSp01pHTK7MvjZ1D29v6PELNzfE6d90jyTgeb48pFGeBt8Ug7z?=
 =?us-ascii?Q?fcChjEK7Jdiasp7xuu2hfShy62AZtT8ZMhDvaDYaPIkKLl006B9dUAycYcS4?=
 =?us-ascii?Q?krfOMkr48EALTGT3UX2fQJrjlJ9TB9ClFsaYrfjNvec1iYKVPLcrlutzS+kx?=
 =?us-ascii?Q?dh4FfFkqefK+YYoLVq6FM+ZNlfRj0BUiIgeUxE+50iIDlZ2pnkiEpPD3zj49?=
 =?us-ascii?Q?H4ajVNLJWsqaf1Wp28wFhpEn0sx6cfCya+z+Q11x50f30UeQB4oCCMjXNJ4P?=
 =?us-ascii?Q?k3jHteaoLObVPD0G96lzOlrQ2nDoXV1GtI0iOnFwhdMdoJimCTARLPoXhiHX?=
 =?us-ascii?Q?6mpIH4s7qlVFzkPxUtlJLtq+Nzwi1fdqUo9gBbho4Ca+nqQo4CDvTpqDhjD4?=
 =?us-ascii?Q?0afqcZNwPLofncaJ5OpYyYyt5yIx2WOZmL+OHlvPEcHWt45yVUkhjDNkCWws?=
 =?us-ascii?Q?8fjtcL+5cWgQTUdQnXkt+nav87aasDZkRagYvkaNBffCgi+hk4kJFZQAxM4C?=
 =?us-ascii?Q?GSV7FKQDWlyK0CFrSu/nj8oyVskU+3iZanaeMlwDJPTNNUvpe046baleBjf8?=
 =?us-ascii?Q?JtdR0CAwx+XNwrty/cHGBVyrvcgG3uQUXu99szfPS6sAVMr96OPkUpOziHfb?=
 =?us-ascii?Q?+UFFr/1m8BxDGGSvlM5yyO8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <60338EEAB13D4E4F84E1B1B2752D1930@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5580.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac33ba4-3d5d-4de4-c8c2-08daa50bdd75
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 06:52:40.4429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 22b6suNOsO5JVSS3Vs/CysvHqdezmNG/3dLAAy85aqYAgp08P/WEk5OGmWWq09p2B0EMzuoFf/rrqBDt9KJ9ABwnD/l+O09renwzH1dY/JY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Make use of set/getapptrust() to implement per-selector trust and trust
> > order.
> >
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> > ---
> >  .../ethernet/microchip/sparx5/sparx5_dcb.c    | 116 ++++++++++++++++++
> >  .../ethernet/microchip/sparx5/sparx5_main.h   |   3 +
> >  .../ethernet/microchip/sparx5/sparx5_port.c   |   4 +-
> >  .../ethernet/microchip/sparx5/sparx5_port.h   |   2 +
> >  .../ethernet/microchip/sparx5/sparx5_qos.c    |   4 +
> >  5 files changed, 127 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drive=
rs/net/ethernet/microchip/sparx5/sparx5_dcb.c
> > index db17c124dac8..10aeb422b1ae 100644
> > --- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
> > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
> > @@ -8,6 +8,22 @@
> >
> >  #include "sparx5_port.h"
> >
> > +static const struct sparx5_dcb_apptrust {
> > +     u8 selectors[256];
> > +     int nselectors;
> > +     char *names;
>=20
> I think this should be just "name".

I dont think so. This is a str representation of all the selector values.
"names" makes more sense to me.

>=20
> > +} *apptrust[SPX5_PORTS];
> > +
> > +/* Sparx5 supported apptrust configurations */
> > +static const struct sparx5_dcb_apptrust apptrust_conf[4] =3D {
> > +     /* Empty *must* be first */
> > +     { { 0                         }, 0, "empty"    },
> > +     { { IEEE_8021QAZ_APP_SEL_DSCP }, 1, "dscp"     },
> > +     { { DCB_APP_SEL_PCP           }, 1, "pcp"      },
> > +     { { IEEE_8021QAZ_APP_SEL_DSCP,
> > +         DCB_APP_SEL_PCP           }, 2, "dscp pcp" },
> > +};
> > +
> >  /* Validate app entry.
> >   *
> >   * Check for valid selectors and valid protocol and priority ranges.
> > @@ -37,12 +53,59 @@ static int sparx5_dcb_app_validate(struct net_devic=
e *dev,
> >       return err;
> >  }
> >
> > +/* Validate apptrust configuration.
> > + *
> > + * Return index of supported apptrust configuration if valid, otherwis=
e return
> > + * error.
> > + */
> > +static int sparx5_dcb_apptrust_validate(struct net_device *dev, u8 *se=
lectors,
> > +                                     int nselectors, int *err)
> > +{
> > +     bool match;
> > +     int i, ii;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(apptrust_conf); i++) {
>=20
> I would do this here:
>=20
>     if (apptrust_conf[i].nselectors !=3D nselectors) continue;
>=20
> to avoid having to think about the semantics of comparing to all those
> zeroes in apptrust_conf.selectors array.

Yes, that would be good.

>=20
> > +             match =3D true;
> > +             for (ii =3D 0; ii < nselectors; ii++) {
> > +                     if (apptrust_conf[i].selectors[ii] !=3D
> > +                         *(selectors + ii)) {
> > +                             match =3D false;
> > +                             break;
> > +                     }
> > +             }
> > +             if (match)
> > +                     break;
> > +     }
> > +
> > +     /* Requested trust configuration is not supported */
> > +     if (!match) {
> > +             netdev_err(dev, "Valid apptrust configurations are:\n");
> > +             for (i =3D 0; i < ARRAY_SIZE(apptrust_conf); i++)
> > +                     pr_info("order: %s\n", apptrust_conf[i].names);
> > +             *err =3D -EOPNOTSUPP;
> > +     }
> > +
> > +     return i;
> > +}=
