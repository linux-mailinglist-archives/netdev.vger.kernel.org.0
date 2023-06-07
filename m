Return-Path: <netdev+bounces-8693-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A331E7253AE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD5AE2811F6
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 05:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE381388;
	Wed,  7 Jun 2023 05:49:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C903C1385
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 05:49:25 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195291BC7
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 22:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686116962; x=1717652962;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qrXkHIxtfOiwX9kZF+y2Qiyu0drNRMZcW/dT/NkDcLs=;
  b=GFC3kEbqxUJEBpCtzj2o7EopYBX9RezCEleQgg27/wR9zKA2XAWBtNxW
   OtmKYRSGc8rE6HFAi/eBXcyCgoF5ZpIH0FuJPEkdezDY0HM7BGtUOIWIi
   S3/UIgh5pWpP+pStO+tinXU6mmWSYIGmk1YsZkPPeEfS9/XKHHg2K6WK5
   g0sH9nvxDRjE3sNb95nt7RrZdkdovRDUTJ3pg9m7gieDu+R7f67z72Avs
   EWmEtScYV3qGQouTg0+C1NxG7kaFiCljTTt8MHTJUwVGYT6WeircV8N/M
   pWCX9UP7E6WVLBrDY1U9MxAuN3Fbd4bhzC3Vh78YQXoDcxuWNaNk4juUF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="422734908"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="422734908"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 22:49:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="853696049"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="853696049"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jun 2023 22:49:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 22:49:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 22:49:19 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 22:49:19 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 22:49:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hg8pBbc7UhfKcVOqZ+4qJaOFD9IaVDShPaQ4D1AGNtJEV370Wud7xzliBDb/ionwr2CEL405JM37AwO/WJQZlcwySeBz1j/3osnP5Mw2AGOrdrVVYQRuxHwkD/2pkdm7IoH6tD7+cwp2sIuRl71zU22BJ2+jYbNVlbLQ0HzVOqkBOC5gE6eT66kNW/1L3vBRiK9VmpzHuKMD22mplAy5P0z+UBr2d3dBjY1KhiojUG7fZQK46h+8IRlTual3cJGkPu9KezUorv0V8n/SEsCLXHDLBDZN6P/2U2YL1SmSGOueSSI+9oMYoUnG/yLjklch13dps8fVKH3hLxgsiJdj+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ett3TFbHby3hCvkZt76wI/jg3aLa1v7vJiH9orv0hV4=;
 b=mZmV+3opzZvSKyUVmTO3V1DzTVVU3Lk8y9bwkik1eM8C5ucwUSpa7m/ieKTz84McRH19LywMchSrmZLg/73IESvAeh8tbWMa9ZxXMXwk8yr9avchoXcrRYPBFbhe9e/RTNKyT5AUJAx2ZNZR9XxSmXf7h5fWIc/SX3fFQP/7LZH2P4SYWoDbJlDimOhzWhfK7XHIpn3EWkv5rwqyHrQcLyzKSxzo/QQsKtyExoO8vKvZrzu95TFWmwJx8lWngYyHVfn/6T45tNadpbmtTgUXUOR/RCpk09LKq2heNibYwvouLqtzFi1DJYIQUNRvVDXcfh+SeIFcoK1r5GrVS81dow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by DS0PR11MB7649.namprd11.prod.outlook.com (2603:10b6:8:146::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 05:49:17 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 05:49:17 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v4 01/13] ice: Skip adv rules
 removal upon switchdev release
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v4 01/13] ice: Skip adv rules
 removal upon switchdev release
Thread-Index: AQHZjjp8BqSX+UcWVk6B2RL/sACSs69+6vkg
Date: Wed, 7 Jun 2023 05:49:17 +0000
Message-ID: <PH0PR11MB5013624B1FD449D782E839D99653A@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-2-wojciech.drewek@intel.com>
In-Reply-To: <20230524122121.15012-2-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|DS0PR11MB7649:EE_
x-ms-office365-filtering-correlation-id: af2da7fc-f01c-4770-697a-08db671aeea0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8roU9a/uWDW3gt/m90UYwGegX9Wq6yk2nrj6NKw4geHFk99vMbWi29f3/KmznpxtswOa6GyUVsbQOpUsp5SFij182c4envPTtB74Mx5aH36MQLAbaPNbaRAU9N7eNriGrAxUxyK9w98ZhH30eTES7YaxOX6g6K3EaECkkmIR3zTGlciji3EKyjHhJB83STN5urA6lYiJqgZGuDaIURMzMwXe5PIoRxOc+4p6RETwwTmbyH4PjrpjFZILsBU9PVh3B2re2KmawHu58VsT4ST2K02fhvLu+OFfYJwxo1bSDc9qrIuZ49KJQWu8a3KVD49Xxu0Nqb0HNGpj/xO2K418JZne+HdO95QOlTfBQ+64ImQTbhniegv3788Xp76pzRbbk1z9z+rJeSlmiRDDNwkuZzsjh8IC2xRQwEmHhy6Zwxk6hudHrpNbMx+lhDo4+WetZB7iMKoXC9b9KDALfyvCqY98mP+sil+NL+3ctmOmsp9fp3iGSuh6u+615OqUEV5ihd0ssrJWgNUNVlIesreB88T3m7mD0ZjvfwYy7NrvAhmVmwAg0M5rmmzGSqClsQWG0jSmD+I611UvtNhgxF3jY2Zypt0q/CMkCfA9SUPGEv0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(39860400002)(376002)(346002)(451199021)(110136005)(54906003)(71200400001)(478600001)(52536014)(5660300002)(8936002)(38070700005)(33656002)(4744005)(2906002)(86362001)(8676002)(66946007)(76116006)(4326008)(122000001)(64756008)(66556008)(66446008)(316002)(66476007)(55016003)(82960400001)(38100700002)(83380400001)(41300700001)(26005)(9686003)(6506007)(53546011)(186003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qJ8OjY0z+Xu/6k6Lx59NW5Ep4AA7BEC3c3H46nI8OOgeGp6pT1J71Df/0Klo?=
 =?us-ascii?Q?sN16+QdsygnJE6VqkDJ5PH1XnuX7SbCWWgAxY6jOM2PbuKGk2/PJVEuWb2a1?=
 =?us-ascii?Q?DAEYSk5Ij+I2f72g1Xjv5msvPFgCkBKttDGhCkhgu/Ptv05WA2WdzF5ofO//?=
 =?us-ascii?Q?G2TxZDkDkWZF59IgP3CU2D5fEbpXAK02kYcdMBDHfbP5qxgTuDHQS+GlQPB9?=
 =?us-ascii?Q?pciaIludYMBZ3uo8lXbLASPIKmkluG9Fnh7Esv/wNtQz+Xqpnrrp2H7KzunQ?=
 =?us-ascii?Q?kGLFSr1MMFoKPKetXEl8SgNQGlFDScYEZsWOSXlOWRUwuZ8jn6LsU9qdAtsp?=
 =?us-ascii?Q?R7ZGCzFUz6KylA85EcU88Wjsc0yUF+uObVUlq0TcqtssSRqfFRin1wAX411Y?=
 =?us-ascii?Q?AjHFapP5jBC9fqGA2u3RposeyfHtAbS3rnZHIkT+23ehyLnhY0qowcICPi1T?=
 =?us-ascii?Q?vCtnbU8PUDnXzj3/rE3rIW9b06Pug65cIv2nueN76oEfI11xXVVacELN16nV?=
 =?us-ascii?Q?EDy4cGxf5yaKb44tQKOzw5761cmpNsIPf0ZKM9RLFG89CFs4/fJ9h+SZZUDJ?=
 =?us-ascii?Q?JYY6MiT/zsiqY/tjzoiD9Ynng0WSP4PH5PV/off2flmE+Du5qXJiW+3fqUV6?=
 =?us-ascii?Q?v01M7xx/o9N9XugH25BG7V2Wv3M++g37sEvptkjvGcE6jF8pdhG9o2p5dI0p?=
 =?us-ascii?Q?1ztjuqkswhSwp+tUA1vQrX4iWqEUPjY14HaS7dI6RjnE/N+uI6MbDX8/otRw?=
 =?us-ascii?Q?n59ZvGKpShC38Vp+Wku9GirlL0PWBcmfRlQL9TOkwp9e+GktpjJTSOgnERvO?=
 =?us-ascii?Q?EVfD80w3HkbXiIyk3/IgLEN+Ub6i3w4/OXfrERzJSoIUDSJ5zYLv/HXP3iyh?=
 =?us-ascii?Q?e+PK2GjNeJlC5iWZxcvHDbH6q9ramlNDo05QCNOf7RFHEizuDw4WwkTfiDLz?=
 =?us-ascii?Q?LLtpEzNGupH+j1cMJ8qST29W8kxRI4Bbbq3U8CDAP4r2x0MX3YAk5o8L+7aY?=
 =?us-ascii?Q?KnXGdCRmlFO4OcFr2aYEAycZUPbZevN0ZnUzxQUZ3z//1Va7MXyH1ccAARkH?=
 =?us-ascii?Q?2tixQWeaPVYdYVNqDc2xdONq7PYcEFgmj5CUdgnFV4CfuJtEg8Uhib4/plul?=
 =?us-ascii?Q?EkxgJCms1ZYqrZ6HuCKxQ2ie1wfpAG3jROmMK4KK9xMvopCl/oDegk4jFRZp?=
 =?us-ascii?Q?3HU9ZiRkE7YttFvSokHrhSLfWKsWjArx2BC2rJh+kZirQkk5cXrUMN7ieQOY?=
 =?us-ascii?Q?SgAyz4T7mPpsyw+UmddZS7sWq+VgxCK/IL6Dq6BIu1/ZP+zOohvVfiHxU5jZ?=
 =?us-ascii?Q?kdR8q/Ox8pA8v8Z6rNF3etOi9RZ41jteFVkh7elBHNq50nV60ATYcRBPcRCX?=
 =?us-ascii?Q?PmYv+3SQhxKdU9yKGACYNtnCyV8NwkAe0jtfTKyhvVbtT+TT+Y77Bsb99zWi?=
 =?us-ascii?Q?6eiThripz7vJBr+C9C8LPUtpP6cWcxqNGmZIYLveQEjUuxmtFbqaH5yXxAmq?=
 =?us-ascii?Q?Gi5cMLzV+i0dveRCNAwj7m+s8yoPYHGjaWeQG9+t7tn30P286B90WC404apW?=
 =?us-ascii?Q?xQgGZdsBprnHXwekKJe/RgEWlaA/KLzmoDou6aTYNsq3EEkhjgOYYTPYgPeX?=
 =?us-ascii?Q?Fw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: af2da7fc-f01c-4770-697a-08db671aeea0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 05:49:17.2864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lDWyt5Q/aqrAimrSGhu2RzmwrA/JXXxYfW/IuavTiS2cZIp9RKj2h3QkeSKk0cCLFYZFyT+TV23ulb5EIYlicokoSsXXewDFAe7NB8NKSf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7649
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Wojciech Drewek
> Sent: Wednesday, May 24, 2023 5:51 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org;
> simon.horman@corigine.com; dan.carpenter@linaro.org
> Subject: [Intel-wired-lan] [PATCH iwl-next v4 01/13] ice: Skip adv rules
> removal upon switchdev release
>=20
> Advanced rules for ctrl VSI will be removed anyway when the VSI will clea=
ned
> up, no need to do it explicitly.
>=20
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_eswitch.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

