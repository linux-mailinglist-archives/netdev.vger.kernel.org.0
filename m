Return-Path: <netdev+bounces-11890-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDEB7735037
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF3121C209DC
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704C2C8EB;
	Mon, 19 Jun 2023 09:28:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A637C8DB
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:28:07 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BBD197
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687166875; x=1718702875;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VlsFvu9mLYug/K95qubPwJQRi2fDQckiZFlrPvwiK4M=;
  b=YcmMDU7FO0v2le7ljMwe4DSxlq1c9af+BqqT7fF/GDsjRpWoXC/afydX
   dfAnPjKFyElaf5UmpkstBzQ3bdA/UJg5c/1pphZ7goQNps+xO3QlHQlER
   QfrjgGu3F9hywlnXN2gwIaGTh12AWVHumDDxTuQijEGXCxG8zKKv372fe
   gotJLEYO0Mf8pniz8ZulThw626hgsWOyMaMbsMIfcaAFXZSj4kFwHqIlL
   2AVMc16lUAUp+IcSkcmc5NuSznvw/BY2xY9Q/jizSXWJIaele+jyUJrs2
   gHQfJB2/H5rX98PWS0kUoqT3w2KiWictw5pgR7VNkoncmXrcNnYrvycTN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="339925431"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="339925431"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 02:27:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="826534307"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="826534307"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jun 2023 02:27:35 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 02:27:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 02:27:35 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 02:27:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhT17pLbgLL7aTortMh0UN9WFJVPHIo6GGnAw3CmBu97TyOylD0kvzGbSG1uRWDdTCpfHknx+f09u9QTSzsQSoIaQUUi23/umOaHMe84LAU/kZlouok8tDFkf/LWz/ZSk7HDJ1EG3oddReoQlx+rqcgntFx1ujf7GDtcODuFe8mcbUETW7yntKzXnjIkxUYIqjPHmpQ1s8RrWVSMmqpmqADmI6GI5Yj7EfAKolqe4c9ysZe+c5cbqjOkQCxkVH4z/H/ghP5wKlSYfuVGNQIr0z9vr7UrEnICp1TMAAHq4r5wmkG5OfFOuONPE8s6Xa88UBlMZf4f0mwPCPTDrjPzIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ir4rSvaYQ5RUt//0/RfZhJl5k7u7wapf+HZPBzzSpBc=;
 b=HvAZEOIHgVrBNUQFuUEG4RuqyhqTim12NWrV45MZeotpHSF3H1DH1scxPGhCxSJMAwUlqdCfjgEbgbAuiyD09Z3rsphMsR79BrqNWZWFL00U12yg7PxiJVAL+DACu0K8i5KeXkymeR8mzVNPRZCsZNQQd0R1mOXaExn4Qb0msforLjLKup388+xpNLjJwEQ1D/6ZiAmQ7YcHmGS0ekVUrlpteZcv4gQMO6a3dsjb8DjCT08hMwhbDATtTabWS8M4WqiY1HsvGscFdMtqXHC9fqxAFGabF1JBfvuo/qWA6y46nqE9B6aqTKuimnV6x8fbh3yyaDHNA372K7fctPSRaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by MN0PR11MB6256.namprd11.prod.outlook.com (2603:10b6:208:3c3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 09:27:32 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 09:27:31 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v5 09/12] ice: Add VLAN FDB
 support in switchdev mode
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v5 09/12] ice: Add VLAN FDB
 support in switchdev mode
Thread-Index: AQHZneAdLFCSvlJthka8BGDBfGNhbq+R5LIg
Date: Mon, 19 Jun 2023 09:27:31 +0000
Message-ID: <PH0PR11MB5013AF3D267AE367C26DE1DC965FA@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230613101330.87734-1-wojciech.drewek@intel.com>
 <20230613101330.87734-10-wojciech.drewek@intel.com>
In-Reply-To: <20230613101330.87734-10-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|MN0PR11MB6256:EE_
x-ms-office365-filtering-correlation-id: c83364ba-5027-4290-f8a5-08db70a7686b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UoCAD4Fffxa0xZ+4B24gAvTHmg4x4osUqMwUZwsZPxWoI63lrMbN0G4ZJOmo18h4I7GTwLgemC/Nkua0TF8H9odPsl7ZcBPWJjSlsuWIfihimElwFRMkP0qDDSNMEXWOvUGrLkez9JalIPDr4ynWFf0mBD+f33ynAjPmXtvvyZGWnpUzO9Ed0QnSnsoCMG2GbqaCnFB9Rq8Yss1lTlnlTuEPu2Kyai+go+HnDfNihDaKo4jxOy9Ww5ReEVNQQ+IMdF8Jeb1W8Kdv9e7QO6eOaV+AFfPRb57thQbUj4CkhAQogcs79GYuAzla1+21nNL05UA6HIfNJEhZb+4vq5MKjZMCfzEQhxxT0g5dIhaQq8vSaZT2tatuDT86c7yc3+Ux1lgyb8ZBPErqCw2rMYGXJzt6m08VXyKVRXzeolwPkPCKT7gXCYwxkdbyJ/dFbpJ9mZQRvDTyaQIwIJIz9Xbr4aKz5TIk0mWD7YnZSuR598Do/2Iop5E/m6/+w1XUSz1RnNTxMQwgGNnztl87mINrCwV8zBteIW2PXvrBThdGeLI82aNvIpTWaCksOoGFhdEvqlymWg3PcpJrfUo/y/aVmFsaGh3HKxLSMEOgocPpns6Kjorl3weB0Oxixqxey8Dw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199021)(52536014)(33656002)(86362001)(41300700001)(8676002)(8936002)(38070700005)(5660300002)(66446008)(64756008)(66556008)(66476007)(66946007)(316002)(82960400001)(38100700002)(122000001)(83380400001)(186003)(9686003)(26005)(6506007)(53546011)(71200400001)(76116006)(4326008)(478600001)(54906003)(110136005)(2906002)(55016003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N5lWa+Ouhj+nFduMo7qQtIjgFGRYwOBvCH96tnfVbNBkQ3ULGrdh1+Ifv7uS?=
 =?us-ascii?Q?cH9/FRpBaqu368NjbnoCJgaq/WdWCoJkzGCbEGROcgZANoNIdoEgknyRbUDm?=
 =?us-ascii?Q?Zi3Z/Du4LnlZH9hCPzUGI8k782rB1nZjLgrh2T19BHASIuBIsw1lOqyya7W3?=
 =?us-ascii?Q?6SJpdW2QTMFwHmznkod7yu5bfoxVulrdzs0XOkyZMy6cyBQI1at76zP9ESeM?=
 =?us-ascii?Q?6/u+z/ewQfQw8r6CptL/48MG8wD3WVsoENtHxVaTpWv1NEMbF4UE91+DPxYQ?=
 =?us-ascii?Q?l02gzy3zy1DNRN9/tGUomFqFpEy8YKvdwLwQeNU+h0BxgoxHTF43KdV2oJ3A?=
 =?us-ascii?Q?lIL90t0WHmxPa7x9YB85DdZjvIwdd2JM3n+yUv8CJV1r4JakllX6m/+W6mO+?=
 =?us-ascii?Q?hEZGhRi8hGtzhBbbOVQXVGDi5+v5dsEm8V9vvZT9Jg2v+cPYIGdJHdRVm+02?=
 =?us-ascii?Q?yEbHlyU8ColjnLXbkO/LcC8eMp4oBAADs1XDSp5XQJaN/OkIsTQrLJmFBfTl?=
 =?us-ascii?Q?cpp2hGsoI45M4ChdZDt1UNwaqlXcQJ2PbSRT4MEUMZNnL0iCWIt4KZRPC5Sw?=
 =?us-ascii?Q?IydZ6ms9aY4KPKi+X0s1VaxCxFG2Pc/VLAGy6+NjV+LcUOYeogAWO+SRpeUh?=
 =?us-ascii?Q?cKsAOUYbba4XBE4jJZdBk99DFay0BcOsG6pbP4L6bCErGVNfdE8SoiCmKaO5?=
 =?us-ascii?Q?NxNzWdog7W4p+eeTOPkkuEsF484JzRdghvCg8cvKPaEiH18TRKkRqI9+lOam?=
 =?us-ascii?Q?hBTShdvK0Cq0ZaOpovfNHN9jWSrWwaAa/0/hIG8ffOKeoIHwoDhEcwhCHiq8?=
 =?us-ascii?Q?KQqtaL1p8PqJ21M4SxrGW5XNCgophen6P2x48qeixlbusLEyo/GcN8sczV05?=
 =?us-ascii?Q?8jXL2pN0zmMW9tjJN9IPf7z04wzPIE63wUMzbshu3rSIvMCG5DkwFEpAHsHH?=
 =?us-ascii?Q?bQRczQFut7jIK7OlfUFoVjYXEpDiIMOhg7HfWTV9Q6wIk0MGeW3jPEFCkXH+?=
 =?us-ascii?Q?i0gpEfYjBMqU9rWhJEhsJVkfcizEhjCWBNwkqlC49HY1F8QJVlGM244u9b4g?=
 =?us-ascii?Q?67591+EXjBqL1KQpmD+bitY1ZavPYdIyr01Fr5yzQ8KY/5WJHNykcN5EsKi4?=
 =?us-ascii?Q?GgFNWe7rnSr6NmMSiTjF1BnZWsmtViyxc0sH3HzYBUu3ZO9ZfjaoSJbLDpOY?=
 =?us-ascii?Q?w0u7OraBZ5cTXa3/aqzJuozXlsc5iLijKA1sHQtLQ/e2ulKVyqhTQJ18C8DR?=
 =?us-ascii?Q?gsCgR1EOp8RIb3k6Hk5szvVge/nENlslaz3IQxVv7C6A13WXNacuzDfERJuX?=
 =?us-ascii?Q?OKa+C7ooFu2Z3Rq4uVFj412l7hMoNY+r2+J7+ixH4LJ3LlO69AtGZU6JnV/H?=
 =?us-ascii?Q?FNp4PymM3FFet/TOFs3sCh1PLtB8w1EG8FMMJ5O2nXZJxUdq49Pk5JE0mn76?=
 =?us-ascii?Q?ffN5atL7fHlR1yn1UiHnclBVCuJXyN0Fbr49rXjT3P3YCssyqhZrSbmn9HFQ?=
 =?us-ascii?Q?zrEqo1xWm8m2vR2MTztnCaxgWh3kCTRGKrF/L5uqeq/coK12Kie1j+4ChESs?=
 =?us-ascii?Q?/TxJtX8XOJHszrLgqvVrP+zQE0zPB0c7UJMCWKzusDuMw2GOa5Opt03Idbm7?=
 =?us-ascii?Q?+A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5013.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c83364ba-5027-4290-f8a5-08db70a7686b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 09:27:31.6416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q3QeSaQBjb1bv03U3O7002n/xixy+lJNEV4vau2pDn40G2bDoHgBJVhfiZm4fo0AlvvanqiD9mXDhq6hyheRtRcHRr0F3wJqhdBJIWFY2gA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6256
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Wojciech Drewek
> Sent: Tuesday, June 13, 2023 3:43 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org;
> simon.horman@corigine.com; dan.carpenter@linaro.org
> Subject: [Intel-wired-lan] [PATCH iwl-next v5 09/12] ice: Add VLAN FDB
> support in switchdev mode
>=20
> From: Marcin Szycik <marcin.szycik@intel.com>
>=20
> Add support for matching on VLAN tag in bridge offloads.
> Currently only trunk mode is supported.
>=20
> To enable VLAN filtering (existing FDB entries will be deleted):
> ip link set $BR type bridge vlan_filtering 1
>=20
> To add VLANs to bridge in trunk mode:
> bridge vlan add dev $PF1 vid 110-111
> bridge vlan add dev $VF1_PR vid 110-111
>=20
> Signed-off-by: Marcin Szycik <marcin.szycik@intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: introduce ice_eswitch_is_vid_valid, remove vlan bool arg,
>     introduce better log msg
> v3: move inline function (ice_eswitch_is_vid_valid) to
>     ice_eswitch_br.h
> v5: introduce ice_eswitch_br_get_lkups_cnt and
>     ice_eswitch_br_add_vlan_lkup in order to reduce
>     duplicate code, rename ice_eswitch_is_vid_valid to
>     ice_eswitch_br_is_vid_valid to keep the naming convention
> ---
>  .../net/ethernet/intel/ice/ice_eswitch_br.c   | 296 +++++++++++++++++-
>  .../net/ethernet/intel/ice/ice_eswitch_br.h   |  21 ++
>  2 files changed, 309 insertions(+), 8 deletions(-)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

