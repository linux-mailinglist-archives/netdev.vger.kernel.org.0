Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D353B3F49
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 10:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhFYIaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 04:30:39 -0400
Received: from mail-vi1eur05on2056.outbound.protection.outlook.com ([40.107.21.56]:49857
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231153AbhFYIa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 04:30:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zp6R6VnTTa3d3xGAAsH1NstAtIcCVDFcta5uFptqLp5D1kuki8ZBN5rxAdoYirm8h2T+uvxaJnSSzPAE4YQjHtz1D0NRDO0YHSubo+iI45oLbtQ9nsE8HD9halQZsT2ohFQDStXHyhS5JzahQNoFg8jDv4M5iekINLRt52hgztKZhdtO5HJt1YLjDwG+GCh8S+mxihWPIU5dkikYUvOmYgcoCT8frSMQGVTlDmK/w5458xbtK1p+NUgbfTb3NGXs1EPemNHAfu5PWrULCqO/PaFBMP5esB7xl/ZeFI2tBsKyX8mQWdE0xXl/xOPuqs2ZoPcSKGW4+qaZoN7cYBfShQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5g83TxXgp2GzReA3b1vBMJkk+C1LTaG3hmekVe7CckA=;
 b=AUt+1cWSyVCCu9GlSjIytdprK/UAprDhyveTvA5OzmfeF/lM+z5vn+EUQV2pNvqnwPUvHZ9WaHMJPS3jy5/6lfY5syb30zr/swYMJd/ENBRtb1Tgb3sMtdbcg2x9jiK4ZaiH5ZOuEe8OEqWjSP50V7Uv4G+S8vfHxakCLJ07Xwyv8LL0AGXXflnb4CsZpwj5VvR6O4gVLzmhhCjYivD4LhiJWqIZdGamvIV2X2u0lqEWAiqRrLtkjxnurZQpHb++jo8Bc517qjMi/U3u0roZko+hYY2D1hyaPwtWhiZnZV/UsQhktVrgsOTgn5ufkb4FOsGZn/Um9d3YcvXd4Rh5qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5g83TxXgp2GzReA3b1vBMJkk+C1LTaG3hmekVe7CckA=;
 b=IGQpsTQHbfrTEHOrSOtUwCdIK7bywVxRoqgmri5OsVPCEDZUklhwyjopSi3E1d1eOF4SAoLn4zIr/YQ9wShFlShCRqzS4GOX+bGqiGLVHvhiA/o5w+Zz4jyCuAHLUH2Zp9w+4bk342nS9kJaJhfca833DupSI0AvLJlFFt3C9RM=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4780.eurprd04.prod.outlook.com (2603:10a6:10:1c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Fri, 25 Jun
 2021 08:28:03 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e%8]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 08:28:03 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Lukasz Majewski <lukma@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC 1/3] ARM: dts: imx28: Add description for L2 switch on XEA
 board
Thread-Topic: [RFC 1/3] ARM: dts: imx28: Add description for L2 switch on XEA
 board
Thread-Index: AQHXZ3S0rjpj2HsO7kKyP5U2LAA3HasgG6aAgABmNgCAARNlgIAAJB6AgACZzYCAABfeIIAAnDSAgAFKiaA=
Date:   Fri, 25 Jun 2021 08:28:03 +0000
Message-ID: <DB8PR04MB6795CDCD1DC16B3F55F97753E6069@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210622144111.19647-1-lukma@denx.de>
        <20210622144111.19647-2-lukma@denx.de>  <YNH3mb9fyBjLf0fj@lunn.ch>
        <20210622225134.4811b88f@ktm>   <YNM0Wz1wb4dnCg5/@lunn.ch>
        <20210623172631.0b547fcd@ktm>
        <76159e5c-6986-3877-c0a1-47b5a17bf0f1@gmail.com>
        <DB8PR04MB679567B66A45FBD1C23E7371E6079@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210624132129.1ade0614@ktm>
In-Reply-To: <20210624132129.1ade0614@ktm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 812249f8-493f-4665-ed81-08d937b32664
x-ms-traffictypediagnostic: DB7PR04MB4780:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4780F710452ADD57171546FCE6069@DB7PR04MB4780.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FlXC5ZxIDTBClg7bIj8ZwnYjA2WRYVTz0OX1ryRN9tUjcOHIdSpnYLWbUyeh+miWUUruZB4UX6r8aiSSpWGwfgvdKs1KZLjxREOEQtUyOAI8R4/z2CjJIJjFNQHTbsTUFCbXBokIj3jXk6l468OW+nVumapj4BmuLS991HAERokhcUduUeYbYVhTQa6SekbqahYLeAUYc7qAw9Wvm5+MJgt352AI8SKwtuA30MqrOgRzcO+TTxPldZKzAdSfAJEY/AHg6+nCoZ4fKuXMh97g51otaoo85mZiqBmiPU9/mRQ1jOceXmEXIgd+fXl/WFMqxU5KXxPvNQT4Rcl+ZlJ9qTjEjD5fBX2SOhQpOk3mxltedzsjh94x/qtmc+uEaGg5ujKjTHG+9HMM+Ug9XfCI3gNKNwp6z7PV8OXkIPqTa/gZRbK9qfy2Gv9omWHQC8106XmiSWgakqANR36ZnVBcycGrK8FTeadJXG3t+HViQdOW6zKDaYE8+OwVtTYK4zsYSbvwj0cpaDD01CwTLIBk8qCci8fRMnToQULCmXUO4isH9nqcbF8WoKt3oZmB5QratTyz0LLQ2pvZpfLrjyc5JxFJ9jYUyS1xroc7QXyYWWhxYzR4zHs+6pfWVuEWuH7Or/L8atAU6ZE8J6mI6sh/ye10L8RShvQGRHnnNeH8YX7uOR4e35sLn3y3sScKdNh7zhAZFcU7ZYERFMxZLl4Szw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(38100700002)(122000001)(53546011)(9686003)(6506007)(186003)(2906002)(76116006)(7416002)(66556008)(7696005)(66446008)(86362001)(64756008)(66476007)(4326008)(52536014)(55016002)(66946007)(5660300002)(33656002)(54906003)(71200400001)(26005)(316002)(110136005)(83380400001)(8936002)(478600001)(8676002)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?VDU5S1pTMkV1M2ZUSFgySjVNMFFwZndNbkFYZnFIOURXblhLQlcrTlRGaGY3?=
 =?gb2312?B?ZzZYL2gzMmNES0UrNVZFQVc2OEljVnAxVGtXcUJ4Y2pJNXNrOGNiR1hqcXlD?=
 =?gb2312?B?eTltMDlrWnlScFJvWk1TQWUzS3VzY3JROGoxM2xweFFkdWtmaXRmUjkzdHp2?=
 =?gb2312?B?eFBPanRxSGpwRlJlTC9ndGlsbG4yeGs3cEg5d0tJWFFuK2NBcXpVOHNTcmh0?=
 =?gb2312?B?TEJyU0hoeHc1a1pLajYyL1gvbmdpRi9RdHhzZmEyN1NobXU3amNGZTVKTkJ5?=
 =?gb2312?B?U0FRdVdLSGtxSEFnWU1qckZmVzh4MC9QVUhON3JGWVdpZjVwTGt4K2ZYRExi?=
 =?gb2312?B?TU9RNGtJL3o0bnNkTlppa0laNUlGNUxnaVlUdG5KMjA0blRYOUNVTkFBVm5t?=
 =?gb2312?B?Y0lmQzRBNkhKa0V0V0dHdDNKQmlhVWEwQ3dEUlkxTWxvTkNOYm8yOUFSY0VQ?=
 =?gb2312?B?MmlYQUY5eFkzWmdvdWxoNFJaa3gyOEtEQTRkKzMxODRDRDRLS2xhRjJ5bTFB?=
 =?gb2312?B?NXJudkhtc1o3SXlpZy95aFdRNENXYW4vS1dUY1cydDhvL3dmSE1JRmFIQ0py?=
 =?gb2312?B?eTRMaVFxMXc0c3ExZmJDbWRhZWdHRkZ5cHZKbTM2YTB6bGpZdFB1enVnQkE0?=
 =?gb2312?B?bmIrS055V3JvOTJrZS9HWWJaQ3g3QTJucTN0Y01OWDh0YnorVkJoa1hWMXBY?=
 =?gb2312?B?alB1a3c5cWtURHk1SExzRkxBUktiemorUnEvN1Y2bFNGL055TnhDZXpmSGtB?=
 =?gb2312?B?aG52QmFYQVZlSDNQQjBkeVh5OWIwc0pYd21RTmM4REdkOXdvOGJHRE5vZ3Mz?=
 =?gb2312?B?QlZHazNtRFlpUFRHRG9oWjMwT21WTVNKZjFhNGxQcDFGTmdIYmd2MUJZZTVF?=
 =?gb2312?B?bDBER3dYYUdnanAzODFmazI4RDkwNUVrMFNGR2crdk41dW02Z3RybUJEdFZ1?=
 =?gb2312?B?UWt0VVI0SEtUSWNxN002L0RsZ0ZnZmJIWEU2RzU3aEhXZmVXSk1kYUZwWmpo?=
 =?gb2312?B?TVp3dnEwQktyWGZTODNXQkt6YzVvRnJQVXBjMTl3SnVpYWRvV3ByZjNWMTZu?=
 =?gb2312?B?b2dJUjJkK2Qra2xoblloQkQxSG9oRWpnY1dOV3pqUHpxcjAzbHFsN1J3MW5h?=
 =?gb2312?B?cG1YUS9xaXorVWpIdXRDbjFhZ25sMGpmZVhtelhNdW9TeXEvSlRNZG5oSmdM?=
 =?gb2312?B?RHhUUUtIRUJWRWdXZjd4TytZTWJMamhYKzd3eGhQc29NZDVLUDBrM005S0g3?=
 =?gb2312?B?QjlYS3NndStRUkxrWWdpalVRTE5VTXNQQWNpTER6bVJKbTFPK09YNDRpYWVZ?=
 =?gb2312?B?SVB0TG5uWVNHMjZ6aDZab0JXeUNvOER6MHg5eWhHdlRQZkNYUCs5TEZONEVR?=
 =?gb2312?B?WU42aytwNStxNzV1TGdRRXdYNlNzMVZJMVMwY3Y0VEZHUGJMdVJuZGM5bVd2?=
 =?gb2312?B?ZUNTYWJvOHlQZEIzLzdXVDB2Zm9ncEhXak5Fc3RtSWszMlJrSzNjNWkvakZ6?=
 =?gb2312?B?Z3lOUHY5WG51SjR2YTFVMi9RU1RZVVhkVFhIcEMwdjVZUW9paWRiTU5IZ3d5?=
 =?gb2312?B?QXJDZTFBd251cnRKWndDbmdJU3BzUUUzWGdWNTBIb3hERnhFZzIydWczcnVX?=
 =?gb2312?B?VWlVNThqT0I5cE8wSmcydHZJTUs5elVqYUNzVmNPVkl2d0RaOGlrbDlJSWc5?=
 =?gb2312?B?SkhaZ29UTjkxbjArbTRoZnJKVmFLcCsxVzRwcTBuZ0FKcXR4QlQ1MzlvVm1o?=
 =?gb2312?Q?VHf1MZsvHIP8RyGMTg=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 812249f8-493f-4665-ed81-08d937b32664
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2021 08:28:03.1412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nIQh/pjV/e3mcO1pAeSbzclc1wOrQEvgWSutBUvC8RNRQgk6epidsFIQzNbcR3eSzX9y0xdOVLqDTxxumms5Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4780
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBMdWthc3osDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTHVr
YXN6IE1hamV3c2tpIDxsdWttYUBkZW54LmRlPg0KPiBTZW50OiAyMDIxxOo21MIyNMjVIDE5OjIx
DQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgRmxvcmlhbiBG
YWluZWxsaQ0KPiA8Zi5mYWluZWxsaUBnbWFpbC5jb20+OyBBbmRyZXcgTHVubiA8YW5kcmV3QGx1
bm4uY2g+DQo+IENjOiBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFr
dWIgS2ljaW5za2kNCj4gPGt1YmFAa2VybmVsLm9yZz47IE1hZGFsaW4gQnVjdXIgKE9TUykgPG1h
ZGFsaW4uYnVjdXJAb3NzLm54cC5jb20+Ow0KPiBOaWNvbGFzIEZlcnJlIDxuaWNvbGFzLmZlcnJl
QG1pY3JvY2hpcC5jb20+OyBWbGFkaW1pciBPbHRlYW4NCj4gPG9sdGVhbnZAZ21haWwuY29tPjsg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgQXJuZCBCZXJnbWFubg0KPiA8YXJuZEBhcm5kYi5kZT47
IE1hcmsgRWlub24gPG1hcmsuZWlub25AZ21haWwuY29tPjsgZGwtbGludXgtaW14DQo+IDxsaW51
eC1pbXhAbnhwLmNvbT47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDog
UmU6IFtSRkMgMS8zXSBBUk06IGR0czogaW14Mjg6IEFkZCBkZXNjcmlwdGlvbiBmb3IgTDIgc3dp
dGNoIG9uIFhFQQ0KPiBib2FyZA0KPiANCj4gSGkgSm9ha2ltLA0KPiANCj4gPiBIaSBMdWthc3os
IEZsb3JpYW4sIEFuZHJldywNCj4gPg0KPiA+ID4gPiBNYXliZSBzb21lYm9keSBmcm9tIE5YUCBj
YW4gcHJvdmlkZSBpbnB1dCB0byB0aGlzIGRpc2N1c3Npb24gLSBmb3INCj4gPiA+ID4gZXhhbXBs
ZSB0byBzY2hlZCBzb21lIGxpZ2h0IG9uIEZFQyBkcml2ZXIgKG5lYXIpIGZ1dHVyZS4NCj4gPiA+
DQo+ID4gPiBTZWVtcyBsaWtlIHNvbWUgZm9sa3MgYXQgTlhQIGFyZSBmb2N1c2luZyBvbiB0aGUg
U1RNTUFDIGNvbnRyb2xsZXINCj4gPiA+IHRoZXNlIGRheXMgKGR3bWFjIGZyb20gU3lub3BzeXMp
LCBzbyBtYXliZSB0aGV5IGhhdmUgZ2l2ZW4gdXAgb24NCj4gPiA+IGhhdmluZyB0aGVpciBvd24g
RXRoZXJuZXQgTUFDIGZvciBsb3dlciBlbmQgcHJvZHVjdHMuDQo+ID4NCj4gPiBJIGFtIHZlcnkg
aGFwcHkgdG8gdGFrZSBwYXJ0aWNpcGF0ZSBpbnRvIHRoaXMgdG9waWMsIGJ1dCBub3cgSSBoYXZl
IG5vDQo+ID4gZXhwZXJpZW5jZSB0byBEU0EgYW5kIGkuTVgyOCBNQUMsIHNvIEkgbWF5IG5lZWQg
c29tZSB0aW1lIHRvIGluY3JlYXNlDQo+ID4gdGhlc2Uga25vd2xlZGdlLCBsaW1pdGVkIGluc2ln
aHQgY291bGQgYmUgcHV0IHRvIG5vdy4NCj4gDQo+IE9rLiBObyBwcm9ibGVtIDotKQ0KPiANCj4g
Pg0KPiA+IEZsb3JpYW4sIEFuZHJldyBjb3VsZCBjb21tZW50IG1vcmUgYW5kIEkgYWxzbyBjYW4g
bGVhcm4gZnJvbSBpdCA6LSksDQo+ID4gdGhleSBhcmUgYWxsIHZlcnkgZXhwZXJpZW5jZWQgZXhw
ZXJ0Lg0KPiANCj4gVGhlIG1haW4gcHVycG9zZSBvZiBzZXZlcmFsIFJGQ3MgZm9yIHRoZSBMMiBz
d2l0Y2ggZHJpdmVycyAoZm9yIERTQSBbMV0gYW5kDQo+IHN3aXRjaGRldiBbMl0pIHdhcyB0byBn
YWluIGZlZWRiYWNrIGZyb20gY29tbXVuaXR5IGFzIHNvb24gYXMgcG9zc2libGUNCj4gKGRlc3Bp
dGUgdGhhdCB0aGUgZHJpdmVyIGxhY2tzIHNvbWUgZmVhdHVyZXMgLSBsaWtlIFZMQU4sIEZEQiwg
ZXRjKS4NCj4gDQo+ID4NCj4gPiBXZSBhbHNvIHdhbnQgdG8gbWFpbnRhaW4gRkVDIGRyaXZlciBz
aW5jZSBtYW55IFNvQ3MgaW1wbGVtZW50ZWQgdGhpcw0KPiA+IElQLCBhbmQgYXMgSSBrbm93IHdl
IHdvdWxkIGFsc28gdXNlIGl0IGZvciBmdXR1cmUgU29Dcy4NCj4gPg0KPiANCj4gRmxvcmlhbiwg
QW5kcmV3LCBwbGVhc2UgY29ycmVjdCBtZSBpZiBJJ20gd3JvbmcsIGJ1dCBteSBpbXByZXNzaW9u
IGlzIHRoYXQNCj4gdXBzdHJlYW1pbmcgdGhlIHN1cHBvcnQgZm9yIEwyIHN3aXRjaCBvbiBpTVgg
ZGVwZW5kcyBvbiBGRUMgZHJpdmVyIGJlaW5nDQo+IHJld3JpdHRlbiB0byBzdXBwb3J0IHN3aXRj
aGRldj8NCj4gDQo+IElmIHllcywgdGhlbiB1bmZvcnR1bmF0ZWx5LCBJIGRvbid0IGhhdmUgdGlt
ZSBhbmQgcmVzb3VyY2VzIHRvIHBlcmZvcm0gdGhhdCB0YXNrDQo+IC0gdGhhdCBpcyB3aHkgSSBo
YXZlIGFza2VkIGlmIE5YUCBoYXMgYW55IHBsYW5zIHRvIHVwZGF0ZSB0aGUgRkVDIChmZWNfbWFp
bi5jKQ0KPiBkcml2ZXIuDQo+IA0KPiANCj4gSm9ha2ltLCBkbyB5b3UgaGF2ZSBhbnkgcGxhbnMg
dG8gcmUtZmFjdG9yIHRoZSBsZWdhY3kgRkVDIGRyaXZlcg0KPiAoZmVjX21haW4uYykgYW5kIGlu
dHJvZHVjZSBuZXcgb25lLCB3aGljaCB3b3VsZCBzdXBwb3J0IHRoZSBzd2l0Y2hkZXY/DQo+IA0K
PiBJZiBOWFAgaXMgbm90IHBsYW5uaW5nIHRvIHVwZGF0ZSB0aGUgZHJpdmVyLCB0aGVuIG1heWJl
IGl0IHdvdWxkIGJlIHdvcnRoIHRvDQo+IGNvbnNpZGVyIGFkZGluZyBkcml2ZXIgZnJvbSBbMl0g
dG8gbWFpbmxpbmU/IFRoZW4gSSBjb3VsZCBmaW5pc2ggaXQgYW5kIHByb3ZpZGUgYWxsDQo+IHJl
cXVpcmVkIGZlYXR1cmVzLg0KDQpJIGRvbid0IGhhdmUgc3VjaCBwbGFuIG5vdywgYW5kIGhhdmUg
bm8gY29uZmlkZW5jZSB0byByZS1mYWN0b3IgdGhlIGxlZ2FjeSBGRUMgZHJpdmVyIGFuZCBpbnRy
b2R1Y2UgbmV3IG9uZSwNCndoaWNoIHRvIHN1cHBvcnQgc3dpdGNoZGV2IGluIGEgc2hvcnQgdGlt
ZS4gSSBhbSBub3QgdmVyeSBleHBlcmllbmNlZCBmb3IgRkVDIGRyaXZlciwgc2luY2UgSSBoYXZl
IGp1c3QgbWFpbnRhaW5lZA0KaXQgZm9yIGhhbGYgYSB5ZWFyLiBUbyBiZSBob25lc3QsIEkgaGF2
ZSBubyBpZGVhIGluIG15IGhlYWQgcmlnaHQgbm93LCB3ZSBldmVuIGRvbid0IGhhdmUgaS5NWDI4
IGJvYXJkcy4NCkknbSBzbyBzb3JyeSBhYm91dCB0aGlzLCBidXQgSSBhbSBhbHNvIGludGVyZXN0
ZWQgaW4gaXQsIEkgYW0gZmluZGluZyB0aW1lIHRvIGluY3JlYXNlIHJlbGF0ZWQga25vd2xlZGdl
Lg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gDQo+IExpbmtzOg0KPiBbMV0gLQ0K
PiBodHRwczovL3NvdXJjZS5kZW54LmRlL2xpbnV4L2xpbnV4LWlteDI4LWwyc3dpdGNoLy0vY29t
bWl0cy9pbXgyOC12NS4xMi1MMi11DQo+IHBzdHJlYW0tRFNBLVJGQ192MQ0KPiBbMl0gLQ0KPiBo
dHRwczovL3NvdXJjZS5kZW54LmRlL2xpbnV4L2xpbnV4LWlteDI4LWwyc3dpdGNoLy0vY29tbWl0
cy9pbXgyOC12NS4xMi1MMi11DQo+IHBzdHJlYW0tc3dpdGNoZGV2LVJGQ192MQ0KPiANCj4gPiBC
ZXN0IFJlZ2FyZHMsDQo+ID4gSm9ha2ltIFpoYW5nDQo+IA0KPiANCj4gDQo+IA0KPiBCZXN0IHJl
Z2FyZHMsDQo+IA0KPiBMdWthc3ogTWFqZXdza2kNCj4gDQo+IC0tDQo+IA0KPiBERU5YIFNvZnR3
YXJlIEVuZ2luZWVyaW5nIEdtYkgsICAgICAgTWFuYWdpbmcgRGlyZWN0b3I6IFdvbGZnYW5nIERl
bmsNCj4gSFJCIDE2NTIzNSBNdW5pY2gsIE9mZmljZTogS2lyY2hlbnN0ci41LCBELTgyMTk0IEdy
b2ViZW56ZWxsLCBHZXJtYW55DQo+IFBob25lOiAoKzQ5KS04MTQyLTY2OTg5LTU5IEZheDogKCs0
OSktODE0Mi02Njk4OS04MCBFbWFpbDogbHVrbWFAZGVueC5kZQ0K
