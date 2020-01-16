Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B2213DF4F
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 16:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgAPPzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 10:55:55 -0500
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:26624
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726406AbgAPPzy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 10:55:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8UuYIUrCINDT5mPr3Q39IXW5Za4zUkjKdLuFtTFSmVWJv1JZ+6M5rmD6uDEZyLnN1dUhs2mo8UyL/NyGJ3LqAl3I2YzaDiiiBrP6iMmSxragA5hGiaUE+BDInaC1ctgbG/DFmXqZ9rfqwJq2DN4DIU6ZLhNfpTwB2HVNi0E5xGtKi9w5adHfz5b/UjAq50zBR5F1VpGo6lDqpku37eQJlxCzNkYoRTu7OGjKWXDNJyLDI6Ev539gaH20k2YSNGfx20SpHn7BLXpSeWWiuLWeQOUkg4Lc3X4uz5/WDjHlgERfJri1w2Tc2psCJ4SZrFENaCl5zMGrgllBKeeowYhRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdUyCqPEIOst8dCQzLfD9dYfZLinTdrERGYaURn6d7o=;
 b=heZ+BqbL23cWj7EVN7CpkuSI0NXhrM3uu1bBuqwNmXVJpcpsz2iOdgRmhKAeL6RU8TJg9FRtY/3TZ1kds/ILGvoFiEl4VrO94rIsCTNjlhPQ+toURCwdsb4rEA87EINtpcWfdWEXgdwSpMWUfNUxQJXxBpPQ2e+AEvyV0U3wKpEozMYxZJGH9c1T0wF+Oec5cLWbbRUxrnslPcsGSDatnum+1Iin/3/yBFpplCu+juK4qhYHjhj32wGmn3snhYF3n4yuEI+y2S1ArOkzWVi9SEWhfg4c2q3XdZ+fjYgP1qGXLFzl9RxBVz3g4e4AVl+DnSZAghjLlzkej3mxuRL27g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdUyCqPEIOst8dCQzLfD9dYfZLinTdrERGYaURn6d7o=;
 b=crjJ6mGwSpIAoSU8CYKK/BH0PttBWzf8LVXARgNVZW88oISxA9yAXBoTl2fxeWx2qdeLA1GITNinjeuMQqyQtoHGcN7dWubiTqZhS71YMsrsKuG4NVHdlA7MaHNYicDd7GzEFtc6DWcF/DfQRYqxeR4+6+Cdh82NAWlzGt/4GcA=
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (20.178.117.153) by
 AM0PR05MB4113.eurprd05.prod.outlook.com (52.134.125.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Thu, 16 Jan 2020 15:55:50 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192%4]) with mapi id 15.20.2644.015; Thu, 16 Jan 2020
 15:55:50 +0000
Received: from [10.80.3.21] (193.47.165.251) by AM4PR07CA0008.eurprd07.prod.outlook.com (2603:10a6:205:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.6 via Frontend Transport; Thu, 16 Jan 2020 15:55:48 +0000
From:   Maor Gottlieb <maorg@mellanox.com>
To:     Andy Gospodarek <andy@greyhouse.net>, Jiri Pirko <jiri@resnulli.us>
CC:     "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
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
Thread-Index: AQHVy3oG0EtUwers0UGLm6hc+vG4CqfregOAgABZSAD///JCgIABmfkAgAAUW4A=
Date:   Thu, 16 Jan 2020 15:55:50 +0000
Message-ID: <8e90935b-7485-0969-6fe4-d802d259f778@mellanox.com>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
 <20200115094513.GS2131@nanopsycho>
 <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com>
 <20200115141535.GT2131@nanopsycho> <20200116144256.GA87583@C02YVCJELVCG>
In-Reply-To: <20200116144256.GA87583@C02YVCJELVCG>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-clientproxiedby: AM4PR07CA0008.eurprd07.prod.outlook.com
 (2603:10a6:205:1::21) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maorg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 64042003-d9eb-4676-402c-08d79a9c8ef1
x-ms-traffictypediagnostic: AM0PR05MB4113:|AM0PR05MB4113:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB41136B60AE3B64D4AFC42E08D3360@AM0PR05MB4113.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(199004)(189003)(316002)(16576012)(8676002)(52116002)(66556008)(71200400001)(16526019)(31696002)(26005)(6666004)(81166006)(2616005)(81156014)(8936002)(5660300002)(186003)(956004)(2906002)(86362001)(478600001)(110136005)(107886003)(54906003)(31686004)(7116003)(66946007)(6486002)(64756008)(66476007)(66446008)(4326008)(36756003)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4113;H:AM0PR05MB5873.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BXPAhaR2fJw8eaYM7WK1grxFUAuj6JhCVdjSX/UdIe0Uupqsc7mwVVQohUrIdgdtXwmSf6ze1I+x6JPeS8ijxTZADOt7DNoWNQdsDcP3FqsrjgDT12pxz8JKkEoZc0uSAOVWHjnONqYnTzgcLWCNhd3xtucE1M7JFyt2EQ6OQnfrr6dCHngfV2FOQ2PxffwmBEnyMpm7QgXApGMD3zSlVEssF8iYonpmI5NdC9D9W1PNwrcQ1zXJbEV73vrHMKaINLbnJCJ1sEJ7pmDrOPNXikqubENGF/UvwYx0PnA8SY/wOt9+9fywl1+qqELXw2bHnvdqnkvvgZ/HIVXXithyFYMxAt1DNmu1ePmB42mR0P1qga1Pt0JFSspL/fgnxssQA49Wrj7lrEhjVHumO/tvGpUgMOqJPIq7REKUXALRLJ8ccPm8fUFIGowNyQIh67RB
Content-Type: text/plain; charset="utf-8"
Content-ID: <712F4A9F56334B4496DEFC6D1680745B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64042003-d9eb-4676-402c-08d79a9c8ef1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 15:55:50.1594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nouLGtpYYK3JcgzKG/iqDOxXM+n7Z5icrwLFykiUljz/LeE9MmlS3J/ij1deJ0+u6Y9UtNmvIJUf0dZHHZvlpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzE2LzIwMjAgNDo0MiBQTSwgQW5keSBHb3Nwb2RhcmVrIHdyb3RlOg0KPiBPbiBXZWQs
IEphbiAxNSwgMjAyMCBhdCAwMzoxNTozNVBNICswMTAwLCBKaXJpIFBpcmtvIHdyb3RlOg0KPj4g
V2VkLCBKYW4gMTUsIDIwMjAgYXQgMDI6MDQ6NDlQTSBDRVQsIG1hb3JnQG1lbGxhbm94LmNvbSB3
cm90ZToNCj4+PiBPbiAxLzE1LzIwMjAgMTE6NDUgQU0sIEppcmkgUGlya28gd3JvdGU6DQo+Pj4+
IFdlZCwgSmFuIDE1LCAyMDIwIGF0IDA5OjAxOjQzQU0gQ0VULCBtYW9yZ0BtZWxsYW5veC5jb20g
d3JvdGU6DQo+Pj4+PiBSRE1BIG92ZXIgQ29udmVyZ2VkIEV0aGVybmV0IChSb0NFKSBpcyBhIHN0
YW5kYXJkIHByb3RvY29sIHdoaWNoIGVuYWJsZXMNCj4+Pj4+IFJETUHigJlzIGVmZmljaWVudCBk
YXRhIHRyYW5zZmVyIG92ZXIgRXRoZXJuZXQgbmV0d29ya3MgYWxsb3dpbmcgdHJhbnNwb3J0DQo+
Pj4+PiBvZmZsb2FkIHdpdGggaGFyZHdhcmUgUkRNQSBlbmdpbmUgaW1wbGVtZW50YXRpb24uDQo+
Pj4+PiBUaGUgUm9DRSB2MiBwcm90b2NvbCBleGlzdHMgb24gdG9wIG9mIGVpdGhlciB0aGUgVURQ
L0lQdjQgb3IgdGhlDQo+Pj4+PiBVRFAvSVB2NiBwcm90b2NvbDoNCj4+Pj4+DQo+Pj4+PiAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQ0KPj4+Pj4gfCBMMiB8IEwzIHwgVURQIHxJQiBCVEggfCBQYXlsb2FkfCBJQ1JDIHwgRkNTIHwN
Cj4+Pj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tDQo+Pj4+Pg0KPj4+Pj4gV2hlbiBhIGJvbmQgTEFHIG5ldGRldiBpcyBpbiB1
c2UsIHdlIHdvdWxkIGxpa2UgdG8gaGF2ZSB0aGUgc2FtZSBoYXNoDQo+Pj4+PiByZXN1bHQgZm9y
IFJvQ0UgcGFja2V0cyBhcyBhbnkgb3RoZXIgVURQIHBhY2tldHMsIGZvciB0aGlzIHB1cnBvc2Ug
d2UNCj4+Pj4+IG5lZWQgdG8gZXhwb3NlIHRoZSBib25kX3htaXRfaGFzaCBmdW5jdGlvbiB0byBl
eHRlcm5hbCBtb2R1bGVzLg0KPj4+Pj4gSWYgbm8gb2JqZWN0aW9uLCBJIHdpbGwgcHVzaCBhIHBh
dGNoIHRoYXQgZXhwb3J0IHRoaXMgc3ltYm9sLg0KPj4+PiBJIGRvbid0IHRoaW5rIGl0IGlzIGdv
b2QgaWRlYSB0byBkbyBpdC4gSXQgaXMgYW4gaW50ZXJuYWwgYm9uZCBmdW5jdGlvbi4NCj4+Pj4g
aXQgZXZlbiBhY2NlcHRzICJzdHJ1Y3QgYm9uZGluZyAqYm9uZCIuIERvIHlvdSBwbGFuIHRvIHB1
c2ggbmV0ZGV2DQo+Pj4+IHN0cnVjdCBhcyBhbiBhcmcgaW5zdGVhZD8gV2hhdCBhYm91dCB0ZWFt
PyBXaGF0IGFib3V0IE9WUyBib25kaW5nPw0KPj4+IE5vLCBJIGFtIHBsYW5uaW5nIHRvIHBhc3Mg
dGhlIGJvbmQgc3RydWN0IGFzIGFuIGFyZy4gQ3VycmVudGx5LCB0ZWFtDQo+PiBIbW0sIHRoYXQg
d291bGQgYmUgb2Zjb3Vyc2Ugd3JvbmcsIGFzIGl0IGlzIGludGVybmFsIGJvbmRpbmcgZHJpdmVy
DQo+PiBzdHJ1Y3R1cmUuDQo+Pg0KPj4NCj4+PiBib25kaW5nIGlzIG5vdCBzdXBwb3J0ZWQgaW4g
Um9DRSBMQUcgYW5kIEkgZG9uJ3Qgc2VlIGhvdyBPVlMgaXMgcmVsYXRlZC4NCj4+IFNob3VsZCB3
b3JrIGZvciBhbGwuIE9WUyBpcyByZWxhdGVkIGluIGEgc2Vuc2UgdGhhdCB5b3UgY2FuIGRvIGJv
bmRpbmcNCj4+IHRoZXJlIHRvby4NCj4+DQo+Pg0KPj4+PiBBbHNvLCB5b3UgZG9uJ3QgcmVhbGx5
IG5lZWQgYSBoYXNoLCB5b3UgbmVlZCBhIHNsYXZlIHRoYXQgaXMgZ29pbmcgdG8gYmUNCj4+Pj4g
dXNlZCBmb3IgYSBwYWNrZXQgeG1pdC4NCj4+Pj4NCj4+Pj4gSSB0aGluayB0aGlzIGNvdWxkIHdv
cmsgaW4gYSBnZW5lcmljIHdheToNCj4+Pj4NCj4+Pj4gc3RydWN0IG5ldF9kZXZpY2UgKm1hc3Rl
cl94bWl0X3NsYXZlX2dldChzdHJ1Y3QgbmV0X2RldmljZSAqbWFzdGVyX2RldiwNCj4+Pj4gCQkJ
CQkgc3RydWN0IHNrX2J1ZmYgKnNrYik7DQo+Pj4gVGhlIHN1Z2dlc3Rpb24gaXMgdG8gcHV0IHRo
aXMgZnVuY3Rpb24gaW4gdGhlIGJvbmQgZHJpdmVyIGFuZCBjYWxsIGl0DQo+Pj4gaW5zdGVhZCBv
ZiBib25kX3htaXRfaGFzaD8gaXMgaXQgc3RpbGwgbmVjZXNzYXJ5IGlmIEkgaGF2ZSB0aGUgYm9u
ZCBwb2ludGVyPw0KPj4gTm8uIFRoaXMgc2hvdWxkIGJlIGluIGEgZ2VuZXJpYyBjb2RlLiBObyBk
aXJlY3QgY2FsbHMgZG93biB0byBib25kaW5nDQo+PiBkcml2ZXIgcGxlYXNlLiBPciBkbyB5b3Ug
d2FudCB0byBsb2FkIGJvbmRpbmcgbW9kdWxlIGV2ZXJ5IHRpbWUgeW91cg0KPj4gbW9kdWxlIGxv
YWRzPw0KPj4NCj4+IEkgdGhpbmtzIHRoaXMgY2FuIGJlIGltcGxlbWVudGVkIHdpdGggbmRvIHdp
dGggIm1hc3Rlcl94bWl0X3NsYXZlX2dldCgpIg0KPj4gYXMgYSB3cmFwcGVyLiBNYXN0ZXJzIHRo
YXQgc3VwcG9ydCB0aGlzIHdvdWxkIGp1c3QgaW1wbGVtZW50IHRoZSBuZG8uDQo+IEluIGdlbmVy
YWwgSSB0aGluayB0aGlzIGlzIGEgZ29vZCBpZGVhICh0aG91Z2ggbWF5YmUgbm90IHdpdGggYW4g
c2tiIGFzDQo+IGFuIGFyZyBzbyB3ZSBjYW4gdXNlIGl0IGVhc2lseSB3aXRoaW4gQlBGKSwgYnV0
IEknbSBub3Qgc3VyZSBpZiBzb2x2ZXMNCj4gdGhlIHByb2JsZW0gdGhhdCBNYW9yIGV0IGFsIHdl
cmUgc2V0dGluZyBvdXQgdG8gc29sdmUuDQo+DQo+IE1hb3IsIGlmIHlvdSBkaWQgZXhwb3J0IGJv
bmRfeG1pdF9oYXNoKCkgdG8gYmUgdXNlZCBieSBhbm90aGVyIGRyaXZlciwNCj4geW91IHdvdWxk
IHByZXN1bWFibHkgaGF2ZSBhIGNoZWNrIGluIHBsYWNlIHNvIGlmIHRoZSBSb0NFIGFuZCBVRFAN
Cj4gcGFja2V0cyBoYWQgYSBkaWZmZXJlbnQgaGFzaCBmdW5jdGlvbiBvdXRwdXQgeW91IHdvdWxk
IG1ha2UgYSBjaGFuZ2UgYW5kDQo+IGJlIHN1cmUgdGhhdCB0aGUgVURQIGZyYW1lcyB3b3VsZCBn
byBvdXQgb24gdGhlIHNhbWUgZGV2aWNlIHRoYXQgdGhlDQo+IFJvQ0UgdHJhZmZpYyB3b3VsZCBu
b3JtYWxseSB1c2UuICBJcyB0aGlzIGNvcnJlY3Q/ICBXb3VsZCB5b3UgYWxzbyBzZW5kDQo+IHRo
ZSBmcmFtZXMgZGlyZWN0bHkgb24gdGhlIGludGVyZmFjZSB1c2luZyBkZXZfcXVldWVfeG1pdCgp
IGFuZCBieXBhc3MNCj4gdGhlIGJvbmRpbmcgZHJpdmVyIGNvbXBsZXRlbHk/DQoNClJvQ0UgcGFj
a2V0cyBhcmUgVURQLiBUaGUgaWRlYSBpcyB0aGF0IHRoZSBzYW1lIFVEUCBoZWFkZXIgKFJvQ0Ug
YXMgDQp3ZWxsKSB3aWxsIGdldCB0aGUgc2FtZSBoYXNoIHJlc3VsdCBzbyB0aGV5IHdpbGwgYmUg
dHJhbnNtaXR0ZWQgZnJvbSB0aGUgDQpzYW1lIHBvcnQuDQpUaGUgZnJhbWVzIHdpbGwgYmUgc2Vu
dCBieSB1c2luZyB0aGUgUkRNQSBzZW5kIEFQSSBhbmQgYnlwYXNzIHRoZSANCmJvbmRpbmcgZHJp
dmVyIGNvbXBsZXRlbHkuDQpJcyBpdCBhbnN3ZXIgeW91ciBxdWVzdGlvbj8NCg0KPiBJIGRvbid0
IHRoaW5rIEkgZnVuZGFtZW50YWxseSBoYXZlIGEgcHJvYmxlbSB3aXRoIHRoaXMsIEkganVzdCB3
YW50IHRvDQo+IG1ha2Ugc3VyZSBJIHVuZGVyc3RhbmQgeW91ciBwcm9wb3NlZCBjb2RlLWZsb3cu
DQo+DQo+IFRoYW5rcyENCj4NCg==
