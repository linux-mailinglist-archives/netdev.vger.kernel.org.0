Return-Path: <netdev+bounces-8673-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31C40725263
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 05:23:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AC131C20C03
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 03:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0D0E654;
	Wed,  7 Jun 2023 03:23:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E37C650
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 03:23:14 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A82B1;
	Tue,  6 Jun 2023 20:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686108192; x=1717644192;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MMITGd2SpZXZiR5p9PtMR2ALHoi/tXoAJVft/NBpL1Y=;
  b=eUcPx596OhEq8y3Qwen3rwW2PiEVcMqDclfcCs28yoW7ibD5jR1gKyQ5
   5Yaj5KNqmK4KO9Jq9N+5A6HvLRIrJdZkKH9uNTjRKOpnglwoi/hBnX2rY
   aXVAoEiPfXa9DTJ/LZONO7n1WOArVQLvRb8aI2Y5RbHTUP1xwvLxUb5EE
   0MuBgKCy/HYryCGYccqbTHi58Dl7u/XsiwulQtHpCd5DZPU2kQyJdXaMY
   h7VtJE+UbzToSEq9b7qFhYs0Q3HFecEiFY/YIqsb+p2x8qsjk1yiSlJP1
   rtISjea/M6GIbW5El47t0HvzLluMVjIQCLLmM9YbTSiIYez6l6nJ09vlv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="346474070"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="346474070"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 20:23:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="799120069"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="799120069"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jun 2023 20:23:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 20:23:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 20:23:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 20:23:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 20:23:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKI4OAU640/KrmxRu3upbessXxfSNGpyykcX0qrYKwbovzr62KZYZsx+tvwJSTblZ4FSSyJS2/JFCTkT0IoVPUBSWgn3ixYhYUb4XKNNQT/99OaBuIbP1ZBxb/FJOgHtSJ9/n/LutMNdGx9lFnJYUkpswmN3ZlwtTPcCVt/MxwmhFHsBo83mYlZx92Jleuc6aGfvWxSTpK/5U0sfGfDMHLbMHcbKxPVRJXiehGsQlrz3psksJDcHQ1W1SWKoafniy+77UjdIhxIbd4zlDhe/UdardppcsqO902CYIb400nTk2luoIuy3wZN6h64gxzdzEYusahBFtKJIL/DcYmLSAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MMITGd2SpZXZiR5p9PtMR2ALHoi/tXoAJVft/NBpL1Y=;
 b=CxE5o2syqjQEYuyp0p99fF606AmXu0miY24zyVwBZEmbj3DOTXOdFlksRFYgVOIFhfGw4umyVN9RhDnlHnhs3+1MSh81mWKfUXoTg5YHXXDxwMtW+/jUSlRvqVGkum1EaDfjFZ8bJHri+nm61n3XMrwwppvEnBz+We0RSIKTM6lQubR3PrwXgFLPCHlKH0hCTj3nVGRI8J+wPBYZKpL4ie4bPNFMXzi8n2zybUr/13rKaskHHFYwO/RY1Wkgyo4lNQjlDplIP4RM1YFoqtfqY94v5kDo1m4zV4hOQB9H1z/IU+WqbLORsxv1sh16kc6URd7XcLyrKy203w9nvaKzrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3122.namprd11.prod.outlook.com (2603:10b6:208:75::32)
 by PH0PR11MB5080.namprd11.prod.outlook.com (2603:10b6:510:3f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 03:23:08 +0000
Received: from BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::9723:863b:334a:b279]) by BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::9723:863b:334a:b279%6]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 03:23:07 +0000
From: "Pucha, HimasekharX Reddy" <himasekharx.reddy.pucha@intel.com>
To: Yuezhen Luan <eggcar.luan@gmail.com>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCHv3 net] igb: Fix extts capture value
 format for 82580/i354/i350
Thread-Topic: [Intel-wired-lan] [PATCHv3 net] igb: Fix extts capture value
 format for 82580/i354/i350
Thread-Index: AQHZlWXKuTcjSmZgKEqKPC14KBkuPK9+s1mA
Date: Wed, 7 Jun 2023 03:23:07 +0000
Message-ID: <BL0PR11MB31227A1BAF9FEADFC6913836BD53A@BL0PR11MB3122.namprd11.prod.outlook.com>
References: <20230602070422.1808-1-eggcar.luan@gmail.com>
In-Reply-To: <20230602070422.1808-1-eggcar.luan@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3122:EE_|PH0PR11MB5080:EE_
x-ms-office365-filtering-correlation-id: c3bed40e-cdf4-44d1-58db-08db6706832d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kN70U/mHS1tBOD7LpHgSJGHkwlX+J5mL/q34iRgFbH3sTI3jaWexoIdzW0Ch56appLEpaQncTxLSKUfhA4Y5Okh6IdUq6XJo+0NFr0Kxv3mykJlOU8zbq76hSG8Au//NM1YfsVtLu5rvFl7mA8gUoNr63p8FciOnhQlzO0F7Lz4H2m4U9F8vi4TUcCE2McdbL0QcAdBg2lGDQm81DrMJanQxw6VfZGoZfyBOVZd820t/xeietM5PyfGGs6mWxF9s7aLqvZxdabkrkNDhQKiBwKtxtYTUMjjo1tD4T0pEU4ODaqEVbr0L3q7Y69NwNjkhr+KWNn7/mMYF1yEmi3Secyowk4pcoEz/8WDdGqk+JntterGIHSD+QbbD+hy5ebToX3ja0R51tUPn5AY3ofkmYwBQP0tCqMj5fqe9syztJOqgEeR477rcjlnE6KHIDuuUBCNybMROj9Iwvav0QBtH44Gg1ECQY0dTkR58bmLTeuE+oVWdVHhaVl92CJs7yrOxjvzESKU3xQuJf0o9tvci4QKwTrnaqTz0rfNcc54liN/qriqy37i9jIT3gRMAZURLASmK+kp9I12UmHLf2fTfC9iJ9BboTuERO3T4N7KmWgGtCShkYIyi8JPbUqBXhYNa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3122.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199021)(55016003)(54906003)(7696005)(110136005)(478600001)(82960400001)(316002)(8676002)(8936002)(41300700001)(66446008)(76116006)(64756008)(38100700002)(66946007)(4326008)(66476007)(122000001)(66556008)(186003)(71200400001)(83380400001)(26005)(6506007)(53546011)(9686003)(86362001)(52536014)(5660300002)(38070700005)(2906002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GxqTLBry/gMtCxbbH3/KUafXII8H5H5eGtXN5ez+0OJDE/hbHu+y6aD84nUt?=
 =?us-ascii?Q?KMAe08BM8qFvvMm4uH3fah8xeIj1h4dnmZm6Fd2mYbXIWNADZwZCvhiRji5n?=
 =?us-ascii?Q?5Y++ABM74R2w02N7jv0Ke3hMSDjt7skA6pfoePN2YcksLh3Apw/LU3ObGOGM?=
 =?us-ascii?Q?h7arg+kK9Q0mcfk3Y0sD37LyXwmYxNK2myb0C5IRSbFYlZojciGUi3aD/r/y?=
 =?us-ascii?Q?/BZfHY2dVHdm26l2mTD3LKBMI3EGbwOcJFzYb2ma5hecAfM1CxZa5lEvRtU7?=
 =?us-ascii?Q?s4rSyP2V5w3QFadbPeJS9D4prJOZNyKFtj5pkhcgMn2UGnH4lAckYyV91keP?=
 =?us-ascii?Q?z+D0uhEbjiZxmxyfyv1moX16szJIOrFeV9mpm7GRqnmLtBG07+0L6cBFKGRN?=
 =?us-ascii?Q?Tmlgyw3VSjJq3kRPZafgLtaAosCpz8mwA0wwC1nQPOB21iNDFVcIGX+VegQe?=
 =?us-ascii?Q?lR4Tmfmgq1dRRuhrhmD7dUOIwNic3pwF+r1HOOGTZFp1mzcYzh8BhtxrM/XX?=
 =?us-ascii?Q?K5ZQkDzQhQL2PpWNumopWvZ2o4lAKw7JoJFadpGORcR5n3kaef8zIzg9dsBI?=
 =?us-ascii?Q?OFt6RFWqvuZTrDVlb7MM2b/oYjqVjQXkLAUd0sWrBj6VcoEf23FfpuGFdk2e?=
 =?us-ascii?Q?PdJBB/dOI4RaepjoaJVQRhwm7SplJ5/u7Qu4jv8eESW3iKFfoen981Gz3vCW?=
 =?us-ascii?Q?4ArUImJsqEBrUVrW/g4WuurDwbtC1lUNFHZv6LtQ6BTkt9dx60X7KHSYvBqU?=
 =?us-ascii?Q?H8IqONljVzkP7/aH8hqzYsGKWdYyyt70Bdk25ECk68LLRqWwVHUBxM71LDoF?=
 =?us-ascii?Q?7kcjGhOpBZb1QpUKegYA+eWrXHX7wFJB5jntIKCyzhgoWBwryRoEF1/KPXHh?=
 =?us-ascii?Q?2y2TyLSeLGZCBZxLJQuCTxR+OYzOt3DSSYISwVGZ0zjaTlea1Y8n2+sDyHnZ?=
 =?us-ascii?Q?eUZxu+IY4PJ04aHACnLlR/ZLko+uGQlCIKRulwl8NjqvytpvPncYtXZFoGWX?=
 =?us-ascii?Q?0ZhFf2MGtXwnup18jL4fe2vpz/pgBgbun4eq82NpPynpF5DLKz78HjbWIvWu?=
 =?us-ascii?Q?LLSvpRUYuId8R6WRn7KT3xzMZ3EAUdiltzxkbV89wd8DsewMGjNEfQGJEvFv?=
 =?us-ascii?Q?DyF0smYbLHl0qitU+poQFGtkoUng8AnJXyNCJ6V3UnmE/yq/RaPBVPqoi75M?=
 =?us-ascii?Q?wtrAjdRdkTHBge1Wnb3lT+B/n9XjrRZlIUXgiVK9sVDzn9mXrNRBV8dfKrLl?=
 =?us-ascii?Q?OinZlHIWUsQv9yCWvSWoT2rWHpiGZQJa0UvuF1CyukUcHOJMXNIOseqbA8BU?=
 =?us-ascii?Q?R4YpKv1N4vuMaPiamhjb5E4WDBaR40kLTFP/Dzh6+66CjS04W4pF4XqbKhcd?=
 =?us-ascii?Q?/02Uv32RjXLG/KGjsvmMh0iAvU9HbrJxzI8CGzSiq1gSaS1Fo7duA3m9TaeS?=
 =?us-ascii?Q?Lnf3ZQFsoeC+vJcIITquTYySMq2B9UK3FS32oKrQDNVoHRhtSJPL4eI2vQz4?=
 =?us-ascii?Q?xRW85yA51KQE03pYKumaVIBbxfGvWip3wo4fpVM42sxtJdidjqRrsvErPJuP?=
 =?us-ascii?Q?AZ8vBbIrlpNtxNw1tvYoqPpS3YYQLIuiLjvTofjlodVz//yQCvQ7vw0H+VS3?=
 =?us-ascii?Q?2g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3122.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3bed40e-cdf4-44d1-58db-08db6706832d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 03:23:07.1083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0u+tPneWk3Sq9/m340jPwL5al5jqgzRmyBwrqt+3pkNyqvds/mUb3dxVdW57oDo5v7XyFFcNTZba/XysxNt1GUjvIFGvqrEIo3dYPKfaiSdCK2gpQ+Wn10hkKSBcIF/X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5080
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Y=
uezhen Luan
> Sent: Friday, June 2, 2023 12:34 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L <an=
thony.l.nguyen@intel.com>; davem@davemloft.net; edumazet@google.com; kuba@k=
ernel.org; pabeni@redhat.com
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; linux-kerne=
l@vger.kernel.org; Yuezhen Luan <eggcar.luan@gmail.com>
> Subject: [Intel-wired-lan] [PATCHv3 net] igb: Fix extts capture value for=
mat for 82580/i354/i350
>
> 82580/i354/i350 features circle-counter-like timestamp registers that are=
 different with newer i210. The EXTTS capture value in AUXTSMPx should be c=
onverted from raw circle counter value to timestamp value in resolution of =
1 nanosec by the driver.
>
> This issue can be reproduced on i350 nics, connecting an 1PPS signal to a=
 SDP pin, and run 'ts2phc' command to read external 1PPS timestamp value. O=
n i210 this works fine, but on i350 the extts is not correctly converted.
>
> The i350/i354/82580's SYSTIM and other timestamp registers are 40bit coun=
ters, presenting time range of 2^40 ns, that means these registers overflow=
s every about 1099s. This causes all these regs can't be > used directly in=
 contrast to the newer i210/i211s.
>
> The igb driver needs to convert these raw register values to valid time s=
tamp format by using kernel timecounter apis for i350s families. Here the i=
gb_extts() just forgot to do the convert.
>
> Fixes: 38970eac41db ("igb: support EXTTS on 82580/i354/i350")
> Signed-off-by: Yuezhen Luan <eggcar.luan@gmail.com>
> ---
> V2 -> V3: Add 'Fixes' tag, and add 'net' tag in patch title
> V1 -> V2: Fix typo in the source code, and add detailed explanation
>
> drivers/net/ethernet/intel/igb/igb_main.c | 8 ++++++--
> 1 file changed, 6 insertions(+), 2 deletions(-)
>

Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Co=
ntingent worker at Intel)



