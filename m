Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27909494906
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 09:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357767AbiATID5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 03:03:57 -0500
Received: from mga17.intel.com ([192.55.52.151]:41765 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240049AbiATID4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 03:03:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642665836; x=1674201836;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zk3qjTgwokdg8NahD1ulTJvIC3IlV/CFaQ42M7QB/rs=;
  b=ajDSVCqJticLbffce3QrAaTdkghJ4sLNlGDuc/GN++MHiwOfkVryWn4p
   uzccpZiYeCujYINY4EO4iUnnvBKbVg4GmEtro0kMkNjz10q52BwN2tOwT
   ADsa883q/pwyB9ZFyCGAB9MFEJjKF3mfKJG1Hb9t9G/SIShUrIXvKHMb8
   eUpuj7UauMMNYovumim+2l53aSQYZfUUgOg9CFx1DTaDdBblo64BC0mBG
   xcTPCjUWSUjSMmHzhjlezArPNF3bj5SJljmySIo+KVk3xv3xNoCy0YHSf
   1pUaIsMkI9FXb6PA5Sf0+/VT56HKNmeZm5y2nFW52NiOYdcSLeSU35clp
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10232"; a="225968301"
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="225968301"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 00:03:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="532667111"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 20 Jan 2022 00:03:55 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 20 Jan 2022 00:03:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 20 Jan 2022 00:03:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 20 Jan 2022 00:03:54 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 20 Jan 2022 00:03:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifTf2seUI32c+/PdMP3HxBi9e25KoGRVcB7Wtfnxs7r82uS0gUtpalcAaIfdA8U4eiOr0EVoamMdfUzQKgmOYvS4D8col+n72QX+Hb6irwYJUbh7Oj/zu0pC4KNEXUO0wN0msM6ubB9iKmSJ2tAQB6e66OHEhDaH9R7ksuNhGXDbyHvTgnbIbNKCyRof3Z4wsO9q69bI6oV+e66+0FW7EVYYY6hfI8B8dsFqyl1SSne9G3KoHdPz0tcNqUBKcDUc19qt2StgGDiP5L3JU8Hk24EpzrgwsXTTNoUcFPPzbroTEAhOL/HNPy1AFKFJK4TxYNdRZ7xZVgiAshXUC3h1Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KWz6b1YBWmjE6heQOFBvhI6cxb9i7FMa4WFG9d3N7lw=;
 b=g7ijlK/cBGfLn3G0HQZcLV+/cX4PUAsSVjrtSnH2P+LB+KKSVMr+LTTF3FnAmYmf9xEXbUuExKAy6P8jSf/+iJfMnC+gOTjfrW+sgui5ySo5stVGneIsVpma0WAmoMKmS5rPpZrsvoYt3P5hybiBJThOtblVKX/Ehv6bx5+v8+vC07UZHFdUWuiI1z+rNoPu/ZEOCmwn0YrFtsDhDp1bY1VnrGEAQ8FAeLx4ScWTUcaeA0bR6RxBVMwwwjj27um9Omy8wbf5JRHEwKyImbMH7ZEKN+/BuFNCodNoi4ZuBk2AQvM3IcflnY9th704mJqMSVOTDsP+JexiL/2O0nsn1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 BN6PR11MB1331.namprd11.prod.outlook.com (2603:10b6:404:49::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.8; Thu, 20 Jan 2022 08:03:52 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::fcc9:90bb:b249:e2e9]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::fcc9:90bb:b249:e2e9%8]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 08:03:52 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] iavf: Remove useless DMA-32 fallback configuration
Thread-Topic: [PATCH] iavf: Remove useless DMA-32 fallback configuration
Thread-Index: AQHYDdRD8oH/E9S7X0m7KiBgTxInqQ==
Date:   Thu, 20 Jan 2022 08:03:52 +0000
Message-ID: <DM8PR11MB56216BAE634CBAB39F0F88E2AB5A9@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <afb3317bc87677096e55fc96f317df29f2ff3408.1641752631.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <afb3317bc87677096e55fc96f317df29f2ff3408.1641752631.git.christophe.jaillet@wanadoo.fr>
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
x-ms-office365-filtering-correlation-id: 2d8d5de5-168a-497b-e04a-08d9dbeb6633
x-ms-traffictypediagnostic: BN6PR11MB1331:EE_
x-microsoft-antispam-prvs: <BN6PR11MB1331F7A607D02544256BEDEEAB5A9@BN6PR11MB1331.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:590;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DCT7/T/BebPcYPbvpmP5JHaws2T+ifFjgPOzTbkW3Uusrgv+etUvxCDsberK/PI3ZS1TJFpEUe6IWtoKx9te5KohLszCdFtowaRUGbMdS8VvzD+1JIV1jLPaIrdL0lYIXY/0PgvNBDzgKKsxQbBoYUXsiOqH0MNjXjzRCMcynfIoqMry5E7wjH4XuIjOhLDaB/VOBpDeY0OMQjRSbpn9v3aWy2FJiq0JXQnFqOU6jYZoCkG1adjnEycwei0V0ME9JSPl2h4kPSORQbP4KCIxzoc8gDCakO5PRB6ROlr8/zqfB5C1QxheVWLtBGDkHj3iy0GEvm4hO+9CdMwFK2i+Wr14PeeaXZIv5o9m9j5AOPlPxjovsSOun99g2hV3lHXdzAtF9I1D0tRhCSfMub1A/BX0f8ktnkcTvH03Nzs1ziFA1rFTCAD98IniwYibTrJm+o1DYzvS36Ug8KXBDWEJy/8LCYSxcS7UrCo1TrAXsaa2+N+GNgvI36izl/pH0OXQqz3AJEH/9mC3TcvD/SyJc0wf7A5Bf99XkHmVvnGcva/ZHlTNIk2ZXBD312D291xletDFQFZjduzTzm4dmp+E1h6LUn4fDhc9ziQXeQGa3fDWXFRSNy+OxrAFFFBm60mSvUsfMksECFwcAc75iFk5kYvzNQjsqtc+nYcKTGDAHohKN4FGVZmCYQ2/ImkhMFfV2Rokd0vAL+rv8uNdREv1nN06iyaBeGNsMfZ5HvXrc+vneOFwXw5U4BCklpLxuFDUgBvVyu3hx/FbQf05bnImk9zcDyZ72afUOxtcFV5ITw8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(82960400001)(55016003)(54906003)(508600001)(71200400001)(966005)(83380400001)(52536014)(66556008)(64756008)(66446008)(316002)(110136005)(66946007)(86362001)(66476007)(76116006)(9686003)(186003)(122000001)(33656002)(5660300002)(2906002)(26005)(38070700005)(8936002)(8676002)(4326008)(6506007)(7696005)(53546011)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u22u15VhPT1w+wyD1eWEBnx3rO97HoSukycvAbxTra1td5mtXUV+teMRdNoE?=
 =?us-ascii?Q?pRmuVwP/DXxn/jT7Uuq1qDNRH1fzcxvvPUlmEVlG4w6fCa3TLoIkz3c+MKvC?=
 =?us-ascii?Q?pKNtRom+xqa4L13oxmGr1hQh66G0jDfr+ckC/7Cqrf+Bktd6XJ3qprFCe1ZH?=
 =?us-ascii?Q?1i5Eh0RUCsajd9MHqC6TkGNoBEWTvy/2F8D3bIL4TkMIsArycSWkn6gsyx/K?=
 =?us-ascii?Q?jhTLerZOqUtrXzqhX39tAZSxrU+1yTr3OYeMRAROyENQ5rQlN5cfpu6tx7H/?=
 =?us-ascii?Q?mFdX+RKUmSHmSlWyY1b2a/RJrWYB+2uM+CYdybs64qtLRuK1gt2fSJ7oPoml?=
 =?us-ascii?Q?cBUgO4v1PhBj0Tr+pe3Lk9DSoKP9iAWAf94L6PU3oND/DEuq6yBbROhOUABB?=
 =?us-ascii?Q?Yb65Tm65c6i4MhAaE4I/Q31ImpX4mFHUpXAA57qUqbMTGP1cndoCgoZxuUKJ?=
 =?us-ascii?Q?XSCJDXYcepmFkS6WOPsn2PEZHjESKVhdklK+lcxTqsTd+JqYwG1ft32u5lem?=
 =?us-ascii?Q?toiaa3YMUyBfz6wYaDAZ/prcKax/+3E97HugngjWXK4/jQA0OcSuF/uUGozY?=
 =?us-ascii?Q?yJvBX6mhHHmcbD7p9yrCyy73fz+pk7f3I2bzDuEe7HIoki9AP1m4NJFQPtzl?=
 =?us-ascii?Q?oKO7SF0baieLWgBGpwrlkG+XWeffOI7A/M3Nh8JSdaGiSXshrO4UTh35g+h4?=
 =?us-ascii?Q?Npbircz+9Vf35viJfS3qPITN7YnN7JSlzdKIrRfTD8fwW3vPYbJ7FTbnBFVo?=
 =?us-ascii?Q?Rjr68/16tVd6WYHF7JRCqFpm4fLtIIUo5dHm9/pW6yfyZ+ExiueiixbTX2YP?=
 =?us-ascii?Q?WbsNG6nNu1aSrX01boZcfIHo52X129ZMpl5sRmWHh4kH0QAb3eVx0xgN9oTv?=
 =?us-ascii?Q?kPVRN3y+ClBEXSwJfj+ZwplRqLVS3epalc1r1RRGqMZTyCmLYy4yalagMdnr?=
 =?us-ascii?Q?P6IWdLl4eRzJE6AxXVzopNhmR2mnqbITIFwH1hl2Bi4nJYdBIuv1BsGhM0o3?=
 =?us-ascii?Q?cRNWpe0q5aS8p13wLGdER1ga0pqjHfK7GaydXGNxzQ3M0s881b6a+GVkWzyn?=
 =?us-ascii?Q?07w4gEPlty+1vAUKMDLPwYyVSmn5QPoI9cUW9K2vN4AIcdg71oGOZt5aKDPn?=
 =?us-ascii?Q?S24j8cxrLtoMAxT9E1p99L9gjFJkbze2vPqqJgSFpXniAciOrRv8Dt0C/Qcq?=
 =?us-ascii?Q?ZYEuEs6a/skpDfzT8LnueIgl/L4g/laWhUTu5eyhP0RD91dVnmdrSE77KS1R?=
 =?us-ascii?Q?cgA36HdQtQ2pS8/4kcJFtYd2Iwprse6SlPyS2wxayMokjAPWTph4SLMzfswf?=
 =?us-ascii?Q?0FCIBniSJwsdFV7nPl9qBDoLZhq580O/J7+VvuamHxysg+weVvNPBLS3LI7I?=
 =?us-ascii?Q?4ESxLrx8v/ZylklGLGHQvogBd6ivkPbj5qvvhAdrzJ+/f5TvlB4KUJi6qEO4?=
 =?us-ascii?Q?ZIlGkWghipcbOklYtjDKkN+Lc39iUQ3dVT3T6ygKQBjPdKcrF/bafgjEYKHw?=
 =?us-ascii?Q?18i5lUmufI+TvFEtcsFxfnmA5/nu+qvOcJFppexcL2L2yYRw77/66GEVrIE9?=
 =?us-ascii?Q?uhd8IWAOY/VnHJcXTi7Oa6M1eg2Cb7dWkZPX1ALOKZzSifFMdTmWI30k8Jdu?=
 =?us-ascii?Q?d7+A7gFfNvqZcVyXcPkV7qlOhyOfumKNpQrtIB/syeUzgKTYaQcrx5l9D82C?=
 =?us-ascii?Q?hKCqeQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8d5de5-168a-497b-e04a-08d9dbeb6633
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 08:03:52.7328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S+X6if+RQqGcS2Vde1bNOWE97fLzATmG7EJUHa3PeFnh2QCqMtdheXQxgsFndpkBP0+2dMXaJNyef86c6gWbuOfpuDyviwx4AIGS51FQ50s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1331
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: niedziela, 9 stycznia 2022 19:24
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>
> Cc: linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org;
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>; Christoph Hellwig
> <hch@lst.de>; Lobakin, Alexandr <alexandr.lobakin@intel.com>; intel-wired=
-
> lan@lists.osuosl.org; netdev@vger.kernel.org
> Subject: [PATCH] iavf: Remove useless DMA-32 fallback configuration
>=20
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
>=20
> Simplify code and remove some dead code accordingly.
>=20
> [1]: https://lkml.org/lkml/2021/6/7/398
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 8125b9120615..b0bd95c85480 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
