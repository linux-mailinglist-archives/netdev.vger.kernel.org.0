Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16FB469B83
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 16:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348401AbhLFPRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 10:17:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:51950 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357850AbhLFPQS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 10:16:18 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10189"; a="261367710"
X-IronPort-AV: E=Sophos;i="5.87,291,1631602800"; 
   d="scan'208";a="261367710"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 07:09:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,291,1631602800"; 
   d="scan'208";a="750391757"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 06 Dec 2021 07:09:27 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 07:09:27 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 07:09:26 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 6 Dec 2021 07:09:26 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 6 Dec 2021 07:09:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4qp+JcoSsChqKCY5VzlS0C9+1n6+lYoXJBCam7JgpbNqxWpceGsWMKx09U+/pwJt4iewXHECjrbScMCNDkRg5XrHSQCtUoaOCzrrVf6jp7K4nVFXbL50nP+fsGgWxQnfYjeHTwA5vNq5YlMuuR/N1pGmOP9ViZ0P1/H0Te2RusNpjP9vtny7rHUGZ7SL5b4MbLFs5HDlnweRioPRNEzo2HZ1buvbxDBcu7XjK5zwtnt8dYnmxISG4eR7Afu9d5+ME6EM/JdN+Iw+i9qEFZRfGemwcd1j9V3xCzk51DvQQfd8prLq19hwIg5FB5ZSCxqyE4osHLytxRThiKkEgRhEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vu3ZlUYWMoQ8y/33SahZP+uQxMM29lA3biYyHvM+kn0=;
 b=P1uc8DIr89HASrlKl9hRK3WojxqsD+XLgRUtdVf0nG1fWZQbmbWf7dgzShbEo3IbM8Hy7Jubzv/gdmHFSfORJB41DuN7E5S99X4OnakV0YaIH9hahJqx0zxKCTVk5Lm4xSir1Dbya+0JhrADaFhNoT35khl6kck3TCFG2KSmpkSm5x5FOcdnxi021dYaJHY3mhX4nTjv+KNPmVXypIW5QjQqCuzYTQEZitbZ4BEoG6g4paqb5RWqEGe3rFDdki7ESVSFTBqM9USXrOI+qGKMzUNLNYh/THFRMf1jCJkivJnOPdnq0yaVkZLI/V+uvlDcuq+yw8IaAIAv6OYamKudOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vu3ZlUYWMoQ8y/33SahZP+uQxMM29lA3biYyHvM+kn0=;
 b=NkxtxDcGDgeO8BNZFicoqzuuAVh7noxWZI3PLYvJZ3GK0fpqepEC+N3cO8jHfcgqaWNeBccSI3EhTXLnw2HfEVgmGs8VXHOTwFhkwJngX923p4RM81B92ml6dc3AFPtWVyyecx4F8TSvrVNyQUw68K6Zp9jO52oQPe1LzBJWCXw=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MW3PR11MB4681.namprd11.prod.outlook.com (2603:10b6:303:57::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 15:09:25 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9%8]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 15:09:25 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Thread-Topic: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Thread-Index: AQHX5t+zHNhA4eAQzEyd+4hcIqumb6wfJraAgAAesICAACIlAIAACV/ggAFk6oCAAARAAIAAHSAAgAADU9CAACN2gIAAA8qwgARu94CAAAHcgA==
Date:   Mon, 6 Dec 2021 15:09:25 +0000
Message-ID: <MW5PR11MB58121BF596AB9C501F900887EA6D9@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211201180208.640179-1-maciej.machnikowski@intel.com>
 <20211201180208.640179-3-maciej.machnikowski@intel.com>
 <Yai/e5jz3NZAg0pm@shredder>
 <MW5PR11MB5812455176BC656BABCFF1B0EA699@MW5PR11MB5812.namprd11.prod.outlook.com>
 <Yaj13pwDKrG78W5Y@shredder>
 <PH0PR11MB583105F8678665253A362797EA699@PH0PR11MB5831.namprd11.prod.outlook.com>
 <87pmqdojby.fsf@nvidia.com>
 <MW5PR11MB581202E2A601D34E30F1E5AEEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87lf11odsv.fsf@nvidia.com>
 <MW5PR11MB5812A86416E3100444894879EA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87fsr9o7di.fsf@nvidia.com>
 <MW5PR11MB5812AA2C625AC00616F94A2AEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87czm9okyc.fsf@nvidia.com>
In-Reply-To: <87czm9okyc.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6fac7a7-da5f-4825-d7e6-08d9b8ca641c
x-ms-traffictypediagnostic: MW3PR11MB4681:EE_
x-microsoft-antispam-prvs: <MW3PR11MB468152F7BA8E1776DDF66138EA6D9@MW3PR11MB4681.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QCWxPDXGHfKaRm/yboF8Dl2u6/VFDHjzjryEn/aMStZc7Tok1eZA8PXDxad6W3156YGa87IxDte19EXrQRIoWaQzY4yg3Evsvn98F7KrZvOWzIU6Se0bln5HCQSOUshklhkBoBH1zUcBlrJVQykTVsp5S92H4wIjr3pu+RoIdb7Hgk+sKhuzwwAnAmuj1I9h52BH/VsJTAtq6VSIoSJCcB/rj3l0UUTaAHOhebE8WNHGyo+C6/sgJ1eVuI0tn403NhVKbBSlelI04YT6jmrWf1loEJEJnqRi+uvIGArDaJU1aE011hOfLnf1ZYTPltCqVpIv5im+mlxe3JL4KFrKh49uXWqdy/F4h4tVp3R4IMGrffB4IPQBpNgsqejKwKYFWmtKH2tXHuVKnHZVhlmya4QDhrboq0aNGK5kX4abH8tlt+hx6HINVW2MfrED5rlu0jjPVh9jv549Nd1GYbCJzjs66xXT+JqDzK+w2I5Wnb3g/OLEBGjBs4ha/pqHCbZjh9SQ7TaOnDCSq/0HztaHDiHS4ZJGClxX3DSvajLVC0VxYU8RRVYolt4Y4MnObcXZX6Hau5lnMr/0Kwg6lQTWAVIYZwXqlbD8UHMwamsinmVElN8LlnDyA7W/FS9ADLCof+slWZrd1Q3Zg31+w2CvYS1SISS6GYnndWNxd2vI30fIq0Qrut3QWGKRSzTpa8C+oESTg3TWzYA9hc7sjs9Ngw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(76116006)(2906002)(53546011)(4326008)(5660300002)(38100700002)(6506007)(8936002)(38070700005)(8676002)(6916009)(33656002)(55016003)(7416002)(26005)(82960400001)(9686003)(186003)(7696005)(316002)(66556008)(64756008)(66446008)(66476007)(83380400001)(52536014)(508600001)(66946007)(71200400001)(86362001)(122000001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZCYLpb/vrHQGEwuztq3xR/ttKrW1yphrQBJ5C5iJHCeLLYyb/qAj5Z/+Tal7?=
 =?us-ascii?Q?sDl1ZfIYbt5yAyuVb5sQkXmQgaxE0IFznZN8SOk7dDz+Q4px6otU/RD2kKsm?=
 =?us-ascii?Q?MW2rONApUiWN+REnrPMNbvrRdSsZvomZ2DoeLGPjumzyxSmE7L7a4Sc+EfGz?=
 =?us-ascii?Q?hL/N4JzxfHkaGU3VvVhEnBgPxkdafVp4PKapaGWNGVM6w5jTPCorgF8Qq6Hy?=
 =?us-ascii?Q?eHQzEIxsMvskhRh/32SvsI+LLTfxshPdzCBMez4yMZ42aWIqDwg3O8eZ5LKL?=
 =?us-ascii?Q?9WgF5zDOEtMAumZekuBchPDcairEuH7y/MP2PXQvFU3CsAWezdfoS0LuVBwz?=
 =?us-ascii?Q?0QnhkuoKhObjeB/kSvPFcF6U2xyWJW9fHrw/n+vTLmqNi6GJMdz+dsgOtLoZ?=
 =?us-ascii?Q?+nurVhup4H5/l5rVmvO+dnuhjx/4xt8jsZKDdxtwOUNPM0yq+PE7+NJZnQfa?=
 =?us-ascii?Q?L4NtRng5ZlUvb38qNe71hK7do3MID/w+Dz0x77i49EMKla3chF26TE7QXo7V?=
 =?us-ascii?Q?+J7w5pbHo/huOSyN0+EiHbe3FdVEY0P8BlW61LLZbPctV8Gr0540azN6LNvo?=
 =?us-ascii?Q?+TGIKfrgn8Q3cBH6p+ihKdbDSRhOrOp2K12LS8k7axwdlVKqkRNqv0sAUWFe?=
 =?us-ascii?Q?xv800eUUpsvHSwkNjctoiKFkkU78xg9Vf13cPgZFZd3Bv+nBH658yBQjkVPa?=
 =?us-ascii?Q?yDx3LmG+Kkgnwjc4GViBb1N9cEcsDsnGFsHFd5ZRe/iLs8sXT8ThfD+jYKrW?=
 =?us-ascii?Q?Rl1T8hQYh1UITT8u2dQLffwGRFSAOpYcp/CMWXjaUDvKuiLq//dTh0lJZJhg?=
 =?us-ascii?Q?vz1xOxHfTcYBillYEXxaUQw/G+FMQfLKnE9NJN5HefsfF7vV8OldY8SfEcLw?=
 =?us-ascii?Q?OfYYe2DuqP6+1224WQnbpv0fMbZ4eLukKk1DtJ2CDm6mPwWfwCxqaKumgHD/?=
 =?us-ascii?Q?UTD/un/hP5mfX1pWl6yDVHG89n8thWrt70GvylGyw/R3yWt0snUkFACq8Lmg?=
 =?us-ascii?Q?h7vUccmBolOKvUTDwR8HoVK1I4N6NGeykxildiiLA9p74lbW5xLPjcphFSHQ?=
 =?us-ascii?Q?PmG7bueXy4NoLo+p/0TnAKmpMvFKwg86exF+7wYCNraIQSQ2xbPUyq+MnYst?=
 =?us-ascii?Q?o9Qux9NmmCBdHGJGn5spgOXCmsppZKd3TxcyKpoFJGq8lB3+E2tZcZrdegcE?=
 =?us-ascii?Q?8slIsnut9qZor2t7Pk2ZgYBce3WLJSgeAFtnEZrlO1B5vCUplxlZsf2A2sbU?=
 =?us-ascii?Q?vG8vdwinIjd0sethwMfLeT6DhlFqocgfZD3jMOyqZ0n4Lic6aecU/wu+bFo2?=
 =?us-ascii?Q?+kC0/VrLazPJfjjjtG95abTHKt8RyFKYoLD5CoCFw1Qc1BOAsYo9vfSbgLci?=
 =?us-ascii?Q?lAkexs2XmI6bYTkmAfkdK6kx4eOpliTPylPoHvIzv6m+DXmYAo1cCmenvb0I?=
 =?us-ascii?Q?vz8VmQ5q/8+owe34/FS6Pnrxg+M+4WIVyQC5oLS87PkmQEFi7FsxbBYNzF8+?=
 =?us-ascii?Q?bwyyzy7KV/U00adQgoRziyKvkU3zfq/scMCF8vcmCsHT5KIgo0e3eNJh0nPT?=
 =?us-ascii?Q?bIsxP473N+do3UsW6kQcyvlETqWAhtwQN9Qsbg7B6UoqS7M5wW5FkxH/hKeJ?=
 =?us-ascii?Q?LtYO+CtEJAKhUmJY+G+YnQovJLtId54oP1mA4p6Wa4gp9rdw7vwGSCke8Mcr?=
 =?us-ascii?Q?plUPMg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6fac7a7-da5f-4825-d7e6-08d9b8ca641c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2021 15:09:25.0877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hMFfECSQ7PG61x8Nng/XNMTFhGYrfVP9rK/3PsS/HGDBCXV6qtg5qEon2Hn65wm5diUGLcc+sfdveS3s/iXTO15p7ZIkriGyX19irnvstpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4681
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Petr Machata <petrm@nvidia.com>
> Sent: Monday, December 6, 2021 3:41 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
> recovered clock for SyncE feature
>=20
>=20
> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
>=20
> >> -----Original Message-----
> >> From: Petr Machata <petrm@nvidia.com>
> >>
> >> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
> >>
> >> > Additionally, the EEC device may be instantiated by a totally
> >> > different driver, in which case the relation between its pins and
> >> > netdevs may not even be known.
> >>
> >> Like an EEC, some PHYs, but the MAC driver does not know about both
> >> pieces? Who sets up the connection between the two? The box admin
> >> through some cabling? SoC designer?
> >>
> >> Also, what does the external EEC actually do with the signal from the
> >> PHY? Tune to it and forward to the other PHYs in the complex?
> >
> > Yes - it can also apply HW filters to it.
>=20
> Sounds like this device should have an EEC instance of its own then.
>=20
> Maybe we need to call it something else than "EEC". PLL? Something that
> does not have the standardization connotations, because several
> instances would be present in a system with several NICs.

There will be no EEC/EEC subsystem, but the DPLL. Every driver would=20
be able to create a DPLL object so that we can easily use it from=20
non-netdev devices as well. See the other mail for more details.

> > The EEC model will not work when you have the following system:
> > SoC with some ethernet ports with driver A
> > Switch chip with N ports with driver B
> > EEC/DPLL with driver C
> > Both SoC and Switch ASIC can recover clock and use the cleaned
> > clock from the DPLL.
> >
> > In that case you can't create any relation between EEC and recover
> > clock pins that would enable the EEC subsystem to control
> > recovered clocks, because you have 3 independent drivers.
>=20
> I think that in that case you have several EEC instances. Those are
> connected by some wiring that is external to the devices themselves. I
> am not sure who should be in charge of describing the wiring. Device
> tree? Config file?

In some complex systems you'll need to create a relation between netdevs
and DPLLs in a config file, so it is the only way to describe all possible
scenarios.
We can't assume any connections between them, as that's design specific,
just like PTP pins are. They have labels, but it's up to the system
integrator to define how they are used.
We can consider creating some of them if they are known to the driver
and belong to the same driver.

> > The model you proposed assumes that the MAC/Switch is in
> > charge of the DPLL, but that's not always true.
>=20
> The EEC-centric model does not in fact assume that. It lets anyone to
> set up an EEC object.
>=20
> The netdev-centric UAPI assumes that the driver behind the netdev knows
> about how many RCLK out pins there are. So it can certainly instantiate
> a DPLL object instead, with those pins as external pins, and leave the
> connection of the external pins to the EEC proper implicit.

Netdev will know how many RCLK outputs are there, as that's the function
of a given MAC/PHY/Retimer.

> That gives userspace exactly the same information as the netdev-centric
> UAPI, but now userspace doesn't need to know about netdevs, and
> synchronously-spinning drives, and GPS receivers, each of which is
> handled through a dedicated set of netlink messages / sysctls / what
> have you. The userspace needs to know about EEC subsystem, and that's
> it.

I believe the direction is to make the connection between a netdev and
its related DPLL that's serving as EEC in a similar way the link to a PTP=20
device is created. Userspace app will need to go to DPLL subsystem
to understand what's the current frequency source for a given netdev.

That's still independent uAPI from the one defined by those patches.

> > The model where recovered clock outputs are controlled independently
> > can support both models and is more flexible. It can also address the
>=20
> - Anyone can instantiate EEC objects
> - Only things with ports instantiate netdevs
>=20
> How is the latter one more flexible?

- Everything can instantiate DPLL object,
- Only a netdev can instantiate recovered clock outputs, which can be=20
  connected to any other part of the system - not only a DPLL.
