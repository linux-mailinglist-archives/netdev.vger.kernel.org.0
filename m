Return-Path: <netdev+bounces-12099-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 280D4736168
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 04:11:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D56E6280F71
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 02:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28FF41360;
	Tue, 20 Jun 2023 02:11:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C941119
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 02:11:07 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A36120;
	Mon, 19 Jun 2023 19:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687227066; x=1718763066;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R5w1KU5CXc2b/x0sjxtAjy6//fQob2okRqAPP4f5igQ=;
  b=LTVebJ2nvGZNhyJsC2YRmUOS29wlCYYKy4vmy1Ix7OYKXTcZFWaoeH5N
   +if2QaEBp5arLZsxMbtMsUU000MNsIQR0hCNqoCiIsDMJXHWKC1uPoMe4
   5qrW3L+L+u1ziscVQ+GLKLy+rtezXXzWQxYnhdBpKJOx30q77++rgprUF
   CufxsypjM412A2CmZ/mMGePvNRda7xMoeTepqiFKsWN2LFOjxlS4PU0Ty
   GPzjDLAbFw3XAS5mSm56pVY0SXvYtZefqPBeFM8dVu7sH9oo5ObnPUpoi
   y8YgzCNtSM7V5BJcjwCIcIaTsN2pMcmahVcd4RaVLvvvOWr8kHWoT943R
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="363171262"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="363171262"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 19:11:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="803780911"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="803780911"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jun 2023 19:11:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 19:11:05 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 19:11:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 19:11:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmdARX1zDzknFGLsCGMX3N25IiLLEJqCH2caUeNQndi5hnQo6fbmddc9jo60MzhJTomFsUjp3Snnahjl+DVwAzb222HdMX4HdRZherMJ6Gpe7S4LssiUz9VOyKNefqXidt07fCtg1T0BxmrgD8hmnlFNYAKCP7GARUEeEnb4rrGhehBOx4qTgg9k5LMAMilYClpCVVDLHmTjLTwP4dr7iKNA6OtGIFSqJfP1tk43q7FSyyxF5fNaMbei9K+cG6ah34B1+14aZTZX1XlEaUf/Mo8d508sCooycI+HPq70GcxUWCM8vUg1/t3EZO8eKO34rb9FH23nGerDVzjCNAsM3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5w1KU5CXc2b/x0sjxtAjy6//fQob2okRqAPP4f5igQ=;
 b=dAPqcc2IwRjO7uBrmKJKfRvn+yLvnBtDcy3NfKUzpMnt9GQ/iNFbWrgwS3sqzMSCFseZH4FBiqz0LxqF4uBkgkMaQfwY+fJRt+VYk4t/RrRcLtkked70J4Oy1DEj6Ob4Sk2PhcYmWNWPoZcgGl0cVHzZXSXk2R7N9dJYiEcM3FfaJ11sVXk07GlLyvL4QesnQJIGa0jtyOQKpQKmxMDMHfD0fcU1Q43zg7YpmRcJlSOBOFEkkpN8k915hoogdd+UnGatBcbuaoKci64HiAqsGqZ6NASOjv9qR6rT9oW8txxIn4VxYOCiX6i3qp9W1PallNOtL7gDIC6QHn55gNxHIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW5PR11MB5809.namprd11.prod.outlook.com (2603:10b6:303:197::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Tue, 20 Jun
 2023 02:11:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 02:11:03 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <bcreeley@amd.com>, Brett Creeley <brett.creeley@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 3/7] vfio/pds: register with the pds_core PF
Thread-Topic: [PATCH v10 vfio 3/7] vfio/pds: register with the pds_core PF
Thread-Index: AQHZlZ4hceEY8m3t0EmPqUpOuvje+K+NFCcggADKnwCABS4EcA==
Date: Tue, 20 Jun 2023 02:11:03 +0000
Message-ID: <BN9PR11MB5276B058E1D127A00938C1788C5CA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-4-brett.creeley@amd.com>
 <BN9PR11MB5276B5AABEEEB9353BCF38308C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <080c4b23-f285-0f31-5815-e4da3f157009@amd.com>
In-Reply-To: <080c4b23-f285-0f31-5815-e4da3f157009@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW5PR11MB5809:EE_
x-ms-office365-filtering-correlation-id: a2949736-dcbb-460d-5083-08db7133994e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X0WJ8sOXrceqgYMfNNv2V2/7GHRvYY+/3DfoGrrN1Yv4x3x5nJ6AcK7PpZvkWXCsIwCfZs2PbvC928oaNZCpQ5DZ/Cy99AR49Oj87CmDEWCZL+9b3FM8KDWvgV6856b+13zDA761DawQxKbrvMNQDzjbJBlfzesE61AlH7XSKvMCLHRW+Ej6baM9ekrCtaBOCd2ubQM9mjGAiLkWJDbby5h+dgELR93jMgo4m4X99HKtmBkDCFOqy8HSh8g7ImT/waM3+OR7G/oGap92bKn4ePTqUUn4Q/3lpmpBPz0OxIEbWl53d9QesyGqwKRlPa/wvIN/TF4pE/b4JZCie5ZDqQAVaVpJ97cJ/5RKdJbLDVWpbFZN7X4RCnH71Ks1tIljBQHOwFfGLX8sIF/mFdxuJmJIcwdX/+0WRUDa3FTP0LeU+qRm52TCuCTlOPJMqc7JtVnKaxTFAgi8zrBS49yMcL7oXD0pz3EjmK4bGldLcEer3wTdbmehShKnylaiVkhGp2r3PUFiQuOlUa59DIO6DUULNBjCWIyt9p0SUxalSMq3ySyKDO0qnVT4OrZrF0uG3HFdYBknXvEyk6L3A/TSa2XBlZix/fpVVU3TFFVwnkN3T9asZY9LllChph0LkNjd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199021)(86362001)(55016003)(33656002)(38100700002)(122000001)(82960400001)(38070700005)(71200400001)(478600001)(26005)(7696005)(110136005)(52536014)(8676002)(8936002)(66946007)(4326008)(66476007)(5660300002)(316002)(64756008)(66446008)(2906002)(76116006)(4744005)(66556008)(41300700001)(186003)(6506007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWNzb1VRejNqM0JQcENHYzJNUjhaTktLdEFBNzIvZzZoRlZGQWJTKzNxZzlE?=
 =?utf-8?B?c01Mb1pWM1V5aGI2allEYlJjalI5Z2thMkI2MjNFZmJVZ0Y0K3V1bkFPa1Bt?=
 =?utf-8?B?NDB6amZQTndXYmRWZ1lZYUlqY0lZenc3V0NhVmRZMTdmQ1AwYmRxbG85blBs?=
 =?utf-8?B?OEZxQVBTenZ0VGwxZ0pCTUhwZ1FNYTRUMWNIY3V6SG52TkQvazhWa3NjV0x0?=
 =?utf-8?B?ODVrSHllRFlVbmZWQ1NzNkFnM3Q1SnZoQlpvWUJZemZoaC9SQmRVZEtLRmVR?=
 =?utf-8?B?YW9QWkVPcXVISCtjL0tCWldvMkJ5Rk1wNEg0Z09sUllCdFZBdUJVQysvbkti?=
 =?utf-8?B?M2daYTF0cXdrWnJZRVoyOGRua2paWjFSTVhpWkF0U1pQQTBBb0ZlaHVRUlI2?=
 =?utf-8?B?YzV5RHp2Nkw1eTZlNXpHNjFmY2llMktsQ2RWbTkzTnBZU0hmdndvQ1FDOE1C?=
 =?utf-8?B?UVFONmxOajIrUmlUT1FWUWU5MUliLzRqbW1tSW0yMCtBK0JrSlM4bXVLaGN6?=
 =?utf-8?B?bTEybHlMSnV0dy9DaUZEYmgrd2xYUllSSE5KbEl6VVNlUzVkazFLQit3aEgy?=
 =?utf-8?B?aXF0bHBZSzEzV21nTml0ZE43NjVXVGR2UWZJYmF3ZVR6Q1pNVlMreEU5QjB0?=
 =?utf-8?B?dzRlK3NxK0hFaHQ2ZzdWaWJtZlhBZVpZQ3Q4TWJsenpmTkRIbkh1dDRIWkFq?=
 =?utf-8?B?V1ZNNndWdmN3bzhvYTBHR3JMUU5jMWJ5MERJMnVFNHFhNHp4RXpCVFowTFlh?=
 =?utf-8?B?SEU4c1FrWFFGeGZ0MFdodXJOZkZkMFI0ZHc4cWhWNytEeElHNDh1TTAybVdk?=
 =?utf-8?B?UkRnL3NDUkdnZVBwM1ZlQUwydmUyek1mUnFqaVY1bjVTNVRNamh5RjdxdmNV?=
 =?utf-8?B?OCtSVGRWWEtqeXhYenlBOGxJTDZKSlArYnp6bC9UdngwaC9XbDJCNU1HcFZy?=
 =?utf-8?B?cHVtWk5LcUFZeVhqMEU2RC80dnI3VE1kUHkvMkw3Z1czUG9kV09tUmZFdFZW?=
 =?utf-8?B?Qjdhc3FvNmk2aEZ6eWdFUjdRd2pQK3NPanBmRm05dVUxMzE1ZXRmaTFzTnNx?=
 =?utf-8?B?UHdYZWMyUC9waWd2cEhiZmF3SWp3U2FNa1JSRmw2NUNLc0djN2wrN2lCeDYv?=
 =?utf-8?B?MTB6VGhidEZXdzR5eUJnS3hEMmtGVkpTdGtYYVJWNmhKR09Ca3hXOTZaUFNq?=
 =?utf-8?B?N0QvUkIrYTFtdHFza2lQSHRKbjIxR1ZqSVhWYlgxeXlGYVM2bEptM2t4bzF2?=
 =?utf-8?B?bUgzN0taL2RYc1ZFTmRzWE5YYjJ0eUk2WUI2N0xReHZHM2Z3anZpVnpWd3NV?=
 =?utf-8?B?U3FKMXZKNVBXbm9lNFVKNllWQjFXOWFzMDU5cXpqSGVDK1hJL3VRSloyTUhp?=
 =?utf-8?B?ZTZlY29CYjNEdlc2VWVZOGlRRHArdnRoRy9LbEdXZXQva21PbzAxUTlZMVdm?=
 =?utf-8?B?b1JqVXYxOVIzUmI3VHpCbm5SQTZ3Tmtyektsamk5Y1VGdFhaUk9QeklnVU1u?=
 =?utf-8?B?TEtWL0JNZ01aYllnM3UvZjFyenhqdllEY1ZWcmJXb05YMzVJWjM2d2hKczNl?=
 =?utf-8?B?cGlBQ0x0UHg1c2I2d1BHeXFUTTd2UG1uOHRBU0xzV05RTHdQVjJzUmhPK203?=
 =?utf-8?B?RE54YlFDNTE4WGNHTTRkamc0MGl1cGVlV0FoMHJVaVlhckVQenJ3SlBKOG5Q?=
 =?utf-8?B?c0VHemZrcjB1UkpycURhVGF6aFppb1hDRHFENjBSSU5kanltYVlHdEV1LzNn?=
 =?utf-8?B?WFpnaHNJclFzQzN0a0JPdDFCQWNxcUVRZ25QaklKN1RMVTZNbmJEOXUyV2dE?=
 =?utf-8?B?NUo5NEVra2loa0lLMUtLZWdYNWtSMU42Wi91TC91RjVzc3NMamV1bWlnaGJI?=
 =?utf-8?B?MEpQZDhpd3hZV1ViZnZPY1ZNMnpibFJaU1RLcUFFRHRUcnV2LzIzSkxkR2tl?=
 =?utf-8?B?ek82dFoxdm5zcy9leGEydzh1Q2xwV1VGM2xBT3pxQUUzWDBid0x5d1JPZGdY?=
 =?utf-8?B?MmxtNWhIRDltL2xHNXZDc2tzSWN4akZjUzROV2VzYjArS3pEQ2RLcmYzNG81?=
 =?utf-8?B?bGxyNVIzREs2Vzk1b2NGMTd6dzdBQnZnanBiS0RNMGRENjJUaHA1WXhlQ1lx?=
 =?utf-8?Q?SHlBwv04XlNm11JQP8BwvCw3c?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a2949736-dcbb-460d-5083-08db7133994e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 02:11:03.1994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iioaqYwAra1FHMySMEXxbNHrCya6rNJl2FgdDa8bpKQoZU0cQVP5c7pKzDk5S0MBUU8HLLaPPqf3ZXn2jnC5yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5809
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiBGcm9tOiBCcmV0dCBDcmVlbGV5IDxiY3JlZWxleUBhbWQuY29tPg0KPiBTZW50OiBTYXR1cmRh
eSwgSnVuZSAxNywgMjAyMyAzOjAyIEFNDQo+ID4NCj4gPj4NCj4gPj4gKyNkZWZpbmUgUERTX0xN
X0RFVl9OQU1FICAgICAgICAgICAgICBQRFNfQ09SRV9EUlZfTkFNRSAiLiINCj4gPj4gUERTX0RF
Vl9UWVBFX0xNX1NUUg0KPiA+PiArDQo+ID4NCj4gPiBzaG91bGQgdGhpcyBuYW1lIGluY2x1ZGUg
YSAndmZpbycgc3RyaW5nPw0KPiANCj4gVGhpcyBhbGlnbnMgd2l0aCB3aGF0IG91ciBEU0MvZmly
bXdhcmUgZXhwZWN0cywgc28gbm8gaXQncyBub3QgbmVlZGVkLg0KDQovKioNCiAqIHBkc19jbGll
bnRfcmVnaXN0ZXIgLSBMaW5rIHRoZSBjbGllbnQgdG8gdGhlIGZpcm13YXJlDQogKiBAcGZfcGRl
djogICAgcHRyIHRvIHRoZSBQRiBkcml2ZXIgc3RydWN0DQogKiBAZGV2bmFtZTogICAgbmFtZSB0
aGF0IGluY2x1ZGVzIHNlcnZpY2UgaW50bywgZS5nLiBwZHNfY29yZS52RFBBDQoNClRoZSBjb21t
ZW50IG1lbnRpb25zIHZEUEEgd2hpY2ggY29uZnVzZWQgbWUgb24gd2hldGhlciB0aGUgY2xpZW50
DQpzaG91bGQgaW5jbHVkZSBhIGtleXdvcmQgb2YgY2xpZW50IHRvIGRpZmZlcmVudGlhdGUuDQoN
CmUuZy4gaGVyZSB0aGUgbmFtZSBpcyAicGRzX2NvcmUuTE0iLiBJZiBib3RoIFZGSU8vdkRQQSB3
YW50IHRvIHN1cHBvcnQNCmxpdmUgbWlncmF0aW9uIHdpdGggcGRzX2NvcmUgd2lsbCB0aGVyZSBi
ZSBhIGNvbmZsaWN0IG9yIGZpbmUgZm9yIG11bHRpcGxlDQpkcml2ZXJzIHJlZ2lzdGVyaW5nIHRv
IGEgc2FtZSBzZXJ2aWNlPw0K

