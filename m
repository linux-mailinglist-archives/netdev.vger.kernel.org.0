Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB91114000
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 12:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfLELTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 06:19:51 -0500
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:29900
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729017AbfLELTv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 06:19:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpV6ToDJ/IQBArrF/wKxIK0ygp08nCuGnrrTcfAwttyaREcPNWDzsRKz66BW6W9jf5TssrjX59i3N1HeeywPUU0Z/1wa0X1hKo89TIjzJvrGeiZvTubUb4mhYZ7htKRwTxfYASIvEd+O9WHu0zTLlosujkOaqiDl1/uEzXrxLXjzGenPABaV0LuvNZECW3sH9PF7xkxuZdg2klfychbi57w9ZPoLvOQ93/Avi2RK91qaCZOtyOW88gnEJKm5YqLRjslJsHAkoI++P1tXQEXC80WvIwxKbo7ZU1DUcuWx18FCeb9Xr6J+kNTlZou3Rl3dQEfXtpp9sZinFtp54ZLsow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMTUuH4rcNNbpG+Z6X3J68J+qDQL1YEuFlAzpAM24Xw=;
 b=T9G3rS4L/zKB7k08zszjCtNpwsHCQSVeU8RhXSpHCZPsaas66ekz9qjKWUSunwK6yqHktajU/lO5B20MG11LkXtfrKLm1OevgPCnty7n63m8paC/+xjBEW/eUCwJg7Mxqors5cZFS2t+y9I7G3yPo3IYu9ymasn/2R0E+BbMsp7yXzByfHfIyyYqiFPxyybm1cmkIKeu9Z1wplAmqFq3bsrJLcbAwNCSL+Q32zsjZFhJNlFVYuO6+C8TwX0AjKE89yJo6wDbCFDFwEsCYItPZDCjmpMbNTG2Pa6KOMO5fWJCzGEv7zGl+dzC9r0FKus9If1KYcuaoHbjh3CMeGOwEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMTUuH4rcNNbpG+Z6X3J68J+qDQL1YEuFlAzpAM24Xw=;
 b=cBPx0JCKRipoyM2VBqzu1z2qnIlBl9SLwkFXU2+xSKb8qMffkrI9Ebbua43O7pjG9UNtodKcQekZd7vwxH8gyPiXdLmkL8t3uc3hMXl8y6HBOXS0NDhJZ5qJSOxvZI3FjJG4m+2HgsQfYhOiOKDvFXsxaMTNgxvk+QclpZPEK9E=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4235.eurprd04.prod.outlook.com (52.135.128.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Thu, 5 Dec 2019 11:19:46 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.014; Thu, 5 Dec 2019
 11:19:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
Thread-Topic: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
Thread-Index: AQHVpOd0/zAyRBOEIkuRK6cuc/m3PqeowUOAgACCKzCAAHEBAIABnIgAgAAZ27CAAATfgIAAANMA
Date:   Thu, 5 Dec 2019 11:19:45 +0000
Message-ID: <DB7PR04MB461820120FF61E08B8B5B0B5E65C0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-3-qiangqing.zhang@nxp.com>
 <ad7e7b15-26f3-daa1-02d2-782ff548756d@pengutronix.de>
 <DB7PR04MB46180C5F1EAC7C4A69A45E0CE65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <d68b2b79-34ec-eb4c-cf4b-047b5157d5e3@pengutronix.de>
 <a1ded645-9e12-d939-7920-8e79983b02a0@geanix.com>
 <DB7PR04MB46184164EAC5719BDCF3822CE65C0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <e7bef254-9762-0b77-1ace-2040113982ec@geanix.com>
In-Reply-To: <e7bef254-9762-0b77-1ace-2040113982ec@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 57a58e1a-b239-47fa-6ff4-08d77975089b
x-ms-traffictypediagnostic: DB7PR04MB4235:|DB7PR04MB4235:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4235B7A0FC738F1DEC9EB3DAE65C0@DB7PR04MB4235.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(13464003)(199004)(189003)(54906003)(19627235002)(81156014)(99286004)(8936002)(25786009)(11346002)(81166006)(110136005)(8676002)(5660300002)(4326008)(2906002)(64756008)(26005)(316002)(66556008)(7696005)(66946007)(14444005)(71190400001)(71200400001)(66446008)(33656002)(52536014)(74316002)(76116006)(66476007)(14454004)(305945005)(186003)(76176011)(102836004)(9686003)(86362001)(55016002)(6506007)(53546011)(229853002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4235;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Za+gCSTSJj67KrCVAcgUGZVJJ5hMs2wUurRQtHtxgSRQu4GXKgGjTBlZ4EpP3loDcwF5sRxb0dzfULt8/J3szOAH1jT86Gc1FbAaLXNz/YKXM0iJ8Oh6zztHZbGOnrZE7gwUjZsJm4d+vYTbDcCWUu1BLFQ0J5Ci5ZwIvaGT62xPw5fkGLw2kYynVNOtmfMCLFfMMKQ5t28/j9kqT8HS8MwxdZxIi1gs5OGs5lTJtkkVjml2JMwZEZWzOpky/U1z1MqckSPYvQZzsWHJKEs76SYPPAx1JkvgQ0nfASyaSOG9CuPV+XFsCBvpE1pOhfZA5FVzmr6fnbNzCE8PXuVynf1/O5hxKwbuUTdqVC32wkJ1tk1J7TMpM+g4vtYu9xarBDktl1GNCuWI6w/8a2SProAlgc5o8sfJ9wqBIUkEZBPunD5L0Lrg/YolIxlJjXQW3kWu8QaChJe76PYrCP42/j3ss0UhvHchh7UeHvcuZ2Bu5xua+heBvNaB+Q0qkGj8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57a58e1a-b239-47fa-6ff4-08d77975089b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 11:19:45.7484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ySGOEWoBnrgetKKuZC4fPyfoUeEtteYzeRobr++0XzNylGCUz/yfDYfu0GAKItygH5djdUsiM6dEZXUGFIDeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4235
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDEy5pyINeaXpSAxOToxMg0KPiBUbzogSm9h
a2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IE1hcmMgS2xlaW5lLUJ1ZGRlDQo+
IDxta2xAcGVuZ3V0cm9uaXguZGU+OyBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnDQo+IENjOiBk
bC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0K
PiBTdWJqZWN0OiBSZTogW1BBVENIIFYyIDIvNF0gY2FuOiBmbGV4Y2FuOiB0cnkgdG8gZXhpdCBz
dG9wIG1vZGUgZHVyaW5nIHByb2JlDQo+IHN0YWdlDQo+IA0KPiANCj4gDQo+IE9uIDA1LzEyLzIw
MTkgMTIuMDQsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBIaSBTZWFuLA0KPiA+DQo+ID4gQXQg
bXkgc2lkZSwgYm90aCBQb3dlci1Pbi1SZXNldCBhbmQgcmVib290IGZyb20gY29uc29sZSBjYW4g
Z2V0IENBTi1JUCBvdXQNCj4gb2Ygc3RvcCBtb2RlLCBIVyBpcyBpLk1YN0QtU0RCL2kuTVg4UVhQ
LW1lay4NCj4gPiBJIHRoaW5rIEhXIGRlc2lnbiBjb3VsZCBtYWtlIGRpZmZlcmVuY2UuDQo+ID4N
Cj4gPiBXZSBtb3JlIGNhcmUgYWJvdXQgaG93IGRvZXMgQ0FOLUlQIHN0dWNrIGluIHN0b3AgbW9k
ZSwgY291bGQgeW91IHBsZWFzZQ0KPiBleHBsYWluIGluIGRldGFpbHM/IFdlIHdhbnQgZmlndXJl
IG91dCB0aGUgcm9vdCBjYXVzZS4NCj4gDQo+IFdoZW4gcnVubmluZyBvbmx5IHdpdGggdGhlIGZp
cnN0IHN0b3AgbW9kZSBjb21taXQ6DQo+IGRlMzU3OGMxOThjNiAoImNhbjogZmxleGNhbjogYWRk
IHNlbGYgd2FrZXVwIHN1cHBvcnQiKSBBbmQgdGhlcmUgaXMgaW5jb21pbmcNCj4gdHJhZmZpYyBv
biBib3RoIENBTiBsaW5lcy4NCj4gSSBoYXBwZW5zIHdoZW4gZ29pbmcgaW50byBzdXNwZW5kLg0K
PiBUaGVuIHRoZSBDQU4tSVAgaXMgc3R1Y2sgaW4gc3RvcCBtb2RlLi4NCg0KVGhhdCBtZWFucyB3
aXRoIGJlbG93IHBhdGNoIHRoZW4gQ0FOLUlQIGNvdWxkIG5vdCBiZWVuIHN0dWNrIGluIHN0b3Ag
bW9kZSwgcmlnaHQ/DQoJY2FuOiBmbGV4Y2FuOiBmaXggZGVhZGxvY2sgd2hlbiB1c2luZyBzZWxm
IHdha2V1cA0KDQpJZiB5ZXMsIEkgdGhpbmsgd2UgZG9uJ3QgbmVlZCBjaGVjayBzdG9wIG1vZGUg
aW4gcHJvYmUgc3RhZ2UsIHNpbmNlIGlzc3VlIGhhcyBkaXNhcHBlYXJlZCBhdXRvbWF0aWNhbGx5
Lg0KDQo+IEknbSBvbiB0aGlzIGN1c3RvbSBpLk1YNnVsbCBib2FyZC4NCj4gSSBoYXZlIGFub3Ro
ZXIgY3VzdG9tIGJvYXJkIGFsc28gd2l0aCB0aGUgaS5NWDZ1bGwgd2hlcmUgdGhlIHdhdGNoZG9n
IHBpbnMNCj4gYXJlIHdpcmVkIHRvIHRoZSBQTUlDLg0KPiBXaWxsIHRyeSB0byB0ZXN0IG9uIHRo
YXQgbmV4dCB3ZWVrDQoNCk9rYXksIHRoYW5rcy4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpo
YW5nDQo+IC9TZWFuDQo=
