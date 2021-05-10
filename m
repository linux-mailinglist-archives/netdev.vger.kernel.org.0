Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F68377A08
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 04:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhEJCL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 22:11:29 -0400
Received: from mail-eopbgr140073.outbound.protection.outlook.com ([40.107.14.73]:12678
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230038AbhEJCL2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 May 2021 22:11:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHpTo9ORRw7vU8z49w3U/I/lXET32fQGjR01BjFLeveA9EDzeFWWk+V11PJ3YMBEmLpIgQ0d9G5Pgp81+xsvPRNHdFph2A6Q3lTBZv2SaYnVH6XPDIaibwwMco+lSF0s7DinynIksgy/ZZMxNLdso0VSj9AEtEgysGrXd1WfuyqDiovjM1bay4GTGgswSkD1CkzOnB5oobmXbceUoxFFp+HnCZlNkwAEODiHrs/2CGWh6O7UJt4/wmU1QFbqbVFxlYBso9Z7eIdtMYxALyHumRj9/590els5QR3H0o+uUpJbvjKzC5kFc/kswHvQLFyebvGFTcyNCWk67plvAczg+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vyQg+4V2zVtks+QV+I6Kj5KnY1+zdh0tvk27W4fQ8zA=;
 b=GRtfta6++kGtwzRBMz3uSd6qOgumfZhxtTlCMWZJabKYnyCEisPW7mmbK2Vf6RTq0Kv/E38CMqgpkPR8kb2VYMq4msVcjl985D+rSehf4qsB8grgwlTbBwDbWGH9Yt4pAYx3fgJZ4fsSRiCk6P+l23gu7/u2NcYfB0rP/idiLSqcXgd85OaFFUgTPbUrFglzcWANINkOZFz6y/5Z5T0b+I+mNks7pRek2ELyrUruzFtFJiyXmOhR6cWNZETMAbRJTpu1Fh4I+gzcQR/QxWOMmSEpjybrmckbUZfMLxgXs6gZnVHeY8Y6NCsTf8NfIjTAS49e/1skYbVXE8m6xSk1AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vyQg+4V2zVtks+QV+I6Kj5KnY1+zdh0tvk27W4fQ8zA=;
 b=oL0MZi0L0zelOgG1vAgXgkFhs8r+QjQngDHTeBK0hWEx+fNYb//Y8L7H9PT12h6vZ9VWCU1swCqJKTT/POfR77SEJjo4C1iAImJXPnBBGZRm2ptDBc28Xx6JsnU5DDL4Fk0QTeX6nufFUDugSCooE80jfma445n0Q/1G5clhf3U=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2502.eurprd04.prod.outlook.com (2603:10a6:4:37::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.30; Mon, 10 May
 2021 02:10:21 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 02:10:21 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Topic: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Index: AQHXNRN2zsKOwhYLU0OtzigMEkddiqq78qqAgACuHyCAAMibgIACfU4wgADPWgCAAW5iAIAT9FVggAIV2YCAAL0YIIAA64mAgAI4pqA=
Date:   Mon, 10 May 2021 02:10:21 +0000
Message-ID: <DB8PR04MB6795166AB5A04B4D4B7DE53AE6549@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
 <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
 <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210422085648.33738d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1732e825-dd8b-6f24-6ead-104467e70a6c@nvidia.com>
 <DB8PR04MB67952FC590FEE5A327DA4C95E6589@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <c4e64250-35d0-dde3-661d-1ee7b9fa8596@nvidia.com>
 <DB8PR04MB6795D3049415E51A15132F59E6569@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <e75fee5a-0b98-58b0-4ec8-9a0646812392@gmail.com>
In-Reply-To: <e75fee5a-0b98-58b0-4ec8-9a0646812392@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28b14463-018d-4fb5-d448-08d91358c40d
x-ms-traffictypediagnostic: DB6PR0401MB2502:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0401MB25029BB024347C3A3A989BCEE6549@DB6PR0401MB2502.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3gRfG8dHa6wWEHQkt4+o/S+NzExJD9eevXtpNQwdu8Dm4KFFOXkbQ0YNufe1JSZOh3KRaEsoUbooW9wM37KVNDjud5dybtM0JQUub6xCFciZHfp7koCCOvrcfjErkj/Pf/a/eQtm1h5Ky/ruTNBePx0rw4U50OM5Vg2mVmP2fvEEKEx6Mx0HF/cpMQltpetWvJofVS+WDaeO+3TVySrUoO+fE6M6euR5MaSE3Tp7l6nBx5SauCracS9iZ+5ju1EeW+2gN7C7ndYoN5nmbNTXsYCVqs8Yin03qjPiFSHZeTVA0HRkcwQI0VNab/6+qqjhS3qLDN446f/Oz98TmvL+TdMUZSVLpdB5L3hh2a+ktAfs1P8XI70ZE+K1fRnu5sQsE3R/X6qxIwv71UBP2xLaH/H0TSAd2urzFdWfzOIN83MojLeShAtfNk4WujxwuRp6DSxNPZ+k1MsRrL5q0Z1y8Ed6kK8ERZxxVtCop3lBD4TBiyF/j1vkspju3s8EmHK6J4U0jBWINthGiCeCCybE0JG8WzM45QgrkzffMnNk1d1WQ9SpEfdxV1v9vXq33ezavr3Kh+bky33vnqEFqP4WBEsmBjdYnCyk8AsX/17eTHC12TFijT1KLj1LZNfeJMZ5/wt3IBRZahfp1oVT92A3ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(26005)(86362001)(186003)(83380400001)(66946007)(9686003)(64756008)(66556008)(66476007)(66446008)(76116006)(8936002)(55016002)(33656002)(71200400001)(7696005)(54906003)(8676002)(53546011)(38100700002)(7416002)(4326008)(5660300002)(6506007)(52536014)(122000001)(316002)(110136005)(2906002)(478600001)(574254001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RkgvbFpYZ0NpVEdGbmVrWXRjMDFFcElvYWlDMDJ5ajV5NEU5UWJQbTR6Qmls?=
 =?utf-8?B?ZWNnRjZENk1Cam9aUE9vcDBDK09ETXZRbWVMVkc3VmZvSCt4SnNSbmxRdTB0?=
 =?utf-8?B?SGVRSkY0cVJWeEtSRHVpbUNucG5qMFdEUkxINlZqTHlleE9rSCtkS2lkMy9H?=
 =?utf-8?B?U0xSME5nUW1CaFM1N1E5V2tyQ001YytWOXloOXhkU3BIcEw0S2VNM1Q0TFEv?=
 =?utf-8?B?czRXckRZRlYvdU0wNHU1UlN5Um1ZRlJuNzFNRW1qc043dDdCZm9WdEpxbDVx?=
 =?utf-8?B?bm5kcStZbEtCMnRJZ1JQWTlNZzVacXMrb3E5clFmaHlic0I3NlBPZEYydVVB?=
 =?utf-8?B?US9YeEhOV1F6ODlSTzczMzNWaW5ocXRlcDZBRkRQMHd0WWVRQVh5cUF5aW5X?=
 =?utf-8?B?eDVldktzbXpqd3FidGFBRkIvdStJY2IzSjYyWnZKVnNpL2F6RkgzeU5vVHNl?=
 =?utf-8?B?cTYydHBQWlJNaHNjY3FJTlloaUJteHdLSVQ4SzRqcW9xdmpIUEVhL1NLN0RC?=
 =?utf-8?B?STNjeXB1d1Y1b3ZmZ2x6Mkh2Q1dZRnljYjc3NHNsWHRqVDZFNTdiWEpYY2Fp?=
 =?utf-8?B?UktFODVvTUN5bFZHTWwrUjV6R0pOZjVhQXFycER6ZSt5azY0TVFGM3JDTzdh?=
 =?utf-8?B?U2pzWlByM0hmR3ZKK3ZyM3N2a24vZkpnMWNMVU5aVVNET3VDVDRSOEs3WURH?=
 =?utf-8?B?cnFVejBiUzRmTTJlRzFYL1RXRlhZUEl6TUVZbmN5M3V3ZFYwUmVOWndVeGlt?=
 =?utf-8?B?ODlTNi9lZ0tsZWZUYUhEZkhTY2loYUh2ZERkcHZacGQwSm5MRW1Ca1RJVnFy?=
 =?utf-8?B?dnU0LzYwYlZGd2xMTTN6SkF4bS94WEZabnJtUlY0MFZ5T2lTK2lDeXJ4T2Q3?=
 =?utf-8?B?ZG1wYlplV3c5clpyd2k4eDE1NGp6Q0NqRjJDQllJanUva2pJSkRnd3cxWDdH?=
 =?utf-8?B?R0c5VC85dy9XcDRRa0k4OTZmN1BFZVVYRjlNUlErUmg5eWYrTWQydGhEdDFp?=
 =?utf-8?B?bWlubjdFNW5qV2ViZ29SQWhqcEw1Mm5IZ2VJVHlVTG43c25nMWVnd0xCdWpN?=
 =?utf-8?B?Rm9GbVJzbW5IWDFCTTFsVHNMaUxRdU90d2I4aFNoMmpHdkh6bGFMQnJqUU5L?=
 =?utf-8?B?ZWpJWndoOHRFUXY2UnJadGJEUnVyNk1mTnRUNDNKakVCcmF3enFwRXkrbWJG?=
 =?utf-8?B?Q2Fyc3dXNXh5RjZ3eklwbWJ2OEYrVVlVZ1pPQmxheWpQbmIxcGU0eUVYcGlR?=
 =?utf-8?B?TTdLZnY2QjNXMGVFNHZVY3JRVmVucFFMdFRWL3ZldlBnN3pscEJlRmkzM3JK?=
 =?utf-8?B?YjV5YTdRaXNLd3hzeU92NDVlSFZxRDB0cVQxclpmcnNrQXhzZ0VKekR6TCtY?=
 =?utf-8?B?QnQzVjZ2bm5DT204ellxTVZDbkNqbGM1T1l4RFl2S3l3V1VjYlhYZ1JZTGF3?=
 =?utf-8?B?M3REMk5yYkE3KzY0d0JDeVJQdnBkRkJIdlQ5OFlRdzV6WUw3aWYxejRhYUV5?=
 =?utf-8?B?eTJJYkJ3UlFrMEN0QVlteHY4NjBnNnBEaUlqRDI3ZFNka2R1MlRsVnNDUnNo?=
 =?utf-8?B?V1ZmeU81YStJSFdFeUQyUjV1VGFrc0Q4RjdRQ3F3UXgzUGdHQ1ZBdUNHMjFS?=
 =?utf-8?B?MVJQcjdsS1RFem5WNHhmUFdjMi9ONmwzK3FsM1lHQjN5eHdVcU9nVDdNNjcw?=
 =?utf-8?B?ZnhibnFlSWIvckthSTNSaHd6YnlhS2ZkVWwwamNpWE1YdURNbStTU0RVNDlL?=
 =?utf-8?Q?kVmPx6JSJ82kfUzIBc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28b14463-018d-4fb5-d448-08d91358c40d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2021 02:10:21.5701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MrgT+HxpeiAR+58AMGRi4BiCNKxklLo5MKnrcdfHcl06ltLzsYivKurY/d7YiNNa61enLe96mgXfF2dBZBEj4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGbG9yaWFuLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZs
b3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBTZW50OiAyMDIx5bm0Neac
iDjml6UgMjM6NDINCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+
OyBKb24gSHVudGVyDQo+IDxqb25hdGhhbmhAbnZpZGlhLmNvbT47IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+IENjOiBwZXBwZS5jYXZhbGxhcm9Ac3QuY29tOyBhbGV4YW5kcmUu
dG9yZ3VlQGZvc3Muc3QuY29tOw0KPiBqb2FicmV1QHN5bm9wc3lzLmNvbTsgZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsNCj4gbWNvcXVlbGluLnN0bTMyQGdtYWlsLmNvbTsgYW5kcmV3QGx1bm4uY2g7IGRs
LWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54cC5jb20+OyB0cmVkaW5nQG52aWRpYS5jb207IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtSRkMgbmV0LW5leHRdIG5ldDog
c3RtbWFjOiBzaG91bGQgbm90IG1vZGlmeSBSWCBkZXNjcmlwdG9yIHdoZW4NCj4gU1RNTUFDIHJl
c3VtZQ0KPiANCj4gDQo+IA0KPiBPbiA1LzgvMjAyMSA0OjIwIEFNLCBKb2FraW0gWmhhbmcgd3Jv
dGU6DQo+ID4NCj4gPiBIaSBKYWt1YiwNCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+PiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNvbT4NCj4gPj4g
U2VudDogMjAyMeW5tDXmnIg35pelIDIyOjIyDQo+ID4+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5n
cWluZy56aGFuZ0BueHAuY29tPjsgSmFrdWIgS2ljaW5za2kNCj4gPj4gPGt1YmFAa2VybmVsLm9y
Zz4NCj4gPj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0BzdC5jb207IGFsZXhhbmRyZS50b3JndWVAZm9z
cy5zdC5jb207DQo+ID4+IGpvYWJyZXVAc3lub3BzeXMuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0
Ow0KPiBtY29xdWVsaW4uc3RtMzJAZ21haWwuY29tOw0KPiA+PiBhbmRyZXdAbHVubi5jaDsgZi5m
YWluZWxsaUBnbWFpbC5jb207IGRsLWxpbnV4LWlteA0KPiA+PiA8bGludXgtaW14QG54cC5jb20+
OyB0cmVkaW5nQG52aWRpYS5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4gU3ViamVj
dDogUmU6IFtSRkMgbmV0LW5leHRdIG5ldDogc3RtbWFjOiBzaG91bGQgbm90IG1vZGlmeSBSWA0K
PiA+PiBkZXNjcmlwdG9yIHdoZW4gU1RNTUFDIHJlc3VtZQ0KPiA+Pg0KPiA+PiBIaSBKb2FraW0s
DQo+ID4+DQo+ID4+IE9uIDA2LzA1LzIwMjEgMDc6MzMsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4g
Pj4+DQo+ID4+Pj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4+PiBGcm9tOiBKb24g
SHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNvbT4NCj4gPj4+PiBTZW50OiAyMDIx5bm0NOaciDIz
5pelIDIxOjQ4DQo+ID4+Pj4gVG86IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBK
b2FraW0gWmhhbmcNCj4gPj4+PiA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+ID4+Pj4gQ2M6
IHBlcHBlLmNhdmFsbGFyb0BzdC5jb207IGFsZXhhbmRyZS50b3JndWVAZm9zcy5zdC5jb207DQo+
ID4+Pj4gam9hYnJldUBzeW5vcHN5cy5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+ID4+IG1j
b3F1ZWxpbi5zdG0zMkBnbWFpbC5jb207DQo+ID4+Pj4gYW5kcmV3QGx1bm4uY2g7IGYuZmFpbmVs
bGlAZ21haWwuY29tOyBkbC1saW51eC1pbXgNCj4gPj4+PiA8bGludXgtaW14QG54cC5jb20+OyB0
cmVkaW5nQG52aWRpYS5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4+PiBTdWJqZWN0
OiBSZTogW1JGQyBuZXQtbmV4dF0gbmV0OiBzdG1tYWM6IHNob3VsZCBub3QgbW9kaWZ5IFJYDQo+
ID4+Pj4gZGVzY3JpcHRvciB3aGVuIFNUTU1BQyByZXN1bWUNCj4gPj4+Pg0KPiA+Pj4+DQo+ID4+
Pj4gT24gMjIvMDQvMjAyMSAxNjo1NiwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+ID4+Pj4+IE9u
IFRodSwgMjIgQXByIDIwMjEgMDQ6NTM6MDggKzAwMDAgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+
Pj4+Pj4gQ291bGQgeW91IHBsZWFzZSBoZWxwIHJldmlldyB0aGlzIHBhdGNoPyBJdCdzIHJlYWxs
eSBiZXlvbmQgbXkNCj4gPj4+Pj4+IGNvbXByZWhlbnNpb24sIHdoeSB0aGlzIHBhdGNoIHdvdWxk
IGFmZmVjdCBUZWdyYTE4NiBKZXRzb24gVFgyDQo+IGJvYXJkPw0KPiA+Pj4+Pg0KPiA+Pj4+PiBM
b29rcyBva2F5LCBwbGVhc2UgcmVwb3N0IGFzIG5vbi1SRkMuDQo+ID4+Pj4NCj4gPj4+Pg0KPiA+
Pj4+IEkgc3RpbGwgaGF2ZSBhbiBpc3N1ZSB3aXRoIGEgYm9hcmQgbm90IGJlaW5nIGFibGUgdG8g
cmVzdW1lIGZyb20NCj4gPj4+PiBzdXNwZW5kIHdpdGggdGhpcyBwYXRjaC4gU2hvdWxkbid0IHdl
IHRyeSB0byByZXNvbHZlIHRoYXQgZmlyc3Q/DQo+ID4+Pg0KPiA+Pj4gSGkgSm9uLA0KPiA+Pj4N
Cj4gPj4+IEFueSB1cGRhdGVzIGFib3V0IHRoaXM/IENvdWxkIEkgcmVwb3N0IGFzIG5vbi1SRkM/
DQo+ID4+DQo+ID4+DQo+ID4+IFNvcnJ5IG5vIHVwZGF0ZXMgZnJvbSBteSBlbmQuIEFnYWluLCBJ
IGRvbid0IHNlZSBob3cgd2UgY2FuIHBvc3QgdGhpcw0KPiA+PiBhcyBpdCBpbnRyb2R1Y2VzIGEg
cmVncmVzc2lvbiBmb3IgdXMuIEkgYW0gc29ycnkgdGhhdCBJIGFtIG5vdCBhYmxlDQo+ID4+IHRv
IGhlbHAgbW9yZSBoZXJlLCBidXQgd2UgaGF2ZSBkb25lIHNvbWUgZXh0ZW5zaXZlIHRlc3Rpbmcg
b24gdGhlDQo+ID4+IGN1cnJlbnQgbWFpbmxpbmUgd2l0aG91dCB5b3VyIGNoYW5nZSBhbmQgSSBk
b24ndCBzZWUgYW55IGlzc3VlcyB3aXRoDQo+ID4+IHJlZ2FyZCB0byBzdXNwZW5kL3Jlc3VtZS4g
SGVuY2UsIHRoaXMgZG9lcyBub3QgYXBwZWFyIHRvIGZpeCBhbnkNCj4gPj4gcHJlLWV4aXN0aW5n
IGlzc3Vlcy4gSXQgaXMgcG9zc2libGUgdGhhdCB3ZSBhcmUgbm90IHNlZWluZyB0aGVtLg0KPiA+
Pg0KPiA+PiBBdCB0aGlzIHBvaW50IEkgdGhpbmsgdGhhdCB3ZSByZWFsbHkgbmVlZCBzb21lb25l
IGZyb20gU3lub3BzeXMgdG8NCj4gPj4gaGVscCB1cyB1bmRlcnN0YW5kIHRoYXQgZXhhY3QgcHJv
YmxlbSB0aGF0IHlvdSBhcmUgZXhwZXJpZW5jaW5nIHNvDQo+ID4+IHRoYXQgd2UgY2FuIGVuc3Vy
ZSB3ZSBoYXZlIHRoZSBuZWNlc3NhcnkgZml4IGluIHBsYWNlIGFuZCBpZiB0aGlzIGlzDQo+ID4+
IHNvbWV0aGluZyB0aGF0IGlzIGFwcGxpY2FibGUgdG8gYWxsIGRldmljZXMgb3Igbm90Lg0KPiA+
DQo+ID4gVGhpcyBwYXRjaCBvbmx5IHJlbW92ZXMgbW9kaWZpY2F0aW9uIG9mIFJ4IGRlc2NyaXB0
b3JzIHdoZW4gU1RNTUFDDQo+IHJlc3VtZSBiYWNrLCBJTUhPLCBpdCBzaG91bGQgbm90IGFmZmVj
dCBzeXN0ZW0gc3VzcGVuZC9yZXN1bWUgZnVuY3Rpb24uDQo+ID4gRG8geW91IGhhdmUgYW55IGlk
ZWEgYWJvdXQgSm9oJ3MgaXNzdWUgb3IgYW55IGFjY2VwdGFibGUgc29sdXRpb24gdG8gZml4IHRo
ZQ0KPiBpc3N1ZSBJIG1ldD8gVGhhbmtzIGEgbG90IQ0KPiANCj4gSm9ha2ltLCBkb24ndCB5b3Ug
aGF2ZSBhIHN1cHBvcnQgY29udGFjdCBhdCBTeW5vcHN5cyB3aG8gd291bGQgYmUgYWJsZSB0bw0K
PiBoZWxwIG9yIHNvbWVvbmUgYXQgTlhQIHdobyB3YXMgcmVzcG9uc2libGUgZm9yIHRoZSBNQUMg
aW50ZWdyYXRpb24/DQo+IFdlIGFsc28gaGF2ZSBTeW5vcHN5cyBlbmdpbmVlcnMgY29waWVkIHNv
IHByZXN1bWFibHkgdGhleSBjb3VsZCBzaGVkIHNvbWUNCj4gbGlnaHQuDQoNCkkgY29udGFjdGVk
IFN5bm9wc3lzIG5vIHN1YnN0YW50aXZlIGhlbHAgd2FzIHJlY2VpdmVkLCBhbmQgaW50ZWdyYXRp
b24gZ3V5cyBmcm9tIE5YUCBpcyB1bmF2YWlsYWJsZSBub3cuDQoNCkJ1dCwgc29tZSBoaW50cyBo
YXMgY2FtZSBvdXQsIHNlZW1zIGEgYml0IGhlbHAuIEkgZm91bmQgdGhhdCB0aGUgRE1BIHdpZHRo
IGlzIDM0IGJpdHMgb24gaS5NWDhNUCwgdGhpcyBtYXkgZGlmZmVyZW50IGZyb20gbWFueSBleGlz
dGluZyBTb0NzIHdoaWNoIGludGVncmF0ZWQgU1RNTUFDLg0KDQpBcyBJIGRlc2NyaWJlZCBpbiB0
aGUgY29tbWl0IG1lc3NhZ2U6DQpXaGVuIHN5c3RlbSBzdXNwZW5kOiB0aGUgcnggZGVzY3JpcHRv
ciBpcyAwMDggWzB4MDAwMDAwMDBjNDMxMDA4MF06IDB4MCAweDQwIDB4MCAweDM0MDEwMDQwDQpX
aGVuIHN5c3RlbSByZXN1bWU6IHRoZSByeCBkZXNjcmlwdG9yIG1vZGlmaWVkIHRvIDAwOCBbMHgw
MDAwMDAwMGM0MzEwMDgwXTogMHgwIDB4NDAgMHgwIDB4YjUwMTAwNDANClNpbmNlIHRoZSBETUEg
aXMgMzQgYml0cyB3aWR0aCwgc28gZGVzYzAvZGVzYzEgaW5kaWNhdGVzIHRoZSBidWZmZXIgYWRk
cmVzcywgYWZ0ZXIgc3lzdGVtIHJlc3VtZSwgdGhlIGJ1ZmZlciBhZGRyZXNzIGNoYW5nZWQgdG8g
MHg0MDAwMDAwMDAwLg0KQW5kIHRoZSBjb3JyZWN0IHJ4IGRlc2NyaXB0b3IgaXMgMDA4IFsweDAw
MDAwMDAwYzQzMTAwODBdOiAweDY1MTEwMDAgMHgxIDB4MCAweDgxMDAwMDAwLCB0aGUgdmFsaWQg
YnVmZmVyIGFkZHJlc3MgaXMgMHgxNjUxMTAwMC4NClNvIHdoZW4gRE1BIHRyaWVkIHRvIGFjY2Vz
cyAweDQwMDAwMDAwMDAsIHRoaXMgdmFsaWQgYWRkcmVzcywgd291bGQgZ2VuZXJhdGUgZmF0YWwg
YnVzIGVycm9yLg0KDQpCdXQgZm9yIG90aGVyIDMyIGJpdHMgd2lkdGggRE1BLCBETUEgc2VlbXMg
c3RpbGwgY2FuIHdvcmsgd2hlbiB0aGlzIGlzc3VlIGhhcHBlbmVkLCBvbmx5IGRlc2MwIGluZGlj
YXRlcyBidWZmZXIgYWRkcmVzcywgc28gdGhlIGJ1ZmZlciBhZGRyZXNzIGlzIDB4MCB3aGVuIHN5
c3RlbSByZXN1bWUuDQpBbmQgdGhlcmUgaXMgYSBOT1RFIGluIHRoZSBndWlkZToNCkluIHRoZSBS
ZWNlaXZlIERlc2NyaXB0b3IgKFJlYWQgRm9ybWF0KSwgaWYgdGhlIEJ1ZmZlciBBZGRyZXNzDQpm
aWVsZCBpcyBhbGwgMHMsIHRoZSBtb2R1bGUgZG9lcyBub3QgdHJhbnNmZXIgZGF0YSB0byB0aGF0
IGJ1ZmZlcg0KYW5kIHNraXBzIHRvIHRoZSBuZXh0IGJ1ZmZlciBvciBuZXh0IGRlc2NyaXB0b3Iu
DQpGb3IgdGhpcyBub3RlLCBJIGRvbid0IGtub3cgd2hhdCBjb3VsZCBJUCBhY3R1YWxseSBkbywg
d2hlbiBkZXRlY3QgYWxsIHplcm9zIGJ1ZmZlciBhZGRyZXNzLCBpdCB3aWxsIGNoYW5nZSB0aGUg
ZGVzY3JpcHRvciB0byBhcHBsaWNhdGlvbiBvd24/IElmIG5vdCwgU1RNTUFDIGRyaXZlciBzZWVt
cyBjYW4ndCBoYW5kbGUgdGhpcyBjYXNlLg0KSSB3aWxsIGNvbnRhY3QgU3lub3BzeXMgZ3V5cyBm
b3IgbW9yZSBkZXRhaWxzLg0KDQpJdCBub3cgYXBwZWFycyB0aGF0IHRoaXMgaXNzdWUgc2VlbXMg
b25seSBjYW4gYmUgcmVwcm9kdWNlZCBvbiBETUEgd2lkdGggbW9yZSB0aGFuIDMyIGJpdHMsIHRo
aXMgbWF5IGJlIHdoeSBvdGhlciBTb0NzKGUuZy4gaS5NWDhEWEwpIHdoaWNoIGludGVncmF0ZWQg
dGhlIHNhbWUgU1RNTUFDIElQIGNhbid0IHJlcHJvZHVjZSBpdC4NCg0KQmVzdCBSZWdhcmRzLA0K
Sm9ha2ltIFpoYW5nDQo+IC0tDQo+IEZsb3JpYW4NCg==
