Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20ACB1000CC
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfKRIyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:54:19 -0500
Received: from mail-eopbgr60062.outbound.protection.outlook.com ([40.107.6.62]:1358
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726371AbfKRIyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 03:54:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4TjTRPEMZFtOZU2BtxLiENuOWrhIkgUMuw5QiwCK3dauigFXo5NPvFYLRTGhkweBhynDRSgKlWxXe9tQBwVxLbqATgCoc7juepc8v63Cw5btFxur09M80UfhKOzRksfpM+wSMMSEJPwt/f+i9ToI/Mlg/ISMY2/KsZcxmh3d5INJ6cD8ItsswMfFY0WPcMJVsID/xLgLVdi+B3byqAqPM/831S4fJq19c/ApP8EWXcHCerzovou+L9CRWYzi6F0Db0JOuno6WffZMmHsPIvpHyf1i4mF4vqTfqQQyMSWfeC0iZxOxXxFyQbmZtBAVr6vgXG0FWXisPH9NcDEmRqew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRtOagBVXfx3t6PsKh8mHHsaeyLQ6+SgHz4jj36/8JY=;
 b=WQFj7zIssIO/9cmXElcx5aJGY9RHittwBnPAW1bfIdrKMexVwBd0y5dgNjHN13tSfCYm+nki9F4sC98YeVt7LVyRvogewi28Aq0rzyzqlqZCpF1qhLkSChBV32rd5Ja4ThjrJZ/E/XwGYWONvvwQFTs60XbF+A0J0MG8vbSb2epdpeCjd66eQdH53ZESvAX82aQs9cYtf+a/gky69Lia2DR1dssCbq+YeVKysN6/S7FkT7tNatG2fYSXPsN719jPE0/zC95cRu8iBpIkL8JizGwcuygHyZxAiXI+fXfxNv+71kxFKQ8K33VzV5Fd4fFoIxpvf16FEGhxfiihykvWGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRtOagBVXfx3t6PsKh8mHHsaeyLQ6+SgHz4jj36/8JY=;
 b=GFUr3Nnk/ER42/8pV6T1wmDUWDJnw1bkZ3HcJ6pYt78st9ChrpggEq9Bh+usk2F3/Cl8OXM3zqFUOpDruBH2ZveF/nt2oMOkAyufuD4rD6ZZKyepC9qZmafl7vuW7c3klqXbe98x3veTlTMC3cGuiIrQ5lOAtjGiQQebl+FaGv0=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4731.eurprd04.prod.outlook.com (20.176.233.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Mon, 18 Nov 2019 08:54:11 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 08:54:11 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVm3IDm0rriooN3k2DjIsf/kbhcKeL8V8AgAQ78GCAAGYugIAAAcOwgAAGSYCAAARFgA==
Date:   Mon, 18 Nov 2019 08:54:11 +0000
Message-ID: <DB7PR04MB46180F8FDF27E7DAB77206FBE64D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
 <9870ec21-b664-522e-e0df-290ab56fbb32@geanix.com>
 <DB7PR04MB4618220095E1F844A44DB480E64D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <16a0aa7b-875e-8dd9-085c-3341d3f1ac51@geanix.com>
 <DB7PR04MB461895F57FD4F360A723D2FAE64D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <12e03487-d468-c009-72c7-88804e87e256@geanix.com>
In-Reply-To: <12e03487-d468-c009-72c7-88804e87e256@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 244b9858-bdf1-48ab-c135-08d76c04e198
x-ms-traffictypediagnostic: DB7PR04MB4731:|DB7PR04MB4731:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4731145DA23076FE7A8F371AE64D0@DB7PR04MB4731.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(189003)(199004)(13464003)(11346002)(99286004)(5660300002)(81156014)(81166006)(8676002)(8936002)(6116002)(26005)(76116006)(2501003)(14454004)(52536014)(74316002)(7736002)(66446008)(66946007)(66476007)(66556008)(64756008)(186003)(102836004)(53546011)(6506007)(2906002)(33656002)(54906003)(110136005)(256004)(14444005)(76176011)(7696005)(316002)(478600001)(3846002)(446003)(305945005)(476003)(486006)(71190400001)(66066001)(9686003)(86362001)(4326008)(229853002)(55016002)(71200400001)(6436002)(6246003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4731;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hY/FlZaNX6+3oiy3/dsqd27Vk+ZL64qwCXogsquzmssI2RQWzsFqwPSpEiZ2APr8IDsrKgcDMkiua3/wv9ZKiFFecLsezYwGfwRsrl6hwtXV++0UZI0QPwgUbR54f7DAhmGZYTHEuIdus/SH9WLc7Pcz4+erWYCLS6pWO67bZpl6tRylgssz17GhBE8v0p5KbmDKMUsDUWh9RPUdBhOsM81fQN7uy3Odm7SDvwnuToVp/ScR49ZqL6PCjmAgSqmMsAOiTzvKlAOuGM43Sm0uI/6nXSP4AE1gmXfz3ap9PPe9iFr04HU5qDOUmWuvEuL7hNdXHhUV6Hd2H97rLeTZNMmnagNU1yWUFFUJYt8p76VePQgq/XwWyY6CrExIa7UQB/55AuunYtiC7EG1+J8w6jGYW1/W6/FzVW9Y6M1tLS00762Uj5+3jkng0zTy05yQ
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 244b9858-bdf1-48ab-c135-08d76c04e198
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 08:54:11.6318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PHMUPGbGc43nNRI3FWuBboqTkADvvyiPQWt1Rw+JLv/o57VyUrsTbvjxXR+8uO/xI3j8hqCc350GxPdw6ZGuig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4731
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDEx5pyIMTjml6UgMTY6MjINCj4gVG86IEpv
YWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBta2xAcGVuZ3V0cm9uaXguZGUN
Cj4gQ2M6IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmc7IGRsLWxpbnV4LWlteCA8bGludXgtaW14
QG54cC5jb20+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggMS8zXSBjYW46IGZsZXhjYW46IGZpeCBkZWFkbG9jayB3aGVuIHVzaW5nIHNlbGYgd2FrZXVw
DQo+IA0KPiANCj4gDQo+IE9uIDE4LzExLzIwMTkgMDkuMDQsIEpvYWtpbSBaaGFuZyB3cm90ZToN
Cj4gPj4+PiBIaSBKb2FraW0gYW5kIE1hcmMNCj4gPj4+Pg0KPiA+Pj4+IFdlIGhhdmUgcXVpdGUg
YSBmZXcgZGV2aWNlcyBpbiB0aGUgZmllbGQgd2hlcmUgZmxleGNhbiBpcyBzdHVjayBpbg0KPiBT
dG9wLU1vZGUuDQo+ID4+Pj4gV2UgZG8gbm90IGhhdmUgdGhlIHBvc3NpYmlsaXR5IHRvIGNvbGQg
cmVib290IHRoZW0sIGFuZCBob3QgcmVib290DQo+ID4+Pj4gd2lsbCBub3QgZ2V0IGZsZXhjYW4g
b3V0IG9mIHN0b3AtbW9kZS4NCj4gPj4+PiBTbyBmbGV4Y2FuIGNvbWVzIHVwIHdpdGg6DQo+ID4+
Pj4gWyAgMjc5LjQ0NDA3N10gZmxleGNhbjogcHJvYmUgb2YgMjA5MDAwMC5mbGV4Y2FuIGZhaWxl
ZCB3aXRoIGVycm9yDQo+ID4+Pj4gLTExMCBbICAyNzkuNTAxNDA1XSBmbGV4Y2FuOiBwcm9iZSBv
ZiAyMDk0MDAwLmZsZXhjYW4gZmFpbGVkIHdpdGgNCj4gPj4+PiBlcnJvciAtMTEwDQo+ID4+Pj4N
Cj4gPj4+PiBUaGV5IGFyZSBvbiwgZGUzNTc4YzE5OGM2ICgiY2FuOiBmbGV4Y2FuOiBhZGQgc2Vs
ZiB3YWtldXAgc3VwcG9ydCIpDQo+ID4+Pj4NCj4gPj4+PiBXb3VsZCBpdCBiZSBhIHNvbHV0aW9u
IHRvIGFkZCBhIGNoZWNrIGluIHRoZSBwcm9iZSBmdW5jdGlvbiB0byBwdWxsDQo+ID4+Pj4gaXQg
b3V0IG9mIHN0b3AtbW9kZT8NCj4gPj4+DQo+ID4+PiBIaSBTZWFuLA0KPiA+Pj4NCj4gPj4+IFNv
ZnQgcmVzZXQgY2Fubm90IGJlIGFwcGxpZWQgd2hlbiBjbG9ja3MgYXJlIHNodXQgZG93biBpbiBh
IGxvdyBwb3dlcg0KPiBtb2RlLg0KPiA+PiBUaGUgbW9kdWxlIHNob3VsZCBiZSBmaXJzdCByZW1v
dmVkIGZyb20gbG93IHBvd2VyIG1vZGUsIGFuZCB0aGVuIHNvZnQNCj4gPj4gcmVzZXQgY2FuIGJl
IGFwcGxpZWQuDQo+ID4+PiBBbmQgZXhpdCBmcm9tIHN0b3AgbW9kZSBoYXBwZW5zIHdoZW4gdGhl
IFN0b3AgbW9kZSByZXF1ZXN0IGlzDQo+ID4+PiByZW1vdmVkLA0KPiA+PiBvciB3aGVuIGFjdGl2
aXR5IGlzIGRldGVjdGVkIG9uIHRoZSBDQU4gYnVzIGFuZCB0aGUgU2VsZiBXYWtlIFVwDQo+ID4+
IG1lY2hhbmlzbSBpcyBlbmFibGVkLg0KPiA+Pj4NCj4gPj4+IFNvIGZyb20gbXkgcG9pbnQgb2Yg
dmlldywgd2UgY2FuIGFkZCBhIGNoZWNrIGluIHRoZSBwcm9iZSBmdW5jdGlvbg0KPiA+Pj4gdG8g
cHVsbCBpdCBvdXQgb2Ygc3RvcCBtb2RlLCBzaW5jZSBjb250cm9sbGVyIGFjdHVhbGx5IGNvdWxk
IGJlDQo+ID4+PiBzdHVjayBpbiBzdG9wIG1vZGUNCj4gPj4gaWYgc3VzcGVuZC9yZXN1bWUgZmFp
bGVkIGFuZCB1c2VycyBqdXN0IHdhbnQgYSB3YXJtIHJlc2V0IGZvciB0aGUgc3lzdGVtLg0KPiA+
Pg0KPiA+PiBFeGFjdGx5IHdoYXQgSSB0aG91Z2h0IGNvdWxkIGJlIGRvbmUgOikNCj4gPj4NCj4g
Pj4+DQo+ID4+PiBDb3VsZCB5b3UgcGxlYXNlIHRlbGwgbWUgaG93IGNhbiBJIGdlbmVyYXRlIGEg
d2FybSByZXNldD8gQUZBSUssDQo+ID4+PiBib3RoDQo+ID4+ICJyZWJvb3QiIGNvbW1hbmQgcHV0
IGludG8gcHJvbXB0IGFuZCBSU1QgS0VZIGluIG91ciBFVksgYm9hcmQgYWxsDQo+ID4+IHBsYXkg
YSByb2xlIG9mIGNvbGQgcmVzZXQuDQo+ID4+DQo+ID4+IFdhcm0gcmVzZXQgaXMganVzdCBgcmVi
b290YCA6LSkgQ29sZCBpcyBwb3dlcm9mZi4uLg0KPiA+DQo+ID4gSSBhZGQgdGhlIGNvZGUgZmxl
eGNhbl9lbnRlcl9zdG9wX21vZGUocHJpdikgYXQgdGhlIGVuZCBvZiB0aGUgcHJvYmUNCj4gZnVu
Y3Rpb24sICdyZWJvb3QnIHRoZSBzeXN0ZW0gZGlyZWN0bHkgYWZ0ZXIgc3lzdGVtIGFjdGl2ZS4N
Cj4gPiBIb3dldmVyLCBJIGRvIG5vdCBtZWV0IHRoZSBwcm9iZSBlcnJvciwgaXQgY2FuIHByb2Jl
IHN1Y2Nlc3NmdWxseS4gRG8geW91DQo+IGtub3cgdGhlIHJlYXNvbj8NCj4gDQo+IFlvdSB3aWxs
IGhhdmUgdG8gZ2V0IGl0IGluIHRoZSBkZWFkbG9jayBzaXR1YXRpb24gZmlyc3QgOikNCg0KQXMg
eW91IHNhaWQsIGlmIHdlIG5lZWQgZ2V0IGl0IGludG8gdGhlIGRlYWRsb2NrIHNpdHVhdGlvbiBm
aXJzdCwgdGhlbiB0aGlzIHBhdGNoIGhhcyBmaXhlZCBpdCwgdGhhdCBtZWFucyB0aGUgcHJvYmxl
bSBnb2VzIGF3YXk/DQoNCldpdGggdGhpcyBwYXRjaCwgaWYgQ0FOIGVudGVyIHN0b3AgbW9kZSB3
aGVuIHN1c3BlbmQsIGl0IGNlcnRhaW5seSBjYW4gZXhpdCBzdG9wIG1vZGUgd2hlbiByZXN1bWUu
IFVubGVzcyBzdWNoIGFjdGl2aXR5IG9jY3VycywgQ0FOIGVudGVyDQpzdG9wIG1vZGUsIGhvd2V2
ZXIgc3lzdGVtIGhhbmcgYmVmb3JlIGl0IGV4aXQgc3RvcCBtb2RlLiBSaWdodD8gDQpTbyBJIGRv
IG5vdCBrbm93IGhvdyB0byByZXByb2R1Y2UgdGhpcyBpc3N1ZSBhZnRlciBhcHBseWluZyB0aGlz
IHBhdGNoLiANCg0KQW5kIHRoZSBjYXNlIEkgbWVudGlvbmVkIGluIGxhc3QgcmVzcG9uc2UsIENB
TiBlbnRlciBzdG9wIG1vZGUgYXQgdGhlIGVuZCBvZiBwcm9iZSBmdW5jdGlvbiwgdGhlbiAicmVi
b290IiB0aGUgc3lzdGVtIHNob3VsZCBiZSB0aGUgc2FtZSBzaXR1YXRpb24NCndpdGggIiBUaGlz
IGNhbiBiZSBhY2hpZXZlZCBieSB1c2luZyBkZTM1NzhjMTk4YzYgYW5kIHNlbmRpbmcgY2FuIG1l
c3NhZ2VzIHRvIGJvdGggY2FuIGludGVyZmFjZXMgd2hpbGUgY2FsbGluZyBzdXNwZW5kLiIgVGhl
IGFpbSBpcyBib3RoIHRoYXQgbGV0IGNvbnRyb2xsZXINCmVudGVyIHN0b3AgbW9kZSwgdGhlbiAn
cmVib290JyB0aGUgc3lzdGVtLiBSaWdodD8NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5n
DQo+IFRoaXMgY2FuIGJlIGFjaGlldmVkIGJ5IHVzaW5nIGRlMzU3OGMxOThjNiBhbmQgc2VuZGlu
ZyBjYW4gbWVzc2FnZXMgdG8gYm90aA0KPiBjYW4gaW50ZXJmYWNlcyB3aGlsZSBjYWxsaW5nIHN1
c3BlbmQuDQo+IA0KPiAvU2Vhbg0K
