Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7922E166C7
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 17:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfEGPch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 11:32:37 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:21788 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEGPch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 11:32:37 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,442,1549954800"; 
   d="scan'208";a="31960315"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 May 2019 08:32:35 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.107) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 7 May 2019 08:32:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QqbYESgXt9g+I75TZNWTl9nIU6DAI2skvafxKXSbIU=;
 b=d387T7rIuCqTjiPaYPb/2rpQrrZrKEcCPs6uPfDdNKp0uv5zyLlB0ZwsAM7sJHYQwMaUmX/WD3x+ZsSuWuXtsqA2TQN1JpWASFvMwU7e5Tmvei/4Vz4NmUya8/yTpxy+uOJP6k6tM5eOLxgtfQINCNTkrCpE5Mfc593m66witQ4=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHPR11MB1919.namprd11.prod.outlook.com (10.175.54.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Tue, 7 May 2019 15:32:34 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::990d:15eb:1a20:3255]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::990d:15eb:1a20:3255%6]) with mapi id 15.20.1856.012; Tue, 7 May 2019
 15:32:33 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <harini.katakam@xilinx.com>, <davem@davemloft.net>,
        <rafalo@cadence.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>
Subject: Re: [PATCH] net: macb: Change interrupt and napi enable order in open
Thread-Topic: [PATCH] net: macb: Change interrupt and napi enable order in
 open
Thread-Index: AQHVBOGZMbHCnAOQYkeJXI/NCGajJ6ZfymGA
Date:   Tue, 7 May 2019 15:32:33 +0000
Message-ID: <1f828865-16ec-0d2e-93a3-e911d0b6baa2@microchip.com>
References: <1557239350-4760-1-git-send-email-harini.katakam@xilinx.com>
In-Reply-To: <1557239350-4760-1-git-send-email-harini.katakam@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:a03:74::18) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f23b32fd-789a-45d6-9eb2-08d6d3013993
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR11MB1919;
x-ms-traffictypediagnostic: MWHPR11MB1919:
x-microsoft-antispam-prvs: <MWHPR11MB19190C94BEA149CDBF0AC6F2E0310@MWHPR11MB1919.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0030839EEE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(136003)(376002)(346002)(189003)(199004)(2501003)(81156014)(8676002)(81166006)(4326008)(68736007)(8936002)(53936002)(31686004)(36756003)(229853002)(14444005)(256004)(2906002)(6512007)(486006)(305945005)(7736002)(71190400001)(71200400001)(3846002)(6116002)(6246003)(66446008)(6486002)(6436002)(66066001)(25786009)(5660300002)(2201001)(110136005)(86362001)(54906003)(99286004)(478600001)(72206003)(316002)(31696002)(14454004)(476003)(186003)(11346002)(102836004)(446003)(26005)(66946007)(66476007)(66556008)(64756008)(386003)(6506007)(52116002)(2616005)(53546011)(73956011)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1919;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LTX3QD86g20QgD4mr+zrz43Dy5o5Uf7iDlDxlYXk9NlafVVtyQTZPMntr3q/+9CB/eCnnOB9WLyFPGZDEcdfe33+MdgLosHLMRW/+DvG+1n3Zcf0/4GJ0XGYEs+GGFjFJyqBuYBQxuO7fa0GPVqbByKy3rgH1jDANZByfjMf54xXYHRV5uZcqf4ybMhCxmP+zpm7Wg9J5dbbDiN8sQ8UHdiVGYdYMd3hKkU4O1v6SjoPGLLJTL+Fq+Urj4JFUxjzHDEXB4yXJP7Wb1wOvjWHTIdZL3tODg9GLH4NXHUxME4Lprx74/xSqSrg6tTUc1iWF3notRprLBy4u8mlfucS5QWoe4L+JVFi2ay11S142a49EA82rROJ78nqiOAbuSlNS/GH/sfrHT0iHPEEKn8VEpnAXy7NHgytV/mdp+ilZWA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <532FBD47D62B164C95435D0E227D07D4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f23b32fd-789a-45d6-9eb2-08d6d3013993
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2019 15:32:33.7330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1919
X-OriginatorOrg: microchip.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDcvMDUvMjAxOSBhdCAxNjoyOSwgSGFyaW5pIEthdGFrYW0gd3JvdGU6DQo+IEV4dGVybmFs
IEUtTWFpbA0KPiANCj4gDQo+IEN1cnJlbnQgb3JkZXIgaW4gb3BlbjoNCj4gLT4gRW5hYmxlIGlu
dGVycnVwdHMgKG1hY2JfaW5pdF9odykNCj4gLT4gRW5hYmxlIE5BUEkNCj4gLT4gU3RhcnQgUEhZ
DQo+IA0KPiBTZXF1ZW5jZSBvZiBSWCBoYW5kbGluZzoNCj4gLT4gUlggaW50ZXJydXB0IG9jY3Vy
cw0KPiAtPiBJbnRlcnJ1cHQgaXMgY2xlYXJlZCBhbmQgaW50ZXJydXB0IGJpdHMgZGlzYWJsZWQg
aW4gaGFuZGxlcg0KPiAtPiBOQVBJIGlzIHNjaGVkdWxlZA0KPiAtPiBJbiBOQVBJLCBSWCBidWRn
ZXQgaXMgcHJvY2Vzc2VkIGFuZCBSWCBpbnRlcnJ1cHRzIGFyZSByZS1lbmFibGVkDQo+IA0KPiBX
aXRoIHRoZSBhYm92ZSwgb24gUUVNVSBvciBmaXhlZCBsaW5rIHNldHVwcyAod2hlcmUgUEhZIHN0
YXRlIGRvZXNuJ3QNCj4gbWF0dGVyKSwgdGhlcmUncyBhIGNoYW5jZSBtYWNiIFJYIGludGVycnVw
dCBvY2N1cnMgYmVmb3JlIE5BUEkgaXMNCj4gZW5hYmxlZC4gVGhpcyB3aWxsIHJlc3VsdCBpbiBO
QVBJIGJlaW5nIHNjaGVkdWxlZCBiZWZvcmUgaXQgaXMgZW5hYmxlZC4NCj4gRml4IHRoaXMgbWFj
YiBvcGVuIGJ5IGNoYW5naW5nIHRoZSBvcmRlci4NCj4gDQo+IEZpeGVzOiBhZTFmMmE1NmQyNzMg
KCJuZXQ6IG1hY2I6IEFkZGVkIHN1cHBvcnQgZm9yIG1hbnkgUlggcXVldWVzIikNCj4gU2lnbmVk
LW9mZi1ieTogSGFyaW5pIEthdGFrYW0gPGhhcmluaS5rYXRha2FtQHhpbGlueC5jb20+DQoNCml0
IGxvb2tzIG9rYXkgdG8gbWU6DQpBY2tlZC1ieTogTmljb2xhcyBGZXJyZSA8bmljb2xhcy5mZXJy
ZUBtaWNyb2NoaXAuY29tPg0KDQo+IC0tLQ0KPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVu
Y2UvbWFjYl9tYWluLmMgfCA2ICsrKy0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlv
bnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2Uv
bWFjYl9tYWluLmMNCj4gaW5kZXggNWQ1YzlkNy4uYzA0OTQxMCAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IEBAIC0yNDI3LDEyICsyNDI3LDEyIEBA
IHN0YXRpYyBpbnQgbWFjYl9vcGVuKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+ICAgCQlnb3Rv
IHBtX2V4aXQ7DQo+ICAgCX0NCj4gICANCj4gLQlicC0+bWFjYmdlbV9vcHMubW9nX2luaXRfcmlu
Z3MoYnApOw0KPiAtCW1hY2JfaW5pdF9odyhicCk7DQo+IC0NCj4gICAJZm9yIChxID0gMCwgcXVl
dWUgPSBicC0+cXVldWVzOyBxIDwgYnAtPm51bV9xdWV1ZXM7ICsrcSwgKytxdWV1ZSkNCj4gICAJ
CW5hcGlfZW5hYmxlKCZxdWV1ZS0+bmFwaSk7DQo+ICAgDQo+ICsJYnAtPm1hY2JnZW1fb3BzLm1v
Z19pbml0X3JpbmdzKGJwKTsNCj4gKwltYWNiX2luaXRfaHcoYnApOw0KPiArDQo+ICAgCS8qIHNj
aGVkdWxlIGEgbGluayBzdGF0ZSBjaGVjayAqLw0KPiAgIAlwaHlfc3RhcnQoZGV2LT5waHlkZXYp
Ow0KPiAgIA0KPiANCg0KDQotLSANCk5pY29sYXMgRmVycmUNCg==
