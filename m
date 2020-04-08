Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92DE81A2978
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 21:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbgDHTm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 15:42:56 -0400
Received: from mail-eopbgr10086.outbound.protection.outlook.com ([40.107.1.86]:25414
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727187AbgDHTmz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 15:42:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFW34sOLly0y8EeDW3ysHL3ONq20+OnuoaUUbr7iksP3lqGSSHTXn7WasXJoHosqqArg7WmBzZ0jjQe0I5v6KGKRXmlSBYtn2vk4A0aRbeUWko111x6ypN6PdYxnSz0GZNILegZJp5W+1LXBSV2CuqjcnU1FJBqp7jSRN9/FVwSKfY1MDrS+sS3D544dIrZvYLL9kGEZl3lEqJTFqK+30tYZFaTKXowQeI40OlIu6jmzR9PTRGAJGDyJm/uQs047nkNrrVB+gqlK9/cmYiNzvdMPZRxZmbb/9OVEivyV+VABrfDi6k0WaPqjYPpDCNtSLBxf5uJeXpEwhx1xVmfUGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/pTqIR7qmH6eKGVXlNVZKOl7KBq/uTH73zRyoSVM38=;
 b=JNJx3MUtxk24R8iedDcBnHbW0cLYEcxCW3g1KLwwB92KmkqirH9Y56z3x4XJbRIxhfdtiXfGVA9J+GocmHKgEFdUun+Fa5dZlwYvMwb7tR24RmfMoJSKnv1kouewUo+iJaDSB/SjaNUMitQriK1DwRYw2YQYYvWS1bm0Wpa5Vx65lr9QaJNHAmpREb587KObvhtQPhVZsTSvzYZueO9pr5BaYu0nkh7aGzS8hS92NyTgmvqztuwMqwvkNUZ638lSk/OveWVPaP/HRcdHbWrywyuYJftgdukA4TDizC/YJwBHOw2+RNRH/Cq54R98x8BN1VK09lk2OjbKVRsgeb/Fqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/pTqIR7qmH6eKGVXlNVZKOl7KBq/uTH73zRyoSVM38=;
 b=mhx0JZzeXi6E7e0OrRBcU/3Hlirm3KA3oVO6IEF3BfcXY6/a+x9lRlYQY4aa/9QzN4ZdS2YE9qY4fX0b9k0lv5/gw8jruR67tb1RIk/f6H/cVTiC6yzbddgKjnJMnFZfx5GwX4rINW7QZtiRKtZqTlN4nW/J51o1SLOJxvj8FsU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6896.eurprd05.prod.outlook.com (2603:10a6:800:178::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Wed, 8 Apr
 2020 19:42:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 19:42:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "xianfengting221@163.com" <xianfengting221@163.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "cai@lca.pw" <cai@lca.pw>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "lsahlber@redhat.com" <lsahlber@redhat.com>,
        "kw@linux.com" <kw@linux.com>,
        "xiubli@redhat.com" <xiubli@redhat.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wqu@suse.com" <wqu@suse.com>,
        "chris@chris-wilson.co.uk" <chris@chris-wilson.co.uk>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "stfrench@microsoft.com" <stfrench@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5: add the missing space character
Thread-Topic: [PATCH v2] net/mlx5: add the missing space character
Thread-Index: AQHWCXBS9ROcHN2SK0+YUleKNIIPWqhvqOGA
Date:   Wed, 8 Apr 2020 19:42:49 +0000
Message-ID: <14df0ecf093bb2df4efaf9e6f5220ea2bf863f53.camel@mellanox.com>
References: <20200403042659.9167-1-xianfengting221@163.com>
In-Reply-To: <20200403042659.9167-1-xianfengting221@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fca70251-73ec-42d5-1b07-08d7dbf50544
x-ms-traffictypediagnostic: VI1PR05MB6896:|VI1PR05MB6896:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB689637986C95B28723D6BBF1BEC00@VI1PR05MB6896.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:216;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(136003)(346002)(396003)(39850400004)(366004)(8936002)(64756008)(7416002)(91956017)(66446008)(36756003)(478600001)(66556008)(66476007)(66946007)(76116006)(81166007)(71200400001)(6512007)(2906002)(4326008)(316002)(110136005)(6506007)(54906003)(5660300002)(86362001)(81156014)(2616005)(8676002)(6486002)(186003)(26005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mQN2jzqo29KnCKoO5OWp/EaY5zsUcVyN1Ydu9BSJNfL4qQ8wRjN4TnUthbM7duWMg8Z0kHTVcgwlxGgeZQdXJ/3x3otZChALIIbyaQkqpJGgBUz8xw8Ki5bjFVE8YYuOztgLDVCzDjimXpnlGhhif0ylYgvhK4jEUktUaybqmOwOyfwYojR9GHrDevjm2kd6+q9O7lFskuRaqwE3hdt6E7rxa7AzAaljpFYXT+0ZUidMaPifcj4GX8G8hLHSuT/UDzKAFbWgulWChhn0treRgW5W6JzvG1MbkZVFy9fTy8IDBjY/npDkGofr8qKuYsA7+3Adg2kA08xTYFs6bYumAGRleKjF9k+v+ZH9JFMWFMAEYZNXa30JyTbOCDiaAaEvjZ3hBJaA9PUK6KZr1FinM7Ay2mePlSBWPi6I98QMG6wBhy5xUykgsZlw5Hsmo21N
x-ms-exchange-antispam-messagedata: nulw/28YQUWIVnoAdm5EIKfJx5opsZBElgpJLghyn3kqtB03sWiejLFk5G90lu9UM5KNEBUkFgCjFCASoEUqs8Xa9PQyZcb8ktFw0Yl9Ppu/DDs8rDy4XO1KJIq1kvyL3zV8KwsI/TnMySM8deJQQw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <83C62A16FD5216469246C72D0E2568EF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fca70251-73ec-42d5-1b07-08d7dbf50544
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 19:42:49.7035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QpTHWwZhT3EKnxTea/+Br4E+R4xGaApG0dtkhN/6YWYxjM9ruJu2L/T8e7I0PyKhTEaA1cAjOO+VMArSHeMQMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6896
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA0LTAzIGF0IDEyOjI2ICswODAwLCBIdSBIYW93ZW4gd3JvdGU6DQo+IENv
bW1pdCA5MWI1NmQ4NDYyYTkgKCJuZXQvbWx4NTogaW1wcm92ZSBzb21lIGNvbW1lbnRzIikgZGlk
IG5vdCBhZGQNCj4gdGhhdCBtaXNzaW5nIHNwYWNlIGNoYXJhY3RlciBhbmQgdGhpcyBjb21taXQg
aXMgdXNlZCB0byBmaXggaXQgdXAuDQo+IA0KPiBGaXhlczogOTFiNTZkODQ2MmE5ICgibmV0L21s
eDU6IGltcHJvdmUgc29tZSBjb21tZW50cyIpDQo+IA0KDQpQbGVhc2UgcmUtc3BpbiBhbmQgc3Vi
bWl0IHRvIG5ldC1uZXh0IG9uY2UgbmV0LW5leHQgcmUtb3BlbnMsIA0KYXZvaWQgcmVmZXJlbmNp
bmcgdGhlIGFib3ZlIGNvbW1pdCBzaW5jZSB0aGlzIHBhdGNoIGlzIGEgc3RhbmQgYWxvbmUNCmFu
ZCBoYXMgbm90aGluZyB0byBkbyB3aXRoIHRoYXQgcGF0Y2guLiBqdXN0IGhhdmUgYSBzdGFuZCBh
bG9uZSBjb21taXQNCm1lc3NhZ2UgZXhwbGFpbmluZyB0aGUgc3BhY2UgZml4Lg0KDQppIGZpeGVk
IHRoZSBjb21taXQgbWVzc2FnZSBvZiB0aGUgcHJldmlvdXMgcGF0Y2gsIHNvIHRoZSBGaXhlcyB0
YWcgaXMNCnVubmVjZXNzYXJ5IA0KDQo+IFNpZ25lZC1vZmYtYnk6IEh1IEhhb3dlbiA8eGlhbmZl
bmd0aW5nMjIxQDE2My5jb20+DQoNCg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9kaWFnL2Z3X3RyYWNlci5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2RpYWcvZndfdHJhY2VyLmMNCj4g
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGlhZy9md190cmFjZXIu
Yw0KPiBpbmRleCBjOWM5YjQ3OWJkYTUuLjMxYmRkYjQ4ZTVjMyAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2RpYWcvZndfdHJhY2VyLmMNCj4g
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2RpYWcvZndfdHJh
Y2VyLmMNCj4gQEAgLTY3Niw3ICs2NzYsNyBAQCBzdGF0aWMgdm9pZCBtbHg1X2Z3X3RyYWNlcl9o
YW5kbGVfdHJhY2VzKHN0cnVjdA0KPiB3b3JrX3N0cnVjdCAqd29yaykNCj4gIAlibG9ja19jb3Vu
dCA9IHRyYWNlci0+YnVmZi5zaXplIC8gVFJBQ0VSX0JMT0NLX1NJWkVfQllURTsNCj4gIAlzdGFy
dF9vZmZzZXQgPSB0cmFjZXItPmJ1ZmYuY29uc3VtZXJfaW5kZXggKg0KPiBUUkFDRVJfQkxPQ0tf
U0laRV9CWVRFOw0KPiAgDQo+IC0JLyogQ29weSB0aGUgYmxvY2sgdG8gbG9jYWwgYnVmZmVyIHRv
IGF2b2lkIEhXIG92ZXJyaWRlIHdoaWxlDQo+IGJlaW5nIHByb2Nlc3NlZCovDQo+ICsJLyogQ29w
eSB0aGUgYmxvY2sgdG8gbG9jYWwgYnVmZmVyIHRvIGF2b2lkIEhXIG92ZXJyaWRlIHdoaWxlDQo+
IGJlaW5nIHByb2Nlc3NlZCAqLw0KPiAgCW1lbWNweSh0bXBfdHJhY2VfYmxvY2ssIHRyYWNlci0+
YnVmZi5sb2dfYnVmICsgc3RhcnRfb2Zmc2V0LA0KPiAgCSAgICAgICBUUkFDRVJfQkxPQ0tfU0la
RV9CWVRFKTsNCj4gIA0K
