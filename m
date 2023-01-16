Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD7566CE9A
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbjAPSQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbjAPSPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:15:53 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F881206E;
        Mon, 16 Jan 2023 10:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673892190; x=1705428190;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ea9xxSSSWw3tm4S7t+DdGGvJKuh8rnL7+iKnpW+sRj0=;
  b=v/+hw4UdBe7KKDet6zgqX/wVwczJMc6SACA+pxy2o0Bnk3t5CedJK+UZ
   wIO3cGljQGIb9Z60EzpQtjXBqXJkpnJ8BbNdMij8sOoeLCNFUHsG/hIAX
   OY+RDl98tsjWz7ZoVDqQZbhHdn5VMuiz68Jy56Iuh1yEv14Mj6mb8hkYm
   0+sRzDiAynbY9hUsaGIpXson3Ne7AVw74SaSZiq6X4abBZ7dzub4Kgdwo
   uH2XXorNwetOGZZZw/KBYUr0K1P2bNuBdlBT9B9aAZCoOnm2nDCDnvI7J
   wqLEkfa76GcMPN9SmAL1wp2sj3H5OZ10RVw5tX8R224fxXcjwazng/611
   w==;
X-IronPort-AV: E=Sophos;i="5.97,221,1669100400"; 
   d="scan'208";a="192479609"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jan 2023 11:03:09 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 11:03:07 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 11:03:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXxIqWkPTOWVF8/SKFVttKKqPVH+PjjnRyEdM3gYy/aC3x4f2BLWg7yfL9TmWA+VDRATJ9b9dhwz7zTl37d40RrQnkw5usrTRKkXjp1mWDcopYw5CNsKncw17tuO+3NS2o555NPCtmL2SEq9WMvCFkJVdDKGmEEi2BYsQdIgfHLaE6Gvg+45in/Cy4FbrksMZGqMXpKfBshaObBTeevuqCt6+/ZROyyN0UBefylBYM6+HtKG3GYhRn098sXlPBJ0Vfr854cAN57bg1sNOrJLGKocz4+tdXqxXkYWfq2VBsbpNFkfigopTIKh4NsRQ+9lsx8WMj/tysJdhMYHMLWiAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W2715M04y4mEehPAOYKMm2Ie9Umqmqn1fp6uxzX9Zf0=;
 b=CPd3vMtTK9ZZArFRdwahr/h5o2m2HNji6Ux7FZaEc6ir9r9w/ZtfzvOAB61SJFRvA3ttiPjjGPOB6+rhU7v7pgErrTFUHpsYLunH3QJ1MkbQp64VVn7lNpivQyV93vwn6Rx3Gwu8o4jLG1u4btev3q7AABcyhM+ro9yD2JyzYLnvaMn5SsGM8Xlq+cWnwopu+zcU3LPEqoLzapr80BhSzktq3y3nVCilJoo33x8ujc/TVO5qlwwg16EI9DsGnBGg0qfKVudJ2Ex6Pq/dTJoDIkHbbpo9CXINnAcmUWcQnx1kuosikfQpQLfwgZMaD6T0r6jleuBJ9T8UcvSOG8JxDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2715M04y4mEehPAOYKMm2Ie9Umqmqn1fp6uxzX9Zf0=;
 b=NjXxcS9DW0oc9DFrWaojf/TH3+pkcAXv14i6gvvfG42PZBKf2vWyGYj0GXmO/IReppwLP73lyFYh73vgjEG47NSVOkQVsrdaz/izURxtytm33EG3RJVX09dz4pkXcCbOnyPA9EEvNtVVflp7Q1kmu9jJIwLoWSzNoj6xXcFjnz0=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by IA1PR11MB7679.namprd11.prod.outlook.com (2603:10b6:208:3f1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 18:03:02 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::3558:8159:5c04:f09c]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::3558:8159:5c04:f09c%4]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 18:03:02 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v6 2/6] dsa: lan9303: move Turbo Mode bit init
Thread-Topic: [PATCH net-next v6 2/6] dsa: lan9303: move Turbo Mode bit init
Thread-Index: AQHZJHABkK7DClBc80KHKpZcwORjQq6eaqUNgAL12sA=
Date:   Mon, 16 Jan 2023 18:03:02 +0000
Message-ID: <MWHPR11MB1693247B3AA9D532B1B0E1ADEFC19@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-3-jerry.ray@microchip.com>
 <20230109211849.32530-3-jerry.ray@microchip.com>
 <20230114204943.jncpislrqjqvinie@skbuf>
In-Reply-To: <20230114204943.jncpislrqjqvinie@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|IA1PR11MB7679:EE_
x-ms-office365-filtering-correlation-id: 8fb20dc5-25de-4bc3-b771-08daf7ebe90e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +DSwtvMCcez2bZ9592RNKlPuyMpcuLGE9u+IhtMVt+qFvM/jtNpZuSCZo46cOQ9y8XJRN2S/3g9QVVkTv29oV088+4Z0yTBZ/9VBvpc9xOVUf8QhP+zEjww4Xhvrp+T1O1tCt3YXWdOgwXeqWhuaXSh8yUFtHcPNDobSEhmZMj9OmO6SeZzgHjWnkYraVth0q7j7tt5qoumCA5/UTY5kjp1uh9CZG0iLuNKk25u4+S3KvgE6oUhWGbmS++3h2pmZBXlEARyq3KvFms1XMVzMAHKsjueAwufJ7p9HG/2Tfca8V9HvN3a55NhFjfrui4gl3WBTCs2kVCukgaOvczYk4VlGQ07dndyu8sYcExLUMIHfnPsZkVF9KxAZ2VUIfpbnhGsb/TWCrNH9pFGYCmgHec26p1idPDlluD3/TC1sgJTz20OmXU9ZultcEdTTIkJyZ00LaW59wvP3MS2UP+YKSv43i1oTTwU/HHvlZ2wrmIVEOnp0G9sxQ7oWaTlw2DvYPsoaIcW5ZB1m4rokAvBUxov/DKhpCrhSjuDOSdpaazKvScJ6/C/gqy52xGWOuqnj4WMMT4cfBh5Pq/Kj1gS07uush2EgTiiCtJ8NePrrGNhIyzWLKeAivkm7gHB9P9vcQ6/4vSg/GXK+7CTDDaLFEH/o768NgV6N/LOPSDvCmWuB2cC4ArVcCyAexJEsCRLVc/Q4YTn9Oo8DFffpSf3mZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199015)(86362001)(6916009)(38070700005)(76116006)(66946007)(64756008)(66476007)(8936002)(55016003)(66556008)(52536014)(66446008)(8676002)(4326008)(2906002)(7416002)(122000001)(38100700002)(83380400001)(33656002)(5660300002)(478600001)(71200400001)(7696005)(54906003)(316002)(41300700001)(9686003)(26005)(186003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?42tee2nC5UMFQNPHiVq75xCbSRR2XoPaPOpTtZ7fLej81s9Q14vH+qiPslL2?=
 =?us-ascii?Q?qTqY0AZ0w4O0Hh7OsbSjiijneEs3FxcnjT+kRrP79DOwHI19vHV3T7TZRIDe?=
 =?us-ascii?Q?1AsdjM45NGQiieSv6ZeF5Yp6SQX8bXxo6M8fKDa6jo7YiAFLf7r9LMG+CB9/?=
 =?us-ascii?Q?qA8OynFXrQaq0sZuYyj2j+W1ulxAsAIujzd7tQukiOwrK4z3Hfa+O8/mLOiA?=
 =?us-ascii?Q?Bu0wvxLWQCTNQnFRa5p+YiAg+IjonSw4nw7YukTQrPVcKdyDOneH15E5ZIag?=
 =?us-ascii?Q?DhjOBv+L8YysxbhrrzgM8SaaZ17bR+uqeQoeMSbTlqYuKGxFjXY9kExfu5FH?=
 =?us-ascii?Q?ZWT1BlqohvNiGMjSoPZQUNq5ZwxZ8JT4/9d7afA5T3OikYK6CCfRdCTJOaNn?=
 =?us-ascii?Q?AflIY43sxYP0JEDWF4Oi4NcJkQRIX0qAePzOrJXA0xLP2b8wP7LeQeZNWO39?=
 =?us-ascii?Q?sWqYQl4ZXLvjmJC+rQA3zsmXyJwSGs1L/CBoGdhwTDC2edLdqaJDfUIu9gRy?=
 =?us-ascii?Q?AF3ScdUT4jWM+5Z3h4dqc/aAP8PcsoCmB7F8t2dtdmeRcN0qlAMYj0gCs6Pw?=
 =?us-ascii?Q?+FKKC1oEb2T5PsOxQQOUSXrnEqvqL8XCQThpixr5sTS+716drYE8ZXrXH3JH?=
 =?us-ascii?Q?5jMmKa4Hk3lU6J0fVvRdRn43yUy5c342kdBKqRPqIJbgsJEOy0iN3IOKhkWJ?=
 =?us-ascii?Q?K5Yq6+F0Z6VG3lQtiC9qnWQLn321T3qinxw6YQGnoqmAoofI5RZPsBQR+Uf1?=
 =?us-ascii?Q?hKSAq7uw1aAxZuK2UhY3iZzQgu8Wqi/TSp53STtRtqwDXtO4nNQGJYpuhdPk?=
 =?us-ascii?Q?9A14znCjIzHqHgrptT9u+CneprsmmFa6fprvG3LURINb0ZBnzB7G98jgWPUY?=
 =?us-ascii?Q?dUbFWxxcxUJJ5D2bFUKD2h5XVSSfOleYGKcksccO07Uhow7CQKBzTDL8FG5T?=
 =?us-ascii?Q?6fqDxz3oreCu2bVCZT1C26NjRaDoy8jblGSOOsKZ6SRc+YZ0nUxmnHPros3d?=
 =?us-ascii?Q?ZzFXUrkGBKgJbjnYM7ILj3GoZ6xCU0G89SNlL1jswb7DM5uP3W+hHCshbxNy?=
 =?us-ascii?Q?+cRsNFlkFnaSrqHFz/s9kX7MZKmlMOW3SW6IVblFLxkVLjt7N9H5zQlDySsx?=
 =?us-ascii?Q?gifPghzQS+T9NW6pD5bFz5Ffr8FwQo67UxO6tlrqqT0xhNOJ57tW49xhfuA8?=
 =?us-ascii?Q?RSYLJm+e44Ff60lgGdCKPRrn9fTmLYupfJFJJLRDOPgvrDlgIixbikdJ8AOi?=
 =?us-ascii?Q?HpyJ654IHylFLWQ/kCqS5rOdD55vDpn5PrdfQMNCLl259A0hX/5l3NG2WuFh?=
 =?us-ascii?Q?XK+P2J4Do9/z4FMobCp5hPQhctk6VpQdhcuJka11cRiy100ikgjdSVM6TbUg?=
 =?us-ascii?Q?wV0657ED70pkdgyVXGJ4zaj2ee1N9+dpsfvDrEwUUEN8i+3xmRLOHrGpeg5l?=
 =?us-ascii?Q?skW944amLKnVA1wIeqtFVtq7BQAaQOY3BcTiyT/0wMMN7MNJW4/KmnSNWW1w?=
 =?us-ascii?Q?cUWyHJbpl48GbsORDHvJR+M6UC2ATL1VrOftG01fFr4GY8S857DvvJS6l8kO?=
 =?us-ascii?Q?xFWsb6DkQ3QvySlqkSy1uwsHwJG1e6AUIarvhd0Z?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb20dc5-25de-4bc3-b771-08daf7ebe90e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 18:03:02.5465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZiCxJJr2DhVI3riHjFi77Zxt4Tn04+xDC+THr1CLrVjqSavUEl3FPgVbHlCmGfE8XxgYlRjwGMn5YaM1/Pztjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7679
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> > In preparing to remove the .adjust_link api, I am moving the one-time
> > initialization of the device's Turbo Mode bit into a different executio=
n
> > path. This code clears (disables) the Turbo Mode bit which is never use=
d
> > by this driver. Turbo Mode is a non-standard mode that would allow the
> > 100Mbps RMII interface to run at 200Mbps.
> >
> > Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> > ---
> >  drivers/net/dsa/lan9303-core.c | 15 ++++++---------
> >  1 file changed, 6 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-c=
ore.c
> > index 5a21fc96d479..50470fb09cb4 100644
> > --- a/drivers/net/dsa/lan9303-core.c
> > +++ b/drivers/net/dsa/lan9303-core.c
> > @@ -886,6 +886,12 @@ static int lan9303_check_device(struct lan9303 *ch=
ip)
> >               return ret;
> >       }
> >
> > +     /* Virtual Phy: Remove Turbo 200Mbit mode */
> > +     lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &reg);
> > +
> > +     reg &=3D ~LAN9303_VIRT_SPECIAL_TURBO;
> > +     regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
> > +
>=20
> Isn't a function whose name is lan9303_check_device() being abused for
> this purpose (device initialization)?
>=20
I will move this into lan9303_setup.

Regards,
Jerry.

> >       return 0;
> >  }
> >
> > @@ -1050,7 +1056,6 @@ static int lan9303_phy_write(struct dsa_switch *d=
s, int phy, int regnum,
> >  static void lan9303_adjust_link(struct dsa_switch *ds, int port,
> >                               struct phy_device *phydev)
> >  {
> > -     struct lan9303 *chip =3D ds->priv;
> >       int ctl;
> >
> >       if (!phy_is_pseudo_fixed_link(phydev))
> > @@ -1073,14 +1078,6 @@ static void lan9303_adjust_link(struct dsa_switc=
h *ds, int port,
> >               ctl &=3D ~BMCR_FULLDPLX;
> >
> >       lan9303_phy_write(ds, port, MII_BMCR, ctl);
> > -
> > -     if (port =3D=3D chip->phy_addr_base) {
> > -             /* Virtual Phy: Remove Turbo 200Mbit mode */
> > -             lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &ct=
l);
> > -
> > -             ctl &=3D ~LAN9303_VIRT_SPECIAL_TURBO;
> > -             regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, ctl=
);
> > -     }
> >  }
> >
> >  static int lan9303_port_enable(struct dsa_switch *ds, int port,
> > --
> > 2.17.1
