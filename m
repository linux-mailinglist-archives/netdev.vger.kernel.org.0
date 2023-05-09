Return-Path: <netdev+bounces-1168-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 611C26FC718
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:52:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BFA41C20B57
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC026182AD;
	Tue,  9 May 2023 12:52:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966F7196
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:52:36 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E822E53
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683636750; x=1715172750;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DXKts2WDmWK7TLoCAyUcL0H51f8li4C1Pwh5eg2nflI=;
  b=Ga6F4/8H2nvlZlvwgrfeFWpX2XWZTbpSCn2m3vQ45eCW11+h7Ckvo+N2
   aLXi6GDCSOeflshcNqslx3k7bdzQsOjLAkij0qL/WR8TwGkspG3WbLvMQ
   Lmhj2bp2lxYWWsFUtOFpG7D4SQ/N80vD1yMhwQEJcpb/ge7vJdwXR5Iqj
   R5LauKz5nEZCXJEQHWlb0MpYRzt5hmVybcJajMSKZECQhY9nu98y0k8ax
   L1SuFI5oWp+0IPJVQM8K0HTVDrQ/plyaSAyTWEV4w9KYs/0M1mHwyi67f
   6TQWQUoWSpLOqgdi1B2RdmSp71sg9PVYnAirDQ8A7c7/WSnvQPuMEu24j
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="352084796"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="352084796"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 05:52:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="731701237"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="731701237"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 09 May 2023 05:52:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 05:52:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 05:52:29 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 05:52:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E14PqoKbj2376XHj084+hS3xonnCLuKRSZjfoSpd86O1cp/mHvQDgzuAvZ+I7TkuvaFo5V4U229uwNGbdS9Et4xFOlEhrvqaFupDi5lCCERF/VKZKiLd7NzkU0xJ+PA/YlpQ1ZVvyxfNUzqhCZMmqtmwYHO8kiPGgaCTeYz16D2/ZThiyG6X18pawLJls8XgW58gXR+MVwxGtgpWeKovN/744R/G+2LF5UEvhuJqoJdwHBGWEJMVpzEMsmUfiueVDqr0rGvEYS0bab8yipa77kyoz/lreECjF5wBPlbUY36ajSXnLnZSm+W2nnD/8g+AWsnBaxtRshuP5ukwVMJLSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXKts2WDmWK7TLoCAyUcL0H51f8li4C1Pwh5eg2nflI=;
 b=ElhrFzKXo+aYOcZYQF6rqBmIICGhNEVrkgij+80AP5k6oApCz30aO0HA+hM08lquJNY5E1nnEUEldJ5gOdn7NV25DF4dqhPJuCTEv9UMhM604Z0AxXUSuS56IRZZ5gFiwcSWE6M4SH/08SoW2pXbgK0swGep4mwuPvqx2IyIYBredQBYQX5TqJUjNjHVdVgejyLNGCeNt+AGT1IifCTmiv39h26QzOXEuW9y7RkWtVb3VRgawYfGaqubEVnjmIxc6urZiIkAcgcLHTXkoKg7CSgjIDXNaD72TsJ0SRP2GxHmhoEmTUhzFxKtKgn7sfBi2lTy5hbsY7H1y67A/ldBrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by MN6PR11MB8146.namprd11.prod.outlook.com (2603:10b6:208:470::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.31; Tue, 9 May
 2023 12:52:27 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%7]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 12:52:27 +0000
From: "Drewek, Wojciech" <wojciech.drewek@intel.com>
To: "Lobakin, Aleksander" <aleksander.lobakin@intel.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ertman, David M"
	<david.m.ertman@intel.com>, "michal.swiatkowski@linux.intel.com"
	<michal.swiatkowski@linux.intel.com>, "marcin.szycik@linux.intel.com"
	<marcin.szycik@linux.intel.com>, "Chmielewski, Pawel"
	<pawel.chmielewski@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>
Subject: RE: [PATCH net-next 12/12] ice: Ethtool fdb_cnt stats
Thread-Topic: [PATCH net-next 12/12] ice: Ethtool fdb_cnt stats
Thread-Index: AQHZdG8WCYLx8cHVKkiG6WmgfOmwA69R6TFw
Date: Tue, 9 May 2023 12:52:26 +0000
Message-ID: <MW4PR11MB5776E4EFEA7FDE7E52C79E1EFD769@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-13-wojciech.drewek@intel.com>
 <6f23fe3c-c23e-7a37-f22b-21a59281715c@intel.com>
In-Reply-To: <6f23fe3c-c23e-7a37-f22b-21a59281715c@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|MN6PR11MB8146:EE_
x-ms-office365-filtering-correlation-id: b3f9a6d4-0d9a-424e-eea7-08db508c3e0e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KPFXg1DUlLD/4JXy00QUUnaH3qbRn1Iczg091x+2OCcpGswASE/n0vzVd9vkIEzOV6ZZMIh49UdYls/is+6MwlgtBbmLcTDnwA7YsUVhkwgcrFBz9NnvXLq185bgL5mlxMC5u8aca/Pj3yit48ZFCov1RCeIKKGgG/2cq8y0SGhcpjEa2arry6cVib3GV0bx7M2ZEfIOgsMNOWatGV/NueCOp/R+O7jfEJFaIF1U1oyzpXKcdDp36I/o7Z8kBnBvrJBrEIK1c5m1I3z74iQcJPuXUcQ6n7vDLMmN58ZtSiXo2Du5Xpm30S58HV2NTx0VxjHE6zriCjGzV/zFMV7pjAElFOUlzCec5PsPrMBoznl5E5wOcWCdLg2VyCKAXQ7kVm8WiBdQaDRaQocreypNLS9ZN/WvbyLpowrB4+/hiwU03LoVSya9WOe47n3yGzTrqr4JRknMdSCbKxIMNOSyEh+sSTGhf8M+JY6MkesiD7aM9LAyhBoIWVmxVHGepYMXqBIir5oqNKDcO4a06hZ++ntRs8szSt2CvSIUHn6oVE4hjM9nY0WUg5wdl783ROU4VAfwC02x7VlO3KmPb8aSXyGVUXeztUHrS6rG8UIom0PFoww3MQi3FJyG8kImBBBO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(366004)(39860400002)(346002)(136003)(451199021)(26005)(6506007)(53546011)(9686003)(83380400001)(66574015)(38100700002)(55016003)(33656002)(122000001)(86362001)(38070700005)(82960400001)(186003)(7696005)(71200400001)(54906003)(41300700001)(6862004)(8676002)(316002)(8936002)(52536014)(478600001)(76116006)(4326008)(6636002)(66446008)(66556008)(66946007)(66476007)(5660300002)(64756008)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T1FGNUJ1bE9Ka2FPSSsrWFhxc0pWQjJ5Njd6L2JZeEREdDNyL3AyRDJEcXl6?=
 =?utf-8?B?c0JBNkhmcVA4cE1nWU5tdFpVODdZdjdpd0VXTVEzblgrSDg4TytYMXpnWkxW?=
 =?utf-8?B?QWtReSs0akt0Tkc1SjVpNEJ6UG9EQ2JjcnBOamovM2MrZFpoODUwRVFySzgz?=
 =?utf-8?B?K01SU3ZGVlVDc2dPUllxYWJxNWNqTTFoczhHdzRDZG4rYzJBQ0FNQ25QMVB3?=
 =?utf-8?B?YTY1ZHBYQzB1YzV4NFpEdU4rMDd4UVdrVDhkQ0NBeCtiVnVZaG9nSVVvdExL?=
 =?utf-8?B?ZHora1h5dGEyYVIwTzlIbFZwTFpHelU4b2Jnd1hHb0x1N0xrbmVlRzZSTFk5?=
 =?utf-8?B?WTA2ZkRrSzNoeWRjZjFYNzdsZzlXZVU5VlZ0QmxUZ3FmY3hQWWMwL041alov?=
 =?utf-8?B?MDI0VjJ3RjBKZFlHbjhDZEovQU50OTFiMWRaQ3V5K3JlcTY5Uy9VOC9XNkh3?=
 =?utf-8?B?WUY4UXR1dWh1T3hTTnl6bFZVRlp4SlJ3Z0Vnc0s3blVrcTNKMWpnUWdPUk85?=
 =?utf-8?B?VVRQLzBzaEVGdzEzdURqY2cvVGx5bWZGWWFXZjZHWDlXaEhOVG9TZWdQbzZ2?=
 =?utf-8?B?OVBVVlNYSksvV01jaEVibXVBUUVzV014c1RrWW9WUlpCVVk5RjlPaHNGblhk?=
 =?utf-8?B?OU41OTlkQ3FleElZajYzUFlaVVMzN29pWGJEaXB2OW53NUdrK3FjUlVLSzNJ?=
 =?utf-8?B?R3hWUm91MXlaZVd4Tkc3TkNNRm90bnVmMHhNTlRKQjEzbnI3clYrTUVnVGpN?=
 =?utf-8?B?RnFqa2hqQktwc1Y1eEhBb2sxaVZmNnNJYW5kdzIydmY0SDJvVEkrRmkvRXhw?=
 =?utf-8?B?UzJuMUdpMXo3S3JsZXRnbnJPcmgrOWFNVDB0QTRvK2pVK3JrbFFOVTNHNHBV?=
 =?utf-8?B?ZFBOZnBzcStwdWRRdVlOQVZNNWM2VU1YZU5jdVptOEZLWFFwelBIaUhWeWxj?=
 =?utf-8?B?L2xYWmNnQVhLU0dReGQvM0JpeHQ0TmIrUUNYVVJBTExaVzVKcnZFcStyV3B3?=
 =?utf-8?B?YlVjUWVtUWJIOTVKNDBqM1JRYmFPb29adk8zVUtRZ2hxS0xnRjlnQzZsRWRl?=
 =?utf-8?B?YlpXT1BvNDl1eWJWaUllcFlPRmwzRTg3VFdQbjNQK0ZUdXhwbEY2RmdYMWJN?=
 =?utf-8?B?c21RSE1KVEJyYWs0Q01GMVJhcXdjQTU0cFkyV1JwbEpFd3RWVFZDWGJFSmJt?=
 =?utf-8?B?Nmh3em5DTWNtNU8wdXlZck03b3hTVDIxSGx3RE5oL0VKOUJzUHFOT3VsU3pa?=
 =?utf-8?B?TW0vdEdGKzdERiswNG1hbWhtbEpwOStFYVNUZ0tYbjhzQTMrUFBXWER0VndX?=
 =?utf-8?B?elExUnludjdQNmFsZktmSWFsSkRVWWZvNTV5WC91dzh4SnJ1Q2F6RG1GdmM1?=
 =?utf-8?B?d0JlajRQd25IRlU5R0tWZVpnWG4xMWZ5OFVSVzczVXZMN3k4dU96eUtaMmZ6?=
 =?utf-8?B?ZVZJbXY4WTZnYWsvcDZtR1hWSURDOFY5bnpBMFkxUHcvMmdyYWV4eDB1bUlj?=
 =?utf-8?B?amd5YmQrWGJRYk5KaVR1VWFpMjNmb0tkQXl5Q3lnbTh2YlY3ekdmQy8wWE81?=
 =?utf-8?B?THFPRjFHVWlOd3p2MkZscHd3MnUrZ01lS2dvcWdqbTcvWHFrTUpzQzJjcDFW?=
 =?utf-8?B?UkNBQTZoaEc3SWcwMDRQS0RJQ1NFRGtwTGVIRFJyenVxdEtQcUwrUHIxdWxD?=
 =?utf-8?B?dFdOSmtMbVkxNzdpcTVTUHQrZnRnSjJ3M1VwUHhJSHR4TVNiZGNTMG05MlFC?=
 =?utf-8?B?ZVdCOFo4S3dJeUpNaTdDNGZpSjFrRmdmYVZZaGorVkhxSEYvVFR6M3BrZU4x?=
 =?utf-8?B?YlhVQ1hETUE0TVpwZ1VVYWxHRENPQ2FCMGsvaWtxY2gza0hGV0x2WTdLd3Rw?=
 =?utf-8?B?MG9rYkdnOE5jTVhvbEt6SnRUMWVvWXVHaFl5YU5ZSmRlV3YrUCtwSkZIeHl3?=
 =?utf-8?B?ZXVheWZlT1VZa2RGbkxUMmtDamkvYkUxQ0dmZ0kwb3dDMXBoQ1I1TFp1WmI3?=
 =?utf-8?B?M3o0ZUl3azFNNnpsenM0MUxkeFpjeEZuRHZXMnBnbnkrY3RzSGlwUndCVTlq?=
 =?utf-8?B?SnIyUUlobkRkYjlReXJqUWlEa2R2RE83T1MxbVZtL0ZWcDRNbmVqZ2ZkSUJx?=
 =?utf-8?Q?07NOvyFpw7hrLvCsABKxks3Lt?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f9a6d4-0d9a-424e-eea7-08db508c3e0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 12:52:26.9538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q6hDLRMsgYTQd1Ha/uUDI26O46uHONY13MYwuLSUnqr9dIzHisHfnBl7CY278AVMA/WiFDnESfyJKnd3JkPsquchjF3boYWml8/+tx+d9hw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8146
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTG9iYWtpbiwgQWxla3Nh
bmRlciA8YWxla3NhbmRlci5sb2Jha2luQGludGVsLmNvbT4NCj4gU2VudDogcGnEhXRlaywgMjEg
a3dpZXRuaWEgMjAyMyAxODozMw0KPiBUbzogRHJld2VrLCBXb2pjaWVjaCA8d29qY2llY2guZHJl
d2VrQGludGVsLmNvbT4NCj4gQ2M6IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBFcnRtYW4sIERhdmlkIE0gPGRhdmlkLm0uZXJ0bWFuQGlu
dGVsLmNvbT47DQo+IG1pY2hhbC5zd2lhdGtvd3NraUBsaW51eC5pbnRlbC5jb207IG1hcmNpbi5z
enljaWtAbGludXguaW50ZWwuY29tOyBDaG1pZWxld3NraSwgUGF3ZWwgPHBhd2VsLmNobWllbGV3
c2tpQGludGVsLmNvbT47DQo+IFNhbXVkcmFsYSwgU3JpZGhhciA8c3JpZGhhci5zYW11ZHJhbGFA
aW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDEyLzEyXSBpY2U6IEV0
aHRvb2wgZmRiX2NudCBzdGF0cw0KPiANCj4gRnJvbTogV29qY2llY2ggRHJld2VrIDx3b2pjaWVj
aC5kcmV3ZWtAaW50ZWwuY29tPg0KPiBEYXRlOiBNb24sIDE3IEFwciAyMDIzIDExOjM0OjEyICsw
MjAwDQo+IA0KPiA+IEludHJvZHVjZSBuZXcgZXRodG9vbCBzdGF0aXN0aWMgd2hpY2ggaXMgJ2Zk
Yl9jbnQnLiBJdA0KPiA+IHByb3ZpZGVzIGluZm9ybWF0aW9uIGFib3V0IGhvdyBtYW55IGJyaWRn
ZSBmZGJzIGFyZSBjcmVhdGVkIG9uDQo+ID4gYSBnaXZlbiBuZXRkZXYuDQo+IA0KPiBbLi4uXQ0K
PiANCj4gPiBAQCAtMzM5LDYgKzM0MCw3IEBAIGljZV9lc3dpdGNoX2JyX2ZkYl9lbnRyeV9kZWxl
dGUoc3RydWN0IGljZV9lc3dfYnIgKmJyaWRnZSwNCj4gPiAgCWljZV9lc3dpdGNoX2JyX2Zsb3df
ZGVsZXRlKHBmLCBmZGJfZW50cnktPmZsb3cpOw0KPiA+DQo+ID4gIAlrZnJlZShmZGJfZW50cnkp
Ow0KPiA+ICsJdnNpLT5mZGJfY250LS07DQo+IA0KPiBBcmUgRkRCIG9wZXJhdGlvbnMgYWx3YXlz
IHNlcmlhbGl6ZWQgd2l0aGluIG9uZSBuZXRkZXY/IEJlY2F1c2UgaWYgaXQncw0KPiBub3QsIHRo
aXMgcHJvYmFibHkgbmVlZHMgdG8gYmUgYXRvbWljX3QuDQoNCkFsbCB0aGUgRkRCIG9wZXJhdGlv
bnMgYXJlIGRvbmUgZWl0aGVyIGZyb20gbm90aWZpY2F0aW9uIGNvbnRleHQgc28gdGhleSBhcmUg
cHJvdGVjdGVkIGJ5DQpydG5sX2xvY2sgb3IgZXhwbGljaXRseSBwcm90ZWN0ZWQgYnkgdXMgKHNl
ZSBpY2VfZXN3aXRjaF9icl9mZGJfZXZlbnRfd29yaywgd2UgdXNlIHJ0bmxfbG9jayB0aGVyZSku
DQoNCj4gDQo+ID4gIH0NCj4gPg0KPiA+ICBzdGF0aWMgdm9pZA0KPiANCj4gWy4uLl0NCj4gDQo+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfZXRodG9v
bC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9ldGh0b29sLmMNCj4gPiBp
bmRleCA4NDA3YzcxNzVjZjYuLmQwNmIyYTY4ODMyMyAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2V0aHRvb2wuYw0KPiA+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfZXRodG9vbC5jDQo+ID4gQEAgLTY0LDYgKzY0LDcg
QEAgc3RhdGljIGNvbnN0IHN0cnVjdCBpY2Vfc3RhdHMgaWNlX2dzdHJpbmdzX3ZzaV9zdGF0c1td
ID0gew0KPiA+ICAJSUNFX1ZTSV9TVEFUKCJ0eF9saW5lYXJpemUiLCB0eF9saW5lYXJpemUpLA0K
PiA+ICAJSUNFX1ZTSV9TVEFUKCJ0eF9idXN5IiwgdHhfYnVzeSksDQo+ID4gIAlJQ0VfVlNJX1NU
QVQoInR4X3Jlc3RhcnQiLCB0eF9yZXN0YXJ0KSwNCj4gPiArCUlDRV9WU0lfU1RBVCgiZmRiX2Nu
dCIsIGZkYl9jbnQpLA0KPiANCj4gSXQncyBjb25mdXNpbmcgdG8gbWUgdG8gc2VlIGl0IGluIHRo
ZSBFdGh0b29sIHN0YXRzLiBUaGV5J3JlIHVzdWFsbHkNCj4gY291bnRlcnMsIGljZSBpcyBubyBh
biBleGNlcHRpb24uIEJ1dCB0aGlzIG9uZSBpcyBub3QsIHNvIGl0IG1pZ2h0IGdpdmUNCj4gd3Jv
bmcgaW1wcmVzc2lvbi4NCj4gSGF2ZSB5b3UgY29uc2lkZXJlZCBhbHRlcm5hdGl2ZXM/IHJ0bmwg
KGlwcm91dGUpIG9yIG1heWJlIGV2ZW4gRGV2bGluaw0KPiAoYnV0IEkgYmVsaWV2ZSB0aGUgZm9y
bWVyIGZpdHMgYmV0dGVyKT8gVGhpcyBtaWdodCBiZSBhIGdvb2QgY2FuZGlkYXRlDQo+IHRvIGJl
Y29tZSBhIGdlbmVyaWMgc3RhdCwgd2hvIGtub3dzLg0KDQpJJ2xsIGRvIHNvbWUgcmVzZWFyY2gg
b24gYWx0ZXJuYXRpdmVzDQoNCj4gDQo+ID4gIH07DQo+ID4NCj4gPiAgZW51bSBpY2VfZXRodG9v
bF90ZXN0X2lkIHsNCj4gDQo+IFRoYW5rcywNCj4gT2xlaw0K

