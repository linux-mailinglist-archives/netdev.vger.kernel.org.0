Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C972A6A28
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731339AbgKDQp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:45:28 -0500
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:56806
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731256AbgKDQpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 11:45:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMYazNjQWaploefBVky414+vC9QKGfXLY2/RIOpcOU5S+3EesX9E5iOVBo+RexgyQlmKz9eYJln5YBhy4BiYjVPXrPuKxQoxfESynQr/2L/KLco5+zlyrYuvnIhzR9ZgJIokrwY6lpLqj6qPfkoObswQ7mFJX1uwDqJkRnL4FqxtlixHIkI8c20XijzqDB5aVG1DzSpCGSR9Erkt9qLi1AqXWYjjIjjHZCNeUmCfDRBulafn7mI2gwaZDsb5XPR9WP5Tml+o3i1UQxxv83URtnJmb6IlJBuJDJnVFH1xbTWuiL1oyj8wFqvC7JOkBO030wpKAhXDzSck0rOZ62lnVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Zc0XvZEnMFpXiu7AwQmQhSUw4Tm4wPAKE0nQbdywuE=;
 b=bWg2C0RkJrdgpFUb70/dJTKIQOllC0+kzc/P4z9BIEnlz9lfMV3O9kDEzqnFPs1Z28RsWeR6JyCiytrJBRd2OLD4zIQHd0yNJW8QT8b0Wtg7lFu4GfQL/M9bLksSM6GsciJeYsOKtEsZJ+9+7bi7GllMCYmA3PFXpBW8zz/5zGSrJ8MGIlub0/ywQhFCWa88bXwnbJ1D0YHfrOVtkfjzDX/3nbDEnqYhlQOaXlSd8adjpXmtJTj8kebQKb/D2/wpJ/eA2APq8JPj+jRoc+B/0IbRvwhQvGoA4IhZ7QlTBIEKEMLrDzD00ao1TBeMpvxzvIEHlNJUch45WQyBkTpeTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Zc0XvZEnMFpXiu7AwQmQhSUw4Tm4wPAKE0nQbdywuE=;
 b=PF19xEboftVn3q6QaYW5WqjFsDnXgevKHc/PYfs4Sc3FG5/0BUzzOpHN58tE0dkehVz42KEtsokjO1l8+xu3BaabI5cOGIEitW/AcBrsmgHNv28sdiyCBYZd6rTYPheyC/pceadK6GnWI7B1InGwEb+RSTFS580lLJh3dNU56PI=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM8PR04MB7409.eurprd04.prod.outlook.com (2603:10a6:20b:1c5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Wed, 4 Nov
 2020 16:45:02 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 16:45:02 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: RE: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Thread-Topic: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Thread-Index: AQHWrcsPyv6BypdD30yr6oyPLeI0Tqm2nOaAgAAE5QCAAAsikIAABW6AgAAC01CAAAJ7AIAAB6eAgAF0BuA=
Date:   Wed, 4 Nov 2020 16:45:02 +0000
Message-ID: <AM0PR04MB6754884EDFBB94EB16545A1596EF0@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
 <20201103161319.wisvmjbdqhju6vyh@skbuf>
 <20201103083050.100b2568@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <AM0PR04MB6754C8F6D12318EF1DD0CA2B96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201103173007.23ttgm3rpmbletee@skbuf>
 <AM0PR04MB6754E51184163B357DAACDFB96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201103174906.ttncbiqvlvfjibyl@skbuf>
 <19c3385d-7974-b5bd-3d5a-51d3d87919b0@gmail.com>
In-Reply-To: <19c3385d-7974-b5bd-3d5a-51d3d87919b0@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.27.120.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d2dd8790-8bd4-4c6b-c4a4-08d880e0f9e2
x-ms-traffictypediagnostic: AM8PR04MB7409:
x-microsoft-antispam-prvs: <AM8PR04MB74099C22E21222E7F7D5F96396EF0@AM8PR04MB7409.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: odTGkntcnRHpdyP0jXNhP/XC5iti37TOo0oiCi76VVGri51RWcd2NLgB606rsUYiLpyBgivkCNAPdisIqEEvQtzCokhoUYOaO2mCTax9vhk5C+lzFthk3U7lNr0bYqWMqTRqAPD8OCBvK8f2bxo1G+kvDAY7PbVRKOYKoSdpGnZt4ajeXsRNABGGEYSQotpC2o3u8Xp1j20gtVHJWe/XQzkPTOiDvTfU3eJcIIJRL7jt883CngjtHV+iiYBAB6rufQeOsBMyhHK04jHRCClQiNZXJuXsmn62bsxz7lDtcRmVuEpYA3oh6sHKYiV3mcxZYfA63o0gscFnQo/hPFXKsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(83380400001)(8676002)(8936002)(54906003)(110136005)(6506007)(316002)(7696005)(26005)(44832011)(86362001)(33656002)(9686003)(2906002)(66476007)(66556008)(55016002)(186003)(66446008)(5660300002)(66946007)(52536014)(71200400001)(64756008)(4326008)(478600001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ekT2xjM250CU/KHzCMlrv31UQSVQCBEI+MSQtzFgPWuLPLx6BzsiqyjA5khGKSknDu2r1DCduNH4L3gk1HLuY9PI7MP5eTqmaIdADUZQDobJRJKrN3iHkwhjtHPv6V+YZf1GR1INxqRG7071Xut8JOmqLmalnkYi70g+YgRB612MrcqN9hS5Jt6NoCEflDdfnvtjnez6PLo6MSS68Kvyjol8NmDP4iJHnrsMw0LtdlGEABaAUXjbxqVNgOFRWXk7O++tIV2p46WA4gFPXtiwLvuOsqR7W3RnchwRl/aRpmiudd+4GSD6336UgZJbM9gOHz1ZRH8qdUGJUfgdTFMaPjd40PKJcIBhvz3MhCzv3sFOq8Amhzi1JQ8NcGbKFtlOtQRSdrezf3ExzbCJ/hEFtZ9LlVVoe9KzrmepBjx+8xauYBP13zdK9hZD9CXJmW6SOEgnFgz6R4IYfPY+nLfjpYrASM5LojwHDGsDKqpqjjqMkm0yo6vyn0rkyi5JKSPus+X3w9drramoEMl49wuUEFsk1OlPgEZlIHTjPKQ2aVJUPAZrKP7aV8Yq1FSlGYM26xEoWAThFaCBKWVF/ktd5AKplTzxJMHqVF6q6knyinHiz7bB6bZPn1t1zqVYxqJIdwf0v16iy526GOzRBzqrPA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2dd8790-8bd4-4c6b-c4a4-08d880e0f9e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 16:45:02.5333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IkeEkJHA0GX6LZt84PUp4bVexGFNaCCXQmJf8s6R/2sPxpIpW9LO73ORErF6D7+0fmndmXVHvhoDokIGmVeDWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7409
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IEVyaWMgRHVtYXpldCA8ZXJp
Yy5kdW1hemV0QGdtYWlsLmNvbT4NCj5TZW50OiBUdWVzZGF5LCBOb3ZlbWJlciAzLCAyMDIwIDg6
MTYgUE0NCj5UbzogVmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT47IENsYXVkaXUg
TWFub2lsDQo+PGNsYXVkaXUubWFub2lsQG54cC5jb20+DQo+Q2M6IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBEYXZpZCBTIC4NCj5NaWxs
ZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBqYW1lcy5qdXJhY2tAYW1ldGVrLmNvbQ0KPlN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggbmV0IHYyIDEvMl0gZ2lhbmZhcjogUmVwbGFjZSBza2JfcmVhbGxvY19o
ZWFkcm9vbSB3aXRoDQo+c2tiX2Nvd19oZWFkIGZvciBQVFANCj4NCj4NCj4NCj5PbiAxMS8zLzIw
IDY6NDkgUE0sIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4+IE9uIFR1ZSwgTm92IDAzLCAyMDIw
IGF0IDA1OjQxOjM2UE0gKzAwMDAsIENsYXVkaXUgTWFub2lsIHdyb3RlOg0KPj4+IFRoaXMgaXMg
dGhlIHBhdGNoOg0KPj4+DQpbLi4uXQ0KPj4+DQo+Pj4gYXJlIHlvdSBzdXJlIHlvdSBoYXZlIGl0
IGFwcGxpZWQ/DQo+Pg0KPj4gQWN0dWFsbHk/IE5vLCBJIGRpZG4ndCBoYXZlIGl0IGFwcGxpZWQu
Li4gSSBoYWQgdGhvdWdodCB0aGF0IG5ldCBoYWQNCj4+IGJlZW4gYWxyZWFkeSBtZXJnZWQgaW50
byBuZXQtbmV4dCwgZm9yIHNvbWUgcmVhc29uIDotLw0KPj4gTGV0IG1lIHJ1biB0aGUgdGVzdCBm
b3IgYSBmZXcgbW9yZSB0ZW5zIG9mIG1pbnV0ZXMgd2l0aCB0aGUgcGF0Y2gNCj4+IGFwcGxpZWQu
DQo+Pg0KPg0KPkkgZmluZCBzdHJhbmdlIHRoYXQgdGhlIGxvY2FsIFRDUCB0cmFmZmljIGNhbiBl
bmQgdXAgY2FsbGluZw0KPnNrYl9yZWFsbG9jX2hlYWRyb21tKCkgaW4gdGhlIG9sZCBrZXJuZWxz
Lg0KPg0KPk5vcm1hbGx5IFRDUCByZXNlcnZlcyBhIGxvdCBvZiBieXRlcyBmb3IgaGVhZGVycy4N
Cj4NCj4jZGVmaW5lIE1BWF9UQ1BfSEVBREVSICAgICBMMV9DQUNIRV9BTElHTigxMjggKyBNQVhf
SEVBREVSKQ0KPg0KPkl0IHNob3VsZCBhY2NvbW1vZGF0ZSB0aGUgZ2lhbmZhciBuZWVkcyBmb3Ig
YWRkaXRpb25hbCAyNCBieXRlcywNCj5ldmVuIGlmIExMX01BWF9IRUFERVIgaXMgMzIgaW4geW91
ciBrZXJuZWwgYnVpbGQgcGVyaGFwcy4NCj4NCg0KSGksDQpUaGUgUFRQIHBhY2tldHMgbmVlZCBl
eHRyYSBoZWFkcm9vbSBhbmQgZ2V0IHJlYWxsb2NhdGVkLCBub3QgVENQIHBhY2tldHMuDQpIb3dl
dmVyIGlmIFRDUCBzdHJlYW1zIGFyZSBzZW50IGNvbmN1cnJlbnRseSB3aXRoIFBUUCBwYWNrZXRz
LCBhbmQNCnNrYl9yZWFsbG9jX2hlYWRyb29tKCkgaXMgdXNlZCB0byByZWFsbG9jYXRlIFBUUCBw
YWNrZXRzLCB3ZSBnZXQgdGhlc2UgY3Jhc2hlcy4NCklmIHNrYl9jb3dfaGVhZCgpIGlzIHVzZWQg
aW5zdGVhZCB0aGVyZSdzIG5vIGNyYXNoLg0KDQoNCg==
