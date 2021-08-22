Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879523F422C
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 00:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhHVWdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 18:33:54 -0400
Received: from mail-am6eur05on2105.outbound.protection.outlook.com ([40.107.22.105]:40661
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230172AbhHVWdt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 18:33:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfNRxH+eC3fVP52LJ7JgOzI+PaGcYBmDim7/fb5HpqyzUa34Gd0ZUfzY/nS+RQVNxZBNAdYQtUQl09tShqEZsLYv3I81twauvTCPpdgzxBdLyld2RCipuDEIJkc02YxosoR8OmlrviRMigwGLB9pRM5AIkNjeIXYKkCAmqY/S/fCR/sEyUF6sEBuRYW5sHZxqrVatZTN4m4/LKDjkkzeuAhMsyMQ0ZpntawCTurK1bJn4onhLq9p7LkUuEgDdri0DxbaJb2sze5bKCe5Nn6AA7BOwDd79t8YdhLqpOn+v43MIl3c9OXsx34xi8Dz/JyKGr/BEWuCv6trlprAjd6xMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJtR2zRXc4vetC7Lp2JxinJW3m4bq9YT2O9t27/k6vk=;
 b=b6ou18e8dDbsH1tUTcCo0y22oExZzKJ8E36tk17LelRHzDLEMA0ZpZx6WkLqGdiYya3/ebI8VZR+mopMdqyn4w+vczBTjFNzP4Zr4lGQTeTna4l59P4IAyq2+oxqTRi6tVnXiqIl/hBckFRKNNSgE77Ywi5fhv2vaaqOFXHa6yfOo44YPgn+1Hkcr4mbSCyCJQ5DTcgU++3mfrHO/ONScJrTUxcNb2umNSgjgDbGqWl/tl3hRkHNWFxGjZjfSP6bTEvcotZAYRJ7dbm+ahbXB746q/GegurOOpdNWvJ34NnTR1w6mr8OmvNlFGiZAbwwzKoCWLLHtPXK3d8vcapbiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJtR2zRXc4vetC7Lp2JxinJW3m4bq9YT2O9t27/k6vk=;
 b=aIoPW5ifZ3GD7BnTy0RjjpyOCP3NpCZX5O0flsipBTPJ1/5oQNRM3tpU8l9Z5bY290kgrYsRajdkZ4CTfLpvLd96Ec7bRU3sdODXXSCMh/8hBisNGSeDOIkoIIpXnJe/Fz8NEHkCGjdncueNx8c53XfZf8otGxxEk+kLOLqzEnE=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2684.eurprd03.prod.outlook.com (2603:10a6:3:eb::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.22; Sun, 22 Aug 2021 22:33:03 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4415.024; Sun, 22 Aug 2021
 22:33:03 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 1/5] net: dsa: realtek-smi: fix mdio_free bug
 on module unload
Thread-Topic: [RFC PATCH net-next 1/5] net: dsa: realtek-smi: fix mdio_free
 bug on module unload
Thread-Index: AQHXl4x7EC/JWmhXnkaFSDyQCHXzdauADasAgAAOkQA=
Date:   Sun, 22 Aug 2021 22:33:02 +0000
Message-ID: <cb38f340-a410-26a4-43be-5f549c980ff3@bang-olufsen.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-2-alvin@pqrs.dk> <YSLEZmuWlD5kUOlx@lunn.ch>
In-Reply-To: <YSLEZmuWlD5kUOlx@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa1d2f25-4f03-4cb1-73d6-08d965bccdc4
x-ms-traffictypediagnostic: HE1PR0302MB2684:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0302MB26848971BAA14776574E309A83C39@HE1PR0302MB2684.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RO52ppR/cqCQKdbXhQ+N7FHoppw7gn1AN7Al512iEOaVIXCibzs+S0QtOQTs2YX/97CNdVAiv2iH5ZqCmB9mnx9K/ldkFhRtDOTRAuNIReENezOdiWpPkgB7Vv/L8ywxkaG5st1xfP0Z4ESwyyNh+5uq0y7l8/tGo8h+jPsrPIAqTkA+6T7iKC3Uuu+jY1VpJeG1xQ2pyBJTIA0ypr2LG6XD4XrbmeKFbFc2GwIRYwder1it/7QfFOSfirPHawmiYoQU0LYbdfXTn4Q5B1ec9qiXD5Z26NGZbgWoRxkumOh5E92ercBqSUByRFSIdELONotYrLXslZp3rErDu1J+9fhtEY/xOuz+PS4HM9wRzWyphawf4lrGwBr52hvEDyU39ngL6J48yI75ZQAcii6FS/hDEPTgQqmbCd4i/e8MdZFNlYALbjQQeeqGG3UJ3y7787657j4vuzpIos+02Q9xKs3sWU5gdK/IZJM+k7LPIyyenRx620NLHpoJaY4Uw1yP9azlO9eqgxFn7SyEDSR+O2uebNedMhhljmIPzKWOv6b6fN5yesUqQIfmawPGv4MvF1xJOs0IJiyKbJSymeB64GWoeM4bXWMOjt82gM4IRsfr9z1SuTEGgoKcySIiGOxJsCuEvYyB92qAj4di6HJ0EmKWDNRTtg7NaCqCJ1SgOKFCsZWhnZOwK5CmLsFTs3N8jm4UUfxxIMaoZsQ7ogWHiGkMRLTgvBXNmn6HRBBOZlVljfLNIenSrHOciCgAzKPOEmc3LB3GjR9WJUBfMWboMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(396003)(366004)(346002)(136003)(376002)(8676002)(4326008)(7416002)(66446008)(66946007)(64756008)(6512007)(66476007)(91956017)(76116006)(71200400001)(66556008)(6506007)(186003)(5660300002)(66574015)(122000001)(38100700002)(2906002)(85202003)(83380400001)(85182001)(478600001)(38070700005)(54906003)(26005)(110136005)(316002)(6486002)(31686004)(36756003)(2616005)(86362001)(53546011)(8936002)(31696002)(8976002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blJkci9pN3RZRUZFVUc2cEl6bWZRemdSbnpIZ01XcVpJcjRualRYNlgzZWR6?=
 =?utf-8?B?RUFEeTR4Y29QeDhFbCs3clNNZVZYS2RHdnR5TkJmZ0tpQ0Y3V2VGWmlmMGc0?=
 =?utf-8?B?SlFvQy9EWUpMOXBTcXJLZzI5YXQxY1hTQkZFV05zZlRhNzF4SWJuaHRFWHlm?=
 =?utf-8?B?RGUzd3Q3czFMcUtYS2lTVWtJWS85NkUyTFlBZGJIb0oyQXBVZStpS2tPNFhB?=
 =?utf-8?B?L1BjOWJlWVk4TER4Yk1DamJHRHo2L2kwY1p3dXJZQnFId1lsNlMremZkbTc3?=
 =?utf-8?B?Y0ZiamppRGRhU21HYWg1Ykt5NVFTMzZXTktneXdjdzZGVkxpbjNyK2VpdndH?=
 =?utf-8?B?dVlaNGQwZGl0ajJDbVNydDBzRW5IMXRGYmNIeWN5YVAwQWRJVVNQbzI2VzZo?=
 =?utf-8?B?ME9xREsydFNRbHZTbXFGSjlhWmJPSEJiT1lKYm1vVUVRQnZac2x4U1J2R1pP?=
 =?utf-8?B?VzJmbDJ2UXFLeDVMamdodnQ2K3Q3eUwrTjFZa0hIaU03N0JGYWlENE5aTHNR?=
 =?utf-8?B?NmpnSkVhclQwSU9QL1pKZ0hvNDVBYTdOT0F2Y3lFSnI4S3ZPVWRZRVlTT3dD?=
 =?utf-8?B?aXZ3bzg5VlJQTDZmcUZ2MGtxeVZ2ZnhWYW45aHRCZ1N3ek9oYnFqUmZOVGFO?=
 =?utf-8?B?ZS9oTUk3MEFIWDJXb2xQWGNPcVNJODdCTk16UHhHU2YzMnFsNkVWSkt3REI4?=
 =?utf-8?B?YWR0akpkRGdGUGQrRzRlMmo0VldSZFBnRGVqYkRGa0xjYUZyajBST25COFpH?=
 =?utf-8?B?cTJNYm5hWXEzV0JETUk3T1VmZHZEb0xUd1U5M2EwNWt6NGRYc3poQkp4QUJ6?=
 =?utf-8?B?Ni9RUXNrcXJBUlFFT0FBQlljQ2VHVUVrV2ZvV2FHSGdYT2VxQWxURG1OZlg2?=
 =?utf-8?B?aXZRL0dlNTdXRUE3cnMwalZwKzJKeWdTL09VSmJldTBOcW51dWtNaUx2bjgy?=
 =?utf-8?B?TGtQT2JQV25Mc2JFTDNQY0JDejUyT2I2SHQ5dkVZRGVMQWhnTnQ3UHhyc21O?=
 =?utf-8?B?MUtGMEhHR0xjR0dYZDlzMkI3M0FZTGlCR2pRQ1pMbFIzZXM0aW1vd1dUTkV2?=
 =?utf-8?B?Y0dET3BmUndaRnZWaVh4VEo2dmJiRTFJcGpJVG5LTTF3U0pqZE9NNnluRTlU?=
 =?utf-8?B?Y2JxenBGZFZyYjVjWlZTcU85TmdLalVnY25sdEZ6bTJJZ090ZTBnL0lrZzFP?=
 =?utf-8?B?M1pIZjF1UlRabXlGRy9lNFdHT1VLK2tBMUVra2d1VXlvYThRcWZLSGJwaGFl?=
 =?utf-8?B?ZkZrWVpPRTRoc2pKKzdxSEViajJoK210VDhxUm1uc09QTWxjWkJnVVpGQnFx?=
 =?utf-8?B?UDVLTVY4bVJLa3V1MkorZ2VYVTFiTTloRUpMdGN2VGcxWXFLSk1qT3c4a1lY?=
 =?utf-8?B?aEZOTG9JTjV2T01RVFZ2K3hrRlJKRE45V3VINnlqeGdBeS90ODAvOENYRDJM?=
 =?utf-8?B?aU1YSGVMN2cycHpEZ3dscVJ3ZTBmaGhjTGdOU04xR1EyTW9PeFAwRG1xZ0dm?=
 =?utf-8?B?WDk1TFFRaFR4VUx6YWZ6eDdQMUNQRVhua1JsN0dpWUZoSjMreCswYmVWRGZq?=
 =?utf-8?B?S2p4YTRLOGFHWGxhN01Dam9JZU01c2tqcy93U2taRVpOeDZIbVlYYmNNclIz?=
 =?utf-8?B?d3lxVDhCL3MvS0tQcUtmcjVxNzdaQkxaRFdqUlBEd0pEY01qTTdqMllaQ0RZ?=
 =?utf-8?B?Y3g5TFYrUFUrS05oMWFNbHdPMk1GRktOekVqcGZhRWxKYTVZZldRSFRONndK?=
 =?utf-8?Q?1VTLtFYOPmEwvPyzX0/DC2BKMPHUmrsT72wpWxk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <386471F46CA6BD40997D5EB2EB092B1A@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1d2f25-4f03-4cb1-73d6-08d965bccdc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2021 22:33:02.8098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wtOPD6ofjtVYwYHtsbOaZhuroya3LauGS14UOho3xVgy2ysuyPXhFcVpRW1aLDiZXD3mQ1NY/Tx9cFAonmYPyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2684
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiA4LzIyLzIxIDExOjQwIFBNLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gU3VuLCBBdWcgMjIsIDIwMjEgYXQgMDk6MzE6MzlQTSArMDIwMCwgQWx2aW4gxaBpcHJhZ2Eg
d3JvdGU6DQo+PiBGcm9tOiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQo+
Pg0KPj4gcmVhbHRlay1zbWktY29yZSBmYWlscyB0byB1bnJlZ2lzdGVyIHRoZSBzbGF2ZSBNSUkg
YnVzIG9uIG1vZHVsZSB1bmxvYWQsDQo+PiByYWlzaW5nIHRoZSBmb2xsb3dpbmcgQlVHIHdhcm5p
bmc6DQo+Pg0KPj4gICAgICBtZGlvX2J1cy5jOjY1MDogQlVHX09OKGJ1cy0+c3RhdGUgIT0gTURJ
T0JVU19VTlJFR0lTVEVSRUQpOw0KPj4NCj4+ICAgICAga2VybmVsIEJVRyBhdCBkcml2ZXJzL25l
dC9waHkvbWRpb19idXMuYzo2NTAhDQo+PiAgICAgIEludGVybmFsIGVycm9yOiBPb3BzIC0gQlVH
OiAwIFsjMV0gUFJFRU1QVF9SVCBTTVANCj4+ICAgICAgQ2FsbCB0cmFjZToNCj4+ICAgICAgIG1k
aW9idXNfZnJlZSsweDRjLzB4NTANCj4+ICAgICAgIGRldm1fbWRpb2J1c19mcmVlKzB4MTgvMHgy
MA0KPj4gICAgICAgcmVsZWFzZV9ub2Rlcy5pc3JhLjArMHgxYzAvMHgyYjANCj4+ICAgICAgIGRl
dnJlc19yZWxlYXNlX2FsbCsweDM4LzB4NTgNCj4+ICAgICAgIGRldmljZV9yZWxlYXNlX2RyaXZl
cl9pbnRlcm5hbCsweDEyNC8weDFlOA0KPj4gICAgICAgZHJpdmVyX2RldGFjaCsweDU0LzB4ZTAN
Cj4+ICAgICAgIGJ1c19yZW1vdmVfZHJpdmVyKzB4NjAvMHhkOA0KPj4gICAgICAgZHJpdmVyX3Vu
cmVnaXN0ZXIrMHgzNC8weDYwDQo+PiAgICAgICBwbGF0Zm9ybV9kcml2ZXJfdW5yZWdpc3Rlcisw
eDE4LzB4MjANCj4+ICAgICAgIHJlYWx0ZWtfc21pX2RyaXZlcl9leGl0KzB4MTQvMHgxYyBbcmVh
bHRla19zbWldDQo+Pg0KPj4gRml4IHRoaXMgYnkgZHVseSB1bnJlZ2lzdGVyaW5nIHRoZSBzbGF2
ZSBNSUkgYnVzIHdpdGgNCj4+IG1kaW9idXNfdW5yZWdpc3Rlci4gV2UgZG8gdGhpcyBpbiB0aGUg
RFNBIHRlYXJkb3duIHBhdGgsIHNpbmNlDQo+PiByZWdpc3RyYXRpb24gaXMgcGVyZm9ybWVkIGlu
IHRoZSBEU0Egc2V0dXAgcGF0aC4NCj4gDQo+IExvb2tpbmcgYXQgdGhlIHNldHVwIGNvZGUsIGlz
IHRoZXJlIGFueXRoaW5nIHVuZG9pbmcgd2hhdA0KPiBydGw4MzY2cmJfc2V0dXBfY2FzY2FkZWRf
aXJxKCkgZG9lcz8NCg0KTm8sIHRoZXJlIGlzbid0LiBJIG5lZ2xlY3RlZCB0byBtZW50aW9uIGlu
IHRoZSBydGw4MzY1bWIgcGF0Y2ggdGhhdCBJIA0KcmV3b3JrZWQgdGhlIElSUSBzZXR1cCAoY29t
cGFyZWQgd2l0aCBydGw4MzY2cmIpIHNvIHRoYXQgaXQgY291bGQgYmUgDQp0b3JuIGRvd24gaW4g
YSBuZWF0IHdheS4gU28geW91IHdpbGwgc2VlIHRoYXQgdGhlIG5ldyBkcml2ZXIgZG9lcyBpdCAN
CnByb3Blcmx5LCBidXQgSSBkaWQgbm90IHRvdWNoIHJ0bDgzNjZyYiBiZWNhdXNlIEkgYW0gbm90
IHVzaW5nIGl0LiBJIGFtIA0KaGFwcHkgdG8gZG8gdGhlIHNhbWUgdG8gcnRsODM2NnJiIGJ1dCBJ
IGRvbid0IHRoaW5rIEkgc2hvdWxkIG1ha2UgaXQgDQpwYXJ0IG9mIHRoaXMgc2VyaWVzLiBXaGF0
IGRvIHlvdSB0aGluaz8NCg0KPiANCj4gVGhpcyBwYXRjaCBob3dldmVyIGxvb3MgTy5LLg0KPiAN
Cj4gUmV2aWV3ZWQtYnk6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gDQo+ICAgICAg
QW5kcmV3DQo+IA0K
