Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2D3F246F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 02:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732971AbfKGBoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 20:44:16 -0500
Received: from mail-eopbgr20049.outbound.protection.outlook.com ([40.107.2.49]:3991
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727597AbfKGBoP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 20:44:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkCCFQKt1AOMbVC8TIE+4Y0JGvPnM4/4RVrAkW4XsatsHIfSId1TEMTMbE40EUXHSslSw6Rm3BPRM2c7Jhu++FN64fUUpUrWOJcEbg3OKb2i0HXsIJNNqftA5giDwfZaCJetIx9VSP3P7mDk7CcMEmpA5RGFWJRqO+zVe1wrsIw+TRVXXkZwa490LrI7d+8BlwM0MllqUh5Nf4TAunJ4rs9oZ+4kL4TtKUZTBrmZ5FWuWjgsiUnNFcURmv53pjY+FgfZAZYCPpt8uBMlYRfVYblm17hfjIFq4lM8hG4Xyh8ngD4pLE6WXb2scrXrj4iMmkogam/glDAtYQYu8Jhzqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdKTpkuETgFkpI4NsgyFX6RokdB7CR6V3Kd/kpR4Ddg=;
 b=nJDlX+JSP1Tiq1jWYrEADhvE6RX17+AA/PsoEEOAy+Gi9LZPPalGJ68XLxs2kPTQlA5UU0eZ9+W9fzQ5RvfJ6kfTacS93lcshNXsYpIppkaHktR9hZ+noS/PT7CWIEHzMdCazA9EYQeK8FgSqHJfPWUqzgfCXiVPR0S+Gto62LRHNTz7pRBpGtZp2TdCDp8rTwt2hLyD4wSmKTF4rnDdJVP1oYAxgI/LYnFnAu5W/bwmUsG/vJqjsUf2eD4038+InzhFIq18sKBydegbkt58yRr140GLvnpTRzNfT7dfz+aQ+6xcy4MCbCmIF9HTsanuxOCRrRK3uNM6CXpG59PJoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdKTpkuETgFkpI4NsgyFX6RokdB7CR6V3Kd/kpR4Ddg=;
 b=FySutZ2wyPZCxpw7cVYZx5VmndLjoai9hlcH3a4HgJtcNcA7HhlzUu5Bdq91b0JCzq8VHHIFqtN3pBBSUCtfrtGHtUg5mcp1oOFQJLEGgOq8ml5clhZknFnvdgqjXRT2gWlPtwYPtcEh0hJYRT4SjNeDlmMPI+SRD1e7a8cBDpU=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3567.eurprd04.prod.outlook.com (52.134.6.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Thu, 7 Nov 2019 01:44:11 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52%7]) with mapi id 15.20.2408.024; Thu, 7 Nov 2019
 01:44:11 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Chuhong Yuan <hslester96@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] net: fec: add a check for CONFIG_PM to avoid clock
 count mis-match
Thread-Topic: [EXT] [PATCH] net: fec: add a check for CONFIG_PM to avoid clock
 count mis-match
Thread-Index: AQHVlHh1RxWa9XB3VkWu+bqZPxdiDad9ymZQgAAFLwCAAB3EoIAA/H+AgAACdvA=
Date:   Thu, 7 Nov 2019 01:44:11 +0000
Message-ID: <VI1PR0402MB3600111063607DDAC4DFFE26FF780@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191106080128.23284-1-hslester96@gmail.com>
 <VI1PR0402MB3600F14956A82EF8D7B53CC4FF790@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CANhBUQ1wZU92K=XTRCNU5HhOzZ761+S83zyjqOdZKpyQVuXrCw@mail.gmail.com>
 <VI1PR0402MB36000BE1C169ECA035BE3610FF790@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CANhBUQ2qN+vLYiHdUFGH22LnTa3nuKMYncq3JHDJp=vM=ZvCPA@mail.gmail.com>
In-Reply-To: <CANhBUQ2qN+vLYiHdUFGH22LnTa3nuKMYncq3JHDJp=vM=ZvCPA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a6516eea-8145-4e5a-3b5c-08d76323fd1c
x-ms-traffictypediagnostic: VI1PR0402MB3567:
x-microsoft-antispam-prvs: <VI1PR0402MB356798F2E0486834641C5A18FF780@VI1PR0402MB3567.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(199004)(189003)(99286004)(8936002)(305945005)(81166006)(229853002)(86362001)(52536014)(4326008)(8676002)(5660300002)(1411001)(66066001)(6116002)(3846002)(71200400001)(14454004)(64756008)(316002)(66946007)(76116006)(54906003)(71190400001)(66556008)(66476007)(66446008)(33656002)(446003)(186003)(6436002)(6916009)(14444005)(6246003)(81156014)(486006)(476003)(11346002)(256004)(76176011)(25786009)(6506007)(2906002)(53546011)(74316002)(55016002)(7736002)(26005)(478600001)(102836004)(9686003)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3567;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UbJN+WOOSKy6VO9niSsSEGs7NDsngIL2drI9byhiP4lELOSjwdHH25+OV84huPQ5Q+YVnewGihoryVukU+1MJLiYmsihr35/ZAQPZjnE85WhSndsimUymv8tDFMxQe51FteoJuhVJg8ChtRVICwhsJwiOQiuCRdY21dKAEY+/QCFByeTxZ0jDX+cjt5Naw8I6+V9otSQZ2ELOK4sccIv8/NdU/fuMbTO9IDy91YdFiMZDaq00iF7qMTqttROFkC/UhaNeutddU8bqmc6zIJRsBjJE0yiWyLwZ8wBRrm7AujwZ4FMzF+uh6Xz1Qw1fRsXmm1wmpVfwKOBSnzuX/zfFC6m4jfCP5MDcHEASlHIj2KN9x1dKW+rWkg2azlKvW317llcR79DbyO/IBkj8TuyqGSO9EuFflUBPZN2lXoO9aSQZru4HOzSzZUtIFvZp0Ba
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6516eea-8145-4e5a-3b5c-08d76323fd1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 01:44:11.5736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q+cqJQy3h3LKcHPXKfJgccBySpGFDVn9gxQMiCRzM/I8hYyjQPj8ZMCnZ2GWuSS5l/zKXdwChREPVY8MYbJtaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3567
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2h1aG9uZyBZdWFuIDxoc2xlc3Rlcjk2QGdtYWlsLmNvbT4gU2VudDogVGh1cnNkYXks
IE5vdmVtYmVyIDcsIDIwMTkgOToxOSBBTQ0KPiBPbiBXZWQsIE5vdiA2LCAyMDE5IGF0IDY6MTcg
UE0gQW5keSBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPiB3cm90ZToNCj4gPg0KPiA+IEZyb206
IENodWhvbmcgWXVhbiA8aHNsZXN0ZXI5NkBnbWFpbC5jb20+IFNlbnQ6IFdlZG5lc2RheSwgTm92
ZW1iZXINCj4gNiwNCj4gPiAyMDE5IDQ6MjkgUE0NCj4gPiA+IE9uIFdlZCwgTm92IDYsIDIwMTkg
YXQgNDoxMyBQTSBBbmR5IER1YW4gPGZ1Z2FuZy5kdWFuQG54cC5jb20+DQo+IHdyb3RlOg0KPiA+
ID4gPg0KPiA+ID4gPiBGcm9tOiBDaHVob25nIFl1YW4gPGhzbGVzdGVyOTZAZ21haWwuY29tPiBT
ZW50OiBXZWRuZXNkYXksDQo+ID4gPiA+IE5vdmVtYmVyDQo+ID4gPiA2LA0KPiA+ID4gPiAyMDE5
IDQ6MDEgUE0NCj4gPiA+ID4gPiBJZiBDT05GSUdfUE0gaXMgZW5hYmxlZCwgcnVudGltZSBwbSB3
aWxsIHdvcmsgYW5kIGNhbGwNCj4gPiA+ID4gPiBydW50aW1lX3N1c3BlbmQgYXV0b21hdGljYWxs
eSB0byBkaXNhYmxlIGNsa3MuDQo+ID4gPiA+ID4gVGhlcmVmb3JlLCByZW1vdmUgb25seSBuZWVk
cyB0byBkaXNhYmxlIGNsa3Mgd2hlbiBDT05GSUdfUE0gaXMNCj4gPiA+IGRpc2FibGVkLg0KPiA+
ID4gPiA+IEFkZCB0aGlzIGNoZWNrIHRvIGF2b2lkIGNsb2NrIGNvdW50IG1pcy1tYXRjaCBjYXVz
ZWQgYnkNCj4gZG91YmxlLWRpc2FibGUuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBUaGlzIHBhdGNo
IGRlcGVuZHMgb24gcGF0Y2gNCj4gPiA+ID4gPiAoIm5ldDogZmVjOiBhZGQgbWlzc2VkIGNsa19k
aXNhYmxlX3VucHJlcGFyZSBpbiByZW1vdmUiKS4NCj4gPiA+ID4gPg0KPiA+ID4gPiBQbGVhc2Ug
YWRkIEZpeGVzIHRhZyBoZXJlLg0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+IFRoZSBwcmV2aW91cyBw
YXRjaCBoYXMgbm90IGJlZW4gbWVyZ2VkIHRvIGxpbnV4LCBzbyBJIGRvIG5vdCBrbm93DQo+ID4g
PiB3aGljaCBjb21taXQgSUQgc2hvdWxkIGJlIHVzZWQuDQo+ID4NCj4gPiBJdCBzaG91bGQgYmUg
bWVyZ2VkIGludG8gbmV0LW5leHQgdHJlZS4NCj4gPg0KPiANCj4gSSBoYXZlIHNlYXJjaGVkIGlu
IG5ldC1uZXh0IGJ1dCBkaWQgbm90IGZpbmQgaXQuDQoNCkRhdmlkLCBwbGVhc2UgZ2l2ZSB0aGUg
Y29tbWVudC4gVGhhbmtzLg0KDQpSZWdhcmRzLA0KQW5keQ0KPiANCj4gPiBBbmR5DQo+ID4gPg0K
PiA+ID4gPiBBbmR5DQo+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogQ2h1aG9uZyBZdWFuIDxoc2xl
c3Rlcjk2QGdtYWlsLmNvbT4NCj4gPiA+ID4gPiAtLS0NCj4gPiA+ID4gPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMgfCAyICsrDQo+ID4gPiA+ID4gIDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiA+ID4gPiA+IGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gPiA+ID4gPiBpbmRl
eCBhOWMzODZiNjM1ODEuLjY5NjU1MGY0OTcyZiAxMDA2NDQNCj4gPiA+ID4gPiAtLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiA+ID4gPiA+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+ID4gPiA+ID4gQEAgLTM2
NDUsOCArMzY0NSwxMCBAQCBmZWNfZHJ2X3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlDQo+
ID4gPiAqcGRldikNCj4gPiA+ID4gPiAgICAgICAgICAgICAgICAgcmVndWxhdG9yX2Rpc2FibGUo
ZmVwLT5yZWdfcGh5KTsNCj4gPiA+ID4gPiAgICAgICAgIHBtX3J1bnRpbWVfcHV0KCZwZGV2LT5k
ZXYpOw0KPiA+ID4gPiA+ICAgICAgICAgcG1fcnVudGltZV9kaXNhYmxlKCZwZGV2LT5kZXYpOw0K
PiA+ID4gPiA+ICsjaWZuZGVmIENPTkZJR19QTQ0KPiA+ID4gPiA+ICAgICAgICAgY2xrX2Rpc2Fi
bGVfdW5wcmVwYXJlKGZlcC0+Y2xrX2FoYik7DQo+ID4gPiA+ID4gICAgICAgICBjbGtfZGlzYWJs
ZV91bnByZXBhcmUoZmVwLT5jbGtfaXBnKTsNCj4gPiA+ID4gPiArI2VuZGlmDQo+ID4gPiA+ID4g
ICAgICAgICBpZiAob2ZfcGh5X2lzX2ZpeGVkX2xpbmsobnApKQ0KPiA+ID4gPiA+ICAgICAgICAg
ICAgICAgICBvZl9waHlfZGVyZWdpc3Rlcl9maXhlZF9saW5rKG5wKTsNCj4gPiA+ID4gPiAgICAg
ICAgIG9mX25vZGVfcHV0KGZlcC0+cGh5X25vZGUpOw0KPiA+ID4gPiA+IC0tDQo+ID4gPiA+ID4g
Mi4yMy4wDQo+ID4gPiA+DQo=
