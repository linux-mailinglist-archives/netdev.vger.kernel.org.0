Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC79441D34
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 16:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhKAPPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 11:15:03 -0400
Received: from mail-cusazon11020014.outbound.protection.outlook.com ([52.101.61.14]:50426
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231847AbhKAPPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 11:15:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EP8pQLpVU5Jq9/UpVg9MPkC6mLHOF2nIDilrQcZWIXfTZCLRcuuQGiwZ9O8l/dH2ui2+EtwVGY9p7U7lHDF4TinVXWrRfi9pqnCQziDW8CwG2rC4FzBs5OvuAAtVNGdSKieNm3ZZ8gOvVCAEN9W86spY9N1NObvOtrqSIDPpRn1Nh4BhlbSVNx1KCtWuSzQwTM3dNi4cCUp16BHPf/EMuG11Z0LPp7t9/6oqG/2ErPVio5yi/1f4U10NkdkePBchRulFENcUfdO/9cEloQDFOcEtERBb6yBw8dt7q8Z/h2iR3IxbM+fgCnNTDBpa7utsqPNGeYMGjtZHAKjuQhRZ7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+2MQzWWD08W+JEyRjgY5mWXm8a8aNnY0k11tFcgOAK8=;
 b=Yeqlt7o2vVBguH+qUy8SMwf4xQ1A5F/EHHk9s7qX559XVApXwHd38JNf+Oz+sP5fkh1tBdtoLKTbt05HPHr1NwSL4I/5IuERQu/PsC0Q8J7cWnEjn5hfSAALUFD0eYf7Ndxe+sfOlN4lmH3rgxdw4ye/5h826kIxq4jy89QvCztgCJGRnGXWc4UqiyRw3UZuh70h4W/8RREObfb7I/OwZ7wKmP/0eMzqPdt/aKZrk/z7i9AKoYTRRP6pamAbL28BVvu3LDgTd822daeGRhR6k6aoqJjM8vkQkb+YzEiyaLMjifwVgGmqkHWQti+JvQegO5LkfUKCyoH2VPR65zLyyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2MQzWWD08W+JEyRjgY5mWXm8a8aNnY0k11tFcgOAK8=;
 b=ZweAvm1VIxGKevlrHemk5hZQOA/x22H0B/wTATuO80+Cku/8g7Y2ADpOa+5ObGb8AZacRgIxGe1KupAiRx5Pnp3wMlZI8uB2cGoOq1hqxqky3UUYb+BKiIBJRXZNpj8Xg8RRG4FVvTH2O4/PjUkyI5lIGJl2DZ95nzSkiUp0upo=
Received: from BN8PR21MB1284.namprd21.prod.outlook.com (2603:10b6:408:a2::22)
 by BN8PR21MB1249.namprd21.prod.outlook.com (2603:10b6:408:a0::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.4; Mon, 1 Nov
 2021 15:12:22 +0000
Received: from BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::5962:fbb9:f607:8018]) by BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::5962:fbb9:f607:8018%7]) with mapi id 15.20.4669.004; Mon, 1 Nov 2021
 15:12:22 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH net-next 4/4] net: mana: Support hibernation and kexec
Thread-Topic: [PATCH net-next 4/4] net: mana: Support hibernation and kexec
Thread-Index: AQHXzSi5FL+xs47DTkemjnXcBfjf5qvrr5YAgAKLS0CAAJBXoA==
Date:   Mon, 1 Nov 2021 15:12:22 +0000
Message-ID: <BN8PR21MB128460B5BE376A9E05D43418CA8A9@BN8PR21MB1284.namprd21.prod.outlook.com>
References: <20211030005408.13932-1-decui@microsoft.com>
 <20211030005408.13932-5-decui@microsoft.com>
 <BN8PR21MB1284785C320EFE09C75286B6CA889@BN8PR21MB1284.namprd21.prod.outlook.com>
 <BYAPR21MB1270A16AA0BF1A302BABCB3FBF8A9@BYAPR21MB1270.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB1270A16AA0BF1A302BABCB3FBF8A9@BYAPR21MB1270.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=38d1b54a-de51-47ac-a27e-8db573cfb9ed;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-30T15:43:58Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c452dabb-423e-46f0-ca93-08d99d4a0181
x-ms-traffictypediagnostic: BN8PR21MB1249:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BN8PR21MB124952D9D29CC37F33BE01A2CA8A9@BN8PR21MB1249.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4061ylCyDQFQIz3v+7CD8GQU6Gv1Jq0YXVO9jPYQSpoyuGPIYFVNwq+oGebudnA0ssNMlsOxlVGIYv1qtCCkzTkI1PgOisww+J9yb54ygs1/Oda7ATGV/iFw2YQMKtk+CxsWTEgXz2ker7n2UN74AMb06EuWHl5YR8SRqV2ACdfiEhX4EDd0d34KRfcUuMGArA4isF2BLagS8ZnlAVT6HsyFNxbgsPiJq260rPCem7Y0YOzKHNjMEguKgPJw8E73wE58VXfXaVOLh5gNKS14vg7MzmErPMTUHd4i5ycukDai72ZRZAQ7OxUH7WAxOF8tNh/ixSpJuyOC7sftZqfKcXw/b5Gu5o0m1tR5XULZnjJj7lewQeWB4Sx1rm1r4R9clsAjpOSv/fFiYxgp127oKWZCyMJ/Wg4uSxvPZ7VO/PER7o8GIu9aiwPvCwYJEGkFHDTeN6CS+ADAfSN6c1sdM8JwKsYyw88ckheR4oDX0tJI5i7ez5We6MilS4nZtOXH75+RbSYTEXW9bXCik4EuUJbp3UD2dHMl2RnLwsq3luRCpvstnO8JzPqBivyzqqiBddrz+wwh4Mq41iTj48GAe06Zg8e5ca8tYxyzTQQWHmlDO59gRseiUTVlG06L8W3X7f5XSqhFdizlF9/WwMDidYYcCFvq3ckjFnyjP3QZRSD1Uyj3Q/jYEiP1HXiwCZWaIXST/qaXAD5b7Ky6AJv+VA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1284.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(316002)(38100700002)(53546011)(4326008)(55016002)(8676002)(86362001)(66446008)(7696005)(6506007)(110136005)(66946007)(76116006)(66476007)(26005)(9686003)(64756008)(33656002)(66556008)(2906002)(186003)(52536014)(38070700005)(82960400001)(54906003)(5660300002)(82950400001)(71200400001)(10290500003)(83380400001)(508600001)(8990500004)(8936002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/3MoljpEnLbNSYAPCMx+4q/C65wgjC6Gp5HlStQuzPntaf8QuLsU9ubFCcyY?=
 =?us-ascii?Q?xWe4uLgeAQ5ro3k2o9s0e4vPjO3i6+yLoASBE06zlH6//oHKsSqbcQiwn21N?=
 =?us-ascii?Q?9E7faCT1EgIfKeWdXkSGZdRoPlBP7hwM1uQG9BgWpdhfMnN12BziWxKP3F0O?=
 =?us-ascii?Q?T0xuqi9rlLg+zj5whgqEeLbZGMyDD6RwAvse9KLGU/SybaH7f0PLILJj7AS+?=
 =?us-ascii?Q?eM1TErSCObB9i4K5ccd9DBvR8qeRtTF4GNEHhynbRhAE8UNYgKD91MexRP09?=
 =?us-ascii?Q?zjS7srD64f9lajl1svI4fuT63v92xHX/u20IhhA4j6Pp6mP5I5Vvu/pz5SHT?=
 =?us-ascii?Q?BXIdTrpOpS+cB3kcBG6WTe4nkPOTDJ9PFogXOsXt3+AmZ5oDFf0uZfH9/NqA?=
 =?us-ascii?Q?0LJsdcuQap/wRpfcE/R1QbNvXGDa4hIU6KIvmnm+98Vlffl8jl5HnCMLxQjx?=
 =?us-ascii?Q?Qox3hSRhzGM0kyGeG4oaMRocXbDypd2lTSj1xZQk3c/TDQNlWK+aoAIBpYrD?=
 =?us-ascii?Q?ZWLVNyApjeAkLmcaN2y6gP3VSvLr0fRjJSFXwE7hmMvwF4WyAM9ZVm/ICG9A?=
 =?us-ascii?Q?xkQqlohO74DvT0HzxiiWsLWpsr16xmdxh43sTvJEFB50Qlhge515yIFAS9Fq?=
 =?us-ascii?Q?a8jdJcHwLbaKWuy4uplMD2d1S+XBGaG4nBjObMdmHcHxajsKCZjb0d/Rqa0Y?=
 =?us-ascii?Q?KEdrW8DX46Opv+iAy3L7kunHCE1jF8U4CPvv8ZJui6WxlaA5eS1hlfSsytzb?=
 =?us-ascii?Q?ReL+B3Wtc2OL/kj+YE/NwO2flNLjjPcnnQ5AOIlz+qiqmMvkMYV7Awf1ZTK0?=
 =?us-ascii?Q?WkezsRdlYRVYlrWlbO61Um1hHtT/usALBd/PZoY8m6LvRxaSgZnhFoeMAkLG?=
 =?us-ascii?Q?+BrMA90kmT2B0d1sdu4S/hGoSLA3M8Ou6d/AhXEdKO+7Xv+4DMZyQ60DdARr?=
 =?us-ascii?Q?oNxC5pHFrkpOPYQLQJ2HU3+l7mgill2DdAX5O90KDnwIg5v596bL+yeO0Yao?=
 =?us-ascii?Q?1vY69Zjfa9sXngJGDt1QKb4IFE6LQnRBnofydhFSvMhl6NyINVo/9/wAomJ6?=
 =?us-ascii?Q?XN8sOpL6PILsZQ+POgADrt1HIjNEzzTQH+sqnlIXTCpZdbAm7u3fWfFaRLjk?=
 =?us-ascii?Q?0yGxa6RxTUKuVN8SZU6y+LRBRRKeVQc/NtkMe+tSv/9ZpROtk2zNaXamsxco?=
 =?us-ascii?Q?6OIPQmmUvY6tv5MlxylCLpZPHXTKdCCwYzgrprSEplvz4QULgsoQg6/hqdPG?=
 =?us-ascii?Q?VV7vjNTt6jAd8aZ1u1KrnnvwQCMSOgO9//OUbOkBCAFBxwgWxEA0X3KQHnqp?=
 =?us-ascii?Q?jWx2PRAwgLUHJEJnwoFUGwl9y0iynKFgLO+la3S7/6XAu9Ei7EUH45/iDVoD?=
 =?us-ascii?Q?DoQ7iXlr/8GkOdwX/P//BOyUw257sp78eP/q8/RwSazi9mDNQZqNnuAO0Yql?=
 =?us-ascii?Q?ot40uFtypyRIOWoJ7+flcvSD3GdQ50xyObHCEOUkrVwdv0YaYm9Zpr40HnL8?=
 =?us-ascii?Q?IYTQY5sN/JOWVmgtrHdiy08aO0jcGvwq/4upLu7tqSJpN+9UP2oHZgKbnNXV?=
 =?us-ascii?Q?WYop8ERt4ZCJshrS9imE0a7MfLZidBV5ctRkJcChfiITwwnj0hv3i6klF6BL?=
 =?us-ascii?Q?TQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1284.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c452dabb-423e-46f0-ca93-08d99d4a0181
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2021 15:12:22.6610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zurU5JRmbPkEOMpouE77teER2LKFDSDW+q0Hnm+u8IXXyKmeauv3FjSOQdNAHsZpx4mV5ifs20tbZuVgfvaINg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1249
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Monday, November 1, 2021 3:03 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>; davem@davemloft.net;
> kuba@kernel.org; gustavoars@kernel.org; netdev@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; stephen@networkplumber.org;
> wei.liu@kernel.org; linux-kernel@vger.kernel.org; linux-
> hyperv@vger.kernel.org; Shachar Raindel <shacharr@microsoft.com>; Paul
> Rosswurm <paulros@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>
> Subject: RE: [PATCH net-next 4/4] net: mana: Support hibernation and
> kexec
>=20
> > From: Haiyang Zhang <haiyangz@microsoft.com>
> > Sent: Saturday, October 30, 2021 8:55 AM
> > >
> > > @@ -1844,44 +1845,70 @@ int mana_probe(struct gdma_dev *gd)
> > >  	if (err)
> > >  		return err;
> > >
> > > -	ac =3D kzalloc(sizeof(*ac), GFP_KERNEL);
> > > -	if (!ac)
> > > -		return -ENOMEM;
> > > +	if (!resuming) {
> > > +		ac =3D kzalloc(sizeof(*ac), GFP_KERNEL);
> > > +		if (!ac)
> > > +			return -ENOMEM;
> > >
> > > -	ac->gdma_dev =3D gd;
> > > -	ac->num_ports =3D 1;
> > > -	gd->driver_data =3D ac;
> > > +		ac->gdma_dev =3D gd;
> > > +		gd->driver_data =3D ac;
> > > +	}
> > >
> > >  	err =3D mana_create_eq(ac);
> > >  	if (err)
> > >  		goto out;
> > >
> > >  	err =3D mana_query_device_cfg(ac, MANA_MAJOR_VERSION,
> > > MANA_MINOR_VERSION,
> > > -				    MANA_MICRO_VERSION, &ac->num_ports);
> > > +				    MANA_MICRO_VERSION, &num_ports);
> > >  	if (err)
> > >  		goto out;
> > >
> > > +	if (!resuming) {
> > > +		ac->num_ports =3D num_ports;
> > > +	} else {
> > > +		if (ac->num_ports !=3D num_ports) {
> > > +			dev_err(dev, "The number of vPorts changed: %d->%d\n",
> > > +				ac->num_ports, num_ports);
> > > +			err =3D -EPROTO;
> > > +			goto out;
> > > +		}
> > > +	}
> > > +
> > > +	if (ac->num_ports =3D=3D 0)
> > > +		dev_err(dev, "Failed to detect any vPort\n");
> > > +
> > >  	if (ac->num_ports > MAX_PORTS_IN_MANA_DEV)
> > >  		ac->num_ports =3D MAX_PORTS_IN_MANA_DEV;
> > >
> > > -	for (i =3D 0; i < ac->num_ports; i++) {
> > > -		err =3D mana_probe_port(ac, i, &ac->ports[i]);
> > > -		if (err)
> > > -			break;
> > > +	if (!resuming) {
> > > +		for (i =3D 0; i < ac->num_ports; i++) {
> > > +			err =3D mana_probe_port(ac, i, &ac->ports[i]);
> > > +			if (err)
> > > +				break;
> > > +		}
> > > +	} else {
> > > +		for (i =3D 0; i < ac->num_ports; i++) {
> > > +			rtnl_lock();
> > > +			err =3D mana_attach(ac->ports[i]);
> > > +			rtnl_unlock();
> > > +			if (err)
> > > +				break;
> > > +		}
> > >  	}
> > >  out:
> > >  	if (err)
> > > -		mana_remove(gd);
> > > +		mana_remove(gd, false);
> >
> > The "goto out" can happen in both resuming true/false cases,
> > should the error handling path deal with the two cases
> > differently?
>=20
> Let me make the below change in v2. Please let me know
> if any further change is needed:
>=20
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -1850,8 +1850,10 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
>=20
>         if (!resuming) {
>                 ac =3D kzalloc(sizeof(*ac), GFP_KERNEL);
> -               if (!ac)
> -                       return -ENOMEM;
> +               if (!ac) {
> +                       err =3D -ENOMEM;
> +                       goto out;
> +               }
>=20
>                 ac->gdma_dev =3D gd;
>                 gd->driver_data =3D ac;
> @@ -1872,8 +1874,8 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
>                 if (ac->num_ports !=3D num_ports) {
>                         dev_err(dev, "The number of vPorts changed: %d-
> >%d\n",
>                                 ac->num_ports, num_ports);
> -                       err =3D -EPROTO;
> -                       goto out;
> +                       /* It's unsafe to proceed. */
> +                       return -EPROTO;
>                 }
>         }
>=20
> @@ -1886,22 +1888,36 @@ int mana_probe(struct gdma_dev *gd, bool
> resuming)
>         if (!resuming) {
>                 for (i =3D 0; i < ac->num_ports; i++) {
>                         err =3D mana_probe_port(ac, i, &ac->ports[i]);
> -                       if (err)
> -                               break;
> +                       if (err) {
> +                               dev_err(dev, "Failed to probe
> vPort %u: %d\n",
> +                                          i, err);
> +                               goto out;
> +                       }
>                 }
>         } else {
>                 for (i =3D 0; i < ac->num_ports; i++) {
>                         rtnl_lock();
>                         err =3D mana_attach(ac->ports[i]);
>                         rtnl_unlock();
> -                       if (err)
> -                               break;
> +
> +                       if (err) {
> +                               netdev_err(ac->ports[i],
> +                                          "Failed to resume
> vPort %u: %d\n",
> +                                          i, err);
> +                               return err;
> +                       }
>                 }
>         }
> +
> +       return 0;
>  out:
> -       if (err)
> -               mana_remove(gd, false);
> +       /* In the resuming path, it's safer to leave the device in the
> failed
> +        * state than try to invoke mana_detach().
> +        */
> +       if (resuming)
> +               return err;
>=20
> +       mana_remove(gd, false);
>         return err;
>  }
>=20
> @@ -1919,7 +1935,7 @@ void mana_remove(struct gdma_dev *gd, bool
> suspending)
>                 if (!ndev) {
>                         if (i =3D=3D 0)
>                                 dev_err(dev, "No net device to
> remove\n");
> -                       goto out;
> +                       break;
>                 }
>=20
>                 /* All cleanup actions should stay after rtnl_lock(),
> otherwise
>=20
> For your easy reviewing, the new code of the function in v2 will be:
>=20
> int mana_probe(struct gdma_dev *gd, bool resuming)
> {
>         struct gdma_context *gc =3D gd->gdma_context;
>         struct mana_context *ac =3D gd->driver_data;
>         struct device *dev =3D gc->dev;
>         u16 num_ports =3D 0;
>         int err;
>         int i;
>=20
>         dev_info(dev,
>                  "Microsoft Azure Network Adapter protocol
> version: %d.%d.%d\n",
>                  MANA_MAJOR_VERSION, MANA_MINOR_VERSION,
> MANA_MICRO_VERSION);
>=20
>         err =3D mana_gd_register_device(gd);
>         if (err)
>                 return err;
>=20
>         if (!resuming) {
>                 ac =3D kzalloc(sizeof(*ac), GFP_KERNEL);
>                 if (!ac) {
>                         err =3D -ENOMEM;
>                         goto out;
>                 }
>=20
>                 ac->gdma_dev =3D gd;
>                 gd->driver_data =3D ac;
>         }
>=20
>         err =3D mana_create_eq(ac);
>         if (err)
>                 goto out;
>=20
>         err =3D mana_query_device_cfg(ac, MANA_MAJOR_VERSION,
> MANA_MINOR_VERSION,
>                                     MANA_MICRO_VERSION, &num_ports);
>         if (err)
>                 goto out;
>=20
>         if (!resuming) {
>                 ac->num_ports =3D num_ports;
>         } else {
>                 if (ac->num_ports !=3D num_ports) {
>                         dev_err(dev, "The number of vPorts changed: %d-
> >%d\n",
>                                 ac->num_ports, num_ports);
>                         /* It's unsafe to proceed. */
>                         return -EPROTO;
>                 }
>         }
>=20
>         if (ac->num_ports =3D=3D 0)
>                 dev_err(dev, "Failed to detect any vPort\n");
>=20
>         if (ac->num_ports > MAX_PORTS_IN_MANA_DEV)
>                 ac->num_ports =3D MAX_PORTS_IN_MANA_DEV;
>=20
>         if (!resuming) {
>                 for (i =3D 0; i < ac->num_ports; i++) {
>                         err =3D mana_probe_port(ac, i, &ac->ports[i]);
>                         if (err) {
>                                 dev_err(dev, "Failed to probe
> vPort %u: %d\n",
>                                            i, err);
>                                 goto out;
>                         }
>                 }
>         } else {
>                 for (i =3D 0; i < ac->num_ports; i++) {
>                         rtnl_lock();
>                         err =3D mana_attach(ac->ports[i]);
>                         rtnl_unlock();
>=20
>                         if (err) {
>                                 netdev_err(ac->ports[i],
>                                            "Failed to resume
> vPort %u: %d\n",
>                                            i, err);
>                                 return err;
>                         }
>                 }
>         }
>=20
>         return 0;
> out:
>         /* In the resuming path, it's safer to leave the device in the
> failed
>          * state than try to invoke mana_detach().
>          */
>         if (resuming)
>                 return err;
>=20
>         mana_remove(gd, false);
>         return err;
> }

The new code looks good!

Thanks,
- Haiyang

