Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3000F3DE334
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 01:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhHBXpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 19:45:24 -0400
Received: from mga05.intel.com ([192.55.52.43]:31743 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232208AbhHBXpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 19:45:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10064"; a="299141678"
X-IronPort-AV: E=Sophos;i="5.84,290,1620716400"; 
   d="scan'208";a="299141678"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 16:45:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,290,1620716400"; 
   d="scan'208";a="568478400"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 02 Aug 2021 16:45:11 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 2 Aug 2021 16:45:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 2 Aug 2021 16:45:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 2 Aug 2021 16:45:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O93L2zlJKQzfKNDydMbztzIf/OpuYDZj6CqXI5jpIrqk6ztOHONrit4TSREVG2pbirz03clE/Sk8o2OVt4ZfJMhm43m/c7brCvO1pWWW4aHvqZDRptOEyYIu0V+yiMngLPCYwgDuwwK+AaTMp9+D1rQAV7m/cHZXA7DRg5cpc0Mtj77qhazLOWwqQzh/scX7HGCeXcluZthdJx++lqJqjsDI4eIkRLZNAXYA9KLaRrO04OReIpjEr023IwXzL1D0bXhEONw3pHa7p1TUM4cnwBTOejH0UwYkOuYLjRKPDCcr3cfekCl1eJj8Mea8nxjEpdV8khMgOGAdHH/5mmQmpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27jImUV8qzIlD1j/vl4R7W+sKkaieakMmKHphbV8vyo=;
 b=TmcGvBWwmi8iNe7rZQmNGBrWFoTGr/Q+jiHAnAb7w3Z3HWCm0M+5HkNPopg7/RoVK420xxqMyk7hHEZXIERqdkh+B6cnewIAyZ5pXbwKfh5Ce8LRAjK2cY5xjcB+AleFfBtsN0vRvwQrBMVkneYBILYhWEkgZUjRxeHVlla9hc6+r/S2SBt16EmOB3yO1eDxS6ijaamibe1JFL7bOMWgpsVHEH58Xv9megWFVyYaooXxz478VGQ1m3e7UltsWt6lb3lHocQ4CISKKQS2/RGEBciaX9YYa4DkKGV6F7TYdFvLA7QVOgqKY2tfoF9AfhYJobuNIZ7B8fj2XPa/LcnUkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27jImUV8qzIlD1j/vl4R7W+sKkaieakMmKHphbV8vyo=;
 b=mbqXdn5wenmzSbo7Ehsr8F1UIoK9ukjXwHdlqk9A3Zwjqe/iQ5xQ+BAygg+0dUZBYflGppoMXVD/NB4IQGWX8h5A2zG5Rj3PM8KiWU4scSoziH/OfdCVIG6srRTqjFAZvrhris4PoVHiXgtAXI3deHDYaEGCV+BeIfRuJ+Eo3UA=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1837.namprd11.prod.outlook.com (2603:10b6:300:10f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Mon, 2 Aug
 2021 23:45:10 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a%5]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 23:45:10 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Arnd Bergmann <arnd@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Topic: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Index: AQHXh68Y1owt0G/CUEakzTAdq+RvtqtgbT+AgAAzuICAADaFgIAACciQ
Date:   Mon, 2 Aug 2021 23:45:09 +0000
Message-ID: <CO1PR11MB508917A17F68DD927CD26A82D6EF9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210802145937.1155571-1-arnd@kernel.org>
 <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
 <20210802230921.GA13623@hoboy.vegasvil.org>
In-Reply-To: <20210802230921.GA13623@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 505a98ab-3fdb-43c4-7081-08d9560f90a5
x-ms-traffictypediagnostic: MWHPR11MB1837:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1837BD7AB6421AACF5FC0AB2D6EF9@MWHPR11MB1837.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i7espyIMkhdUobh5eqPQ70mmpeWi8JPTIt7Q1w7/5d5UttLBPM7L5jMypFj6SbaP0Q/f9w25Vzhwe/Yls/R/PyW3xXkfZI3a2EgmCPuIJb8v5lFGVz9qu/pWL4xsOc7hPuaMz4quteOSqsOlLRJ9+GSBguXBLemUOALp633nophA0JQ7Ir5XsDnjXSZNub0Pjq3dDjJIUux+Evqb0HcxcGod4Q6nz4GaFdVf0mSdJpGpyh4a/glXbDL5zHAch552wRwVY8GfJ5IslaNY7qrPkMTKRdQeyHxVCyT25sATSsf/HgYgEzAA/s11d3qfydGusON0frEefnzTzVlodalV1EgWLiV6EzYs2y/qque0x88XYvx5BcncPb2cii8LadX+8u/fLHBIX4vNLF/YZQxUuM+yHEOZpWDu/bFJR8SSV7AGDmIiQZVvjlCRQ7pqArY4t+N8uoETTXT+NuOgki6MCLWKSE44aih197WuQ9XM/WKPo56L8S9RAej4GPE3xVZAruVu0TTjBPkI0epGUBFFTz+Nwo80hTGuwjzY/y4taZPIbKbyS+T5YVrQPF/acZIYSlssXVRChSyOJ4uESJozq8pC7tfTbPCu+ULOFGq1VlFMhM21Ww8OzPYkzmZjZiu92dg+ptKfcfY/odeNESGb7ctnvdn+I6X2tv1EUSLpYNJCti5b+hATUmelMw1jl9fApvq8ma2UNolnZzvGQavmFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(76116006)(71200400001)(4326008)(4744005)(66556008)(66446008)(316002)(66946007)(2906002)(38100700002)(186003)(52536014)(122000001)(66476007)(64756008)(7696005)(6916009)(478600001)(38070700005)(7416002)(8676002)(6506007)(53546011)(9686003)(26005)(55016002)(83380400001)(33656002)(54906003)(86362001)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MGtrFxoacu/meWQFdlatIRet3x7n05nZDTg1s4MFKETBpM2VP/vBWO566OBK?=
 =?us-ascii?Q?dj1L3xeas01L/r8vaJyKW05VjRwPmRF6NoP9bhBGp3kzqowzBzzqRHcBhoOq?=
 =?us-ascii?Q?ozDx6hTExSR4pJlv/l232/b2FmwSVp3mkomYfQOoDITF6igWLv5/2WDuN9NS?=
 =?us-ascii?Q?gq2/ctyqEEZYCwmOWumNxj+FFqZ4t1r8BwGy6BvapFs11sATif+4P+275cT3?=
 =?us-ascii?Q?FUcu09NPo5DNC6b+O/z44VuYTczflqJhWfaON6znGAN+RAWrb7DVx1yrrf2a?=
 =?us-ascii?Q?Grf8C6CAaFYwDDtuB/uF7npymD2XOkAtSHM7+oiKEZ6h/u3yvWFQxniK4n/A?=
 =?us-ascii?Q?/ew7N1ShrCtMxG7YzMufULhmGGKFz21iNxACeU0vn0vUJFzq/lCQQ7fW7bPS?=
 =?us-ascii?Q?p1bTRABrnuSYY3bs+ArlLZb+INIw8WICVTA4NI6/xGa0EFNemPaIR6k4y4Ek?=
 =?us-ascii?Q?51v5ReM4LIiVhWqmF1BAN+XoLCc4Z1XIoka0B4j7O90Cbbm41ammVLlQ2cPb?=
 =?us-ascii?Q?f/ks3bz22Bay4nKC7mGCMsRIpTkgJV/q4M/tz6EbwS3KtOLmx7bOGA/UFrWw?=
 =?us-ascii?Q?ty7+Ww+gbJPR+oKbOepragQm3EUVgJCr41dRto+xSdgchykYfkZAWJp8oGBh?=
 =?us-ascii?Q?eTfhWYsgqxUJD86k/JzHKndD0c3WqilRnOw7QY9xL5bs1dzL32MX5q4ErQ84?=
 =?us-ascii?Q?qLpoSDQdxyosgmmfKWRlz6JvAVriZ6QEzKrbAx1TYgOD5isMq9DzGeHXSFpA?=
 =?us-ascii?Q?RHm5N1QQF6pjpBi1un3taGkK+JQbEM0tJUflMgxZR33m/SQ/BjNvfO/owV+3?=
 =?us-ascii?Q?8QNC2IGQPf2/cbtKCiBKBa3OUzPE9N2FarhVB0FPLrsEuYF+QNjiW67MvgFu?=
 =?us-ascii?Q?O1Frg9U3CrpNwOWOe/X+tWB8IgL29/ktBQofxza5c6JTfp6wpjfxgm+GhvcV?=
 =?us-ascii?Q?9HpY4vXmrsWg5mTCNkMmoQ88blZpHTy8blnF7ajofK+3Avd/nJOvW0x5jVL0?=
 =?us-ascii?Q?p+u5AUrE+ApHDZ0YITp23RsRZaqQ+0oh45NIwGJFjGv0YLW+x3UBJaaJwKF3?=
 =?us-ascii?Q?CVKtttM2IkLmxh81DfYoX5EzCzdy4/+un3vxS6kNLTujZkWOQkGXWNq8otGr?=
 =?us-ascii?Q?2PsJu3FVkWuozNerkBtyuW3qZbg9HwzcO1XZNyAPqdJSvy/zOsI3KcMyAItF?=
 =?us-ascii?Q?DGMt5nht/CYvpZuvyQWW1+mk6yP94PjqpZIXAqb+uLdwSbbjfVYx7zq8nHDo?=
 =?us-ascii?Q?zMPZlaoZ0Mcey40CjvZg8TGq2AbILsRPriyq5QlTiDHiTcMgONNIzIJ6s3Rp?=
 =?us-ascii?Q?Wg2E8pIg2CfSbKGwcVnaQgEz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 505a98ab-3fdb-43c4-7081-08d9560f90a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 23:45:09.9790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LhVw3Hgkw/2Ffg9Gu35W79Ahl+quV1HS2e5qxIM6Rua+0z79i00x5r03/gusjWslekE+wrvK0Ylda+I8bPF/BwatKZrN4WZ+WcGHeQ5JoYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1837
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Monday, August 02, 2021 4:09 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Arnd Bergmann <arnd@kernel.org>; Nicolas Pitre <nicolas.pitre@linaro.=
org>;
> Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Jaku=
b
> Kicinski <kuba@kernel.org>; Arnd Bergmann <arnd@arndb.de>; Kurt
> Kanzenbach <kurt@linutronix.de>; Saleem, Shiraz <shiraz.saleem@intel.com>=
;
> Ertman, David M <david.m.ertman@intel.com>; intel-wired-lan@lists.osuosl.=
org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
> dependencies
>=20
> On Mon, Aug 02, 2021 at 07:54:20PM +0000, Keller, Jacob E wrote:
> > So go back to "select"?
>=20
> Why not keep it simple?
>=20
> PTP core:
>    Boolean PTP_1588_CLOCK
>=20
> drivers:
>    depends on PTP_1588_CLOCK
>=20
> Also, make Posix timers always part of the core.  Tinification is a
> lost cause.
>=20
> Thanks,
> Richard

Ok, so basically: if any driver that needs PTP core is on, PTP core is on, =
with no way to disable it.

Thanks,
Jake

