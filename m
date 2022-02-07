Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459EA4AB736
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 10:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240388AbiBGJIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 04:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349318AbiBGJAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 04:00:01 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 01:00:00 PST
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C564C043181
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 01:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644224400; x=1675760400;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=zNL0fSAWkBaH4keObMlMuhSypoafrebBSnUId7JnMYw=;
  b=VRbST3aLL07cJ/E5pB2B+/emV/DT6do3/T5eZgBXvQGMx3HERFSteYG9
   cjYPg2INHmFpfEG0iet9/66igBMu68GHrSs45VoCaQCnuWpqCtR6aeHGQ
   V8TlDAvkti4kGHG64d5JleWkX7omnRfre1KKx2lG/RdEg7c+Tvkuq93To
   gyBq7iuaPLD1hosOUpZsQrbDUOGLOnfHowIjR0uMUShc3Es0qe4rFaq4v
   Y+gkv35nbW9Gj5VOAjTNTPkxaIInc86WqAck2V4+VVLCLdctTSHdk4pHa
   5xESShNjNlFSc8vSB+WjjZIEltXbmyCSsnLxUty8AM+CyKvga4iXqnD2M
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10250"; a="247509459"
X-IronPort-AV: E=Sophos;i="5.88,349,1635231600"; 
   d="scan'208";a="247509459"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 00:58:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,349,1635231600"; 
   d="scan'208";a="628456163"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 07 Feb 2022 00:58:57 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 7 Feb 2022 00:58:57 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 7 Feb 2022 00:58:57 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 7 Feb 2022 00:58:57 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 7 Feb 2022 00:58:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6dkbrVaQBIdRLnbxyklDZFqy5sIEX2HIbAW40jWgJoKPkdkXs0oelOCjjwbbmxJHWkkCwudc41+xO3jyICJsRlhyD0vNxb2acmdycBw82A69ZyNiVtqD3kK1Cl29GofeYT5CBQsd8xb++jalO6dzbYXj37CaKf/x9dcAhCZlUntipPyHtudz//xzfH4uo2wgObfnXR8P53qBsG/6CoD0nvreJrYptyf1gpfUM2hqvjsnyY6ZNT17+hcNYflEbSm4cTsE6k5LLdEYCGQxpCm09BKwwA8aQaVkfUBxg5uqVdYgOfkPrZX79zU8LPiIbBMABmdpBGJG9DrRPWY1YdUWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPJX13CksKS7/3ebkUHKXNNKNF2Rt58yFwoahGZB01s=;
 b=Igb2VadEVjGxnD0xT5GDjFYO2A8L3Y3rD8Xp+hqB+4LYPe6E9ztxaADNn7+6kZOivdLRHxMkm9RWlPs+bGlR1sV5L5hGsqcIutYz9dShehtaK00/lU1mZ43o9EkTNmXD9PMKe18HHhVby75ngoPxp8yVGkAnMmchj3gy+W54c2qdESWp/VuaoPDZUOj3NI8PJRsYVRdGEZ6ipddov9Q64ZsWN2CUz2luWRdCMVWIYQ756+yoUglUrwMXlXRIHKHgWUK1B5qtvcx22MkBtE4CiBZ9XZO2SIxrzOReh2//nktTW1gIK5vIS55YYzppGAyyJrQ9tM4mZxuV+7aYfYAr1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by BL0PR11MB3379.namprd11.prod.outlook.com (2603:10b6:208:6c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 08:58:54 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::14f3:c99f:8985:674c]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::14f3:c99f:8985:674c%4]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 08:58:54 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     Corinna Vinschen <vinschen@redhat.com>,
        "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH 2/2 net-next v6] igb: refactor XDP
 registration
Thread-Topic: [Intel-wired-lan] [PATCH 2/2 net-next v6] igb: refactor XDP
 registration
Thread-Index: AQHYDURWBYi2gbWj8UaxOvmsJSIoxqyH5xjQ
Date:   Mon, 7 Feb 2022 08:58:54 +0000
Message-ID: <MW3PR11MB455413AA525BC82D2CEF33E99C2C9@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20220119145259.1790015-1-vinschen@redhat.com>
 <20220119145259.1790015-3-vinschen@redhat.com>
In-Reply-To: <20220119145259.1790015-3-vinschen@redhat.com>
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
x-ms-office365-filtering-correlation-id: 5c58d5c4-202a-45f4-6830-08d9ea18119d
x-ms-traffictypediagnostic: BL0PR11MB3379:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL0PR11MB3379FC5B63FD5AF1F6D47E989C2C9@BL0PR11MB3379.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ltgFIYCSBAq+8nSX2dJqavVBriGPFAF/rv1UCT7bwbMRVsBE+un/ACMK7w5bRUefF4dxXSUK/NL+CHh2gkL2fu+fsuMCQrJzg6wDsR1avdcZqJYS0FRbzcHCHt4JDj3p3iVjZb0Fk0kw+z70ry/eOcw9cIBcGnal7pF2G05mZbdTrLpXmoRRKOAQjKKU0zPXnYlOcgKILRLBRQDfExAGW0nmmvzojkZG6JfmkTE9aUBPPLyATa5Iugc54IkVv3WH5hclTt5TcP1wfrRMi7dwIEAjuWggJB9+Qo96IDW8Fjab2BcyoEYfrioWXVE3l4TpAjesJX024Z9INEztIgepJBz6SQjJlMY7hZVatbWy4zT/JT5RnBH38lGajz/qFpcI47i1wOPNoloxE02CH7R2hbaMVj6GjSG0iAsmUcuZTlI8gy9101V8LnqeKSgRr7XmulNFDc7MZX9jykcloB/DGDNLoI1AKjJCRFUrcxApSqHYGTNW3QNYI25CXRkCEfdI0KB8+e/eDH24KOScwtUuFiZ0XPxPaUBKjtVYbreX4mYRCRPB0Lc0VXmVIeY77qZibN/lODK2G5L5OCQu/+NcLXKkF91D84GzM4HjyCpjyKvbYGsxPZzgmfs0+MU8m1yzGFR/SrniAiYWEyOip1fJoYJr9rRwK62lUqoeoUvUZAcR4VzBK+aRSyXrGVX5GK52g8x6LCnbYyXbIqrE9Hhtvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(110136005)(26005)(186003)(83380400001)(7696005)(9686003)(71200400001)(6506007)(5660300002)(33656002)(6636002)(316002)(76116006)(52536014)(8676002)(66446008)(55016003)(38070700005)(66556008)(66476007)(2906002)(8936002)(66946007)(86362001)(64756008)(508600001)(4744005)(122000001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CkOfR/eHuaBrqhgGZP6OPIamxlslNJJS49SmobeMMIYNPjHEi0D2cTzT9VMh?=
 =?us-ascii?Q?Pe4BEUt741iS23VvOfof0Cd8+SGIVktis2BYlPOkEIgGNqvDFO8zkQfqVH7p?=
 =?us-ascii?Q?E4YVdiMMMD7Ny00jYPI9mZ39mYKDJB4bD1BLLdcJ247vfIMmSox4pkxrmnwr?=
 =?us-ascii?Q?XS6t1JpTgvXiTpJd1nmkmY+TzBuZim4BO5i4/fVOFvrVbKeeiazXzw5+gAur?=
 =?us-ascii?Q?aJdcHD1yC9CrVEhpIcnM18SK7Vy4gY+afmhZJjQBXb4oo9kfroC98OIoSAG5?=
 =?us-ascii?Q?mWdHNdM8PA0ewySOinF5n0UIVAtCn9PsMW0ZXYyxio1kMcWNy7NsXCEtcJoc?=
 =?us-ascii?Q?VhGUu8dzygXv1SQ5mn0oWvx+cSnw090KYLmT4IygXx4aXK5KFO9zdmuGq+LO?=
 =?us-ascii?Q?FZwzNEx4SkvxvaWQkgup2lmcXnNOt82MhVQA/l77BLTLjS1GtrCQ4ParwMn5?=
 =?us-ascii?Q?lU7RsnKBCGGPSMaIXBh5ywxh66P7EaokNnbIavthArjp+w8vsd0u/SQLskUP?=
 =?us-ascii?Q?a1Zv54iPU7GMnwe4IMl+bwDaf+G+1msjP1SlNAMly0G+54JVfF3qXm8JgopS?=
 =?us-ascii?Q?sYtdsAJipFqj95azY9l9XEWE+K2LvPt4Z+9O/Owq2RXfL4lsG7vIEkzoecsh?=
 =?us-ascii?Q?m9bGdE7ZCfD0JyBoGkG0YbuWHpvbKNam9NN8zHrxT4aaLKMXgag/Gle0l8He?=
 =?us-ascii?Q?B01BZh90LRPp+DwPYiD3+pwL0RiBx88yjDH0yl4LeSIZKOhsan0Jdgkmo9Mj?=
 =?us-ascii?Q?kAKi/Va/n10OatF8eTWkcLxxhRcYVWjcKwlbgQTjKSksMCzqV0RNKZQs56oh?=
 =?us-ascii?Q?9FXkMmxTVSwFyVBEzy8j+CzjtX2I9sN3IGY96yl9aGtq7Xam7EV7LOmyf/S2?=
 =?us-ascii?Q?btqxc7mnJlUHI+YxH4ZoRiuS3AwP1FmRwREyNXO35FlLj1RVHPcPt2DQpjjb?=
 =?us-ascii?Q?IpkXo2XChJNd91ACknJi5oPTOVdnIuzEghqsj8sWdA0J3EBvXWezvdyXIBxn?=
 =?us-ascii?Q?xbnbabA9ijfJhhZruxA4yMDMpQOw8xl/odmTU9gxG7vu1zQZrddFVk/rgQvT?=
 =?us-ascii?Q?GuutHbTX22bq+nRPMUtH2zbpDH4/PVmXgun8s5krWoQF4ozfl5P/DRJGfFiG?=
 =?us-ascii?Q?JYuWWARnA1618lVEXg4ylT6fwuX1aPhfTfOGH9JZugRjV8sv36YsLJxjp53B?=
 =?us-ascii?Q?8t7xv2rPPglA5wK8MKhfZBVPdyn6AVltX3eMI3xpCydbDpbFnXw1RERaoMSp?=
 =?us-ascii?Q?Tnym15enxOGJIkYqCG8a0cFuOvydAEz/z7JDm8KQYqiSYlzbXwiPreL8fjlG?=
 =?us-ascii?Q?GMM+1Esa6tr070zaaB0JgXb4oPAOICvWiNIP7fbUsyvX38qmwvykW9c24gwS?=
 =?us-ascii?Q?RW7JP1Ahwz13qEMkJB52OM3mqqsmAlBYGb3IJrl7oagOg1vpdwLZVoZxqeyp?=
 =?us-ascii?Q?AafeznypZRA8RQkJDXVwnJPgmeVb3VO4HR0aWOm5qfmszua1fyBCd9r8lhUi?=
 =?us-ascii?Q?XQQIiVyCc+iepk3qUKZr/U8bDnX5v+JbHyIMak2ejQg4V97g0vJI9Lxov3xq?=
 =?us-ascii?Q?ycuytxIiQukV5eoM0X6CRwtBvdAC7nVA/sEDxejXTdTVZCQ+YTAoxWtvDyZb?=
 =?us-ascii?Q?GSMX+3yczAtrHvWg3mGyhKs3BDYmfQr825CQ8PXklhrXCz3t6gOnAArCnWxH?=
 =?us-ascii?Q?YNT8xA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c58d5c4-202a-45f4-6830-08d9ea18119d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2022 08:58:54.4185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ND4zlSxj11lWR/KrgjEfTI3sKqSxThIVGvdf3k9VFYrR6uv9crFxyROquA/7y/ZU6oWH1VpIkxnltD1fymyEUoj0YFd+9oz5HENw1Vu0CoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3379
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Corinna Vinschen
>Sent: Wednesday, January 19, 2022 8:23 PM
>To: intel-wired-lan@osuosl.org; netdev@vger.kernel.org; Gomes, Vinicius
><vinicius.gomes@intel.com>
>Subject: [Intel-wired-lan] [PATCH 2/2 net-next v6] igb: refactor XDP
>registration
>
>On changing the RX ring parameters igb uses a hack to avoid a warning when
>calling xdp_rxq_info_reg via igb_setup_rx_resources.  It just clears the s=
truct
>xdp_rxq_info content.
>
>Instead, change this to unregister if we're already registered.  Align cod=
e to
>the igc code.
>
>Fixes: 9cbc948b5a20c ("igb: add XDP support")
>Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
>---
> drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
> drivers/net/ethernet/intel/igb/igb_main.c    | 19 +++++++++++++------
> 2 files changed, 13 insertions(+), 10 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
