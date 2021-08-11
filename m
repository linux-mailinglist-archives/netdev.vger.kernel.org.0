Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89613E8B55
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 09:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbhHKH6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 03:58:33 -0400
Received: from mail-am6eur05on2069.outbound.protection.outlook.com ([40.107.22.69]:22804
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233850AbhHKH6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 03:58:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fgAeSXFmRgoEjWVgj88bqPdWmN7lHDRTuXxgjqo28IpvIIezWMWqGf89D+twsfXf0g7genTXgawJV86tBsHRNmjWCp0inXMNjxDQ9Jkvd/z4AY3zLD05KMhogxi0mT6sC7/wn8XkK5G7oHlVslNOq0GVmu8b7+CfPbKuC6UhkPt9MPPdCWfB5s8gBkmoxRCQ/MxVRLvVcgECfMlteI1RfIIXUJaav0QMgDGEkl1pzvURUFqfija16DeiPuED9ECoDDmUqB3gSD8GVAqeyihwqZHXmcOaLF1gHnwdlBWINwZpQRXUqjhDYU/xF012BFv2bEbK/g1/0dP7+VU1h++m6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L98PqshvS9yNMiQ4cKstmz2oeSEfYnmC9U7TrSrK5BI=;
 b=Jr0Giv5IF1cnkG6V4EsZsbLPyqpSV52iBn5iJ7MYc0iOI5LOu+FXpPgzlN5+oovHTVskG3kwV+M1katT4kQU+t1FFpBy5Ekp/RB/CS0fRBYh5ORil9lQCKDVBrQGV1HNDG/jxNvnFQ1BHReTThP/o92Mq7dDUUr4bMdSIsIZY0Z0azX3stGKbfzhAvntOjMNh4/FRHlHzUvPEufftV6jrTTAHTll9/3XU5lOrVBJtGl5wdwab18GQHibbgJua3RcRSQoKRya6zBZfgPZ5HHA1wZ+jZgtwlcXFyEOlzxf23iz3IxfFwAz6x92TvmJrqChR8FWDgcY4A1c88uUHzCj4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L98PqshvS9yNMiQ4cKstmz2oeSEfYnmC9U7TrSrK5BI=;
 b=UqSrwI3uRLXYXtz4l3IqMVRo3ybhKaMEZSRMnNlmJXdJnP6RmrAKZG8TmHO4HbSEog1DdVBKCFPhoNYBFgXAMXU+QuwwO1Zm0mj0UeJ6rspkI/5mLSC7aEpg4e06EJ91nVt+uFeTGuEr0dXKKnhcmbyU+qLDKFKN4EOz4YVCftc=
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VI1PR04MB6798.eurprd04.prod.outlook.com (2603:10a6:803:131::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Wed, 11 Aug
 2021 07:57:47 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::498:421b:7d3:a0c3]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::498:421b:7d3:a0c3%8]) with mapi id 15.20.4415.016; Wed, 11 Aug 2021
 07:57:47 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
 wakeup-irq" property
Thread-Topic: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
 wakeup-irq" property
Thread-Index: AQHXidrZaeAm3FGM8UWFBIfAWGHBc6tqnwvwgADpEgCAAHa+4IAA1qiAgADpUEA=
Date:   Wed, 11 Aug 2021 07:57:46 +0000
Message-ID: <VI1PR04MB6800EE08F70CC3F0DD53C991E6F89@VI1PR04MB6800.eurprd04.prod.outlook.com>
References: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
 <20210805074615.29096-2-qiangqing.zhang@nxp.com>
 <2e1a14bf-2fa8-ed39-d133-807c4e14859c@gmail.com>
 <DB8PR04MB67950F6863A8FEE6745CBC68E6F69@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <498f3cee-8f37-2ab1-93c4-5472572ecc37@gmail.com>
 <DB8PR04MB6795DC35D0387637052E64A1E6F79@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YRKOGYwx1uVdsKoF@lunn.ch>
In-Reply-To: <YRKOGYwx1uVdsKoF@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e3876d2-60c2-49e0-9b70-08d95c9db55f
x-ms-traffictypediagnostic: VI1PR04MB6798:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB679898F13A81785CCB6F4F06E6F89@VI1PR04MB6798.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q3QMQyZi0A6PmZXhZPcB/Yy/FS0ucOJM9k+x+2YN7DPmwFVcAdedTZvNRYE7xj8UPh8bLVscit/1/lBLGXLpedSs/8++sKEskeM9VI459XwHULmGHD1cf2cURxsHlh2oT6NOSgGT84z4et6fUtUFqYq+lXZQ4gm6pebN9slHNEvYPIYTMjUdZDhbulGsJUYClvhQMwQNT2jTHjeKrUJUOSodhYqHOiTOdaXnrKqKAAisAHOIKLaJXVaxc8Y9rPuRUgEVFIehIrpe8QmNWMHGYdyn7LTJINost8khehofUuzQvJS0KFMcSj/yWBj9a/cdGbEz2ugGeevoiDi1sLdx0CxKOHtRJhEk03ggPZuOq8Jh4sYFY8JsY1rBm1TnCvQ19F/ExsrsJHwjrUXqh6lCrzff8H2rkb6q850Ft/DxuXlA6vLJzEnY/StVwDWbHCNvQ7YUU+UI6hpraRmlgEUd8qwYY1oBJqSUYE+qXKVFwgsbYgAZoThbgNysUuv1uyDELAmszyPP4S7jclx7Xhk7HwRwFqbKfduUmCuuVtFNQpKp7j6pi3bvUfdXTIIeKyQibfJuqIpb+Qi++GO0LlZoNJ9qURGlm8ZZwiXYhjtb5JrLxLyhfp4QDJDwX+8LaIo8r+H5smEFQutfOVhzl/+OXHwZNjaYG0TcVJ/VjeT4ZYO4AGSir6lJV/foOH/ebJZSzwfD3w8jWbmN4QJldQ4LNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(53546011)(54906003)(6916009)(52536014)(186003)(6506007)(86362001)(478600001)(9686003)(316002)(38070700005)(7696005)(8676002)(7416002)(26005)(122000001)(33656002)(76116006)(71200400001)(2906002)(66476007)(4326008)(5660300002)(83380400001)(55016002)(66446008)(64756008)(8936002)(66946007)(66556008)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?NExEN3R3UGxadTB1VWM0eEF0Y25SWHVINmtKSEEvR2Ztem1ZM0JvakRlSUhs?=
 =?gb2312?B?bTJ6SlUxMHJrbFFVL3ZNS01DNXVtTlF3aFNLbTcyRm9mdUt3Q2JJdytuSEZF?=
 =?gb2312?B?eHREUUY1U2RQVTVaUjY5RjFKR08zTWdoYUFDNTUyV0dFaE92eVovTDRZZDBl?=
 =?gb2312?B?SEVQc1pxeUFISXlGZjFScENxREdRdlNIS3haWXkzcmJBOVpnNExYVTZSR012?=
 =?gb2312?B?dHh6TUxtakd4VGNzWjNwRkwwU1pVQXRWcWkrTzhMUzV3SndoNVIzdUVDYUlX?=
 =?gb2312?B?Q0tiQmljNzc5T1YvWjJmVUVaOEU4RnNpWklGS1UrSW14ZWV1MHZHNnlNb2ZP?=
 =?gb2312?B?aEVhMjVjbHUvY0NnNHlmMDlybVE1UVYxUVVNQ2trMzN5eklLa0ZhRStsUGoz?=
 =?gb2312?B?L2E2OWRMdGRMRFpoYTJ4MzJFSjVzVm5zRVBVQWgya1JIc203QTZHM2FaN0FX?=
 =?gb2312?B?TjlGTmdpQ2NSbUxaMG1ibmt2NTdkc3VMSjkyL0hTZlN2b0xrRzlya1ZqN1FV?=
 =?gb2312?B?azRDd0FkSDNaKzdBM2xhZVRldmcrazlxbEtONUJkTXV5NUEyMG1vR2JBUmtO?=
 =?gb2312?B?bUxDNjFwdXA2R1ZWR21KdHJVSE5QdUx2S0VsY3ZEYzNBb2w3Zk9HM25qeHlh?=
 =?gb2312?B?Z01SMU1TWUFjdlJtTDZtdTdSOTh1OVBLNm5GMFIwZGlab2Rna1ByR2NuRFYv?=
 =?gb2312?B?cTZ0cG14RVdpQzJyK0RQTlFKaWNZQ1VjMmJ5a21SbUxqdjYveFZUZXI0NlJ2?=
 =?gb2312?B?MWUwbHBRcmtWOUltZVhMOUppSUd0WmpwbVBkS0ZiZ2JqNm83NjAweUtmdXNV?=
 =?gb2312?B?Wng0UHMwazNGWDJRK2pVeU5KckdpeXRkRFcrRW81NVlRdmVDQ0VKUGd1N1dq?=
 =?gb2312?B?VWxuMkJoUkpnMUVHNVRveUdUTDA1bUtNVUNBTG95VFoyeDZFcHpYeGo3NG1Y?=
 =?gb2312?B?OVpnMDVKd1BqRk9Vd29xd2YvVTAzbXI0a3NNRjBINFMwdDgxeGJINys3MERP?=
 =?gb2312?B?N3dsbjAzZGJXcnZDWGZKR2R1eW1CWnQ0Zkx6YlVzcTd1RThmWjh4RWZOYWhD?=
 =?gb2312?B?aW5zMmMwdTBQTkNVcjlPTjQvNUtKcVJacUZuV3BEZ2JmK3R6Z0k0UHVocGZm?=
 =?gb2312?B?NlVJcEJaQ3ErRW1IWmVIUFZGbDBQOEFueGZON0szaFRCdjI2WmszTE1QaFNU?=
 =?gb2312?B?YzEzd0ZDTS9WMXEvamxST1NmR2ZlL250dldQVDhFRktGWGVJNjBKZlowcU5O?=
 =?gb2312?B?cHVpU09MTHc0TFRrMjdOb1VkOWxTOWUwRFFVaVJUZ2FwWTVxeWJPWGRGQThi?=
 =?gb2312?B?MTVJazBHWlAvWVFHVlh0V0dwajVHckFVVEl6UDRwSkNySDNwdEc0d25lMTI0?=
 =?gb2312?B?N1VYWHkzZlFPTmw0NmpmbEhrK0tXQmZNK0dSYWM3azZlT3pVc2pONGtQZDlm?=
 =?gb2312?B?VjgzNlhYZmxIRkhmMGo5emtHKzhCQm0rUG1rbkw1OHB0M3RtVlFoaDhGd1E5?=
 =?gb2312?B?MFpDN01mOUpZL2l6NGdvU0l4ejNPY2FXeEh4RjhXeGRSZC8rK0RSb1RnbmU3?=
 =?gb2312?B?RnNYSHB3M1U0cEZtYkd4elYxeEMxM0FXU29Xa3c0bkNQdjNGOGRJV3E5UXpH?=
 =?gb2312?B?aCtFelFqMnJWRnp3eUlhQS9jeEljU0MrMUxyVVI5ak9CdDdtVmtxcjFhNDlN?=
 =?gb2312?B?R2E2QUtMTVVPMlVLcVRHakRXVENHOENjNUp5VkdzMlFST2t4NmNIQ01NVGNF?=
 =?gb2312?Q?T5i+cB+hc/YGRqnDWg=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e3876d2-60c2-49e0-9b70-08d95c9db55f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2021 07:57:47.0645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DjjOVEmXmO4j5YxaGg48TgHmoxrnKNM6ML6Uk0PgbUyxwAiJzioQcQ2aBBRaHqykSn6PNJg5iT1VjYdbDXQYJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6798
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbmRyZXcsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5k
cmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIxxOo41MIxMMjVIDIyOjMzDQo+
IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogRmxvcmlh
biBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0K
PiBrdWJhQGtlcm5lbC5vcmc7IHJvYmgrZHRAa2VybmVsLm9yZzsgc2hhd25ndW9Aa2VybmVsLm9y
ZzsNCj4gcy5oYXVlckBwZW5ndXRyb25peC5kZTsgZmVzdGV2YW1AZ21haWwuY29tOyBrZXJuZWxA
cGVuZ3V0cm9uaXguZGU7DQo+IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRl
YWQub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMS8zXSBkdC1iaW5kaW5nczog
bmV0OiBmc2wsIGZlYzogYWRkICJmc2wsDQo+IHdha2V1cC1pcnEiIHByb3BlcnR5DQo+IA0KPiA+
ID4gPiAxKSBGRUMgY29udHJvbGxlciBoYXMgdXAgdG8gNCBpbnRlcnJ1cHQgbGluZXMgYW5kIGFs
bCBvZiB0aGVzZSBhcmUNCj4gPiA+ID4gcm91dGVkIHRvIEdJQw0KPiA+ID4gaW50ZXJydXB0IGNv
bnRyb2xsZXIuDQo+ID4gPiA+IDIpIEZFQyBoYXMgYSB3YWtldXAgaW50ZXJydXB0IHNpZ25hbCBh
bmQgYWx3YXlzIGFyZSBtaXhlZCB3aXRoDQo+ID4gPiA+IG90aGVyDQo+ID4gPiBpbnRlcnJ1cHQg
c2lnbmFscywgYW5kIHRoZW4gb3V0cHV0IHRvIG9uZSBpbnRlcnJ1cHQgbGluZS4NCj4gPiA+ID4g
MykgRm9yIGxlZ2FjeSBTb0NzLCB3YWtldXAgaW50ZXJydXB0IGFyZSBtaXhlZCB0byBpbnQwIGxp
bmUsIGJ1dA0KPiA+ID4gPiBmb3IgaS5NWDhNDQo+ID4gPiBzZXJpYWxzLCBhcmUgbWl4ZWQgdG8g
aW50MiBsaW5lLg0KPiANCj4gU28geW91IG5lZWQgdG8ga25vdyB3aGljaCBvZiB0aGUgaW50ZXJy
dXB0cyBsaXN0ZWQgaXMgdGhlIHdha2UgdXAgaW50ZXJydXB0Lg0KPiANCj4gSSBjYW4gc2VlIGEg
ZmV3IHdheXMgdG8gZG8gdGhpczoNCj4gDQo+IFRoZSBGRUMgZHJpdmVyIGFscmVhZHkgaGFzIHF1
aXJrcy4gQWRkIGEgcXVpcmsgdG8gZmVjX2lteDhtcV9pbmZvIGFuZA0KPiBmZWNfaW14OHFtX2lu
Zm8gdG8gaW5kaWNhdGUgdGhlc2Ugc2hvdWxkIHVzZSBpbnQyLg0KPiANCj4gb3INCj4gDQo+IERv
Y3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9pbnRlcnJ1cHQtY29udHJvbGxlci9pbnRl
cnJ1cHRzLnR4dA0KPiANCj4gICBiKSB0d28gY2VsbHMNCj4gICAtLS0tLS0tLS0tLS0NCj4gICBU
aGUgI2ludGVycnVwdC1jZWxscyBwcm9wZXJ0eSBpcyBzZXQgdG8gMiBhbmQgdGhlIGZpcnN0IGNl
bGwgZGVmaW5lcyB0aGUNCj4gICBpbmRleCBvZiB0aGUgaW50ZXJydXB0IHdpdGhpbiB0aGUgY29u
dHJvbGxlciwgd2hpbGUgdGhlIHNlY29uZCBjZWxsIGlzIHVzZWQNCj4gICB0byBzcGVjaWZ5IGFu
eSBvZiB0aGUgZm9sbG93aW5nIGZsYWdzOg0KPiAgICAgLSBiaXRzWzM6MF0gdHJpZ2dlciB0eXBl
IGFuZCBsZXZlbCBmbGFncw0KPiAgICAgICAgIDEgPSBsb3ctdG8taGlnaCBlZGdlIHRyaWdnZXJl
ZA0KPiAgICAgICAgIDIgPSBoaWdoLXRvLWxvdyBlZGdlIHRyaWdnZXJlZA0KPiAgICAgICAgIDQg
PSBhY3RpdmUgaGlnaCBsZXZlbC1zZW5zaXRpdmUNCj4gICAgICAgICA4ID0gYWN0aXZlIGxvdyBs
ZXZlbC1zZW5zaXRpdmUNCj4gDQo+IFlvdSBjb3VsZCBhZGQNCj4gDQo+ICAgICAgICAxOCA9IHdh
a2V1cCBzb3VyY2UNCj4gDQo+IGFuZCBleHRlbmQgdG8gY29yZSB0byBlaXRoZXIgZG8gYWxsIHRo
ZSB3b3JrIGZvciB5b3UsIG9yIHRlbGwgeW91IHRoaXMgaW50ZXJydXB0IGlzDQo+IGZsYWdnZWQg
YXMgYmVpbmcgYSB3YWtldXAgc291cmNlLiBUaGlzIHNvbHV0aW9uIGhhcyB0aGUgYWR2YW50YWdl
IG9mIGl0IHNob3VsZA0KPiBiZSB1c2FibGUgaW4gb3RoZXIgZHJpdmVycy4NCg0KVGhhbmtzIGEg
bG90IGZvciB5b3VyIGNvbW1lbnRzIGZpcnN0IQ0KDQpJIGp1c3QgbG9vayBpbnRvIHRoZSBpcnEg
Y29kZSwgaWYgd2UgZXh0ZW5kIGJpdFs1XSB0byBjYXJyeSB3YWtldXAgaW5mbyAoIGR1ZSB0byBi
aXRbNF0gaXMgdXNlZCBmb3IgSVJRX1RZUEVfUFJPQkUpLCANCnRoZW4gY29uZmlndXJlIGl0IGlu
IHRoZSBUWVBFIGZpZWxkIG9mICdpbnRlcnJ1cHRzJyBwcm9wZXJ0eSwgc28gdGhhdCBpbnRlcnJ1
cHQgY29udHJvbGxlciB3b3VsZCBrbm93IHdoaWNoIGludGVycnVwdA0KaXMgd2FrZXVwIGNhcGFi
bGUuIA0KSSB0aGluayB0aGVyZSBpcyBubyBtdWNoIHdvcmsgY29yZSB3b3VsZCBkbywgbWF5IGp1
c3Qgc2V0IHRoaXMgaW50ZXJydXB0IHdha3VwIGNhcGFibGUuIEFub3RoZXIgZnVuY3Rpb25hbGl0
eSBpcw0KZHJpdmVyIHNpZGUgZ2V0IHRoaXMgaW5mbyB0byBpZGVudGlmeSB3aGljaCBtaXhlZCBp
bnRlcnJ1cHQgaGFzIHdha2V1cCBjYXBhYmlsaXR5LCB3ZSBjYW4gZXhwb3J0IHN5bWJvbCBmcm9t
IGtlcm5lbC9pcnEvaXJxZG9tYWluLmMuDQoNClRoZSBpbnRlbnRpb24gaXMgdG8gbGV0IGRyaXZl
ciBrbm93IHdoaWNoIGludGVycnVwdCBpcyB3YWtldXAgY2FwYWJsZSwgSSB3b3VsZCBjaG9vc2Ug
dG8gcHJvdmlkZXIgdGhpcyBpbiBzcGVjaWZpYyBkcml2ZXIsDQppbnN0ZWFkIG9mIGludGVycnVw
dCBjb250cm9sbGVyLCBpdCBzZWVtcyB0byBtZSB0aGF0IG90aGVycyBtYXkgYWxsIGNob29zZSB0
aGlzIHNvbHV0aW9uIGZvciB3YWtldXAgbWl4ZWQgaW50ZXJydXB0Lg0KDQpTbyBJIHdvdWxkIHBy
ZWZlciBzb2x1dGlvbiAxLCBpdCdzIGVhc2llciBhbmQgdW5kZXItY29udHJvbC4gSSBjYW4gaGF2
ZSBhIHRyeSBpZiB5b3Ugc3Ryb25nbHkgcmVjb21tZW5kIHNvbHV0aW9uIDIuDQoNCkJlc3QgUmVn
YXJkcywNCkpvYWtpbSBaaGFuZw0KPiAJICBBbmRyZXcNCg==
