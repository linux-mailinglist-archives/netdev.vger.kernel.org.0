Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B735395816
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 11:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhEaJ3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 05:29:53 -0400
Received: from mail-am6eur05on2063.outbound.protection.outlook.com ([40.107.22.63]:7809
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230527AbhEaJ3v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 05:29:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVqeGMJaCdp9/hdGxooz3sFq9dhfaQokb6g/TSAah/bm3XNrbt0voLmsKPh6Yx5VTNN3iWWE93eyrPYMdVdNdTeH1mdN5MBgsKCgNXzwQGQ2vB/6CFLhhxkEksfnZ5bNCgIi4w5pcThcHwb3Esq9jSMo7ZdhsCeoMwlBmRhptLgwONAdNlBuM+EgMkNRRvb1wDS1emIRO9vNp4aYDsbpZbMgsaJYA3HR8VUeVXkG2hv8a270Ma6CR4cYLnMC0tMJE6o3a3bI1q8b2cdbS/XyWsnAVuhWBISfz/9bX7GOJjZSBqo3BxpzAG90owK3e6Pt41A5dlvOLpxh/EPlqJVv4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWnrgWgkg7ZX6v0cwF3CQ8kuxkEMd6X9LreN4Jvho2Q=;
 b=jjUNavtQq9kPP43kbdzuvVVlmvwSCZb2p2oxLgnsxTWBsTJ6S6o/VpXh/UXCqEjysRosxbC+YeY0bE/+KWynZCfrZudtaLUU0bvhW+AjeQ5stlR3piAj1ZKD1zq6E1sulw+jyNrijprZ5F9/wKcjQ9ILoPC8To/eOBRrNQfzC29Z+te/4ugc+MAbop6f9W+2utqYFwfCOumSgj1IRsdBCxYEb6y1lJB+rkp2PzxPnOuoK9u5Oanyxp6RzeDL2Y0FyOC3EHaS6Rp0p7tXg8mGUm8ASIBVcohm7tSRx4vzhlMEK8YDqk/6DhrQ4mezPGh/v0uZcknzYZjXgG3Jl4ET4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWnrgWgkg7ZX6v0cwF3CQ8kuxkEMd6X9LreN4Jvho2Q=;
 b=S8Il+lxC8Sj6qF0r9MWTam4K7P3VCuObriK4sfOaC5y6Bl6XdwbORgQwe2TekVa6clMhFmCDNYLOA1Z5pdQ8CaNJ1+FBitWVkIc6cOXvOFS1SJH0KS/3WuzjyXqfUJYDtSeJ1b+e92zi+rgSzlVyWLDeLXHHDnZvdRLL+wR7xzg=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6140.eurprd04.prod.outlook.com (2603:10a6:10:c7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Mon, 31 May
 2021 09:28:10 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 09:28:10 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Thierry Reding <treding@nvidia.com>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V1 net-next] net: stmmac: should not modify RX descriptor
 when STMMAC resume
Thread-Topic: [PATCH V1 net-next] net: stmmac: should not modify RX descriptor
 when STMMAC resume
Thread-Index: AQHXUtVO01AocOsk1k2Ywq4dfn66rar3YvuAgAVtk2A=
Date:   Mon, 31 May 2021 09:28:10 +0000
Message-ID: <DB8PR04MB679514B98EB32EB8178614AEE63F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210527084911.20116-1-qiangqing.zhang@nxp.com>
 <YK+sJ20/z5i6rYVK@orome.fritz.box>
In-Reply-To: <YK+sJ20/z5i6rYVK@orome.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34279e34-aba0-4df8-42df-08d924166800
x-ms-traffictypediagnostic: DBBPR04MB6140:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB61403903B097C0CB19729BC0E63F9@DBBPR04MB6140.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L/rkfJtdPHk8tJl3WqYfhQl7O2cvete2glaCcwY/NZgswQ4rTjv55sZXpOFjk+rK938sTilCZMCXx3BLGqQBrvc0TUNdqEOazGuDSN1S0ulcCx8RMbvYsRqhApAwEKBXUsEMqqwyy97+ThzEvw+x3H3+bdQI9J1Qm4r7OWxU5FRtxpn08+okAubRZGKLhgn4v37eyaUZRLaEfYwGr0XWu7cXn/XexV4NhVU3uM1OSgckgYKwBjkRMoj9Yf7M3wju1N4FWSrRqvkS8s9EQqBWgECL3q94Rda6Ph07U2nGI2ksany81qKnlNQ74tz/DqIyrfT5W2MSZN+5q9SwK/H5S/19uxXoFpi2krxCRyOiqKxFBzK/QgaU2Ab0Gz6x5VPzmltsJfFY5+nQyC2FwGs6VLu3DKW9t60j9S4qrKL9NQp4CRnOeWa5Psz/MSxGCxpQU0klTsO8C6lI3ir1ogap8dfhqIKw1rK3D9vVWwdLjssui/e1GOyMwxTwZmn62rTpCiwOijpdlpuK8HNmrT951rQVtDonPC25XRxDo9eZbpyjMF9G3Plc+OtctoFpXMCtgF4v1OCR9Lgx5fp2/aWiBoGgaMHZ8Hp7WhCnzDjnuDc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(76116006)(8936002)(53546011)(52536014)(6506007)(122000001)(316002)(66446008)(66946007)(54906003)(38100700002)(9686003)(26005)(8676002)(478600001)(66556008)(64756008)(86362001)(5660300002)(55016002)(66476007)(186003)(2906002)(6916009)(71200400001)(4326008)(7696005)(83380400001)(33656002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?alBIYWNHclkra3NKaFNJQXJNZjljdjZnWWwyL2Q4empzaWZ5ZFBuZUJjaCtQ?=
 =?gb2312?B?WmRZcjhKemlCb0ZIN3NWRFFHUjQ5c2pJQ1FJL2wvdVBFbDNDNnl2MFRPb1VC?=
 =?gb2312?B?UHVoR3FFdkpndmpVQU1DQ1VVd3psdzBNMzhQZTZzbklYRENiWGhMQW9zMm9R?=
 =?gb2312?B?eGxZTUc5cUlxemsxZzZNckFPK3hYd21hOHRMb1Q1eGFUblE0amltYWkzQU5L?=
 =?gb2312?B?SVV5cnlMZTYvNnJQNkhUdXdDdTU3VFNJQnh5RUNCZE5SK2p0Smh6ak1WZGVG?=
 =?gb2312?B?TERLUDVaVHIwRHl6dzJMblB4bHZWVHpHT0NFTlovN1J3MTNLN081M20ycXhq?=
 =?gb2312?B?TW5oa21Dc1dEMnZVM0tDcDB5OWxHZkNrWHBNRnhYZGhLSWpzbmpzc3Bwb2d6?=
 =?gb2312?B?c1hUTzNyMFkwUEJNUzc4czlMM1duWEdqd2w4RTlUUmVENFdSd0RRSU9qRW5q?=
 =?gb2312?B?S2tnTFdCbk5VdnY0ZkU4NFE0Qks2bXhlaWx6cXljMmU4Y0lFdXZFdTk5UTRx?=
 =?gb2312?B?VkV0YTVScGQwaVFaRXl6dm9BRzNWSEQ1emgvaFBCR1lLMi8rNnZPOUdDTVh0?=
 =?gb2312?B?QmxQakFvWFBibjY2eEhEcDFtZFpaVXpWMkNFcllyWHNmdHM3TnpwMFA4dkxP?=
 =?gb2312?B?VGFtZ1ZxWUNERWYybDFzQUlqZmpVaUFtNWo0QjJVSXFpOW14STBOaWNjTDFy?=
 =?gb2312?B?cVJWallDdXQxcmpuV0tjRjU2YWJOK1FoakliYzRzUnNKa3o3Nk9NR2duU2ZF?=
 =?gb2312?B?VStxenhBSGZ4ZlR1dkJkNnRWbFRHcHFwTjJQQVRudVRMMEpYYTdRT3UyKzZG?=
 =?gb2312?B?OVplZWtZUFZ3aVFMMUd3Z2F6Vm4rNlNzZFRWeURoRTFPZGY5QWM4eEFwQXJi?=
 =?gb2312?B?RnBKbWszcDJDTnJKMHhDQzlGTHV1eFY5RDRONzdwQ05FOVowZEdVcVUzdTcv?=
 =?gb2312?B?R1ZkZy9rZ3VzYU5JWmpCR1NSVFVkSmE1OXl2OVBraC9Fd2VoNjNsK0szdjZZ?=
 =?gb2312?B?YWxtaDV1NE44WmNzR3VMUmNadWs5MWZjL1VWaWpDNnVTWFg3VjNXczRQQ0JI?=
 =?gb2312?B?M25LbUl4YXhFMUJ4YjZGelR5SWRlRmx1K2xXWVlBTUtrZ3NxZEJZSTdJbDBI?=
 =?gb2312?B?dXhKME5LbVl1akJ2NTR5OXVEby91b2hUVktIeXpGcTRySFJKclB3N3JsK0Ix?=
 =?gb2312?B?VExvV2hnbnp5VjBsSU9NVzErMnpTbGdEZ0NyZFl1dEYxYnBJY1hvUG5WSk4y?=
 =?gb2312?B?RVUrYjl5Wm9qL3gxaG1HWVpYMlVKajE2V0pKTlhSQXlVb2hkUS9JVjh6anJJ?=
 =?gb2312?B?Ly9iN1dTVnJlRnQxaW00d3R2NmlxTVB4ZjJKZ0YxTUovMFVLU0hxVVNramE0?=
 =?gb2312?B?czlTSi9kbmJQTUd0ZTZubER2dWdIdmdBWVFsTWNwbWRjYU9kakt2WmUvTm1T?=
 =?gb2312?B?UzNuNTBIUG9ZdzVPN0xyOWtvVFRpcFA4R3l0blFVQ0d1RDh5U0lsUWRzeVlB?=
 =?gb2312?B?VFFxcXNTVHVFOXhLUks2eGJ3eENhdTArSjZXWFp4S1RLNUVrZmVPL2JMaXdG?=
 =?gb2312?B?RkliMSt1U3pkSTNtU1h2dzFid3JKNU0zOHRFQStMUHcrN3ErYmpkcHBPQUx0?=
 =?gb2312?B?eE5remMwYWNOMXJsRHFndmRsTzc1TVZ6bWs2aDZmdFh5UE9QOU13YzJ1c0VU?=
 =?gb2312?B?ZENHOW5oT0F5eUN0MU9LaU1wTkNvdVpvbXNQWGNjSkY3ZHdSRTVqc3BMY2VS?=
 =?gb2312?Q?AOMHX90wYexZeTko7MGNRpeLIcLLBGu2R9JXSmG?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34279e34-aba0-4df8-42df-08d924166800
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2021 09:28:10.1447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vIYsJ4NFlPsE6DiQhQtFqeJcBR0fzEHwVOIsr4My3A1bowURWiaR2kVeE+8g7rVA5k5rXa8GTjhFoDHw5xVcmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBUaGllcnJ5LA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFRo
aWVycnkgUmVkaW5nIDx0cmVkaW5nQG52aWRpYS5jb20+DQo+IFNlbnQ6IDIwMjHE6jXUwjI3yNUg
MjI6MjcNCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IENj
OiBmLmZhaW5lbGxpQGdtYWlsLmNvbTsgam9uYXRoYW5oQG52aWRpYS5jb207IHBlcHBlLmNhdmFs
bGFyb0BzdC5jb207DQo+IGFsZXhhbmRyZS50b3JndWVAZm9zcy5zdC5jb207IGpvYWJyZXVAc3lu
b3BzeXMuY29tOw0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IG1jb3F1
ZWxpbi5zdG0zMkBnbWFpbC5jb207DQo+IGFuZHJld0BsdW5uLmNoOyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIFYxIG5ldC1uZXh0XSBuZXQ6IHN0bW1hYzogc2hvdWxkIG5vdCBtb2RpZnkgUlggZGVz
Y3JpcHRvcg0KPiB3aGVuIFNUTU1BQyByZXN1bWUNCj4gDQo+IE9uIFRodSwgTWF5IDI3LCAyMDIx
IGF0IDA0OjQ5OjExUE0gKzA4MDAsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBXaGVuIHN5c3Rl
bSByZXN1bWUgYmFjaywgU1RNTUFDIHdpbGwgY2xlYXIgUlggZGVzY3JpcHRvcnM6DQo+ID4gc3Rt
bWFjX3Jlc3VtZSgpDQo+ID4gCS0+c3RtbWFjX2NsZWFyX2Rlc2NyaXB0b3JzKCkNCj4gPiAJCS0+
c3RtbWFjX2NsZWFyX3J4X2Rlc2NyaXB0b3JzKCkNCj4gPiAJCQktPnN0bW1hY19pbml0X3J4X2Rl
c2MoKQ0KPiA+IAkJCQktPmR3bWFjNF9zZXRfcnhfb3duZXIoKQ0KPiA+IAkJCQkvL3AtPmRlczMg
fD0gY3B1X3RvX2xlMzIoUkRFUzNfT1dOIHwNCj4gUkRFUzNfQlVGRkVSMV9WQUxJRF9BRERSKTsg
SXQNCj4gPiBvbmx5IGFzc2VydHMgT1dOIGFuZCBCVUYxViBiaXRzIGluIGRlc2MzIGZpZWxkLCBk
b2Vzbid0IGNsZWFyIGRlc2MwLzEvMg0KPiBmaWVsZHMuDQo+ID4NCj4gPiBMZXQncyB0YWtlIGEg
Y2FzZSBpbnRvIGFjY291bnQsIHdoZW4gc3lzdGVtIHN1c3BlbmQsIGl0IGlzIHBvc3NpYmxlDQo+
ID4gdGhhdCB0aGVyZSBhcmUgcGFja2V0cyBoYXZlIG5vdCByZWNlaXZlZCB5ZXQsIHNvIHRoZSBS
WCBkZXNjcmlwdG9ycw0KPiA+IGFyZSB3cm90ZSBiYWNrIGJ5IERNQSwgZS5nLg0KPiA+IDAwOCBb
MHgwMDAwMDAwMGM0MzEwMDgwXTogMHgwIDB4NDAgMHgwIDB4MzQwMTAwNDANCj4NCj4gVGhpcyBp
cyBzb21ldGhpbmcgdGhhdCBjb21wbGV0ZWx5IGJhZmZsZXMgbWUuIFdoeSBpcyBETUEgc3RpbGwg
d3JpdGluZyBiYWNrIFJYDQo+IGRlc2NyaXB0b3JzIG9uIHN5c3RlbSBzdXNwZW5kPyBzdG1tYWNf
c3VzcGVuZCgpIHNob3VsZCB0YWtlIGNhcmUgb2YNCj4gY29tcGxldGVseSBxdWllc2NpbmcgdGhl
IGRldmljZSBzbyB0aGF0IERNQSBpcyBubyBsb25nZXIgYWN0aXZlLiBJdCBzb3VuZHMgbGlrZQ0K
PiBmb3Igc29tZSByZWFzb24gdGhhdCBkb2Vzbid0IGhhcHBlbiB3aGVuIHlvdSBydW4gaW50byB0
aGlzIHByb2JsZW1hdGljDQo+IHNpdHVhdGlvbi4NClRoYW5rcy4gSSBkb24ndCB0aGluayBzby4g
c3RtbWFjX3N0b3BfYWxsX2RtYSgpIGluIHN0bW1hY19zdXNwZW5kKCkgdG8gc3RvcCBSWCBETUEs
IFJYIGRlc2NyaXB0b3JzDQpoYXZlIGJlZW4gd3JvdGUgYmFjayBiZWZvcmUgc3RvcCBETUEsIGFu
ZCB0aGVzZSBkZXNjcmlwdG9ycyBoYXZlIG5vdCBiZWVuIGhhbmRsZWQgeWV0LCBzbyB0aGV5IHN0
YXkgdGhlcmUuDQoNCkV4cGxhaW4gbW9yZSBkZXRhaWxlZCwgTkFQSSBzY2hlZHVsZWQgZmluaXNo
ZWQsIERNQSByZWNlaXZlIGZyYW1lcyBhbmQgd3JpdGUgYmFjayBSWCBkZXNjcmlwdG9ycywgYnV0
IFJYIGludGVycnVwdA0KZG9lc24ndCBpc3N1ZSB5ZXQsIHN5c3RlbSBzdXNwZW5kaW5nLCBzdG9w
IFJYIERNQS4gQWZ0ZXIgc3lzdGVtIHN1c3BlbmRlZCwgUlggZGVzY3JpcHRvcnMgaXMgdGhlIHdy
aXRlIGJhY2sgZm9ybWF0Lg0KICANCj4gSSBzZWUgdGhhdCBzb21lIHBsYXRmb3JtIGFkYXB0YXRp
b25zIG92ZXJyaWRlIHRoZSBETUEgLT5zdG9wX3J4KCkgY2FsbGJhY2sNCj4gKHNlZSBkd21hYy1z
dW44aS5jIGFuZCBkd3hnbWFjMl9kbWEuYyksIHNvIHBlcmhhcHMgc29tZSBzaW1pbGFyIG92ZXJy
aWRlDQo+IGlzIHJlcXVpcmVkIG9uIHlvdXIgcGxhdGZvcm0gdG8gYWN0dWFsbHkgc3RvcCBETUE/
DQpJIGNoZWNrIHRoZSBkcml2ZXIgeW91IG1lbnRpb25lZCwgaXQgc2VlbXMgdGhleSBoYXZlIFNv
QyBsZXZlbCByZWdpc3RlcnMgdG8gY29uZmlndXJlIERNQS4gQnV0IGkuTVg4TVAgZG9lc24ndCBp
bXBsZW1lbnQgaXQuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiBUaGllcnJ5DQo=
