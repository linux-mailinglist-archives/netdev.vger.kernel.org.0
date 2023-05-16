Return-Path: <netdev+bounces-2927-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 512E3704913
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:23:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 516681C20D7A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70A08156F7;
	Tue, 16 May 2023 09:23:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B43D168A4
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:23:41 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F8330FE;
	Tue, 16 May 2023 02:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684229002; x=1715765002;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RD7XxEVLQtturu/Xh4oIUqYTX5QhuLOzq4taDLbkSwg=;
  b=DY+lsjpMte8+to1auDyvhWa41R2SG9CNnfeT6oNZUZsnx6GBwZrAku7E
   mpoZnxtmz9S+k+pXcsPZclCuwu0tRbPHhltIZAKXrejqhZPHHamW0Nwn4
   BEwbQRi2JwW5sPuYKAX9Lh9ZmsZwzepIcjjpKE7BHDZ1wZ1UaUBmWZ67m
   i1/yeZbNmL6UZreYwATdaqZ7B41HAIhXJSPqkGMHGLSqkJ7AuV9hrMH6U
   JQQOwV0AzVSpTNsR5eOU4Ld0glVy8B62RtfQuyt/9EE2jKId7FeDP2i3B
   jr+yvlEeOkCbF7hqjR6P41p+sjEcLJfiYDU33m8sYPTnPtRpcHG1BLvZQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="414836483"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="414836483"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 02:22:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="701276089"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="701276089"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 16 May 2023 02:22:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 02:22:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 02:22:45 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 02:22:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7eig22aLL2tSEOZGucGFu2Vi7JkIK2pcw8SFsiHv5ia3NnGljb04gDgqPASs5zm8tGUNhdCFHFPFJmNTnfA+ui0bsQtbIGrQN4Vvna/OM4AMFETDgE/3LRGGIsDQZfmDIg/YtQoUv/vlIbGygDahsf9ZAFa+Lrwpvq3DOmtq+DGcXwigvo+LGByK2MLBt0na7htEcVUj+jTyXPchv48X0Kqqt98W785zOaKS+0zkGD/q5PDm/+ikZrBWTmEUxQXRe+A40oqFsj7bnbMnBmXLm6qjvnu/odMZV/Xbau/l9bm9f6s9HoswS/C/lLXwqwx06CmSN2SnJ033Eb4vsfetA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzuvR9CvCpJX0P25Rdpnw9lc+/ydOpY6AEG4j5Q9ln8=;
 b=Cdj/vdv+4vsdTjNoTwAQX24EGauETNR89aOMyxgi4VUbRO0tf0eWrRAVELnhb0LSOf78Sg2yu7C2ldR/AyINkWJul+V/fMl5uJpGyGxXIaYcNqpMnoG9MW8XwKVkTtaDwNIe41OY2RobzPBL/vk834w5wxIOnXAz5y1Qhmkx8o7UX4ZYOTjU+NSY27IU/Wa6yEQYWlgtH5flFxiCfQKW48YYqKdjhlk10Xb7j5RE4abt9UiCAIOH6dBB99GLu0o8GuAaValNLm19yl5iv8Uu4vZ30rFp0ZZ6SQ/5U4vX3TzsYCMi1cMMj/c8ZMufniD3gJDVJflUvXkK+gY6QlrJfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SJ2PR11MB7576.namprd11.prod.outlook.com (2603:10b6:a03:4c9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.28; Tue, 16 May
 2023 09:22:38 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%5]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 09:22:38 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC: Jakub Kicinski <kuba@kernel.org>, Jonathan Lemon
	<jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, "Olech, Milena"
	<milena.olech@intel.com>, "Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Thread-Topic: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Thread-Index: AQHZeWdQDnOnlwLdVUynBqrraL/3s69brg0AgAEOquA=
Date: Tue, 16 May 2023 09:22:37 +0000
Message-ID: <DM6PR11MB46570013B31FCCF1FCE0854D9B799@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-6-vadfed@meta.com> <ZGJn/tKjzxNYcNKU@nanopsycho>
In-Reply-To: <ZGJn/tKjzxNYcNKU@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SJ2PR11MB7576:EE_
x-ms-office365-filtering-correlation-id: 5379cb34-bc37-4c7c-1a75-08db55ef1761
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p/23O4VMcNOQD0F6ni8PRN8jSUJCYb9YmjjideiI+SsVs9IZ7huzcNax7e7oHGeGz8vB/wqjGH7e4ut0eTOlh7KsKEx+FaIWFMuIRWApfQUHPF1nLtkdvE2YTduYW84rV18rLpONB09yQbHDZT/e+23towLkqFz+rDeTj1mhNAwHeW1+mGm2CYuKV5HDNfq4D7XybB89j+cWYtXHg2y3DTAA1Zhc02riJax/knQnC/CKVIDvbWAiBWzLYjN9lpWauWqGpdydfy6Fh14Xcsq116P81UOxw9rq+k40OxZFGulKzkbwPZXpOW/xpDCMIDbHAcC2bplUpkye7BS2C2xoAL4156f/Ovfn35NxIdMaduGwdI7WrXeF8FRp+JuBxG/t4dHFtD57PwevX1Oqb9G1BPvnuGhHD1r4rxCojJ5WgqfzCo6TpJAPHT6XllJXEIvWY55YlM3g19XHpmHa2G7nNCQoXUvnrthzGbbTGfbW7lgKRLpRhkoJk0PnKVf5U6bXOJWiNdfkObOMkLr6+9Fh4xengDBfVNWf7Hsc6y3wGtNFvbCAxEahQMtYcws2uo0uVIhMuUpraIGtd0vSwFXaD341ZqDhTsr21xNt6O0fPG8kf+t4rcNncaKmD0BzdAVv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199021)(41300700001)(71200400001)(54906003)(4326008)(7696005)(316002)(8676002)(55016003)(8936002)(7416002)(5660300002)(52536014)(110136005)(76116006)(64756008)(66946007)(66446008)(66476007)(66556008)(478600001)(9686003)(6506007)(26005)(2906002)(4744005)(186003)(83380400001)(82960400001)(33656002)(86362001)(38100700002)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oCYqg1wRt5XA8JtJ0Cp1rzvcC0BtWjkfnYbVyJG+lWlG08AW3X9rW0/7sCFL?=
 =?us-ascii?Q?BD1vokQqc55lgv1BwiE5SOpBpWGlCGIvQZfH3xrX/VzDbCkzXYQJWKF6IjYF?=
 =?us-ascii?Q?ywVR/qPDA6q/+GlFTtANZe8bMXMUhOgOlM36DowIc2Yb8DrY1j3YWpMtLjzr?=
 =?us-ascii?Q?1FkTBF4H9uAfmPenW4pyfCU70P95L3xVeHteyn6wQgIhHowWwZri+idSihzY?=
 =?us-ascii?Q?4z+YnmONGVTuRGn2iVdJK3Z0spSEUs9VjvQuu8NQ74Z3F6rPFTEb9hwYSHjM?=
 =?us-ascii?Q?/DYz1msR3P/RVndniUjBnTcqVPfHMatJ6JQBQ0q5osW9m7U81/CXJ/pwgRXS?=
 =?us-ascii?Q?JJNv53p4I8dejX9RZuX2FOH9JmOJmcJUCu85nw9LFnb+JtRr4XkrQ++HAHtz?=
 =?us-ascii?Q?nxwJBJP21e2IWPd/tkyKae3vUmZ0v1MVKYdoLkL8J5MgMSc16n1BC4QIV1EG?=
 =?us-ascii?Q?A8rW5xw+NAOlMPgT11g+ss91y4DvoOnHO4/lrmSWs7laa36lSsBySVFeArBN?=
 =?us-ascii?Q?6MUd6s7z+YLYfe2QyMLqAE9eCjE2dlYbsce75jxg/Fy7Zob53XMDqlc2L4es?=
 =?us-ascii?Q?PD9HPyz/yQ29ayBJyatj71psNaPeu7mWG9Gucj8lKNLmj4++TL3WNajTvlzW?=
 =?us-ascii?Q?g6V/lqFDPio7gUlarsLNQsq1cUqK7lmlA33cCSPBWIXF42iRIaHiBGA1akKo?=
 =?us-ascii?Q?l970FH2d/ndZ83odnJR3j6SwDkhQO1jMzmUhyUSOdxaF9qe+2xPSpF/tCKbz?=
 =?us-ascii?Q?59pSKSNCfF6FDra1Lkb8AHwLyCH+IY6n4GV4+NCYSdSWfG+MBUqwCtqr+Od1?=
 =?us-ascii?Q?ioG7zugb1UR7FVUQRCtQL1aBPLI605FhISXPIUXUXdTAMO7S1hjpTfM/AbiQ?=
 =?us-ascii?Q?vLKFriCq3GPgKty5GLRFYymNxfBTRUhn8gjCTIjQtgVCykHUl4mPjh1G4BNV?=
 =?us-ascii?Q?bEzc3w63/c9mDZ/VHgjGve0k+tV8DFpz3cKuja9ng7vH0P2uqv1Zugs6mI62?=
 =?us-ascii?Q?oYFMmVG3NgplL75oUWCl5RVd9o+Ayl+sWZDE5Vrho/zgnjitK/N9BGDK9fSG?=
 =?us-ascii?Q?atjEkn7tYNz2XcHkwNzlLg9Eler3tVmq76PJdA8ihEqyiULKRWbfH86wpCQ8?=
 =?us-ascii?Q?ns4lcOM5lwyJN2QJatwy80AzruH2bvctewvOiQ+L9JXtuGnJ3+Pi0fDg2CCz?=
 =?us-ascii?Q?jHExp6bhxywg8ZoGSdhN0OQzT7iELeZjx1a0blcHEnyW7cjmLG4yh1dZgMKa?=
 =?us-ascii?Q?V+uEFI6Dr723bQEwiKO10J7Dmj7aT23jb2WiuxC7Hj9kbeq7RSmNgRe5tA80?=
 =?us-ascii?Q?uv17sKtZPnhpBbfHTJx/okvqdxVXJqDmgs1NrFJ26ZM6EoKcy8kc1e6dHA4S?=
 =?us-ascii?Q?wMFKgXO6xF9SXYjK3WE4giy1nlhWEzYWmrhSOoPhvVXPUZHiBvKbcO+UNRUR?=
 =?us-ascii?Q?8oikd3Cm7bAGSrSoIcwo3kyspPxuwVU49XM9lKPYRi4vXj3GXMidpnr/XebO?=
 =?us-ascii?Q?M6l0L/4DuNt98dUhvGKCIrSXWEescUm4+9FK5aqQ573BaN7cWaiDf4viNyZJ?=
 =?us-ascii?Q?XDLLcn59wnsuOnUM3U9sQjKawR1Ujz7aKgXPHfU3WJsDLyMnj29fxVVWZ40z?=
 =?us-ascii?Q?Ww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5379cb34-bc37-4c7c-1a75-08db55ef1761
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2023 09:22:38.0221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TxVy6ZTggjwxbJAMkUWtA7H7jf4gbZ47q9dOEP4NOtk5zr7JBw4StzDH5FgOhxF1R+0+OdM28xd4pSFDscBsF2IOW7xhnWj2TeAonWnyO8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7576
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Monday, May 15, 2023 7:13 PM
>
>Fri, Apr 28, 2023 at 02:20:06AM CEST, vadfed@meta.com wrote:
>
>[...]
>
>>+static const enum dpll_lock_status
>>+ice_dpll_status[__DPLL_LOCK_STATUS_MAX] =3D {
>>+	[ICE_CGU_STATE_INVALID] =3D DPLL_LOCK_STATUS_UNSPEC,
>>+	[ICE_CGU_STATE_FREERUN] =3D DPLL_LOCK_STATUS_UNLOCKED,
>>+	[ICE_CGU_STATE_LOCKED] =3D DPLL_LOCK_STATUS_CALIBRATING,
>
>This is a bit confusing to me. You are locked, yet you report
>calibrating? Wouldn't it be better to have:
>DPLL_LOCK_STATUS_LOCKED
>DPLL_LOCK_STATUS_LOCKED_HO_ACQ
>
>?
>

Sure makes sense, will add this state.

>
>>+	[ICE_CGU_STATE_LOCKED_HO_ACQ] =3D DPLL_LOCK_STATUS_LOCKED,
>>+	[ICE_CGU_STATE_HOLDOVER] =3D DPLL_LOCK_STATUS_HOLDOVER,
>>+};
>
>[...]

