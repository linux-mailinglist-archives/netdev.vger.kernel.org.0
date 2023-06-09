Return-Path: <netdev+bounces-9616-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE2BA72A047
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:39:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 176B41C2082A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFF4419BBB;
	Fri,  9 Jun 2023 16:39:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB5D15495
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:39:29 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DF62D71
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686328768; x=1717864768;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xE22myVfUcXpSiYwuoOda8ZktEdpwkooBXAO/IH/JLg=;
  b=gcTU+hfeogmUipLcDlRqf5LxdwH5pebonU6YXuJptE7RO687rikCedG/
   MV3XTCEaHftiIWxJ6ULN7ICvssISh5OHWaqI4ksoHNQuK0frgP8/0Nsph
   UcFyJGLeqwdkLFBuD1k+hxc175gTic8TG2OCi8h9nArlu2Inh5HBXmrzi
   jeis6C8beQ145o9L3MrAQMiQv4wlxyqnjv4Hh8WncZzXxBkY8PXGE3W5u
   xez44lfcXhP63gNyuc/bfsZBg0fGv+E3Ue+z+Qqk49Qi6vMC9RpuphJKY
   wuOzbi/Yh0swrcczQvkjg28BEbc3TajbDZcHpidhk5/6JKJ4DYhk9+lP3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="444009604"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="444009604"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:39:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="743545780"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="743545780"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 09 Jun 2023 09:39:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 09:39:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 09:39:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 09:39:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXtlCb1Zj52ledhqUTIURq9fZumVQVAl6El9Jdfwv8FYP83gEF6jeHM0L20oSF9XpxS0kVOHnQEBrCjCY0G9J1jE4jHV67OC60z1YnffI6/CvN59oeqlnRa+j5nAzjEMHjf47PqR4AuCUwmXnHPtaw2jGnU0R5yvU+nUK4HXSrtY/Tm/X66RIF0qsT+Pj2r7EzvAzx7oqEKQLxN+U66zfh5Kv0+GSkFCwHgO+KXkHT2pKAddpLm33tgKnx3r4252MhSyQusfBUGI2zinlJdnRqUAirQpiUtPEUwLLZ5CZ6fvyHhos01hD7Y4xihbEHWJStoADlU6x/RaEL5bDc6oaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xE22myVfUcXpSiYwuoOda8ZktEdpwkooBXAO/IH/JLg=;
 b=DWFty9xxatat/wv046xshjhM2pdTLAfVUgRSY6ZJIgq7jPVySk9Drbd6PYWLnVAC8+dl38Agq0K61fu2i9WhuuSjtyA9QY8wLnVjSXdI8mSKqJF8x8/1fZRKG4Uo3jkqAgaetvdXMNx25OpzxJ8C0hLjVpaViPchDTtlFn2xlUuYSna8ZPn5wv+azqAv/Cx9trXyp1wR327ZoFq9eEVrxToC19bmlUt0dmFCBGI2JC3E3CNbPPLpTUAFxqH9uwNKikyqtLG41LUegfvDMKHa/xtIVZKx4obiESmQnxSxBTsmwIYqoQZPi9+mpkcYAwL2hwzLcVCMIps97Hyx0HpyAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by CH0PR11MB5233.namprd11.prod.outlook.com (2603:10b6:610:e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 16:39:19 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5e37:38f7:33d2:137a]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5e37:38f7:33d2:137a%6]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 16:39:19 +0000
From: "Ertman, David M" <david.m.ertman@intel.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH iwl-next v3 06/10] ice: Flesh out implementation of
 support for SRIOV on bonded interface
Thread-Topic: [PATCH iwl-next v3 06/10] ice: Flesh out implementation of
 support for SRIOV on bonded interface
Thread-Index: AQHZmjQsaFSLqVaJM0qO8XdiSZCXbK+CSVKAgABj/iA=
Date: Fri, 9 Jun 2023 16:39:18 +0000
Message-ID: <MW5PR11MB5811D379B0645D459FAAF10FDD51A@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20230608180618.574171-1-david.m.ertman@intel.com>
 <20230608180618.574171-7-david.m.ertman@intel.com>
 <20230609104053.rxedc4grgm6sxecd@DEN-LT-70577>
In-Reply-To: <20230609104053.rxedc4grgm6sxecd@DEN-LT-70577>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|CH0PR11MB5233:EE_
x-ms-office365-filtering-correlation-id: 587d32ec-299f-4c56-772d-08db69081248
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6NT52lBfA6sbDwsFjMYi3c4K5Tjcq4+M27IuobHiFlQhgkdJXPrmld9zn7iX0GegNeMROcX14+N7jKbNIPLArvsCGWeO9FP4Ri+7CfcaVImUhKzNslHjEOiDtmDGutkT0oBP8D6ZoXbKH0dwuSt5hgOJP514zjT7Ci/XUHzKj9rZ6kmBNmpPO6WAluVE1CWRZVcuhHDhAWBhgAS+y+vZaFs7LtLQyYJr9xs33zQfEtJfEaO3oPByiRjRSIWp5GwGhThzbFCMvfTDpXUjq3ZQZOL2RE6RVvrT6CTdjs57TyB/fTJtEhz4FZHBc8CX9WRojV+XllhPMjP5eBNLw+HLlIjZZ2Co2HS4voZ9JGiYp6RMbgDCmDfjRGEsLNVpsfelIJssKKEDTnY7N3IrYvz/h259ObZef1qOfql56LJd1zNwVScSQB31y0kNXk7pI+Whb4jQneTp3fHj5WuS7waQZggk6Rqakgfvi3QFTz3U/HKAeBkhm/Lhz38iZT0Vz5NgcCJMDSrthrZTAqjYE2BaJ1Hd8Q/V2yhpLqLI0HLO7Iiy17mi+4Nw7XvwCTO3E91pTLdGADne3SlfIHIBNBec8bGPyeUgiMuBPvPYELqusm+ZbypVHgEf0UOabzU5M7Dz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(478600001)(71200400001)(83380400001)(66446008)(82960400001)(38100700002)(66946007)(4326008)(122000001)(6916009)(76116006)(52536014)(54906003)(64756008)(5660300002)(8936002)(86362001)(55016003)(66476007)(33656002)(8676002)(2906002)(38070700005)(316002)(41300700001)(4744005)(66556008)(186003)(6506007)(26005)(53546011)(9686003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UHdlOFVTbndZVm1PZGNnTVN6b3BYVCtyRWhIbWVybzgrSmd3QjN5UmFMVm41?=
 =?utf-8?B?UEhXMms0dzY4bC9VRUhwV28rV1JFWGlxbG16T3YxbXZEU1NHeldKcFFRMnRL?=
 =?utf-8?B?YnVKdVZtQzRuRzdLd2x4b0hVSVNBTll3SUEyTy9taWtaZWdUeUhLMU9ySWJK?=
 =?utf-8?B?Lzh5aUtMV2R1emlYN3dtL0kvSWdvMlkwdzd2REc5djhrZjYrTmhxbFFqQnBm?=
 =?utf-8?B?cm0xVE84MXlJa2VrMEYvQ05kREhCcWhIRnU3ZWd5UVliUlZuSVJYcEFsZ25Y?=
 =?utf-8?B?QnVFcWdCWUlrNUVKenlxTkYvREJhMGtLV0czRWVKQVo1V2NXMmVNNks1WVdZ?=
 =?utf-8?B?M3p2UnlmUVJUVnpOaVZMNTdISDlUaml0aG8wdXdnZm9Zdk1ITkxGang3UGdJ?=
 =?utf-8?B?NXhBWmZmMmFoZDlBODUxYnFwMis1cUtLSUlvRWFZZlhJQkQrSFdzNWRtME1w?=
 =?utf-8?B?WWxqZzFPQXdwSUFwb012c0wwb29XTE54YllUdUNIOWp2SnQrWWJheWRaeHVX?=
 =?utf-8?B?dktkWjZyNThwbzEwVnVJVDdqUEJJTktIekpqWjdBUDZ1Q0ltMHBTOVowaGt5?=
 =?utf-8?B?dmFTWW1ka01xNWtEbXZ4aTJqaUFuSmIvQWlCUGJ6aWx1RnIrUmNKcUV3SlZz?=
 =?utf-8?B?ZE5EL2d2TGkyRy9YY01sa0V4Z3N0cVgzcmFtSTVNRmEzVlczWVB5OHFyc1dm?=
 =?utf-8?B?bjBkT002Tm5iUFZ0RW42eVoyZGdweVJvL014MUUzWVJmcmNsZWR4RkRKWXJI?=
 =?utf-8?B?WHc0aGxUeSt0YmJiK1lWZ3RHNHZEOHkwTjVJSWF5QTVsQkVTY3lzSWgrMnV0?=
 =?utf-8?B?NXdKc0dtV2JOTzlhbGZBYW5ZMktraE42SHVoOFRVOWttekttbUZUNjhzc0hJ?=
 =?utf-8?B?OUVVRU96Tis2ZDcyc3RKMjluclhWSE5uNFZ4Um5JZG1HTXNEZVl2NjdFenpy?=
 =?utf-8?B?dHp2ZkFoMDFTc2J3TTJvYUJBREtrRDRydVhtVkxoVUpYa1lGbUFZRFFpMkpv?=
 =?utf-8?B?MXRrR2lmUUxoQmlvd0h1N2puUGQ5azF2aEkwcWZhblVGMk9hcnpmTlQ3a2RK?=
 =?utf-8?B?R2lMWGpXUmRTdTg1RC85U004dDIxbEtvWEJrWUJHNU45ak1RTDFpL3hTWHEy?=
 =?utf-8?B?dnN5KzUzNWJvSEhUQzdJWXFsSFF6M3ZXT3k1cm9CWmd2Q09Qd2pwRmt0OXVp?=
 =?utf-8?B?OE1veVR1cDZEdkIvbHZVSGxrRlRGZHdXYUordC9OcXJtZmNsb0NRdmI4bVgw?=
 =?utf-8?B?UVgyUmJuQTl5djhlRWpoMDg1QnNUN2E4dHh3cFk3Y1BlZ21YNzVmd3pkWHYr?=
 =?utf-8?B?Skc3ajBIQ0ovaWlsZ0hLL3NGZk1CRnBNbVh1anlsVVJPckR6bzVidk9xdGRJ?=
 =?utf-8?B?aGR2dWx0d0YxdzN0TUVxOUxkZ044UkxiRTYwek14dlJGMWJMSkpORFZ3TkVn?=
 =?utf-8?B?ZEVobHM4eE9kZ0t2NDNlbGhacE9oQVl2WWZDOXp1Z25DUFRaTmxxVDRuaWh6?=
 =?utf-8?B?bW12YndPZnlIaDFjTHpsZi9hdGgya2NsSDR6YmRBc09UUXZtS1E3YXNCdERw?=
 =?utf-8?B?ZnlKeEZ5RENlMDg0NFVyKzd3YWlmNHdqMnNGT3NFOHdZNWNreUtTZUdxa3hL?=
 =?utf-8?B?ZVc2Q1hFdkxDR0Vqd3AwWGZYQ04vU2hnVkdXQ3ZaZko3cUgyUjdaTmR4TWJW?=
 =?utf-8?B?UzN1L3VGd09xYS9ub0Q5QThPdzhRcDdNdG91UDNtY1pSM1c5TDF2UCsyaElu?=
 =?utf-8?B?clBTYjZCR3FpcjJsUWRzVDdBQjVVNjZ6SFJ2aEZTYWlabWNSWEVmdzcxVWtF?=
 =?utf-8?B?TmphUUViUHJvOUN5LzB5WUpYUXJhdTI0TUlwQjg4UFFNWG01ekNMN3A1QTNE?=
 =?utf-8?B?ZE5vOXdGaWJESFJKamVsVUNxaXF3aTB5eEQ3VWFMSUliNjBJMFgzeEw2blk2?=
 =?utf-8?B?ckY4MlBnQTY4cjhvOG1lRkJMb2d2QmNxMVFDR21NSU43dHhIeEtDdWRuQXNY?=
 =?utf-8?B?bW1BYjNvZE1ZN2xkT0IzVVlsU1l3cXlwT1dFVjRqSmtnd3UxYmNOMGlNaVlU?=
 =?utf-8?B?UTMrUXM5YXgzV01pb1plUzZxVWd6VW1mbEdwWFJnZHJWWDd5S0l5QVJXWEsw?=
 =?utf-8?Q?6FZkkQdVRl5eFm74VX+h7cMs6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 587d32ec-299f-4c56-772d-08db69081248
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2023 16:39:19.0235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cBSgxgaXZL4WSSCBspPirfFe/WHGK+8mf1H6SCvOS0YBe+qd5jkKyGSNYHDnAP+xAtD6nkaE0GlE180upQq3/YYjJF8EAnqXKM+JYq7nzjM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5233
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYW5pZWwgTWFjaG9uIDxkYW5p
ZWwubWFjaG9uQG1pY3JvY2hpcC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgSnVuZSA5LCAyMDIzIDM6
NDEgQU0NCj4gVG86IEVydG1hbiwgRGF2aWQgTSA8ZGF2aWQubS5lcnRtYW5AaW50ZWwuY29tPg0K
PiBDYzogaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBpd2wtbmV4dCB2MyAwNi8xMF0gaWNlOiBGbGVz
aCBvdXQgaW1wbGVtZW50YXRpb24gb2YNCj4gc3VwcG9ydCBmb3IgU1JJT1Ygb24gYm9uZGVkIGlu
dGVyZmFjZQ0KPiANCj4gPiBBZGQgaW4gdGhlIGZ1bmN0aW9ucyB0aGF0IHdpbGwgYWxsb3cgYSBW
RiBjcmVhdGVkIG9uIHRoZSBwcmltYXJ5IGludGVyZmFjZQ0KPiA+IG9mIGEgYm9uZCB0byAiZmFp
bC1vdmVyIiB0byBhbm90aGVyIFBGIGludGVyZmFjZSBpbiB0aGUgYm9uZCBhbmQgY29udGludWUN
Cj4gPiB0byBUeCBhbmQgUnguDQo+ID4NCj4gPiBBZGQgaW4gYW4gb3JkZXJlZCB0YWtlLWRvd24g
cGF0aCBmb3IgdGhlIGJvbmRlZCBpbnRlcmZhY2UuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBE
YXZlIEVydG1hbiA8ZGF2aWQubS5lcnRtYW5AaW50ZWwuY29tPg0KPiANCj4gSWYgeW91IG5lZWQg
dG8gcmVzcGluIGFueXdheTogcy9hZ2dyZWFndGUvYWdncmVnYXRlLywgcy9waW50ZXIvcG9pbnRl
ci8NCj4gT3RoZXJ3aXNlIGRvbnQgYm90aGVyLg0KDQpJIGRvIG5lZWQgdG8gcmVzcGluLCBhbmQg
Y2hhbmdlcyBtYWRlIPCfmIoNCg0KRGF2ZUUNCg0KPiANCj4gUmV2aWV3ZWQtYnk6IERhbmllbCBN
YWNob24gPGRhbmllbC5tYWNob25AbWljcm9jaGlwLmNvbT4NCg0K

