Return-Path: <netdev+bounces-2009-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B34516FFF3D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 05:23:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B4FC28179F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E06B80E;
	Fri, 12 May 2023 03:23:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ECC7E9
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 03:23:52 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6350B5248;
	Thu, 11 May 2023 20:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683861830; x=1715397830;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+CjhWK702SAqR+UKkbwQBZcdVDQXZm1JL7zQqVsIH/8=;
  b=RhFd9i7qpJiBruT3eMuji7ZSUQ28igw+eKKVZYeCIzabQ01ET/eHIIki
   bFpwBdBdgK0aJYNwMVM8SDkcuVVrLU0qUgPSFsux20J9Gn8DTSfFNP3QJ
   Po+yDCL2yDxNrtf6llJ0gx2ufaIR3BKfKofd45C2VjKhz5JjS+aDIYZcp
   0p8qDBS0os7GPYq4aPuRblr1OGzuakCXH6mYF6/ku/XKfvUSlldmxMuk/
   AJEdBR4yU+KzkYkzK/pPJVI7rWY44p2Sf9WidhGZjD8sr0hesLYcwlCQ1
   6m6wG6KfnGEZk9jyFJtzmCPuMawMMl7yltZ7z2r8YQ9PCniC1nN0j5Img
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="416319295"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="416319295"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 20:23:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="730645970"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="730645970"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2023 20:23:49 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 20:23:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 20:23:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 20:23:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 20:23:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETaeiCLRYq20+svI5x21lOTvxaW5y74dTr39roLbGmlFLLuVdneZQvamZVmGRBSgpJI8kHb08UPL7QXDzgmNeK7SSjEb5/nTPd1xQ3rqL37IoarZi6t984+mkD6VzeFw0lIQjbyWDk79PU+UMYE3tkNSipnk8XjQbdjiUmjp8YNtG5Wjs29DMwnniyjoLd+yludYqtBaQtrDyCApvyA/LFYsS+jrzgkmK2yRl9so7H4iicGZtR/hQnUQeOn0qrxPtC3zYhkzhBGaGgvKDz1NMau/TMEyPvK+jfpENLs69qNTrs0k6MVsJsJnY1zrGFUeDS97p8BGk8+EYlwnaS84hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7+xOYsn+5YGkYD/gF0wkwLPR3NEV8+dlFKoz5ryGPiU=;
 b=ki85TyvKXlDME7gFShaJfhvIUIgM6j/lOJvqCS2itp7tC3WdjPRDPVLEW2LoIFLNJpV2VtfWYFKvygIWYMYX7x9HR1tFpB3eivoiooGjLHdJT7UYqcYawQh75OyW/xgtB+0w34fnf9bWz6sV48gn08/ds3P568uxqFL7xGcF2EQX9Ae9nLbgcE5VnMuQf2YvR6boqMvKRQpZi+cRwtIIlORolQBOg7RnQw77c8UGIBrr2b4+cBCTdY2Lh7MUYGYnyVmrmKm3xyqvFd2f+wYGLRchLxYI8/bYnyfA/sh3GXOilSCT5abvqLmuhD7VleANGQeTP8xn7GeSMIeOesSMHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by PH0PR11MB5593.namprd11.prod.outlook.com (2603:10b6:510:e0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Fri, 12 May
 2023 03:23:46 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6387.022; Fri, 12 May 2023
 03:23:46 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Shakeel Butt <shakeelb@google.com>
CC: Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>, Cgroups
	<cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "Brandeburg@google.com" <Brandeburg@google.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Srinivas@google.com"
	<Srinivas@google.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>,
	"Chen@google.com" <Chen@google.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
	"You@google.com" <You@google.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAAA4vgIAAB2YAgAEwMBCAABKHgIAAKNbwgAAVVACAABAwAIAAMNEAgABhfVCAAGbfEIAADugAgAATvZCAAM4SAIAAWFPwgAANFgA=
Date: Fri, 12 May 2023 03:23:45 +0000
Message-ID: <CH3PR11MB7345F99927E27ED49EEFC6E5FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
 <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
 <IA0PR11MB7355E486112E922AA6095CCCFC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <CANn89iJbAGnZd42SVZEYWFLYVbmHM3p2UDawUKxUBhVDH5A2=A@mail.gmail.com>
 <IA0PR11MB73557DEAB912737FD61D2873FC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <20230511211338.oi4xwoueqmntsuna@google.com>
 <CH3PR11MB734512D5836DBA1F1F3AE7CDFC759@CH3PR11MB7345.namprd11.prod.outlook.com>
In-Reply-To: <CH3PR11MB734512D5836DBA1F1F3AE7CDFC759@CH3PR11MB7345.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|PH0PR11MB5593:EE_
x-ms-office365-filtering-correlation-id: 4bf3515a-0b52-48ee-a303-08db52984ba0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fsQiEoR1bnYYz69MTTDZMaQ2IbkxAIiV32M7LtyFfVa4GwTpdQ0Er6H8TvoQLfSJnlMLuUterF1yAMOB+emQro8Bzu/aQX0mIx1QnosyFuxsOz/ptVtYHLaa0Gp72ocT7juNQHDrmQJMkt3CFnQUuKlc31cy2bQg9108ztpFPbs3mKHVBgXlkxQIgb/3HZ6SkRJCzzDcGXauXaFdxMsuIJytGC292ADjzBl/e9P3QwVfkiuGCHG8pJZqi88+XbbFUw7j1x42k38qxrtTuYwxGMErdO8PZ17YjSZE6Uqe2CLP5Y3xfOXFIY5XTBi11qmqHSNyzqRb26EM9Uu7YplKBDRoCSzRLwuFvK6POxssZl4NeQhUpvXAvvZ7PEcsosKiNeBWgY4FO2xwGStS6+c+ZjJawTbAGyWxpZWmYw33a+jU0ilvKmU/Z75O1QpxP3PNAJAhNdb6wLTVMK0Mzml4DV2IYhXC2zprNvgVbr6vsCXcA5DI+pgYFtijUrEHjJJZzvi2qcWQXuDGWABLpj6Fu5aF6CR92qtJdSWuV677Y46+ubYxpQ4aH+rYVjhhAjM1wLsZiOVL9L4hvHogsecraFGzLH7EeF1aZ5+DUubB4sHvz6uiv0in0XYKGwHFF0+O
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(39860400002)(396003)(136003)(451199021)(66946007)(66556008)(64756008)(66476007)(4326008)(478600001)(66446008)(76116006)(6916009)(71200400001)(7416002)(8936002)(8676002)(5660300002)(52536014)(54906003)(53546011)(26005)(9686003)(7696005)(316002)(41300700001)(6506007)(2906002)(83380400001)(186003)(2940100002)(55016003)(122000001)(82960400001)(38070700005)(86362001)(33656002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?14zE8L8oJCt1v0zEYQA00FdMfAl2mVTEObbu7LLsviY/dwmxb+8CDOSglQH4?=
 =?us-ascii?Q?xzHciZnw2ID7E/EnhM7onQiYMYHWZMHKY/NFR5AeVfeW7azaI3SLuYA7bjGN?=
 =?us-ascii?Q?0M0RL0a3LpCGRUhZYgBVhxiFWzGBJdxu4Gu+825DNcsQfH5kTD5b3d0oah0U?=
 =?us-ascii?Q?C/Bf3YfUo3japIIAe5FiCsJXDwHClK27EC/ku4dj2HSvGE04yqixv8E+mBKH?=
 =?us-ascii?Q?1/wtKvNybPdh6YlBrxEkhVGvp+bqy0Z8CUuyLodijWMYvgkGdnTXKlymyVy+?=
 =?us-ascii?Q?M9zIxpCT4/j8OGhSdsBTT7xm9MlR/v658M0Pw/wGbCgnVN2gB25z817ODcHp?=
 =?us-ascii?Q?hKHoba5EfQlKFO+sEMyQC0yBc+R2t74f9PWn8yAcHXgjKGXP587I4FaNcwcv?=
 =?us-ascii?Q?di39ItWzwYsLwPt/OwvYmb5KOn6PdXAuinHYAOoHjke9LJLN7IceIx9Qy3/b?=
 =?us-ascii?Q?NV/J90pCTKNckI3NSw2HrKT1w+jE14XSi9PFqUz7xhRjPAzUC/oFLDinTt/H?=
 =?us-ascii?Q?f7cnknSdmKS8N9bqyehw9GL7U7OesKKfqiJ0tRH6sHAQynApiKukUjgKYer3?=
 =?us-ascii?Q?GIeBhwyBk6dOFk2npidoMb0YcMcY4rfCgdo22fMyQnKPwgpUkaWvSlaPUvLr?=
 =?us-ascii?Q?miPMxgjN1rsjnFAlx31GvLuJljffXipI99CFjgFxuun0TuchLqmfbv2O0X+l?=
 =?us-ascii?Q?7TxFun6I8J8RbeLUPcj/p14hwEE208JmeIS0RR3dbBmlwD4Q470fJAKT3xfy?=
 =?us-ascii?Q?jf8YjCnndYslhhhh7KkInzJ3YSOuHjlPixUr1IIPgagDhThhSOoNk4+LIM80?=
 =?us-ascii?Q?sPkXxbReHkvgghNP8krzM8DHN6q1+PsMHOiG7TUg4yYasJQZ0I9/knDQ5Ts6?=
 =?us-ascii?Q?i1gL1DXxgVuyGhkPOEYlPzlhwRHTLJWuh4whdnuWE59sheJkxBHXpVr2a6mj?=
 =?us-ascii?Q?7qkkGTwRmxYUIz9IWhFaMvMfXsSYLfAYyYuxyqkQamYVzQCmYLeNjRGHa9po?=
 =?us-ascii?Q?IP7MYmHLkDps+kCEjtnv2q12BNWI/8YKUR8V1kdvu7+6qOuWHcOXf3R66eRI?=
 =?us-ascii?Q?LinZZjDXliUBxQAEdw3q8XBKDexeab8U2aNKaNUIRjufO4p0C0RWhFn7qZfW?=
 =?us-ascii?Q?7UgstCE/Oze6dISKlZjkRU0zay7f5OMh6muwTwCEJ2dNTRrgYa3fAAG4TmSD?=
 =?us-ascii?Q?B/j0AmjTd7cqyGkHPadZQE/tlFMp1poAurlfVfetFCweLpdXKgIJfwx7VUG5?=
 =?us-ascii?Q?3++eSc5Dyy3Guib6VcS/M/eYgvdlvSVHsVqKs7z+hjwxFOCoo1Yb/jGVbh+1?=
 =?us-ascii?Q?+pT+qpSLGZXzxiGzeLNj0JZa1raQ/oA17L5RPbYpazGPa9v6bClsjVq2ONB3?=
 =?us-ascii?Q?c06GFOHyAdF9DjZmks5zLVFx21sQii49kDjFd8fwLIUiLJv4G4nSEorOPPoH?=
 =?us-ascii?Q?N9lHBPYJK5XOw+v1CDbGZR7p6WHbPEMiDJV3MWsOb5M98dBfcptKyLw5Wuel?=
 =?us-ascii?Q?X4RxGLHQBZWyVFONSCGgPgLslsxGEFELaTR3gUVQJUKbwCS8BviAn6axvIuN?=
 =?us-ascii?Q?eqe92vRFZgKyvrHphJ3vS2Z7qIrHKX98el+i19I6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf3515a-0b52-48ee-a303-08db52984ba0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 03:23:46.0187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WI3Cc+wR62MVWZ6w0Di1EeoyIafS9zJz+T0INC9Exi8yxZ6G+7Q0cgxWIId8lvdb15jxCWy0XIOcMJHZPq3UBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5593
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Remove the invalid mail addr added unintentionally.

> -----Original Message-----
> From: Zhang, Cathy
> Sent: Friday, May 12, 2023 10:39 AM
> To: Shakeel Butt <shakeelb@google.com>; Zhang@google.com
> Cc: Eric Dumazet <edumazet@google.com>; Linux MM <linux-
> mm@kvack.org>; Cgroups <cgroups@vger.kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; davem@davemloft.net; kuba@kernel.org;
> Brandeburg@google.com; Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> Srinivas@google.com; Srinivas, Suresh <suresh.srinivas@intel.com>;
> Chen@google.com; Chen, Tim C <tim.c.chen@intel.com>; You@google.com;
> You, Lizhen <Lizhen.You@intel.com>; eric.dumazet@gmail.com;
> netdev@vger.kernel.org
> Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a pro=
per
> size
>=20
>=20
>=20
> > -----Original Message-----
> > From: Shakeel Butt <shakeelb@google.com>
> > Sent: Friday, May 12, 2023 5:19 AM
> > To: Zhang@google.com; Zhang, Cathy <cathy.zhang@intel.com>
> > Cc: Eric Dumazet <edumazet@google.com>; Linux MM <linux-
> > mm@kvack.org>; Cgroups <cgroups@vger.kernel.org>; Paolo Abeni
> > <pabeni@redhat.com>; davem@davemloft.net; kuba@kernel.org;
> > Brandeburg@google.com; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>;
> > Srinivas@google.com; Srinivas, Suresh <suresh.srinivas@intel.com>;
> > Chen@google.com; Chen, Tim C <tim.c.chen@intel.com>;
> You@google.com;
> > You, Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a
> > proper size
> >
> > On Thu, May 11, 2023 at 09:26:46AM +0000, Zhang, Cathy wrote:
> > >
> > [...]
> > >
> > >      8.98%  mc-worker        [kernel.vmlinux]          [k] page_count=
er_cancel
> > >             |
> > >              --8.97%--page_counter_cancel
> > >                        |
> > >                         --8.97%--page_counter_uncharge
> > >                                   drain_stock
> > >                                   __refill_stock
> > >                                   refill_stock
> > >                                   |
> > >                                    --8.91%--try_charge_memcg
> > >                                              mem_cgroup_charge_skmem
> >
> > I do want to understand for above which specific condition in
> > __refill_stock is causing to drain stock in the charge code path. Can
> > you please re-run and profile your test with following code snippet
> > (or use any other mechanism which can answer the question)?
> >
> > From f1d91043f21f4b29717c78615b374d79fc021d1f Mon Sep 17 00:00:00
> > 2001
> > From: Shakeel Butt <shakeelb@google.com>
> > Date: Thu, 11 May 2023 20:00:19 +0000
> > Subject: [PATCH] Debug drain on charging.
> >
> > ---
> >  mm/memcontrol.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c index
> > d31fb1e2cb33..4c1c3d90a4a3 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2311,6 +2311,16 @@ static void drain_local_stock(struct
> > work_struct
> > *dummy)
> >  		obj_cgroup_put(old);
> >  }
> >
> > +static noinline void drain_stock_1(struct memcg_stock_pcp *stock) {
> > +	drain_stock(stock);
> > +}
> > +
> > +static noinline void drain_stock_2(struct memcg_stock_pcp *stock) {
> > +	drain_stock(stock);
> > +}
> > +
> >  /*
> >   * Cache charges(val) to local per_cpu area.
> >   * This will be consumed by consume_stock() function, later.
> > @@ -2321,14 +2331,14 @@ static void __refill_stock(struct mem_cgroup
> > *memcg, unsigned int nr_pages)
> >
> >  	stock =3D this_cpu_ptr(&memcg_stock);
> >  	if (READ_ONCE(stock->cached) !=3D memcg) { /* reset if necessary */
> > -		drain_stock(stock);
> > +		drain_stock_1(stock);
> >  		css_get(&memcg->css);
> >  		WRITE_ONCE(stock->cached, memcg);
> >  	}
> >  	stock->nr_pages +=3D nr_pages;
> >
> >  	if (stock->nr_pages > MEMCG_CHARGE_BATCH)
> > -		drain_stock(stock);
> > +		drain_stock_2(stock);
> >  }
> >
> >  static void refill_stock(struct mem_cgroup *memcg, unsigned int
> > nr_pages)
> > --
> > 2.40.1.606.ga4b1b128d6-goog
>=20
> Hi Shakeel,
>=20
> Run with the temp change you provided,  the output shows it comes to
> drain_stock_1(), Here is the call trace:
>=20
>      8.96%  mc-worker        [kernel.vmlinux]            [k] page_counter=
_cancel
>             |
>              --8.95%--page_counter_cancel
>                        |
>                         --8.95%--page_counter_uncharge
>                                   drain_stock_1
>                                   __refill_stock
>                                   refill_stock
>                                   |
>                                    --8.88%--try_charge_memcg
>                                              mem_cgroup_charge_skmem
>                                              |
>                                               --8.87%--__sk_mem_raise_all=
ocated
>                                                         __sk_mem_schedule
>                                                         |
>                                                         |--5.37%--tcp_try=
_rmem_schedule
>                                                         |          tcp_da=
ta_queue
>                                                         |          tcp_rc=
v_established
>                                                         |          tcp_v4=
_do_rcv


