Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460E11C94A4
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgEGPQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:16:20 -0400
Received: from mail-db8eur05on2134.outbound.protection.outlook.com ([40.107.20.134]:36032
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725914AbgEGPQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 11:16:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3hWVdfqGW2j2Aw1D53h+W487Vagknbpr4PlbJ1zRgwSN6byeNMV9BpH+mKvzmuGqmA1ymvmjevR0aCmfA+uJs3sltUT5QPydFeyGlyBbfhSX9XJaP+WN2HnS9Yq9WPoY/+u9gYrZEe0KqUYvr1x/IBu6VPIE1nqLLLosNchJlPsDijht31iC2xYgceK+34jwAqeBHtZRpjxH2SkMtUMeDapQ9U6VfxOz67TiEdq7U+J315gq6x21nCqTgBM/be2wdHQbgEt/hdJjrHIoWpO/uPD+Nz3nYjhg4TXDxjJjgGxKKNVVsrBYJSin8EgbfCkfkyuHSUmrH8OU/+b5TwaEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hk0+qBzJkawVqyM7nwUAJR4y04ik4ikibl8xagybnbw=;
 b=cw1FDHTL0JQcZhJmakC+v8hYK2aEmTpDx1iCydQCHO2lB2M52hD5ahNfsTznFNZs0hGYtaEWLGK0PBPaCBC6rghrH8A01taKaeSgPCcam2p5T/tx9vb9/1B+wHmIYk9EWTdG68OILdjIHpnvFe32gmYqmmbHrZa4Q+8UD3R7J6IWAPCsAUYZ2SY5Ot4wfAFL5H+8FU1eiGIiAc1O7tcIJ0Msp2Dy9zPQRdH8rgDp3TIM1Jsahmr4QPc3qIyeMbgvdCfbZAswE0PDQOShorc6InWeji+/GJOA1Iz+zQP9g8Az2DbTYWBbFhVpDCJqHDmOV+X2jvGFnOiRBrEeLxCm3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hk0+qBzJkawVqyM7nwUAJR4y04ik4ikibl8xagybnbw=;
 b=Qh9L+NRzScr4flyP6KEcPs2JwGqfLJz23IDEvJbz1JjaZMhHbaKS3a9kjrzqa1FEE0NO+LTZXVhICEui7LbbIyQpauwFLHd/CkpXJO6nL7vl0uZOw+d9opKuuyhv4nSsX4VyfgKFh+T0iKMqEjUdkSuWY7VJiImz46j8ayV6r60=
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com (2603:10a6:20b:a8::25)
 by AM6PR05MB5141.eurprd05.prod.outlook.com (2603:10a6:20b:67::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30; Thu, 7 May
 2020 15:16:14 +0000
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::d8d3:ead7:9f42:4289]) by AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::d8d3:ead7:9f42:4289%6]) with mapi id 15.20.2979.030; Thu, 7 May 2020
 15:16:14 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "tony@atomide.com" <tony@atomide.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>
CC:     "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH v2] ARM: dts: am437x: fix networking on boards with
 ksz9031 phy
Thread-Topic: [PATCH v2] ARM: dts: am437x: fix networking on boards with
 ksz9031 phy
Thread-Index: AQHWJIII3W/PJOejREifJgtNRdtK5Kicu+EA
Date:   Thu, 7 May 2020 15:16:14 +0000
Message-ID: <91c1ba87f2dfa66e11681d2660782a2efce2615d.camel@toradex.com>
References: <20200507151244.24218-1-grygorii.strashko@ti.com>
In-Reply-To: <20200507151244.24218-1-grygorii.strashko@ti.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 
authentication-results: atomide.com; dkim=none (message not signed)
 header.d=none;atomide.com; dmarc=none action=none header.from=toradex.com;
x-originating-ip: [51.154.7.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5de1d9d-a855-4ef2-628d-08d7f2999590
x-ms-traffictypediagnostic: AM6PR05MB5141:
x-microsoft-antispam-prvs: <AM6PR05MB5141E3F446785D6A0D093CA3F4A50@AM6PR05MB5141.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-forefront-prvs: 03965EFC76
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wAGlEX3nfZ6aDgjNm1T9Pyk+IcLG0RgfORiO6wvK4tsTZQ7vyl2IA27ItJL3YlPmTEuPYoLGbUKxzm/tVCPqUphcTZF2njr7qnTE1SRXUicpblMDpGMQpMFFhSfN62lDxhsfnTqLS+zk3rVCUKYhWDC5+VKIzyElob+gFPERmWT+UaJ51qnpr46+Cz7wGKpAUGfkCBsO0dvrIzz6EQGDsjY2Yvd8kXZFAMo7JFm26xD7oTpW6n0/JgIPqjgTXCk90b0PMk19RHPXbcHjg4mLEQ+N33FrlimWnth6xcZ541t0rwlrFkyu3wBjsWkdSsegR+QUJ/q5EMg0ryA65sdHKsUV7G7KcnaRYqO3hIbwYgCbOd5jhzGLpi/2enyGZEJxauA1sSbH98dqBv1xQ5TcBopak75cyTHR1b3z8Nbp5XAhAnTzMDfx905gWMto6PrmTafDe+J6d0uUnE3gh9Jira8MOdXnFYeyX5wOwdj/oHpY32luQFPRHZYPQm/UrSciGnhS4yOpgBzSMLHDy7kLfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6120.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(136003)(396003)(366004)(346002)(376002)(33430700001)(86362001)(2616005)(186003)(71200400001)(2906002)(36756003)(26005)(6506007)(4326008)(5660300002)(91956017)(6486002)(8936002)(76116006)(66556008)(66946007)(478600001)(66476007)(6512007)(64756008)(33440700001)(8676002)(83280400001)(83320400001)(83290400001)(83310400001)(66446008)(316002)(54906003)(110136005)(44832011)(83300400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: RE6UfStw0UaGo2HDWrgie3t7yseQycUGW65i7nW+JddHaIzyMg+UHmV/oBO5Da4FSCiaOZhePEpelqJldyjQ1A6L2M712tZvURXPoto4rAziPmP5eVOEWpn1g5Qf7KLmk4QixZvU2hWkPrpOtQuwawi2S3Kw/W6eKpZqsXhFMkYIzNc+PVRoKkJ+lfOanDskRTs0PvOt/+HWQw1EYjRaMesJf1f2vBpq/bXWYm4+YLXnJmfrEpYTBFM+k9eHFchDVgJS9kE39yPDy+I7eXqSsUecsa+IDtt36JaM2Li0efHwyJiVj/ffgaBRwFcoPrAqZ/qYQHitOy1bvBzgwf4uStgUz9pBKzN4xuHXX0pvVgKf/QcSse6jvEa1buFx5ZycWU/PaoZdMUPoX4FveTo9E4+sxbkndh2Lq5l9lm96+kyNCeo5J9erPj6OR9BOUDxfMjbrl+cKcicXG0aseLA5g5JzDqOjRD/PvHoYdknXOlPgWjhuilwtLeFqzXtEsI+pgXNdfWJ91Q1L65+zNDsTyHdSLzK4wdxGwdRab38v8V8XP3UasLSxGBwN5mzXGEBrBmLUBJp9gfJYCwPVVSYtCY6CNl+CQxp+GExAsTXz4eK/J+LosVN+XA7iI7D9ErZ1khJzmCBGAd3zRHhbRT1gRkwBZSx0yncw5pLFV/XvyxPC35kbWlpYlOGEchRf8KSPfPcINu4E/tVMqiW1wDnnF8mdc6yLPW/kIocVfd/6FXehc80hkiZlHVnk6cxvZwjOIwei6Oa/D8h80DKYjiCqulHzhgUav9xBP6Ka6FdqcVk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6732801A49BDC4A80B8E0CB78AF63CC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5de1d9d-a855-4ef2-628d-08d7f2999590
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2020 15:16:14.8390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GlD3HlK9JEu2Kb/L3ysaK5P1AuB530szCkVLe1kXvtGXMYiq/04Lhm67+s4jCGEgfw72nu03kkIq06V1vNUY16dgFOH4J5gqMS3oYKxavT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5141
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA1LTA3IGF0IDE4OjEyICswMzAwLCBHcnlnb3JpaSBTdHJhc2hrbyB3cm90
ZToNCj4gU2luY2UgY29tbWl0IGJjZjM0NDBjNmRkNyAoIm5ldDogcGh5OiBtaWNyZWw6IGFkZCBw
aHktbW9kZSBzdXBwb3J0IGZvcg0KPiB0aGUNCj4gS1NaOTAzMSBQSFkiKSB0aGUgbmV0d29ya2lu
ZyBpcyBicm9rZW4gb24gYm9hcmRzOg0KPiAgYW00Mzd4LWdwLWV2bQ0KPiAgYW00Mzd4LXNrLWV2
bQ0KPiAgYW00Mzd4LWlkay1ldm0NCj4gDQo+IEFsbCBhYm92ZSBib2FyZHMgaGF2ZSBwaHktbW9k
ZSA9ICJyZ21paSIgYW5kIHRoaXMgaXMgd29ya2VkIGJlZm9yZSwNCj4gYmVjYXVzZQ0KPiBLU1o5
MDMxIFBIWSBzdGFydGVkIHdpdGggZGVmYXVsdCBSR01JSSBpbnRlcm5hbCBkZWxheXMgY29uZmln
dXJhdGlvbg0KPiAoVFgNCj4gb2ZmLCBSWCBvbiAxLjIgbnMpIGFuZCBNQUMgcHJvdmlkZWQgVFgg
ZGVsYXkuIEFmdGVyIGFib3ZlIGNvbW1pdCwgdGhlDQo+IEtTWjkwMzEgUEhZIHN0YXJ0cyBoYW5k
bGluZyBwaHkgbW9kZSBwcm9wZXJseSBhbmQgZGlzYWJsZXMgUlggZGVsYXksDQo+IGFzDQo+IHJl
c3VsdCBuZXR3b3JraW5nIGlzIGJlY29tZSBicm9rZW4uDQo+IA0KPiBGaXggaXQgYnkgc3dpdGNo
aW5nIHRvIHBoeS1tb2RlID0gInJnbWlpLXJ4aWQiIHRvIHJlZmxlY3QgcHJldmlvdXMNCj4gYmVo
YXZpb3IuDQo+IA0KPiBDYzogT2xla3NpaiBSZW1wZWwgPG8ucmVtcGVsQHBlbmd1dHJvbml4LmRl
Pg0KPiBDYzogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBDYzogUGhpbGlwcGUgU2No
ZW5rZXIgPHBoaWxpcHBlLnNjaGVua2VyQHRvcmFkZXguY29tPg0KPiBGaXhlczogY29tbWl0IGJj
ZjM0NDBjNmRkNyAoIm5ldDogcGh5OiBtaWNyZWw6IGFkZCBwaHktbW9kZSBzdXBwb3J0DQo+IGZv
ciB0aGUgS1NaOTAzMSBQSFkiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBHcnlnb3JpaSBTdHJhc2hrbyA8
Z3J5Z29yaWkuc3RyYXNoa29AdGkuY29tPg0KDQpSZXZpZXdlZC1ieTogUGhpbGlwcGUgU2NoZW5r
ZXIgPHBoaWxpcHBlLnNjaGVua2VyQHRvcmFkZXguY29tPg0KDQo+IC0tLQ0KPiAgYXJjaC9hcm0v
Ym9vdC9kdHMvYW00Mzd4LWdwLWV2bS5kdHMgIHwgMiArLQ0KPiAgYXJjaC9hcm0vYm9vdC9kdHMv
YW00Mzd4LWlkay1ldm0uZHRzIHwgMiArLQ0KPiAgYXJjaC9hcm0vYm9vdC9kdHMvYW00Mzd4LXNr
LWV2bS5kdHMgIHwgNCArKy0tDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwg
NCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybS9ib290L2R0cy9hbTQz
N3gtZ3AtZXZtLmR0cw0KPiBiL2FyY2gvYXJtL2Jvb3QvZHRzL2FtNDM3eC1ncC1ldm0uZHRzDQo+
IGluZGV4IDgxMWM4Y2FlMzE1Yi4uZDY5MmUzYjI4MTJhIDEwMDY0NA0KPiAtLS0gYS9hcmNoL2Fy
bS9ib290L2R0cy9hbTQzN3gtZ3AtZXZtLmR0cw0KPiArKysgYi9hcmNoL2FybS9ib290L2R0cy9h
bTQzN3gtZ3AtZXZtLmR0cw0KPiBAQCAtOTQzLDcgKzk0Myw3IEBADQo+ICANCj4gICZjcHN3X2Vt
YWMwIHsNCj4gIAlwaHktaGFuZGxlID0gPCZldGhwaHkwPjsNCj4gLQlwaHktbW9kZSA9ICJyZ21p
aSI7DQo+ICsJcGh5LW1vZGUgPSAicmdtaWktcnhpZCI7DQo+ICB9Ow0KPiAgDQo+ICAmZWxtIHsN
Cj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtL2Jvb3QvZHRzL2FtNDM3eC1pZGstZXZtLmR0cw0KPiBi
L2FyY2gvYXJtL2Jvb3QvZHRzL2FtNDM3eC1pZGstZXZtLmR0cw0KPiBpbmRleCA5ZjY2Zjk2ZDA5
YzkuLmE5NThmOWVlNGE1YSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm0vYm9vdC9kdHMvYW00Mzd4
LWlkay1ldm0uZHRzDQo+ICsrKyBiL2FyY2gvYXJtL2Jvb3QvZHRzL2FtNDM3eC1pZGstZXZtLmR0
cw0KPiBAQCAtNTA0LDcgKzUwNCw3IEBADQo+ICANCj4gICZjcHN3X2VtYWMwIHsNCj4gIAlwaHkt
aGFuZGxlID0gPCZldGhwaHkwPjsNCj4gLQlwaHktbW9kZSA9ICJyZ21paSI7DQo+ICsJcGh5LW1v
ZGUgPSAicmdtaWktcnhpZCI7DQo+ICB9Ow0KPiAgDQo+ICAmcnRjIHsNCj4gZGlmZiAtLWdpdCBh
L2FyY2gvYXJtL2Jvb3QvZHRzL2FtNDM3eC1zay1ldm0uZHRzDQo+IGIvYXJjaC9hcm0vYm9vdC9k
dHMvYW00Mzd4LXNrLWV2bS5kdHMNCj4gaW5kZXggMjUyMjI0OTdmODI4Li40ZDVhN2NhMmUyNWQg
MTAwNjQ0DQo+IC0tLSBhL2FyY2gvYXJtL2Jvb3QvZHRzL2FtNDM3eC1zay1ldm0uZHRzDQo+ICsr
KyBiL2FyY2gvYXJtL2Jvb3QvZHRzL2FtNDM3eC1zay1ldm0uZHRzDQo+IEBAIC04MzMsMTMgKzgz
MywxMyBAQA0KPiAgDQo+ICAmY3Bzd19lbWFjMCB7DQo+ICAJcGh5LWhhbmRsZSA9IDwmZXRocGh5
MD47DQo+IC0JcGh5LW1vZGUgPSAicmdtaWkiOw0KPiArCXBoeS1tb2RlID0gInJnbWlpLXJ4aWQi
Ow0KPiAgCWR1YWxfZW1hY19yZXNfdmxhbiA9IDwxPjsNCj4gIH07DQo+ICANCj4gICZjcHN3X2Vt
YWMxIHsNCj4gIAlwaHktaGFuZGxlID0gPCZldGhwaHkxPjsNCj4gLQlwaHktbW9kZSA9ICJyZ21p
aSI7DQo+ICsJcGh5LW1vZGUgPSAicmdtaWktcnhpZCI7DQo+ICAJZHVhbF9lbWFjX3Jlc192bGFu
ID0gPDI+Ow0KPiAgfTsNCj4gIA0K
