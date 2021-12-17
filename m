Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F88478F89
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 16:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238144AbhLQPYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 10:24:08 -0500
Received: from mga12.intel.com ([192.55.52.136]:46788 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238141AbhLQPYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 10:24:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639754644; x=1671290644;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ziSCYtE7SM3xZN0ZkClvu8cycvjuJMLCi/V1jhPaQak=;
  b=Tnjb0z5IJHySK1P9Rk9EK4WmQxbyij0WNWl/+0WxH8gY6hEqVawOWYop
   qIshPfbd9dqefxMlAefAddy4cA09AFFqq/ptWgyOnCG4MfkKuKFh51+ay
   uMKH7aOsLLrED5eQWjte5tWc9Sxf9c6k1I1AsidSI+RSVxKJtBlmR4080
   84AByDjzQDMlfHft9plnH1O80wwATudFg3aaalCnP+w+DLGjeahDZAlLE
   SJ98kISX4hRtiBsagJv5p3wKDcv3iF4gzbOP+Hrvm2/GTLnL1HQ820sCA
   5SBjmmqrbHYTZ0OWOLsoS6KPw1oZE0e9puuqrIQyUlS3LULAn9As8zPdt
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="219786413"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="219786413"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:24:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="605921319"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Dec 2021 07:24:04 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 07:24:03 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 07:24:03 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 17 Dec 2021 07:24:03 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 17 Dec 2021 07:24:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwnSWd4pBaeVEDkv4Mmc1mzsncWZ3U/8MeVtwSaVLlNYhKVSMasfVk6f2PBXq+8C78fPvAaVEKGot8Njy6UjMqMvGTZgrshHjfNd+MyMehV1ae+7TRVGsn09/xrVECFH2lPwICrAh6S/ZZr/pvDjC0/WMyyJ9ysO4sj8+wCFZMAeyrlEK20L3IMusGBZ2t5bv2L6LSypY+Z2pgxIpb/djdbCjJC+rZwndwWNRumVap36PUzRazz1Yufe07lbrEbE6xuHCDPhPRiNMrgBZA6w7a0FIIALtFICrovH4EbD1sASlZzC2xPCiq/G4pW7ml9yHUcyy87PSDIA5Hv1vpe62g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPanpeF/6CxAXUUB/DmjAvQEou6oK1MSvygDYSV0zPI=;
 b=adzBaDhsw7JJxClIcDCJl9s2mIuFiyWMfNF4PIGdCNkbT8xvX9vDqowPmUm0NwuAixYzFUp/r9rt/cTiwijvnbMqDxc9M4Ylr54GZpWkm6ep68okESW2YVnYyfg6BIH7iQl8zxpkGTj13Vp52zNZhHuGbhGOqKLAQj5UZoQifE267MTuyOd6BosVRxjCxMc+s7xiyRSw8uBBpGqvqhbmpbucBLDCE7vO7rkOiUtZryblozVN2SPDoWqGG16z/+OdIE4UXHxhZuXoE8mZ15hpYKPa5PJkFTxS73+1+O88EFMZ/UO/zlMeCFDyQepmM3jOSv+J5WRe872HqYwIvZiHgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM5PR1101MB2105.namprd11.prod.outlook.com (2603:10b6:4:51::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.17; Fri, 17 Dec 2021 15:24:00 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f%3]) with mapi id 15.20.4778.016; Fri, 17 Dec 2021
 15:24:00 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Mathew, Elza" <elza.mathew@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v2 intel-net 3/6] ice: remove dead store
 on XSK hotpath
Thread-Topic: [Intel-wired-lan] [PATCH v2 intel-net 3/6] ice: remove dead
 store on XSK hotpath
Thread-Index: AQHX8DaTwGleV/g/s06kfO/GrOUl+aw2hM3g
Date:   Fri, 17 Dec 2021 15:24:00 +0000
Message-ID: <DM6PR11MB329225DA5F67CEDB3B587AC4F1789@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
 <20211213153111.110877-4-maciej.fijalkowski@intel.com>
In-Reply-To: <20211213153111.110877-4-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1f03cce-badb-4373-91c7-08d9c1714066
x-ms-traffictypediagnostic: DM5PR1101MB2105:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM5PR1101MB2105E529620340AD2AA1AB6CF1789@DM5PR1101MB2105.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ynQ6yo0Cl3wxVoh07HfRiv1wpmNY9ylsS96gOh7PpJp6zhUa95UhK/cRfEWGFI3S7hwIG5aUUk9V0vOV9nyTCC5znJ5pGHyMnKUHtJHINPaqdWWwh4Dz4DczcclvnnVXxC7u77fUOIFqpp5pdMikdGJOfnUHBX+jEY7wt2zwnwxqC4PAUI3ka2PKEkULFpgJwfKlzjsgYcfuioNWFOVHU4EGe3WePicUQynw479CLoy/BwjZ+ljptCl7uLwhXGoAKgH9LmkARrJKT3wIo2t2Ci7OZwBLg3VF+v88bt0SS3JoRiKJT4PMPdGPZTZrezW26wZmvT+MVCUSuo/cMgTWR5Fcqg6wvUoPiXLOIW6rdhOrGujX2YGyWy6cqG9u8RIHp7ll5E2ep8aXbAm4nYMKp1n7IV5c/EBAqr5xcDeOVBlI5JI6opW458KAuw09uoYgQUU9jjKNm0zbKt7vaICF4QvOeKJ5Yh8bxOqSebCvVTbr0X9L/o8D0N5s+8ekDHueqoxRK6o7ujwFCyNC8dV7174H5Q144DOj5J+H1p7YDBL/1jRZnqXElXmuGakRr2KoSUjx+lAVWvYf6I0Vz+Ce/QWPhBUlzw799oo49XJXXpgk2QbxTewPr/5G7gfkVyVS8iyOk8NNo9/dgpRlICzmtm7/63c4At7nsf7CTU0jriTIsIPyMpD7ASFjajesYlRD+xGlp+gI3LERp8AT40jm0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4744005)(26005)(82960400001)(5660300002)(8676002)(8936002)(53546011)(6506007)(71200400001)(54906003)(107886003)(122000001)(52536014)(55016003)(110136005)(316002)(38100700002)(186003)(9686003)(4326008)(2906002)(66446008)(66476007)(64756008)(7696005)(66946007)(508600001)(76116006)(33656002)(38070700005)(83380400001)(86362001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oTVuHFGFz1VfRhvW/xWgBmjN08VlNdh5yNxa3DYF4w4JwEgBtgdTF9clLLOu?=
 =?us-ascii?Q?oGhRwz4QwSZgv4/RSutKhV3l9er4iUZQCuMAERHfpM285Pnu8Gt322I5XG4W?=
 =?us-ascii?Q?S8EfqM3e8i6qkgRMIikMn9kt/ruAiXNXOAnY+SZv/ZcwNkeACRNBkaerz6Rx?=
 =?us-ascii?Q?VmNPUq9sclaetv+z0R29EG51RMr1BtXxXmqViez5rb8SU9Xr+l7Vkh/4GKP5?=
 =?us-ascii?Q?mxD2Yge2K5pKSDER6AeGcmU0JGDL8DKjhuFWtw5/Ohjc/OuSSjlBxFSxV1KK?=
 =?us-ascii?Q?SftXldH+qyk8Fv3bwGUoJZ2ZzlJoeQkzsININz/ehBImgn+3T3Ep5g0018Vm?=
 =?us-ascii?Q?OcNdzTpojpW2sSl/G0hh2VWFSuEpT5GgW++gX7Qprqlta+CTgJgtILixSS65?=
 =?us-ascii?Q?6/8adwdBrUXni5NJhgTz3nO29ZyC3ixEJJkQXhA3CQkClvjs/eUZYURQ8TIa?=
 =?us-ascii?Q?lm2spH6GWBrpmaMFD0/EyMEXvtxzrqFM639ulVJyU3P2xy/ii5qynwYhSZ22?=
 =?us-ascii?Q?ftYHzmHSWF4aTlP2dX6bHJ0wapW6LeEQXsv0wY5CCKH3X7b2LyIY2LFSXZ4S?=
 =?us-ascii?Q?63bVTtylR+Z8QpABVsAvjuu5g9OVTRgBoogEkTT7rwEu0wKWsPHgTMBdY6jk?=
 =?us-ascii?Q?Aybz0jpbYHDLE1VhATrF08BgbRmdehrzrbroO0BpH4g96AccGfaZM5NwaQK4?=
 =?us-ascii?Q?opcvl3LnlGkOwjlGVfo9DqbGY1e70wWJvauanbEukbsUBQ9vS2Yn4qGbSRgx?=
 =?us-ascii?Q?gBYU4bqSxvGruLQPxPKN3Yrm8f+AY9E28otX4GOGG5P0Nezz6go9nUgFRyIz?=
 =?us-ascii?Q?lHFoIWQ2ZWngOpJOPWoeWLcx3RuGp5QTFCKIlcYVL/m/XLogwJ7/XnlWmlRr?=
 =?us-ascii?Q?V0Lf9Ea7yY6xNc+iMi3TNZhWGK8umNbD8O+sZg3g9i9xVw9phztHu4G7JbaR?=
 =?us-ascii?Q?ApwpiwrjYTq8UYXMqFihSi/fVjM6GKciRNyIGykd5S+hBSZ//S0wBDrGybFg?=
 =?us-ascii?Q?NOwznjbqElhiFbWSrFIXajl+CB5GZe6cbGgVYHMjBvi3dakc2EAsG4TTaEJh?=
 =?us-ascii?Q?G9xiFyc8KXc1xtavZNL5KZ+oK7p2sC3bW2je/42S+RXHNDfGzwfikZl7F2ON?=
 =?us-ascii?Q?VYH5ZtnpH+v3OKD65v5ybikRoJEje/vpeDQArOaR7hax4I3rBthOI7ZYmcJb?=
 =?us-ascii?Q?J+55R8B8cG1wuc0WmURK3RhyoXSBGh4zBfIPCt1wVOqYom+55EwvYTDfdu43?=
 =?us-ascii?Q?h9g6CYw/mDHI/uVBxQqBirmnH9dsuuZZwaFCmm3aPHmEl/2G63QhnsMjlzrp?=
 =?us-ascii?Q?dTveLoy690fYLxs29TEzBjvoowRZMr63tzBENRz4VI2+Us4eWXXTvlpIryex?=
 =?us-ascii?Q?22lWrbtdZqpOmyHs3bkDbtdAdwAWFQPDIfgr/EeR0lWvxrvSMYqDIRj1fWAd?=
 =?us-ascii?Q?pC8OgyQ9oI6xlC4MhRmXKTXrt4yZW1yisIQO557omKzbRsUXN6GDe7tWIWD2?=
 =?us-ascii?Q?/MrZeUF5iXiZKbSsxnv6OxOtj3SJaKBtmF8HGJ2J7rIrYJvzq2yNUT5nX3TP?=
 =?us-ascii?Q?GAvRJTApoogyBDehu/9B4USnJuT+BvleKkTpYaZl41cRAY40aEuEpFRbniM6?=
 =?us-ascii?Q?Cc2U/4+sVQVDavxON/eltg2rvzQMX8ZJuprsZ2X30GhoN4Q38LCZvK7zhtkK?=
 =?us-ascii?Q?NUBndg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f03cce-badb-4373-91c7-08d9c1714066
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 15:24:00.4939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Khc3RgyaYTfZcRn5FM5nRzzLO/8khDtO/6AsK+2SvKt1Se6Iow6V4dnvQX2j//HOal0+TJqzGt0UCcrqXk3ONspc1dJtGfmlo2JrrzhXVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2105
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Monday, December 13, 2021 9:01 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Mathew, Elza <elza.mathew@intel.com>; netdev@vger.kernel.org;
> kuba@kernel.org; bpf@vger.kernel.org; davem@davemloft.net; Karlsson,
> Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v2 intel-net 3/6] ice: remove dead stor=
e on
> XSK hotpath
>=20
> From: Alexander Lobakin <alexandr.lobakin@intel.com>
>=20
> The 'if (ntu =3D=3D rx_ring->count)' block in ice_alloc_rx_buffers_zc() w=
as
> previously residing in the loop, but after introducing the batched interf=
ace it
> is used only to wrap-around the NTU descriptor, thus no more need to assi=
gn
> 'xdp'.
>=20
> Fixes: db804cfc21e9 ("ice: Use the xsk batched rx allocation interface")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 1 -
>  1 file changed, 1 deletion(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
