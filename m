Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9B229BF88
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1815525AbgJ0RCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 13:02:55 -0400
Received: from mail-eopbgr670042.outbound.protection.outlook.com ([40.107.67.42]:60224
        "EHLO CAN01-TO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1793661AbgJ0PHo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 11:07:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2RbteVGQA8fJmM2vxsWs28PXcUgGiOHrg4lm1ZC2L2/PMyY7f0Yk3ZuwS+yQPjiq4BPA+7WeNIvLwLD4Xk1fnn6WJLWbKNpnyP9JnuMoId45iZBY9RyvwOgPTQEjm55SkJTqi3HH0gg7Iy6NGj72Exj9vN0h70Ik7JoaVgGXmFr3TAFxRnElqjYHA4BUmSoduSD3Zzku3kp+tEaaJ9rHDVwG+L0QusI9QYJVcCZwwrkoKZCw0iq2RDn3BiBHRnHlJ0HkdktS5PTfz0tR6M3JiXP7Ea1TsAqCmchXvDgPWnWPZgRdDo060CmhwNES43RhphFKfYmhmhjTPt88tLNzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QjGx3wQCeeudIu/bNmM54gQuyuXsX75GI0IH9EqoUg=;
 b=ntmBFtjM6Ih4mfK1o9Wh7tzHSEVT1hQ+8iNCPnZ6UNm+IFrEHzI4Prww3vghkQWOh3pw7iudCbBesoxUiL1Buv/I5/nUw59kiKthzauIeTkNHDYLk8YANZLBzpjNtntH7TK9BUHKcnj8FKhbMCM+FgPVkyttZKnsnUnUs3C/rWTCjL524qIkToG/GHfWSL0M9lRVgBhpAos3ezZYeSlch8BtfmX3G+pCLT91k9lv42QkIWwXCsaLgdP7Yn+8M6opHvah+tPWd9QgJ1IUNtkh07+BC5rMC/od916DxBn2xtFWc86dRvEoEqXNR/oSQTDqcYMqXrROwwhrEjrllgQppQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QjGx3wQCeeudIu/bNmM54gQuyuXsX75GI0IH9EqoUg=;
 b=wQImUWfvZqnN8Old68ZKFhfIwSzCa3e6+ptxB+ADwivz0uCDFFP2FPbr8gUx0Vv5cIs7vNogEspLH5qhJnbXs/XscP5GvfhEVSc2QCnEKor4WIPe5YAT3W9xBqHhOaKizN5ZuWQy66QEu+zSkLHessXTWDfWR53Ou3eRmIPrxTQ=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB2928.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:19::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Tue, 27 Oct
 2020 15:07:38 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 15:07:38 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "radheys@xilinx.com" <radheys@xilinx.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2] net: axienet: Properly handle PCS/PMA PHY for
 1000BaseX mode
Thread-Topic: [PATCH net-next v2] net: axienet: Properly handle PCS/PMA PHY
 for 1000BaseX mode
Thread-Index: AQHWq8E7PUguthtn20CBUMpx0hrAIqmqPA8AgAANWYCAATkXAIAAC88A
Date:   Tue, 27 Oct 2020 15:07:38 +0000
Message-ID: <2375491642cc056d04c2c43fc4d90b8184d86ce1.camel@calian.com>
References: <20201026175535.1332222-1-robert.hancock@calian.com>
         <BYAPR02MB56382BA3CB100008FC02B02BC7190@BYAPR02MB5638.namprd02.prod.outlook.com>
         <afbabf3c247d311e18701b301d32b49919b34017.camel@calian.com>
         <BYAPR02MB5638BE069270D40A3930A4C7C7160@BYAPR02MB5638.namprd02.prod.outlook.com>
In-Reply-To: <BYAPR02MB5638BE069270D40A3930A4C7C7160@BYAPR02MB5638.namprd02.prod.outlook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-12.el8) 
authentication-results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2acf05fa-9bfd-4f58-3be5-08d87a8a0b6b
x-ms-traffictypediagnostic: YTBPR01MB2928:
x-microsoft-antispam-prvs: <YTBPR01MB2928F0565C676D3BE1ED5F64EC160@YTBPR01MB2928.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fsepDu86VXcN4MBBd1H12BRE/9jh/A0cfRQKCLiFj9jqQI1Mq9agLTOIoYmNhjTnuQJzDhWZzzfBR94iUUTu/ZB+ZFJ96TewWkd8OHlyKPCmyWBst9Qh0igG7Ftmo11k71i0sVAatWyztfD7RI7i3jmT/dTcVLUCKCAgihRQ3nDiemcpC/n8/WKAUi7Eu3FqDZbeLY5GDkS6RxlGrBBsTR/JGrblA6VrLIcC+nX4WLgyX6oSBZjbPBYTHwkg/w6NIrBhjN1IyV8dgya2N5hTAh/+kwK6L9vvQ325d/WTHwmJBA3R0sJMe470M/aRNWCh3639PEnvyg3dubgK5kKTgWfnRrlikJ4cjsQ26U8bPZWXykGvmG2qZ6mPUjJJWdoDaG4xsgKgToxSRJ0iOcKYv+5/pRH/5nBDA25QZakRRFtFy3+Uk6eV22h4AmR5V8IYQGs/CsZWAbzOEAN0wy6ffaZG/PvLyDJ0O4Gva62nQ0Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39850400004)(136003)(396003)(316002)(53546011)(6506007)(6512007)(2906002)(8936002)(186003)(6486002)(44832011)(4001150100001)(86362001)(478600001)(76116006)(66476007)(2616005)(110136005)(54906003)(4326008)(71200400001)(15974865002)(66556008)(66446008)(64756008)(5660300002)(91956017)(36756003)(66946007)(8676002)(83380400001)(26005)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: b/O0YCU/o1XRd8emGUwjZkXRkzpEej+vmerRVUG90R7I2NTLb0ECQjO9fBjI7nzT6zSO5RD8rPuf5CmedEaNCLCpEagY3bO3Ynz/GNR8qngOU/DktLQAx3v1KiTgM/3CPz8Ufu2SAwp5xb7vUUunbUQzIOfmAcjHVSwbkXtHHNmJQ3kF3HMYO4yd/IPV0XnFuKV9afxoUT4eihUFVrgbVAVA1G/K8frtQtV7XcggsXJIqO+55tFVblQzpdPNeHvUEuUYlX4H71u1wf7e3mYgtu1DGuPjdlMhUeCTEqlLt8BUE3wZUgR6skGIBn8nf/ZRX7J6Aa3X5AHhViNsluUrwORLxNMPHMu3syvRyKyIP9hMBB+09237K+Whl5Qw+M8SdsFeDhHmyWqXvdsK+pzv/31+41i+mqFJmYZzzTM/kWfPqwkl5TmUGg4pd2QRFgWVP5sREE5+CaIENVOojvMMVPM/Uzr+3sv9kq1uFwyo7HEgLgwC0LzN931LA/aK4QnzEzMvkXcKCs3rKi6mM2vqNPJPL6rdyiTnOIaNN/GI34F7JL+FxX6od/T185cXoS/Q7v1XhoT3THLJnYLjxghCBjV6XadE0HSSgm9owqJEOrghDxfagpjqox77BJbGST6ftERiSarWW/o4TdBdK7fWXQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <75191AA4B2366746BA2207D77B5DA2A5@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2acf05fa-9bfd-4f58-3be5-08d87a8a0b6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 15:07:38.7468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qDiKSdylMKxycMvz43E+W14+W1uyknfGQldVGSMs4nJ1/By5rMXVyCmRBD3X6331WL73kSgSElDhS1g+lSlzDXTZUukgbNdgFajYuDcT2So=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB2928
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTEwLTI3IGF0IDE0OjI1ICswMDAwLCBSYWRoZXkgU2h5YW0gUGFuZGV5IHdy
b3RlOg0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogUm9iZXJ0IEhh
bmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5jb20+DQo+ID4gU2VudDogVHVlc2RheSwgT2N0
b2JlciAyNywgMjAyMCAxOjE1IEFNDQo+ID4gVG86IFJhZGhleSBTaHlhbSBQYW5kZXkgPHJhZGhl
eXNAeGlsaW54LmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+ID4ga3ViYUBrZXJuZWwub3Jn
DQo+ID4gQ2M6IGxpbnV4QGFybWxpbnV4Lm9yZy51azsgTWljaGFsIFNpbWVrIDxtaWNoYWxzQHhp
bGlueC5jb20+Ow0KPiA+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGFuZHJld0BsdW5uLmNoDQo+
ID4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2Ml0gbmV0OiBheGllbmV0OiBQcm9wZXJs
eSBoYW5kbGUNCj4gPiBQQ1MvUE1BIFBIWQ0KPiA+IGZvciAxMDAwQmFzZVggbW9kZQ0KPiA+IA0K
PiA+IE9uIE1vbiwgMjAyMC0xMC0yNiBhdCAxODo1NyArMDAwMCwgUmFkaGV5IFNoeWFtIFBhbmRl
eSB3cm90ZToNCj4gPiA+IFRoYW5rcyBmb3IgdGhlIHBhdGNoLg0KPiA+ID4gDQo+ID4gPiA+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiA+IEZyb206IFJvYmVydCBIYW5jb2NrIDxy
b2JlcnQuaGFuY29ja0BjYWxpYW4uY29tPg0KPiA+ID4gPiBTZW50OiBNb25kYXksIE9jdG9iZXIg
MjYsIDIwMjAgMTE6MjYgUE0NCj4gPiA+ID4gVG86IFJhZGhleSBTaHlhbSBQYW5kZXkgPHJhZGhl
eXNAeGlsaW54LmNvbT47DQo+ID4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gPiA+ID4ga3ViYUBr
ZXJuZWwub3JnDQo+ID4gPiA+IENjOiBNaWNoYWwgU2ltZWsgPG1pY2hhbHNAeGlsaW54LmNvbT47
IGxpbnV4QGFybWxpbnV4Lm9yZy51azsNCj4gPiA+ID4gYW5kcmV3QGx1bm4uY2g7IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IFJvYmVydCBIYW5jb2NrDQo+ID4gPiA+IDxyb2JlcnQuaGFuY29ja0Bj
YWxpYW4uY29tPg0KPiA+ID4gPiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5leHQgdjJdIG5ldDogYXhp
ZW5ldDogUHJvcGVybHkgaGFuZGxlDQo+ID4gPiA+IFBDUy9QTUENCj4gPiA+ID4gUEhZIGZvcg0K
PiA+ID4gPiAxMDAwQmFzZVggbW9kZQ0KPiA+ID4gPiANCj4gPiA+ID4gVXBkYXRlIHRoZSBheGll
bmV0IGRyaXZlciB0byBwcm9wZXJseSBzdXBwb3J0IHRoZSBYaWxpbngNCj4gPiA+ID4gUENTL1BN
QQ0KPiA+ID4gPiBQSFkNCj4gPiA+ID4gY29tcG9uZW50IHdoaWNoIGlzIHVzZWQgZm9yIDEwMDBC
YXNlWCBhbmQgU0dNSUkgbW9kZXMsDQo+ID4gPiA+IGluY2x1ZGluZw0KPiA+ID4gPiBwcm9wZXJs
eSBjb25maWd1cmluZyB0aGUgYXV0by1uZWdvdGlhdGlvbiBtb2RlIG9mIHRoZSBQSFkgYW5kDQo+
ID4gPiA+IHJlYWRpbmcNCj4gPiA+ID4gdGhlIG5lZ290aWF0ZWQgc3RhdGUgZnJvbSB0aGUgUEhZ
Lg0KPiA+ID4gPiANCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogUm9iZXJ0IEhhbmNvY2sgPHJvYmVy
dC5oYW5jb2NrQGNhbGlhbi5jb20+DQo+ID4gPiA+IC0tLQ0KPiA+ID4gPiANCj4gPiA+ID4gUmVz
dWJtaXQgb2YgdjIgdGFnZ2VkIGZvciBuZXQtbmV4dC4NCj4gPiA+ID4gDQo+ID4gPiA+ICBkcml2
ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXQuaCAgfCAgMyArDQo+ID4gPiA+
ICAuLi4vbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMgfCA5Ng0KPiA+
ID4gPiArKysrKysrKysrKysrKy0NCj4gPiA+ID4gLS0tLQ0KPiA+ID4gPiAgMiBmaWxlcyBjaGFu
Z2VkLCA3MyBpbnNlcnRpb25zKCspLCAyNiBkZWxldGlvbnMoLSkNCj4gPiA+ID4gDQo+ID4gPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXQu
aA0KPiA+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldC5o
DQo+ID4gPiA+IGluZGV4IGYzNGM3OTAzZmY1Mi4uNzMyNmFkNGQ1ZTFjIDEwMDY0NA0KPiA+ID4g
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXQuaA0KPiA+
ID4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXQuaA0K
PiA+ID4gPiBAQCAtNDE5LDYgKzQxOSw5IEBAIHN0cnVjdCBheGllbmV0X2xvY2FsIHsNCj4gPiA+
ID4gIAlzdHJ1Y3QgcGh5bGluayAqcGh5bGluazsNCj4gPiA+ID4gIAlzdHJ1Y3QgcGh5bGlua19j
b25maWcgcGh5bGlua19jb25maWc7DQo+ID4gPiA+IA0KPiA+ID4gPiArCS8qIFJlZmVyZW5jZSB0
byBQQ1MvUE1BIFBIWSBpZiB1c2VkICovDQo+ID4gPiA+ICsJc3RydWN0IG1kaW9fZGV2aWNlICpw
Y3NfcGh5Ow0KPiA+ID4gPiArDQo+ID4gPiA+ICAJLyogQ2xvY2sgZm9yIEFYSSBidXMgKi8NCj4g
PiA+ID4gIAlzdHJ1Y3QgY2xrICpjbGs7DQo+ID4gPiA+IA0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYw0KPiA+ID4g
PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMNCj4g
PiA+ID4gaW5kZXggOWFhZmQzZWNkYWE0Li5mNDY1OTVlZjI4MjIgMTAwNjQ0DQo+ID4gPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMNCj4g
PiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21h
aW4uYw0KPiA+ID4gPiBAQCAtMTUxNywxMCArMTUxNywyOSBAQCBzdGF0aWMgdm9pZCBheGllbmV0
X3ZhbGlkYXRlKHN0cnVjdA0KPiA+ID4gPiBwaHlsaW5rX2NvbmZpZyAqY29uZmlnLA0KPiA+ID4g
PiANCj4gPiA+ID4gIAlwaHlsaW5rX3NldChtYXNrLCBBc3ltX1BhdXNlKTsNCj4gPiA+ID4gIAlw
aHlsaW5rX3NldChtYXNrLCBQYXVzZSk7DQo+ID4gPiA+IC0JcGh5bGlua19zZXQobWFzaywgMTAw
MGJhc2VYX0Z1bGwpOw0KPiA+ID4gPiAtCXBoeWxpbmtfc2V0KG1hc2ssIDEwYmFzZVRfRnVsbCk7
DQo+ID4gPiA+IC0JcGh5bGlua19zZXQobWFzaywgMTAwYmFzZVRfRnVsbCk7DQo+ID4gPiA+IC0J
cGh5bGlua19zZXQobWFzaywgMTAwMGJhc2VUX0Z1bGwpOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsJ
c3dpdGNoIChzdGF0ZS0+aW50ZXJmYWNlKSB7DQo+ID4gPiA+ICsJY2FzZSBQSFlfSU5URVJGQUNF
X01PREVfTkE6DQo+ID4gPiA+ICsJY2FzZSBQSFlfSU5URVJGQUNFX01PREVfMTAwMEJBU0VYOg0K
PiA+ID4gPiArCWNhc2UgUEhZX0lOVEVSRkFDRV9NT0RFX1NHTUlJOg0KPiA+ID4gPiArCWNhc2Ug
UEhZX0lOVEVSRkFDRV9NT0RFX0dNSUk6DQo+ID4gPiA+ICsJY2FzZSBQSFlfSU5URVJGQUNFX01P
REVfUkdNSUk6DQo+ID4gPiA+ICsJY2FzZSBQSFlfSU5URVJGQUNFX01PREVfUkdNSUlfSUQ6DQo+
ID4gPiA+ICsJY2FzZSBQSFlfSU5URVJGQUNFX01PREVfUkdNSUlfUlhJRDoNCj4gPiA+ID4gKwlj
YXNlIFBIWV9JTlRFUkZBQ0VfTU9ERV9SR01JSV9UWElEOg0KPiA+ID4gPiArCQlwaHlsaW5rX3Nl
dChtYXNrLCAxMDAwYmFzZVhfRnVsbCk7DQo+ID4gPiA+ICsJCXBoeWxpbmtfc2V0KG1hc2ssIDEw
MDBiYXNlVF9GdWxsKTsNCj4gPiA+ID4gKwkJaWYgKHN0YXRlLT5pbnRlcmZhY2UgPT0NCj4gPiA+
ID4gUEhZX0lOVEVSRkFDRV9NT0RFXzEwMDBCQVNFWCkNCj4gPiA+ID4gKwkJCWJyZWFrOw0KPiA+
ID4gDQo+ID4gPiAxMDBCYXNlVCBhbmQgMTBCYXNlVCBjYW4gYmUgc2V0IGluIFBIWV9JTlRFUkZB
Q0VfTU9ERV9NSUkgaWYgd2UNCj4gPiA+IGFsbG93IGZhbGx0aHJvdWdoIGhlcmUuDQo+ID4gDQo+
ID4gTm90IHF1aXRlIHN1cmUgd2hhdCB5b3UgYXJlIHNheWluZyBoZXJlPw0KPiANCj4gSSB3YXMg
c2F5aW5nIHRvIGFsbG93IHN3aXRjaCBjYXNlIGZhbGwgdGhyb3VnaC4NCg0KQWgsIEkgc2VlLiBZ
ZXMsIHRoYXQgd291bGQgd29yayB0byBzYXZlIGEgY291cGxlIGR1cGxpY2F0ZSBsaW5lcyAtIGp1
c3QNCm5vdCBzdXJlIGlmIHVzaW5nIHRoZSBzd2l0Y2ggZmFsbC10aHJvdWdoIGlzIHByZWZlcmFi
bGUuIEFueSB0aG91Z2h0cw0KZnJvbSBwZW9wbGUgb24gd2hhdCdzIHByZWZlcnJlZD8NCg0KLS0g
DQpSb2JlcnQgSGFuY29jaw0KU2VuaW9yIEhhcmR3YXJlIERlc2lnbmVyLCBBZHZhbmNlZCBUZWNo
bm9sb2dpZXMgDQp3d3cuY2FsaWFuLmNvbQ0K
