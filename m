Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE6AA12A6
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 09:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfH2HbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 03:31:04 -0400
Received: from mail-eopbgr150080.outbound.protection.outlook.com ([40.107.15.80]:16403
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727114AbfH2HbD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 03:31:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=If/4OQadAwl/FqiRPcj5obZHyNVILuBtCcyXgsWhYN4uO9jqAZkTE1EEBf7Kt/rzZxg4rtdcK27Wj3lool0cqNVRZjZ/3eEUBia/535ohWcZbLoQhSMFO2NdxKRzYakVrEfUrVVXQ/KVzMbOIjynVNcQWbz6Heug/Ue0ajUjk8joe7oGAq/wPNrja/0en6BJwMypcQrEPSdKV9DKkbCpJQVpEaGX5tgLwyiX3wG2fK4kkR/pRqmvm3cLypzfgoEmtRLY87JasKPAKa+b7WMaVeamtP5wobREYNEgd/6Z5uDAQLaCaJnVLpWHSh9uIgkF2Hhn/4PLDT9Qg6rTo1u/YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zna0N6td2DN9CCj7IlJZxWxdl4IL0nKFbGLaCpI/oKA=;
 b=Uyp9QWc8B/d9v7YLAynDQx19SoIFJBO4teyuJlz1Tmmefbx+fn9rx+ItsrPfq1Fk50z/LOAG8C5M+ir23Qxlsw0o3xNbW/WaNoqQV1krqfhQ6BiWYerzouSVnI9vUny2aDL86jSAvEwvizAy5c/gngYFe6OuPthxzvcSUhYahcwOUX8jT0rdzK/bhq/F0JFPn3tYV0j9c3Qe9/R5vUf9Guo3b1G1GlYo4G1AcuBGvVXD9ETzQU12IMaf1zBfTFWT9gi9/GRgHLVKdyAY1xP1PaB5AqWOhqourpOdZOV8DxvTFw4JWsG3ZBrVbS6vTmPGP0Q4YviPeiN2W93WcuZC3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zna0N6td2DN9CCj7IlJZxWxdl4IL0nKFbGLaCpI/oKA=;
 b=EKiFAdJHOlfAVNAAJ1wxPNoObP0/gAQ03e1Wsz8p6Tzg/T7ZYvwXxH99KZ+aZLsQQTYAQx/BorXIg21Yjs90viGcmyqhNgofmzmc3zTTmmmw3btAFIR6qnZqCP7tYCcHLw+Yf2PcbYss0qg5dgC2IS94OIZH7G4/5CasAKy8UmM=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5018.eurprd04.prod.outlook.com (20.176.233.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Thu, 29 Aug 2019 07:30:20 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f%4]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 07:30:20 +0000
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
Thread-Index: AQHVVAt+uezYlHzMP0yJKoK3YxkiS6cD2xAAgAAKUjCAAA71AIAMq3CAgAEuS9A=
Date:   Thu, 29 Aug 2019 07:30:20 +0000
Message-ID: <DB7PR04MB4618E527339B69AEAD46FB06E6A20@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190816081749.19300-1-qiangqing.zhang@nxp.com>
 <20190816081749.19300-2-qiangqing.zhang@nxp.com>
 <dd8f5269-8403-702b-b054-e031423ffc73@geanix.com>
 <DB7PR04MB4618A1F984F2281C66959B06E6AB0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <35190c5b-f8be-8784-5b4f-32a691a6cffe@geanix.com>
 <6a9bc081-334a-df91-3a23-b74a6cdd3633@geanix.com>
In-Reply-To: <6a9bc081-334a-df91-3a23-b74a6cdd3633@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18c78fd5-4f3e-4d29-a5e0-08d72c52bf42
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5018;
x-ms-traffictypediagnostic: DB7PR04MB5018:|DB7PR04MB5018:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5018403284C4540846269CE5E6A20@DB7PR04MB5018.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(13464003)(199004)(189003)(86362001)(3846002)(33656002)(2201001)(229853002)(74316002)(7736002)(305945005)(6116002)(2906002)(2501003)(81166006)(81156014)(8676002)(8936002)(186003)(66574012)(4326008)(14454004)(26005)(102836004)(316002)(110136005)(45080400002)(6506007)(53546011)(25786009)(52536014)(54906003)(55016002)(9686003)(6306002)(66066001)(53936002)(99286004)(966005)(6246003)(7696005)(76176011)(478600001)(71200400001)(71190400001)(14444005)(256004)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(446003)(11346002)(5660300002)(6436002)(476003)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5018;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: c6jPjuMGGHq6FRzVpzgsGKBRnjyvv6a5knGSFfBxyVG8JuBCLhjAF5MuOu1eCym/zG8JHIxuLsHuYcv/AO2NmnHHY6TRcHx6Qc2W7b/wYOi5x1BO4ZGant5yC1oUvMhZh02m8KE7a7NB6YHR/gLkujT5SSCIDCfdlrodELQ0H4d2LxOUT5abBX9IB70OtTx1QYr+ltCmdMCooYy/rYfLN96TGaEyEiTFbB+orvqEN6H9OvZ8i1PbaUXnM4ZI/lFz9O+PYHbCevxW4rVAixeoozwoCD95dp8ZG4NDKSgsX8fYSNVkjPfP5bkY7utsvHdJU9qbjLrF4GwoSsBc17xDbqh7fJLMtoNYmjg9j8le+8B/wj64/+Vz8+dvJ4VzxDvBTstLz+4GQLJbRlQJTx8QqVcVJoT8kAQpsgmRZ6gaXFI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c78fd5-4f3e-4d29-a5e0-08d72c52bf42
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 07:30:20.2501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gqlCkfWFgBcea4BTXOZM+8JWvR9qJ65uNItNDIv7wukqycItZbbkuiLHgxvTayUp52s3SNzG1hMRPlKowReJsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5018
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDjmnIgyOOaXpSAyMToyNQ0KPiBUbzogSm9h
a2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IG1rbEBwZW5ndXRyb25peC5kZTsN
Cj4gbGludXgtY2FuQHZnZXIua2VybmVsLm9yZw0KPiBDYzogd2dAZ3JhbmRlZ2dlci5jb207IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRsLWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54cC5jb20+
OyBNYXJ0aW4gSHVuZGViw7hsbCA8bWFydGluQGdlYW5peC5jb20+DQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggUkVQT1NUIDEvMl0gY2FuOiBmbGV4Y2FuOiBmaXggZGVhZGxvY2sgd2hlbiB1c2luZyBz
ZWxmDQo+IHdha2V1cA0KPiANCj4gDQo+IA0KPiBPbiAyMC8wOC8yMDE5IDEzLjU1LCBTZWFuIE55
ZWtqYWVyIHdyb3RlOg0KPiA+DQo+ID4gSSBoYXZlIGFkZGVkIHNvbWUgbW9yZSBkZWJ1Zywgc2Ft
ZSB0ZXN0IHNldHVwOg0KPiA+DQo+IGh0dHBzOi8vZXVyMDEuc2FmZWxpbmtzLnByb3RlY3Rpb24u
b3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRmdpc3QuZ2l0aA0KPiB1Yi5jb20lMkZza25z
ZWFuJTJGODEyMDg3MTRkZTIzYWEzNjM5ZDNlMzFkY2NiMmYzZTAmYW1wO2RhdGE9MDIlDQo+IDdD
MDElN0NxaWFuZ3FpbmcuemhhbmclNDBueHAuY29tJTdDMWRhZTdlYzRmMTkxNDYyYmU0M2QwOGQ3
MmJiYjENCj4gZTgyJTdDNjg2ZWExZDNiYzJiNGM2ZmE5MmNkOTljNWMzMDE2MzUlN0MwJTdDMCU3
QzYzNzAyNTk1NDk4OTUyDQo+IDk4MTMmYW1wO3NkYXRhPXUydDc0N0w0bWk4N2VqdWFMd2w0V1dK
TkpJRkl6dmxFZk5FJTJCU0xxMktiYyUzRCYNCj4gYW1wO3Jlc2VydmVkPTANCj4gPg0KPiA+IHJv
b3RAaXdnMjY6fiMgc3lzdGVtY3RsIHN1c3BlbmQNCj4gPg0KPiA+IC4uLg0KPiA+DQo+IGh0dHBz
Oi8vZXVyMDEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUy
RiUyRmdpc3QuZ2l0aA0KPiB1Yi5jb20lMkZza25zZWFuJTJGMmE3ODZmMTU0MzMwNTA1NmQ0ZGUw
M2QzODc4NzI0MDMmYW1wO2RhdGE9MDINCj4gJTdDMDElN0NxaWFuZ3FpbmcuemhhbmclNDBueHAu
Y29tJTdDMWRhZTdlYzRmMTkxNDYyYmU0M2QwOGQ3MmJiYg0KPiAxZTgyJTdDNjg2ZWExZDNiYzJi
NGM2ZmE5MmNkOTljNWMzMDE2MzUlN0MwJTdDMCU3QzYzNzAyNTk1NDk4OTUNCj4gMjk4MTMmYW1w
O3NkYXRhPVdiSTJlZUlsck5DNkhVU3ZpYWdhaUF5aTRZcEslMkIyYkMzYWw0WW45RVhaTSUzRA0K
PiAmYW1wO3Jlc2VydmVkPTANCj4gPg0KPiA+IC9TZWFuDQo+IA0KPiBBbnkgbHVjayByZXByb2R1
Y2luZyB0aGlzPw0KDQpIaSBTZWFuLA0KDQpJJ20gc29ycnkgdGhhdCBJIGNhbid0IGdldCB0aGUg
ZGVidWcgbG9nIGFzIHRoZSBzaXRlIGNhbid0IGJlIHJlYWNoZWQuIEFuZCBJIGNvbm5lY3QgdHdv
IGJvYXJkcyB0byBkbyB0ZXN0IGF0IG15IHNpZGUsIHRoaXMgaXNzdWUgY2FuJ3QgYmUgcmVwcm9k
dWNlZC4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IC9TZWFuDQo=
