Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E059048DDB4
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 19:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237544AbiAMSds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 13:33:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:50839 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230151AbiAMSds (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 13:33:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642098828; x=1673634828;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m2jE1Xrco08L3VzCTmaN3TATvZrXjXwbUvRZxeCzYvA=;
  b=DOyPau70tV1Bc+6slz6ZEhgxf5TIgm7IVa8z8MouUdszkzxOJY7PRz+X
   lRs0Z9SLIGJ2TmUpQiV+uc7mt3B+K0htzIqB3E4Sq0pktbmvWEniFufO/
   vgZaowCmKAHbVdOAUKibv28udITu9jt69oaW3p2N7BhwKp54t+EK/c3Je
   83OQty0GeQ9XjxsHz+1/y+w8RsJjLfPXqUu7cX0+g89NTvpVo+XWcHgqX
   47nc2RzTqgUqKd3WZeF1wkCthOuDLKmOqS4gpe0Mf2QG23iAYQL02lWqZ
   yLfQLePj9o+Yt0hLXMdrPWky80xg55yz03U73r/9TO//ly7fjqVuzp41h
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="231433293"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="231433293"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 10:33:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="620698449"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jan 2022 10:33:47 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 10:33:46 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 10:33:45 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 10:33:45 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 13 Jan 2022 10:33:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MfkM3ORgz7imzl4U1FOfdxwKles+3XKF+PZHkIMKms+/AX4aq7qUOEDxd+zjs+L4Jh4y1kXYduPvo+1u8YWqRfNlq1FPy1AIYCURLZv7nyEqZZ1I8MBpyCG1s+XX194LdAKibukKBuCFQ7Si9xzuNGp7XKXs6zxmzUWBqO16TvEQq29JkUo2DoFR+LoE9XXz4BglsirdO/DvdzGgtAwmhK/xZ2hCXAKtjcaFgsQGD+fP9celJaCkRAzmX8f2MLsmv7fVZs4gLB24JijtTMvriWUw7WhIbghNV0mRpzvFozL9P3n2RG6voB7ptFAjgPDMeSBYnf24QihrMOI7VmeFSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VLk6jKjev9BMYcT+vFYiX5GxbDSTCbeUZzR3qUsvd9Y=;
 b=amgNnEgs0PdFIXenUhenM0+qWwlfzIhPKuvbzknmbuP8QZa2kybZeaaoLKvWMU+0MEmG6D/dSL9TF/1fRyt3kQQME9HIbIIg5RBO+bwXuo/Sr46BFRdx9Z7vywJm8ssnWYThgYKNRP4nmjNX4/X2AWfCJwwJt8Wqvpzi0nF6mIGs+GdDoJ89ELNbD0IsWATHO2Uy0859fapovVN+RwO2whKeLCkVgYyxpjaOJgGAgCCOVAcbr8yrJVpfd+hnQP8pWrM8kmsfgtFpY0rEsJyYfjeoL2vtGMt97H97Cttg5O0sOwwmwK3eRnZIhKrdfxhfgzHBTniECCFPFNAk0aD/ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by SJ0PR11MB5006.namprd11.prod.outlook.com (2603:10b6:a03:2db::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 13 Jan
 2022 18:33:36 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b%4]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 18:33:36 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [Intel-wired-lan] [PATCH] i40e: Remove useless DMA-32 fallback
 configuration
Thread-Topic: [Intel-wired-lan] [PATCH] i40e: Remove useless DMA-32 fallback
 configuration
Thread-Index: AQHYBXyct47XNXx/XUCIPN/yJ8St+6xhTQ5g
Date:   Thu, 13 Jan 2022 18:33:36 +0000
Message-ID: <BYAPR11MB3367FFB4154822E9D881C8ACFC539@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <5549ec8837b3a6fab83e92c5206cc100ffd23d85.1641748468.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <5549ec8837b3a6fab83e92c5206cc100ffd23d85.1641748468.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee0bb462-0032-471f-a3f1-08d9d6c3365e
x-ms-traffictypediagnostic: SJ0PR11MB5006:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB5006CF511AF084E55D6E181CFC539@SJ0PR11MB5006.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DCVE6I485WdlLC5Lwt6tTQqHFQvP1X/rqs2i6DWehp/PXIhaD8oM2t7NHgSlLVf9MmqDEPioRBlEYnTGnxsSdyWGhrhjzKG5pu1vylqEV6+rWevtQ/YHAA2oOfHzoCmE89Gi1T3/zMRr9ioPhyjNWNIB6ZllBuyaf14bbOAx+np9ZeOWGpqNiX9r2z01+h2KnLwGJ5TigGSvx44xnzBXmSNaGFzNqHyFPebK3uUDP1Ebj6snwZyHxLWaeBXKlnPb+C8Amy2UdRL98wP0cxePszgx9tFrAWjh56Fw25AA6TKvF82AzSQkTneHg15MImnb6nHPYngolCH9uQKba88CHbqrT9nTthsPKipgXcjds3QAol9alowhFkRV1FSmaMMdppRhXqwolTIuHxa3/Na8JdK95dKvA3WMwufbdSUOxM31EuRWRR3yO7B7O4xzb2fdEs8yYEjJtD3N15sj/w+10y67HNQT1EFBZgeRKws7WFB9TrVJ1IbH+Nl0Bp/OQC0SA+HNYxvMPFWCCiTMCzrlOdd8b6NejRriGYF8H22uOcNqib/10DMkgR0HcbPwGFjEk6f4iEaJhJ95FubIe6ErKmo+CEv43OTh2/EgAt0gA/Z/YPJM7f+JQFgs22KQordVgp5prvtyVJkr1b1VtEbpcUYPd/SkWHGDpcsSfiCt5Ec8AzkFYdukFjya6ntbP5/7jJL91TYTjCa6tQBMkYQweWG2gUS+r46pPHKAX/CjxLjaEvqRLUJxx63PDalA46ZxEXe1Tx6jQfU2+52ism0oxt5r1BRJKWU85Ehps7ZFFlY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(76116006)(7696005)(52536014)(54906003)(55016003)(122000001)(26005)(83380400001)(66476007)(5660300002)(186003)(66946007)(71200400001)(8676002)(8936002)(66556008)(4326008)(110136005)(316002)(9686003)(2906002)(966005)(38070700005)(86362001)(82960400001)(6506007)(53546011)(508600001)(66446008)(64756008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xq1pCYVTC3W35JyC86xxLg+LHg2vwEuWKa2DFj5V/rUPZlZUP6gRt7N6X+Uv?=
 =?us-ascii?Q?SnbhRoyVzFjw0fGVTz01R7OAaPzzGU3ve7mY4yEszR2nMPKaT/0zcsL4iJDl?=
 =?us-ascii?Q?i2/caUmikqGzBjONWwje8wuBVmVfAFOvdkO4O6qLH2SuJs2cQ+2ut9B8BUfh?=
 =?us-ascii?Q?ZkWR1oJ3wSnvX/DCMdLRVkJYZvxb708U/xY9rxniU3IQwnIwjX65pMM8jbJ8?=
 =?us-ascii?Q?EFFmmzhiJmXsrWfLgp0eELOehruOAjsmP9S6zlwlTL1/OmumKsrWh0s3WdTU?=
 =?us-ascii?Q?lgXHm44nUAIylbK8rhqL93TmNEqiju1Ituoeho3P3gzND8ck5T4JEekEE8/A?=
 =?us-ascii?Q?tvim6xdwvxaEQHFEiQltqZ5ZC7ANeoqSZVSnt79i0vAQamncNb/BYvLHE8fl?=
 =?us-ascii?Q?kE6ZbGeDTDobmJZVfFK2irfkQGzUVLhfxvBQt1w1dt0p9SUZJTNbs1KLWzlb?=
 =?us-ascii?Q?dgFjYO6NxkAzmmQO8iboAPprtmvmJV4lgRqKVe8y1nQgVtotJoY268kOpa34?=
 =?us-ascii?Q?JH0jf/1tXt6v1tLcL3bpqtDB6TCX3ZEGFOxhqdk6K4WQnB412/2n+K6YTXIJ?=
 =?us-ascii?Q?XJuU+O9tTCn2tmO7HiiBqUoyhpT0aJbRCKt96XscYims2JGX1PZCrO2vmz+E?=
 =?us-ascii?Q?OJM8WoJEBKnbUwZmQWCPl1cNNWBZKVOyZD+FbAMj/vGz91xHdFb9ICDM+95f?=
 =?us-ascii?Q?SGRUvM/BbGBXmuaWqN6QRt1Ks+sV4m2C2ljK1rmJFwB5nqhVffMUNLZib4Ev?=
 =?us-ascii?Q?V//yUvEptMbhisj8qGCWp34AlPkS4f6V0IIb9rvvNdwYkm3oBUZwdtjyFIpA?=
 =?us-ascii?Q?ED2zdRgvbbVZLplZL1zgYuhcoGiLTCNTYhaO7rI/7fkm3qc1zcpBOWWnlM8F?=
 =?us-ascii?Q?37bUKUoS/kJTnx93mUTvYHognYYMflnWdMLFXlt+Boc/GmdJBFmjZPkRhmwF?=
 =?us-ascii?Q?T6YnDtKzxdDI65KzqsS7Ama7QclcYRggtOrmxPAI1kAMqi0K6BvpGtecMlR8?=
 =?us-ascii?Q?0jLmZoRdkdag67+bqydKfA/5OiNKfK66e4M1Ipo0Vve05icLRwhQIoF8csj8?=
 =?us-ascii?Q?HimoB+uYNiLZx961UvFwyoQEYkmsJEO9aLS8KL1aaVdvZ0qof7uls1KhUVBC?=
 =?us-ascii?Q?iKRa+Viu2lLHg2otQGjKeq43W+i7uz/tQY6FBeeiBrQH7Rgk0bCGELw0KIvo?=
 =?us-ascii?Q?67SFVUzR/pJM1vmGmsCT35DWgHVUSJZkO/W31i6NTwyidW7F4daHuiPCjIUO?=
 =?us-ascii?Q?EScolQkVgsBcggjebwKVrdtZPgHkkvXNDI4gO7IbRzjvBl9SEhepfNeitKoy?=
 =?us-ascii?Q?wF1pbZS2QxiZNOwrHj7yDbGO5K9iCrQcCUhZH+8fHd4RNByGGxszIzUlc4J2?=
 =?us-ascii?Q?gEulUZc0bK7U6KSmBku7UWzjHx7ocrpJagGHs56VkAsygyQN/cg6uHtELBPx?=
 =?us-ascii?Q?BB7XVHojRDgBnyVOjl9RR7DYmnjKz+g1qesbv9CpXbsE0C/6zVpP/c3sNgZb?=
 =?us-ascii?Q?SvobEBdxHJd7PQZnDkVaYTxQXvcHOVA7PBxnAp9wJV+AT/aUbuWSKfC9FSpt?=
 =?us-ascii?Q?HgJuXy43IVZ7+eEZCCZNeBtksFVfACiFTCo0yUvSV85T53K/tkBfV6cSHezf?=
 =?us-ascii?Q?cw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee0bb462-0032-471f-a3f1-08d9d6c3365e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 18:33:36.7680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Uio1tGvXdH6Gf23tK8kNfTzChtA5x0Nm7GbpyOZHXa+hR4WSF5jjQmCRXXHu5d+QQUQezFTpCxFb1GgsZtHxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5006
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Christophe JAILLET
> Sent: Sunday, January 9, 2022 10:45 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org; kernel-janitors@vger.kernel.org; linux-
> kernel@vger.kernel.org; Christophe JAILLET
> <christophe.jaillet@wanadoo.fr>; intel-wired-lan@lists.osuosl.org; Christ=
oph
> Hellwig <hch@lst.de>
> Subject: [Intel-wired-lan] [PATCH] i40e: Remove useless DMA-32 fallback
> configuration
>=20
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
>=20
> So, if dma_set_mask_and_coherent() succeeds, 'pci_using_dac' is known to
> be 1.
>=20
> Simplify code and remove some dead code accordingly.
>=20
> [1]: https://lkml.org/lkml/2021/6/7/398
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 22 +++++++---------------
>  1 file changed, 7 insertions(+), 15 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
