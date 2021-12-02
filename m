Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD51D466D58
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 23:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348780AbhLBW77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 17:59:59 -0500
Received: from mail-dm6nam11on2063.outbound.protection.outlook.com ([40.107.223.63]:54912
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243340AbhLBW76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 17:59:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1GK1i1uBn/rMgHhyVjPXgVFZDVCtW/LYwndlDSLCrQfJYGA2FHM4TM2TKtMLq351z8EiqYBvLXtbKAMB0m3J3zNMteilrMkdeh1Gz6GSIA0O9pQWZMeG85z+Vug0fYluewaur1+Irc7ALZWGFpRR65V797QuUVGgFzKqUTQD4UW8QNprOPinK2f2/sySUjn9fLhGv9oznqtrl5pRFJZtDzAMiaZM2gY+YKzA9HUHbpf9SrBgmvuWwfaWW3zClkiPQISTWubSTBz8cgMnfF+EKOt0TAlxgPDtbSLDfWCz/YtfwenC9n+qvybA7il0ULW6JAgyDEMqbgA/LctL1IFwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tf8NByhdOvy/fF7rOLhebtfcxpjsfnilEhW0WUjW2/0=;
 b=oQgufW5IDlswQxIVeDG3u6K5LuKE973iThVf1OHr6qmbgLgLqCUNUsTls8BxHI6JvGSslQBvRgaYMiSNMTp1vNJe1z9zd6NceUpZ4PCEDZbx2S91xZQehJahz7KYzI0ZwFfh73cyheWBse1b3UAr7MvykQMafxYA/C6HvRjEyC0ul0AWmrszMFFHXWVpKwloZwBVg9H7Vk2+/0cClmJlxMD5C7zpKIdhtFffcLo3uB8r2I59vo4o89U6eriH6VZGA58bB3SltTIf/LigJJOwOck7C35Rrl0QASpPyPjaqr6gnZGtsgvj4Cpg+RJBnwAndhxtWWlqzj0yPLYvB4t3Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tf8NByhdOvy/fF7rOLhebtfcxpjsfnilEhW0WUjW2/0=;
 b=PeN9tPjBVvYFHoWvy2jlE6OnrUbUEJN3UC1UudpUUdO/lMYSj7/N1XiSX4Qd2XFSa/LjMTvwx3JBrXCAcJWqzTapc/pmHLP53gOQhqGDdsMxYaGxWsWZoQMVOjL+S4mIYO9JHWSQ9M0kHYXvetfX4iq6wtyX+PftdJ9d+Vnk+/91GZVtD55mfcAP4aMolJ9cPOyFdOvUxmsxvQi7smg+u1JhdZfu+xgFbJezuL+2Hgb9kUOW6PgE7wMGYOgqcaOR/KK5pTeW6h8O0Xc9EXkPAAOesARq3fis8dzH+ohhjcp3xXeguQRzOSDFpWAW/eV4jioPrvAOxmeAA/LDbfbKnw==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB5016.namprd12.prod.outlook.com (2603:10b6:a03:1c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Thu, 2 Dec
 2021 22:56:28 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2%5]) with mapi id 15.20.4734.028; Thu, 2 Dec 2021
 22:56:28 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "amhamza.mgc@gmail.com" <amhamza.mgc@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: Fix dangling pointer access
Thread-Topic: [PATCH] net/mlx5: Fix dangling pointer access
Thread-Index: AQHX58orsQTsxtPZW0yxeuYAuda3BKwf0BkA
Date:   Thu, 2 Dec 2021 22:56:28 +0000
Message-ID: <c29127290d489ef883aba38e9c471049fd8304fe.camel@nvidia.com>
References: <20211202221539.113434-1-amhamza.mgc@gmail.com>
In-Reply-To: <20211202221539.113434-1-amhamza.mgc@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e30df535-055b-44bc-1024-08d9b5e6f9dd
x-ms-traffictypediagnostic: BY5PR12MB5016:
x-microsoft-antispam-prvs: <BY5PR12MB5016069AAB9C6F317D5B4D03B3699@BY5PR12MB5016.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HOYkjtrwufvLK9omL1erODTVEwGUonFlCXxVOYc++o8vsCGfPPDzEKX8346wIghAq2qmn0eljKMvAyDx3mu2RpeUYkl0iIFsZtV9GwJV0jb3qwsqrRIiVK5fCXh4v8vH2pVI1+BKmBgXliAaU34zEN3k//+eYdz7kXatf6euEDzoZIl1Pfbx1xSGfoC4rrJfvEA6D3v7dv+YdiOkSC1a/Dqxk3rcnibxV6PzmI7AhGGFY4H3hpC/mfNvBjuQfuBLBz/x+YZqIMerLioEG/pQM/AgbXYGmW3CbL3GkV8k8tPXGuLiH/T214we1lN8qzBuX8j6UW1ubf/bE1I1Jtd3l6TOIaxQZzQQngJ6Vp2IT1bCgwkEBtwo/Ti2A3+04kLDifuecz3quDGhnsCo9QFa/uBywVSMI6vbSDCtJEypdxZ+GuwxdrApMkz3nm2KOUmMUlCc1GIqQhVYH+BSjjkNIj4x8hiHNxt4YSYQmAA5clf/pVKkQSCLUouJu8yh2admKxtqmnDMS98rodWoK+/Rnk2y6N/qT3G3qjq+YIZTtYe+zl76SlXAF5xE/AA1PG78UjY5H6Yy75bIzFEit7s737uoku4ZRKtk7D87k0Z22S5KWcQ+9oMYRDf81vLP2Ae30HeHcETU6gwDAXlIFV89xLRnLip1AcOvRqNLb0dpUzNOcBjH8gveHZLeaQikwbsQnzNn4Jy+7NNp5ygVJ7CXmUxLMYWReEq0wX1TpKtHlEaaXoDjNXZB1WFnK5qgST5e0gH0r6/twz1/vMECDWE52T8uX2ueD7Zdg1WptmFEuYw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(8936002)(110136005)(508600001)(66476007)(66556008)(2906002)(8676002)(71200400001)(6486002)(26005)(76116006)(6512007)(38100700002)(2616005)(64756008)(316002)(86362001)(186003)(38070700005)(6506007)(36756003)(83380400001)(66946007)(5660300002)(4326008)(4744005)(966005)(122000001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Wmh0WjRCaW1lK1R1N05YSlk0NWIxRlRFZ3ZjZWNPZlpBM2lhV1VDeUNvVHl6?=
 =?utf-8?B?SjE0bHF2R3dnQ2l4bnZLL09QL3hzY3UyZUxyQ1k5NGkvQ3A0MDNpVmZwTkhr?=
 =?utf-8?B?S3VPNGdxWXB1WDhBUThTa3hvM2hUL3NGc1MzREFBRzhYTGpsUjhjTjV3REpo?=
 =?utf-8?B?ZzF4VHlIQ1BUeUtZcEgyMGEvRkxVUkFHbXZTZWJ4VWtLUE9jQ25PQVJCU0hv?=
 =?utf-8?B?WVhUMXYvMk9jcVI5SUg3bnN4VCs1b0JvYUdZTEhTTzMrWEIwbUUzMVovYzVB?=
 =?utf-8?B?ei9qaDJJbDduZXZUZzRxK0pjaVBTSWQyUHM4UWg0azYybnUwcU03Q2hCNzlB?=
 =?utf-8?B?eXlvTFFuUU1FN3hxSGpNQVNSOFkySkhHNEtMcm05OW92cFF3Yi96T0FNLzlr?=
 =?utf-8?B?M3EzdHVCSkZQNUpBaXdhVUpRZnJJZTdyZzhOQlBPSTArNElrcmNKQzBJN2Zs?=
 =?utf-8?B?OVhjWmphYWRnMGhQV3ZHQ3Q3REJyVjZDaFp2TExYS1dPSDYxMTVSVEZRUGZU?=
 =?utf-8?B?N3ZOSFYvQUxqVE1ZQjlYaStRcDJtd0s0YjdFRDNEZmhPc08vWnZnQ0pDRys5?=
 =?utf-8?B?NklXZHNMUGJyMWYyaGFIVHVGbUZzVUtBNGxJcHUxWWxMYXZKZVJJVm9nb3du?=
 =?utf-8?B?SkxGbUdtNHlRVytUanAzZm9KUlZOZW9sUyswd1kybWtEdzU0TjlFeW1LWks2?=
 =?utf-8?B?bG9wcjc5S0pydXZkQmNqL2VZOXJHQXNlejVhYWs5Z3pVZkhwenB4TTF1NUtL?=
 =?utf-8?B?Wnd5OVRMcHRPcEpGS3A5TnAzQlpUdW5nZGtIaHVySXFDeUIyYXhqVFdFYXBH?=
 =?utf-8?B?YVRiS0hCNlRlQnZ2SkEwMXVwU0tIRXczRE43V1owdklhcFFlWTVoQW0wRXQ4?=
 =?utf-8?B?cmVXV3N5RUM4VkxPMGYrbGw0Y0p1Y3RKelRPUnJMdTRWSkJQMlp4M2x4RHQw?=
 =?utf-8?B?NHpjb29Db0thQm5RQUpJb0dvRlJJQW53aTJQTXRwai9CaGtoZGF2aFVSQlEr?=
 =?utf-8?B?R0RwWWZzOER4ZUNCazV0WXdjSU5zVW5yUEFUaHlNUnFMNnRMNEdrRG5ONE9F?=
 =?utf-8?B?bjdlRkZLSy9QNkxYcGJKd00zcjh3UDZaVVQreFBBTURxSm5WU21aWldWdmdo?=
 =?utf-8?B?VVYyb3lIRVpMdmlyM3hiQVZ0TzhYVWNheTNPRXJwdTJCbk13SjA3QTBDNTly?=
 =?utf-8?B?ZzhOSzlZMEVtekxGRHdnTmRqYjA4UVVuRmtnV1RNVlM5cUo4MWdKanBFKzlY?=
 =?utf-8?B?ZXNQRW1xWktKT05nd3J0eVdwOFd3cmJkOTNmMFJvRVJabnZJQjl6K3Fsa2pH?=
 =?utf-8?B?YVZKU0pMOWt3aTJVeXRHUGhJUjI0cmFzdGFFRVFCRXpWTUMrRzlqdE1wRVNk?=
 =?utf-8?B?VnE0NldneGQwdkFBQ0tVR0F2cVgvNXhWVTRVOFB4NndMT0hqSEhSVTVvaEh0?=
 =?utf-8?B?VlBNTS9XM3RTT21GOXdvL1k2T1BwdlpxMUdUMzZwNXRnLzJ2V0piYnd5blY3?=
 =?utf-8?B?MUlkODN2dml0REZEbXBnZmwwUE9QaS9VWXJWMjZINTFBdmc4QkNCN3BpdDRa?=
 =?utf-8?B?eW1IZ1cvT1RCVE1PcFF4NkQvSzRlNUhtYldRdjZNZDlGc3ppRE50Y1dtWEJW?=
 =?utf-8?B?Y05vV0lzek5waVUwVVRLdHVJRENKRTZ0MzZsTmEyM0hkUE5UWjBUYUNicTJK?=
 =?utf-8?B?RmRCNjR0bDkyYjhuOTBZRndFYmFjN1NqcE9qaGtQSjRCTEx1UUNUVjdwb1lT?=
 =?utf-8?B?ZTYrNnZKYm9ONjFzaW82eGFvQzJZdjJ5dlNvTzZCRzZZeEMzZXhxeE9ka0hH?=
 =?utf-8?B?YlpKKy9hcVltSDg0QjN5aXlSejMrRnFiekljWHNnejk0QlE1UzJGOFNSU1ky?=
 =?utf-8?B?azRHOTgwaEhIWjVvMkYzOEtRSU9ZU2U1dTkvbFJ4czVmVlNDbXBMVVAveVQ2?=
 =?utf-8?B?MVAvUy9jSFBlZVcrbjlObkJHS0kxN3VKaVRxVU1DUWp0SjU0cmpJU0kxeURD?=
 =?utf-8?B?ZmdQMHFaVW9xZnNYaHhPNnRDNDlHRkVMWVNoeXlqZVNoQkx5SWJSbjIreWh6?=
 =?utf-8?B?aDAyV1RYa04zRlp0aHBleldtK0FjSUZFaGloc0V5dk5jZWk0T0FKNzcyYjBo?=
 =?utf-8?B?OUk1bEJZeWJxQWFCakZYZ21uajVjMmE0aXNuT2tGd2VVcWRhck9kSVhlNVZS?=
 =?utf-8?Q?zYMD7eFqVsaDND5CUhmY2WY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <37AB67481ADBE445BF33A61BE0037AE6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e30df535-055b-44bc-1024-08d9b5e6f9dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 22:56:28.7770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5rHj/63d9NU4qieANjm8opbSeYRBOM4P31d7IV2/Uhi1pByr7074pagGkWluMPlLlQH+ksjATOiwVdUyQ8jRKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5016
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTEyLTAzIGF0IDAzOjE1ICswNTAwLCBBbWVlciBIYW16YSB3cm90ZToNCj4g
Rml4IGZvciBkYW5nbGluZyBwb2ludGVyIGFjY2VzcyByZXBvcnRlZCBieSBDb3Zlcml0eS4NCj4g
DQo+IEFkZHJlc3Nlcy1Db3Zlcml0eTogMTQ5NDEzOCAoIlVzZSBhZnRlciBmcmVlIikNCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IEFtZWVyIEhhbXphIDxhbWhhbXphLm1nY0BnbWFpbC5jb20+DQo+IC0t
LQ0KPiDCoGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9oZWFsdGguYyB8
IDIgKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvaGVhbHRoLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
aGVhbHRoLmMNCj4gaW5kZXggM2NhOTk4ODc0YzUwLi44NTYwMjMzMjE5NzIgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9oZWFsdGguYw0KPiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMNCj4g
QEAgLTMzNSw3ICszMzUsNyBAQCBzdGF0aWMgaW50IG1seDVfaGVhbHRoX3RyeV9yZWNvdmVyKHN0
cnVjdA0KPiBtbHg1X2NvcmVfZGV2ICpkZXYpDQo+IMKgew0KPiDCoMKgwqDCoMKgwqDCoMKgbWx4
NV9jb3JlX3dhcm4oZGV2LCAiaGFuZGxpbmcgYmFkIGRldmljZSBoZXJlXG4iKTsNCj4gwqDCoMKg
wqDCoMKgwqDCoG1seDVfaGFuZGxlX2JhZF9zdGF0ZShkZXYpOw0KPiAtwqDCoMKgwqDCoMKgwqBp
ZiAobWx4NV9oZWFsdGhfd2FpdF9wY2lfdXAoZGV2KSkgew0KPiArwqDCoMKgwqDCoMKgwqBpZiAo
ZGV2LT50aW1lb3V0cyAmJiBtbHg1X2hlYWx0aF93YWl0X3BjaV91cChkZXYpKSB7DQoNCg0KdGhl
IHByb3BlciBmaXggd2FzIGFscmVhZHkgc3VibWl0dGVkIGFuZCBhY2NlcHRlZCB0byBuZXQ6DQpo
dHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMTEyMDEwNjM3MDkuMjI5MTAzLTExLXNh
ZWVkQGtlcm5lbC5vcmcvDQoNClRoYW5rIHlvdQ0KDQo=
