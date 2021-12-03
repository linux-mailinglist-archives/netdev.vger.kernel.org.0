Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D0446799E
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381539AbhLCOtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 09:49:21 -0500
Received: from mga14.intel.com ([192.55.52.115]:60663 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232079AbhLCOtS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 09:49:18 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="237208680"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="237208680"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 06:45:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="460892365"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 03 Dec 2021 06:45:54 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 06:45:53 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 06:45:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 3 Dec 2021 06:45:53 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 3 Dec 2021 06:45:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNQeAVlTtSurVkvXrWRGXuaJ16XNIOZEIlXHQ4awT9A8ww8lHNd5TiBY/oh2iEC9xmAwnKT3hGkrTHkoyNniHaq+MWpJSM6y3428jpgs2p/2wWZWSLoXC7yYrVe0Ax6HDiGCQK/rhwVnqXhsZQcFJHPd6NKbW0Y6AXDg35b6GJiulV8lBEqZDe1LVLxsaL9ONLA55BK1cKUp3dROTTzu6/t7nmIsULSq+N2Sq7XNRDGYciTRfm4YWIiEDIRnt1M9BBJXZjDVv8TXzLWYmznDklVa+D47JzcF7Zpf1pCXWk8wQRgUTX5A5SvGREWTtf9fDB+3iN3riPzojBqIOT0LkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+NK3gxJ2vADhrUhqLxuYF49ReFReCcFCKsWOYzwK9U=;
 b=L6fzpAmC/64PMmY6pgW1Zzg+1vvXZguhJ4JpL9i37Em2FenGW0wFhPw0NWnZ8FjciJZfLhQtAo7HeXrIFf3t30C7EDRcA5Dpaq/H2HKLBukRO4Pjfyx4H1GF9Snpt1bw0Qs1XOQeJo3XJoDWvR0tPrMiCvkmKbIsslPDDocy2J26PZ1hzwFOZQ6uwTJPHL8OCNk2qNWelfV6UuCG2hUmEcbkGnDrc/dKDmR4s7Mr27TR4ko6eTuK/Vhl0sWyOcR+6Stl7JqGynOE2YD6ffSdqGUkFNWhq3Z8D/HskGgzY2y4GSTqejXOpMTe11xuSRsvBrOWJMHED6uK/WqjynyPBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+NK3gxJ2vADhrUhqLxuYF49ReFReCcFCKsWOYzwK9U=;
 b=jJEtCzwn4V8EF+YKEAA6hyYWYrCMxOzSbHEG2psc/Bynp9d2W1lfzpreeTnOeqHwJ32Tlih09UP5AlAcxQduQtUQRlMh9sxnGwG+xeUR0twVwO0DAa2WOidP+cXPGGo9x2r25fc8ycUF80R0J8kzJcsq3IHzJRSPTGnnZsWaYM0=
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by SJ0PR11MB5771.namprd11.prod.outlook.com (2603:10b6:a03:424::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 3 Dec
 2021 14:45:52 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d9a0:60c3:b2b2:14ce]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::d9a0:60c3:b2b2:14ce%7]) with mapi id 15.20.4755.014; Fri, 3 Dec 2021
 14:45:52 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net-next 8/9] ixgbe: switch to
 napi_build_skb()
Thread-Topic: [Intel-wired-lan] [PATCH net-next 8/9] ixgbe: switch to
 napi_build_skb()
Thread-Index: AQHX4I+SvG19PkQ0F0uYCTVoIxHDlqwg56oQ
Date:   Fri, 3 Dec 2021 14:45:52 +0000
Message-ID: <BYAPR11MB33679BDF8869BEC763EFE25FFC6A9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20211123171840.157471-1-alexandr.lobakin@intel.com>
 <20211123171840.157471-9-alexandr.lobakin@intel.com>
In-Reply-To: <20211123171840.157471-9-alexandr.lobakin@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98f6a65c-e90c-46a6-4945-08d9b66b9ad4
x-ms-traffictypediagnostic: SJ0PR11MB5771:
x-microsoft-antispam-prvs: <SJ0PR11MB577153B457961088DD0303FDFC6A9@SJ0PR11MB5771.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L6seRnH+O8W3PWtOum6OGyt/uBju0RbZnSh4/6CGJj8nOFgSxVBsJk/3vC8l9SAdwbXwVxR07e4/p8M5qkrl+HrjiVSBNhwIxC5sA7IFBe8HRP4BOPerPvo1znM2MSoxmhAwojgi30+aeGhZ7ShkBz62IduWRpqKtadrketSAwLjzCTV75uJdDVHMKHS4QKJmp8q9KmhGGUkX1zykJihXpkHrpTPnh0Z3ouTo8umRTqj3gTDN9VK9mYJNmJZrtoNtBCNHVEYl/J6C3SfURbP43o9SkdlEFSfnoPKTJllLMRsw+ZNPykAkmqRk4ZgPFzCAeyIu4AMawGjOBghOnXS0cxYzoEX79c1ea4wuceBEMbIL8Ji/xgevG1+3XAMrlfht06c0AT6llYlgvAGvd7k3kHfRMBVYfZLT48A1/RVR1MlfouH8pvqMTHvc5DiuYlCSXw6xbPzb5/0VtlXsbgTZHhrBxF0fWkx3EKr5wjbNoFOFWBHKAe2GSfceCj4R4sT6vvumFMBTpGPyy+XwDQQZSLj7Hq5FsaYpQP0ANBHBsGWwWfucp26JHbETYvkk/juYi4z3ZToPw/LC4THG8/3SUC6TcO+l2K6Ve+yHT0LX7Q7tyzF5MHPnZGLRFkOOeJkJ/Frn6Z1A/kiOCdHfgqvRk8V1URi2b76+8BeqKRUrbegftChEgfHUm8cP23gtb4C/6e+9A7W6r6oQabAgk2S4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(38100700002)(38070700005)(110136005)(54906003)(53546011)(186003)(64756008)(52536014)(66446008)(122000001)(86362001)(8676002)(316002)(83380400001)(8936002)(55016003)(508600001)(66476007)(33656002)(76116006)(66556008)(26005)(9686003)(4326008)(66946007)(7696005)(5660300002)(82960400001)(6506007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VqzMMMH1sS5OmCderFBTTM1+/dzEWazaPVo8hfSHewHLV/nPa3fQiWWb/iTY?=
 =?us-ascii?Q?umoWl5iCh5OEjyOmw/8/1zwqMcj2PPWJEqIn+QxsjovJLbxF7DrNV7fBMcaB?=
 =?us-ascii?Q?vsfK2+B3u/4TY3m3vkciSz7LCsx7Mi1A0DZyJ0C1+7j8CtTwYI5H0uVb26hV?=
 =?us-ascii?Q?kyPujvsRM4uNCwIP6b07AWkI1mjl84hOluL96CNpgKidF3wVuxYQVk0QKn7L?=
 =?us-ascii?Q?YKIqeQmkJvWomdBVhV3ve1RYG21NWDPQti6+arBYnPonnp1jTgbvGnPzJabI?=
 =?us-ascii?Q?w5HDsjlGdEXMcMqtONTU5cAd1iYMsjyQA5wzYjkziA6ZqAQ6aGskfI+k6aNK?=
 =?us-ascii?Q?zNxOez1jsYr+CS69mbNX6ZmiT06KhXk1OeqRZlbGbuVT2NeObfNx6Cp6WQG0?=
 =?us-ascii?Q?JPO0iqqfFWtYRw3B5tzQ+H+SbeyS62KuRs/p3Tfxhs/BvgJoW0Ud5OQmA4WR?=
 =?us-ascii?Q?cUw6kVgnjXMb0pr6FA6qw5Odk4EorD8hYEPGQh2+5RDcxRiS77F71i5hvKcy?=
 =?us-ascii?Q?hzZklf7kyLCN3wtVtWqiDVtVxmDEx/IXhnbwXflBlyDfYJ/xwHQO7QcborXh?=
 =?us-ascii?Q?jl/f/E7sj1hhK3xRWTfRWqyxCeojtBMlZlyWB2Q5WMYI4G/9DXIua0MF5Kyp?=
 =?us-ascii?Q?5nqWPNYdpHq4qStlhcHF17cbEktQHOx1kkBLuge/cGT1y/B1HrPmAclnTdbe?=
 =?us-ascii?Q?0b4XGJoDcGcwqoFyZUHV33JHeMI1DzyR3k8YYN4jIB5gLuOvCQbrE9NT9iwO?=
 =?us-ascii?Q?ZZK6Eo+N+LmAHWWYdpzY2pv9IWIyM2UT7qltruGkMqY42VnACBnsGIOFuSnI?=
 =?us-ascii?Q?RigiTFCzJ0abSZJ1HhQEtMhKJsRssfbsUcWBioRdvc9WgH6t6KxIHxplm2Ug?=
 =?us-ascii?Q?xq/Pj8B7MvqJlttts2k74RtNXQ7smsauGWIgbLqQHVybpGmI4E9e3RBBJ5Rw?=
 =?us-ascii?Q?2b7Kx18iZkV1MWRfLqBLGtMx8vh5rr0BMaa38eohvxzl6hHEnW24qTGI5HHk?=
 =?us-ascii?Q?rpVXUzZcc8fRXxAoeDklK2yvHvLXhaQgBI6P9kWO6KrSIGznVlh9zUw7zVtS?=
 =?us-ascii?Q?gDuSL5fIoIpU7EhVeS9AQvm5UsiGHf07ARul3LrZom2PF6/gQLjm8/h2kSFq?=
 =?us-ascii?Q?lzLIBpZXQAbAGxb7QD+aYFbODqG2V3S/pohThAnHuGCPKLekWpBZOhI8e+rf?=
 =?us-ascii?Q?xpg2OJ7Bvqt22PCWcx9w7TdQaiXeX/8vqHssVYo+KOTzRUAMyzluT+ulhcwR?=
 =?us-ascii?Q?0Zg0oubR/vvzQ/HLW6rufWkle+nkm5x1qMy84hNAIvM3MT197YOIQkP2sfYv?=
 =?us-ascii?Q?/NUVNaSjX+GWm2qeB9P/aEGjOs2uPgiE3EyUpTu6a/CcT8zkhhOdoDcLrcfl?=
 =?us-ascii?Q?HZs/UWjWNZXkDPQgVc10v8q48uwC7EsN/ntyIH46ALedMM9K9KbsS+20bd9Y?=
 =?us-ascii?Q?hUenc3dbdH5JMVXDxlMr2lsJHhLmna3nzggaD5XDmygBY0/0Hm7sw28i6oLS?=
 =?us-ascii?Q?zoKrDq5QmGojqFisLL7SgdwTx1sqCCQrA8Vbdt8rPppcZy5vVmCN0M11NOXp?=
 =?us-ascii?Q?LNcM+1u4/eGUTlzQgejfsceYJbANqdGgVo5WW4xRzAaf7apYcSOOZ7/mz5y1?=
 =?us-ascii?Q?/A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98f6a65c-e90c-46a6-4945-08d9b66b9ad4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2021 14:45:52.3936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B/wIG6Et4TbwpccedxzIhjmIXFbaoh6/sbwNZ7mljzN3ghhnYSihpdJbedmQwy64qvAuRIzLnahTu6hcmTvppw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5771
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Alexander Lobakin
> Sent: Tuesday, November 23, 2021 10:49 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
> <kuba@kernel.org>; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net-next 8/9] ixgbe: switch to napi_bui=
ld_skb()
>=20
> napi_build_skb() reuses per-cpu NAPI skbuff_head cache in order to save s=
ome
> cycles on freeing/allocating skbuff_heads on every new Rx or completed Tx=
.
> ixgbe driver runs Tx completion polling cycle right before the Rx one and=
 uses
> napi_consume_skb() to feed the cache with skbuff_heads of completed entri=
es,
> so it's never empty and always warm at that moment. Switch to the
> napi_build_skb() to relax mm pressure on heavy Rx.
>=20
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
