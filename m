Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D567B3E8F2B
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 12:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237183AbhHKK4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 06:56:55 -0400
Received: from mail-eopbgr40069.outbound.protection.outlook.com ([40.107.4.69]:20031
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237181AbhHKK4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 06:56:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJfFzhmyJIaFH7Jew7QfZjkx8OrrX2WOq8Dzub1+ji0oQ+15mo1/Z/nBPUuSd9wvlcGtFjRQOMSTH/vvAhwrLZuBhpCaE/ZzTw5wpz1b3QDJHK9lD6FcUx/UHT9OLBTwlA5jegldzz6mfUzxaS0SXPidk44YCMBLt4WliY7WTx5yJSaHD5xE0AIibaaJkiEhNNLL/pxabgU99Hw3ivpNAcPdHmbFQOYhbo2S4CD0jnCHfq69v2qJDXMJpYDabn7yGSqUiQR24at85/gfgZXTgP4iVjINsn/CK2nbXnizwxKn9kqtlUfYSpJNEmqVaGIVkzvOW5tqsAQE3tfvSR7fSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJ1Xe+HyFOicoqIOygXRPFNiG55K1s2WpgGSSl51GOk=;
 b=S6zCR1xP8eXxF8yEV4zrc7RUT3s7K8xebmIlGw1nNctVCag4hMYCGJBRVZbLGi0z9qWxD4lRih2LlZ6cy/nVNzMI6FLEifamcxqx3VMfSFAw7yQ4T/Ptg+sAhFu5c1rNRIydpr+/dJzPIrhgVt7LYThKUavo7R+o/mFH/3nTOZ/n2x+0OC05w3xOrBmuU8EqpU8eZT2626oFma7qcL/IAdmya4arGlvUe4fsr6CW+mjmaSCHGZriPi32YMdyP5b1mij1UuXD5IEphsm75YGYAtD6txe4eNbDralusTsGlyDd2q403G8JuieFmlQ1pzR9pFxqcca20tooMGBK04yV1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJ1Xe+HyFOicoqIOygXRPFNiG55K1s2WpgGSSl51GOk=;
 b=LXc3pIYn8VGcj5xvB/0sLGLhU/k2q6VHhwtfp/HEP4hgi+kwwAnFudQbAb1kfS6RhcKaOmr6w9ZfYVTAYR1qIlakbfz3C7jlP0C1N1dzqwjQcdVu0SjzQ3q7VMadMh5DMGx0zWxn8eKqLUENTz14X2uHnSsRSVFfOZ/7hj0+mws=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5130.eurprd04.prod.outlook.com (2603:10a6:10:14::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Wed, 11 Aug
 2021 10:56:27 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d%6]) with mapi id 15.20.4394.025; Wed, 11 Aug 2021
 10:56:26 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Marc Zyngier <maz@kernel.org>
CC:     Matteo Croce <mcroce@linux.microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Drew Fustini <drew@beagleboard.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jon Hunter <jonathanh@nvidia.com>,
        Will Deacon <will@kernel.org>
Subject: RE: [PATCH net-next] stmmac: align RX buffers
Thread-Topic: [PATCH net-next] stmmac: align RX buffers
Thread-Index: AQHXYMSQgEG/0NSpREG9Gh0IIVxFk6ttdHmAgAEFA4CAAAIYQA==
Date:   Wed, 11 Aug 2021 10:56:26 +0000
Message-ID: <DB8PR04MB6795749EF7482925E1647335E6F89@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
 <871r71azjw.wl-maz@kernel.org> <YROpd450N+n6hYt2@orome.fritz.box>
In-Reply-To: <YROpd450N+n6hYt2@orome.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2043c4ec-a0f3-42b2-8f50-08d95cb6aac3
x-ms-traffictypediagnostic: DB7PR04MB5130:
x-microsoft-antispam-prvs: <DB7PR04MB51307D9EAAF60B1149FFBD72E6F89@DB7PR04MB5130.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7armRIUPSKaEgkB6xNP/n2v+UySG7xmeuXjy5gDcnYtQMVXST/hSSlh3vKiVYKN/7rt8gH1m0NwweFaAOdbgrQ+aNKY9VUPQKEWRs5BDRbVP9dqDwlUs+ggWth00FzmmmzapSWMZdOf9a0D8/+kWVK6w6YbhF+ihbSLUT9b48XULE8XMrcrMB55Nt6/Tk/9Dz8F55xT4oiwLwq2HkxTyw5qoGVBIMZt/u/GypRItWS/DuDgt/jkOJjacJOFKFjqx0kbBsjOkghtxS8w9CX5Q0FSmtTCbHh9/6SerNCif1rmqhT6qbgddCtVIWWgXIUNdM3kEEYCuhs6ZzkH0cuV8nLGeYVEW9+0I6QutF9ko4+3s3pq5b0SLTETZ8pEq4gP7gXSbUUgW+Wn9i8HPaEC4K0IhGKiIMQkarTHxirbd5fiWGwD5y4GKePOO4gmMhw+5EQDCUveLhJR20x0ZeDDl5RzsG17uEenznjEFfJDHAETgDnRMt9Ab2ie6bGJlkF7hKP/ZkMIhSxUgevyraMiGR5RHxbQlUAbJMAG3LzUbAvrrR8swI6Kjz2xxrI1KFkbLHWN7NPBbVgXTIJrbD3pJ1fu1iGL6WgvuMGN/HKe7G9eC+nq7AKRD8sxndT0fwWKlENX1NNJsJpyqNRsTQeAe37v7LcZx6+zmXeKEI/4FKqF4HkdZvhXmpummJzv0/gu+3KYS3IWvsSefUqoI002cfe2mPrfDYLJl7LHWPrD6CJwNzcSmxnhzdGpFIft1Fyg9Sf9zv1Am43VO+ibqMLVocvCdBZ38YXx+ZzYEfOITFwg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(508600001)(5660300002)(53546011)(6506007)(966005)(26005)(110136005)(7696005)(316002)(71200400001)(7416002)(66556008)(66446008)(76116006)(66946007)(64756008)(4326008)(66476007)(9686003)(52536014)(54906003)(8676002)(8936002)(186003)(55016002)(122000001)(86362001)(38100700002)(2906002)(83380400001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1VLMmRKSTc0cmU1RWhtcWljYXFJRkJ3UTZ6V0k1bVR3MHYwbThDc1FmdDQx?=
 =?utf-8?B?YW52Um04OGJjYTgwQlF5TERLZVVhKy85QnpZSkh6dHIwd2p3a29yL3RCOFZ5?=
 =?utf-8?B?Q01vYzFuMkNuTWJCaXlCcURLNjd5dVNUQUhQS1QwUkVwMWF5b2c2RHJuTkY3?=
 =?utf-8?B?OXBYOHdaMDNrb1djQ2NLeDJsNDFpNkVUMnczc1B2WlI5NExxc29wbkRhQm5O?=
 =?utf-8?B?VmE2S2l0TjBQN0VCT2dNbXdDcmlYRDQ5TS9FaUFiSmMrZXpyOHlhdlBnbEww?=
 =?utf-8?B?eTFsWHhXZHQxWnU2Vm53cVdaKzd0b210dlBudldKOWhLNXhndXN3d01lbmd0?=
 =?utf-8?B?c0lBSHd3ekc5SGprSXljbXVWNnpKQVlTTnlKMHgxM2lwNnl0SERuSHZHcVlL?=
 =?utf-8?B?alRnVDd0VVlsOGRhQVVFSHgvNTliWHAyYW80S0tZVU9EaGI2VlNzeVFTdTdB?=
 =?utf-8?B?emdsY1hRWXVsSU1FWVRYaVFjRGxrdXdHN1JCUGFneEpxbUZTNE9zcGtoUmNa?=
 =?utf-8?B?SXlwOEQwTkFBMnZUSVNQR1ZvSkpkS3lHdTB2SGRUZGhUMmhHbjdTbTFXK2hh?=
 =?utf-8?B?TjJNRWU0ZEV2d0NqV2F6a0sySFAxNzVlTXNyREhBaUU0QUw2dVk4TjhtWnFR?=
 =?utf-8?B?OXYrNmZhWjdtM2NQOUk2ZXA3aU0zSzVxbmJ1c3FKS1U4bEtHVS9rQWQxMXph?=
 =?utf-8?B?d0wzdjVQdlVCcjhZcXA5RWRvSWxkUi9TSmJUSy8yWVBSMWlkUThiZG9QWGV6?=
 =?utf-8?B?alU0ZGE1WGdrYkdhTlhPbmtzTkYrczdGUVJtcGNxek8yZHNydDZNWW1WYzBU?=
 =?utf-8?B?dHhWMnRWcjNrQ0JPdUlBZXVBTHRiejRnajVwaTVYY01Eb2hrSmJYMnVaOUJt?=
 =?utf-8?B?Q25rbmVNKzlHS1dFT0lvZ1RmTW1Sc1k5WHBwelRkSkpKWFdvV3BqdHJTOFVm?=
 =?utf-8?B?UHBvRUdhOEJaSm00c0hjVHNkc0tQL3RMaHorcDVFU2VxaFZqSE80d2tGcVpr?=
 =?utf-8?B?ZmJuUndoZ2lMajFxOTBPZ2k5eWVtaFlBNjl0NlV5Mk54cmplMnNKdkNvaGxO?=
 =?utf-8?B?LzBjRU1GOUJRQWFtWlgwK3huUzJlRC9PWnk0VENGMDhvNExpSUltbzBabEJ5?=
 =?utf-8?B?U0xGaHExUGs0MU90bTlBOS8wTDNWUHB0cUhSVExRcG5KTlVtWDNRR3ppbXBO?=
 =?utf-8?B?Uk55VVVUalRkdFlGRWNnZ1hpKytQY2V6d1dOQ3g3dXIvQnllb1VoNkQrcldB?=
 =?utf-8?B?SEpQL0FHNElkUk1QR3dmeFBDQnl4TVFidVNWNVhSSjVVNkJENWNJRWFoaU1P?=
 =?utf-8?B?NUlPUnZZcXZOQVZNSS9aVFEzMFNnY0I0RW53aVRJNy9PS3RKdzZ3UjVsOGk1?=
 =?utf-8?B?RmhZRFM4dHpncmVrT1BoeDFYbXZudFhkbjdsMVlLUWVlVXdZSFp3K2tmWmRv?=
 =?utf-8?B?NFBCNmk4aW9tMnFlTEJQMllWNWFFUldieW15aGpkUXZoNVhwMFk1RE5DNkFZ?=
 =?utf-8?B?NFFkOHpqVjJxRzJXdEZ5YitzNzVGNkVhWDQvQ3FrY09HTFY0aHNIZmZXblFt?=
 =?utf-8?B?K1hPaGgvYk1jZGZaVTFmM2p1Rm5iTHQ3RFp4czJreTloTVFvVGlJK1N1WW1l?=
 =?utf-8?B?Q1U2ZklHVFlsRmdrUDYrcmdOaS9zK2RUMERJVHd4S2tUcGE0TS9VVElCODBy?=
 =?utf-8?B?a2o4MVhrMGx1MDNQcnFZT291anZGb0FOVmhVWk12V2MyTC9vSWxteXpJQzZJ?=
 =?utf-8?Q?o1LsKoIIWOvqtnkLmlVhD55xXdlzQ/gzmp8ws2/?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2043c4ec-a0f3-42b2-8f50-08d95cb6aac3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2021 10:56:26.6699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XkXY5UZtlmCqzZR2h/7qcnpvtDtVDg9gfyJOVZavg+IsHUM4kftZgCknsRp0mNPb4VJ5Ll7cMVaD+GGSlMoaqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5130
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFRoaWVycnkgUmVkaW5nIDx0
aGllcnJ5LnJlZGluZ0BnbWFpbC5jb20+DQo+IFNlbnQ6IDIwMjHlubQ45pyIMTHml6UgMTg6NDIN
Cj4gVG86IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+DQo+IENjOiBNYXR0ZW8gQ3JvY2Ug
PG1jcm9jZUBsaW51eC5taWNyb3NvZnQuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4g
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtcmlzY3ZAbGlzdHMuaW5mcmFkZWFk
Lm9yZzsgR2l1c2VwcGUNCj4gQ2F2YWxsYXJvIDxwZXBwZS5jYXZhbGxhcm9Ac3QuY29tPjsgQWxl
eGFuZHJlIFRvcmd1ZQ0KPiA8YWxleGFuZHJlLnRvcmd1ZUBmb3NzLnN0LmNvbT47IERhdmlkIFMu
IE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+IEpha3ViIEtpY2luc2tpIDxrdWJhQGtl
cm5lbC5vcmc+OyBQYWxtZXIgRGFiYmVsdCA8cGFsbWVyQGRhYmJlbHQuY29tPjsNCj4gUGF1bCBX
YWxtc2xleSA8cGF1bC53YWxtc2xleUBzaWZpdmUuY29tPjsgRHJldyBGdXN0aW5pDQo+IDxkcmV3
QGJlYWdsZWJvYXJkLm9yZz47IEVtaWwgUmVubmVyIEJlcnRoaW5nIDxrZXJuZWxAZXNtaWwuZGs+
OyBKb24NCj4gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNvbT47IFdpbGwgRGVhY29uIDx3aWxs
QGtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHRdIHN0bW1hYzogYWxp
Z24gUlggYnVmZmVycw0KPiANCj4gT24gVHVlLCBBdWcgMTAsIDIwMjEgYXQgMDg6MDc6NDdQTSAr
MDEwMCwgTWFyYyBaeW5naWVyIHdyb3RlOg0KPiA+IEhpIGFsbCwNCj4gPg0KPiA+IFthZGRpbmcg
VGhpZXJyeSwgSm9uIGFuZCBXaWxsIHRvIHRoZSBmdW5dDQo+ID4NCj4gPiBPbiBNb24sIDE0IEp1
biAyMDIxIDAzOjI1OjA0ICswMTAwLA0KPiA+IE1hdHRlbyBDcm9jZSA8bWNyb2NlQGxpbnV4Lm1p
Y3Jvc29mdC5jb20+IHdyb3RlOg0KPiA+ID4NCj4gPiA+IEZyb206IE1hdHRlbyBDcm9jZSA8bWNy
b2NlQG1pY3Jvc29mdC5jb20+DQo+ID4gPg0KPiA+ID4gT24gUlggYW4gU0tCIGlzIGFsbG9jYXRl
ZCBhbmQgdGhlIHJlY2VpdmVkIGJ1ZmZlciBpcyBjb3BpZWQgaW50byBpdC4NCj4gPiA+IEJ1dCBv
biBzb21lIGFyY2hpdGVjdHVyZXMsIHRoZSBtZW1jcHkoKSBuZWVkcyB0aGUgc291cmNlIGFuZA0K
PiA+ID4gZGVzdGluYXRpb24gYnVmZmVycyB0byBoYXZlIHRoZSBzYW1lIGFsaWdubWVudCB0byBi
ZSBlZmZpY2llbnQuDQo+ID4gPg0KPiA+ID4gVGhpcyBpcyBub3Qgb3VyIGNhc2UsIGJlY2F1c2Ug
U0tCIGRhdGEgcG9pbnRlciBpcyBtaXNhbGlnbmVkIGJ5IHR3bw0KPiA+ID4gYnl0ZXMgdG8gY29t
cGVuc2F0ZSB0aGUgZXRoZXJuZXQgaGVhZGVyLg0KPiA+ID4NCj4gPiA+IEFsaWduIHRoZSBSWCBi
dWZmZXIgdGhlIHNhbWUgd2F5IGFzIHRoZSBTS0Igb25lLCBzbyB0aGUgY29weSBpcyBmYXN0ZXIu
DQo+ID4gPiBBbiBpcGVyZjMgUlggdGVzdCBnaXZlcyBhIGRlY2VudCBpbXByb3ZlbWVudCBvbiBh
IFJJU0MtViBtYWNoaW5lOg0KPiA+ID4NCj4gPiA+IGJlZm9yZToNCj4gPiA+IFsgSURdIEludGVy
dmFsICAgICAgICAgICBUcmFuc2ZlciAgICAgQml0cmF0ZSAgICAgICAgIFJldHINCj4gPiA+IFsg
IDVdICAgMC4wMC0xMC4wMCAgc2VjICAgNzMzIE1CeXRlcyAgIDYxNSBNYml0cy9zZWMgICA4OA0K
PiBzZW5kZXINCj4gPiA+IFsgIDVdICAgMC4wMC0xMC4wMSAgc2VjICAgNzMwIE1CeXRlcyAgIDYx
MiBNYml0cy9zZWMNCj4gcmVjZWl2ZXINCj4gPiA+DQo+ID4gPiBhZnRlcjoNCj4gPiA+IFsgSURd
IEludGVydmFsICAgICAgICAgICBUcmFuc2ZlciAgICAgQml0cmF0ZSAgICAgICAgIFJldHINCj4g
PiA+IFsgIDVdICAgMC4wMC0xMC4wMCAgc2VjICAxLjEwIEdCeXRlcyAgIDk0MiBNYml0cy9zZWMg
ICAgMA0KPiBzZW5kZXINCj4gPiA+IFsgIDVdICAgMC4wMC0xMC4wMCAgc2VjICAxLjA5IEdCeXRl
cyAgIDk0MCBNYml0cy9zZWMNCj4gcmVjZWl2ZXINCj4gPiA+DQo+ID4gPiBBbmQgdGhlIG1lbWNw
eSgpIG92ZXJoZWFkIGR1cmluZyB0aGUgUlggZHJvcHMgZHJhbWF0aWNhbGx5Lg0KPiA+ID4NCj4g
PiA+IGJlZm9yZToNCj4gPiA+IE92ZXJoZWFkICBTaGFyZWQgTyAgU3ltYm9sDQo+ID4gPiAgIDQz
LjM1JSAgW2tlcm5lbF0gIFtrXSBtZW1jcHkNCj4gPiA+ICAgMzMuNzclICBba2VybmVsXSAgW2td
IF9fYXNtX2NvcHlfdG9fdXNlcg0KPiA+ID4gICAgMy42NCUgIFtrZXJuZWxdICBba10gc2lmaXZl
X2wyX2ZsdXNoNjRfcmFuZ2UNCj4gPiA+DQo+ID4gPiBhZnRlcjoNCj4gPiA+IE92ZXJoZWFkICBT
aGFyZWQgTyAgU3ltYm9sDQo+ID4gPiAgIDQ1LjQwJSAgW2tlcm5lbF0gIFtrXSBfX2FzbV9jb3B5
X3RvX3VzZXINCj4gPiA+ICAgMjguMDklICBba2VybmVsXSAgW2tdIG1lbWNweQ0KPiA+ID4gICAg
NC4yNyUgIFtrZXJuZWxdICBba10gc2lmaXZlX2wyX2ZsdXNoNjRfcmFuZ2UNCj4gPiA+DQo+ID4g
PiBTaWduZWQtb2ZmLWJ5OiBNYXR0ZW8gQ3JvY2UgPG1jcm9jZUBtaWNyb3NvZnQuY29tPg0KPiA+
DQo+ID4gVGhpcyBwYXRjaCBjb21wbGV0ZWx5IGJyZWFrcyBteSBKZXRzb24gVFgyIHN5c3RlbSwg
Y29tcG9zZWQgb2YgMg0KPiA+IE52aWRpYSBEZW52ZXIgYW5kIDQgQ29ydGV4LUE1NywgaW4gYSB2
ZXJ5ICJmdW5ueSIgd2F5Lg0KPiA+DQo+ID4gQW55IHNpZ25pZmljYW50IGFtb3VudCBvZiB0cmFm
ZmljIHJlc3VsdCBpbiBhbGwgc29ydCBvZiBjb3JydXB0aW9uDQo+ID4gKHNzaCBjb25uZWN0aW9u
cyBnZXQgZHJvcHBlZCwgRGViaWFuIHBhY2thZ2VzIGRvd25sb2FkZWQgaGF2ZSB0aGUNCj4gPiB3
cm9uZyBjaGVja3N1bXMpIGlmIGFueSBEZW52ZXIgY29yZSBpcyBpbnZvbHZlZCBpbiBhbnkgc2ln
bmlmaWNhbnQgd2F5DQo+ID4gKHBhY2tldCBwcm9jZXNzaW5nLCBpbnRlcnJ1cHQgaGFuZGxpbmcp
LiBBbmQgaXQgaXMgYWxsIHRyaWdnZXJlZCBieQ0KPiA+IHRoaXMgdmVyeSBjaGFuZ2UuDQo+ID4N
Cj4gPiBUaGUgb25seSB3YXkgSSBoYXZlIHRvIG1ha2UgaXQgd29yayBvbiBhIERlbnZlciBjb3Jl
IGlzIHRvIHJvdXRlIHRoZQ0KPiA+IGludGVycnVwdCB0byB0aGF0IHBhcnRpY3VsYXIgY29yZSBh
bmQgdGFza3NldCB0aGUgd29ya2xvYWQgdG8gaXQuIEFueQ0KPiA+IG90aGVyIGNvbmZpZ3VyYXRp
b24gaW52b2x2aW5nIGEgRGVudmVyIENQVSByZXN1bHRzIGluIHNvbWUgc29ydCBvZg0KPiA+IGNv
cnJ1cHRpb24uIE9uIHRoZWlyIG93biwgdGhlIEE1N3MgYXJlIGZpbmUuDQo+ID4NCj4gPiBUaGlz
IHNtZWxscyBvZiBtZW1vcnkgb3JkZXJpbmcgZ29pbmcgcmVhbGx5IHdyb25nLCB3aGljaCB0aGlz
IGNoYW5nZQ0KPiA+IHdvdWxkIGV4cG9zZS4gSSBoYXZlbid0IGhhZCBhIGNoYW5jZSB0byBkaWcg
aW50byB0aGUgZHJpdmVyIHlldCAoaXQNCj4gPiB0b29rIG1lIGxvbmcgZW5vdWdoIHRvIGJpc2Vj
dCBpdCksIGJ1dCBpZiBzb21lb25lIHBvaW50cyBtZSBhdCB3aGF0IGlzDQo+ID4gc3VwcG9zZWQg
dG8gc3luY2hyb25pc2UgdGhlIERNQSB3aGVuIHJlY2VpdmluZyBhbiBpbnRlcnJ1cHQsIEknbGwg
aGF2ZQ0KPiA+IGEgbG9vay4NCj4gDQo+IE9uZSBvdGhlciB0aGluZyB0aGF0IGtpbmQgb2Ygcmlu
Z3MgYSBiZWxsIHdoZW4gcmVhZGluZyBETUEgYW5kIGludGVycnVwdHMgaXMgYQ0KPiByZWNlbnQg
cmVwb3J0IChhbmQgYXR0ZW1wdCB0byBmaXggdGhpcykgd2hlcmUgdXBvbiByZXN1bWUgZnJvbSBz
eXN0ZW0NCj4gc3VzcGVuZCwgdGhlIERNQSBkZXNjcmlwdG9ycyB3b3VsZCBnZXQgY29ycnVwdGVk
Lg0KPiANCj4gSSBkb24ndCB0aGluayB3ZSBldmVyIGZpZ3VyZWQgb3V0IHdoYXQgZXhhY3RseSB0
aGUgcHJvYmxlbSB3YXMsIGJ1dA0KPiBpbnRlcmVzdGluZ2x5IHRoZSBmaXggZm9yIHRoZSBpc3N1
ZSBpbW1lZGlhdGVseSBjYXVzZWQgdGhpbmdzIHRvIGdvIGhheXdpcmUgb24uLi4NCj4gSmV0c29u
IFRYMi4NCj4gDQo+IEkgcmVjYWxsIGxvb2tpbmcgYXQgdGhpcyBhIGJpdCBhbmQgY291bGRuJ3Qg
ZmluZCB3aGVyZSBleGFjdGx5IHRoZSBETUEgd2FzIGJlaW5nDQo+IHN5bmNocm9uaXplZCBvbiBz
dXNwZW5kL3Jlc3VtZSwgb3Igd2hhdCB0aGUgbWVjaGFuaXNtIHdhcyB0byBlbnN1cmUgdGhhdA0K
PiAoaW4gdHJhbnNpdCkgcGFja2V0cyB3ZXJlIG5vdCByZWNlaXZlZCBhZnRlciB0aGUgc3VzcGVu
c2lvbiBvZiB0aGUgRXRoZXJuZXQNCj4gZGV2aWNlLiBTb21lIGluZm9ybWF0aW9uIGFib3V0IHRo
aXMgY2FuIGJlIGZvdW5kIGhlcmU6DQo+IA0KPiAJaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0
ZGV2LzcwOGVkYjkyLWE1ZGYtZWNjNC0zMTI2LTVhYjM2NzA3ZTI3NQ0KPiBAbnZpZGlhLmNvbS8N
Cj4gDQo+IEl0J3MgaW50ZXJlc3RpbmcgdGhhdCB0aGlzIGhhcHBlbnMgb25seSBvbiBKZXRzb24g
VFgyLiBBcHBhcmVudGx5IG9uIHRoZSBuZXdlcg0KPiBKZXRzb24gQUdYIFhhdmllciB0aGlzIHBy
b2JsZW0gZG9lcyBub3Qgb2NjdXIuIEkgdGhpbmsgSm9uIGFsc28gbmFycm93ZWQgdGhpcw0KPiBk
b3duIHRvIGJlaW5nIHJlbGF0ZWQgdG8gdGhlIElPTU1VIGJlaW5nIGVuYWJsZWQgb24gSmV0c29u
IFRYMiwgd2hlcmVhcw0KPiBKZXRzb24gQUdYIFhhdmllciBkaWRuJ3QgaGF2ZSBpdCBlbmFibGVk
LiBJIHdhc24ndCBhYmxlIHRvIGZpbmQgYW55IG5vdGVzIG9uDQo+IHdoZXRoZXIgZGlzYWJsaW5n
IHRoZSBJT01NVSBvbiBKZXRzb24gVFgyIGRpZCBhbnl0aGluZyB0byBpbXByb3ZlIG9uIHRoaXMs
DQo+IHNvIHBlcmhhcHMgdGhhdCdzIHNvbWV0aGluZyB3b3J0aCB0cnlpbmcuDQo+IA0KPiBXZSBo
YXZlIHNpbmNlIGVuYWJsZWQgdGhlIElPTU1VIG9uIEpldHNvbiBBR1ggWGF2aWVyLCBhbmQgSSBo
YXZlbid0IHNlZW4NCj4gYW55IHRlc3QgcmVwb3J0cyBpbmRpY2F0aW5nIHRoYXQgdGhpcyBpcyBj
YXVzaW5nIGlzc3Vlcy4gU28gSSBkb24ndCB0aGluayB0aGlzIGhhcw0KPiBhbnl0aGluZyBkaXJl
Y3RseSB0byBkbyB3aXRoIHRoZSBJT01NVSBzdXBwb3J0Lg0KPiANCj4gVGhhdCBzYWlkLCBpZiB0
aGVzZSBwcm9ibGVtcyBhcmUgYWxsIGV4Y2x1c2l2ZSB0byBKZXRzb24gVFgyLCBvciByYXRoZXIg
VGVncmExODYsDQo+IHRoYXQgY291bGQgaW5kaWNhdGUgdGhhdCB3ZSdyZSBtaXNzaW5nIHNvbWV0
aGluZyBhdCBhIG1vcmUgZnVuZGFtZW50YWwgbGV2ZWwNCj4gKG1heWJlIHNvbWUgY2FjaGUgbWFp
bnRlbmFuY2UgcXVpcms/KS4NCg0KDQpIZXkgVGhpZXJyeSwNCg0KUGxlYXNlIGFsc28gbm90aWNl
IG1lIGlmIHlvdSBmb3VuZCB0aGUgcm9vdCBjYXVzZSwgdGhhdCB3b3VsZCBiZSBhcHByZWNpYXRl
ZCENCkkgaGF2ZSBub3QgdXBzdHJlYW0gdGhlIGZpeCB5b3UgbWVudGlvbmVkIHlldCBzaW5jZSB5
b3VyIGNvbnRpbnVvdXMgTkFDSy4NCg0KVGhhbmtzIGluIGFkdmFuY2Ug8J+Yig0KDQpCZXN0IFJl
Z2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gVGhpZXJyeQ0KPiANCj4gPiA+IC0tLQ0KPiA+ID4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hYy5oIHwgNCArKy0tDQo+ID4g
PiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPiA+
DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMv
c3RtbWFjLmgNCj4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3Rt
bWFjLmgNCj4gPiA+IGluZGV4IGI2Y2Q0M2VkYTdhYy4uMDRiZGIzOTUwZDYzIDEwMDY0NA0KPiA+
ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjLmgNCj4g
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hYy5oDQo+
ID4gPiBAQCAtMzM4LDkgKzMzOCw5IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBzdG1tYWNfeGRwX2lz
X2VuYWJsZWQoc3RydWN0DQo+ID4gPiBzdG1tYWNfcHJpdiAqcHJpdikgIHN0YXRpYyBpbmxpbmUg
dW5zaWduZWQgaW50DQo+ID4gPiBzdG1tYWNfcnhfb2Zmc2V0KHN0cnVjdCBzdG1tYWNfcHJpdiAq
cHJpdikgIHsNCj4gPiA+ICAJaWYgKHN0bW1hY194ZHBfaXNfZW5hYmxlZChwcml2KSkNCj4gPiA+
IC0JCXJldHVybiBYRFBfUEFDS0VUX0hFQURST09NOw0KPiA+ID4gKwkJcmV0dXJuIFhEUF9QQUNL
RVRfSEVBRFJPT00gKyBORVRfSVBfQUxJR047DQo+ID4gPg0KPiA+ID4gLQlyZXR1cm4gMDsNCj4g
PiA+ICsJcmV0dXJuIE5FVF9TS0JfUEFEICsgTkVUX0lQX0FMSUdOOw0KPiA+ID4gIH0NCj4gPiA+
DQo+ID4gPiAgdm9pZCBzdG1tYWNfZGlzYWJsZV9yeF9xdWV1ZShzdHJ1Y3Qgc3RtbWFjX3ByaXYg
KnByaXYsIHUzMiBxdWV1ZSk7DQo+ID4gPiAtLQ0KPiA+ID4gMi4zMS4xDQo+ID4gPg0KPiA+ID4N
Cj4gPg0KPiA+IC0tDQo+ID4gV2l0aG91dCBkZXZpYXRpb24gZnJvbSB0aGUgbm9ybSwgcHJvZ3Jl
c3MgaXMgbm90IHBvc3NpYmxlLg0K
