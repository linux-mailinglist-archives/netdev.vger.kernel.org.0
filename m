Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE7837F80A
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 14:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhEMMhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 08:37:45 -0400
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:33137
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232321AbhEMMhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 08:37:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dIMFnDhTsk7/lYocqr2ohYolMq1p269KEVjFnWS7nhtswv9DXkiKx+tmKoj+zGKSqTINP4baDFkCAZ5a8XFPja69OHUN8gYEwo631qJlkXWUpzpJByjsUFahpma9tS8NSRAKKeRMNXmzjKthoy9gz72aRugHeSWxz/Cj2bb3CUHICGH/0zVuF63jSLZdf19BzES/BBNv4rPKR4NOAU+yn2AOwzbRlfPMSLTKeU82DvH3cOpU8HFUGNCEwGjEWQxIEq8BWCD/xiV/Yu2Px7ekzXsPvlh96xtUoMwXbSW0ku07zq3yswO/ElN12V1lHWNr0s4BAjGH7lJNtbqWPwri2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUy+QjncLFyi16MAR1bcwo7U8Mm0nw8Zu5b9wn2/azI=;
 b=L5vQNyZLc+bv7pDdkoFzkVhq/IV+2pc6kGx1uKt85rMdzdjN4Mpxq8u9scM5Y9qTKLDNE5YM7TflLO1CI6Kb+DWLrpXPfurqGQ/g44aSS/6WeVB61B2RsUIBAQ0rEjboDnwUTNj2ucGQLIWTAA33PLElMfOtduyEKgTGGKm756mGrG2BE3E1uobCJHzz7UMYUYq5PakbAa4V1hdKou2UwCWCTlNCbhEJVQIHJy16mZpXbLrAYw9zLRt70zy4TNms7yNLN/W/R8xqRfHdHzgHs47n8w5Vq+Iz81Q3o3JxEDEAuzx6p2uhdckFIamIavGET5HSZR3MY+dr7+TXPtuBAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUy+QjncLFyi16MAR1bcwo7U8Mm0nw8Zu5b9wn2/azI=;
 b=UG/YcVP0+NUQWZsWaVJf75VUcyBYHzmdl/5jyGQFSmnJHPyRFpwdV4WWgmDk/k8EI8PvBvh3Sz8pH8yhWIbQiCTiZ0LUtzs5/3wjx9uDz/WlKgGQNJ70femPk3YLQGx15+r1TOAR6D+MAbUAZAoJOngpRLhGfP+aRlqHkHbjdC4=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2904.eurprd04.prod.outlook.com (2603:10a6:4:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Thu, 13 May
 2021 12:36:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4129.025; Thu, 13 May 2021
 12:36:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: i.MX8MM Ethernet TX Bandwidth Fluctuations
Thread-Topic: i.MX8MM Ethernet TX Bandwidth Fluctuations
Thread-Index: AQHXQoZ/tVGcom8wzE+eoQ5m9ZEBXqrfxlLQgAGKcaA=
Date:   Thu, 13 May 2021 12:36:28 +0000
Message-ID: <DB8PR04MB67958B0138DDDDEAD20949FAE6519@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
 <DB8PR04MB67957305FEAC4E966D929883E6529@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB67957305FEAC4E966D929883E6529@DB8PR04MB6795.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kontron.de; dkim=none (message not signed)
 header.d=none;kontron.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ee10086-c84f-46d4-80f3-08d9160bbaf4
x-ms-traffictypediagnostic: DB6PR0402MB2904:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB290441374271AB8B3B4B7E60E6519@DB6PR0402MB2904.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vn1fmt0AhakAFW50hscANK4xNbfe4fOMcfe5l1E8KNQKjOqM7vXkCP+vivasHNkvZikvkPU51U8R1ChwaHRH0ot1O5jwdVT8CNOGZCLTGD66NOQuklHd0L1k8o9wPsbrfeVx0hRZXK+YKwlnWN9BFh0CWYGq6AjmP4hGUPrvRjqq+K1hwJpfht09BqevfHGB+MIMEogFLJocNKmzP20TztemRR5TQL0ojMTi0OXvcghHkbK1d6VCcPYu8yCj19SggSMJWM0iSHGqQku+BBzanWAjqeKC50aApJqWieXglocG4ZIP0lz4JHRUMWuOaODzpY1KeGyMiDHPNegUlSnPsek8JyvtkW6VE1eCEIgsP3EoLki8GlCSEX3DGgL9YFwT8OVCRpSk71iEPWxyLNlyD9KbPtFgiaEqgefKd0+sGYmA/Wjwkc3QajLXuI07Jzv/WMZFMmdMauusT7FO+fz/cOGbwtR1sTuUgjNSynGIjKHeR/eybXTYyB18RIDofGiepDCnfVP5uCdSfEpPQKClfZ3NNq/ZZUXIhRFEJ4+VLPR9ikT2qiUtDuTOJYzLQPgB1jpQjiRGZBGzo1O2pVCjUJk3eDIW+UVhwuhRxaCyw1vuAJA8u1M3YWeFfaBUlVD7IVwBFUORz1qWeVDctAd/i3BJyHjiFv4AGDEyIKKuGgUo834rGVtiITAcQddngYBy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(45080400002)(71200400001)(186003)(478600001)(66556008)(76116006)(26005)(8676002)(5660300002)(66476007)(64756008)(8936002)(52536014)(33656002)(6506007)(966005)(110136005)(316002)(66946007)(9686003)(66446008)(7696005)(122000001)(83380400001)(38100700002)(55016002)(2906002)(53546011)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?Rkxiemh1NHBMUEx6TXZ1NTV4dzliT2h2YXpMOG8zTERIbW1NaXR6OWUxU1NP?=
 =?gb2312?B?RFpaakdEODAzMlJjcmt6eVhidlB5emJjUHJEN09kWTE4bVJnd2lhaW9XazJ1?=
 =?gb2312?B?cjBYMGl5M1ZoY3BPeDkxR2ZWbEpnaTR0VUJHUUJ0Y0NUdmNEbUlhQzR0R1di?=
 =?gb2312?B?bWNORjlpRGZYc3Z0SE1tQVhycVJJc3dSanhIa1hMdXZqSWtLOEZ6SXZsSU9h?=
 =?gb2312?B?Q3VsRXpyaHlTZjBkM2dBZmNmT3k5T3BYa2Mwd2MrVk0rblh1Tk1QUnZocmdL?=
 =?gb2312?B?bjhPYzRsZTBIQkV5KzkvMzRsSEc2YmNMQkhHc0lHdHp2VFhTbndIRXFBOHky?=
 =?gb2312?B?b1pkSTNONWN5TmlRZThaZmtiSURONnRFQmJTRTZrTlFjZU5QWGc2ckpQVjJ4?=
 =?gb2312?B?YTQ1MWZDRDBoY3RQbDV0TjRlYVVOV25WSGFOdmVQTjFCZ256R0E5WmZ2ZGZL?=
 =?gb2312?B?S2hMNWNmU0hzNDJGQ3VlN3NXaG1UdEF0andpR1ZVTUpqODJJZmRnL0xPTjgy?=
 =?gb2312?B?bUNONStmZ01xM0VzWEZ4TExlWkN6YUEwblhEYlVaOHhRckNDSTNLb3lPOHM2?=
 =?gb2312?B?dEl1WXRpR2JFUXNzb2ZpQWF6R1FnMTEyMGhSQnVhYy96YU9jcHN5WFJMSkJ0?=
 =?gb2312?B?UnZkdDhuSE45enBZV29lakhuTDdlZldOb1ZRVG9VMmNEUWJnM1NJWjZNUEVv?=
 =?gb2312?B?ajhnM0U1aHAxeFpEVnV3N2VtS2MrV2VlbDJLbUlvSG12SklXdTJMbVRZcjlP?=
 =?gb2312?B?VmdzMHB2TDhRM2xzUnJFbmUwc1gweS9vbVZlTlRNNEt1b2lTa2ZVQWo3NlFx?=
 =?gb2312?B?cjhPZjc4VWRzcnRlc2FFV2pXemg0ell3d0dLUWpOZHo1SzVSZGo3SGdBWEx1?=
 =?gb2312?B?djBLcFFJTjNqbkkySkt5a3VnYk8vc0pnSkVjd3Z6UXR0WEFWNDlZbC9WY0x1?=
 =?gb2312?B?WGlTUGpxcE1RaEdSYzA0bWRYQWdITHRSNmxwUnFGOFZ6NkI1RkFlSWljZFRK?=
 =?gb2312?B?SURGbXc2aUZoeVBPSnQ2c1h5MnYvSHcvdDVLNXlPNHNkcEVyVlVZVWlUQ1U0?=
 =?gb2312?B?akpIRm1aVlUzTzR0Q3Rvcm8yaURrbG5oeEowTlliYmFiQnM3d2R4S2ZPQStR?=
 =?gb2312?B?a3ZMWlNERGp6NG9aRnlFUGVVemdvbEZCZkxKTHhiR3lYa0c4TW9ITjdIMkZi?=
 =?gb2312?B?QzJwYURrdG1rZ0QydUptVy9QZmcwR242dnMweUFLMnhxSGJ4VndxUjFlTUQr?=
 =?gb2312?B?WUtHL0VXc2hPeTVCU1AwSWplTkJsU2FKOHpkTUZJTm5CRjFrZStMeUNvaEYy?=
 =?gb2312?B?RE9RQmdwR1Jjb0lBRU1KcXlaMHNnaXM2VFRialMxdTl5MkpLejlzY0FKVlRs?=
 =?gb2312?B?bUs1NVNjM2RnZHZhSnhNUVN5NkdHRlNKY3VVNGxBaDFXbDF0VWtlaFNCRUhO?=
 =?gb2312?B?NVNDNzdMWHVXVHRsOGdjMWNrVkgzMjk4dmVNekx6alZkZnlmL0VHeDVlYlZr?=
 =?gb2312?B?VXZTdDNHSExnZ25lQ3dHZFB0ZHpWZTlmNXpKL3RXcFFLa0Q1RDliK1RFakFT?=
 =?gb2312?B?ZjhDb3JNQllhL2M5bmgrV2o2WVFmNDhjVEVuTGttazlyNkVkYTRGTkx6Wk5X?=
 =?gb2312?B?ZDNnSVJKWCsvMWFqaHFtZy80YkJzVDNvejk4WXRvVUptN0U1Um1kdTZEVXVr?=
 =?gb2312?B?MG5KeXdGSjlsS3l4cEZRY2RqMU9LWXhMd0NHd3MxbEVnYTdYTVZNYUpxY1VO?=
 =?gb2312?Q?FAOwgYhBS4Y+/zhp7eCTlShvMSfaTRAiWfUC1SW?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee10086-c84f-46d4-80f3-08d9160bbaf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 12:36:28.4930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T3XyC0ZArOx99iMxK+8LPnIPvEXeiDPCcas69RXy/j4mEba2Xmu2kZQPm2LwmCp/TaaeXP/iLhqAnNrpr0ODpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2904
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGcmllZGVyLA0KDQpGb3IgTlhQIHJlbGVhc2Uga2VybmVsLCBJIHRlc3RlZCBvbiBpLk1Y
OE1RL01NL01QLCBJIGNhbiByZXByb2R1Y2Ugb24gTDUuMTAsIGFuZCBjYW4ndCByZXByb2R1Y2Ug
b24gTDUuNC4NCkFjY29yZGluZyB0byB5b3VyIGRlc2NyaXB0aW9uLCB5b3UgY2FuIHJlcHJvZHVj
ZSB0aGlzIGlzc3VlIGJvdGggTDUuNCBhbmQgTDUuMTA/IFNvIEkgbmVlZCBjb25maXJtIHdpdGgg
eW91Lg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg0KPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29t
Pg0KPiBTZW50OiAyMDIxxOo11MIxMsjVIDE5OjU5DQo+IFRvOiBGcmllZGVyIFNjaHJlbXBmIDxm
cmllZGVyLnNjaHJlbXBmQGtvbnRyb24uZGU+OyBkbC1saW51eC1pbXgNCj4gPGxpbnV4LWlteEBu
eHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgtYXJtLWtlcm5lbEBsaXN0
cy5pbmZyYWRlYWQub3JnDQo+IFN1YmplY3Q6IFJFOiBpLk1YOE1NIEV0aGVybmV0IFRYIEJhbmR3
aWR0aCBGbHVjdHVhdGlvbnMNCj4gDQo+IA0KPiBIaSBGcmllZGVyLA0KPiANCj4gU29ycnksIEkg
bWlzc2VkIHRoaXMgbWFpbCBiZWZvcmUsIEkgY2FuIHJlcHJvZHVjZSB0aGlzIGlzc3VlIGF0IG15
IHNpZGUsIEkgd2lsbCB0cnkNCj4gbXkgYmVzdCB0byBsb29rIGludG8gdGhpcyBpc3N1ZS4NCj4g
DQo+IEJlc3QgUmVnYXJkcywNCj4gSm9ha2ltIFpoYW5nDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogRnJpZWRlciBTY2hyZW1wZiA8ZnJpZWRlci5zY2hyZW1w
ZkBrb250cm9uLmRlPg0KPiA+IFNlbnQ6IDIwMjHE6jXUwjbI1SAyMjo0Ng0KPiA+IFRvOiBkbC1s
aW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4g
PiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gPiBTdWJqZWN0OiBpLk1Y
OE1NIEV0aGVybmV0IFRYIEJhbmR3aWR0aCBGbHVjdHVhdGlvbnMNCj4gPg0KPiA+IEhpLA0KPiA+
DQo+ID4gd2Ugb2JzZXJ2ZWQgc29tZSB3ZWlyZCBwaGVub21lbm9uIHdpdGggdGhlIEV0aGVybmV0
IG9uIG91ciBpLk1YOE0tTWluaQ0KPiA+IGJvYXJkcy4gSXQgaGFwcGVucyBxdWl0ZSBvZnRlbiB0
aGF0IHRoZSBtZWFzdXJlZCBiYW5kd2lkdGggaW4gVFgNCj4gPiBkaXJlY3Rpb24gZHJvcHMgZnJv
bSBpdHMgZXhwZWN0ZWQvbm9taW5hbCB2YWx1ZSB0byBzb21ldGhpbmcgbGlrZSA1MCUNCj4gPiAo
Zm9yIDEwME0pIG9yIH42NyUgKGZvciAxRykgY29ubmVjdGlvbnMuDQo+ID4NCj4gPiBTbyBmYXIg
d2UgcmVwcm9kdWNlZCB0aGlzIHdpdGggdHdvIGRpZmZlcmVudCBoYXJkd2FyZSBkZXNpZ25zIHVz
aW5nDQo+ID4gdHdvIGRpZmZlcmVudCBQSFlzIChSR01JSSBWU0M4NTMxIGFuZCBSTUlJIEtTWjgw
ODEpLCB0d28gZGlmZmVyZW50DQo+ID4ga2VybmVsIHZlcnNpb25zICh2NS40IGFuZCB2NS4xMCkg
YW5kIGxpbmsgc3BlZWRzIG9mIDEwME0gYW5kIDFHLg0KPiA+DQo+ID4gVG8gbWVhc3VyZSB0aGUg
dGhyb3VnaHB1dCB3ZSBzaW1wbHkgcnVuIGlwZXJmMyBvbiB0aGUgdGFyZ2V0ICh3aXRoIGENCj4g
PiBzaG9ydCBwMnAgY29ubmVjdGlvbiB0byB0aGUgaG9zdCBQQykgbGlrZSB0aGlzOg0KPiA+DQo+
ID4gCWlwZXJmMyAtYyAxOTIuMTY4LjEuMTAgLS1iaWRpcg0KPiA+DQo+ID4gQnV0IGV2ZW4gc29t
ZXRoaW5nIG1vcmUgc2ltcGxlIGxpa2UgdGhpcyBjYW4gYmUgdXNlZCB0byBnZXQgdGhlIGluZm8N
Cj4gPiAod2l0aCAnbmMgLWwgLXAgMTEyMiA+IC9kZXYvbnVsbCcgcnVubmluZyBvbiB0aGUgaG9z
dCk6DQo+ID4NCj4gPiAJZGQgaWY9L2Rldi96ZXJvIGJzPTEwTSBjb3VudD0xIHwgbmMgMTkyLjE2
OC4xLjEwIDExMjINCj4gPg0KPiA+IFRoZSByZXN1bHRzIGZsdWN0dWF0ZSBiZXR3ZWVuIGVhY2gg
dGVzdCBydW4gYW5kIGFyZSBzb21ldGltZXMgJ2dvb2QnIChlLmcuDQo+ID4gfjkwIE1CaXQvcyBm
b3IgMTAwTSBsaW5rKSBhbmQgc29tZXRpbWVzICdiYWQnIChlLmcuIH40NSBNQml0L3MgZm9yIDEw
ME0NCj4gbGluaykuDQo+ID4gVGhlcmUgaXMgbm90aGluZyBlbHNlIHJ1bm5pbmcgb24gdGhlIHN5
c3RlbSBpbiBwYXJhbGxlbC4gU29tZSBtb3JlDQo+ID4gaW5mbyBpcyBhbHNvIGF2YWlsYWJsZSBp
biB0aGlzIHBvc3Q6IFsxXS4NCj4gPg0KPiA+IElmIHRoZXJlJ3MgYW55b25lIGFyb3VuZCB3aG8g
aGFzIGFuIGlkZWEgb24gd2hhdCBtaWdodCBiZSB0aGUgcmVhc29uDQo+ID4gZm9yIHRoaXMsIHBs
ZWFzZSBsZXQgbWUga25vdyENCj4gPiBPciBtYXliZSBzb21lb25lIHdvdWxkIGJlIHdpbGxpbmcg
dG8gZG8gYSBxdWljayB0ZXN0IG9uIGhpcyBvd24gaGFyZHdhcmUuDQo+ID4gVGhhdCB3b3VsZCBh
bHNvIGJlIGhpZ2hseSBhcHByZWNpYXRlZCENCj4gPg0KPiA+IFRoYW5rcyBhbmQgYmVzdCByZWdh
cmRzDQo+ID4gRnJpZWRlcg0KPiA+DQo+ID4gWzFdOg0KPiA+IGh0dHBzOi8vZXVyMDEuc2FmZWxp
bmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRmNvbW0NCj4gPiB1
DQo+ID4NCj4gbml0eS5ueHAuY29tJTJGdDUlMkZpLU1YLVByb2Nlc3NvcnMlMkZpLU1YOE1NLUV0
aGVybmV0LVRYLUJhbmR3aWR0aC0NCj4gPg0KPiBGbHVjdHVhdGlvbnMlMkZtLXAlMkYxMjQyNDY3
JTIzTTE3MDU2MyZhbXA7ZGF0YT0wNCU3QzAxJTdDcWlhbmcNCj4gPg0KPiBxaW5nLnpoYW5nJTQw
bnhwLmNvbSU3QzVkNDg2NmQ0NTY1ZTRjYmMzNmEwMDhkOTEwOWRhMGZmJTdDNjg2ZWExZA0KPiA+
DQo+IDNiYzJiNGM2ZmE5MmNkOTljNWMzMDE2MzUlN0MwJTdDMCU3QzYzNzU1OTA5MTQ2Mzc5Mjkz
MiU3Q1Vua25vDQo+ID4NCj4gd24lN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3TURBaUxD
SlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMWhhDQo+ID4NCj4gV3dpTENKWFZDSTZNbjAlM0QlN0Mx
MDAwJmFtcDtzZGF0YT15Z2NUaFFPTEl6cDBsemhYYWNSTGpTam5qbTFGRWoNCj4gPiBZU3hha1h3
WnR4ZGU4JTNEJmFtcDtyZXNlcnZlZD0wDQo=
