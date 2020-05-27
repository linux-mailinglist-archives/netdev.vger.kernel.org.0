Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4914B1E4A44
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391224AbgE0QdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:33:12 -0400
Received: from mail-eopbgr1410107.outbound.protection.outlook.com ([40.107.141.107]:15278
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387763AbgE0QdJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:33:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfDvThtIWclaiyHqzmhGD3lwnaIbi28xdkilmr1H23VvcUSuO957E82HB/IKEGIzUFwqDQzOimMb1hciLFwn0Rez6IcIMFaPT21X9RT0nW1DMKuoYtemIN1x0kp4zV3di9592JhFWX+jygr0tfIUc3u2RakwJTxBCWAbp6Gx6vSLIN6lZGlblMWdKKkRdadL0bvKnvtAsyHHrgCHfweMslEllm/AWALod4rNYrWTbFnqShWbT7PRjL5/Q/NEZwCgrNXlfcPv/5aVJdFenNGt7qPwG66jMobpUbQ1eB5X9BUYhF6C0Dy2pc8sl8jiEe3xYHxP3INytHW02TTXWyanWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sH1bRwO1ILjdBGqaotTt+r7jcvaJ4XvAkfPdogJkpw=;
 b=Xt7emn/8Kj9oKwrN/g7vTb55mtf7GEEoJUxjC2pY8ObtU5Br0sReUPHEtfXIVqQzMUqCkANuXhOSAIzNKe4HMv79R3rkgkjNOzz9QlCDJyYiydgrW/xM4yq0lZzFtDPpFEWdspSZEhAYeVvhofaJoMOLSWHAQNLg4iadxhAVpgzzYvPCEesHW0YsmJLg66AfANvUdXL8wPbvNJTNf0KP2eKc42rugem7GVIEQum9CSBef1tplffQUVWTXwxUgwdnq0ljEMsE5LOwAnM/QOWAILYPi8iNbTPLF3md65+hNtcHyvZq9QI2fswrqUSc38XmdQ2gmA5NNJAi8sehXExyNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sH1bRwO1ILjdBGqaotTt+r7jcvaJ4XvAkfPdogJkpw=;
 b=Dl+jN/iPndhVcPbmqW6HyFP6LnYS4r6TbhkK1gMNlqOyBCYnIcjZ44RdRaGdHaave93VQoElvEpnXGE0B5GexZKzNOu3qTmipe7wfCLxdb9CYzUYhqER3JcQNltd2DaAb3vo19z+VpYJKVRSoi+gT7gZ3Uu0l4ZVb64fycox9vk=
Received: from OSBPR01MB3590.jpnprd01.prod.outlook.com (2603:1096:604:45::16)
 by OSBPR01MB1493.jpnprd01.prod.outlook.com (2603:1096:603:5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Wed, 27 May
 2020 16:33:04 +0000
Received: from OSBPR01MB3590.jpnprd01.prod.outlook.com
 ([fe80::383a:9fc3:aaa4:d3b]) by OSBPR01MB3590.jpnprd01.prod.outlook.com
 ([fe80::383a:9fc3:aaa4:d3b%7]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:33:04 +0000
From:   Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Rob Herring <robh@kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: RE: [PATCH 16/17] dt-bindings: watchdog: renesas,wdt: Document
 r8a7742 support
Thread-Topic: [PATCH 16/17] dt-bindings: watchdog: renesas,wdt: Document
 r8a7742 support
Thread-Index: AQHWKssCxC2vfuzWzEyRDegtm28a06i7N4kAgAClJYCAADacAIAAH9HA
Date:   Wed, 27 May 2020 16:33:04 +0000
Message-ID: <OSBPR01MB35901639581F7DEFEFD13BA3AAB10@OSBPR01MB3590.jpnprd01.prod.outlook.com>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200527013136.GA838011@bogus>
 <CA+V-a8t6mXkTUac69V=T8_27r_sdN+=MktDTM1mmtbXRn8SSQQ@mail.gmail.com>
 <CAL_JsqJUn9iOy5FT6VRmsC-uAhSdN8_Sne0Vn_7Q1dHudbzopw@mail.gmail.com>
In-Reply-To: <CAL_JsqJUn9iOy5FT6VRmsC-uAhSdN8_Sne0Vn_7Q1dHudbzopw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=bp.renesas.com;
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c8b5b404-6d14-4370-00dd-08d8025ba13a
x-ms-traffictypediagnostic: OSBPR01MB1493:
x-microsoft-antispam-prvs: <OSBPR01MB149344BA3F18CF9C9154D13DAAB10@OSBPR01MB1493.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:238;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ckEePHCXj8Zn0Ecqi28PoYqh5Fchs5kuYP1DbgUyB60XAWOyZYycaL7woeld4Z7yE8vIV8iezZMSz/ZjOusWn1Yqq0GTAqcL2CNfa8RDGMj29tmnpc6pYm1zj44AEyZaxaAqw3KXQBDQrqk8F0jX88RUgMnHiv/W6448qE0dawKHK2muOhFa3tfH3ZXRkAnCdp3oSitLO78vm4PxOLESOWemGdCUmALpEOdlFHtBxqRkgNVOZJOAVWgHfzBhnIW+nz1/hzeTMdJ3ERfuIgfuN/7qMGxhXFAJWlAI57RJPOTBODzq3ugwIteW4zbk3YSGWbZ8Qa4+42TIl0NenRs4bsUi3vNfuOI7HCT3ZGNG45WCazFr4pbtBNUum0n5u1PGHkLSmo1A6Jl1cOmkuWlc2lDlnMGyPufNUcSbYSXYanGh/saarmwLYGoQKeeARIw81awVJrT1qcY0ulvTAAKMMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB3590.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(66476007)(110136005)(8936002)(7416002)(66446008)(55016002)(64756008)(66556008)(7696005)(9686003)(26005)(6506007)(66946007)(83380400001)(186003)(5660300002)(53546011)(54906003)(33656002)(2906002)(316002)(76116006)(71200400001)(478600001)(966005)(8676002)(4326008)(52536014)(86362001)(142933001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Wx6hnCv1I2hGvem2jCwHT6rPeXoUxrapPPVcAsGeWNpv+jHdMyh/HNSR2QGR2LBgIG/BRgrYWCSfZOaFif+rCet2qBuQS14pwnC+t7485RTahsQSNyv7aBjKaCgDmQ9JCZatDohe6Qhbo9LTj0IwaS05ooJE0ah0jcveUZoUnIin26pzgaNEhkHTRMwacUHYJPyPpjW499sQBMEMs8gyQNGgtfDZaX7nbC1gGtFgWKYQC7glJEhupeTpwxehkLL4HVDxWq5dskoIfjyi9FCn7Y4l3J/9hzpVppp1tl56MhSpT26ol5Ch9xNNTeYOC5FjiZ+est5ZMoYl6bWPQKT6McMykzkBI4DzaJI3K0dnGcPdA0K9LLvMm5hE1JDt3JeoPKMdJcAuESsJZx8M48eHhMJSg6xNl+xdaVKEruDxxovi8YxLGJ/d3y0XsK3HKWFkGHNEwkMRV391LshRzHCmDr+PhGDa3p8AEpLfbNziXem8BLiZJA6Nhq/KDyiZcQOG
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b5b404-6d14-4370-00dd-08d8025ba13a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 16:33:04.2048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UMMWX/O7LAyNaVx7aADg+dK6uj4yAsDb7m5T+iU0XUYKrl+y4UQCWVTX+LYfZD3VU0DN0gT8PV6PUukVdRqdC9wwGOu4BYP7DxmukNwlRek7F99ESgAvPc6+/9q66Nvk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1493
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUm9iLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJvYiBIZXJy
aW5nIDxyb2JoQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDI3IE1heSAyMDIwIDE1OjM4DQo+IFRvOiBM
YWQsIFByYWJoYWthciA8cHJhYmhha2FyLmNzZW5nZ0BnbWFpbC5jb20+DQo+IENjOiBQcmFiaGFr
YXIgTWFoYWRldiBMYWQgPHByYWJoYWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT47
IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnQrcmVuZXNhc0BnbGlkZXIuYmU+OyBKZW5zIEF4Ym9l
DQo+IDxheGJvZUBrZXJuZWwuZGs+OyBXb2xmcmFtIFNhbmcgPHdzYStyZW5lc2FzQHNhbmctZW5n
aW5lZXJpbmcuY29tPjsgVWxmIEhhbnNzb24gPHVsZi5oYW5zc29uQGxpbmFyby5vcmc+OyBTZXJn
ZWkgU2h0eWx5b3YNCj4gPHNlcmdlaS5zaHR5bHlvdkBjb2dlbnRlbWJlZGRlZC5jb20+OyBEYXZp
ZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBXaW0gVmFuIFNlYnJvZWNrIDx3aW1A
bGludXgtd2F0Y2hkb2cub3JnPjsNCj4gR3VlbnRlciBSb2VjayA8bGludXhAcm9lY2stdXMubmV0
Pjsgb3BlbiBsaXN0OkxJQkFUQSBTVUJTWVNURU0gKFNlcmlhbCBhbmQgUGFyYWxsZWwgQVRBIGRy
aXZlcnMpIDxsaW51eC1pZGVAdmdlci5rZXJuZWwub3JnPjsgb3Blbg0KPiBsaXN0Ok9QRU4gRklS
TVdBUkUgQU5EIEZMQVRURU5FRCBERVZJQ0UgVFJFRSBCSU5ESU5HUyA8ZGV2aWNldHJlZUB2Z2Vy
Lmtlcm5lbC5vcmc+OyBMS01MIDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgTGludXgN
Cj4gSTJDIDxsaW51eC1pMmNAdmdlci5rZXJuZWwub3JnPjsgTGludXggTU1DIExpc3QgPGxpbnV4
LW1tY0B2Z2VyLmtlcm5lbC5vcmc+OyBuZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBM
aW51eC1SZW5lc2FzIDxsaW51eC0NCj4gcmVuZXNhcy1zb2NAdmdlci5rZXJuZWwub3JnPjsgTGlu
dXggV2F0Y2hkb2cgTWFpbGluZyBMaXN0IDxsaW51eC13YXRjaGRvZ0B2Z2VyLmtlcm5lbC5vcmc+
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMTYvMTddIGR0LWJpbmRpbmdzOiB3YXRjaGRvZzogcmVu
ZXNhcyx3ZHQ6IERvY3VtZW50IHI4YTc3NDIgc3VwcG9ydA0KPg0KPiBPbiBXZWQsIE1heSAyNywg
MjAyMCBhdCA1OjIzIEFNIExhZCwgUHJhYmhha2FyDQo+IDxwcmFiaGFrYXIuY3NlbmdnQGdtYWls
LmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBIaSBSb2IsDQo+ID4NCj4gPiBPbiBXZWQsIE1heSAyNywg
MjAyMCBhdCAyOjMxIEFNIFJvYiBIZXJyaW5nIDxyb2JoQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiA+
ID4NCj4gPiA+IE9uIEZyaSwgTWF5IDE1LCAyMDIwIGF0IDA0OjA4OjU2UE0gKzAxMDAsIExhZCBQ
cmFiaGFrYXIgd3JvdGU6DQo+ID4gPiA+IFJaL0cxSCAoUjhBNzc0Mikgd2F0Y2hkb2cgaW1wbGVt
ZW50YXRpb24gaXMgY29tcGF0aWJsZSB3aXRoIFItQ2FyIEdlbjIsDQo+ID4gPiA+IHRoZXJlZm9y
ZSBhZGQgcmVsZXZhbnQgZG9jdW1lbnRhdGlvbi4NCj4gPiA+ID4NCj4gPiA+ID4gU2lnbmVkLW9m
Zi1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMu
Y29tPg0KPiA+ID4gPiBSZXZpZXdlZC1ieTogTWFyaWFuLUNyaXN0aWFuIFJvdGFyaXUgPG1hcmlh
bi1jcmlzdGlhbi5yb3Rhcml1LnJiQGJwLnJlbmVzYXMuY29tPg0KPiA+ID4gPiAtLS0NCj4gPiA+
ID4gIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy93YXRjaGRvZy9yZW5lc2FzLHdk
dC50eHQgfCAxICsNCj4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiA+
ID4NCj4gPiA+IE1lYW53aGlsZSBpbiB0aGUgRFQgdHJlZSwgY29udmVydGluZyB0aGlzIHNjaGVt
YSBsYW5kZWQuIENhbiB5b3UgcHJlcGFyZQ0KPiA+ID4gYSB2ZXJzaW9uIGJhc2VkIG9uIHRoZSBz
Y2hlbWEuDQo+ID4gPg0KPiA+IFRoaXMgd2FzIGtpbmRseSB0YWtlbiBjYXJlIGJ5IFN0ZXBoZW4g
ZHVyaW5nIG1lcmdlIGluIGxpbnV4LW5leHQgWzFdLg0KPg0KPiBZZXMsIEknbSBhd2FyZSBvZiB0
aGF0LiBJIHdhcyBob3BpbmcgZm9yIGEgYmV0dGVyIGNvbW1pdCBtZXNzYWdlIHdoaWNoDQo+IHN0
YW5kcyBvbiBpdHMgb3duIChlc3NlbnRpYWxseSB0aGUgb25lIGhlcmUpLg0KPg0KQXMgcmVxdWVz
dGVkIEkgaGF2ZSBwb3N0ZWQgYSBwYXRjaCBbMV0uDQoNClsxXSBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9wYXRjaHdvcmsvcGF0Y2gvMTI0ODU5Ny8NCg0KQ2hlZXJzLA0KLS1QcmFiaGFrYXINCg0K
DQpSZW5lc2FzIEVsZWN0cm9uaWNzIEV1cm9wZSBHbWJILCBHZXNjaGFlZnRzZnVlaHJlci9QcmVz
aWRlbnQ6IENhcnN0ZW4gSmF1Y2gsIFNpdHogZGVyIEdlc2VsbHNjaGFmdC9SZWdpc3RlcmVkIG9m
ZmljZTogRHVlc3NlbGRvcmYsIEFyY2FkaWFzdHJhc3NlIDEwLCA0MDQ3MiBEdWVzc2VsZG9yZiwg
R2VybWFueSwgSGFuZGVsc3JlZ2lzdGVyL0NvbW1lcmNpYWwgUmVnaXN0ZXI6IER1ZXNzZWxkb3Jm
LCBIUkIgMzcwOCBVU3QtSUROci4vVGF4IGlkZW50aWZpY2F0aW9uIG5vLjogREUgMTE5MzUzNDA2
IFdFRUUtUmVnLi1Oci4vV0VFRSByZWcuIG5vLjogREUgMTQ5Nzg2NDcNCg==
