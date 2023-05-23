Return-Path: <netdev+bounces-4611-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58E2070D8CD
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:21:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E233A2812FD
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C789B1E50C;
	Tue, 23 May 2023 09:21:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29F21D2A8
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:21:00 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3D6118
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684833658; x=1716369658;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ay2aHU+IW86rhCe1Uf3EKMa1gUDEq1X2srr3YZDMLMQ=;
  b=NT7d9kAjPPdEwPWbmiIhbc66iyblupW0Etk2qHml6gY3wywUUc1+/5qb
   TRQGA+mmjIffINkvd7FiZ26myTTIDI00kZDeDrbebvuZHbP1wNsfGj3xQ
   ZBGLDrr3NvDpfRrkgS/Of2eUlAqcigK3U1zCUikeCtaY4jNvZt23SAkfl
   asQc2gV6QwDJEnhUBDN8NqBQBqzle26k6EWqlaaTHe1vVSBUubPjrbVGV
   rqOKdqxJjgCTHrD/bkot2hrGcyQeHY0as0M5mAg7+RMYSBOPnBJv++cgO
   gS6f0R2r32Mitatfx9pRGxPDm/Ld7qdeZQEibMexQramROKsce6abZOkz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="439540006"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="439540006"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 02:20:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="681319233"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="681319233"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 23 May 2023 02:20:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 02:20:44 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 02:20:44 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 02:20:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnkjTMcoCCa/eSkI7k3BsaJMGwE96UGPqwNoPmhSCc5leAC0cQCHZ/r/+NZFt7o8NnzSOJvejy7vEQEj0qjFSz+zqqPNDri85k20DvoacLT01soNsTdIg3ml0kmY0gC1WegOWaCHodqe+XCgiq6dLktA/AsvaaO4s90Ldpep55kyxeeHuTKSAdk7GcYUQK0M9jyJdt6jxWzL3RFxu/TmgP5+1ZQ7tGab94A8tDSJMBOwgWZeEwHawRcL6JbVJI9GeC/eD1zAlk+QG2zatcU1B9KCqIscVGRQvoYMI6c8YB1dWsDXx1HXIKdLa/iU2p/8Wc74qMjr93/z3OOkyJJMIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ay2aHU+IW86rhCe1Uf3EKMa1gUDEq1X2srr3YZDMLMQ=;
 b=NmXH6e41oYzYRUVegyZj5I12+6FWqBce0a9js9GRFVuHLpPTElXaW7b9SNSZFQtp5ubmefC7r648jm1c0P5yUIky3X9cC9nKf3rkBE33fed2hubc6bNoaEWOwpd6LJAQNJhKKK9S8Id7cLW6LcaPM2zSh1PmAk8bT/OuEx2EoOX+XEa6xQFdNmDC9dbLlgtZ6qvlnAhcVXuJnHiDE5Kg+owuEtPOAhW+l5mBhWC2rQ32+4knPsIKgQ+07goEBM1/KFBcIVb8+GFNxD09fNnSBApunn58OsAKboeM26u4gDK/BKOIzujHOSWvn0BEPEKWihnEkeO5EP3gV2DdJ5YN/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by DS0PR11MB8161.namprd11.prod.outlook.com (2603:10b6:8:164::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 09:20:42 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 09:20:42 +0000
From: "Drewek, Wojciech" <wojciech.drewek@intel.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v3 01/10] ice: Minor switchdev
 fixes
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v3 01/10] ice: Minor switchdev
 fixes
Thread-Index: AQHZjI0EGyWW2t78cE6w7smxd/1w0a9mENaAgAF+ROA=
Date: Tue, 23 May 2023 09:20:42 +0000
Message-ID: <MW4PR11MB5776899A9A1FDC0B1438201EFD409@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230522090542.45679-1-wojciech.drewek@intel.com>
 <20230522090542.45679-2-wojciech.drewek@intel.com>
 <2b4f07b4-607f-126c-1eaa-5bdac701d831@molgen.mpg.de>
In-Reply-To: <2b4f07b4-607f-126c-1eaa-5bdac701d831@molgen.mpg.de>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|DS0PR11MB8161:EE_
x-ms-office365-filtering-correlation-id: c350e1e2-7845-435b-40c7-08db5b6efb6c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ByieadaA2bSHdwSE8Bg2bvHk8qggYWCaAw9Xiv1wzay79BTuTkfbo6E+ZR5gM6H6BH2khejmgUXEDKm4+FyHH/WeVg+W9fa1WcHrbJdPsUTsGME5uoZjnc+66SOvmntn0AgNTnaaN20WD8YjKgakl2LC44sL5z1v6X+DqCMVuR/J+O7FKmd0Kw5cOpcbnxiLX1ZU3Fqg3jFC4mz+e2/Mw4KTAUBXVVQWDRXuNcKHSYuPMoa4qwJ4FRoY0jdFqexYY1tIDglQMtaW8o1R/+bWE8IhzG+1Ty0vH87TPi9QGeYoqOU3mQ8zpHa1fP94xmuIly5AkZoUujVpBFa2Q6fI/4w4cjSyEyajKhBvOD4zm9wjsNE1g9BGjWrAkwwUaGfbNJnR3xGRSFJvcowGCUuuxFzYAAAuASE9Y7z/osjY7fdjv17YZ7xWEtmODVlg6KnPehysD+ofbs66IuFn+XZDINRkP7Wtv6NR2nokipgFccf37i7McetA04qPbVq6cWrj8H85fguLIKVJNbA3XDwe8MQ/9qmHC2mSYXjXKDa3F7ROxX+WzH/zmyesT9X/AoLp+bwDpcUo2Yo2vKXJk46CDWLA09E5hii/FLxwTIGxp52wQC9lkFktzQFQiQ/hisyj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199021)(2906002)(52536014)(5660300002)(53546011)(9686003)(186003)(122000001)(82960400001)(38070700005)(86362001)(26005)(6506007)(38100700002)(83380400001)(66574015)(8676002)(8936002)(71200400001)(7696005)(478600001)(33656002)(55016003)(4326008)(6916009)(66446008)(66556008)(66946007)(76116006)(66476007)(41300700001)(64756008)(316002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NU5vUXBhWEV2UjNieHE1Q3g3M25QMzZGSC9OYWxQTG5pa3NTd1RqTXEzV2tO?=
 =?utf-8?B?R3lQK2gxMTdtQlRuOTZWNUlsVDFlUXc4cEJWOTBxZXFuT1JHcUR5RHo3c05k?=
 =?utf-8?B?aVVFUXlmUXI1RWhtQjNOSzhYcDBkOUcyakpNZFcyWGdhRGo4bmxOZ3YzNFIx?=
 =?utf-8?B?TGZVczBwVE1xaFI4c0E4WFAxdVhrdG1uTUVkRitKejJNU1lhRHgvWlFlSG1T?=
 =?utf-8?B?TWw1dlVsL1FRUVBXR3ZCbUVSZ29YMnBTL3ZuSTJWY09SY3ArRjhBb1pEdTZj?=
 =?utf-8?B?ZEVHTCs1cmJ3Y05ZZS96ZlpxMkd2c2RiZkFVK1NYaXVHMU1udy9sUzJsdWNJ?=
 =?utf-8?B?cUVBdE5XeGJRdlV4a2VPZ2tpZEJNL2QwK1JjQmw5eFZjVDBsTXUwWEJEdGJV?=
 =?utf-8?B?cE81TUEydDVxTTFBVys4Z3pqeEpmK3VXQVkzcm5NTmNSblh4ZHdwbEdHc3F5?=
 =?utf-8?B?ZmtvMTF4Um9YcjdMRVMxL3BuZHYzdVZqRW9KWkE1Mi84NzExaHdsQUxObTVV?=
 =?utf-8?B?eXVwaytxaEpQbUVDNTlOUnBhdXZZQ0R0cCttb0x2cTZ1a013TXJrZ2cwMFZW?=
 =?utf-8?B?Z3VERTd1bWpOWFlJZXg3RVQyUXU0eVpzVHo1L3JmSHJiYnVtN0szbFljVkox?=
 =?utf-8?B?ejJxUTczNDk3OVVlYVpXelBQMlJ3YWdLZHMrL0tVT3Q1Rzg0Tnl3cXVGMEpr?=
 =?utf-8?B?UXpwaVNtN0l2Qk1kY0s0ZlgvRzRCWjBlNTR2UHk2a29iK2ttRG5JaXlQcjc2?=
 =?utf-8?B?YXJVY1NFekRDNzBPRXNjZEJFQjhDRjFBUUo1U0J2LzZpdFpTaW5tTVpHRzVw?=
 =?utf-8?B?bDY3N0lYTDJ3Yi9VRTVUM1F6bWlyKzZ4MmxTMUdEM3BHMnNYbTcyVFFOVjRN?=
 =?utf-8?B?cXpla2VDcy94Q1ljRVJOTVUrU25GdG9OMFdsNHhtUTR0N0VpZ1VRbGtpWXZE?=
 =?utf-8?B?UTFkU21QNE5FVnVSeW1vV3QydlFWby9LM0M3UlNZcnQrcGNRcFdwczhqNCt1?=
 =?utf-8?B?cjFNcW1IUDZEa1EydzJiYmpRZnp3TUZTV0ZMVHZ1ajhIcmk0bFYwZzRtV1VH?=
 =?utf-8?B?V1R3bXd5RVpyYTQzR1hsazVlOWZmOG5WRloyd05IMFlZQWFwN21JWmF2eDR0?=
 =?utf-8?B?cEM5c3ZkdHEvdXUvTUVrL2xjK3d2dGVDcUtOa0FEVml5d08wTFpEU0dNNkwr?=
 =?utf-8?B?VWF5T1d0ZVFhMnhsSnRXSVhvY1EvTXZhaDBVa0orL3lBa3h1WXlGeWlwcnZG?=
 =?utf-8?B?WnF1RW9aN3UrWDJFaFZTUHVubkdlT2FCaDVrbUlXUk40Ti9SZXJCd1NjMkdG?=
 =?utf-8?B?MC9CY3lUZ2JZYTF6THplRG0xcUVwUExJcVZQclRxVnlSM1VIa0s0YzR5L1pv?=
 =?utf-8?B?WWJscldJQ0JCa1o1aHF0T0JmcVVIWFdVWmhHMk9XV2NFSytYWXJOU1lGUmwr?=
 =?utf-8?B?bERIak1OeWpkVGYwM2dSZjBRVXRXcHBhQVdENWxwdk5rRm5odE5FaW14MW5n?=
 =?utf-8?B?MC9LRE11dmlSSzgxcy90YWRkcU10b2N6eGE5c3pNTlA2RTRQYytJbXFxWndI?=
 =?utf-8?B?TDRITDVMUkZyNlJoL1R3UUZlVGpYai91ZitkVlJmVlRZNE9qcVVFSC92SVZW?=
 =?utf-8?B?TzQ0Y1g2VG1xS0hZL3RabnNYNUIvVS8vbXdBQ1lMejMzV1EvdlNRaVFsa1Zl?=
 =?utf-8?B?YlNXaDY4T0doYXM1b2hVcU9wVy8ramtpdnpYRDRqOGQwc3Nyc2UyRmdsVDZN?=
 =?utf-8?B?NjdsYkNxdlFRVElUQ3h4USs1RHB3UVFOWDhCYUtPNmVnbVlLTFo3akhDNWFz?=
 =?utf-8?B?dFh2Z0ViVGcwL0g4KzJubHI2bnh0dDE2ZlpHQmx5eEhlWVJ2QThZNlZBWHQy?=
 =?utf-8?B?ZXdZMFgwMU92TFI2OCtqckV1OTFaQk9ISjFnSVRKQ3NzVExCTjBlRGlOb3Fz?=
 =?utf-8?B?YnhkTUpOU3cwUkdnUXQzTHkvbFVtdTI1T3VZTEJBTStZVFVveVdjZHRYM0VE?=
 =?utf-8?B?SnNQU082OWNaN3dFTVB4cjVLRUJzbFNkbkVQQkQ4QmdYUmh4VCt6YU5SWkt5?=
 =?utf-8?B?Uk1haERDSFlqVkZWTWczb1FXdkx4SnphT2EyU0oybFBTZHlJMWc4OTdtNlA1?=
 =?utf-8?Q?nXTwyc0H4rgGvRtAT6Q43nArD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c350e1e2-7845-435b-40c7-08db5b6efb6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 09:20:42.5578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KHPD22ME+akFfXK24c25WoTGgRmNpTH0dx53+Yhyo5WvcI9ye/q0VevfwOKQApAk79aRYLvUrtH6IjOwM8b9nVnz255jf0mjIL6VvY7wY5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8161
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGF1bCBNZW56ZWwgPHBt
ZW56ZWxAbW9sZ2VuLm1wZy5kZT4NCj4gU2VudDogcG9uaWVkemlhxYJlaywgMjIgbWFqYSAyMDIz
IDEyOjA2DQo+IFRvOiBEcmV3ZWssIFdvamNpZWNoIDx3b2pjaWVjaC5kcmV3ZWtAaW50ZWwuY29t
Pg0KPiBDYzogaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtJbnRlbC13aXJlZC1sYW5dIFtQQVRDSCBpd2wtbmV4
dCB2MyAwMS8xMF0gaWNlOiBNaW5vciBzd2l0Y2hkZXYgZml4ZXMNCj4gDQo+IERlYXIgV29qY2ll
Y2gsDQo+IA0KPiANCj4gVGhhbmsgeW91IGZvciB5b3VyIHBhdGNoZXMuDQoNClRoYW5rcyBmb3Ig
cmV2aWV3IFBhdWwhDQoNCj4gDQo+IEFtIDIyLjA1LjIzIHVtIDExOjA1IHNjaHJpZWIgV29qY2ll
Y2ggRHJld2VrOg0KPiA+IEludHJvZHVjZSBhIGZldyBmaXhlcyB0aGF0IGFyZSBuZWVkZWQgZm9y
IGJyaWRnZSBvZmZsb2FkDQo+ID4gdG8gd29yayBwcm9wZXJseS4NCj4gPg0KPiA+IC0gU2tpcCBh
ZHYgcnVsZSByZW1vdmFsIGluIGljZV9lc3dpdGNoX2Rpc2FibGVfc3dpdGNoZGV2Lg0KPiA+ICAg
IEFkdmFuY2VkIHJ1bGVzIGZvciBjdHJsIFZTSSB3aWxsIGJlIHJlbW92ZWQgYW55d2F5IHdoZW4g
dGhlDQo+ID4gICAgVlNJIHdpbGwgY2xlYW5lZCB1cCwgbm8gbmVlZCB0byBkbyBpdCBleHBsaWNp
dGx5Lg0KPiA+DQo+ID4gLSBEb24ndCBhbGxvdyB0byBjaGFuZ2UgcHJvbWlzYyBtb2RlIGluIHN3
aXRjaGRldiBtb2RlLg0KPiA+ICAgIFdoZW4gc3dpdGNoZGV2IGlzIGNvbmZpZ3VyZWQsIFBGIG5l
dGRldiBpcyBzZXQgdG8gYmUgYQ0KPiA+ICAgIGRlZmF1bHQgVlNJLiBUaGlzIGlzIG5lZWRlZCBm
b3IgdGhlIHNsb3ctcGF0aCB0byB3b3JrIGNvcnJlY3RseS4NCj4gPiAgICBBbGwgdGhlIHVubWF0
Y2hlZCBwYWNrZXRzIHdpbGwgYmUgZGlyZWN0ZWQgdG8gUEYgbmV0ZGV2Lg0KPiA+DQo+ID4gICAg
SXQgaXMgcG9zc2libGUgdGhhdCB0aGlzIHNldHRpbmcgbWlnaHQgYmUgb3ZlcndyaXR0ZW4gYnkN
Cj4gPiAgICBuZG9fc2V0X3J4X21vZGUuIFByZXZlbnQgdGhpcyBieSBjaGVja2luZyBpZiBzd2l0
Y2hkZXYgaXMNCj4gPiAgICBlbmFibGVkIGluIGljZV9zZXRfcnhfbW9kZS4NCj4gPg0KPiA+IC0g
RGlzYWJsZSB2bGFuIHBydW5pbmcgZm9yIHVwbGluayBWU0kuIEluIHN3aXRjaGRldiBtb2RlLCB1
cGxpbmsgVlNJDQo+ID4gICAgaXMgY29uZmlndXJlZCB0byBiZSBkZWZhdWx0IFZTSSB3aGljaCBt
ZWFucyBpdCB3aWxsIHJlY2VpdmUgYWxsDQo+ID4gICAgdW5tYXRjaGVkIHBhY2tldHMuIEluIG9y
ZGVyIHRvIHJlY2VpdmUgdmxhbiBwYWNrZXRzIHdlIG5lZWQgdG8NCj4gPiAgICBkaXNhYmxlIHZs
YW4gcHJ1bmluZyBhcyB3ZWxsLiBUaGlzIGlzIGRvbmUgYnkgZGlzX3J4X2ZpbHRlcmluZw0KPiA+
ICAgIHZsYW4gb3AuDQo+ID4NCj4gPiAtIFRoZXJlIGlzIHBvc3NpYmlsaXR5IHRoYXQgaWNlX2Vz
d2l0Y2hfcG9ydF9zdGFydF94bWl0IG1pZ2h0IGJlDQo+ID4gICAgY2FsbGVkIHdoaWxlIHNvbWUg
cmVzb3VyY2VzIGFyZSBzdGlsbCBub3QgYWxsb2NhdGVkIHdoaWNoIG1pZ2h0DQo+ID4gICAgY2F1
c2UgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlLiBGaXggdGhpcyBieSBjaGVja2luZyBpZiBzd2l0
Y2hkZXYNCj4gPiAgICBjb25maWd1cmF0aW9uIHdhcyBmaW5pc2hlZC4NCj4gDQo+IElmIHlvdSBl
bnVtZXJhdGUvbGlzdCBjaGFuZ2VzIGluIGEgY29tbWl0IG1lc3NhZ2UsIGl04oCZcyBhIGdvb2Qg
aW5kaWNhdG9yDQo+IHRvIG1ha2Ugb25lIHBhdGNoL2NvbW1pdCBmb3IgZWFjaCBpdGVtLiA7LSkg
RG9pbmcgdGhpcyBhbHNvIG1ha2VzIGl0DQo+IGVhc2llciB0byB1c2UgYSBzdGF0ZW1lbnQgYXMg
dGhlIGNvbW1pdCBtZXNzYWdlIHN1bW1hcnksIHRoYXQgbWVhbnMNCj4gdXNpbmcgYSB2ZXJiIChp
biBpbXBlcmF0aXZlIG1vb2QpIOKAkyBGaXggbWlub3Igc3dpdGNoZGV2IHRoaW5ncyDigJMgYW5k
DQo+IG1ha2luZyBgZ2l0IGxvZyAtLW9uZWxpbmVgKSBtb3JlIHVzZWZ1bC4gU21hbGxlciBjb21t
aXRzIGFyZSBhbHNvIGVhc2llcg0KPiB0byByZXZlcnQgb3IgdG8gYmFja3BvcnQuDQoNCk9yaWdp
bmFsbHkgdGhpcyBwYXRjaHNldCBoYWQgMTIgcGF0Y2hlcyBzbyBkaWRuJ3Qgd2FudCB0byBoYXZl
IHRvIG1hbnkNCnBhdGNoZXMgaW4gaXQuIEkgYWdyZWUgdGhhdCB0aGlzIHBhdGNoIHNob3VsZCBi
ZSBzcGxpdHRlZCwgc2luY2UgdHdvIG9mIHRoZW0gd2VyZSBkcm9wcGVkLA0KDQo+IA0KPiA+IFNp
Z25lZC1vZmYtYnk6IFdvamNpZWNoIERyZXdlayA8d29qY2llY2guZHJld2VrQGludGVsLmNvbT4N
Cj4gPiAtLS0NCj4gPiB2MjogZW5jbG9zZSBiaXRvcHMgaW50byBzZXBhcmF0ZSBzZXQgb2YgYnJh
Y2VzLCBtb3ZlDQo+ID4gICAgICBpY2VfaXNfc3dpdGNoZGV2X3J1bm5pbmcgY2hlY2sgdG8gaWNl
X3NldF9yeF9tb2RlDQo+ID4gICAgICBmcm9tIGljZV92c2lfc3luY19mbHRyDQo+ID4gLS0tDQo+
ID4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2Vzd2l0Y2guYyB8IDE0ICsr
KysrKysrKysrKystDQo+ID4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX21h
aW4uYyAgICB8ICA0ICsrLS0NCj4gPiAgIDIgZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9pY2UvaWNlX2Vzd2l0Y2guYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2ljZS9pY2VfZXN3aXRjaC5jDQo+ID4gaW5kZXggYWQwYTAwN2I3Mzk4Li5iZmQwMDMxMzVmYzgg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9lc3dp
dGNoLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2Vzd2l0
Y2guYw0KPiA+IEBAIC0xMDMsNiArMTAzLDEwIEBAIHN0YXRpYyBpbnQgaWNlX2Vzd2l0Y2hfc2V0
dXBfZW52KHN0cnVjdCBpY2VfcGYgKnBmKQ0KPiA+ICAgCQlydWxlX2FkZGVkID0gdHJ1ZTsNCj4g
PiAgIAl9DQo+ID4NCj4gPiArCXZsYW5fb3BzID0gaWNlX2dldF9jb21wYXRfdnNpX3ZsYW5fb3Bz
KHVwbGlua192c2kpOw0KPiA+ICsJaWYgKHZsYW5fb3BzLT5kaXNfcnhfZmlsdGVyaW5nKHVwbGlu
a192c2kpKQ0KPiA+ICsJCWdvdG8gZXJyX2Rpc19yeDsNCj4gPiArDQo+ID4gICAJaWYgKGljZV92
c2lfdXBkYXRlX3NlY3VyaXR5KHVwbGlua192c2ksIGljZV92c2lfY3R4X3NldF9hbGxvd19vdmVy
cmlkZSkpDQo+ID4gICAJCWdvdG8gZXJyX292ZXJyaWRlX3VwbGluazsNCj4gPg0KPiA+IEBAIC0x
MTQsNiArMTE4LDggQEAgc3RhdGljIGludCBpY2VfZXN3aXRjaF9zZXR1cF9lbnYoc3RydWN0IGlj
ZV9wZiAqcGYpDQo+ID4gICBlcnJfb3ZlcnJpZGVfY29udHJvbDoNCj4gPiAgIAlpY2VfdnNpX3Vw
ZGF0ZV9zZWN1cml0eSh1cGxpbmtfdnNpLCBpY2VfdnNpX2N0eF9jbGVhcl9hbGxvd19vdmVycmlk
ZSk7DQo+ID4gICBlcnJfb3ZlcnJpZGVfdXBsaW5rOg0KPiA+ICsJdmxhbl9vcHMtPmVuYV9yeF9m
aWx0ZXJpbmcodXBsaW5rX3ZzaSk7DQo+ID4gK2Vycl9kaXNfcng6DQo+ID4gICAJaWYgKHJ1bGVf
YWRkZWQpDQo+ID4gICAJCWljZV9jbGVhcl9kZmx0X3ZzaSh1cGxpbmtfdnNpKTsNCj4gPiAgIGVy
cl9kZWZfcng6DQo+ID4gQEAgLTMzMSw2ICszMzcsOSBAQCBpY2VfZXN3aXRjaF9wb3J0X3N0YXJ0
X3htaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldikNCj4g
PiAgIAlucCA9IG5ldGRldl9wcml2KG5ldGRldik7DQo+ID4gICAJdnNpID0gbnAtPnZzaTsNCj4g
Pg0KPiA+ICsJaWYgKCF2c2kgfHwgIWljZV9pc19zd2l0Y2hkZXZfcnVubmluZyh2c2ktPmJhY2sp
KQ0KPiA+ICsJCXJldHVybiBORVRERVZfVFhfQlVTWTsNCj4gPiArDQo+ID4gICAJaWYgKGljZV9p
c19yZXNldF9pbl9wcm9ncmVzcyh2c2ktPmJhY2stPnN0YXRlKSB8fA0KPiA+ICAgCSAgICB0ZXN0
X2JpdChJQ0VfVkZfRElTLCB2c2ktPmJhY2stPnN0YXRlKSkNCj4gPiAgIAkJcmV0dXJuIE5FVERF
Vl9UWF9CVVNZOw0KPiA+IEBAIC0zNzgsOSArMzg3LDEzIEBAIHN0YXRpYyB2b2lkIGljZV9lc3dp
dGNoX3JlbGVhc2VfZW52KHN0cnVjdCBpY2VfcGYgKnBmKQ0KPiA+ICAgew0KPiA+ICAgCXN0cnVj
dCBpY2VfdnNpICp1cGxpbmtfdnNpID0gcGYtPnN3aXRjaGRldi51cGxpbmtfdnNpOw0KPiA+ICAg
CXN0cnVjdCBpY2VfdnNpICpjdHJsX3ZzaSA9IHBmLT5zd2l0Y2hkZXYuY29udHJvbF92c2k7DQo+
ID4gKwlzdHJ1Y3QgaWNlX3ZzaV92bGFuX29wcyAqdmxhbl9vcHM7DQo+ID4gKw0KPiA+ICsJdmxh
bl9vcHMgPSBpY2VfZ2V0X2NvbXBhdF92c2lfdmxhbl9vcHModXBsaW5rX3ZzaSk7DQo+ID4NCj4g
PiAgIAlpY2VfdnNpX3VwZGF0ZV9zZWN1cml0eShjdHJsX3ZzaSwgaWNlX3ZzaV9jdHhfY2xlYXJf
YWxsb3dfb3ZlcnJpZGUpOw0KPiA+ICAgCWljZV92c2lfdXBkYXRlX3NlY3VyaXR5KHVwbGlua192
c2ksIGljZV92c2lfY3R4X2NsZWFyX2FsbG93X292ZXJyaWRlKTsNCj4gPiArCXZsYW5fb3BzLT5l
bmFfcnhfZmlsdGVyaW5nKHVwbGlua192c2kpOw0KPiA+ICAgCWljZV9jbGVhcl9kZmx0X3ZzaSh1
cGxpbmtfdnNpKTsNCj4gPiAgIAlpY2VfZmx0cl9hZGRfbWFjX2FuZF9icm9hZGNhc3QodXBsaW5r
X3ZzaSwNCj4gPiAgIAkJCQkgICAgICAgdXBsaW5rX3ZzaS0+cG9ydF9pbmZvLT5tYWMucGVybV9h
ZGRyLA0KPiA+IEBAIC01MDMsNyArNTE2LDYgQEAgc3RhdGljIHZvaWQgaWNlX2Vzd2l0Y2hfZGlz
YWJsZV9zd2l0Y2hkZXYoc3RydWN0IGljZV9wZiAqcGYpDQo+ID4NCj4gPiAgIAlpY2VfZXN3aXRj
aF9uYXBpX2Rpc2FibGUocGYpOw0KPiA+ICAgCWljZV9lc3dpdGNoX3JlbGVhc2VfZW52KHBmKTsN
Cj4gPiAtCWljZV9yZW1fYWR2X3J1bGVfZm9yX3ZzaSgmcGYtPmh3LCBjdHJsX3ZzaS0+aWR4KTsN
Cj4gPiAgIAlpY2VfZXN3aXRjaF9yZWxlYXNlX3JlcHJzKHBmLCBjdHJsX3ZzaSk7DQo+ID4gICAJ
aWNlX3ZzaV9yZWxlYXNlKGN0cmxfdnNpKTsNCj4gPiAgIAlpY2VfcmVwcl9yZW1fZnJvbV9hbGxf
dmZzKHBmKTsNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNl
L2ljZV9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX21haW4uYw0K
PiA+IGluZGV4IGIwZDFlNjExNmViOS4uODBiMmI0ZDM5Mjc4IDEwMDY0NA0KPiA+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9tYWluLmMNCj4gPiBAQCAtMzg1LDcgKzM4NSw3
IEBAIHN0YXRpYyBpbnQgaWNlX3ZzaV9zeW5jX2ZsdHIoc3RydWN0IGljZV92c2kgKnZzaSkNCj4g
PiAgIAl9DQo+ID4gICAJZXJyID0gMDsNCj4gPiAgIAkvKiBjaGVjayBmb3IgY2hhbmdlcyBpbiBw
cm9taXNjdW91cyBtb2RlcyAqLw0KPiA+IC0JaWYgKGNoYW5nZWRfZmxhZ3MgJiBJRkZfQUxMTVVM
VEkpIHsNCj4gPiArCWlmICgoY2hhbmdlZF9mbGFncyAmIElGRl9BTExNVUxUSSkpIHsNCj4gPiAg
IAkJaWYgKHZzaS0+Y3VycmVudF9uZXRkZXZfZmxhZ3MgJiBJRkZfQUxMTVVMVEkpIHsNCj4gPiAg
IAkJCWVyciA9IGljZV9zZXRfcHJvbWlzYyh2c2ksIElDRV9NQ0FTVF9QUk9NSVNDX0JJVFMpOw0K
PiA+ICAgCQkJaWYgKGVycikgew0KPiA+IEBAIC01NzY3LDcgKzU3NjcsNyBAQCBzdGF0aWMgdm9p
ZCBpY2Vfc2V0X3J4X21vZGUoc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldikNCj4gPiAgIAlzdHJ1
Y3QgaWNlX25ldGRldl9wcml2ICpucCA9IG5ldGRldl9wcml2KG5ldGRldik7DQo+ID4gICAJc3Ry
dWN0IGljZV92c2kgKnZzaSA9IG5wLT52c2k7DQo+ID4NCj4gPiAtCWlmICghdnNpKQ0KPiA+ICsJ
aWYgKCF2c2kgfHwgaWNlX2lzX3N3aXRjaGRldl9ydW5uaW5nKHZzaS0+YmFjaykpDQo+ID4gICAJ
CXJldHVybjsNCj4gPg0KPiA+ICAgCS8qIFNldCB0aGUgZmxhZ3MgdG8gc3luY2hyb25pemUgZmls
dGVycw0KPiANCj4gVGhlIGRpZmYgaXRzZWxmIGxvb2tzIGdvb2QuDQo+IA0KPiBSZXZpZXdlZC1i
eTogUGF1bCBNZW56ZWwgPHBtZW56ZWxAbW9sZ2VuLm1wZy5kZT4NCj4gDQo+IA0KPiBLaW5kIHJl
Z2FyZHMsDQo+IA0KPiBQYXVsDQo=

