Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0446144CAA
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 08:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgAVHxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 02:53:25 -0500
Received: from mail-eopbgr10042.outbound.protection.outlook.com ([40.107.1.42]:58126
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726083AbgAVHxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 02:53:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYTlSvJBpWNHmqXysEQ09/gwhIoFjYJW9lIZJ6/g7LwUoEjxMqURlvNe+AxLFO1zXR0WXxGIq5aLbaHUYSyiUMUsId7Vfn6sxTS5llOHar67BFbaiYDQG8QS1J45lQgoNXh+nBOyQADFshWIJ7mnnh3wmBByIMI2V2qGkKX3+hbw73hd8MyTNZmvsvoD/R2Y65OUjT+s6hToKeu5uqDw5XHNdDRID56KOwUm0HDydZIhtPt/REWSJqGsLTWzfsk5wtuiHA65njE5fhdDFoJTl2gnxXlXhRVh8mEu7aBp5g/2VcnggJ8GqVJm/gJS/IcisYVkSUTXueVDG+EWGo5YGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qup+875RDWaIJ2DKDkTlbNdktrcsEEKRcyGZeX4gylk=;
 b=hWn/ygAbKHuuR0u30we2ct59AS0OrXcqtwVnAtiYZCRolj/2I8In3Prc/q24sXOP80TfMLJFBmRitx6y57Qr2lufLt7f9EOKzfzXsM3/pMRyqdUVO/RuWqHWQgqxlKocTEBF+342vmNgVDbRDJIqmuPSFiLI2oZzrSH4MNfXrMjCzrpvcskoXsMF+XO3zMBi0sRUBWe0pM+LC8QEeNOvGw1JDZCc5jghooPS4TO0L7SvoucplJz6drAbHgbdel71CLfMq2FN6iCzjTCYZCXM3byYjNr9t+PwMy6i1tTGWo0WnKQrtnZd8f2ZMTi1YnEk14nJfXiqDLtHSKQfxM4RFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qup+875RDWaIJ2DKDkTlbNdktrcsEEKRcyGZeX4gylk=;
 b=N++haTuImAjJxUZyFUp3WVcEQdjD6AzTSMwbsVYE6hb4fcFTEW/7VxFHZ/Ge2+M+rPgmVudaLoHSK3vJHBwGNpI1fBvGPO+iU5UgvKMMA9FsfNh0XjbLHYm9I5bPKT310RlTv0E3se8vzYJVMfJ4UEu0UI1uufByIT12ivsnRbQ=
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (20.178.117.153) by
 AM0PR05MB4372.eurprd05.prod.outlook.com (52.134.124.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 22 Jan 2020 07:53:20 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192%4]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 07:53:20 +0000
Received: from [10.80.3.21] (193.47.165.251) by FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Wed, 22 Jan 2020 07:53:18 +0000
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
Thread-Index: AQHVy3oG0EtUwers0UGLm6hc+vG4CqfregOAgABZSAD///JCgIABmfkAgAAUW4CAAAFqgIAExYSAgAGxTQCAAm7yAA==
Date:   Wed, 22 Jan 2020 07:53:19 +0000
Message-ID: <97a7e0b9-f581-4983-4b20-d5e95d5b2bb8@mellanox.com>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
 <20200115094513.GS2131@nanopsycho>
 <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com>
 <20200115141535.GT2131@nanopsycho> <20200116144256.GA87583@C02YVCJELVCG>
 <8e90935b-7485-0969-6fe4-d802d259f778@mellanox.com> <31666.1579190451@famine>
 <2b2d0e14-59c7-5efa-93a8-8027f4ed43e5@mellanox.com> <3719.1579545820@famine>
In-Reply-To: <3719.1579545820@famine>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-clientproxiedby: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maorg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bc1b96f8-0ee2-4cc6-37d8-08d79f1025b2
x-ms-traffictypediagnostic: AM0PR05MB4372:|AM0PR05MB4372:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4372575BD3EF0D6A447D9338D30C0@AM0PR05MB4372.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(199004)(189003)(52116002)(7116003)(64756008)(66446008)(86362001)(66946007)(31696002)(66476007)(31686004)(26005)(66556008)(5660300002)(8676002)(6916009)(71200400001)(2616005)(956004)(316002)(2906002)(16576012)(4326008)(54906003)(53546011)(107886003)(81156014)(8936002)(6486002)(478600001)(16526019)(186003)(36756003)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4372;H:AM0PR05MB5873.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: takcV1qB5/IwsLdFO56D7YYC4TO+TyarucNzx+dYfTq/4H4PBG0SSYSHbx9kuMwEDvwfUkn91tPNAip2CbDhi1vWYbYF/U3foePJFb8WtellVcMxesNckBWd0MkzNsedqiUKNDR3UaqM6HorehTimiDNeAfvHxj/4DWBNd0vEIFgWl+/wLcHcvNi+NfcLgKcK0Sf/PYGoj47HXRy4zfzKj8Aa1yWh9DBD+gANSHt+t6VLgI8h84KWpLW/Qbiwd3WqAbNxN4wt+Ajlo0wsXS7x+iVlit7ctZIOEafx3mLkS3VVH2/OkmM36/M0cynylS4To+7u8rKcEMJ/gkdBG/FNZNzlg+bHGboCQKh/AWHeqKxseZoDlMeSSl7GWiZbGVyvC442tVeYU8yaLuT5lcxMcqjy1E8SRVV/+aI+NAwHj4DOPPPOC2HHBQHhrKGWnf8
Content-Type: text/plain; charset="utf-8"
Content-ID: <860B1CA715210142A04B3373432F20DE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc1b96f8-0ee2-4cc6-37d8-08d79f1025b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 07:53:19.9013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SlLgGu7VYZFwff77g8Z9MFlL4Cv7ymSiUQBNCLHFDO0O+XIG+QQD8F1jcz9Q3dPKvKrGFkG0Y82E/Td0BLHsRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4372
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzIwLzIwMjAgODo0MyBQTSwgSmF5IFZvc2J1cmdoIHdyb3RlOg0KPiBNYW9yIEdvdHRs
aWViIDxtYW9yZ0BtZWxsYW5veC5jb20+IHdyb3RlOg0KPg0KPj4gT24gMS8xNi8yMDIwIDY6MDAg
UE0sIEpheSBWb3NidXJnaCB3cm90ZToNCj4+PiBNYW9yIEdvdHRsaWViIDxtYW9yZ0BtZWxsYW5v
eC5jb20+IHdyb3RlOg0KPj4+DQo+Pj4+IE9uIDEvMTYvMjAyMCA0OjQyIFBNLCBBbmR5IEdvc3Bv
ZGFyZWsgd3JvdGU6DQo+Pj4+PiBPbiBXZWQsIEphbiAxNSwgMjAyMCBhdCAwMzoxNTozNVBNICsw
MTAwLCBKaXJpIFBpcmtvIHdyb3RlOg0KPj4+Pj4+IFdlZCwgSmFuIDE1LCAyMDIwIGF0IDAyOjA0
OjQ5UE0gQ0VULCBtYW9yZ0BtZWxsYW5veC5jb20gd3JvdGU6DQo+Pj4+Pj4+IE9uIDEvMTUvMjAy
MCAxMTo0NSBBTSwgSmlyaSBQaXJrbyB3cm90ZToNCj4+Pj4+Pj4+IFdlZCwgSmFuIDE1LCAyMDIw
IGF0IDA5OjAxOjQzQU0gQ0VULCBtYW9yZ0BtZWxsYW5veC5jb20gd3JvdGU6DQo+Pj4+Pj4+Pj4g
UkRNQSBvdmVyIENvbnZlcmdlZCBFdGhlcm5ldCAoUm9DRSkgaXMgYSBzdGFuZGFyZCBwcm90b2Nv
bCB3aGljaCBlbmFibGVzDQo+Pj4+Pj4+Pj4gUkRNQeKAmXMgZWZmaWNpZW50IGRhdGEgdHJhbnNm
ZXIgb3ZlciBFdGhlcm5ldCBuZXR3b3JrcyBhbGxvd2luZyB0cmFuc3BvcnQNCj4+Pj4+Pj4+PiBv
ZmZsb2FkIHdpdGggaGFyZHdhcmUgUkRNQSBlbmdpbmUgaW1wbGVtZW50YXRpb24uDQo+Pj4+Pj4+
Pj4gVGhlIFJvQ0UgdjIgcHJvdG9jb2wgZXhpc3RzIG9uIHRvcCBvZiBlaXRoZXIgdGhlIFVEUC9J
UHY0IG9yIHRoZQ0KPj4+Pj4+Pj4+IFVEUC9JUHY2IHByb3RvY29sOg0KPj4+Pj4+Pj4+DQo+Pj4+
Pj4+Pj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCj4+Pj4+Pj4+PiB8IEwyIHwgTDMgfCBVRFAgfElCIEJUSCB8IFBheWxvYWR8
IElDUkMgfCBGQ1MgfA0KPj4+Pj4+Pj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+PiBXaGVu
IGEgYm9uZCBMQUcgbmV0ZGV2IGlzIGluIHVzZSwgd2Ugd291bGQgbGlrZSB0byBoYXZlIHRoZSBz
YW1lIGhhc2gNCj4+Pj4+Pj4+PiByZXN1bHQgZm9yIFJvQ0UgcGFja2V0cyBhcyBhbnkgb3RoZXIg
VURQIHBhY2tldHMsIGZvciB0aGlzIHB1cnBvc2Ugd2UNCj4+Pj4+Pj4+PiBuZWVkIHRvIGV4cG9z
ZSB0aGUgYm9uZF94bWl0X2hhc2ggZnVuY3Rpb24gdG8gZXh0ZXJuYWwgbW9kdWxlcy4NCj4+Pj4+
Pj4+PiBJZiBubyBvYmplY3Rpb24sIEkgd2lsbCBwdXNoIGEgcGF0Y2ggdGhhdCBleHBvcnQgdGhp
cyBzeW1ib2wuDQo+Pj4+Pj4+PiBJIGRvbid0IHRoaW5rIGl0IGlzIGdvb2QgaWRlYSB0byBkbyBp
dC4gSXQgaXMgYW4gaW50ZXJuYWwgYm9uZCBmdW5jdGlvbi4NCj4+Pj4+Pj4+IGl0IGV2ZW4gYWNj
ZXB0cyAic3RydWN0IGJvbmRpbmcgKmJvbmQiLiBEbyB5b3UgcGxhbiB0byBwdXNoIG5ldGRldg0K
Pj4+Pj4+Pj4gc3RydWN0IGFzIGFuIGFyZyBpbnN0ZWFkPyBXaGF0IGFib3V0IHRlYW0/IFdoYXQg
YWJvdXQgT1ZTIGJvbmRpbmc/DQo+Pj4+Pj4+IE5vLCBJIGFtIHBsYW5uaW5nIHRvIHBhc3MgdGhl
IGJvbmQgc3RydWN0IGFzIGFuIGFyZy4gQ3VycmVudGx5LCB0ZWFtDQo+Pj4+Pj4gSG1tLCB0aGF0
IHdvdWxkIGJlIG9mY291cnNlIHdyb25nLCBhcyBpdCBpcyBpbnRlcm5hbCBib25kaW5nIGRyaXZl
cg0KPj4+Pj4+IHN0cnVjdHVyZS4NCj4+Pj4+Pg0KPj4+Pj4+DQo+Pj4+Pj4+IGJvbmRpbmcgaXMg
bm90IHN1cHBvcnRlZCBpbiBSb0NFIExBRyBhbmQgSSBkb24ndCBzZWUgaG93IE9WUyBpcyByZWxh
dGVkLg0KPj4+Pj4+IFNob3VsZCB3b3JrIGZvciBhbGwuIE9WUyBpcyByZWxhdGVkIGluIGEgc2Vu
c2UgdGhhdCB5b3UgY2FuIGRvIGJvbmRpbmcNCj4+Pj4+PiB0aGVyZSB0b28uDQo+Pj4+Pj4NCj4+
Pj4+Pg0KPj4+Pj4+Pj4gQWxzbywgeW91IGRvbid0IHJlYWxseSBuZWVkIGEgaGFzaCwgeW91IG5l
ZWQgYSBzbGF2ZSB0aGF0IGlzIGdvaW5nIHRvIGJlDQo+Pj4+Pj4+PiB1c2VkIGZvciBhIHBhY2tl
dCB4bWl0Lg0KPj4+Pj4+Pj4NCj4+Pj4+Pj4+IEkgdGhpbmsgdGhpcyBjb3VsZCB3b3JrIGluIGEg
Z2VuZXJpYyB3YXk6DQo+Pj4+Pj4+Pg0KPj4+Pj4+Pj4gc3RydWN0IG5ldF9kZXZpY2UgKm1hc3Rl
cl94bWl0X3NsYXZlX2dldChzdHJ1Y3QgbmV0X2RldmljZSAqbWFzdGVyX2RldiwNCj4+Pj4+Pj4+
IAkJCQkJIHN0cnVjdCBza19idWZmICpza2IpOw0KPj4+Pj4+PiBUaGUgc3VnZ2VzdGlvbiBpcyB0
byBwdXQgdGhpcyBmdW5jdGlvbiBpbiB0aGUgYm9uZCBkcml2ZXIgYW5kIGNhbGwgaXQNCj4+Pj4+
Pj4gaW5zdGVhZCBvZiBib25kX3htaXRfaGFzaD8gaXMgaXQgc3RpbGwgbmVjZXNzYXJ5IGlmIEkg
aGF2ZSB0aGUgYm9uZCBwb2ludGVyPw0KPj4+Pj4+IE5vLiBUaGlzIHNob3VsZCBiZSBpbiBhIGdl
bmVyaWMgY29kZS4gTm8gZGlyZWN0IGNhbGxzIGRvd24gdG8gYm9uZGluZw0KPj4+Pj4+IGRyaXZl
ciBwbGVhc2UuIE9yIGRvIHlvdSB3YW50IHRvIGxvYWQgYm9uZGluZyBtb2R1bGUgZXZlcnkgdGlt
ZSB5b3VyDQo+Pj4+Pj4gbW9kdWxlIGxvYWRzPw0KPj4+Pj4+DQo+Pj4+Pj4gSSB0aGlua3MgdGhp
cyBjYW4gYmUgaW1wbGVtZW50ZWQgd2l0aCBuZG8gd2l0aCAibWFzdGVyX3htaXRfc2xhdmVfZ2V0
KCkiDQo+Pj4+Pj4gYXMgYSB3cmFwcGVyLiBNYXN0ZXJzIHRoYXQgc3VwcG9ydCB0aGlzIHdvdWxk
IGp1c3QgaW1wbGVtZW50IHRoZSBuZG8uDQo+Pj4+PiBJbiBnZW5lcmFsIEkgdGhpbmsgdGhpcyBp
cyBhIGdvb2QgaWRlYSAodGhvdWdoIG1heWJlIG5vdCB3aXRoIGFuIHNrYiBhcw0KPj4+Pj4gYW4g
YXJnIHNvIHdlIGNhbiB1c2UgaXQgZWFzaWx5IHdpdGhpbiBCUEYpLCBidXQgSSdtIG5vdCBzdXJl
IGlmIHNvbHZlcw0KPj4+Pj4gdGhlIHByb2JsZW0gdGhhdCBNYW9yIGV0IGFsIHdlcmUgc2V0dGlu
ZyBvdXQgdG8gc29sdmUuDQo+Pj4+Pg0KPj4+Pj4gTWFvciwgaWYgeW91IGRpZCBleHBvcnQgYm9u
ZF94bWl0X2hhc2goKSB0byBiZSB1c2VkIGJ5IGFub3RoZXIgZHJpdmVyLA0KPj4+Pj4geW91IHdv
dWxkIHByZXN1bWFibHkgaGF2ZSBhIGNoZWNrIGluIHBsYWNlIHNvIGlmIHRoZSBSb0NFIGFuZCBV
RFANCj4+Pj4+IHBhY2tldHMgaGFkIGEgZGlmZmVyZW50IGhhc2ggZnVuY3Rpb24gb3V0cHV0IHlv
dSB3b3VsZCBtYWtlIGEgY2hhbmdlIGFuZA0KPj4+Pj4gYmUgc3VyZSB0aGF0IHRoZSBVRFAgZnJh
bWVzIHdvdWxkIGdvIG91dCBvbiB0aGUgc2FtZSBkZXZpY2UgdGhhdCB0aGUNCj4+Pj4+IFJvQ0Ug
dHJhZmZpYyB3b3VsZCBub3JtYWxseSB1c2UuICBJcyB0aGlzIGNvcnJlY3Q/ICBXb3VsZCB5b3Ug
YWxzbyBzZW5kDQo+Pj4+PiB0aGUgZnJhbWVzIGRpcmVjdGx5IG9uIHRoZSBpbnRlcmZhY2UgdXNp
bmcgZGV2X3F1ZXVlX3htaXQoKSBhbmQgYnlwYXNzDQo+Pj4+PiB0aGUgYm9uZGluZyBkcml2ZXIg
Y29tcGxldGVseT8NCj4+Pj4gUm9DRSBwYWNrZXRzIGFyZSBVRFAuIFRoZSBpZGVhIGlzIHRoYXQg
dGhlIHNhbWUgVURQIGhlYWRlciAoUm9DRSBhcw0KPj4+PiB3ZWxsKSB3aWxsIGdldCB0aGUgc2Ft
ZSBoYXNoIHJlc3VsdCBzbyB0aGV5IHdpbGwgYmUgdHJhbnNtaXR0ZWQgZnJvbSB0aGUNCj4+Pj4g
c2FtZSBwb3J0Lg0KPj4+PiBUaGUgZnJhbWVzIHdpbGwgYmUgc2VudCBieSB1c2luZyB0aGUgUkRN
QSBzZW5kIEFQSSBhbmQgYnlwYXNzIHRoZQ0KPj4+PiBib25kaW5nIGRyaXZlciBjb21wbGV0ZWx5
Lg0KPj4+PiBJcyBpdCBhbnN3ZXIgeW91ciBxdWVzdGlvbj8NCj4+PiAJSWYgdGhlIFJETUEgc2Vu
ZCBieXBhc3NlcyBib25kaW5nLCBob3cgd2lsbCB5b3UgaW5zdXJlIHRoYXQgdGhlDQo+Pj4gc2Ft
ZSBoYXNoIHJlc3VsdCBtYXBzIHRvIHRoZSBzYW1lIHVuZGVybHlpbmcgaW50ZXJmYWNlIGZvciBi
b3RoIGJvbmRpbmcNCj4+PiBhbmQgUkRNQT8NCj4+Pg0KPj4+IAktSg0KPj4gSW4gUm9DRSwgdGhl
IGFmZmluaXR5IGlzIGRldGVybWluZWQgd2hpbGUgdGhlIEhXIHJlc291cmNlcyBhcmUgY3JlYXRl
ZA0KPj4gYW5kIHdpbGwgYmUgbW9kaWZpZWQgZ2xvYmFsbHkgaW4gcnVuIHRpbWUgdG8gdHJhY2sg
dGhlIGFjdGl2ZSBzYWx2ZXMuDQo+PiBJZiB3ZSBnZXQgdGhlIHNsYXZlIHJlc3VsdCwgYWxsIHRo
ZSBVRFAgcGFja2V0cyB3aWxsIGhhdmUgdGhlIHNhbWUNCj4+IGFmZmluaXR5IGFzIFJvQ0UuDQo+
IAlIb3cgZG8geW91ICJ0cmFjayB0aGUgYWN0aXZlIHNsYXZlcz8iDQo+DQo+IAlXaGF0IEkgd2Fu
dCB0byBrbm93IGlzIHdoZXRoZXIgb3Igbm90IHRoZSBSb0NFIGNvZGUgaXMgZ29pbmcgdG8NCj4g
cGVlayBpbnRvIHRoZSBib25kaW5nIGludGVybmFsIGRhdGEgc3RydWN0dXJlcyB0byBsb29rIGF0
LCBlLmcuLA0KPiBib25kLT5zbGF2ZV9hcnIuICBJIGRvbid0IHNlZSBhbiBvYnZpb3VzIHdheSB0
byBpbnN1cmUgYSBkdXBsaWNhdGlvbiBvZg0KPiBib25kaW5nJ3MgaGFzaCB0byBzbGF2ZSBtYXBw
aW5nIHdpdGhvdXQga25vd2luZyB0aGUgcGxhY2VtZW50IG9mIHRoZQ0KPiBzbGF2ZXMgaW4gc2xh
dmVfYXJyLg0KPg0KPj4gVGhlIGRvd25zaWRlIGlzIHRoYXQgYWxsIFJvQ0UgSFcgcmVzb3VyY2Vz
IHdpbGwgYmUgc3R1Y2sgd2l0aCB0aGUNCj4+IG9yaWdpbmFsIGFmZmluaXR5IHBvcnQgYW5kIG5v
dCBtb3ZlIHRvIHRoZSByZS1hY3RpdmF0ZSBzbGF2ZSBvbmNlIGl0DQo+PiBnb2VzIHVwLiBBbm90
aGVyIGRpc2FkdmFudGFnZSwgd2hlbiBib3RoIHBvcnRzIGFyZSBkb3duLCB3ZSBzdGlsbCBuZWVk
DQo+PiB0byBjcmVhdGUgdGhlIFJvQ0UgSFcgcmVzb3VyY2VzIHdpdGggYSBnaXZlbiBwb3J0IGFm
ZmluaXR5LiBCb3RoDQo+PiBwcm9ibGVtcyBhcmUgc29sdmVkIGJ5IGV4cG9ydGluZyB0aGUgaGFz
aC4NCj4gCVRoaXMgc291bmRzIGxpa2UgYSBkaWZmZXJlbnQgZXhwbGFuYXRpb247IGFib3ZlLCB5
b3Ugc2FpZCB0aGluZ3MNCj4gYXJlICJtb2RpZmllZCBnbG9iYWxseSBpbiBydW4gdGltZSIgYnV0
IGhlcmUgdGhlIG1hcHBpbmdzIGFyZSBzdGF0aWMuICBJDQo+IGRvbid0IHNlZSBhbiBleHBsYW5h
dGlvbiBvZiBob3cgaGF2aW5nIHRoZSBoYXNoIHNvbHZlcyB0aGVzZSBwcm9ibGVtcywNCj4gb3Ig
d2h5IGl0IHdvdWxkIGJlIGJldHRlciB0aGFuIEppcmkncyBzdWdnZXN0aW9uIG9mIGFuIC5uZG8g
b3IgZ2VuZXJpYw0KPiB3cmFwcGVyLg0KPg0KPiAJLUoNCg0KDQpJIHdpbGwgdHJ5IHRvIGNsYXJp
ZnkgaXQuDQpJbiBSb0NFLCB0aGUgdHggYWZmaW5pdHkgaXMgc2VsZWN0ZWQgaW4gdGhlIGNvbnRy
b2wgcGF0aC7CoCBJbiBjYXNlIHRoYXQgDQpwb3J0IGlzIGdvaW5nIGRvd24sIHRoZW4gdGhlIHBv
cnQgY291bGQgYmUgcmVtYXBwZWQgdG8gYWN0aXZlIHBvcnQuDQpJZiBJIGhhdmUgdGhlIGhhc2gg
cmVzdWx0LCB0aGVuIEkgY2FuIGRvIG1vZHVsbyB3aXRoIHRoZSBudW1iZXIgb2YgdGhlIA0KZGV2
aWNlIHBvcnRzLCBubyBtYXR0ZXIgaWYgdGhlIHBvcnQgaXMgYWN0aXZlIG9yIG5vdC4gT3V0Z29p
bmcgdHJhZmZpYyANCndpbGwgZ28gdGhyb3VnaCB0aGlzIHBvcnQgdW5sZXNzIHRoZSBwb3J0IHdh
cyByZW1hcHBlZC4gU28gSSBjYW4gDQpndWFyYW50ZWUgdGhhdCB0aGUgc2FtZSBSb0NFIHBhY2tl
dHMgd2lsbCBiZSB0cmFuc21pdHRlZCBmcm9tIHRoZSBzYW1lIA0KcG9ydCwgYnV0IGJlY2F1c2Ug
d2UgYXJlIG5vdCBnb2luZyB0byBsb29rIGludG8gdGhlIHNsYXZlX2FyciwgaXQgaXNuJ3QgDQpp
bnN1cmVkIHRoYXQgc2FtZSBSb0NFIGFuZCBub24tUm9DRSBVRFAgcGFja2V0cyB3aWxsIGhhdmUg
dGhlIHNhbWUgYWZmaW5pdHkuDQoNCldoYXQgYWJvdXQgZXh0ZW5kaW5nIHRoZSAubmRvIHN1Z2dl
c3Rpb24gdG8gZ2V0IGEgZmxhZyB0aGF0IHJldHVybnMgdGhlIA0KdHggc2xhdmUgYXNzdW1lIGFs
bCBzbGF2ZXMgYXJlIGF2YWlsYWJsZT8NCg0KPg0KPiAtLS0NCj4gCS1KYXkgVm9zYnVyZ2gsIGph
eS52b3NidXJnaEBjYW5vbmljYWwuY29tDQo=
