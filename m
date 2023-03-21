Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328706C2E85
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 11:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjCUKRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 06:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjCUKRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 06:17:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084073BC56;
        Tue, 21 Mar 2023 03:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679393870; x=1710929870;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=efKHI3LFTzbuTRJAfkDfNSSgUGrmGyg/sQSjgGenlUE=;
  b=PqP0PVMkcAGyZ0K9+yjx519QbtbhUEpyN0XXD3hri0dMaojEWSObQC5r
   3F2sgkyLMKoro/+Sn/1XgYOjGO5jT1mIYIhL21aVL7hmVaOQ89MQxRkw3
   XsKOG31xoXyw12aQxp1ybBeVomWq1ByEEbRnqLvIh9aJYlZ7XlsaCp6ns
   Io3ucir0Qv1JNUpe9DhIjvZ168kAussSXQlOVAG9sRZ84RlVNaYaBGPo6
   V/dM0Esec6spRL+CbEQOY8ewOb9T16pgKroroDnah7mLQya6sfv7QHITT
   7N0s+1m+knTBV0oXKbGWwC0nEq71qtyIFOPVDioWlEYib68WsHFfOhGvB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="336408460"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="336408460"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 03:17:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="681439637"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="681439637"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 21 Mar 2023 03:17:50 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 03:17:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 03:17:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 03:17:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIJABRLAEgxOjxORTBp8C+sJ7oHKkPt5Q++Fs7eV0WMnw00ghB8BChEKlKsv4ft8dq2mak7naMqxu4s+b7diVMJ2MdDkjBkL7UDQI4dc7P6b7rVqIvv3QTSziVit+sYI/wdphRn9X03z0SPRt6e+1qdOAcnDzk6Xr/q4h6FWRvsS/2+OLn/mG+pcDOixT3FzKyLKJDC+yZRWARqLxrR5eBJi+XAjAji+re10koatsFSbWqrjDrAEwfLA8nRUV+nBOFOBRfhoRbTu4An7nEVasSUwcBwIn9g2F//G4lFPYO6DmlYBT6ju64fTMS6MnczA83jXjHC8pbc/xKBC+1I14g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lnrn/zwj9uTv99tIamC2ebwOsCY8RaziCnfmAOPnCZI=;
 b=U1ubypSHYA1RunRj5uiaaRE27fNCzDgQLKGiZ1tXWqxZFR4f6ZBJ7+0EQEzQVspepwKdwnXubz21ow8A8pmAOqEftBcdXTu1dJ0+mHUEUQ6q8sMLihzKfaxdxv8NOis2oY220lzYijNgmRGICmiVVdICh72v9KzH7RgXFI0RaZPV51leBrHsr2zI2GEIvgMPpUlhXtdd7WGXrgiQr+oTH7TMjn+tsLTsuYy54rVwIfIsbzokqyRGZdT7wmwgb0Qf8jBJgqQQR7xAVB2S135MC4Ugxfa5dFDIX0nYS33X/tmtSZrTzhuP19lmdFGM3T4Vo8G5jF6hcHY6qGmhaleS2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7587.namprd11.prod.outlook.com (2603:10b6:510:26d::17)
 by BN9PR11MB5259.namprd11.prod.outlook.com (2603:10b6:408:134::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 10:17:47 +0000
Received: from PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::a9d7:2083:ea9f:7b0c]) by PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::a9d7:2083:ea9f:7b0c%8]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 10:17:47 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Lai, Peter Jun Ann" <peter.jun.ann.lai@intel.com>
Subject: RE: [PATCH net v2 2/2] net: stmmac: move fixed-link support fixup
 code
Thread-Topic: [PATCH net v2 2/2] net: stmmac: move fixed-link support fixup
 code
Thread-Index: AQHZWQtu+ICkP7bLzEy6mFAy7d+uRK8E7slg
Date:   Tue, 21 Mar 2023 10:17:46 +0000
Message-ID: <PH0PR11MB75877482FC5A666FC795F0179D819@PH0PR11MB7587.namprd11.prod.outlook.com>
References: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
 <20230314070208.3703963-3-michael.wei.hong.sit@intel.com>
 <166f45dc-c27e-41fd-aa82-bad696f32184@lunn.ch>
In-Reply-To: <166f45dc-c27e-41fd-aa82-bad696f32184@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7587:EE_|BN9PR11MB5259:EE_
x-ms-office365-filtering-correlation-id: 4c785fc6-4d8b-4015-92c9-08db29f58471
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SvVzVQXcYVg4NTdww7diRU+MsGG6NiFJQPtdrKXcLUuLi2EDwLbaHI7U+UZKTZzJXXcMJ/jfCFhCNThRKeGrpY+wn0WZtir1u+Q87VZ/B//Xf8ahUspIYtq/cDwPGu+6M8Xu0EuFzTeYSY0AKLVUWpPTUimAg8fM5SvyIEMTNQGmHQ0ZUHiT7r/RDNEQP6dV6VVlbaJtxSwQt9a9NVwkQBGvQr9h2sTVfqXQElFmzshbedjcUgtenowl74z/GTrJVM1miqYl1du4PUK1nJN+ZkoWSxCHXlpl1UmI1NrbOjQBYkvOms/GjEhd7MmvQHVmFQFrbhkd4V6q94FfNe/pyULUcOtvoYXDKIwN8B6dpbqpDergHLb5UpJaI8zHJL7M6Qqv+ejx+8ie4l+A88utNfwH7rVCdZIL2knogCjQk+hS7oqIUNr2u9wR2PCqEpQwL/sVlnqWkm5WHQSSlBt7h76bmIsepPx2XKOcsnWaj+Df2LkLPjqPD7AyzgVwt+V4HvHC5Pie8hNpe3r/0uS2gNtWY52vawgQ3N923Vl4M4ZVdFJfuQFTq2k2aQwLRloH1d30zDt1bC/oR+jyh5i+aTlYTHQRla7njicLWJuBsBnAmf8on1dKV3AAtLwpsLL2LWIpXxi8ZkF1dP4J8Xw/K6daJIB5VpipiUA374olGEwbJKCRQpDzvET9velB9GJIsd7q+Ca4Tsh2T/tdjI0bqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199018)(83380400001)(38100700002)(86362001)(122000001)(316002)(38070700005)(55016003)(6916009)(82960400001)(66556008)(66446008)(4326008)(66476007)(64756008)(41300700001)(66946007)(8676002)(2906002)(52536014)(76116006)(8936002)(186003)(6506007)(53546011)(33656002)(478600001)(71200400001)(54906003)(7696005)(107886003)(26005)(5660300002)(7416002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/8uvKwrHOJMF+aqBMxr93Xb3DdAsPGPBmZeIO3MHa9HGBcGQblK1qZ5bUUau?=
 =?us-ascii?Q?7EvEjz3dNURFCcuUaiMLeW9GggOn4U8EblPaGMcOmDgtxynl7etmitHNYjcx?=
 =?us-ascii?Q?chTKWXNv4BTgOROFYdu6kRXOxwSplu2q+hI/5a1NLZiH/bILZlXP+WkrbzAU?=
 =?us-ascii?Q?i7n+2LCBuCyEjCpjnCjFT9DIM5Ii9wehfORjebLKHG/yOFd66MEBYg83mj3w?=
 =?us-ascii?Q?KfffPdsYZEq5x45USINZVO16EvmOaIRdG8w87MT0ibCmIgsxxR0L3u1cFXEB?=
 =?us-ascii?Q?KFDJYTMjUhrpVqm9dj1rI1W1OwY+4fLgwzVJwQ7is+mF8NYKvenZYFgt4c3I?=
 =?us-ascii?Q?SRjcaIczMaQhLEywImZSMbBk++RK0H34zYzPfHOx8zL+MlJQSWIHKGTcCjIE?=
 =?us-ascii?Q?Un0A/cvuxrmL9skrpnjtWAKcgBg2fXaFL+PPcGKhvbdhB+fVhnkR482Pi5GC?=
 =?us-ascii?Q?59Gv1zHEPvHzskhzw772YVUhsC52kU7s53rfFETDoXTxj6DawW78Y+qHWdam?=
 =?us-ascii?Q?6a981w3s36RUJpKZ0u1bf9dtNLngWggMpNKUvFzBvqIsBuGnb1OsZcWim685?=
 =?us-ascii?Q?A6q0kR+RBA5Z5DJUU8ERXgf1xbJim+H5wvvZCBE27xWhnTeQeAId5fiU3hXM?=
 =?us-ascii?Q?aiox0BQo35cV+61I+0eF6vI1F1T2AOAIna/mKAKMDLdEZ8Gjhq67OO8kSq3r?=
 =?us-ascii?Q?ZSvZIJxkgtBiGKWQ+qaJTuTQ6SYzwboNX6VjqGF4aaWgCC1R4EOcle1cq7+F?=
 =?us-ascii?Q?abneuHA6ISBfjXm7kZtIWzV0Lp+EFehpYxcgm2IXJR1c+O+Zfbgn57ZRcBwd?=
 =?us-ascii?Q?SLlNs2Bm1mJfUcAypjZ3eM0Jn3xukIqztx7D/Th+v1uxm8KGVnnRW5rT4LN8?=
 =?us-ascii?Q?mYITGnbxxMSICXMqBs6W3011INXWlr1nS+YTOiOnrwRVd2lNXyd/6uKQDoPV?=
 =?us-ascii?Q?BGlbslQv2TUbVeRq1hy07nvzFvsGZOujJs80nZog5miT5CWEO0pqDv5w9jIJ?=
 =?us-ascii?Q?mh8PgsgtyeerrJp49uoJe2TRg3UijWQoZIS1ggJVOB3OU0cPDiZF5Xk5o9jO?=
 =?us-ascii?Q?6f1HGyfR510dY6IGRX4Gefw1EJBK6RAMjYKbbBPAmLZ28Ink46plPuquhdi7?=
 =?us-ascii?Q?aNd3t/cXJElpEkjMd+Nj01dDsfAKH1EFi8d2ltNSkk25ggH4ecsLeUH8NdHQ?=
 =?us-ascii?Q?6Om4el9KmVD8pX0x/zHeuU7/JvJLVi7HqrnDFgfc20G5pQ4zrtPus1X+zdH/?=
 =?us-ascii?Q?sbJ50ZMFRfPcQ37BDMdOMPyGxrFj//EHuAC0DRqfuDL8nXrORDlBHgUKdYla?=
 =?us-ascii?Q?jRR+/MWbtNMpkM71LUFGhH2DPqhtVz73oDr8055yM+L3xAK07pF+oA13Zhl6?=
 =?us-ascii?Q?5ujpofhwcTlQan9dZ/2U3H12HTq8GtlsWaagDuMNJ2kAdZVjFVnr0ZkVSUNt?=
 =?us-ascii?Q?p81eXwZ11v3gRbd3pxdRNYE4xrAH7/FdxQwbxrlR/Y6D43IZ89kUTs1VhyrA?=
 =?us-ascii?Q?MMVk+U3mVPtrsxNNfMP7yehT5sRGVv7KtDMMV9S3cBmMT8XQH+dSQsZp5HYV?=
 =?us-ascii?Q?/ErUalPOkscRVdZ85vH4LdrZNzVgevTWMeW4NLG2bx5oTcoJLwEEYBm/T50C?=
 =?us-ascii?Q?Fg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c785fc6-4d8b-4015-92c9-08db29f58471
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 10:17:46.8662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QEhBIzgxa7K0ij8zDNMWzMT9xe1hZaCoTHgcfpXgmr3lF2Suo3pTSMw21cjgHAMLfWNMNHwnB6MIzulRHhC9kiTQucSJM0smbkJlGC4kw8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5259
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Saturday, March 18, 2023 4:03 AM
> To: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre
> Torgue <alexandre.torgue@foss.st.com>; Jose Abreu
> <joabreu@synopsys.com>; David S . Miller
> <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Maxime Coquelin
> <mcoquelin.stm32@gmail.com>; Ong, Boon Leong
> <boon.leong.ong@intel.com>; netdev@vger.kernel.org; linux-
> stm32@st-md-mailman.stormreply.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Looi,
> Hong Aun <hong.aun.looi@intel.com>; Voon, Weifeng
> <weifeng.voon@intel.com>; Lai, Peter Jun Ann
> <peter.jun.ann.lai@intel.com>
> Subject: Re: [PATCH net v2 2/2] net: stmmac: move fixed-link
> support fixup code
>=20
> On Tue, Mar 14, 2023 at 03:02:08PM +0800, Michael Sit Wei Hong
> wrote:
> > xpcs_an_inband value is updated in the speed_mode_2500
> function which
> > turns on the xpcs_an_inband mode.
> >
> > Moving the fixed-link fixup code to right before phylink setup
> to
> > ensure no more fixup will affect the fixed-link mode
> configurations.
>=20
> Please could you explain why this is correct, when you could
> simple not set priv->plat->mdio_bus_data->xpcs_an_inband =3D
> true; in intel_speed_mode_2500()?
>=20
> This all seems like hacks, rather than a clean design.
>=20
>      Andrew
Makes sense, will test out with your suggestion and submit
the changes in next version, will feedback if there is any
findings.
