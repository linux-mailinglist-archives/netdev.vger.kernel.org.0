Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC6539ED0D
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhFHDZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:25:00 -0400
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:54240
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231228AbhFHDZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:25:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIm5ymVk3rd2Vq9R5QZUHaP8aSvDN4N9ZpDYPeWFOo1kAmArm71PSqotZe8L3aJs7Z4TTpMgWYg7GbMw4wMXfJfIj5cBvysfG08sc+sTDLZPLkk12iLew+2HBxKX0Xz9ZBNv4qR5ITc1XwJ/q1qV99KXHr/mncArbTVhNokU6IDyYTPxIWrwjyXcZ9LpSDUgQKRYW8y3QPg5zR6ZryCwfgl6kPE2ofMQCz9YRPcLfRyFwXL8OjciQ2JpHnnDGGqcJo2av1kCQbYICaY6IDsHeChIbEdop7aDp2Cpc3A0KaRrRck6Tf/r7a3esrdpvkqqCwu9Q4Bsw+PBuYIUK9wg8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57ZsbmAp3tsrf0NnxY2KG3xPAvCM9d4eSWl9r8Blzwg=;
 b=CZOKLZUnBDAptw4jmaDzPpFRuD5SIiwh3SNQczEV330cRw0qIDHExvyXNUWdgVIurNbu43hOWxOtcNlDXSobDHKW0wqFNGB14Q4BjlRMNxRsfRSy/Gyv8Xx1nELGGr0ZetAz9PNvn0LcjTYqEUNEfiobE8fPdFvQgxptZsC2lXthRb7WKKbJXegsVMtyKHf2fNb6LlejVBMaKB4EzZqiv1hF0B/6UxB+1KH3xnIRW/NILk+WeIHMZcK15CoBYzeMT3CGjjwGXZkxtC9Emc4S2pcmDoBCHVdHJ7lQ8rOBtyA/onp4ngooFGt8xZ3WK8TOfuk9mCBFVw7eoYrL7U5FEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57ZsbmAp3tsrf0NnxY2KG3xPAvCM9d4eSWl9r8Blzwg=;
 b=Whgp0FIDTdSev792CNV2iss/sPqXn7RJU+xmalDbkR/M04bI94e3MOsru0Yt9a/htzqOOp1vzmsR/QLeXtQrA/LsUNn7iSiawuR4easYxh3BNowZE8xnb49F/NZnlVFxbik11VzyIYYj0TxeexPaKw8NOinqYmD8715TLSOk1ZU=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2728.eurprd04.prod.outlook.com (2603:10a6:4:97::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:23:06 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:23:05 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V1 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Topic: [PATCH V1 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Index: AQHXUvDdAkrP6ejNDkGcbE4OJnlbKqr3PELAgAAgsQCAEidCwA==
Date:   Tue, 8 Jun 2021 03:23:05 +0000
Message-ID: <DB8PR04MB679556065CABCB72C79815D7E6379@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210527120722.16965-1-qiangqing.zhang@nxp.com>
 <DB8PR04MB679585D9D94C0D5D90003ED2E6239@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YK+nRkzOhQHn9LDO@lunn.ch>
In-Reply-To: <YK+nRkzOhQHn9LDO@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48a8193e-c7a4-492a-3472-08d92a2cbb5c
x-ms-traffictypediagnostic: DB6PR0402MB2728:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB272810F187E7261E20D5CBD6E6379@DB6PR0402MB2728.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UK0qbw1H6rDSXPi7a2V+nM85iyZrEWleeedJXs4Ht9ktbxm0B6h/zGzTfjTxh8W8W/pfetz+3KAHjGgZGKu/qSwi4X26RtD5fmGCe5Rvt3azRqrlSiO6tFG/SMKFkm1dHXMOOf7byH5cw1HWtyUF2ipLc+AWmvFWpBIGvcL7lxD4iGZL0vn4ttP8KSekygjWKJaX2lRX258nDFBKHp4QTJNNfBUeTyldPyUy5t917+jr4a5f32d9yaxwaaei0xKcNxrLFYDNLRBMXZ2JUsRlN2+OZMHZfXA1NdOW0pyX78f84ZE6gqK9Te5vkpdFBK8CUMzLdPuZQLTP5xJi76Ln3cYjAOtNIdlt1Yk2oCc2zWfGqUGHJRW6dRPKd+SUbHJvgM005X7kA4gUxguRbq5aBtmtijO8nr4P7wOQBrTxW1897ESUNU6HNoAmKmzs8O3Kl5f/hE3AuAQ3ty0qw/WbnBuziC+mraGK5V5bSAl+j66AZjkbKnUMEAf0DhP4AtSFqoXJhfbgtWthgz/QupGI9KtK5JKtxdUZ8fDbhMaYzgOd0w3hOfMu0a5OANUEqKU9p72KhMjW/uNOSGuUvbV0sQnAfh/y8tpXuaLk12oIpdc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(5660300002)(83380400001)(66946007)(9686003)(64756008)(66476007)(66556008)(66446008)(6506007)(54906003)(76116006)(55016002)(4326008)(4744005)(38100700002)(33656002)(52536014)(316002)(86362001)(186003)(478600001)(71200400001)(122000001)(2906002)(53546011)(26005)(6916009)(8676002)(7696005)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?UUIycEZGUmxqdjgreDlmRjV4SXJ0SjV3Zy9hM3RWSk5tMkZKclJUWHlPY3Jl?=
 =?gb2312?B?WEhDZXdhSzl5WWNSRjZyck1XS1dQWmRKYTc4Wmp5dHV2Q2FaVkptYnk0YWFB?=
 =?gb2312?B?MHNyTzNhY1kzbFRZNGprWnFsVU9Fd1hKTDNIVGVHUUFiQVkvYk8rWFFTTzNU?=
 =?gb2312?B?dWJHd2I5V01nUWZsbjJDcGkzSDFGYTdlZUxtS2QzTllycUxKdXJYTjFKK2dH?=
 =?gb2312?B?VTFYREt6RWZSZDVqMUV0WkpBVSt1MU1iYnU3Y0I1OE9rQXZUNkh3enJpL0RL?=
 =?gb2312?B?QllwSVZCVzNydk1qUmNRKzZSZDErTlJiYnlOQVhsSDluQ1Q3QlRUQUl6M25s?=
 =?gb2312?B?YnE1L1BwTW9URVpvd1BOZVVGM2s5WDBSRUQ5MHJEOUl6QnVXbWt1ZXhSY2lW?=
 =?gb2312?B?QWpKdXZuTFpJY2c1RlYyK0lCOC9ZOERuRlEvTFJGMGZZZXI5aFF0RHAzUXdN?=
 =?gb2312?B?VlpSNVhJRGhJQStUemN5R1dIbUxGamFCcFp6MGdnY0NKT2dhVkkxcSsyNjFh?=
 =?gb2312?B?QllFK3piYWhvazZjRVBZM3pBUXZFYUtFbTFGdGdVMkUzR1VkYU9TQ2VRQUpS?=
 =?gb2312?B?dFRtby8vK08zbDRBcHl2VmF2eFZ3L3ZSL29nZ3cvVWZuME1SL2lNY2gwT2hj?=
 =?gb2312?B?WmxrMFhKU1laUkRjMmpCUDJscmJIWmk5N1F0K2lLREhiQUdPL1A5eFhsZnlu?=
 =?gb2312?B?YjJKNEdXcXJWVnlzb2hKb3dIdGQ2eDQzdWNvWWhINDEwdnp6UnJ0bWJXbGE2?=
 =?gb2312?B?eVVKNEs2SzFZeHpaWkNEM0tXTlFLWDhFUXI3T1JKSWQrOUdXNWRLOWZUbE92?=
 =?gb2312?B?RnBxYWxEeWk5Z0dGdzVSMzVMeHdlTndJUk92WmhuZnpXQVF1cS9jbjlUMDA3?=
 =?gb2312?B?aUhOUUJwc1hSTFM0NmtHQVY0K002elE5Mi9nL1dFU3FQcVM4bHBaQ015bjBV?=
 =?gb2312?B?ZjJablVuN0NGTTlLbXdvdnhybVVVZFo2c1h6b2o5OGVkblN0VTZ5aEwwQnh6?=
 =?gb2312?B?bGFrWGpuS0ZER3lwZXFMZDVDemJZZklsZ1QwYmVXVnVDZ0tHcVpObkZGUWRJ?=
 =?gb2312?B?SVljRGh5ZEtqdzJjVHVIYXpVZTFpYmxpbGU1N1BqWGZwbG1SQm9nTkFDdjF4?=
 =?gb2312?B?ck9YaXlaVjczdHYwdjUvNmxmRFdqU29JbnYzQ1YxWHQ2Z3M5ZXZJVnE2L3Vi?=
 =?gb2312?B?emlHbFNLQUpMSlRUamVWVHF6WnoyN2NCWlNDaklOelk0ZjROYkV2S2VCa1Zi?=
 =?gb2312?B?NGlEdjRUR1UrSXREMkNRNThra1NRVEhnM0VtQXZyQVlQV0pIR3NTL2FteVhs?=
 =?gb2312?B?YlBUbTJmZmhyZm5yMHdoWEVvWWxyV1RBalljNFNuUjR5Z2JjK09DZGNSVFND?=
 =?gb2312?B?eGFPQTNOdElMS0g5RmdVdzhJR1NNakxwTG10eXhiOFFWUHRtK0dSb3lnSEtS?=
 =?gb2312?B?a09WV0gyR1VqbFlTNS9QSE5wQVB5NlVsWjNIdW90TVZZeCs2Z0NWWGtoZDVR?=
 =?gb2312?B?R21TRFlIRjRISTNPenU0VDlFWlpydzQrdWJHNTJyb3NvMkREajhRM3JMUFZj?=
 =?gb2312?B?VmhNRVJiVEZXVzJmYU02QTZ4dW44c2w4TXRjWWUrRW5jTWdJRjFPaWFETGJ3?=
 =?gb2312?B?cnQvVjVkZW1Ea0Y3NWRSV1pVSDBNeVV3dFNNMDNLUkN4OFpMYk84L1JqVk5F?=
 =?gb2312?B?eEJVcml0SnBqL1B1RHNWeUMvL01ISUpDTDFlNkRuZlVhWnlKdVB5T1lWWHdB?=
 =?gb2312?Q?o2722SbXLKKBdxQnb6IwRB4nQnZZZ+hdSAjrqZw?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a8193e-c7a4-492a-3472-08d92a2cbb5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 03:23:05.8262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vtGTa7ZktiDMKn+5h5257TP6rSBqjRR6uwn9+FTajnbdmZSUM3DoA3G0hWA5GnzKmin6aEN7zxdi0tca8+l6Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2728
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGcmllZGVyLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFu
ZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gU2VudDogMjAyMcTqNdTCMjfI1SAyMjowNg0K
PiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IGRhdmVt
QGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgZnJpZWRlci5zY2hyZW1wZkBrb250cm9u
LmRlOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnOyBkbC1saW51eC1pbXgNCj4gPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIFYxIG5ldC1uZXh0IDAvMl0gbmV0OiBmZWM6IGZpeCBUWCBiYW5kd2lkdGggZmx1Y3R1
YXRpb25zDQo+IA0KPiBPbiBUaHUsIE1heSAyNywgMjAyMSBhdCAxMjoxMDo0N1BNICswMDAwLCBK
b2FraW0gWmhhbmcgd3JvdGU6DQo+ID4NCj4gPiBIaSBGcmllZGVyLA0KPiA+DQo+ID4gQXMgd2Ug
dGFsa2VkIGJlZm9yZSwgY291bGQgeW91IHBsZWFzZSBoZWxwIHRlc3QgdGhlIHBhdGNoZXMgd2hl
biB5b3UgYXJlDQo+IGZyZWU/IFRoYW5rcy4NCj4gDQo+IEhpIEZyaWVkZXINCj4gDQo+IElmIHlv
dSBjYW4sIGNvdWxkIHlvdSBhbHNvIHRlc3QgaXQgd2l0aCB0cmFmZmljIHdpdGggYSBtaXh0dXJl
IG9mIFZMQU4gcHJpb3JpdGllcy4NCj4gWW91IG1pZ2h0IHdhbnQgdG8gZm9yY2UgdGhlIGxpbmsg
dG8gMTBGdWxsLCBzbyB5b3UgY2FuIG92ZXJsb2FkIGl0LiBUaGVuIHNlZQ0KPiB3aGF0IHRyYWZm
aWMgYWN0dWFsbHkgbWFrZXMgaXQgdGhyb3VnaC4NCg0KRGlkIHlvdXIgbWFpbGJveCBnZXQgYm9t
YmVkLCBsZXQgeW91IG1pc3MgdGhpcyBtYWlsLCBob3BlIHlvdSBjYW4gc2VlIHRoaXMgcmVwbHku
DQoNCkNvdWxkIHlvdSBwbGVhc2UgZ2l2ZSBzb21lIGZlZWRiYWNrIGlmIGl0IGlzIHBvc3NpYmxl
PyBUaGFua3MgOi0pDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiAJIEFuZHJldw0K
