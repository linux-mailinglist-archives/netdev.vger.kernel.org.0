Return-Path: <netdev+bounces-1037-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A5096FBED6
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:47:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C0881C20AEE
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 05:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19468211A;
	Tue,  9 May 2023 05:47:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CF620EF
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:47:05 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70CA7AB1;
	Mon,  8 May 2023 22:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683611221; x=1715147221;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yhYWxeRwg+s340DZgd7Un/rXBhgLurZt8ak1Ot+eHmw=;
  b=Cqa8e3KNcT9tWKfIubjhJnwcHQoaVHr9sWWwOl3YYhOIXQ8tBNCR4ECh
   Q8ZVz7xKn2Px/0/dwbJe+jGPDQ9gwgAhn91fBLJjBA+nvF26l/j9gAa/8
   MGH6up7mo9ncNvpc4ICaTrC47asOg+0vSNZE226oNtPakwwz07csD/8ys
   +FwyTXFmLWPccxXJ6/3ihGa6lk0v4vvq9TNghptk55phlZI5XkthoLELc
   W38mf7toOWGXfYJn2UPEB/BhjBctYhTxvVHW6wDHoGzirUldvFt4yP2tL
   OlzGNpt+Rn/RFA+/PoeFbPc+i6bTmO3XJuf1NgGxnlz/eE+aXv2B065CC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="334263957"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="334263957"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 22:47:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="788375842"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="788375842"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 08 May 2023 22:47:00 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 22:46:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 22:46:59 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 22:46:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAcqotm8aY/joN7cyN+qfzE7YlHSv/yiUHKJfFGzNpy+Ha03orJxmFq2uPEN1pvJhFMiTfnyuBBucCdPJKlQO0fpmmOfAZst9YAsdem3cnX0X1ohF0KbxdEzctO4wxVlumn9tumDA+4MhpyZmDqmkBxXR6txPjnPbWliFsXBxE76u8lh51SzIfN+0vvAqD9yw96q5+l1wNF00IShcR50CYZDYBlZDiKew7e+r0MwgiI1xV04zGnRI4AaEcdgsixWU2yBmjX2lvRY1+yCf7t6MWHf2adjRfBN7oW+PgBntadF2wcHZmBNLVvDK43GIQytOf/Y1WxCncOVQax9IRBDrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qe+mfyKDTGlnwX87SACr54wAjmVhx8aKlzOnggU5sZ0=;
 b=QRi57zPE7MDTeGDbKm67O95LPJ5HU77PQdRDPxImSBib/14dHAbQhG+J+HBjbdFGCGEcTAeXxdrdD2VK/8jOBEwHgEgj2WbgDtc5iq0z7+lLveOpEN9haC40hFSk/e41kA8tKMUbB/ZrkcNly2k5LhzNqnrvLz8CNasMVgBah0pBcp1L0zOS/xE4qZsvBgtbYUQkS41TUbjMZuHupyj4eceZQtEVebhv499bFUkh1TrIdnniZ+88OWhGtwswVgNf7p5vOhwc6HnRS1sC2E5pDUY00eGI3lp7PX0xMKKWATY8L7w8s2uHjLrEcAd2c2hpWv+zX/mqPuE5f2Wfx7ISkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5518.namprd11.prod.outlook.com (2603:10b6:5:39a::8) by
 DS7PR11MB6063.namprd11.prod.outlook.com (2603:10b6:8:76::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.32; Tue, 9 May 2023 05:46:57 +0000
Received: from DM4PR11MB5518.namprd11.prod.outlook.com
 ([fe80::3124:6fbf:e20a:f14a]) by DM4PR11MB5518.namprd11.prod.outlook.com
 ([fe80::3124:6fbf:e20a:f14a%2]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 05:46:57 +0000
From: "Rai, Anjali" <anjali.rai@intel.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>, "kuba@kernel.org" <kuba@kernel.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "Gandhi, Jinen"
	<jinen.gandhi@intel.com>, "joannelkoong@gmail.com" <joannelkoong@gmail.com>,
	"Qin, Kailun" <kailun.qin@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "regressions@lists.linux.dev"
	<regressions@lists.linux.dev>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: RE: Regression Issue
Thread-Topic: Regression Issue
Thread-Index: AdmBflVc4Ic7nWyeSlqpAyBHS0vdoQAAg7EAAAAQuLAAAXPEEAAXT8IAAABvdgAAFQWSIA==
Date: Tue, 9 May 2023 05:46:57 +0000
Message-ID: <DM4PR11MB55184DF5A8FE63E6AD8AB2F49A769@DM4PR11MB5518.namprd11.prod.outlook.com>
References: <20230508123138.41b5dc48@kernel.org>
 <20230508194406.73759-1-kuniyu@amazon.com>
In-Reply-To: <20230508194406.73759-1-kuniyu@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5518:EE_|DS7PR11MB6063:EE_
x-ms-office365-filtering-correlation-id: 1b1208e8-d572-493a-41ea-08db5050cd2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bJkfZnX7/yPHXNOsngQHQfc0b9DRoWM+SokPg0wcuU1S6p+wuRrOxsTQs+UHIrcuKNbRsv8r0linqgZmd0UjQ9MwWMF0IUCCHRU4GNYa++DOV+uviZpWd1qMJODFvfMTAO0tBgb63fI8KIBZ4HMqM7dYXZiAW2bgt6fIxYaIVNmUF6h8ku9iUoQfln7SpbkkuUJ3SD5S+O72ypndHe6S2ojPHImD73zeSb9f2wVJAUCwC1db7MDqSnCVpHFXR3MZIRNe5+YZQn+eVjCoTimZWK6Ei2jqzvw1WDU78Qg695zs7puzoQFhnvKfZZh+knaRt0VwuWhYSK0il98r+uUgiHq3YUdjbMODT2r6BIzoJW+qJhV/kAyLEyzggpc0CG25fJxAu5IlWTpHMn91J0TaHL/jU3c1HyWD97uLpjDurdDkqzAUxsdrK1iGFpeyp2In2bPFEgg08GROkNDldrtFJ2iQdOEvW5DBRksn/Df7tTNfyI4EmNfrFkHLVh0oRkipYOwcMzamqCOZJB4qklftAxBp3PE3CmtcLIOpf3x1bOiRnNle8XWS/1wMJTvU+7inqPcTAcJ+SsMXkMKFtPhBUtxbpWssWXnYx/NLszEhBHLXpt4n2FYONsV+DdKWGQ9V0f0u7gDdIVGFHUDrOdo9SQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5518.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(346002)(376002)(136003)(451199021)(86362001)(33656002)(966005)(316002)(110136005)(54906003)(4326008)(478600001)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(7696005)(41300700001)(55016003)(5660300002)(52536014)(7116003)(8676002)(8936002)(2906002)(3480700007)(82960400001)(38070700005)(38100700002)(122000001)(186003)(53546011)(9686003)(26005)(6506007)(83380400001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EdaDfUVkevE6bq5DKOi9WaoBPjbxoS1yW2XNVyS6sUI96zKkrMCLQET2TNjY?=
 =?us-ascii?Q?/2H+KgAPi3duMaoc/IDcNtdPDXQl49ab5nfBZC22DEhGwWQuiGgLrWlGjWT3?=
 =?us-ascii?Q?mQThH7dGbn1SSvucK73lFDshrxHcIhoizsgLAmNCvjHCw8H2dVT3ismWVIZ/?=
 =?us-ascii?Q?3pkVfGeLZNjPMCG9zEIyJjuU2QKmsNKJVIyWw0TF3xLg3aaVLZ877M8uj2si?=
 =?us-ascii?Q?biUxpZHTaJBPXYYCso9MqMiS3j2NKHo7j07AEIm7nY07NVCHPmbzcJR/mKLL?=
 =?us-ascii?Q?m0FD2oTMwxK+GX4tMaGGahEkocVQj/hjQex7+58p9fsS4RT58xCIQQM37Gju?=
 =?us-ascii?Q?oSXxNe6btodzL7V9dQfp1dJDCRCaKZNUu3DhtzijfG0yGFI+/bZdZS8JY0p7?=
 =?us-ascii?Q?6StWThrVh1hQQ4yF1PErWnetxxby7R2VsFyF8fSL9rAYjjbxlZUrSK7P3hNz?=
 =?us-ascii?Q?J11pn6N0JuwdV8olw2XrXvxNZKqmjmj0iUiqYwAIDQCN3/q/WAlwdS3gDprY?=
 =?us-ascii?Q?FxjxyOHgVXsDdu0M6l3gfGkumUyS3o8Nhawp9fnWMZwggP7RJmwl1jZNsF2N?=
 =?us-ascii?Q?gEyb0DXbjBv8oBUGfSKFrylSqk6si6w5otosACgtLnwrm+hQwKU6+MX6jCiq?=
 =?us-ascii?Q?bO5b6Pb+zzfjHuU8x0Px5JLvxXmEt7cg3y5MGXO241i6xx0npHWzUjoCQIKr?=
 =?us-ascii?Q?pX9q3rAT7baGOQKYfpI9wfewOjBm0jaSvPk8dtzSzpVhYao687bAFgGWBmQG?=
 =?us-ascii?Q?00uv8HDFV4iJVdS7KNvsWhHhQOO4OfZQW8K3crkOa0LT5ybKosZg3MHYx0ds?=
 =?us-ascii?Q?cj4uH//iBuSXI40PUD/gRYL4/i7ch2iXiS7YGbpKsW4xierI+CCMPAPWRDcy?=
 =?us-ascii?Q?oXNtImMeCBIs70vZLV3LxUo+6cDTyhknO7UDXTEBxXKSYBTvNNJ/fWinjGSi?=
 =?us-ascii?Q?xphOxtwnreqGHvTJdRpccS8UOFywH+/fi6MY95S6nhee5XHqYQv9h9HJFUh5?=
 =?us-ascii?Q?+0IGFmbqECgZAWSQhjldfnsnJIhlKX4KBBj/5OkwBozG+uDtcawlTc/OR7o7?=
 =?us-ascii?Q?9gMhSUAHkFj0Z9DMZiJKOY/IF0DgygOCsw1y13YwQykb+JMisZbvF5xCfP1K?=
 =?us-ascii?Q?LByBsOnbsGLzxF8K5A/tJ+grj98eyw56BB8tkLQhjuollUZ5qNCjBkBDLt3w?=
 =?us-ascii?Q?TJi/teqmljDESfprBc2IksaAe5+QRrdrHn+TL+FMbQGQX5gVFjX7HvrTX+02?=
 =?us-ascii?Q?VJV5nWu+v837VqlLFmDaPhUf/tCd1u6jCz+wE9IAwqCsHYOee7AIAhwIkF6n?=
 =?us-ascii?Q?pq5aX32gcMBWXYY97p5fOtVLPwwHqWN9/Ya4aV7krYAHDaYPGdjUeLUA6MaR?=
 =?us-ascii?Q?gydTIpv31XA/IbH8QBipfnf77LQwgjYHiQV7MBu4wq6jI7ehcRBNnu9ubuU2?=
 =?us-ascii?Q?hTS7RATjg65EEPJ5aymAvfKS4aI4EFT3GVJU/O1oLSZu9Nvo8gooy/YRzI90?=
 =?us-ascii?Q?S/20FUY1nxYURRIIXQ2ewM+71+n3tzuWT06SStBQw9BGOMu/eY9lFapQuhDH?=
 =?us-ascii?Q?mBTBF2B3oGRK/uGiwZYwcNchCV4z4VG6Kuus5me4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5518.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b1208e8-d572-493a-41ea-08db5050cd2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 05:46:57.2698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KcuSNzAGpEsjL7nsxZm3lIbP9ota/f3/2+qa7OATScAUtAgFCCErH6mUxdZvlwOvXoto4M5fx3kKZu+nzJV9RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6063
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I updated the kernel to v6.2.8 and the test runs fine.

Thank you for the help

-----Original Message-----
From: Kuniyuki Iwashima <kuniyu@amazon.com>=20
Sent: Tuesday, May 9, 2023 1:14 AM
To: kuba@kernel.org; Rai, Anjali <anjali.rai@intel.com>
Cc: gregkh@linuxfoundation.org; Gandhi, Jinen <jinen.gandhi@intel.com>; joa=
nnelkoong@gmail.com; Qin, Kailun <kailun.qin@intel.com>; kuniyu@amazon.com;=
 netdev@vger.kernel.org; regressions@lists.linux.dev; stable@vger.kernel.or=
g
Subject: Re: Regression Issue

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 8 May 2023 12:31:38 -0700
> On Mon, 8 May 2023 08:27:49 +0000 Rai, Anjali wrote:
> > On Mon, May 08, 2023 at 07:33:58AM +0000, Rai, Anjali wrote:
> >>> > We have one test which test the functionality of "using the same=20
> >>> > loopback address and port for both IPV6 and IPV4", The test=20
> >>> > should result in EADDRINUSE for binding IPv4 to same port, but=20
> >>> > it was successful
> >>> >=20
> >>> > Test Description:
> >>> > The test creates sockets for both IPv4 and IPv6, and forces IPV6=20
> >>> > to listen for both IPV4 and IPV6 connections; this in turn makes=20
> >>> > binding another (IPV4) socket on the same port meaningless and=20
> >>> > results in -EADDRINUSE
> >>> >=20
> >>> > Our systems had Kernel v6.0.9 and the test was successfully executi=
ng, we recently upgraded our systems to v6.2, and we saw this as a failure.=
 The systems which are not upgraded, there it is still passing.
> >>> >=20
> >>> > We don't exactly at which point this test broke, but our=20
> >>> > assumption is
> >>> > https://github.com/torvalds/linux/commit/28044fc1d4953b07acec0da
> >>> > 4d2fc4
> >>> > 784c57ea6fb
> >>>=20
> >>> Is there a specific reason you did not add cc: for the authors of tha=
t commit?
> >>>=20
> >>> > Can you please check on your end whether this is an actual regressi=
on of a feature request. =20
> >>>
> >>> If you revert that commit, does it resolve the issue?  Have you worke=
d with the Intel networking developers to help debug this further?
>=20
> > > I am part of Gramine OpenSource Project, I don't know someone from=20
> > > Intel Networking developers team, if you know someone, please feel=20
> > > free to add them.
> > >=20
> > > Building completely linux source code and trying with different=20
> > > commits, I will not be able to do it today, I can check that may=20
> > > be tomorrow or day after.
> >
> > The C code was passing earlier, and output was " test completed=20
> > successfully" but now with v6.2 it is failing and returning
> > "bind(ipv4) was successful even though there is no IPV6_V6ONLY on=20
> > same port\n"
>=20
> Adding the mailing list and the experts. Cleaning up the quoting,=20
> please don't top post going forward.
>=20
> Kuniyuki, have we seen this before?

Yes, we had the same report [0] and fixed with this patch [1], and it seems=
 to be backported to v6.1.21 and v6.2.8, not v6.0.y (EOL).

[0]: https://lore.kernel.org/netdev/e21bf153-80b0-9ec0-15ba-e04a4ad42c34@re=
dhat.com/
[1]: https://lore.kernel.org/netdev/20230312031904.4674-2-kuniyu@amazon.com=
/
[2]: https://lore.kernel.org/stable/?q=3Dtcp%3A+Fix+bind%28%29+conflict+che=
ck+for+dual-stack+wildcard+address.

