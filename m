Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6490E365368
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhDTHlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 03:41:31 -0400
Received: from mail-eopbgr20055.outbound.protection.outlook.com ([40.107.2.55]:54914
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229485AbhDTHla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 03:41:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIo8WuIBDViaWHyJUu4K/QpBE+AfXOOKcPUf0gjWYDvF0ehZffwBQF9oQwIjmziYRkfJPxo3czfBQYslDXNvFuiNXR7wHm3JhHeyRtAxvjwfVaHXnKvH9Ffijgvc8l/3TkQ1ozlffcAAVsKgKHq77m03HTndFQzwZcKVEuPInT0nodzAT/NY6SaCd+5b2UBtzzc8sSadCnbnL/OeOMq9LODL2+BORPxmUjMtR9Bd/sA+akz1seB9Xind0wZXK2G8JheLNflk5XKSAewxe+ukSjnqwwg8EWwl6GZLyeVpeNhhwRczSv2p7/mEQ0zzzD9Xd1vpmlC3rbKiRzCwwu/SHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5T195rgK9IVIabmFEBbAf8kKq7vk5cJZvVqvwBoHUE=;
 b=i4WafDbcpyU+NEP2XNOGMDjJWU++NCqf42cltIqcDY7JG+HU4zlzovEIhxq74cet7m8ie5w0rpsedZ7FP0u0b2HzuPY9x6wxZic0ULEkWBdMvKUzt2qAYqOaX9xFtaE+2ej6Vjj8InSrVFNuEbk0IIhaIzmN0rcXvGsr5K/zkEcAqxpIFsDUx4VXnj80SewKJahb+mZrpQ0qwA3vEHeEXxAeLW6asoGq1dL0GYK8YyzWnTjSQQXen4z0XxPee17iSQdhHka2OAVKXB4TPh8cLrHGCH5zAMAF0gox6/L4VcnhwDBEB1E/jWJ4/JiOi4KLAGji3d/R/r7tDKUd/FcUXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5T195rgK9IVIabmFEBbAf8kKq7vk5cJZvVqvwBoHUE=;
 b=AfzeWIIQrbYDw9HkKYZCI+e/tXEO7NeBnoXLQ7DhtY+V9BzaaqatfXn/msy4hhsGD9A8MeVazz9RuUH2I9qsGeBHymVVoNbgrlVqwBiH0zqpIk+s3YIVF3nNNgoEqgahHg4wp9iEUGO/tvvamdpKEK6DD8fT6E2aG8SbXCCJ5us=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM6PR04MB4200.eurprd04.prod.outlook.com (2603:10a6:209:4f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 07:40:56 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777%3]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 07:40:56 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [net-next 1/3] net: dsa: optimize tx timestamp request handling
Thread-Topic: [net-next 1/3] net: dsa: optimize tx timestamp request handling
Thread-Index: AQHXMrxTcFa/yb7c402hVeJWcQQ266q6Y1GAgAKoCNA=
Date:   Tue, 20 Apr 2021 07:40:56 +0000
Message-ID: <AM7PR04MB68857C8DBF0D5ED26998ABA7F8489@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20210416123655.42783-1-yangbo.lu@nxp.com>
 <20210416123655.42783-2-yangbo.lu@nxp.com>
 <20210418150623.GA24506@hoboy.vegasvil.org>
In-Reply-To: <20210418150623.GA24506@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a724bf4-199a-43f3-754c-08d903cfa288
x-ms-traffictypediagnostic: AM6PR04MB4200:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB4200FC021C173A21CE5182BAF8489@AM6PR04MB4200.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yZxFlf3TBKxH0asIfMxo8VF/n9Ps3QxTjv+2NT1A4qH0Jdbt16UHzB+ZH01SXFSFNC9uhwRGWdpj0XmKG1eqTZabjU4NneKGrlrI4GX/DYiNh7KJGAWhCjpj374Nf/iUbRve3T42tcVefyy/yaWs+iwBwtq4e/sAhWPbfjwjltOgUVCJQYUFwCdLUbesXtDEDWf/aCveU76OalF4xP7oHZfd/ydgg+jv5fIGU0bkPtFhLpCWeQ82k8hOGXuxdv9b81XE/AFezb9XX08A6tsA2dyqZnVohMw9mHq/ILo9J3W4n6FIKLNhj2cvw0vD1FOyCRHO9NnLNT0mVZ//jLp4BDHxf9yffVzzymbvE9jcs9AsvKugCRoA8CYf8FMMWklgKNTr8719pjRuJ5Jowkzfvg1pSHuqgqEv3QGgf6JaRzFILaTfniSXTvvL8MQRm6FaimjdeShWR7ddvsAu7nkeQ5PjnvzdC0dLyjmQO0bivsPvOhFrQccxQPNJe4fABVjVq8QGGd/L4McHsDtWA2U/nhlC+4jt0gEtXz9V41OsGLbalkbvDlI33Jnre5GDHz6bOM41gQnbSwOxFugEUlzwyFSyhhW4MvdmdgDKU7Owp1U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(33656002)(2906002)(64756008)(122000001)(9686003)(26005)(38100700002)(76116006)(55016002)(52536014)(53546011)(83380400001)(71200400001)(8676002)(4326008)(7696005)(498600001)(7416002)(186003)(6916009)(8936002)(54906003)(5660300002)(66476007)(66946007)(66446008)(6506007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?SVRPblRoSi80Q2pOYWxnYmNIaXBESU9HSEh1VDN2MDBobk5LaW5XTDA4MUNZ?=
 =?gb2312?B?eXE4TlB2bXNwQjYwS3BkUXF2SDg3R3QzYm9aaWs2azV6eFNuQ0VmSlpxaXBZ?=
 =?gb2312?B?RzJLclVJbXh2bCtROWM3c2dOWngxTkxnZ0hnaWFtNGlFK0wreUdHT1FaaEdD?=
 =?gb2312?B?OTdpWUhkMXJPOWVsMlVHVXZPdUtpZEgzc2YyaGxBMjU0SytoYVFMZUZIZHB5?=
 =?gb2312?B?c2FHYXcvNDFVNXZNY0J6SFgrWkhXbmtiWlRqWHBieHhudzc3dVRhSWJPVk5H?=
 =?gb2312?B?djBKdGJsQVArbXptM1g5Y01oV0RsYlVFYWhVeG9iNWl3TE12N1VyaFIzWi9F?=
 =?gb2312?B?eXJZMWZkWWRuOXlTaGtTQ011dmQ5dG8yQVRNRWx0cnhUaUNka1hNbGVoeEM0?=
 =?gb2312?B?azV2eVpTaEZWU3V2S0s0Z3pkTW5waWhJMjlGM1pZOEV3aDJZUkNUaFpSVVY4?=
 =?gb2312?B?WllXc2Q1Q2lSdE9FM3pXM21peENwOElwNVA4TFA1cVJqQ09vL0dWY1RzcSt5?=
 =?gb2312?B?akx1dmZ5NFZSKy9ibEtxK3IrTTNadllIMTNLL3QrVHM4OFV0L2JxbXdoeXFj?=
 =?gb2312?B?WGl4eVVIQmp4K2hXbHNkcXlwVXlhQlowTi9Ba1pDcnpYQW5yaHpOYzUwMnpB?=
 =?gb2312?B?dmJpSWRTQUFZcHM3VkJzR1kvcTVHZU15S252aHZ5YjJUSFF5R0thU1BCTDEz?=
 =?gb2312?B?M0gzRGNBQ3d3WDJncDNaSWVkSkFmalYraEdkelhmeEl5UlZTbHlmTEI0QWw5?=
 =?gb2312?B?RnNkTFMyalo0b3l3cmdxT2FvUEJHSFE4Um4zV0NyL0Yvb1Q3aHdzcTBPNzli?=
 =?gb2312?B?YU1QUENTazVsSHdpVDdYeVpqR0Z2N2ZqTEgvS3lKUFFGcUwycHdEdEdpUmk0?=
 =?gb2312?B?RWsvaTZxblF1MSt2bTZFNlRaMmhFdnZ4b2l2ZEpxcDQvY2dHTGNqKzJWU25w?=
 =?gb2312?B?eStnd1FnRnpoYnpyU3JOZFEweTFkcFBMa3NIY1loSW1jb2pieS9rRVAwTjBp?=
 =?gb2312?B?SEpyK291U29PWkhiSzFFelVZRitWdjZBOXdQV24rUzVKbUpFUlVPQVIxd1hI?=
 =?gb2312?B?cDk1SlE2UGdLRUVVNERtUmVjRDhNM3lzU1JDSGRUeGRHbThIQVpEM2J6OGM5?=
 =?gb2312?B?UUFlc3A0akErRTl2cmgyMUxTSzRwa0orTjhuclNwSXpCTXpwZkxnc3ZnWWtS?=
 =?gb2312?B?Q0IxWnA0RUFLOE9HSWk0MnhyNGZYbkI0bTB5bmUveWZJdjFyaWMwK1o1VUZZ?=
 =?gb2312?B?cG01cE05UWY5ZlozeFR2TjhWdCt3SjhmOVc1amhRek5NZVpSYTAyVVQ0RWtz?=
 =?gb2312?B?OVQxQ3FNSTdxQitQbzU0VlVaMnl4eFZ0c2g3aXJPWWhzNEJoNC9PR0NkNXB4?=
 =?gb2312?B?VlBHWHFKejRuQXU2WmxJRGtiYTJOUk0wWEZZOHQxYzlVL2pJL2g1NG84QmM3?=
 =?gb2312?B?SDNCcU5iYnZ4UTltbURETG0vd3pnYldVT0NpYUtlM2ptN21kN0ZIdGR2M1ZE?=
 =?gb2312?B?Yit4M0Vhb0c2MHlTUDhRNlJ0d3B6YkNVSjl5bmFUbTE3M2lrejRuWTNLUzlE?=
 =?gb2312?B?eGxNaVBmdnA0dGJiN2RkNlIvMVAvWTN2elphWnF1Ly9mL3ZoKzdIU1k2T09p?=
 =?gb2312?B?Q1hmRDFCcGljZERUb1ZpSSsxdkswNFZUdld6WE92LzRIR0J0aEpYSmladkxK?=
 =?gb2312?B?aE45Y1hpenZCVmxnWGJLZTZIN1BzeTRoMHl4UTdmYVBHc0E1V2o0QXZlaXg5?=
 =?gb2312?Q?zkX/CY0aljmfhHZ5LgVTD+ChIwJKmSBqBpdqq4A?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a724bf4-199a-43f3-754c-08d903cfa288
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 07:40:56.7799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Z2cMWb35Focd/evl4iCWym0laIjjDYA/NFtLHdvpkd90ku5X6hV0pdygIDqANzWkzL9VT169CiJ5uIkoL4gKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNoYXJkIENvY2hyYW4gPHJp
Y2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNNTCMTjI1SAyMzowNg0KPiBU
bzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsNCj4gRGF2aWQg
UyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtl
cm5lbC5vcmc+Ow0KPiBKb25hdGhhbiBDb3JiZXQgPGNvcmJldEBsd24ubmV0PjsgS3VydCBLYW56
ZW5iYWNoIDxrdXJ0QGxpbnV0cm9uaXguZGU+Ow0KPiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4u
Y2g+OyBWaXZpZW4gRGlkZWxvdCA8dml2aWVuLmRpZGVsb3RAZ21haWwuY29tPjsNCj4gRmxvcmlh
biBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+OyBDbGF1ZGl1IE1hbm9pbA0KPiA8Y2xh
dWRpdS5tYW5vaWxAbnhwLmNvbT47IEFsZXhhbmRyZSBCZWxsb25pDQo+IDxhbGV4YW5kcmUuYmVs
bG9uaUBib290bGluLmNvbT47IFVOR0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5jb207DQo+IGxpbnV4
LWRvY0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3Vi
amVjdDogUmU6IFtuZXQtbmV4dCAxLzNdIG5ldDogZHNhOiBvcHRpbWl6ZSB0eCB0aW1lc3RhbXAg
cmVxdWVzdCBoYW5kbGluZw0KPiANCj4gT24gRnJpLCBBcHIgMTYsIDIwMjEgYXQgMDg6MzY6NTNQ
TSArMDgwMCwgWWFuZ2JvIEx1IHdyb3RlOg0KPiA+IE9wdGltaXphdGlvbiBjb3VsZCBiZSBkb25l
IG9uIGRzYV9za2JfdHhfdGltZXN0YW1wKCksIGFuZCBkc2EgZGV2aWNlDQo+ID4gZHJpdmVycyBz
aG91bGQgYWRhcHQgdG8gaXQuDQo+ID4NCj4gPiAtIENoZWNrIFNLQlRYX0hXX1RTVEFNUCByZXF1
ZXN0IGZsYWcgYXQgdGhlIHZlcnkgYmVnaW5uaW5nLCBpbnN0ZWFkIG9mIGluDQo+ID4gICBwb3J0
X3R4dHN0YW1wLCBzbyB0aGF0IG1vc3Qgc2ticyBub3QgcmVxdWlyaW5nIHR4IHRpbWVzdGFtcCBq
dXN0IHJldHVybi4NCj4gPg0KPiA+IC0gTm8gbG9uZ2VyIHRvIGlkZW50aWZ5IFBUUCBwYWNrZXRz
LCBhbmQgbGltaXQgdHggdGltZXN0YW1waW5nIG9ubHkgZm9yIFBUUA0KPiA+ICAgcGFja2V0cy4g
SWYgZGV2aWNlIGRyaXZlciBsaWtlcywgbGV0IGRldmljZSBkcml2ZXIgZG8uDQo+ID4NCj4gPiAt
IEl0IGlzIGEgd2FzdGUgdG8gY2xvbmUgc2tiIGRpcmVjdGx5IGluIGRzYV9za2JfdHhfdGltZXN0
YW1wKCkuDQo+ID4gICBGb3Igb25lLXN0ZXAgdGltZXN0YW1waW5nLCBhIGNsb25lIGlzIG5vdCBu
ZWVkZWQuIEZvciBhbnkgZmFpbHVyZSBvZg0KPiA+ICAgcG9ydF90eHRzdGFtcCAodGhpcyBtYXkg
dXN1YWxseSBoYXBwZW4pLCB0aGUgc2tiIGNsb25lIGhhcyB0byBiZSBmcmVlZC4NCj4gPiAgIFNv
IHB1dCBza2IgY2xvbmluZyBpbnRvIHBvcnRfdHh0c3RhbXAgd2hlcmUgaXQgcmVhbGx5IG5lZWRz
Lg0KPiANCj4gVGhpcyBwYXRjaCBjaGFuZ2VzIHRocmVlIHRoaW5ncyBeXl4gYXQgb25jZS4gIFRo
ZXNlIGFyZSBBRkFJQ1QgaW5kZXBlbmRlbnQNCj4gY2hhbmdlcywgYW5kIHNvIHBsZWFzZSBicmVh
ayB0aGlzIG9uZSBwYXRjaCBpbnRvIHRocmVlIGZvciBlYXNpZXIgcmV2aWV3Lg0KDQpXaWxsIHNw
bGl0IGl0IGluIG5leHQgdmVyc2lvbi4gVGhhbmsgeW91Lg0KDQo+IA0KPiBUaGFua3MsDQo+IFJp
Y2hhcmQNCg==
