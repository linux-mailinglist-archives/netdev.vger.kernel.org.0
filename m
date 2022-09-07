Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306DB5B0055
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiIGJYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiIGJYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:24:15 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99ECB14E8;
        Wed,  7 Sep 2022 02:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662542654; x=1694078654;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xGrkYDUXvLfy3jcwj34HaqUs1/jrmRX6NZap2oBW/Nw=;
  b=L0he/BSG+UDilQOhz5XNznetZFBT6wkscK2s2ACtUZJosSq3fdevEIRO
   7jUOzR21vfuPNR/MsbQyP6Pxg77oIqmrJFt7hiJroZxkJ3Mh5V5GoSMPH
   MBPFNkRJ+Zxjsb2FOtCVbCzpBZ/dbst443BggvRobkO4WaLClgRXKr1nO
   E3Nk4JaNuRP5wcHqD3cj9BLQ7UrszK9asTBlnC61JJ9ukFHgolH/WUjDJ
   Vw2652IRd9rzaPomDt97WxRuCd2oMe6xxOmbJZa6X8GnZ4g5bAsFt5U2y
   mYid01ho+Wd3K4zZio9VoBAIhclP0RXh4UIb/ypfhENRpKfBLPkehXsJM
   A==;
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="175981239"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Sep 2022 02:24:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 7 Sep 2022 02:24:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Wed, 7 Sep 2022 02:24:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gP493e+1nNh/oBrtTg8F59ZmnnpMIxOb4MfoboEzF5Jpns5d1pvWE7z6me2R9Xi08oMc43b72y671xXXPgqrE7BYCwTdD0MmPj6tSqpWFS9wsprXmb4XF4EYbdYGzD8UMDUNsqOpD87Gs58nPGf/mqyHROvWh3FKTTQ/4mONOq1iuvF2YDABeGXNfV1eCGOCBsLQsbjWOP30xJ0sNtueVVv2BlZ3ciop4MStH+SGkxmwCQxS2yc17Srq4AclPfv81XTFIdTW+MOFAiyVJmhI/vm1xqicY8yMs0dadpEd6wo8F+KSPh84IfscF1ovSHjFxWz0ye+D+I5mz5K93TXOyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t2L0giIKGJrscSUxyz1nKhugR02gKoeTPW5FlDJrBJA=;
 b=awlCG2uZipU1lqGwA1fiTKsP9StpqVzpGvE4dXDNjYFn/9PKu1Z4xjgKV3fqsvaq9tFIYideqQwzaPI12vrP/aR5J74d0yIl2Czj1EMGUNbYlgifkjN/CItVtpqsOmcoolvhYvnpBIMDwoYSrrBO1JpgRNA5eim0VJVBtXvz9aDAY/FwHWwI1MiQrtIHu0TklIRe4+pOgZ4Afeycq9E0onGtErboNnfhPJd8GSkV/gF0Wg+F9MsFpsNTo91cIwI0ZkNi9FG34hV+9IOpCcTZp0eU2bGgyJzsJY4XD6S8KrIkvMS0sdn90bWPX+Zuo4CxFcD9SgSez4ZdHSdm4qyC3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2L0giIKGJrscSUxyz1nKhugR02gKoeTPW5FlDJrBJA=;
 b=Zxh7vODXJYmiQdpq6k02GEwHngFdVFcpMM0ZCLfY/Nosjlazu484SxIUnEPayEd9D7jqXCYud59cuG5z2xfmCf/SUK2KktHsYhcVNmm6YhQ8yI6GSb/WR+cb65iZqiMvLi5YyIhHvk95SzaI0SYzwQtJwrNuTsQSi4o6LhIVAEY=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by CO6PR11MB5651.namprd11.prod.outlook.com (2603:10b6:5:356::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 7 Sep
 2022 09:24:06 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::955:c58c:4696:6814]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::955:c58c:4696:6814%3]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 09:24:06 +0000
From:   <Divya.Koppera@microchip.com>
To:     <michael@walle.cc>
CC:     <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>
Subject: RE: [PATCH v2 net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Thread-Topic: [PATCH v2 net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Thread-Index: AQHYwRDJNV3vhZ/TwE6+oYymZqWFva3Qz3OAgALhBwCAAANToA==
Date:   Wed, 7 Sep 2022 09:24:06 +0000
Message-ID: <CO1PR11MB4771F4A261174353450FE4E4E2419@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <YxX1I6wBFjzID2Ls@lunn.ch>
 <20220907090750.2937889-1-michael@walle.cc>
In-Reply-To: <20220907090750.2937889-1-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4771:EE_|CO6PR11MB5651:EE_
x-ms-office365-filtering-correlation-id: 3abfa3c6-fc01-4fbe-7327-08da90b2b621
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0fQiQdXcGmVQTURyvQWB5/BZQaIVsq1xq9jKFfMzsfvuWhA4eXc0smJQKEaHxt+/F+WddJhCS5CerUtrCbKirmHgwgmc4ywyKFxNo4JtoIuCdhtSTB69OkA66xusGclMTRdNiHl4RMTa90R2OrNXY2xMtXLKYlOeIaL44flAEtpyGPLjsgkelJ48K0JaePqsnQYsi0pa/CfOwx7zjSjD5cXZmEZYroKzPsS0t0D9nqNKVnYMzAWhs3qkM2S3ynzEwOD78l/vt7/jMQjATTrVV+VEWwF3WHggrvv+aJdSXp/YJDKkEPUOrfOs0DnrcizrgB0qCD6qYoDIw7zDfwE9I5bx4bQF7RtYMRsQ+NG14HAx2v4WvtkqUuVJSYHbczdq0zN5KT+j+PASZW3tweP9QlZPNJt6cJwpTs8Jdka5QHrQVnfHQJfB6ZEmnibWW87ZlJex5MQMbQ0uxdcozyXdbM6rXa2wtAiCvQctLsHezRp0HVTmiUufHFR9DODHWPiLU79bZV0ectEcpApVWjJ0+hvo5lxrqn7633V+oOnWUwIQ/X4h1DphxX4LTGsF2R3HFweUS0JFOGFBLvNwmekryw96x7lZKyu/53jKbcdXZw93vCu8Bg+aDrQO/J41sLS2GLhglYYFfJ8FKp/e66bVyEyKIYJkJWoLCJlupfUGAwidqGw+5UKMrf9O+ZlzhWGMlP8aRpnE/KL8gtHYs1np2P5InBt2N1fFKwDIrOpQqAGafpFcftWFn4803ddNcC+ld8iGc5de6W4OnH20j7ozGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(376002)(346002)(39860400002)(366004)(86362001)(53546011)(7416002)(26005)(7696005)(6506007)(52536014)(5660300002)(9686003)(33656002)(186003)(71200400001)(478600001)(41300700001)(66476007)(64756008)(8936002)(83380400001)(54906003)(38070700005)(316002)(6916009)(2906002)(122000001)(66946007)(66556008)(8676002)(4326008)(76116006)(38100700002)(55016003)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Lk7Ft1WwMAJ7EjMyuuYLFeu3LSuvEUjPX9s9XAO/Syk9GVgxgmjsw5SyuIML?=
 =?us-ascii?Q?pIdWaTFmhRp2PcSa7lj7eRtX4t8eLC+tUqB9py/cUOli8nAfJyXRY/Er40R4?=
 =?us-ascii?Q?TsoVSVV8I/lunFjOtemq3NKE3GmZm8pucSZMoN4phFM6XT5Aemk6LFCXyXov?=
 =?us-ascii?Q?5xaldGcplsJpHYyrUyKYjVtpgU4D+ppilsVemiLOu9O4JfBLLJfKSmz2lmKe?=
 =?us-ascii?Q?ZszIBIaKN4qv9q9JBNT/sKhz1U13de1jpA8u95fXs/j8HyuWPubre9g6uLz6?=
 =?us-ascii?Q?OkUt+qcawBvxGZnynZzQpnF98J/9DbILtt6HL9Qd8SEKV2tXxflmY4ZVX5QP?=
 =?us-ascii?Q?RVP1e1w4wzuPMzshTZOAmEUDv4/Z8C9QXb+Ix5Dm0inNH3Nhuu8INcRbTEwg?=
 =?us-ascii?Q?cdt404KVPqjoPRbsNs9kzHtRQJj3028MfJ/7ZeySglXD/m0k/tlleBK0sECL?=
 =?us-ascii?Q?swnU2jvL4wIv2MHKTWAAKyXJ1cUzTBhji0mL+8cs/j0/lXAv9F7Jzzw7108L?=
 =?us-ascii?Q?Nx4Gk1PtRT/Oq1fk2/a7r8cmEvYY60NdxKBRgNvrO3dO/4RFdeoJ9PDmInpN?=
 =?us-ascii?Q?rK4K9bxkds0eUM68/zrMvsH1I1ACfVOmxTOUPOqejfxkjjRE+Q89RWf+N+ss?=
 =?us-ascii?Q?PFh54Tel1NhFpFn4z3oPpsViiDN4HihmeacrRiwUS8p463zg/msZApE+TaoV?=
 =?us-ascii?Q?ChpevmSF00ANdEoYQpLhdtpvSIRTiodzPzKU7y2e+WNQre9uq+I/r0J3BOrA?=
 =?us-ascii?Q?s7rc8t6Ya6iFOEXz9mc6f+U8OhYsEosxV2i9T7DgL4WIZAh4EdWvDNB3sOCA?=
 =?us-ascii?Q?W/P9q2RSg2MzWcySJxhOy2i4/Cm4ylMeAweuOQ6zhNU2wUDuK8Zr5+/ZfaMw?=
 =?us-ascii?Q?cnr4mSwm/ojNrvLmmj6pM1pII7Izyavp4vRKXXNYM3nsAJDptJAd4z8ZjJf1?=
 =?us-ascii?Q?epqjolsRwCuTRGgoVNqhGILfhoS6zanROiiOm0YzuPiFmAZ+m2EGWt4+hmeK?=
 =?us-ascii?Q?YvOziYijL18LMBHV5KiIos1ov35bV+sGPKhBJ2smfUSnbPj4uZdnh+leqx0f?=
 =?us-ascii?Q?6w9mpsewWC7HxfDi/qs6q9Kt+zC4NRVDv4mrhsEfJKBe9A5zQ4MbhY/O20/Y?=
 =?us-ascii?Q?fnSZP4/7dbPQKwEG2DVNfjqv0fpUPPzka8l1AvAArcnNzFIV7ldXfUrcC7r2?=
 =?us-ascii?Q?T5UHm96rzt1CvRhbI9/fFXHO6elUaS7PCyo4E46iHvvnSa2mdByUt3yPe7Vb?=
 =?us-ascii?Q?Td2Fs5ugzwxOoAaaTAPXR/7D2Nf+MrIxtA2bKhnISk3HgMECjqs+TxJ7s4D8?=
 =?us-ascii?Q?g8/ROd48njHDY4Pqf43mS7QHx+VwKGxCZbXAsFd7eP5uOF0H2BeMrclJmuZC?=
 =?us-ascii?Q?b9Qhz1S3p8FPD7KZ8EnJHXxcnTPuBSUP3lsitWgcJwY7rFyJocuqUxkrG0tU?=
 =?us-ascii?Q?2GQeCwClFJNtXA9wDhiBP5tJ+CPmHIgwJpIlEn68umIxLg+1CWlEFiG76p8l?=
 =?us-ascii?Q?L1lb90Id1Py4z7N04z4XYR7aWZIvVDh5MbYg+EzYAQ7H5CG7pqdOnSFU5pjV?=
 =?us-ascii?Q?Uvm9L3KeYQXBJBORzyewJoAb5DLaSZp8WWSuGm1hS67yZBZPtYnN0e2oh6tM?=
 =?us-ascii?Q?hA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3abfa3c6-fc01-4fbe-7327-08da90b2b621
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 09:24:06.0257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PsINU6HpBrwp5U1SkAoWseR/wDB9m+GmWMMwv1Oml0oUini8rdPOU+16MjEOKR9aDvuuaZvD6YZniQ6NjP6g0wy7jVmIT6hPt1GgLA97nbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5651
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
> Sent: Wednesday, September 7, 2022 2:38 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: andrew@lunn.ch; UNGLinuxDriver <UNGLinuxDriver@microchip.com>;
> davem@davemloft.net; edumazet@google.com; hkallweit1@gmail.com;
> kuba@kernel.org; linux-kernel@vger.kernel.org; linux@armlinux.org.uk;
> netdev@vger.kernel.org; pabeni@redhat.com; Oleksij Rempel
> <o.rempel@pengutronix.de>; Michael Walle <michael@walle.cc>
> Subject: Re: [PATCH v2 net-next] net: phy: micrel: Adding SQI support for
> lan8814 phy
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> > On Mon, Sep 05, 2022 at 03:47:30PM +0530, Divya Koppera wrote:
> >> Supports SQI(Signal Quality Index) for lan8814 phy, where it has SQI
> >> index of 0-7 values and this indicator can be used for cable
> >> integrity diagnostic and investigating other noise sources. It is not
> >> supported for 10Mbps speed
> >>
> >> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> >> ---
> >> v1 -> v2
> >> - Given SQI support for all pairs of wires in 1000/100 base-T phy's
> >>   uAPI may run through all instances in future. At present returning
> >>   only first instance as uAPI supports for only 1 pair.
> >> - SQI is not supported for 10Mbps speed, handled accordingly.
> >
> > I would prefer you solve the problem of returning all pairs.
> >
> > I'm not sure how useful the current implementation is, especially at
> > 100Mbps, where pair 0 could actually be the transmit pair. Does it
> > give a sensible value in that case?
>=20
> It is good practice to CC the patches to the ones who gave feedback on th=
e
> previous versions. Not everyone is subscribed to all the high traffic
> mailinglist.
>=20

Sorry I missed adding you.=20

> Thanks,
> -michael
