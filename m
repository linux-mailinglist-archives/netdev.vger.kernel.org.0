Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E581FB501
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbgFPOvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:51:36 -0400
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:6159
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728515AbgFPOvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 10:51:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=donZodjXUbBe4Qwu8Isr8fKY2Iz8aia1z7zDDGLl0zkWrRYghuNS9KJdnG0ik4gZgAz8EY3SQMzBqFV0OCE4gmZpvLUp+7W1TwIeN6XNF/tkP7fiuxDx5ey6x4QmsfZgsfZ6vsEh1NtaE7HkzZmyxTsJOD9fZw2sGKWpPJd43j0fq8cs1enhiIrEnNZicr/sQt7vAXRWe6yGmo30f+7A6bUcnROZ/W3ii7cfg+9i3kMw3uQaDNCK7/ZdIBFPmRaODv7t6sRW6XTtNV8yIwZiwnitOVqPT7rjzstXRwuWq9TGSPwYiO9zSzqs9P8ManCBGNRF84i1p+OXCiU0zsGjAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ggq02sGNJV+AeMcT+defxVymL+VLIKkGjAoobcN5skk=;
 b=b1A+sV8bqy6e2QAO86tfPboH5HnMFW7UzWGOcpaDe28z3LmoRBaHtzAeZctKA01p+NpI5xSgerPZf/O3WmMXT2nUZhBc6WwDQsOZNS1hgizMxFpcCbS3LvBQDStL705mzBprAwNFIewEeno8ZjAzqjk/hFedkaVkQfngBtxFU87SK1EEhHEBOPquRxEVF8+mzLYE1m8ktrhq/9wo0gENlWmbfHk+Jyal9xcB1IZFvg8vLcspZVE6C1nQzs0X1VeFj60Ck4RJoBxW+vdo2GKrnIvZ7hKDwM8RO6O1pGz5sPTkNf1h9ZuY002Q4FtXFwT3DEpI0HATDJufPv4RLSgvXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ggq02sGNJV+AeMcT+defxVymL+VLIKkGjAoobcN5skk=;
 b=F21Ig/Ii0Dg6ldb6HRG1/y9SsL6A8P9Nnkh9IJuwBG10ZHwZ5yhZ+UhTVPQULLRi4BTcu1Djs8JQPIliiCKCml1AyBWiWwlf8Mv8d4uCDf20m/LsBiLaC7TxNJO72oZ9Iea2vN1KFhNqTDORilQqFiwDRlpmUyHRso51HWDmyFE=
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 (2603:10b6:301:2e::20) by MWHPR10MB1919.namprd10.prod.outlook.com
 (2603:10b6:300:10a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21; Tue, 16 Jun
 2020 14:51:32 +0000
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1]) by MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1%5]) with mapi id 15.20.3088.028; Tue, 16 Jun 2020
 14:51:32 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "madalin.bucur@oss.nxp.com" <madalin.bucur@oss.nxp.com>,
        "fido_max@inbox.ru" <fido_max@inbox.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 2/2] dpaa_eth: fix usage as DSA master, try 4
Thread-Topic: [PATCH net 2/2] dpaa_eth: fix usage as DSA master, try 4
Thread-Index: AQHWQ+w4YATHUwfoUU+FfDKFMLwXTKjbU2QA
Date:   Tue, 16 Jun 2020 14:51:31 +0000
Message-ID: <acb765da28bde4dff4fc2cd9ea661fa1b3486947.camel@infinera.com>
References: <20200616144118.3902244-1-olteanv@gmail.com>
         <20200616144118.3902244-3-olteanv@gmail.com>
In-Reply-To: <20200616144118.3902244-3-olteanv@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 638b5407-a186-4bfb-96ef-08d81204c236
x-ms-traffictypediagnostic: MWHPR10MB1919:
x-microsoft-antispam-prvs: <MWHPR10MB1919E85F3A59CD0814CA7B7AF49D0@MWHPR10MB1919.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04362AC73B
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rg8EMKAuhDnhDHVLSjEf1VoYTXZzw4U9I8zNZivi+DgqCg5KF0suXUBqduNAiCDb/pTTp8ksNw1+9SWH5I1ku1fzEJm4d4ocuiaIJTIAxibmPkOsCeDPPH/OK8TQB9shYPv7ATyB6ZbRSVOkTwOkRuiiYU6VFFkPZEEIlaY4IQ0ZJGBF8waofjP1k8tnXcty6HfT6utKl6tKMi4oeXjbrjLO+r7/xxXGVmHy0lWq2ncsSlu7tLhMSIvm4Frp1ylJy0kKR6QJd7p4Yzk/+FCHn0dIj316zOkQWR5QeoTQqkUb6JqPzMakyvL7XQsB7G8d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2190.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(83380400001)(2906002)(4326008)(36756003)(5660300002)(6512007)(2616005)(76116006)(6506007)(8936002)(91956017)(66446008)(64756008)(186003)(316002)(26005)(66556008)(66946007)(66476007)(71200400001)(478600001)(6486002)(54906003)(86362001)(110136005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: do2XLHS4veBs+W+SGhgLVrNqjHdAWS8aC3R7BZLCleF0SNIWG7uV3dE/VhH08ynsqrMJaRfvmRRfJbTHug0DKs/HQkvO6uRyn4KT5IwuopiZYRqrzuxHSnT1aOmrtvRTrXsYmqB54FFnQ7xht8vyt5uQyUTCtpQh3q0LA35vcPaseVDw03+DgLQFZFNV7ClItPknnh1SsgaZZaJrPHGz6/BFRgI8t5KydEB+SZaz1BNxzETzo18eq3q/e8XGUmjktwxa36hOnXq8Faib+UrAUVtdHRytSYwhaHEmsKJLfAtuJKkwuym9OhcrIQEcDBL3jt3IfOXQgtSC1K2EIhHjqhP3VnCNiWoIYmE8l0+jw5KuzJkoagIWqXi9AFq3UHuR7HW76thIoH5R1T1dkeWnRjQAQ7yrsgKdsLZM8XHPvboaEuU23FpzqJ+xypRt5YHLV+j3mU+MYlSLFlNPn2LxnxVOPNrUjb5BDVf/WNGOwq/8FZlV1b9dBleKEmllfvHe
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D9F99458ECC8648B0986F38E88DEEC8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 638b5407-a186-4bfb-96ef-08d81204c236
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2020 14:51:31.8572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MrraTOLQyMraz/9MmsZoNnhYSJJBIWAxUg/TYZDauGTn8PGXrQRUXluOs4lo6QBOs9QNzU/KhbBylmtXB330qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1919
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA2LTE2IGF0IDE3OjQxICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEZyb206IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+DQo+IA0K
PiBUaGUgZHBhYS1ldGggZHJpdmVyIHByb2JlcyBvbiBjb21wYXRpYmxlIHN0cmluZyBmb3IgdGhl
IE1BQyBub2RlLCBhbmQNCj4gdGhlIGZtYW4vbWFjLmMgZHJpdmVyIGFsbG9jYXRlcyBhIGRwYWEt
ZXRoZXJuZXQgcGxhdGZvcm0gZGV2aWNlIHRoYXQNCj4gdHJpZ2dlcnMgdGhlIHByb2Jpbmcgb2Yg
dGhlIGRwYWEtZXRoIG5ldCBkZXZpY2UgZHJpdmVyLg0KPiANCj4gQWxsIG9mIHRoaXMgaXMgZmlu
ZSwgYnV0IHRoZSBwcm9ibGVtIGlzIHRoYXQgdGhlIHN0cnVjdCBkZXZpY2Ugb2YgdGhlDQo+IGRw
YWFfZXRoIG5ldF9kZXZpY2UgaXMgMiBwYXJlbnRzIGF3YXkgZnJvbSB0aGUgTUFDIHdoaWNoIGNh
biBiZQ0KPiByZWZlcmVuY2VkIHZpYSBvZl9ub2RlLiBTbyBvZl9maW5kX25ldF9kZXZpY2VfYnlf
bm9kZSBjYW4ndCBmaW5kIGl0LCBhbmQNCj4gRFNBIHN3aXRjaGVzIHdvbid0IGJlIGFibGUgdG8g
cHJvYmUgb24gdG9wIG9mIEZNYW4gcG9ydHMuDQo+IA0KPiBJdCB3b3VsZCBiZSBhIGJpdCBzaWxs
eSB0byBtb2RpZnkgYSBjb3JlIGZ1bmN0aW9uDQo+IChvZl9maW5kX25ldF9kZXZpY2VfYnlfbm9k
ZSkgdG8gbG9vayBmb3IgZGV2LT5wYXJlbnQtPnBhcmVudC0+b2Zfbm9kZQ0KPiBqdXN0IGZvciBv
bmUgZHJpdmVyLiBXZSdyZSBqdXN0IDEgc3RlcCBhd2F5IGZyb20gaW1wbGVtZW50aW5nIGZ1bGwN
Cj4gcmVjdXJzaW9uLg0KPiANCj4gT24gVDEwNDAsIHRoZSAvc3lzL2NsYXNzL25ldC9ldGgwIHN5
bWxpbmsgY3VycmVudGx5IHBvaW50cyB0bzoNCj4gDQo+IC4uLy4uL2RldmljZXMvcGxhdGZvcm0v
ZmZlMDAwMDAwLnNvYy9mZmU0MDAwMDAuZm1hbi9mZmU0ZTYwMDAuZXRoZXJuZXQvbmV0L2V0aDAN
Cg0KSnVzdCB3YW50IHRvIHBvaW50IG91dCB0aGF0IG9uIDQuMTkueCwgdGhlIGFib3ZlIHBhdGNo
IHN0aWxsIGV4aXN0czoNCmNkIC9zeXMNCmZpbmQgLW5hbWUgZXRoMA0KLi9kZXZpY2VzL3BsYXRm
b3JtL2ZmZTAwMDAwMC5zb2MvZmZlNDAwMDAwLmZtYW4vZmZlNGU2MDAwLmV0aGVybmV0L25ldC9l
dGgwDQouL2NsYXNzL25ldC9ldGgNCg0KPiANCj4gd2hpY2ggcHJldHR5IG11Y2ggaWxsdXN0cmF0
ZXMgdGhlIHByb2JsZW0uIFRoZSBjbG9zZXN0IG9mX25vZGUgd2UndmUgZ290DQo+IGlzIHRoZSAi
ZnNsLGZtYW4tbWVtYWMiIGF0IC9zb2NAZmZlMDAwMDAwL2ZtYW5ANDAwMDAwL2V0aGVybmV0QGU2
MDAwLA0KPiB3aGljaCBpcyB3aGF0IHdlJ2QgbGlrZSB0byBiZSBhYmxlIHRvIHJlZmVyZW5jZSBm
cm9tIERTQSBhcyBob3N0IHBvcnQuDQo+IA0KPiBGb3Igb2ZfZmluZF9uZXRfZGV2aWNlX2J5X25v
ZGUgdG8gZmluZCB0aGUgZXRoMCBwb3J0LCB3ZSB3b3VsZCBuZWVkIHRoZQ0KPiBwYXJlbnQgb2Yg
dGhlIGV0aDAgbmV0X2RldmljZSB0byBub3QgYmUgdGhlICJkcGFhLWV0aGVybmV0IiBwbGF0Zm9y
bQ0KPiBkZXZpY2UsIGJ1dCB0byBwb2ludCAxIGxldmVsIGhpZ2hlciwgYWthIHRoZSAiZnNsLGZt
YW4tbWVtYWMiIG5vZGUNCj4gZGlyZWN0bHkuIFRoZSBuZXcgc3lzZnMgcGF0aCB3b3VsZCBsb29r
IGxpa2UgdGhpczoNCj4gDQo+IC4uLy4uL2RldmljZXMvcGxhdGZvcm0vZmZlMDAwMDAwLnNvYy9m
ZmU0MDAwMDAuZm1hbi9mZmU0ZTYwMDAuZXRoZXJuZXQvZHBhYS1ldGhlcm5ldC4wL25ldC9ldGgw
DQo+IA0KPiBBY3R1YWxseSB0aGlzIGhhcyB3b3JrZWQgYmVmb3JlLCB0aHJvdWdoIHRoZSBTRVRf
TkVUREVWX0RFViBtZWNoYW5pc20sDQo+IHdoaWNoIHNldHMgdGhlIHBhcmVudCBvZiB0aGUgbmV0
X2RldmljZSBhcyB0aGUgcGFyZW50IG9mIHRoZSBwbGF0Zm9ybQ0KPiBkZXZpY2UuIEJ1dCB0aGUg
ZGV2aWNlIHdoaWNoIHdhcyBzZXQgYXMgc3lzZnMgcGFyZW50IHdhcyBpbmFkdmVydGVudGx5DQo+
IGNoYW5nZWQgdGhyb3VnaCBjb21taXQgMDYwYWQ2NmY5Nzk1ICgiZHBhYV9ldGg6IGNoYW5nZSBE
TUEgZGV2aWNlIiksDQo+IHdoaWNoIGRpZCBub3QgdGFrZSBpbnRvIGNvbnNpZGVyYXRpb24gdGhl
IGVmZmVjdCBpdCB3b3VsZCBoYXZlIHVwb24NCj4gb2ZfZmluZF9uZXRfZGV2aWNlX2J5X25vZGUu
IFNvIHJlc3RvcmUgdGhlIG9sZCBzeXNmcyBwYXJlbnQgdG8gbWFrZSB0aGF0DQo+IHdvcmsgY29y
cmVjdGx5Lg0KPiANCj4gRml4ZXM6IDA2MGFkNjZmOTc5NSAoImRwYWFfZXRoOiBjaGFuZ2UgRE1B
IGRldmljZSIpDQo+IFNpZ25lZC1vZmYtYnk6IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0
ZWFuQG54cC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2Rw
YWEvZHBhYV9ldGguYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Zy
ZWVzY2FsZS9kcGFhL2RwYWFfZXRoLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUv
ZHBhYS9kcGFhX2V0aC5jDQo+IGluZGV4IGM0NDE2YTVmODgxNi4uMjk3MjI0NGU2ZWIwIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFhX2V0aC5j
DQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhL2RwYWFfZXRoLmMN
Cj4gQEAgLTI5MTQsNyArMjkxNCw3IEBAIHN0YXRpYyBpbnQgZHBhYV9ldGhfcHJvYmUoc3RydWN0
IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gICAgICAgICB9DQo+IA0KPiAgICAgICAgIC8qIERv
IHRoaXMgaGVyZSwgc28gd2UgY2FuIGJlIHZlcmJvc2UgZWFybHkgKi8NCj4gLSAgICAgICBTRVRf
TkVUREVWX0RFVihuZXRfZGV2LCBkZXYpOw0KPiArICAgICAgIFNFVF9ORVRERVZfREVWKG5ldF9k
ZXYsIGRldi0+cGFyZW50KTsNCj4gICAgICAgICBkZXZfc2V0X2RydmRhdGEoZGV2LCBuZXRfZGV2
KTsNCj4gDQo+ICAgICAgICAgcHJpdiA9IG5ldGRldl9wcml2KG5ldF9kZXYpOw0KPiAtLQ0KPiAy
LjI1LjENCj4gDQoNCg==
