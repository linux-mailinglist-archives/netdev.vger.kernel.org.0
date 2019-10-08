Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D408CF6E7
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbfJHKVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:21:05 -0400
Received: from mail-eopbgr30080.outbound.protection.outlook.com ([40.107.3.80]:61422
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729790AbfJHKVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 06:21:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RkgrUsj121XOTBvAwtKEnTZsFt8/IRXsHQPForIk4lAtcH68rNS+IMd5WSTj4OQzFl6uHXBspZGfmeot4Tctk5Y7vEV9ZHAq2sx7rhcPdmbupYziaD4l3CMhoI723lTyWDhb7LNcy3oNUjuy9dZ5IWEONqWu+I1YScw8xi+2IJI1GXHZt+hPRYYnoQUj9v1P/5mmjXDg2gwnyNhadX1/w8jjWBnZLHsi9fDEusNfHvdYU+zsYWwAOidsovG/ak18ua3Ga9dTp/C0jVWanq2wpa2zQHHI3mNp+vdaAiwW9mZu8iktu5f3d31nSJp+lxGo3/gNvXYetto8/xcpJPF4IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAXvZH0SC4IvclOFg9qdJiVXICY/bqoZh2mfnaphjeA=;
 b=ToDzhoP8Ji/oEBz6J1vhYDEJ3okQoXlQUpka040/le4sMnNTnCR4ZXlFGbyvr21QTKv56AieFGUbdnSbyLi4Ma+0oI+EQcnjdT3mEiSvLZSqOPopF3eW7c5apfA24KjTokhkqleHU3Ffy/pATlvCY6VXTsHmp4l4rwXnYaP2sDxkx/3EHevEmGCxpSraYEBHDdtHFXkV87tXRLnm23FsRnb4MBKp0unYy197SW8vO8aL/hnqa78AxjkWzKxJNAyc3egsNW8/RxD4jTz+wk5WVEy/vts7zzdx8UWEc2F5TaNu6WTEvMWqBAWuBwRRbmNFQ1roBIz3Kqugh511pN5NJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAXvZH0SC4IvclOFg9qdJiVXICY/bqoZh2mfnaphjeA=;
 b=cNRIf2tEYWZvtTxuLQ3HROl4IgItL5iUliR1Qft2hCJYwhMfLGRDOL9pfIxHeIp6NjLXtel19nQf/GGSXbdw/7b0iPi/hmMSpNGzXNJHhZZhgk7qfvdMLcC+o9AboQThmRIbayzv6AGFB0ofqBwOo5gwsLvyMAbT6uqoXIBKx84=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4604.eurprd04.prod.outlook.com (52.135.138.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.23; Tue, 8 Oct 2019 10:21:00 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::79f1:61a7:4076:8679]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::79f1:61a7:4076:8679%3]) with mapi id 15.20.2327.026; Tue, 8 Oct 2019
 10:21:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        =?utf-8?B?TWFydGluIEh1bmRlYsO4bGw=?= <martin@geanix.com>
Subject: RE: [PATCH REPOST 1/2] can: flexcan: fix deadlock when using self
 wakeup
Thread-Topic: [PATCH REPOST 1/2] can: flexcan: fix deadlock when using self
 wakeup
Thread-Index: AQHVVAt+uezYlHzMP0yJKoK3YxkiS6cD2xAAgAAKUjCAAA71AIAMq3CAgAEuS9CACueJAIAAERoggAfqqoCALCoiMA==
Date:   Tue, 8 Oct 2019 10:20:59 +0000
Message-ID: <DB7PR04MB4618DEF0873D110536724818E69A0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190816081749.19300-1-qiangqing.zhang@nxp.com>
 <20190816081749.19300-2-qiangqing.zhang@nxp.com>
 <dd8f5269-8403-702b-b054-e031423ffc73@geanix.com>
 <DB7PR04MB4618A1F984F2281C66959B06E6AB0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <35190c5b-f8be-8784-5b4f-32a691a6cffe@geanix.com>
 <6a9bc081-334a-df91-3a23-b74a6cdd3633@geanix.com>
 <DB7PR04MB4618E527339B69AEAD46FB06E6A20@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <588ab34d-613d-ac01-7949-921140ca4543@geanix.com>
 <DB7PR04MB461868320DA0B25CC8255213E6BB0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <739eee2e-2919-93b4-24fe-8d0d198ae042@geanix.com>
In-Reply-To: <739eee2e-2919-93b4-24fe-8d0d198ae042@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdda9318-9a42-420b-5811-08d74bd93712
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DB7PR04MB4604:|DB7PR04MB4604:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB46041326210F55765DFECB0CE69A0@DB7PR04MB4604.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(13464003)(189003)(199004)(86362001)(4744005)(486006)(14444005)(66574012)(2201001)(256004)(33656002)(6436002)(66066001)(9686003)(99286004)(8676002)(54906003)(478600001)(305945005)(25786009)(7736002)(74316002)(55016002)(26005)(71190400001)(186003)(71200400001)(110136005)(316002)(64756008)(6506007)(7696005)(6116002)(66446008)(66946007)(3846002)(52536014)(81156014)(76176011)(229853002)(102836004)(5660300002)(14454004)(53546011)(66556008)(6246003)(476003)(76116006)(11346002)(2906002)(2501003)(81166006)(8936002)(446003)(66476007)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4604;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OAh/j24/cg30GrvLICCM3Q20g43Yz8FISa6fbTr1T2DOwHWuu8bmp7HYl6BkTC9Uh9gvVENaQpcJbi7zrFQnKpjFN6pa69gD2oyyVhkFfNkUzy5A3YH2vA3ThpXTmN2blmi/s80FwH4+ExP0EsxNOYtcwfZtvM/aMShG9Tl6owROe2wwNLNrDBIIR42laao4BdNgVAkDxdC1FKShRKiyafYYAeihHKIY5BYl8iRrA1bGgVz93pvX8FHY58AUy3zUOtImW/Xw4ebMaeqeF08jMjdznnNCeuSZFijd3BKSe2iF9OoWaFbhVfwvKj3X6syu3tqZhEW2hmZhOXjsCUUPl8ED4btGUmh/Vn75M4LflT7yY0quHgTakXcvCSlSazZWK/5dp/+t89SC57lQelQk3vQSsDmHdbFEa+K6QXF1sV8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdda9318-9a42-420b-5811-08d74bd93712
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 10:20:59.8451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BJL3tA/hP4UnxMEuzkDGSAq8/eb/24iSDq5dt0Nm9iFvjB7uJ4Ot1nppxP125qfk37XSML3diURN0bKfIA/eCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4604
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDnmnIgxMOaXpSAxNTo1Mw0KPiBUbzogSm9h
a2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IG1rbEBwZW5ndXRyb25peC5kZTsN
Cj4gbGludXgtY2FuQHZnZXIua2VybmVsLm9yZw0KPiBDYzogd2dAZ3JhbmRlZ2dlci5jb207IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRsLWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54cC5jb20+
OyBNYXJ0aW4gSHVuZGViw7hsbCA8bWFydGluQGdlYW5peC5jb20+DQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggUkVQT1NUIDEvMl0gY2FuOiBmbGV4Y2FuOiBmaXggZGVhZGxvY2sgd2hlbiB1c2luZyBz
ZWxmDQo+IHdha2V1cA0KPiANCj4gDQo+IA0KPiBPbiAwNS8wOS8yMDE5IDA5LjEwLCBKb2FraW0g
Wmhhbmcgd3JvdGU6DQo+ID4gSGkgU2VhbiwNCj4gPg0KPiA+IENvdWxkIHlvdSB1cGRhdGUgbGFz
dGVzdCBmbGV4Y2FuIGRyaXZlciB1c2luZyBsaW51eC1jYW4tbmV4dC9mbGV4Y2FuIGFuZCB0aGVu
DQo+IG1lcmdlIGJlbG93IHR3byBwYXRjaGVzIGZyb20gbGludXgtY2FuL3Rlc3Rpbmc/DQo+ID4g
ZDBiNTM2MTY3MTZlIChIRUFEIC0+IHRlc3RpbmcsIG9yaWdpbi90ZXN0aW5nKSBjYW46IGZsZXhj
YW46IGFkZCBMUFNSDQo+ID4gbW9kZSBzdXBwb3J0IGZvciBpLk1YN0QgODAzZWI2YmFkNjViIGNh
bjogZmxleGNhbjogZml4IGRlYWRsb2NrIHdoZW4NCj4gPiB1c2luZyBzZWxmIHdha2V1cA0KPiA+
DQo+ID4gQmVzdCBSZWdhcmRzLA0KPiA+IEpvYWtpbSBaaGFuZw0KPiANCj4gSGkNCj4gDQo+IEkg
cmV2ZXJ0ZWQgMiBjb21taXRzIG9uIHRodyBuYW5kIGRyaXZlciBhbmQgZ290IHRoZSB0ZXN0aW5n
IGtlcm5lbCB0byB3b3JrLg0KPiANCj4gSSBjYW4gY29uZmlybSB0aGUgaXNzdWUgaXMgcmVzb2x2
ZWQgd2l0aCB0aGlzIHBhdGNoIDotKQ0KDQpIaSBNYXJjLA0KDQpIb3cgYWJvdXQgdGhlc2UgdHdv
IGZpeGVzIGZvciBGbGV4Y2FuPw0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gL1Nl
YW4NCg==
