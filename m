Return-Path: <netdev+bounces-1124-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB4A96FC470
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:01:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1200728125E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349EA10972;
	Tue,  9 May 2023 11:01:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C92C1096E
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:01:33 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745AD10E52
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 04:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683630084; x=1715166084;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zk8uOhaS4ysWVbzF2LnUfO7xehSj0h05AGRmHIznzW8=;
  b=MjkD0DG6eItgIGjXycCnBewaC0FLpCyUkxH6xvDKPf0Y1bnOLMa7kQxj
   jk3IsvRsghzdao4aO8/ea5kdC3sypQXA15SFAJVXER9gifb1iqtWdQIhq
   YXUDM1HxIq7t/vIs5l8Cz/46V/qUSWLVew6xu3bm+j8z9eS8QNlJ5ytok
   GswU3nhB5R9A3+qkS79b8akcqRCwvPX0SS+Hm44TaJwC13j+TafgsXYHx
   wXEAMYLvIyejvZeyXi0D6vLZlMRBf7iOOaCFgxbZ87XjZOMAY7xxhD5gf
   Y+sbsJCbKghv45F9dOD4lAPIdGvBTMWQJ8oiBaxptYMlRqunJJ0KT39S9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="415465787"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="415465787"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 04:01:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="843061032"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="843061032"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 09 May 2023 04:01:22 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 04:01:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 04:01:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 04:01:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 04:01:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLedb2sZ80qhB03OBDsIDPUtgW2+elFzKXJQnTOH6pdN7uFRNenAFq9dhP8d4YWGbDbg+mrMc98jSP0/azzUdwSUkBcj/6fLnNtGpnOS63k3CuTWyPup4jsGINIu2IV/TxYAZUEbtdK6mZuJkViXDQ9IX/MF+zEK29Jn6yCrCFcIiRiG5OnKd9pD+25TWDvzu7GNMhTxRblT2VHF/nJtnc2k/9sAA83MYOkYXw87U7xJT1rxb9QiVr37qdNZiEekusL/jE9MsWceWb9FHDXJN2ciaTrWtC6V+meTsDJUzgqmuq8ZZ7RkmCnfzxhMYS2zxN7/ITortLmT6A534nHvSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zk8uOhaS4ysWVbzF2LnUfO7xehSj0h05AGRmHIznzW8=;
 b=N9XHzwd498yJmETaDVlaYl4TviRJIdAJG4BaMHHvStsIiNFF4mgyqKFY/UGD7egsjzZrEhkSvh8k2Xexn8w//r5EtyD/muAB2+K0tn8xofixyJ75vvPWZA+sFd51sCEBE3An4MFbFX/a9lnvhfRsf4WQyGEgxYLrkY8Pbvjdt5y8o8WcRtlmkRGfCveNaPonOdmqm3uPoMzfz0+3LGoounAHvYB780Q5BiqdCzzuTPqJWO5t3IanPoa3ORO2fPypvqEvHi08Fnmht8wJvIzFe2PS0jK4J58B2qDTxuTUCg7Pp7cTwqApEMQrm/DvdLqWIvAPEtI7FwWNdIpXOdjIRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by PH8PR11MB6973.namprd11.prod.outlook.com (2603:10b6:510:226::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 11:01:19 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 11:01:18 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Paolo Abeni <pabeni@redhat.com>, "edumazet@google.com"
	<edumazet@google.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>
CC: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "You,
 Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMA==
Date: Tue, 9 May 2023 11:01:17 +0000
Message-ID: <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
	 <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
In-Reply-To: <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|PH8PR11MB6973:EE_
x-ms-office365-filtering-correlation-id: 5d1334f1-3692-40b0-6bc0-08db507cb6d4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9AxV6K00aNUNh7ZT/Zt2/sVBPRoN5/+kAyp9738GT0vm+oQmnpfgm4GkCN/Nd7IjUYqbZexXq52nXsDMQNLMSSIT/7gHtCnOr7oVwZ5dbg3y6NNjon8W5ArijTNDe20eep/w1vcLsiIUw/rd8xlNqQapWC7Oz8XKxjnr4AKl6KDMjCJ6+YVkXz6zBKk5Lrg8gs9DNfhUGOGYD58Lv7fAb0m4EZ3yb7vdRIOkdPg2tFRLKAns8/MonEuUO+vlapWxuKhECwUA275bdpMNJPAqsdl3MWoDCwQzP8GMbZyjWvyXThQB6s915r3JnPhiJYZzPF6afJGIzbYoKo05b8LA/UIlZw6V2pMKeXpmnP+OS+FmalJW5cC0xCC7gZWx/RkmMIDmyW3tciSJ+Uf7lywGGfbTJ4tHn/0Bmf/yswBfVf6YnxtDqgb/+gK5eVKpwNQDCwYL4IO3Y4YrK4ndqzHI/SreZv8VihHfFNi2ebYhoLIKC/CFVZMIHLRndWEDRRyHNvX2L4OzdAbVAkYmB/Eb5aspI+BMBZnQCh0O2lyL9mvIyvoumAKLuZkR/HeCEDi3XxxN92xz54hUK5Rpd1lXIuJwXo31sVt+JTdOQ1KYYpXmGbkkOMELVefIDiJOAuZQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199021)(83380400001)(54906003)(110136005)(478600001)(9686003)(26005)(2940100002)(6506007)(186003)(53546011)(8676002)(41300700001)(4326008)(66946007)(66476007)(76116006)(7696005)(8936002)(66446008)(66556008)(64756008)(71200400001)(316002)(52536014)(5660300002)(2906002)(55016003)(33656002)(86362001)(38100700002)(122000001)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFBzbU5WVFVOMDN1Y1pvZmRwMUt6WWtIZ1pLREVDcGM4NnFpWDRCbXliZmRO?=
 =?utf-8?B?TGU1TmR1VkZsdVM3a2NxZVAwUmJ2SEVmWjVmaVhPMC8valVFajdNN3BhelVU?=
 =?utf-8?B?TE13R0RXblowZS9PcGlBSGhhWnArWm1sa2x3T0o1amQvMlBHT05DVzV4aFRk?=
 =?utf-8?B?Z1dBSG5pRlo3QmFZSFVYekFxbVlLYitoVlV0cGJmZmJoY0kyNUg5dUdZOStB?=
 =?utf-8?B?amI5T1gxaTBzQUlvOC9zMEQvUzl3UFhHWDMrUnFmUEp1clEyaUhtRkhObWR5?=
 =?utf-8?B?QlRSZ0lrNUM3aE1xNnRxd2RhdzRBN0VwQ2Jib2ozOGwrK3VKZjl6MFNBT1Bl?=
 =?utf-8?B?Ny8zTC95cm1ITUFhaTNzZTRZMmNITDlkcklBaXRtd01wZ1p4cjlyYjlCQlh5?=
 =?utf-8?B?SStGL3kvQjhVSlhjNFp0cTRkM3BLcHBVbEZxc0RpbVg4WjJwdFpHZWhvSlhp?=
 =?utf-8?B?ejFKYktmUVI5ZmNwVWx0ZW9KckdkTEhzbFExWnNySWJIbDFYSW1ocW5Sa0w0?=
 =?utf-8?B?R3AxVWJ4S2U0V1V1Q1ZIdEFCenpJdzYyNFFSL2tLenI0a0owdHdma1MvRE9H?=
 =?utf-8?B?SXNhdzcrcS9LVDI2Y2V4TEdaeXo2Y25IRVZMeGcxSDJBREFTQzI5c004THph?=
 =?utf-8?B?b3pIUzlBNEtNOXVxUmdjdFE3ZGpqa2pPOUZiSnhRSk00MEpnV0VnQWdDL1lu?=
 =?utf-8?B?U3NUK2dWaDBwckdrczhyMGZNaGFWSUtFcVc5cHh3bVZyM01pQmcvUHFCQldt?=
 =?utf-8?B?QndYYWFKdDd0UUhsNWh1OUJyTk5NelQySmZ2Qm9Vbm9iMDRJcjd3bzdBUDFX?=
 =?utf-8?B?ajBwZWZMYlIxb2UvQWtsK05JbDdoM3Qxa01LTnpLNEhTdFBoT2JNSXVNY3Jr?=
 =?utf-8?B?NEJWTGpaVUQ1M3VkajdqOWdaQkVCVm5UNWxZZnZLVkEvOVR3NURUS0l3Vmp6?=
 =?utf-8?B?bTkvM3d6TDhrMFgyTHdMcHhQV1pyWGN6bFlmV3R3YmtrVUd2NUhPbTlwRVc2?=
 =?utf-8?B?cDc5ZTFINDF0SExyaWhXTFZtcmxuQWF1WnNzWE54bkhLVlJZdXVOazhvZnNP?=
 =?utf-8?B?OFpmZERqalR6a0xKM1dTQUhuR0NjUUErQU45Zk1QS0FuYmdibko0a0NQcGRI?=
 =?utf-8?B?dDJqdmVhc2Z3cmhLT05KVDhIRnJLYTVla002RnZOVXpDK09vLzlYS2tMM3dn?=
 =?utf-8?B?L2k5YVBJbldjYjQ1a3dUSjhxbUdoVzh1Q3FDUUJ4Rm5qTTFPQkc5aTF5U09E?=
 =?utf-8?B?dzd2Szk3cmM3MjI2SnpFN2hqNGl5WWRTWklBWnU5MEFmR3FDOE5leldYYUEw?=
 =?utf-8?B?MGo2WS9ONVV3bTdqWGg5RDdMa1VlR2Y1RVhRUnpFa25iY3NJOGh1V1I1Ny8r?=
 =?utf-8?B?bkFOM0xURVdwRHB2MGErMEo4cXFIdll3QTZxTzlsS3VkYjhuTXFKR3FLQWNX?=
 =?utf-8?B?Y2VkV0VXbmRGd0NvRTFSZnJpcFUvNWlKN1lZa3N4VUJHME8zUUVCRkJ2ZklB?=
 =?utf-8?B?VE5DMGc2UlFZS3FBSEl1bzdlVUtHb0VzSjNpS2Q0aHRRbllyV0UyVkwrV3B0?=
 =?utf-8?B?RFhReEI0Wmg5UC9ldmg1VnVKZ3lNek9iZ3N6WUpsRzhOOUw4Q1NTWjFacWhH?=
 =?utf-8?B?ZUpqd2UzNG9SaGNxQjJJWG5PT05hc3JoOG1Ea0VJSHhXZ2ovUzJSRUxVWE1t?=
 =?utf-8?B?U1YzdFBrTnJ0YkZqZHNQZ2V1TVFBcityMnNxeXZmVlhvOTlXRzROY1E4dHhl?=
 =?utf-8?B?ZFVZYWFmSGRUV2MxdkVkUEFnSDdQU3BTSTBKZXpkbXBWbnNsSGVwZUxWeSsx?=
 =?utf-8?B?WFBwMVBCcFl0ZW54dDZiQzFzcU55aUFyTzRjNCsrcUhlL0hMYUVaaFJmYWlN?=
 =?utf-8?B?RUVrMENER0Q5ajc2bnoyK3hrZG4zYWFDZWtDYW4xNWNRY0cxZmlIczRFK2xv?=
 =?utf-8?B?M2xuMzlmWlpUaUlDZlh2TElrN040SnhtY28yUzE5emV6UlcrNnlJVXptS0My?=
 =?utf-8?B?b3R2eEJTMGNzRTg0V2RFVzRocEJjZ01OOXFXS0Y2ekZ2Wmc2MTM3QzZBRE1X?=
 =?utf-8?B?TjVwTzdsSlM1Wk5IdEhXaXlLN2Q1RllXdkFLVDFlOHNUSXlrU0JPT0xlS3o2?=
 =?utf-8?Q?zYzz1C+58FUwNpv4z9NUwl1hM?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d1334f1-3692-40b0-6bc0-08db507cb6d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 11:01:17.6443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AxI/13G/2BrCTd4wdObfgIPvBSWHNb+if/zwB5+nIzV03+P0p7DhoU2gvinX9ZmygPkMRwCXO1g/qvQwEiUOiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6973
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWmhhbmcsIENhdGh5DQo+
IFNlbnQ6IFR1ZXNkYXksIE1heSA5LCAyMDIzIDY6NDAgUE0NCj4gVG86IFBhb2xvIEFiZW5pIDxw
YWJlbmlAcmVkaGF0LmNvbT47IGVkdW1hemV0QGdvb2dsZS5jb207DQo+IGRhdmVtQGRhdmVtbG9m
dC5uZXQ7IGt1YmFAa2VybmVsLm9yZw0KPiBDYzogQnJhbmRlYnVyZywgSmVzc2UgPGplc3NlLmJy
YW5kZWJ1cmdAaW50ZWwuY29tPjsgU3Jpbml2YXMsIFN1cmVzaA0KPiA8c3VyZXNoLnNyaW5pdmFz
QGludGVsLmNvbT47IENoZW4sIFRpbSBDIDx0aW0uYy5jaGVuQGludGVsLmNvbT47IFlvdSwNCj4g
TGl6aGVuIDxMaXpoZW4uWW91QGludGVsLmNvbT47IGVyaWMuZHVtYXpldEBnbWFpbC5jb207DQo+
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUkU6IFtQQVRDSCBuZXQtbmV4dCAx
LzJdIG5ldDogS2VlcCBzay0+c2tfZm9yd2FyZF9hbGxvYyBhcyBhIHByb3Blcg0KPiBzaXplDQo+
IA0KPiANCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBQYW9s
byBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+DQo+ID4gU2VudDogVHVlc2RheSwgTWF5IDksIDIw
MjMgNTo1MSBQTQ0KPiA+IFRvOiBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT47
IGVkdW1hemV0QGdvb2dsZS5jb207DQo+ID4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJu
ZWwub3JnDQo+ID4gQ2M6IEJyYW5kZWJ1cmcsIEplc3NlIDxqZXNzZS5icmFuZGVidXJnQGludGVs
LmNvbT47IFNyaW5pdmFzLCBTdXJlc2gNCj4gPiA8c3VyZXNoLnNyaW5pdmFzQGludGVsLmNvbT47
IENoZW4sIFRpbSBDIDx0aW0uYy5jaGVuQGludGVsLmNvbT47IFlvdSwNCj4gPiBMaXpoZW4gPGxp
emhlbi55b3VAaW50ZWwuY29tPjsgZXJpYy5kdW1hemV0QGdtYWlsLmNvbTsNCj4gPiBuZXRkZXZA
dmdlci5rZXJuZWwub3JnDQo+ID4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzJdIG5l
dDogS2VlcCBzay0+c2tfZm9yd2FyZF9hbGxvYyBhcyBhDQo+ID4gcHJvcGVyIHNpemUNCj4gPg0K
PiA+IE9uIFN1biwgMjAyMy0wNS0wNyBhdCAxOTowOCAtMDcwMCwgQ2F0aHkgWmhhbmcgd3JvdGU6
DQo+ID4gPiBCZWZvcmUgY29tbWl0IDQ4OTBiNjg2ZjQwOCAoIm5ldDoga2VlcCBzay0+c2tfZm9y
d2FyZF9hbGxvYyBhcyBzbWFsbA0KPiA+ID4gYXMgcG9zc2libGUiKSwgZWFjaCBUQ1AgY2FuIGZv
cndhcmQgYWxsb2NhdGUgdXAgdG8gMiBNQiBvZiBtZW1vcnkNCj4gPiA+IGFuZCB0Y3BfbWVtb3J5
X2FsbG9jYXRlZCBtaWdodCBoaXQgdGNwIG1lbW9yeSBsaW1pdGF0aW9uIHF1aXRlIHNvb24uDQo+
ID4gPiBUbyByZWR1Y2UgdGhlIG1lbW9yeSBwcmVzc3VyZSwgdGhhdCBjb21taXQga2VlcHMNCj4g
PiA+IHNrLT5za19mb3J3YXJkX2FsbG9jIGFzIHNtYWxsIGFzIHBvc3NpYmxlLCB3aGljaCB3aWxs
IGJlIGxlc3MgdGhhbiAxDQo+ID4gPiBwYWdlIHNpemUgaWYgU09fUkVTRVJWRV9NRU0gaXMgbm90
IHNwZWNpZmllZC4NCj4gPiA+DQo+ID4gPiBIb3dldmVyLCB3aXRoIGNvbW1pdCA0ODkwYjY4NmY0
MDggKCJuZXQ6IGtlZXAgc2stPnNrX2ZvcndhcmRfYWxsb2MNCj4gPiA+IGFzIHNtYWxsIGFzIHBv
c3NpYmxlIiksIG1lbWNnIGNoYXJnZSBob3QgcGF0aHMgYXJlIG9ic2VydmVkIHdoaWxlDQo+ID4g
PiBzeXN0ZW0gaXMgc3RyZXNzZWQgd2l0aCBhIGxhcmdlIGFtb3VudCBvZiBjb25uZWN0aW9ucy4g
VGhhdCBpcw0KPiA+ID4gYmVjYXVzZQ0KPiA+ID4gc2stPnNrX2ZvcndhcmRfYWxsb2MgaXMgdG9v
IHNtYWxsIGFuZCBpdCdzIGFsd2F5cyBsZXNzIHRoYW4NCj4gPiA+IHNrLT50cnVlc2l6ZSwgbmV0
d29yayBoYW5kbGVycyBsaWtlIHRjcF9yY3ZfZXN0YWJsaXNoZWQoKSBzaG91bGQNCj4gPiA+IHNr
LT5qdW1wIHRvDQo+ID4gPiBzbG93IHBhdGggbW9yZSBmcmVxdWVudGx5IHRvIGluY3JlYXNlIHNr
LT5za19mb3J3YXJkX2FsbG9jLiBFYWNoDQo+ID4gPiBtZW1vcnkgYWxsb2NhdGlvbiB3aWxsIHRy
aWdnZXIgbWVtY2cgY2hhcmdlLCB0aGVuIHBlcmYgdG9wIHNob3dzIHRoZQ0KPiA+ID4gZm9sbG93
aW5nIGNvbnRlbnRpb24gcGF0aHMgb24gdGhlIGJ1c3kgc3lzdGVtLg0KPiA+ID4NCj4gPiA+ICAg
ICAxNi43NyUgIFtrZXJuZWxdICAgICAgICAgICAgW2tdIHBhZ2VfY291bnRlcl90cnlfY2hhcmdl
DQo+ID4gPiAgICAgMTYuNTYlICBba2VybmVsXSAgICAgICAgICAgIFtrXSBwYWdlX2NvdW50ZXJf
Y2FuY2VsDQo+ID4gPiAgICAgMTUuNjUlICBba2VybmVsXSAgICAgICAgICAgIFtrXSB0cnlfY2hh
cmdlX21lbWNnDQo+ID4NCj4gPiBJJ20gZ3Vlc3NpbmcgeW91IGhpdCBtZW1jZyBsaW1pdHMgZnJl
cXVlbnRseS4gSSdtIHdvbmRlcmluZyBpZiBpdCdzDQo+ID4ganVzdCBhIG1hdHRlciBvZiB0dW5p
bmcvcmVkdWNpbmcgdGNwIGxpbWl0cyBpbiAvcHJvYy9zeXMvbmV0L2lwdjQvdGNwX21lbS4NCj4g
DQo+IEhpIFBhb2xvLA0KPiANCj4gRG8geW91IG1lYW4gaGl0dGluZyB0aGUgbGltaXQgb2YgIi0t
bWVtb3J5IiB3aGljaCBzZXQgd2hlbiBzdGFydCBjb250YWluZXI/DQo+IElmIHRoZSBtZW1vcnkg
b3B0aW9uIGlzIG5vdCBzcGVjaWZpZWQgd2hlbiBpbml0IGEgY29udGFpbmVyLCBjZ3JvdXAyIHdp
bGwNCj4gY3JlYXRlIGEgbWVtY2cgd2l0aG91dCBtZW1vcnkgbGltaXRhdGlvbiBvbiB0aGUgc3lz
dGVtLCByaWdodD8gV2UndmUgcnVuDQo+IHRlc3Qgd2l0aG91dCB0aGlzIHNldHRpbmcsIGFuZCB0
aGUgbWVtY2cgY2hhcmdlIGhvdCBwYXRocyBhbHNvIGV4aXN0Lg0KPiANCj4gSXQgc2VlbXMgdGhh
dCAvcHJvYy9zeXMvbmV0L2lwdjQvdGNwX1t3cl1tZW0gaXMgbm90IGFsbG93ZWQgdG8gYmUgY2hh
bmdlZA0KPiBieSBhIHNpbXBsZSBlY2hvIHdyaXRpbmcsIGJ1dCByZXF1aXJlcyBhIGNoYW5nZSB0
byAvZXRjL3N5cy5jb25mLCBJJ20gbm90IHN1cmUNCj4gaWYgaXQgY291bGQgYmUgY2hhbmdlZCB3
aXRob3V0IHN0b3BwaW5nIHRoZSBydW5uaW5nIGFwcGxpY2F0aW9uLiAgQWRkaXRpb25hbGx5LA0K
PiB3aWxsIHRoaXMgdHlwZSBvZiBjaGFuZ2UgYnJpbmcgbW9yZSBkZWVwZXIgYW5kIGNvbXBsZXgg
aW1wYWN0IG9mIG5ldHdvcmsNCj4gc3RhY2ssIGNvbXBhcmVkIHRvIHJlY2xhaW1fdGhyZXNob2xk
IHdoaWNoIGlzIGFzc3VtZWQgdG8gbW9zdGx5IGFmZmVjdCBvZg0KPiB0aGUgbWVtb3J5IGFsbG9j
YXRpb24gcGF0aHM/IENvbnNpZGVyaW5nIGFib3V0IHRoaXMsIGl0J3MgZGVjaWRlZCB0byBhZGQg
dGhlDQo+IHJlY2xhaW1fdGhyZXNob2xkIGRpcmVjdGx5Lg0KPiANCg0KQlRXLCB0aGVyZSBpcyBh
IFNLX1JFQ0xBSU1fVEhSRVNIT0xEIGluIHNrX21lbV91bmNoYXJnZSBwcmV2aW91c2x5LCB3ZQ0K
YWRkIGl0IGJhY2sgd2l0aCBhIHNtYWxsZXIgYnV0IHNlbnNpYmxlIHNldHRpbmcuDQoNCj4gPg0K
PiA+IENoZWVycywNCj4gPg0KPiA+IFBhb2xvDQoNCg==

