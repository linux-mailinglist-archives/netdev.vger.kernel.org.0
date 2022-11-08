Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD01621E0E
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiKHUw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiKHUw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:52:26 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4609F5656A
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 12:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667940745; x=1699476745;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r4auoxpl1bAErPKyUuYb14RSEoGHT2kafqDtOPlFHJQ=;
  b=Xl7/mR2CJ50WQx8d/oTIsUzI6nl6MHdA6LsXFnge0zxLupL8bIV7Ib1t
   BSNGHIpI1SHRydOaODZGnu3MVBL0ETlAm1V/evyY7WuCFI6a6jIaZjhkd
   Uu90p0g+x1O/r+lA1pomMRdCOmvyg/2+oIQhNZxfhixGyLNDI9U0L1AzQ
   n2ZwUhIzeb7+XUoV70PvBRZm+LBTqmLVoSyN4MaW00wMA5mdJieJDWUZ1
   Ol7Z9wp2HSRWkFcbpYExoQ3Vfp8babkbtZxi6YGC/ThRJquxMFrL6Sw7a
   Dec3jUHPpbCk1v2/TX1jhHJz2f3lY3yo4FufILWYbdFkkj3TaF8IXF/iJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="375080058"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="375080058"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 12:52:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="587511904"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="587511904"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 08 Nov 2022 12:52:22 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 12:52:18 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 12:52:18 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 12:52:18 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 12:52:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LqabG2LMKIikwvZh7miw++H9TFEHJg64oEXFfloUnOFe0rKGZWMG7DpHXffbkhYJrd6cyi5AYtS2tSxbOt4ZrMvLAJPjwGIYc11aQlRvnaWyCuct6l9sp6rPHOVSa460IXSR16eGvTxyzIfDx1F8gWxzlBL6+g0C7lsHBudrMH+E8K/bXvtL/ZkYnS0XkRKlSuLn8aUAM+t0OQXZSuuvV4zvDq49uPqlCOjnM0jrtajr5AEULcWKj+hqDWy9xe55J21es53VaTkf/UHbSt8a0+imHzztmhbWOSwsRpDWUeoSwZd6ojNMwX21a5Fz9uIl197gdNNPdSpFgXzAGFx7Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Csd/u85+Bawdj+74FJ1KxSxr9q1pGdHz8Zeb0Nieef4=;
 b=hS6x+XghcXkzwZDweADhL0jLOhaO4k8AD2a1NFb8PB4ugKpN4USXkwPM/VPsDiSmHtxMd1MukHarubTliUWYievuRrRNCqSB/Jkqo1F8tbk3ejLQ8EnDHcsn1Mfm0Jfmyq4up1W1M4jHLUXO3zjGDMWO5zFW9R2PEIzglEjbEf/Bv80q8AGHYd2SpNKCtMaHI7PtMSBXVks24jqG2afiagXMgi72eC/o8Y+vcNq6RVBl2rUorXvj8NAolSXvQCbD/UEnuHjGZRcwySAqMaNmyTbTPKWn1KjECntYO+CFOTBNDjPtFF3ZUmEFtgcSgQtd3Y0y9XKbK8Y6V6bEj/PGpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY5PR11MB6413.namprd11.prod.outlook.com (2603:10b6:930:37::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 20:52:15 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 20:52:14 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH net-next] genetlink: correctly begin the iteration over
 policies
Thread-Topic: [PATCH net-next] genetlink: correctly begin the iteration over
 policies
Thread-Index: AQHY87KHQiBbQkEqgkeNWeW7OzV0ja41fiIAgAABYpA=
Date:   Tue, 8 Nov 2022 20:52:14 +0000
Message-ID: <CO1PR11MB50899EFCE56CC904D9742D52D63F9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221108204128.330287-1-kuba@kernel.org>
 <20221108124332.4759847d@kernel.org>
In-Reply-To: <20221108124332.4759847d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|CY5PR11MB6413:EE_
x-ms-office365-filtering-correlation-id: 36812ca6-53e6-4f13-dcff-08dac1cb1d70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UncXZIyDFlJRfraWE3cXJh0JEHBmb9dQSarN/t/ZNLa3ENMoNAFyILYO3CQ62Sz//vDjJUGgFZGcn2GLtHcKKDM0qMUcdwAixRLUFyr7aRShZisAV47/MFcTMVxty3SMbl1MrP0Hb39BXdVTreUBy8NfshZqtLu9dTAvUWSj7iMKOql9Rmxub/8zSKODc23sB+zL0fdeD2WOHmGauvE033f/kB2ahFA4QSQ1m2lyHlp2omW/KIlWa+3wXyZBGLzPFiUs7LthRGcej3VGW2GbbFUkn8RUgUdkNjft5zWGbhepxqtxrZtb9XatHW9cTxmnO7l8nJA5hB+OIWdYt8Ui6uIHPhLTyT2rl6QPjkASS0Wz8W540qsc45/g/Z4HYI+GIYAtfldCw+tOHdYP259d1FsUNVaEceP2WghicliRtAN7B3jfkN17U5URVEb683OPcJySbHOBb+RykK59AyQFF7j0YlojQkdT4rmn3aQl4Fys8ZQYSmESn6a8acC7rxvQ+f0+DW7bl1gNIw0lddYy7+7K64vVxtw07O4SohfbB26LMShdozQFlf8Gmb6n7TCSsOF6H2hjgEca8fBMRAwtbPQa4wWySgQmsLOaOT5o3UqXI/WJ1w/ONgh/U677tHm4s+O3JynIgQtieaoQ12HzUQRs9bBf4qhuIt+jIqhldYIHbMbMoBne3ApV175RV6vIc1065z4x98N65UXUr7XZvIPWEx/MSy/VDcjUjLLaqymyE2SAsI6mbGi5tRVAjX78FyW5V6GVx5YLoafs24Sn2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199015)(83380400001)(71200400001)(38070700005)(478600001)(122000001)(82960400001)(316002)(54906003)(5660300002)(110136005)(55016003)(2906002)(7696005)(66476007)(6506007)(53546011)(4326008)(66446008)(66556008)(76116006)(64756008)(8676002)(66946007)(38100700002)(41300700001)(52536014)(8936002)(86362001)(9686003)(26005)(4744005)(186003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1YMNqv2JMF+jcx3G9Z0wf+wSl65CjDfTmPkfJIj2aG+ADnrxzxCk/YvQHytG?=
 =?us-ascii?Q?d0DpFAlNd4okBz4O1etagkjoHBHC/EFHPNLmex2VEqvbkCJBqhgvjM3EN9cE?=
 =?us-ascii?Q?zqHGnAxBMfG4Bv/SXRKaHtuP2IWAXBZhfs7svj58+Wr8q+9Lf3hnNRuc9fN8?=
 =?us-ascii?Q?U30h9Ehf9eo7GSIA8fksFkrtJ1LUB4eKZP0u2DXqwLzYd0GaFUjV3pRfubcm?=
 =?us-ascii?Q?8tHdDDbUqxOHHKhj4bTYWRHrtz7T7n5iWub/ELkxS3iZaY+sE0M4j/IUUM4/?=
 =?us-ascii?Q?5mw27M+FIlWSKkXTQipTvt5dIlD5tubvbUe2Ew8wL1BmJCxVD8QtCbLORqep?=
 =?us-ascii?Q?c1ujsponnttWgkushNS+D22mYTvsynZemUD3lln4cmPp3bpcXZTkvN5bGYJO?=
 =?us-ascii?Q?Xe/zh2zDuCSkWTXM1se2zlTftGnaYtsBMlLQbaqgzRn8/ta4nj9Jl2G5JoZn?=
 =?us-ascii?Q?RFfPvV/IfscTBRH+QkbH3AsSnSmlzc6KqYFYdFueQT4z7kHP1U9FuwSeb1R7?=
 =?us-ascii?Q?l8IGaG4+2hujr1E+i6sLGUIKXR/hquoosx/bMWvpDBqZDnlGE2lk6y3uzSgQ?=
 =?us-ascii?Q?ODW6CE1RimTmCMgSpz+C7CturgTsDFkO1p0jwtOcBWzgmkIlIxwVmvfWIKxv?=
 =?us-ascii?Q?s0Qu1JpsB4bQ5iiBxSfSsWzHDWI/RcpPgoH83NYbsGFyH1uIc8Z1/ILQQqvt?=
 =?us-ascii?Q?df71K2AfVBGgzuE9bfDF4VkADnJ+QvSytDSpcKaaEkVufTv755onJBU1/tDH?=
 =?us-ascii?Q?HcFL5mXZUQVfBNIQE+9sL4JkN8SMJQHDwZdin1+SutIbuIb2/S3bC0Z0ap4Q?=
 =?us-ascii?Q?SAWNzMdBo8vJCqA20E7urWSauyMZCam/QVU/SrwMXthZli+qRRJ0Zmt0fjJ6?=
 =?us-ascii?Q?dvvfX03yUB3YiyVmjMWU3d5aXb7v6mswV2pM1umFbOuAPyDGANTekJxDLmcz?=
 =?us-ascii?Q?zwjxEDmaYomoebw8O1BnkkGktxT57YsGmSJlVMfq37gDcyAIs+09pcoJjbJq?=
 =?us-ascii?Q?qYy4KzwyRzDLzXwS919BqPmw8O08WXu4QaYNegOaXZo107M8gg7KpRXFAvrX?=
 =?us-ascii?Q?3LmbyGq/6kFM9um6cB1GFho1iT4PGz1FknYmB/mR39/1i6o7JvvtNaYeEnFc?=
 =?us-ascii?Q?f8Js/5tdElech7SldcgbpKwXRFtZTPby4BQ29s3VsSL70fimuRwdn2HLq2nv?=
 =?us-ascii?Q?CACUJrUgtv+j35b2hOQtZ2/Pd9TfkWWNvhCeuZQDQ2JavaBz4Lq3zKXxWkDq?=
 =?us-ascii?Q?Fv0vlCEzo0UiOm69fS+UvZhkPqJMRHqYr2vy2k2ZZy8r69RcnXMxQW50YMlb?=
 =?us-ascii?Q?CINL8VdL9irmxtEaUms8obVxaZL+wnOYDRsuYA/ibhvTzOYG7dPrdGf7hOex?=
 =?us-ascii?Q?OONrUyQhM1JTkYHjivd8xIImpTIhhVq/1aOBlb6ylL/CxVDnYr6taMQzhEG0?=
 =?us-ascii?Q?BwQFtg36tf/NHTywpaMZbDxQQCB0ujie44uBCeiv/iLzWD6SzxxgcHmXElbX?=
 =?us-ascii?Q?lCZPX4WKBfX+WwFWxKVAUGXLIhFvAiU5qrv1cQptbeTugP8qxpxi3VSlv2TX?=
 =?us-ascii?Q?iZqvX6nRx3FaWFGa57kU7TTq1GmD6k9LP7yzoarv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36812ca6-53e6-4f13-dcff-08dac1cb1d70
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 20:52:14.2335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H56DJPq+lleWvg1iYVGxpcm7zUBipsbBYzo4jAFUFtgcNsTWjQ95HIeWABejiXaTah5UFZlDhxkxNdKHgigtOY9mjZgRJszKDCvKh76Xj2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6413
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, November 8, 2022 12:44 PM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; edumazet@google.com; pabeni@redhat.com;
> Keller, Jacob E <jacob.e.keller@intel.com>
> Subject: Re: [PATCH net-next] genetlink: correctly begin the iteration ov=
er policies
>=20
> On Tue,  8 Nov 2022 12:41:28 -0800 Jakub Kicinski wrote:
> > Why KASAN doesn't catch the use of uninit memory here is a mystery :S
>=20
> Ah, because it's not KMSAN.

Yea, because KASAN mainly focuses on use-after-free and allocated buffer ov=
erruns, while KMSAN focuses on uninitialized memory. It looks like KMSAN is=
n't yet upstream.

Thanks,
Jake
