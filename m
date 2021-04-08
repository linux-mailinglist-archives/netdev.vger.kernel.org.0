Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A283587B4
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 17:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhDHPBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 11:01:38 -0400
Received: from mail-mw2nam10on2124.outbound.protection.outlook.com ([40.107.94.124]:60896
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231480AbhDHPBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 11:01:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1Li4Kj+EtZ0a+Pfrc86KLuOi3j6wO6ScW/75qE1CALyA5vjuQZNAho3wOs7HAZenXTvff3kgk2DHXdIC/DAwpU/i2EtMDMfpjJ2WhZMwuh05XukMRh/OO5Z2Gt4lVuIDIj/OkkgWIdtY4nlNxLRDrHr4xwhT3OEQjZ9OAbArkLeF214shvHnfLOIc6URU2oOg+ikM2xryyxWKEmTteR6xrAHgl41bdPFfGseKMplPvy4ByEfgupA3uF9BwOUcpehG0IrHlHMpURsOJNXASGlcbrie44DmFEzTX5vkKhRsMbAQjyXUQSkYSgLc6tBvtQbCodCLgQhQ0E5RTo4QAqeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhjhfhMmZ4Yr71xi5AXsan3CMkNPF2zRyISRflarkas=;
 b=SbKRi3+EYDjIBFEBpHUQ8cwSkYfc28u5I3U/FtvXu7vNi5NUKZHdYpsNOt0gWiHfJBKBvOfOaEvNeQwxog0O23uNOwqf7NEPpo6LzZmvyO4NHxWD4Euns5D2jxrXW0haEZgWGebMo7wgIAnXz3aCJxpCqjXpa9oMh7JAH6/pi7iwin6mekepPXi5ecPl9Dm9mFS+K1dXikyvzJKEm3snuezMHFBAkmAGc1+QwsmLayUvdCH1DfEK5u0PcOdB5aY+o9RFEY1pOpNWSQ/sXYKmL7C2UWFzWp2+io6g8Azxoc/Eohj5GQCN7KU2tRJCMDwGBSA+b83Mj9h88xZE8WZ2JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhjhfhMmZ4Yr71xi5AXsan3CMkNPF2zRyISRflarkas=;
 b=Eid41Nlg//ZziLlF+Mh9zbIT9AlpzbdHVyv0KFVH6Uf80Eq10F/2xx3G0WJU6czVLk3G6j8foejgHCZNsfRP/K5wNNkEFh1nHg7iFsmZUfbnTpDXaR7i+zQUv5Yw45CsvzP3a+MtTYw12intZDnWYpQT17QywxWprUDU3xbLq3Q=
Received: from DS7PR13MB4733.namprd13.prod.outlook.com (2603:10b6:5:3b1::24)
 by DM5PR13MB1084.namprd13.prod.outlook.com (2603:10b6:3:78::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.11; Thu, 8 Apr
 2021 15:01:21 +0000
Received: from DS7PR13MB4733.namprd13.prod.outlook.com
 ([fe80::f414:a9a:6686:f7e0]) by DS7PR13MB4733.namprd13.prod.outlook.com
 ([fe80::f414:a9a:6686:f7e0%4]) with mapi id 15.20.4020.021; Thu, 8 Apr 2021
 15:01:21 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "pakki001@umn.edu" <pakki001@umn.edu>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "dwysocha@redhat.com" <dwysocha@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Thread-Topic: [PATCH] SUNRPC: Add a check for gss_release_msg
Thread-Index: AQHXK0NV8TqxghYc4k6II+5Gojms3qqquYoA
Date:   Thu, 8 Apr 2021 15:01:21 +0000
Message-ID: <c0de0985c0bf09a96efc538da2146f86e6fa7037.camel@hammerspace.com>
References: <20210407001658.2208535-1-pakki001@umn.edu>
In-Reply-To: <20210407001658.2208535-1-pakki001@umn.edu>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: umn.edu; dkim=none (message not signed)
 header.d=none;umn.edu; dmarc=none action=none header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea2bb06d-e35c-4953-e807-08d8fa9f2bfa
x-ms-traffictypediagnostic: DM5PR13MB1084:
x-microsoft-antispam-prvs: <DM5PR13MB10849DA7352A5BABEE859BE2B8749@DM5PR13MB1084.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sFVlEhKiv9jT+v1QItYPV67Hx+DRzuTVvEW9cafjimBxXTBxmlqwDc+aWNVVljX2XZDb3ipiPqO7o5Oi5Zh12+vZBGfRZapcAZw/AvhtI/Db8Lb7q6rHXObHGeSTWThEYb4PxEjI791Fdp53+caQvR1ltG5U6Czu6acx5jlH8VbyuPzT2bnoPC3aklWu1YGIog4gf5T0LNYJEVr3PFZI0VEYi3VG1ydKoutdj+hk31cUME6cEC35OheY+VXUoRjFnP7xgmSOTaoFjgheAydLxYBEwvNswCrr3g1cr/WEDhD7iRgttsomqJB5nfQM4ptjZM7iOaujW7HH5RafZ3cMKgMyVjYXqT1PUN9Y3Vh4P9ULIzQWlh1TaUFR1nqSxJg2TsYQX6Y1pJJwpH5IsEGWUr0M5q7RK282GZO0h8udvBAJUvvtKFFCi+BPS9FuU34pk4HqyWimet+8F73FCtq0igT/GKSEUCiQRhUfS4ScqE65955M1UeagJlHrNjNXnJPJJtVbeoT6cSOhf5QT0iZhRj2jMtxvNEHv4scj+zIW2DIOcQw6d0XfYspntZlQFszsizSYp1q7oPxSjfRWOJtS7CGROomv0qMA9kJXn67Em/FO9rd2dhFHxSI1BFRABQgzMY4FmhzqHXQuclja7A2yBFknzguxinpaWOxbmhRKjk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR13MB4733.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(376002)(136003)(39840400004)(6512007)(54906003)(64756008)(66476007)(66556008)(66446008)(478600001)(6486002)(8936002)(316002)(38100700001)(86362001)(8676002)(36756003)(76116006)(6506007)(6916009)(26005)(83380400001)(7416002)(2616005)(2906002)(186003)(4744005)(4326008)(66946007)(71200400001)(91956017)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZFR2eTkwZkV6OGlTTUhzNUZVL2UxV2lKSWIySDFYYU9TRUczZVpYc3ZveEVI?=
 =?utf-8?B?WGFKWXJJY0MrNmlwNGZ0d0lYTm5QNlpCWmoyK0VpTmI5R0hYeG01dUN6YXov?=
 =?utf-8?B?QzFTUTh6dHpTTE0veTRsbGRpZG9UcCtPdndyUThjQnNiZXZLbVlxaTh1OW1Z?=
 =?utf-8?B?QWNXWG1NQVNKb1JJSllxUEJIckxUQnVBNFNDb2dUT0MvZmpGZEVqK1RSbTZr?=
 =?utf-8?B?UkoxL2JTVXpKbmtsbXpEQWU4cXVXV044cTJWdUtMblYwZUFGTXJ4SzdsL3dB?=
 =?utf-8?B?em9rdWJzK2NrVXJUNHBIUkNBTUNWQXd2ZkFpdE9nS1QvNjRkV1M0cE90M3kr?=
 =?utf-8?B?ckVaZVd2SW1sdUwvV1VKcmtoV3pBcGp0U2p2cFJ3Mzk2UzF5dHlvZXkyVDVy?=
 =?utf-8?B?bm4ybW1ZZ2NZRERxWjJ0VjlSeThVM3kzL2ZiSGRJZVBvZStYM1RqZnFjOGxw?=
 =?utf-8?B?YUJMQXhXVExCam1NUTZDYmlJZXFxYjUzeXpCZ1YzTmJ4V253Sm5wOXZVOVdi?=
 =?utf-8?B?UmcvUzdLMUZxUm1vVTY4OGhhQ0tWenhDZDdsZHRkaHVoVXRlcWNxRWVKN0Z0?=
 =?utf-8?B?djRRZmllL3FDRVZiU3lWL3pJV2dRZC84WVZ6SytRUmsyelFqMEt2ZktlTDNI?=
 =?utf-8?B?ZWZQUEhCWHFVaFRMM3lUcktMYlVVTGNSSzdoTk13RlNDenAvOU1ZRno4NGNy?=
 =?utf-8?B?aWgwMUl1bjFNS1hLTUd0WE1Eajd6Qkdrd1AxdzdmSzRTa05Sa1NTT0RxR1p0?=
 =?utf-8?B?Zk9zNEh3QWN0bUdZYVhBdW5uUGRPN3ZjMmRrb3JUdGx3c3NlRFIwQzNiZFhv?=
 =?utf-8?B?aHI1ZGdvc2pnZFlpNnlxYzRDRStSSmNZU05zNnJyWHN2eXBCK1Z0bFdpYS9j?=
 =?utf-8?B?RFJXNEx4ZytUcWVsYi94TkdzeFVpRmVsVGJ1enFqckNhcktId0JlcDdHc2Zr?=
 =?utf-8?B?ZExscHBpbVA1QXVlTEIvdDU4SmhPSG1GSW1LTFAvVlBWNVJaWnhnWkw3dFU2?=
 =?utf-8?B?dmJXZXI1STQ3aHFEN1Y0ZE1kZUlLK2NBOG5pZlpRSXNzVVJwR1Irc1NBeVNZ?=
 =?utf-8?B?b3F5T2taZWJlbkIwT3p1dmlwTXRwSFdzY0xtOFFDeTFKU0pCdnliMjBiK3dI?=
 =?utf-8?B?OWk3bXA0Q2o2VFZWMkFkNi81d2R6Y2FHRWR5TjM4dWJFMERoOTUwbUhndlJv?=
 =?utf-8?B?YUg5ZS9IbVBLS05KYnJWb0hYVkpjSWRyTHJLTzhsRjlYZXRmNlhCR2pCcnYv?=
 =?utf-8?B?WkxkajZCUXVESS9zcW55T0NjTE9DOTd1YXh2SEFYeUQ2Z1IySmpWSnRIMUlQ?=
 =?utf-8?B?WXlZT0xaZFA0MGFyRTJkWmkwek44b2NIR3p5ZDRwSzhhUjR2NXd0QTh6M0d5?=
 =?utf-8?B?UFhKWWx5RHRXMHczcUxFNG9sZGlSanRZck9xdzRDVXluU3ZEZVVab3FGaExT?=
 =?utf-8?B?THZCYnd3OVZkWFlPQjAyeFZyWW1TdHkyUGlLdVc4MkVEYW5mK013QnRqV1hC?=
 =?utf-8?B?N2hycmY2eWFOUE1MNmw1RjlxTmN0SXNpemx3YW03SjNxRXZxT0U1L1luR3g2?=
 =?utf-8?B?MS9WK3BvY1FVeWhUSHZQUDBQNVdxc0RJdllLM2d4aHdFbFc4Z3BpcjlIWCto?=
 =?utf-8?B?bStUUEVTOGJoVjNrY2VzMDNSb2V1Zys2Q2plenk0YXRjWnYzaDJpVS9ZeC9D?=
 =?utf-8?B?T0huS1dSY0tTVTFBN1VYZzRHMUNVSkl6K2R5TjQ0ODAyOXJZenNKb2pVUVZS?=
 =?utf-8?Q?T8u/kn9h699mgDtLmRhAyo+nrxkZ67JnVJ5xG/u?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <918A6F3F63B3A941971EC83709B4CA6E@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR13MB4733.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea2bb06d-e35c-4953-e807-08d8fa9f2bfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 15:01:21.4725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: amrILnMtmTU8wgL3oPVQJ20T3zB/c6bWr2cIC/Av4qSmHsbv+GSSuC5p5JYXMveoMtkAfplvx8p2S/MoS/QVaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTA0LTA2IGF0IDE5OjE2IC0wNTAwLCBBZGl0eWEgUGFra2kgd3JvdGU6DQo+
IEluIGdzc19waXBlX2Rlc3Ryb3lfbXNnKCksIGluIGNhc2Ugb2YgZXJyb3IgaW4gbXNnLCBnc3Nf
cmVsZWFzZV9tc2cNCj4gZGVsZXRlcyBnc3NfbXNnLiBUaGUgcGF0Y2ggYWRkcyBhIGNoZWNrIHRv
IGF2b2lkIGEgcG90ZW50aWFsIGRvdWJsZQ0KPiBmcmVlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
QWRpdHlhIFBha2tpIDxwYWtraTAwMUB1bW4uZWR1Pg0KPiAtLS0NCj4gwqBuZXQvc3VucnBjL2F1
dGhfZ3NzL2F1dGhfZ3NzLmMgfCAzICsrLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvc3VucnBjL2F1dGhf
Z3NzL2F1dGhfZ3NzLmMNCj4gYi9uZXQvc3VucnBjL2F1dGhfZ3NzL2F1dGhfZ3NzLmMNCj4gaW5k
ZXggNWY0MmFhNWZjNjEyLi5lYjUyZWViYjM5MjMgMTAwNjQ0DQo+IC0tLSBhL25ldC9zdW5ycGMv
YXV0aF9nc3MvYXV0aF9nc3MuYw0KPiArKysgYi9uZXQvc3VucnBjL2F1dGhfZ3NzL2F1dGhfZ3Nz
LmMNCj4gQEAgLTg0OCw3ICs4NDgsOCBAQCBnc3NfcGlwZV9kZXN0cm95X21zZyhzdHJ1Y3QgcnBj
X3BpcGVfbXNnICptc2cpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHdhcm5fZ3NzZCgpOw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGdzc19yZWxlYXNlX21zZyhnc3NfbXNnKTsNCj4gwqDCoMKgwqDCoMKgwqDCoH0NCj4gLcKgwqDC
oMKgwqDCoMKgZ3NzX3JlbGVhc2VfbXNnKGdzc19tc2cpOw0KPiArwqDCoMKgwqDCoMKgwqBpZiAo
Z3NzX21zZykNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdzc19yZWxlYXNlX21z
Zyhnc3NfbXNnKTsNCj4gwqB9DQo+IMKgDQo+IMKgc3RhdGljIHZvaWQgZ3NzX3BpcGVfZGVudHJ5
X2Rlc3Ryb3koc3RydWN0IGRlbnRyeSAqZGlyLA0KDQoNCk5BQ0suIFRoZXJlJ3Mgbm8gZG91Ymxl
IGZyZWUgdGhlcmUuDQoNCi0tIA0KVHJvbmQgTXlrbGVidXN0DQpMaW51eCBORlMgY2xpZW50IG1h
aW50YWluZXIsIEhhbW1lcnNwYWNlDQp0cm9uZC5teWtsZWJ1c3RAaGFtbWVyc3BhY2UuY29tDQoN
Cg0K
