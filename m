Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB713A0AE9
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 05:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbhFID5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 23:57:39 -0400
Received: from mail-vi1eur05on2053.outbound.protection.outlook.com ([40.107.21.53]:18784
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233410AbhFID5i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 23:57:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NrhWYisWN4PI85ajisn7IGX1TBqmT5gZZAZS4foQ2/5FR6yiFqJJaieqPszNj9WS3G2W4ctH4IXdENpMGs0eKrV29ous1ZI5KVKf18yo05MTASdAXrVzA50AgXhSeLLkaQKrrl1qwj3sTc1JWeiGmyIK/q/3JZ0bLFUIjARq69mjKhJnG6TPXXb62IJ/krLmW2Xi7drtnkMmsSTtqiBYce/TkKpEB5Rzry3hrKwsXyStZR9TZdWmIjGx+STM7393DNEwRMjOjDcUASmW4kMVvJSsXuOa8ApwoLFvqF34wsK2r1ZFEJ2VNGqg7s4W2dW5ugVbfIFIaXRczXFvf9DQlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLTYuA3hpJ1f7MRxpdDq2kuWXeQZyZj8rSv/PsBcENc=;
 b=FdPnjhuGcdehAFnYfABcLDfKxrZUoL0Rv/LemWSdIRJtzR9RSDZ6f7VAYoevnDjCrnMCZXBM3OAVUmeQWktGAB/sdxANuM5vV12AkS0qMzf2VM+RavMBIeCso/kt3mc8Hkdq2CtmQZyc7NPlmBKZUl0zeADcocDEGvrVDEhA5ZUVAbSW/KIF0wnKJfaEOQoibLcZk5h2RFaDrs4eg6a6V+Z/+442O8DpxPR9QEZxaE8xUYlJmGVbjn/F3WTP5xMY1XlvuQqgQIPENsbUpgXlL5ZQqrj9lTX/1xUH4d6s+rFT3y4PLdajnzky5mHdAHAVeAhJApcJUEQ/rYU7jEmlTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLTYuA3hpJ1f7MRxpdDq2kuWXeQZyZj8rSv/PsBcENc=;
 b=atzC+pC/Kr0wRYSk9jsIw/bVJSWs5532epLXv3Dwxap9ijKnW0MQZ3gaGjOUkELs6g52yiXu0rFhWw4E4QrLDLLvb/PMn8LYkQETcLHKqUFsam4lIyf+iJdViXgiWZKpCc1YsyGiLLjXaFDWC71nw72+wZvlemcSqWIg8+GEGlY=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8431.eurprd04.prod.outlook.com (2603:10a6:10:24e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 03:55:39 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4219.020; Wed, 9 Jun 2021
 03:55:39 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V3 net-next 3/4] net: phy: realtek: add dt property to
 enable ALDPS mode
Thread-Topic: [PATCH V3 net-next 3/4] net: phy: realtek: add dt property to
 enable ALDPS mode
Thread-Index: AQHXXBSh0nhwyLkWNESDxO+tqgeOSKsJ324AgAAFxMCAAQf8gIAACx4ggAAH3ACAAAP/0A==
Date:   Wed, 9 Jun 2021 03:55:39 +0000
Message-ID: <DB8PR04MB6795685FD29A6040858C994BE6369@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
        <20210608031535.3651-4-qiangqing.zhang@nxp.com>
        <20210608175104.7ce18d1d@xhacker.debian>
        <DB8PR04MB6795D312FDECF820164B0DE6E6379@DB8PR04MB6795.eurprd04.prod.outlook.com>
        <20210609095633.1bce2c22@xhacker.debian>
        <DB8PR04MB67955F0424EAEBF362D34B30E6369@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210609110428.5a136b03@xhacker.debian>
In-Reply-To: <20210609110428.5a136b03@xhacker.debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: synaptics.com; dkim=none (message not signed)
 header.d=none;synaptics.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fc97348-f4bc-4277-3525-08d92afa722e
x-ms-traffictypediagnostic: DB9PR04MB8431:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB9PR04MB8431CB86B426643B506DF4CBE6369@DB9PR04MB8431.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K1140PrnGsdRWjvaZZOsb90RU6iSXRYmVXG/dAErJmafCaEhFz35AwYLuo2/YFOkrlmKug9GBG3GUI734jOeyFS3EpG8beS8rjA8if4QIrOqEEPEfC4n+/1ZKTGBALbdiBnQHk8ooHz5UZhLTidAz4ST1dW4CWNaIokRJIKVuwfSeAWCHy+Ye7cCYHNqO6o0qjvk0UEyBrnwNibPEvxd9J4zs7gHGVezmkzXc094dCWrjurJIjaJILldQImp0tRi1+DRJt/6sy1K8Y6ggcg4u9bXYVa1L02K3xGv4ByLCN4IfHNxjb96hXvEJKKfEg4jwGXEpz21B9d2NSdz9XuTjAakGsHDztGxqdkdP25emJH/PN0oTm7fvTEd4OmxEbqOuS+Jp8OFTs8oRv7yuU41L+YSqSkNAo3Udu9YPVba7//DMQG4kf3ZJLfwR55Y2zwz4em0592prK2JxU/dx1+tMmFWm8/UJ3QXeLL7klVAK4LoUILBmJbCtbEG6pEgcMUUTppPxeOQGuwz20oV/zvU0/v/ThbmfMJMNOyiraNgCGQcuf830/jhdCqq9sn3X2JG/IJKZrZFt0c/0Csk2KKVffZ+B/hzm55eIfUrd53eMao/DzDgP0E5xFBo/pHNy0rAvKDbPHEj/yGS89O3GE5hRsnfQfOA5OwPHixgZN+CB+7JpLmbT49A0L5RGPQGG3dWAsKI3ohX7A2sabYNp89y/6cytfVsXh+RteoLsB9z3SU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(6916009)(38100700002)(478600001)(8676002)(8936002)(54906003)(83380400001)(5660300002)(966005)(122000001)(71200400001)(26005)(55016002)(7696005)(6506007)(53546011)(4326008)(2906002)(66946007)(66556008)(76116006)(86362001)(9686003)(66476007)(64756008)(66446008)(33656002)(7416002)(52536014)(316002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eEtUbnJCU2ZhcXhINkRzejA0VXQ4S0w3VzdXdWJ1b0xiMmlRblpoOXlQQ3l6?=
 =?utf-8?B?QS9McTFrakhRY3lSOHZEMGZDcjRTRDF1L1FaRi80M0EzeldCVWZMcTF6bDA0?=
 =?utf-8?B?SzBiTjIvcjE2V3pBc296VVd6bHJSc25FTUQ5K3NCK1FBc0pjVlgyUzU3YnJh?=
 =?utf-8?B?Nmg5R1hUVHdtVG5xVldIVFJGMWltT3UxbzV5Y2F4QmpsZnNRejduVTQxMk5V?=
 =?utf-8?B?QnJMczZ5MFlKQXBUditDMmo5eEM4cnhMZEpxL2VWSHlhWjJoR2JTelN3SDEr?=
 =?utf-8?B?ZEsyUldqQ3VVekQ5UzVnSGF2MTdON2lub1FGTDdra2JtZTYrOVZIWFkzNmVM?=
 =?utf-8?B?Q1BQNXRLY2ZXNUgyNGNZRi92eTgzY3VNZytiaXZFWnNyZlFzazU5RXlTMzdv?=
 =?utf-8?B?ay9mREtCTnhVUExRNFpwL21kOHVoQzMwVWtnbDgvTUl0M3VkSHg3a2FZNy8z?=
 =?utf-8?B?ZE9tS0RsL1VFNUhyWk5BMU9sRHhUVmJhU3YwMDJuNlg1dmhQdmRQbVpPR2hS?=
 =?utf-8?B?eWxudlZJa3IwTVp6RStiT1FQZnVuSWZicEttVG0rMzJ0SHpFYlJVN3ZhcVA3?=
 =?utf-8?B?aVlEakVDdE50SjBQcmNSK3JRbExzRGMxeVMrQ1BXV3R0Q3dNMkhLdEJlVEE1?=
 =?utf-8?B?Snd5bmt1dytIb0VPK2NybHZHeW8wUnlaSkVRWFJERmpmT1RESmdjdGZpL2Uz?=
 =?utf-8?B?K3dDQXExbnNoanVWN0ZtRU94R2MyNCs2OVZIQllQYlVoS3lsMEVIUWx6YVlo?=
 =?utf-8?B?MXhObUM0VFl2WjZsRmdzWWN5b045QXVLS0dGaUpqd3lQaG56S1N1MFJiS05G?=
 =?utf-8?B?eUtiYzQrUW00Qmord3dTdUp4Z1JMbUt5OUVQeDlyQ0FZN0k3SjljSzNqQkx1?=
 =?utf-8?B?YTZ2bUc5c1YzYnU3NmhqMkptT3BPNkk5ZVJVYXNSUSswOTYrTE9DNUxjdGhu?=
 =?utf-8?B?VXVvQ1pKUWE2QzMrU1p6M0cyRDFaWjllbmtRTW53dU5MbXVrd3VSMGl2NjZZ?=
 =?utf-8?B?TkNLcXk4S0VxOG1BMG40b01TWkNvQzhMWGV4Q3EvbGo5cnNTcWF6Rkplbk9Q?=
 =?utf-8?B?OHRCQ3pqUU5Mc2tlU0V6Wmk3SDR3TExJb1lrdVJtMUNxSjlEcGFuRDBVVFF5?=
 =?utf-8?B?V2FHYno2OXh4c2R2NFRRQ0hVQWlOYWpHa21kdDdQcFlUVzJIWUlZSVJDT25S?=
 =?utf-8?B?RmM0ZzY0Tk1ldDZORDd3d1hjeG1FSzE5S21TOUZYVnZnNnNya0RmUEZtS0ll?=
 =?utf-8?B?MkdjYjBETnVnbllOMmxyaHAzYzlrSW1yNGRpTERUV0ZQM2E4a1ZmQ1hlUWNZ?=
 =?utf-8?B?UDc0czkzRHpETkxENU5CLyswSVJ4WTBJSGdjeTdkRWJFQmdmeEUwRVZYV1pX?=
 =?utf-8?B?eHRtNUVDaWlybFNzWFB4NmpHSlFOa0JFbWJ4VDRrV1hhaXB1OXV0N1NzNnB0?=
 =?utf-8?B?WHJMZUVPS3V1SGxQbDRpNWNIMmZyaGw4OU0yc2lIUE11a1JLWWUrcFIxWENW?=
 =?utf-8?B?c0dLQ0h1QkJRd0tYZkxTOTlPOTlPYnlpQXF4L2tjMTRiMEdPUzliaitpSHJC?=
 =?utf-8?B?QW9PWnM5SC9mV0IxV09peHI4NmFrcUFmUVNVdGd1dXNGSW1ydkxMMElRU3JM?=
 =?utf-8?B?RFQ3V0hMYU81T1AyOU1wenNadW9mclZMd3hLREI5OWk1czFtbHpLLzlZUUtt?=
 =?utf-8?B?RHFMSWtmSGRna1NyaFJDZ05lMFpGK1c3dFBrMzZKRzJQcjVBTFp0QUZvVDdG?=
 =?utf-8?Q?z7DaV9ytxblRcx/1jWQz58Pc8saioh2GlEMvBPb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc97348-f4bc-4277-3525-08d92afa722e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 03:55:39.3904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 19JL7TFj3oHw/XQyi/3F91s57SHbC9H2xMlycZ0GdetWZ+e0LQIsNT1y/b/vJP6/86ooFbXceGOJZ0PlJ25zPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8431
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBKaXNoZW5nLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpp
c2hlbmcgWmhhbmcgPEppc2hlbmcuWmhhbmdAc3luYXB0aWNzLmNvbT4NCj4gU2VudDogMjAyMeW5
tDbmnIg55pelIDExOjA0DQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAu
Y29tPg0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyByb2JoK2R0
QGtlcm5lbC5vcmc7DQo+IGFuZHJld0BsdW5uLmNoOyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsgbGlu
dXhAYXJtbGludXgub3JnLnVrOw0KPiBmLmZhaW5lbGxpQGdtYWlsLmNvbTsgZGwtbGludXgtaW14
IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRy
ZWVAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggVjMgbmV0LW5leHQgMy80XSBuZXQ6IHBoeTogcmVhbHRlazogYWRk
IGR0IHByb3BlcnR5IHRvDQo+IGVuYWJsZSBBTERQUyBtb2RlDQo+IA0KPiBPbiBXZWQsIDkgSnVu
IDIwMjEgMDI6NTE6MTEgKzAwMDANCj4gSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhw
LmNvbT4gd3JvdGU6DQo+IA0KPiA+IENBVVRJT046IEVtYWlsIG9yaWdpbmF0ZWQgZXh0ZXJuYWxs
eSwgZG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMNCj4gdW5sZXNzIHlvdSBy
ZWNvZ25pemUgdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KPiA+DQo+
ID4NCj4gPiBIaSBKaXNoZW5nLA0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KPiA+ID4gRnJvbTogSmlzaGVuZyBaaGFuZyA8SmlzaGVuZy5aaGFuZ0BzeW5hcHRpY3MuY29t
Pg0KPiA+ID4gU2VudDogMjAyMeW5tDbmnIg55pelIDk6NTcNCj4gPiA+IFRvOiBKb2FraW0gWmhh
bmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiA+ID4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5u
ZXQ7IGt1YmFAa2VybmVsLm9yZzsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiA+ID4gYW5kcmV3QGx1
bm4uY2g7IGhrYWxsd2VpdDFAZ21haWwuY29tOyBsaW51eEBhcm1saW51eC5vcmcudWs7DQo+ID4g
PiBmLmZhaW5lbGxpQGdtYWlsLmNvbTsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47
DQo+ID4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9y
ZzsNCj4gPiA+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+IFN1YmplY3Q6IFJl
OiBbUEFUQ0ggVjMgbmV0LW5leHQgMy80XSBuZXQ6IHBoeTogcmVhbHRlazogYWRkIGR0DQo+ID4g
PiBwcm9wZXJ0eSB0byBlbmFibGUgQUxEUFMgbW9kZQ0KPiA+ID4NCj4gPiA+IE9uIFR1ZSwgOCBK
dW4gMjAyMSAxMDoxNDo0MCArMDAwMA0KPiA+ID4gSm9ha2ltIFpoYW5nIDxxaWFuZ3Fpbmcuemhh
bmdAbnhwLmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+
ID4gSGkgSmlzaGVuZywNCj4gPiA+DQo+ID4gPiBIaSwNCj4gPiA+DQo+ID4gPiA+DQo+ID4gPiA+
ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+ID4gPiBGcm9tOiBKaXNoZW5nIFpo
YW5nIDxKaXNoZW5nLlpoYW5nQHN5bmFwdGljcy5jb20+DQo+ID4gPiA+ID4gU2VudDogMjAyMeW5
tDbmnIg45pelIDE3OjUxDQo+ID4gPiA+ID4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpo
YW5nQG54cC5jb20+DQo+ID4gPiA+ID4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2Vy
bmVsLm9yZzsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiA+ID4gPiA+IGFuZHJld0BsdW5uLmNoOyBo
a2FsbHdlaXQxQGdtYWlsLmNvbTsgbGludXhAYXJtbGludXgub3JnLnVrOw0KPiA+ID4gPiA+IGYu
ZmFpbmVsbGlAZ21haWwuY29tOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsNCj4g
PiA+ID4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9y
ZzsNCj4gPiA+ID4gPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4gPiA+ID4gU3Vi
amVjdDogUmU6IFtQQVRDSCBWMyBuZXQtbmV4dCAzLzRdIG5ldDogcGh5OiByZWFsdGVrOiBhZGQg
ZHQNCj4gPiA+ID4gPiBwcm9wZXJ0eSB0byBlbmFibGUgQUxEUFMgbW9kZQ0KPiA+ID4gPiA+DQo+
ID4gPiA+ID4gT24gVHVlLCAgOCBKdW4gMjAyMSAxMToxNTozNCArMDgwMCBKb2FraW0gWmhhbmcN
Cj4gPiA+ID4gPiA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+IHdyb3RlOg0KPiA+ID4gPiA+DQo+
ID4gPiA+ID4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gSWYgZW5hYmxl
IEFkdmFuY2UgTGluayBEb3duIFBvd2VyIFNhdmluZyAoQUxEUFMpIG1vZGUsIGl0IHdpbGwNCj4g
PiA+ID4gPiA+IGNoYW5nZSBjcnlzdGFsL2Nsb2NrIGJlaGF2aW9yLCB3aGljaCBjYXVzZSBSWEMg
Y2xvY2sgc3RvcCBmb3INCj4gPiA+ID4gPiA+IGRvemVucyB0byBodW5kcmVkcyBvZiBtaWxpc2Vj
b25kcy4gVGhpcyBpcyBjb21maXJtZWQgYnkNCj4gPiA+ID4gPiA+IFJlYWx0ZWsgZW5naW5lZXIu
IEZvciBzb21lIE1BQ3MsIGl0IG5lZWRzIFJYQyBjbG9jayB0byBzdXBwb3J0DQo+ID4gPiA+ID4g
PiBSWCBsb2dpYywgYWZ0ZXIgdGhpcyBwYXRjaCwgUEhZIGNhbiBnZW5lcmF0ZSBjb250aW51b3Vz
IFJYQw0KPiA+ID4gPiA+ID4gY2xvY2sgZHVyaW5nDQo+ID4gPiBhdXRvLW5lZ290aWF0aW9uLg0K
PiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEFMRFBTIGRlZmF1bHQgaXMgZGlzYWJsZWQgYWZ0ZXIg
aGFyZHdhcmUgcmVzZXQsIGl0J3MgbW9yZQ0KPiA+ID4gPiA+ID4gcmVhc29uYWJsZSB0byBhZGQg
YSBwcm9wZXJ0eSB0byBlbmFibGUgdGhpcyBmZWF0dXJlLCBzaW5jZQ0KPiA+ID4gPiA+ID4gQUxE
UFMgd291bGQgaW50cm9kdWNlIHNpZGUNCj4gPiA+ID4gPiBlZmZlY3QuDQo+ID4gPiA+ID4gPiBU
aGlzIHBhdGNoIGFkZHMgZHQgcHJvcGVydHkgInJlYWx0ZWssYWxkcHMtZW5hYmxlIiB0byBlbmFi
bGUNCj4gPiA+ID4gPiA+IEFMRFBTIG1vZGUgcGVyIHVzZXJzJyByZXF1aXJlbWVudC4NCj4gPiA+
ID4gPiA+DQo+ID4gPiA+ID4gPiBKaXNoZW5nIFpoYW5nIGVuYWJsZXMgdGhpcyBmZWF0dXJlLCBj
aGFuZ2VzIHRoZSBkZWZhdWx0IGJlaGF2aW9yLg0KPiA+ID4gPiA+ID4gU2luY2UgbWluZSBwYXRj
aCBicmVha3MgdGhlIHJ1bGUgdGhhdCBuZXcgaW1wbGVtZW50YXRpb24NCj4gPiA+ID4gPiA+IHNo
b3VsZCBub3QgYnJlYWsgZXhpc3RpbmcgZGVzaWduLCBzbyBDYydlZCBsZXQgaGltIGtub3cgdG8g
c2VlDQo+ID4gPiA+ID4gPiBpZiBpdCBjYW4gYmUNCj4gPiA+IGFjY2VwdGVkLg0KPiA+ID4gPiA+
ID4NCj4gPiA+ID4gPiA+IENjOiBKaXNoZW5nIFpoYW5nIDxKaXNoZW5nLlpoYW5nQHN5bmFwdGlj
cy5jb20+DQo+ID4gPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWlu
Zy56aGFuZ0BueHAuY29tPg0KPiA+ID4gPiA+ID4gLS0tDQo+ID4gPiA+ID4gPiAgZHJpdmVycy9u
ZXQvcGh5L3JlYWx0ZWsuYyB8IDIwICsrKysrKysrKysrKysrKysrLS0tDQo+ID4gPiA+ID4gPiAg
MSBmaWxlIGNoYW5nZWQsIDE3IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4gPiA+
ID4gPg0KPiA+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9yZWFsdGVrLmMN
Cj4gPiA+ID4gPiA+IGIvZHJpdmVycy9uZXQvcGh5L3JlYWx0ZWsuYyBpbmRleCBjYTI1OGYyYTk2
MTMuLjc5ZGM1NWJiNDA5MQ0KPiA+ID4gPiA+ID4gMTAwNjQ0DQo+ID4gPiA+ID4gPiAtLS0gYS9k
cml2ZXJzL25ldC9waHkvcmVhbHRlay5jDQo+ID4gPiA+ID4gPiArKysgYi9kcml2ZXJzL25ldC9w
aHkvcmVhbHRlay5jDQo+ID4gPiA+ID4gPiBAQCAtNzYsNiArNzYsNyBAQCBNT0RVTEVfQVVUSE9S
KCJKb2huc29uIExldW5nIik7DQo+ID4gPiA+ID4gPiBNT0RVTEVfTElDRU5TRSgiR1BMIik7DQo+
ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gIHN0cnVjdCBydGw4MjF4X3ByaXYgew0KPiA+ID4gPiA+
ID4gKyAgICAgICB1MTYgcGh5Y3IxOw0KPiA+ID4gPiA+ID4gICAgICAgICB1MTYgcGh5Y3IyOw0K
PiA+ID4gPiA+ID4gIH07DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gQEAgLTk4LDYgKzk5LDE0
IEBAIHN0YXRpYyBpbnQgcnRsODIxeF9wcm9iZShzdHJ1Y3QgcGh5X2RldmljZQ0KPiA+ID4gKnBo
eWRldikNCj4gPiA+ID4gPiA+ICAgICAgICAgaWYgKCFwcml2KQ0KPiA+ID4gPiA+ID4gICAgICAg
ICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ICsgICAg
ICAgcHJpdi0+cGh5Y3IxID0gcGh5X3JlYWRfcGFnZWQocGh5ZGV2LCAweGE0MywNCj4gPiA+ID4g
PiBSVEw4MjExRl9QSFlDUjEpOw0KPiA+ID4gPiA+ID4gKyAgICAgICBpZiAocHJpdi0+cGh5Y3Ix
IDwgMCkNCj4gPiA+ID4gPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gcHJpdi0+cGh5Y3IxOw0K
PiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gKyAgICAgICBwcml2LT5waHljcjEgJj0gKFJUTDgy
MTFGX0FMRFBTX1BMTF9PRkYgfA0KPiA+ID4gPiA+ID4gKyBSVEw4MjExRl9BTERQU19FTkFCTEUg
fCBSVEw4MjExRl9BTERQU19YVEFMX09GRik7DQo+ID4gPg0KPiA+ID4gSSBiZWxpZXZlIHlvdXIg
aW50ZW50aW9uIGlzDQo+ID4gPg0KPiA+ID4gcHJpdi0+cGh5Y3IxICY9IH4oUlRMODIxMUZfQUxE
UFNfUExMX09GRiB8IFJUTDgyMTFGX0FMRFBTX0VOQUJMRSB8DQo+ID4gPiBwcml2LT5SVEw4MjEx
Rl9BTERQU19YVEFMX09GRik7DQo+ID4gPiBIb3dldmVyLCB0aGlzIGlzIG5vdCBuZWNlc3Nhcnku
IFNlZSBiZWxvdy4NCj4gPg0KPiA+IE5vLCBtaW5lIGludGVudGlvbiBpcyB0byByZWFkIGJhY2sg
dGhpcyB0aHJlZSBiaXRzIHdoYXQgdGhlIHJlZ2lzdGVyIGNvbnRhaW5lZC4NCj4gPg0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gcHJpdi0+cGh5Y3IxIGlzIDAgYnkgZGVmYXVsdCwgc28gYWJvdmUgNSBM
b0NzIGNhbiBiZSByZW1vdmVkDQo+ID4gPiA+DQo+ID4gPiA+IFRoZSBpbnRlbnRpb24gb2YgdGhp
cyBpcyB0byB0YWtlIGJvb3Rsb2FkZXIgaW50byBhY2NvdW50LiBTdWNoIGFzDQo+ID4gPiA+IHVi
b290DQo+ID4gPiBjb25maWd1cmUgdGhlIFBIWSBiZWZvcmUuDQo+ID4gPg0KPiA+ID4gVGhlIGxh
c3QgcGFyYW0gInNldCIgb2YgcGh5X21vZGlmeV9wYWdlZF9jaGFuZ2VkKCkgbWVhbnMgKmJpdCBt
YXNrDQo+ID4gPiBvZiBiaXRzIHRvIHNldCogSWYgd2UgZG9uJ3Qgd2FudCB0byBlbmFibGUgQUxE
UFMsIDAgaXMgZW5vdWdoLg0KPiA+ID4NCj4gPiA+IEV2ZW4gaWYgdWJvb3QgY29uZmlndXJlZCB0
aGUgUEhZIGJlZm9yZSBsaW51eCwgSSBiZWxpZXZlDQo+ID4gPiBwaHlfbW9kaWZ5X3BhZ2VkX2No
YW5nZWQoKSBjYW4gY2xlYXIgQUxEUFMgYml0cyB3L28gYWJvdmUgNSBMb0NzLg0KPiA+DQo+ID4g
VGhlIGxvZ2ljIGlzOg0KPiA+IDEpIHJlYWQgYmFjayB0aGVzZSB0aHJlZSBiaXRzIGZyb20gdGhl
IHJlZ2lzdGVyLg0KPiA+IDIpIGlmIGxpbnV4IHNldCAicmVhbHRlayxhbGRwcy1lbmFibGUiLCBh
c3NlcnQgdGhlc2UgdGhyZWUgYml0OyBpZiBub3QsIGtlZXAgdGhlc2UNCj4gdGhyZWUgYml0cyBy
ZWFkIGJlZm9yZS4NCj4gPiAzKSBjYWxsIHBoeV9tb2RpZnlfcGFnZWRfY2hhbmdlZCgpIHRvIGNv
bmZpZ3VyZSwgIm1hc2siIHBhcmFtZXRlciB0byBjbGVhcg0KPiB0aGVzZSB0aHJlZSBiaXRzIGZp
cnN0LCAic2V0IiBwYXJhbWV0ZXIgdG8gYXNzZXJ0IHRoZXNlIHRocmVlIGJpdHMgcGVyIHRoZSBy
ZXN1bHQNCj4gb2Ygc3RlcCAyLg0KPiA+DQo+ID4gU28sIGlmIHN0ZXAgMSByZWFkIGJhY2sgdGhl
IHZhbHVlIGlzIHRoYXQgdGhlc2UgdGhyZWUgYml0cyBhcmUgYXNzZXJ0ZWQsIHRoZW4gaW4NCj4g
c3RlcCAzLCBpdCB3aWxsIGZpcnN0IGNsZWFyIHRoZXNlIHRocmVlIGJpdHMgYW5kIGFzc2VydCB0
aGVzZSB0aHJlZSBiaXRzIGFnYWluLiBUaGUNCj4gcmVzdWx0IGlzIEFMRFBTIGlzIGVuYWJsZWQg
ZXZlbiB3aXRob3V0ICIgcmVhbHRlayxhbGRwcy1lbmFibGUgIiBpbiBEVC4NCj4gPg0KPiANCj4g
QWhhLCBJIHNlZSB5b3Ugd2FudCB0byBrZWVwIHRoZSBBTERQUyBiaXRzKG1heWJlIGNvbmZpZ3Vy
ZWQgYnkgcHJlbGludXggZW52KQ0KPiB1bnRvdWNoZWQuDQo+IElmIEFMRFBTIGhhcyBiZWVuIGVu
YWJsZWQgYnkgcHJlbGludXggZW52LCBldmVuIHRoZXJlJ3Mgbm8NCj4gInJlYWx0ZWssYWxkcHMt
ZW5hYmxlIg0KPiBpbiBEVCwgdGhlIEFMRFBTIG1heSBiZSBrZWVwIGVuYWJsZWQgaW4gbGludXgu
IFRodXMgdGhlIEFMRFBTIGJlaGF2aW9yIHJlbHkgb24NCj4gdGhlIHByZWxpbnV4IGVudi4gSSdt
IG5vdCBzdXJlIHdoZXRoZXIgdGhpcyBpcyBjb3JyZWN0IG9yIG5vdC4NCj4gDQo+IElNSE8sIHRo
ZSAicmVhbHRlayxhbGRwcy1lbmFibGUiIGlzIGEgInllcyIgb3IgIm5vIiBib29sLiBJZiBpdCdz
IHNldCwgQUxEUFMgd2lsbA0KPiBiZSBlbmFibGVkIGluIGxpbnV4OyBJZiBpdCdzIG5vLCBBTERQ
UyB3aWxsIGJlIGRpc2FibGVkIGluIGxpbnV4LiBXZSBzaG91bGQgbm90IHJlbHkNCj4gb24gcHJl
bGludXggZW52Lg0KDQpZb3UgY2FuIHJlZmVyIHRvIGJlbG93IFYxIGNvbW1lbnRzLCB3ZSBtYXkg
bm90IHRha2UgZW5vdWdoIGNhc2VzIGludG8gYWNjb3VudCwgb3RoZXJzIG1heSBjYXJlIGFib3V0
IGJvb3QgbG9hZGVyLiANCmh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDIxLzYvMS8yNjQNCg0KQW55
d2F5LCBrZWVwIHRoZSBvcmlnaW5hbCB2YWx1ZSBpbiByZWdpc3RlcnMgc2hvdWxkIG5vdCBoYXZl
IHNpZGUgZWZmZWN0cy4gVGhhbmtzIGZvciB5b3VyIHJldmlld2luZywgYW5kIEkgc2F3IHRoaXMg
cGF0Y2ggc2V0IGhhcyBiZWVuDQphY2NlcHRlZCwgaWYgeW91IHdhbnQgdG8gaW1wcm92ZSB0aGlz
IGNvZGUsIEkgYW0gaGFwcHkgdG8gcmV2aWV3IGFuZCB0ZXN0IHlvdXIgcGF0Y2guDQoNCkJlc3Qg
UmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiBUaGFua3MNCg==
