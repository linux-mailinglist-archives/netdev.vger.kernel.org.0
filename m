Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074B321EF90
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 13:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgGNLmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 07:42:20 -0400
Received: from mail-eopbgr1310139.outbound.protection.outlook.com ([40.107.131.139]:55264
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726370AbgGNLmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 07:42:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfnCAz8yGyYW+NReN7H9FW5G8IZBREOfIjCRsOv6Sz4PaRaigR7xFmGxsVXwqJGFZzh11KWBeUFI9Mt/75rFOkUbHXfCuZSi0cSifQW0Of9u4hx7G04J5ktDmc5ROJ3KReoQR+eTk/SCAuhoxYOZnyKL845uP247p5djSg591yfY2bDlizMKKYegIPXw+ecvm976dacRjxSL0C7cO3dJ+cWFhHqO2cizjRpSefcTYcMN5TtloHhzL767rnorGQWTKeSKqNFyP4svj70qN9T8C7lSqd404dbiiVh1qScmfCGhRfvdNvcWVSvXHF4Ce50EPil4+tBgkZnHK+f/aE1xnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EaumU8bjD36B9WihkPMfdgN0iyWNTMYlNLUEJa8aNBo=;
 b=MoSaeaZHisxM7isEIA5jTSe5Z+6SMkcJasTJrKIBqbNMnUwBo3dAHUXigDyTkvzwhPe1SuYvQuhji8zHQdbdFBD/6R3BSytgh5IDzvXHHRvURdymYOwYhrbU8FUzJ9pRKpK5CXxHdSCPEr8iFuHwwftg+O3oXdbMYK+s+CC6c8JPLXcUUrmp941pG1PJSdXdlVm0cXouEjhDC/KkQPklzfkC0RyzkgbPVZxQxW/ELxYUq3ux1D2DPTj/5sP7nKgj2+JOZTzLgk5LAGopFnJ4+asIAp3GjZDPqBqp6yn00HacsJd+/BkQbh9NA19bgxIc6JpJyuCvCSRdoyTSatYuJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EaumU8bjD36B9WihkPMfdgN0iyWNTMYlNLUEJa8aNBo=;
 b=ZGmCD41KWj/Ejcxa4nz8FGKXeEDzsbF8uoBzB5xBMemwKKVy+UoPFAvi6mK+YEZJH5Iyr0PvVo1flN1bDOu59o5aknwNpoTEK6OxWtv1TppidMC7meF4Q58o4Y9ftayvzo80jwfv1xBDj3KMHBhMexW1wVNO/qpgRofiq3XP51M=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TY2PR01MB4506.jpnprd01.prod.outlook.com (2603:1096:404:119::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Tue, 14 Jul
 2020 11:42:11 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3%6]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 11:42:11 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        dmaengine <dmaengine@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/9] iommu/ipmmu-vmsa: Hook up R8A774E1 DT matching code
Thread-Topic: [PATCH 2/9] iommu/ipmmu-vmsa: Hook up R8A774E1 DT matching code
Thread-Index: AQHWWV2MbTXg+hkXBUeG2IKsFpTIWqkGuXGAgAAF1ACAAAM3gIAALMKg
Date:   Tue, 14 Jul 2020 11:42:11 +0000
Message-ID: <TY2PR01MB3692A868DD4E67D770C610E3D8610@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAMuHMdV4zzrk_=-2Cmgq8=PKTeU457iveJ58gYekJ-Z8SXqaCQ@mail.gmail.com>
 <CA+V-a8tB0mA17f51GMQQ-Cj_CUXze_JjTahrpoAtmwuOFHQV6g@mail.gmail.com>
 <CAMuHMdXM3qf266exJtJrN0XAogEsJoM-k3FON9CjX+stLpuMFA@mail.gmail.com>
In-Reply-To: <CAMuHMdXM3qf266exJtJrN0XAogEsJoM-k3FON9CjX+stLpuMFA@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [240f:60:5f3e:1:2d25:f7bf:9b71:7e0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6097b998-8199-4d15-95ad-08d827eaf28c
x-ms-traffictypediagnostic: TY2PR01MB4506:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TY2PR01MB450618B750931E3B7AB7CDD0D8610@TY2PR01MB4506.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GiDvEhjEHo9m/Mq2c5p/QHtl3xx0GiVkWWCb5AIDS2OlbOmDNeFqLJ/pEjPdo6QpdIyzEudL/lGBSyKxmPXXresq0dm21jFF+d/+lwoV3kOn0cS7FuW4c8QclCLGax6dtzYN9YfyIg5waMMqY28HI+0biG2uC7irj51CuNWIVV0I3sKThsztb89pd50U5+6ucvF6C/zMwrJHMKoKP35zqGATp9we8ShGE6LLCt+mn0nYNh37YdIsVWHh4ZhyVCUvrnNrbY7vOg8wp4n0LYbLcSDwK31yIKyvv58u5mJ1Y5d8VaTt+LVxBUqVCUlb00q0AkotqhQYPFJHa9DGyaFA8l3s/uvb1V1MZWhXA0NG8gTy/7cxyl+WNEZvyIwIT3X/dXOhQSOPHK4aIniBrwKcwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(66556008)(53546011)(6506007)(64756008)(66446008)(66476007)(86362001)(186003)(71200400001)(7696005)(54906003)(8936002)(110136005)(76116006)(4326008)(66946007)(52536014)(9686003)(2906002)(8676002)(55016002)(5660300002)(33656002)(498600001)(7416002)(83380400001)(52103002)(158003001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: loXaNbR5PEQBHs+48101/R0kj/aaSAkDAlI3RMZyOAL8XTOARGC0TOk58B4Fbz/aWiXDQt6wrKrCn+ATdFMJhNTbTm9etxtmPeqEjUgEOkNVaKBluB5X1dbs9uPJ9YCrrcC1T+t139hYxvNPoAuwxV2tKfXGDkHiazCuba4O/o+kemDRNidnz/6ez0A5khR7d4J54+F7Jc/pDA+KDVpffJ4I0y44BptzVaRRD1B4ymdv6suE8/Z49f687HqhTDemkda6OAOSDgdXBzDTwdWVs+5mI4I1RVDlukugnBG+yLCjJGCN6Kwzsk+aCWjO7gB8DgMTAyiIRpTApDIxrlZbNp+m+DkOCk5brg3bkQ2xOWQZeaaj3jx2lJQAgUMKE77cvYgXpNT7m8HCzXJybB0XxcqPoYcEikWKIHaLr9zi899QuQa0ev/GajUQOxiZspmhIWyDh1aqxu3lcgCw6tEGq17oCEtbmOezEQTddLAKJS8U210fx7dMWeeHAqN1LSnd1ZvWdvSMIqFOq99CRQ4p1L0P0xV3nS+mGWztLpCHiHU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6097b998-8199-4d15-95ad-08d827eaf28c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2020 11:42:11.6846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +ScZmrTio0vecAJe2vVQVEn3xs81LsK5HX1ocHzsHI/1PJ1FoAOqBbJ4vWkLl1H3JNNXTbjQKtb4olM9kL1BfLn5B7LBj94p9rEyb1I3J3MeElL2TKHCqn/CdB4sOS/G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB4506
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQtc2FuLA0KDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogVHVlc2Rh
eSwgSnVseSAxNCwgMjAyMCA1OjQyIFBNDQo+IA0KPiBIaSBQcmFiaGFrYXIsDQo+IA0KPiBPbiBU
dWUsIEp1bCAxNCwgMjAyMCBhdCAxMDozMCBBTSBMYWQsIFByYWJoYWthcg0KPiA8cHJhYmhha2Fy
LmNzZW5nZ0BnbWFpbC5jb20+IHdyb3RlOg0KPiA+IE9uIFR1ZSwgSnVsIDE0LCAyMDIwIGF0IDk6
MDkgQU0gR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydEBsaW51eC1tNjhrLm9yZz4gd3JvdGU6DQo+
ID4gPiBPbiBNb24sIEp1bCAxMywgMjAyMCBhdCAxMTozNSBQTSBMYWQgUHJhYmhha2FyDQo+ID4g
PiA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPiB3cm90ZToNCj4gPiA+
ID4gRnJvbTogTWFyaWFuLUNyaXN0aWFuIFJvdGFyaXUgPG1hcmlhbi1jcmlzdGlhbi5yb3Rhcml1
LnJiQGJwLnJlbmVzYXMuY29tPg0KPiA+ID4gPg0KPiA+ID4gPiBBZGQgc3VwcG9ydCBmb3IgUlov
RzJIIChSOEE3NzRFMSkgU29DIElQTU1Vcy4NCj4gPiA+ID4NCj4gPiA+ID4gU2lnbmVkLW9mZi1i
eTogTWFyaWFuLUNyaXN0aWFuIFJvdGFyaXUgPG1hcmlhbi1jcmlzdGlhbi5yb3Rhcml1LnJiQGJw
LnJlbmVzYXMuY29tPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBMYWQgUHJhYmhha2FyIDxwcmFi
aGFrYXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+ID4gPg0KPiA+ID4gVGhhbmtz
IGZvciB5b3VyIHBhdGNoIQ0KPiA+ID4NCj4gPiA+ID4gLS0tIGEvZHJpdmVycy9pb21tdS9pcG1t
dS12bXNhLmMNCj4gPiA+ID4gKysrIGIvZHJpdmVycy9pb21tdS9pcG1tdS12bXNhLmMNCj4gPiA+
ID4gQEAgLTc1MSw2ICs3NTEsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHNvY19kZXZpY2VfYXR0
cmlidXRlIHNvY19yY2FyX2dlbjNbXSA9IHsNCj4gPiA+ID4gIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
c29jX2RldmljZV9hdHRyaWJ1dGUgc29jX3JjYXJfZ2VuM193aGl0ZWxpc3RbXSA9IHsNCj4gPiA+
ID4gICAgICAgICB7IC5zb2NfaWQgPSAicjhhNzc0YjEiLCB9LA0KPiA+ID4gPiAgICAgICAgIHsg
LnNvY19pZCA9ICJyOGE3NzRjMCIsIH0sDQo+ID4gPiA+ICsgICAgICAgeyAuc29jX2lkID0gInI4
YTc3NGUxIiwgfSwNCj4gPiA+DQo+ID4gPiBBZGRpbmcgYW4gZW50cnkgdG8gc29jX3JjYXJfZ2Vu
M193aGl0ZWxpc3RbXSBkb2Vzbid0IGRvIGFueXRoaW5nLCB1bmxlc3MNCj4gPiA+IHlvdSBhbHNv
IGFkZCB0aGUgc2FtZSBlbnRyeSB0byBzb2NfcmNhcl9nZW4zW10uDQo+ID4gPg0KPiA+IEkgdGhp
bmsgdGhlIGNvbW1lbnQgIkZvciBSLUNhciBHZW4zIHVzZSBhIHdoaXRlIGxpc3QgdG8gb3B0LWlu
IHNsYXZlDQo+ID4gZGV2aWNlcy4iIGlzIG1pc2xlYWRpbmcuICBCb290aW5nIHRocm91Z2ggdGhl
IGtlcm5lbCBJIGRvIHNlZSBpb21tdQ0KPiA+IGdyb3VwcyAoYXR0YWNoZWQgaXMgdGhlIGxvZ3Mp
Lg0KPiANCj4gSW5kZWVkLiBXaXRob3V0IGFuIGVudHJ5IGluIHNvY19yY2FyX2dlbjNbXSwgdGhl
IElQTU1VIGlzIGVuYWJsZWQNCj4gdW5jb25kaXRpb25hbGx5LCBhbmQgc29jX3JjYXJfZ2VuM193
aGl0ZWxpc3RbXSBpcyBpZ25vcmVkLg0KPiBUaGF0J3Mgd2h5IHlvdSB3YW50IGFuIGVudHJ5IGlu
IGJvdGgsIHVubGVzcyB5b3UgaGF2ZSBhbiBSLUNhciBHZW4zDQo+IFNvQyB3aGVyZSB0aGUgSVBN
TVUgd29ya3MgY29ycmVjdGx5IHdpdGggYWxsIHNsYXZlIGRldmljZXMgcHJlc2VudC4NCj4gUGVy
aGFwcyBzb2NfcmNhcl9nZW4zW10gc2hvdWxkIGJlIHJlbmFtZWQgdG8gc29jX3JjYXJfZ2VuM19n
cmV5bGlzdFtdDQo+IChvciBzb2NfcmNhcl9nZW4zX21heWJlbGlzdFtdKSB0byBtYWtlIHRoaXMg
Y2xlYXI/DQoNCkkgdGhpbmsgc28gKHdlIHNob3VsZCByZW5hbWUgaXQpLg0KDQo+ID4gQWxzbyB0
aGUgcmVjZW50IHBhdGNoIHRvIGFkZA0KPiA+ICJyOGE3Nzk2MSIganVzdCBhZGRzIHRvIHNvY19y
Y2FyX2dlbjNfd2hpdGVsaXN0Lg0KPiANCj4gT29wcywgY29tbWl0IDE3ZmUxNjE4MTYzOTgwMWIg
KCJpb21tdS9yZW5lc2FzOiBBZGQgc3VwcG9ydCBmb3IgcjhhNzc5NjEiKQ0KPiBkaWQgaXQgd3Jv
bmcsIHRvby4NCg0KVGhhbmsgeW91IGZvciB0aGUgcG9pbnQgaXQgb3V0LiBXZSBzaG91bGQgYWRk
IHI4YTc3OTYxIHRvIHRoZSBzb2NfcmNhcl9nZW4zW10uDQpIb3dldmVyLCBJIGRvbid0IGtub3cg
d2h5IEkgY291bGQgbm90IHJlYWxpemUgdGhpcyBpc3N1ZS4uLg0KU28sIEkgaW52ZXN0aWdhdGVk
IHRoaXMgYSBsaXR0bGUgYW5kIHRoZW4sIElJVUMsIGdsb2JfbWF0Y2goKSB3aGljaA0Kc29jX2Rl
dmljZV9tYXRjaCgpIHVzZXMgc2VlbXMgdG8gcmV0dXJuIHRydWUsIGlmICpwYXQgPSAicjhhNzc5
NiIgYW5kICpzdHIgPSAicjhhNzc5NjEiLg0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hp
bW9kYQ0KDQo=
