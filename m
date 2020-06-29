Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1968220DFFE
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbgF2Ulu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731664AbgF2TOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:05 -0400
Received: from JPN01-OS2-obe.outbound.protection.outlook.com (mail-os2jpn01on070a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe9c::70a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55542C00864D;
        Mon, 29 Jun 2020 03:08:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNidqBogWk66AhwJbjxamwFbGl+05NfN7ClMmsWjvV+ql+8S0ziSbC2s/Ce8nTLFrjphWCN7i+LrZGWLPmHPmDyTa3oQDiwUvgS2Qdz2EKyadMixFZUBVj8W3gF/u2+HSNaR6/WkicLkukg1iXX2oUIUiosoxdF4aOny+xCLlGNIoND9odzAcWswIHLn1McrBvXb3DE3z1CLZu2mWJNk8tbImVQJRNe0wVfw5rDOJ94IPGGQmh5rPiE8cZ/4inxFoY7iUVpmxjvNIWGMUVFQnejnpSkG5sFipaAh62jymrHrRcleI3Z421b45xHuugy1ZxGxDlOO4IYmepLT/c17BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peydagHXY2ALoQZ6xVNc7/54AQj9iBT+/LAOG7kQsxI=;
 b=Er2TQnWURIweYCxqIfSK3DLcSS+5CG22Kia/k2SpkcwPLSN5qmZzRQromuN4pIgMpYgkNYIE0RpYNr7F2tGDd4Ht1qubu1c3aQVsFSTaZGQ+xl/ViL20et8R13WjM/Vr+BpelBQd5FNVDSFMLbFTNeEIY08Jckru+dXNWFXEBm2tI+HdXnqCrvokN3yxnwVJ1cgSXN9eQWlU1YYxVvAyLzZFHGWjv16EROBP+zo+vfNN63bWWgB7ZXxc73mmti1SA+fWEIz22OMzdV2/SY8lLERp6n1nG+zkVEsXBacPXK4WwBu1J+Qiz2hYF9vFQDGjwLmususEwWtJQ2ADawBn1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peydagHXY2ALoQZ6xVNc7/54AQj9iBT+/LAOG7kQsxI=;
 b=m9v8aoCjY++TnzmheszSimerTmdyhalXUFhILnCUfE7+CfueuOgdyrABCGCNLUyXMc26P3Xby8+j+MjIb0XSmg6WO+Bnzyu9FYGYA9/vuBqbg1yplk7GM4R8Xukw1MvnUuCl+CWKuBCS/lUFf/Gd1nUTgVY+mFNuSJWRjk8lFTU=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYAPR01MB2688.jpnprd01.prod.outlook.com (2603:1096:404:81::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 10:08:31 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3%6]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 10:08:31 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
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
Thread-Index: AQHWM0Kg7roEc2K3tEugD8qfTO7LKKjZTL9ggAAmMYCABhvkIIAPtGcQgAA4GgCAABfroA==
Date:   Mon, 29 Jun 2020 10:08:30 +0000
Message-ID: <TY2PR01MB36925830AB31323A980BD6A7D86E0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <1590486419-9289-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <TY2PR01MB369266A27D1ADF5297A3CFFCD89C0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <9f71873b-ee5e-7ae3-8a5a-caf7bf38a68e@gmail.com>
 <TY2PR01MB36926D80F2080A3D6109F11AD8980@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <TY2PR01MB36926B67ED0643A9EAA9A4F3D86E0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <a1dc573d-78b0-7137-508d-efcdfa68d936@cogentembedded.com>
In-Reply-To: <a1dc573d-78b0-7137-508d-efcdfa68d936@cogentembedded.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: cogentembedded.com; dkim=none (message not signed)
 header.d=none;cogentembedded.com; dmarc=none action=none
 header.from=renesas.com;
x-originating-ip: [240f:60:5f3e:1:d114:9c0b:3419:c431]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 631df7c9-8b2a-4455-6146-08d81c146019
x-ms-traffictypediagnostic: TYAPR01MB2688:
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-microsoft-antispam-prvs: <TYAPR01MB268808C89D65C3A3EDFC4980D86E0@TYAPR01MB2688.jpnprd01.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P4ALNGz2bMEoAOpJ54zwRT67PnGWM/k6FXMG2/rLYoG0jc9vQo7v8bpmoMcvJvLhXbnuQzUWD3VvRlksE85ACxltV2mKGWbor0zESOSqdyD6qQFu+XkBCdtU48BoyCz6LIFEGyfitoKgE/4LDsL1wLHuVZua9YWb7u0aVZ4/mHjx4a3dVKwt4hoe9M5rSYHaseoq1KaucWgCc4afHQwXHoN2uLccc5M4C4J/DKvXymzK2XaO9xMANdod/zOiJJ7WrHzZX1G4L5bAHfOvOIwhs0B3BUZOEn5kdkcUrfYzdEs4Regdc1in3gBWZc2Knc1dhe6poS4OPhIdl2ZcUDbppu2DUSGt+6cypZ5Pbe0xNVQRG4jtLeL7SmZhHw/YbGQvBfdCBZqgQ2Nh+zRa1Lyeeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(66476007)(55016002)(9686003)(83380400001)(33656002)(71200400001)(966005)(478600001)(86362001)(53546011)(76116006)(7696005)(316002)(64756008)(66556008)(66946007)(8676002)(66446008)(186003)(110136005)(5660300002)(4326008)(2906002)(54906003)(52536014)(6506007)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9lE6ynawd+bNdCnWZG1GmInysO3iDY2Jv5y/1Wly2j0sk/txkEWzvrT1aiCfOOf97tEfyqaUXu4PaDEPQgjt/LnSazXBDLeqR6mhKyfBH+SZUOJIxgiRLf1FDt3YJliZVAU0HH3vJNr6dw8kP81LnETJHsaAbjlN0uGFcDYz8NS5+tGTgH1+BGzGRr6vEqxecFfUTEMNtZEwtxHZGECuP13M5Hutmu/YCFgrV50PpV3M25pFA9dCefG2bYLGos5BTe4beD6Yx9RVf260fFOnzfPKYNQphd/xx5U4YHCwMQFygE7G4XdJAu2O2LcUhGKhn2vllak0116SHMW0dQUVbcJk2J+/3nu2FUPmztEJuE5IZnhRbrh45WImzJxXL/cOX/XzlzpvmL4NFl6MfTyc3V5oEgo9m9c/zBAUF6nrYYlX9OKoRhsa6awAQrv//sA65MEByDLm6ahqf9YQpodH8DDD6hFUYz8/mBR4MN58o5iH3Qp6g2sRCUy1kEWZV4Xvbg6jgLPxQQbX3VLow2BNfubq6l6LM2e/7zfZ0kGgXfw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631df7c9-8b2a-4455-6146-08d81c146019
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 10:08:30.9115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RVHENWTDTLt0UtWnNBQY45FMNaLJZfhHJOWu2g+GCaKimPfSKePhBO3RNbFHnSOT3UMbmrknZm+xwIHM4YScqD5KeCjv66LKq/Hwossm2nk9JzhuA4ovID3otnu18pC6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2688
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8hDQoNCj4gRnJvbTogU2VyZ2VpIFNodHlseW92LCBTZW50OiBNb25kYXksIEp1bmUgMjks
IDIwMjAgNTo0MCBQTQ0KPiANCj4gSGVsbG8hDQo+IA0KPiBPbiAyOS4wNi4yMDIwIDg6MjQsIFlv
c2hpaGlybyBTaGltb2RhIHdyb3RlOg0KPiANCj4gPj4+Pj4gRnJvbTogWW9zaGloaXJvIFNoaW1v
ZGEsIFNlbnQ6IFR1ZXNkYXksIE1heSAyNiwgMjAyMCA2OjQ3IFBNDQo+ID4+Pj4+DQo+ID4+Pj4+
IEFjY29yZGluZyB0byB0aGUgcmVwb3J0IG9mIFsxXSwgdGhpcyBkcml2ZXIgaXMgcG9zc2libGUg
dG8gY2F1c2UNCj4gPj4+Pj4gdGhlIGZvbGxvd2luZyBlcnJvciBpbiByYXZiX3R4X3RpbWVvdXRf
d29yaygpLg0KPiA+Pj4+Pg0KPiA+Pj4+PiByYXZiIGU2ODAwMDAwLmV0aGVybmV0IGV0aGVybmV0
OiBmYWlsZWQgdG8gc3dpdGNoIGRldmljZSB0byBjb25maWcgbW9kZQ0KPiA+Pj4+Pg0KPiA+Pj4+
PiBUaGlzIGVycm9yIG1lYW5zIHRoYXQgdGhlIGhhcmR3YXJlIGNvdWxkIG5vdCBjaGFuZ2UgdGhl
IHN0YXRlDQo+ID4+Pj4+IGZyb20gIk9wZXJhdGlvbiIgdG8gIkNvbmZpZ3VyYXRpb24iIHdoaWxl
IHNvbWUgdHggcXVldWUgaXMgb3BlcmF0aW5nLg0KPiA+Pj4+PiBBZnRlciB0aGF0LCByYXZiX2Nv
bmZpZygpIGluIHJhdmJfZG1hY19pbml0KCkgd2lsbCBmYWlsLCBhbmQgdGhlbg0KPiA+Pj4+PiBh
bnkgZGVzY3JpcHRvcnMgd2lsbCBiZSBub3QgYWxsb2NhbGVkIGFueW1vcmUgc28gdGhhdCBOVUxM
IHBvcmludGVyDQo+ID4+Pj4+IGRlcmVmZXJlbmNlIGhhcHBlbnMgYWZ0ZXIgdGhhdCBvbiByYXZi
X3N0YXJ0X3htaXQoKS4NCj4gPj4+Pj4NCj4gPj4+Pj4gU3VjaCBhIGNhc2UgaXMgcG9zc2libGUg
dG8gYmUgY2F1c2VkIGJlY2F1c2UgdGhpcyBkcml2ZXIgc3VwcG9ydHMNCj4gPj4+Pj4gdHdvIHF1
ZXVlcyAoTkMgYW5kIEJFKSBhbmQgdGhlIHJhdmJfc3RvcF9kbWEoKSBpcyBwb3NzaWJsZSB0byBy
ZXR1cm4NCj4gPj4+Pj4gd2l0aG91dCBhbnkgc3RvcHBpbmcgcHJvY2VzcyBpZiBUQ0NSIG9yIENT
UiByZWdpc3RlciBpbmRpY2F0ZXMNCj4gPj4+Pj4gdGhlIGhhcmR3YXJlIGlzIG9wZXJhdGluZyBm
b3IgVFguDQo+ID4+Pj4+DQo+ID4+Pj4+IFRvIGZpeCB0aGUgaXNzdWUsIGp1c3QgdHJ5IHRvIHdh
a2UgdGhlIHN1YnF1ZXVlIG9uDQo+ID4+Pj4+IHJhdmJfdHhfdGltZW91dF93b3JrKCkgaWYgdGhl
IGRlc2NyaXB0b3JzIGFyZSBub3QgZnVsbCBpbnN0ZWFkDQo+ID4+Pj4+IG9mIHN0b3AgYWxsIHRy
YW5zZmVycyAoYWxsIHF1ZXVlcyBvZiBUWCBhbmQgUlgpLg0KPiA+Pj4+Pg0KPiA+Pj4+PiBbMV0N
Cj4gPj4+Pj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtcmVuZXNhcy1zb2MvMjAyMDA1
MTgwNDU0NTIuMjM5MC0xLWRpcmsuYmVobWVAZGUuYm9zY2guY29tLw0KPiA+Pj4+Pg0KPiA+Pj4+
PiBSZXBvcnRlZC1ieTogRGlyayBCZWhtZSA8ZGlyay5iZWhtZUBkZS5ib3NjaC5jb20+DQo+ID4+
Pj4+IFNpZ25lZC1vZmYtYnk6IFlvc2hpaGlybyBTaGltb2RhIDx5b3NoaWhpcm8uc2hpbW9kYS51
aEByZW5lc2FzLmNvbT4NCj4gPj4+Pj4gLS0tDQo+ID4+Pj4+ICAgIEknbSBndWVzc2luZyB0aGF0
IHRoaXMgaXNzdWUgaXMgcG9zc2libGUgdG8gaGFwcGVuIGlmOg0KPiA+Pj4+PiAgICAtIHJhdmJf
c3RhcnRfeG1pdCgpIGNhbGxzIG5ldGlmX3N0b3Bfc3VicXVldWUoKSwgYW5kDQo+ID4+Pj4+ICAg
IC0gcmF2Yl9wb2xsKCkgd2lsbCBub3QgYmUgY2FsbGVkIHdpdGggc29tZSByZWFzb24sIGFuZA0K
PiA+Pj4+PiAgICAtIG5ldGlmX3dha2Vfc3VicXVldWUoKSB3aWxsIGJlIG5vdCBjYWxsZWQsIGFu
ZCB0aGVuDQo+ID4+Pj4+ICAgIC0gZGV2X3dhdGNoZG9nKCkgaW4gbmV0L3NjaGVkL3NjaF9nZW5l
cmljLmMgY2FsbHMgbmRvX3R4X3RpbWVvdXQoKS4NCj4gPj4+Pj4NCj4gPj4+Pj4gICAgSG93ZXZl
ciwgdW5mb3J0dW5hdGVseSwgSSBkaWRuJ3QgcmVwcm9kdWNlIHRoZSBpc3N1ZSB5ZXQuDQo+ID4+
Pj4+ICAgIFRvIGJlIGhvbmVzdCwgSSdtIGFsc28gZ3Vlc3Npbmcgb3RoZXIgcXVldWVzIChTUikg
b2YgdGhpcyBoYXJkd2FyZQ0KPiA+Pj4+PiAgICB3aGljaCBvdXQtb2YgdHJlZSBkcml2ZXIgbWFu
YWdlcyBhcmUgcG9zc2libGUgdG8gcmVwcm9kdWNlIHRoaXMgaXNzdWUsDQo+ID4+Pj4+ICAgIGJ1
dCBJIGRpZG4ndCB0cnkgc3VjaCBlbnZpcm9ubWVudCBmb3Igbm93Li4uDQo+ID4+Pj4+DQo+ID4+
Pj4+ICAgIFNvLCBJIG1hcmtlZCBSRkMgb24gdGhpcyBwYXRjaCBub3cuDQo+ID4+Pj4NCj4gPj4+
PiBJJ20gYWZyYWlkLCBidXQgZG8geW91IGhhdmUgYW55IGNvbW1lbnRzIGFib3V0IHRoaXMgcGF0
Y2g/DQo+ID4+Pg0KPiA+Pj4gICAgICBJIGFncmVlIHRoYXQgd2Ugc2hvdWxkIG5vdyByZXNldCBv
bmx5IHRoZSBzdHVjayBxdWV1ZSwgbm90IGJvdGggYnV0IEkNCj4gPj4+IGRvdWJ0IHlvdXIgc29s
dXRpb24gaXMgZ29vZCBlbm91Z2guIExldCBtZSBoYXZlIGFub3RoZXIgbG9vay4uLg0KPiA+Pg0K
PiA+PiBUaGFuayB5b3UgZm9yIHlvdXIgY29tbWVudCEgSSBob3BlIHRoaXMgc29sdXRpb24gaXMg
Z29vZCBlbm91Z2guLi4NCj4gPg0KPiA+IEknbSBzb3JyeSBhZ2FpbiBhbmQgYWdhaW4uIEJ1dCwg
ZG8geW91IGhhdmUgYW55IHRpbWUgdG8gbG9vayB0aGlzIHBhdGNoPw0KPiANCj4gICAgIFllcywg
aW4gdGhlIHNlbnNlIG9mIHJldmlld2luZyAtLSBJIGRvbid0IGNvbnNpZGVyIGl0IGNvbXBsZXRl
LiBBbmQgbm8sIGluDQo+IHRoZSBzZW5zZSBvZiBsb29raW5nIGludG8gdGhlIGlzc3VlIG15c2Vs
Zi4uLiBDYW4gd2UgZG8gYSBwZXItcXVldWUgdGVhci1kb3duDQo+IGFuZCByZS1pbml0IChub3Qg
bmVjZXNzYXJpbHkgYWxsIGluIDEgcGF0Y2gpPw0KDQpUaGFuayB5b3UgZm9yIHlvdXIgcmVwbHkh
IFNpbmNlIEknbSBhc2tpbmcgUmVuZXNhcyBpbnRlcm5hbCBtZW1iZXJzIGFib3V0IHRoaXMsDQpw
bGVhc2Ugd2FpdCBmb3IgYSBsaXR0bGUuDQojIEkgZG9uJ3QgdGhpbmsgd2UgY2FuIGRvIGEgcGVy
LXF1ZXUgdGVhci1kb3duIGFuZCByZS1pbml0IHRob3VnaC4uLg0KDQpCZXN0IHJlZ2FyZHMsDQpZ
b3NoaWhpcm8gU2hpbW9kYQ0KDQo+ID4gQmVzdCByZWdhcmRzLA0KPiA+IFlvc2hpaGlybyBTaGlt
b2RhDQo+IA0KPiBNQlIsIFNlcmdlaQ0K
