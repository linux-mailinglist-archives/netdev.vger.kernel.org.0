Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1737B2F25A5
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbhALBm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 20:42:27 -0500
Received: from mail-eopbgr50088.outbound.protection.outlook.com ([40.107.5.88]:1351
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726837AbhALBm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 20:42:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BO1cGbrfK8k9YgVVWoxdAmS6fBa3M7HoKEs3fKFascyM2oStuo6W1xpzzdtZPSihlT1KFGgOl6BuKGPrn5EyGOYiXrfW2a0cHDLH/YqbSQMbNOdoC3Qx2Zm1owppmF0V8k9dL/AT7O038g2kqcE+1EdxFtiF0rlBI3RaeeNHPVPJ8r/m1cPQnbsJakvn0LW0K2V89VXDZJ2MKDgpuKoUXasJMZW+uDT3y1TlodWf7EoZlYKvPbGaT8cQ7zzI9mgGGnur9IYV/ZF/VTsfGIzNesMmfjWv9xpiaVDSzkuNo8TeHdAJQD+7oYwCGkK4VMoO3rUJmBLy7TLfCf8iJYOD1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HBFYOYN4+kkNPN+osijaFMPlDD8ztKU6P51io+s3N8=;
 b=FqPsVA175pC2+blhw587sXSVotsXerfTW0Rc+H7e0FGDSt1R8OYI7K6YWLhABdPC8moqpwnLo/DIyV7Cszpjc6wkwRSe5vywiPitI+25ARxBoebaC4PVmIF7DOF6dj3dL2pijT4HiPTPrmSBMIBQ1EK8468sd8wxd/kvZsbyUeUpyVOux+rHR45ksPkfWHDwJhpyTDTVjf+RSreNpkc0V7pV8qFo7r+aFbz2E7ocGZmv6uMRFscony/sm1N32AjBu5lwXwSbLxiK5W+aQ9gASwKdsAPBs3EGB7t3xlVnsWwambmC9dflKYD67MxV3DWppDOpY1LzCY/12uaOpcsrng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HBFYOYN4+kkNPN+osijaFMPlDD8ztKU6P51io+s3N8=;
 b=AD1Rzhp3mq009sIo8sDrHW2/+RXppnPLscYWTfbRnU1TP1wcHkD/v9nQGdZ+dMwlJUA194EGkeU0AFdbrLMYB54k1PprmFXHq9TE13Npk9XBFQGD59LTs37LVslr9fE7UwW1KNOZMrpQqTfqcHTvSB7FfMRR33n+KauGYhHfVo8=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7705.eurprd04.prod.outlook.com (2603:10a6:10:209::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 01:41:37 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 01:41:36 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH 4/6] ethernet: stmmac: fix dma physical address of
 descriptor when display ring
Thread-Topic: [PATCH 4/6] ethernet: stmmac: fix dma physical address of
 descriptor when display ring
Thread-Index: AQHW6A4AOMxqzlC/p0u4GcQLrdx1PqoirsWAgACJBwA=
Date:   Tue, 12 Jan 2021 01:41:36 +0000
Message-ID: <DB8PR04MB679592B0547495108BBADBD5E6AA0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
 <20210111113538.12077-5-qiangqing.zhang@nxp.com>
 <e2ff7caa-6af8-49b9-cbf0-82b1e97a15c9@gmail.com>
In-Reply-To: <e2ff7caa-6af8-49b9-cbf0-82b1e97a15c9@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6c2320da-87df-4f06-ec2a-08d8b69b334e
x-ms-traffictypediagnostic: DBBPR04MB7705:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB77052010314853753D3F9296E6AA0@DBBPR04MB7705.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TlO6XKL2PImGVpw2plu2I41rri7HudNRCS5GtAGp4TQQpLAfAoq3auot6abJdkmI4HGeDbhgZm+tF97jInU9CDuicH/aThtlENWalVJIBsJSC6mBHps+zgujplcu3BAzBSqxLp290DgZkoYLV+1M2s64fmR7qdt378Rv85z+zMPWmmIsYHR6Gr+lDB9Q8u0IL3fbNlwuZ5N+WvnJ9KyNlp4slsquODNIySSib7C10rmNZ9OSfXbWrpsSyCP6yn5bN9tU8qm0RNGE2E1iWgpDyIq4+nluQL5kdERz09U1gQFCGhqC8WWbZqMrRF/mErEmr3Xb+KrOSyFxEZuE6sxun+e/QrkkMjuwvR3U38M//0xJMrCT6Zn5N6OlTQKLqNZ2iJfBPn/MWdaYJ0zfZHFzTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(8676002)(478600001)(66946007)(66556008)(33656002)(66476007)(66446008)(76116006)(5660300002)(8936002)(83380400001)(2906002)(86362001)(64756008)(7696005)(316002)(53546011)(186003)(4326008)(54906003)(6506007)(71200400001)(26005)(52536014)(55016002)(110136005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TGtSVENpYUI3a09DYzFidE51YXFmTU5qeVM0TGFCeld6dUFka3lUOWtWSTl4?=
 =?utf-8?B?ZjdsZVJLYXpadG1ZWU5vRFEvZFlRalg3K01NSkpQL1l1cWdRT0haczRNcGZU?=
 =?utf-8?B?ZEY0b3Jxa21sM3k4ckwrVEFKYmFRRExuUm5KN0lOdHptTEpGbExnbDQvK2gz?=
 =?utf-8?B?aFdyYjBGN3laRkhXcFNPbE92cVZlNHRXd1IyNW03cXpQYXhTeGx2aHNkR1c1?=
 =?utf-8?B?ajY1QWlWUlRKaTcwcnZmejdaYnNqOEpzcHZ3OEI1ZVJoSzR6eHVOMVMzVkM0?=
 =?utf-8?B?dm9KOUxpVS9ZeEhEbmUzUjMzY1puVzd5VWpYTzVGeHJJaENHU2NZZ2VrWTF5?=
 =?utf-8?B?alFLSEFURmRadUhaY3I5aW9EUStCRTRQUnE3ZzhyMDBhd0lHSjVZQWJ3YTM5?=
 =?utf-8?B?K0l2ZDFhUFRxSlJBU2VSamY2MGNudmYyZUV6UGN1YnhzWjd5eVdtYUVSOFh0?=
 =?utf-8?B?aExXdzBsRDNhSENtTFV4ZG1BSlZGanFBUGtWT0Y5dWczMll2eTdNbzBlTlVl?=
 =?utf-8?B?WjB4YzNmR3ZxNWlTV21hOE1wMVRNeE1TVm9iWGRVT3E0dXNYUldTWHNXcGhZ?=
 =?utf-8?B?MkxPeEdQVlI3UzRDOFZ3eGVLdW5MY2dXeHF6L2JMZWV4dFBXWUdILzRvWDZq?=
 =?utf-8?B?Z2VtbzFtNjhwMEFOWk1iOW1EUTd5QXVibzNTcyszUktCdDBoQUpiWTkxRFdi?=
 =?utf-8?B?M28xK1dUSUVyYXJ5VnIrTXdWVTBtcy9oSlREQnRxdVhZZFN0bS96aUFpQTJp?=
 =?utf-8?B?dENZMjNQUjFJSWtzZ3dYZkpIRDJFRjNFUEpETHdnYmNKb3EwVkUxMWJ2YkxB?=
 =?utf-8?B?eGVXV0R6eHNqcFZFRFFiNXloZEk4TitZVFNYNzFWZWl2cUlSSnVlOUdPZkxK?=
 =?utf-8?B?N3haV3lnT0dXek1oTCtGcUwxQlhITHkrQ1hkSDBNM2FVSllsb0xDVmtIL1Za?=
 =?utf-8?B?ZzVYUUU3bGRIT2J3QU1NQjF0MjNhSHhjZHF5anB6RkZSd3o1R3hCRCtoVFQr?=
 =?utf-8?B?TTMvZUZWeEppWTIzUUkyazZ4Mi9ZYlJ2cWI3MVdLZFVRL1lndkQzZ0lZc0ZC?=
 =?utf-8?B?ZWtOU0s0anpPS3NzMUdWTXUrK1FZbUQyd1V5dVZLZzNSN1NPMmFhMHlhUUVG?=
 =?utf-8?B?YWFlaWpOc1cvcldmZVJHYUZ5aFRPbnRRQ0VKejFoSHN3dWMxbzJ2OHhOOHFl?=
 =?utf-8?B?K3pyUkZKZ2s3a1ZVYkFsZXlYellGWFQzQzgyNDBFTzE3VDVRUVJKUTcrR2JJ?=
 =?utf-8?B?bWJuZEE3U3g0dmx4YThnd0JvT1dHeWdBZGd6cHFOU3hsTngwUlhRYWw1K2tU?=
 =?utf-8?Q?cum0EsfekDSb8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c2320da-87df-4f06-ec2a-08d8b69b334e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 01:41:36.8308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tJM5dB93DzJGi+wbQGB2VpmJHL9rl0PKZsen5oO+pJ/nhnGyPIBl9FVjOAQEQ+OparTWX0RJnoTVfmObeANIDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7705
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZsb3JpYW4gRmFpbmVsbGkg
PGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBTZW50OiAyMDIx5bm0MeaciDEy5pelIDE6MzANCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBwZXBwZS5jYXZhbGxh
cm9Ac3QuY29tOw0KPiBhbGV4YW5kcmUudG9yZ3VlQHN0LmNvbTsgam9hYnJldUBzeW5vcHN5cy5j
b207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IGt1YmFAa2VybmVsLm9yZw0KPiBDYzogbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT4NCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCA0LzZdIGV0aGVybmV0OiBzdG1tYWM6IGZpeCBkbWEgcGh5c2ljYWwg
YWRkcmVzcyBvZg0KPiBkZXNjcmlwdG9yIHdoZW4gZGlzcGxheSByaW5nDQo+IA0KPiBPbiAxLzEx
LzIxIDM6MzUgQU0sIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBEcml2ZXIgdXNlcyBkbWFfYWxs
b2NfY29oZXJlbnQgdG8gYWxsb2NhdGUgZG1hIG1lbW9yeSBmb3IgZGVzY3JpcHRvcnMsDQo+ID4g
ZG1hX2FsbG9jX2NvaGVyZW50IHdpbGwgcmV0dXJuIGJvdGggdGhlIHZpcnR1YWwgYWRkcmVzcyBh
bmQgcGh5c2ljYWwNCj4gPiBhZGRyZXNzLiBBRkFJSywgdmlydF90b19waHlzIGNvdWxkIG5vdCBj
b252ZXJ0IHZpcnR1YWwgYWRkcmVzcyB0bw0KPiA+IHBoeXNpY2FsIGFkZHJlc3MsIGZvciB3aGlj
aCBtZW1vcnkgaXMgYWxsb2NhdGVkIGJ5IGRtYV9hbGxvY19jb2hlcmVudC4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+ID4g
LS0tDQo+ID4gIC4uLi9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYzRfZGVzY3MuYyAgICB8
ICA1ICstDQo+ID4gIC4uLi9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZW5oX2Rlc2MuYyAg
ICB8ICA1ICstDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2h3aWYu
aCAgICB8ICAzICstDQo+ID4gIC4uLi9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvbm9ybV9k
ZXNjLmMgICB8ICA1ICstDQo+ID4gIC4uLi9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3Rt
bWFjX21haW4uYyB8IDUwDQo+ID4gKysrKysrKysrKysrLS0tLS0tLQ0KPiA+ICA1IGZpbGVzIGNo
YW5nZWQsIDQ0IGluc2VydGlvbnMoKyksIDI0IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjNF9kZXNjcy5j
DQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYzRfZGVzY3Mu
Yw0KPiA+IGluZGV4IGM2NTQwYjAwM2I0My4uOGUxZWUzM2JhMWU2IDEwMDY0NA0KPiA+IC0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjNF9kZXNjcy5jDQo+ID4g
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWM0X2Rlc2NzLmMN
Cj4gPiBAQCAtNDAyLDcgKzQwMiw4IEBAIHN0YXRpYyB2b2lkIGR3bWFjNF9yZF9zZXRfdHhfaWMo
c3RydWN0IGRtYV9kZXNjDQo+ICpwKQ0KPiA+ICAJcC0+ZGVzMiB8PSBjcHVfdG9fbGUzMihUREVT
Ml9JTlRFUlJVUFRfT05fQ09NUExFVElPTik7DQo+ID4gIH0NCj4gPg0KPiA+IC1zdGF0aWMgdm9p
ZCBkd21hYzRfZGlzcGxheV9yaW5nKHZvaWQgKmhlYWQsIHVuc2lnbmVkIGludCBzaXplLCBib29s
DQo+ID4gcngpDQo+ID4gK3N0YXRpYyB2b2lkIGR3bWFjNF9kaXNwbGF5X3Jpbmcodm9pZCAqaGVh
ZCwgdW5zaWduZWQgaW50IHNpemUsIGJvb2wgcngsDQo+ID4gKwkJCQl1bnNpZ25lZCBpbnQgZG1h
X3J4X3BoeSwgdW5zaWduZWQgaW50IGRlc2Nfc2l6ZSkNCj4gPiAgew0KPiA+ICAJc3RydWN0IGRt
YV9kZXNjICpwID0gKHN0cnVjdCBkbWFfZGVzYyAqKWhlYWQ7DQo+ID4gIAlpbnQgaTsNCj4gPiBA
QCAtNDExLDcgKzQxMiw3IEBAIHN0YXRpYyB2b2lkIGR3bWFjNF9kaXNwbGF5X3Jpbmcodm9pZCAq
aGVhZCwNCj4gPiB1bnNpZ25lZCBpbnQgc2l6ZSwgYm9vbCByeCkNCj4gPg0KPiA+ICAJZm9yIChp
ID0gMDsgaSA8IHNpemU7IGkrKykgew0KPiA+ICAJCXByX2luZm8oIiUwM2QgWzB4JXhdOiAweCV4
IDB4JXggMHgleCAweCV4XG4iLA0KPiA+IC0JCQlpLCAodW5zaWduZWQgaW50KXZpcnRfdG9fcGh5
cyhwKSwNCj4gPiArCQkJaSwgKHVuc2lnbmVkIGludCkoZG1hX3J4X3BoeSArIGkgKiBkZXNjX3Np
emUpLA0KPiANCj4gVGhpcyBjb2RlIHdpbGwgcHJvYmFibHkgbm90IHdvcmsgY29ycmVjdGx5IG9u
IGEgbWFjaGluZSB3aXRoIHBoeXNpY2FsIGFkZHJlc3Nlcw0KPiBncmVhdGVyIHRoYW4gMzItYml0
IGFueXdheSBhbmQgdGhlIGFkZHJlc3MgYml0cyB3b3VsZCBiZSB0cnVuY2F0ZWQgdGhlbiwNCj4g
Y2Fubm90IHlvdSB1c2UgYSBwaHlfYWRkcl90IG9yIGRtYV9hZGRyX3QgYW5kIHVzZSAlcGEgYXMg
ZmFyIGFzIHRoZSBwcmludGsNCj4gZm9ybWF0IGdvZXM/DQoNClRoYW5rcywgSSB3aWxsIGZpeCBp
dC4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IC0tDQo+IEZsb3JpYW4NCg==
