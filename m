Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB5A7DA71
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 13:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbfHALkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 07:40:32 -0400
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:23042
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729318AbfHALkb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 07:40:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQ8hexgn2vjNdc2qtGlsEESxYv76pqxhEDcCB84kb/SY9sXgHJTIbej64Z7mwa7AfAoWNO2sy0+dAJLm3wDfuQ+VxT4zDPmgWwiK8i5RT/meoAaHoWVlvXEdZoH8zG+WyoCi546MRWAQKl+cjpqDV9tZXy18SHXLe7dVJuhU4cEPCT3zKqR3gLx09+57018CKxc7fE3uuQPIvG+bo88ghClK+GC20HwZEill1ALMyYElg+wWnGvYlR1VJkBwcDOTP2HeXjY002VNO7BYK/8kYRoqTZt3uIACVJlOhvbdUJCVr02RtOgl6LvQjsxoTEcmYc4dNcvApC+SRYhPHfTglQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggj8WBcxc5o+pblt5UnGzLhb791fjaTRHyeZmUFnXew=;
 b=YpTeosJpZupFNhyxgaSE6gFccQkQ4fHf179zS26FIvXdIsgikSzwlVR292GyB9pMjzaSnwMyVRkCLjHs6qa4Kw9NrllZ6e7urGDcVpIQ3Z5fbAD78IOejbwNnHG4GX+FRmJjK0bN8FaD+eFkjOn+/z0kXLH3vwgR0LQc+xfRLM3AFhIS5scLNeYh8l5koCysdfnfi5jG3p520xmWR0X85SBCRWVron+5JTdT52ogdEwDLGitUPvHzfVAnadDHM4eyAz+BWmW+cOQ6w7YIjQjyEfc/6E6uddXTEMX7xJX8bLWyZprw/EzhNxtHUDUJ+yZgrlwd+4nmP+yw+5hEQTxxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggj8WBcxc5o+pblt5UnGzLhb791fjaTRHyeZmUFnXew=;
 b=imJTSROYeyu0X6JBwO1mcoOPlV56Bj+dVfiEBmTxS0bpSP+iMdgZo7hxaucRCgvB3nlg32B6DC/CSPyVrd/WN0kabO59quMaIMV2WF10Z3wjr6F1S9XczJEe9tP9XrJjJ8zHF54tlrLZtvpLrXC4LFVI/TS6/RDuIFjgCLyQbYk=
Received: from DB7PR05MB4201.eurprd05.prod.outlook.com (52.135.128.31) by
 DB7PR05MB4299.eurprd05.prod.outlook.com (52.134.108.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Thu, 1 Aug 2019 11:40:27 +0000
Received: from DB7PR05MB4201.eurprd05.prod.outlook.com
 ([fe80::e058:5cb7:e073:2e6e]) by DB7PR05MB4201.eurprd05.prod.outlook.com
 ([fe80::e058:5cb7:e073:2e6e%2]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 11:40:27 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     "xiangxia.m.yue@gmail.com" <xiangxia.m.yue@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Allow dropping specific tunnel
 packets
Thread-Topic: [PATCH net-next] net/mlx5e: Allow dropping specific tunnel
 packets
Thread-Index: AQHVSEvWPe1RR7PYh0SU7IZ7jQEneabmKzgA
Date:   Thu, 1 Aug 2019 11:40:27 +0000
Message-ID: <994bd4bf-c020-ea2c-f131-7db5efa62a34@mellanox.com>
References: <1564648859-17369-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1564648859-17369-1-git-send-email-xiangxia.m.yue@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-clientproxiedby: PR0P264CA0151.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::19) To DB7PR05MB4201.eurprd05.prod.outlook.com
 (2603:10a6:5:21::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8198417-2bc2-426b-1ead-08d716750ca4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR05MB4299;
x-ms-traffictypediagnostic: DB7PR05MB4299:
x-microsoft-antispam-prvs: <DB7PR05MB4299B2AF2D0512BCA76C2FEFB5DE0@DB7PR05MB4299.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(189003)(199004)(256004)(99286004)(14444005)(14454004)(76176011)(65826007)(386003)(6506007)(53546011)(446003)(11346002)(476003)(6436002)(7736002)(486006)(2616005)(6512007)(6636002)(305945005)(229853002)(8936002)(5660300002)(53936002)(31696002)(86362001)(186003)(26005)(102836004)(71190400001)(71200400001)(6486002)(478600001)(81156014)(68736007)(8676002)(6246003)(6116002)(4326008)(64126003)(25786009)(64756008)(66556008)(66476007)(66946007)(81166006)(52116002)(3846002)(2906002)(36756003)(31686004)(66066001)(65806001)(66446008)(110136005)(65956001)(58126008)(2501003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB4299;H:DB7PR05MB4201.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HUEfj/LNmWF0rdp+R5uqLYwKVJRwiJqmd0QKlVG1fDshT6kbvNN5dY5FndoBWJxvWyBDmBlB+GV2vaao7edbsBohIjnUQ62aTcQwiS76STsa8wyXKXvr9O8kRhpEwO6hdYXS5qFIrHzEWH3WMXJ1mbjuIMu3OhNk423vKtTvlWis88z8N65sP79dRjV67plRliN0tHKGTN/uT0GX/kALysnb254csVKjXBbys8unuU/3io9ybqInNyWaGHX3uE7sz6DbZ9Texmg3paYFMZqdUvb/HrlhjcSV9G1WoWBDIEzhrHkVqrq5DFdoQdWb/vMq2Ki09wYb8sFnYpBQyxo4ZNok1zPIS3KfGlwZ2kTAiiyAsceXHoRBW1VF+rwIejPK/85TCjfCqxIUByat1z15rrbARuVlt7tadn+SOtHpQgs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CA986012AEF8945A8A1FF56D77E9F79@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8198417-2bc2-426b-1ead-08d716750ca4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 11:40:27.6990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: roid@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4299
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMTktMDgtMDEgMTE6NDAgQU0sIHhpYW5neGlhLm0ueXVlQGdtYWlsLmNvbSB3cm90
ZToNCj4gRnJvbTogVG9uZ2hhbyBaaGFuZyA8eGlhbmd4aWEubS55dWVAZ21haWwuY29tPg0KPiAN
Cj4gSW4gc29tZSBjYXNlLCB3ZSBkb24ndCB3YW50IHRvIGFsbG93IHNwZWNpZmljIHR1bm5lbCBw
YWNrZXRzDQo+IHRvIGhvc3QgdGhhdCBjYW4gYXZvaWQgdG8gdGFrZSB1cCBoaWdoIENQVSAoZS5n
IG5ldHdvcmsgYXR0YWNrcykuDQo+IEJ1dCBvdGhlciB0dW5uZWwgcGFja2V0cyB3aGljaCBub3Qg
bWF0Y2hlZCBpbiBoYXJkd2FyZSB3aWxsIGJlDQo+IHNlbnQgdG8gaG9zdCB0b28uDQo+IA0KPiAg
ICAgJCB0YyBmaWx0ZXIgYWRkIGRldiB2eGxhbl9zeXNfNDc4OSBcDQo+IAkgICAgcHJvdG9jb2wg
aXAgY2hhaW4gMCBwYXJlbnQgZmZmZjogcHJpbyAxIGhhbmRsZSAxIFwNCj4gCSAgICBmbG93ZXIg
ZHN0X2lwIDEuMS4xLjEwMCBpcF9wcm90byB0Y3AgZHN0X3BvcnQgODAgXA0KPiAJICAgIGVuY19k
c3RfaXAgMi4yLjIuMTAwIGVuY19rZXlfaWQgMTAwIGVuY19kc3RfcG9ydCA0Nzg5IFwNCj4gCSAg
ICBhY3Rpb24gdHVubmVsX2tleSB1bnNldCBwaXBlIGFjdGlvbiBkcm9wDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBUb25naGFvIFpoYW5nIDx4aWFuZ3hpYS5tLnl1ZUBnbWFpbC5jb20+DQo+IC0tLQ0K
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMgfCAzICsr
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl90Yy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMN
Cj4gaW5kZXggZjNlZDAyOC4uMjVkNDIzZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCj4gQEAgLTI0ODUsNyArMjQ4NSw4IEBA
IHN0YXRpYyBib29sIGFjdGlvbnNfbWF0Y2hfc3VwcG9ydGVkKHN0cnVjdCBtbHg1ZV9wcml2ICpw
cml2LA0KPiAgDQo+ICAJaWYgKGZsb3dfZmxhZ190ZXN0KGZsb3csIEVHUkVTUykgJiYNCj4gIAkg
ICAgISgoYWN0aW9ucyAmIE1MWDVfRkxPV19DT05URVhUX0FDVElPTl9ERUNBUCkgfHwNCj4gLQkg
ICAgICAoYWN0aW9ucyAmIE1MWDVfRkxPV19DT05URVhUX0FDVElPTl9WTEFOX1BPUCkpKQ0KPiAr
CSAgICAgIChhY3Rpb25zICYgTUxYNV9GTE9XX0NPTlRFWFRfQUNUSU9OX1ZMQU5fUE9QKSB8fA0K
PiArCSAgICAgIChhY3Rpb25zICYgTUxYNV9GTE9XX0NPTlRFWFRfQUNUSU9OX0RST1ApKSkNCj4g
IAkJcmV0dXJuIGZhbHNlOw0KPiAgDQo+ICAJaWYgKGFjdGlvbnMgJiBNTFg1X0ZMT1dfQ09OVEVY
VF9BQ1RJT05fTU9EX0hEUikNCj4gDQoNCnRoYW5rcyENCg0KUmV2aWV3ZWQtYnk6IFJvaSBEYXlh
biA8cm9pZEBtZWxsYW5veC5jb20+DQo=
