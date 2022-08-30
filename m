Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19D35A5D66
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiH3HwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiH3Hv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:51:56 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEF2D0754;
        Tue, 30 Aug 2022 00:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661845911; x=1693381911;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4n/h0b3TNAxD+KQ4V2EEN5eZYaWgKbUBQ2GFRWn5TNI=;
  b=nAW+MtdsTQ2Z7FBhT7K09wufBsG55sEhttScqCUOtc5N+9HNBUUnb6NW
   ikmzWuwPp+mGP15u4j/rwtJGqtxiuS9EBw90IbHz5cvWNR9vP1L3axiJq
   Z3FMMT4zhUG/XhH2xVFIW9sDNuFp4rRmEKAxnklJKm3UHMXea9E0ymR3o
   Gmabk6zQ/+Kssm5bOdaBBmZqZKe4dETVZJ9UDO2pNyZpg6Z4BBGwdy9yk
   fFhcxdlrspF9EpjN26gJaOH6gR/w4y9Jm5u6eGffgxCXF98Q+UKf3WT78
   80DHcVdd6Bl8zyeYhj5zB9ZhJ0fdPs7JUf4pkbYQIzAlwnX6fGoH8662h
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="282081272"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="282081272"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 00:51:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="644738152"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 30 Aug 2022 00:51:49 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 00:51:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 00:51:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 30 Aug 2022 00:51:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 30 Aug 2022 00:51:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0cLr1o3kGyQ/dxLPcQJKit0n2mQV+gE7al1NbiQ6P4lQiuUmeY+1A1pQrNrWyGlEUD0mq89qSyMOT279kTM58E+sX/kY8e5FQo+vv0dZaP3EC3k7qceGel/yVK/Q/D8/D5ThPbM3Q2mvYmr6ftfcyBbW1tMLcJEeRyhMUwSBFOnFggXR39C6UqzhGGIUqSJPUZWyyrEU6t1eLQJ941g60tz7Sp8BroExN8fcGuJJYLn87G+LAek0HSmNhazaMTix0Z60OKwUrA/Es5cV1kBH911R7aJrepGTJ6aszb0ZvrbMqYqfR8c1NIde/xYu06SAnn57aQiQbizzFff/SSCaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J6DfWymdomehwGgAsRixHGBMetXyiH77ub7RulJj8FI=;
 b=BnPgT1Mm8bgvDMJFKdcMSSBAYWoqkKzI/SM7bMcNoOxL2KMLqXoVJHhOQubjipDFBL1BxDX7BG7/0o8GFE8vx/Zc30gj2Jw7/EHrGGM1YyTBNmpgjcC2jX0n1YFg5CgWwfZow/xY9QLj4enDyTTdivSe39UDUA7qzzdOva/W4Z8jxYdm1JyRNX98yJjZeNivvJ5uQdnIEbxI7g8SDE+qTOxbPPDBqqmujyExk0IjEku/+UScgU+kk7+O7pYdfLwkAqqfljM9cUsPyXuwIzYuquQWYhDBuz8S8p+QFvUoemZd5HjZYoN10uRFKsmGbuX/cNE9x1f0px1DpxseZk3JOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4348.namprd11.prod.outlook.com (2603:10b6:5:1db::18)
 by MWHPR11MB1808.namprd11.prod.outlook.com (2603:10b6:300:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 07:51:46 +0000
Received: from DM6PR11MB4348.namprd11.prod.outlook.com
 ([fe80::c5ef:f3e4:4f2a:e5ec]) by DM6PR11MB4348.namprd11.prod.outlook.com
 ([fe80::c5ef:f3e4:4f2a:e5ec%4]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 07:51:46 +0000
From:   "Jamaluddin, Aminuddin" <aminuddin.jamaluddin@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Subject: RE: [PATCH net 1/1] net: phy: marvell: add link status check before
 enabling phy loopback
Thread-Topic: [PATCH net 1/1] net: phy: marvell: add link status check before
 enabling phy loopback
Thread-Index: AQHYuFxMKg+SoAedC0ayqAwz26yoSq2/m/mAgAd8s1A=
Date:   Tue, 30 Aug 2022 07:51:46 +0000
Message-ID: <DM6PR11MB43480C1D3526031F79592A7F81799@DM6PR11MB4348.namprd11.prod.outlook.com>
References: <20220825082238.11056-1-aminuddin.jamaluddin@intel.com>
 <Ywd4oUPEssQ+/OBE@lunn.ch>
In-Reply-To: <Ywd4oUPEssQ+/OBE@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43ab738f-105e-4979-aed7-08da8a5c7ce1
x-ms-traffictypediagnostic: MWHPR11MB1808:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bI8z0CscPYjz+hyqisJx1i6CQHto/D1NxT8eFdSMqEw/EbTvvxjFZOuDX7CEXbmiyT5EACur0cSL0PhqOxABjW3gl0ZigTB31TlFFWOZP8JRlZZIddDEMZLSKj4x8RjmQTrUrJ2UwLflZJAWRaRVuhzMQYHvcx45l5BFaPEPaoIVadAV1W1ISrtYi4sJ+qFUm3EEn3vlIPx7xnBPziQUQKNwRutMGh4cYGGRUYfDNmNA1ntdAjmoFRLt9Lxuo7v7U+o/jvi59wOXnpmLKFB1G7xF2aEZKGRkpU6VXgPH6uDywfsrnSfY/K/AoezXqRBZQeWghK8Uv5+XpJI+97ONtNi0GxCtzoGGT59uXYdfuNTEvHDMQOTJy2oHkOG4a0Hpn1YaWZVkcLOV4gGloGBiqrFgMsZxgerW58rkq7CYZAgZqbcP6BsJwzs4O8i0cHimU2N9Juv23aEOqcgiDBp2tc+VYeOHlF3+nyrg/pd5Ur1TC4ffC2rjejnyldjN6yZbOq074DRNY/2ZXCdqHJ7eawLyLfW6CsnZt5Oevuc3Sh9uQe5QD3LTGFhXL1C/vMmX/CosqXtIhzcz9Xz8PR62yvG4WvWPJKv2UA+bry6ZFSW03+frw4Q7Y7knTAyAmK07036CntGSiU3ivhtwonNtj4RorIaBLnJc1RaFhmiMccPxfkBAa7/SW0pKR3g54NutDwpcED44cA70Z8MIDJ82roq3A+UIteQmlpqNgFmCzZ3PqSSXeSTJQVnzgrlYAZ02Cvy6AcRqXwOW6ee8EC1a3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4348.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(366004)(39860400002)(396003)(55016003)(38070700005)(86362001)(82960400001)(38100700002)(66556008)(4326008)(66476007)(66446008)(66946007)(8676002)(64756008)(5660300002)(52536014)(41300700001)(54906003)(478600001)(76116006)(7416002)(8936002)(122000001)(186003)(316002)(6916009)(71200400001)(26005)(6506007)(7696005)(2906002)(53546011)(107886003)(33656002)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3azFYYHFtF49Lj51LG2qdITna/WS/5EJN1DxCU01S8b9TKkn6ZLyTsrVzVr6?=
 =?us-ascii?Q?l34jwEJgD45kJtXHvtY/yHBe/eVXBNf3Bp/o/mOBg4FA/O8RS4stqVKPATia?=
 =?us-ascii?Q?U7bghepfDCbVHUMcTFqiNomGKNNUQvhhLkIclLKPpT5ZGEJBfaqJwBrYGT0d?=
 =?us-ascii?Q?NXBnkIX6rppAMoQ6HjIeBnYkg1dCxBdqM8b/7HVIdyDFkfohSeEu+dBSpKmR?=
 =?us-ascii?Q?9Dhd1RY8IbVqqm1tZvH2eZlzcoElKjuSy7UQ9ggEYc/Q7zDP1FWpG1LMGlD9?=
 =?us-ascii?Q?YbvSSfn2LXdA1XRIDh5G1uhWDZnYibknEkxIcij7GXIelx2/VR8leJDeQeOr?=
 =?us-ascii?Q?JbEt/oZgfd363EqIpSfv3LRB3Hx6IJc1Dr8jwm2hSzRlJ6CagKMsGkKpdffU?=
 =?us-ascii?Q?HM7Gl/Ke+ReC488lXFtn1h6xb1hhtmM93YyJdx6SDbl/4x/Psvms8mhR3DK4?=
 =?us-ascii?Q?uWCuZzI02Md1LkUMe1iiLfIy24YjXPBfH2vmMourp7/xQS/JUijPXc9GdMmo?=
 =?us-ascii?Q?JSxkqK5mtRJM/RJ3/WqVWiH+epCYvkL5XjD98Lm6oVkmdAcN+QaWG1BCM31S?=
 =?us-ascii?Q?S4fEFwlJ19K/5jcRv02NM5Hn+xtM+x036xefdTn+0mHhc5JzZtQsQFwdd2JH?=
 =?us-ascii?Q?MyIzCJgjuI3EaGYwR+2r7NGhK4rzC6vdQ3VvzlQ83m2wT4afd8YdGxDmQBM1?=
 =?us-ascii?Q?0mMwSpEhB+ACsO0P9D1BFAMHV86wtVvaDLebl8PpZNCS+Omb2Z26E49VGVSg?=
 =?us-ascii?Q?QGtyj2Wy6H/045zxlQ6mWSjyGVsQe7ykUqT9EWrz73Ne8Lri+6AAiuXJu7kP?=
 =?us-ascii?Q?Vl2d+8bYGqntTXO7ppRxHoo4RI1d/QDYNXKmFLeFJS2cgjwj67Pvgtz5hc2H?=
 =?us-ascii?Q?CFEp33qGymD0OiI/gAtLj3KX8O17JA/0WL4j+FD3YiXVkBdoUxlB3UF0otwx?=
 =?us-ascii?Q?e080JrQVhTDNSbQcRUZ13Uy6MN6eY5BsCahwXthXzvghJ/AlG4F9LWuwk1Nq?=
 =?us-ascii?Q?gBJ/7d7QQJEPxCpiUhjT5jWmPleCti57tXTgInHu8GP1a4tqokBsKKiSNklc?=
 =?us-ascii?Q?TFmmkx7ZXEM6sp7DW38s7s0j4Ho3Uk1uTdmQFmHlf1iVYz/wlc2YBWjAYsa3?=
 =?us-ascii?Q?nJcUR5AnhsiVQVigJwDqGfEvnwMD98Nr1blQ2jLHc4/cgJprOADM/8YYQcm5?=
 =?us-ascii?Q?WMFCebw576IVZFiQLStJti4UejnSGrwMbm/Pr1gG4O8lexKsT3MTTeJaRLrK?=
 =?us-ascii?Q?mVJjFVvjrOhMbhy7WTcLVBpkdkZ/yIOavhYFI/Tp+sAQz734GS7OD8UnuHR9?=
 =?us-ascii?Q?v39ieLUwuDmMJEpsD6r+GUhWzHGPEIKoHtwMQJGBOFoFHmHXubRzjAaNh51s?=
 =?us-ascii?Q?UHo/sA0c3lO7aICo9Z05CDFwsMYk3D8tpcERyqvxYDdmvnInJttTaff0S8Zh?=
 =?us-ascii?Q?7iodeVmaKnd4AvOCE3De6S2GPtko2stxey5ugkakh9rabwINbwKfI71rxNbp?=
 =?us-ascii?Q?IXHZnnKsts+7WSfvdSjmf2IqdDWk2a0vfDGsLXdvM+VB9hB3lsp/Z4uvBxi+?=
 =?us-ascii?Q?O3N0hYyDBBL2Voiw7nlf9ToJzxxsYT3pZyaAmu2iD6B7VpCle9VrZ3Fxt7x2?=
 =?us-ascii?Q?sA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4348.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43ab738f-105e-4979-aed7-08da8a5c7ce1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 07:51:46.2823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E63aobCUHIug37cOaUX22Qh5olP3JKBj8nZOz/bOiPcL7hAxIneb+b32pACZazaqPvE+J7vLPmKj7028ao7VamvnObvmoDdXq5aIElPyMxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1808
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, 25 August, 2022 9:27 PM
> To: Jamaluddin, Aminuddin <aminuddin.jamaluddin@intel.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> <linux@armlinux.org.uk>; David S . Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Ismail, Mohammad Athari
> <mohammad.athari.ismail@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; stable@vger.kernel.org; Tan, Tee Min
> <tee.min.tan@intel.com>; Zulkifli, Muhammad Husaini
> <muhammad.husaini.zulkifli@intel.com>
> Subject: Re: [PATCH net 1/1] net: phy: marvell: add link status check bef=
ore
> enabling phy loopback
>=20
> > @@ -2015,14 +2016,23 @@ static int m88e1510_loopback(struct
> phy_device *phydev, bool enable)
> >  		if (err < 0)
> >  			return err;
> >
> > -		/* FIXME: Based on trial and error test, it seem 1G need to
> have
> > -		 * delay between soft reset and loopback enablement.
> > -		 */
> > -		if (phydev->speed =3D=3D SPEED_1000)
> > -			msleep(1000);
> > +		if (phydev->speed =3D=3D SPEED_1000) {
> > +			err =3D phy_read_poll_timeout(phydev, MII_BMSR,
> val, val & BMSR_LSTATUS,
> > +						    PHY_LOOP_BACK_SLEEP,
> > +
> PHY_LOOP_BACK_TIMEOUT, true);
>=20
> Is this link with itself?
=20
Its required cabled plug in, back to back connection.

>=20
> Have you tested this with the cable unplugged?

Yes we have and its expected to have the timeout. But the self-test require=
d the link
to be up first before it can be run.

>=20
> > +			if (err)
> > +				return err;
>=20
> I'm just trying to ensure we don't end up here with -ETIMEDOUT.
>=20
> >
> > +#define PHY_LOOP_BACK_SLEEP	1000000
> > +#define PHY_LOOP_BACK_TIMEOUT	8000000
>=20
> The kernel seems to be pretty consistent in having loopback as one word.

Noted will update in v2.

>=20
> 	Andrew
