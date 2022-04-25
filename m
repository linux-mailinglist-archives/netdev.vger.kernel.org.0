Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3053750E405
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 17:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242739AbiDYPKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 11:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240822AbiDYPKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 11:10:31 -0400
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.109.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DAE064713
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 08:07:26 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2043.outbound.protection.outlook.com [104.47.22.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-14-C1pC2ModNLequItHYRF6NQ-1; Mon, 25 Apr 2022 17:06:17 +0200
X-MC-Unique: C1pC2ModNLequItHYRF6NQ-1
Received: from ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3b::9) by
 GVAP278MB0517.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:36::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.13; Mon, 25 Apr 2022 15:06:16 +0000
Received: from ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM
 ([fe80::dd15:e6d7:a4d0:7207]) by ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM
 ([fe80::dd15:e6d7:a4d0:7207%7]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 15:06:15 +0000
From:   Marcel Ziswiler <marcel.ziswiler@toradex.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "festevam@gmail.com" <festevam@gmail.com>
Subject: Re: net: stmmac: dwmac-imx: half duplex crash
Thread-Topic: net: stmmac: dwmac-imx: half duplex crash
Thread-Index: AQHYV2WZ5uT4Cdlm/Umu1AAuySf2Oqz/ns2AgAEebIA=
Date:   Mon, 25 Apr 2022 15:06:15 +0000
Message-ID: <5e51e11bbbf6ecd0ee23b4fd2edec98e6e7fbaa8.camel@toradex.com>
References: <36ba455aad3e57c0c1f75cce4ee0f3da69e139a1.camel@toradex.com>
         <YmXIo6q8vVkL6zLp@lunn.ch>
In-Reply-To: <YmXIo6q8vVkL6zLp@lunn.ch>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a3d8b31-b95f-4c99-54f2-08da26cd2520
x-ms-traffictypediagnostic: GVAP278MB0517:EE_
x-microsoft-antispam-prvs: <GVAP278MB051762BC52352748FDE44628FBF89@GVAP278MB0517.CHEP278.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: IyPL0LyQuIjW9v4uKFGkvvcPAYgNwn7aGglhMnw816odkeODrIcKTS1aG908niBv0v2aJCwROlcKHQCM5FXpRGXv8gSJTBsyagufEAibuSE1hXqfv4d+zZIjd503uKqwRauKB+i92hNYV2/uR4zo/KSxyWkZqWMB33G3muR80aLYAEiXiXWS8W41W9yAYCQy/VHJMNIaYyMW+wy/Bw+vtOxF+yiixPSYynC6dOgJBo9piIwWpoGyPMd5A1Fzgd7NvU5vkll/HTE18XQcDZ59g3LWPcV9aYsJILkjXBB9tYrB46JrFt40l/36h9lCm07MU4g5KdRnaab8uUL1pKWuBudXVyyJeVGqXGy0uOmAiJunyUKLXlsn7VzGd1in5Y/5IsUPwbEF8t8Ts0PSIR3RJkeGzsfZ/BhCzciJuihesVFu1mcFiplpsmqpTg66OwpwS+5PtnsrKtkNfDx6wRLNrItW23f6ifvzXAqgc1tv0xTgCYZEzTh2HUwyiUvPJn26qarMVNwDIH+dw1v4ZyzY45r5yvaRZD53q+UX3vHJ4Iaj36bkx6JslrUejmWdyV/wnm0W6TQabkoHQEXfm6Z6iRUGF0XSVCZ0rWJn3eKJzrh740noE8ZTQYxHgRQ93QdFkyjJOLuUM68v3l6fvsOKQkGHeQ5aEidOt4alU67YZGEZ/kDivbUElElC5bfFpEdH75XraTkoqYucAlOWsDhH1vGrhwJpcVw/BP5+EuvYfbe9+jB6znCERjCk5L4mwA/4KEJSVuaK82gYawYNSxp+nliJ2RX4/dY/oUwfAHMcOkA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(396003)(39850400004)(136003)(366004)(376002)(346002)(2616005)(36756003)(83380400001)(7416002)(186003)(8676002)(2906002)(44832011)(5660300002)(66946007)(66556008)(76116006)(66446008)(64756008)(66476007)(6916009)(6506007)(71200400001)(316002)(54906003)(8936002)(26005)(6512007)(6486002)(966005)(38070700005)(38100700002)(86362001)(508600001)(4326008)(122000001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVVTcW51RGs0V2JQWmoveXdMa1RsekZPRXJFYUpaaVVHSkxBbkRVcXdCbzVr?=
 =?utf-8?B?RDFQQzk2dmloaGRGbC9JVlhsV0p0cjhmUVNGUEMxSDdDYy9KT3hFTlNxUkVX?=
 =?utf-8?B?aDBXaVJpd2FzN2tOa283bnhQcUMvNlNORjZGekNFbXJrYTNqc3dLbittRUNw?=
 =?utf-8?B?eTVBMzZIVFg4eERxSVhzeVh2RUVCcEkrdFZmUkVsLzJOd1JEWlFGKzBHeCs4?=
 =?utf-8?B?cW10cStWd3NaZXRUckxuYkdrVnVsbnliSjYyTGI4V1JIZ2J0bjRSR1lNNUo2?=
 =?utf-8?B?RWhvYjlxcVRveVdHS2VvcExmM2piOWo5eVNMbVdBZE0rVVQzUldBYmt0Z0Jn?=
 =?utf-8?B?REZhVGFyR3BDR2tpc3JPSmFxK2ExaHNJZSt1eEtlSDM4czhzM1NnMlB2ZUFP?=
 =?utf-8?B?VnMvS080ZWlkYk1IYW5BbkZwQXppTDN5ampMb3NVdkgyNjY3cEkySjZyalp2?=
 =?utf-8?B?VU9kK0JaekF6Yy9VTmVFenFRSmxjMEVOK3EyV09YeWJOanJveUFXYmRGaTdX?=
 =?utf-8?B?Q3E5WlE5dHlka2NLMlZqaXhYaTcrZG1ROE9YM3V3RU50K3NLbFVrU0w3VXNM?=
 =?utf-8?B?S3Foa0oyNmMvRHNXZ01nUTdoREp3WkxMeXBGQ3VCaUkvMExWTG9NNFF3bjRo?=
 =?utf-8?B?UmtzM2Z0dGVxb1krTnY4amtMeW1NUk1qYldqUzhyOUFjc0lKcWVOb3RaczQx?=
 =?utf-8?B?Y3RYVkJ4L3R5azRnOXVBTFk0NUo4eTRJZWdKMTZZTFpkbGhNM0VMdjZ1WG1Q?=
 =?utf-8?B?K3BnWTZPRWJ6Z2Z5NjgzNHdJSkpRTjEwMEx0aXpCTW0xUDV6WGdoVXVEYjNP?=
 =?utf-8?B?MCtCYkpWV2xLY2l1WURiQWZNTFlqVFFieG5wK0FjOU50U1RTT054cis5WTdK?=
 =?utf-8?B?TVE4NDlGaUpzRDdldVovOW12TXgrYnJLaElBdnUxczdCa1hST1FLWHNicldp?=
 =?utf-8?B?TUJmOTlLUThVcUdpbDZtMWFUYUlnY1JEV09uVFlhZVErSFhzL08vWWN2aGRD?=
 =?utf-8?B?TzdNRVMyWHVlVU5WU1hPbkd5d0k1cTZnWk1rVm1jU0lTTDJZTDFvZG1WTlY5?=
 =?utf-8?B?alR0Si9aRVFCZ2J1clFrQ2o1eEsxcHdkNDVrOWhuSlROWlErNStZNVhNQnVD?=
 =?utf-8?B?T2NSc2NnY0QwblFHdnlhaWVjNldtL0xrNm0yNjJtcDNSUUNzYUlKSVIrRUlN?=
 =?utf-8?B?YWozLzNsa0dVSmxxN0JIY2pVWkhKZkE4QktTN3Q1bndoaldPY2l3SVU0c1pX?=
 =?utf-8?B?VnRuUnJWWDEvM3c5a05ES0lubkIzSVVJVUR2SXB2cmgycFZPaWZxQ3hiVFdI?=
 =?utf-8?B?U3lPL3oyU1NHYkV1bElWNEppSGRqODgzTEVqNGNuTHR0Zk1aOHNqY2JXQlgw?=
 =?utf-8?B?Q2x2aDFIckJRM2IrOWFLR01DVkN5czVCMTJUdWsyQkZPUTZ1NHVQLy9jby9Y?=
 =?utf-8?B?THg5YnoyekQxMmlCMG5WOWs3bGtyMUJQMWhRR0Z4UkNOWS9pSDl3UHplcllq?=
 =?utf-8?B?ODJQYkZ3VUk5UXVVV2tTQUFKWUlLbUhMNE8rUVoxZ3RDMUFVSGdDdjFWcFVP?=
 =?utf-8?B?Qk9lY3pKcVpIcG9OMFdpbXMvY3BVRWduc1B1c3BXc3VnejdJemlET2xueW5t?=
 =?utf-8?B?UE5BQ1FGMGlYa1dVQlhUOE42OFFuUDZWS0g0QWhHMnY0eVB3TDFDUDBlbjRW?=
 =?utf-8?B?aVhDWk8xemJaRGh6aVlqT2tBMjFlQURaWjhNc3VKV2w3eEovZkVpdjZWOW4z?=
 =?utf-8?B?NTZTMXNjMlE5YVkyRVQwTFJKU0pBdmtvbTFRVWVFdXRBazBtY0F3OCtaOUVm?=
 =?utf-8?B?bFJyT0FXdEVkalBHdWZqK0RGWHMrd0l0NlhXa0FGekNxWHZKbGlZQVYvNFFP?=
 =?utf-8?B?TW4vTFNKSVhSQnpCWlBTVlQ1S1pkUSsvcW9TaDRrdzJ5V1pRMmlheHVvYjFD?=
 =?utf-8?B?djFUUVZSNk5NV1hZeEQxbDJWT05rN1k2VGRvd0xmUDh5eFFjMW43WVduQjN0?=
 =?utf-8?B?dEdKVjJwYkt4eVNwYkZlOXZDZE0vRzNpTU1LVXJ3ZDRuZUJoSU9NRGphbjg2?=
 =?utf-8?B?QmtvUm90MEZWdEdpRmhsZlZiZVFvclZSMnNNOEpwZW9DMWpWS3lwNmE0dXpI?=
 =?utf-8?B?TXFQRmtESGZGanpBdkxidE9jcFhiUllkemxiazRxeHRRR3dYQ0R4UERBV0cv?=
 =?utf-8?B?aXNKN3l6YWdtaC9EQmdmSHh0alNBZVdPSTBpNFJtVG1DQ1lCa3lFVVFDVW4w?=
 =?utf-8?B?eldBY1JESVVFY053ZFByWVVoOG1nRzMwZXcrNG0xZGI4cTFVU3BpU2JocTl0?=
 =?utf-8?B?U0lRMlNCK25MSUsyZS8vZ2VOekdHRjlGUytES082QnI2K1ZkMk9jM1JCL3NV?=
 =?utf-8?Q?DRbhSsI1bd3N/bcre8cBP7C4bknRYLbjJWZXE?=
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0683.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3d8b31-b95f-4c99-54f2-08da26cd2520
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2022 15:06:15.8748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7HJQJZfxIW3NtD7cxbr1E/a6inpLjdi+6NIiGQwQw7EXL8sPJNvhE0laznZfU5JwQn7PGWDhHeRXcfq7aJfOWazHJVSQz5CKqti0VPo2aLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0517
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=marcel.ziswiler@toradex.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <5E5939C49984EE40B14929D1ED133674@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3DQoNClRoYW5rcyBmb3IgeW91ciBoZWxwIQ0KDQpPbiBNb24sIDIwMjItMDQtMjUg
YXQgMDA6MDEgKzAyMDAsIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBPbiBTYXQsIEFwciAyMywgMjAy
MiBhdCAxMDo1ODowN1BNICswMDAwLCBNYXJjZWwgWmlzd2lsZXIgd3JvdGU6DQo+ID4gSGkgdGhl
cmUNCj4gPiANCj4gPiBXZSBsYXRlbHkgdHJpZWQgb3BlcmF0aW5nIHRoZSBJTVg4TVBFVksgRU5F
VF9RT1MgaW14LWR3bWFjIGRyaXZlciBpbiBoYWxmLWR1cGxleCBtb2RlcyB3aGljaCBjcmFzaGVz
IGFzDQo+ID4gZm9sbG93czoNCj4gDQo+IEhvdyBtYW55IHRyYW5zbWl0IHF1ZXVlcyBkbyB5b3Ug
aGF2ZSBpbiBvcGVyYXRpb246DQoNCkxvb2tzIGxpa2UgTlhQIGRlZmF1bHRzIHRvIDUgUlggYW5k
IFRYIHF1ZXVlcyBlYWNoIGJlaW5nIHNldHVwIHZpYSBkZXZpY2UgdHJlZSBbMV0uIFVuZm9ydHVu
YXRlbHksIHVwb24gYm9vdA0KdGhlIGRyaXZlciBvbmx5IHJlcG9ydHMgdGhlIFJYIHNpZGUgb2Yg
dGhpbmdzOg0KDQpbICAgIDcuMjM5NjA0XSBpbXgtZHdtYWMgMzBiZjAwMDAuZXRoZXJuZXQgZXRo
MTogUmVnaXN0ZXIgTUVNX1RZUEVfUEFHRV9QT09MIFJ4US0wDQoNCj4gwqDCoMKgwqDCoMKgIC8q
IEhhbGYtRHVwbGV4IGNhbiBvbmx5IHdvcmsgd2l0aCBzaW5nbGUgcXVldWUgKi8NCj4gwqDCoMKg
wqDCoMKgwqAgaWYgKHByaXYtPnBsYXQtPnR4X3F1ZXVlc190b191c2UgPiAxKQ0KPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJpdi0+cGh5bGlua19jb25maWcubWFjX2NhcGFiaWxp
dGllcyAmPQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IH4oTUFDXzEwSEQgfCBNQUNfMTAwSEQgfCBNQUNfMTAwMEhEKTsNCj4gDQo+IFdoYXQgZG9lcyBl
dGh0b29sIHNob3cgYmVmb3JlIHlvdSBmb3JjZSBpdD8gRG9lcyBpdCBhY3R1YWxseSBsaXN0IHRo
ZQ0KPiBIQUxGIG1vZGVzPw0KDQpHb29kIHBvaW50LiBJIHdhcyBibGluZGVkIGJ5IE5YUCBkb3du
c3RyZWFtIHdoaWNoLCB3aGlsZSBsaXN0aW5nIGFsbCBpbmNsLiAxMGJhc2VUL0hhbGYgYW5kIDEw
MGJhc2VUL0hhbGYgYXMNCnN1cHBvcnRlZCBsaW5rIG1vZGVzLCBhbHNvIGRvZXMgbm90IHdvcmsu
IEhvd2V2ZXIsIHVwc3RyZWFtIGluZGVlZCBzaG93cyBvbmx5IGZ1bGwtZHVwbGV4IG1vZGVzIGFz
IHN1cHBvcnRlZDoNCg0Kcm9vdEB2ZXJkaW4taW14OG1wLTA3MTA2OTE2On4jIGV0aHRvb2wgZXRo
MQ0KU2V0dGluZ3MgZm9yIGV0aDE6DQogICAgICAgIFN1cHBvcnRlZCBwb3J0czogWyBUUCBNSUkg
XQ0KICAgICAgICBTdXBwb3J0ZWQgbGluayBtb2RlczogICAxMGJhc2VUL0Z1bGwgDQogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIDEwMGJhc2VUL0Z1bGwgDQogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIDEwMDBiYXNlVC9GdWxsIA0KLi4uDQoNCk9uY2UgSSByZW1vdmUgdGhl
bSBxdWV1ZXMgYmVpbmcgc2V0dXAgdmlhIGRldmljZSB0cmVlIGl0IHNob3dzIGFsbCBtb2RlcyBh
cyBzdXBwb3J0ZWQgYWdhaW46DQoNCnJvb3RAdmVyZGluLWlteDhtcC0wNzEwNjkxNjp+IyBldGh0
b29sIGV0aDENClNldHRpbmdzIGZvciBldGgxOg0KICAgICAgICBTdXBwb3J0ZWQgcG9ydHM6IFsg
VFAgTUlJIF0NCiAgICAgICAgU3VwcG9ydGVkIGxpbmsgbW9kZXM6ICAgMTBiYXNlVC9IYWxmIDEw
YmFzZVQvRnVsbCANCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMTAwYmFzZVQvSGFs
ZiAxMDBiYXNlVC9GdWxsIA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAxMDAwYmFz
ZVQvRnVsbCANCi4uLg0KDQpIb3dldmVyLCAxMGJhc2VUL0hhbGYsIHdoaWxlIG5vIGxvbmdlciBq
dXN0IGNyYXNoaW5nLCBzdGlsbCBkb2VzIG5vdCBzZWVtIHRvIHdvcmsgcmlnaHQuIExvb2tpbmcg
YXQgd2lyZXNoYXJrDQp0cmFjZXMgaXQgZG9lcyBzZW5kIHBhY2tldHMgYnV0IHNlZW1zIG5vdCB0
byBldmVyIGdldCBuZWl0aGVyIEFSUCBub3IgREhDUCBhbnN3ZXJzIChhcyB3ZWxsIGFzIGFueSBv
dGhlciBwYWNrZXQNCmZvciB0aGF0IG1hdHRlcikuIExvb2tzIGxpa2UgdGhlIHNhbWUgYWN0dWFs
bHkgYXBwbGllcyB0byAxMGJhc2VUL0Z1bGwgYXMgd2VsbC4gV2hpbGUgMTAwYmFzZVQvSGFsZiBh
bmQNCjEwMGJhc2VUL0Z1bGwgd29yayBmaW5lIG5vdy4NCg0KQW55IGlkZWEgd2hhdCBlbHNlIGNv
dWxkIHN0aWxsIGJlIGdvaW5nIHdyb25nIHdpdGggdGhlbSAxMGJhc2VUIG1vZGVzPw0KDQpJIGRv
IGtub3cgdGhhdCBldGgwIHdoaWNoIGlzIEZFQyBiYXNlZCBpbnN0ZWFkLCB3b3JrcyBqdXN0IGZp
bmUgd2l0aCBhbnkgYW5kIGFsbCB0aG9zZSBtb2RlcyBzbyBteSBuZXR3b3JrDQpzZXR1cCBvdGhl
cndpc2Ugc2VlbXMgc291bmQuDQoNCkFsc28gdGhlIHF1ZXN0aW9uIHJlbWFpbnMsIHdoeSBldGh0
b29sIGFsbG93cyBzdWNoIGlsbGVnYWwgY29uZmlndXJhdGlvbiBhbmQgZXZlbiB3b3JzZSB3aHkg
dGhlIGtlcm5lbA0Kc3Vic2VxdWVudGx5IGp1c3QgY3Jhc2hlcy4gTm90IHN1cmUgaG93IGV4YWN0
bHkgdGhpcyBjb3VsZCBiZSBwcmV2ZW50ZWQgdGhvdWdoLg0KDQpPbiBhIHNpZGUgbm90ZSwgYmVz
aWRlcyBtb2RpZnlpbmcgdGhlIGRldmljZSB0cmVlIGZvciBzdWNoIHNpbmdsZS1xdWV1ZSBzZXR1
cCBiZWluZyBoYWxmLWR1cGxleCBjYXBhYmxlLCBpcw0KdGhlcmUgYW55IGVhc2llciB3YXk/IE11
Y2ggbmljZXIgd291bGQsIG9mIGNvdXJzZSwgYmUgaWYgaXQganVzdHdvcmtlZFRNIChlLmcuIGFk
dmVydGlzZSBhbGwgbW9kZXMgYnV0IG9uY2UgYQ0KaGFsZi1kdXBsZXggbW9kZSBpcyBjaG9zZW4g
cmV2ZXJ0IHRvIHN1Y2ggc2luZ2xlLXF1ZXVlIG9wZXJhdGlvbikuIFRoZW4sIG9uIHRoZSBvdGhl
ciBoYW5kLCB3aG8gc3RpbGwgdXNlcw0KaGFsZi1kdXBsZXggY29tbXVuaWNhdGlvbiBpbiB0aGlz
IGRheSBhbmQgYWdlICg7LXApLg0KDQpbMV0NCmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90cmVlL2FyY2gvYXJtNjQvYm9v
dC9kdHMvZnJlZXNjYWxlL2lteDhtcC1ldmsuZHRzP2g9djUuMTgtcmM0I24xMTANCg0KPiDCoMKg
wqDCoCBBbmRyZXcNCg0KQ2hlZXJzDQoNCk1hcmNlbA0K

