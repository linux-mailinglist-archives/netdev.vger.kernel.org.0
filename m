Return-Path: <netdev+bounces-12100-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4201E73617D
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 04:20:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D36B280F81
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 02:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA94D139B;
	Tue, 20 Jun 2023 02:19:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82921365
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 02:19:55 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37A4E74;
	Mon, 19 Jun 2023 19:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687227594; x=1718763594;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cfSVk88eLyYK1l7ICKWSj6mX2WHyPYFHE2/wXV2Vv8M=;
  b=i2ae8/fzNnQ/9Ak8tZY4hZuSRxGVGKmiAcnZrm+hyHC2/IfOJyQGfL8M
   H+1TJMGKYacbfBZCuM4x4hxqIy/vA9RgM8S8blcuR4LRw31d89XqVsAIV
   ZCJVNpOQtmi0vRY9W2LEuWQ9McJPLB0zzB1Xzr/ymF93N3tTxiz9YLeap
   q4F3bvG25dGcM+wdTbPScsf8pElQg75JrIqBg1rpS3aIkvABOkfiUT9zj
   /2e8Q/Y7dPNMIQVMgTIVHazuKdjIckHldSov/atO41O88GCOFsIkiy32S
   5CMh5hWR7Ob6SKdWbtsTv2Ao1qMGiIC22mS0qv5DbiHIsJKeecrUYGHkx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="425700480"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="425700480"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 19:19:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="783886498"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="783886498"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 19 Jun 2023 19:19:53 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 19:19:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 19:19:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 19:19:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S4v4X49toGoeZgCj829mXw1j2MxKpHQIiQoJaG7Fq7AJGrzfkFm/jiSXgUruCREbBrOEOu5VhnsTK5ebcv7bVJD6+RFHowJq5bW/J3YYk4pcYXDsgHOxrSmF+d4bwGZgBOCleUofRaSqS3zXE8AY0gbIDuEAyQ/jAQ4b4EtaO/UjUwH8YMtzSnCdM9ksXDTILBjSMSdCTH0bt6/LmNlcP2lshD8g5cKQlCUiRy3sKQ3nUMHc1n43XT8du7xuH7OHLivdEbhNj2JTE3yO6+pAl8VS7E4rCC7lAdHb0vxCgMIvJ8jrMaO7VFNwqWXP58d/ZUFu1aTkVE95mmDHp9U+OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfSVk88eLyYK1l7ICKWSj6mX2WHyPYFHE2/wXV2Vv8M=;
 b=Dgqd6BFHFZ4h0RMRgQiynKoEVtpBh8iWIfGuTNFXmpMBpHkXBXeyUZrEIxG11q4KjPXxzhdNpqpYMAhR3nCEW1DpNxiCCL3ii2oiMipjIh7kiAvrvoYK7SKLAst+j8GkszQKFmGpfxpsmHEmf3pXjgAJtZOyTupHhcgXZp4FJW7fff6jxuL8Il+8dJ+MxxVmLxaFmjVu/NBWdIWTOTITt1UUSj/ZvR6qa+QkGDtVn/TBYETe1aRK8HTSWubx+LCJMHL/NH+WrJ5M+bB1risMB9CBWLd2FWt42AKgIUOHdyI39J6FbwMwQAWFQ7jyHta9upbztho+qeo3n8loMaUyMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7294.namprd11.prod.outlook.com (2603:10b6:208:429::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 02:19:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 02:19:50 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <bcreeley@amd.com>, Brett Creeley <brett.creeley@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Topic: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Index: AQHZlZ4kU3Fwl99xbECsoSBHo1JwW6+NFosQgAFrP4CABIvrAA==
Date: Tue, 20 Jun 2023 02:19:50 +0000
Message-ID: <BN9PR11MB52762B0ACFC46319498FE0908C5CA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-5-brett.creeley@amd.com>
 <BN9PR11MB5276511543775B852AD1C5A88C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f1d31c66-4914-b5a4-4092-5e7a3f74ee76@amd.com>
In-Reply-To: <f1d31c66-4914-b5a4-4092-5e7a3f74ee76@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7294:EE_
x-ms-office365-filtering-correlation-id: 2eb33df1-72fb-4679-0c18-08db7134d358
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SwTg1GKcKwr0aRGbn/9D2AZYfR7jxbb2XjKNHYOp4lFtY1fNIOPzpaUr9DM8mRPJw5KAhe1bnWqtC3Yakw9xpNC5s22IXNzaFxVxOZ9lyURsUPHrPimxJT0poAe/65kz+p8FQE9FUYGjVVRz5Fd7auZTclB1Pps2qsSSKqud21l5ZvSWwQwH3U1Rs4tRUsrqk8Ewxj+pdrpYbGx+9gcLeWr3HFa6yi8XShtyb7FewzRWtMVtSiJPTX9+X+eCd83cyekTSC2f/pOe+FW+WwxFwU4nADwsUHY+cBRp1zDECh9uUP5U6QYxx8+xzeeg2Z0WzVEB45noomoa1QVPJq2XB2s6s1r3mVVRXCFYzLS8mTRZEj8kpOsq924NLp84TxklzgZz5FSylaFE56+X0XLNFDL8iRdazNwm547OPlpgTx4IGMqmhzWiJ+p1Ng5Do06lF3rbxLsdIgwKgJ6hn5f09oU2PL5YGBMVwvShi8fTlB337VpxdWvTriFW70LtqX7dk8gQ6ZmUo/B1hEAXPSw8ne0xnbm7/tv4KmShCS+oeh83BQ+/LXzrGPkUka/VLZahZavfa7BEFoRhAodcCNaVZserJKkhP2/XJbtsO5tGwq3Ct7Ti7Mpp6iH4FDxxKZfm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199021)(122000001)(82960400001)(52536014)(86362001)(83380400001)(38070700005)(2906002)(76116006)(5660300002)(66899021)(4326008)(110136005)(66556008)(186003)(66946007)(8676002)(8936002)(64756008)(66446008)(66476007)(53546011)(478600001)(38100700002)(41300700001)(55016003)(6506007)(9686003)(26005)(71200400001)(7696005)(316002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NmVCSUF0MGppQmNINitBNzY0NGlreThZdHhaS1pORXc1a1NJcndkZitwcTBJ?=
 =?utf-8?B?MzA2QldIbUdKS0M2R09VVDhENUFjQmtReUdKODdYakFRYjhKR1BGVDdpSHlz?=
 =?utf-8?B?eE9LMjNDQk8wQ3BDaCtGd1hTZDNXQ1BpbEFHS2JkS1IxUFdPcnY0Z3V3Nm50?=
 =?utf-8?B?dEs0dllBdEEyUkk0aFc1MlpIVUFIaDRpRVVxdko2dXZack5adTllcDAxYlNS?=
 =?utf-8?B?cXJwcjZDa0d4UGxzM1RQYkNiWWhjbGlCbkFQdTV1dVkyTERHSFdZY2o2bWlV?=
 =?utf-8?B?T3hGdHRNUG5VT09MZ1o1MGpHajQ1OXNFUm01SDJUTFdBSjVYUklVbUNKTDQv?=
 =?utf-8?B?ajRvVmNIajBLalQxTkVwYVBLMXpUbUZrYWRqTVZWWnFxd3ZOTktkZnMzWVVh?=
 =?utf-8?B?TEt2QTF3R2xwQmRkOGpDV2E3a3VkckNCUnNyMmFhNjcyRVZOOUJYZlJJa0Rp?=
 =?utf-8?B?YllRMGZSWlRnOWhKK3hhTENIeXUwbnFzZUFtcVZUdDBDSUhHR2xWdTgwZW4y?=
 =?utf-8?B?QXM4QjVMWVhybjJNQndjRGVjSTJmZlpVbXVQUjIxYmVteWtTaUlaSHlranNI?=
 =?utf-8?B?NCsxY29iRjFhUzA4TlFia1p6RWJmbC9XTVI4M29aaGpLK1B6Rkt6WUMzek05?=
 =?utf-8?B?ZVdCMGkrKzF2SHFZN3VrVW04WUVxRlZnVUFUTTV3UCtvN2cyNEVZcWptWFJR?=
 =?utf-8?B?dGY3ZFFVcU1OdjR6V210bXk1R2Y3azk4NUdXZWw3QTNEMXczV2xMaDQzV09I?=
 =?utf-8?B?aFBPWUlidTV5SGprVGFhWGdHNTdqbzg5alNkRGxXeHhNa3FabnpLMFZVRTZy?=
 =?utf-8?B?b0E4SEdCT09hbC92OTh1NzN5YllFU01ibWhzVFlGNVFZVkZvUnZXRmdXQTZM?=
 =?utf-8?B?SStoUGJ2MFloR2YvdG1rTUhhMEdjenNHOG1JK2o2ZDYzNmQ3ZndkbUhrOEFZ?=
 =?utf-8?B?Nzg4bWI0c1c1N0FZS2lpVzN1dGxsR05OTExsbHArdFpyWUJCZEJvbVRBemll?=
 =?utf-8?B?T2ttaTc1enJFQStiU2hhSVFZcXpVOWFEYTE2cHJLT29pWjZDVHhJYjltcEJi?=
 =?utf-8?B?RjhuZGlNdFN4T200OXBPNU9SL0VWaTJUb1dwbjA2bjVHQjczS0d3ZXNxK29k?=
 =?utf-8?B?aytBYnFBek9SQUlpOWkyMllvdlFIUXg4K0RoU0lSRXp4bWhzRkN4Mkh0K3BB?=
 =?utf-8?B?NWV4amViQVRvM0tzemFFakVyV0d6L0I0SGhPTjBIRDhXcGQ2K2s1NG9BUGw0?=
 =?utf-8?B?MGJXN01xN0ZqNjc0cjFnZEFvWWtFT1ZEYTNpR1RvUEMwNGcrV2kzc2dYSWtz?=
 =?utf-8?B?Ly9oQW1zVU1rWU1qcnRLWmxoMi8xeXFyOXBSZWo1cHFFZitOM3crVVJPWXNy?=
 =?utf-8?B?aEZFamFIZmhmbVA5VmFsOHJSakc5WnBGSFJ0dkNnbS9mT1JVWGJXTTRWd2FN?=
 =?utf-8?B?SXhjYXU1aFhWcE5HZlFRZG0veFJLZFFsVW1mNm5UcjJ6RzdWaUduRW5TbWRr?=
 =?utf-8?B?am1TbGFoY2VsQWl5MUN5MzJaREQ0NXA4Tk1tSEJIYnhYNXkwU3RnR0ZiYmZq?=
 =?utf-8?B?R0RxSXZvVlJnandHMjZrVU54TFEwdEQ2bHFVWG5jb0dNdTUzTVZzMHF1b0x0?=
 =?utf-8?B?VzJaT3E5RzJ4VkV4YjhXeTFCaUZBSlJRMi9yc0hBUHNNZ1E5NEJ3eTRVdGdu?=
 =?utf-8?B?ZVJoN0RLQW1vT2lqTHNUMXlKNThxM0t6blM1TFkzVXZGcU1yMjFDZ21wUkcr?=
 =?utf-8?B?VEJwV3FLc0VSS200U1g3eDF4VmpwRlNFMEN5OE1OQVdxVlg3MGgvNzJCN2hB?=
 =?utf-8?B?bkdURVlRU0RZcVRqQkkyaEJNK0NZNERLSytpMExLWi8yN3JqbllyZTNxY1pW?=
 =?utf-8?B?SVhtbUg0bG9UdUZwN2dQbVBZNFAvSzQ2aDBXU3ExWms5b21nMGpYaFZXdkdK?=
 =?utf-8?B?MlhGVS9hRGcvakJkVFZmZnJoSDFXVERtUU9aUjVOaG5wUGRVdUFBcFgzYnFF?=
 =?utf-8?B?VWh3QVFrSmhPQjZGdndPTFAralM5Y1NDaExXeTByVHEzcGNzUzRQVmlIZFNN?=
 =?utf-8?B?amlOZi80TlpDNkk1NFRuR2liQmxUVldOVnNSUTVMbW0wUkVhcUlNTDc1T1VW?=
 =?utf-8?Q?9A/15C7aKiUQlm31vuHhezQ++?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb33df1-72fb-4679-0c18-08db7134d358
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 02:19:50.0827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: echYKIZXP48lA1rKMwe+PoQ/d1L1bHM5tl0l5QFuzvxGfAlY9GqjGy1gZqGfZeHbIYFEgh71vt9y2EQSOmpQ9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7294
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiBGcm9tOiBCcmV0dCBDcmVlbGV5IDxiY3JlZWxleUBhbWQuY29tPg0KPiBTZW50OiBTYXR1cmRh
eSwgSnVuZSAxNywgMjAyMyAxMjo0NSBQTQ0KPiANCj4gT24gNi8xNi8yMDIzIDE6MDYgQU0sIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+IENhdXRpb246IFRoaXMgbWVzc2FnZSBvcmlnaW5hdGVkIGZy
b20gYW4gRXh0ZXJuYWwgU291cmNlLiBVc2UgcHJvcGVyDQo+IGNhdXRpb24gd2hlbiBvcGVuaW5n
IGF0dGFjaG1lbnRzLCBjbGlja2luZyBsaW5rcywgb3IgcmVzcG9uZGluZy4NCj4gPg0KPiA+DQo+
ID4+IEZyb206IEJyZXR0IENyZWVsZXkgPGJyZXR0LmNyZWVsZXlAYW1kLmNvbT4NCj4gPj4gU2Vu
dDogU2F0dXJkYXksIEp1bmUgMywgMjAyMyA2OjAzIEFNDQo+ID4+DQo+ID4+ICsNCj4gPj4gK3N0
YXRpYyBpbnQgcGRzX3ZmaW9fY2xpZW50X2FkbWlucV9jbWQoc3RydWN0IHBkc192ZmlvX3BjaV9k
ZXZpY2UNCj4gKnBkc192ZmlvLA0KPiA+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB1bmlvbiBwZHNfY29yZV9hZG1pbnFfY21kICpyZXEsDQo+ID4+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHNpemVfdCByZXFfbGVuLA0KPiA+PiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB1bmlvbiBwZHNfY29yZV9hZG1pbnFfY29tcCAqcmVzcCwN
Cj4gPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTY0IGZsYWdzKQ0KPiA+
PiArew0KPiA+PiArICAgICB1bmlvbiBwZHNfY29yZV9hZG1pbnFfY21kIGNtZCA9IHt9Ow0KPiA+
PiArICAgICBzaXplX3QgY3BfbGVuOw0KPiA+PiArICAgICBpbnQgZXJyOw0KPiA+PiArDQo+ID4+
ICsgICAgIC8qIFdyYXAgdGhlIGNsaWVudCByZXF1ZXN0ICovDQo+ID4+ICsgICAgIGNtZC5jbGll
bnRfcmVxdWVzdC5vcGNvZGUgPSBQRFNfQVFfQ01EX0NMSUVOVF9DTUQ7DQo+ID4+ICsgICAgIGNt
ZC5jbGllbnRfcmVxdWVzdC5jbGllbnRfaWQgPSBjcHVfdG9fbGUxNihwZHNfdmZpby0+Y2xpZW50
X2lkKTsNCj4gPj4gKyAgICAgY3BfbGVuID0gbWluX3Qoc2l6ZV90LCByZXFfbGVuLA0KPiA+PiBz
aXplb2YoY21kLmNsaWVudF9yZXF1ZXN0LmNsaWVudF9jbWQpKTsNCj4gPg0KPiA+ICdyZXFfbGVu
JyBpcyBraW5kIG9mIHJlZHVuZGFudC4gTG9va3MgYWxsIHRoZSBjYWxsZXJzIHVzZSBzaXplb2Yo
cmVxKS4NCj4gDQo+IEl0IGRvZXMgYSBtZW1jcHkgYmFzZWQgb24gdGhlIG1pbiBzaXplIGJldHdl
ZW4gcmVxX2xlbiBhbmQgdGhlIHNpemUgb2YNCj4gdGhlIHJlcXVlc3QuDQoNCklmIGFsbCB0aGUg
Y2FsbGVycyBqdXN0IHBhc3MgaW4gc2l6ZW9mKHVuaW9uKSBhcyAncmVxX2xlbicsIHRoZW4gaXQn
cyBwb2ludGxlc3MNCnRvIGRvIG1pbl90IGFuZCB5b3UgY2FuIGp1c3QgdXNlIHNpemVvZihjbWQu
Y2xpZW50X3JlcXVlc3QuY2xpZW50X2NtZCkgaGVyZQ0Kd2hpY2ggaXMgYWx3YXlzIHNtYWxsZXIg
dGhhbiBvciBlcXVhbCB0byB0aGUgc2l6ZW9mKHVuaW9uKS4NCg0KPiA+PiArDQo+ID4+ICsgICAg
IGVyciA9IHBkc192ZmlvX2NsaWVudF9hZG1pbnFfY21kKHBkc192ZmlvLCAmY21kLCBzaXplb2Yo
Y21kKSwNCj4gPj4gJmNvbXAsDQo+ID4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIFBEU19BUV9GTEFHX0ZBU1RQT0xMKTsNCj4gPj4gKyAgICAgaWYgKGVycikgew0KPiA+
PiArICAgICAgICAgICAgIGRldl9lcnIoZGV2LCAidmYldTogU3VzcGVuZCBmYWlsZWQ6ICVwZVxu
IiwgcGRzX3ZmaW8tPnZmX2lkLA0KPiA+PiArICAgICAgICAgICAgICAgICAgICAgRVJSX1BUUihl
cnIpKTsNCj4gPj4gKyAgICAgICAgICAgICByZXR1cm4gZXJyOw0KPiA+PiArICAgICB9DQo+ID4+
ICsNCj4gPj4gKyAgICAgcmV0dXJuIHBkc192ZmlvX3N1c3BlbmRfd2FpdF9kZXZpY2VfY21kKHBk
c192ZmlvKTsNCj4gPj4gK30NCj4gPg0KPiA+IFRoZSBsb2dpYyBpbiB0aGlzIGZ1bmN0aW9uIGlz
IHZlcnkgY29uZnVzaW5nLg0KPiA+DQo+ID4gUERTX0xNX0NNRF9TVVNQRU5EIGhhcyBhIGNvbXBs
ZXRpb24gcmVjb3JkOg0KPiA+DQo+ID4gK3N0cnVjdCBwZHNfbG1fc3VzcGVuZF9jb21wIHsNCj4g
PiArICAgICAgIHU4ICAgICBzdGF0dXM7DQo+ID4gKyAgICAgICB1OCAgICAgcnN2ZDsNCj4gPiAr
ICAgICAgIF9fbGUxNiBjb21wX2luZGV4Ow0KPiA+ICsgICAgICAgdW5pb24gew0KPiA+ICsgICAg
ICAgICAgICAgICBfX2xlNjQgc3RhdGVfc2l6ZTsNCj4gPiArICAgICAgICAgICAgICAgdTggICAg
IHJzdmQyWzExXTsNCj4gPiArICAgICAgIH0gX19wYWNrZWQ7DQo+ID4gKyAgICAgICB1OCAgICAg
Y29sb3I7DQo+ID4NCj4gPiBQcmVzdW1hYmx5IHRoaXMgZnVuY3Rpb24gY2FuIGxvb2sgYXQgdGhl
IGNvbXBsZXRpb24gcmVjb3JkIHRvIGtub3cNCj4gd2hldGhlcg0KPiA+IHRoZSBzdXNwZW5kIHJl
cXVlc3Qgc3VjY2VlZHMuDQo+ID4NCj4gPiBXaHkgZG8geW91IHJlcXVpcmUgYW5vdGhlciB3YWl0
X2RldmljZSBzdGVwIHRvIHF1ZXJ5IHRoZSBzdXNwZW5kIHN0YXR1cz8NCj4gDQo+IFRoZSBkcml2
ZXIgc2VuZHMgdGhlIGluaXRpYWwgc3VzcGVuZCByZXF1ZXN0IHRvIHRlbGwgdGhlIERTQy9maXJt
d2FyZSB0bw0KPiBzdXNwZW5kIHRoZSBWRidzIGRhdGEvY29udHJvbCBwYXRoLiBUaGUgRFNDL2Zp
cm13YXJlIHdpbGwgYWNrL25hY2sgdGhlDQo+IHN1c3BlbmQgcmVxdWVzdCBpbiB0aGUgY29tcGxl
dGlvbi4NCj4gDQo+IFRoZW4gdGhlIGRyaXZlciBwb2xscyB0aGUgRFNDL2Zpcm13YXJlIHRvIGZp
bmQgd2hlbiB0aGUgVkYncw0KPiBkYXRhL2NvbnRyb2wgcGF0aCBoYXMgYmVlbiBmdWxseSBzdXNw
ZW5kZWQuIFdoZW4gdGhlIERTQy9maXJtd2FyZSBpc24ndA0KPiBkb25lIHN1c3BlbmRpbmcgeWV0
IGl0IHdpbGwgcmV0dXJuIC1FQUdBSU4uIE90aGVyd2lzZSBpdCB3aWxsIHJldHVybg0KPiBzdWNj
ZXNzL2ZhaWx1cmUuDQo+IA0KPiBJIHdpbGwgYWRkIHNvbWUgY29tbWVudHMgY2xhcmlmeWluZyB0
aGVzZSBkZXRhaWxzLg0KDQpZZXMgbW9yZSBjb21tZW50IGlzIHdlbGNvbWVkLg0KDQpJdCdzIGFs
c28gbWlzbGVhZGluZyB0byBoYXZlIGEgJyBzdGF0ZV9zaXplICcgZmllbGQgaW4gc3VzcGVuZF9j
b21wLiBJbiBjb25jZXB0DQp0aGUgZmlybXdhcmUgY2Fubm90IGNhbGN1bGF0ZSBpdCBhY2N1cmF0
ZWx5IGJlZm9yZSB0aGUgVkYgaXMgZnVsbHkgc3VzcGVuZGVkLg0K

