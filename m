Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACDA414FD7
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237078AbhIVS1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:27:53 -0400
Received: from mga06.intel.com ([134.134.136.31]:17180 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236973AbhIVS1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 14:27:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="284679319"
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="284679319"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 11:26:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="474790240"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 22 Sep 2021 11:26:21 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 11:26:20 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 11:26:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 11:26:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 11:26:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oeGUB/UG6Ua6zzqRRj+D/BdbNO5Oh8+d9iTZoQPcDVOrBSayAoomBqgxNc+UODSscQ8xcTvOnakenJLNLEXCsDoIzcZLoaMUHoRHRDURnfrQwu6LKV8Fi13uA+arcBqWn1iRqJjfxuHXDCo02sBs+R6rLqSRQjy9KdLC5Wbz0yMewCFy/ajUPZ6TCsjEGX2Ws4xuFo7Ze8+3HUSALozblpNquw1qUQBvv694xyNZSHI0HiFExBu0JF9uc1XwjJs7nc3PAW3PIOmD/gFbGldbKfblxTvwJ9lcxB/SFL+vR95cd6H5pOYodxN+SuWEmtjWKm767H7m9RkXb53qF9gXdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=A7qmZOoCdxjMWzUUytMSvJz5swEvSTkDX/+LDMvFpG8=;
 b=ma+XaOFgG3GTgme6Cog2P2GSuCyyK0KLYpqEJDSJT1a/YOL96GGiyewjCge4ct7G2cNcWPRBxCZWV6Rj4bbQJpVn15lhF3Ci2jzwuwTnv4mIKoJ0r/+Yx6bNYzHTazXcOoeWATJ1EvJeRygBH7w9mOQxGAtavuHWOCeyoVOBHTozTG5+zVcPW1CDwzFyTFOYM8XFLT7+/7L89EsRxNEcLXJ4sRALjSMDRC/MYxDGdY4ci1hj8kB7XAm8FQn/LoW2yE3qwOMpJ+LSzUE1j6Qeevd8IYfy2JZvPl3mp+m2ZkIZ64Cjrut/HUbh+lH/aWIuXL4iyfKpf0hq2YG8CdLqSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7qmZOoCdxjMWzUUytMSvJz5swEvSTkDX/+LDMvFpG8=;
 b=tv92je1sFUGHWHiaA3FPSsKu+xwpZ9vLaenz3rgfMTuw7oNgaNx9KVOJl4CcT+jNJ5wxmG7E25XeRgIn2bGnAF/HZHXbNOsEwKl0o1X3NXmykPZ/L1oPe0COlQJA+2UsaEE2ptGgwEu35XF1SamkHsaQvk17hDhJ1Hw7ITERKlk=
Received: from BL0PR11MB3363.namprd11.prod.outlook.com (2603:10b6:208:6f::20)
 by BL0PR11MB3201.namprd11.prod.outlook.com (2603:10b6:208:6b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Wed, 22 Sep
 2021 18:26:16 +0000
Received: from BL0PR11MB3363.namprd11.prod.outlook.com
 ([fe80::b838:ffe:36cb:d8d9]) by BL0PR11MB3363.namprd11.prod.outlook.com
 ([fe80::b838:ffe:36cb:d8d9%2]) with mapi id 15.20.4544.014; Wed, 22 Sep 2021
 18:26:16 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "joamaki@gmail.com" <joamaki@gmail.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v7 intel-next 9/9] ice: make use of
 ice_for_each_* macros
Thread-Topic: [Intel-wired-lan] [PATCH v7 intel-next 9/9] ice: make use of
 ice_for_each_* macros
Thread-Index: AQHXlPQJHvnQZWzz7UOP5+kd8MszaquwlFWA
Date:   Wed, 22 Sep 2021 18:26:16 +0000
Message-ID: <BL0PR11MB3363A83E7180E11CB7B0F908FCA29@BL0PR11MB3363.namprd11.prod.outlook.com>
References: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
 <20210819120004.34392-10-maciej.fijalkowski@intel.com>
In-Reply-To: <20210819120004.34392-10-maciej.fijalkowski@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48c23ff9-72a9-4fbd-440e-08d97df6773e
x-ms-traffictypediagnostic: BL0PR11MB3201:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB320115386F7B5430353D353BFCA29@BL0PR11MB3201.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q24buKrwKlKa22/zdzD+FzIr6i0IYB0jnwckl4IgehNZGSyBVMZmzA1CI8P02q/S7UhGCxSk4UpF5mxZVoNfJ5yf7eLUhXX0vHWtng6wb6C+NusaiaVqi4eHcU3LBZJAWpJUHzg50x3+KFlUNaV/jZSpaIpB++q+ZF0QvVyKChyBpsBE0ksZKjBnXUsMxh87PnPc8XzqFsfNz7Sz61+5D1mHfT0H31myjmALsgG9n2TsasXn4YcJr44/4SzDJUcPqEeAM21ZxaTx0p4ge4FtWzBgwyblmWt/iE/1YsJ6ZDB+QOBB1uLw/xBMWyRWPaJBZQgcvXZBM7mtaiYsH2NTHwCqMcLaNXhkoHmxeGO/hwE2yzepcoc3AnDlZd+G6ZJTOWFVhi66CHaD3TNGRlzyoni0jOKCZP6f8gnCpP7Tf89yciM+Lus0J2lwVbwB1bEE2FxLqiSXPVnP2yK1y/H9kJC0q4QI0V7fdn4T02Lp+7RttN0kTcxV0ne15dWUdlXLCxoiybj2j/8/J064HMpjtjl0S/QAE0Igfn59j1k+DEb4EUzrP6ozNbBznOjXYwMmed+ovMEXeyNe0FM7jLweS7QCBfHMy0T5iLIUUoryIAmHFUjR2WqhTuh2yEyUy+X/EUu6WhQs5av0HqBsvqdGMeV1Zn08w+aqwya9vGSWNaY3wqMURLDOXrRjUaMO321N7Abs71Yvm37iUR2EOkAM4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3363.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(71200400001)(9686003)(83380400001)(5660300002)(66446008)(64756008)(53546011)(4326008)(316002)(6506007)(2906002)(76116006)(38070700005)(54906003)(8936002)(52536014)(508600001)(186003)(122000001)(55016002)(38100700002)(107886003)(110136005)(86362001)(26005)(66476007)(33656002)(66556008)(66946007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GQZ5tPSjT+BYzhUVz5v2SekNDDEFxtG2cdxURJmHEeoJWO6ZiG7F23DzLdDh?=
 =?us-ascii?Q?6TM3QiNx39HWxyJU5qRAtUl1Vl/F24jTwtbJFEJWeUFQw4WmQyckRX4p/ljG?=
 =?us-ascii?Q?uSJ57RwI2rszL0ex1pF9OnikDI6v7FoWeeQr9L8txfexgKhhlHaQQljvLAyd?=
 =?us-ascii?Q?N2Q7N4PGtCBgyNsFxU/VnKLC98ySSe8K7yhG9cr3Iv6uP9jf5MrZUkjKL6HQ?=
 =?us-ascii?Q?SOUUecNI9cl+VIlR+fb3GMv69akJrmQWnl1uON54A6PWYTG6h/QtW5qAaN4q?=
 =?us-ascii?Q?i7z/wYCWSfAnG/sa2s3WsNqwM+7SEQa+D0xZg5GHRo5XaxEDOkwZqLpaSVr9?=
 =?us-ascii?Q?gejJf56AjWU22dbMzGawrIg4QYZ61UE9Ge6QMV+vARICj6w67unon03kqjrm?=
 =?us-ascii?Q?DaC7bZTPCXZF7KKtJjY02xMNed2HmH8NVasV2pTbLe1MrqvksuZDx/yM4A6q?=
 =?us-ascii?Q?Q3ncoxvUe7hYZZ/rWIDZcPQ6BVgwA+WntZz4La7EXsHIIF/2q+2886Hxuuoa?=
 =?us-ascii?Q?8J5XkKWpv613bYpLwYwMNC2wwKBx9V2kY0YjrQaZN0pnJg+QkNuUYA+KelVw?=
 =?us-ascii?Q?bGJ9ykCAxkWIZTkC9Kb8wyuaJQwczJKtyztiqpb2/YuFawHKUmAGjQU03If1?=
 =?us-ascii?Q?SJcE23IyTz8nXqWkB9V6Mj+RWLsmf5IaoCbPBDdxmaprTlYgFGwXxAGaFQsy?=
 =?us-ascii?Q?KaiPuIZB58tUuEmoMtIzf0Lsvw9UdoRYN3WR0P3T1QY3so8TD8KbdncVmQfG?=
 =?us-ascii?Q?2b2Recr7AdcAsM32TKflDUT3TIxCpO/LD6gBiOs9i0FqA/6fWKxcVuZf/wKh?=
 =?us-ascii?Q?rwgAgcs0A56Ay0llFmmgtME1cizeE9EGgaQTiAMfIZfxWWUsSg3K1DZu2E3Z?=
 =?us-ascii?Q?OXVyTC+JKtcJOK5i8lPmCve6X5i040FeEPyuW/6eF6sNTAEh3aNYvNAjcetS?=
 =?us-ascii?Q?TjbzKN9DrFx+Myg7WIX3ZQ14sNrCv4CXwm2vIR+N5JkwQYgnaj9rTZ23WFhe?=
 =?us-ascii?Q?jE6u7bS3NqBwgKQ9UTkow7AZ2tSHvBajTYg/P1v8nqs2PhAJibM2HBC+WM1f?=
 =?us-ascii?Q?LF4xqmjSUgEGgtFGrxvsVgqjvwzYLxiYJ3+VUcBMtfIXuIXLf3sI3VwY0f5D?=
 =?us-ascii?Q?cDtMLV9Uiw2e8UHrfdZW6UDGCc9wvrLyaAXENyniT6rxUE9akAGR3w/O60R2?=
 =?us-ascii?Q?Ju38RqStzOcf/sHVpKYfkRsOcjFFqBs2hK/JlFbk9VpulP/b/Z7SEYWquEAj?=
 =?us-ascii?Q?OU8hMGbFSFQ1IOBzciVBcoboqWXTGXOVN2BmiR1lPPWADuvCpgJqKUs48Nua?=
 =?us-ascii?Q?I3VWjEpUrY+mtRe/Eypb/Ndo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3363.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48c23ff9-72a9-4fbd-440e-08d97df6773e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 18:26:16.3992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BKHHWUDmBgR11oBGHbwRROtSVU16TvfKkAjKC6DWNPGBnEIQrGWw7kBqKDnHYjUDk/LSL15/q+1EE2+wttO1wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3201
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Thursday, August 19, 2021 5:30 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: joamaki@gmail.com; Lobakin, Alexandr <alexandr.lobakin@intel.com>;
> netdev@vger.kernel.org; toke@redhat.com; bjorn@kernel.org;
> kuba@kernel.org; bpf@vger.kernel.org; davem@davemloft.net; Karlsson,
> Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v7 intel-next 9/9] ice: make use of
> ice_for_each_* macros
>=20
> Go through the code base and use ice_for_each_* macros.  While at it,
> introduce ice_for_each_xdp_txq() macro that can be used for looping over
> xdp_rings array.
>=20
> Commit is not introducing any new functionality.
>=20
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h         |  5 ++++-
>  drivers/net/ethernet/intel/ice/ice_arfs.c    |  2 +-
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  4 ++--
> drivers/net/ethernet/intel/ice/ice_ethtool.c | 10 ++++-----
>  drivers/net/ethernet/intel/ice/ice_lib.c     | 22 ++++++++++----------
>  drivers/net/ethernet/intel/ice/ice_main.c    | 14 ++++++-------
>  6 files changed, 30 insertions(+), 27 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
