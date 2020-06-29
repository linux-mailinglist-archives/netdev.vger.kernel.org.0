Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010EF20D6C6
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732286AbgF2TXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732226AbgF2TWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:22:42 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0601.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22434C02A566;
        Mon, 29 Jun 2020 06:23:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZVd31c1sCZbrLwpIfiwrCpiHNiGry3dUmc0D9ZafZH/LhFYm6pkPJQ+C+h/dYSP7yATaECvwbQB+ReeyuhnV6qDPeenSLVvy5W80hhftPPxwBtzC1dm7x6xmj+eNdp047zXxdtTP7W/Gni9WUHHBnWqrmr589yaoRmXPUNRuP+vhtWKGGeHKAeDv6iCxYOve9WgXILo5XRqOpNJgRBb+QLZlCXJS0Lr+YKRekfPJ3CjzmKJ7jvj9baZ9Tj8ONn5XFQCBZDIyCCqYvvyTCKcoGv0ic1Q04YSR64DEiOQhkq9z6M+ySGQQXg7kcg6VY2I3MvqlLHN2YHFEQoG4X59lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1amHVcgdX65bnf8s84divLoILbcUSjVrRdavIPH9Vnc=;
 b=OKiSIJTwfChQ0PiEBJlJKazcqZcuICgDREE/sqpObpX6iBWaFmc2uVM757p+Zc9ztzFQozXQM43u5/fNTxJnceolaFc5sbG7U9GrPtBXuk4rQAGeroc5uQzf2VbjhCjwj2ffS2V6YZmBvE6FxJYJ8NmzU+QzGAmCjW4Zlfldr0gxDMqVEH7x6Hbi4yf2RBE5zhO1mDaO35Wg284ImEeyIsiB2qRoiSKSTzQypbuRQyJ61g5NZXYUoGFssOvuWkL2mHVZwslJnamiJZrdp71Wt0QQJdrpGa00fe5onM0FXoTzsckHmzbYG2BQA4ei35C+z2hVws1pUWNy5sFIGGwGzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1amHVcgdX65bnf8s84divLoILbcUSjVrRdavIPH9Vnc=;
 b=lbzg/zzXnW1wrDzAzF/OvMSoKxV3v12XHtS2dZ4uwxlqoMT7EYYn/p2F16zPAi7zZRSLVemYMB9OuSh4qlEG5JLhHI+NG2cNbxsxCDtSd1HL4NWX2eROJYtKCF090RGpnNJIfrxN84Kbeaforqy5/2c4VzXctNw7vRDrwHyo75o=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5444.eurprd04.prod.outlook.com (2603:10a6:208:114::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 13:23:21 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 13:23:21 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next v3 4/7] net: phy: add backplane kr
 driver support
Thread-Topic: [EXT] Re: [PATCH net-next v3 4/7] net: phy: add backplane kr
 driver support
Thread-Index: AQHWSJoOSv10qY8hR027u6Fzd8TnaKjksHoAgAAAoSCABpcfgIAETVgQ
Date:   Mon, 29 Jun 2020 13:23:21 +0000
Message-ID: <AM0PR04MB54437450D9A5CBAE5CB3FF45FB6E0@AM0PR04MB5443.eurprd04.prod.outlook.com>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
 <1592832924-31733-5-git-send-email-florinel.iordache@nxp.com>
 <20200622142430.GP279339@lunn.ch>
 <AM0PR04MB5443DAF865284ADE78423C64FB970@AM0PR04MB5443.eurprd04.prod.outlook.com>
 <83ff6b40-157e-3f1c-7370-29a0681dfad2@gmail.com>
In-Reply-To: <83ff6b40-157e-3f1c-7370-29a0681dfad2@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.126.18.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7a6cbb62-42aa-42d4-7e25-08d81c2f9821
x-ms-traffictypediagnostic: AM0PR04MB5444:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB54448524617E1AFE5EB06BEDFB6E0@AM0PR04MB5444.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cLizEL72jA0IF/O36H/NbZ9rsTyimMSYxMlj9pcFE7s59rQV3xEpazc5U/g6HNDjYcuqxWp7IhUla/IsTsaC1XyYHjWp84kEAuitd4jAfEkewC1oBhsJ8Bdl3jPV79qTKN6W+JewZdQdTUGFCMYQ7sA5upalBQTFNwSmmrwYj2cJ0sWjIXC4gf+679Od2FBX/BbdUI/uAUqEilBuac2YPB+YTJzUYYWs33Q5qrSK6HebL12nkl1pyEQEZZF4y7ddyaKImiVNIHiR4tTjDOEWV8SzjK1vW4Z9yYjtpCf5NO6LUm6tOmyCwgC2YYmluIwvQ1GhXEP41Ji7SXoR0W2epQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(76116006)(4326008)(52536014)(7696005)(86362001)(5660300002)(6506007)(53546011)(54906003)(110136005)(71200400001)(66446008)(64756008)(66556008)(66476007)(66946007)(55016002)(7416002)(44832011)(186003)(26005)(8676002)(33656002)(9686003)(8936002)(498600001)(83380400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Vu1Oz7F42vGfMOpEENdpNjNRoe5BAdKhbuMlzeWX2N/u44RLDNj6o0TBbbuhS7Qh+a69toCpP+IERrWrMAwPwRSYwnYvZnPl076RUv3sq9Gj+1UM3xLrZsv8HITAmutJ0HbfwicEEbrgJ8ks0M3shBKpYyHGlzURO1Cty9gXPKgkg9U+x05QlznTvJ3WyXzbxYa5ETTwgUaOSJiSDS5FjeqgwNM3fL3FkKl+Uu1vhtfyiWRJe/q3UTdGR+cRKYP3FzLhLCL2mmd8MVLtBOx2RFRhxi15JQEuX8HUPePMA+jxKA7NnMvTDq7kNHXzKUXDxS2j09NZixvk/SEklL35TfzB3NVMiUKfrmq2VEUqBavKKqu5snsboW9oTxm7D3yoEw8PFGqH8GsC26Qg8/Z3dAJH2sin1x+9npMxrJsRUMT1h6vj4JrZakTtKEaBfnbZHjIb3QXDj+a9ns08FSMlwPjEFAAqCdhAmeiVrFeDMYQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5443.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6cbb62-42aa-42d4-7e25-08d81c2f9821
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 13:23:21.3248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qisXWL2VjeOVE+mCeyy/MFBptV2k2Fim2PxgK817rNDSt/wnoerp0w+hkiGjDp29vaJ/nmAYYc5kUAoVbbItZUP2FQL3RFlS2jyCJvO8PRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5444
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGbG9yaWFuIEZhaW5lbGxpIDxm
LmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBKdW5lIDI2LCAyMDIwIDEwOjA1
IFBNDQo+IFRvOiBGbG9yaW5lbCBJb3JkYWNoZSA8ZmxvcmluZWwuaW9yZGFjaGVAbnhwLmNvbT47
IEFuZHJldyBMdW5uDQo+IDxhbmRyZXdAbHVubi5jaD4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5u
ZXQ7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGhrYWxsd2VpdDFAZ21haWwuY29tOw0KPiBsaW51
eEBhcm1saW51eC5vcmcudWs7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1kb2NA
dmdlci5rZXJuZWwub3JnOw0KPiByb2JoK2R0QGtlcm5lbC5vcmc7IG1hcmsucnV0bGFuZEBhcm0u
Y29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+IGNvcmJldEBsd24ubmV0OyBzaGF3bmd1b0BrZXJuZWwu
b3JnOyBMZW8gTGkgPGxlb3lhbmcubGlAbnhwLmNvbT47IE1hZGFsaW4NCj4gQnVjdXIgKE9TUykg
PG1hZGFsaW4uYnVjdXJAb3NzLm54cC5jb20+OyBJb2FuYSBDaW9ybmVpDQo+IDxpb2FuYS5jaW9y
bmVpQG54cC5jb20+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJl
OiBbRVhUXSBSZTogW1BBVENIIG5ldC1uZXh0IHYzIDQvN10gbmV0OiBwaHk6IGFkZCBiYWNrcGxh
bmUga3IgZHJpdmVyDQo+IHN1cHBvcnQNCj4gDQo+IENhdXRpb246IEVYVCBFbWFpbA0KPiANCj4g
T24gNi8yMi8yMCA3OjM5IEFNLCBGbG9yaW5lbCBJb3JkYWNoZSB3cm90ZToNCj4gPj4gLS0tLS1P
cmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4gRnJvbTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5u
LmNoPg0KPiA+PiBTZW50OiBNb25kYXksIEp1bmUgMjIsIDIwMjAgNToyNSBQTQ0KPiA+PiBUbzog
RmxvcmluZWwgSW9yZGFjaGUgPGZsb3JpbmVsLmlvcmRhY2hlQG54cC5jb20+DQo+ID4+IENjOiBk
YXZlbUBkYXZlbWxvZnQubmV0OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiA+PiBmLmZhaW5l
bGxpQGdtYWlsLmNvbTsgaGthbGx3ZWl0MUBnbWFpbC5jb207IGxpbnV4QGFybWxpbnV4Lm9yZy51
azsNCj4gPj4gZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWRvY0B2Z2VyLmtlcm5l
bC5vcmc7DQo+ID4+IHJvYmgrZHRAa2VybmVsLm9yZzsgbWFyay5ydXRsYW5kQGFybS5jb207IGt1
YmFAa2VybmVsLm9yZzsNCj4gPj4gY29yYmV0QGx3bi5uZXQ7IHNoYXduZ3VvQGtlcm5lbC5vcmc7
IExlbyBMaSA8bGVveWFuZy5saUBueHAuY29tPjsNCj4gPj4gTWFkYWxpbiBCdWN1ciAoT1NTKSA8
bWFkYWxpbi5idWN1ckBvc3MubnhwLmNvbT47IElvYW5hIENpb3JuZWkNCj4gPj4gPGlvYW5hLmNp
b3JuZWlAbnhwLmNvbT47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4gU3ViamVj
dDogW0VYVF0gUmU6IFtQQVRDSCBuZXQtbmV4dCB2MyA0LzddIG5ldDogcGh5OiBhZGQgYmFja3Bs
YW5lIGtyDQo+ID4+IGRyaXZlciBzdXBwb3J0DQo+ID4+DQo+ID4+IENhdXRpb246IEVYVCBFbWFp
bA0KPiA+Pg0KPiA+PiBPbiBNb24sIEp1biAyMiwgMjAyMCBhdCAwNDozNToyMVBNICswMzAwLCBG
bG9yaW5lbCBJb3JkYWNoZSB3cm90ZToNCj4gPj4+IEFkZCBzdXBwb3J0IGZvciBiYWNrcGxhbmUg
a3IgZ2VuZXJpYyBkcml2ZXIgaW5jbHVkaW5nIGxpbmsgdHJhaW5pbmcNCj4gPj4+IChpZWVlODAy
LjNhcC9iYSkgYW5kIGZpeGVkIGVxdWFsaXphdGlvbiBhbGdvcml0aG0NCj4gPj4NCj4gPj4gSGkg
RmxvcmluZWwNCj4gPj4NCj4gPj4gVGhpcyBpcyBzdGlsbCBhIFBIWSBkZXZpY2UuIEkgZG9uJ3Qg
cmVtZW1iZXIgYW55IGRpc2N1c3Npb25zIHdoaWNoDQo+ID4+IHJlc29sdmVkIHRoZSBpc3N1ZXMg
b2YgaWYgYXQgdGhlIGVuZCBvZiB0aGUgYmFja3BsYW5lIHRoZXJlIGlzIGFub3RoZXIgUEhZLg0K
PiA+Pg0KPiA+PiBJdCBtYWtlcyBsaXR0bGUgc2Vuc2UgdG8gcmVwb3N0IHRoaXMgY29kZSB1bnRp
bCB3ZSBoYXZlIHRoaXMgcHJvYmxlbQ0KPiA+PiBkaXNjdXNzZWQgYW5kIGEgd2F5IGZvcndhcmQg
ZGVjaWRlZCBvbi4gSXQgZml0cyBpbnRvIHRoZSBkaXNjdXNzaW9uDQo+ID4+IFJ1c3NlbGwgYW5k
IElvYW5hIGFyZSBoYXZpbmcgYWJvdXQgcmVwcmVzZW50aW5nIFBDUyBkcml2ZXJzLiBQbGVhc2UN
Cj4gY29udHJpYnV0ZSB0byB0aGF0Lg0KPiA+Pg0KPiA+PiAgICAgICAgIEFuZHJldw0KPiA+DQo+
ID4gSGkgQW5kcmV3LA0KPiA+DQo+ID4gWWVzLCB5b3UgYXJlIHJpZ2h0OiB3ZSBkZWNpZGVkIHRv
IHNlbmQgb25seSBzdXBwb3J0IGZvciBEUEFBMSB1c2luZw0KPiA+IGN1cnJlbnQgYXBwcm9hY2gg
YXMgYSBQSFkgZGV2aWNlIChhcyBtZW50aW9uZWQgaW4gY292ZXItbGV0dGVyKSwgdW50aWwgUENT
DQo+IHJlcHJlc2VudGF0aW9uIHdpbGwgYmUgZnVsbHkgY2xhcmlmaWVkLg0KPiA+IFRoZSBlbnRp
cmUgRFBBQTIgc3VwcG9ydCB3YXMgcmVtb3ZlZCBmb3Igbm93LCB0b2dldGhlciB3aXRoIHBoeWxp
bmsNCj4gY2hhbmdlcy4NCj4gPiBEUEFBMSBtYWludGFpbmVyIChNYWRhbGluIEJ1Y3VyKSBhZ3Jl
ZXMgd2l0aCBjdXJyZW50IHJlcHJlc2VudGF0aW9uIGFzIGEgUEhZDQo+IGRldmljZSBmb3IgRFBB
QTEuDQo+ID4gU28gd2Ugd291bGQgbGlrZSB0byBoYXZlIHNvbWUgZGlzY3Vzc2lvbnMgYXJvdW5k
IHRoaXMgYXBwcm9hY2ggZm9yIERQQUExDQo+IG9ubHksIGFzIGl0IHNlZW1zIHN1aXRhYmxlIGZv
ciB1cy4NCj4gDQo+IFRoZSBxdWVzdGlvbiBpcyByZWFsbHkgd2hldGhlciBpdCBpcyBzdWl0YWJs
ZSBmb3Igb3RoZXJzIGJleW9uZCBOWFAsIHRoZSBkcml2ZXJzDQo+IGFyZSBjZXJ0YWlubHkgb3Jn
YW5pemVkIGluIHN1Y2ggYSB3YXkgdGhhdCB0aGVyZSBpcyBsaXR0bGUgTlhQIHNwZWNpZmljcyBp
biB0aGVtIHNvDQo+IHRoZSBpbnRlbnQgaXMgY2xlYXJseSB0aGVyZS4NCj4gDQo+IFdlIHdpbGwg
cHJvYmFibHkgbm90IGtub3csIGVpdGhlciBiZWNhdXNlIHZlbmRvcnMgaGF2ZSBkZWNpZGVkIHRv
IGhpZGUgYWxsIG9mDQo+IHRoaXMgc3R1ZmYgdW5kZXIgZmlybXdhcmUsIG9yIHRoZXkgZG8gbm90
IHVzZSBMaW51eCBvciB0aGV5IGp1c3QgYXJlIG5vdCBmb2xsb3dpbmcNCj4gd2hhdCBpcyBnb2lu
ZyBvbiB1cHN0cmVhbSBhbmQgaGF2ZSBubyBkZXNpcmUgdG8gcGFydGljaXBhdGUuDQo+IC0tDQo+
IEZsb3JpYW4NCg0KSGkgRmxvcmlhbiwNClRoaXMgaXMgY29ycmVjdDogYmFja3BsYW5lIHN1cHBv
cnQgaGFzIGEgbW9kdWxhciwgZXh0ZW5zaWJsZSwgZ2VuZXJpYyBhcmNoaXRlY3R1cmUNCmFuZCB0
aGUgbW9kdWxlcyBhcmUgY29tcGxldGVseSBkaXNjb25uZWN0ZWQNCnNvIHRoZXkgY2FuIGJlIHJl
dXNlZCBhbW9uZyBkaWZmZXJlbnQgY29uZmlndXJhdGlvbnMgc2V0dXBzLg0KVGhlcmVmb3JlIHdl
IGhhdmUgZW5jYXBzdWxhdGVkIHRoZSBzdGFuZGFyZCBiYWNrcGxhbmUgZnVuY3Rpb25hbGl0eSBp
biBzZXZlcmFsDQpnZW5lcmljIG1vZHVsZXMgbGlrZTogRXRoZXJuZXQgQmFja3BsYW5lIEdlbmVy
aWMgRHJpdmVyLCBMaW5rIFRyYWluaW5nIGFuZA0KQXV0by1uZWdvdGlhdGlvbiBpbmNsdWRpbmc6
IElFRUUgODAyLjMtYXAvYmEgc3RhbmRhcmRzLCBFcXVhbGl6YXRpb24gQWxnb3JpdGhtcw0KKHRo
YXQgaW5jbHVkZTogRml4ZWQgYWxnb3JpdGhtIGFuZCBCRUUgLSBCaXQgRWRnZSBlcXVhbGl6YXRp
b24gYWxnb3JpdGhtKS4NCkRldmljZSBzcGVjaWZpYyBtb2R1bGVzIGFyZSB1c2VkIHRvIGVuYWJs
ZSBRb3JJUSBmYW1pbHkgb2YgZGV2aWNlcy4NClRoaXMgYXJjaGl0ZWN0dXJlIGlzIGRlc2NyaWJl
ZCBpbiBkZXRhaWwgaW4gRG9jIGZpbGU6IGJhY2twbGFuZS5yc3QNCk90aGVyIHZlbmRvcnMgdGhh
dCB3YW50IHRvIGVuYWJsZSBiYWNrcGxhbmUgZm9yIHRoZWlyIGRldmljZXMgc2hvdWxkDQphZGQg
b25seSB0aGVpciBkZXZpY2Ugc3BlY2lmaWMgbW9kdWxlcyAoc2ltaWxhciB3aXRoIHFvcmlxIG1v
ZHVsZXMpLg0KVGhlc2UgbW9kdWxlcyBiYXNpY2FsbHkgbXVzdCBkZXNjcmliZSBkZXZpY2Ugc3Bl
Y2lmaWMgcmVnaXN0ZXJzIGFuZA0KbWFrZSB0aGUgY29ubmVjdGlvbiBiZXR3ZWVuIGJhY2twbGFu
ZSBnZW5lcmljIEFQSSBzZXJ2aWNlcyBhbmQgZGV2aWNlIHNwZWNpZmljIG9wZXJhdGlvbnMuDQpB
bGwgZ2VuZXJpYyBtb2R1bGVzIHRoYXQgZW5jYXBzdWxhdGUgc3RhbmRhcmQgYmFja3BsYW5lIGZ1
bmN0aW9uYWxpdHkgY2FuIGJlDQpyZXVzZWQgYnkgb3RoZXIgdmVuZG9ycyBidXQgdGhpcyBpcyBu
b3QgbWFuZGF0b3J5Lg0KT3RoZXIgdmVuZG9ycyBjYW4gZXh0ZW5kIGN1cnJlbnQgYXJjaGl0ZWN0
dXJlIHdpdGggbmV3IGdlbmVyaWMgbW9kdWxlczoNCmZvciBleGFtcGxlIG90aGVyIGVxdWFsaXph
dGlvbiBhbGdvcml0aG1zIGFuZCBzdGFuZGFyZHMgY2FuIGJlIGFkZGVkIGluIHRoZSBmdXR1cmUN
CmlmIGN1cnJlbnRseSBleGlzdGluZyBvbmVzIGFyZSBub3QgZGVzaXJlZCBvciBjb25zaWRlcmVk
IGluYXBwcm9wcmlhdGUuDQpUaGVyZSBhcmUgc2V2ZXJhbCBvdGhlciBzdGFuZGFyZCBhbGdvcml0
aG1zIGF2YWlsYWJsZSB0aGF0IGNhbiBiZSB1c2VkIGZvcg0KU2lnbmFsIGVxdWFsaXphdGlvbjog
dGhleSBqdXN0IGhhdmUgdG8gYmUgaW1wbGVtZW50ZWQgYW5kIGludGVncmF0ZWQgaGVyZS4NCk9m
IGNvdXJzZSB3ZSB2YWxpZGF0ZWQgdGhpcyBiYWNrcGxhbmUgYXJjaGl0ZWN0dXJlIG9ubHkgb24g
TlhQIHBsYXRmb3JtcyAoYnkgdXNpbmcgUW9ySVEgZGV2aWNlcykNCmJ1dCBvdGhlciB2ZW5kb3Jz
IHdpbGwgYmUgYWJsZSB0byB1c2UgaXQgaW4gdGhlIGZ1dHVyZSBvbiB0aGVpciBvd24gcGxhdGZv
cm1zLg0KVGhhbmsgeW91IGZvciBmZWVkYmFjaywNCkZsb3JpbmVsLg0K
