Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA20141E9E
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 15:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgASOxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 09:53:00 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:17729
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbgASOw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 09:52:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUu6M1wxyRmsmZeKdfO6knoG0DSA838ORZdONUFfAyRSHtxNusoIRwzgxgNYfc83DrEq+BC5u7k+61E7g4FIXqUNIFHNV/vE9oVykpxDv+d5u+z9w0SI3dSMmYR7YrBduRMBuhQPSaLNMaOi8Ogb4JBRBuyVNRpCgsBiVWRTCLYAFq882v5dsnYw/wClxhmfJ5H8h/IPPSI6iOENPw+VcB4onM9mb4WfXCwMD9WlItIbioZhFdjQzSK9Hzzm8uK0jbfy3G9Gc5saYG1MAJWSR60twqPfjdhjzJqsk2NFwbfG98u5kxBBb6K8OGtbvk7SICZhK+jLPKeSrOwFetUihg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9iZpr++TcPLIvXGnYVzgy69ofytznx0SQbUTmNzxOs=;
 b=OmcV4NnCBjJgZAUm5Z+oEh9r19hLnZQCr1R1DoFVMwfS8MybpUacHV6D60o0qgjzZ6Uy+MoRqk/zLm71IGiJZgawCrJq8DVPOk+EpLuVhH1JNyeH0sQ8MoaYEqyGVu8knMydy6rMEFVbHrdXX6xqQopBLc++16kRW0bcOvx9FKJBZrDnBcos/BcanHwgQ5V2mX6TzgMQruYnMaZicp2unxMLE+Ix93sUSIdMJJFwY0jNnwkgNmr3VWzKusPS6H1BxKG6BznYY12Bb7lJSEeqnb966wJxWO5SbAIIAygPf7ZXsMWUp830PgIWgjfuhY6pgWwCe2mrwXx1FR22YAe7PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9iZpr++TcPLIvXGnYVzgy69ofytznx0SQbUTmNzxOs=;
 b=Jun0QGC6Z1KvMTPLRQ4FH/udEhDfRwfI/DaOXNrazdtYLXRzMDPQomn5J2ZYCu6QDsdrHvX5dU7D1k9PygJVTEzFKuPX+i1aTYCkr6UZHquCLOv1k3k5eVCwJYO7A416o8a63/EaujIP0dukaYHjmH6XOxr+AKPJZJ/aeRT/bA4=
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (20.178.117.153) by
 AM0PR05MB6225.eurprd05.prod.outlook.com (20.178.114.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Sun, 19 Jan 2020 14:52:54 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192%4]) with mapi id 15.20.2644.024; Sun, 19 Jan 2020
 14:52:53 +0000
Received: from [10.80.3.21] (193.47.165.251) by FR2P281CA0012.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Sun, 19 Jan 2020 14:52:52 +0000
From:   Maor Gottlieb <maorg@mellanox.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     Andy Gospodarek <andy@greyhouse.net>,
        Jiri Pirko <jiri@resnulli.us>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: Expose bond_xmit_hash function
Thread-Topic: Expose bond_xmit_hash function
Thread-Index: AQHVy3oG0EtUwers0UGLm6hc+vG4CqfregOAgABZSAD///JCgIABmfkAgAAUW4CAAAFqgIAEo/2A
Date:   Sun, 19 Jan 2020 14:52:53 +0000
Message-ID: <2b2d0e14-59c7-5efa-93a8-8027f4ed43e5@mellanox.com>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
 <20200115094513.GS2131@nanopsycho>
 <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com>
 <20200115141535.GT2131@nanopsycho> <20200116144256.GA87583@C02YVCJELVCG>
 <8e90935b-7485-0969-6fe4-d802d259f778@mellanox.com> <31666.1579190451@famine>
In-Reply-To: <31666.1579190451@famine>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-clientproxiedby: FR2P281CA0012.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::22) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maorg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7d3a507c-d04c-4d5b-d657-08d79cef431a
x-ms-traffictypediagnostic: AM0PR05MB6225:|AM0PR05MB6225:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB62255F1CE958701DB4CBB4A3D3330@AM0PR05MB6225.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0287BBA78D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(199004)(189003)(31696002)(316002)(54906003)(52116002)(16576012)(7116003)(8676002)(86362001)(6916009)(956004)(6486002)(2616005)(478600001)(107886003)(186003)(16526019)(81156014)(81166006)(8936002)(36756003)(26005)(53546011)(4326008)(71200400001)(66946007)(66556008)(5660300002)(66446008)(64756008)(66476007)(31686004)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6225;H:AM0PR05MB5873.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WtwnOzrxBreZoIaWU4bFcZPFpU6u/9cseis8ark72UeCilBvlsKDIT3ZVhTEInlki4f1+2gCM3Ywm/wYGGAM3PHqyT0RNGUzkWAXsniJmYQI/oBFF775P1Dq5Ap34Gf82My7Q45CaC3hczAUaVijjH9V0tYK7z9uS2kGvMLd2MB1Ei8fYpB9rGaPUMZzgh2u3x1mIum2juZ/n5V4bikGVNn0QC8OBqtm+FL6PJh3eklJkHpWGTjt64BYAIGgZQUTgaektEHRAC0529Yc2X+nGku2gmz06TQ2pg1fwlvxggjkJnTYvzOLAhbk8lWhDGqIIE5348TFU/GY14OtoSpN4j7SUTabIXA+sB/DvXI78GFOlZAqAoCQ1tgIW9DmZ9X8yn6zVLqBzpwkfM2H6ppk1XQaffjFKe/gyDm01JWGnLqzlYh1mEKtjw4e4kNSm9U7
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A053CCA23B5554A9BC92AEDC1FEF855@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3a507c-d04c-4d5b-d657-08d79cef431a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2020 14:52:53.5862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /TZsN4zHIJZ3WmxvtdMmB8vOu5ou9X+WsunGQEHJIBjRBrOpIDvvgpewZJ6CD6PkHozj5BgXIPV8kula4Ooruw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzE2LzIwMjAgNjowMCBQTSwgSmF5IFZvc2J1cmdoIHdyb3RlOg0KPiBNYW9yIEdvdHRs
aWViIDxtYW9yZ0BtZWxsYW5veC5jb20+IHdyb3RlOg0KPg0KPj4gT24gMS8xNi8yMDIwIDQ6NDIg
UE0sIEFuZHkgR29zcG9kYXJlayB3cm90ZToNCj4+PiBPbiBXZWQsIEphbiAxNSwgMjAyMCBhdCAw
MzoxNTozNVBNICswMTAwLCBKaXJpIFBpcmtvIHdyb3RlOg0KPj4+PiBXZWQsIEphbiAxNSwgMjAy
MCBhdCAwMjowNDo0OVBNIENFVCwgbWFvcmdAbWVsbGFub3guY29tIHdyb3RlOg0KPj4+Pj4gT24g
MS8xNS8yMDIwIDExOjQ1IEFNLCBKaXJpIFBpcmtvIHdyb3RlOg0KPj4+Pj4+IFdlZCwgSmFuIDE1
LCAyMDIwIGF0IDA5OjAxOjQzQU0gQ0VULCBtYW9yZ0BtZWxsYW5veC5jb20gd3JvdGU6DQo+Pj4+
Pj4+IFJETUEgb3ZlciBDb252ZXJnZWQgRXRoZXJuZXQgKFJvQ0UpIGlzIGEgc3RhbmRhcmQgcHJv
dG9jb2wgd2hpY2ggZW5hYmxlcw0KPj4+Pj4+PiBSRE1B4oCZcyBlZmZpY2llbnQgZGF0YSB0cmFu
c2ZlciBvdmVyIEV0aGVybmV0IG5ldHdvcmtzIGFsbG93aW5nIHRyYW5zcG9ydA0KPj4+Pj4+PiBv
ZmZsb2FkIHdpdGggaGFyZHdhcmUgUkRNQSBlbmdpbmUgaW1wbGVtZW50YXRpb24uDQo+Pj4+Pj4+
IFRoZSBSb0NFIHYyIHByb3RvY29sIGV4aXN0cyBvbiB0b3Agb2YgZWl0aGVyIHRoZSBVRFAvSVB2
NCBvciB0aGUNCj4+Pj4+Pj4gVURQL0lQdjYgcHJvdG9jb2w6DQo+Pj4+Pj4+DQo+Pj4+Pj4+IC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tDQo+Pj4+Pj4+IHwgTDIgfCBMMyB8IFVEUCB8SUIgQlRIIHwgUGF5bG9hZHwgSUNSQyB8IEZD
UyB8DQo+Pj4+Pj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tDQo+Pj4+Pj4+DQo+Pj4+Pj4+IFdoZW4gYSBib25kIExBRyBuZXRk
ZXYgaXMgaW4gdXNlLCB3ZSB3b3VsZCBsaWtlIHRvIGhhdmUgdGhlIHNhbWUgaGFzaA0KPj4+Pj4+
PiByZXN1bHQgZm9yIFJvQ0UgcGFja2V0cyBhcyBhbnkgb3RoZXIgVURQIHBhY2tldHMsIGZvciB0
aGlzIHB1cnBvc2Ugd2UNCj4+Pj4+Pj4gbmVlZCB0byBleHBvc2UgdGhlIGJvbmRfeG1pdF9oYXNo
IGZ1bmN0aW9uIHRvIGV4dGVybmFsIG1vZHVsZXMuDQo+Pj4+Pj4+IElmIG5vIG9iamVjdGlvbiwg
SSB3aWxsIHB1c2ggYSBwYXRjaCB0aGF0IGV4cG9ydCB0aGlzIHN5bWJvbC4NCj4+Pj4+PiBJIGRv
bid0IHRoaW5rIGl0IGlzIGdvb2QgaWRlYSB0byBkbyBpdC4gSXQgaXMgYW4gaW50ZXJuYWwgYm9u
ZCBmdW5jdGlvbi4NCj4+Pj4+PiBpdCBldmVuIGFjY2VwdHMgInN0cnVjdCBib25kaW5nICpib25k
Ii4gRG8geW91IHBsYW4gdG8gcHVzaCBuZXRkZXYNCj4+Pj4+PiBzdHJ1Y3QgYXMgYW4gYXJnIGlu
c3RlYWQ/IFdoYXQgYWJvdXQgdGVhbT8gV2hhdCBhYm91dCBPVlMgYm9uZGluZz8NCj4+Pj4+IE5v
LCBJIGFtIHBsYW5uaW5nIHRvIHBhc3MgdGhlIGJvbmQgc3RydWN0IGFzIGFuIGFyZy4gQ3VycmVu
dGx5LCB0ZWFtDQo+Pj4+IEhtbSwgdGhhdCB3b3VsZCBiZSBvZmNvdXJzZSB3cm9uZywgYXMgaXQg
aXMgaW50ZXJuYWwgYm9uZGluZyBkcml2ZXINCj4+Pj4gc3RydWN0dXJlLg0KPj4+Pg0KPj4+Pg0K
Pj4+Pj4gYm9uZGluZyBpcyBub3Qgc3VwcG9ydGVkIGluIFJvQ0UgTEFHIGFuZCBJIGRvbid0IHNl
ZSBob3cgT1ZTIGlzIHJlbGF0ZWQuDQo+Pj4+IFNob3VsZCB3b3JrIGZvciBhbGwuIE9WUyBpcyBy
ZWxhdGVkIGluIGEgc2Vuc2UgdGhhdCB5b3UgY2FuIGRvIGJvbmRpbmcNCj4+Pj4gdGhlcmUgdG9v
Lg0KPj4+Pg0KPj4+Pg0KPj4+Pj4+IEFsc28sIHlvdSBkb24ndCByZWFsbHkgbmVlZCBhIGhhc2gs
IHlvdSBuZWVkIGEgc2xhdmUgdGhhdCBpcyBnb2luZyB0byBiZQ0KPj4+Pj4+IHVzZWQgZm9yIGEg
cGFja2V0IHhtaXQuDQo+Pj4+Pj4NCj4+Pj4+PiBJIHRoaW5rIHRoaXMgY291bGQgd29yayBpbiBh
IGdlbmVyaWMgd2F5Og0KPj4+Pj4+DQo+Pj4+Pj4gc3RydWN0IG5ldF9kZXZpY2UgKm1hc3Rlcl94
bWl0X3NsYXZlX2dldChzdHJ1Y3QgbmV0X2RldmljZSAqbWFzdGVyX2RldiwNCj4+Pj4+PiAJCQkJ
CSBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsNCj4+Pj4+IFRoZSBzdWdnZXN0aW9uIGlzIHRvIHB1dCB0
aGlzIGZ1bmN0aW9uIGluIHRoZSBib25kIGRyaXZlciBhbmQgY2FsbCBpdA0KPj4+Pj4gaW5zdGVh
ZCBvZiBib25kX3htaXRfaGFzaD8gaXMgaXQgc3RpbGwgbmVjZXNzYXJ5IGlmIEkgaGF2ZSB0aGUg
Ym9uZCBwb2ludGVyPw0KPj4+PiBOby4gVGhpcyBzaG91bGQgYmUgaW4gYSBnZW5lcmljIGNvZGUu
IE5vIGRpcmVjdCBjYWxscyBkb3duIHRvIGJvbmRpbmcNCj4+Pj4gZHJpdmVyIHBsZWFzZS4gT3Ig
ZG8geW91IHdhbnQgdG8gbG9hZCBib25kaW5nIG1vZHVsZSBldmVyeSB0aW1lIHlvdXINCj4+Pj4g
bW9kdWxlIGxvYWRzPw0KPj4+Pg0KPj4+PiBJIHRoaW5rcyB0aGlzIGNhbiBiZSBpbXBsZW1lbnRl
ZCB3aXRoIG5kbyB3aXRoICJtYXN0ZXJfeG1pdF9zbGF2ZV9nZXQoKSINCj4+Pj4gYXMgYSB3cmFw
cGVyLiBNYXN0ZXJzIHRoYXQgc3VwcG9ydCB0aGlzIHdvdWxkIGp1c3QgaW1wbGVtZW50IHRoZSBu
ZG8uDQo+Pj4gSW4gZ2VuZXJhbCBJIHRoaW5rIHRoaXMgaXMgYSBnb29kIGlkZWEgKHRob3VnaCBt
YXliZSBub3Qgd2l0aCBhbiBza2IgYXMNCj4+PiBhbiBhcmcgc28gd2UgY2FuIHVzZSBpdCBlYXNp
bHkgd2l0aGluIEJQRiksIGJ1dCBJJ20gbm90IHN1cmUgaWYgc29sdmVzDQo+Pj4gdGhlIHByb2Js
ZW0gdGhhdCBNYW9yIGV0IGFsIHdlcmUgc2V0dGluZyBvdXQgdG8gc29sdmUuDQo+Pj4NCj4+PiBN
YW9yLCBpZiB5b3UgZGlkIGV4cG9ydCBib25kX3htaXRfaGFzaCgpIHRvIGJlIHVzZWQgYnkgYW5v
dGhlciBkcml2ZXIsDQo+Pj4geW91IHdvdWxkIHByZXN1bWFibHkgaGF2ZSBhIGNoZWNrIGluIHBs
YWNlIHNvIGlmIHRoZSBSb0NFIGFuZCBVRFANCj4+PiBwYWNrZXRzIGhhZCBhIGRpZmZlcmVudCBo
YXNoIGZ1bmN0aW9uIG91dHB1dCB5b3Ugd291bGQgbWFrZSBhIGNoYW5nZSBhbmQNCj4+PiBiZSBz
dXJlIHRoYXQgdGhlIFVEUCBmcmFtZXMgd291bGQgZ28gb3V0IG9uIHRoZSBzYW1lIGRldmljZSB0
aGF0IHRoZQ0KPj4+IFJvQ0UgdHJhZmZpYyB3b3VsZCBub3JtYWxseSB1c2UuICBJcyB0aGlzIGNv
cnJlY3Q/ICBXb3VsZCB5b3UgYWxzbyBzZW5kDQo+Pj4gdGhlIGZyYW1lcyBkaXJlY3RseSBvbiB0
aGUgaW50ZXJmYWNlIHVzaW5nIGRldl9xdWV1ZV94bWl0KCkgYW5kIGJ5cGFzcw0KPj4+IHRoZSBi
b25kaW5nIGRyaXZlciBjb21wbGV0ZWx5Pw0KPj4gUm9DRSBwYWNrZXRzIGFyZSBVRFAuIFRoZSBp
ZGVhIGlzIHRoYXQgdGhlIHNhbWUgVURQIGhlYWRlciAoUm9DRSBhcw0KPj4gd2VsbCkgd2lsbCBn
ZXQgdGhlIHNhbWUgaGFzaCByZXN1bHQgc28gdGhleSB3aWxsIGJlIHRyYW5zbWl0dGVkIGZyb20g
dGhlDQo+PiBzYW1lIHBvcnQuDQo+PiBUaGUgZnJhbWVzIHdpbGwgYmUgc2VudCBieSB1c2luZyB0
aGUgUkRNQSBzZW5kIEFQSSBhbmQgYnlwYXNzIHRoZQ0KPj4gYm9uZGluZyBkcml2ZXIgY29tcGxl
dGVseS4NCj4+IElzIGl0IGFuc3dlciB5b3VyIHF1ZXN0aW9uPw0KPiAJSWYgdGhlIFJETUEgc2Vu
ZCBieXBhc3NlcyBib25kaW5nLCBob3cgd2lsbCB5b3UgaW5zdXJlIHRoYXQgdGhlDQo+IHNhbWUg
aGFzaCByZXN1bHQgbWFwcyB0byB0aGUgc2FtZSB1bmRlcmx5aW5nIGludGVyZmFjZSBmb3IgYm90
aCBib25kaW5nDQo+IGFuZCBSRE1BPw0KPg0KPiAJLUoNCg0KSW4gUm9DRSwgdGhlIGFmZmluaXR5
IGlzIGRldGVybWluZWQgd2hpbGUgdGhlIEhXIHJlc291cmNlcyBhcmUgY3JlYXRlZCANCmFuZCB3
aWxsIGJlIG1vZGlmaWVkIGdsb2JhbGx5IGluIHJ1biB0aW1lIHRvIHRyYWNrIHRoZSBhY3RpdmUg
c2FsdmVzLg0KSWYgd2UgZ2V0IHRoZSBzbGF2ZSByZXN1bHQsIGFsbCB0aGUgVURQIHBhY2tldHMg
d2lsbCBoYXZlIHRoZSBzYW1lIA0KYWZmaW5pdHkgYXMgUm9DRS4NClRoZSBkb3duc2lkZSBpcyB0
aGF0IGFsbCBSb0NFIEhXIHJlc291cmNlcyB3aWxsIGJlIHN0dWNrIHdpdGggdGhlIA0Kb3JpZ2lu
YWwgYWZmaW5pdHkgcG9ydCBhbmQgbm90IG1vdmUgdG8gdGhlIHJlLWFjdGl2YXRlIHNsYXZlIG9u
Y2UgaXQgDQpnb2VzIHVwLiBBbm90aGVyIGRpc2FkdmFudGFnZSwgd2hlbiBib3RoIHBvcnRzIGFy
ZSBkb3duLCB3ZSBzdGlsbCBuZWVkIA0KdG8gY3JlYXRlIHRoZSBSb0NFIEhXIHJlc291cmNlcyB3
aXRoIGEgZ2l2ZW4gcG9ydCBhZmZpbml0eS4gQm90aCANCnByb2JsZW1zIGFyZSBzb2x2ZWQgYnkg
ZXhwb3J0aW5nIHRoZSBoYXNoLg0KDQo+DQo+Pj4gSSBkb24ndCB0aGluayBJIGZ1bmRhbWVudGFs
bHkgaGF2ZSBhIHByb2JsZW0gd2l0aCB0aGlzLCBJIGp1c3Qgd2FudCB0bw0KPj4+IG1ha2Ugc3Vy
ZSBJIHVuZGVyc3RhbmQgeW91ciBwcm9wb3NlZCBjb2RlLWZsb3cuDQo+Pj4NCj4+PiBUaGFua3Mh
DQo+Pj4NCj4gLS0tDQo+IAktSmF5IFZvc2J1cmdoLCBqYXkudm9zYnVyZ2hAY2Fub25pY2FsLmNv
bQ0K
