Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE3743C4D6
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238685AbhJ0IQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:16:22 -0400
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:31457
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238627AbhJ0IQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 04:16:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cousNquVZUCCt9CpiblblvLkBfvwQy4MQXh7Y9/shbCG18js7/11i7HMa0qvJqi0q9z7yd/IImnvvR9STDHIZVB8raIlSElWmtrrHKeAoPQE48akXZeDiM7m9k6ylgVNGfrI1RVfJt58feA3AD38zfy80SxzHlqDuTRO4v9D3YGKDjUKjY+/Xy8iletQZfnmjPVymK62Dl+qYO3pTQRkE4UKcnjdmzLQcfk0mJlIZgK7i5hQZutWV0kXudcbE4cNVjEUGZqTuruQlxAAerVHQjEoJ/Gm7TEilED+Aq5SBmIETi0e+SpgvmUO6LTwBqqMa4m2Pc89v03yqCwio6fDQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wGb4HpxxyaIdsTaOPJ4fLPTx6608CSrD95Zo+0HuTqE=;
 b=HLkEKzv4wJwU/mDWgqnfDqZG8CQFR780QHZ5FX9LT11KCjKJXrNSYajUFzF9mOgrQcbTGjxVH5Fy1ZESm70D7yt/QF4h9hagWTuCP9QNMLEChQwxWzFDkXJty6AFXS9eJwPyaFTMdoG7e9hNtDJjfnfRPKXddNnbPXTaPxDkgafrZNquxVpBUI/n6aD1zkCz8BJhNEgCnDRNMXM9/N+wD0oT/HGa8NCowqAFRUyPNGUrpQTuTMeyO4SiqICkXPle1aVeNw4NLKjalOsQLhbRcuDR1v4+ZSCvTmc13TST7DIGPsbbLY9iLaw3pTjRbwrwEEAZfYFb7Is2egLvW6g7Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wGb4HpxxyaIdsTaOPJ4fLPTx6608CSrD95Zo+0HuTqE=;
 b=jvnzDlozw3GaZXZIv27cHVtKviipDLvSU0WjKMHCVcjOBmJ9nr9nRaGXT5foZ8cAaC1GF7oAj7HM8UC8hTQ8R3rC0jEgN7FCU1Q7B5zuyL+9mDrZnjZ+uog+uYq3sLOxFyXZE/xiQ4dCUyLSaPtYVa5+7qgCpvUHW7M89WXa/L0=
Received: from BY3PR05MB8081.namprd05.prod.outlook.com (2603:10b6:a03:366::15)
 by BYAPR05MB4150.namprd05.prod.outlook.com (2603:10b6:a02:8f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12; Wed, 27 Oct
 2021 08:13:50 +0000
Received: from BY3PR05MB8081.namprd05.prod.outlook.com
 ([fe80::60d5:3d7c:49b5:cda0]) by BY3PR05MB8081.namprd05.prod.outlook.com
 ([fe80::60d5:3d7c:49b5:cda0%9]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 08:13:50 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     =?utf-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 03/10] vsock: owner field is specific to VMCI
Thread-Topic: [PATCH 03/10] vsock: owner field is specific to VMCI
Thread-Index: AQHXylr/44cRk9CkHEaGuwLmRE6CeqvmfxAA
Date:   Wed, 27 Oct 2021 08:13:49 +0000
Message-ID: <89E7CE3A-364F-4D42-8B7A-651A105524D7@vmware.com>
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
 <20211021123714.1125384-4-marcandre.lureau@redhat.com>
 <CAGxU2F4n7arHPJ3SpbpJzk1qoT1rQ57Ki3ZjeHquew+_SpRd_A@mail.gmail.com>
In-Reply-To: <CAGxU2F4n7arHPJ3SpbpJzk1qoT1rQ57Ki3ZjeHquew+_SpRd_A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03233ab1-91d4-4a1c-40c5-08d99921b514
x-ms-traffictypediagnostic: BYAPR05MB4150:
x-microsoft-antispam-prvs: <BYAPR05MB4150F8BF18DF2B16C17BDE04DA859@BYAPR05MB4150.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Tw92hVuEWWSyXlnqxADA8am4FYIhb4k03sJB4TrHouNZvqHpj1nQFbeTAX/tAdJgAmlVI25soouie+xXUMts80mriHXpnh13ITwjWN4YnS4I9jyTZePV6oqVQQPQ80wzcCGHWutHvNqn3jWNOsRDnpVfNitLxtAghP0jr6lSNFoQPz87diJt9BRZ8pnrrOT3kG4xZ8JzYE3ikX5xHvgPETILJz21fFHjMSWmRD29kXvh0TTEsSM94XlYushrPjVp4B6BQxup2FeTWxPacOrws9pGaYQWoxTv4f2Co0YbxR/3gzqg62xOh5PVBAdHtklpiDvbWVKdZMKPfz5/LHw3URI2P1SF0EWCqtCqY+PrDgTL5J4TxjI6HR/O7EM6jIZ4DsGMaTUdVcJqJUj1fz+upcyu6sE9imYt+7k0caYmnrfCe/Y3vsC0iEdehRjqas7qqq0FzqVKUkIQpbbiQZcX9IozQp/ED2Ano0CggWZT4z5JBZfoiNRjDOGbUP7OMTd/FXBEEMAWczz1+1N3WIeP4UP6X+CAc4kOFMMVyYjuhmrVYI2ZPwnWKjHznfIvMjQfw3Fj7bAANT/0W5XSr17SGfUMkqPR1J1xfuPS4scKhSOA7K+PMvNyZp8MqPrGxJIztjTa1Jv7fXW0FufIjWod2AC/FKeZkigJzAIpJIqN8+9qQKwrsCpK88GbBew24aB8HQ5jt2JXKD2ggcFTFaRPXxzDkvfw8VKQMOHjRcs4oCeS1KHFbgrICtBSEMH+RUW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8081.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(8936002)(5660300002)(186003)(2906002)(71200400001)(33656002)(36756003)(6512007)(6506007)(8676002)(122000001)(2616005)(66476007)(26005)(508600001)(53546011)(66556008)(86362001)(38070700005)(316002)(83380400001)(66946007)(54906003)(66446008)(64756008)(6916009)(6486002)(76116006)(91956017)(4326008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YThyaFYxQ2VUL2pDM2hMenRvdUlmNWk4ZGpOdGpXYTU0QjdMZkFFb2Rad0kz?=
 =?utf-8?B?V3ZzRVFVSVNLOFI5VkgzbVRYdUNQOXNJNVRxTkgzd2RaYWVtM1hKbDlLeDRG?=
 =?utf-8?B?OWUwcHpuY0k5Y3liUzFkZGkveTF6K09mSkJLUWVmRWlTUTZWSFl5czZQWjF1?=
 =?utf-8?B?U0l3TGNYS2x0cjBQMjhhSmt1ZW1KNTkyNWxsUmEzZUdUWHBkU1ovSnlsS1lT?=
 =?utf-8?B?dElhRlloVUxNc0xvOXpEVUxkalNiKzg0aXNLWnN0dHJCa0pMV0pwa1A5WGtC?=
 =?utf-8?B?SlBwVElkV0pMZHQzNCtiRU84UlZVSHRXWlNjTkFNZis3MVRwaEI5VG1tbVBH?=
 =?utf-8?B?VTVoeE5iS0NyTFFzZnNkdWpOaEE3NWsvYjRpOGdTZi94c3RxU3JtUlNtc3gy?=
 =?utf-8?B?SUFDWTcrVHp0akNIaitEQksxaG42UGFzSnUxUkhqRmU2dmJDUnltVk1sUFJU?=
 =?utf-8?B?UnpYZHQvYlZ4UTN6cEt6UkJNNVV0cFVRYnlpTnBXUGw3TG50Ym1sNVp1L2pI?=
 =?utf-8?B?MGFMc1B6UzJUeFVBeVhOdDIyVEZFRlV5bE1VS3MwSDdrbmpFMWMwT3JHUWdZ?=
 =?utf-8?B?VzJNRXEwcFhSYkQwem1wbkNzNkNMaTZVSUZRK3RiRVRnMEVLVm5ZRmFlUlJY?=
 =?utf-8?B?dDg2TGl0ZS9PMnFTOEt0dFhkWnI0bWYvejB3WXZHUDFFZXZ3aDRyYmtyTFhK?=
 =?utf-8?B?SWRNemVkbkxiUjJNcjB6OFNQKzhjQ2JiME9hK0Q2Y1V1WVRDMnNKNW5zSDBy?=
 =?utf-8?B?RmgxV3dWMW9DaTlKVjdwUlpmUW51RVF6TjRVblhnNzM1NkwvenlaNGRERGZG?=
 =?utf-8?B?Q0pSU2grK2tyUG1JVkI2ZCs3ZDcwVmlPaFZCQklOcHVSWS9Ta21VbDNrZk9p?=
 =?utf-8?B?YlZHQTNzWVpxdnJPMXBMUGoya3dOa2tDc1QwV0NHWklEendVWmJzWHBXaVI0?=
 =?utf-8?B?d08yMFF3LzcyZ1FFb3U0enFxb2wvOWZ3eGFHeC9UNmhWUTFDWmlzTHc1eGpq?=
 =?utf-8?B?cTVJQ2VXMDZJblNtRjVFZEdJbHRQNFYwdGZ1bFFFaGE1Rm9wdnE4Zm5Ka0Iw?=
 =?utf-8?B?citsT1RyN1F5QlJ0VlBTVm9jRmJtWFBhS2dyZUpTQjdPOGM1b0tIMkg0OXk2?=
 =?utf-8?B?M3Q3a2pOZ1JEOW9FaGV6M2dBWVg4TjRDZVlmMDhlZkpabWJiVVRoRGxGZStq?=
 =?utf-8?B?T1NYZ2FKYng1eFhSLytqclBTaTVFZHR3R01LYXl5WkxLa3B6TjdEVSszbmNl?=
 =?utf-8?B?SjE5R01qZDlJTk15Vi96QlpIN09BWmVNYzF0TkNNQzkycXdGTE1ib2FKbWJB?=
 =?utf-8?B?bTVPdjA0VDRBS09OQ1NDVFVHaityU0NRaGV6ZEtDaHh5ekhlY2JtUXZqaU1X?=
 =?utf-8?B?WVE0dDRUeW5IZ1V5MkFia1V0SGlESXlmQm5NV3lKUkxpM2JJZFFwYjRQMW8r?=
 =?utf-8?B?S3NwN2ZydlIreW1KYld6V2UydnpmMXUzeXA4RHJRQnRndmxqMXo0ZXRWcmpC?=
 =?utf-8?B?SW9wa0tHSUZQYjhkUjhkZEpWR3B4bDhKK3JtazBuWU1TOWprWVZkK05FUnNQ?=
 =?utf-8?B?Y0VxdkNKaXM3MjZRMFpmL3FDQjhFd1A2eGpZWlBjVmtSZlB3TVl5TU1DWTIw?=
 =?utf-8?B?emQ3MzdBY3RpaVRLYk9QaVErY3VXaHZpMzdQRUtYNUNYQVFNbUtYT0dvMXBK?=
 =?utf-8?B?SVpyeXU3eXBFelN0cW1Pa3cvZ2ZhWjlkM1VXQ3IyUytncDc1cWZnKy9kNlVn?=
 =?utf-8?B?Ly9EMFRFeGhjSXg0TGNXaktpZGF5cGloMjV2MzdjL1h5amRYSzBoUzhsR0Fr?=
 =?utf-8?B?MjJhTTNDMHpBNkNXZEhXTk1tV3lLU1ZqNzZCQU5ZaUVsekxIZnd5cmFvVTlQ?=
 =?utf-8?B?cEhCZ001N2k5QWMrN2pNOUo5L2VNZkdKUUF2cnhWb09ieUJ2ODFVUGVVb09k?=
 =?utf-8?B?NFJnK2czZExOTjhvdkcyRnJHbGUwMFEwcXVIWE1EelFFK2Z4VktreHlKU3cw?=
 =?utf-8?B?ZlRmWHdBSkNvaXlCbmxHZm12UjZrR1VMcHpSNEt3SG05cmxoamFOK0dBdVJS?=
 =?utf-8?B?U1c5Z2FnYmo4YkZOK3VERTgxNXRJN1l3cklWTklzTzJSNDFqczBRSkNKOGhQ?=
 =?utf-8?B?UUdPNjE5OHFybXBpM2o1TER3M0Vhby9teVFBaEozZUFXQW9CUGZzOWRGLzM3?=
 =?utf-8?Q?g6NgTGaZhtCLLDfxlN9bYB0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD6D7371D79F9143938F246BCD58B017@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8081.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03233ab1-91d4-4a1c-40c5-08d99921b514
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 08:13:49.9763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n0US8cEh7bie6lb9SSh87b4RqHq8OfQH8NdIF+3iNGcuWe13L2aSigT5TcHQJfLK+ePj3ZVsDoxf400ti6J79A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4150
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IE9uIDI2IE9jdCAyMDIxLCBhdCAxMzoxNiwgU3RlZmFubyBHYXJ6YXJlbGxhIDxzZ2FyemFy
ZUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IENDaW5nIEpvcmdlbi4NCj4gDQo+IE9uIFRodSwg
T2N0IDIxLCAyMDIxIGF0IDA0OjM3OjA3UE0gKzA0MDAsIE1hcmMtQW5kcsOpIEx1cmVhdSB3cm90
ZToNCj4+IFRoaXMgZmllbGQgaXNuJ3QgdXNlZCBieSBvdGhlciB0cmFuc3BvcnRzLg0KPiANCj4g
SWYgdGhlIGZpZWxkIGlzIHVzZWQgb25seSBpbiB0aGUgVk1DSSB0cmFuc3BvcnQsIG1heWJlIGl0
J3MgYmV0dGVyIHRvIA0KPiBtb3ZlIHRoZSBmaWVsZCBhbmQgdGhlIGNvZGUgaW4gdGhhdCB0cmFu
c3BvcnQuDQoNCklmIHRoZSB0cmFuc3BvcnQgbmVlZHMgaW5pdGlhbGl6ZSB0aGVzZSBmaWVsZHMs
IHRoYXQgc2hvdWxkIGhhcHBlbiB3aGVuIHdlDQpjYWxsIHZzb2NrX2Fzc2lnbl90cmFuc3BvcnQu
IFNvIHdlIHdvdWxkIG5lZWQgdG8gdmFsaWRhdGUgdGhhdA0KZ2V0X2N1cnJlbnRfY3JlZCgpIGdl
dHMgdGhlIHJpZ2h0IGNyZWRlbnRpYWxzIGFuZCB0aGF0IHRoZSBwYXJlbnQgb2YgYQ0Kc29ja2V0
IGhhcyBhbiBJbml0aWFsaXNlZCBvd25lciBmaWVsZCBhdCB0aGF0IHBvaW50IGluIHRpbWUuDQoN
CnNvY2tfYXNzaWduX3RyYW5zcG9ydCBtYXkgYmUgY2FsbGVkIHdoZW4gcHJvY2Vzc2luZyBhbg0K
aW5jb21pbmcgcGFja2V0IHdoZW4gYSByZW1vdGUgY29ubmVjdHMgdG8gYSBsaXN0ZW5pbmcgc29j
a2V0LA0KYW5kIGluIHRoYXQgY2FzZSwgdGhlIG93bmVyIHdpbGwgYmUgYmFzZWQgb24gdGhlIHBh
cmVudCBzb2NrZXQuDQpJZiB0aGUgcGFyZW50IHNvY2tldCBoYXNu4oCZdCBiZWVuIGFzc2lnbmVk
IGEgdHJhbnNwb3J0IChhbmQgYXMgSQ0KcmVtZW1iZXIgaXQsIHRoYXQgaXNu4oCZdCB0aGUgY2Fz
ZSBmb3IgYSBsaXN0ZW5pbmcgc29ja2V0KSwgdGhlbiBpdA0KaXNu4oCZdCBwb3NzaWJsZSB0byBp
bml0aWFsaXplIHRoZSBvd25lciBmaWVsZCBhdCB0aGlzIHBvaW50IHVzaW5nDQp0aGUgdmFsdWUg
ZnJvbSB0aGUgcGFyZW50LiBTbyB0aGUgaW5pdGlhbGlzYXRpb24gb2YgdGhlIGZpZWxkcw0KcHJv
YmFibHkgaGF2ZSB0byBzdGF5IGluIGFmX3Zzb2NrLmMgYXMgcGFydCBvZiB0aGUgZ2VuZXJpYyBz
dHJ1Y3R1cmUuDQoNCklzIHRoZXJlIGEgcGFydGljdWxhciByZWFzb24gdG8gZG8gdGhpcyBjaGFu
Z2UgYXMgcGFydCBvZiB0aGlzIHNlcmllcw0Kb2YgcGF0Y2hlcz8NCg0KVGhhbmtzLA0KSm9yZ2Vu
DQoNCj4gVGhhbmtzLA0KPiBTdGVmYW5vDQo+IA0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBNYXJj
LUFuZHLDqSBMdXJlYXUgPG1hcmNhbmRyZS5sdXJlYXVAcmVkaGF0LmNvbT4NCj4+IC0tLQ0KPj4g
aW5jbHVkZS9uZXQvYWZfdnNvY2suaCAgIHwgMiArKw0KPj4gbmV0L3Ztd192c29jay9hZl92c29j
ay5jIHwgNiArKysrKysNCj4+IDIgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspDQo+PiAN
Cj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9hZl92c29jay5oIGIvaW5jbHVkZS9uZXQvYWZf
dnNvY2suaA0KPj4gaW5kZXggYWIyMDc2NzdlMGE4Li5lNjI2ZDk0ODRiYzUgMTAwNjQ0DQo+PiAt
LS0gYS9pbmNsdWRlL25ldC9hZl92c29jay5oDQo+PiArKysgYi9pbmNsdWRlL25ldC9hZl92c29j
ay5oDQo+PiBAQCAtNDEsNyArNDEsOSBAQCBzdHJ1Y3QgdnNvY2tfc29jayB7DQo+PiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogY2FjaGVkIHBlZXI/DQo+PiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICovDQo+PiAgICAgIHUzMiBjYWNoZWRfcGVl
cjsgIC8qIENvbnRleHQgSUQgb2YgbGFzdCBkZ3JhbSBkZXN0aW5hdGlvbiBjaGVjay4gKi8NCj4+
ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfVk1XQVJFX1ZNQ0lfVlNPQ0tFVFMpDQo+PiAgICAgIGNv
bnN0IHN0cnVjdCBjcmVkICpvd25lcjsNCj4+ICsjZW5kaWYNCj4+ICAgICAgLyogUmVzdCBhcmUg
U09DS19TVFJFQU0gb25seS4gKi8NCj4+ICAgICAgbG9uZyBjb25uZWN0X3RpbWVvdXQ7DQo+PiAg
ICAgIC8qIExpc3RlbmluZyBzb2NrZXQgdGhhdCB0aGlzIGNhbWUgZnJvbS4gKi8NCj4+IGRpZmYg
LS1naXQgYS9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2Nr
LmMNCj4+IGluZGV4IGUyYzBjZmIzMzRkMi4uMTkyNTY4MmE5NDJhIDEwMDY0NA0KPj4gLS0tIGEv
bmV0L3Ztd192c29jay9hZl92c29jay5jDQo+PiArKysgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2Nr
LmMNCj4+IEBAIC03NjEsNyArNzYxLDkgQEAgc3RhdGljIHN0cnVjdCBzb2NrICpfX3Zzb2NrX2Ny
ZWF0ZShzdHJ1Y3QgbmV0ICpuZXQsDQo+PiAgICAgIHBzayA9IHBhcmVudCA/IHZzb2NrX3NrKHBh
cmVudCkgOiBOVUxMOw0KPj4gICAgICBpZiAocGFyZW50KSB7DQo+PiAgICAgICAgICAgICAgdnNr
LT50cnVzdGVkID0gcHNrLT50cnVzdGVkOw0KPj4gKyNpZiBJU19FTkFCTEVEKENPTkZJR19WTVdB
UkVfVk1DSV9WU09DS0VUUykNCj4+ICAgICAgICAgICAgICB2c2stPm93bmVyID0gZ2V0X2NyZWQo
cHNrLT5vd25lcik7DQo+PiArI2VuZGlmDQo+PiAgICAgICAgICAgICAgdnNrLT5jb25uZWN0X3Rp
bWVvdXQgPSBwc2stPmNvbm5lY3RfdGltZW91dDsNCj4+ICAgICAgICAgICAgICB2c2stPmJ1ZmZl
cl9zaXplID0gcHNrLT5idWZmZXJfc2l6ZTsNCj4+ICAgICAgICAgICAgICB2c2stPmJ1ZmZlcl9t
aW5fc2l6ZSA9IHBzay0+YnVmZmVyX21pbl9zaXplOw0KPj4gQEAgLTc2OSw3ICs3NzEsOSBAQCBz
dGF0aWMgc3RydWN0IHNvY2sgKl9fdnNvY2tfY3JlYXRlKHN0cnVjdCBuZXQgKm5ldCwNCj4+ICAg
ICAgICAgICAgICBzZWN1cml0eV9za19jbG9uZShwYXJlbnQsIHNrKTsNCj4+ICAgICAgfSBlbHNl
IHsNCj4+ICAgICAgICAgICAgICB2c2stPnRydXN0ZWQgPSBuc19jYXBhYmxlX25vYXVkaXQoJmlu
aXRfdXNlcl9ucywgQ0FQX05FVF9BRE1JTik7DQo+PiArI2lmIElTX0VOQUJMRUQoQ09ORklHX1ZN
V0FSRV9WTUNJX1ZTT0NLRVRTKQ0KPj4gICAgICAgICAgICAgIHZzay0+b3duZXIgPSBnZXRfY3Vy
cmVudF9jcmVkKCk7DQo+PiArI2VuZGlmDQo+PiAgICAgICAgICAgICAgdnNrLT5jb25uZWN0X3Rp
bWVvdXQgPSBWU09DS19ERUZBVUxUX0NPTk5FQ1RfVElNRU9VVDsNCj4+ICAgICAgICAgICAgICB2
c2stPmJ1ZmZlcl9zaXplID0gVlNPQ0tfREVGQVVMVF9CVUZGRVJfU0laRTsNCj4+ICAgICAgICAg
ICAgICB2c2stPmJ1ZmZlcl9taW5fc2l6ZSA9IFZTT0NLX0RFRkFVTFRfQlVGRkVSX01JTl9TSVpF
Ow0KPj4gQEAgLTgzMyw3ICs4MzcsOSBAQCBzdGF0aWMgdm9pZCB2c29ja19za19kZXN0cnVjdChz
dHJ1Y3Qgc29jayAqc2spDQo+PiAgICAgIHZzb2NrX2FkZHJfaW5pdCgmdnNrLT5sb2NhbF9hZGRy
LCBWTUFERFJfQ0lEX0FOWSwgVk1BRERSX1BPUlRfQU5ZKTsNCj4+ICAgICAgdnNvY2tfYWRkcl9p
bml0KCZ2c2stPnJlbW90ZV9hZGRyLCBWTUFERFJfQ0lEX0FOWSwgVk1BRERSX1BPUlRfQU5ZKTsN
Cj4+IA0KPj4gKyNpZiBJU19FTkFCTEVEKENPTkZJR19WTVdBUkVfVk1DSV9WU09DS0VUUykNCj4+
ICAgICAgcHV0X2NyZWQodnNrLT5vd25lcik7DQo+PiArI2VuZGlmDQo+PiB9DQo+PiANCj4+IHN0
YXRpYyBpbnQgdnNvY2tfcXVldWVfcmN2X3NrYihzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19i
dWZmICpza2IpDQo+PiAtLQ0KPj4gMi4zMy4wLjcyMS5nMTA2Mjk4ZjdmOQ0KPj4gDQo+IA0KDQo=
