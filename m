Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3108822559B
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgGTBsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:48:40 -0400
Received: from mail-eopbgr1410138.outbound.protection.outlook.com ([40.107.141.138]:30205
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbgGTBsj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 21:48:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBLm2stOJFziHIRqslRKm1uim3NReOMpE7syg+g1s7KnDNwumIfOV6PIrEvVJneAizKuTI6M/DceTqJi13A52eIiXeW2VDW1jPBfOBVzs/upaneLE4r6+zWbsmnN3uy6ieWTUfa2BD0kyqoJit9Mg8uDjiM7r/+kYs89I7RHw7L6D3XzB/SCDhK3zESm1plteDrHrXXzcC6vsb3hqXHg2FK6TinsxymU1YZVl27tffBi0sm3icgsy3h7yFUPzY2ogfyQWbXl8XGaYwhevefFYAr0gceMHqyFAA8SjXs0CYKRONV/b5BkyCMz1VLyJKcTdYXk017MTi+uqSflRbHUVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIrKk/B6xWRL0uPDLfXnWRHc4uw9H8GuXmAAMPVqpwY=;
 b=W+A1STCTb0kACJ8gNJlJNJ8MlqmyjR7M0pRvnFJE+HdvOfmPNZzLPwoKi3JWHqI8jeSJgZRtt88sklWyJWPiiYEZZk3D+exdr0uP7HXxWBL5ppwps+4F3gNfYUA40ioj/C36jmYiGSn9JxzJfQz2fBh1LULuZD1NGTfFuzUADPfAQ309QCSd1PEaofjIPGWnYikRRfudZ96sR8xtZoEqW2Jah3O4KG841aZ8jeO67e0340ICn5FckwheFpUrChV9kwKCBUuOtRSb0CtbHTKbnnlAj/sLdbl4plFUMEm2S0ecEQC7PGwjwFlStdc20AnsqYM9nvmDj8lgSEVg/lTz5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIrKk/B6xWRL0uPDLfXnWRHc4uw9H8GuXmAAMPVqpwY=;
 b=pP4KcSSg4T2MJJ87iE7UHSSMJybGwpTz3Pd76ACLX7xWa9+aDOjNvV0IraoMazzvNqBn3JlgkuYYqBg4ALcYygoY6cdT9vBsy7+PTvmykhfs9iQSpRZoO1ECOm4VSvPA6LBb0Xi8bXEqady5MJIGAsfLw1RcRqim3eVHzsAGznU=
Received: from OSAPR01MB3683.jpnprd01.prod.outlook.com (2603:1096:604:33::12)
 by OSBPR01MB2229.jpnprd01.prod.outlook.com (2603:1096:603:20::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Mon, 20 Jul
 2020 01:48:33 +0000
Received: from OSAPR01MB3683.jpnprd01.prod.outlook.com
 ([fe80::1d16:3e99:8fb2:84e1]) by OSAPR01MB3683.jpnprd01.prod.outlook.com
 ([fe80::1d16:3e99:8fb2:84e1%7]) with mapi id 15.20.3195.025; Mon, 20 Jul 2020
 01:48:33 +0000
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
Thread-Index: AQHWM0Kg7roEc2K3tEugD8qfTO7LKKjZTL9ggAAmMYCABhvkIIAPtGcQgAA4GgCAAVSU0IAI302AgADAfvCAFS0OgIAAaPnQ
Date:   Mon, 20 Jul 2020 01:48:33 +0000
Message-ID: <OSAPR01MB3683625EBE8E3353E99651A0D87B0@OSAPR01MB3683.jpnprd01.prod.outlook.com>
References: <1590486419-9289-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <TY2PR01MB369266A27D1ADF5297A3CFFCD89C0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <9f71873b-ee5e-7ae3-8a5a-caf7bf38a68e@gmail.com>
 <TY2PR01MB36926D80F2080A3D6109F11AD8980@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <TY2PR01MB36926B67ED0643A9EAA9A4F3D86E0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <a1dc573d-78b0-7137-508d-efcdfa68d936@cogentembedded.com>
 <TY2PR01MB3692A9F68ACC62E920EE2965D86F0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <e7e5fd5f-1ed4-7699-1a1f-f4f1bb5495cf@gmail.com>
 <TY2PR01MB3692E49BB082DEF855A3ACBAD8690@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <64414933-c918-1613-255e-880017bc426a@gmail.com>
In-Reply-To: <64414933-c918-1613-255e-880017bc426a@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [240f:60:5f3e:1:a966:8821:c19:abd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 65e45b67-97a9-4df3-5a76-08d82c4f0313
x-ms-traffictypediagnostic: OSBPR01MB2229:
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-microsoft-antispam-prvs: <OSBPR01MB22292FB5B8FFE091B9C3FCCDD87B0@OSBPR01MB2229.jpnprd01.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lLMgOPo5m2+PjdQvCli2rjKdkJgDxk+9qCBIjIb5xFx9nS5kI5mt092TI1axj8ECJzIcEvnzxBeAim5eQdwkn3khLVe25LThHkTN23197CBfvyIWOe3MMHfltDTx6tNuVGIaszuJ4e/90vyQRdpM/pZ771lQL1GfV1zqkxZlBP2W3EMAWITfCHu2LHq7pVEgXK91EqujpxmK4TePR4KpFfsLknle5cOx+oeBzMvyYtUXsIHsVCPbT4lnMPuEARc3OHo7ifRHFV7EXyH4HzLivfNqpuckAFkvRpGj3W3TrnUYG+okTnTyhtuyee+6oCv7Ta0dbjipMRrSAyDUgt/24A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB3683.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(316002)(54906003)(66476007)(33656002)(83380400001)(5660300002)(7696005)(66556008)(9686003)(64756008)(110136005)(66446008)(71200400001)(52536014)(8936002)(66946007)(8676002)(4326008)(76116006)(55016002)(53546011)(478600001)(86362001)(186003)(2906002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: m1AT6S+lLbJbgwwzVkWq+O50nQR3jvLZ42kUosU3bWqN5f+1VeulgNZefpDFQ/h/yHbuJuESyQH9sdMmnbbbDHb2TnseNQd5bi80gav8v1WRTwj0mzOlC8AEuwgkZBOZZAvQOSNZN02LsTuxfawTbRhTUm+0uvK25YvbSPKexeJ1cJybzcPGalWbCPlamlHp5r4KkNCh46HKUsL0DIlCL3FT4RGzd8CZRO7j1kx7lYZBEC/1t40A9aTmKTlC7yDZqYzpiL5mUzT8PDplFgQG8iY0LmvP9xufFVnmdHSvAyfDoZZl1yvPexNP8Yu1FAvubNmkgd12FMkS1oaFTEZ3qtWLxTf6X5eO32MfhiKTfUPGQruB/2SvHyGNJ3ftZUf1kRqIR9/SGVxO4r4FkiGirqHtBpNeSxi20pFQHETbVfTaLgFI08LvlfijPs42WUdyAKOAPp8c6oMKbwY4jE8j0rpuDl6rhDe4gr1wi7gitLSCbc5f4zMNbDInwyUoOxpfOUd30Ibh/Xjy+61C4VvGz5M+JnD9A523HsRflv4s6Go=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB3683.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e45b67-97a9-4df3-5a76-08d82c4f0313
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 01:48:33.6664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4z/Eb4pRWeBNZjuOEdqN/7tVAalzxNSX+eapklUGhPZ9wT22ZlX/U4yxdQ16FBXH6WD/INaZ0u7lowBl2OhsPV6PD75RGBB6LPYeUyhyw6txevsP1JqucDMyFmRtKa03
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2229
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8hDQoNCj4gRnJvbTogU2VyZ2VpIFNodHlseW92LCBTZW50OiBNb25kYXksIEp1bHkgMjAs
IDIwMjAgNDoyMCBBTQ0KPiANCj4gSGVsbG8hDQo+IA0KPiAgICBTb3JyeSBhYm91dCBhbm90aGVy
IGxhdGUgcmVwbHksIHdhcyBoYXZpbmcgaC93IGlzc3VlcyBvbiB0aGUgbmV3IHdvcmsuLi4NCg0K
Tm8gcHJvYmxlbSEgOikgVGhhbmsgeW91IGZvciB5b3VyIHJlcGx5IQ0KDQo+IE9uIDA3LzA2LzIw
MjAgMTI6MjUgUE0sIFlvc2hpaGlybyBTaGltb2RhIHdyb3RlOg0KPHNuaXA+DQo+ID4+ICAgICBN
YXliZSB3ZSBzaG91bGQganVzdCBmaXggdGhvc2UgYmxpbmQgYXNzdW1wdGlvbnM/DQo+ID4NCj4g
PiBNYXliZSBJIHNob3VsZCBoYXZlIGRlc2NyaWJlZCBzb21lIGZhY3RzIGluc3RlYWQgb2YgYXNz
dW1wdGlvbnMgbGlrZSBiZWxvdz8NCj4gPiBJZiBzbywgSSBzaG91bGQgbW9kaWZ5IHRoZSBjb2Rl
IHRvby4NCj4gPg0KPiA+IEFmdGVyIHJhdmJfc3RvcF9kbWEoKSB3YXMgY2FsbGVkLCB0aGUgZHJp
dmVyIGFzc3VtZWQgYW55IHRyYW5zZmVycyB3ZXJlDQo+ID4gc3RvcHBlZC4gSG93ZXZlciwgdGhl
IGN1cnJlbnQgcmF2Yl90eF90aW1lb3V0X3dvcmsoKSBkb2Vzbid0IGNoZWNrIHdoZXRoZXINCj4g
PiB0aGUgcmF2Yl9zdG9wX2RtYSgpIGlzIHN1Y2NlZWRlZCB3aXRob3V0IGFueSBlcnJvciBvciBu
b3QuIFNvLCB3ZSBzaG91bGQNCj4gPiBmaXggaXQuDQo+IA0KPiAgICBZZXMuIEJldHRlciBhIHN0
dWNrIFRYIHF1ZXVlICh3aXRoIGEgY2hhbmNlIHRvIHJlY292ZXIpIHRoYW4ga2VybmVsIG9vcHMu
Li4NCg0KSSBnb3QgaXQuDQoNCjxzbmlwPg0KPiA+PiAgICAgV2VsbCwgSSB3YXMgdGhpbmtpbmcg
b2YgcG9sbGluZyBUQ0NSIGFuZCBDU1IgbGlrZSB0aGUgY3VycmVudA0KPiA+PiByYXZiX3N0b3Bf
ZG1hKCkgZG9lcywgYnV0IGlmIHRoYXQgd29ya3MuLi4NCj4gPg0KPiA+IEknbSBub3Qgc3VyZSB3
aGV0aGVyIHBvbGxpbmcgVENDUiBhbmQgQ1NSIGlzIGVub3VnaCBvciBub3QuDQo+ID4gSW5zdGVh
ZCBvZiBwb2xsaW5nIHRob3NlIHJlZ2lzdGVycywgbWF5YmUgd2Ugc2hvdWxkIHBvbGwgd2hldGhl
cg0KPiA+IHJhdmJfc3RvcF9kbWEoKSBpcyBzdWNjZWVkZWQgb3Igbm90Pw0KPiANCj4gICAgWWVz
LCBpZiBieSBwb2xsaW5nIHlvdSBtZWFuIGp1c3QgY2hlY2tpbmcgdGhlIHJlc3VsdCBvZiBpdC4g
Oi0pDQoNClllcywgSSBpbnRlbmQgdG8gY2hlY2sgdGhlIHJlc3VsdCBvZiBpdCA6KQ0KDQo+ID4g
RXNwZWNpYWxseSwgcmVzdWx0IG9mIHJhdmJfY29uZmlnKCkgaXMNCj4gPiBhIGtleSBwb2ludCB3
aGV0aGVyIHRoZSBoYXJkd2FyZSBpcyByZWFsbHkgc3RvcHBlZCBvciBub3QuDQo+ID4gU28sIEkn
bSB0aGlua2luZyB0aGF0IGp1c3QgcG9sbGluZyB0aGUgcmF2Yl9zdG9wX2RtYSgpIGluDQo+ID4g
cmF2Yl90eF90aW1lb3V0X3dvcmsoKSBpcyBiZXR0ZXIgdGhhbiB0aGUgcGVyLXF1ZXVlIHRlYXIt
ZG93biBhbmQNCj4gPiByZS1pbml0IG5vdy4gQnV0LCB3aGF0IGRvIHlvdSB0aGluaz8NCj4gDQo+
ICAgIEkgZG9uJ3QgdGhpbmsgaXQncyBiZXR0ZXIgc2luY2Ugd2UncmUgbm93IHN1cHBvc2VkIHRv
IGhhbmRsZSBhIHBlci1xdWV1ZQ0KPiBUWCB0aW1lb3V0IChzdGlsbCBub3Qgc3VyZSBpdCdzIHBv
c3NpYmxlIHdpdGggdGhpcyBoL3cpLiBCdXQgb2YgY291cnNlLCBpdCdzDQo+IGJldHRlciBhcyBp
dCdzIHNpbXBsZSBlbm91Z2ggZm9yIGEgYnVnIGZpeC4NCg0KVGhhbmsgeW91IGZvciB5b3VyIGNv
bW1lbnQuIFllcywgSSBhZ3JlZSBpdCdzIGJldHRlciB0byBoYW5kbGUgYSBwZXItcXVldWUgVFgg
dGltZW91dC4NCkhvd2V2ZXIsIEkgdGhpbmsgd2UgbmVlZCByZWZhY3RvcmluZyBmb3IgaXQuIFNv
LCBJJ2QgbGlrZSB0byBmaXggYSBidWcgYnkgc2ltcGxlIGNvZGUuDQoNCj4gPj4+IDwgUHJlcGFy
ZSBuZXcgZGVzY3JpcHRvcnMgYW5kIHN0YXJ0IGFnYWluID4NCj4gPj4+IDQuIFByZXBhcmUgbmV3
IGRlc2NyaXB0b3JzLg0KPiA+Pg0KPiA+PiAgICAgVGhhdCdzIHdoZXJlIHRoZSBjYXVzZSBmb3Ig
dXNpbmcgdGhlIHdvcmtxdWV1ZSBsaWVzIC0tIHRoZSBkZXNjcmlwdG9ycyBhcmUNCj4gPj4gYWxs
b2NhdGVkIHdpdGggR0ZQX0tFUk5FTCwgbm90IEdGUF9BVE9NSUMuLi4NCj4gPg0KPiA+IElJVUMs
IHdlIGNhbiBhdm9pZCB0byB1c2UgdGhlIHdvcmtxdWV1ZSBpZiByZS1hbGxvY2F0aW9uIGlzIG5v
dCByZWFsbHkgbmVjZXNzYXJ5Lg0KPiA+DQo+ID4+IGlmIHlvdSBoYXZlIHRpbWUvZGVzaXJlIHRv
DQo+ID4+IHVudGFuZ2xlIGFsbCB0aGlzLCBJJ2QgYXBwcmVjaWF0ZSBpdDsgZWxzZSBJJ2QgaGF2
ZSB0byB3b3JrIG9uIHRoaXMgaW4gbXkNCj4gPj4gY29waW91cyBmcmVlIHRpbWUuLi4gOi0pDQo+
ID4NCj4gPiBJZiB3ZSBkb24ndCBuZWVkIHJlZmFjdG9yaW5nLCBJIHRoaW5rIEkgY2FuIGRvIGl0
IDopDQo+IA0KPiAgICBMZXQncyBnbyBmb3J3YXJkIHdpdGggdGhlIHNpbXBsZSBmaXggKGFzc3Vt
aW5nIGl0IGZpeGVzIHRoZSBvcmlnaW5hbCBvb3BzKS4NCg0KVGhhbmsgeW91IGZvciB5b3VyIGNv
bW1lbnQhIEknbGwgZG8gdGhhdC4NCg0KQmVzdCByZWdhcmRzLA0KWW9zaGloaXJvIFNoaW1vZGEN
Cg0KPiBbLi4uXQ0KPiANCj4gTUJSLCBTZXJnZWkNCg==
