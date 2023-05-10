Return-Path: <netdev+bounces-1345-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01F0C6FD86C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:43:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9B641C20AB8
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 07:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 376916139;
	Wed, 10 May 2023 07:43:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CDD80C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:43:19 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1312A26A2
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 00:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683704597; x=1715240597;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/oYFNqw8WXHETxUfeq/6kAuHg9n37RZ2T3+KUcjrGas=;
  b=PIi9xXtmv2UteErwWWctUQ5otUQBdiBLKdoB2QuiqILzY99cQe14rMBE
   cD+UTr3X3hKYNnaIgZ5y7cHRH+H1a2/8CrV3eSHNbn/UwqwYJj7E3bNLH
   XXU+3n0YWvtIXV9x/BEGvYwZmykwT4UU06oyrgZ2Kt4hoW2CxWAIocnHu
   uBHBGc83HAKnTRpKGXp7t9aLT8t0eTsIsjUpkeHMpR9tzP8gwcz3XM8fb
   oJwPPBDwgaQoMyyme3nvsZIC1juYTGlNIv4l0jH7GN3iHbDXLUXDH9oqV
   gbvep365/UOcn5i9UXLaRQBUXErAV0k3L9dtL+VL0zNK2tt42Qkf6oI5l
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="415725297"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="415725297"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 00:43:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="843419955"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="843419955"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 10 May 2023 00:43:16 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 00:43:16 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 00:43:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 00:43:15 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 00:43:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FkbiEmov5q410mld3t0shWfaC3Dnhmc+WgiIPRxHLv/pSVDmyXmmbRFUHRoxbr1SrD8Uup//PoYnyXT00K2cY3auxQz1clIhBaGULpco4jlE4woxi32Rcm42aSFYN6jGGmHqLILTt2bLnM8Rg1CDk4mvXEBBPBTA8h1G+eEupXAqDoHa224fJULNzGQfSuW/UF4Xdz/RjUvrCf5QhRUzxo3J4BDMm7rsLyhwDTPiWcAHfBnh+vc3YRgvGmJp3Dj/vyq31MSQc56jOh2UPrsgrm1+jU4Ts4xZ2ctFF5P/d6hc7vgtQmmixafAAjdfoVg2d+GrdXfCWYnHAS98E46rJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/oYFNqw8WXHETxUfeq/6kAuHg9n37RZ2T3+KUcjrGas=;
 b=iqLbm3jsl+q1ooH3wgEVaxD119joXSBPa5HGHV10YObZhpr6o5lz9wB0cVRYhQ7q2RSdQVFKLirjr6gTMLe1I9PXEEOgzf8LKQ41fxEyqePnNmawJ1OygAWLNBnj1K/4VIa4UXrl9zrij/WUfSxSv31//p/1KQn5nEPjBu/6lUkY8Fm2f1GQ2N+ad6xDhYVkj391WdpCSWWCPOlJ4gOpE8sRyQvShcJbwfWshGu0RzmanhdHmigMVvJXs6B684PYxNF0ecq/iP5vVd0b0QlkN8OxjbdEqZxeD6oWyfLzmdVa27+i3RYtv/cTe3QhhT/OCH08hUUaJW2hcDnjI9uYkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by CH3PR11MB8592.namprd11.prod.outlook.com (2603:10b6:610:1b1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 07:43:07 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 07:43:07 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Eric Dumazet <edumazet@google.com>
CC: Paolo Abeni <pabeni@redhat.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, "Brandeburg,
 Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "You,
 Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Shakeel Butt <shakeelb@google.com>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAAA4vgIABCVRQ
Date: Wed, 10 May 2023 07:43:06 +0000
Message-ID: <CH3PR11MB73458F27EF26FACFB8A3CC8CFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
In-Reply-To: <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|CH3PR11MB8592:EE_
x-ms-office365-filtering-correlation-id: 4a61b7fa-3389-4ec0-7461-08db512a31cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GC6+VWwoAzYPD6Wf2W8rZq6jy3mNHy8Xovbe+YKuj8dvs9Zu8wr8aWi2GUi8xeLp5/CGCXJly38igsQoHX0ZNN+UPgH7GNcUmfhvwDG2uT0mm0gOxi/GT5kb6wzwuJqyfSvBgybgebhSth78PYlQ9XFGPZ0Rhjt9hP1NelWzG9tXaBdSudjxDoB7/Q2JChANWaJ36ou6uwkKGejGrgGNJ26iiiAoSj5uxQBYtnjisPTKTx+xkwSQbT4sGZq56M14K/rTsJO4IftbjiAcEzUp3qKQrITM/LfxJ+LrFUfbkQPzTyLAN+Abf8uSHk79c7cBzo/T8xhHstQqwNpAHi296TSGstQM7iBbDqzyqRIKnecmMTPNshap83APpb6fugyoppshlseMqu147mC+VMcdrQEQjdx8B5cDgIGVmGTMLB+0FKdrPobBgSdx2TONsoKmudP9v7sRwVYhgHR+gR2g0oBt6no0Ssr/QpfwC0frALVBQT4/V/3Fr2jeMUzSvoatBNJt3hcXwOGYXz76kUuxeiyErL0B6IQZhH48lLHQv4TDx0zOucWRyqNT2XBJZv6X951yD2qDwW3uvEnahQ50+b1lzaqJUtPeihVVGKxkTXTEv3/FhowY7mTWA0aG7reU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199021)(82960400001)(26005)(122000001)(9686003)(6506007)(38100700002)(38070700005)(7696005)(83380400001)(71200400001)(186003)(2906002)(76116006)(86362001)(55016003)(33656002)(66946007)(66556008)(5660300002)(8936002)(66476007)(54906003)(41300700001)(66446008)(64756008)(52536014)(4326008)(478600001)(316002)(6916009)(8676002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STk3YklrUnd2bnRHbCt4Wk5zT1AxaGllSGhHWDNHS1gyMGJOTnMrOEVVM1Ri?=
 =?utf-8?B?MUdnck9qVlRsbm1aaElEc2d0cUgvT2xVN3VjSE1EdWN5bXVUSXp2RU9OcWo3?=
 =?utf-8?B?TkNUTHcrdE5LYnJVK3UzZmFZMEc4OWFOclc4c3Q2MU8rYTdQdjRTdDBnTnRl?=
 =?utf-8?B?ZnBxMWRZa2ZHYmRDYktpVzBFdWFlSlZSaWFSWDZpZGdoSUhxUGp3RmtwQ1U3?=
 =?utf-8?B?VzR5VmpMdXMwbFdsTmJhN2taZUw4WTVCd1h6cnFmMHZyNkFuUkUzSmZZZ2RZ?=
 =?utf-8?B?bkZqdDc5a0k4MGJlandhbHIzVlQ1Ukc0b2FBdGpYaGhCTUVyTFRETWV2VmE1?=
 =?utf-8?B?RXdmODE5REtLL1dwdTk1Z2htMytMQXlEWnpMaFNxZVV6aUsxSnFyNDZscXNS?=
 =?utf-8?B?UituMHo1TVQ5c1duSEdzMkNBYjJJSHdOcnFqYVVPSkFyVy9zRC9BZ20wLzF0?=
 =?utf-8?B?cTJQWFFUSlVUWjUvRm1KZ2NBM2Q3Ri91b1p6bWdHdU9wSk4raE53a3BJTTJy?=
 =?utf-8?B?UjJCMWhOcnYya0FCRlcxVjA2dkZLV3pwVm4rMTZESGt2TUdKWGFtdXlUYy9X?=
 =?utf-8?B?cm4zT2l3ZEJUZUhXQ25ucDV3cTFLMUFxS2pOTmRRM2J1V01HT3gvVkNsQmpq?=
 =?utf-8?B?VTlLNDZuVVFwaWJFWnhoZFZVcmpZVDF2dFlHTzdnWmVrTjVMQUoySlJId28y?=
 =?utf-8?B?VzhFYXVCUjI2RG95M2xFemdOeTErT1ZmNVVhUm5YcU4zTjd6TmxHNjlHZWRU?=
 =?utf-8?B?VXZiaURDYktqRGNvZ1d5YlpBb2VhdmF5d1MzTjRxanBST2JGS2xnc3NyYS9Z?=
 =?utf-8?B?ZlA2S08zRzBqOC93aGQwY3ZROGdkbFl1SnhLMnJIUzEvU1pydVBZS1cva2Zu?=
 =?utf-8?B?TGszcjdFa1BwVExZcjJxcloxY1V1akJNQys4S0VZQmNYMWVtTXNJRlhkMWZx?=
 =?utf-8?B?cmJnWWxOQ3Rkd2ZRQ0JDY3M1UlZHbWNGL3BjS3ZibHltUk9lQXIxWGs1UzFw?=
 =?utf-8?B?cHJqZlBJcFM1NE5DNVZmSmhudE1ia2JQcjlZRjdVZTZnVWZrNUNzT1J6TENC?=
 =?utf-8?B?ZEhGK05jRWtTQjBBOEpjeDc0MGt5dGRjMDhVRnhCOWJRZlRtbm1BT1kxbjVm?=
 =?utf-8?B?R3l5QnFzNUpwMWFCS1J1WWRiVVY0RHp6NTFrWFpOSUhyZ2xsbGNyY0g0S25q?=
 =?utf-8?B?UjhuQ2ExVjN1d1NUWjdqQ0lTOWM2Q013V2I4Umx6M2w4M2dJMzNqampKMWds?=
 =?utf-8?B?YUUrN0piby9wOHlKNjNNUHE0K2xJWnkzaGNCT0dMSTVYUFA3cjdBbjVlM0VJ?=
 =?utf-8?B?MGdjS0xCU1IxN2NGWWxLRnR0UFJua2l3WTc2alZ3YWlZVnFjOU1zb2k5cStS?=
 =?utf-8?B?dHI3RkFPcDhZY3hxMVBmN2FNYTFIejBnZit6L2FXdnFDbCtvL3l2K2pPZVpW?=
 =?utf-8?B?TloxcU84L1RUSTZKeUg2ZnpGUnFOYjBKMlpkVmVyVUhGdHlRblNRVVBrMVhq?=
 =?utf-8?B?cTFBakZjTzBmQWlpUWpNbU1DMzd3eFBEZS9wRmlvYkI5Q2tpTkhIQ1NySUs3?=
 =?utf-8?B?QTRlcm1LM0ErK3RhK1F2V2xoOXE3VzJGUTR1K25OZi9EYnZjZnk5NDY2OHRm?=
 =?utf-8?B?YU94Y2FVdnNVUEFPUjBXUFhLaU8xUUlGVVprT3RJT3BudmxzRnI5RmwzcTlZ?=
 =?utf-8?B?VENnNzlod3hxZFJsRkw1enRrWkVqRVE3UnpjUldHV3BQNkw4Tnd0L2dqV1hS?=
 =?utf-8?B?SVAydy9JMkw3czFPcnNBMWxhRlpTVDZNbE1uTnNXbGdZR25lRFpBYlJ5ekxY?=
 =?utf-8?B?NG1WamF0MXZTdnVPQ0xoeUNoZTBnM1R0b3pnNXNwWEF3RHowRVkwRnRWL2RR?=
 =?utf-8?B?VmlUNlM1dHlmWUMrZXBWeC9KSTg5MXZCSHdrcUpZQU1RMG9DTXd5TmFXK3lL?=
 =?utf-8?B?N2hvWi9haTQ0Wm82eE0zTHlmR2ZKOW1FOGlJVG1KWnFQVnJBUi9UWUlSZmhH?=
 =?utf-8?B?NC85MDR4UkYvcDNHbVNFdDUzT0ErL2Jsc1VXUklXRWs0b1hSQ0pIckpGRkJk?=
 =?utf-8?B?RFZKWEhZNTI2QzhRYkFzc0VVQlZUZC9Xd0lNSTZrSE9jSFNQa2F2QmlYUWdU?=
 =?utf-8?Q?yAB0wjhUwsGmWdVrjDUeic/6/?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a61b7fa-3389-4ec0-7461-08db512a31cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 07:43:06.8557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zAgDgCTLVIxDnmVNoYmx6I1dB1EwCeXArRPWidI4pDBccFWPkYlus+W2Q86HRf4a5Mlr2tG2p6PgYoy6u65AUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8592
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IDxl
ZHVtYXpldEBnb29nbGUuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBNYXkgOSwgMjAyMyAxMTo0MyBQ
TQ0KPiBUbzogWmhhbmcsIENhdGh5IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+IENjOiBQYW9s
byBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBrdWJh
QGtlcm5lbC5vcmc7IEJyYW5kZWJ1cmcsIEplc3NlIDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNv
bT47DQo+IFNyaW5pdmFzLCBTdXJlc2ggPHN1cmVzaC5zcmluaXZhc0BpbnRlbC5jb20+OyBDaGVu
LCBUaW0gQw0KPiA8dGltLmMuY2hlbkBpbnRlbC5jb20+OyBZb3UsIExpemhlbiA8bGl6aGVuLnlv
dUBpbnRlbC5jb20+Ow0KPiBlcmljLmR1bWF6ZXRAZ21haWwuY29tOyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBTaGFrZWVsIEJ1dHQNCj4gPHNoYWtlZWxiQGdvb2dsZS5jb20+DQo+IFN1YmplY3Q6
IFJlOiBbUEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IEtlZXAgc2stPnNrX2ZvcndhcmRfYWxsb2Mg
YXMgYSBwcm9wZXINCj4gc2l6ZQ0KPiANCj4gT24gVHVlLCBNYXkgOSwgMjAyMyBhdCA1OjA34oCv
UE0gWmhhbmcsIENhdGh5IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+IHdyb3RlOg0KPiA+DQo+
ID4NCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IEVy
aWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIE1h
eSA5LCAyMDIzIDc6NTkgUE0NCj4gPiA+IFRvOiBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGlu
dGVsLmNvbT4NCj4gPiA+IENjOiBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+OyBkYXZl
bUBkYXZlbWxvZnQubmV0Ow0KPiA+ID4ga3ViYUBrZXJuZWwub3JnOyBCcmFuZGVidXJnLCBKZXNz
ZSA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+Ow0KPiA+ID4gU3Jpbml2YXMsIFN1cmVzaCA8
c3VyZXNoLnNyaW5pdmFzQGludGVsLmNvbT47IENoZW4sIFRpbSBDDQo+ID4gPiA8dGltLmMuY2hl
bkBpbnRlbC5jb20+OyBZb3UsIExpemhlbiA8bGl6aGVuLnlvdUBpbnRlbC5jb20+Ow0KPiA+ID4g
ZXJpYy5kdW1hemV0QGdtYWlsLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgU2hha2VlbCBC
dXR0DQo+ID4gPiA8c2hha2VlbGJAZ29vZ2xlLmNvbT4NCj4gPiA+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggbmV0LW5leHQgMS8yXSBuZXQ6IEtlZXAgc2stPnNrX2ZvcndhcmRfYWxsb2MgYXMNCj4gPiA+
IGEgcHJvcGVyIHNpemUNCj4gPiA+DQo+ID4gPiBPbiBUdWUsIE1heSA5LCAyMDIzIGF0IDE6MDHi
gK9QTSBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT4NCj4gPiA+IHdyb3RlOg0K
PiA+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQo+ID4gPiA+ID4gRnJvbTogWmhhbmcsIENhdGh5DQo+ID4gPiA+ID4gU2VudDogVHVl
c2RheSwgTWF5IDksIDIwMjMgNjo0MCBQTQ0KPiA+ID4gPiA+IFRvOiBQYW9sbyBBYmVuaSA8cGFi
ZW5pQHJlZGhhdC5jb20+OyBlZHVtYXpldEBnb29nbGUuY29tOw0KPiA+ID4gPiA+IGRhdmVtQGRh
dmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZw0KPiA+ID4gPiA+IENjOiBCcmFuZGVidXJnLCBK
ZXNzZSA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBTcmluaXZhcywNCj4gPiA+ID4gPiBT
dXJlc2ggPHN1cmVzaC5zcmluaXZhc0BpbnRlbC5jb20+OyBDaGVuLCBUaW0gQw0KPiA+ID4gPiA+
IDx0aW0uYy5jaGVuQGludGVsLmNvbT47IFlvdSwgTGl6aGVuIDxMaXpoZW4uWW91QGludGVsLmNv
bT47DQo+ID4gPiA+ID4gZXJpYy5kdW1hemV0QGdtYWlsLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZw0KPiA+ID4gPiA+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IEtl
ZXAgc2stPnNrX2ZvcndhcmRfYWxsb2MNCj4gPiA+ID4gPiBhcyBhIHByb3BlciBzaXplDQo+ID4g
PiA+ID4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiA+ID4gPiA+ID4gRnJvbTogUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQu
Y29tPg0KPiA+ID4gPiA+ID4gU2VudDogVHVlc2RheSwgTWF5IDksIDIwMjMgNTo1MSBQTQ0KPiA+
ID4gPiA+ID4gVG86IFpoYW5nLCBDYXRoeSA8Y2F0aHkuemhhbmdAaW50ZWwuY29tPjsgZWR1bWF6
ZXRAZ29vZ2xlLmNvbTsNCj4gPiA+ID4gPiA+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2Vy
bmVsLm9yZw0KPiA+ID4gPiA+ID4gQ2M6IEJyYW5kZWJ1cmcsIEplc3NlIDxqZXNzZS5icmFuZGVi
dXJnQGludGVsLmNvbT47IFNyaW5pdmFzLA0KPiA+ID4gPiA+ID4gU3VyZXNoIDxzdXJlc2guc3Jp
bml2YXNAaW50ZWwuY29tPjsgQ2hlbiwgVGltIEMNCj4gPiA+ID4gPiA+IDx0aW0uYy5jaGVuQGlu
dGVsLmNvbT47IFlvdSwgTGl6aGVuIDxsaXpoZW4ueW91QGludGVsLmNvbT47DQo+ID4gPiA+ID4g
PiBlcmljLmR1bWF6ZXRAZ21haWwuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4gPiA+
ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDEvMl0gbmV0OiBLZWVwDQo+ID4gPiA+
ID4gPiBzay0+c2tfZm9yd2FyZF9hbGxvYyBhcyBhIHByb3BlciBzaXplDQo+ID4gPiA+ID4gPg0K
PiA+ID4gPiA+ID4gT24gU3VuLCAyMDIzLTA1LTA3IGF0IDE5OjA4IC0wNzAwLCBDYXRoeSBaaGFu
ZyB3cm90ZToNCj4gPiA+ID4gPiA+ID4gQmVmb3JlIGNvbW1pdCA0ODkwYjY4NmY0MDggKCJuZXQ6
IGtlZXAgc2stPnNrX2ZvcndhcmRfYWxsb2MNCj4gPiA+ID4gPiA+ID4gYXMgc21hbGwgYXMgcG9z
c2libGUiKSwgZWFjaCBUQ1AgY2FuIGZvcndhcmQgYWxsb2NhdGUgdXAgdG8NCj4gPiA+ID4gPiA+
ID4gMiBNQiBvZiBtZW1vcnkgYW5kIHRjcF9tZW1vcnlfYWxsb2NhdGVkIG1pZ2h0IGhpdCB0Y3Ag
bWVtb3J5DQo+ID4gPiA+ID4gPiA+IGxpbWl0YXRpb24NCj4gPiA+IHF1aXRlIHNvb24uDQo+ID4g
PiA+ID4gPiA+IFRvIHJlZHVjZSB0aGUgbWVtb3J5IHByZXNzdXJlLCB0aGF0IGNvbW1pdCBrZWVw
cw0KPiA+ID4gPiA+ID4gPiBzay0+c2tfZm9yd2FyZF9hbGxvYyBhcyBzbWFsbCBhcyBwb3NzaWJs
ZSwgd2hpY2ggd2lsbCBiZQ0KPiA+ID4gPiA+ID4gPiBzay0+bGVzcyB0aGFuIDENCj4gPiA+ID4g
PiA+ID4gcGFnZSBzaXplIGlmIFNPX1JFU0VSVkVfTUVNIGlzIG5vdCBzcGVjaWZpZWQuDQo+ID4g
PiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+IEhvd2V2ZXIsIHdpdGggY29tbWl0IDQ4OTBiNjg2ZjQw
OCAoIm5ldDoga2VlcA0KPiA+ID4gPiA+ID4gPiBzay0+c2tfZm9yd2FyZF9hbGxvYyBhcyBzbWFs
bCBhcyBwb3NzaWJsZSIpLCBtZW1jZyBjaGFyZ2UNCj4gPiA+ID4gPiA+ID4gc2stPmhvdA0KPiA+
ID4gPiA+ID4gPiBwYXRocyBhcmUgb2JzZXJ2ZWQgd2hpbGUgc3lzdGVtIGlzIHN0cmVzc2VkIHdp
dGggYSBsYXJnZQ0KPiA+ID4gPiA+ID4gPiBhbW91bnQgb2YgY29ubmVjdGlvbnMuIFRoYXQgaXMg
YmVjYXVzZQ0KPiA+ID4gPiA+ID4gPiBzay0+c2tfZm9yd2FyZF9hbGxvYyBpcyB0b28gc21hbGwg
YW5kIGl0J3MgYWx3YXlzIGxlc3MgdGhhbg0KPiA+ID4gPiA+ID4gPiBzay0+dHJ1ZXNpemUsIG5l
dHdvcmsgaGFuZGxlcnMgbGlrZSB0Y3BfcmN2X2VzdGFibGlzaGVkKCkNCj4gPiA+ID4gPiA+ID4g
c2stPnNob3VsZCBqdW1wIHRvDQo+ID4gPiA+ID4gPiA+IHNsb3cgcGF0aCBtb3JlIGZyZXF1ZW50
bHkgdG8gaW5jcmVhc2Ugc2stPnNrX2ZvcndhcmRfYWxsb2MuDQo+ID4gPiA+ID4gPiA+IEVhY2gg
bWVtb3J5IGFsbG9jYXRpb24gd2lsbCB0cmlnZ2VyIG1lbWNnIGNoYXJnZSwgdGhlbiBwZXJmDQo+
ID4gPiA+ID4gPiA+IHRvcCBzaG93cyB0aGUgZm9sbG93aW5nIGNvbnRlbnRpb24gcGF0aHMgb24g
dGhlIGJ1c3kgc3lzdGVtLg0KPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiAgICAgMTYuNzcl
ICBba2VybmVsXSAgICAgICAgICAgIFtrXSBwYWdlX2NvdW50ZXJfdHJ5X2NoYXJnZQ0KPiA+ID4g
PiA+ID4gPiAgICAgMTYuNTYlICBba2VybmVsXSAgICAgICAgICAgIFtrXSBwYWdlX2NvdW50ZXJf
Y2FuY2VsDQo+ID4gPiA+ID4gPiA+ICAgICAxNS42NSUgIFtrZXJuZWxdICAgICAgICAgICAgW2td
IHRyeV9jaGFyZ2VfbWVtY2cNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBJJ20gZ3Vlc3Npbmcg
eW91IGhpdCBtZW1jZyBsaW1pdHMgZnJlcXVlbnRseS4gSSdtIHdvbmRlcmluZyBpZg0KPiA+ID4g
PiA+ID4gaXQncyBqdXN0IGEgbWF0dGVyIG9mIHR1bmluZy9yZWR1Y2luZyB0Y3AgbGltaXRzIGlu
DQo+ID4gPiAvcHJvYy9zeXMvbmV0L2lwdjQvdGNwX21lbS4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+
IEhpIFBhb2xvLA0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gRG8geW91IG1lYW4gaGl0dGluZyB0aGUg
bGltaXQgb2YgIi0tbWVtb3J5IiB3aGljaCBzZXQgd2hlbiBzdGFydA0KPiA+ID4gY29udGFpbmVy
Pw0KPiA+ID4gPiA+IElmIHRoZSBtZW1vcnkgb3B0aW9uIGlzIG5vdCBzcGVjaWZpZWQgd2hlbiBp
bml0IGEgY29udGFpbmVyLA0KPiA+ID4gPiA+IGNncm91cDIgd2lsbCBjcmVhdGUgYSBtZW1jZyB3
aXRob3V0IG1lbW9yeSBsaW1pdGF0aW9uIG9uIHRoZQ0KPiBzeXN0ZW0sIHJpZ2h0Pw0KPiA+ID4g
PiA+IFdlJ3ZlIHJ1biB0ZXN0IHdpdGhvdXQgdGhpcyBzZXR0aW5nLCBhbmQgdGhlIG1lbWNnIGNo
YXJnZSBob3QNCj4gPiA+ID4gPiBwYXRocyBhbHNvDQo+ID4gPiBleGlzdC4NCj4gPiA+ID4gPg0K
PiA+ID4gPiA+IEl0IHNlZW1zIHRoYXQgL3Byb2Mvc3lzL25ldC9pcHY0L3RjcF9bd3JdbWVtIGlz
IG5vdCBhbGxvd2VkIHRvDQo+ID4gPiA+ID4gYmUgY2hhbmdlZCBieSBhIHNpbXBsZSBlY2hvIHdy
aXRpbmcsIGJ1dCByZXF1aXJlcyBhIGNoYW5nZSB0bw0KPiA+ID4gPiA+IC9ldGMvc3lzLmNvbmYs
IEknbSBub3Qgc3VyZSBpZiBpdCBjb3VsZCBiZSBjaGFuZ2VkIHdpdGhvdXQNCj4gPiA+ID4gPiBz
dG9wcGluZyB0aGUgcnVubmluZyBhcHBsaWNhdGlvbi4gIEFkZGl0aW9uYWxseSwgd2lsbCB0aGlz
IHR5cGUNCj4gPiA+ID4gPiBvZiBjaGFuZ2UgYnJpbmcgbW9yZSBkZWVwZXIgYW5kIGNvbXBsZXgg
aW1wYWN0IG9mIG5ldHdvcmsgc3RhY2ssDQo+ID4gPiA+ID4gY29tcGFyZWQgdG8gcmVjbGFpbV90
aHJlc2hvbGQgd2hpY2ggaXMgYXNzdW1lZCB0byBtb3N0bHkgYWZmZWN0DQo+ID4gPiA+ID4gb2Yg
dGhlIG1lbW9yeSBhbGxvY2F0aW9uIHBhdGhzPyBDb25zaWRlcmluZyBhYm91dCB0aGlzLCBpdCdz
DQo+ID4gPiA+ID4gZGVjaWRlZCB0byBhZGQgdGhlDQo+ID4gPiByZWNsYWltX3RocmVzaG9sZCBk
aXJlY3RseS4NCj4gPiA+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiBCVFcsIHRoZXJlIGlzIGEgU0tf
UkVDTEFJTV9USFJFU0hPTEQgaW4gc2tfbWVtX3VuY2hhcmdlDQo+ID4gPiA+IHByZXZpb3VzbHks
DQo+ID4gPiB3ZQ0KPiA+ID4gPiBhZGQgaXQgYmFjayB3aXRoIGEgc21hbGxlciBidXQgc2Vuc2li
bGUgc2V0dGluZy4NCj4gPiA+DQo+ID4gPiBUaGUgb25seSBzZW5zaWJsZSBzZXR0aW5nIGlzIGFz
IGNsb3NlIGFzIHBvc3NpYmxlIGZyb20gMCByZWFsbHkuDQo+ID4gPg0KPiA+ID4gUGVyLXNvY2tl
dCBjYWNoZXMgZG8gbm90IHNjYWxlLg0KPiA+ID4gU3VyZSwgdGhleSBtYWtlIHNvbWUgYmVuY2ht
YXJrcyByZWFsbHkgbG9vayBuaWNlLg0KPiA+DQo+ID4gQmVuY2htYXJrIGFpbXMgdG8gaGVscCBn
ZXQgYmV0dGVyIHBlcmZvcm1hbmNlIGluIHJlYWxpdHkgSSB0aGluayA6LSkNCj4gDQo+IFN1cmUs
IGJ1dCBzeXN0ZW0gc3RhYmlsaXR5IGNvbWVzIGZpcnN0Lg0KPiANCj4gPg0KPiA+ID4NCj4gPiA+
IFNvbWV0aGluZyBtdXN0IGJlIHdyb25nIGluIHlvdXIgc2V0dXAsIGJlY2F1c2UgdGhlIG9ubHkg
c21hbGwgaXNzdWUNCj4gPiA+IHRoYXQgd2FzIG5vdGljZWQgd2FzIHRoZSBtZW1jZyBvbmUgdGhh
dCBTaGFrZWVsIHNvbHZlZCBsYXN0IHllYXIuDQo+ID4NCj4gPiBBcyBtZW50aW9uZWQgaW4gY29t
bWl0IGxvZywgdGhlIHRlc3QgaXMgdG8gY3JlYXRlIDggbWVtY2FjaGVkLW1lbXRpZXINCj4gPiBw
YWlycyBvbiB0aGUgc2FtZSBob3N0LCB3aGVuIHNlcnZlciBhbmQgY2xpZW50IG9mIHRoZSBzYW1l
IHBhaXINCj4gPiBjb25uZWN0IHRvIHRoZSBzYW1lIENQVSBzb2NrZXQgYW5kIHNoYXJlIHRoZSBz
YW1lIENQVSBzZXQgKDI4IENQVXMpLA0KPiA+IHRoZSBtZW1jZyBvdmVyaGVhZCBpcyBvYnZpb3Vz
bHkgaGlnaCBhcyBzaG93biBpbiBjb21taXQgbG9nLiBJZiB0aGV5DQo+ID4gYXJlIHNldCB3aXRo
IGRpZmZlcmVudCBDUFUgc2V0IGZyb20gc2VwYXJhdGUgQ1BVIHNvY2tldCwgdGhlIG92ZXJoZWFk
DQo+ID4gaXMgbm90IHNvIGhpZ2ggYnV0IHN0aWxsIG9ic2VydmVkLiAgSGVyZSBpcyB0aGUgc2Vy
dmVyL2NsaWVudCBjb21tYW5kIGluIG91cg0KPiB0ZXN0Og0KPiA+IHNlcnZlcjoNCj4gPiBtZW1j
YWNoZWQgLXAgJHtwb3J0X2l9IC10ICR7dGhyZWFkc19pfSAtYyAxMDI0MA0KPiA+IGNsaWVudDoN
Cj4gPiBtZW10aWVyX2JlbmNobWFyayAtLXNlcnZlcj0ke21lbWNhY2hlZF9pZH0gLS1wb3J0PSR7
cG9ydF9pfSBcDQo+ID4gLS1wcm90b2NvbD1tZW1jYWNoZV90ZXh0IC0tdGVzdC10aW1lPTIwIC0t
dGhyZWFkcz0ke3RocmVhZHNfaX0gXCAtYyAxDQo+ID4gLS1waXBlbGluZT0xNiAtLXJhdGlvPTE6
MTAwIC0tcnVuLWNvdW50PTUNCj4gPg0KPiA+IFNvLCBpcyB0aGVyZSBhbnl0aGluZyB3cm9uZyB5
b3Ugc2VlPw0KPiANCj4gUGxlYXNlIHBvc3QgL3Byb2Mvc3lzL25ldC9pcHY0L3RjcF9bcnddbWVt
IHNldHRpbmcsIGFuZCAiY2F0DQo+IC9wcm9jL25ldC9zb2Nrc3RhdCIgd2hpbGUgdGhlIHRlc3Qg
aXMgcnVubmluZy4NCg0KSGkgRXJpYywNCg0KSGVyZSBpcyB0aGUgb3V0cHV0IG9mIHRjcF9bcndd
bWVtOg0KDQp+JCBjYXQgL3Byb2Mvc3lzL25ldC9pcHY0L3RjcF9ybWVtDQo0MDk2ICAgIDEzMTA3
MiAgNjI5MTQ1Ng0KOn4kIGNhdCAvcHJvYy9zeXMvbmV0L2lwdjQvdGNwX3dtZW0NCjQwOTYgICAg
MTYzODQgICA0MTk0MzA0DQoNClJlZ2FyZGluZyAvcHJvYy9uZXQvc29ja3N0YXQsIGl0J3MgY2hh
bmdlZCBkdXJpbmcgcnVuLCAnbWVtJyBpcyBhbHNvDQpjaGFuZ2VkIGJ1dCBpdCBzZWVtcyBsZXNz
IHRoYW4gMSBwYWdlLCBmb3IgSSBjaGVja2VkIG1hbnVhbGx5LCAgaXQgbWlnaHQNCm5vdCBiZSBz
byBhY2N1cmF0ZS4gJ21lbScgaGVyZSBpcyBmb3IgJ3RjcF9tZW1vcnlfYWxsb2NhdGVkJyB3aGlj
aCBpcyBvbmx5DQpvbmx5IGFkZC9zdWIgd2hlbiAncGVyX2NwdV9md19hbGxvYycgcmVhY2hlcyBp
dHMgbGltaXQsIHJpZ2h0Pw0KDQo+IA0KPiBTb21lIG1tIGV4cGVydHMgc2hvdWxkIGNoaW1lIGlu
LCB0aGlzIGlzIG5vdCBhIG5ldHdvcmtpbmcgaXNzdWUuDQo+IA0KPiBJIHN1c3BlY3Qgc29tZSBr
aW5kIG9mIGFjY2lkZW50YWwgZmFsc2Ugc2hhcmluZy4NCj4gDQo+IENhbiB5b3UgcG9zdCB0aGlz
IGZyb20geW91ciAuY29uZmlnDQo+IA0KPiBncmVwIFJBTkRTVFJVQ1QgLmNvbmZpZw0KDQpDT05G
SUdfUkFORFNUUlVDVF9OT05FPXkNCg0KDQoNCg0KDQo=

