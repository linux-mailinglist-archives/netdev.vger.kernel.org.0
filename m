Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C267A14AFFE
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 08:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgA1HCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 02:02:49 -0500
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:50949
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725799AbgA1HCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 02:02:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5iigP6q+k7k9o4J2zLRSgRFNiKF8plczlyJley3IPI+bBN//VT0+y5APEWRSvSmOeuTTq4CcXET0q+N5sWQhCu2IlruPIOq1DosOcM7/hMgJ4PT7sjabuVj/d4JJGLTbuZQ8lPF/Iqwa0yCgmy9RsraFB9JuVPVY0DcL+cLN3SLESoAeiLaxOKEVZi0QUPuVPBnaMmbaiIh/UyXb9Do4tTmJmc5PZ81TPgbgAsATlN1L1o37p1TLfT41PgNP9VDgf6XXXE1J/eTC2Ti0I3pm2nNp5xpemqv2N3J5rH0fSX5grHoVkmg7cX4ERwNGEJ97r9lbxT9re5zx0CwoEmK3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hi9lpaOWvViJMVQZRzSNwrP45bWiZ4MhKZWf71czUso=;
 b=SZhed8qdRsfOHNXr2vmcw7SOKUcxKQQLieBa3pERk9Uh6LBKXzI+0Evhxs7SovQj3lnz1ysY9VIYSea1OdTsFGXgAaL+YuxUI+xeayos8PpOPQV/iHyi9A2MqdZmH60yP2f6W9kxHsM/SSHG45jKxnPRJSoHd8wDeu72sZ0WoY0oUfuKe5nG9y7w4cjIitd4ti0/vBYgMLktanqiInzrukwQSkqpty5xgqw8pRu7A4j26DDMEsnMc84uW6QJuhgsmlH30i+fSFLmsewtNe3ZzrjY/p1Pn2OkiUKD1OKeNtLJFY4cKhcMHTUjtjN25PVuH2T75zTns+VryzGgCB7Y5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hi9lpaOWvViJMVQZRzSNwrP45bWiZ4MhKZWf71czUso=;
 b=SkTx7xlZNDH7mVXbgTUG1Kas3nPzybpRjYmeF9lc3EYaGEM3tgmQkpfFM64o+NVNEGZnXXDeOSxQSb+DUd2d8j/X86Y2SqobZzHp4TdtHLiFfUyhsEA0Y5T82B8gxmB9Ix2Xsx8159ZbhKeUWxBy5cSaFnyrjZ1Cjkn+LfE/fvE=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6779.eurprd04.prod.outlook.com (52.133.242.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.23; Tue, 28 Jan 2020 07:02:44 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2665.026; Tue, 28 Jan 2020
 07:02:44 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>
Subject: RE: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Thread-Topic: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Thread-Index: AQHV0Sw23V0HaV1F6UKjzaVeqBvXWaf2+L4AgADjpXCABvOdgIAA2nOA
Date:   Tue, 28 Jan 2020 07:02:44 +0000
Message-ID: <DB8PR04MB6985B1D84CD954E7DE5FE34FEC0A0@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
 <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com>
 <DB8PR04MB6985606F38572D8512E8D27EEC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <77e3ddcb-bddb-32d8-9c87-48ba9a7f2773@gmail.com>
In-Reply-To: <77e3ddcb-bddb-32d8-9c87-48ba9a7f2773@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3b6a80f0-dad2-4423-bf04-08d7a3c0132d
x-ms-traffictypediagnostic: DB8PR04MB6779:|DB8PR04MB6779:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB67791D40914D1A837525F510AD0A0@DB8PR04MB6779.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 029651C7A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(199004)(189003)(5660300002)(9686003)(54906003)(55016002)(110136005)(478600001)(8676002)(26005)(186003)(6506007)(53546011)(81166006)(81156014)(7696005)(8936002)(316002)(4326008)(2906002)(66556008)(64756008)(66446008)(66476007)(71200400001)(86362001)(33656002)(52536014)(66946007)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6779;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ghPdq1pEPbKNaHoHxrpFQyJfA8H09t+dJ9V8nl2aDuY3i7zCOGv7xPyvJGodXMWcjLdVg+PDpKg3ojGXgl/9GHPw4IBdoCEC6/EEGtkr5uwxMK7geHEadkGAMQPKKHHq2/LzsVYkOokAmaN1z58oUrZZ+bOZtMEuQrchr8Uk8RydNEJTKWW3d4Qqf/6gADaf30v1oi7IEHBKJWIX8PlUiBZqwx6iSVyz2QPVvCMW8e35ikpW0+4IbppqZJq0i22qeXZdmVAZ/1268EgkTAKVlB8nvNFWHtN155lXZfFzJvFXwalb6hSfCB9OJ5EDmSvBJ1/LmhNWdiSXfNSAqHNhv8IGuoe2irlj8o+KfXu1mBfPH7a4n576kCyAb/8putT1k6e+HyFZT5+0ojG0g7aFyqzkba1C4x3CNMw5+UtT8ObKdqzBBOqWqiypDiTitwJ9
x-ms-exchange-antispam-messagedata: 5+2r3tEoChjT/FS4m/KA1rPVGt455s2QCmFPV/QWUrVNkOYwDWMH5pdBn0mkOiPd4f4c84xHJyXs20SOdJFX01ZCj8A6NQEvCjVsQTRP4wjz25Ns75RVD0CD94hW3T2BkSoK74V7Ir4G5gXy27ocew==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b6a80f0-dad2-4423-bf04-08d7a3c0132d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2020 07:02:44.6609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +XLxbTc6bx1b0lI3cR96Le0QT6BRfDKco7GzvZp89EIVp+oSEtim+WAlsHTY02QIf51HN5Df8nXXFOyDD4S8YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6779
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGbG9yaWFuIEZhaW5lbGxpIDxm
LmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBKYW51YXJ5IDI3LCAyMDIwIDc6
NDMgUE0NCj4gVG86IE1hZGFsaW4gQnVjdXIgKE9TUykgPG1hZGFsaW4uYnVjdXJAb3NzLm54cC5j
b20+OyBkYXZlbUBkYXZlbWxvZnQubmV0DQo+IENjOiBhbmRyZXdAbHVubi5jaDsgaGthbGx3ZWl0
MUBnbWFpbC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IHlrYXVrYWJAc3VzZS5kZQ0K
PiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDEvMl0gbmV0OiBwaHk6IGFxdWFudGlhOiBh
ZGQgcmF0ZV9hZGFwdGF0aW9uDQo+IGluZGljYXRpb24NCj4gDQo+IE9uIDEvMjIvMjAgMTE6Mzgg
UE0sIE1hZGFsaW4gQnVjdXIgKE9TUykgd3JvdGU6DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQo+ID4+IEZyb206IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29t
Pg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIEphbnVhcnkgMjIsIDIwMjAgNzo1OCBQTQ0KPiA+PiBU
bzogTWFkYWxpbiBCdWN1ciAoT1NTKSA8bWFkYWxpbi5idWN1ckBvc3MubnhwLmNvbT47DQo+IGRh
dmVtQGRhdmVtbG9mdC5uZXQNCj4gPj4gQ2M6IGFuZHJld0BsdW5uLmNoOyBoa2FsbHdlaXQxQGdt
YWlsLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gPj4geWthdWthYkBzdXNlLmRlDQo+
ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IHBoeTogYXF1YW50aWE6
IGFkZA0KPiByYXRlX2FkYXB0YXRpb24NCj4gPj4gaW5kaWNhdGlvbg0KPiA+Pg0KPiA+PiBPbiAx
LzIyLzIwIDU6NTkgQU0sIE1hZGFsaW4gQnVjdXIgd3JvdGU6DQo+ID4+PiBUaGUgQVFSIFBIWXMg
YXJlIGFibGUgdG8gcGVyZm9ybSByYXRlIGFkYXB0YXRpb24gYmV0d2Vlbg0KPiA+Pj4gdGhlIHN5
c3RlbSBpbnRlcmZhY2UgYW5kIHRoZSBsaW5lIGludGVyZmFjZXMuIFdoZW4gc3VjaA0KPiA+Pj4g
YSBQSFkgaXMgZGVwbG95ZWQsIHRoZSBldGhlcm5ldCBkcml2ZXIgc2hvdWxkIG5vdCBsaW1pdA0K
PiA+Pj4gdGhlIG1vZGVzIHN1cHBvcnRlZCBvciBhZHZlcnRpc2VkIGJ5IHRoZSBQSFkuIFRoaXMg
cGF0Y2gNCj4gPj4+IGludHJvZHVjZXMgdGhlIGJpdCB0aGF0IGFsbG93cyBjaGVja2luZyBmb3Ig
dGhpcyBmZWF0dXJlDQo+ID4+PiBpbiB0aGUgcGh5X2RldmljZSBzdHJ1Y3R1cmUgYW5kIGl0cyB1
c2UgZm9yIHRoZSBBcXVhbnRpYQ0KPiA+Pj4gUEhZcy4NCj4gPj4+DQo+ID4+PiBTaWduZWQtb2Zm
LWJ5OiBNYWRhbGluIEJ1Y3VyIDxtYWRhbGluLmJ1Y3VyQG9zcy5ueHAuY29tPg0KPiA+Pj4gLS0t
DQo+ID4+PiAgZHJpdmVycy9uZXQvcGh5L2FxdWFudGlhX21haW4uYyB8IDMgKysrDQo+ID4+PiAg
aW5jbHVkZS9saW51eC9waHkuaCAgICAgICAgICAgICB8IDMgKysrDQo+ID4+PiAgMiBmaWxlcyBj
aGFuZ2VkLCA2IGluc2VydGlvbnMoKykNCj4gPj4+DQo+ID4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvcGh5L2FxdWFudGlhX21haW4uYw0KPiA+PiBiL2RyaXZlcnMvbmV0L3BoeS9hcXVhbnRp
YV9tYWluLmMNCj4gPj4+IGluZGV4IDk3NTc4OWQ5MzQ5ZC4uMzZmZGQ1MjNiNzU4IDEwMDY0NA0K
PiA+Pj4gLS0tIGEvZHJpdmVycy9uZXQvcGh5L2FxdWFudGlhX21haW4uYw0KPiA+Pj4gKysrIGIv
ZHJpdmVycy9uZXQvcGh5L2FxdWFudGlhX21haW4uYw0KPiA+Pj4gQEAgLTIwOSw2ICsyMDksOSBA
QCBzdGF0aWMgaW50IGFxcl9jb25maWdfYW5lZyhzdHJ1Y3QgcGh5X2RldmljZQ0KPiA+PiAqcGh5
ZGV2KQ0KPiA+Pj4gIAl1MTYgcmVnOw0KPiA+Pj4gIAlpbnQgcmV0Ow0KPiA+Pj4NCj4gPj4+ICsJ
LyogYWRkIGhlcmUgYXMgdGhpcyBpcyBjYWxsZWQgZm9yIGFsbCBkZXZpY2VzICovDQo+ID4+PiAr
CXBoeWRldi0+cmF0ZV9hZGFwdGF0aW9uID0gMTsNCj4gPj4NCj4gPj4gSG93IGFib3V0IGludHJv
ZHVjaW5nIGEgbmV3IFBIWV9TVVBQT1JUU19SQVRFX0FEQVBUQVRJT04gZmxhZyBhbmQgeW91DQo+
ID4+IHNldCB0aGF0IGRpcmVjdGx5IGZyb20gdGhlIHBoeV9kcml2ZXIgZW50cnk/IHVzaW5nIHRo
ZSAiZmxhZ3MiIGJpdG1hc2sNCj4gPj4gaW5zdGVhZCBvZiBhZGRpbmcgYW5vdGhlciBzdHJ1Y3R1
cmUgbWVtYmVyIHRvIHBoeV9kZXZpY2U/DQo+ID4NCj4gPiBJJ3ZlIGxvb2tlZCBhdCB0aGUgcGh5
ZGV2LT5kZXZfZmxhZ3MgdXNlLCBpdCBzZWVtZWQgdG8gbWUgdGhhdCBtb3N0bHkgaXQNCj4gPiBp
cyB1c2VkIHRvIGNvbnZleSBjb25maWd1cmF0aW9uIG9wdGlvbnMgdG93YXJkcyB0aGUgUEhZLg0K
PiANCj4gWW91IHJlYWQgbWUgaW5jb3JyZWN0bHksIEkgYW0gc3VnZ2VzdGluZyB1c2luZyB0aGUg
cGh5X2RyaXZlcjo6ZmxhZ3MNCj4gbWVtYmVyLCBub3QgdGhlIHBoeV9kZXZpY2U6OmRldl9mbGFn
cyBlbnRyeSwgcGxlYXNlIHJlLWNvbnNpZGVyIHlvdXINCj4gcG9zaXRpb24uDQoNClNvcnJ5LCBJ
IHdhcyBsb29raW5nIGF0IHRoZSB3cm9uZyBmbGFncyAodGhpbmtpbmcgdGhpcyBpcyBhIFBIWSBk
ZXZpY2UgZmVhdHVyZSwNCm5vdCBhIFBIWSBkcml2ZXIgZmVhdHVyZSkuDQoNCkkndmUgbG9va2Vk
IGF0IFBIWV9JU19JTlRFUk5BTCBhcyBhIHJlZmVyZW5jZSBhbmQgZm91bmQgaXQncyB1c2VkIGxp
a2UgdGhpczoNCg0KICAgICAgICBpZiAocGh5ZHJ2LT5mbGFncyAmIFBIWV9JU19JTlRFUk5BTCkN
CiAgICAgICAgICAgICAgICBwaHlkZXYtPmlzX2ludGVybmFsID0gdHJ1ZTsNCg0KaXQganVzdCBn
ZXRzIG1pcnJvcmVkIGluIGEgcGh5X2RldmljZSBiaXQgc28gSSBjb25jbHVkZWQgdGhpcyBiaXQg
Y291bGQgZml0DQp0aGVyZSBqdXN0IGFzIHdlbGwsIHRoYXQncyBob3cgSSBjYW1lIHVwIHdpdGgg
dGhlIGN1cnJlbnQgcHJvcG9zYWwuDQoNClRoZXJlIGlzIGFtcGxlIHNwYWNlIHVudXNlZCBpbiB0
aGUgcGh5X2RyaXZlciBmbGFncywgc28gSSBjYW4gYWRkIHRoZSBiaXQgdGhlcmUuDQpTaG91bGQg
SSBhZGQgYWNjZXNzb3JzIHRvbz8NCg0KPiA+IEFub3RoZXIgcHJvYmxlbQ0KPiA+IGlzIHRoYXQg
aXQncyBtZWFuaW5nIHNlZW1zIHRvIGJlIG9wYXF1ZSwgIFBIWSBzcGVjaWZpYy4gSSB3YW50ZWQg
dG8gYXZvaWQNCj4gPiB0cmFtcGxpbmcgb24gYSBjZXJ0YWluIFBIWSBoYXJkY29kZWQgdmFsdWUg
YW5kIEkgdHVybmVkIG15IGF0dGVudGlvbiB0bw0KPiA+IHRoZSBiaXQgZmllbGRzIGluIHRoZSBw
aHlfZGV2aWNlLiBJIG5vdGljZWQgdGhhdCB0aGVyZSBhcmUgYWxyZWFkeSAxMg0KPiA+IGJpdHMg
c28gZHVlIHRvIGFsaWdubWVudCwgdGhlIGFkZGVkIGJpdCBpcyBub3QgYWRkaW5nIGV4dHJhIHNp
emUgdG8gdGhlDQo+ID4gc3RydWN0Lg0KPiA+DQo+ID4+PiArDQo+ID4+PiAgCWlmIChwaHlkZXYt
PmF1dG9uZWcgPT0gQVVUT05FR19ESVNBQkxFKQ0KPiA+Pj4gIAkJcmV0dXJuIGdlbnBoeV9jNDVf
cG1hX3NldHVwX2ZvcmNlZChwaHlkZXYpOw0KPiA+Pj4NCj4gPj4+IGRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L3BoeS5oIGIvaW5jbHVkZS9saW51eC9waHkuaA0KPiA+Pj4gaW5kZXggZGQ0YTkx
ZjFmZWFhLi4yYTVjMjAyMzMzZmMgMTAwNjQ0DQo+ID4+PiAtLS0gYS9pbmNsdWRlL2xpbnV4L3Bo
eS5oDQo+ID4+PiArKysgYi9pbmNsdWRlL2xpbnV4L3BoeS5oDQo+ID4+PiBAQCAtMzg3LDYgKzM4
Nyw5IEBAIHN0cnVjdCBwaHlfZGV2aWNlIHsNCj4gPj4+ICAJLyogSW50ZXJydXB0cyBhcmUgZW5h
YmxlZCAqLw0KPiA+Pj4gIAl1bnNpZ25lZCBpbnRlcnJ1cHRzOjE7DQo+ID4+Pg0KPiA+Pj4gKwkv
KiBSYXRlIGFkYXB0YXRpb24gaW4gdGhlIFBIWSAqLw0KPiA+Pj4gKwl1bnNpZ25lZCByYXRlX2Fk
YXB0YXRpb246MTsNCj4gPj4+ICsNCj4gPj4+ICAJZW51bSBwaHlfc3RhdGUgc3RhdGU7DQo+ID4+
Pg0KPiA+Pj4gIAl1MzIgZGV2X2ZsYWdzOw0KPiA+Pj4NCj4gPj4NCj4gPj4NCj4gPj4gLS0NCj4g
Pj4gRmxvcmlhbg0KPiANCj4gDQo+IC0tDQo+IEZsb3JpYW4NCg==
