Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07CD71200D0
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfLPJRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:17:34 -0500
Received: from mail-eopbgr140075.outbound.protection.outlook.com ([40.107.14.75]:45168
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726875AbfLPJRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 04:17:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clJTtacOj0JPvAuFjwENiWKkU9IeweXt/skTQFY/XQ5vM7DvjI4NjcDZt2AkxZLynLch/hlviGimkUW28ZCKRbbXqeE80yzsxudXw2oIqp7KJpeoNDzFwqnvF/3jtg6gyIBTrx08xmlGIM+Z4yb8m/rIMaHzTiCPizrqdWaCTf07OptCDx8TyN7UEulb78Mn8bZSXDZHGEZL1doi0sAindra/sM5YdpzWec+QFbBYrCztjhgDTS/+RzsZ4/9U0Cmp2V5YJSX2qqkEUGcnYjJjV//+nTw76rDkeLOjv6vVHwBmvFqpR+i1fogNIRXqugt+wer7B7brIfrKSBEBl6DEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0aa5tqvNJdjQ0mIWMHPH99tHOx4Iw44ovZTAxGEmrw=;
 b=aLd3nB/NII1vscAt8JLHGE6caFxYe3RE/8XwrUtQKuArOnL2T1NROV2nyl9jEotWKMhqWAETOTW8QvMyHH804yBL5cG9WxiITGfWHgNRGc3unF3bHufg1XidqPFNK0OB8V5KSkMB6TWJwnS1WrlyH8ckcvpXOcxKGT7Ax/abSgEpqk7XSvLQZZMFFCujYLh1D9bBPJI8SmXMzdPADFtdbFRc8RYEAGs4rWvVOo4jE/CYviS2RNPyzfofdwDMoWz/ptnWFzhVStZ835hgRgj5Bc0i1NDBDrhcuDhdDivJoZcGnpAdBJRsGvxRFrDDmnzOstIjNXbOUloh8eX5Pt5ymA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0aa5tqvNJdjQ0mIWMHPH99tHOx4Iw44ovZTAxGEmrw=;
 b=XYBfc7WHN7QtJ5FWlMRPrJgIIkS17x86NyC84DLAZqq2z3P0q1KvQymJcVxRMSTHyIuumfoqC+dIXWx2r/msJYyRfQygmgj3lDmko1nc71VlW5fRS1DNX+y5fYUkFgUHmV6chppyD6j0S5PC86q+G1IwjoWXWuHYKbpNq8EcaHU=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5922.eurprd05.prod.outlook.com (20.178.119.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 09:17:29 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 09:17:28 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Thread-Topic: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Thread-Index: AQHVruL03dhci0tJKEiwh8p1eIZoWaezgmKAgAinFoCAADnbgIAAFpiAgAAGYgCAAAUzAA==
Date:   Mon, 16 Dec 2019 09:17:28 +0000
Message-ID: <6c48fe0d-9ddf-ef29-7d5f-0a77944c61b2@mellanox.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
 <20191210153959.GD4053085@kroah.com>
 <4b7ee2ce-1415-7c58-f00e-6fdad08c1e99@mellanox.com>
 <20191216071509.GA916540@kroah.com>
 <b1242f0f-c34d-e6af-1731-fec9c947c478@mellanox.com>
 <20191216085852.GA1139951@kroah.com>
In-Reply-To: <20191216085852.GA1139951@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.20.239]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5dd46d94-254a-4e67-c873-08d78208c605
x-ms-traffictypediagnostic: AM0PR05MB5922:
x-microsoft-antispam-prvs: <AM0PR05MB59225005EA0C2D6DFF6C9EA7D1510@AM0PR05MB5922.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(189003)(199004)(55236004)(76116006)(91956017)(64756008)(53546011)(2616005)(6506007)(2906002)(26005)(478600001)(36756003)(54906003)(86362001)(7416002)(71200400001)(8676002)(81156014)(31686004)(6512007)(8936002)(81166006)(4326008)(186003)(6486002)(66946007)(31696002)(6916009)(66446008)(66556008)(66476007)(316002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5922;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yo5rv62yW+8hhgFkEOmo6mekLk6MT53Y9oa4lEZ9h+Q0YluaQsvKmDxrqOnLwAOslbisI6nMwfCLPQ3L+m1YcKfVL94gQC8fYo0Psn52eOWFs/snITdu+QcysV7Vta6yX7XfkOf1guLPgWTxSOoqMPiciBhzjV9abg1B6qGMkQ5TtzvC9SI1UMzncTpMtOyLkj8Xu/ofyh6AbIRGEtZrR7lu6Mg7s/5orUUVZPnr4SNEKGrPgu/+AOqvSWLUyGr08nnDAZI+trOHPyCoPHTiCm/ITKqBGihLNHONzgAZRdcmqycTInJ3ZU8W/MY99cmbQQRLlZA28Nhge1WUO+4TsjX2jtLAieO6ybYEG/dvGgojiex4B/tZ/kS7ibkq/bLHPsCUVDhWMWHWV3DMaEJ1b0kmU3S4JUYEWf3NrzbUYaN6jh3DqFvbp7JNrYCbgVQf
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A59ACFA9652D914A9AF937EF91B7482A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd46d94-254a-4e67-c873-08d78208c605
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 09:17:28.8202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CwjG7Shg8SOawhSJcUtPM9w4Ke1hwljp955xqasc8PUtokS3fgEpNlrmeeVaGvKBI/mLlhl0RiHnqmGQPqSb/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5922
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTYvMjAxOSAyOjI4IFBNLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBNb24sIERlYyAxNiwg
MjAxOSBhdCAwODozNjowMkFNICswMDAwLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+PiBPbiAxMi8x
Ni8yMDE5IDEyOjQ1IFBNLCBHcmVnIEtIIHdyb3RlOg0KPj4+IE9uIE1vbiwgRGVjIDE2LCAyMDE5
IGF0IDAzOjQ4OjA1QU0gKzAwMDAsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4+IFsuLl0NCj4+Pj4+
IEkgZmVlbCBsaWtlIHRoZSB2aXJ0dWFsIGJ1cyBjb2RlIGlzIGdldHRpbmcgYmV0dGVyLCBidXQg
dGhpcyB1c2Ugb2YgdGhlDQo+Pj4+PiBjb2RlLCB1bSwgbm8sIG5vdCBvay4NCj4+Pj4+DQo+Pj4+
PiBFaXRoZXIgd2F5LCB0aGlzIHNlcmllcyBpcyBOT1QgcmVhZHkgdG8gYmUgbWVyZ2VkIGFueXdo
ZXJlLCBwbGVhc2UgZG8NCj4+Pj4+IG5vdCB0cnkgdG8gcnVzaCB0aGluZ3MuDQo+Pj4+Pg0KPj4+
Pj4gQWxzbywgd2hhdCBldmVyIGhhcHBlbmVkIHRvIG15ICJZT1UgQUxMIE1VU1QgQUdSRUUgVE8g
V09SSyBUT0dFVEhFUiINCj4+Pj4+IHJlcXVpcmVtZW50IGJldHdlZW4gdGhpcyBncm91cCwgYW5k
IHRoZSBvdGhlciBncm91cCB0cnlpbmcgdG8gZG8gdGhlDQo+Pj4+PiBzYW1lIHRoaW5nPyAgSSB3
YW50IHRvIHNlZSBzaWduZWQtb2ZmLWJ5IGZyb20gRVZFUllPTkUgaW52b2x2ZWQgYmVmb3JlDQo+
Pj4+PiB3ZSBhcmUgZ29pbmcgdG8gY29uc2lkZXIgdGhpcyB0aGluZy4NCj4+Pj4NCj4+Pj4gSSBh
bSB3b3JraW5nIG9uIFJGQyB3aGVyZSBQQ0kgZGV2aWNlIGlzIHNsaWNlZCB0byBjcmVhdGUgc3Vi
LWZ1bmN0aW9ucy4NCj4+Pj4gRWFjaCBzdWItZnVuY3Rpb24vc2xpY2UgaXMgY3JlYXRlZCBkeW5h
bWljYWxseSBieSB0aGUgdXNlci4NCj4+Pj4gVXNlciBnaXZlcyBzZi1udW1iZXIgYXQgY3JlYXRp
b24gdGltZSB3aGljaCB3aWxsIGJlIHVzZWQgZm9yIHBsdW1iaW5nIGJ5DQo+Pj4+IHN5c3RlbWQv
dWRldiwgZGV2bGluayBwb3J0cy4NCj4+Pg0KPj4+IFRoYXQgc291bmRzIGV4YWN0bHkgd2hhdCBp
cyB3YW50ZWQgaGVyZSBhcyB3ZWxsLCByaWdodD8NCj4+DQo+PiBOb3QgZXhhY3RseS4NCj4+IEhl
cmUsIGluIGk0MCB1c2UgY2FzZSAtIHRoZXJlIGlzIGEgUENJIGZ1bmN0aW9uLg0KPj4gVGhpcyBQ
Q0kgZnVuY3Rpb24gaXMgdXNlZCBieSB0d28gZHJpdmVyczoNCj4+ICgxKSB2ZW5kb3JfZm9vX25l
dGRldi5rbyBjcmVhdGluZyBOZXRkZXZpY2UgKGNsYXNzIG5ldCkNCj4+ICgyKSB2ZW5kb3JfZm9v
X3JkbWEua28gY3JlYXRpbmcgUkRNQSBkZXZpY2UgKGNsYXNzIGluZmluaWJhbmQpDQo+Pg0KPj4g
QW5kIGJvdGggZHJpdmVycyBhcmUgbm90aWZpZWQgdXNpbmcgbWF0Y2hpbmcgc2VydmljZSB2aXJ0
YnVzLCB3aGljaA0KPj4gYXR0ZW1wdHMgdG8gY3JlYXRlIHRvIHR3byB2aXJ0YnVzX2RldmljZXMg
d2l0aCBkaWZmZXJlbnQgZHJpdmVyLWlkLCBvbmUNCj4+IGZvciBlYWNoIGNsYXNzIG9mIGRldmlj
ZS4NCj4gDQo+IFllcywgdGhhdCBpcyBmaW5lLg0KPiANCj4+IEhvd2V2ZXIsIGRldmljZXMgb2Yg
Ym90aCBjbGFzcyAobmV0LCBpbmZpbmliYW5kKSB3aWxsIGhhdmUgcGFyZW50IGRldmljZQ0KPj4g
YXMgUENJIGRldmljZS4NCj4gDQo+IFRoYXQgaXMgZmluZS4NCj4gDQo+PiBJbiBjYXNlIG9mIHN1
Yi1mdW5jdGlvbnMsIGNyZWF0ZWQgcmRtYSBhbmQgbmV0ZGV2aWNlIHdpbGwgaGF2ZSBwYXJlbnQg
YXMNCj4+IHRoZSBzdWItZnVuY3Rpb24gJ3N0cnVjdCBkZXZpY2UnLiBUaGlzIHdheSB0aG9zZSBT
RnMgZ2V0cyB0aGVpcg0KPj4gc3lzdGVtZC91ZGV2IHBsdW1iaW5nIGRvbmUgcmlnaHRseS4NCj4g
DQo+IGh1aD8gIFRoZSByZG1hIGFuZCBuZXRkZXZpY2Ugd2lsbCBoYXZlIGFzIHRoZWlyIHBhcmVu
dCBkZXZpY2UgdGhlDQo+IHZpcnRkZXZpY2UgdGhhdCBpcyBvbiB0aGUgdmlydGJ1cy4gIE5vdCB0
aGUgUENJIGRldmljZSdzICdzdHJ1Y3QNCj4gZGV2aWNlJy4NCj4gDQpZZXMuIEkgbWVhbnQgc2Ft
ZSB3aGVuIEkgc2FpZCAic3ViLWZ1bmN0aW9uICdzdHJ1Y3QgZGV2aWNlJyIsIHdoaWNoIGlzDQpu
b3RoaW5nIGJ1ZyBhIHZpcnRkZXZpY2UuDQoNCm9rLiBHcmVhdC4gV2UgYXJlIG9uIHNhbWUgcGFn
ZSBub3cuDQoNCkFzIHdlIGRpc2N1c3NlZCwgaWYgc3ViLWZ1bmN0aW9ucyB1c2VzIHRoZSBidXMs
IGl0IHdpbGwgdXNlIHRoZSB2aXJ0YnVzDQphbmQgdmlydGRldmljZSBkZXZpY2Ugd2l0aCBhYm92
ZSBkaXNjdXNzZWQgZGlmZmVyZW5jZXMuDQpPbmNlIEkgZmluaXNoIGludGVybmFsIFJGQyByZXZp
ZXcgZm9yIHN1Yi1mdW5jdGlvbnMsIHdpbGwgcG9zdCBpdCBvbiB0aGUNCmxpc3QuDQpJIGRvIG5v
dCBleHBlY3QgUkZDIHRvIGZpbmlzaCBiZWZvcmUgQ2hyaXN0bWFzIGhvbGlkYXlzLg0KDQpUaGFu
a3MsDQpQYXJhdg0KDQo+IHRoYW5rcywNCj4gDQo+IGdyZWcgay1oDQo+IA0KDQo=
