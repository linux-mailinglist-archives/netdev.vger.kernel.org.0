Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4359113C61B
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgAOOd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 09:33:28 -0500
Received: from mail-am6eur05on2066.outbound.protection.outlook.com ([40.107.22.66]:5411
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726248AbgAOOd2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 09:33:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNuNIECJDl+kty02e/3BSGcF6P6ffQtSVH1Biv+/9EdeGY1jg4c+2ZUyw+zV5mzRWix5d9Ye7eYT4v+5KZfJFJvNLLrIz3tukXGly1yAODbxig1vaYJlfCzkhtA44WftNfQA9Yh7mrdHftoXsUoSPlw+pdNL9rs/jM4cQD7Vla/wgQkxtrMUUCrTsmknSUcI7tpVyGRjdr9t+eZ5eq1QVTz1U1jSGr5k1YJ1YAd3vi5ijAfnQSP7cGEtBm0U+sLMkeh0Llpb8vuASefjBWeEvTNK0pYif8OLTAwtNqbmOXEmX4ipQi+GgEN1uvM2i16/2VUFBFouqFUWfar46gB9Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Op3Sro+9N9+Zu7FSCiZL87UiVh8g5vFx3DY3AAbQjpo=;
 b=Mw3RztXukBpEUhaBCdt1jNri9TP0sNjtgEGhKTV2vMlJm7+KggeTd2QJXgqGGCDTzGTxvg1Ks0h4vWVXWml4l2fLWy1GJLkd+Uku7p2bRKyhL8+UGfglBo/D9ThPnxuwPvxWN8daY1HIX8DUt7jATYI28fKrhTTFh0dUTmoRx4m4OXGHhruEgf8mbAIvo9xpzab/yW7sTmDoqi/tuUdHlF+NLZQFQ+GhuWZ7seWgKMXn7ngVeuio8Z4WdkoJjMFE2AhkrcCumtTAhVQH2mqvY3BAQC0q6+jW+pbFE/ExGf9TprRNJPySb5Nuq5I++SGK5L95jOTQmvRa8v30xWf/IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Op3Sro+9N9+Zu7FSCiZL87UiVh8g5vFx3DY3AAbQjpo=;
 b=IQEL7LzCWC8+0sEX9dkOfEh60cjDAxXuTe0tIDJmQxa1/N5mwTcCdPJf6VKhTSVYfewzuISPUCNxxAwdHwyvaCbEBNX6D3VYwEmqJv/8vxovMtlkbWSxc9/j0Ih+fN9bPuI3s/+3VkZ6/RPEj9uPXxMCSbCRTusnx+Psj7fUMUo=
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB4277.eurprd05.prod.outlook.com (52.135.166.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.8; Wed, 15 Jan 2020 14:33:23 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::d1:c74b:50e8:adba]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::d1:c74b:50e8:adba%5]) with mapi id 15.20.2623.017; Wed, 15 Jan 2020
 14:33:23 +0000
Received: from localhost (193.47.165.251) by ZR0P278CA0046.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Wed, 15 Jan 2020 14:33:22 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Maor Gottlieb <maorg@mellanox.com>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: Expose bond_xmit_hash function
Thread-Topic: Expose bond_xmit_hash function
Thread-Index: AQHVy3oGgIF7KBJViUaUTiVJMTGSk6fregOAgAA3xYCAABPFgIAABPYA
Date:   Wed, 15 Jan 2020 14:33:23 +0000
Message-ID: <20200115143320.GA76932@unreal>
References: <03a6dcfc-f3c7-925d-8ed8-3c42777fd03c@mellanox.com>
 <20200115094513.GS2131@nanopsycho>
 <80ad03a2-9926-bf75-d79c-be554c4afaaf@mellanox.com>
 <20200115141535.GT2131@nanopsycho>
In-Reply-To: <20200115141535.GT2131@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0046.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::15) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5f29279c-1137-41a8-3d69-08d799c7dfef
x-ms-traffictypediagnostic: AM6PR05MB4277:|AM6PR05MB4277:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB427720879998814C54FF4467B0370@AM6PR05MB4277.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(39860400002)(396003)(346002)(366004)(376002)(136003)(189003)(199004)(66476007)(52116002)(66446008)(33656002)(66946007)(66556008)(16526019)(6496006)(8936002)(33716001)(64756008)(956004)(186003)(26005)(6916009)(8676002)(86362001)(107886003)(2906002)(4326008)(5660300002)(9686003)(1076003)(54906003)(316002)(81156014)(81166006)(7116003)(71200400001)(478600001)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4277;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +gh7y1+cyEzEdD+rYGycIXNqzDHk/hWy9K3148pyrkxvp9UtGgkEbek11h0ab3wULTPA5vf4ynuYc+Kn4txLkEfrnkZKQjWzQkn16PlYCqNr4sug+2AqaI/+e1FVufMUn8rZ/Y0c+yykfLFLKE5ZT7LOcasRcpeRhCqcp/WLBIX6KWqvUo3+fARS9wy1rr87/WZGaHccXE6FTfBWOq1ysMcTKCSCu1tyZiMme1Ir1fJNxZ8Fqa5QpHiSa9+Qx/vElhV+QzTHbpTXfxjwCX+lZd8f8gwlLhDmhgh01+HaIEPVcUA8G2FD+9b5L7hxfe/zSNfysXwNFAKYPS2u4GtyuETaZHYPc7Ra/1DtQl+IdvMsaz1k9qDsbtv+DDPxweh1kQ+2LbFpiQK7u3CmUBU9BOy+voPDdvyZL4oJnWuHQyz+XMFSKzwkZ02/wnEsSr+K
Content-Type: text/plain; charset="utf-8"
Content-ID: <EDD37402AC8A254B99C99509A3E6C55F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f29279c-1137-41a8-3d69-08d799c7dfef
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 14:33:23.3512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YVx0GUBIBVvi9b3yLtNVwjeFnmS8pBaiVx9qzX8NgSjFsUsokxB0XE0sp6HbIcRPG49XrhUFe3op5VyVrNPbuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4277
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBKYW4gMTUsIDIwMjAgYXQgMDM6MTU6MzVQTSArMDEwMCwgSmlyaSBQaXJrbyB3cm90
ZToNCj4gV2VkLCBKYW4gMTUsIDIwMjAgYXQgMDI6MDQ6NDlQTSBDRVQsIG1hb3JnQG1lbGxhbm94
LmNvbSB3cm90ZToNCj4gPg0KPiA+T24gMS8xNS8yMDIwIDExOjQ1IEFNLCBKaXJpIFBpcmtvIHdy
b3RlOg0KPiA+PiBXZWQsIEphbiAxNSwgMjAyMCBhdCAwOTowMTo0M0FNIENFVCwgbWFvcmdAbWVs
bGFub3guY29tIHdyb3RlOg0KPiA+Pj4gUkRNQSBvdmVyIENvbnZlcmdlZCBFdGhlcm5ldCAoUm9D
RSkgaXMgYSBzdGFuZGFyZCBwcm90b2NvbCB3aGljaCBlbmFibGVzDQo+ID4+PiBSRE1B4oCZcyBl
ZmZpY2llbnQgZGF0YSB0cmFuc2ZlciBvdmVyIEV0aGVybmV0IG5ldHdvcmtzIGFsbG93aW5nIHRy
YW5zcG9ydA0KPiA+Pj4gb2ZmbG9hZCB3aXRoIGhhcmR3YXJlIFJETUEgZW5naW5lIGltcGxlbWVu
dGF0aW9uLg0KPiA+Pj4gVGhlIFJvQ0UgdjIgcHJvdG9jb2wgZXhpc3RzIG9uIHRvcCBvZiBlaXRo
ZXIgdGhlIFVEUC9JUHY0IG9yIHRoZQ0KPiA+Pj4gVURQL0lQdjYgcHJvdG9jb2w6DQo+ID4+Pg0K
PiA+Pj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCj4gPj4+IHwgTDIgfCBMMyB8IFVEUCB8SUIgQlRIIHwgUGF5bG9hZHwgSUNS
QyB8IEZDUyB8DQo+ID4+PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+Pj4NCj4gPj4+IFdoZW4gYSBib25kIExBRyBuZXRk
ZXYgaXMgaW4gdXNlLCB3ZSB3b3VsZCBsaWtlIHRvIGhhdmUgdGhlIHNhbWUgaGFzaA0KPiA+Pj4g
cmVzdWx0IGZvciBSb0NFIHBhY2tldHMgYXMgYW55IG90aGVyIFVEUCBwYWNrZXRzLCBmb3IgdGhp
cyBwdXJwb3NlIHdlDQo+ID4+PiBuZWVkIHRvIGV4cG9zZSB0aGUgYm9uZF94bWl0X2hhc2ggZnVu
Y3Rpb24gdG8gZXh0ZXJuYWwgbW9kdWxlcy4NCj4gPj4+IElmIG5vIG9iamVjdGlvbiwgSSB3aWxs
IHB1c2ggYSBwYXRjaCB0aGF0IGV4cG9ydCB0aGlzIHN5bWJvbC4NCj4gPj4gSSBkb24ndCB0aGlu
ayBpdCBpcyBnb29kIGlkZWEgdG8gZG8gaXQuIEl0IGlzIGFuIGludGVybmFsIGJvbmQgZnVuY3Rp
b24uDQo+ID4+IGl0IGV2ZW4gYWNjZXB0cyAic3RydWN0IGJvbmRpbmcgKmJvbmQiLiBEbyB5b3Ug
cGxhbiB0byBwdXNoIG5ldGRldg0KPiA+PiBzdHJ1Y3QgYXMgYW4gYXJnIGluc3RlYWQ/IFdoYXQg
YWJvdXQgdGVhbT8gV2hhdCBhYm91dCBPVlMgYm9uZGluZz8NCj4gPg0KPiA+Tm8sIEkgYW0gcGxh
bm5pbmcgdG8gcGFzcyB0aGUgYm9uZCBzdHJ1Y3QgYXMgYW4gYXJnLiBDdXJyZW50bHksIHRlYW0N
Cj4NCj4gSG1tLCB0aGF0IHdvdWxkIGJlIG9mY291cnNlIHdyb25nLCBhcyBpdCBpcyBpbnRlcm5h
bCBib25kaW5nIGRyaXZlcg0KPiBzdHJ1Y3R1cmUuDQo+DQo+DQo+ID5ib25kaW5nIGlzIG5vdCBz
dXBwb3J0ZWQgaW4gUm9DRSBMQUcgYW5kIEkgZG9uJ3Qgc2VlIGhvdyBPVlMgaXMgcmVsYXRlZC4N
Cj4NCj4gU2hvdWxkIHdvcmsgZm9yIGFsbC4gT1ZTIGlzIHJlbGF0ZWQgaW4gYSBzZW5zZSB0aGF0
IHlvdSBjYW4gZG8gYm9uZGluZw0KPiB0aGVyZSB0b28uDQo+DQo+DQo+ID4NCj4gPj4NCj4gPj4g
QWxzbywgeW91IGRvbid0IHJlYWxseSBuZWVkIGEgaGFzaCwgeW91IG5lZWQgYSBzbGF2ZSB0aGF0
IGlzIGdvaW5nIHRvIGJlDQo+ID4+IHVzZWQgZm9yIGEgcGFja2V0IHhtaXQuDQo+ID4+DQo+ID4+
IEkgdGhpbmsgdGhpcyBjb3VsZCB3b3JrIGluIGEgZ2VuZXJpYyB3YXk6DQo+ID4+DQo+ID4+IHN0
cnVjdCBuZXRfZGV2aWNlICptYXN0ZXJfeG1pdF9zbGF2ZV9nZXQoc3RydWN0IG5ldF9kZXZpY2Ug
Km1hc3Rlcl9kZXYsDQo+ID4+IAkJCQkJIHN0cnVjdCBza19idWZmICpza2IpOw0KPiA+DQo+ID5U
aGUgc3VnZ2VzdGlvbiBpcyB0byBwdXQgdGhpcyBmdW5jdGlvbiBpbiB0aGUgYm9uZCBkcml2ZXIg
YW5kIGNhbGwgaXQNCj4gPmluc3RlYWQgb2YgYm9uZF94bWl0X2hhc2g/IGlzIGl0IHN0aWxsIG5l
Y2Vzc2FyeSBpZiBJIGhhdmUgdGhlIGJvbmQgcG9pbnRlcj8NCj4NCj4gTm8uIFRoaXMgc2hvdWxk
IGJlIGluIGEgZ2VuZXJpYyBjb2RlLiBObyBkaXJlY3QgY2FsbHMgZG93biB0byBib25kaW5nDQo+
IGRyaXZlciBwbGVhc2UuIE9yIGRvIHlvdSB3YW50IHRvIGxvYWQgYm9uZGluZyBtb2R1bGUgZXZl
cnkgdGltZSB5b3VyDQo+IG1vZHVsZSBsb2Fkcz8NCj4NCj4gSSB0aGlua3MgdGhpcyBjYW4gYmUg
aW1wbGVtZW50ZWQgd2l0aCBuZG8gd2l0aCAibWFzdGVyX3htaXRfc2xhdmVfZ2V0KCkiDQo+IGFz
IGEgd3JhcHBlci4gTWFzdGVycyB0aGF0IHN1cHBvcnQgdGhpcyB3b3VsZCBqdXN0IGltcGxlbWVu
dCB0aGUgbmRvLg0KDQpXZSBhcmUgdGFsa2luZyBhYm91dCBjb2RlIHNoYXJpbmcgYW5kIG5vdCBh
dHRlbXB0aW5nIHRvIHNvbHZlIGFueQ0KcHJvYmxlbSBvdGhlciB0aGFuIHRoYXQuDQoNClJpZ2h0
IG5vdywgd2UgaGF2ZSBvbmUgb2YgdHdvIG9wdGlvbnM6DQoxLiBPbmUtdG8tb25lIGNvcHkvcGFz
dGUgb2YgdGhhdCBib25kX3htaXQgZnVuY3Rpb24gdG8gUkRNQS4NCjIuIEFkZCBFWFBPUlRfU1lN
Qk9MIGFuZCBjYWxsIGZyb20gUkRNQS4NCg0KRG8geW91IGhhdmUgYW5vdGhlciBzb2x1dGlvbiB0
byBvdXIgdW5kZXNpcmUgdG8gZG8gY29weS9wYXN0ZSBpbiBtaW5kPw0KDQpUaGFua3MNCg0KPg0K
PiA+DQo=
