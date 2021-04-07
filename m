Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9417C3576AE
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 23:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbhDGVWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 17:22:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:3649 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232548AbhDGVVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 17:21:47 -0400
IronPort-SDR: x0fxtprqjqotmbvM3ujzzQFaRXk1ZUz6NKGAY8ZGuoTyJTGm9VJvJc2b8S2oQz+yim5X7WCMaK
 QkqcAkVvxGAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="180533076"
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="180533076"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 14:21:31 -0700
IronPort-SDR: Igkbj7AQZIX1KcqeFcNuokTObIBWdO6vraYAi0LDv8UnGWf3nRwmlpRxQR6NgyY8lT3o1Qlp/i
 rY48sCk/48SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="441477192"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 07 Apr 2021 14:21:31 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 7 Apr 2021 14:21:30 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 7 Apr 2021 14:21:30 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.50) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 7 Apr 2021 14:21:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqAU4e6z8ceDuRIze9RWqPFlCYlLo/9TvloqFc4OFNkN2q9xtKxs00iw9n5j+qiMEs7VNWuzVnqkQ3MioKgYkO8JN8l+yDJE1TcesseGkyDNajNmd9wBQrhDCuS7hMxErJ6pGM6Khcai/ywhzcXdMarvqukPRSTkF46zvlbP/ZFwgU5CJy3HW7K2eXbBF7BqAZy2sOaQQUmsnXpjys4o5lys8jUXpy5+UHAH6jCwn/Pup0+oqvPTdIvzU8d4fRbEvyn+ZTGSMPm0rQjtWf1TXoeQrkVtjwjyrJtmulTodWdvovl7jeoE/bTr3Q9VNh8J0mdKde31xdVp2WAtggvgIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnGFyv7vfQ7KEVJ0cXGkXIYh3KGtIQcPxWNhCFA//aY=;
 b=P93h/faWeWihVzg1fm+z5jIBij0fiojKC+xVLGni4fA2ChpzQMY0UyDeBAlXBx/9+pRiiXNgQ1tranmSSpM+mO/u+2jeugwCm+H0r2tgPngqxD7PCLKqu+JzgWgVA7BJNU9g9DVsfc+Z6MRfVe/e8E0IvoLVbXWnX4U0A4iyRhRgCMcvxDoX+hY3Cb9mhDJNwGmeNa8WV0HzmbO3MRg1uWLL3XvFHeqiISitDb3AG7RsZwAh0+9DUYE7fc/97AxCFaV0nsAZQv+D4MMTWNE11aH0lebelGfSG2zj8wj99ffUjv/X2uz+vszMw5aS1OR3rOrCuzQ3mp+wtTsuCyQK+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnGFyv7vfQ7KEVJ0cXGkXIYh3KGtIQcPxWNhCFA//aY=;
 b=U8W0Io0fs/G7KeKSbx9XWHK5gsVfKxlTQc6ThN1Lx/ZtIt4q9i/Fg/oz0xss9FWjWJ/uY9SgYLxDnALGaqtVdhRE7uCdBhfvGlYaaLzPsUQeb2fmFkQyVE8nybBwi9oRA0WaPenv1oW0gFetWhvvTzCDQQD/PNSPCHHUAEXuqlE=
Received: from CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7)
 by CO1PR11MB5121.namprd11.prod.outlook.com (2603:10b6:303:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Wed, 7 Apr
 2021 21:21:28 +0000
Received: from CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc78:a58:d862:c366]) by CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc78:a58:d862:c366%3]) with mapi id 15.20.4020.016; Wed, 7 Apr 2021
 21:21:28 +0000
From:   "Brelinski, TonyX" <tonyx.brelinski@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Yongxin.Liu@windriver.com" <Yongxin.Liu@windriver.com>,
        "andrewx.bowers@intel.com" <andrewx.bowers@intel.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "Creeley, Brett" <brett.creeley@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH V2 net] ice: fix memory leak of aRFS after resuming from
 suspend
Thread-Topic: [PATCH V2 net] ice: fix memory leak of aRFS after resuming from
 suspend
Thread-Index: AQHXHItNzep6dM+QaEKDLxJvVxGD5KqdcgEAgAK/joCACXq1gA==
Date:   Wed, 7 Apr 2021 21:21:28 +0000
Message-ID: <CO1PR11MB510576338209FFCBAF1465F4FA759@CO1PR11MB5105.namprd11.prod.outlook.com>
References: <20210319064038.15315-1-yongxin.liu@windriver.com>
 <PH0PR11MB5175BAF6F45C7F862CD0A33DE57C9@PH0PR11MB5175.namprd11.prod.outlook.com>
 <c30428155948b44cf08aa438db8bebff67730207.camel@intel.com>
In-Reply-To: <c30428155948b44cf08aa438db8bebff67730207.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.236.132.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f100766-d713-4c75-3b7e-08d8fa0b1bb3
x-ms-traffictypediagnostic: CO1PR11MB5121:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB51215F1FCAEDA9B31D2D4E91FA759@CO1PR11MB5121.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l1CiouZgluFfvbgGbEsnhD0T6AnJQPK7WpJPJSMJw7UMbDMwSdyIdZxL9Ev7BXHEYcW2yU2222L0amOl9WLjoJBDymQSQMOBEu418zyOh+YWcozhng0r1M9RgIj4qu8c/A9+LzzwkFq1tzVYJPwzBuj5ny9oDABnSZBG43PXWj3QnyNpFxrcKPD2dzqf889OUa0OvkEVdj2c4vm6A4WE/c78nbgPb6EngS+U+nSi8E4EkzNBpTVsdj/RavSQbWaGDmNsHb0Lnadcv+/cI9n67tf2UhOXxwZnVBwt41RPy+OCwT/2uLhYwqflI/s9j3tG/l6nxHc67AplfTIN4Ac7ZdwI2GUSjz20p5yMXX0NjoQwg1+pscrmSuI0negFaW6fo1vUwLYeYwOkc9oJByCpFWpxA5G9J+vrdD0jrlkrBuYi+fxTuYDT/atreZQHv+TF2U/pJqt6TJ78awhh5OT6ps/CGlfuBA/OSWjshlMU830xdVICvQdgKhnCWAw3HyR8MZD9lKAJZYHxgjkl7AR7GK+kbplWj2QUnZRj/UI/B/peBOJ+Mr5Rp9hxuO3vVnZKzMDpguA+7em95JbAO+YlimyDydlcHMQZ4ClLMuneZUCVrvhvW0uG0yk8qt30g30w7TunLAIW63j1cfC/PtRsmr7aO0d5etDKnlpOTmrYNV4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(136003)(376002)(366004)(4326008)(64756008)(8936002)(66556008)(6506007)(66446008)(7696005)(66476007)(26005)(478600001)(53546011)(9686003)(33656002)(186003)(5660300002)(86362001)(54906003)(6636002)(66946007)(110136005)(55016002)(2906002)(76116006)(71200400001)(38100700001)(52536014)(8676002)(83380400001)(15650500001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZLxQxpeB2JnToYxmgiedCNtXIcyRE+lhyqovGrWlKWp0sX86s3siReVqJeLY?=
 =?us-ascii?Q?1ZIlxrOx6OkDG92waaCpgIER9mSIUYtNUy62Kire9ODoerRqyBYlde5pVzbL?=
 =?us-ascii?Q?m+xEd1HuW9DKW8aYyTWdmtcbx1vgv1jn7c2Xf06FeTk0Jl95oWfAwbfmcxJy?=
 =?us-ascii?Q?AQ4SUT40W/jdge42dLhKGGVI7Sq1rZBLGzC+qCSFvUDJMm1c/WfRPo1Nk/zj?=
 =?us-ascii?Q?xQDLnu6OUSjrgtLONQhkaVUfz+JMWnGplG+pssNI4jlZ/Gd+D9NiMhUXSLx1?=
 =?us-ascii?Q?JsRP0Y5K87VZWcr3m0wB8E9otToYWosqAtIYlMFwtqqZOOAVLW9cmL0BhY47?=
 =?us-ascii?Q?GlsGcZus12+jx11weXwf7zcjWo2luGyJUyJtfwgFJwSpr++XXRh/5lLKYXxd?=
 =?us-ascii?Q?rwaRWdZ6+Qx55c9hSc1sBd5khFlaXNcR/ktvuTu/XKYC6iBtVseiOeuyJRyN?=
 =?us-ascii?Q?uus8RjzN7pWxKyPInvNtciuRQY1y5PzxTkuvhutuvamjNFI605xmVR45YFZI?=
 =?us-ascii?Q?kKz4Px/f5D/AwyxHXwAGQW+wBfv5d7PnuMz37HvKkUuvHhxzjjzFc/Wimq2z?=
 =?us-ascii?Q?hwYucB3OSv2OnLUeqPJs2kgtMsWCoI8lDYrmpK1kJR8G3/QLl95pPmgGixce?=
 =?us-ascii?Q?WIM6dcoaDt7pwk4lgC7hxUfvRO5vL2sJne8ZzSs8Qf7I+rAavjdR7r8gU69c?=
 =?us-ascii?Q?jRfnFOUEWCfa1Ut+CK3K9yr47nfhESBj0Ba2SDca9Z9rxsJ84YTI9xy6Fzqo?=
 =?us-ascii?Q?s+VdmohTHdxHGYpl2OQNPK8v/PjFItBrB0SMT39ZBn+lMgXvRb+lq+tnv2mW?=
 =?us-ascii?Q?arYixcpAIYxWdtu6DrEe91tVJ8Tdxdy8El6JKIe1RG+9f4yop1MoYTJ/XgAm?=
 =?us-ascii?Q?bbY5Ia0cfnK6L1Q80pd/JclGVhINGHyZ2RQBBNL10j25V4ltSo0E10Vr2qTo?=
 =?us-ascii?Q?xuf7UU8xCyXB33gPVf/3ysQcNaMadP9joYZrqL25Rrvyym4EhyU6OA/lVN6H?=
 =?us-ascii?Q?1WJyHFDg09Q7yiwsKyuMHshZwOuysCTxK19svoFHsLbgSrbmpo4RW8Jjw+DC?=
 =?us-ascii?Q?gGQJamfIA3hxjkuF8Yax5nQ7DcyrF/2iTOhuoE+PTttQj0N12NbThsdGWvTH?=
 =?us-ascii?Q?f772ctq/EpcHj6CqPpAdqcwrhjprcLO8mUJXNvMZM7ENsiDIEBxbHBzhAuaX?=
 =?us-ascii?Q?JNoQUr8R5fMd6SY9lmPl0sXLTwQa7WbvVOVduUpbT5XRO2aZLT7StkvjVwnv?=
 =?us-ascii?Q?1NpzX0EGwr1urKJGgUu41CP+Gy084xAJSGSLgxovgaj8y8Qnda0Ni4Z34DQW?=
 =?us-ascii?Q?jgFFdG58Udm+u6uEX841gYld?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f100766-d713-4c75-3b7e-08d8fa0b1bb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 21:21:28.7896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y9FzkvjEuP2T8854NPZewnI0p02mNWO3dMtmx3YNwM4DPbc/9gTSHNF5YkSkEHWSczeIPDGTCTHlhtccCkDiSRWwIgat6K5PGPVAC/PPeEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5121
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Nguyen, Anthony L
> Sent: Thursday, April 1, 2021 1:27 PM
> To: Chittim, Madhu <madhu.chittim@intel.com>;
> Yongxin.Liu@windriver.com; andrewx.bowers@intel.com;
> jeffrey.t.kirsher@intel.com; Creeley, Brett <brett.creeley@intel.com>
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org
> Subject: Re: [Intel-wired-lan] [PATCH V2 net] ice: fix memory leak of aRF=
S
> after resuming from suspend
>=20
> On Wed, 2021-03-31 at 02:28 +0000, Liu, Yongxin wrote:
> > Hello Brett,
> >
> > Could you please help to review this V2?
> >
>=20
> Hi Yongxin,
>=20
> I have this applied to the Intel-wired-lan tree to go through some testin=
g.
> Also, adding the Intel-wired-lan list for reviews.
>=20
> Thanks,
> Tony
>=20
> > Thanks,
> > Yongxin
> >
> > > -----Original Message-----
> > > From: Liu, Yongxin <yongxin.liu@windriver.com>
> > > Sent: Friday, March 19, 2021 14:44
> > > To: brett.creeley@intel.com; madhu.chittim@intel.com;
> > > anthony.l.nguyen@intel.com; andrewx.bowers@intel.com;
> > > jeffrey.t.kirsher@intel.com
> > > Cc: netdev@vger.kernel.org
> > > Subject: [PATCH V2 net] ice: fix memory leak of aRFS after resuming
> > > from suspend
> > >
> > > In ice_suspend(), ice_clear_interrupt_scheme() is called, and then
> > > irq_free_descs() will be eventually called to free irq and its
> > > descriptor.
> > >
> > > In ice_resume(), ice_init_interrupt_scheme() is called to allocate
> > > new irqs.
> > > However, in ice_rebuild_arfs(), struct irq_glue and struct cpu_rmap
> > > maybe cannot be freed, if the irqs that released in ice_suspend()
> > > were reassigned to other devices, which makes irq descriptor's
> > > affinity_notify lost.
> > >
> > > So call ice_free_cpu_rx_rmap() before ice_clear_interrupt_scheme(),
> > > which can make sure all irq_glue and cpu_rmap can be correctly
> > > released before corresponding irq and descriptor are released.
> > >
> > > Fix the following memory leak.
> > >
> > > unreferenced object 0xffff95bd951afc00 (size 512):
> > >   comm "kworker/0:1", pid 134, jiffies 4294684283 (age 13051.958s)
> > >   hex dump (first 32 bytes):
> > >     18 00 00 00 18 00 18 00 70 fc 1a 95 bd 95 ff ff
> > > ........p.......
> > >     00 00 ff ff 01 00 ff ff 02 00 ff ff 03 00 ff ff
> > > ................
> > >   backtrace:
> > >     [<0000000072e4b914>] __kmalloc+0x336/0x540
> > >     [<0000000054642a87>] alloc_cpu_rmap+0x3b/0xb0
> > >     [<00000000f220deec>] ice_set_cpu_rx_rmap+0x6a/0x110 [ice]
> > >     [<000000002370a632>] ice_probe+0x941/0x1180 [ice]
> > >     [<00000000d692edba>] local_pci_probe+0x47/0xa0
> > >     [<00000000503934f0>] work_for_cpu_fn+0x1a/0x30
> > >     [<00000000555a9e4a>] process_one_work+0x1dd/0x410
> > >     [<000000002c4b414a>] worker_thread+0x221/0x3f0
> > >     [<00000000bb2b556b>] kthread+0x14c/0x170
> > >     [<00000000ad2cf1cd>] ret_from_fork+0x1f/0x30 unreferenced object
> > > 0xffff95bd81b0a2a0 (size 96):
> > >   comm "kworker/0:1", pid 134, jiffies 4294684283 (age 13051.958s)
> > >   hex dump (first 32 bytes):
> > >     38 00 00 00 01 00 00 00 e0 ff ff ff 0f 00 00
> > > 00  8...............
> > >     b0 a2 b0 81 bd 95 ff ff b0 a2 b0 81 bd 95 ff ff
> > > ................
> > >   backtrace:
> > >     [<00000000582dd5c5>] kmem_cache_alloc_trace+0x31f/0x4c0
> > >     [<000000002659850d>] irq_cpu_rmap_add+0x25/0xe0
> > >     [<00000000495a3055>] ice_set_cpu_rx_rmap+0xb4/0x110 [ice]
> > >     [<000000002370a632>] ice_probe+0x941/0x1180 [ice]
> > >     [<00000000d692edba>] local_pci_probe+0x47/0xa0
> > >     [<00000000503934f0>] work_for_cpu_fn+0x1a/0x30
> > >     [<00000000555a9e4a>] process_one_work+0x1dd/0x410
> > >     [<000000002c4b414a>] worker_thread+0x221/0x3f0
> > >     [<00000000bb2b556b>] kthread+0x14c/0x170
> > >     [<00000000ad2cf1cd>] ret_from_fork+0x1f/0x30
> > >
> > > Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
> > > ---
> > >  drivers/net/ethernet/intel/ice/ice_main.c | 1 +
> > >  1 file changed, 1 insertion(+)

Tested-by: Tony Brelinski <tonyx.brelinski@intel.com> A Contingent Worker a=
t Intel


