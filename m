Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4317738FE19
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 11:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhEYJsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 05:48:35 -0400
Received: from mail-eopbgr140059.outbound.protection.outlook.com ([40.107.14.59]:40164
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232695AbhEYJsd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 05:48:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgLYyq80SH0gAmyunsQKa+sjdRvUqR3cefee656VTgP9Q6KAGMMsAFxFCAx58IxgCpla5nd567WEmlFsYa66zPA8nxWZzIIRuqB8pFDsPAEk/xvNbpGJs8wa7ZPW1l1UNwi8o/wEc6kvjqLVITVpWwj/K9jLjM/VIv1TGsFEtbiLqMLC4pimQ9K6oPbyp9j2pSVjYBXOYM6n6C9o+AKrcDdfE3cgF94fzt9JmbaGL59MslkzesjVQnH+AocXWD/xblFKEGuox3yEyRowKvMzC0emem8fg9EBtWOwYNSzV8eduHlZiqvKhOWK/3J7sKiEqbV0sUdmgAYiNg6bFBgxog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbSb3EAy1c3In1TIpL3tgmZmV7ehDSe7hCZj+ah3syQ=;
 b=BIj0l2CTJegVjScvSeq9cRm56SAkyzVjeNbcD570KZBbl8LEkWc+p9+MpFHmbtbIrG0YoPpXZJ/KzytQ3niprVfnW1rTxfWa9qJ6jycp2pY/nU3k2/6BhC+V9ERDp/ao4bti1NraGVgvbQIJdMyWNfBExZhZODp/+qJTbb1ROhx24Xq/6YcyH2f0Zv7Ts56DR9ZGevipRT0hdLZtDzhfmOrb3fOeU7WrvuqaQmeDIyQ4H8ol3mDoT5moPkV74Po3Nqg2YC04Wzyf+f7xKtTucmb6i2ObilGnmxfbo75DPgWstn9l9FiVR2qlClbf8ofZ/yicvehtR/wpBWUyOK8AaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbSb3EAy1c3In1TIpL3tgmZmV7ehDSe7hCZj+ah3syQ=;
 b=RJE16Qi7tp338sJjP2BQvjI7WJ9E1LjEblghXEB+/HaiKJB8Y2R+vSU6t/EkiuqODhvUhwbnI4O2jKzPMApXBB5ImhrESMTp2kFs+hpC+qiZY3XeBIJExpnvab+sc/Df5qBd3lhbyWk2HK/bzX0fPtbyojd0EN+mH3WiaHeM8fw=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Tue, 25 May
 2021 09:46:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 09:46:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [RFC net-next 2/2] net: fec: add ndo_select_queue to fix TX
 bandwidth fluctuations
Thread-Topic: [RFC net-next 2/2] net: fec: add ndo_select_queue to fix TX
 bandwidth fluctuations
Thread-Index: AQHXT708BKGTZN/11k693vD2JZ2LfqrxJUUAgAJjs/A=
Date:   Tue, 25 May 2021 09:46:27 +0000
Message-ID: <DB8PR04MB67957EA8964DB8CE625F6CFFE6259@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210523102019.29440-1-qiangqing.zhang@nxp.com>
 <20210523102019.29440-3-qiangqing.zhang@nxp.com> <YKpqtK7YBVFnqRSw@lunn.ch>
In-Reply-To: <YKpqtK7YBVFnqRSw@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57aedb4f-f8e6-4351-55ff-08d91f61f7e9
x-ms-traffictypediagnostic: DBAPR04MB7333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB7333BF0A0A6F22453D79F5C1E6259@DBAPR04MB7333.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7f07Zru903Nouw9D42c/E2Gwhdmo6GHnRI+xhNzwZlCuz4OTea8wI1+kQ9iMOW8DKYHlDj5clFL/vNkXXZjohr5Raw3O6xr8UXevV6/QlrMjlsn17OXBove4RFgX+txZH76O9a4iSPthixcB59bz0Dw/TE990UiTkHXzZOVD0NzAYIskESlKTTdEof4aGJnZDR2C2Tmzoeq4x0P/0It6vegtiFiiRolqjAKTBFpbbF+8GfJpZ0W6qEri6joyoUmz6HPbbdTVvxpKl77+ivNOse7qA4m0q/zZ7K8NaTb1MYg10wqA2R+biy6xieGwXhsT6blyykJW7VQKVf5M0Vq2vuUN9MWrZfraiVINV0AIktqvVXm5g8GuYwqobGRL9ys4LooC2Lw2LnshmePeD60lNEjrv1wpWhF2BfDxO4+M9IzT2BqJql/JkDGSTl8x3p5edSa9lDMzQv9AcnanHVLmCIUcot+EK6fFhcMJVEco4EqFGA9n9kRai6rqBTd6A7Dft6kov/hVo5toU7vosnQ2aiNpfiTYBmNtJCCM4Ir1ZcIr4q9chK/A3JBwttPxgpqkWmIdF5owbv4I79wVqnyTr0GULu/NCr5dxEec9lsiOWE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39850400004)(136003)(376002)(346002)(53546011)(8676002)(9686003)(478600001)(8936002)(76116006)(186003)(55016002)(66946007)(5660300002)(7696005)(71200400001)(6916009)(83380400001)(33656002)(54906003)(316002)(4326008)(6506007)(66446008)(2906002)(38100700002)(64756008)(66556008)(86362001)(52536014)(26005)(66476007)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?cFh2WWtTM1dFL2N1Z003WmlQM0pCRGwvV1gweEZxbnh1TkxmQmlKK0VWRDNk?=
 =?gb2312?B?NDZzUlNDK0xjczA4NUprNkoyNTVYYm9RZ01WNHVzaytxTENFcHl2bFlGK3E1?=
 =?gb2312?B?Wm9qcnhDQUd0YXlGRm9JYlRERUZ6WWZtSjJTbHlDU3pXbGQzZVJwRHYwN2d0?=
 =?gb2312?B?S2U5ZCs1Zm0vRDZteEtBdllFRWRWM2twQjhSTy9pZ2Z0YmF5WlQvMmpzTlcv?=
 =?gb2312?B?SVBXK2Vqd1g4YlNmREh6a3NmWVYyckVMSWJiZTdUSUN3aGF4dkh4T1Y2OHJS?=
 =?gb2312?B?S0ZMcDhrVGdsS25BU1h5Mnp2anN1MnQ2OUJLQ01qZkZGVzlkVitBMmZ2NzJa?=
 =?gb2312?B?NHJ2ODV5TjBhZjBuTHpTSGtmc2JINEd1d1FLb0NJbWhyT1VMN05NV0VvWm5C?=
 =?gb2312?B?eDErZWtpUG55aVQ2QkxLcm9NaXJEbi81ZTZJVzVqN1FkaVpkdkMxai8vMS9x?=
 =?gb2312?B?alh3cU93aDUxUHVlRGYrK1VVZWUwV2hJRFdZc2VkTGZBQVk1b1JFcEpQSjA2?=
 =?gb2312?B?VFVsNVY4Rmd3c1VzcXdVQSthdFJhYXk1a1U4SG93VjZ1c3NNUzdBcGJnemFy?=
 =?gb2312?B?bTNDNThjT3g5ZHg4MHlDNFpjK1RZN2tVSUZ4LzduNWY5b2RaTlUzS1NTdXRG?=
 =?gb2312?B?WTlOYlA0OWtVUFpHdWV3bEFVYjRTZTM3R1c5aEdvWmFQT3pyQ0hYMmxRblFP?=
 =?gb2312?B?MUJMbUk3L1NBYVFZeStwWEJZZDlTNzFHWmgvbG80R3JRN2E2L3RuNUVhcWxo?=
 =?gb2312?B?R09SdmllWXRJTjFyVkNaOXJocnlvaFViM05RRnF3K1lzcERkbTQvL21zdlRT?=
 =?gb2312?B?R2tFbWV2SnRSbUFZV252TXk5SU5MZmo2WXF3RU5yQ2tBMmIrQk1mK0VwR3A2?=
 =?gb2312?B?ZUZJOGVuem0wVGN0YTBSRjFZOGF1NmcrWWdOdjhVOEd4aWgva1B6M3NrNDlC?=
 =?gb2312?B?dFVjREtIcDJRTW1RcFB5N090UjdSQkNBRG05QmZUL3hIbDZQUk1sVjlFZld2?=
 =?gb2312?B?VWpwVFdUNUFMQVdJSDlJTWJxdWNNZ01TMlJwOUlLS2ZKUmJCbGRXSHMyNHp6?=
 =?gb2312?B?Y0tKUVB4WHlSeW5DV2l3eHQxeVdTcFdVQUZ6cFBwNFJVb2RBM2dtYW03TGlT?=
 =?gb2312?B?UHBaeUJDR01VZWR0WGN0RzdzS3ZzTG1IQkxDaFNVVEJiT3k0NlBwZFdqOVQy?=
 =?gb2312?B?UWR5aU9TOTE1bXh6U0pZWlF2WEFsTnNoeG9scVFTNmJud3d1Y3Rub3pxYmw3?=
 =?gb2312?B?UGlRWXJ5QUFsWlA0VWRNUlVXdlpxb3F4RjNGOW85TWVmaGE2bWVBSXdhS3Ay?=
 =?gb2312?B?dUVvVGNWMlpQU2o3UWRNMENEVlc5NUVBSEJBb2VNM3l4a3MwY2Y5Q2F3eWdw?=
 =?gb2312?B?Ry8ySElyaWgxdHBidlkwbVI1bzJpL3AzZFQyRDJyNjhhamcvRVQvcnNONUpQ?=
 =?gb2312?B?Ym52S1ZuOUJSR1BCTXQxNTRkL1FnNGN3VkQwWFVLZnFuSWN4SnNuUHNSOXRy?=
 =?gb2312?B?YUx6VVZLaVd6ZDFDTXZBK3JPdzRCeFplTy9KZnRxT0k4dFhiNzRaSW1SNTNq?=
 =?gb2312?B?aTZ2Umo1Z1V2ZnBrdHE4WFJHT214R2l3Ulh2Q1craHpaczl3Nys5Q3V4VCtm?=
 =?gb2312?B?Y1ZUaCtNT3hjRE9KWTV0cGdza1ZkblllTGExTEhEQ0Z0bGRIUDR0RnBkamJE?=
 =?gb2312?B?RG9OSTdCT1lCMGxudmI2V0FGb21Ick1HL1dXeE42Vm5COUVINkg5RjBJQWkr?=
 =?gb2312?Q?OXjI2YZpKZZl4zm74Ek3hNDSCsDqzFUV9wYrcog?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57aedb4f-f8e6-4351-55ff-08d91f61f7e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 09:46:27.7873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6m2hYOcrnqMrEPa54nPDms7TwwMPQDQ3Laa75z5biw5daaqsqIzEFNIugXva/lbUvC/RwJrjS5E3Q3rzMFGhWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbmRyZXcsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5k
cmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIxxOo11MIyM8jVIDIyOjQ2DQo+
IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogZGF2ZW1A
ZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBmcmllZGVyLnNjaHJlbXBmQGtvbnRyb24u
ZGU7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IGRsLWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54cC5jb20+DQo+IFN1YmplY3Q6IFJlOiBb
UkZDIG5ldC1uZXh0IDIvMl0gbmV0OiBmZWM6IGFkZCBuZG9fc2VsZWN0X3F1ZXVlIHRvIGZpeCBU
WA0KPiBiYW5kd2lkdGggZmx1Y3R1YXRpb25zDQo+IA0KPiBPbiBTdW4sIE1heSAyMywgMjAyMSBh
dCAwNjoyMDoxOVBNICswODAwLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4gRnJvbTogRnVnYW5n
IER1YW4gPGZ1Z2FuZy5kdWFuQG54cC5jb20+DQo+ID4NCj4gPiBBcyB3ZSBrbm93IHRoYXQgQVZC
IGlzIGVuYWJsZWQgYnkgZGVmYXVsdCwgYW5kIHRoZSBFTkVUIElQIGRlc2lnbiBpcw0KPiA+IHF1
ZXVlIDAgZm9yIGJlc3QgZWZmb3J0LCBxdWV1ZSAxJjIgZm9yIEFWQiBDbGFzcyBBJkIuIEJhbmR3
aWR0aCBvZg0KPiA+IHF1ZXVlIDEmMiBzZXQgaW4gZHJpdmVyIGlzIDUwJSwgVFggYmFuZHdpZHRo
IGZsdWN0dWF0ZWQgd2hlbiBzZWxlY3RpbmcNCj4gPiB0eCBxdWV1ZXMgcmFuZG9tbHkgd2l0aCBG
RUNfUVVJUktfSEFTX0FWQiBxdWlyayBhdmFpbGFibGUuDQo+IA0KPiBIb3cgaXMgdGhlIGRyaXZl
ciBjdXJyZW50bHkgc2NoZWR1bGluZyBiZXR3ZWVuIHRoZXNlIHF1ZXVlcz8gR2l2ZW4gdGhlDQo+
IDgwMi4xcSBwcmlvcml0aWVzLCBpIHRoaW5rIHdlIHdhbnQgcXVldWUgMiB3aXRoIHRoZSBoaWdo
ZXN0IHByaW9yaXR5IGZvcg0KPiBzY2hlZHVsaW5nLiBUaGVuIHF1ZXVlIDAgYW5kIGxhc3RseSBx
dWV1ZSAxLg0KDQpJIHRoaW5rIGN1cnJlbnRseSB0aGVyZSBpcyBubyBzY2hlZHVsZSBiZXR3ZWVu
IHRoZXNlIHF1ZXVlcyBpbiB0aGUgZHJpdmVyLg0KDQpDb3VsZCB5b3UgcGxlYXNlIHBvaW50IG1l
IHdoZXJlIEkgY2FuIGZpbmQgbWFwcGluZyBiZXR3ZWVuIHByaW9yaXRpZXMgYW5kIHF1ZXVlcz8g
WW91IHByZWZlciB0byBiZWxvdyBtYXBwaW5nPw0Kc3RhdGljIGNvbnN0IHUxNiBmZWNfZW5ldF92
bGFuX3ByaV90b19xdWV1ZVs4XSA9IHsxLCAxLCAwLCAwLCAwLCAyLCAyLCAyfTsNCg0KQmVzdCBS
ZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+ICAgICBBbmRyZXcNCg==
