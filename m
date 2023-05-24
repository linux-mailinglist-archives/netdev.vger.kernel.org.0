Return-Path: <netdev+bounces-4956-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3B3270F5D4
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:03:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D6731C20C0E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3093617ADA;
	Wed, 24 May 2023 12:03:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0886F8472;
	Wed, 24 May 2023 12:03:22 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8728F135;
	Wed, 24 May 2023 05:03:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFtRslZATU/Qtpehgq9eGTrUnxQUq1StPGIxbvspF7Y4JDESDBSR1M4rCE4KVMyNHV8gw59U2nj1MWM8ksfKM4q4u0EMpyhVraKfCbjN/IqfDuyxD6uIfsZrBcGREK8JHHOjAIriOiTwwgyxRAk+hdX2IZMnqPGOvOuxAmNsKUJNlJrQiPpEHNUnT4xCwJmKBCbfGzWxmdI8br3wqal/z9Mw5x+BtuxMiYKAXGxj5frhZAto+t5yl4TYJbdp626wDjrc9Jr3baWP0TsAtkNib8SeMFsG1D/qLWWs9+YDuCLACF6lWPjMhhzQqMzuVe0G5Zbu45p1tT6Cfi2FzLCctw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tUqAa5hLbi1T4H3nn7mA+WFXg3IDDHEqrjGiMFCvtJo=;
 b=a20967AzOLyvNTEM/aFj4slEr2rvD0+lmWA99PNwD+ge0jvg9ABNJV30kpPxrDOq4JNrBKWYc7TRBtFUyndMeQjo8PpvZxk4fg5PxOmK8F26RsKARvxhwQBbb4tzRL5xZuA4tOqu8ASWY7BFsKV07baDymYSTsPXQWWbvmX1NcnhCRdTYxpxc7AuwzKWxRrn1LLi/xmk457edkEEpxrROY25YRiXtBMMixMZmajDdSx89VTzvqkgRKlmu1USGB1qzhIJm2rPrKddAGd2YHE75sf0ZKqgSEg7xESEkL9G39F0dlLUrVyQczzBheC1bRkRhZ6O92Ncmoq8M4/sefJAeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUqAa5hLbi1T4H3nn7mA+WFXg3IDDHEqrjGiMFCvtJo=;
 b=ecieDn1GWHwRzuQlVinJYFmklgCn/ZqvAnuO4vvIdVOLIOMw5F6wceQpGxXuYXiCDkaSW+MIxQwltAHI2Cv/rbYdNV3l3Uten06RJnmw8Tcd6EjYgwcz6RqUQOqabmyuW5C8U34WPipXl/EHJCc6zAheeY5ItzASMZPzGDFxWTQT4Z338F0Qc7mdN7RrmUK/VQCxRLxyLDjvVWeD/egA4Vg8KS1iiWBxRQlwglDlvzGaYkKJamZj6GS9pMbklH57RSmBPkGZSEoxROEOTTFlnHuT57FvLnLqN5l6gsbnHJOozjlsZJDD8owXVs551Q6Y2N5h75cGa4GahQSZHDgkmg==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by BL1PR12MB5969.namprd12.prod.outlook.com (2603:10b6:208:398::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 12:03:16 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::9e8a:eef5:eb8a:4a02]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::9e8a:eef5:eb8a:4a02%6]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 12:03:16 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>, "ttoukan.linux@gmail.com"
	<ttoukan.linux@gmail.com>, "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
	"jbrouer@redhat.com" <jbrouer@redhat.com>, "saeed@kernel.org"
	<saeed@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "maxtram95@gmail.com" <maxtram95@gmail.com>, "lorenzo@kernel.org"
	<lorenzo@kernel.org>, "alexander.duyck@gmail.com"
	<alexander.duyck@gmail.com>, "kheib@redhat.com" <kheib@redhat.com>,
	"ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
	"mkabat@redhat.com" <mkabat@redhat.com>, "brouer@redhat.com"
	<brouer@redhat.com>, "atzin@redhat.com" <atzin@redhat.com>,
	"fmaurer@redhat.com" <fmaurer@redhat.com>, "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>, "jbenc@redhat.com" <jbenc@redhat.com>
Subject: Re: mlx5 XDP redirect leaking memory on kernel 6.3
Thread-Topic: mlx5 XDP redirect leaking memory on kernel 6.3
Thread-Index: AQHZjY743nR7ST598kifD6Q1M3DiL69oDfyAgAE79oCAAApggA==
Date: Wed, 24 May 2023 12:03:16 +0000
Message-ID: <6de64ad1fa9c4c82de190d4f71923984979782d8.camel@nvidia.com>
References: <d862a131-5e31-bd26-84f7-fd8764ca9d48@redhat.com>
	 <00ca7beb7fe054a3ba1a36c61c1e3b1314369f11.camel@nvidia.com>
	 <7a0bd108-ba00-add9-a244-02a6c3cb64df@huawei.com>
In-Reply-To: <7a0bd108-ba00-add9-a244-02a6c3cb64df@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|BL1PR12MB5969:EE_
x-ms-office365-filtering-correlation-id: 18003d99-391c-4cc9-b193-08db5c4edb6b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 kM0CqpydrM/0ulAhD1lWKTXOdjffjZT2r6KHZy3oioxEChlU3UNJBVK7BhvO3XJqiIu9fHt6dJ/O7kIzjdRYBzlZKMV400rVpOfXZHeg6n8GFybP8mfjXJfj/7wgRIBxnLYH3BAjt4/siB4AlUjWTJHM4HLQXVXhckUdH2ajhC1F/nIStIFr8z2O6p0IjAWpBYYcl4KHY0vj4GBiotT0Ut3mQZf3SCk90GpMWbdGYaimxj2c+6PhYDXALUfR76tQFp54Q2ePxi0XV5a2cQ9C18gYcOWHvHO8yWBzmHnenQ1AGdReje/nDRzgE1TT7fZOs3NGuH03e8mCmppvsOOd20HBTCcQjKOWtQpJnMhaf0sMsl9vkRvwbwwI5dKT5/n/p6obNV6hu0vPTQI4BAabFjZulOlXXa2N/YdbRxNtUpo8ZUFO8fmUZJhNnU8gMGk2gSbVXWHdQElpfU7FPzm1pj7v2hiUmVOKAGCnAxh5IuPQ/2ERW9n2CVpB6fSQYucG72QIqpHhGQaWLlIkrGIW6qWJwZ3WCkOMwnpHojUk1xGrors3mfWwrDXOY7Jp9vy7OOM5d3mjd5nssdNWKFCSwklwRRSb6QXD9XlupyDtwN1AYrWQMXLg/CcdwEJdqolrBaPJsA+AAlCCM2XlXQb9O1i0M/VKF/L+oi3laIhOINBYVmhDega7m1BNGoXdITjaHJADkTjbFkKGsaFvTJ18iQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199021)(7416002)(5660300002)(2906002)(8936002)(316002)(66946007)(4326008)(64756008)(66446008)(66476007)(91956017)(66556008)(76116006)(54906003)(8676002)(478600001)(110136005)(83380400001)(2616005)(71200400001)(53546011)(186003)(6512007)(6506007)(36756003)(41300700001)(86362001)(38070700005)(38100700002)(966005)(6486002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dUpxcVdBZTVBckk4cks4VWFrVlhGUU5uVnh2Tjd6STJqaXlwN1pkU21uUm4v?=
 =?utf-8?B?Z2xHcDltVDRFMERIdENaVThVcTBuM0Y5cGpTTGY1UDN4RjUzWmdiNUl3YUUr?=
 =?utf-8?B?RmJOL3lSN3BtTGd3WG5hL21yekNMNkptc0lEVTkwRDNXQ2RnZWJjck16d0VN?=
 =?utf-8?B?QlZuWlc4RmtRZmdpejdGbHpaMjkvTGF6bDdTTk9vL3lzcHR1WTl5bnY4ajRN?=
 =?utf-8?B?YjNkZXphK0w2MEpKNFJ4R2loVVREM29LZG1HNnJDbkRQNWJhaG84K05ReXc3?=
 =?utf-8?B?eWZwY1JJVWRmSGpVQ1RwNlFLOU85NCsydis3MTV1NW5HajBnejFrdkhOOURy?=
 =?utf-8?B?cHRydXJJSG5ISFQzcXZQbUl0QWQ4ajZUWGJQOWZJZThvNnVGL1V6SjM4MHhj?=
 =?utf-8?B?V2kzekFTNWtkVkFTZkdQUUxTa2d1bm1KR3ppb3pGemdFYnJRbFNxV01jcU15?=
 =?utf-8?B?UVUxbWo4bmFKMTF5SXQwYXhnYjJ1MVNORmZrWHNyQmFXWVFtWFhpdGtNSEhO?=
 =?utf-8?B?bnI2ZzNtY2svcHY3VDFYclZ1Tm9ZWjFXR1J0bXUyNlF6dW1tK25wYWlTY2lF?=
 =?utf-8?B?QndJUnVxTTIyVTFlbWtTOVllSFQxc2tWYjR1NmJWVVIrQ281TCs1dU1iaXdH?=
 =?utf-8?B?bVUyQnZwc2RzQjZmdWxLT3g1U25PdGJMK09QVEJ1U05IOWREUDJKeGx6blZi?=
 =?utf-8?B?SG9IUDlaMXdVMWFQV1VZbTNLL1BnYTg4dGVMVkVOUmxyWlQ5Rm94M2g5QitR?=
 =?utf-8?B?Qy9PS2N0aWxMd2krM2RMQTk0KzhrUklnZE1WRU9kc1gyK0pCNUoydlFIOTRQ?=
 =?utf-8?B?R2prbkpxWVprOXpHdVEvUy9BQUg0U096QW8zaHQ3VXVuMzgrMVVBQWh0SFZL?=
 =?utf-8?B?T1lTL3pXMEhDMFhqYUVCUHBPYlFwcHZ5bkx3TTRRM0pKSkxGcitPMHZpQmM0?=
 =?utf-8?B?Z3JoYmI1UmpuV3g1U2VGS1IvSUtDQUVVd2pSQW4wTnlqUHJNVUNRYVBjMVBi?=
 =?utf-8?B?eUJ2Z29ldkFQblpCMG1UOHV1V0o4ZWViUlBRUmpPOTZNMkc5TTZxQTF1cWxp?=
 =?utf-8?B?S2tTRE9RWlJIcjRuVXRLK2hiRlVGTzBXVFV4VDlMaVZIOFNkMGdNa2pEcmtJ?=
 =?utf-8?B?YnNZanVWTTBWZy80S0pGdHBuVG9mcEp1UTNUSms1ZnUvMk4yMnY0S2tCTVF3?=
 =?utf-8?B?aGV2c1VHRitoazVONUdPcTFlc3ltdDdiSlhPczdXdFBRN2cvb3pPNUFiK0Mz?=
 =?utf-8?B?T3JFMno2NENlN0J2bm1vVUFlWE53OW93T1lXM3hhSjJueEJUWnNjdlJyQmRX?=
 =?utf-8?B?NWV1cVJNbzdzZEhscHgreDRZT1pEeGdsalhxSTZQN1p6MVpUckVyRUdCV0Fw?=
 =?utf-8?B?c3cycEw3L0ZVSHZHN0xvM2pUUVhXRGZiOUZQdWVYZ1NxazFhOEhhTWJsMHBp?=
 =?utf-8?B?NnkzTnJMdmsrUG14WVkwTjBuSVdDT014NnQ3WHArZzJPNUtZY3g0WTlvTEtN?=
 =?utf-8?B?YVZ6L1YzemlPTDN3azhod0s0ZDNNMmIzNkZVOGl3blRSY3M0VXYrVDFESjEz?=
 =?utf-8?B?bVJJM04wekRlRjdGUWcrVWtHRjZXMFhQRFRrY1pQeXZNREhUemJmZkpBdEhv?=
 =?utf-8?B?RTdKZ2JLVWJWS1J0M3U4a2FDUUhYdXQwRjlvcitMVU5GZEh6SzBNTlgyQ2VZ?=
 =?utf-8?B?WXpKVlVadldrZ3RPRUpReEhBMG9kUmVOT0hHaDlCOVZVQkJPLzAwSy9JbWdx?=
 =?utf-8?B?bjdQLzZuNHk5WGFweWhCQ1N1eWhJbm5yd0xRZksvMFJlR1N4MHUrMk51UTBu?=
 =?utf-8?B?NWFISzVINm5RMGZtNFBwTHZ1TFFJeUFOWTk3SC9EYkVZZ1JsZXZXbElabUNk?=
 =?utf-8?B?ZGNzRzhUNzBhYTVJcS9mbklvKzlsTGI4L3lsTVkwZ1paclc0a2NiS0RMWmJm?=
 =?utf-8?B?aTdLM05hUWphVnJhdkZJQmwzQmxBdFh1YlhSdVFSb3pKS0hjQ0xPdXYyZERQ?=
 =?utf-8?B?bkpta0ExYit2d0pMY085N2Ftd2haL3haSktoanZRMzhMWm5iMmhZdVVqeG81?=
 =?utf-8?B?TytacXRqQ1p4TnpsYlpYY0llN3ZTeE1pc0lhZENWN1BVejhQZDcrdHIyeGtq?=
 =?utf-8?B?SGJrSm10aDU5eDBxZDFOdlJzSzNVcGJHZXRSQjNmL3BlSnd2WXVCMHIyeGVS?=
 =?utf-8?Q?7UxPo34gdh6HTaG47QxOHCBslMZNQ7PYFKyXME/g0gyU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A049F430AA186D4AB4922D2279C88CCE@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18003d99-391c-4cc9-b193-08db5c4edb6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 12:03:16.1127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zdhELGL20SIohY92tOJeoVxSgG80W8d8gkbc24RD4Oq3y86e/ByNCxy9vhIVE7Zc1jO8P25qTsHmEQn9cZqcuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5969
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gV2VkLCAyMDIzLTA1LTI0IGF0IDE5OjI2ICswODAwLCBZdW5zaGVuZyBMaW4gd3JvdGU6DQo+
IE9uIDIwMjMvNS8yNCAwOjM1LCBEcmFnb3MgVGF0dWxlYSB3cm90ZToNCj4gPiANCj4gPiBPbiBU
dWUsIDIwMjMtMDUtMjMgYXQgMTc6NTUgKzAyMDAsIEplc3BlciBEYW5nYWFyZCBCcm91ZXIgd3Jv
dGU6DQo+ID4gPiANCj4gPiA+IFdoZW4gdGhlIG1seDUgZHJpdmVyIHJ1bnMgYW4gWERQIHByb2dy
YW0gZG9pbmcgWERQX1JFRElSRUNULCB0aGVuIG1lbW9yeQ0KPiA+ID4gaXMgZ2V0dGluZyBsZWFr
ZWQuIE90aGVyIFhEUCBhY3Rpb25zLCBsaWtlIFhEUF9EUk9QLCBYRFBfUEFTUyBhbmQgWERQX1RY
DQo+ID4gPiB3b3JrcyBjb3JyZWN0bHkuIEkgdGVzdGVkIGJvdGggcmVkaXJlY3RpbmcgYmFjayBv
dXQgc2FtZSBtbHg1IGRldmljZSBhbmQNCj4gPiA+IGNwdW1hcCByZWRpcmVjdCAod2l0aCBYRFBf
UEFTUyksIHdoaWNoIGJvdGggY2F1c2UgbGVha2luZy4NCj4gPiA+IA0KPiA+ID4gQWZ0ZXIgcmVt
b3ZpbmcgdGhlIFhEUCBwcm9nLCB3aGljaCBhbHNvIGNhdXNlIHRoZSBwYWdlX3Bvb2wgdG8gYmUN
Cj4gPiA+IHJlbGVhc2VkIGJ5IG1seDUsIHRoZW4gdGhlIGxlYWtzIGFyZSB2aXNpYmxlIHZpYSB0
aGUgcGFnZV9wb29sIHBlcmlvZGljDQo+ID4gPiBpbmZsaWdodCByZXBvcnRzLiBJIGhhdmUgdGhp
cyBicGZ0cmFjZVsxXSB0b29sIHRoYXQgSSBhbHNvIHVzZSB0byBkZXRlY3QNCj4gPiA+IHRoZSBw
cm9ibGVtIGZhc3RlciAobm90IHdhaXRpbmcgNjAgc2VjIGZvciBhIHJlcG9ydCkuDQo+ID4gPiAN
Cj4gPiA+IMKgIFsxXSANCj4gPiA+IGh0dHBzOi8vZ2l0aHViLmNvbS94ZHAtcHJvamVjdC94ZHAt
cHJvamVjdC9ibG9iL21hc3Rlci9hcmVhcy9tZW0vYnBmdHJhY2UvcGFnZV9wb29sX3RyYWNrX3No
dXRkb3duMDEuYnQNCj4gPiA+IA0KPiA+ID4gSSd2ZSBiZWVuIGRlYnVnZ2luZyBhbmQgcmVhZGlu
ZyB0aHJvdWdoIHRoZSBjb2RlIGZvciBhIGNvdXBsZSBvZiBkYXlzLA0KPiA+ID4gYnV0IEkndmUg
bm90IGZvdW5kIHRoZSByb290LWNhdXNlLCB5ZXQuIEkgd291bGQgYXBwcmVjaWF0ZSBuZXcgaWRl
YXMNCj4gPiA+IHdoZXJlIHRvIGxvb2sgYW5kIGZyZXNoIGV5ZXMgb24gdGhlIGlzc3VlLg0KPiA+
ID4gDQo+ID4gPiANCj4gPiA+IFRvIExpbiwgaXQgbG9va3MgbGlrZSBtbHg1IHVzZXMgUFBfRkxB
R19QQUdFX0ZSQUcsIGFuZCBteSBjdXJyZW50DQo+ID4gPiBzdXNwaWNpb24gaXMgdGhhdCBtbHg1
IGRyaXZlciBkb2Vzbid0IGZ1bGx5IHJlbGVhc2UgdGhlIGJpYXMgY291bnQgKGhpbnQNCj4gPiA+
IHNlZSBNTFg1RV9QQUdFQ05UX0JJQVNfTUFYKS4NCj4gDQo+IEl0IHNlZW1zIG1seDUgaXMgaW1w
bGVtZW50aW5nIGl0J3Mgb3duIGZyYWcgYWxsb2NhdGlvbiBzY2hlbWUsIGl0IHRoZXJlIGENCj4g
cmVhc29uIHdoeSB0aGUgbmF0aXZlIGZyYWcgYWxsb2NhdGlvbiBzY2hlbWUgaW4gcGFnZSBwb29s
IGlzIG5vdCB1c2VkP8KgVG8NCj4gYXZvaWQgdGhlICIoKHBhZ2UtPnBwX21hZ2ljICYgfjB4M1VM
KSA9PSBQUF9TSUdOQVRVUkUpIiBjaGVja2luZz8NCg0KbWx4NSB1c2VzIGZyYWdtZW50YXRpb24g
b2YgdGhlIHBhZ2UgZnJvbSB3aXRoaW4gdGhlIGRyaXZlciBpbnN0ZWFkIG9mIHRoZSBwcmUtDQpw
YXJ0aXRpb25pbmcgb2YgdGhlIHBhZ2UgdXNpbmcgcGFnZV9wb29sX2FsbG9jX2ZyYWcoKS4gQXMg
c2hvd24gaW4gY29tbWl0DQo1MmNjNmZmYzBhYjIgKCJwYWdlX3Bvb2w6IFJlZmFjdG9yIHBhZ2Vf
cG9vbCB0byBlbmFibGUgZnJhZ21lbnRpbmcgYWZ0ZXINCmFsbG9jYXRpb24iKQ0KDQpUaGUgZXhj
ZXB0aW9uIGlzIGhvd2V2ZXIgdGhlIGZvbGxvd2luZyBvcHRpbWl6YXRpb246DQpwYWdlX3Bvb2xf
cHV0X2RlZnJhZ2dlZF9wYWdlKCkgY2FuIGJlIGNhbGxlZCBmb3IgWERQX1RYIGRpcmVjdGx5IHRv
IGF2b2lkIHRoZQ0Kb3ZlcmhlYWQgb2YgZnJhZ21lbnQgbWFuYWdlbWVudC4gVGhhdCdzIGJlY2F1
c2UgbWx4NSBjdXJyZW50bHkgc3VwcG9ydHMgb25seSBvbmUNCnBhY2tldCBwZXIgcGFnZSBmb3Ig
WERQLg0KDQo+ID4gPiANCj4gPiANCj4gPiBUaGFua3MgZm9yIHRoZSByZXBvcnQgSmVzcGVyLiBJ
bmNpZGVudGFsbHkgSSd2ZSBqdXN0IHBpY2tlZCB1cCB0aGlzIGlzc3VlDQo+ID4gdG9kYXkNCj4g
PiBhcyB3ZWxsLg0KPiA+IA0KPiA+IE9uIFhEUCByZWRpcmVjdCBhbmQgdHgsIHRoZSBwYWdlIGlz
IHNldCB0byBza2lwIHRoZSBiaWFzIGNvdW50ZXIgcmVsZWFzZQ0KPiA+IHdpdGgNCj4gPiB0aGUg
ZXhwZWN0YXRpb24gdGhhdCBwYWdlX3Bvb2xfcHV0X2RlZnJhZ2dlZF9wYWdlIHdpbGwgYmUgY2Fs
bGVkIGZyb20gWzFdLg0KPiA+IEJ1dCwNCj4gDQo+IHBhZ2VfcG9vbF9wdXRfZGVmcmFnZ2VkX3Bh
Z2UoKSBjYW4gb25seSBiZSBjYWxsZWQgd2hlbiB0aGVyZSBpcyBvbmx5IHVzZXINCj4gdXNpbmcN
Cj4gdGhlIHBhZ2UsIEkgYW0gbm90IHN1cmUgaG93IGl0IGNhbiBlbnN1cmUgdGhhdCB5ZXQuDQo+
IA0KU2VlIHByZXZpb3VzIGNvbW1lbnQuDQoNCj4gPiBhcyBJIGZvdW5kIG91dCBub3csIGR1cmlu
ZyBYRFAgcmVkaXJlY3Qgb25seSBvbmUgZnJhZ21lbnQgb2YgdGhlIHBhZ2UgaXMNCj4gPiByZWxl
YXNlZCBpbiB4ZHAgY29yZSBbMl0uIFRoaXMgaXMgd2hlcmUgdGhlIGxlYWsgaXMgY29taW5nIGZy
b20uDQo+ID4gDQo+ID4gV2UnbGwgcHJvdmlkZSBhIGZpeCBzb29uLg0KPiA+IA0KPiA+IFsxXQ0K
PiA+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L25ldGRl
di9uZXQtbmV4dC5naXQvdHJlZS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW4veGRwLmMjbjY2NQ0KPiA+IA0KPiA+IFsyXQ0KPiA+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L25ldGRldi9uZXQtbmV4dC5naXQvdHJlZS9uZXQv
Y29yZS94ZHAuYyNuMzkwDQo+ID4gDQo+ID4gVGhhbmtzLA0KPiA+IERyYWdvcw0KPiA+IA0KPiA+
IA0KDQo=

