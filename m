Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70063B5D9A
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 14:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhF1MKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 08:10:51 -0400
Received: from mail-db8eur05on2105.outbound.protection.outlook.com ([40.107.20.105]:62576
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232608AbhF1MKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 08:10:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kaeepFogTjWuLJ7dEgHD8NjX2OxZA3RvyBxjXUGBcjoisHOqUndJl9DgAkNpXmVTiGF2gOr+YMl9bRYaUXuW/srnXOMDje+E/yc14mQ0WP1hlOA/7b/wojv7SoUo4Laa0z2HSd+LLVzyyEEgtSzVo1c35zDh+osNqhFrJcow/w2nHIhUOucBbCDoh3WUcT5UI3CeHw4mNrVFecoMmvtp+9nkfSxnxPUloDF58P3AkUIPMSY6hyBn6txe5SkLzJLFWkTj8vzm/Ow/yM+A5Y1am0MmbPGV/iGn6rWMUNRY1uTi2h8wUDJG9FVLA4k0yTLZa1alN7THfwBO6i7fvltEKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRBf8mAo8A1MIezso5hth40A5uEQenQugj/eIp4aeJY=;
 b=J6Vooaw259DomY7+X+R0XNgNBd0U1KV1qIl6E6FwDtEcNXe1VP4yZ6XYebaJ8nlm3QOsTb0654tz5l+yCPq0trl0ipFPA42PvCFVRiTPZJaI6ZdIv9o3HJUFBEM2VfolmjYFU6VEy8nkqhlwjA21ftUMM5sIvIKja/yv77AIL1m03vit2qSWooPStLwXu2meHAigtZe/iW02TWZ+9PCERqJF0Grr+scoue13cRWuc4uTEM61eNQLSzSb09b7sxnvv6qNa04KU/I7ZGtFmivtVg5rTa6HpJkjfjDUDXnI9Ox6/tRndTBNG3TCiyxPmQ6YRnTvPh60ZG4sRtjCOKCJ8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=itu.dk; dmarc=pass action=none header.from=itu.dk; dkim=pass
 header.d=itu.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itu.dk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRBf8mAo8A1MIezso5hth40A5uEQenQugj/eIp4aeJY=;
 b=DKnw9VaxXJGwRMVdeKHj1PVKwP93As6qf47rjxlMYZfLuje3gnyz7CI3bDFXlIz6y/GzX+1IS+OfwbAj1h/5FB1PBlSp7JOUrKk7lBjWrgNLvHE11O3qcr3ViT+JSAIgdpqrzZUdLA1lye10ZN3ReLBxM2Q6X/Wqt7T6wLJpfXyoKZ0DrVUiqlz4s/ZHhPu5FHrW34qzYLDS3kNHbTLDgHSLw/v4JSCntQBE0UsBt5CQjfQCo8jfnwElmYIV5jz0h7UZ4vJZwpq6oAxJyGjlQEu9Kzp+9gFE3jovxJMt+IyTAEOYd661G26lpCQe7KUgoCEKcVl2j1RSM4hp2iDqbg==
Received: from AM0PR02MB5777.eurprd02.prod.outlook.com (2603:10a6:208:180::13)
 by AM9PR02MB6564.eurprd02.prod.outlook.com (2603:10a6:20b:2c9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Mon, 28 Jun
 2021 12:08:22 +0000
Received: from AM0PR02MB5777.eurprd02.prod.outlook.com
 ([fe80::9832:7a6d:cf4e:d511]) by AM0PR02MB5777.eurprd02.prod.outlook.com
 ([fe80::9832:7a6d:cf4e:d511%9]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 12:08:22 +0000
From:   Niclas Hedam <nhed@itu.dk>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH v3] net: sched: Add support for packet bursting.
Thread-Topic: [PATCH v3] net: sched: Add support for packet bursting.
Thread-Index: AQHXbBZKB2PwikligUmuVj3zphRt3A==
Date:   Mon, 28 Jun 2021 12:08:22 +0000
Message-ID: <5E66E8DB-E4E5-4658-9179-E3A5BD9E8A31@itu.dk>
References: <532A8EEC-59FD-42F2-8568-4C649677B4B0@itu.dk>
 <877diekybt.fsf@toke.dk>
In-Reply-To: <877diekybt.fsf@toke.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none header.from=itu.dk;
x-originating-ip: [130.226.132.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f82d13d4-2dcf-45df-2296-08d93a2d6d08
x-ms-traffictypediagnostic: AM9PR02MB6564:
x-microsoft-antispam-prvs: <AM9PR02MB65646A87FACB0541FB307E8CB4039@AM9PR02MB6564.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nEW1lwvNKGr/A8xP0QU4LPrw5Z/gE6dlVyXgwRheXvOBlbKqJiE/QwkHTVxVTPXOrWCw358XCc7HheV0g9pWqEXoBHtMpJ4d3Boc6lr2tOya0n1nlOm5TU5ivq89hvgXUpnza7e2rhz1lQmK3wNgb1Gd2Fi1x7qq4IXIlHWRwz/xlMuUrBrlOFyuEl+I2xP4AITGUyEheo1du8uhC+1AHQTVVREoimMMsC7izAJJQ51PjVbAyHwJgQNPa2E36R1kjykhc3M1PedFakNxIbH9Sg4jxeogQiR03TPBp1yrLSdMzMNRE9Raasejxk+P712h9UBMljInI61wFgCsFKy/N1l1mmotSC/FNMV60zAPwJyG2VboYFr/7xGqJ3QAWh7z1+nYkQxAF3xewsgKGulL5UmIU5pfdEYNwHjWK36fI7TewJjcQU+VAddji4peAQE/qmeQyFJF34h16uuU4361qlzf/Lzo8i+XZePzOzoLypL7jFSvgDT44NwAbjFd3Vz9lhOPTJbSoQZnk+KvZD5qo31/65UWucgkcFDLxEcvAw9WRHcfAK3tr1EbdzazONR/rOsl4dzyENXzryvQN6vqcs9WMZFozQrMxI4PLGfQnBPLCLD10kE/AT1i9hZg9eFN6N3dQ2F7ytk7twObEj9UBFUVfJpNMFyDGghXqRydQWjuUlSmQoRcQMET7LjDvmYU6IFX0bpPVz9OMcYOWoWNew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB5777.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39840400004)(346002)(396003)(376002)(6506007)(6486002)(6916009)(5660300002)(6512007)(33656002)(86362001)(122000001)(478600001)(38100700002)(66574015)(91956017)(76116006)(71200400001)(316002)(2616005)(8676002)(66946007)(66476007)(66556008)(64756008)(66446008)(186003)(26005)(83380400001)(2906002)(54906003)(4326008)(786003)(8976002)(8936002)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RE9qaHlONDRuSmRLR0YvODhJQnpKcGZwdkZNRytNY21IdVBtUE9WbXFrVnR6?=
 =?utf-8?B?cVRzcmhnOG5ITXlseTBCSHkwREgxdkFjdU1ybFpJRk1UYUp1MStKVndJZkZX?=
 =?utf-8?B?eWYydmIvU0lJNWs5T1c3b25lckdxaGR2VU5YbEpodW8yWWx1OVM1TWRxQUZ1?=
 =?utf-8?B?b0p4MHNSWGdUVWl5dnRjS1hVVFRLa3ptMUx4NGFNajlrMTcyV01tYWdRM1px?=
 =?utf-8?B?TnVoUzc0blROQlJEczZMY1FKdW52eGxrVUNqNWlkNENZRHhLL28yVnYwdkhx?=
 =?utf-8?B?SDR3US8zUUN2MjBBSmszUEhJbVlqdjVGWkluaDBJdnpybFpYc1RGWEZUVkNU?=
 =?utf-8?B?YU9VZWllRjVTQmZtUi9zWExSWkRxd0VIUUEyL2tYejg5cWc4bmdCV01icVY3?=
 =?utf-8?B?Sk5RMHdvV25lSHFsNVB2LzV6UjlFUXN2QWlMclRiNitMSW96QWFFbUx0cmZM?=
 =?utf-8?B?UDdKd21BNHpzRmVwTDBzZG1IeDM2bUlBcUxkSE1SemVWelZMRVZxQ0FqU1JK?=
 =?utf-8?B?bkxGbnQ1cEJUNHF1Sit1NytqK2hnUEI5OXdkYXhZT1NxYmkvTnRCQWo5b2gy?=
 =?utf-8?B?ZHg2RVd3Ynd5ejZzSm54SE5ySzJzQlVEZ3RsNkk0UDRFWFFVQTRCcUdReVNQ?=
 =?utf-8?B?TmxBVVlRRW1ObTFnSThhVHozUDI3SWdjcHloQTRhYlZTV1JvOTRnOFdBbS9L?=
 =?utf-8?B?UkpSVVljb1Y2Q3ZtempzUmhHQmdzM3UyUUNuMXF6RTA5b1FCZkhWU2pxOEQ3?=
 =?utf-8?B?QkJVQXpjMm1ZMnNlTXE5elhEelFJK0s0SURzOXRueGtzU0ROdkFHdjVkN201?=
 =?utf-8?B?bHVWQytZVzRjVmtHWTlHdVk4VVkyVUlpVkZDUURKYnZoTVFINFJXTzAyanFP?=
 =?utf-8?B?WEhxZEhwbXowbXowdml3Rkw0eWZEdzNpTlltcURhdUVJZGgrQjNRVG5NajdO?=
 =?utf-8?B?RGhkUXROV1FxejZaNjRRSTh4Tml5MHRXUmpHRm82dkprY0FaZjNkQkRkb3pV?=
 =?utf-8?B?M2pUS1Y1NTBFSTBYOExzS0s2RjVvTnpncWN1dWJkRXlFVVo0UzZPeW4wdVpu?=
 =?utf-8?B?L1MvZXlmVER6RkRLRWUrVlAzNHVNRFV4OWJodkdBaDlYeVhoZFZnSDc5T0Jj?=
 =?utf-8?B?ME5uZE03blN6eVBJZjdEOWlCNTh2dlJUeHppVmg0NDNkZTlqR3BCQzVkL21m?=
 =?utf-8?B?b1hNWVh5UFh2M2d0VlZPMTZYZGxGTm4yeHBVS2hXWVVNRXBOS1dvc0NXaW0v?=
 =?utf-8?B?S0RITkxrZENxTUxFMmduejh5SEFUeG40bXNtSHVpRXg3c1dXRFpXQXd4RENS?=
 =?utf-8?B?blpEMnVod2hCd1lkcHBLcWFZaWtaY29hbmZVZ0VwSW9sWWQzZGMyc0hJbWlP?=
 =?utf-8?B?NGVITEV6akFYdHVWbXc3RHN6emtQSUJ5WGhTUE5iV2JjUVVhdXVYeStTeDJ1?=
 =?utf-8?B?REd2TnJWK1lNNUV3Q3B6ZlpjcVRubXVxU04reE1JZ0NFTGYxellvTXVwYjRW?=
 =?utf-8?B?RFlNWG0vV3ZxaDNuY0pGZFpDTnppd1lzZ0pFZTVpL0thU3VjanBQK2NGRHpy?=
 =?utf-8?B?SUtkQVJvUEhrcFF5cU9QcXRuOGZWUndJRERwRHVhS1B0dy9ucDZlMTkrMkhs?=
 =?utf-8?B?Z1pCMXdCRVhvS3dFOGZhNGxqMk01ZEpuenFjRkdZWDBIcVhrVTUyZHNiNnFG?=
 =?utf-8?B?bXZZS2xqeWNjSFZtK0c2aUJ5eUJValk0VU5YdkV2bi9CRTRDaWFKOFpHRytn?=
 =?utf-8?B?eklBalBkM1VSMHEzSk94VlZlMXNZRXdjK2lLb1VKWDdvZ2pUVlR6TlZYSlIy?=
 =?utf-8?B?TWZsQUwvZXZtMXBTejBUZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A07643AAF54664F9EA0196EEF365C43@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: itu.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB5777.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f82d13d4-2dcf-45df-2296-08d93a2d6d08
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2021 12:08:22.6287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea229b6-7a08-4086-b44c-71f57f716bdb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g7rZznR1XqhbHA7A2MbFM3cett7HqA1orSbSqoIBZ9mdu0tk00LlA+Um08cUjH+9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR02MB6564
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBjb21taXQgaW1wbGVtZW50cyBwYWNrZXQgYnVyc3RpbmcgaW4gdGhlIE5ldEVtIHNjaGVk
dWxlci4NClRoaXMgYWxsb3dzIHN5c3RlbSBhZG1pbmlzdHJhdG9ycyB0byBob2xkIGJhY2sgb3V0
Z29pbmcNCnBhY2tldHMgYW5kIHJlbGVhc2UgdGhlbSBhdCBhIG11bHRpcGxlIG9mIGEgdGltZSBx
dWFudHVtLg0KVGhpcyBmZWF0dXJlIGNhbiBiZSB1c2VkIHRvIHByZXZlbnQgdGltaW5nIGF0dGFj
a3MgY2F1c2VkDQpieSBuZXR3b3JrIGxhdGVuY3kuDQoNClNpZ25lZC1vZmYtYnk6IE5pY2xhcyBI
ZWRhbSA8bmljbGFzQGhlZC5hbT4NCi0tLQ0KdjI6IGFkZCBlbnVtIGF0IGVuZCBvZiBsaXN0IChD
b25nIFdhbmcpDQp2MzogZml4ZWQgZm9ybWF0dGluZyBvZiBjb21taXQgZGlmZiAoVG9rZSBIw7hp
bGFuZC1Kw7hyZ2Vuc2VuKQ0KIGluY2x1ZGUvdWFwaS9saW51eC9wa3Rfc2NoZWQuaCB8ICAyICsr
DQogbmV0L3NjaGVkL3NjaF9uZXRlbS5jICAgICAgICAgIHwgMjQgKysrKysrKysrKysrKysrKysr
KysrLS0tDQogMiBmaWxlcyBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQ0KDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3BrdF9zY2hlZC5oIGIvaW5jbHVk
ZS91YXBpL2xpbnV4L3BrdF9zY2hlZC5oDQppbmRleCA3OWE2OTlmMTA2YjEuLjFiYTQ5ZjE0MWRh
ZSAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9wa3Rfc2NoZWQuaA0KKysrIGIvaW5j
bHVkZS91YXBpL2xpbnV4L3BrdF9zY2hlZC5oDQpAQCAtNjAzLDYgKzYwMyw3IEBAIGVudW0gew0K
IAlUQ0FfTkVURU1fSklUVEVSNjQsDQogCVRDQV9ORVRFTV9TTE9ULA0KIAlUQ0FfTkVURU1fU0xP
VF9ESVNULA0KKyAgICAgICAgVENBX05FVEVNX0JVUlNUSU5HLA0KIAlfX1RDQV9ORVRFTV9NQVgs
DQogfTsNCg0KQEAgLTYxNSw2ICs2MTYsNyBAQCBzdHJ1Y3QgdGNfbmV0ZW1fcW9wdCB7DQogCV9f
dTMyCWdhcDsJCS8qIHJlLW9yZGVyaW5nIGdhcCAoMCBmb3Igbm9uZSkgKi8NCiAJX191MzIgICBk
dXBsaWNhdGU7CS8qIHJhbmRvbSBwYWNrZXQgZHVwICAoMD1ub25lIH4wPTEwMCUpICovDQogCV9f
dTMyCWppdHRlcjsJCS8qIHJhbmRvbSBqaXR0ZXIgaW4gbGF0ZW5jeSAodXMpICovDQorCV9fdTMy
CWJ1cnN0aW5nOwkvKiBzZW5kIHBhY2tldHMgaW4gYnVyc3RzICh1cykgKi8NCiB9Ow0KDQogc3Ry
dWN0IHRjX25ldGVtX2NvcnIgew0KZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9zY2hfbmV0ZW0uYyBi
L25ldC9zY2hlZC9zY2hfbmV0ZW0uYw0KaW5kZXggMGMzNDVlNDNhMDlhLi41MmQ3OTYyODdiODYg
MTAwNjQ0DQotLS0gYS9uZXQvc2NoZWQvc2NoX25ldGVtLmMNCisrKyBiL25ldC9zY2hlZC9zY2hf
bmV0ZW0uYw0KQEAgLTg1LDYgKzg1LDcgQEAgc3RydWN0IG5ldGVtX3NjaGVkX2RhdGEgew0KIAlz
NjQgbGF0ZW5jeTsNCiAJczY0IGppdHRlcjsNCg0KKwl1MzIgYnVyc3Rpbmc7DQogCXUzMiBsb3Nz
Ow0KIAl1MzIgZWNuOw0KIAl1MzIgbGltaXQ7DQpAQCAtNDY3LDcgKzQ2OCw3IEBAIHN0YXRpYyBp
bnQgbmV0ZW1fZW5xdWV1ZShzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgUWRpc2MgKnNjaCwN
CiAJLyogSWYgYSBkZWxheSBpcyBleHBlY3RlZCwgb3JwaGFuIHRoZSBza2IuIChvcnBoYW5pbmcg
dXN1YWxseSB0YWtlcw0KIAkgKiBwbGFjZSBhdCBUWCBjb21wbGV0aW9uIHRpbWUsIHNvIF9iZWZv
cmVfIHRoZSBsaW5rIHRyYW5zaXQgZGVsYXkpDQogCSAqLw0KLQlpZiAocS0+bGF0ZW5jeSB8fCBx
LT5qaXR0ZXIgfHwgcS0+cmF0ZSkNCisJaWYgKHEtPmxhdGVuY3kgfHwgcS0+aml0dGVyIHx8IHEt
PnJhdGUgfHwgcS0+YnVyc3RpbmcpDQogCQlza2Jfb3JwaGFuX3BhcnRpYWwoc2tiKTsNCg0KIAkv
Kg0KQEAgLTUyNyw4ICs1MjgsMTcgQEAgc3RhdGljIGludCBuZXRlbV9lbnF1ZXVlKHN0cnVjdCBz
a19idWZmICpza2IsIHN0cnVjdCBRZGlzYyAqc2NoLA0KIAlxZGlzY19xc3RhdHNfYmFja2xvZ19p
bmMoc2NoLCBza2IpOw0KDQogCWNiID0gbmV0ZW1fc2tiX2NiKHNrYik7DQotCWlmIChxLT5nYXAg
PT0gMCB8fAkJLyogbm90IGRvaW5nIHJlb3JkZXJpbmcgKi8NCi0JICAgIHEtPmNvdW50ZXIgPCBx
LT5nYXAgLSAxIHx8CS8qIGluc2lkZSBsYXN0IHJlb3JkZXJpbmcgZ2FwICovDQorCWlmIChxLT5i
dXJzdGluZyA+IDApIHsNCisJCXU2NCBub3c7DQorDQorCQlub3cgPSBrdGltZV9nZXRfbnMoKTsN
CisNCisJCWNiLT50aW1lX3RvX3NlbmQgPSBub3cgLSAobm93ICUgcS0+YnVyc3RpbmcpICsgcS0+
YnVyc3Rpbmc7DQorDQorCQkrK3EtPmNvdW50ZXI7DQorCQl0Zmlmb19lbnF1ZXVlKHNrYiwgc2No
KTsNCisJfSBlbHNlIGlmIChxLT5nYXAgPT0gMCB8fAkJLyogbm90IGRvaW5nIHJlb3JkZXJpbmcg
Ki8NCisJICAgIHEtPmNvdW50ZXIgPCBxLT5nYXAgLSAxIHx8CQkvKiBpbnNpZGUgbGFzdCByZW9y
ZGVyaW5nIGdhcCAqLw0KIAkgICAgcS0+cmVvcmRlciA8IGdldF9jcmFuZG9tKCZxLT5yZW9yZGVy
X2NvcikpIHsNCiAJCXU2NCBub3c7DQogCQlzNjQgZGVsYXk7DQpAQCAtOTI3LDYgKzkzNyw3IEBA
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgbmxhX3BvbGljeSBuZXRlbV9wb2xpY3lbVENBX05FVEVNX01B
WCArIDFdID0gew0KIAlbVENBX05FVEVNX0VDTl0JCT0geyAudHlwZSA9IE5MQV9VMzIgfSwNCiAJ
W1RDQV9ORVRFTV9SQVRFNjRdCT0geyAudHlwZSA9IE5MQV9VNjQgfSwNCiAJW1RDQV9ORVRFTV9M
QVRFTkNZNjRdCT0geyAudHlwZSA9IE5MQV9TNjQgfSwNCisJW1RDQV9ORVRFTV9CVVJTVElOR10J
PSB7IC50eXBlID0gTkxBX1U2NCB9LA0KIAlbVENBX05FVEVNX0pJVFRFUjY0XQk9IHsgLnR5cGUg
PSBOTEFfUzY0IH0sDQogCVtUQ0FfTkVURU1fU0xPVF0JPSB7IC5sZW4gPSBzaXplb2Yoc3RydWN0
IHRjX25ldGVtX3Nsb3QpIH0sDQogfTsNCkBAIC0xMDAxLDYgKzEwMTIsNyBAQCBzdGF0aWMgaW50
IG5ldGVtX2NoYW5nZShzdHJ1Y3QgUWRpc2MgKnNjaCwgc3RydWN0IG5sYXR0ciAqb3B0LA0KDQog
CXEtPmxhdGVuY3kgPSBQU0NIRURfVElDS1MyTlMocW9wdC0+bGF0ZW5jeSk7DQogCXEtPmppdHRl
ciA9IFBTQ0hFRF9USUNLUzJOUyhxb3B0LT5qaXR0ZXIpOw0KKwlxLT5idXJzdGluZyA9IFBTQ0hF
RF9USUNLUzJOUyhxb3B0LT5idXJzdGluZyk7DQogCXEtPmxpbWl0ID0gcW9wdC0+bGltaXQ7DQog
CXEtPmdhcCA9IHFvcHQtPmdhcDsNCiAJcS0+Y291bnRlciA9IDA7DQpAQCAtMTAzMiw2ICsxMDQ0
LDkgQEAgc3RhdGljIGludCBuZXRlbV9jaGFuZ2Uoc3RydWN0IFFkaXNjICpzY2gsIHN0cnVjdCBu
bGF0dHIgKm9wdCwNCiAJaWYgKHRiW1RDQV9ORVRFTV9MQVRFTkNZNjRdKQ0KIAkJcS0+bGF0ZW5j
eSA9IG5sYV9nZXRfczY0KHRiW1RDQV9ORVRFTV9MQVRFTkNZNjRdKTsNCg0KKwlpZiAodGJbVENB
X05FVEVNX0JVUlNUSU5HXSkNCisJCXEtPmJ1cnN0aW5nID0gbmxhX2dldF91NjQodGJbVENBX05F
VEVNX0JVUlNUSU5HXSk7DQorDQogCWlmICh0YltUQ0FfTkVURU1fSklUVEVSNjRdKQ0KIAkJcS0+
aml0dGVyID0gbmxhX2dldF9zNjQodGJbVENBX05FVEVNX0pJVFRFUjY0XSk7DQoNCkBAIC0xMTUw
LDYgKzExNjUsOSBAQCBzdGF0aWMgaW50IG5ldGVtX2R1bXAoc3RydWN0IFFkaXNjICpzY2gsIHN0
cnVjdCBza19idWZmICpza2IpDQogCQkJICAgICBVSU5UX01BWCk7DQogCXFvcHQuaml0dGVyID0g
bWluX3QocHNjaGVkX3RkaWZmX3QsIFBTQ0hFRF9OUzJUSUNLUyhxLT5qaXR0ZXIpLA0KIAkJCSAg
ICBVSU5UX01BWCk7DQorCXFvcHQuYnVyc3RpbmcgPSBtaW5fdChwc2NoZWRfdGRpZmZfdCwgUFND
SEVEX05TMlRJQ0tTKHEtPmJ1cnN0aW5nKSwNCisJCQkgICAgVUlOVF9NQVgpOw0KKw0KIAlxb3B0
LmxpbWl0ID0gcS0+bGltaXQ7DQogCXFvcHQubG9zcyA9IHEtPmxvc3M7DQogCXFvcHQuZ2FwID0g
cS0+Z2FwOw0KLS0NCjIuMjUuMQ==
