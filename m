Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D04B3A13B3
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 14:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbhFIMGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 08:06:05 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:29967
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239719AbhFIMFN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 08:05:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWk/2bg/8J9d43P9XAjirVZ5DjcWgRf1A13jI9xBp7lrbDyd7oCKFVvdhnb/ZpivZERnqB1C8WiDUFZHyMbLZlFSS10c8QVu9I/qjrAXBvuI72gFXSAJpwF10LbN8KxifCdrH1l0hePAtsSvF8lNp0UUU4K9hphbFi7ASWPaavLQ5gRt+c/xyCSzTxjc+3pDA1Cd0qkb6xtOk0xJt9rGPSuufJfHjnT3Xci3HRwEEg30vYCzUtqxG4jetJ5sSxf2YPtaWnBrw2kJpjDuwd/wmUz+HShS6LQ+mZDcyUo451irknCM+UanpkfDlkVx9ortp21vseD+X+xYMaqt9JGmiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHBt3QAJCqG/Y4BSmQqeapCUm4IZ0PFGFre9hcDO7/c=;
 b=HG+7oepC7qnDPCubEg94Zi1mDXe8CXbaqe0ISZ1B25z7J0Q07mz+hreXwysyxY0BoJVKdm97fei3BrRbSOeGp3P4ApbuZdhlhDbQUBmLVEjtGd+umBXto+SnJuW5MePi23RZTYyPXSH4U7TqQ6IjCwwp5Avz8Oyhay5rtcpqnod33BEdVzQ9GNBfzC6vUhCudp2Q54f7Lj7gUlKwghCCsqCrAzDQnyC5Jigy5K9nQR7SKjIJWxsXv3eJqigfLK8bdLKYsz7bnTIeRyFuBIDh62O6a7FiLg83XaLKy/WAx1yVzgHueXgWjU7CAP6ZcBNdZzxITgjO6C6bokIkD1XhIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHBt3QAJCqG/Y4BSmQqeapCUm4IZ0PFGFre9hcDO7/c=;
 b=DRlcCjX1toxVFIJAEbUWZ7XxKAtqkTlI7GLEqIpsZzzcvTs/VblODIaXnlL8Oe4X9JlH8oyTH8AsKdB2NBi2vZu2GMnzN1Tlziqxzfq1hR3shamENGEkm6o6fvkefULI5Di9VG2BsjrPVKTclN+AzzGrPGjy6ramtk83QKYH4/Y=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (10.255.185.79) by
 DB8PR04MB6969.eurprd04.prod.outlook.com (52.133.242.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.22; Wed, 9 Jun 2021 12:03:17 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4219.020; Wed, 9 Jun 2021
 12:03:16 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V1 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Topic: [PATCH V1 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Index: AQHXUvDdAkrP6ejNDkGcbE4OJnlbKqr3PELAgAAgsQCAEidCwIAAuD6AgAFrO7A=
Date:   Wed, 9 Jun 2021 12:03:16 +0000
Message-ID: <DB8PR04MB67955C613E293BD1785D9A94E6369@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210527120722.16965-1-qiangqing.zhang@nxp.com>
 <DB8PR04MB679585D9D94C0D5D90003ED2E6239@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YK+nRkzOhQHn9LDO@lunn.ch>
 <DB8PR04MB679556065CABCB72C79815D7E6379@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <a3ccbaab-3290-43a8-b105-7f61da2a2f3c@kontron.de>
In-Reply-To: <a3ccbaab-3290-43a8-b105-7f61da2a2f3c@kontron.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kontron.de; dkim=none (message not signed)
 header.d=none;kontron.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9577dcc0-3212-480e-ae5e-08d92b3e90fa
x-ms-traffictypediagnostic: DB8PR04MB6969:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB69697A3F9DF300759681CEA2E6369@DB8PR04MB6969.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9mv6tFSxwj/5nZk+ruDCBol0CKSpQGRJs3gCnHlngB6R0F9IShgAnfHDLMCW8H3VKEohYKZL/KHb0Aikoi33AHXBfiLaxrwew5LM5Qlhwy3qJfn2CfMEld6RRXRTPyYx0eSicZZ4jU8vkVZjzg66VT2kgENBEHZ+kcgQAPLmSfM/aToUPvZqY79hT6KaTrXRncVLjAeB0ONWQtPNbmlfxM8ZPiXvDDOAZjbvxXJbCcG6pOJr0jiy3eePlPcHKJRfSxZhX9vxWU1qM1gxf6e/lFlmt2PztmviUQI+hcWIy4Tlk4aW/9EbfNBJt6HC995msbYOZuaWzdh/pdrsYPO1erRioTjd76C8oTOfoL6waj68EX9BrxfHay0sVOcK8fsEVBO3QBiIZLuOZW+DLv+5kH4Pr4WP3a6tAEuCVmsw/aMmjNYhwbL+DzyR0tBBUFCb43Tp641ozK4HIxTCgvH6cSW5J9KKHqUCxsGuIQteTJLrWON+LOkmY/o+8TDUZGaGj2wMuc65pbWPUFp5GzIyrmb3kxlRfy+yHIy/kJ0RxJG1k88wzPzCqk3Sb7sROazqztOmHDUCBAXEN/0XzIke9/f59/NqcEX2QHFuWaf9Kso=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(478600001)(8676002)(53546011)(8936002)(54906003)(86362001)(9686003)(316002)(6506007)(7696005)(76116006)(66446008)(66946007)(66476007)(66556008)(5660300002)(64756008)(186003)(71200400001)(26005)(33656002)(52536014)(55016002)(122000001)(38100700002)(83380400001)(2906002)(110136005)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?YjByVGIvODNKWkROM01NcU5tbUVYYmZyL3krY2JESkRYVzBKTC9DbEdQMklu?=
 =?gb2312?B?c2ZQRTZVRmxXYjR1akYrQnNWQ2xqR3BoK1hMU2NTTmNEYVhZRlhuN2pRUVJX?=
 =?gb2312?B?cmtIWVFkUXVqbHVOZ2ovdkpOeVhWZW5zOURTQkQybGJNMGJBWFVNTnA0eTNH?=
 =?gb2312?B?Y1BCMk1mQVplM2R1emFxZXhVNFl3blFlUjYwZ2dZajFwNkNQSmtXRGU4dE9B?=
 =?gb2312?B?Uk1kTElVd0gwL0twS0d0dWlIaVJJb0RLZXJLaS9CaXNIQklhNVQwSDZYRk1C?=
 =?gb2312?B?a2ljWCtPTW4zRDQ4ZlB3S29rNktva1dzRFNUWCt0Vnp5VHhXRDBUbllmRE16?=
 =?gb2312?B?a3pPcFhXcG44RVFsZGFjRllaMHNyUWFUT2xjK2x2RU1QSW5KWUUzTktreHpX?=
 =?gb2312?B?Q1VJM1FMUUp2YVI3Tk9XSTBDUkg4MUFGbWw0WWVlakE3NitrdjZHQ3J3T3p0?=
 =?gb2312?B?VmhLejFVaXA0c24yNDhwdTZqSFBJSW1rYW1vQlFTQkRsQ2hYYnpReFdkUm9t?=
 =?gb2312?B?SHd0M09FWGlaUGNQQlhINDVCbC9XRUpKRC83Vjl2WmZuLzh1Vk4rcE1xMWdq?=
 =?gb2312?B?Y3NDaDQvdE9xQXpQY1BTNVVsYUhmQ1NsaXMrOUxmSERoRWhzQTlRQ3ZMcGli?=
 =?gb2312?B?ZWd4cC9ZNHUvOXd0UWxPeWVNbFo4YUZqajJUaGVKMzQvZ0l3OVBzTEFOMFRN?=
 =?gb2312?B?KzUvYzhUUm8xK2JGSEVZK2hOdWlRakdmcWVSeDVlUk1IdkgxcDlqbzFXSmtQ?=
 =?gb2312?B?Q3JKN2pTbHJtZ3o1Z0pBaUh3YklqNmxNeWdkbG9ERVBkZW9LMkhGN1dBWjIw?=
 =?gb2312?B?Y2tMM1VGdmwzTTFzT2VrQWZNdFA0K3pDWThQQ0V3c3Rka0Z0U3BzOC90ZEZx?=
 =?gb2312?B?bkxLYmNnQm5CVzZVcGl1TG52RVViMU5ROFRuM1pOY2E5SUxYZEdiNFR1YmRM?=
 =?gb2312?B?aG16UDhIKy9TOUdnOHREVGxGQVZqVk5VKzdFWG1IRnNrS0xMREdodFBaNjVr?=
 =?gb2312?B?Zm5yRGhjcisvdXAxN3BHQXZNcEZ4TEQ5UXJLTTlEbHV6Z2VqQjVzMTF5L1My?=
 =?gb2312?B?M3RONFFhTzFNalBFNkQ3RG1WOEVVb1lTc2ZYT2JHYVdzUXZxNE5FQ3hYQURG?=
 =?gb2312?B?TDJEMFA1TlVGUWFmVEZRb2ViY2o3TDIwSzFPdVVCZjV6R1I3UVpwR2NYZ2tr?=
 =?gb2312?B?cVdTWEljVFpQMC82cnFxd0tPMEE2cUZQRjVEbWJISEt0cXdMSE5sVUFFUFFn?=
 =?gb2312?B?TGhDM2lpUmFjSVRnSUFoQnI2R3g3RUZraENJQjUvdWIwbVNJeWQ3SS9XNGxU?=
 =?gb2312?B?TnBsbVpzREZmS2ZxdzJKRDhKcUx4SUhhSDBUOWNJWTZvcTFpZWR0U0swNG4y?=
 =?gb2312?B?eDY5Mm5HaDFxbmZVOGtYeEc3aURUNjdQZTd2Y0RpNDJsQnVMa2lwVzN3bGty?=
 =?gb2312?B?bTFwdG1LQnUvN1NPYVdnR25PZEIyZ3FHODJISytlUkg2a1hZbzRQMTBqeDRY?=
 =?gb2312?B?ZkZaUkQ1NUhQRzJ5cFJsc05WUUNGL2w2YWVNcEI3TUhOeTJYUHNIZks3VXow?=
 =?gb2312?B?L1Y2TkdBUEt4OUhLM29TbVMxVVlqcnFyYlI1V01RYzNaa0VNdVpSUllFbzB3?=
 =?gb2312?B?akN4MWhycGpDTXJiUkdCYnRadi9DclNNUjgreGhXcDYvNS9WWTJDQVhvaXBD?=
 =?gb2312?B?OWFzWDRuWVFpM1NGbVdpcmxZLzN2STFvK0lHMTBJdkpqTDMwK3dOUXdNdmRR?=
 =?gb2312?Q?BtbbRrXp6uaepw1UzmSAjq18pAC5Iju2WQkRWT3?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9577dcc0-3212-480e-ae5e-08d92b3e90fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 12:03:16.8566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rw9v4esG0FaExvOvG3X0XikzX6cLiX4wUQoE6fOPl/54yPsHDPaISV+Q8LXj2PIM699ACyVPbPUQByGgkEysmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6969
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGcmllZGVyLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZy
aWVkZXIgU2NocmVtcGYgPGZyaWVkZXIuc2NocmVtcGZAa29udHJvbi5kZT4NCj4gU2VudDogMjAy
McTqNtTCOMjVIDIyOjE5DQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAu
Y29tPjsgQW5kcmV3IEx1bm4NCj4gPGFuZHJld0BsdW5uLmNoPg0KPiBDYzogZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFYxIG5ldC1uZXh0IDAvMl0gbmV0OiBmZWM6IGZpeCBU
WCBiYW5kd2lkdGggZmx1Y3R1YXRpb25zDQo+IA0KPiBIaSBKb2FraW0sIGhpIEFuZHJldywNCj4g
DQo+IE9uIDA4LjA2LjIxIDA1OjIzLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4NCj4gPiBIaSBG
cmllZGVyLA0KPiA+DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206
IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gPj4gU2VudDogMjAyMcTqNdTCMjfI1SAy
MjowNg0KPiA+PiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4g
Pj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsNCj4gPj4gZnJpZWRl
ci5zY2hyZW1wZkBrb250cm9uLmRlOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiA+PiBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29t
Pg0KPiA+PiBTdWJqZWN0OiBSZTogW1BBVENIIFYxIG5ldC1uZXh0IDAvMl0gbmV0OiBmZWM6IGZp
eCBUWCBiYW5kd2lkdGgNCj4gPj4gZmx1Y3R1YXRpb25zDQo+ID4+DQo+ID4+IE9uIFRodSwgTWF5
IDI3LCAyMDIxIGF0IDEyOjEwOjQ3UE0gKzAwMDAsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPj4+
DQo+ID4+PiBIaSBGcmllZGVyLA0KPiA+Pj4NCj4gPj4+IEFzIHdlIHRhbGtlZCBiZWZvcmUsIGNv
dWxkIHlvdSBwbGVhc2UgaGVscCB0ZXN0IHRoZSBwYXRjaGVzIHdoZW4geW91DQo+ID4+PiBhcmUN
Cj4gPj4gZnJlZT8gVGhhbmtzLg0KPiA+Pg0KPiA+PiBIaSBGcmllZGVyDQo+ID4+DQo+ID4+IElm
IHlvdSBjYW4sIGNvdWxkIHlvdSBhbHNvIHRlc3QgaXQgd2l0aCB0cmFmZmljIHdpdGggYSBtaXh0
dXJlIG9mIFZMQU4NCj4gcHJpb3JpdGllcy4NCj4gPj4gWW91IG1pZ2h0IHdhbnQgdG8gZm9yY2Ug
dGhlIGxpbmsgdG8gMTBGdWxsLCBzbyB5b3UgY2FuIG92ZXJsb2FkIGl0Lg0KPiA+PiBUaGVuIHNl
ZSB3aGF0IHRyYWZmaWMgYWN0dWFsbHkgbWFrZXMgaXQgdGhyb3VnaC4NCj4gPg0KPiA+IERpZCB5
b3VyIG1haWxib3ggZ2V0IGJvbWJlZCwgbGV0IHlvdSBtaXNzIHRoaXMgbWFpbCwgaG9wZSB5b3Ug
Y2FuIHNlZSB0aGlzDQo+IHJlcGx5Lg0KPiA+DQo+ID4gQ291bGQgeW91IHBsZWFzZSBnaXZlIHNv
bWUgZmVlZGJhY2sgaWYgaXQgaXMgcG9zc2libGU/IFRoYW5rcyA6LSkNCj4gDQo+IFRoYW5rcyBm
b3IgdGhlIHBhdGNoZXMhIEFzIGZhciBhcyB0aGUgYmFuZHdpZHRoIGRyb3BzIGFyZSBjb25jZXJu
ZWQsIHRoaXMNCj4gc29sdmVzIHRoZSBwcm9ibGVtLiBBY2NvcmRpbmcgdG8gbXkgc2ltcGxlIGlw
ZXJmIHRlc3RzIHRoZSB1bnRhZ2dlZCBUWCB0cmFmZmljDQo+IG5vdyBhbHdheXMgZ29lcyB0byBx
dWV1ZSAwIGFuZCB0aGVyZWZvcmUgZG9lc24ndCBzZWUgYW55IHJhbmRvbSBiYW5kd2lkdGgNCj4g
bGltaXRhdGlvbnMgYW55bW9yZS4NCj4NCj4gUmVnYXJkaW5nIEFuZHJldydzIHJlcXVlc3QgZm9y
IHRlc3RpbmcgdGhpcyB3aXRoIHNvbWUgdGFnZ2VkIHRyYWZmaWMgbWl4LCBteQ0KPiBwcm9ibGVt
IGlzIHRoYXQgdGhvdWdoIEkgaGF2ZSB1c2VkIFZMQU5zIGJlZm9yZSBhbmQga25vdyBob3cgdG8g
c2V0IHRoZW0gdXAsDQo+IEkndmUgbmV2ZXIgZG9uZSBhbnl0aGluZyB3aXRoIFFvUywgc28gSSBk
b24ndCByZWFsbHkgbm93IGhvdyB0byBzZXQgdGhlDQo+IHByaW9yaXRpZXMgKGxvb2tzIGxpa2Ug
SSBuZWVkIHRvIHNldCB1cCBpbnRlcm5hbCBwcmlvcml0aWVzIGFuZCBlZ3Jlc3MgbWFwcGluZw0K
PiBzb21laG93IT8pLiBJZiB5b3UgaGF2ZSBhbnkgcG9pbnRlcnMgZm9yIHRoaXMgaXQgd291bGQg
YmUgYXBwcmVjaWF0ZWQuIEkNCj4gcHJvYmFibHkgY291bGQgZG8gc29tZSBxdWljayB2ZXJpZmlj
YXRpb24gdGVzdHMsIGJ1dCBJIGRvbid0IGhhdmUgdGhlIHRpbWUgdG8NCj4gcmVhbGx5IGRpdmUg
aW50byB0aGUgdG9waWMuDQoNClRoYW5rcyBhIGxvdCBmb3IgeW91ciB0ZXN0aW5nISBDb3VsZCBJ
IGFkZCB5b3VyIHQtYiBhbmQgci1iIHRhZyB3aGVuIEkgcmVwb3N0IHRoZSBwYXRjaGVzIHRvIGNo
YW5nZSBmdW5jdGlvbnMgaW50byBzdGF0aWMgYXMgSmFrdWIgY29tbWVudGVkIGJlZm9yZT8NCg0K
QmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IA0KPiBCZXN0IHJlZ2FyZHMNCj4gRnJpZWRl
cg0K
