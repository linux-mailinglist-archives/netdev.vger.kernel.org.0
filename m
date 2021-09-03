Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56413FFAAE
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 08:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347144AbhICGwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 02:52:22 -0400
Received: from mail-eopbgr60068.outbound.protection.outlook.com ([40.107.6.68]:64758
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234729AbhICGwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 02:52:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WprmheKek/d69ynEHtz3Q0h9PL1tBfRS3LFKi4ENklTqd2exjlE/6DzLip6yezvZIVlE7SDjKUuvsazCWogpOaNleYxzMYZL+qN+ZK3xJ4r7hd+x2/oxJ14DPK1MWxBQvX8i9zYzQsN3abICzz1nNwjXD8m5Z5Viduk/7MVw+sJah33LMZH2cyEQM+xo6p7OZdgae3XFDrKPdnYQEBvZqbUTxoNM52QTFcKJSnJSy7/B2bknlBO6p4RWLkIloYvwt7M+dYhng99g1co+OAtszQBmWptreSZJx7PnBrOcnO24YVL+ydyCQwVw15qEocTr9dtobmqU0VPkaxAnOpVdlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vahYwe3eUHTT4G4gam49M40kyaAsbw9rs/s8ds/Jf44=;
 b=OWlgsd3Xy+E3/9btFo4b//XCEr5xgU3fUaC4sZ7Vdd0n4ZVj6J/utYwl3ijmYGt9N/EAPLgntbiFN43J+NXTiJIzSOYqZMCvml+YawyWGkH5AJwKi67hiEHBFelDB0X+4wFA1rqx/yQX4bAN6JdjoFejnvVhLbIYIMwkWZ68r7/cXHhmQJmQDoHZkEEuMSGIy5cvTPQDDjkUI1Oxr8B/hI8lD9XZPcb647ZlHebrPNqIrZisT2HNBBv4pE2qCqVDbsDfPWp2PC5VatxbRd7qJCVv9yPget7oFoBNxRxSZjLpN+LBDiVCDki6skXkgsdTdAqNdz/ieNRA4PetS8cdZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vahYwe3eUHTT4G4gam49M40kyaAsbw9rs/s8ds/Jf44=;
 b=LeM9kKbij3CM2Enkz9jBE97EUj2fGTiUXxn7YmG4vbCCCf27flttfafn79PeHGIZcBt3/KazzSkM4apODfauxC1OTCqE/jtt8KQh7V1ZW3cOAUnAp8Ah7m1cjqmnZwavqYy1f6HKHv198aW7JCXuUnFW2oN4EQVlMCNuaMLPGag=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7480.eurprd04.prod.outlook.com (2603:10a6:10:1a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Fri, 3 Sep
 2021 06:51:09 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f%9]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 06:51:09 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Thread-Topic: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Thread-Index: AQHXnxAXiWCMYvQkY0qCXzBIAPLPn6uO53WAgAAPWNCAAAsFgIAACEPggAAhioCAAQx9sIAAM98AgAAW9HCAAA9qgIAAAa+AgAAYrQCAAOF04A==
Date:   Fri, 3 Sep 2021 06:51:09 +0000
Message-ID: <DB8PR04MB6795C36B8211EE1A1C0280D9E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210901092149.fmap4ac7jxf754ao@skbuf>
 <DB8PR04MB6795CCAE06AA7CEB5CCEC521E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210901105611.y27yymlyi5e4hys5@skbuf>
 <DB8PR04MB67956C22F601DA8B7DC147D5E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210901132547.GB22278@shell.armlinux.org.uk>
 <DB8PR04MB6795BB2A13AED5F6E56D08A0E6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210902083224.GC22278@shell.armlinux.org.uk>
 <DB8PR04MB67954F4650408025E6D4EE2AE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210902104943.GD22278@shell.armlinux.org.uk>
 <DB8PR04MB6795C37D718096E7CA1AA72DE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YTDCZN/WKlv9BsNG@lunn.ch>
In-Reply-To: <YTDCZN/WKlv9BsNG@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48d414dd-8222-4ebb-fed9-08d96ea73649
x-ms-traffictypediagnostic: DBAPR04MB7480:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB74808C2C8FD6FEA60158889FE6CF9@DBAPR04MB7480.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pdvi+NE8J0p55xJjq20JAip+Dh2vl2D9QZuRR2qGPBOrOoQtDWQyiGYnxkjIZZ2IQSY8lpIuLBao2USdFJudWxtM3rd+/vjXdaw8EjDZZXMXrSdiquQNzM7ouhVYb1O2skEO/Pj9Ts49LDYaDmxRNRb54MlBAPKlZj05iQoxecwy1HnIKJ7YNWHbLAT5L4Jft7DUvISj3BK5u1RPoyOB0wWbufUPQvpbLlddUwpRGhQ2JVlC8unPYNsqvQgDpU0JV1/nyo08yZLYVw80K12ZDo575QTYuqlsANo8P8o2rBlE8op3CLMVHn+ys2QERfDtkqaV71Gr7bI0jYxlsMcbGb/lUVuAUTopabYzq02VaXZaLIzI5ZOTczbbNBWzALw2tVM+a7DYoaOoeIc6f37ueVMNvPoxa4UWZYQn99IUU3xdm5lHkTSSD9gwwvbrj50SqPzSBTNwEfxVfgEmD86ZGE0jCJGxoy1LVIAOeuAeq9xdm1Qep9yrzq6ZjzrQMCdTcUlE8Kc89xGBPQyE65V2MmTcSrw2n2uW1qut6KJol+4FRF5eUTBHQ6Fy2MqV9+pP9qtkW3gbhlUvHst1tIY6EM7UozyNQMqirUeTqzgVImmb9D5A9trN+m/pvRZjG/6uStbsxAwcIolgB4bftAnidJleDMYRZrOjfXto5dz5iCIOB9+WertRPw2h8aFtm89UYOB55J3U2CCOtRrNQA5Iu1PLAjQKQRCpgUanc9pafYI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(122000001)(38100700002)(33656002)(38070700005)(2906002)(53546011)(66946007)(76116006)(86362001)(83380400001)(54906003)(110136005)(71200400001)(316002)(5660300002)(26005)(52536014)(66446008)(6506007)(186003)(478600001)(8936002)(8676002)(4326008)(66556008)(7416002)(66476007)(7696005)(55016002)(9686003)(64756008)(309714004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?T3Z6YTkvdHliYnRTNWNSMExMOWp5dE5RKzUrTGtYRkVGTUZOY3FZNjBCeitQ?=
 =?gb2312?B?a2prM05sZlo1dWViOXBKOGJHRExLN0phNkNVMUpDcnN3ajdVYmtHUzZHWEJQ?=
 =?gb2312?B?RllHVndQdWFsbVpLQ3MxSGNmajJacXZHVG9qRi91S25ZWUhzS3hidE1MbzdJ?=
 =?gb2312?B?cVNvYUpEc1JybExTQ2gyT1dwd2FCU25qZzVrMTJaU3JIeG80WEpXcm1MTmo0?=
 =?gb2312?B?SUZ5N0hvT1pNYVNRVHNEdm45MUFrZHgyR1NwK2FGVS9sNlpFWnA2cFJEb2w3?=
 =?gb2312?B?Yzk0eHhjazEyc0swQ0xWNnZ2dWsyY3Vsa252MWxpa3hwRnFpeFVVNXh1QS9w?=
 =?gb2312?B?YU93dldYcVJRRHJ0bmtYbUFmUkpMa0tIdjdBNElKUDRCOEl5SE5QYjRNdlpo?=
 =?gb2312?B?QUM0aTlWeGJOTnhpT3Q3RHplRTA0RkdYY29UMkpXVmN4dWVkRUlZSWVrdGZi?=
 =?gb2312?B?WlVXOG5qNzU0dU1MVWxtNm9abUVXcGVrM1RPVUUwblpOZERXT3hVcEpoKzJO?=
 =?gb2312?B?VVFrMWxiTHgxYWltZ1ZOMWd3TjRWajNBVk1kNGY3bzhta3ZRNEdMK01kSGY1?=
 =?gb2312?B?Wnk3cTlNd29tNzFaZDU1Mk5ESlh3K2Mxbzk0U2Zldm1sbDB3OTk0M1F1VENF?=
 =?gb2312?B?UHY3Ylhqazd2ci9RVDkyTU5PbDVZTFZVemZXUkIzRk5rTWprems5MFdBamMr?=
 =?gb2312?B?M2RRTlFzbWEyc2taMzdHc3BBU0RaVjZ2aEpieSt5KzE2RUNoTEg1OU1XcnBx?=
 =?gb2312?B?YzZRU0ZZVkFsaFNQRWltS29wUTRQMG5Da21oN0ZCVm9ZNndpcWxpVXdJdDBq?=
 =?gb2312?B?NjU4TmZtTWtkakt3eHJyMk5RY0wwb0g5Ym1wbTVSMHFlMTdQOFdQT3J5VDk1?=
 =?gb2312?B?dFVRdHdFd1piWHVKdlE5Wm5BTUY1b1RaMkhINzZtZFRiRDZPS1NvTXVDVlhy?=
 =?gb2312?B?Mkcrb1cvOTlaNHlNbW5xelNFME5FbWQzYmkwaCt1Tmw2KzkxZlR5TnE1bnMw?=
 =?gb2312?B?ZGFMMExGTk1jNTlIbUo2akdxWndXUjZFOWY0TTVySFVDQVJ2OGIzTTMzdDA2?=
 =?gb2312?B?QTVOc0ZKUHhnK2hKT2FwNllES2lRaEV2OEFoUjA3TDFCTUtRNlYxWTZyYTBk?=
 =?gb2312?B?Y1ZXOVpJMXNnM2dqTVc5QmJpd21URDZySk5ZL01kSm01RVlCZ2FrNGFLV1Zr?=
 =?gb2312?B?RHBuMXdTNnNzN2pKK3ZZb2crUXVwSWhvWWZOWXROZEpXQm9NWmZUKzlEVzg5?=
 =?gb2312?B?TUtYWEdZWVJiYlBqcktsdGJKb1NLREQvQnU2RWJWMEtrWEpSN3BRZ2dheHVs?=
 =?gb2312?B?NFpHQ2JnNXA0YTFOSFBGU1FJdDlPTnQvdVJiN1R6dVRyVHV0eGhMRE5Fb0da?=
 =?gb2312?B?UkdzczYrUHJSMnhGWXp3WTNlMzc3U1p2V1ZaZWtQTW5LbU5pSDV4RUlMUWNv?=
 =?gb2312?B?WWl3amVaYWd3UE1wYUE5YWN0WFU5cEZJSDAzdTRtNzg0MVBpdWluSkdSZ0VB?=
 =?gb2312?B?L3Y1OHF6b1lhUURyZGdFVFpHRnBnbFJQT1FwdFZFUGszL2lVUzBUd0FSVmFY?=
 =?gb2312?B?WjJUeTVzWERPVGFFVGZVT0l6LzhncU9wMW5JTTJCTTVWajYzVDVOczRwRVBX?=
 =?gb2312?B?SkxpalhsZTcrVHROVStkYU9mRGlQTk1BeDcydStic2pYbDBpRkxoZmxTRXg2?=
 =?gb2312?B?eG5xSGgzN0E2Y2RhMWcrTWpLVEx3dDJHK0o5MGx5MmczL2lHVEQ5QjlZUzh1?=
 =?gb2312?Q?MiYfJtBY8nHMz8ZNiE7arb55FviP+2k3f/nSmQw?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d414dd-8222-4ebb-fed9-08d96ea73649
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2021 06:51:09.8730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Fvuc8xIY8PP2f1YVkCVCmXloJE7m9QjT8CnB1JSardJ5gyVNPBKxkV3omzGDry2hwBS1f6u0rhy4Bc02WFfTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4NCj4gU2VudDogMjAyMcTqOdTCMsjVIDIwOjI0DQo+IFRvOiBKb2FraW0gWmhh
bmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogUnVzc2VsbCBLaW5nIDxsaW51eEBh
cm1saW51eC5vcmcudWs+OyBWbGFkaW1pciBPbHRlYW4NCj4gPG9sdGVhbnZAZ21haWwuY29tPjsg
cGVwcGUuY2F2YWxsYXJvQHN0LmNvbTsNCj4gYWxleGFuZHJlLnRvcmd1ZUBmb3NzLnN0LmNvbTsg
am9hYnJldUBzeW5vcHN5cy5jb207DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVs
Lm9yZzsgbWNvcXVlbGluLnN0bTMyQGdtYWlsLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgZi5mYWluZWxsaUBnbWFpbC5jb207IGhrYWxsd2VpdDFAZ21haWwuY29tOw0KPiBkbC1saW51
eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBuZXQ6IHN0
bW1hYzogZml4IE1BQyBub3Qgd29ya2luZyB3aGVuIHN5c3RlbSByZXN1bWUNCj4gYmFjayB3aXRo
IFdvTCBlbmFibGVkDQo+IA0KPiA+IEVtbSwgQGFuZHJld0BsdW5uLmNoLCBBbmRyZXcgaXMgbXVj
aCBmYW1pbGlhciB3aXRoIEZFQywgYW5kIFBIWQ0KPiA+IG1haW50YWluZXJzLCBDb3VsZCB5b3Ug
cGxlYXNlIGhlbHAgcHV0IGluc2lnaHRzIGhlcmUgaWYgcG9zc2libGU/DQo+IA0KPiBBbGwgdGhl
IGJvYXJkcyBpIGhhdmUgZWl0aGVyIGhhdmUgYW4gRXRoZXJuZXQgU3dpdGNoIGNvbm5lY3RlZCB0
byB0aGUgTUFDLCBvcg0KPiBhIE1pY3JlbCBQSFkuIE5vbmUgYXJlIHNldHVwIGZvciBXb0wsIHNp
bmNlIGl0IGlzIG5vdCB1c2VkIGluIHRoZSB1c2UgY2FzZSBvZg0KPiB0aGVzZSBib2FyZHMuDQo+
IA0KPiBJIHRoaW5rIHlvdSBuZWVkIHRvIHNjYXR0ZXIgc29tZSBwcmludGsoKSBpbiB2YXJpb3Vz
IHBsYWNlcyB0byBjb25maXJtIHdoYXQgaXMNCj4gZ29pbmcgb24uIFdoZXJlIGlzIHRoZSBXb0wg
aW1wbGVtZW50ZWQ6IE1BQyBvciBQSFksIHdoYXQgaXMgc3VzcGVuZGVkIG9yDQo+IG5vdCwgZXRj
Lg0KDQpUaGFua3MgQW5kcmV3LCBSdXNzZWxsLA0KDQpJIGNvbmZpcm1lZCBGRUMgaXMgTUFDLWJh
c2VkIFdvTCwgYW5kIFBIWSBpcyBhY3RpdmUgd2hlbiBzeXN0ZW0gc3VzcGVuZGVkIGlmIE1BQy1i
YXNlZCBXb0wgaXMgYWN0aXZlLg0KSSBzY2F0dGVyIHByaW50aygpIGluIGJvdGggcGh5X2Rldmlj
ZS5jIGFuZCByZWFsdGVrLmMgcGh5IGRyaXZlciB0byBkZWJ1ZyB0aGlzIGZvciBib3RoIFdvTCBh
Y3RpdmUgYW5kIGluYWN0aXZlIGNhc2UuDQoNCldoZW4gTUFDLWJhc2VkIFdvTCBpcyBhY3RpdmUs
IHBoeV9zdXNwZW5kKCkgaXMgdGhlIGxhc3QgcG9pbnQgdG8gYWN0dWFsbHkgc3VzcGVuZCB0aGUg
UEhZLCB5b3UgY2FuIHNlZSB0aGF0LA0KCXBoeV9ldGh0b29sX2dldF93b2wocGh5ZGV2LCAmd29s
KTsNCglpZiAod29sLndvbG9wdHMgfHwgKG5ldGRldiAmJiBuZXRkZXYtPndvbF9lbmFibGVkKSkN
CgkJcmV0dXJuIC1FQlVTWTsNCg0KSGVyZSwgbmV0ZGV2IGlzIHRydWUgYW5kIG5ldGRldi0+d29s
X2VuYWJsZWQgaXMgdHVyZSAobmV0L2V0aHRvb2wvd29sLmM6IGV0aG5sX3NldF93b2woKSAtPiBk
ZXYtPndvbF9lbmFibGVkID0gISF3b2wud29sb3B0czspDQpTbyB0aGF0IHBoeWRldi0+c3VzcGVu
ZCgpIHdvdWxkIG5vdCBiZSBjYWxsZWQsIFBIWSBpcyBhY3RpdmUgYWZ0ZXIgc3lzdGVtIHN1c3Bl
bmRlZC4gUEhZIGNhbiByZWNlaXZlIHBhY2tldHMgYW5kIHBhc3MgdG8gTUFDLA0KTUFDIGlzIHJl
c3BvbnNpYmxlIGZvciBkZXRlY3RpbmcgbWFnaWMgcGFja2V0cyB0aGVuIGdlbmVyYXRlIGEgd2Fr
ZXVwIGludGVycnVwdC4gU28gYWxsIGlzIGZpbmUgZm9yIEZFQywgYW5kIHRoZSBiZWhhdmlvciBp
cyBjbGVhci4NCg0KRm9yIFNUTU1BQywgd2hlbiBNQUMtYmFzZWQgV29MIGlzIGFjdGl2ZSwgYWNj
b3JkaW5nIHRvIHRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uLCBvbmx5IGNhbGwgcGh5bGlua19t
YWNfY2hhbmdlKCk9ZmFsc2UsDQpQSFkgd291bGQgYmUgYWN0aXZlLCBzbyBQSFkgY2FuIHJlY2Vp
dmUgcGFja2V0cyB0aGVuIHBhc3MgdG8gTUFDLCBNQUMgaWdub3JlIHBhY2tldHMgZXhjZXB0IG1h
Z2ljIHBhY2tldHMuIFN5c3RlbSBjYW4gYmUNCndha2VkIHVwIHN1Y2Nlc3NmdWxseS4NCg0KVGhl
IGlzc3VlIGlzIHRoYXQgcGh5bGlua19tYWNfY2hhbmdlKCk9ZmFsc2Ugb25seSBub3RpZnkgYSBw
aHlsaW5rIG9mIGEgY2hhbmdlIGluIE1BQyBzdGF0ZSwgYXMgd2UgYW5hbHl6ZWQgYmVmb3JlLCBQ
SFkgd291bGQgbGluayB1cCBhZ2Fpbg0KYmVmb3JlIHN5c3RlbSBzdXNwZW5kZWQsIHdoaWNoIGxl
YWQgdG8gLm1hY19saW5rX3VwIGNhbid0IGJlIGNhbGxlZCB3aGVuIHN5c3RlbSByZXN1bWUgYmFj
ay4gVW5mb3J0dW5hdGVseSwgYWxsIE1BQyBjb25maWd1cmF0aW9ucw0KYXJlIGluIHN0bW1hY19t
YWNfbGlua191cCgpLCBhcyBhIHJlc3VsdCwgTUFDIGhhcyBub3QgYmVlbiBpbml0aWFsaXplZCBj
b3JyZWN0bHkgd2hlbiBzeXN0ZW0gcmVzdW1lIGJhY2ssIHNvIHRoYXQgaXQgY2FuJ3Qgd29yayBh
bnkgbG9uZ2VyLg0KICANCkludGVuZCB0byBmaXggdGhpcyBvYnZpb3VzIGJyZWFrYWdlLCBJIGRp
ZCBzb21lIHdvcms6DQpSZW1vdmluZyBwaHlsaW5rX21hY19jaGFuZ2UoKSAoUnVzc2VsbCBzYWlk
IGl0J3MgZm9yIE1MT19BTl9JTkJBTkQsIGJ1dCB3ZSBoYXZlIGEgTUxPX0FOX1BIWSkgZnJvbSBz
dXNwZW5kL3Jlc3VtZSBwYXRoLA0KdGhlbiBhZGRpbmcgcGh5bGlua19zdG9wKCkgaW4gc3VzcGVu
ZCwgcGh5bGlua19zdGFydCgpIGluIHJlc3VtZSgpIGFsc28gZm9yIFdvTCBhY3RpdmUgcGF0aC4g
SSBmb3VuZCByZW1vdGUgbWFnaWMgcGFja2V0cyBjYW4ndCB3YWtlIHVwIHRoZQ0Kc3lzdGVtLCBJ
IGZpcnN0bHkgc3VzcGVjdCBQSFkgbWF5IGJlIHN1c3BlbmRlZC4gQWZ0ZXIgZnVydGhlciBkZWJ1
ZywgSSBjb25maXJtIHRoYXQgUEhZIGlzIGFjdGl2ZSwgYW5kIHN0bW1hY19wbXQoKSBpcyBjb3Jy
ZWN0bHkgY29uZmlndXJlZC4NClNvIHRoZSBpc3N1ZSBzZWVtcyB3ZSBpbnZva2UgcGh5bGlua19z
dG9wKCkgZm9yIFdvTCBhY3RpdmUgcGF0Y2gsIGNvbnRpbnVpbmcuLi4sIFJlbW92aW5nIHBoeWxp
bmtfbWFjX2NoYW5nZSgpIGFuZCBwaHlsaW5rX3N0b3AoKSBpbiBzdXNwZW5kLCANCnRoZSBzeXN0
ZW0gY2FuIGJlIHdha2VkIHVwIHZpYSBtYWdpYyBwYWNrZXRzLg0KDQpUaGUgY29uY2x1c2lvbiBp
cyB0aGF0LCBhcyBsb25nIGFzIHdlIGNhbGwgcGh5bGlua19zdG9wKCkgZm9yIFdvTCBhY3RpdmUg
aW4gc3VzcGVuZCgpLCB0aGVuIHN5c3RlbSBjYW4ndCBiZSB3YWtlZCB1cCBhbnkgbG9uZ2VyLCBh
bmQgdGhlIFBIWQ0Kc2l0dWF0aW9uIGlzIGFjdGl2ZS4gVGhpcyBsZXQgbWUgcmVjYWxsIHdoYXQg
UnVzc2VsbCBtZW50aW9uZWQgaW4gdGhpcyB0aHJlYWQsIGlmIHdlIG5lZWQgYnJpbmcgTUFDIGxp
bmsgdXAgd2l0aCBwaHlsaW5rIGZyYW1ld29yayB0byBsZXQgTUFDDQpjYW4gc2VlIHRyYWZmaWMg
ZnJvbSBQSFkgd2hlbiBNQUMtYmFzZWQgV29MIGlzIGFjdGl2ZT8gDQoNCk5vdywgSSBkb24ndCBr
bm93IHdoZXJlIEkgY2FuIGZ1cnRoZXIgZGlnIGludG8gdGhpcyBpc3N1ZSwgaWYgeW91IGhhdmUg
YW55IGFkdmljZSBwbGVhc2Ugc2hhcmUgd2l0aCBtZSAsIHRoYW5rcyBpbiBhZHZhbmNlLg0KDQpC
ZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg==
