Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C003F2203
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 23:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbhHSVBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 17:01:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:5325 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhHSVBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 17:01:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="213525698"
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="213525698"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 14:00:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="573730511"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 19 Aug 2021 14:00:43 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 19 Aug 2021 14:00:42 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 19 Aug 2021 14:00:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 19 Aug 2021 14:00:42 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 19 Aug 2021 14:00:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbQmR+kFpoxKxvElKgXx0BiH9ID34VR/QUt29fg4P5oPJfzTOve2VdXp1gCn6ry9Nr9lCyW4lXlB7pvQLRdjrlhZZzE58WAq09IRZM0rMtyqv7bpkxdEymhxv35vUtB4hoVmwuva/I5nai332CaZi4KIwaAILCgPSFjF/v61xhfBZxiscQJI8bHL1Rbxo5KY9Qr3An1dMbVuOku0GqI8sKZtiYPvbeANHI/ykRMjWbXpiB1hr10LyQM36t98mdqog19Jx+uqeIn1LHxMN6w6il6hXGWP4Qtgtt0OF7+7tCPj00BMFgfRval8QTL4zbZS9HNY58NqqW7al8/nzepz1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3ywgdQVoRTzO1iF4XLi6WuAId01QxfP0qdcupjZEQA=;
 b=I33Wab4XrTlOMH/A+XSLOgaXiD6Stj7bMC7FDvc81dW0Q06uDZURlRJVeh/YnzU2xJf9lTeMdOG6GR/KCFThske/PY8ppyXGskhDATcux2PMiRM058hkaO5uL1kQj7iKUL8nA0ZzlAzA6au+hpOabq4OI37FR3QKt+N8x0eclj0vJdf3eXL3eCUDUswmRtaMRJI85+92kbEb62LlIKa0nAh5V4H2vFZmEt8L0cDNSEtz//LkWdubWWUw5wvjW18q8NxeTkKMuGXYJ3u6NMfmrdjgNYo269ysZTNCm1gwms6ZwvPgceT25KvyfY/f6rAiR83kN7b/Fby6JzSIS4mCEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3ywgdQVoRTzO1iF4XLi6WuAId01QxfP0qdcupjZEQA=;
 b=UKm2XvC3gvd+gMP72JzHsPoMyUYuZUcAafkaGxQ8x6E6Xm8db+ZgcQL8zXCuAVfuXSUSK9NPpuLrLzNr/3ymRlP2RcdhfISnZ8IeV6RaLHCUAZ0suTPVeOaanBlylbhOGB2ynAyuHkuvgLrSkLvi8kCH2gSIhhdz9iYcC0qdato=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1519.namprd11.prod.outlook.com (2603:10b6:301:d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 21:00:41 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%4]) with mapi id 15.20.4415.025; Thu, 19 Aug 2021
 21:00:41 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>
Subject: RE: [PATCH net 1/1] ice: do not abort devlink info if PBA can't be
 found
Thread-Topic: [PATCH net 1/1] ice: do not abort devlink info if PBA can't be
 found
Thread-Index: AQHXlFiQ28+ySjTD00KL5o5CwjrgSqt7DMKAgABFBUA=
Date:   Thu, 19 Aug 2021 21:00:41 +0000
Message-ID: <CO1PR11MB5089936C177B4A0794EC38D0D6C09@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210818174659.4140256-1-anthony.l.nguyen@intel.com>
 <20210819095325.5694e925@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210819095325.5694e925@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57ca1b63-069f-4281-a808-08d96354676b
x-ms-traffictypediagnostic: MWHPR11MB1519:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB15195BFDE4AE14CDFB36BA46D6C09@MWHPR11MB1519.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gR1MhCttPUHKsulQXBgTOfwCcyiNvcUMQbFHzHH+/7nENpRJJXNd80jj3y5kheRe/YXSW9tgyATNCH93NsjUMkJHFRpQmhXFdeikF9v/fa9Nuaxx5wZ81wPJ5hOa2OO48jzc68hKwocU9K2qEfqotBiS7jwhuJC+7y6BQ0oJOZFjW3gLo/S9BjInKCHZZWm/BPPZIg4ab5/gbuaq5fNk1HSLsMbODQuRPiHisVWk4uGAds0gYeWaN0t4sxcmr+9KtXF1gWvYAdjeEGTLgUoNVTYHd8GMvK6MdpKxGyhOSA13XwVlns/Tmt7Gacm14sK3nnM0PMOld9DGvOEKX150IPFnyxIDiQ+i5iLAxkHwOL6Fcn9vi45oVTs2aINbmFcoYl1rziMZXjOJIb/Ithyb05TAwDOP93cog0hxek9aZ/u8vxlM4Tna4cnAhjEt5/BhCmXIohV3kt6fZNm2SeoeeS+wyE8xtQtnPPZhjuGhJ1AkNMmFEdP8YqUQpGd3Um/xsCFgiKi64J8jp5cCVPDFWKqDOHXhFeQm8kARXcDbx9oPO9a2Xmp/lRoC94nKOQevBo15hIFBMmVlnRxLDvL9zsxQV7XOAAHiU8VH+I/sSHx2kU92XdEz+chCIQRu+/WgtFLbBtZcGFY0RQuUmCfpUniBbUGJ5AaKdA41CwPIlW/rpNwIwfS4aaU9KThtoVwNWyWlp2llkvuhti6WNAA1Rg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(33656002)(478600001)(54906003)(110136005)(53546011)(6506007)(107886003)(7696005)(4744005)(316002)(6636002)(122000001)(38100700002)(38070700005)(76116006)(8936002)(64756008)(71200400001)(66446008)(9686003)(5660300002)(52536014)(2906002)(66946007)(83380400001)(4326008)(55016002)(26005)(186003)(86362001)(8676002)(66556008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2R1i2C8K2U5onnZAkB49BbfsjgDUDe7ET0hIYgvopxO4Lv2URNUQxP/i2Pxp?=
 =?us-ascii?Q?/ro0DGO78KeeaMund1Td6UM+4uVvxqdSM1yxbMxB4hI+FDcgiYBBjwKLtf2E?=
 =?us-ascii?Q?ixpy7602cx9tRINlDlJf34JZzcamKmUiGMgXM7uwl8v4w0tOl8U3VnA/yrJo?=
 =?us-ascii?Q?pg75K6pqDRlSlKZdB/6XeU1WoJc5ZNpDdOT8zGcFsPf9mwjF46KTmY4i6tcQ?=
 =?us-ascii?Q?Z4KTWHVmdOj+Ck9KZzuHBEBYjZhGH0TirmwWD6Jl5AyuMI+fXFEVDa7TVD1d?=
 =?us-ascii?Q?fHPloXaJMn8trgeah25XJTaI2UmT/hRAAZCSYuLH7A1L+7go90A4bADK/MOM?=
 =?us-ascii?Q?qAwvWi3lvInuICmcttNK1X4jTugsugtAnXK72uOnBIENSbaLXUvyqGQv+qG9?=
 =?us-ascii?Q?3i/jyuldnE0V2NxAnivyzwnJlcDAFL06SrnuxHeQP6jjy2UA1RxQXm3Ll5jX?=
 =?us-ascii?Q?v3VGL9vQcJ2UV6HdI1iH3tldIXT717O/2la0zlZxHhPke5LzDLB2ngGjuAuW?=
 =?us-ascii?Q?e4Q8k4ouK/PDdJLILtE4CpTMz1NbeFp/08DXtHA7NK7NOJB5ESPlnXr2T/HR?=
 =?us-ascii?Q?sFsyrPpUWCceA35gYymLHjAJeGRxjS0WA1X6eULs2eosikM10z95OkA6hjf6?=
 =?us-ascii?Q?Vuj58F1cR+Gxc5vjlTRByNVTam/pPzgf7IC11wGHM8IOBbn4Fv4x1JRYysnO?=
 =?us-ascii?Q?M1WonCO/aUwCZ81fPqf6E5am9ESjFTtkTRuYftDMl2Udc+Qkc1pjeQyZ1x3u?=
 =?us-ascii?Q?TgQwuVGH+DXm8pn8OP8D7NocZfmZKGV9lcbWVqJKJqhWKYpnnL3unqYLAk8C?=
 =?us-ascii?Q?nJPFx7ctAhTaznvjP1T1eNAvmh6kNrrDSz3QXss2XlZKTIlJqfWvGEvoj3EK?=
 =?us-ascii?Q?3s2N/z2YF6Hy6+GtI9PB6KMMMUiAMRejohccCiqA9SCXMrUY5ekSsMU/HpWF?=
 =?us-ascii?Q?duRaeULABsX6U9A7andABPaQzDVIQMrAC8+Gh1dsQrRP06SeRi73ev8gmn4v?=
 =?us-ascii?Q?WUr4ZCuMnKMVJn5Msr316hYIKb5P0Yl753XAdW6Yb7q990blqPXKpMh1OGOa?=
 =?us-ascii?Q?JzDjlgMdml0TJcKrIMaPe0TXHPpRZaYCdgHBnDwbh1QFepkHWtMy0UKZ5NQf?=
 =?us-ascii?Q?XspKwxffBIILK9Fg+OeQrYKFsCoKqaJOl9AQ9CEMZaPigRQNfS2vADFwvgwB?=
 =?us-ascii?Q?KlcQ7ZTvCerCp6SqV1HCbCS0SEWM03y0tfcovUf99js6iThJ4Lt1iO+AdllW?=
 =?us-ascii?Q?Egm0C6xGGeq9KZc7wFF9axQdfXDqVasa9Vd7Vy9x9TpcbPXWTWZW1wIz+rrg?=
 =?us-ascii?Q?CXA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57ca1b63-069f-4281-a808-08d96354676b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 21:00:41.1803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v2zCjFrzllm0Ep6DqH23sBJq/hypLZ/XrBkRVGuYP8qyPjh2x/hfO6g+GaJnmSI5Kw9zSqISc3BVn1b2MyQjpc2aaJNKprJvjou74FkgYBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1519
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, August 19, 2021 9:53 AM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; Keller, Jacob E <jacob.e.keller@intel.com>;
> netdev@vger.kernel.org; Brelinski, TonyX <tonyx.brelinski@intel.com>
> Subject: Re: [PATCH net 1/1] ice: do not abort devlink info if PBA can't =
be found
>=20
> On Wed, 18 Aug 2021 10:46:59 -0700 Tony Nguyen wrote:
> > From: Jacob Keller <jacob.e.keller@intel.com>
> >
> > The devlink dev info command reports version information about the
> > device and firmware running on the board. This includes the "board.id"
> > field which is supposed to represent an identifier of the board design.
> > The ice driver uses the Product Board Assembly identifier for this.
>=20
> Since I'm nit picking I would not use PBA in the subject 'cause to most
> devs this means pending bit array.

Yep that makes more sense! Thanks for the good review.

Thanks,
Jake
