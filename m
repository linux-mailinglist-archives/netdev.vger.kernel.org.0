Return-Path: <netdev+bounces-1342-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F6C6FD80C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:21:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9018828132A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 07:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49AB26129;
	Wed, 10 May 2023 07:21:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CA019937
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:21:37 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC885FD4;
	Wed, 10 May 2023 00:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683703295; x=1715239295;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xe1u12dMftjosPFSSA5OqYJvKIgBdKYXCLssvEh1/7s=;
  b=Ffj6XgTTjgIORa3zZwBkpWbWPCob8H4ykvnCKeY7/+tZ/RBvEBNNzpqO
   eH9WzrJPgeM3KygMDTGlXgUrSmgmgI88KhTnTuoglO0Gby2a8Iz4FWJ6W
   drleCEgfPgV5qyJ1/qbsdAqEP+iZ/r23hB04cCOTm0OHfgY+41TvYNtHQ
   LdMqF5dUs40F7HMTItCaM4YMCuhVfER77EADVky+d7DTFjO4SdS5qvgs/
   g9MXMTNgNIZv8Mo1ggGVq3Kn+AAVrm/rFcLdb4xh4KT6zuDYzNP9tRwXP
   hhtMoFMvEhybHYAdXbyNYEZVXt1OnRdKIbWGH+ASt90FT5pl71Pf9jIH+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="339386948"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="339386948"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 00:21:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="873481181"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="873481181"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 10 May 2023 00:21:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 00:21:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 00:21:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 00:21:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zk90NOaci64UxemUZkeFCGUaYQep+3Iu1yrNPPo8nCS6RtTsfkT4pP5BIrn6V3+fqt+NTzxq675Z1jwDkN7e7yy68lEdAn9weNtTE/RpcHHBCaURAvRC0UUbQC5BwzXLM44eekf8plBSzLQ8SHCtKwW4L215CCsoS4suhp2ZBQqXH/ktL6lKVN2GYqNIOpmL1w0xETqnNGjPjjvJ5RWJnv71y5hLuFiG/18cSOXsMQoAZf6zuhddh1+hhViIOOtnASdR0s5873DFs1KAnlA+PGqQX0ewJwIBkjO2BuG6mWUHWiD6qwq+gAqIjY3CphCkfhZYnKKXAENOzNDpQ0EE0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xe1u12dMftjosPFSSA5OqYJvKIgBdKYXCLssvEh1/7s=;
 b=cjBlJSUjj4ws+4DUZMaAsDmtRcLz3wigMYNleX2yXhNUguwdurLFgpjkaS8Jqj+MNwRp7oaMK+yFkNH+QPi4i0odVzxZOsRaVgpyMaeRtgiiJ9BbM9L6woZy4Vr4T3mMWX/re54U5QommQzikBWtn6HvqR5J5MyUCljGs2h6eB0sYO2th9NVjxMS9pAGzJ0ELOXpHiLCHm2Eiv1iKTW9Zk2BAsGVb82HTmqI0BRpwPj4gbNTnZ9QJDgLM+h23K/+yOK8nGplo2RL2rFveZ18h9HkvoQjiGGPKqyORkYE3apQ5Gy5E5jtRBn9o9LW6MqpDr13mQUBTcImAnQmR1DkOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by MW4PR11MB7080.namprd11.prod.outlook.com (2603:10b6:303:21a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.31; Wed, 10 May
 2023 07:21:30 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 07:21:30 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Shakeel Butt <shakeelb@google.com>, Linux MM <linux-mm@kvack.org>, Cgroups
	<cgroups@vger.kernel.org>
CC: Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"Srinivas, Suresh" <suresh.srinivas@intel.com>, "Chen, Tim C"
	<tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAADPPgIAA25Bw
Date: Wed, 10 May 2023 07:21:29 +0000
Message-ID: <CH3PR11MB7345E0CB35DF23445EFDC5B5FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6JK1Ts90uGYSDRWXX3-D=gyN3q+Bpy-oW+dqJsjjBm2w@mail.gmail.com>
In-Reply-To: <CALvZod6JK1Ts90uGYSDRWXX3-D=gyN3q+Bpy-oW+dqJsjjBm2w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|MW4PR11MB7080:EE_
x-ms-office365-filtering-correlation-id: 4520bf3d-b11f-4726-5cba-08db51272c55
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fK2X26jG7QUBXKcObNjb0Ybq0zPT7zHHftXRWByf7MuwrNdIJ2QU536w8muAeBuEW1CwRETXKN0b3Trw46RG/pARc91nRHfIhG5UML8E/kzomO4Lpuq3fT3ub1n8yE1IAQH/2NlodZUg6b/3kHkMVyMI0/ZaxI25I7VMOJcyQaqAzVJfQqupAu+JDSmsEd+2RtnBA2+KlASfKGNlV/oL3IjzWzYdop5fH2rSAY0naWlmNeeJ59qCs+UT4CmV7PlHA2uRApxUDgGDN7VyLuAhgedj35itlvKUM4VtzPpAp4Hb4aAjTcciXFdbo0pz3ahlshyVXmMob/8ZgZZrjc3qzU9zWAWK6ErNvxFQc8MO+OhErDcF2chaCaiPsCbYG4Q+mBjGjbd0MgmHqOPyWqjgUluhUkGXHbi8qNfP7SUdQ9FyjK6i8p9GWiM2lv0+4quH9BGPpMA7AivASoufSiYlcIDK64lujk1k3ngKnjqRbA1qfhM8rug/SphbJJWamafopuWcF2UMuZ53QE6ZTWJpc8WuPlkeWpsj22gZkoUb4IeNW1QR9DtOAIA2EcrRN/aNDRxXoDvHNQ/fOcIVjQM4xWuDPKJR+WW9GyuUly2W9Io=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199021)(86362001)(478600001)(76116006)(66946007)(54906003)(110136005)(316002)(66446008)(33656002)(64756008)(66476007)(7696005)(66556008)(4326008)(55016003)(2906002)(186003)(8676002)(5660300002)(52536014)(41300700001)(8936002)(82960400001)(122000001)(38070700005)(38100700002)(6506007)(26005)(53546011)(83380400001)(9686003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXBzOExuQkFBcTlqMXAxNWNkSkxlWUdDNFdjUmpKRExpUFp2d1BnRXM1SVMr?=
 =?utf-8?B?UUkwUDc3b3VOMDFiOXV3RHQyb21HUkdhclNjMHY5Uys5ckVGL05MT1FLZTFl?=
 =?utf-8?B?dWk2S21VTFVnTGJBYlZ2aGluVTR1a21Cdk1wYUt2RTcvRzBYeUFOcHFhcjJ1?=
 =?utf-8?B?RU5uU0NsOVBTUnZCVjJ4aFhnNTUwWm1jc1ZrNzQ0aVVOU0JCcXFoZjNUd1Y3?=
 =?utf-8?B?cjhvYm5LRkZ6RXJzODJjcmNQYzhQM3hyREk2T1ZoV1d5QkVJUlBGQVN4K1JK?=
 =?utf-8?B?Nkp0S3lQaEk4dEZIVVRGYXcyc2NqTEdZQjNZTm5EdytFWERKU3JDNXJ4WkpX?=
 =?utf-8?B?TlZaejFaWk5wWFBCcm5kNUlraDY2emdjby9vZy9uVTFIZjgrUEJIcnRxK3Ax?=
 =?utf-8?B?ck1SK21vSTRNdzdPcTBxaW95R3NiT01xU055VVRscVhPSTNrUEJySzhuRTQr?=
 =?utf-8?B?ZEtVN3BkWFZBeG4xRXVBZWpIcWVoNFhwUENMVGFwRXVWRm5iWUpQNTJhY2ZR?=
 =?utf-8?B?R0FhT1FHK3RFb2o1RXNqU2JJTlpuNkEwZHcvRTB5ZzQyUlY1L2l4TmNzSXpp?=
 =?utf-8?B?V3J5T21aaDVvQkMwWFJnNk4xNHNvN0MzNkJ0R3J2RDdhTXhYYzlZSDNWNnc4?=
 =?utf-8?B?MDFqaWpkMjJPRDN6bVNjeHlja0E0Y0R5Vi9qY0pja3ZKNkZ2RklONnFVakFy?=
 =?utf-8?B?bkZmdU5TS2NhWWoycUNNN21JeFZ2L0wvZlJwYml0VkZxZ1lsYkZTZnhoZ29v?=
 =?utf-8?B?MzJCVHpkbzljNmdpNlF3OTJNSlIreEN3ZlVlaFV0UGhZMVIwcGFMNXVjZlhX?=
 =?utf-8?B?RDRYTXhNMEVSOGFjSlh3UmVlcWFjdjhmbkxWMkxkc003NmxCZzlaVzg2S1RE?=
 =?utf-8?B?TGFwMTlHQjlEaDFQRTEwQ2lyZlpheFVWeklGeVVQYjNRVy84dTZmL052Q1pE?=
 =?utf-8?B?RElycU4rMVZEZmJyMFMxUE01cE1teHVucWkvQTN6V2xEQXNzZFVXa29adlBo?=
 =?utf-8?B?bmRGMTNSeDIybkcyaHJhdTBkdUpDdEV6UEU0UnhweTRuV0FwaDhCWnRuQUtj?=
 =?utf-8?B?VGlMSktQaGNpeWlEbHFXaEROdXF4dGNQZUNTUC9mam9zNUNBNCtjUjVoMk1H?=
 =?utf-8?B?UjFhQXBpMi90V1RnQnR6UXM0S3ZldmdYeDlwM1VkdzI1QkQ0UDF3NWNsQ09o?=
 =?utf-8?B?TFN6WmhFREJyMXJXN0cwbWg5cXhSOGQyeXBzK25HWXpTSjJObkU5eDhmcngz?=
 =?utf-8?B?Nk14SnBkbFh6OEdDeDg0MDhHWXBVSFhHMUZ5NnNxdFc5ZnJONTk5WE1DOWZX?=
 =?utf-8?B?dGlTYlVRR1JEaFdFKzF2NElMaFVQV3J1ZC9GenAwbDJ3a0o5Z2dsYlg1Y2Jy?=
 =?utf-8?B?RVVZRE55djd1Z1FrZktSNHRTRlBsc09wTEdSMzluVDBpR2h0OUxBT0xyZENk?=
 =?utf-8?B?WGU3M3BZNVdwMTBKYU1KaGNmdm9jYnBzcGlpQ2RUZlNyMnFOdDJMWnNkWElv?=
 =?utf-8?B?YVNNc2RmMzJaeEFkRVFpYm1kMmtaZHFELzU5Y3ZZOGFnbTM2ZEs0MDFETWpC?=
 =?utf-8?B?TEx1NzhVOW5YWWtoL1dFSkNzM1dxUmZDUjdvZzFGVE9JeWRuSHBzSHBTVzh6?=
 =?utf-8?B?cW9LUnM3bDlsVk1Rell2K0xCeHBQcmFTeGlDdENHUytZc2Zkd3FFQ1pLZ09m?=
 =?utf-8?B?UTluYU5iWGdiUjdwT0Y2OFJiRHpHOUpXMjdVcHVoc25qUFNTMVhaeXVrckFw?=
 =?utf-8?B?TUo1VkduM0hpVlIvd3dGeWpGUUZ2Tlc3OWZpWmdjN1VtWFZNK2VBK05xZDl1?=
 =?utf-8?B?dmUvaHFncG44Z2FqUTZHNk5oTjRMekRKNjVQekZ2WHRPdHRoUGhzRzRHOXls?=
 =?utf-8?B?UXM3M2FSUkNvNGlpNldjVno3VjIyY05RbGk2NlRzUkhWU3B1bUw5cU5HalZY?=
 =?utf-8?B?Zk9HcFprQVV1eUJUVXhMcFhUZVkrb2I3MGJ5VzR3S0h2Z2NXSmhmQTF0bmdi?=
 =?utf-8?B?OFNTZE1QOGVTblVDdDRQaHJOcmxESDl5SGw2QVh1TEdoODczeE5WTmJGTmFP?=
 =?utf-8?B?aFNydWtvcGxWSGxoNFZQaDdwNUx2Z3czdE9OVCt3UHp2dnJRbHhEUmR4bEVk?=
 =?utf-8?Q?bFtdOyi6RqHTh+4Sxb8ZwOqzx?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4520bf3d-b11f-4726-5cba-08db51272c55
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 07:21:29.1993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d8d1v6J/N8pG+xPoWLZ2nvsmHbAB9SMhrXB3x457yw++MrMtBHghIiqZhj8NEHkaj0r/OUZQs7amvFBeG2axdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7080
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2hha2VlbCBCdXR0IDxz
aGFrZWVsYkBnb29nbGUuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIE1heSAxMCwgMjAyMyAxOjU4
IEFNDQo+IFRvOiBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT47IExpbnV4IE1N
IDxsaW51eC0NCj4gbW1Aa3ZhY2sub3JnPjsgQ2dyb3VwcyA8Y2dyb3Vwc0B2Z2VyLmtlcm5lbC5v
cmc+DQo+IENjOiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+OyBQYW9sbyBBYmVu
aQ0KPiA8cGFiZW5pQHJlZGhhdC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5l
bC5vcmc7DQo+IEJyYW5kZWJ1cmcsIEplc3NlIDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT47
IFNyaW5pdmFzLCBTdXJlc2gNCj4gPHN1cmVzaC5zcmluaXZhc0BpbnRlbC5jb20+OyBDaGVuLCBU
aW0gQyA8dGltLmMuY2hlbkBpbnRlbC5jb20+OyBZb3UsDQo+IExpemhlbiA8bGl6aGVuLnlvdUBp
bnRlbC5jb20+OyBlcmljLmR1bWF6ZXRAZ21haWwuY29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IEtlZXAgc2stPnNr
X2ZvcndhcmRfYWxsb2MgYXMgYSBwcm9wZXINCj4gc2l6ZQ0KPiANCj4gT24gVHVlLCBNYXkgOSwg
MjAyMyBhdCA4OjA34oCvQU0gWmhhbmcsIENhdGh5IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+
IHdyb3RlOg0KPiA+DQo+IFsuLi5dDQo+ID4gPg0KPiA+ID4gU29tZXRoaW5nIG11c3QgYmUgd3Jv
bmcgaW4geW91ciBzZXR1cCwgYmVjYXVzZSB0aGUgb25seSBzbWFsbCBpc3N1ZQ0KPiA+ID4gdGhh
dCB3YXMgbm90aWNlZCB3YXMgdGhlIG1lbWNnIG9uZSB0aGF0IFNoYWtlZWwgc29sdmVkIGxhc3Qg
eWVhci4NCj4gPg0KPiA+IEFzIG1lbnRpb25lZCBpbiBjb21taXQgbG9nLCB0aGUgdGVzdCBpcyB0
byBjcmVhdGUgOCBtZW1jYWNoZWQtbWVtdGllcg0KPiA+IHBhaXJzIG9uIHRoZSBzYW1lIGhvc3Qs
IHdoZW4gc2VydmVyIGFuZCBjbGllbnQgb2YgdGhlIHNhbWUgcGFpcg0KPiA+IGNvbm5lY3QgdG8g
dGhlIHNhbWUgQ1BVIHNvY2tldCBhbmQgc2hhcmUgdGhlIHNhbWUgQ1BVIHNldCAoMjggQ1BVcyks
DQo+ID4gdGhlIG1lbWNnIG92ZXJoZWFkIGlzIG9idmlvdXNseSBoaWdoIGFzIHNob3duIGluIGNv
bW1pdCBsb2cuIElmIHRoZXkNCj4gPiBhcmUgc2V0IHdpdGggZGlmZmVyZW50IENQVSBzZXQgZnJv
bSBzZXBhcmF0ZSBDUFUgc29ja2V0LCB0aGUgb3ZlcmhlYWQNCj4gPiBpcyBub3Qgc28gaGlnaCBi
dXQgc3RpbGwgb2JzZXJ2ZWQuICBIZXJlIGlzIHRoZSBzZXJ2ZXIvY2xpZW50IGNvbW1hbmQgaW4g
b3VyDQo+IHRlc3Q6DQo+ID4gc2VydmVyOg0KPiA+IG1lbWNhY2hlZCAtcCAke3BvcnRfaX0gLXQg
JHt0aHJlYWRzX2l9IC1jIDEwMjQwDQo+ID4gY2xpZW50Og0KPiA+IG1lbXRpZXJfYmVuY2htYXJr
IC0tc2VydmVyPSR7bWVtY2FjaGVkX2lkfSAtLXBvcnQ9JHtwb3J0X2l9IFwNCj4gPiAtLXByb3Rv
Y29sPW1lbWNhY2hlX3RleHQgLS10ZXN0LXRpbWU9MjAgLS10aHJlYWRzPSR7dGhyZWFkc19pfSBc
IC1jIDENCj4gPiAtLXBpcGVsaW5lPTE2IC0tcmF0aW89MToxMDAgLS1ydW4tY291bnQ9NQ0KPiA+
DQo+ID4gU28sIGlzIHRoZXJlIGFueXRoaW5nIHdyb25nIHlvdSBzZWU/DQo+ID4NCj4gDQo+IFdo
YXQgaXMgdGhlIG1lbWNnIGhpZXJhcmNoeSBvZiB0aGlzIHdvcmtsb2FkPyBJcyBlYWNoIHNlcnZl
ciBhbmQgY2xpZW50DQo+IHByb2Nlc3NlcyBydW5uaW5nIGluIHRoZWlyIG93biBtZW1jZz8gSG93
IG1hbnkgbGV2ZWxzIG9mIG1lbWNncz8gQXJlDQo+IHlvdSBzZXR0aW5nIG1lbW9yeS5tYXggYW5k
IG1lbW9yeS5oaWdoIHRvIHNvbWUgdmFsdWU/IEFsc28gaG93IGFyZSB5b3UNCj4gbGltaXRpbmcg
dGhlIHByb2Nlc3NlcyB0byBDUFVzPyBjcHVzZXRzPw0KDQpIZXJlIGlzIHRoZSBmdWxsIGNvbW1h
bmQgdG8gc3RhcnQgbWVtY2FjaGVkIGluc3RhbmNlOg0KDQpkb2NrZXIgcnVuIC1kIC0tbmFtZSAk
e21lbWNhY2hlZF9uYW1lfSAtLXByaXZpbGVnZWQgLS1tZW1vcnkgMUcgLS1uZXR3b3JrIGJyaWRn
ZSBcDQotcCAke3BvcnRfaX06JHtwb3J0X2l9ICR7Y3B1X3Bpbm5pbmdfc1tzZXRdfSBtZW1jYWNo
ZWQgbWVtY2FjaGVkIC1wICR7cG9ydF9pfSBcDQotdCAke3RocmVhZHNfaX0gLWMgMTAyNDANCg0K
V2UgaGF2ZSBhIHNjcmlwdCB0byBnZXQgQ1BVIHNldCBmcm9tIHRoZSBzYW1lIE5VTUEgbm9kZSwg
Ym90aCBDUFUgY291bnQgYW5kIHRocmVhZA0KY291bnQgZm9yIGVhY2ggaW5zdGFuY2UgYXJlIGVx
dWFsIHRvIE51bShzeXN0ZW0gb25saW5lIENQVXMpIC8gTnVtKG1lbWNhY2hlZCBpbnN0YW5jZXMp
Lg0KVGhhdCBpcywgaWYgd2UgcnVuIDggbWVtY2FjaGVkIGluc3RhbmNlcywgMjI0IC8gOCA9IDI4
LCBzbyBlYWNoIGluc3RhbmNlIHdpbGwgZ2V0IDI4IENQVXMgYW5kDQoyOCB0aHJlYWRzIGFzc2ln
bmVkLg0KDQpIZXJlIGlzIHRoZSBmdWxsIGNvbW1hbmQgdG8gc3RhcnQgbWVtdGllciBpbnN0YW5j
ZToNCmRvY2tlciBydW4gLS1ybSAtLW5ldHdvcmsgYnJpZGdlICR7Y3B1X3Bpbm5pbmdfc1tzZXRd
fSAtLW1lbW9yeSAxRyBcDQpyZWRpc2xhYnMvbWVtdGllcl9iZW5jaG1hcmsgbWVtdGllcl9iZW5j
aG1hcmsgLS1zZXJ2ZXI9JHttZW1jYWNoZWRfaWR9IC0tcG9ydD0ke3BvcnRfaX0gXA0KLS1wcm90
b2NvbD1tZW1jYWNoZV90ZXh0IC0tdGVzdC10aW1lPTIwIC0tdGhyZWFkcz0ke3RocmVhZHNfaX0g
LWMgMSAtLXBpcGVsaW5lPTE2IC0tcmF0aW89MToxMDAgXA0KLS1ydW4tY291bnQ9NSAtLWhpZGUt
aGlzdG9ncmFtDQoNCkVhY2ggaW5zdGFuY2UgaGFzIHRoZSBzYW1lIENQVSBzZXQgYXMgdGhlIHNl
cnZlciBpdCBjb25uZWN0cyB0bywgYW5kIGl0IGhhcyB0aGUgc2FtZSB0aHJlYWRzDQpjb3VudC4N
Cg0KVGhhdCBpcyBhbGwgZm9yIHNlcnZlciBhbmQgY2xpZW50IHNldHRpbmdzLg0KDQo=

