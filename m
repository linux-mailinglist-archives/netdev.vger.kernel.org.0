Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81DE35BA2F
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 08:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbhDLGih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 02:38:37 -0400
Received: from mail-eopbgr10050.outbound.protection.outlook.com ([40.107.1.50]:29092
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229574AbhDLGig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 02:38:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PV9+qjBEjoIxj2SJrunTDhb4cdoVCTGXc/cXyiQgYHgn8MxU2zYWdVAglwrTuDoE4tPVOW3ydgxBMleDLaCb581vdmi/LYWsMCLy8bR/DdRtPCVpkg6cew5vi3LezbvAPsY3fVUyy4bbWc3zUXRwTRr7I18l4oSg6OaIiBKbkMXVDE1RSE6N6SRj4nmsl+CpJValrD2tA5GCNu2FAvpy7ND21/1Q3yKdveXoPuj1flImP+KwW1CaD0hUkr8gq/hD9duJf3S9m1o8RByRQRoRsYrUI8HHvjYfjAtcAhHtzzqLzriMi50iweGPeFX35PcRVp26s5OYLdnxIBLz8qHxYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSYHxna/Y9twwDKr5xbmr28ajbLmSxntLfb9saFUqKQ=;
 b=DF36UEHr3Al+J7sGMqOab9/2jPwqgLMs215QmA+zHPCXFam00Xfs7AtF4SpJAn0zdZ0Z7p5nqYdqHjljRg+Eqjqs3bqPUB7wZFHbK/WK/5Yx56t8nKn+dzp6UmLDSlXR4jxNO5FAsESMpbu8oA2KCEgZ6N2QYxR3C+KB7OMW8AmPKoYtjuwu9pgzsfzEAevdbNONKAZ5NmZJHm+vTOv/QVxdBZo8QvA5U9tb9WiReyLJ9xkCr3pT3j5ctdCAfZgCUqAec7Qhj7DIE60k9H2Y91KWd9IDwKkiONxBkykbMQyYPGowK14mNjaMLwlDpShur3mlHDbG+f89O09pB6afLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSYHxna/Y9twwDKr5xbmr28ajbLmSxntLfb9saFUqKQ=;
 b=rCq1ZKXkrnCk60LmeDzpbIBag4hfXk5gej/nyaqHgUwyAm1ovpyy13oLJYTLub/TQLFhHZEYDf+51N65YgNN9bDYklj1IkmxIbUC944Uu9t3ZwWusYys6e0URhwK0ukDMeCNk0Q8RLCGp8k9PJrzQmvlNqexq7NLWeIn8dlOoJk=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB8027.eurprd04.prod.outlook.com (2603:10a6:10:1e6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.20; Mon, 12 Apr
 2021 06:38:15 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 06:38:15 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Rob Herring <robh+dt@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH net-next 1/3] dt-bindings: net: add new properties for
 of_get_mac_address from nvmem
Thread-Topic: [PATCH net-next 1/3] dt-bindings: net: add new properties for
 of_get_mac_address from nvmem
Thread-Index: AQHXLR/Nkg01JZoX9UOYOnQHLo+6aqqsNCGAgAQ2W+A=
Date:   Mon, 12 Apr 2021 06:38:15 +0000
Message-ID: <DB8PR04MB67950A57793F62B5056DC3D3E6709@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210409090711.27358-1-qiangqing.zhang@nxp.com>
 <20210409090711.27358-2-qiangqing.zhang@nxp.com>
 <CAL_JsqKeqvC=vP+SA3i76W5jsCWxzdiNkrmHS0uU=qXUAoVq8Q@mail.gmail.com>
In-Reply-To: <CAL_JsqKeqvC=vP+SA3i76W5jsCWxzdiNkrmHS0uU=qXUAoVq8Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccf2f404-86ff-41a3-6ac7-08d8fd7d8d6f
x-ms-traffictypediagnostic: DBBPR04MB8027:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB80273410F54755FBD6615EF3E6709@DBBPR04MB8027.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TG9qzAl7YaYKuBgsHdF1tDCmxYRGxJ976aecosydp6fXBdtodDwDKPtAK2OfQ6UEwcfIPXKMKHhXZA0FV4PDJ7nDOlpXDlH81ErQUCpZibto5L58e5YSarZDcUaApCtq5jvLj1o/D9p+4WukNFBV2Hqn30q3m+E++cZgx8fSAZ7gm4G8GV3ySBUSJOnOX0MiRhcxN6tdVUJfE7JYu2v8oca2JVCF5nhMNdgrfAuxHcvqCZ8z7mCg/E4W0RHQLzpCxyc6KGg2GNIkuadydHJS0w6mi48NPlZAzuR5fV70B7nEULW7owvYP9udUj9TNXfPOrYNqog/BMjx35SaVR89JuyPvV/mfXr55s2b3h0T48lDl6m2Jl7RmU4w5ioREONopHjlJ0EwcCya4pa3U6DoW5wJ8TQp2quT7qrXoI0osBdGrSPMb9vEA89h5XnXIH1OX+mzqYCBJHLUWQGc6BrveZ411BTqkT1c1SilgPJC6eOcorcGDYZdvn7d4f3t6yptX+rQ5q88+6Ddlp9AD4eE2BGFjhafLalhEnvSMZ1GwHuaODjL95RHs3CUsHFZv55YDLf5EnbJxI5BGlRpiu4P5Ls4hMQ6rPr1lMhDs7vwuEI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39850400004)(346002)(376002)(136003)(38100700002)(478600001)(7416002)(26005)(4326008)(9686003)(53546011)(83380400001)(71200400001)(33656002)(52536014)(8676002)(6506007)(186003)(66946007)(86362001)(66556008)(7696005)(55016002)(66476007)(76116006)(2906002)(66446008)(64756008)(8936002)(54906003)(316002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WlFOK1VVbEpIcDN1L1FHY0NLRGNLcU40WEZTQlBwek1NR1ZqLzZoWERDdDJR?=
 =?utf-8?B?L1E5bHpYY21Ia0M2VlBqY21hOVhTU1l3TThwUFJBVm5ORDNSRDVVSmVIR01V?=
 =?utf-8?B?MXUyanFWc1FuUHZ2OTFzSEM3TXp5bCtTUUlXOXRET0sxeC80MlNNN29QTitY?=
 =?utf-8?B?cWptSjlNZkVOTzB6NDBBMTNWbE9rV2hHcEsyRGxicHBPQ1UybDhycEZ0aHVI?=
 =?utf-8?B?RHNrd2xrTWdTR0xjQVpiN04ya3dkRTYwQUhXRlZTcGhlUnEzZSsyQ2Yvay9x?=
 =?utf-8?B?aUxOU0E3ekFaS216VS9uTVY3Z09ib3JYbHU0U0RSYm1wR1hNejRjR1ArbFJO?=
 =?utf-8?B?RHhSVjNlQi9YVXVNeG1Yc0pNUi9pU2dsZG02bGlJbUtIM2lKaVRCRkpWV2Ns?=
 =?utf-8?B?eWo2Z3BuWU5HL3RwZ0xvOWZPcHJEYklGNG9lb25SY0V1WjdPUUVTRm9aQldn?=
 =?utf-8?B?NUNQTGRDZUh1VzMzS0c1N3d4eDhjRGcxejlZOGtua1JnNHdjMnNzVitIbGpa?=
 =?utf-8?B?K1dDNGcrK0FjRUNSaXU2K3ptWUowdFBvQXlFd2FPV3Z0Y3ZxYmZ3cVE1VS8v?=
 =?utf-8?B?bURKeDNCUlM2TmNoM1dGMkFhbnMzNzA4UmVrT3lUN3pwTHNqU2o0cko4b3ZM?=
 =?utf-8?B?UDZidWxXYmcybnpYYXFsYVFmcThOeFByZ3ZBZHRRMFZiMWhQamVOZld2cUl2?=
 =?utf-8?B?VE9FUEZ4SzFrU3c5QWE4MW44NUl4WHdzY0YyYVhtTEo2c2d2YmhyRVFyRVVr?=
 =?utf-8?B?b01VOXovYmZKajR2anBsb1dWbkZ2SlVmZTFQbkZvczVRQ2JWLzZQV254ZlRI?=
 =?utf-8?B?aEhva25Zcmh5RWJXWll6eVo4K1ZrcFJucm9UU3BJSXJFY0N4MXAyRW9IMzJz?=
 =?utf-8?B?bitTZ0ZTcnl0alRHdUQ3bkZJSFdaTDQrVUJTYmtVYmdIVE5KNmFGeFpMaFIv?=
 =?utf-8?B?MDlLYjdaaGxtZnRjSys3TUtDRWsvcGREV1VZWldkRDQ3ZWwwN2RZV0RUd1Rx?=
 =?utf-8?B?ZjhWL1FPSk5oVmo4WmFXRitGVk9IUjdoUE9rbEpLM3NycWxQNGtQS2VSQ211?=
 =?utf-8?B?cGMxZWh4ZTE0eXRDbXJrQWR1NlgvSXNjZk5NbWF5VGJsd1VZOGFDUXBLQzNk?=
 =?utf-8?B?c2dSYWJ0NWJKWGNjamZVZWEvQnljZGVBaDlqSGt6Y2hQR2dLOW8yblY4bTY3?=
 =?utf-8?B?Z0ZQZ20vbFliOVlROHozN2pYVzZLSURNdGd2MkdXQUhWaG1pbnl2RWhNOEdU?=
 =?utf-8?B?TVN4a1NUakYwN3lkVFY2Tlp1YXNDbXpiaUxYSW03blJ4Mi9WZ080WHBYbDZN?=
 =?utf-8?B?RVVsQmZRVzQrRnh1U3Q0aVBoVlNUMHhvZitzTEhjYlB1WVA3dUJCckpMUlN6?=
 =?utf-8?B?aU1HN2JoUGtXTGxFYUJTMlN4NWMzYWZCU1BNbkZacWZjVFliTlUwT0M2UFl6?=
 =?utf-8?B?SW1kVEI0Tm9uSituZDNNMjA1blBSaXpIeVQ0WThRWUFZd3lBSWkxcU9IczNr?=
 =?utf-8?B?MDZYbnJFVktYbG1OZ3BoK0RJNTBOMkIyYVc3QzEwTUJ5UThyY2tTOSsxRjla?=
 =?utf-8?B?bXpBNWFlSzZ6Q2xaaEU5UUF4b21sWmRNUW5ZbmZBb3VEWmxINkZPMGZoM1gr?=
 =?utf-8?B?UHpJbmZhZUZIcmhYUTNONXdCN085V1pMemU3dm1mYXprRDBSSHVqUGh4STEr?=
 =?utf-8?B?bWZ0amVZU3RFMjFTWWhVbDZuNHdlcWg4YkVhUmNFZDB4cHExNjdIbVpDS0Zs?=
 =?utf-8?Q?lO+EzferpZPM0R/ZuFz1+6UC3nISXRkz+dx4V/R?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccf2f404-86ff-41a3-6ac7-08d8fd7d8d6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 06:38:15.6990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sYjbsn7YXhF4HjMDa17u+L2syoAFt45SXx/uUUE547J74IIx7WHvMbRwWz3/F8VkByGSpUvykTtXdPRwh0a99w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBSb2IsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUm9iIEhl
cnJpbmcgPHJvYmgrZHRAa2VybmVsLm9yZz4NCj4gU2VudDogMjAyMeW5tDTmnIg55pelIDIxOjUw
DQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogRGF2
aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2Vy
bmVsLm9yZz47DQo+IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IEhlaW5lciBLYWxsd2Vp
dCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+Ow0KPiBSdXNzZWxsIEtpbmcgPGxpbnV4QGFybWxpbnV4
Lm9yZy51az47IEZyYW5rIFJvd2FuZA0KPiA8ZnJvd2FuZC5saXN0QGdtYWlsLmNvbT47IG5ldGRl
diA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47DQo+IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3Jn
OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBkbC1saW51eC1pbXgNCj4gPGxpbnV4LWlt
eEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDEvM10gZHQtYmluZGlu
Z3M6IG5ldDogYWRkIG5ldyBwcm9wZXJ0aWVzIGZvcg0KPiBvZl9nZXRfbWFjX2FkZHJlc3MgZnJv
bSBudm1lbQ0KPiANCj4gT24gRnJpLCBBcHIgOSwgMjAyMSBhdCA0OjA3IEFNIEpvYWtpbSBaaGFu
ZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gRnJvbTogRnVn
YW5nIER1YW4gPGZ1Z2FuZy5kdWFuQG54cC5jb20+DQo+ID4NCj4gPiBDdXJyZW50bHksIG9mX2dl
dF9tYWNfYWRkcmVzcyBzdXBwb3J0cyBOVk1FTSwgc29tZSBwbGF0Zm9ybXMNCj4gDQo+IFdoYXQn
cyBvZl9nZXRfbWFjX2FkZHJlc3M/IFRoaXMgaXMgYSBiaW5kaW5nIHBhdGNoLiBEb24ndCBtaXgg
TGludXggdGhpbmdzIGluDQo+IGl0Lg0KDQpPaywgd2lsbCBpbXByb3ZlIGl0Lg0KDQo+ID4gTUFD
IGFkZHJlc3MgdGhhdCByZWFkIGZyb20gTlZNRU0gZWZ1c2UgcmVxdWlyZXMgdG8gc3dhcCBieXRl
cyBvcmRlciwNCj4gPiBzbyBhZGQgbmV3IHByb3BlcnR5ICJudm1lbV9tYWNhZGRyX3N3YXAiIHRv
IHNwZWNpZnkgdGhlIGJlaGF2aW9yLiBJZg0KPiA+IHRoZSBNQUMgYWRkcmVzcyBpcyB2YWxpZCBm
cm9tIE5WTUVNLCBhZGQgbmV3IHByb3BlcnR5DQo+ID4gIm52bWVtLW1hYy1hZGRyZXNzIiBpbiBl
dGhlcm5ldCBub2RlLg0KPiA+DQo+ID4gVXBkYXRlIHRoZXNlIHR3byBwcm9wZXJ0aWVzIGluIHRo
ZSBiaW5kaW5nIGRvY3VtZW50YXRpb24uDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBGdWdhbmcg
RHVhbiA8ZnVnYW5nLmR1YW5AbnhwLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBKb2FraW0gWmhh
bmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiA+IC0tLQ0KPiA+ICAuLi4vYmluZGluZ3Mv
bmV0L2V0aGVybmV0LWNvbnRyb2xsZXIueWFtbCAgICAgICAgICB8IDE0ICsrKysrKysrKysrKysr
DQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0t
Z2l0DQo+ID4gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2V0aGVybmV0
LWNvbnRyb2xsZXIueWFtbA0KPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L25ldC9ldGhlcm5ldC1jb250cm9sbGVyLnlhbWwNCj4gPiBpbmRleCBlOGYwNDY4N2EzZTAuLmM4
NjhjMjk1YWFiZiAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvbmV0L2V0aGVybmV0LWNvbnRyb2xsZXIueWFtbA0KPiA+ICsrKyBiL0RvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZXRoZXJuZXQtY29udHJvbGxlci55YW1sDQo+ID4g
QEAgLTMyLDYgKzMyLDE1IEBAIHByb3BlcnRpZXM6DQo+ID4gICAgICAgIC0gbWluSXRlbXM6IDYN
Cj4gPiAgICAgICAgICBtYXhJdGVtczogNg0KPiA+DQo+ID4gKyAgbnZtZW0tbWFjLWFkZHJlc3M6
DQo+ID4gKyAgICBhbGxPZjoNCj4gPiArICAgICAgLSAkcmVmOiAvc2NoZW1hcy90eXBlcy55YW1s
I2RlZmluaXRpb25zL3VpbnQ4LWFycmF5DQo+ID4gKyAgICAgIC0gbWluSXRlbXM6IDYNCj4gPiAr
ICAgICAgICBtYXhJdGVtczogNg0KPiA+ICsgICAgZGVzY3JpcHRpb246DQo+ID4gKyAgICAgIFNw
ZWNpZmllcyB0aGUgTUFDIGFkZHJlc3MgdGhhdCB3YXMgcmVhZCBmcm9tIG52bWVtLWNlbGxzIGFu
ZA0KPiBkeW5hbWljYWxseQ0KPiA+ICsgICAgICBhZGQgdGhlIHByb3BlcnR5IGluIGRldmljZSBu
b2RlOw0KPiANCj4gV2h5IGNhbid0IHlvdSB1c2UgbG9jYWwtbWFjLWFkZHJlc3Mgb3IgbWFjLWFk
ZHJlc3M/IFRob3NlIHRvbyBjYW4gY29tZQ0KPiBmcm9tIHNvbWUgb3RoZXIgc291cmNlLg0KDQpJ
IGFsc28gZG9uJ3QgdW5kZXJzdGFuZCB3aGF0IEFuZHkncyBkbyBmb3IgdGhpcywgcGVyIGhpcyBj
b21taXQgbWVzc2FnZSAiSWYgdGhlIE1BQyBhZGRyZXNzIGlzIHZhbGlkIGZyb20gTlZNRU0sIGFk
ZCBuZXcgcHJvcGVydHkgIm52bWVtLW1hYy1hZGRyZXNzIiBpbiBldGhlcm5ldCBub2RlLiIuDQpI
ZSBzYWlkIHRoaXMgZG9uZSBfRFlOQU1JQ0FMTFlfLCBidXQgSSBoYXZlIG5vdCBmb3VuZCB3aGVy
ZSAiIm52bWVtLW1hYy1hZGRyZXNzIiBwcm9wZXJ0eSBiZWVuIGFkZGVkLCBhbmQgY2FuJ3QgZmlu
ZCBpdCBmcm9tIGV0aGVybmV0IG5vZGUuIFNvIEkgc2VuZCBvdXQgcGF0Y2ggZmlyc3QgdG8gc2Vl
IGlmIHJldmlld2Vycw0KY2FuIGdpdmUgYSBoaW50LCBvciBwb2ludCBvdXQgdGhpcyBpcyBhY3R1
YWxseSBpbmNvcnJlY3QuDQogIA0KPiA+ICsNCj4gPiAgICBtYXgtZnJhbWUtc2l6ZToNCj4gPiAg
ICAgICRyZWY6IC9zY2hlbWFzL3R5cGVzLnlhbWwjL2RlZmluaXRpb25zL3VpbnQzMg0KPiA+ICAg
ICAgZGVzY3JpcHRpb246DQo+ID4gQEAgLTUyLDYgKzYxLDExIEBAIHByb3BlcnRpZXM6DQo+ID4g
ICAgbnZtZW0tY2VsbC1uYW1lczoNCj4gPiAgICAgIGNvbnN0OiBtYWMtYWRkcmVzcw0KPiA+DQo+
ID4gKyAgbnZtZW1fbWFjYWRkcl9zd2FwOg0KPiA+ICsgICAgJHJlZjogL3NjaGVtYXMvdHlwZXMu
eWFtbCMvZGVmaW5pdGlvbnMvZmxhZw0KPiA+ICsgICAgZGVzY3JpcHRpb246DQo+ID4gKyAgICAg
IHN3YXAgYnl0ZXMgb3JkZXIgZm9yIHRoZSA2IGJ5dGVzIG9mIE1BQyBhZGRyZXNzDQo+IA0KPiBT
byAnbnZtZW0tbWFjLWFkZHJlc3MnIG5lZWRzIHRvIGJlIHN3YXBwZWQgb3IgaXQncyBzd2FwcGVk
IGJlZm9yZSB3cml0aW5nPw0KPiBJbiBhbnkgY2FzZSwgdGhpcyBiZWxvbmdzIGluIHRoZSBudm1l
bSBwcm92aWRlci4NCg0KTUFDIGFkZHJlc3MgcmVhZCBmcm9tIE5WTUVNIGNlbGwgbmVlZHMgdG8g
YmUgc3dhcHBlZC4gVGhlIG9yZGVyIG9mIGJ5dGVzIHRoYXQgTlZNRU0gcHJvdmlkZXIgcHJvdmlk
ZWQgaXMgZml4ZWQsIHNvIEkgdGhpbmsgd2Ugc2hvdWxkIHN3YXAgYXQgdGhlIE5WTUVNIGNvbnN1
bWVyIHNpZGUuDQpJdCBpcyBtb3JlIHJlYXNvbmFibGUgYW5kIGNvbW1vbiBhZGQgYSBwcm9wZXJ0
eSBpbiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbnZtZW0vbnZtZW0tY29uc3Vt
ZXIueWFtbCwgYW5kIHN3YXAgdGhlIGRhdGEgaW4gbnZtZW1fY2VsbF9yZWFkKCkgZnVuY3Rpb24u
DQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiBSb2INCg==
