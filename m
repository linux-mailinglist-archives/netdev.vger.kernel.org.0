Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF42471A7C
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 14:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhLLNrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 08:47:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:46654 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231278AbhLLNrm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 08:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639316862; x=1670852862;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ajRFE4CBlenEtJIFoWAueUpBKjoKsfYmwX5mySnPnTg=;
  b=kub+0qZVsAmjhrbJNwa2yQc1LKpx0tWA8Bi5IOj3F64Xua4fp/+39qU6
   S7fYqcojucEQEIyCZtMCjq1b2J/8YLBETMRlpoT8BWUAKO5m9s4Y/DKaq
   Wcc+ob+rK6f+x22BQ4VxLiXImIZ30hVfo4S7B+PSx7ldg0srSRvflId3j
   Uitjl821XMYEqC89Tkj0b9j6dpZOUtdYkpRU6AwXbrUK5mIx4OQbsv/+s
   NycgUQ8zZRSbM6kiQ+pYf7NOmqaWqVceBeUSp3YINWqYPbHfP2gfkQtmq
   P3BlPFG6uLcvqW1kO+QwTvofhpah8iX0OFXty7p3+tAdVF4W05TFn6eyX
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10195"; a="262722891"
X-IronPort-AV: E=Sophos;i="5.88,200,1635231600"; 
   d="scan'208";a="262722891"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2021 05:47:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,200,1635231600"; 
   d="scan'208";a="518245576"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga007.fm.intel.com with ESMTP; 12 Dec 2021 05:47:41 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 12 Dec 2021 05:47:41 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 12 Dec 2021 05:47:41 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 12 Dec 2021 05:47:41 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 12 Dec 2021 05:47:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ni/yCqzmY9hR0OsrZU0nZAxMA2T71qwfJZzvR6wNIzvgkr638JnxGFk91PZCcXOu81zN89wT+riu9vjizWRWAOcRVPLOXjqW0x5heVyP8OtWtrqYFVzcY2Ovax0MGEbDyXe5WJZLBol6GcGTZwBHsq56QlA/raYUi17dhct+hQcUFph6l13OjlxyHkmCkzRGYqHugSfPv0m7ADL4xWHi5+dm85EnnrTCluGpOxGHPvWYB0TkwdHL4pqmnJgqL2mpNFdklOz+tajTC5aV6V9XYQpnvdgJgWAc8yXQh8Lh8zb7aWAULGieiejFOjAvRPnqEht6IpMJvMtR/tlgmJDFRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PH/A8e37WX7zZOS0zMEv36OCKNPfsPuS9TQ9vgpcSr0=;
 b=WBwIi3MNJOnvAhNgS+LKIUYi4PSxxQ4uRVdcl0xaLn+EM1o3k6eZZl1gtnPXPr7UJcc07Csr766ZYbZBs5BIP0NzFeoqRamY3P1jXtscmiF7lndC67If/LJHqlk5TiW02JQB3H5lacIYhogpXwDurfy3WL0R46uYuXaFLpHh9rPfdu6gARWSkL/YY1hUEjnRFpE8pyVq7fbhPc/qpoKeuwk0tcmsICKyLWFflpodhxm8svxJvhdIccZuK9sMY50KCRHZlr4w3StgYpjlvb8n1BICaqD1JrKWVKZAqDhNsCHAYKBm0GOk+wYsVfmZ7lJqAgcVZgDCVfk3DiWedabG1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PH/A8e37WX7zZOS0zMEv36OCKNPfsPuS9TQ9vgpcSr0=;
 b=UDSKjsXQ9dEgn/crJP7hzZH6SU+kF4tIvmQpCJoD2QI+iZmXfkKcYmTfHt6dJ5s/NOgs7Kbhl/XqEqP9P4kAKRbefrTupbJxF+p/TYOnojXuC8wEmFm8dAmyCtiSN6IhRKs3I5uRW68aX6JvD5Oz2jVMSuvfqQkwNcAhSK4lQ8A=
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 DM8PR11MB5639.namprd11.prod.outlook.com (2603:10b6:8:24::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.17; Sun, 12 Dec 2021 13:47:39 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::3114:bfaa:f64d:684a]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::3114:bfaa:f64d:684a%4]) with mapi id 15.20.4778.012; Sun, 12 Dec 2021
 13:47:39 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net-next 9/9] ixgbevf: switch to
 napi_build_skb()
Thread-Topic: [Intel-wired-lan] [PATCH net-next 9/9] ixgbevf: switch to
 napi_build_skb()
Thread-Index: AQHX4I+Weuj+9VTpk0KS26ixn0HYwawu/G6A
Date:   Sun, 12 Dec 2021 13:47:39 +0000
Message-ID: <DM8PR11MB5621C77BBC2B7DD6FB7806B8AB739@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20211123171840.157471-1-alexandr.lobakin@intel.com>
 <20211123171840.157471-10-alexandr.lobakin@intel.com>
In-Reply-To: <20211123171840.157471-10-alexandr.lobakin@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f851b6a-95f2-491c-9b6e-08d9bd75f685
x-ms-traffictypediagnostic: DM8PR11MB5639:EE_
x-microsoft-antispam-prvs: <DM8PR11MB563957923AB09678EDCC6E4CAB739@DM8PR11MB5639.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pmmdj28NGnQEveytrAFW5RQAtcpF4M9AHQu81HIHIe8pZwc1BtSionfAzkLfsPRnHMDNRcfVu8FsiMexC6xE+RJ/mLBeE9vW1UXU2clGrR5VEP1hOdmi9NzRkkpY2Ei7xGeV2OD0QomVGEbQ/6OgQHsnmoV1p2CFV8J95/C/hn6WAlgbai9F2S7XdPtgcy8ZUoBhY07RSshQoo7m2GDfOwYZQDJUS08tID5tPWNZsYTz+Bb9q0i4iVQcH2btNV+YPBqy7GvfCfX0Neoy4YJla00uYbn92cK2dqIyM0SpEaZUKTu+DAeVPjXyij9EuwuWgGGaHvrVkOioq91aEA6K+Rmm0nmMSILJC5YUSh6UUATgKb5SSloYUOk7zrKGH9AWYKNu34rTUFD1f65+D6/8TH3L7Bssgibl12IFCzrjk+baYaOjwpfrhFiaFQeswx5qGuviVA0dnQn7iEW60RK/NWleaFnFsGOs9aSGLyiQmCo4qsF32f2oiWyJzzSVpz3cw5kDjG1HLq1wkCWtNW3+UH9gtEiTHjv9z4ATm3P8yQxXbC5uWsjdJQ3OLAgWacS1yYTjx4bc+bIatnLwZintnUapoXTs4gfo2YX1t3NNhfLOhrvWDk+07AIoiz+0jGpUPkd07RFJ0y8e2epPgWzFUM6qqGrtcaifL1mDV3knK3hUpLg867iluK6oHGfHcPk9htstU7lmCIg8F2LCtPAadA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(53546011)(6506007)(8936002)(122000001)(26005)(38100700002)(4326008)(8676002)(66946007)(33656002)(7696005)(66476007)(64756008)(9686003)(52536014)(76116006)(38070700005)(508600001)(83380400001)(66556008)(66446008)(71200400001)(55016003)(86362001)(5660300002)(82960400001)(316002)(2906002)(110136005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CpwliagJ+uimW+WzLmPleNxCqjqOJyUYpVsu/PVLhlFWXTsNINgHNZHeAtac?=
 =?us-ascii?Q?bzm1spQ5M7jLMIC1Lv8/KXo4nDe3NAsiPTmr/mfQmhmjLJ510aNpYfulGUWf?=
 =?us-ascii?Q?1T65SpO0exfLLKbpyjyEv0NgBH+UXX3N2jQBkfsnK4pJTthQW/E2pxZ1FW8F?=
 =?us-ascii?Q?He7bFZ2KaAjVZM2/Shh+UvhHfaDef7xXytLxezD4H9yEAYQUTnupQg//Y7Fx?=
 =?us-ascii?Q?pwCUqTiJwmDKoR7X8U7tdGN0IuhEKKFSFBA41x2kExh5K+XlTvH8HSVVNYPD?=
 =?us-ascii?Q?fcGWAtSuBrguZZZi0LiOut9HLypA+3wLaJZsTVrMbXCVVlSMA4jTOxW0j4bG?=
 =?us-ascii?Q?OX5CvWjRHuIz7yF0RAUlgYZWNSKy4V9dyhLVzYy8gq1S1uuTxXPoPSV/+W19?=
 =?us-ascii?Q?KlmzjhImNWqY9bA2bKMfoaHOKYbxG2AN98m8UzqvCDyvjhti2CznIh+r4moC?=
 =?us-ascii?Q?xZCROlYFqpLkaJl9lfQ2F6V805FYemRB1S51BZfMFR2KCdstrKUOr9X5hrmW?=
 =?us-ascii?Q?OyFrAWuK9Zy0hEDU2ReLkV7Qv7W9sErEd7vFTsIS1fIqY4csff5meT0nKczA?=
 =?us-ascii?Q?U81hCw/HubjRt4E7D56Bwwrc3iwju3G1rU+l2/lb5wbhHNXgi/ZKruoUMoBu?=
 =?us-ascii?Q?fpOTnwG90oo0AspEJhwDhC6XMKRJAejs53FTjhX+jo1dVOCNiZ0kuD17LwyH?=
 =?us-ascii?Q?G78QyCxzjSNdBt76VHkuKLLFj3pUa2/krSA3/e8VH4oktbbxTcbAEMRQyNt9?=
 =?us-ascii?Q?MyUfO/Y9M0kidBH6X5kuz2ZhCEcIfLoiVO3AJ06AKQqRmFu3G8eOOitRBJ7a?=
 =?us-ascii?Q?rXC9lCCQtaxdy6r+1Z7ssOJskdxhYH3XVWOv/GpZEIZlzWO1scqQ8khouSxS?=
 =?us-ascii?Q?lswoiEloFMZPpy8DPy3oP0r9oENgVIjh1WWkugHcLciXZR56IJ2b+EkQ5aeo?=
 =?us-ascii?Q?h5AKOErQ2hWAkmHfalBOshPrJAaaAzgH1P8zZ/zgkZxpYKtGmcRBwIyhBMOC?=
 =?us-ascii?Q?lLJvjb/8iq0K2Wk4OGzr4JNA/4bH6Pqqk+pOD9fB8TVRsq5b0w1Z1UNTX+gp?=
 =?us-ascii?Q?xPl3F2ugQf7Kg7Cxov0fiQ2HeNFiAO3QQh07vQ65sWb48pJjgk1+OKa8eAj9?=
 =?us-ascii?Q?J1Z71BM/uC4u3X5OH9KTih+AZcjN9l/J4xxWDTcyi7+BGL1oVbnOIwdQvo2e?=
 =?us-ascii?Q?r6+R2O7MXo/af4iXwZtsvKrHs4UY0mo1EzDkocOd9ep3b+tEnkoeZm2YlYJS?=
 =?us-ascii?Q?3Vto3HEGsUTvgMzzcz46n/a1P+MXB0pTpE9EoYgloIofvG+CwYar5NUlFBAv?=
 =?us-ascii?Q?uBR3CRM5AsK6KHALj5kLlFhgIUO97q1b//8hQgE0NLKNib9/Marhfn0ayOD6?=
 =?us-ascii?Q?7W9kf0bheOuf4QYdSuyfkQWfg5KgNYJkXeoznmuqZgWEubtdUx/ZjmO8o5t/?=
 =?us-ascii?Q?5Z/DQWUQgSFGREBzBXKRp/VX9re6Ug4SR8jIBOofhTDwTOFYi1jenKyHeOCu?=
 =?us-ascii?Q?nbv4TPOAf72WB/ki5VL3mFoFgzFBHPIqnBKufpaJd2YrsyjAgbnaph+rrWuc?=
 =?us-ascii?Q?4KoKfBfqgszaoi4MYr7vWWdwE2p/mJJ5dz3Tpl1PDaB3QnrKvNFCRpnIVCDT?=
 =?us-ascii?Q?nISASIypZmzXztyyvRtJTQ5RbX95yC/qLTLUqAvxPrJl1geecl3Qlua57pIq?=
 =?us-ascii?Q?eqTNPA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f851b6a-95f2-491c-9b6e-08d9bd75f685
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2021 13:47:39.3145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ToE2WLcid8VKgIwS2P+zA2mhZnljGZrzF30YWjG2urBVziovWAHdLcu1EM0n4wiKES/R99O+aFuSkst0T0FDvA4eIdkNXnOvQxwV6ANC9I0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5639
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Alexander Lobakin
> Sent: wtorek, 23 listopada 2021 18:19
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
> <kuba@kernel.org>; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net-next 9/9] ixgbevf: switch to
> napi_build_skb()
>=20
> napi_build_skb() reuses per-cpu NAPI skbuff_head cache in order to save
> some cycles on freeing/allocating skbuff_heads on every new Rx or
> completed Tx.
> ixgbevf driver runs Tx completion polling cycle right before the Rx one a=
nd
> uses napi_consume_skb() to feed the cache with skbuff_heads of
> completed entries, so it's never empty and always warm at that moment.
> Switch to the napi_build_skb() to relax mm pressure on heavy Rx.
>=20
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> index b1dfbaff8b31..ea73fb3026bc 100644
> --- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> +++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> @@ -944,7 +944,7 @@ static struct sk_buff *ixgbevf_build_skb(struct

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
