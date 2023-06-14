Return-Path: <netdev+bounces-10902-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6875F730ADC
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 00:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FA5028156E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058B8134B8;
	Wed, 14 Jun 2023 22:42:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B5D13AC0
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 22:42:54 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EF41715
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686782573; x=1718318573;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hJr/P0xz5up0isNKxAuErVwjuglq6ro1NjV4/JSJmg0=;
  b=PHOtnkk1fSj0WZ2i+vvcuHHg7yyg017fa+mpIQQiAqB741AOf5VGdkCm
   Ihet18PooE4Dd/iNtbSAGV3Ux6wgi83MYTRCXZ7ji2P5JGhyVLIiGO409
   Vb9Evrd7DbvuIsFBBxhkV8BB1cWlZN2iWSeknq1vW5y7mBqEbYlJlYDB8
   +Q5DW8Ikt6yqSRm/OhhGk8ZJID3dDiZnIkxVsj0JWrL0DLR1JnbanDwRX
   NyPmGXiPPlDVXMCYIaxRH/x/IK+jXG5wCs587n8uSnVy4FEeHtGm3timR
   WGZr7vwJ/KhzsWk0cJDcLRzVNbTG3HZ2fQDa+XumVcadszESfZnMrCvVF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="362128622"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="362128622"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 15:42:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="715380367"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="715380367"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 14 Jun 2023 15:42:51 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 15:42:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 15:42:50 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 15:42:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJecd1iOTT+KcH33kWS8Wd8h0vYCu7UGEQyZuA1y4N8YM+sVnHeVUAe+m3wgg6M8LmJkev/0x9zRkRk+vQQp4mQkQCEcDXUg/veJPAdjAx0eVXpBthGSZPBi261zvr8Ap00P2cXA2fPcBKa1GAVKd7MC3KSCPOiYALuWiaWFqKVKTVFD3d9KrurTWbiQ+Zt9IdXNMWSW4ipYOzeVrfIJh2/IftsQDBaRerfiIbu6jOFCpv8u+m4uTuIFM4hQXZWtzDMExB3hgcn1KOc8NxruaDq6qw/GnCksSHfuW6dBSKt/hA8AZOr7YeSMriLJlM2rYpjvdoU4XOm3JQoNgEqRWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJr/P0xz5up0isNKxAuErVwjuglq6ro1NjV4/JSJmg0=;
 b=FVn/UKKB/1UO8ES4gndZQvO6yuTrgivjAqPBfV6DzaXyyu5YdmJIo+T86Mx8KUA+XDiRECVuO1O+n3BDuGqVsMAKSvc0KICKwYhNAKprQPL0q8iPlhs9VAg+wMNNoUZ1VlHbykd5Lpoz66l1DXQF/tyxF9743RviX0gFiLuh/CZTm1L+NJsa2OaRBg2avtmZa0h9eoxiV1Oy0foZ3qK+R86eRB6++6Q8PGfs2OER5Rc3VhNGeYt5eHPeTumCTkm2gRZQjdU1kb2BspMHESur/Ozumxmp8ZLrZ2QHkIJSw+vbTesN4xQEGx5ui5EofNzHZRZttZNzzXzzdzMkhAtQ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by MW4PR11MB5774.namprd11.prod.outlook.com (2603:10b6:303:182::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Wed, 14 Jun
 2023 22:42:49 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5e37:38f7:33d2:137a]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5e37:38f7:33d2:137a%6]) with mapi id 15.20.6455.030; Wed, 14 Jun 2023
 22:42:49 +0000
From: "Ertman, David M" <david.m.ertman@intel.com>
To: Brett Creeley <bcreeley@amd.com>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>
CC: "daniel.machon@microchip.com" <daniel.machon@microchip.com>,
	"simon.horman@corigine.com" <simon.horman@corigine.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH iwl-next v4 02/10] ice: Add driver support for firmware
 changes for LAG
Thread-Topic: [PATCH iwl-next v4 02/10] ice: Add driver support for firmware
 changes for LAG
Thread-Index: AQHZmxeMU0H/mWURmECI3Vg6OeoxwK+K1uAAgAAUnRA=
Date: Wed, 14 Jun 2023 22:42:48 +0000
Message-ID: <MW5PR11MB5811013247814142055CF99EDD5AA@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20230609211626.621968-1-david.m.ertman@intel.com>
 <20230609211626.621968-3-david.m.ertman@intel.com>
 <401c13fc-9fbb-a126-f05a-6468a563404a@amd.com>
In-Reply-To: <401c13fc-9fbb-a126-f05a-6468a563404a@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|MW4PR11MB5774:EE_
x-ms-office365-filtering-correlation-id: 2018518f-e909-489d-bac5-08db6d28ae1e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XPY9LqOKNljfq5k8f10TwjgjoAwsuAPXSTIvflvqM8oJpFRYD7eAkMxTOaVa3s99ipNaZtE/Z4WKett9bnZd3XxMUq/p8zN71PYjFnwpTdSbkkWCVRzp1mLFYwV/J9L5cAyVqJnApFm1J26UcvEsbLQw1BIt13QJlkxKkI1Zj/cbxWWYehfkEnAp/QhGuDI3Si6I0cAMhQ/YZWAj/MUZXDQ3Yg2+8dxjs1qXTE1u4hmX1Je1cCf9e8w4qQ+fFSYwUeFmHZjak2fh2dDhJkwZpxs71r1jT2t+aLg2seqk1CXqDkfOc965W+McUf0iz0KihnoHorLNoWeC1Dh0CeaAhCuh9pW2Nc7IrVSfj8BbBDSQLrgN51Xl20Ji3ag9PTLnRdQ1IQC3V5YxBO0nb7hniAACeGv+NO4GWAQyd/L0oaomFoadeKoqkNk6vED8/G2Uc1ooveAIp7uqWGBx0ufSd/tHvpj7rfHLXcbJ7c1Q5f7E8KW0zx7kbfA6n44mxqa07+dGMZhe22LhYS3287ylu01PAlonWIprqWBWywql7ieaD7KlufG0epTPEFca757zEqytMJ1S0brbOlPUIdv0eerlVKFMswxodrBGDtOSS+IpY5/nW302QPrKD+715DJz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199021)(53546011)(26005)(38100700002)(41300700001)(7696005)(83380400001)(186003)(6506007)(9686003)(71200400001)(54906003)(2906002)(82960400001)(110136005)(66476007)(4326008)(122000001)(55016003)(478600001)(66556008)(66446008)(316002)(64756008)(66946007)(52536014)(8936002)(76116006)(5660300002)(8676002)(38070700005)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDBGRGhqaGRScFl5YXh0QkdKZ3VmRWl4TldKTE1ZSE0xVWRUL0liK0xsbmpv?=
 =?utf-8?B?R1R6L3NBQVZKeHN5aGt6U3E5bzJuZ1Y3ZGtmTExrRjZkTXZaYzJJWkY2ZXE0?=
 =?utf-8?B?TXRUcXkyeXNMaVVwMlJPTUV1RFNybUE4M05ZU2hhMUFHRXVWdmV6RjdkUTQ5?=
 =?utf-8?B?eVNIdXViMXNlb0d1Uzg0WjBuZGszQXFTak11WHNPUzVtQTFxOUNPaDF4SlZR?=
 =?utf-8?B?R3BwblM4N05JK25NUGdTNGFjT0x0aVVoSy9KUkJWNzZSK0trNkg4T2NqNU1J?=
 =?utf-8?B?N09ZRVd1VXpsZWJISFZRWUd5TnE5U1hzcyttRjlrS1J6STRsaEtlVDZRY3hJ?=
 =?utf-8?B?VWVIdW42TjJQdTN2ODgrRWdLMGNiOElIRHc2R24reHRXL3FqNEVlUFVVekJP?=
 =?utf-8?B?b3E1akFwRTVYQzVKKzdYSUhscWZ5eDNtcUhacXpCSG9FSjBxQXBtcjFRTEdo?=
 =?utf-8?B?cDdXMGpNYnphd1NYdjRrL3BmSjNaUmltNytkVlNCN21LRXRUUEVhZWxGNEF5?=
 =?utf-8?B?dS94T1pqRHlCNWJ0RitNZ2tTTXVTcWxaeWZLdFVQRVRkdW8zSDBVRFVMSlFJ?=
 =?utf-8?B?Y1ZJMEtxYXNLVnQyNnBaMzRhR2wzQVdRVXJUMkFRYkV3RmZydjFOUWpRSkFa?=
 =?utf-8?B?bmY5bHJCeWhFRm9CMy9CTEtsWkNaT3dpQ0szYmVHT1VvRytuOG1JUER6VSs0?=
 =?utf-8?B?T0xrK0J0WnVURDVHcCtFdDg3b0tYeHI2Rk5TU05wdnJacGowTjBDNU5YU2ZY?=
 =?utf-8?B?YUZ6RGtwTEdod2hIaVJONnQ0L1FLZmlyNlRoc1JQUkVxZWkrZE9iNzljOS8x?=
 =?utf-8?B?U3ZYWVNZQW1mNURacW9mTS9wakd3L1JiSDJxVVRPb1NtUmE1K1dXT000aith?=
 =?utf-8?B?bUVtb1ZydUhyc2VlUzZranloYnVsN1dSZStYRVIySDY3c1FxYXVxb3BvT3R4?=
 =?utf-8?B?R1RNNTZMaVE3TEp4cHAwZEdjK3FVQkJSVC9VZks3MmZ2TDR3NDJQWVFwNHRt?=
 =?utf-8?B?aXQzTm1YQWlPdG8vQzBZZytMaE5uMGhlZ2VMZnk2WjFsODdaaHlCOUhDQk1Z?=
 =?utf-8?B?d3B1L1VGNjZjV2RrQTlXcUpHVmNCYWNFNzh4SkM3c1FIK2NwOTZVRzh1MGpX?=
 =?utf-8?B?NERnNythM0xWai9COGU5Z0dtWlNCaDAxNDdVMW4vNSs0RzI1RU0xY01ORWdX?=
 =?utf-8?B?OW8zWmFFdURmd3l2aG91Vk1NL2JKSVgyMlFNQWMwK2ZhZmlZbWlObnNmL0p0?=
 =?utf-8?B?QWo3TktZT0hEKzhDVk1GNmdnaHl0QkhUdFlocGdqRjZGT2RHcUtkUlMzVDUx?=
 =?utf-8?B?dTdzR2htaWhQbFhmOXI5ekFsUTR1NzRocFRYSTByMkdJU1FkRnlPZmhORUhG?=
 =?utf-8?B?cmtuNnFSV0c4cEpWbU8wdktWMzdrTkMxeENVZytpNXZVSDNRS21VWmdwRXIv?=
 =?utf-8?B?bUQzY1RCSXlZZEU3YmFiMXBrOHI2Rk5BNzh2dWwrRE9JZ2FxMU1YRkpLc0ZO?=
 =?utf-8?B?QU9XNS8ySHFHVjU2UXg3T25NNmhEaExPM0VsWUZ6QWlieTM5VlVhYUdtWFJV?=
 =?utf-8?B?OENTTS9EYm5WVk1kc0tnZ1lOSGpEeUR4R3FxSFhDbDVoa3NBeG5nY0VMdDl3?=
 =?utf-8?B?eHZJWEVCYnhWa2t2NWVQcThFQzlKaHB3RTQwZWpoZGxtRzlzNWpjSXhlV2U3?=
 =?utf-8?B?NDhnSDVpUDIvaUNkZGNFYVNRMHpLQmxPSG5NMXVsVHN0QVllRS9jdXFvd2Ey?=
 =?utf-8?B?S1BWZTlzZDZKMDBqWXIrZUdrenVERHlHTWJBK2ljU3liUTFMZEF5cXY0Mkc1?=
 =?utf-8?B?ejVESzV6aTJmVWRXNUZLWUIvd2pmMzNlLzBBK1B5M1BIdzdCcUtuWExvQmk5?=
 =?utf-8?B?OC80bURhTU81U3lGakUzVkhSd092SkcyT2lqV3Y3K1czMEtQZ1YwYWt0dWgv?=
 =?utf-8?B?NUJZZnRzeWNYdFlwemM0cGdVMjhtTFBjUjdBcTZiZWR3RW02YVhiVkhpenVJ?=
 =?utf-8?B?MGF0OXBiR0E5dHpVcGxuYkJJYnF1aEhZalVvSnZZelJuTEIxTDNMN1lnMlRI?=
 =?utf-8?B?VWI4ZE5FZU1vTWUxbktIUTU2cDhHbmdGS2xEd0JzZ1lDZktCanZ5NkU3eHJq?=
 =?utf-8?Q?CdiM9RALdHkXc20v/qcDeK2S+?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2018518f-e909-489d-bac5-08db6d28ae1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 22:42:48.9888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Sj2iuywBz3zw7R2nSnkXwhP22KD1b5/3xP5vu3lD89rGtXoldJcWBa3clXaqtpriDLDZsIBQCHn1a5Z5FQjl3zsfxVPY9GpTHyBJa+7bdc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5774
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCcmV0dCBDcmVlbGV5IDxiY3Jl
ZWxleUBhbWQuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIEp1bmUgMTQsIDIwMjMgMjoyNCBQTQ0K
PiBUbzogRXJ0bWFuLCBEYXZpZCBNIDxkYXZpZC5tLmVydG1hbkBpbnRlbC5jb20+OyBpbnRlbC13
aXJlZC0NCj4gbGFuQGxpc3RzLm9zdW9zbC5vcmcNCj4gQ2M6IGRhbmllbC5tYWNob25AbWljcm9j
aGlwLmNvbTsgc2ltb24uaG9ybWFuQGNvcmlnaW5lLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGl3bC1uZXh0IHY0IDAyLzEwXSBpY2U6IEFkZCBk
cml2ZXIgc3VwcG9ydCBmb3IgZmlybXdhcmUNCj4gY2hhbmdlcyBmb3IgTEFHDQo+IA0KPiBPbiA2
LzkvMjAyMyAyOjE2IFBNLCBEYXZlIEVydG1hbiB3cm90ZToNCj4gPiBDYXV0aW9uOiBUaGlzIG1l
c3NhZ2Ugb3JpZ2luYXRlZCBmcm9tIGFuIEV4dGVybmFsIFNvdXJjZS4gVXNlIHByb3Blcg0KPiBj
YXV0aW9uIHdoZW4gb3BlbmluZyBhdHRhY2htZW50cywgY2xpY2tpbmcgbGlua3MsIG9yIHJlc3Bv
bmRpbmcuDQo+ID4NCj4gPg0KPiA+IEFkZCB0aGUgZGVmaW5lcywgZmllbGRzLCBhbmQgZGV0ZWN0
aW9uIGNvZGUgZm9yIEZXIHN1cHBvcnQgb2YgTEFHIGZvcg0KPiA+IFNSSU9WLiAgQWxzbyBleHBv
c2VzIHNvbWUgcHJldmlvdXNseSBzdGF0aWMgZnVuY3Rpb25zIHRvIGFsbG93IGFjY2Vzcw0KPiA+
IGluIHRoZSBsYWcgY29kZS4NCj4gPg0KPiA+IENsZWFuIHVwIGNvZGUgdGhhdCBpcyB1bnVzZWQg
b3Igbm90IG5lZWRlZCBmb3IgTEFHIHN1cHBvcnQuICBBbHNvIGFkZA0KPiA+IGFuIG9yZGVyZWQg
d29ya3F1ZXVlIGZvciBwcm9jZXNzaW5nIExBRyBldmVudHMuDQo+ID4NCj4gPiBSZXZpZXdlZC1i
eTogRGFuaWVsIE1hY2hvbiA8ZGFuaWVsLm1hY2hvbkBtaWNyb2NoaXAuY29tPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IERhdmUgRXJ0bWFuIDxkYXZpZC5tLmVydG1hbkBpbnRlbC5jb20+DQoNCi4uLg0K
DQo+ID4gKy8qKg0KPiA+ICsgKiBpY2VfbGFnX2NoZWNrX252bV9zdXBwb3J0IC0gQ2hlY2sgZm9y
IE5WTSBzdXBwb3J0IGZvciBMQUcNCj4gPiArICogQHBmOiBQRiBzdHJ1Y3QNCj4gPiArICovDQo+
ID4gK3N0YXRpYyB2b2lkIGljZV9sYWdfY2hlY2tfbnZtX3N1cHBvcnQoc3RydWN0IGljZV9wZiAq
cGYpDQo+IA0KPiBOaXQsIGJ1dCB0aGlzIG5hbWUgaXMgYSBiaXQgbWlzbGVhZGluZyB0byBtZS4g
SSB3b3VsZCBleHBlY3QgaXQgdG8gYmUNCj4gY2FsbGVkIHNvbWV0aGluZyBsaWtlICJpY2VfbGFn
X2luaXRfZmVhdHVyZV9zdXBwb3J0X2ZsYWcoKSIgb3Igc29tZXRoaW5nDQo+IHNpbWlsYXIgdGhh
dCBiZXR0ZXIgZGVzY3JpYmVzIHdoYXQgdGhlIGZ1bmN0aW9uIGlzIGRvaW5nLg0KDQpOYW1lIGNo
YW5nZWQNCg0KPiANCj4gPiArew0KPiA+ICsgICAgICAgc3RydWN0IGljZV9od19kZXZfY2FwcyAq
Y2FwczsNCj4gPiArDQo+ID4gKyAgICAgICBjYXBzID0gJnBmLT5ody5kZXZfY2FwczsNCj4gDQo+
IE5pdCwgYnV0IHNpbmNlIHlvdSBhcmUgYWxyZWFkeSBjcmVhdGluZyBhIGxvY2FsIHZhcmlhYmxl
IHlvdSBjb3VsZCBnbw0KPiBvbmUgbGV2ZWwgZnVydGhlciB0byB0aGUgY29tbW9uX2NhcCwgc28g
aXQgY291bGQgYmU6DQo+IA0KPiBjb21tb25fY2FwLT5yb2NlX2xhZyBhbmQgY29tbW9uX2NhcC0+
c3Jpb3ZfbGFnDQoNClZhcmlhYmxlIGNoYW5nZWQgdG8gZ28gZG93biBvbmUgbW9yIGxldmVsLg0K
DQpDaGFuZ2VzIHRvIGNvbWUgb3V0IGluIHY1DQpEYXZlRQ0KPiANCj4gPiArICAgICAgIGlmIChj
YXBzLT5jb21tb25fY2FwLnJvY2VfbGFnKQ0KPiA+ICsgICAgICAgICAgICAgICBpY2Vfc2V0X2Zl
YXR1cmVfc3VwcG9ydChwZiwgSUNFX0ZfUk9DRV9MQUcpOw0KPiA+ICsgICAgICAgZWxzZQ0KPiA+
ICsgICAgICAgICAgICAgICBpY2VfY2xlYXJfZmVhdHVyZV9zdXBwb3J0KHBmLCBJQ0VfRl9ST0NF
X0xBRyk7DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKGNhcHMtPmNvbW1vbl9jYXAuc3Jpb3ZfbGFn
KQ0KPiA+ICsgICAgICAgICAgICAgICBpY2Vfc2V0X2ZlYXR1cmVfc3VwcG9ydChwZiwgSUNFX0Zf
U1JJT1ZfTEFHKTsNCj4gPiArICAgICAgIGVsc2UNCj4gPiArICAgICAgICAgICAgICAgaWNlX2Ns
ZWFyX2ZlYXR1cmVfc3VwcG9ydChwZiwgSUNFX0ZfU1JJT1ZfTEFHKTsNCj4gPiArfQ0KPiA+ICsN
Cj4gDQo+IFsuLi5dDQo+IA0KDQo=

