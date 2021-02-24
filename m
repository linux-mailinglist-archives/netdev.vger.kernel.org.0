Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA67323571
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 02:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhBXBrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 20:47:20 -0500
Received: from mail-am6eur05on2068.outbound.protection.outlook.com ([40.107.22.68]:36399
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230010AbhBXBrS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 20:47:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SW8WBFMKpqtvqTVheuP165eTKF7w6k5Gz0pyI9GXJqWi4Uq6WPVs8CcM+9wpUU102d2sJLTs9sqFYyzbYjh41kOz11Vj+wOf8dAZeHnZG7/4JdnfLgp4wvNqddz5GLnNAkraML1wZO33yAzEKnwl/1iQP2mD8Ht1xrYSUV6B0ocBl/tkliPv53jHjWuBwbyBWwt02YJkvOoNOWiPvlVNQLh9QPQ2aOv71UMJMcA/IRArekbr5EXLDcd6wwnvPVj5QdM+5g7iBaZWWkIGF2fD6lOqqk8HxeW35ouUrPE+xikZTt6uDln7DsRG/e+ZmwJUwYzn1HcXpmscWzCwp53uuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2prdSBtNjZqizrvRud/GAHPupmYvY+enP7+/q5TznKU=;
 b=Dm3nbGkbKZzYgtl7+noCZwe9Z/SB17ft2PZLsZlsIgVPaOHsJgnST6gyYurF8lXATeSeOBIDtzz4tiu0cnyb9UMFCGbIRNB0w/mb0pORvIqbQROLd3/8nN5dHBgq1HpYZVjk7+zWwOmHT2I32kzcJgYiLUfyDodcakAeZpdlYA69NbFLv3UUeZCkKwGoIAkLzDmziucMYsO3YalDM5o8b3t6FLoYlFi6Ro9g/b0acBZtKd/uMMmDCNb3zMeK5XW5EK/73MBGeYHe2gL0EBHPq/pCIC1ht60yj0nbC2Z2q99IisdUKEIhTqF8Gburp3XLrJCyvWp54TCZUtafem57VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2prdSBtNjZqizrvRud/GAHPupmYvY+enP7+/q5TznKU=;
 b=j64blj8KA0XtzYJJqm+RLt8XZkoSrUx+z5T8KkOSV2BoeRf3m7BUwTe+GaNCfwxocslvQROgQytyKCUqH84MCl9KPYv7S8pGEZsUR3SEmZYRwumT1GHNE9loYJXjG8w8/5vqk51ykFIzIFHPRKRAey8IXOvnA9Z+KiDfSTv6xao=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6796.eurprd04.prod.outlook.com (2603:10a6:10:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 24 Feb
 2021 01:46:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Wed, 24 Feb 2021
 01:46:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V1 net-next 1/3] net: stmmac: add clocks management for
 gmac driver
Thread-Topic: [PATCH V1 net-next 1/3] net: stmmac: add clocks management for
 gmac driver
Thread-Index: AQHXCdFgGUEk6r7PhU6Xna7l5T4itKpl8xoAgACW4OA=
Date:   Wed, 24 Feb 2021 01:46:28 +0000
Message-ID: <DB8PR04MB6795B3804780DB7EF0BDFF5DE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
        <20210223104818.1933-2-qiangqing.zhang@nxp.com>
 <20210223084602.0d1aba9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210223084602.0d1aba9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0bdd7ae1-e999-4db2-faec-08d8d86600e0
x-ms-traffictypediagnostic: DB8PR04MB6796:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB679648D7A426D73F589C146FE69F9@DB8PR04MB6796.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lnxX25uIi5R7z+VDSN6yQEV13Zw8lFfecOl3uLACu69wUQWSRETAQgbA3ix+WA4blI5hwcGzFFoMGXyHr6J/bwIkAOZQoKot3CfuRiV3Lb18EUI32uROIhsEjho20utqEtKJTQXZf9iNK5xQPS+T3l9rZ4LfShjxrD6AzBN5ttI30wBhK580CMkXzmqKKK791ti1xJ2p3PatzKB45PG/I7TQCeak+Wae/01WMgubFdSkNlWsoiXcfKC87gFE24gTioevem3lixzQ6lfXYcxOQyQmaOiy+VduW80F6F2+aIfXFzzmTOrqToMUGnyThZBtOMC9P/fNEj7SWHrZNQVJXg9m3GSy2WLIOAq6w9YyWapGXUIA3DWGn0RmlIL7+BG3Twee7UPI1GSnZT4T4TGIibAt3pBbAAStF+lnWEWlIlz+QYC6CL2TS3pPAYnVyf2XdQ0gmJfHuAydNoyRjTNjIoK48+ni5J7oYguKx06D4UIOnW+ohtr4LpI5jyoVmODq3tjCqTNBeNXEss/IowFb0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(86362001)(4326008)(316002)(5660300002)(66476007)(66556008)(76116006)(66946007)(33656002)(7696005)(9686003)(71200400001)(83380400001)(54906003)(66446008)(64756008)(52536014)(6506007)(186003)(4744005)(8936002)(53546011)(55016002)(8676002)(478600001)(6916009)(2906002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?NXJtdkx0QXJRcFBJbm5TTEd1YUtWVEVHSEdhTXk2VkhSM05XOVJoaGxFcUI2?=
 =?gb2312?B?WmovSmVQU1RsditRQ1NDV2RwRWs1RGV1aGFud21JRmJIakt5Nm9qLzh3bHhR?=
 =?gb2312?B?c3U2Y1BYd2MyQk9MamdqVVdRSGtWZnlSbThCR3hEdzZzaTl0U2lJUDROQWFC?=
 =?gb2312?B?cFZieVRtbWhGZjc0L1FKZHhpQUhmb3RoSDdyVFd5Rkc5SlhaNG1EKzBJTkxx?=
 =?gb2312?B?bnZ3YkhpNTdHT0tab3dhUVlHK2d3cHJnekFWR2NXekRETUVkRXpmWTBNL0RS?=
 =?gb2312?B?WXpTaEZNNFdDVFJUSDI0SURsdTJRN2tobmVTTUNMVFhuUFVKWUI1MEtJemVq?=
 =?gb2312?B?aEJ0ZElkcTF3c0RtQ3JQbllqS3pTcjRoZzJaVHpaakpkQVptd2JXajFEcTV0?=
 =?gb2312?B?VWgwSy9iSlIxbmcxckZYT0tUclRwZ0VEY0RPYlpDUU5tK0dNeG53WVVuWmxt?=
 =?gb2312?B?TmJHV1VXT3NGc0NXYXJjNU5RVkc1c3JIRnNFdnBRMTRyK3hSeGdzTHhNZHQ2?=
 =?gb2312?B?aWlLTWl2cUVDVTNSNnlMcnlIVWNYckVBaGE3OEREdE1jMjBVNjUxSlpLeUhZ?=
 =?gb2312?B?YjZ0clRqRzVFQWNZb0hMYldtcmdjeXJwME9ZWmNuc0dnOTZEL3poNmh5WXJ2?=
 =?gb2312?B?dlRVUGFHL09WZEdUdUJvbW56SVJlUUhHTG15THgvektlSE9pcnVoaFIzK1M3?=
 =?gb2312?B?VmNGbVFuSUdXOXV1ZFZhY0lHWW9pZFlzaVAwWnBRSlA0WGtBZ09jUUJLZlRr?=
 =?gb2312?B?RHJTV2tBSENlT0JHNlMvdlZyNFluNnVPanlNanRVZkhBVEtVa2pxY01senZm?=
 =?gb2312?B?SGUvOXdTQlFqTTd5ZmN5RUhKeVp4WlRCSTFIVktuYXp6OXVwUTA3a3ZrSVlw?=
 =?gb2312?B?UHhyaHZ6TXFhYzhRTElzM3kyN3pQcDVGVHdvWVltM3duYS9KRFN0U2lFWWFE?=
 =?gb2312?B?THRPNFRkR0NhV3Q3MC9RUmJUYUh4cFgwM2RDK2tLQnlSRW9CUkUxblFmOExp?=
 =?gb2312?B?eG15bHltQlJYMEt3clJKRUtoN3ZYYmZnbnU0cmQwZ280QWsrT2ozRHZCT1ly?=
 =?gb2312?B?a2lMU2x2a2lqTG1ZQlJ6diszamh3NU9NdzJ6YWJubGZqa0JlNVBCSlhod2dx?=
 =?gb2312?B?ME0zbUZvRndXZ01kVUdESmxua2FRdW5yRXRyNlhUTmZsZkpRRFlKRGQyQ2lN?=
 =?gb2312?B?SXJmNzFoNnZGdjlzNGVqTzk0UjhpNDNaVm9JZ1JnRE9ZbTlDRmY2REF0U1lL?=
 =?gb2312?B?NFc5ckFTYXZDNUluWTFVeGNiajJWSWd5OTRwbjVTbVFJWDE2MXBNT3FLM2RL?=
 =?gb2312?B?ZWcxTTk0SXZkUzZSWkpUWVF2WjJJY3R2YVFidk1EdXlpR0ZjdDZwblJ4TnZP?=
 =?gb2312?B?TkJXSHhPeXIrZFJ2eFdtZHJtcDFQOWNuYTJrNXNLUGJYYXFlT2Y4WkRwbGF2?=
 =?gb2312?B?L0lMNGFmSWNHbk1kRnM5VDB3WjAzdnJKbWhNYkp6djdaWW4xWkdBenVNdWdC?=
 =?gb2312?B?WHFFNHJIWUNaVnpSZ3hCbjlPL1hQOFRQVjNqQzN0MU0vUHQzT2pyZ1NzSDA1?=
 =?gb2312?B?clhkUFRvdExzWVdpNzVPb0QzVWNpWllVekQxMUNWd3AyK2lDNU05bjdrcEZD?=
 =?gb2312?B?U1pYR29oQVlaYTFsWlgyeUkvdE82eURtMjNFaHkzUnB5R1plNHI2anZpWVBV?=
 =?gb2312?B?N0lNZXNzTThQV2xCTldLVGdYUmNkQzdUcjkvaFJlMFVIQnNWVVZMOWpCdUU4?=
 =?gb2312?Q?MWhK4AwNLGRY9mCluAMAZQ49qnRHhLiuQOZM04Q?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bdd7ae1-e999-4db2-faec-08d8d86600e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 01:46:28.4808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7pOPKOZzF5gkB2BYinCVZ4/mWB/OUev4QCHrb+ziK7ra/jtdzzR6tREJcjODv72Ymq+MH93ZCeDd75cegWfz9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogMjAyMcTqMtTCMjTI1SAwOjQ2DQo+IFRvOiBKb2Fr
aW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogcGVwcGUuY2F2YWxsYXJv
QHN0LmNvbTsgYWxleGFuZHJlLnRvcmd1ZUBzdC5jb207DQo+IGpvYWJyZXVAc3lub3BzeXMuY29t
OyBkYXZlbUBkYXZlbWxvZnQubmV0OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBkbC1saW51
eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFYxIG5ldC1u
ZXh0IDEvM10gbmV0OiBzdG1tYWM6IGFkZCBjbG9ja3MgbWFuYWdlbWVudCBmb3INCj4gZ21hYyBk
cml2ZXINCj4gDQo+IE9uIFR1ZSwgMjMgRmViIDIwMjEgMTg6NDg6MTYgKzA4MDAgSm9ha2ltIFpo
YW5nIHdyb3RlOg0KPiA+ICtzdGF0aWMgaW50IHN0bW1hY19idXNfY2xrc19lbmFibGUoc3RydWN0
IHN0bW1hY19wcml2ICpwcml2LCBib29sDQo+ID4gK2VuYWJsZWQpDQo+IA0KPiBuaXQ6IG15IHBl
cnNvbmFsIHByZWZlcmVuY2UgaXMgdG8gbm90IGNhbGwgZnVuY3Rpb25zIC4uX2VuYWJsZSgpIGFu
ZCB0aGVuIG1ha2UNCj4gdGhlbSBoYXZlIGEgcGFyYW1ldGVyIHNheWluZyBpZiBpdCdzIGVuYWJs
ZSBvciBkaXNhYmxlLg0KPiBDYWxsIHRoZSBmdW5jdGlvbiAuLl9jb25maWcoKSBvciAuLl9zZXQo
KSBvciBzdWNoLg0KDQpPSywgdGhhbmtzLCB3aWxsIGltcHJvdmUgaXQuDQoNCkJlc3QgUmVnYXJk
cywNCkpvYWtpbSBaaGFuZw0K
