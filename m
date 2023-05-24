Return-Path: <netdev+bounces-4871-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4657470EEAE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 08:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBA3E2811E3
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 06:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F97A46BF;
	Wed, 24 May 2023 06:56:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9C23FDB
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:56:17 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8550A1711
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 23:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684911374; x=1716447374;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bqmp+8J8NY3g7s/TwEl8t0mVuX6sisOCPUN0vEvc8Wk=;
  b=WH3q1ebcO5UndGD+xe6xMadox81ZFKSvuDoCd9mRBuuG2/ZX6FSnDhs7
   u76Ut6WGZf9xMdGlmkqfeFaXb/LLp5eIJad1YxBKDsML9mKADOYsiNDBW
   4E8xiWlQUK0vZqSWfPJuR59/SPYDuRuCqoRKodqOHpWnZeehsgEzrDzfi
   cYtnZ2DyqHjUeJ7t8t343tA3H+g3RGDp65k2rLdq+012B/eo9Y/9e1Agz
   3UU4sbBKgsKnTTwgw1shC8vp64o8QqiVKGMOYD9z7+zrzUr9Q9APQBpt9
   ralltgIukM4lCavK0obP312WFOC3FP6688c1I6GYIIvYnIdOjtIR7OC//
   A==;
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="153651172"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 May 2023 23:56:13 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 23 May 2023 23:56:13 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 23 May 2023 23:56:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJ7wnYwBVndSTsTqBvFRo9U7cTo4aPhXvxnSr/Wac8u4J0D6CxZsaZzGR6+yC4WejsQpSBQruUpCU6xPH4LBp7fm+AUK8nQipAEONlgtaytD/dgLumvLjNTbONDZ6uK8+m9f1u3noUjHHXfyccpTXj2W8mUPpYjFnjYMItlN3lscXGQjyLlfVP5kCw+Dm6/23Q3c7EuPhDvRcd2sUHjJM0Osblbai5FXtfK4XeJT1SOmkfV9/qDktOoFWFCrIaOtjxWiwdZALOBVKWOpDdyNYgE4shM8KNC+A87bndgycIKu4MIAcyL3hIMLE1SyVK1ZI0RTx6uqYPAAV2D6DM5gzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91Dfrsb5dgXVmEWkuj+kbHqeTrZvNyc3SY63dlMgIjU=;
 b=Xj4G4DhEr+BNlQTlng4ub5jR7+GgSNvSgFny7FuTeYny1y4qixkDi7sBoPlsATZX3EuYmvuXzMjJlr9FsptLvyhjHCaiaDcrZWqVF4uN+09mTN2oCUA/C4fsm8lDkt1x+Tm3tWc957umIg/N1tFwxIIS5AHZLxq99m+a5+5xEYq8ixx0Vc0iefiwGyQBAY4Uqz90CPo7ATBnfT8AXg4ePpCoFY2CRyuoOrWcTffzAbsJxuUuzVggoDAFqMgJSo+gEwNJu8OcXrtR7dtZB+I3ZFKiyCfrdQbcFJE6+bAr+Zeu97JViqu3BMsIL3hFMqFF0Ucwpq54RZZc/ARkuASWvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91Dfrsb5dgXVmEWkuj+kbHqeTrZvNyc3SY63dlMgIjU=;
 b=sHD9o6RhxSaE727okcqs/JdpReCLREHefwBHGV76G4D3oenAdEwvz+3Fluf4Vco9Wp4iosnod0ENwDLhne3bUyH3uNNfd5ZB/Bb7vnK6FVWFJ/Gio1xvhIOj8h/UPR1ubOH9FHCnCL9S51evq6dv3h9RNDvByLtqxJ9ld1MhkvY=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by SN7PR11MB7139.namprd11.prod.outlook.com (2603:10b6:806:2a2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 06:56:11 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1%6]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 06:56:11 +0000
From: <Daniel.Machon@microchip.com>
To: <petrm@nvidia.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 9/9] man: dcb-app: clean up a few mistakes
Thread-Topic: [PATCH iproute2-next 9/9] man: dcb-app: clean up a few mistakes
Thread-Index: AQHZjN0loIEp1xRjJUy4brQm5Bz/Va9oE0yAgADsnQA=
Date: Wed, 24 May 2023 06:56:11 +0000
Message-ID: <ZG21ClPkdp7PoQTM@DEN-LT-70577>
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-9-83adc1f93356@microchip.com>
 <87zg5v3s32.fsf@nvidia.com>
In-Reply-To: <87zg5v3s32.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|SN7PR11MB7139:EE_
x-ms-office365-filtering-correlation-id: 91a2fc81-550b-4d72-433f-08db5c23f55d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y08mrqNr35lIsld8qnifrUlXPvXxleGDDlXqrU5Hv17bs+ACyH4Fl+XFTpRaYvYSnPhklunAv26K5K/Mn2oQtNW19PCQuDKZCaF3c+thgeXQ9+r7no625r8dNkAGw72rU6BzW3A+CE9gVWQzgnTp15no7XUiYE0tR8Z4eGd0hwU6lDHT4hA0sBwtStzRkqFC3TqNXdFkKHbzHJsLNfSDZqwuEDdZOCFlbUv4/QLVEuSIyP5m8zFiLsA7reT5aRQkFi4QTSa6XJYxL4FaCQXOM95AXkpJI8+jRlWf7e1/OAiPD8600ZmkxwTOopIDSqzpVZ2cBJ9W24opCHGmnsgn0EYwHnNh/rNY0AtYkaeFfdg5f3ChUjDa5lEYe/Bp37wyFcbvNervrupKUStpObLpHP51ZTNy8AT0cumq3/WlZF+2D2MdKnkcK/po8NE5YZqtgqTPkmasPi1KyCbGHy/vaXkYuW+F9JIXG+iZyFWNsVF5SdP0Gy3RlLZlBqBd5JdsPLLwb6+zY+JlzKc9RB3VM91oE4dUUHyue6N1QXsgp9I8wLD9uLVIo6x6Oiltltb8ND/O+HYx79V0y06n9hd2XIqjKjH+GdGvnW2UxRcZ3qVSEU+6LgSkicLi3yb0bkkx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199021)(9686003)(83380400001)(122000001)(6512007)(26005)(38100700002)(6506007)(107886003)(186003)(2906002)(478600001)(71200400001)(316002)(4326008)(76116006)(66476007)(64756008)(6916009)(66556008)(66446008)(91956017)(66946007)(38070700005)(41300700001)(86362001)(6486002)(33716001)(5660300002)(8676002)(8936002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZdfrHuemGbjXqQ5np9ndbuIIp1TAFYfBGo+XBT8dC2U4qRshHwU7C7FyrTqk?=
 =?us-ascii?Q?ZI7W7307w0DyZs+df3dSZLqHkY9jH4NL/OPgdf+jGA/x0v9eXRWRvCt9ZTRn?=
 =?us-ascii?Q?RbPQyp/Hh8X/iPC38mBlR7uyfaaG+a68mE9tGwignMjPlMOI/De/iJWwnq50?=
 =?us-ascii?Q?uEghiO22ZqfCRUiTKpVxFn4/geuXxun/KXAjclEghv/2fEI6h1M3RlpGa0my?=
 =?us-ascii?Q?PoC93ER3TnUipYy6eoPhvFKZAuxO9Yx+skprAZIt3jNnaAeWsH8J2ATYs9Mk?=
 =?us-ascii?Q?nTs++zAJ4dJIpP6DDTiF2OuANNGk3SbYQDb9DSh5B4rCzmWfaTBgFzd/OL2c?=
 =?us-ascii?Q?TSOmn/vEyzMxN5VaDB16Vu6J0w+yoOt+CAjGUKeHTqqW0cJDiLbjy0dlcQUd?=
 =?us-ascii?Q?NXjD79R74djgIusk+JHXu1YzwYWEJ5+DDFaGHJAgjYWbujsAMXlKz6JCy7wt?=
 =?us-ascii?Q?YIObbfj9aR9+nCELSCLqyWkL5TIsKdEOlFlOZXg19XeDzkPk0kf2DGSovwdC?=
 =?us-ascii?Q?SBt3NQT7db0nDBWrzPpN9OVVerqUW+dlPdSgBNx/zL3YMhb1RTF9u6L5/JGn?=
 =?us-ascii?Q?M7WdauoWRke+jg/A8H2rWLAQU0FUZs0oxzFaVHuSYc8Uq3lFBz3ZNewosJfE?=
 =?us-ascii?Q?1PCd9b5+ePs5/sx+9HPRObzB87q/V3EIRVlfElbTFTa1ukX4HHVzMx4wCArz?=
 =?us-ascii?Q?wQGkf62qUBd+T076CZBlZn6Iu5iIXBj4w6nTuNNw17L5X/sGSNcepJXq+JtF?=
 =?us-ascii?Q?VGOAm6p1oH4QmwKtMGcHMT40nm4kVMA0CJf7WUixU6e0DJu1SZsdPHlMozwx?=
 =?us-ascii?Q?pb9DsrjdkrbIuFPf0jmNCgk7i0O7xo9FhAzHSNPuGVdme++b0/iN7z1BEm/8?=
 =?us-ascii?Q?TYWDXKLx6qlscq2CserswiEmTovepkIoZ1Id/Kbivc3JXbYDqBiHOLdRr9zC?=
 =?us-ascii?Q?CUxEJs6Ey1U10scSLSSM0DLGyEFK7pvcXAzd7uEnyjCtryVS0JsBueZwsiMj?=
 =?us-ascii?Q?uTjd3xsBU2H9ffUXZHeXl5Sr7E2mGPQ+jZn1+yJg80TlY6EXnpXK/dNqwmEF?=
 =?us-ascii?Q?Rvz/+0TFn/2+U+iBzUbqCzWQFdgxvmheZV4wvTxM04404WE73qtAfcbLS6Vl?=
 =?us-ascii?Q?mt2yS8HXekZGXbPOL4FQR0zvTwgjFVBhw0+Xbtvnhrxjcvots/gT7EEa3blH?=
 =?us-ascii?Q?pdw5Dh0XyLF2DrhfchLDiFp5Y1v0iyaZL71qBfthIukBuI8haQe28//h6Dny?=
 =?us-ascii?Q?xfu8qB6xIIZbZnJ5rYtTw+nicQRsvhvNmAZX8RURiNlssH6lSIIa6JhkE68z?=
 =?us-ascii?Q?1loBaJHa3r3U20f+1jl+KRMNjENSYp3afaHhfEEJf3KQ6yW430yzqKGHcL1f?=
 =?us-ascii?Q?PJZZP5l8T/sViZcQaeTkhhGh5NCCFHISZguy0waUxC65h0ImNHlhOLyOTp+4?=
 =?us-ascii?Q?TVtZasNZ8zOkmE2F6uvVR9UcYyAvk4Z30gri0bBEhs95xaT7yYH7cfYLrPgm?=
 =?us-ascii?Q?O2Vn7gtfdqHcm1awZ13ditm9bMvzc4Kcqyfz1N4hCR3Mp3hmO7VGmx21Qr+w?=
 =?us-ascii?Q?PzQCaMoNTomi9g4hWB2QZSzdFCObiHIuWHeduL6D/1zcM5QFM+7QimvxOVV5?=
 =?us-ascii?Q?5g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3EE8FF253600F44C89896253AADA110C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a2fc81-550b-4d72-433f-08db5c23f55d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 06:56:11.3012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oFKA0dPikVrn9NdFwu0r/SGaXzKdJDkB4Y079RaiPYhSwmgaVE2podS/4wnXs14D3c8+BPTpUoNlmw4Vm97IJmHAhNukTNn3tAHDRARRH0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7139
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

 > Daniel Machon <daniel.machon@microchip.com> writes:
>=20
> > While referencing the dcb-app manpage, I spotted a few mistakes. Lets
> > fix them.
> >
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> > ---
> >  man/man8/dcb-app.8 | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/man/man8/dcb-app.8 b/man/man8/dcb-app.8
> > index ecb38591168e..ebec67c90801 100644
> > --- a/man/man8/dcb-app.8
> > +++ b/man/man8/dcb-app.8
> > @@ -1,4 +1,4 @@
> > -.TH DCB-ETS 8 "6 December 2020" "iproute2" "Linux"
> > +.TH DCB-APP 8 "6 December 2020" "iproute2" "Linux"
> >  .SH NAME
> >  dcb-app \- show / manipulate application priority table of
> >  the DCB (Data Center Bridging) subsystem
> > @@ -26,7 +26,7 @@ the DCB (Data Center Bridging) subsystem
> >  .RB "[ " pcp-prio " ]"
> >
> >  .ti -8
> > -.B dcb ets " { " add " | " del " | " replace " } " dev
> > +.B dcb app " { " add " | " del " | " replace " } " dev
> >  .RI DEV
> >  .RB "[ " default-prio " " \fIPRIO-LIST\fB " ]"
> >  .RB "[ " ethtype-prio " " \fIET-MAP\fB " ]"
> > @@ -106,7 +106,7 @@ individual APP 3-tuples through
> >  .B add
> >  and
> >  .B del
> > -commands. On the other other hand, the command
> > +commands. On the other hand, the command
>=20
> Heh, neat typo.

Liked that one too.

>=20
> >  .B replace
> >  does what one would typically want in this situation--first adds the n=
ew
> >  configuration, and then removes the obsolete one, so that only one
> > @@ -184,7 +184,7 @@ for details. Keys are DSCP points, values are prior=
ities assigned to
> >  traffic with matching DSCP. DSCP points can be written either directly=
 as
> >  numeric values, or using symbolic names specified in
> >  .B /etc/iproute2/rt_dsfield
> > -(however note that that file specifies full 8-bit dsfield values, wher=
eas
> > +(however note that file specifies full 8-bit dsfield values, whereas
>=20
> Nope, this one's correct. The first that is a conjunction, the second
> one... a pronoun? Not sure.

Argh. You are right. Will change it here and in dcb-rewr.8 too.

>=20
> Maybe make it "note that the file"? It's clear what file we are talking
> about and the grating "that that" goes away. Pretty sure it's a
> stylistic faux pas.

>=20
> >  .B dcb app
> >  will only use the higher six bits).
> >  .B dcb app show
> > @@ -230,7 +230,7 @@ priority 4:
> >  .P
> >  # dcb app replace dev eth0 dscp-prio 24:4
> >  .br
> > -# dcb app show dev eth0 dscp-prio
> > +# dcb app -N show dev eth0 dscp-prio
> >  .br
> >  dscp-prio 0:0 24:4 48:6
> =

