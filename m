Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9479C44C619
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 18:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhKJRnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 12:43:02 -0500
Received: from mail-dm6nam10on2048.outbound.protection.outlook.com ([40.107.93.48]:9568
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230230AbhKJRnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 12:43:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRZJelBj+5UAWqM67QWriqq1GoeRm1FHuBw62Ga78Ybr318S43S7sM8be1kSArJgdl8sDmzGSXhMyoyJeScLCDDdl/SU+ox5ukeXiqxy6lKsp+XHHTkdN0RAI3i0gfPexRYO+b3mZdrNXXgdJIBfccvkvbHZGVmnsasxs/+DET6BeYh3x9gKaQTEWgucPNRx+ip+tzu1bMFeTbp3i6FfuhPV7xxFr1zMLPD/OiWvA+cIyHFrnNGgXgBIrIdo/907NMvshaSw0zuqMCL/I9ZAmx3Guh68OXgJ7x0EoOf4LcaAJEQeqltI3TTyKbH6ZSMAqSsSCrIaYE6S1S21rU2vaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HY6YUdWhtxlyodGoyfYfubgS+S+EJ0EVQJrLj+DiVag=;
 b=Q+gDYqoLGZBxvmfc+S8P6JtfHc8SHbUY2/VoJXwUONV9/e59UXOwkVlIkgoV2931hAzNWaXSragb5BKOPhaUFyjZ5gsUA6FO0MBTTG285rT3qD0iFG7ONJQmvWkOnXlCCu2M9evHTe5Omkd2yTCxaxO5HOvs3wF5hrF52VzzZiGpLnHNjfgFIyRHT8Wzz9+j/qL+NBUIRoug/Ca478xWPWuHdThNvm1tDVkLY5nNiFoFUfzFcVXeO8Hlj96XKb7jEHnmZNlOgMmBalIux8L/MqzqPBkbK3rJ51qy2uHYlYtBxz9oHdQz5AsewkERVMdC95dgsDbPS4V1kJliiovfMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HY6YUdWhtxlyodGoyfYfubgS+S+EJ0EVQJrLj+DiVag=;
 b=MW5i6CvuIe6vQbhZKLWBZFxxNjoiU9j6fuB8VVx1GVgD8uE5WUPoip7FqxYno9fj9aY4aj6lc3QcSqrYFcuC15j7kSIeBeZlfsmxTgd5lqNJLnqZVnLDFvGrIhNvzZto2RxC6bgME1dsD+UHgcLuQ7TKDbDZIuYmXUv32Ur32WY=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by SJ0PR05MB7658.namprd05.prod.outlook.com (2603:10b6:a03:2e5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5; Wed, 10 Nov
 2021 17:40:10 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::fd9a:e92c:5d9e:9f6d]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::fd9a:e92c:5d9e:9f6d%9]) with mapi id 15.20.4690.015; Wed, 10 Nov 2021
 17:40:10 +0000
From:   Nadav Amit <namit@vmware.com>
To:     "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>
CC:     Joe Perches <joe@perches.com>, Juergen Gross <jgross@suse.com>,
        X86 ML <x86@kernel.org>, Pv-drivers <Pv-drivers@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        Linux-graphics-maintainer <Linux-graphics-maintainer@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Zack Rusin <zackr@vmware.com>, Deep Shah <sdeep@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Keerthana Kalyanasundaram <keerthanak@vmware.com>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] MAINTAINERS: Mark VMware mailing list entries as
 private
Thread-Topic: [PATCH 2/2] MAINTAINERS: Mark VMware mailing list entries as
 private
Thread-Index: AQHX1N78hdP2HY1w7EKJ7QP4MiAOaqv6SY6AgAAMZACAAARXAIAABd+AgAFfsICAAUTLAIAABaAA
Date:   Wed, 10 Nov 2021 17:40:09 +0000
Message-ID: <F21C4118-BFDE-4DA7-B42F-90EC71CFED57@vmware.com>
References: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
 <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
 <5179a7c097e0bb88f95642a394f53c53e64b66b1.camel@perches.com>
 <cb03ca42-b777-3d1a-5aba-b01cd19efa9a@csail.mit.edu>
 <dcbd19fcd1625146f4db267f84abd7412513d20e.camel@perches.com>
 <5C24FB2A-D2C0-4D95-A0C0-B48C4B8D5AF4@vmware.com>
 <1875b0458294d23d8e3260d2824894b095d6a62d.camel@perches.com>
 <20211110172000.GA121926@csail.mit.edu>
In-Reply-To: <20211110172000.GA121926@csail.mit.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6077667d-92fe-46a8-3b37-08d9a471247d
x-ms-traffictypediagnostic: SJ0PR05MB7658:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR05MB76585626C48A4A3D04B01D31D0939@SJ0PR05MB7658.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ClasftLsmNYfdf0Vjtaxa2nQxeu021j3Ks5/Ic6qcAwLk5jQPclbvpEdOzEVJ0zusWZQWEyX2SznTHq4UMZrkc7fhoCh1cwgxEiBBiYulWn+aZxWL4+SBe6dBDvjCqNJwW11eaijtqZzrlG+ewEdAL/wgSLHMUJsQiIF5bOO9VbYqwXl7/Ctus6e6Fn1a6A273LjvK5lhqspUTuTXRr81/1Bz822FBEeRkvU0OC9BTGCpIkMOu6daoIwJdNbltnfmqPXjs1r9SusZFGwp2diJrcWTQDj4UZZXEAupPX/8+1tsT38BBcYdTulSpcjnFp9jbRfcCuDci/0npgaXp17tp1nXwwZAar8NjwC2f7wYkL+9kmyhJTDDZ/1Pmvx4So3l97GEJgPjTKkFhuRa2GOg/BLemA4NMoglSQ+KTMdJiQ0xQh+bx3TCnpii8w9YzSTZIwh9i6k8vH1U2TCqofrWl/XPLdKgf8J6KZrWck/4Ft876x+taBBI59w1uHzqloC5ypNcIO/kUJPTroSye9tH/bXLM7Y4ZTw8Pn+qeSPTQbM4MwE4Maf8WpKujx5JJ6ysivWAvXo7fppRQiayrM64AdVzZqS7XhrJfSnss0ibh37pFvU7PLA2WDK6w0fw741JdFCXQNYvwnaXIXFZV1ZDGhcUyu0T8ypAs0jvzZKSnBJgqjypPaVtQrrsV0mK9Das2hXBCUcyTKQ6IPuwQacoOQuJ2AXXZ94VkOgyURDopall2XsIjHEutnIyzd2OSqdkhOfOWHZ5QBRKYCPrXiGwXbvR0mP+zxslTgkijjLYbQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(54906003)(86362001)(6506007)(53546011)(8936002)(508600001)(8676002)(38100700002)(316002)(122000001)(5660300002)(6486002)(6512007)(76116006)(33656002)(36756003)(71200400001)(2906002)(6916009)(2616005)(186003)(66476007)(66446008)(64756008)(26005)(66946007)(4326008)(66556008)(83380400001)(38070700005)(130980200001)(223123001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3ZZdkFsWUNvdkVVejVPQnJOT1FuY2xQTkhOSExTelVVRkNrNVJXOGpNY0lT?=
 =?utf-8?B?N3Bxci9HajNtektvNWpRTG1YbzlIWU40cTdCeTlGVU1qcEJmZzVxaUhhaVFz?=
 =?utf-8?B?dW5xdmdJa1BFMTBrSitPTE5oY1g3RzY0QTFPWXJiSzBNU1ArNjNiTWsxdGhQ?=
 =?utf-8?B?cmdra3FsaXh1MlY4d25xa2ZsWFpsL0VUakRERVJNdFJDaWh6Qy8xeWhaamRP?=
 =?utf-8?B?Z3d2SjhZMHl4WW9uNWR4S2wrZXkzaHNGMmhlYktSWEpGNnJoUU16TjRNNzFa?=
 =?utf-8?B?Zmk5dHNNamVYcUc3WmVldWhScjRveVQ1YjdNT0I4R3A3bjVHQjFoYVZwSHl2?=
 =?utf-8?B?bVVtSG8rOEZoNEJIRzlab3VIOUE2WXdaM1JvbDNTam5xS1VWWHZ2L2FVdkNq?=
 =?utf-8?B?ZWdpSTdyb1FxVGZSeWdrODgxaU9STDNsU3NrczNWM2xxSGUxUVVnd1drVnhV?=
 =?utf-8?B?dTRuZXlxaURDVlhtSDVZU1hkdi92a2ttUVhvRDBMRE81SWZqYTF1V1RkUDNo?=
 =?utf-8?B?R3Zoa1Q4Q1NxdUdieW02cy95VlRDeXdJV2NwRDRQeTlxYktaL2FBNnA0NFEv?=
 =?utf-8?B?U0psZ283S3dvVzdaYzYxL0J5UDZJYk9hd1Q5SUxmSE9RSmp5VUVsTm5wRGVX?=
 =?utf-8?B?c1B1dVdJSS9OeGFPK3pydkxYVTUrZFpvNWUrTjB1UjZqdWxpOWV0b0pQSDFM?=
 =?utf-8?B?eGZvVVl4OGZ5Z1NMOXZzTzB2RDM1SG1aNmFmM3lKRE1pNU5acWo3bEMxS3Ex?=
 =?utf-8?B?akhycE9Jc3h3bFlBQlloY2dPa3luU1lJQ1QvQkFtQllLQVB0TWNxNW45RnpQ?=
 =?utf-8?B?RDQxbEp6VE9zMWh4M0lYUWVpT2ZYN2hJZFlsa0dmL1I2bnA2NWkraVlGaDdR?=
 =?utf-8?B?MDBYRVE1VnV1a2RBNVNBRmNHREFaUlY1QS9oOUtxR0tsRnlNejEwdEljRlpn?=
 =?utf-8?B?cFRrSmMwMHU3blZJT2pPRlcwbVl2VFpHaU4vbUNjL01EUVpSWGI1TnV1YUFo?=
 =?utf-8?B?VTBFRTJQcnNjTEFtZlgxV3pOTmtHeldoY2VaYjAzUDR2YnJMVEw1Vld6N0pl?=
 =?utf-8?B?NmtkNzRWRnNZZW9OcUdKSWlVaHAyci9oZHVvYVVQYmx5YlRxb29wbFN0clNw?=
 =?utf-8?B?aWZtZ1JTamdnOS9GTGswWXlxa3F5elE0cVFTMXBMRDA4VjBJVS85MXY3R2Jl?=
 =?utf-8?B?RUtBUnRmZUwxbTFaTlBPVUl2T3ZpVXVNcnlLd2JqWkRoeXpJeTlLeEVkdU0r?=
 =?utf-8?B?WW1SbjkvWHhxMlFCVWhmMk90cFdwOHZCQW15THhvRlBKR0pQdzYvbHpONWs3?=
 =?utf-8?B?SHlCNElZTzRWclQwUlF5MTNxZkhGWVNFSVc2ZWxtVHFBVXR6RzdFcnBXMmov?=
 =?utf-8?B?bHYwQmNlb2lMM01FclZhNnRGSzNpSWRhQmRZaDhpS1ZUZnhwU0pzUzMrTVFw?=
 =?utf-8?B?OHlxWERiOWY5OGJQTUFIdEhNL1QrcTdCQlBITUNKdElWalh1REtxeE0vV2Zo?=
 =?utf-8?B?MEdvMGNvOVlaRHF2UHZOdHFGWkxxdGxMbjFoN1JpVFBYUFZGWDBvU2R6Lzlj?=
 =?utf-8?B?K05vZjlQUGRGWFpPWG1zaWdycmc4S0FFby81SVR0TElGMVhlRmcrQ01XbCty?=
 =?utf-8?B?cERncVhkWHpwUXRYQi9ZNTZFSXJscW9RUk5DcWpHV1M4QzNCS0grVU8zUldI?=
 =?utf-8?B?b3BXWEt6emo4NVVjQkRzaXlsMWpsYUtZakh4SytCRnhHeURVbnN1Y3U4S2s0?=
 =?utf-8?B?dm9aSHJuVmdIR0hSaTlzRVk4Y3g5V1I4V0RINEhVUGJBYkxvWkNSZHZ2NGtm?=
 =?utf-8?B?aFBKRWZUby8wZlZhcUNtSnF6WEdwZXdSc0xGKzFYZDFsYUNuODhXLzBCUHBM?=
 =?utf-8?B?a0lrSWIvQkQzK3psT3B4SllIMlZwUnIxZTYzNnAwN0NEYS9JUHNvMFJnYndx?=
 =?utf-8?B?bEFZTnNyQnZiQzBPbS96ZnJINkxZU3dkSmxYSFFpMnR4c1lTNVo1VWdib0Z6?=
 =?utf-8?B?bG5XWGdEZzFVeENIYmRXeEpXZUF6NHcwQVMrbWJnWTMvenBRbERXcDhCQjJn?=
 =?utf-8?B?WWZUa0NTNlI1WTBFZ2w4QklPZGU5RXQ1cUJsY3pIRFNONk1FQ2xMTUV6WnFE?=
 =?utf-8?B?V1lqd0hJczhsYzQ0WGFiVkJsZlBOSklJWE11cjVVVVdhNVFZUGxkRkdPdzg3?=
 =?utf-8?Q?IX9cdw+dcxQ17kpUwtE9kS4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B49AC2FF84691A41BB97B3251147B118@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6077667d-92fe-46a8-3b37-08d9a471247d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2021 17:40:09.7732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Teqn+IP1FnwelqgwWv6MmmW9OdHl5PsdLT8eZ0FK0e+uLqohgfUZpTkiMcjLL94e9K38zlJKxvuW3kjNtGQ+WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7658
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTm92IDEwLCAyMDIxLCBhdCA5OjIwIEFNLCBTcml2YXRzYSBTLiBCaGF0IDxzcml2
YXRzYUBjc2FpbC5taXQuZWR1PiB3cm90ZToNCj4gDQo+IE9uIFR1ZSwgTm92IDA5LCAyMDIxIGF0
IDAxOjU3OjMxUE0gLTA4MDAsIEpvZSBQZXJjaGVzIHdyb3RlOg0KPj4gT24gVHVlLCAyMDIxLTEx
LTA5IGF0IDAwOjU4ICswMDAwLCBOYWRhdiBBbWl0IHdyb3RlOg0KPj4+PiBPbiBOb3YgOCwgMjAy
MSwgYXQgNDozNyBQTSwgSm9lIFBlcmNoZXMgPGpvZUBwZXJjaGVzLmNvbT4gd3JvdGU6DQo+Pj4+
IE9uIE1vbiwgMjAyMS0xMS0wOCBhdCAxNjoyMiAtMDgwMCwgU3JpdmF0c2EgUy4gQmhhdCB3cm90
ZToNCj4+Pj4gDQo+Pj4+IFNvIGl0J3MgYW4gZXhwbG9kZXIgbm90IGFuIGFjdHVhbCBtYWludGFp
bmVyIGFuZCBpdCBsaWtlbHkgaXNuJ3QNCj4+Pj4gcHVibGljYWxseSBhcmNoaXZlZCB3aXRoIGFu
eSBub3JtYWwgbGlzdCBtZWNoYW5pc20uDQo+Pj4+IA0KPj4+PiBTbyBJTU8gInByaXZhdGUiIGlz
bid0IGFwcHJvcHJpYXRlLiAgTmVpdGhlciBpcyAiTDoiDQo+Pj4+IFBlcmhhcHMganVzdCBtYXJr
IGl0IGFzIHdoYXQgaXQgaXMgYXMgYW4gImV4cGxvZGVyIi4NCj4+Pj4gDQo+Pj4+IE9yIG1heWJl
IHRoZXNlIGJsb2NrcyBzaG91bGQgYmUgc2ltaWxhciB0bzoNCj4+Pj4gDQo+Pj4+IE06CU5hbWUg
b2YgTGVhZCBEZXZlbG9wZXIgPHNvbWVib2R5QHZtd2FyZS5jb20+DQo+Pj4+IE06CVZNd2FyZSA8
Zm9vPiBtYWludGFpbmVycyA8bGludXgtPGZvbz4tbWFpbnRhaW5lcnNAdm1saW51eC5jb20+DQo+
PiANCj4+IE1heWJlIGFkZGluZyBlbnRyaWVzIGxpa2UNCj4+IA0KPj4gTToJTmFtZWQgbWFpbnRh
aW5lciA8d2hvZXZlckB2bXdhcmUuY29tPg0KPj4gUjoJVk13YXJlIDxmb28+IHJldmlld2VycyA8
bGludXgtPGZvbz4tbWFpbnRhaW5lcnNAdm13YXJlLmNvbT4NCj4+IA0KPj4gd291bGQgYmUgYmVz
dC9zaW1wbGVzdC4NCj4+IA0KPiANCj4gU3VyZSwgdGhhdCBzb3VuZHMgZ29vZCB0byBtZS4gSSBh
bHNvIGNvbnNpZGVyZWQgYWRkaW5nICIoZW1haWwgYWxpYXMpIg0KPiBsaWtlIEp1ZXJnZW4gc3Vn
Z2VzdGVkLCBidXQgSSB0aGluayB0aGUgUjogZW50cnkgaXMgY2xlYXIgZW5vdWdoLg0KPiBQbGVh
c2UgZmluZCB0aGUgdXBkYXRlZCBwYXRjaCBiZWxvdy4NCj4gDQo+IC0tLQ0KPiANCj4gRnJvbSBm
NjZmYWEyMzhmYWNmNTA0Y2ZjNjYzMjU5MTJjZTdhZjhjYmY3OWVjIE1vbiBTZXAgMTcgMDA6MDA6
MDAgMjAwMQ0KPiBGcm9tOiAiU3JpdmF0c2EgUy4gQmhhdCAoVk13YXJlKSIgPHNyaXZhdHNhQGNz
YWlsLm1pdC5lZHU+DQo+IERhdGU6IE1vbiwgOCBOb3YgMjAyMSAxMTo0Njo1NyAtMDgwMA0KPiBT
dWJqZWN0OiBbUEFUQ0ggdjIgMi8yXSBNQUlOVEFJTkVSUzogTWFyayBWTXdhcmUgbWFpbGluZyBs
aXN0IGVudHJpZXMgYXMgZW1haWwNCj4gYWxpYXNlcw0KPiANCj4gVk13YXJlIG1haWxpbmcgbGlz
dHMgaW4gdGhlIE1BSU5UQUlORVJTIGZpbGUgYXJlIHByaXZhdGUgbGlzdHMgbWVhbnQNCj4gZm9y
IFZNd2FyZS1pbnRlcm5hbCByZXZpZXcvbm90aWZpY2F0aW9uIGZvciBwYXRjaGVzIHRvIHRoZSBy
ZXNwZWN0aXZlDQo+IHN1YnN5c3RlbXMuIEFueW9uZSBjYW4gcG9zdCB0byB0aGVzZSBhZGRyZXNz
ZXMsIGJ1dCB0aGVyZSBpcyBubyBwdWJsaWMNCj4gcmVhZCBhY2Nlc3MgbGlrZSBvcGVuIG1haWxp
bmcgbGlzdHMsIHdoaWNoIG1ha2VzIHRoZW0gbW9yZSBsaWtlIGVtYWlsDQo+IGFsaWFzZXMgaW5z
dGVhZCAodG8gcmVhY2ggb3V0IHRvIHJldmlld2VycykuDQo+IA0KPiBTbyB1cGRhdGUgYWxsIHRo
ZSBWTXdhcmUgbWFpbGluZyBsaXN0IHJlZmVyZW5jZXMgaW4gdGhlIE1BSU5UQUlORVJTDQo+IGZp
bGUgdG8gbWFyayB0aGVtIGFzIHN1Y2gsIHVzaW5nICJSOiBlbWFpbC1hbGlhc0B2bXdhcmUuY29t
Ii4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNyaXZhdHNhIFMuIEJoYXQgKFZNd2FyZSkgPHNyaXZh
dHNhQGNzYWlsLm1pdC5lZHU+DQo+IENjOiBaYWNrIFJ1c2luIDx6YWNrckB2bXdhcmUuY29tPg0K
PiBDYzogTmFkYXYgQW1pdCA8bmFtaXRAdm13YXJlLmNvbT4NCj4gQ2M6IFZpdmVrIFRoYW1waSA8
dml0aGFtcGlAdm13YXJlLmNvbT4NCj4gQ2M6IFZpc2hhbCBCaGFrdGEgPHZiaGFrdGFAdm13YXJl
LmNvbT4NCj4gQ2M6IFJvbmFrIERvc2hpIDxkb3NoaXJAdm13YXJlLmNvbT4NCj4gQ2M6IHB2LWRy
aXZlcnNAdm13YXJlLmNvbQ0KPiBDYzogbGludXgtZ3JhcGhpY3MtbWFpbnRhaW5lckB2bXdhcmUu
Y29tDQo+IENjOiBkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnDQo+IENjOiBsaW51eC1y
ZG1hQHZnZXIua2VybmVsLm9yZw0KPiBDYzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcNCj4g
Q2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGxpbnV4LWlucHV0QHZnZXIua2VybmVs
Lm9yZw0KPiAtLS0NCj4gTUFJTlRBSU5FUlMgfCAyMiArKysrKysrKysrKy0tLS0tLS0tLS0tDQo+
IDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9NQUlOVEFJTkVSUyBiL01BSU5UQUlORVJTDQo+IGluZGV4IDExOGNmODE3
MGQwMi4uNDM3MmQ3OTAyN2U5IDEwMDY0NA0KPiAtLS0gYS9NQUlOVEFJTkVSUw0KPiArKysgYi9N
QUlOVEFJTkVSUw0KPiBAQCAtNjEzNCw4ICs2MTM0LDggQEAgVDoJZ2l0IGdpdDovL2Fub25naXQu
ZnJlZWRlc2t0b3Aub3JnL2RybS9kcm0tbWlzYw0KPiBGOglkcml2ZXJzL2dwdS9kcm0vdmJveHZp
ZGVvLw0KPiANCj4gRFJNIERSSVZFUiBGT1IgVk1XQVJFIFZJUlRVQUwgR1BVDQo+IC1NOgkiVk13
YXJlIEdyYXBoaWNzIiA8bGludXgtZ3JhcGhpY3MtbWFpbnRhaW5lckB2bXdhcmUuY29tPg0KPiBN
OglaYWNrIFJ1c2luIDx6YWNrckB2bXdhcmUuY29tPg0KPiArUjoJVk13YXJlIEdyYXBoaWNzIFJl
dmlld2VycyA8bGludXgtZ3JhcGhpY3MtbWFpbnRhaW5lckB2bXdhcmUuY29tPg0KPiBMOglkcmkt
ZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnDQo+IFM6CVN1cHBvcnRlZA0KPiBUOglnaXQgZ2l0
Oi8vYW5vbmdpdC5mcmVlZGVza3RvcC5vcmcvZHJtL2RybS1taXNjDQo+IEBAIC0xNDE4OSw3ICsx
NDE4OSw3IEBAIEY6CWluY2x1ZGUvdWFwaS9saW51eC9wcGRldi5oDQo+IFBBUkFWSVJUX09QUyBJ
TlRFUkZBQ0UNCj4gTToJSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuY29tPg0KPiBNOglTcml2
YXRzYSBTLiBCaGF0IChWTXdhcmUpIDxzcml2YXRzYUBjc2FpbC5taXQuZWR1Pg0KPiAtTDoJcHYt
ZHJpdmVyc0B2bXdhcmUuY29tIChwcml2YXRlKQ0KPiArUjoJVk13YXJlIFBWLURyaXZlcnMgUmV2
aWV3ZXJzIDxwdi1kcml2ZXJzQHZtd2FyZS5jb20+DQoNClRoaXMgcGF0Y2ggdGhhdCB5b3UganVz
dCBzZW50IHNlZW1zIHRvIGdvIG9uIHRvcCBvZiB0aGUgcHJldmlvdXMgcGF0Y2hlcw0KKGFzIGl0
IHJlbW92ZXMgIkw6IHB2LWRyaXZlcnNAdm13YXJlLmNvbSAocHJpdmF0ZSnigJ0pLg0KDQpTaW5j
ZSB0aGUgcGF0Y2hlcyB3ZXJlIHN0aWxsIG5vdCBtZXJnZWQsIEkgd291bGQgcHJlc3VtZSB5b3Ug
c2hvdWxkIHNxdWFzaA0KdGhlIG9sZCAyLzIgd2l0aCB0aGlzIG5ldyBwYXRjaCBhbmQgc2VuZCB2
MyBvZiB0aGVzZSBwYXRjaGVzLg0KDQo=
