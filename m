Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3225D2274AF
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgGUBjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:39:48 -0400
Received: from mail-eopbgr1400139.outbound.protection.outlook.com ([40.107.140.139]:25561
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725857AbgGUBjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 21:39:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWLnNKLdv2PXxNNUz+2A/SP+WWFXXx3apOjyY9xwc0n0GZ7Hr2aIV4IqFHNEWalAtcGS9SSPF78BPXezlGdLcNGNFB4Tjf/57Ha7sZpd4begjAyNPeZBxWSBVrlR/XlQCI6pEw1IdA7NWTXH+RCehJxuoXyn9u9j4UUyWF3wfOz2E6eHGlrJI3TsarBi3icmM69yUa37TdaFF9hda6y+Rk3JZ8G831Iq7AnY6xHA4lSGIKoC0AmVU1ZfRCJXrWDuReqC8rUPjZ2V5UwMNdQpFGsX/c9U5qVN9m+26jFiZzbfKAXbO+ho8uUG2MUvEOFR9clk0gofaB8dWzKjey4uPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0QQ4LKmtblH/tfCUhMOP+f3tR36i/bBunDe5UN5Qc9Y=;
 b=dZUVQoW51g1Alk7ct04Zw1uSBgrxbp5J//NGNu2pnrVu9ghTtFBrTPxb1xavmSB2DxBnMzuZFHQF9vFZS2H4JgPsTKzX2vwitec4sD0TT2zwUrXVDFy2FAqe7LCasx6NUdHqmrSRLGqx2tTwxtK20OJ1TqHO9gxDtIWqD0R4MLsuXvch9wHqKugRvH6ubn1t9LeDwqdDqBqo/OrzwHnjjJmGj/OybJtalauFc/zTZ+bJVki5v61UFNs5HQRhwUIz211ggkroPXI/eqoNCOsM9GE7NjCt24ElNYTre+pYxKajROVMTc0zaa+GgPgKY23L+PLMgAkEFiBCwjNbkG6szw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0QQ4LKmtblH/tfCUhMOP+f3tR36i/bBunDe5UN5Qc9Y=;
 b=rV8a7ur8Bc5YlT+JArb0XV1mwBzn73OMuUJ4zqYxxnc303tIr0PxkRFbhstSvYCHEbkSKuA+hJBBF+FyNMuHtxabODmbtaWDjnJ0oz3drPm+c0jdU0o6O0LoBeOA15mY7shN0XIJcbUDo4ZRkVNe0COkIIvLhnhiaft04bf0wv4=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYAPR01MB5277.jpnprd01.prod.outlook.com (2603:1096:404:c3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 01:39:42 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3%6]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 01:39:42 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "REE dirk.behme@de.bosch.com" <dirk.behme@de.bosch.com>,
        "Shashikant.Suguni@in.bosch.com" <Shashikant.Suguni@in.bosch.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH/RFC v2] net: ethernet: ravb: exit if hardware is
 in-progress in tx timeout
Thread-Topic: [PATCH/RFC v2] net: ethernet: ravb: exit if hardware is
 in-progress in tx timeout
Thread-Index: AQHWXo0/YmIcDGkyjky44w3tAtIpdKkQtVyAgACC3YA=
Date:   Tue, 21 Jul 2020 01:39:42 +0000
Message-ID: <TY2PR01MB36927FF2DECE617E60BA6B7FD8780@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <1595246298-29260-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <7d37c358-fab9-8ec1-6fff-688d33898b09@gmail.com>
In-Reply-To: <7d37c358-fab9-8ec1-6fff-688d33898b09@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [240f:60:5f3e:1:b8c3:2cf:9453:55ba]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b66d9915-2a77-48bc-cb6e-08d82d16f10c
x-ms-traffictypediagnostic: TYAPR01MB5277:
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-microsoft-antispam-prvs: <TYAPR01MB5277373316C518DC2B43F714D8780@TYAPR01MB5277.jpnprd01.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wCqewysY19GHT46HytT9wofk68SN3VdqjCEJend7DPtsY8rptP8/yubCwNt667573QcJpvTYoAVbFJx5Ac6iwlThvWE13gzuR9dxQkNegDfLy2fvUQxOqcShIonfi5c1CPQ000vP+3BwCIdB+opqwSILYYu2ACuq3pmOHh+3NlyxTtjm6JpGh3YBPSOBqs9yTFL78NsueoJi14D67Mq3h6ZPUMHCwT+Mr5wEj5xJQ9/2ZAV81FcndToMX92Lrthmv1f7AperACJZ8JbLP3aZkYQRM5Nm1W2D4hDS97caQZ/hHiLjy/XGRoQ2R/4LxVsvRAlX9PSuyvJiPTlhz+VdVQM+gu++y0QqSH2sryVo787p4jxIJO9mOejPkRNOlXJ/FtnJuN5UcvuEC/xo5LVzow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(396003)(39860400002)(366004)(376002)(186003)(55016002)(53546011)(6506007)(478600001)(2906002)(8676002)(8936002)(66946007)(66476007)(64756008)(66446008)(66556008)(9686003)(76116006)(316002)(52536014)(86362001)(5660300002)(7696005)(4326008)(966005)(83380400001)(33656002)(110136005)(54906003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +M19uFVO3qXaYmBUKU3iiKExdPBADdfjomSrR0yt921N6PzAchmyIRCzPZkEBwNqReQFPeEX/9NvVDONUL+uLAE87UBYHkxBgBm0tIKzwzVEGanVJpH2pByikzC9AdDstgF42TVq0ZTRu7KGssLwweYaXU8WNWrvep6IjoKlBBdTjCphUHiA13HBFcsAtdI1txAelqg/h5hIx8s4OqS/NfU2FWiI/5AjNayXY0JfAFaSg0q3ADH27agPNo5WhTB3iyKi6SvTZXa2EpAxQ2RVBJKUgLV00CfDaI92Ntnwrl+a8QOCyoU6d4yv68vAA48gaDG9A3Yiqb/bPK21TnMIUHm26ey224mtr9iEBfNFCfVuCDAUBrUX9lH90gOM1+UaYw97HcMYa8cZMuG2gCWJwck2GUofDzMm8haE+dJZGkue95oLHRk0igpqfPAZ8yccpXffn5MaVoUoisv+vju+Z+pPWNYZNsTF/IQUN/qdOrfV3mUJsW7EbAn9B+EUss70V7bE4qJgkXk+Lx5hVnSz6mMJCQqsB9J/zHYZKqIGgvE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b66d9915-2a77-48bc-cb6e-08d82d16f10c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 01:39:42.8403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dRFysZrmcuZ5ssjvoCqzk/FEVwj3jpLQNHUXiu0l08g+UjSHGkeeIHs1OZy4sYJf2L3LBsKmipHTweo+NPcQubFr1au10MLgF9dYUS/hYj7mIRs/7EvkyGfMH4D358+w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5277
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8hDQoNClRoYW5rIHlvdSBmb3IgeW91ciByZXZpZXchDQoNCj4gRnJvbTogU2VyZ2VpIFNo
dHlseW92LCBTZW50OiBUdWVzZGF5LCBKdWx5IDIxLCAyMDIwIDI6MTUgQU0NCj4gDQo+IEhlbGxv
IQ0KPiANCj4gT24gNy8yMC8yMCAyOjU4IFBNLCBZb3NoaWhpcm8gU2hpbW9kYSB3cm90ZToNCj4g
DQo+ID4gQWNjb3JkaW5nIHRvIHRoZSByZXBvcnQgb2YgWzFdLCB0aGlzIGRyaXZlciBpcyBwb3Nz
aWJsZSB0byBjYXVzZQ0KPiA+IHRoZSBmb2xsb3dpbmcgZXJyb3IgaW4gcmF2Yl90eF90aW1lb3V0
X3dvcmsoKS4NCj4gPg0KPiA+IHJhdmIgZTY4MDAwMDAuZXRoZXJuZXQgZXRoZXJuZXQ6IGZhaWxl
ZCB0byBzd2l0Y2ggZGV2aWNlIHRvIGNvbmZpZyBtb2RlDQo+IA0KPiAgICBIbW0sIG1heWJlIHdl
IG5lZWQgYSBsYXJnZXIgdGltZW91dCB0aGVyZT8gVGhlIGN1cnJlbnQgb25lIGFtb3VudHMgdG8g
b25seQ0KPiB+MTAwIG1zIGZvciBhbGwgY2FzZXMgKG1heWJlIHdlIHNob3VsZCBwYXJhbWV0cml6
ZSB0aGUgdGltZW91dD8pLi4uDQoNCkkgZG9uJ3QgdGhpbmsgc28gYmVjYXVzZSB3ZSBjYW5ub3Qg
YXNzdW1lIHdoZW4gUlggaXMgZmluaXNoZWQuDQpGb3IgZXhhbXBsZSwgaWYgb3RoZXIgZGV2aWNl
IHNlbmRzIHRvIHRoZSBoYXJkd2FyZSBieSB1c2luZyAicGluZyAtZiIsDQp0aGUgaGFyZHdhcmUg
aXMgb3BlcmF0aW5nIGFzIFJYIHdoaWxlIHRoZSBwaW5nIGlzIHJ1bm5pbmcuDQoNCj4gPiBUaGlz
IGVycm9yIG1lYW5zIHRoYXQgdGhlIGhhcmR3YXJlIGNvdWxkIG5vdCBjaGFuZ2UgdGhlIHN0YXRl
DQo+ID4gZnJvbSAiT3BlcmF0aW9uIiB0byAiQ29uZmlndXJhdGlvbiIgd2hpbGUgc29tZSB0eCBh
bmQvb3IgcnggcXVldWUNCj4gPiBhcmUgb3BlcmF0aW5nLiBBZnRlciB0aGF0LCByYXZiX2NvbmZp
ZygpIGluIHJhdmJfZG1hY19pbml0KCkgd2lsbCBmYWlsLA0KPiANCj4gICAgQXJlIHdlIHNlZWlu
ZyBkb3VibGUgbWVzc2FnZXMgZnJvbSByYXZiX2NvbmZpZygpPyBJIHRoaW5rIHdlIGFyZW4ndC4u
Lg0KDQpObywgd2UgYXJlIG5vdCBzZWVpbmcgZG91YmxlIG1lc3NhZ2VzIGZyb20gcmF2Yl9jb25m
aWcoKSBiZWNhdXNlDQpyYXZiX3N0b3BfZG1hKCkgaXMgcG9zc2libGUgdG8gZmFpbCBiZWZvcmUg
cmF2Yl9jb25maWcoKSBpcyBjYWxsZWQgaWYNClRDQ1Igb3IgQ1NSIGlzIHNwZWNpZmljIGNvbmRp
dGlvbi4NCg0KPiA+IGFuZCB0aGVuIGFueSBkZXNjcmlwdG9ycyB3aWxsIGJlIG5vdCBhbGxvY2Fs
ZWQgYW55bW9yZSBzbyB0aGF0IE5VTEwNCj4gPiBwb2ludGVyIGRlcmVmZXJlbmNlIGhhcHBlbnMg
YWZ0ZXIgdGhhdCBvbiByYXZiX3N0YXJ0X3htaXQoKS4NCj4gPg0KPiA+IFRvIGZpeCB0aGUgaXNz
dWUsIHRoZSByYXZiX3R4X3RpbWVvdXRfd29yaygpIHNob3VsZCBjaGVjaw0KPiA+IHRoZSByZXR1
cm4gdmFsdWUgb2YgcmF2Yl9zdG9wX2RtYSgpIHdoZXRoZXIgdGhpcyBoYXJkd2FyZSBjYW4gYmUN
Cj4gPiByZS1pbml0aWFsaXplZCBvciBub3QuIElmIHJhdmJfc3RvcF9kbWEoKSBmYWlscywgcmF2
Yl90eF90aW1lb3V0X3dvcmsoKQ0KPiA+IHJlLWVuYWJsZXMgVFggYW5kIFJYIGFuZCBqdXN0IGV4
aXRzLg0KPiA+DQo+ID4gWzFdDQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtcmVu
ZXNhcy1zb2MvMjAyMDA1MTgwNDU0NTIuMjM5MC0xLWRpcmsuYmVobWVAZGUuYm9zY2guY29tLw0K
PiA+DQo+ID4gUmVwb3J0ZWQtYnk6IERpcmsgQmVobWUgPGRpcmsuYmVobWVAZGUuYm9zY2guY29t
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IFlvc2hpaGlybyBTaGltb2RhIDx5b3NoaWhpcm8uc2hpbW9k
YS51aEByZW5lc2FzLmNvbT4NCj4gDQo+ICAgIEFzc3VtaW5nIHRoZSBjb21tZW50IGJlbG93IGlz
IGZpeGVkOg0KPiANCj4gUmV2aWV3ZWQtYnk6IFNlcmdlaSBTaHR5bHlvdiA8c2VyZ2VpLnNodHls
eW92QGdtYWlsLmNvbT4NCg0KVGhhbmtzIQ0KDQo+ID4gLS0tDQo+ID4gIENoYW5nZXMgZnJvbSBS
RkMgdjE6DQo+ID4gIC0gQ2hlY2sgdGhlIHJldHVybiB2YWx1ZSBvZiByYXZiX3N0b3BfZG1hKCkg
YW5kIGV4aXQgaWYgdGhlIGhhcmR3YXJlDQo+ID4gICAgY29uZGl0aW9uIGNhbiBub3QgYmUgaW5p
dGlhbGl6ZWQgaW4gdGhlIHR4IHRpbWVvdXQuDQo+ID4gIC0gVXBkYXRlIHRoZSBjb21taXQgc3Vi
amVjdCBhbmQgZGVzY3JpcHRpb24uDQo+ID4gIC0gRml4IHNvbWUgdHlwby4NCj4gPiAgaHR0cHM6
Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC8xMTU3MDIxNy8NCj4gPg0KPiA+ICBVbmZvcnR1
bmF0ZWx5LCBJIHN0aWxsIGRpZG4ndCByZXByb2R1Y2UgdGhlIGlzc3VlIHlldC4gU28sIEkgc3Rp
bGwNCj4gPiAgbWFya2VkIFJGQyBvbiB0aGlzIHBhdGNoLg0KPiANCj4gICAgIEkgdGhpbmsgdGhl
IEJvc2NoIHBlb3BsZSBzaG91bGQgdGVzdCB0aGlzIHBhdGNoLCBhcyB0aGV5IHJlcG9ydGVkIHRo
ZSBrZXJuZWwgb29wcy4uLg0KPiANCj4gPg0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5l
c2FzL3JhdmJfbWFpbi5jIHwgMTQgKysrKysrKysrKysrKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQs
IDEzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGluZGV4IGE0NDJiY2Y2Li41MDBmNWMxIDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMN
Cj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4g
QEAgLTE0NTgsNyArMTQ1OCwxOCBAQCBzdGF0aWMgdm9pZCByYXZiX3R4X3RpbWVvdXRfd29yayhz
dHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+ID4gIAkJcmF2Yl9wdHBfc3RvcChuZGV2KTsNCj4g
Pg0KPiA+ICAJLyogV2FpdCBmb3IgRE1BIHN0b3BwaW5nICovDQo+ID4gLQlyYXZiX3N0b3BfZG1h
KG5kZXYpOw0KPiA+ICsJaWYgKHJhdmJfc3RvcF9kbWEobmRldikpIHsNCj4gPiArCQkvKiBJZiBy
YXZiX3N0b3BfZG1hKCkgZmFpbHMsIHRoZSBoYXJkd2FyZSBpcyBzdGlsbCBpbi1wcm9ncmVzcw0K
PiA+ICsJCSAqIGFzICJPcGVyYXRpb24iIG1vZGUgZm9yIFRYIGFuZC9vciBSWC4gU28sIHRoaXMg
c2hvdWxkIG5vdA0KPiANCj4gICAgcy9pbi1wcm9ncmVzcyBhcyAiT3BlcmF0aW9uIiBtb2RlL29w
ZXJhdGluZy8uDQoNCkknbGwgZml4IGl0Lg0KDQo+ID4gKwkJICogY2FsbCB0aGUgZm9sbG93aW5n
IGZ1bmN0aW9ucyBiZWNhdXNlIHJhdmJfZG1hY19pbml0KCkgaXMNCj4gPiArCQkgKiBwb3NzaWJs
ZSB0byBmYWlsIHRvby4gQWxzbywgdGhpcyBzaG91bGQgbm90IHJldHJ5DQo+ID4gKwkJICogcmF2
Yl9zdG9wX2RtYSgpIGFnYWluIGFuZCBhZ2FpbiBoZXJlIGJlY2F1c2UgaXQncyBwb3NzaWJsZQ0K
PiA+ICsJCSAqIHRvIHdhaXQgZm9yZXZlci4gU28sIHRoaXMganVzdCByZS1lbmFibGVzIHRoZSBU
WCBhbmQgUlggYW5kDQo+ID4gKwkJICogc2tpcCB0aGUgZm9sbG93aW5nIHJlLWluaXRpYWxpemF0
aW9uIHByb2NlZHVyZS4NCj4gPiArCQkgKi8NCj4gPiArCQlyYXZiX3Jjdl9zbmRfZW5hYmxlKG5k
ZXYpOw0KPiA+ICsJCWdvdG8gb3V0Ow0KPiA+ICsJfQ0KPiA+DQo+ID4gIAlyYXZiX3JpbmdfZnJl
ZShuZGV2LCBSQVZCX0JFKTsNCj4gPiAgCXJhdmJfcmluZ19mcmVlKG5kZXYsIFJBVkJfTkMpOw0K
PiA+IEBAIC0xNDY3LDYgKzE0NzgsNyBAQCBzdGF0aWMgdm9pZCByYXZiX3R4X3RpbWVvdXRfd29y
ayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+ID4gIAlyYXZiX2RtYWNfaW5pdChuZGV2KTsN
Cj4gDQo+ICAgIEJUVywgdGhhdCBvbmUgYWxzbyBtYXkgZmFpbC4uLg0KDQpZZXMsIHRoYXQncyB0
cnVlLi4uIEluIHRoaXMgY2FzZSwgSSB0aGluayB0aGlzIHNob3VsZCBwcmludCBlcnJvciBtZXNz
YWdlIGFuZA0Kc3RvcCBUWCBhbmQgUlggdG8gYXZvaWQgYW55IHVuZXhwZWN0ZWQgYmVoYXZpb3Jz
IGxpa2Uga2VybmVsIHBhbmljLiBTbywgSSdsbCBhZGQNCnN1Y2ggYSBjb2RlLg0KDQpCZXN0IHJl
Z2FyZHMsDQpZb3NoaWhpcm8gU2hpbW9kYQ0KDQo+ID4gIAlyYXZiX2VtYWNfaW5pdChuZGV2KTsN
Cj4gPg0KPiA+ICtvdXQ6DQo+ID4gIAkvKiBJbml0aWFsaXNlIFBUUCBDbG9jayBkcml2ZXIgKi8N
Cj4gPiAgCWlmIChwcml2LT5jaGlwX2lkID09IFJDQVJfR0VOMikNCj4gPiAgCQlyYXZiX3B0cF9p
bml0KG5kZXYsIHByaXYtPnBkZXYpOw0KPiA+DQoNCg==
