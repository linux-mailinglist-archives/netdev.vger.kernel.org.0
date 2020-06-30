Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F02E20ED52
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 07:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgF3FXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 01:23:03 -0400
Received: from mail-eopbgr1400133.outbound.protection.outlook.com ([40.107.140.133]:31505
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726117AbgF3FXC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 01:23:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjAE90L6IaJt7HZF3rxKfD+XfoTRbupQUP+NK6O/nZaIg7qvVtyoYCZkdz2TQCYeNFvqxwaKP5lxS1IQsQIKd0lkN+3YKPnaeHif4on80ZW+ZZpGA9xrfZyTXSz2vNpuC2xuohmO0ECt9eck160WIZTQZ1xn8z/zt0p7PcORrt+7Uvege6FsSdtp+Bi41HWVxIJIORgaQgXRegTu2rIdnUI4nQ8JsPYK+aPgKaalTIZvvMM9rh2MCkAIHPKSIppRhPlqXQoA5RcgxjQSnuSkJvXmsM9h8J4qW7Hmv+SBh8aH3ng2yVySnEVBfgJMaTPbV/f6xgbWOy0/ObVVF7c7Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zTZUqusDL8EtEbQLud8q7/lvtGYQyec+ySF+m4FsqY=;
 b=UiZIc0V11bT5EYqpteHbqPGARrY7ZSEr5o5KBeu8c2HwV1Km4NRARIqy54zhs0SysnUMhBn+TBz7TOPHyClebBIsxaUgUjAdKtmq1pwA/LZ5FBPfBhGIJ3avtdpHFJ+6mSBYQMGQ/vPgJuSsRmRMbSrNSt3zCHmR+O3W2MjL+AqIux8DO8YPX5XMfpFrLP7yyCPxoQLIDOCVvVFpPH/kwzQm6PCZbcqUj8Tml370mIfdaC6gPe6HUyTx3h7Bf7Gtd4vtVGIpVOCy0SrNr0qcdOtX3LLIWOM+yUTcngGKZ5NtgbBbQlVD6KRP5y2VD50k4qAR+iTJClarEC7RmwdSfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zTZUqusDL8EtEbQLud8q7/lvtGYQyec+ySF+m4FsqY=;
 b=rcMKSGWISX6dbi5ULKITJaP2G91HM7OzQns3WiV3BBqGtrSn4avwlNPFbZzM3f4dVj0oeB0ej3aliE1NL3E1q6V0DsOWDrOAZXMixxXM/ULO9a8hROr7GGp+s6Q6TiCaK7sCPf3zYVDLDu5G/8Ejx0wpV7/dHlQ7hd2YzouM8HQ=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYAPR01MB4224.jpnprd01.prod.outlook.com (2603:1096:404:cb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Tue, 30 Jun
 2020 05:22:57 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3%6]) with mapi id 15.20.3131.026; Tue, 30 Jun 2020
 05:22:57 +0000
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
Thread-Index: AQHWM0Kg7roEc2K3tEugD8qfTO7LKKjZTL9ggAAmMYCABhvkIIAPtGcQgAA4GgCAAVSU0A==
Date:   Tue, 30 Jun 2020 05:22:57 +0000
Message-ID: <TY2PR01MB3692A9F68ACC62E920EE2965D86F0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
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
x-originating-ip: [240f:60:5f3e:1:6993:87cc:5ed8:ca72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 049b3113-f112-4236-2fde-08d81cb5a620
x-ms-traffictypediagnostic: TYAPR01MB4224:
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-microsoft-antispam-prvs: <TYAPR01MB4224915055EC845CA0331B79D86F0@TYAPR01MB4224.jpnprd01.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: krJ+BlQOEPY8A6fV6OH65cdWoVhf/8eNEy/OtcPdIhAmw3pqGLHReFZFRD2cEej3UV64vD/nYTSvRO8pzDkYIY5eWgZWRg4V+djXpo5I9IIZyUddXb5e0qio9QPZF30zlk3UNzWekZg+hOXoe77EiBXPP/YXJJAn6QTNXI0fabG55A8uFkADg2X7tyLjoYdT7aZARKnRq5BCWuhg0ZOrXruARw7BI1UfkbFPGg73mpx44qnpTjbmIsdpmuizKnP3QGEVD9j9QgQS36W5LD/e/CsEWISKyfwq1VaVMLc5Xf5+/Kh+SU32uV2Gy297Mqre5j+dnDd21UxcV7D/E1bL8feSa4bRa3IszNw0OBeDaXIkGK/yAGpWzOANI9MLZUdVF9eS81O53uOjzGjLQFykNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(966005)(186003)(4326008)(55016002)(2906002)(7696005)(6506007)(53546011)(478600001)(86362001)(83380400001)(316002)(33656002)(8676002)(71200400001)(8936002)(66446008)(64756008)(66556008)(66476007)(5660300002)(66946007)(9686003)(54906003)(76116006)(110136005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: C15ZasrHeYWECE4aPZ6tXHGliKnnAz6M121kepaDl7f9PLG+1kq5UaVRxulSl+4Adwh9R/qICXAkrXN+fxGo2DJVAq8zThC8ptpQNxr0YUncFElkgIaVnEMDBsTTYTuhZavjjRI2FCICByvb5F2uYVDWcjOn4aFwq678wcvgfgbtumIr0XJCAVVnjLmPTaoWedIILzDFInSsavdU4WW1+4NUTYfmVov43y2jeNAySLoXeOItjEnY/n8RTA5DBpl+lJxyt//Zahee1flHhrH2FX6wZLjNFndA29XeUJJ4k/nrxk/C2qx5KZxR25kKBOpVWh6ACUByX0ti8FsZvJUX6tt0KBGk1X5il9exW0/5tocDpugJmu6s9+LA5MXndivK9/FkUSV4cC9wgcxtwQIZJAYAlSkcRuxB7yGHyzYlzSxHOnkJQ9NulMO4qu226IWVvnDkwuweDKU27Re9yd6ov+MZrZfM28p7qG1qRgTptmo9q7qZyKj5JZ3+qHqvTP4O+xIvpbfbaBJemwRrkSAaT86BSuF1NQv1XQ/W6mAMASQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 049b3113-f112-4236-2fde-08d81cb5a620
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 05:22:57.2871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bF7bMCtspM0ttzByflDenWpct19kc5LLtz34kMVU3N7wI7cw9CgAz4jAl5ixCCPaYKr18B+r9Qpq80r691LyBoA8ZN085lP34wdaG4ZlnqkqZ6GXYk90C5q+enRUiDiK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4224
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
bmVjZXNzYXJpbHkgYWxsIGluIDEgcGF0Y2gpPw0KDQpUaGFuayB5b3UgZm9yIHlvdXIgY29tbWVu
dCEgSSdtIG5vdCBzdXJlIHRoaXMgInJlLWluaXQiIG1lYW4uIEJ1dCwgd2UgY2FuIGRvDQphIHBl
ci1xdWV1ZSB0ZWFyLWRvd24gaWYgRE1BQyBpcyBzdGlsbCB3b3JraW5nLiBBbmQsIHdlIGNhbiBw
cmVwYXJlIG5ldyBkZXNjcmlwdG9ycw0KZm9yIHRoZSBxdWV1ZSBhZnRlciB0ZWFyLWRvd24uDQoN
CjwgVGVhci1kb3duID4NCjEuIFNldCBEVF9FT1MgdG8gdGhlIGRlc2NfYmF0W3F1ZXVlXS4NCjIu
IFNldCBETFIuTEJBeCB0byAxLg0KMy4gQ2hlY2sgaWYgRExBLkxCQXggaXMgY2xlYXJlZC4NCg0K
PCBQcmVwYXJlIG5ldyBkZXNjcmlwdG9ycyBhbmQgc3RhcnQgYWdhaW4gPg0KNC4gUHJlcGFyZSBu
ZXcgZGVzY3JpcHRvcnMuDQo1LiBTZXQgRFRfTElOS0ZJWCB0byB0aGUgZGVzY19iYXRbcXVldWVd
Lg0KNi4gU2V0IERMUi5MQkF4IHRvIDEuDQo3LiBDaGVjayBpZiBETEEuTEJBeCBpcyBjbGVhcmVk
Lg0KDQoNCkknbSB0aGlua2luZyBkb2luZyB0ZWFyLWRvd24gYW5kICJyZS1pbml0IiBvZiB0aGUg
ZGVzY3JpcHRvcnMgaXMgYmV0dGVyDQp0aGFuIGp1c3QgdHJ5IHRvIHdha2UgdGhlIHN1YnF1ZXVl
LiBCdXQsIHdoYXQgZG8geW91IHRoaW5rPw0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hp
bW9kYQ0KDQo+ID4gQmVzdCByZWdhcmRzLA0KPiA+IFlvc2hpaGlybyBTaGltb2RhDQo+IA0KPiBN
QlIsIFNlcmdlaQ0K
