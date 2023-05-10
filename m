Return-Path: <netdev+bounces-1341-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC8C6FD7C4
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 449ED1C20BC2
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 07:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B65525699;
	Wed, 10 May 2023 07:03:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A045D7F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:03:49 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A94DB;
	Wed, 10 May 2023 00:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683702227; x=1715238227;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tvLbPwFgOkMqFvNDKByOqDhNqZBze90VLXlTV4kG/0A=;
  b=W8Nq+Hq16pJ9+40z8+H0YPDYq3yRfqXDVZ3ak9SIb1Wc49L8S2ZuWmtt
   Mr12Ld3f4Y3fB8o1RmP4eUWFHE+i7ST+7hBWm6PNH9bENsYzPRizFr+ca
   ZzjRK5q877CLHiJ9zgmXxmuXBPWfKRrCZ2VRka874CPvjgNRXRafHZr69
   as2nSanol4X+DVotzQz4/lkO2jl+FzSkyek0ba09TPUmEfDhRCXV7JGiF
   2J/rduOrbty5k283gMRiE7NRep+bh9GwASvGpG16xX2h3GOrsj1Y65s3x
   IXkciW3bzWEoQiMlYFtH8yODKr3GDMra6pWaKwi3P0294fW8/SuvZQeQj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="415718163"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="415718163"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 00:03:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="702151818"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="702151818"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 10 May 2023 00:03:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 00:03:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 00:03:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 00:03:45 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 00:03:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iu9C68Sl8WAjNO4OGASlCF7anomyX/R5TL0UuxMAxVtZj+izNEkCgnufMPId3fJbs3YY++JddT4yJCrOxAslLj59E/rUzID5KAl9YP1yBi8W4lkVcw7yj3y6SQKt2W6nalFl6gpbLQU0x0gRwX2hxE1bdbkQeAuZYdN83RJSGewosjvjaTuCTuI5O+zhm7cHYBiz9+ryUs6ZYDeTBuS5JwVnuMh354QIdwEFgDf1qkkQIfiyGclwpVnA+VIJ+k6t0eRZpqgU6RtiqtegqqPn7OrNfoJWGeLiEiOz8rV6l1HPjPGKw35TDcH+W9N4DDOwkPkGqihIjcblPMPbN8x5xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvLbPwFgOkMqFvNDKByOqDhNqZBze90VLXlTV4kG/0A=;
 b=cILMK2MGaEsiIk7iiPqR2xuQTtCKs+SLK5N4cKDKawSAolicxOI6uacjow4RTzyWAffx83nV60uuLXMZSCwvZayr4Ezwsf0dbVjMW1/m+H8oHGSPh8csaL2P/sHob+p3rev6tHdw2IxjUPWzboeosXTKugpq9ibpE+H5az9jJQjugqUHh39Xfq4LID2FUUtvRUcrkfjfzjJOxU9db1gZunNLf/cwH6awCEwzqu+jESeSONSanUKIdWwV/s0gwuk+LnuvbwcT8F3xC5pXOY8XDtr3SJypC60YG7OoOO6AP4NMRdv0Upqea2x6yaCQ5v+QQvIATwE/sD5fvUTnLEFMFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by CH3PR11MB8186.namprd11.prod.outlook.com (2603:10b6:610:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Wed, 10 May
 2023 07:03:43 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 07:03:43 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Shakeel Butt <shakeelb@google.com>, "Chen, Tim C" <tim.c.chen@intel.com>
CC: "edumazet@google.com" <edumazet@google.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>,
	"You, Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69SMhgAgAAMv4CAAAOcAIAA095Q
Date: Wed, 10 May 2023 07:03:43 +0000
Message-ID: <CH3PR11MB734547B820C475A465BA6D94FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <20230509171910.yka3hucbwfnnq5fq@google.com>
 <DM6PR11MB41078CDC3B97ED88AF71DEBFDC769@DM6PR11MB4107.namprd11.prod.outlook.com>
 <CALvZod7njXsc0JDHxxi_+0c=owNwC6m1g_FieRfY4XkfuTmo1A@mail.gmail.com>
In-Reply-To: <CALvZod7njXsc0JDHxxi_+0c=owNwC6m1g_FieRfY4XkfuTmo1A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|CH3PR11MB8186:EE_
x-ms-office365-filtering-correlation-id: 6ac3a343-f9c9-47af-dfdb-08db5124b0f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CUVUQxnhLHZf4m8E3lMIzpluBn9kBVBEisdZmpSj+xGA9LDJa1h3U+SDXbt5bpi4bRbpgihetgea1To+K+i48YX0dgcqMVDiXNoblytzfbsFqQe5Sy1zPFK5kVIjbCb4hdTmoKwoVCVY1yDz1nMkaFlcbjl78QJbTrlqfxosc2jk7eYmS1l1cF64xgdSpy2ZD5V1qiK628giPqg4XqMlU2hEr7KjRuvzWXn55QDalmcOZEUYeg2onqODg/+ge3oXm9HTVm6U3teZxtbePpVCitaLdSTM0UXucZDc6HwzFUEz/vFXxH7cxRtxJABcxPGrhLxLb2I9B5C1rSQ3gWNj7gdrz+VcJ8AYvFqlAQBtM+qjjJXBn+OfIvdxApXMfNW/hXZ82ebveFvJnDKiHwB7o9q9LCZe1QpvElXzJZJ9bZwnmdJ1O9rUBh6C5EyWsI5RY+MXLzLc5ZTeeKz5HGO28YZV1/oOXBYv4FBeb15pnwTLLM27KxCYcXEuJkPnnWdYFUuXSdnEU1DsPm6yqGBZgOdny62u2OBIu1TWfoIL+k0xQJ+9GtVeROAXx30NyMZGPZdGN2njagPE3v+jxRKwlU4wDn4SdmgJHyPvIyFOxMdKycoKO8lV6NXyLcLTp/3O
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199021)(71200400001)(7696005)(66946007)(64756008)(76116006)(66556008)(66476007)(66446008)(54906003)(110136005)(82960400001)(2906002)(6636002)(4326008)(38070700005)(86362001)(41300700001)(38100700002)(122000001)(316002)(52536014)(8676002)(8936002)(5660300002)(33656002)(55016003)(478600001)(186003)(9686003)(6506007)(53546011)(83380400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STA0bDNCdkNobTNsczhrYXhLeGtSQ3RyRFNCdEpJUEhGWUpzc2dMVEF6RUdv?=
 =?utf-8?B?WmN2MW5YYVBzTFNqMGZrVXRMVi9ac3NMNVRvRzJFSTB5SWdYallGTUNGY21u?=
 =?utf-8?B?bXd1b0dpZjRYMUkzTzJyMG9neTlDMGVVbTk5b0grL25EbVJjektTeW9KWmFO?=
 =?utf-8?B?WnhFK1NvZ1BMQllBOTYvaldvSWVKcGFKZ094YVRnUFF1NVFFTUNrS0ZLNm5R?=
 =?utf-8?B?UW00OGEyQStkWHZsTmVQTnIzWms3K1NpclloN1IvcEdrL09UR0RNVzZReW9m?=
 =?utf-8?B?aE10UnNxb2Zra0JVZXJEazhOdE9sbjNLaTAzVkxPVEFzSjZtM3hqVk90Z1Ri?=
 =?utf-8?B?TDBYRkR0ZnZkNmpiaGdzdzdWTjBKMHk4azlvSFNIM2Zxanhtc0NSVmQ0TEg0?=
 =?utf-8?B?bzFLTGIxVkdWc2JvTkZqZE1RZ2RoeFVKM0ROWFZTcUhZTHhHcDA4QVhiczBr?=
 =?utf-8?B?SlR0SHE0RUlQV3QyNWhnRkNWZGdjbkFLZWxtRTFVK1ZKWDhwZjVmYXl0VmtF?=
 =?utf-8?B?UVhSZ0VNeGJPYW1kUll0eTVEOUZ6M1ZRRzgvcjJjR2RUUElGZGN1dEpRZ0Zz?=
 =?utf-8?B?bUZJNzRaQTRXZlVkTDZKNTdHWDZyaU9oZEF6ZzlXSS9OOHVvK3c1dDNHQUd1?=
 =?utf-8?B?Ri9zUUlUcVVhVDRQTFlJMHk0ZHY0ZG5PYzkzTlRjNHlMb0F1dTl5S3BxU3ha?=
 =?utf-8?B?QVlTVDZObmpCUXRqdjE0KzBoYkVmZ1IxcmxHT0lFSUdNV3R5ajQ5QmU3SVZV?=
 =?utf-8?B?V2FIcXZQaE5YTkJUcXJkRkZqeHhOMHFoaFZSVUdtdmRzbVN4L0V1cWhPRmZp?=
 =?utf-8?B?bHlXRXFXVlN5cWR4NWFEdVR5Ykd6L2MyNTN2bFJ2bTF0WXdrSExVY1ZqVERL?=
 =?utf-8?B?MVcxYkhoaUppbGRlVWxrb2RRVXRKUUVmSk1FbTdKc0hIQWZJcGJ3ZGtDbmV2?=
 =?utf-8?B?SUR0Y0k1TVJPZGd4S0JZY25ZdlJTVGJLazc5QVR4Y0VhNC80WHBnN3VOc0Zv?=
 =?utf-8?B?eVdkNkpIK1U2Qk5BSU5WbU8yOFlURmhyMVhnS1l6d1NZMVc2MWRSN3U1RXFP?=
 =?utf-8?B?bzNYazI4LzJOR0FoTDg5WGpnb0w5VDhqTmdiL3JxbjV2ZjBUN3FwcWxEeGsx?=
 =?utf-8?B?NlJkT2JqbVhwM2tIZkRxVkwwOUFESXJDQU5aOEFGVk5vei9JaHN5bEJ6Ykh1?=
 =?utf-8?B?dlpxOGNwMVlDWDRXK0VyblRZbzlQazBXRUdmTEpmejkzYzZuMjllM1BuSVlJ?=
 =?utf-8?B?V1dVR2o3bk5TRGkxOEZSTnp0ZnFXMDlJYkhFUmxTd0RGMDN2cUh6dDhWakRF?=
 =?utf-8?B?RVNEK0oxOElDWXR6RVVDWDdjckVPL3pYTnFjT2ZoTUxtOHJnV0dFKzhNK0xK?=
 =?utf-8?B?dVpnbTZzZkw5Q1V0WTVoNlVUMWhUYVlGaFJsZnVkMEh3ZUtrb1R3YW5sT05Z?=
 =?utf-8?B?OFJ1VjJLbjEyMFQvV0FDbTVQMUJLUFZlbnFkbndGek5wZ05JZU1RcTFxdDQv?=
 =?utf-8?B?eGRkUytaTHdXN1daT3BUZVFIQ1dqZHFaWE9lelBXOEhoQ3NNeXlreVFzbERi?=
 =?utf-8?B?a3VWUGRWcE1INmFsRENncmNHOWJGK0tWZFdFOXp0cmlHTXFPd21zRTdaL2lB?=
 =?utf-8?B?ZjVqMHRyMysxOW9BdTJQMWd4MDN5QUF3MFZiZlo2QWFndGt1ZVJIU1BTQnl2?=
 =?utf-8?B?cFNEMFpBYVRYcXE3TEJUVFRobVNlRVlWbUJjMVpyMThaWXlPNksyYXBJWG0v?=
 =?utf-8?B?UVFZbjlhWGhRTGJMVHkzQytwY2RSaFMvQlhSZ0doZENteWw5V2hndkxueVJh?=
 =?utf-8?B?b1JHTGtBS1g4QWdzbE9ydEVZcUgrZFRvUktrUVJ4Y0Z5TzlmM1dPVTJuMzdD?=
 =?utf-8?B?elFtOXluTVU2NFF3ajhZa3dST2o4dzYwd01BTHJ4dmNPdE9KWU5ib2xIVHFR?=
 =?utf-8?B?czZURTVGRVFjTmZkQlpnMS9PNHQxSm8vcnpXN0hUOTBHaVZlRDc5TnNRWStN?=
 =?utf-8?B?bUgwRTRPUy85SlJFMVY4SWxab0NBRS9ibjExRk84Uk5DYlZwYnVOdnRzQmox?=
 =?utf-8?B?cWhXSzFremxSTUozUHV2QzhnbnJrZ3dBK1ZSalB3L2VET09HWFJhVG9vbnFV?=
 =?utf-8?Q?ziIP9OVJc2Kfq4bdw0810Vvcu?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac3a343-f9c9-47af-dfdb-08db5124b0f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 07:03:43.2776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KZDaIxMfdNV+cULU1xJVyJjRFBpbfkdovJ1doc+Ezj/JHEYXj44lKxe6gyvaRaprgsjhFJVynMIMkkcENgWcHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8186
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2hha2VlbCBCdXR0IDxz
aGFrZWVsYkBnb29nbGUuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIE1heSAxMCwgMjAyMyAyOjE4
IEFNDQo+IFRvOiBDaGVuLCBUaW0gQyA8dGltLmMuY2hlbkBpbnRlbC5jb20+DQo+IENjOiBaaGFu
ZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT47IGVkdW1hemV0QGdvb2dsZS5jb207DQo+
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207
IEJyYW5kZWJ1cmcsDQo+IEplc3NlIDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT47IFNyaW5p
dmFzLCBTdXJlc2gNCj4gPHN1cmVzaC5zcmluaXZhc0BpbnRlbC5jb20+OyBZb3UsIExpemhlbiA8
bGl6aGVuLnlvdUBpbnRlbC5jb20+Ow0KPiBlcmljLmR1bWF6ZXRAZ21haWwuY29tOyBuZXRkZXZA
dmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7DQo+IGNncm91cHNAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IEtlZXAgc2st
PnNrX2ZvcndhcmRfYWxsb2MgYXMgYSBwcm9wZXINCj4gc2l6ZQ0KPiANCj4gT24gVHVlLCBNYXkg
OSwgMjAyMyBhdCAxMTowNOKAr0FNIENoZW4sIFRpbSBDIDx0aW0uYy5jaGVuQGludGVsLmNvbT4g
d3JvdGU6DQo+ID4NCj4gPiA+Pg0KPiA+ID4+IFJ1biBtZW1jYWNoZWQgd2l0aCBtZW10aWVyX2Jl
bmNoYW1yayB0byB2ZXJpZnkgdGhlIG9wdGltaXphdGlvbg0KPiA+ID4+IGZpeC4gOCBzZXJ2ZXIt
Y2xpZW50IHBhaXJzIGFyZSBjcmVhdGVkIHdpdGggYnJpZGdlIG5ldHdvcmsgb24NCj4gPiA+PiBs
b2NhbGhvc3QsIHNlcnZlciBhbmQgY2xpZW50IG9mIHRoZSBzYW1lIHBhaXIgc2hhcmUgMjggbG9n
aWNhbCBDUFVzLg0KPiA+ID4+DQo+ID4gPiA+UmVzdWx0cyAoQXZlcmFnZSBmb3IgNSBydW4pDQo+
ID4gPiA+UlBTICh3aXRoL3dpdGhvdXQgcGF0Y2gpICAgICArMi4wN3gNCj4gPiA+ID4NCj4gPg0K
PiA+ID5EbyB5b3UgaGF2ZSByZWdyZXNzaW9uIGRhdGEgZnJvbSBhbnkgcHJvZHVjdGlvbiB3b3Jr
bG9hZD8gUGxlYXNlIGtlZXANCj4gaW4gbWluZCB0aGF0IG1hbnkgdGltZXMgd2UgKE1NIHN1YnN5
c3RlbSkgYWNjZXB0cyB0aGUgcmVncmVzc2lvbnMgb2YNCj4gbWljcm9iZW5jaG1hcmtzIG92ZXIg
Y29tcGxpY2F0ZWQgb3B0aW1pemF0aW9ucy4gU28sIGlmIHRoZXJlIGlzIGEgcmVhbA0KPiBwcm9k
dWN0aW9uIHJlZ3Jlc3Npb24sIHBsZWFzZSBiZSB2ZXJ5IGV4cGxpY2l0IGFib3V0IGl0Lg0KPiA+
DQo+ID4gVGhvdWdoIG1lbWNhY2hlZCBpcyBhY3R1YWxseSB1c2VkIGJ5IHBlb3BsZSBpbiBwcm9k
dWN0aW9uLiBTbyB0aGlzIGlzbid0DQo+IGFuIHVucmVhbGlzdGljIHNjZW5hcmlvLg0KPiA+DQo+
IA0KPiBZZXMsIG1lbWNhY2hlZCBpcyB1c2VkIGluIHByb2R1Y3Rpb24gYnV0IEkgYW0gbm90IHN1
cmUgYW55b25lIHJ1bnMgOCBwYWlycw0KPiBvZiBzZXJ2ZXIgYW5kIGNsaWVudCBvbiB0aGUgc2Ft
ZSBtYWNoaW5lIGZvciBwcm9kdWN0aW9uIHdvcmtsb2FkLiBBbnl3YXlzLA0KPiB3ZSBjYW4gZGlz
Y3VzcywgaWYgbmVlZGVkLCBhYm91dCB0aGUgcHJhY3RpY2FsaXR5IG9mIHRoZSBiZW5jaG1hcmsg
YWZ0ZXIgd2UNCj4gaGF2ZSBzb21lIGltcGFjdGZ1bCBtZW1jZyBvcHRpbWl6YXRpb25zLg0KDQpU
aGUgdGVzdCBpcyBydW4gb24gcGxhdGZvcm0gd2l0aCAyMjQgQ1BVcyAoSFQgZW5hYmxlZCkuIEl0
J3Mgbm90IGEgbXVzdCB0byBydW4NCjggcGFpcnMsIHRoZSBtZW1jZyBjaGFyZ2UgaG90IHBhdGhz
IGNhbiBiZSBvYnNlcnZlZCBpZiB3ZSBydW4gb25seSBvbmUgcGFpcg0KYnV0IHdpdGggbW9yZSBD
UFVzLiBMZXZlcmFnZSBhbGwgQ1BVIHJlc291cmNlcyBvbiBUQ1AgY29ubmVjdGlvbiB0byBzdHJl
c3MNCmNvbnRlbnRpb25zLg0KDQo+IA0KPiA+IFRpbQ0K

