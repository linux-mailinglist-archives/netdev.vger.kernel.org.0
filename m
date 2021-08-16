Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E573ECECC
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 08:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhHPGt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 02:49:26 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:55461
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233349AbhHPGtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 02:49:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBzPjDvPvWfsUf0tU/RcpOaka1ygTywR62ifugjYKbS0fpfC6DokrkBAd0mfWqowfJmmp5w7t9kf6UkbALRFkvCEXsH0aCKDcdGPc81x0OgdPh/GyC9FEjyvFh/A/gIYN1aqaPI1gsTh9NHTQiQWJV3msci+ClT9Efvbepn432NdvjNoZDyUOGp3Ggc1HkBBgayyQFmlEe2HSHuEHtmnJfGO8ctPg9IL+N/izaO8bKpc6FQe/EQnTz6FSuQ07Pa0Ak2H0qQt3dLfFauqa6OmP+WcDtYmTdIu7jIDbScsaSMMxn2avLAbpJzTYuRi6RdbhByX7viBvTfCgVb7NWvGtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gp+igXgaof9ql2Bbpgwj77b88wpjZepsDJjNvJhvSAY=;
 b=XABCeEp2FI2JVndCXVPMkdHCfPt72xUnflBdsrx9JCfNRxc8cgxy9zFqPw9gvECZdRXnFJoy626DSwLJQRE6jJlJV6hqs58mgYkHZzNcewCX+JvokLpl/XyP6wvMyRVOx+cHpDorqAe/PEj07cuY+m3ViIVN5kADmvLnofouKj9KEAgEs6xMDuy0brcmeHqGBu+HEq+bah0rDeBM4QZaOY6TG8k2IbuDJ0PELeHBDkYqiIBSirP5ILyFW6Yp/KpkBBJRaPJ7liPrtkhYY/HxRE8bU8VDjUJwT9QsctoAsmOo69R48XB0F2pws2PXtDdGjJiGa6JHLJerLktyCryLbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gp+igXgaof9ql2Bbpgwj77b88wpjZepsDJjNvJhvSAY=;
 b=K1Koi0LLRbt/meOPtZLGTHrZR6PJTLPw7MCMcbF/7SsR7n/itn02g4FB2nRgKvUulQjZMZXOFx4KLAdkFQIarOFkusO9Gjo+Fqlks7/wQxegG1jcHfeub0keqad7F5HCccos8W+Otpx/6oGBiKW1Sg2uWrvQ6PwXVKyNVwSUH2s=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2326.eurprd04.prod.outlook.com (2603:10a6:4:47::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Mon, 16 Aug
 2021 06:48:49 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 06:48:49 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Rob Herring <robh@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
 wakeup-irq" property
Thread-Topic: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
 wakeup-irq" property
Thread-Index: AQHXidrZaeAm3FGM8UWFBIfAWGHBc6tqnwvwgADpEgCAAHa+4IAA1qiAgADpUECABA30gIAD8mnQ
Date:   Mon, 16 Aug 2021 06:48:49 +0000
Message-ID: <DB8PR04MB679595375E757DEBD569C7EFE6FD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
 <20210805074615.29096-2-qiangqing.zhang@nxp.com>
 <2e1a14bf-2fa8-ed39-d133-807c4e14859c@gmail.com>
 <DB8PR04MB67950F6863A8FEE6745CBC68E6F69@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <498f3cee-8f37-2ab1-93c4-5472572ecc37@gmail.com>
 <DB8PR04MB6795DC35D0387637052E64A1E6F79@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YRKOGYwx1uVdsKoF@lunn.ch>
 <VI1PR04MB6800EE08F70CC3F0DD53C991E6F89@VI1PR04MB6800.eurprd04.prod.outlook.com>
 <YRa4g8cjGrQ979pQ@robh.at.kernel.org>
In-Reply-To: <YRa4g8cjGrQ979pQ@robh.at.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd710a05-0560-447b-bdfe-08d96081e712
x-ms-traffictypediagnostic: DB6PR0401MB2326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0401MB23264A586F3F5EBE9B4A84E7E6FD9@DB6PR0401MB2326.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qg/SlMkMH/LO7ru+DNf28U9+sbfOwZEBIVdsaSf4/1HCtx5uR+rvO/lUYyY4sMwNA104x8g54Mt7OeJ5293dfMaOy8ut0y7xZWhWUX353VHLFOs60kmf18FKuSLTKx8GuZyGNiRCMPaDGAXoRqSawCImdt7rADcmMGc3gpxRz2NeCBrnpHJ7lyvNPyxwypjgrtrVSkc2oPPG5YIWsLFzOJy30GWXVanCseLNS0y5pEb1+YUBoErsQMlHuVzdeYafHai1yRgHdjewON98CzgUmgX2BJ3+AMTZTU2lcTm6fh3/UFn5aHRU2dbg6jJpAZNRJtpBESi+cDOpKEBUmyfnVYM0+SW0tXpIWeHCCkcApvQ/ZuWq+m22YmAkNHP295H+QWBaTlWDkrESNevFseROyWgbLeRajKoBTZAELgUQJ3jG58pEr7MHvwbeoXdnLKa9ZEUHP902CD5Rtq+RuQDVm8Gm91KmwZBQDc3OdoIo5EdWlvpX4l0FBNTEcCewhDAGQhE+8TNkpzNTKVI7ZTwWFOL9XgNXtD1gXHwgRdCRPUOYN9nuSwy0EExWKwq+pRv+C91r1rf0hKs6JoWUt3cTiyYOpg7qKT9bsOqlNvc8qWauE72CpM6yUSlaKozUDAwqCdmUNA4Q9uqCUchPEtuYzjLfvnszZ9c+ZyUENv2KV0XSA/KOsrZ6AaCraXHGM2vNFPlzxM+edWrdKLhNEv/pPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(66446008)(66556008)(64756008)(478600001)(66476007)(9686003)(4326008)(5660300002)(55016002)(6916009)(7696005)(26005)(52536014)(83380400001)(316002)(66946007)(76116006)(86362001)(38070700005)(7416002)(122000001)(71200400001)(38100700002)(33656002)(8936002)(6506007)(8676002)(2906002)(53546011)(54906003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d004aVRRUUwwZFEzSlMyMkpNM3ZPREJXMURqZ2QzYlZ6UmYwTWRMQngreHNQ?=
 =?utf-8?B?SFN3ZWttczFOL2F5TTYwbGdHSnBDTFZDNE5vNjlTQW1OUWcwQllBT0ZmTEJN?=
 =?utf-8?B?K1pYNDVndU9lTkMrdDZrRDVUdG03eXhFbVByRFlSR1dlR1Y0T25rNDc2WjFw?=
 =?utf-8?B?M25zMXdBL2dTZWtNcHFFbVRnd0F5QTNyamM4c29oZ0dsdHN5ZWtibFhEQTVC?=
 =?utf-8?B?aTdrSkl6amlWK0NXRFg5UzN2M1lWVUlxUmdDdjFQYXBJUW9CcHlWQ3A0Vnk2?=
 =?utf-8?B?cE1aYk5KNnExK2g2Vnpja3lFRUNBWXBSNnZjTjh1WUI3blJaMEtHMDhVMGdV?=
 =?utf-8?B?ZElMM0MxUDYxSnFvZFFlSDdVSlVBZGkzVTB3V0UzTXNIV3VNMTY4clZjSDA5?=
 =?utf-8?B?OWU0Nnd4dWtEbE40eHRvN245bnh2TnkwajNJR2FROUJsQ2ZDOVNrT1NWWmdi?=
 =?utf-8?B?MUdKckFlSE15UGpEKzNxcUROTWZaSzJWSjZ4d0t1L3czVW1TWGkxdVZsRlF0?=
 =?utf-8?B?b0FZOW1WeHR0anFYcWM4YkhuZ0E2V1pPdy9zYWVrTW0ySVBubXhqOUMvakx1?=
 =?utf-8?B?OEQvazhPWDV6MS9vSm5abmNROW55MHRBUCtOaW8zVktKVFVsMmdJam5hc2ow?=
 =?utf-8?B?SU1TSDNPaHdqeEpjQVpJUU0xNTVEUE1VU0hpaUtYL3B2Nk5Ed2RzcG1VdVZG?=
 =?utf-8?B?ZWlWNXVDQTIvY0Z2blNVanJsVWFmSWJoaXlxQmt1M0Q1TmhMUndZSW93aFV3?=
 =?utf-8?B?WEtlNE1iY2hRYWtQYTAvNHFXSjdxeHVucldvVkdabVFvaEFUR2ZDbHEwQ21V?=
 =?utf-8?B?RTkyT1BZemxNMFRZS1dTbis2QWNEWWpqb3Vla1RENkdJSkh0OTVrU3NGWTRn?=
 =?utf-8?B?S1NOZm1iejBIWGlLMTkrQnlrditick45bldIK1RIbEJXR25CSTJVZ2R2WFJh?=
 =?utf-8?B?NmRhMklndzBIWFhzQnpiUVBVWEJ5Wmpmd1QyZFpOQTRzUTllZU1SWFFUZEFw?=
 =?utf-8?B?TnRnNDc2dU4wZWNZQ04xWVExSUFVb081RFZFR0VBREpnUTZ1UDVFMFRCRnBM?=
 =?utf-8?B?SnY2UlFVK0NqQ0s0dXF3ZHo3alBRTmJzZXpKbFV0SWZIeERzWjU5M0g1WXVF?=
 =?utf-8?B?OG9ZZGUyYklSQm9mY2krRFVzakRGeUc4bGdDaFdDaHNzQkZub0pWOVRmelB2?=
 =?utf-8?B?Mko4Ymp4VitvajUrZDBjRFRBMnFiWVkwemRPRkhucEN2Qkd2cGdBUjNmdWtz?=
 =?utf-8?B?MU1LT0MvdjZSdFhGcWFFQ0FneXM1ejJEck1kckYyL0xzczVHZ01JeG5JLzZE?=
 =?utf-8?B?S3QydjRhL2RCdk41VDA2T3JHd3E2cFdJL2JQUlFoaUN0aFp0S3V3SE5vOVpp?=
 =?utf-8?B?dmc5djJJTC90RThtN1NRQ0hHbllndjQ5WmpoNG9WM3ppeGhvWEo4RHhYUnlJ?=
 =?utf-8?B?K0xuNjJqYTVWTktwRU44NEhRSUNtbkVqSjFCcFd4TVdoNUx1N05acldhMDlG?=
 =?utf-8?B?WHpEN2xoaFNDQ2RTU3BnQXZLa1EzTGFoWjNLMDBOMEI3TXV4SGhjY3doK3hV?=
 =?utf-8?B?NS9iNTJ3MnplRnlzZHZHRDZUa1BPVkYyN3diOG1ORHV3WDdVOG51c1FiWFdh?=
 =?utf-8?B?bmxxcG81TzBqSGZ5ekVXQTNoRkYzaVFjS05hRDlLWEh4a2FZQ1psdWM4eVA2?=
 =?utf-8?B?RWl6RUNBWUh6YlRFSTM3cTVIZVZ5TE1SNWl0WjFJVm9ub2krMlVrMUFGaTN0?=
 =?utf-8?Q?jt6pFZCPnCiHB5WX94=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd710a05-0560-447b-bdfe-08d96081e712
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 06:48:49.1915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YadZi0BQtRUQbZ4HLRfRranP3Vmp9PlDaNcy/sLnkMnWC0l/dDIjSnDrhuwK4JL0Oe90/ZaJQBYNLHjnAg/FVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJvYiBIZXJyaW5nIDxyb2Jo
QGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjHlubQ45pyIMTTml6UgMjoyMw0KPiBUbzogSm9ha2lt
IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD47IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPjsNCj4g
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBzaGF3bmd1b0BrZXJuZWwub3Jn
Ow0KPiBzLmhhdWVyQHBlbmd1dHJvbml4LmRlOyBmZXN0ZXZhbUBnbWFpbC5jb207IGtlcm5lbEBw
ZW5ndXRyb25peC5kZTsNCj4gZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVh
ZC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzNdIGR0LWJpbmRpbmdzOiBu
ZXQ6IGZzbCwgZmVjOiBhZGQgImZzbCwNCj4gd2FrZXVwLWlycSIgcHJvcGVydHkNCj4gDQo+IE9u
IFdlZCwgQXVnIDExLCAyMDIxIGF0IDA3OjU3OjQ2QU0gKzAwMDAsIEpvYWtpbSBaaGFuZyB3cm90
ZToNCj4gPg0KPiA+IEhpIEFuZHJldywNCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdl
LS0tLS0NCj4gPiA+IEZyb206IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gPiA+IFNl
bnQ6IDIwMjHlubQ45pyIMTDml6UgMjI6MzMNCj4gPiA+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5n
cWluZy56aGFuZ0BueHAuY29tPg0KPiA+ID4gQ2M6IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVs
bGlAZ21haWwuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gPiA+IGt1YmFAa2VybmVsLm9y
Zzsgcm9iaCtkdEBrZXJuZWwub3JnOyBzaGF3bmd1b0BrZXJuZWwub3JnOw0KPiA+ID4gcy5oYXVl
ckBwZW5ndXRyb25peC5kZTsgZmVzdGV2YW1AZ21haWwuY29tOyBrZXJuZWxAcGVuZ3V0cm9uaXgu
ZGU7DQo+ID4gPiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsNCj4gPiA+IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnOw0KPiA+ID4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRl
YWQub3JnDQo+ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDEvM10gZHQtYmluZGlu
Z3M6IG5ldDogZnNsLCBmZWM6IGFkZA0KPiA+ID4gImZzbCwgd2FrZXVwLWlycSIgcHJvcGVydHkN
Cj4gPiA+DQo+ID4gPiA+ID4gPiAxKSBGRUMgY29udHJvbGxlciBoYXMgdXAgdG8gNCBpbnRlcnJ1
cHQgbGluZXMgYW5kIGFsbCBvZiB0aGVzZQ0KPiA+ID4gPiA+ID4gYXJlIHJvdXRlZCB0byBHSUMN
Cj4gPiA+ID4gPiBpbnRlcnJ1cHQgY29udHJvbGxlci4NCj4gPiA+ID4gPiA+IDIpIEZFQyBoYXMg
YSB3YWtldXAgaW50ZXJydXB0IHNpZ25hbCBhbmQgYWx3YXlzIGFyZSBtaXhlZCB3aXRoDQo+ID4g
PiA+ID4gPiBvdGhlcg0KPiA+ID4gPiA+IGludGVycnVwdCBzaWduYWxzLCBhbmQgdGhlbiBvdXRw
dXQgdG8gb25lIGludGVycnVwdCBsaW5lLg0KPiA+ID4gPiA+ID4gMykgRm9yIGxlZ2FjeSBTb0Nz
LCB3YWtldXAgaW50ZXJydXB0IGFyZSBtaXhlZCB0byBpbnQwIGxpbmUsDQo+ID4gPiA+ID4gPiBi
dXQgZm9yIGkuTVg4TQ0KPiA+ID4gPiA+IHNlcmlhbHMsIGFyZSBtaXhlZCB0byBpbnQyIGxpbmUu
DQo+ID4gPg0KPiA+ID4gU28geW91IG5lZWQgdG8ga25vdyB3aGljaCBvZiB0aGUgaW50ZXJydXB0
cyBsaXN0ZWQgaXMgdGhlIHdha2UgdXAgaW50ZXJydXB0Lg0KPiANCj4gV2UgYWxyZWFkeSBoYXZl
IGEgd2F5IHRvIGRvIHRoaXMgYnkgdXNpbmcgJ3dha2V1cCcgZm9yIHRoZSBpbnRlcnJ1cHQtbmFt
ZXMNCj4gZW50cnkuIEJ1dCBJIGd1ZXNzIHRoYXQgc2hpcCBoYXMgc2FpbGVkIGhlcmUgYW5kIHRo
YXQgd291bGRuJ3Qgd29yayB3ZWxsIGlmIG5vdA0KPiBqdXN0IGEgd2FrZXVwIHNvdXJjZSAodGhv
dWdoIHlvdSBjb3VsZCByZXBlYXQgYW4gaW50ZXJydXB0IGxpbmUgdGhhdCdzIHRoZQ0KPiB3YWtl
dXAgc291cmNlKS4NCg0KWWVzLCBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgaXQncyBhIGNvbW1vbiBz
b2x1dGlvbiwgc3VjaCBhczoNCmludGVycnVwdHMgPSA8R0lDX1NQSSAxMTggSVJRX1RZUEVfTEVW
RUxfSElHSD4sDQoJCTxHSUNfU1BJIDExOSBJUlFfVFlQRV9MRVZFTF9ISUdIPiwNCgkJPEdJQ19T
UEkgMTIwIElSUV9UWVBFX0xFVkVMX0hJR0g+LA0KCQk8R0lDX1NQSSAxMjEgSVJRX1RZUEVfTEVW
RUxfSElHSD4sDQoJCTxHSUNfU1BJIDEyMCBJUlFfVFlQRV9MRVZFTF9ISUdIPiwNCmludGVycnVw
dC1uYW1lcyA9ICJpbnQwIiwgImludDEiLCAiaW50MiIsICJwcHMiLCAid2FrZXVwIjsNCg0KV2hl
cmUgd2UgcmVwZWF0IGludGVycnVwdCAxMjAgZm9yIGJvdGggImludDIiIGFuZCAid2FrZXVwIiwg
ZG9lcyB5b3UgbWVhbiB0aGlzPw0KDQo+ID4gPg0KPiA+ID4gSSBjYW4gc2VlIGEgZmV3IHdheXMg
dG8gZG8gdGhpczoNCj4gPiA+DQo+ID4gPiBUaGUgRkVDIGRyaXZlciBhbHJlYWR5IGhhcyBxdWly
a3MuIEFkZCBhIHF1aXJrIHRvIGZlY19pbXg4bXFfaW5mbw0KPiA+ID4gYW5kIGZlY19pbXg4cW1f
aW5mbyB0byBpbmRpY2F0ZSB0aGVzZSBzaG91bGQgdXNlIGludDIuDQo+IA0KPiBCaW5nbyENCj4g
DQo+IE5vdGUgdGhhdCBpZiB0aGUgZGV2aWNlIGlzIHdha2V1cCBjYXBhYmxlLCBpdCBzaG91bGQg
aGF2ZSBhICd3YWtldXAtc291cmNlJw0KPiBwcm9wZXJ0eSBpbiB0aGlzIGNhc2UuDQo+IA0KPiA+
ID4NCj4gPiA+IG9yDQo+ID4gPg0KPiA+ID4gRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRp
bmdzL2ludGVycnVwdC1jb250cm9sbGVyL2ludGVycnVwdHMudHgNCj4gPiA+IHQNCj4gPiA+DQo+
ID4gPiAgIGIpIHR3byBjZWxscw0KPiA+ID4gICAtLS0tLS0tLS0tLS0NCj4gPiA+ICAgVGhlICNp
bnRlcnJ1cHQtY2VsbHMgcHJvcGVydHkgaXMgc2V0IHRvIDIgYW5kIHRoZSBmaXJzdCBjZWxsIGRl
ZmluZXMgdGhlDQo+ID4gPiAgIGluZGV4IG9mIHRoZSBpbnRlcnJ1cHQgd2l0aGluIHRoZSBjb250
cm9sbGVyLCB3aGlsZSB0aGUgc2Vjb25kIGNlbGwgaXMgdXNlZA0KPiA+ID4gICB0byBzcGVjaWZ5
IGFueSBvZiB0aGUgZm9sbG93aW5nIGZsYWdzOg0KPiA+ID4gICAgIC0gYml0c1szOjBdIHRyaWdn
ZXIgdHlwZSBhbmQgbGV2ZWwgZmxhZ3MNCj4gPiA+ICAgICAgICAgMSA9IGxvdy10by1oaWdoIGVk
Z2UgdHJpZ2dlcmVkDQo+ID4gPiAgICAgICAgIDIgPSBoaWdoLXRvLWxvdyBlZGdlIHRyaWdnZXJl
ZA0KPiA+ID4gICAgICAgICA0ID0gYWN0aXZlIGhpZ2ggbGV2ZWwtc2Vuc2l0aXZlDQo+ID4gPiAg
ICAgICAgIDggPSBhY3RpdmUgbG93IGxldmVsLXNlbnNpdGl2ZQ0KPiA+ID4NCj4gPiA+IFlvdSBj
b3VsZCBhZGQNCj4gPiA+DQo+ID4gPiAgICAgICAgMTggPSB3YWtldXAgc291cmNlDQo+IA0KPiBJ
J2QgYmUgb2theSB3aXRoIHRoaXMgKHRob3VnaCBpdCBzaG91bGQgYmUgYSBwb3dlciBvZiAyIG51
bWJlcikuDQo+IA0KPiA+ID4NCj4gPiA+IGFuZCBleHRlbmQgdG8gY29yZSB0byBlaXRoZXIgZG8g
YWxsIHRoZSB3b3JrIGZvciB5b3UsIG9yIHRlbGwgeW91DQo+ID4gPiB0aGlzIGludGVycnVwdCBp
cyBmbGFnZ2VkIGFzIGJlaW5nIGEgd2FrZXVwIHNvdXJjZS4gVGhpcyBzb2x1dGlvbg0KPiA+ID4g
aGFzIHRoZSBhZHZhbnRhZ2Ugb2YgaXQgc2hvdWxkIGJlIHVzYWJsZSBpbiBvdGhlciBkcml2ZXJz
Lg0KPiANCj4gQW5vdGhlciBvcHRpb24gaXMgY291bGRuJ3QgeW91IGp1c3QgZW5hYmxlIGFsbCB0
aGUgaW50ZXJydXB0cyBhcyB3YWtldXAgc291cmNlcz8NCj4gUHJlc3VtYWJseSwgb25seSBvbmUg
b2YgdGhlbSB3b3VsZCB0cmlnZ2VyIGEgd2FrZXVwLg0KDQpZZXMsIGFub3RoZXIgc29sdXRpb24s
IEkgdGhvdWdodCBpdCBidXQgbm90IGltcGxlbWVudGVkIGl0IGFzIHdlIGhhZCBiZXR0ZXIgbGV0
IHVzZXJzIGtub3cgd2hpY2gNCmludGVycnVwdCBpcyB3YWtldXAgY2FwYWJsZS4NCg0KQmVzdCBS
ZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+ID4NCj4gPiBUaGFua3MgYSBsb3QgZm9yIHlvdXIgY29t
bWVudHMgZmlyc3QhDQo+ID4NCj4gPiBJIGp1c3QgbG9vayBpbnRvIHRoZSBpcnEgY29kZSwgaWYg
d2UgZXh0ZW5kIGJpdFs1XSB0byBjYXJyeSB3YWtldXANCj4gPiBpbmZvICggZHVlIHRvIGJpdFs0
XSBpcyB1c2VkIGZvciBJUlFfVFlQRV9QUk9CRSksIHRoZW4gY29uZmlndXJlIGl0IGluDQo+ID4g
dGhlIFRZUEUgZmllbGQgb2YgJ2ludGVycnVwdHMnIHByb3BlcnR5LCBzbyB0aGF0IGludGVycnVw
dCBjb250cm9sbGVyIHdvdWxkIGtub3cNCj4gd2hpY2ggaW50ZXJydXB0IGlzIHdha2V1cCBjYXBh
YmxlLg0KPiA+IEkgdGhpbmsgdGhlcmUgaXMgbm8gbXVjaCB3b3JrIGNvcmUgd291bGQgZG8sIG1h
eSBqdXN0IHNldCB0aGlzDQo+ID4gaW50ZXJydXB0IHdha3VwIGNhcGFibGUuIEFub3RoZXIgZnVu
Y3Rpb25hbGl0eSBpcyBkcml2ZXIgc2lkZSBnZXQgdGhpcyBpbmZvIHRvDQo+IGlkZW50aWZ5IHdo
aWNoIG1peGVkIGludGVycnVwdCBoYXMgd2FrZXVwIGNhcGFiaWxpdHksIHdlIGNhbiBleHBvcnQg
c3ltYm9sDQo+IGZyb20ga2VybmVsL2lycS9pcnFkb21haW4uYy4NCj4gPg0KPiA+IFRoZSBpbnRl
bnRpb24gaXMgdG8gbGV0IGRyaXZlciBrbm93IHdoaWNoIGludGVycnVwdCBpcyB3YWtldXAgY2Fw
YWJsZSwNCj4gPiBJIHdvdWxkIGNob29zZSB0byBwcm92aWRlciB0aGlzIGluIHNwZWNpZmljIGRy
aXZlciwgaW5zdGVhZCBvZiBpbnRlcnJ1cHQNCj4gY29udHJvbGxlciwgaXQgc2VlbXMgdG8gbWUg
dGhhdCBvdGhlcnMgbWF5IGFsbCBjaG9vc2UgdGhpcyBzb2x1dGlvbiBmb3Igd2FrZXVwDQo+IG1p
eGVkIGludGVycnVwdC4NCj4gPg0KPiA+IFNvIEkgd291bGQgcHJlZmVyIHNvbHV0aW9uIDEsIGl0
J3MgZWFzaWVyIGFuZCB1bmRlci1jb250cm9sLiBJIGNhbiBoYXZlIGEgdHJ5IGlmDQo+IHlvdSBz
dHJvbmdseSByZWNvbW1lbmQgc29sdXRpb24gMi4NCj4gPg0KPiA+IEJlc3QgUmVnYXJkcywNCj4g
PiBKb2FraW0gWmhhbmcNCj4gPiA+IAkgIEFuZHJldw0K
