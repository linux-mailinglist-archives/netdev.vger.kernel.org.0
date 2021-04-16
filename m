Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B3D36266B
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 19:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239551AbhDPRLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 13:11:19 -0400
Received: from mail-mw2nam12on2127.outbound.protection.outlook.com ([40.107.244.127]:2841
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235011AbhDPRLS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 13:11:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjNkPSn9qaked0sMamqow6HLyCeK4Cm297lxTe60QtnIT9bBS3pfzWZsg3nMeJ8lOFwjxOBRgJjo2ZOaJwaUjQT6NZ8QGyYl26uOW5MlF0NuR7GgotjCvpjB9Cp5SVehtVkbcdaWDvlusWVF4sa3w0ro4hSRlLsuyY2zZNd6oRQV6fqOdWwhqNizv7mOfVs5vPae0I4hukPPFaYmQlSHvEBAA0EKJ2pcptewGzQkb/0iu8qgeWv1u7aMvK8DIe1fO8oyGsVoCY/paL1a3JTBcokXkSvhXqT2fA2bgCTydRChqUfXpko+s5NMI6HPPNFPhDCRQHzQOld5plPyDXoFfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qnrtw/GRHL6Qnp3bd4F4zwadFGOI0L8OerAaC6cEpU=;
 b=HVmTvHrAnjMJ19i7iKw/YdD9Ya/KvfvSvoY0SFghZSV36Zgu9RCWv+ROej9yN0iicyHw/+bC1BNm97IN2kAY3376htLPVUtj+hE0lKlUNkAaAbR4mU4j8V95+oN+Ce5RGmsteWCuaANOXejMKxRBitigwwN7SjxEBNUJeUJlOGVCZE3nEj4TyOJ3Ut4lntcYUNnPWe1uqWi0lSP1gpAT1pNcuTkwc9NMDVMutJYHHUYAMj9wtZ5LuL614HECtq1n5LDPTlC+dFBeHXMYF38B72TqFiQsmzcLlS9zaoPnTTN5JYEBSyflR7rvzOddXKf95K2DNp8c+NiLNjQjyt68Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qnrtw/GRHL6Qnp3bd4F4zwadFGOI0L8OerAaC6cEpU=;
 b=dm+iK5x1Ru4fpe7cRnKJNqDmI73e4QPgFv3O+YDsTDAfjFxtLk7sLy0/ZUYb1w+MWrk9vBT3QmF3Q7n6cANY3Ae56s6WqcbWPyDtV0nsWXWuj1UMhc6V1O/zauZMWLf67Wbayn9AAyQxnZ3Xe6WdGJL67jw4F2HhJ8tVocXedBQ=
Received: from MN2PR21MB1295.namprd21.prod.outlook.com (2603:10b6:208:3e::25)
 by MN2PR21MB1536.namprd21.prod.outlook.com (2603:10b6:208:202::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.2; Fri, 16 Apr
 2021 17:10:52 +0000
Received: from MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::84fb:f29:d4a9:6c10]) by MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::84fb:f29:d4a9:6c10%2]) with mapi id 15.20.4065.006; Fri, 16 Apr 2021
 17:10:52 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Dexuan Cui <decui@microsoft.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v7 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v7 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXMobHCX5IiTHS5Eaqo96lxXqxa6q3WUIAgAAHtcA=
Date:   Fri, 16 Apr 2021 17:10:51 +0000
Message-ID: <MN2PR21MB12957D66D4DB4B3B7BAEFCA5CA4C9@MN2PR21MB1295.namprd21.prod.outlook.com>
References: <20210416060705.21998-1-decui@microsoft.com>
 <20210416094006.70661f47@hermes.local>
In-Reply-To: <20210416094006.70661f47@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c3e4926e-6dad-4db1-bc63-cbf797964561;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-16T17:07:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9689b16-99c0-48c3-46b7-08d900fa96b8
x-ms-traffictypediagnostic: MN2PR21MB1536:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB153605929A64EF2B5B04FB4ECA4C9@MN2PR21MB1536.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2FBno8Ht3LRHJQr3QF8f86cNxEtz9ylvJdyKR0Qsu2Jv5bGctfpJxGH1Xvr45KhEGBT3uheFj85iHtnX2W8CNzh+oIk9C8QC1pSPCW9qLwsG+spWLiJx99ePOKdtsZgufzPmKYeowi9H51jB5WUzeJeHPOAmrxWISXVnWbTU0Voai4N/3r2MsjA/V1cx2vzAZBMAznxX+mzh6AJ9fMF04wlZitLZz5zpuEKyPGQWyQhIKtfc8o3xendj3otMxP0wuzAUigggjkjbUzqeJYIxALYwGe/3cWE9thW4nNwmb8u1XyjUhYdkoNrdRSrvuTcomLzPAmFPG5rCG0FudzozyYmnXJ1SxM42nVPMyV/46whk6AFRPYPpTpWIodw4FhrHFb/eZhpETqu9PUa1e3KaZYkc70km2kFTVVnGYDX/8+5iPUtzfd75I6do4rrKwrSaqPIdhv9fZb1vTaik0aFLNqIP07+4JlOt92yvQs/ei3fQRYCLZpQT/h7H0sKCP5906R398KVsdItfGGURyo7ELouAlRg5UftaG+XB1u1O/agDYIfwIBedmR1OvOiMdFwszkzOSGWqwKk3KOOOsbfj8Wy5mqYeTlAC1Wo1qOI+Dnk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1295.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(47530400004)(52536014)(4326008)(7696005)(26005)(7416002)(9686003)(110136005)(316002)(86362001)(6506007)(53546011)(8990500004)(5660300002)(33656002)(66946007)(66476007)(8936002)(8676002)(64756008)(82950400001)(6636002)(66556008)(66446008)(10290500003)(76116006)(186003)(54906003)(71200400001)(2906002)(55016002)(82960400001)(38100700002)(478600001)(122000001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9GysyYI4J8y9EDKsWw4l+OmoKo0BwzNOuD6weXj8L30YSgzuFb7rSewsN0eR?=
 =?us-ascii?Q?z1Efj9O+btGFsOpPLHB9rzVq834mnPRTTM2jBGpW5Um8YLijTZiXpgzLcm3W?=
 =?us-ascii?Q?vBPA9IA0je2vIMeWb81F2jPMCvGjC7qpPvZvK1z47QX5QukoMZNhYyKdWhB1?=
 =?us-ascii?Q?EWixHWdiVLeWzIk1fipY7ileMQnsO2VI9gk35vTYUFIGo9sdFihWEqp5kfpd?=
 =?us-ascii?Q?6csrh09fefv4lr3oNhCjXrlCOQFfWBPyWUUa31FAfStKnBFSt95mM03v+LLb?=
 =?us-ascii?Q?/dgDlKYH0H0IQojIk1ZM5hVu2Hh3c8pn6lHw32UN/y8M5uY3BNGILRcVCr71?=
 =?us-ascii?Q?PcXKarBqyBGknNzH3fHXrFu6N3FuQ7QbMQ2Bg5ZY1BrXUcZOgFpHDJvv7PjX?=
 =?us-ascii?Q?LXYPId71qlaInQ8JRRjH8iNN9F+vEy82I1pYmYoqkWbT9hzStEad+EPg1hKp?=
 =?us-ascii?Q?jOSV5d4kWLkFEdaPHFR/vlNJEgcg0ZHEXdDZwvbQQ+bgcrF9+xph6ghISYRm?=
 =?us-ascii?Q?EfsmC0NN9qaxHAQAeJuCdvcTUM/6yzjRopB8JA0qXbMzXyW7filnbowNw2Rd?=
 =?us-ascii?Q?IXbLLM3P3uZ5A69xVw5M6ZqiCT+tV4ZdoPLT3qWkpo2HI/0Msa1rqVd4Ai9w?=
 =?us-ascii?Q?97q5TCoHBUTKhHAuH8DYW6QXG2ByrwHvlKmcSj9qpBirXTSkNVGiCeI7nZ7V?=
 =?us-ascii?Q?9jQusXFUrAzIE8Yot6VzGrbciqR1NLfsoJ+WabF2ls5QAxA56AcIet0AHJET?=
 =?us-ascii?Q?o0yRyU2wwSa2htzWMsx15vZNXX+T4OSJRIisuQcvVzn4+eXUvmuGQkcU6Orb?=
 =?us-ascii?Q?kADxzaXAFibcIje98lr601Dt+shifgQIzpcU5BOeBu+fxj/LSE0/CHqwUwCi?=
 =?us-ascii?Q?gU20Qu0J9x+HF02TFX8Z+SVyUDvQIjJwDwlcRhqzc3SIOLMs/pzjrla7yYiA?=
 =?us-ascii?Q?aMheQwKRFq1LwvKjH/S8qRKhDln0HjcO9oaITMlnD+cVM0JWJuI3jgsvJCTX?=
 =?us-ascii?Q?65CPOKx6Ffl9JpWsTQ0KXZEPiNpHz9U0Tbdo4NVPOhyyLNbi0TmBocT/AamH?=
 =?us-ascii?Q?Hr8P9KV9xFoRF8kMgVGeZN2F7aj84ZEgwg13fNqDRlMW2KtiHt/9zRKMyon6?=
 =?us-ascii?Q?QzTgvY0peVFXiwwc3dVoeeuLxzGCvBezLw+XKoijG9O8LvqNPEKeKsWCJKCa?=
 =?us-ascii?Q?sZ5lZl8Ukv/dH6+a+HLWMDeOKz/bLSFtdnPoI/WOqLQd/fn6gunhdbjpJFTr?=
 =?us-ascii?Q?kEG+ULtEmGTSXSycAK88tFhZJix4FqdDMJ3ZTaL0zftjyZnrj7EvtHxx23tV?=
 =?us-ascii?Q?crGV/ouh6nwCrvR68zQqh4mq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1295.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9689b16-99c0-48c3-46b7-08d900fa96b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2021 17:10:51.8300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s/ynIXQ5Gi0i97xBiUww0eE6/r7W87UnuekhSZ0DPtldPkDNOH1hBtprfdS3x8raq+0k0jL8aOJv+mKG6zKvbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1536
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Friday, April 16, 2021 12:40 PM
> To: Dexuan Cui <decui@microsoft.com>
> Cc: davem@davemloft.net; kuba@kernel.org; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> <liuwe@microsoft.com>; netdev@vger.kernel.org; leon@kernel.org;
> andrew@lunn.ch; bernd@petrovitsch.priv.at; rdunlap@infradead.org;
> Shachar Raindel <shacharr@microsoft.com>; linux-kernel@vger.kernel.org;
> linux-hyperv@vger.kernel.org
> Subject: Re: [PATCH v7 net-next] net: mana: Add a driver for Microsoft Az=
ure
> Network Adapter (MANA)
>=20
> On Thu, 15 Apr 2021 23:07:05 -0700
> Dexuan Cui <decui@microsoft.com> wrote:
>=20
> > diff --git a/drivers/net/hyperv/netvsc_drv.c
> b/drivers/net/hyperv/netvsc_drv.c
> > index 7349a70af083..f682a5572d84 100644
> > --- a/drivers/net/hyperv/netvsc_drv.c
> > +++ b/drivers/net/hyperv/netvsc_drv.c
> > @@ -2297,6 +2297,7 @@ static struct net_device *get_netvsc_byslot(const
> struct net_device *vf_netdev)
> >  {
> >  	struct device *parent =3D vf_netdev->dev.parent;
> >  	struct net_device_context *ndev_ctx;
> > +	struct net_device *ndev;
> >  	struct pci_dev *pdev;
> >  	u32 serial;
> >
> > @@ -2319,8 +2320,17 @@ static struct net_device
> *get_netvsc_byslot(const struct net_device *vf_netdev)
> >  		if (!ndev_ctx->vf_alloc)
> >  			continue;
> >
> > -		if (ndev_ctx->vf_serial =3D=3D serial)
> > -			return hv_get_drvdata(ndev_ctx->device_ctx);
> > +		if (ndev_ctx->vf_serial !=3D serial)
> > +			continue;
> > +
> > +		ndev =3D hv_get_drvdata(ndev_ctx->device_ctx);
> > +		if (ndev->addr_len !=3D vf_netdev->addr_len ||
> > +		    memcmp(ndev->perm_addr, vf_netdev->perm_addr,
> > +			   ndev->addr_len) !=3D 0)
> > +			continue;
> > +
> > +		return ndev;
> > +
> >  	}
> >
> >  	netdev_notice(vf_netdev,
>=20
>=20
> This probably should be a separate patch.
> I think it is trying to address the case of VF discovery in Hyper-V/Azure=
 where
> the reported
> VF from Hypervisor is bogus or confused.

This is for the Multi vPorts feature of MANA driver, which allows one VF to=
=20
create multiple vPorts (NICs). They have the same PCI device and same VF=20
serial number, but different MACs.=20

So we put the change in one patch to avoid distro vendors missing this=20
change when backporting the MANA driver.

Thanks,
- Haiyang

