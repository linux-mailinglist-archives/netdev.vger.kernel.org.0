Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32ACA5785AF
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 16:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiGROne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 10:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiGROnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 10:43:32 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150073.outbound.protection.outlook.com [40.107.15.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745731CB1F;
        Mon, 18 Jul 2022 07:43:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cob7J/9FRscqlTG6zKolqO8b2B/2EkEbnPnfSFm1dS82QoFHWx6aK5K7eXwjzq6+rndbLnAB05oPLEQR1I8Sc+0ydBDNmMMLEbrrlY8CS2GpFVhWpceHCm10KJEUPm9n5Pb5AES7VWf7+ZknkvAd3UxEq6BwTZ5tbfkTUbTgDQJNpfvonp52uVM3kFly458UUFKGXyK+2WAz7YCwYZx+GDvSeENwoRDy8P1/Ahc8yk17dBDuEvL31CxisNLBpF0M336uzJRBxVW35hQlqc0A1pKD0yReWddeNtdb3ZLpTsoFuYpxRi1CHmHwQlDEXAeyYxcmBodnuEmYxcMXap2h4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1SK8doAtRIpKS2fN3hUPTVje4513n1IjtZMthwi6aQ=;
 b=buUdkqWIiY+U1zZ0DO96xyY+vSJDRKNyDPX8lp5A71n9aRrV/Rvy9hlH2ADw8+eibUS+6pQe1oEmMPOLHzJZgGVxZSSsnT7OU6/uBsA7+IF/KTKJjflQF7u92G8EEXmsUaefva/7xuSCFY/MvQEB+0N1V9FaRELkD8PL7tXlWQj3HMXqO9HENVFmHg73+62M9z5xDyzar3Zo2A/xOYzyz1Ug6fJNXy/KxfBNfAv+GnCaaiy1F5arhjo9rDJKRbfBv2Lk3TPYDs+SU1TxbyxKvYKyqam8dA70MMqZgRkzZ897qL85Dhqd4GRDFyAV3M/jdCMRMtYnk7naSebtG30LHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1SK8doAtRIpKS2fN3hUPTVje4513n1IjtZMthwi6aQ=;
 b=a9QSGWbXYhYP5Gosw5Fc35x4sCkDaq1XmcSq8Q14n90YM9QaP6h2XQZjU9Tp0idWIQcL2q9S/houxpTFYvv2EveJaWx3+lWMNKf4OhW62Y1vMpL5ijAa4M3l/evo/2dc0AB9OXL926dL6ENmZlIzX6NtkglgNQc4O7e4+tCKi10=
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AM6PR04MB4294.eurprd04.prod.outlook.com (2603:10a6:209:4a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 14:43:29 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1%7]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 14:43:28 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Aisheng Dong <aisheng.dong@nxp.com>
Subject: RE: [PATCH V3 1/3] dt-bindings: net: fsl,fec: Add i.MX8ULP FEC items
Thread-Topic: [PATCH V3 1/3] dt-bindings: net: fsl,fec: Add i.MX8ULP FEC items
Thread-Index: AQHYmm+TiFZ3rflyiEqldr6GrvzRI62EIuSAgAAMQRA=
Date:   Mon, 18 Jul 2022 14:43:28 +0000
Message-ID: <AM9PR04MB9003D8120D5E0945DE300F7A888C9@AM9PR04MB9003.eurprd04.prod.outlook.com>
References: <20220718142257.556248-1-wei.fang@nxp.com>
 <20220718142257.556248-2-wei.fang@nxp.com>
 <0d758fae-efde-eb0c-5fc9-2407826ac163@linaro.org>
In-Reply-To: <0d758fae-efde-eb0c-5fc9-2407826ac163@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93b9c6e2-36e7-4280-3e3e-08da68cbe109
x-ms-traffictypediagnostic: AM6PR04MB4294:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lLTu1Z2aTYwLQFCJKIUeRYhXC+daC0O8utxs637kvcVfu/lCKwca+x+6q+v34xJ7xY2wvo3RLGidLZpSBOyB35h4H02xW/0JpFuoLpW1u2v1x/rZc8ZtvxbF5Decy96CsS/m7U6otf6Y2nYNnUg3Jk7nirGS/enUSvM+YyIq/lEX4yb8pPpRjZmaSSoISJbMV/1thJr12alZ2S5dPKOHyzINVreKC+F519Ut1WIfAtZBF4vt/2R8kYiRkKAaelsySBWP8CoqPGu0aKbhpJzkTtQmKMdeLGxo5/ry3ljk+gn0VfYvEwyLSt+ZUG3thajiAsxIj+wniN51gRs33Ij2fCDaneCRMJZIXZe/Q2DF8vRMA4aaZRC8zLH9qu7KllZI5JkxwrRs6d/zO7kIYiSrJYKQdvf+znaZwtHXmBVKsAmH2vNjqEMXS+FS5GoitU3yvJwlNKZqzhasBOM0ODnKaAjZHr95nLWME1x5YO9+iO9LFWz+LoVqcbe/yJ0JpsjB+NRn/YwONkzLB54e2AzaxFvjvwI70VkMGJBdZGzlVH1uRr2Id8LyfmtCyEKUmy0mtLBB2RP0XtBZ9esw9ZJfZX07kDK0xLkIjUdRRMYCItvdmtjkh5OejwmMw7ZRWG1759+cIz5bc1i7dnPEBG8wumAZd/12gMf4oFz1ImrqaOcjoMobbhjiqQHACEFcER0yvB94rahW5x++XvyCTC+WmwTfx1ptPz8oiDTNG/XaS+c2xgCnE7z1GD3P+R5ZTypN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(41300700001)(26005)(122000001)(9686003)(38100700002)(6506007)(7696005)(53546011)(83380400001)(2906002)(55016003)(186003)(33656002)(76116006)(71200400001)(966005)(54906003)(316002)(52536014)(8936002)(110136005)(478600001)(86362001)(4326008)(8676002)(66946007)(64756008)(66556008)(66446008)(66476007)(45080400002)(38070700005)(5660300002)(7416002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?akc0ektMZ1I3T0piYkU3RHhmTTdnRTd5L0JjYlZ3K0UybzJxK2srbWJkV2Zu?=
 =?gb2312?B?SjJXRE4wS1ZCT041MkJ5U1pxaFhsOU9lemxlU2JRdWJvSXBXUkRhYXRTVWVh?=
 =?gb2312?B?REZJaVpackk3NGNUWnZ5KzJQNExXWWhrdGF5eUduUWVYQWY5VkRsc3Vad0dM?=
 =?gb2312?B?Z3Z3SVBEdUxKeE5HNkxYOWpULy9oT1NjdmQvU3RZOEovNml4UGlMN3I1T0FC?=
 =?gb2312?B?WkpLY2dDcGVVTHZwc2ttTWpVZFRhcmtYQlZvbDlSY0NsRmR6cFhKMXRrSUp1?=
 =?gb2312?B?aWRxUFhPaTZTeGt1MmhpdHVsWUllcHFtV1lnNENWUUlXRW1jZmE2a29yN2pL?=
 =?gb2312?B?SDRRZnNqelRpb09mOUJJVi92WXBFeUJuZTF0SDJxZTFGUXJBeUJtZG9ycVVs?=
 =?gb2312?B?SnpHRU1vVjY4SmMxbFErN1lKUGxveGtneEg0NUpmUEh1NWpnU1dYUUJDNG04?=
 =?gb2312?B?RG5YZ012aEYvVTU3SUw2MnRwQnlYaHRsZ3k4OWRCSTAxY2FRTEpsdXVLWnNI?=
 =?gb2312?B?d1pBNHI1eW1rNUpJUU5OTVBaSVRMNGF5bnp0V0tIalE2N1EzTWhYNDVzWmQ4?=
 =?gb2312?B?SnU3Q0NlOHhSeWZweFM1NkZwZFJINS9WVFBoRzRTWmtFKzh3N0t3Z0VnL0Z2?=
 =?gb2312?B?VXBKVWZiWS94bndXOGhNdlFrUGJEN1c1QWdpL0VGcWJZRFBOYmowZjNhb2p3?=
 =?gb2312?B?eHdtb2pJMTlPUStsNlJwQ0NZV0VybVA5RVp6b0ZoUGk4SDVnYzVmUnI0ZGY5?=
 =?gb2312?B?ZEd4dGpTRjZxT1VjcG02VWFuM3ZOa0RpeTBUMGJpVDdITkNYWWVOMWpaRVR1?=
 =?gb2312?B?c1k2ZkpBUjJKckhZUk5lMmNWN28vcHQzeU9tTGwzTE9mOVVhbCt4OTl2eXR2?=
 =?gb2312?B?WXo3MVZWa2lucXpYSWNZZE0zRUVhZVdwQjVFVkVLNHRRUjJsY3lOMThmWUpt?=
 =?gb2312?B?bnRMY3RRVnQyTnZrUExiU1pPME5pWnNVZVppKzY3OVBQRURlek95bm1RT3RK?=
 =?gb2312?B?akU3eHFMejBCZFNuVGZiMDE1bFFCQ0Z5Y1lFMFhpeE9sM1MxdlFHUDJZY3l0?=
 =?gb2312?B?TlFJY1ZDWVhuYVd4U21ibXByV2l0SVR3VzJ1VlBnYm1Dck9rSk9ldTYyNHBt?=
 =?gb2312?B?Rk5HenZrV3BaUS95VW9ZRERFUmlDM2xoQk5mWFdyWVNPb3JJd3VTQ3JuMC9t?=
 =?gb2312?B?Uk1maXVQcldzdDN0dHRObVJiSVNIVlgrRnNoSEdOYXlwbi83NVBGL3NSZTFs?=
 =?gb2312?B?V1pERHBtOVhQNzBDdExQNm5EQ0RyNUVrV1RuWWl1RHh6YzY1TWZIT2c2dkdm?=
 =?gb2312?B?SENpenF3MVUwMWhZYUVFTEh0Tlo5Nk00N05GT3hkNDloa3FGQ24vU3RaSmlm?=
 =?gb2312?B?c2JUNkVVTFFPa2s1dnpHL3VuekhEc0lCYkZqb3hMLzY2by81bWpBY3NaTHpu?=
 =?gb2312?B?dDFPeWtMMFdYdDBJcmFwV2xMY0VreERueDdpTWtaRGdxTytIOU9odWxOYmR0?=
 =?gb2312?B?WC93MXZxczM0ZVBPQW9XUGVtbjQ3RGlIRU8zNlI4RGY2QmNlMUF1RjU2NnI4?=
 =?gb2312?B?Mll5Q29MbDcrUnM1OVY0QzNKYXp5SmdIbUpIekdlM0lJU2RqbkRpUHR3a2JE?=
 =?gb2312?B?NVRYMGRmQ1lFMWs1S0ZtbW5ybnFHWFZuMk1WWnFzbUtIOUN5K3owa0dDWjFi?=
 =?gb2312?B?TEZTdXUweE0wWUhLL0RMN1NMN3MzQ1lFSU5OekpFc1lROUlIZkNIVnk3cURZ?=
 =?gb2312?B?RkdOUTZRT0tobU43UDhhYUUyNzFHcUtNOExSeXpPRTBiaWlPdWxtcWtoZThZ?=
 =?gb2312?B?UmR0MC9jKzYvNFg4RlJ5Y1RBWFpiKzZwaXFCaldoQ2ZjenVwR3pwYXAxOEhE?=
 =?gb2312?B?dTRvZFp5NmJCQXlqR29qY1VRSDNVbFB0dVg1d3hYUEJOK0RYdENzQ2N2MXZw?=
 =?gb2312?B?ZWEvVUh5b0xKa1RDNWs0dWRuTmZSTTlPYUFJVmpCbmlwVWw4M0ZPNkpCd1Rv?=
 =?gb2312?B?TkZtNEFjam9iNlBqdDdYQmwxc3ZndXVqd0RDWmkrSkxYYWhxL1dyeUZyaC8w?=
 =?gb2312?B?Zkx2KzRueUwxMU5xT3YxQjdHMnA1MXFXcllLK1Z4NzhCankxeFV5WXVZSDRr?=
 =?gb2312?Q?RL3g=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93b9c6e2-36e7-4280-3e3e-08da68cbe109
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 14:43:28.9164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oaAjCfpcycp+pXBXr4UTmposjUS3T81aDfLCvnOuLkAe+Uo1jV8q63F4FD7l7sFHZ719DTBtl4fOEyu8YjbWyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4294
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiAyMDIyxOo31MIx
OMjVIDIxOjQwDQo+IFRvOiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT47IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7DQo+IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5p
QHJlZGhhdC5jb207DQo+IHJvYmgrZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStk
dEBsaW5hcm8ub3JnOw0KPiBzaGF3bmd1b0BrZXJuZWwub3JnOyBzLmhhdWVyQHBlbmd1dHJvbml4
LmRlDQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVs
Lm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsga2VybmVsQHBlbmd1dHJvbml4
LmRlOyBmZXN0ZXZhbUBnbWFpbC5jb207DQo+IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5j
b20+OyBQZW5nIEZhbiA8cGVuZy5mYW5AbnhwLmNvbT47IEphY2t5IEJhaQ0KPiA8cGluZy5iYWlA
bnhwLmNvbT47IHN1ZGVlcC5ob2xsYUBhcm0uY29tOw0KPiBsaW51eC1hcm0ta2VybmVsQGxpc3Rz
LmluZnJhZGVhZC5vcmc7IEFpc2hlbmcgRG9uZyA8YWlzaGVuZy5kb25nQG54cC5jb20+DQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggVjMgMS8zXSBkdC1iaW5kaW5nczogbmV0OiBmc2wsZmVjOiBBZGQg
aS5NWDhVTFAgRkVDIGl0ZW1zDQo+IA0KPiBPbiAxOC8wNy8yMDIyIDE2OjIyLCB3ZWkuZmFuZ0Bu
eHAuY29tIHdyb3RlOg0KPiA+IEZyb206IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiA+
DQo+ID4gQWRkIGZzbCxpbXg4dWxwLWZlYyBmb3IgaS5NWDhVTFAgcGxhdGZvcm0uDQo+ID4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gDQo+IFBsZWFz
ZSBhZGQgQWNrZWQtYnkvUmV2aWV3ZWQtYnkgdGFncyB3aGVuIHBvc3RpbmcgbmV3IHZlcnNpb25z
LiBIb3dldmVyLA0KPiB0aGVyZSdzIG5vIG5lZWQgdG8gcmVwb3N0IHBhdGNoZXMgKm9ubHkqIHRv
IGFkZCB0aGUgdGFncy4gVGhlIHVwc3RyZWFtDQo+IG1haW50YWluZXIgd2lsbCBkbyB0aGF0IGZv
ciBhY2tzIHJlY2VpdmVkIG9uIHRoZSB2ZXJzaW9uIHRoZXkgYXBwbHkuDQo+IA0KSSdtIHZlcnkg
Z3JhdGVmdWwgZm9yIHlvdXIgaW5zdHJ1Y3Rpb24sIGl0IGlzIHZlcnkgdXNlZnVsLiBBbmQgSSdt
IHNvIHNvcnJ5IHRoYXQgSSBkaWQgbm90IA0KYWRkIEFja2VkLWJ5IHRhZ3MgZm9yIHRoZSBuZXcg
dmVyc2lvbi4gQ2FuIHlvdSBzaWduIHRoZSBBY2tlZC1ieS9SZXZpZXdlZC1ieQ0KdGFncyBhZ2Fp
bj8gSSB3aWxsIGJlIHZlcnkgYXBwcmVjaWF0ZWQuDQoNCj4gaHR0cHM6Ly9ldXIwMS5zYWZlbGlu
a3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGZWxpeGlyLmJvDQo+
IG90bGluLmNvbSUyRmxpbnV4JTJGdjUuMTclMkZzb3VyY2UlMkZEb2N1bWVudGF0aW9uJTJGcHJv
Y2VzcyUyRnN1Yg0KPiBtaXR0aW5nLXBhdGNoZXMucnN0JTIzTDU0MCZhbXA7ZGF0YT0wNSU3QzAx
JTdDd2VpLmZhbmclNDBueHAuY29tJTcNCj4gQ2RkNjEwYWQ0MGQzMzRhNzMzZmMzMDhkYTY4YzMw
NjhhJTdDNjg2ZWExZDNiYzJiNGM2ZmE5MmNkOTljNWMzDQo+IDAxNjM1JTdDMCU3QzAlN0M2Mzc5
Mzc0ODQwOTIyNzQ5MDAlN0NVbmtub3duJTdDVFdGcGJHWnNiM2QNCj4gOGV5SldJam9pTUM0d0xq
QXdNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsxaGFXd2lMQ0pYVkNJNk1uMCUzDQo+IEQl
N0MzMDAwJTdDJTdDJTdDJmFtcDtzZGF0YT04NFJGMHNjcmc4b3F3Ukxmc3BINTVwZGJJU0xkZDNM
YTVEDQo+IHVoS3V3ME5xQSUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiANCj4gSWYgYSB0YWcgd2FzIG5v
dCBhZGRlZCBvbiBwdXJwb3NlLCBwbGVhc2Ugc3RhdGUgd2h5IGFuZCB3aGF0IGNoYW5nZWQuDQo+
IA0KPiANCj4gDQo+IEJlc3QgcmVnYXJkcywNCj4gS3J6eXN6dG9mDQo=
