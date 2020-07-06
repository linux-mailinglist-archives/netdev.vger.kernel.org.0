Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F692154B2
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 11:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgGFJZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 05:25:13 -0400
Received: from mail-eopbgr1320090.outbound.protection.outlook.com ([40.107.132.90]:8934
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728440AbgGFJZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 05:25:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVosRar+iAj+3FST7Y6XSTb2iLx/nldGJOYhUK6KlKXgGHAbm5Vl6GR+41u1Op5EJVuMsH3WOmGfw7WMdciJwD+mk7PEIcVsQiCP3tlFPgOFakUih84YYpLFpgt1Iq3uL+XCJAoYIwJVFJqRUmHtjrDTSIJ1yz4ZX11nNYuOvgOthkhgWJWnvEymihyqDYHiWyCD+kqfBHIOebWDbBTh3RASzo0E3YjvSvqjeWLklz6itHCuoi4aSpUTFCTIb+/EO7G3oyOYpyy8yiURIozrQ0KzbD38fYLbLRzc5w0hd8sBfQ5Co003GWUiCVtuLAirM7zbGvd8KAperc+It2LQqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKbiMzWF2ElPt705H9CX39wTkN7gcKEPBpZZe979v54=;
 b=JawrC1pndsv9S05TrMwvnBTgBsAqSGnkZQsNqnjUbTQ8V6stmknWIO87s34tNu4/o11l6NOjoqejTGdWgY1SSBP+aSMI0n0Xld2fl/D1Y6kdVNDpiVfuWGmvXa9pIQeDgSd+H3okKc5KWK3csYXQ4D3GtPbyxnDToJPg8E7RzjTV+u2cy/rHrkwGGFgRMOWi99RaXXV2f1tNvFHEA3zvhDFKQz0XSCemxvkkKd4WAZA1oWQLxus3UQTOekX56OFn8P9fqd6WaBG7ENjLF8xAw/8PzMLvfnVMYAuZ9U6RyOYh+wLZD/lJQgcxmC7IhyQXuqq9+T+ah/GGG/belLVCDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKbiMzWF2ElPt705H9CX39wTkN7gcKEPBpZZe979v54=;
 b=PmHcsb+NW3hXKg0GLMFuW2WzX/GH2Bbevf4gMmFbZ/sKbNvjeFJFZaLLGhT0b40Emjpx0nlH4WacvWlvWVmk4AvJC/6aKXWf0fa41MUgobyPE+lLdkJXk3Ykg/2loxSpdQWI49tR2c986I4HKxGFCpM8dpORk9kPqO5mO2qa/BI=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TY2PR01MB2060.jpnprd01.prod.outlook.com (2603:1096:404:11::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Mon, 6 Jul
 2020 09:25:08 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3%6]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 09:25:08 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC:     "REE dirk.behme@de.bosch.com" <dirk.behme@de.bosch.com>,
        "Shashikant.Suguni@in.bosch.com" <Shashikant.Suguni@in.bosch.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH/RFC] net: ethernet: ravb: Try to wake subqueue instead of
 stop on timeout
Thread-Topic: [PATCH/RFC] net: ethernet: ravb: Try to wake subqueue instead of
 stop on timeout
Thread-Index: AQHWM0Kg7roEc2K3tEugD8qfTO7LKKjZTL9ggAAmMYCABhvkIIAPtGcQgAA4GgCAAVSU0IAI302AgADAfvA=
Date:   Mon, 6 Jul 2020 09:25:07 +0000
Message-ID: <TY2PR01MB3692E49BB082DEF855A3ACBAD8690@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <1590486419-9289-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <TY2PR01MB369266A27D1ADF5297A3CFFCD89C0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <9f71873b-ee5e-7ae3-8a5a-caf7bf38a68e@gmail.com>
 <TY2PR01MB36926D80F2080A3D6109F11AD8980@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <TY2PR01MB36926B67ED0643A9EAA9A4F3D86E0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <a1dc573d-78b0-7137-508d-efcdfa68d936@cogentembedded.com>
 <TY2PR01MB3692A9F68ACC62E920EE2965D86F0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <e7e5fd5f-1ed4-7699-1a1f-f4f1bb5495cf@gmail.com>
In-Reply-To: <e7e5fd5f-1ed4-7699-1a1f-f4f1bb5495cf@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [240f:60:5f3e:1:2db6:6c31:f0ea:12be]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d3efdd59-b7f6-4c11-1ff3-08d8218e797c
x-ms-traffictypediagnostic: TY2PR01MB2060:
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-microsoft-antispam-prvs: <TY2PR01MB2060D77DBB7EA4BB3386886ED8690@TY2PR01MB2060.jpnprd01.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04569283F9
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FhTr+6IkpzQS2IEJgkONLZvKDaBfSdxOmzMEdpUa0XnGCWJhobKhwkt0cS72hs1wXqxea882YJGx3olALSQNxwMncBTx2bkXqipxdx09wM/1ReqOMjCgyVWimjQYVOSvltzY+aXj4oX310UNZk6zuCMzVud9M6QX4Rt9w77/nVt15UpTxPmXnd/G4210xJnMWAFnwaKhnFEWgbVVbr7JSZGylPau4zOkmyOHEx+50Sdfh/P3G1sYGbk5Us9lLROg1IQQGh83Nh3XlRblaf8vYfN5HEatj5a9hQhi88bpWUkqfcE/fC1dBpmn+S3NTcztgMW3X6ovRYI1AZBgT5IMqKfY8nxxBknLIzXXfxvOsRsoehyz7F6uB4P7f7Yj2SJ0QSqhkA4B6X2F7T727NY0rQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(2906002)(9686003)(53546011)(54906003)(8936002)(6506007)(966005)(83380400001)(8676002)(7696005)(110136005)(52536014)(33656002)(4326008)(186003)(316002)(5660300002)(55016002)(71200400001)(66946007)(66476007)(66446008)(86362001)(64756008)(76116006)(66556008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: LEcFLnn7nB2wPZs+90gl/PY95ML3dGXPuLsAShA5IhjFgfBzazdPBN6Hq45LiLytMbdC13hMBvi8rq1YCIdlpoTShi3GDTOHZwNtFbMDOLDH0LMeeO9/fdwkTZAGRY10tVj7YTZ3RJHm4LHjg8pNgPk6ErSZQX0zyLrE/Fe+yLBiGaAVKCXVf2sMrQLbY3bpXnut9z86x0QHazLTcgBQhmulT4PI8ExSYCQHQkkJdL60oqeHPcTOUXvyzWd8QJX1lo/U2YFkSkBum0sksHNPaSA1yojSSEMyj7d5/T4ohQb1NUSCZR89cH1b5i9TAALyOxUvG73BHQA9xb585u6q6JGG669n3oi2168odHyFDCrJ4K8aAtBMGZzER57siTrAUkuHj+xRD2fXSttgoah/qtjtBJPHBI58dZi5G4CJq1618vK7ni0ULv7Jwkufjp7kc4hNEPAer1ph8ZnexuI/KzWWo6Hc/p8bN6tlpZpe7FtABqzrAFSI5tVvHtEy/BQ1ckzkvWx0GIGPjk1twYajEBG3j/QIwyVXyBkG4FggT0M=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3efdd59-b7f6-4c11-1ff3-08d8218e797c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2020 09:25:07.9006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PakSPLAFEiP4KQls6qnDs6BuISRrJukhVTnOhxvbCqv+vqpbPtnvN0k0Vy2wvcv7vQ0zmMzNRxov2ZTGWcRpZ7VTIIuf2qiHDqcYYOz9mcd9ylTwL9ds/xENVEMkN8S2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB2060
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8hDQoNCj4gRnJvbTogU2VyZ2VpIFNodHlseW92LCBTZW50OiBNb25kYXksIEp1bHkgNiwg
MjAyMCA1OjI5IEFNDQo+IA0KPiBIZWxsbyENCj4gDQo+IE9uIDMwLjA2LjIwMjAgODoyMiwgWW9z
aGloaXJvIFNoaW1vZGEgd3JvdGU6DQo+IA0KPiA+Pj4+Pj4+IEZyb206IFlvc2hpaGlybyBTaGlt
b2RhLCBTZW50OiBUdWVzZGF5LCBNYXkgMjYsIDIwMjAgNjo0NyBQTQ0KPiA+Pj4+Pj4+DQo+ID4+
Pj4+Pj4gQWNjb3JkaW5nIHRvIHRoZSByZXBvcnQgb2YgWzFdLCB0aGlzIGRyaXZlciBpcyBwb3Nz
aWJsZSB0byBjYXVzZQ0KPiA+Pj4+Pj4+IHRoZSBmb2xsb3dpbmcgZXJyb3IgaW4gcmF2Yl90eF90
aW1lb3V0X3dvcmsoKS4NCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+IHJhdmIgZTY4MDAwMDAuZXRoZXJu
ZXQgZXRoZXJuZXQ6IGZhaWxlZCB0byBzd2l0Y2ggZGV2aWNlIHRvIGNvbmZpZyBtb2RlDQo+ID4+
Pj4+Pj4NCj4gPj4+Pj4+PiBUaGlzIGVycm9yIG1lYW5zIHRoYXQgdGhlIGhhcmR3YXJlIGNvdWxk
IG5vdCBjaGFuZ2UgdGhlIHN0YXRlDQo+ID4+Pj4+Pj4gZnJvbSAiT3BlcmF0aW9uIiB0byAiQ29u
ZmlndXJhdGlvbiIgd2hpbGUgc29tZSB0eCBxdWV1ZSBpcyBvcGVyYXRpbmcuDQo+ID4+Pj4+Pj4g
QWZ0ZXIgdGhhdCwgcmF2Yl9jb25maWcoKSBpbiByYXZiX2RtYWNfaW5pdCgpIHdpbGwgZmFpbCwg
YW5kIHRoZW4NCj4gPj4+Pj4+PiBhbnkgZGVzY3JpcHRvcnMgd2lsbCBiZSBub3QgYWxsb2NhbGVk
IGFueW1vcmUgc28gdGhhdCBOVUxMIHBvcmludGVyDQo+IA0KPiAgICAgUG9pbnRlci4gOi0pDQoN
Ck9vcHMhIEkgc2hvdWxkIGZpeCBpdCA6KQ0KDQo+ID4+Pj4+Pj4gZGVyZWZlcmVuY2UgaGFwcGVu
cyBhZnRlciB0aGF0IG9uIHJhdmJfc3RhcnRfeG1pdCgpLg0KPiA+Pj4+Pj4+DQo+ID4+Pj4+Pj4g
U3VjaCBhIGNhc2UgaXMgcG9zc2libGUgdG8gYmUgY2F1c2VkIGJlY2F1c2UgdGhpcyBkcml2ZXIg
c3VwcG9ydHMNCj4gPj4+Pj4+PiB0d28gcXVldWVzIChOQyBhbmQgQkUpIGFuZCB0aGUgcmF2Yl9z
dG9wX2RtYSgpIGlzIHBvc3NpYmxlIHRvIHJldHVybg0KPiA+Pj4+Pj4+IHdpdGhvdXQgYW55IHN0
b3BwaW5nIHByb2Nlc3MgaWYgVENDUiBvciBDU1IgcmVnaXN0ZXIgaW5kaWNhdGVzDQo+ID4+Pj4+
Pj4gdGhlIGhhcmR3YXJlIGlzIG9wZXJhdGluZyBmb3IgVFguDQo+IA0KPiAgICAgTWF5YmUgd2Ug
c2hvdWxkIGp1c3QgZml4IHRob3NlIGJsaW5kIGFzc3VtcHRpb25zPw0KDQpNYXliZSBJIHNob3Vs
ZCBoYXZlIGRlc2NyaWJlZCBzb21lIGZhY3RzIGluc3RlYWQgb2YgYXNzdW1wdGlvbnMgbGlrZSBi
ZWxvdz8NCklmIHNvLCBJIHNob3VsZCBtb2RpZnkgdGhlIGNvZGUgdG9vLg0KDQpBZnRlciByYXZi
X3N0b3BfZG1hKCkgd2FzIGNhbGxlZCwgdGhlIGRyaXZlciBhc3N1bWVkIGFueSB0cmFuc2ZlcnMg
d2VyZQ0Kc3RvcHBlZC4gSG93ZXZlciwgdGhlIGN1cnJlbnQgcmF2Yl90eF90aW1lb3V0X3dvcmso
KSBkb2Vzbid0IGNoZWNrIHdoZXRoZXINCnRoZSByYXZiX3N0b3BfZG1hKCkgaXMgc3VjY2VlZGVk
IHdpdGhvdXQgYW55IGVycm9yIG9yIG5vdC4gU28sIHdlIHNob3VsZA0KZml4IGl0Lg0KDQo+ID4+
Pj4+Pj4gVG8gZml4IHRoZSBpc3N1ZSwganVzdCB0cnkgdG8gd2FrZSB0aGUgc3VicXVldWUgb24N
Cj4gPj4+Pj4+PiByYXZiX3R4X3RpbWVvdXRfd29yaygpIGlmIHRoZSBkZXNjcmlwdG9ycyBhcmUg
bm90IGZ1bGwgaW5zdGVhZA0KPiA+Pj4+Pj4+IG9mIHN0b3AgYWxsIHRyYW5zZmVycyAoYWxsIHF1
ZXVlcyBvZiBUWCBhbmQgUlgpLg0KPiA+Pj4+Pj4+DQo+ID4+Pj4+Pj4gWzFdDQo+ID4+Pj4+Pj4g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtcmVuZXNhcy1zb2MvMjAyMDA1MTgwNDU0NTIu
MjM5MC0xLWRpcmsuYmVobWVAZGUuYm9zY2guY29tLw0KPiA+Pj4+Pj4+DQo+ID4+Pj4+Pj4gUmVw
b3J0ZWQtYnk6IERpcmsgQmVobWUgPGRpcmsuYmVobWVAZGUuYm9zY2guY29tPg0KPiA+Pj4+Pj4+
IFNpZ25lZC1vZmYtYnk6IFlvc2hpaGlybyBTaGltb2RhIDx5b3NoaWhpcm8uc2hpbW9kYS51aEBy
ZW5lc2FzLmNvbT4NCj4gPj4+Pj4+PiAtLS0NCj4gPj4+Pj4+PiAgICAgSSdtIGd1ZXNzaW5nIHRo
YXQgdGhpcyBpc3N1ZSBpcyBwb3NzaWJsZSB0byBoYXBwZW4gaWY6DQo+ID4+Pj4+Pj4gICAgIC0g
cmF2Yl9zdGFydF94bWl0KCkgY2FsbHMgbmV0aWZfc3RvcF9zdWJxdWV1ZSgpLCBhbmQNCj4gPj4+
Pj4+PiAgICAgLSByYXZiX3BvbGwoKSB3aWxsIG5vdCBiZSBjYWxsZWQgd2l0aCBzb21lIHJlYXNv
biwgYW5kDQo+ID4+Pj4+Pj4gICAgIC0gbmV0aWZfd2FrZV9zdWJxdWV1ZSgpIHdpbGwgYmUgbm90
IGNhbGxlZCwgYW5kIHRoZW4NCj4gPj4+Pj4+PiAgICAgLSBkZXZfd2F0Y2hkb2coKSBpbiBuZXQv
c2NoZWQvc2NoX2dlbmVyaWMuYyBjYWxscyBuZG9fdHhfdGltZW91dCgpLg0KPiA+Pj4+Pj4+DQo+
ID4+Pj4+Pj4gICAgIEhvd2V2ZXIsIHVuZm9ydHVuYXRlbHksIEkgZGlkbid0IHJlcHJvZHVjZSB0
aGUgaXNzdWUgeWV0Lg0KPiA+Pj4+Pj4+ICAgICBUbyBiZSBob25lc3QsIEknbSBhbHNvIGd1ZXNz
aW5nIG90aGVyIHF1ZXVlcyAoU1IpIG9mIHRoaXMgaGFyZHdhcmUNCj4gPj4+Pj4+PiAgICAgd2hp
Y2ggb3V0LW9mIHRyZWUgZHJpdmVyIG1hbmFnZXMgYXJlIHBvc3NpYmxlIHRvIHJlcHJvZHVjZSB0
aGlzIGlzc3VlLA0KPiA+Pj4+Pj4+ICAgICBidXQgSSBkaWRuJ3QgdHJ5IHN1Y2ggZW52aXJvbm1l
bnQgZm9yIG5vdy4uLg0KPiA+Pj4+Pj4+DQo+ID4+Pj4+Pj4gICAgIFNvLCBJIG1hcmtlZCBSRkMg
b24gdGhpcyBwYXRjaCBub3cuDQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gSSdtIGFmcmFpZCwgYnV0IGRv
IHlvdSBoYXZlIGFueSBjb21tZW50cyBhYm91dCB0aGlzIHBhdGNoPw0KPiA+Pj4+Pg0KPiA+Pj4+
PiAgICAgICBJIGFncmVlIHRoYXQgd2Ugc2hvdWxkIG5vdyByZXNldCBvbmx5IHRoZSBzdHVjayBx
dWV1ZSwgbm90IGJvdGggYnV0IEkNCj4gPj4+Pj4gZG91YnQgeW91ciBzb2x1dGlvbiBpcyBnb29k
IGVub3VnaC4gTGV0IG1lIGhhdmUgYW5vdGhlciBsb29rLi4uDQo+ID4+Pj4NCj4gPj4+PiBUaGFu
ayB5b3UgZm9yIHlvdXIgY29tbWVudCEgSSBob3BlIHRoaXMgc29sdXRpb24gaXMgZ29vZCBlbm91
Z2guLi4NCj4gPj4+DQo+ID4+PiBJJ20gc29ycnkgYWdhaW4gYW5kIGFnYWluLiBCdXQsIGRvIHlv
dSBoYXZlIGFueSB0aW1lIHRvIGxvb2sgdGhpcyBwYXRjaD8NCj4gPj4NCj4gPj4gICAgICBZZXMs
IGluIHRoZSBzZW5zZSBvZiByZXZpZXdpbmcgLS0gSSBkb24ndCBjb25zaWRlciBpdCBjb21wbGV0
ZS4gQW5kIG5vLCBpbg0KPiA+PiB0aGUgc2Vuc2Ugb2YgbG9va2luZyBpbnRvIHRoZSBpc3N1ZSBt
eXNlbGYuLi4gQ2FuIHdlIGRvIGEgcGVyLXF1ZXVlIHRlYXItZG93bg0KPiA+PiBhbmQgcmUtaW5p
dCAobm90IG5lY2Vzc2FyaWx5IGFsbCBpbiAxIHBhdGNoKT8NCj4gDQo+ICAgICBJbiBmYWN0LCBp
dCB3b3VsZCBlbnN1ZSBtYW55IGNoYW5nZXMuLi4NCg0KSSB0aGluayBzby4NCg0KPiA+IFRoYW5r
IHlvdSBmb3IgeW91ciBjb21tZW50ISBJJ20gbm90IHN1cmUgdGhpcyAicmUtaW5pdCIgbWVhbi4g
QnV0LCB3ZSBjYW4gZG8NCj4gDQo+ICAgICBXZWxsLCBJIG1lYW50IHRoZSByaW5nIHJlLWFsbG9j
YXRpb24gYW5kIHJlLWZvcm1hdHRpbmcuLi4gYnV0IChsb29raW5nIGF0DQo+IHNoX2V0aCkgdGhl
IGZvcm1lciBpcyBub3QgcmVhbGx5IG5lY2Vzc2FyeSwgaXQncyBlbm91Z2ggdG8ganVzdCBzdG9w
IHRoZSBUWA0KPiByaW5nIGFuZCB0aGVuIHJlLWZvcm1hdCBpdCBhbmQgcmUtc3RhcnQuLi4NCg0K
SSBnb3QgaXQuIEkgYWxzbyB0aGluayB0aGUgcmluZyByZS1hbGxvY2F0aW9uIGlzIG5vdCByZWFs
bHkgbmVjZXNzYXJ5Lg0KDQo+IFdlbGwsIHVuZm9ydHVuYXRlbHksIHRoZSB3YXkgSQ0KPiBzdHJ1
Y3R1cmVkIHRoZSBjb2RlLCB3ZSBjYW4ndCBkbyAqanVzdCogdGhhdC4uLg0KDQpJIGFncmVlLiBX
ZSBuZWVkIHJlZmFjdG9yaW5nIGZvciBpdC4NCg0KPiA+IGEgcGVyLXF1ZXVlIHRlYXItZG93biBp
ZiBETUFDIGlzIHN0aWxsIHdvcmtpbmcuIEFuZCwgd2UgY2FuIHByZXBhcmUgbmV3IGRlc2NyaXB0
b3JzDQo+ID4gZm9yIHRoZSBxdWV1ZSBhZnRlciB0ZWFyLWRvd24uDQo+ID4NCj4gPiA8IFRlYXIt
ZG93biA+DQo+ID4gMS4gU2V0IERUX0VPUyB0byB0aGUgZGVzY19iYXRbcXVldWVdLg0KPiA+IDIu
IFNldCBETFIuTEJBeCB0byAxLg0KPiA+IDMuIENoZWNrIGlmIERMQS5MQkF4IGlzIGNsZWFyZWQu
DQo+IA0KPiAgICAgRExSLkxCQXgsIHlvdSBtZWFuPw0KDQpZZXMuIEkgaGVhcmQgdGhpcyBwcm9j
ZWR1cmUgZnJvbSBCU1AgdGVhbS4NCg0KPiAgICAgV2VsbCwgSSB3YXMgdGhpbmtpbmcgb2YgcG9s
bGluZyBUQ0NSIGFuZCBDU1IgbGlrZSB0aGUgY3VycmVudA0KPiByYXZiX3N0b3BfZG1hKCkgZG9l
cywgYnV0IGlmIHRoYXQgd29ya3MuLi4NCg0KSSdtIG5vdCBzdXJlIHdoZXRoZXIgcG9sbGluZyBU
Q0NSIGFuZCBDU1IgaXMgZW5vdWdoIG9yIG5vdC4NCkluc3RlYWQgb2YgcG9sbGluZyB0aG9zZSBy
ZWdpc3RlcnMsIG1heWJlIHdlIHNob3VsZCBwb2xsIHdoZXRoZXINCnJhdmJfc3RvcF9kbWEoKSBp
cyBzdWNjZWVkZWQgb3Igbm90PyBFc3BlY2lhbGx5LCByZXN1bHQgb2YgcmF2Yl9jb25maWcoKSBp
cw0KYSBrZXkgcG9pbnQgd2hldGhlciB0aGUgaGFyZHdhcmUgaXMgcmVhbGx5IHN0b3BwZWQgb3Ig
bm90Lg0KU28sIEknbSB0aGlua2luZyB0aGF0IGp1c3QgcG9sbGluZyB0aGUgcmF2Yl9zdG9wX2Rt
YSgpIGluDQpyYXZiX3R4X3RpbWVvdXRfd29yaygpIGlzIGJldHRlciB0aGFuIHRoZSBwZXItcXVl
dWUgdGVhci1kb3duIGFuZA0KcmUtaW5pdCBub3cuIEJ1dCwgd2hhdCBkbyB5b3UgdGhpbms/DQoN
Cj4gPiA8IFByZXBhcmUgbmV3IGRlc2NyaXB0b3JzIGFuZCBzdGFydCBhZ2FpbiA+DQo+ID4gNC4g
UHJlcGFyZSBuZXcgZGVzY3JpcHRvcnMuDQo+IA0KPiAgICAgVGhhdCdzIHdoZXJlIHRoZSBjYXVz
ZSBmb3IgdXNpbmcgdGhlIHdvcmtxdWV1ZSBsaWVzIC0tIHRoZSBkZXNjcmlwdG9ycyBhcmUNCj4g
YWxsb2NhdGVkIHdpdGggR0ZQX0tFUk5FTCwgbm90IEdGUF9BVE9NSUMuLi4NCg0KSUlVQywgd2Ug
Y2FuIGF2b2lkIHRvIHVzZSB0aGUgd29ya3F1ZXVlIGlmIHJlLWFsbG9jYXRpb24gaXMgbm90IHJl
YWxseSBuZWNlc3NhcnkuDQoNCj4gaWYgeW91IGhhdmUgdGltZS9kZXNpcmUgdG8NCj4gdW50YW5n
bGUgYWxsIHRoaXMsIEknZCBhcHByZWNpYXRlIGl0OyBlbHNlIEknZCBoYXZlIHRvIHdvcmsgb24g
dGhpcyBpbiBteQ0KPiBjb3Bpb3VzIGZyZWUgdGltZS4uLiA6LSkNCg0KSWYgd2UgZG9uJ3QgbmVl
ZCByZWZhY3RvcmluZywgSSB0aGluayBJIGNhbiBkbyBpdCA6KQ0KDQo+ID4gNS4gU2V0IERUX0xJ
TktGSVggdG8gdGhlIGRlc2NfYmF0W3F1ZXVlXS4NCj4gPiA2LiBTZXQgRExSLkxCQXggdG8gMS4N
Cj4gPiA3LiBDaGVjayBpZiBETEEuTEJBeCBpcyBjbGVhcmVkLg0KPiA+DQo+ID4NCj4gPiBJJ20g
dGhpbmtpbmcgZG9pbmcgdGVhci1kb3duIGFuZCAicmUtaW5pdCIgb2YgdGhlIGRlc2NyaXB0b3Jz
IGlzIGJldHRlcg0KPiA+IHRoYW4ganVzdCB0cnkgdG8gd2FrZSB0aGUgc3VicXVldWUuIEJ1dCwg
d2hhdCBkbyB5b3UgdGhpbms/DQo+IA0KPiAgICAgRGVmaW5pdGVseSBiZXR0ZXIsIHllcy4uLg0K
DQpJIGdvdCBpdC4NCg0KQmVzdCByZWdhcmRzLA0KWW9zaGloaXJvIFNoaW1vZGENCg0KPiA+IEJl
c3QgcmVnYXJkcywNCj4gPiBZb3NoaWhpcm8gU2hpbW9kYQ0KPiANCj4gTUJSLCBTZXJnZWkNCg==
