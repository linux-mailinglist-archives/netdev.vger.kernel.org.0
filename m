Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3AA47563C
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhLOKZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:25:18 -0500
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:22535
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229791AbhLOKZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 05:25:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oq6zaDUzl1Df/80UcJMdSmZPBrEq92MelfvJI+e5gDWOqvVOy3mz9iYWmW8lrB8nKxc2531TrMRgnhX+UzyT6mE4m9kA9HWVwxKtzJTCRHbkAq+6p7d23w8N2UsEeG3IO2B6tV8kLt4rFdWUyShNhejxjxlbtbmBbhoRiPGA/JOCvoR+xgWA0MJzdZelrQuMPsyF6vr6OvT/SZ4IF6h2X4982sX/f8eSVdMWUtgz+wIyM7+wiHNtcaX3XWTflimkh7nDon274vMDO0lT59cAA8Fk86t7lBbM6e752PAgD4khKP5GH9scNYIBbMocijfb5FfWl9OSOUuWvmod1pc0hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6q8KcVHKtqS4Zb3vAAjQ908PojUHXc0KHz1CMCLDmgc=;
 b=fhhC1umRHGs/hpakyzz9sYOeBaMveAdhDxMkob5v23ElDexqeOOfGcwJ7fKdhYlKnwKLIhO/NapfU/JIg2hEwFGMWlmHMwcBKforweM3FMcynPqBzQElP5UM7X/OF4OBwUOK1QRRX+G5tpmkC1g8HvXicltM56yLRa/cE7FgDVUwPt4o/JAOSs5VIHLiX9O/2nssU/2OTc5QJyjVKRzgp4ZrAvdtu1AMc5KojLjxZNXn42eaI7wpoDrTC9XOKbPhZXi9Q2i04d1UWtANH1dczQjfstk4UqnPwI1e93zuYBQjtAl4KdveSJPKW9+9e4EWP4uSHg7RcH/8IHmPCoOdWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6q8KcVHKtqS4Zb3vAAjQ908PojUHXc0KHz1CMCLDmgc=;
 b=XxUmTdxKApirZHtXvf1am4vQyIRTQzoXa9gsXQXBmj44g/Wg0gzEBYghVQKGsSRpDVAWmjt2AuxOJkN+tFivu7MhkjlFwowS7L8M3GyUR2Msu7TpFYJH6D1WYwKitTY5KPC3CEtaU+zqct8AkwOPw4kCPRo0l6ik6UyCewappfs=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4778.eurprd04.prod.outlook.com (2603:10a6:10:18::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Wed, 15 Dec
 2021 10:25:15 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 10:25:14 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Philippe Schenker <philippe.schenker@toradex.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Thread-Topic: [PATCH net-next 3/3] net: fec: reset phy on resume after
 power-up
Thread-Index: AQHX8OR72xHlAReyBk2jbzr2bx9r+KwyVmAAgAA9uACAAMQSsA==
Date:   Wed, 15 Dec 2021 10:25:14 +0000
Message-ID: <DB8PR04MB679570A356B655A5D6BFE818E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20211214121638.138784-1-philippe.schenker@toradex.com>
 <20211214121638.138784-4-philippe.schenker@toradex.com>
 <YbjofqEBIjonjIgg@lunn.ch>
 <20211214223548.GA47132@francesco-nb.int.toradex.com>
In-Reply-To: <20211214223548.GA47132@francesco-nb.int.toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adda18b9-693b-49a5-9bac-08d9bfb52f18
x-ms-traffictypediagnostic: DB7PR04MB4778:EE_
x-microsoft-antispam-prvs: <DB7PR04MB4778FF464C1D0C7FDEA9E604E6769@DB7PR04MB4778.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OsfPnSkyasUFaeD84cUGeT7AP1ssoqF/jaf1pScqmvbts9jSFKEkO2gWKV0cpCeFZCyJet3s8wSBAQw1zdMkhejcm2Ngd082rPDnbLglFLgX10fwYHvH+6HDGxcM0St6dcoOH2EvW/sX3XG8HAnb69+iX+8g5XLkgu8LL6ysdxiWrznp3r4tI0SqclVMCi1KAjrbqA0sBRp5dPS4GnLPiTy2L8QslbCBGqngfvi3zlQHkWmW6QonW/ybQmEX6cHJDsav4yxenbUcy/bYc0e412UYXsWBTdf1szmyTHCovGkptK8S0I0V2qIqyqLw8ZxYHL6AVpOvd0Q8hvhfXBSRziz9CjwnEg0Kq0EQKfjc4wMFQy6TwwkzGccCx5IwHytfQjY61ohzPIon1m8Lz73l9vmFUxxWHHZwnV58dJK1mG6eOWcbLbROPKjV++u1sMnqEsQ+K2h0f+QDI2MKZaR6btmAp5rJa+3JG/v6j7vkktXp/x6d2IFM5619Q73nQfhmuu0NnZZi8BqWrhI1ghr3UkWLeZdakvnG+LywrK9Qf047tRD3b8/HFAdNp8Dtjah0Pma/q90bjM5NGbXrNVGNdiXMV+lV3+M6F+UCJbBCEIPRV9xiZepWubnVbn72N1uCvNQZ6mSVrCVpo5LRaLsMFxFlxj69zgatF6IR2O2OSusMuT2TV0rFNwdEd5uAtEtHSu3+PAQWGM88eI1pPA/VHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(316002)(6506007)(110136005)(54906003)(33656002)(966005)(5660300002)(83380400001)(38100700002)(66556008)(55016003)(71200400001)(66476007)(66946007)(64756008)(186003)(8676002)(38070700005)(508600001)(45080400002)(7416002)(26005)(66446008)(122000001)(52536014)(4326008)(7696005)(2906002)(9686003)(86362001)(53546011)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?K2xkbWlkbE5UZHl3bkxrK0d6a2NrVmREV2dRS09Id2JhZ0tXd2dyVXZJUHhn?=
 =?gb2312?B?aGduaFV0VmFISTB5eXJsL3hDM2dKY0xPeFAySlI0RVVzeVB3VTRveEY4Sk5S?=
 =?gb2312?B?a0pGQTFwMi9ZSlQyVWZDZ2R5RkhMMEY3Q3JFNnc0dzZ5RXAvMFR3cmdqVVB2?=
 =?gb2312?B?c1VnMTJmeTJsWTcyUEZkeVVNN1FkSnp3WEZrZ1pvWWJkbHB2MGdKOXBWajJP?=
 =?gb2312?B?VFViblRQdzhnQzN0QVEySXhwbStVWTFXZ2hZeUphaWpiRTNrS1M1bzVLRFhT?=
 =?gb2312?B?NG5Ld0VGOU9QSUFQaGh0aFViOHdEMktxaDdtUlo4WlUrajFEUmdobFhmOHZt?=
 =?gb2312?B?WVA4Ukl6cnZPYjdNOVpBL3hGMUpMa0RGY3BzemVTdk5QRUkvOHBQS1MySEFL?=
 =?gb2312?B?KythbCtUVndzVjUwbWplQmJOWDRzU1lLOFc0SE1RNWltL0RKc3dlODA5YU5X?=
 =?gb2312?B?aWs5TytvODd4Z3p1TnZaTlIzUHREZEFvcVdTS2k5cnE5R1BxdFJudzNHYytN?=
 =?gb2312?B?R3RPZGV6bmtGbUI0bDArblNNRWUzc2V3RDZTeEtHcG42cXNXUjhyYXE0MXhT?=
 =?gb2312?B?MXdzaG8yK1ZuZmhuM1JzMzdlQVJWak4rQ1ZjRzVORjhJSmh5ODRzZHlPTzdF?=
 =?gb2312?B?OEtvR1JMSzFDdnNIQWJNN1R3aHg5SHpiMHBpOWl6Y3dnR29GTmVKQXI2cjNt?=
 =?gb2312?B?NGQyemphRFYwS2tCNFJic21UYUFMYVQwV0haN3FEYlByaXErNEE0ZUFTU2Jz?=
 =?gb2312?B?aTNVNUpxWHFqWWg0c0FEL2VhSEhkMzQyMUs5RzRkQk1reTVhSXUwOElqb2pz?=
 =?gb2312?B?ZEhpNk4wR0JxYi96WUhMUWRuWStPY3NKSWhobWwzbWN6dFRNS2dxM3JEM2Nw?=
 =?gb2312?B?M1JoMWhvVVdZc3VBTDVPeGhRUmZkTUN1RVlwK2Z0RkZSa0dNLy83b1VNL0RV?=
 =?gb2312?B?YjRWSjREb3NyZmNJRXorSTM0N050Rzl2cU81aWVxV3RnN3huS3RmTmh2SENF?=
 =?gb2312?B?YVRTRDYvekRSZEhJNWFydkVxdjVlQWJaeWlBTGtRMURVYTkrZzBZZE1NQzFl?=
 =?gb2312?B?VHFxZW5DM0Z1WkcwY0h2NmVmbFlmQUxHZzBhcm11bTlGa0JsT05CazN4cm82?=
 =?gb2312?B?YThERFRGMGt6QnM1NXRWTkhVOG9vbHl4bFBjZWtNVHJRYklJMG1BUTVGWURm?=
 =?gb2312?B?eHJxSjZENFo5RXA1VWNUTFRFM0p1NkgxRW1uRVZBVGZZdExmZFJ2UDYvSzhK?=
 =?gb2312?B?Q3lxbkJWdlQzS1prSkcyZ0c5S05JNUVnbHBWUUFkcytrVDZxLy92alV0K1Z4?=
 =?gb2312?B?eWl5SmZzS3dGWlJBWW9qQXNrNmxqeDVSWCsxajhnWFZIMkdkSFpMMFVoZ2Vu?=
 =?gb2312?B?U0lSWU8rMzRjamRlUk5yM3U0dTYrV1RDSlRhNHhQdUo3c045QnFZUEUyLzl1?=
 =?gb2312?B?WXFNLzFTS29QRXByT3BKQ05TY1ozcUhvb3FIRG8zdk5ORlZqV1BhUkdxaTNK?=
 =?gb2312?B?dVpqd0x1QTczSTVHeVBjNXlFWWxpd0J5WkYwZXlyQlJFRHZwMVRRaWR6Y1Nt?=
 =?gb2312?B?M3RUalZZNjhzYnl3a3NzMGhaOEZjRy9WbjNpUEZjWFJsOXNvVWEzVFlId1Fn?=
 =?gb2312?B?RmlXVEZNNCsxVitEN0gyOXJmK25wT3oybWtwRWdJNSsrZWVkUXZFWjZnY0Nv?=
 =?gb2312?B?eHMrTHVSVWlieEFsYlFGS1VZcXNQdXl0ZG5UTkd3cHUvSCtnTStNUWd6WnJW?=
 =?gb2312?B?WWxpLzZOUHUwYVpqcUZKZHNkZ2NOaCtlcldIc2xvNHBJbVM5RmlGVGdOZ1FX?=
 =?gb2312?B?NW9nQ0ZtM01NSkNLRFVLUXJUR3Q3M0FWYkhpeUl0dnBCanIvbGtnYU5Pamx5?=
 =?gb2312?B?ZXdjZ3REYzBxWWJpd2U0V2RXaHRmRFFEaE5WYVlSZXdSNUJ2NkdhNHFUa0w0?=
 =?gb2312?B?aXlJaUJOTHJXSVhWMkk5angxRStpbGFycFluTndMQm81anIzaVNxc3lhcXp5?=
 =?gb2312?B?eGRxblhkZFZTSzd0MWhlZ0oybEhZNUNEVjJiaUM2aVRDQzE0OXFDL1JMemkw?=
 =?gb2312?B?V24rTzUxaGZIREFYZkNCTHNKTG9leTFtRlc2WE1odmYvZmUycTAwZkowcGZS?=
 =?gb2312?B?WG1ianE4dFhpUEhPeTBUMTlOdCtHZzJiZXRCMWd0Tm9UU1VpWnR1ZG5GUDhp?=
 =?gb2312?B?eGc9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adda18b9-693b-49a5-9bac-08d9bfb52f18
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 10:25:14.8638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NfTBogMrgNIR7sB9CDOa2Gwnuww6kVTtQbo4h84BR9vzSR1r4e6zo8qpMKaXd+xBLWSmVE5x14I8P75+A+zFxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4778
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGcmFuY2VzY28sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTog
RnJhbmNlc2NvIERvbGNpbmkgPGZyYW5jZXNjby5kb2xjaW5pQHRvcmFkZXguY29tPg0KPiBTZW50
OiAyMDIxxOoxMtTCMTXI1SA2OjM2DQo+IFRvOiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+
DQo+IENjOiBQaGlsaXBwZSBTY2hlbmtlciA8cGhpbGlwcGUuc2NoZW5rZXJAdG9yYWRleC5jb20+
Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFu
Z0BueHAuY29tPjsgRGF2aWQNCj4gUyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IFJ1
c3NlbGwgS2luZyA8bGludXhAYXJtbGludXgub3JnLnVrPjsNCj4gSGVpbmVyIEthbGx3ZWl0IDxo
a2FsbHdlaXQxQGdtYWlsLmNvbT47IEZyYW5jZXNjbyBEb2xjaW5pDQo+IDxmcmFuY2VzY28uZG9s
Y2luaUB0b3JhZGV4LmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBGYWJp
bw0KPiBFc3RldmFtIDxmZXN0ZXZhbUBnbWFpbC5jb20+OyBGdWdhbmcgRHVhbiA8ZnVnYW5nLmR1
YW5AbnhwLmNvbT47DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDog
UmU6IFtQQVRDSCBuZXQtbmV4dCAzLzNdIG5ldDogZmVjOiByZXNldCBwaHkgb24gcmVzdW1lIGFm
dGVyDQo+IHBvd2VyLXVwDQo+IA0KPiBIZWxsbyBBbmRyZXcsDQo+IA0KPiBPbiBUdWUsIERlYyAx
NCwgMjAyMSBhdCAwNzo1NDo1NFBNICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gPiBXaGF0
IGkgZG9uJ3QgcGFydGljdWxhcmx5IGxpa2UgYWJvdXQgdGhpcyBpcyB0aGF0IHRoZSBNQUMgZHJp
dmVyIGlzDQo+ID4gZG9pbmcgaXQuIE1lYW5pbmcgaWYgdGhpcyBQSFkgaXMgdXNlZCB3aXRoIGFu
eSBvdGhlciBNQUMsIHRoZSBzYW1lDQo+ID4gY29kZSBuZWVkcyBhZGRpbmcgdGhlcmUuDQo+IFRo
aXMgaXMgZXhhY3RseSB0aGUgc2FtZSBjYXNlIGFzIHBoeV9yZXNldF9hZnRlcl9jbGtfZW5hYmxl
KCkgWzFdWzJdLCB0byBtZSBpdA0KPiBkb2VzIG5vdCBsb29rIHRoYXQgYmFkLg0KPiANCj4gPiBT
byBtYXliZSBpbiB0aGUgcGh5IGRyaXZlciwgYWRkIGEgc3VzcGVuZCBoYW5kbGVyLCB3aGljaCBh
c3NlcnRzIHRoZQ0KPiA+IHJlc2V0LiBUaGlzIGNhbGwgaGVyZSB3aWxsIHRha2UgaXQgb3V0IG9m
IHJlc2V0LCBzbyBhcHBseWluZyB0aGUgcmVzZXQNCj4gPiB5b3UgbmVlZD8NCj4gQXNzZXJ0aW5n
IHRoZSByZXNldCBpbiB0aGUgcGh5bGliIGluIHN1c3BlbmQgcGF0aCBpcyBhIGJhZCBpZGVhLCBp
biB0aGUgZ2VuZXJhbA0KPiBjYXNlIGluIHdoaWNoIHRoZSBQSFkgaXMgcG93ZXJlZCBpbiBzdXNw
ZW5kIHRoZSBwb3dlci1jb25zdW1wdGlvbiBpcyBsaWtlbHkNCj4gdG8gYmUgaGlnaGVyIGlmIHRo
ZSBkZXZpY2UgaXMgaW4gcmVzZXQgY29tcGFyZWQgdG8gc29mdHdhcmUgcG93ZXItZG93biB1c2lu
Zw0KPiB0aGUgQk1DUiByZWdpc3RlciAoYXQgbGVhc3QgZm9yIHRoZSBQSFkgZGF0YXNoZWV0IEkg
Y2hlY2tlZCkuDQo+IA0KPiBXaGF0IHdlIGNvdWxkIGRvIGlzIHRvIGNhbGwgcGh5X2RldmljZV9y
ZXNldCBpbiB0aGUgZmVjIGRyaXZlciBzdXNwZW5kIHBhdGgNCj4gd2hlbiB3ZSBrbm93IHdlIGFy
ZSBnb2luZyB0byBkaXNhYmxlIHRoZSByZWd1bGF0b3IsIEkgZG8gbm90IGxpa2UgaXQsIGJ1dCBp
dA0KPiB3b3VsZCBzb2x2ZSB0aGUgaXNzdWUuDQo+IA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9m
cmVlc2NhbGUvZmVjX21haW4uYw0KPiBAQCAtNDA2NCw3ICs0MDY0LDExIEBAIHN0YXRpYyBpbnQg
X19tYXliZV91bnVzZWQgZmVjX3N1c3BlbmQoc3RydWN0DQo+IGRldmljZSAqZGV2KQ0KPiAgICAg
ICAgIHJ0bmxfdW5sb2NrKCk7DQo+IA0KPiAgICAgICAgIGlmIChmZXAtPnJlZ19waHkgJiYgIShm
ZXAtPndvbF9mbGFnICYgRkVDX1dPTF9GTEFHX0VOQUJMRSkpDQo+ICsgICAgICAgew0KPiAgICAg
ICAgICAgICAgICAgcmVndWxhdG9yX2Rpc2FibGUoZmVwLT5yZWdfcGh5KTsNCj4gKyAgICAgICAg
ICAgICAgIHBoeV9kZXZpY2VfcmVzZXQobmRldi0+cGh5ZGV2LCAxKTsNCj4gKyAgICAgICB9DQo+
ICsNCj4gDQo+ICAgICAgICAgLyogU09DIHN1cHBseSBjbG9jayB0byBwaHksIHdoZW4gY2xvY2sg
aXMgZGlzYWJsZWQsIHBoeSBsaW5rIGRvd24NCj4gICAgICAgICAgKiBTT0MgY29udHJvbCBwaHkg
cmVndWxhdG9yLCB3aGVuIHJlZ3VsYXRvciBpcyBkaXNhYmxlZCwgcGh5IGxpbmsNCj4gZG93bg0K
DQpBcyBJIG1lbnRpb25lZCBiZWZvcmUsIGJvdGggbWFjIGFuZCBwaHlsaWIgaGF2ZSBub3QgdGFr
ZW4gUEhZIHJlc2V0IGludG8gY29uc2lkZXJhdGlvbiBkdXJpbmcNCnN5c3RlbSBzdXNwZW5kL3Jl
c3VtZSBzY2VuYXJpby4gQXMgQW5kcmV3IHN1Z2dlc3RlZCwgeW91IGNvdWxkIG1vdmUgdGhpcyBp
bnRvIHBoeSBkcml2ZXIgc3VzcGVuZA0KZnVuY3Rpb24sIHRoaXMgaXMgYSBjb3JuZXIgY2FzZS4g
T25lIHBvaW50IEkgZG9uJ3QgdW5kZXJzdGFuZCwgd2h5IGRvIHlvdSByZWplY3QgdG8gYXNzZXJ0
IHJlc2V0IHNpZ25hbCBkdXJpbmcNCnN5c3RlbSBzdXNwZW5kZWQ/IA0KDQpCZXN0IFJlZ2FyZHMs
DQpKb2FraW0gWmhhbmcNCj4gRnJhbmNlc2NvDQo+IA0KPiBbMV0NCj4gaHR0cHM6Ly9ldXIwMS5z
YWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGbG9yZS5r
DQo+IGVybmVsLm9yZyUyRm5ldGRldiUyRjIwMTcxMjExMTIxNzAwLjEwMjAwLTEtZGV2JTQwZzBo
bDFuLm5ldCUyRiZhDQo+IG1wO2RhdGE9MDQlN0MwMSU3Q3FpYW5ncWluZy56aGFuZyU0MG54cC5j
b20lN0NmNzE0MGZlOTcxNTQ0ZmU4ZDINCj4gMjYwOGQ5YmY1MjE1MTclN0M2ODZlYTFkM2JjMmI0
YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0MwJTdDNjM3Nw0KPiA1MTE4MTUyNzk3OTIzMyU3Q1Vu
a25vd24lN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3TURBaUwNCj4gQ0pRSWpvaVYybHVN
eklpTENKQlRpSTZJazFoYVd3aUxDSlhWQ0k2TW4wJTNEJTdDMzAwMCZhbXA7c2RhdGE9aXRWDQo+
IG0wanJvUTBNekRHNUlwcXMzT1kwRjVTWSUyRmtiZEZSV2F1TktxMlhpUSUzRCZhbXA7cmVzZXJ2
ZWQ9MA0KPiBbMl0gMWIwYTgzYWMwNGUzICgibmV0OiBmZWM6IGFkZCBwaHlfcmVzZXRfYWZ0ZXJf
Y2xrX2VuYWJsZSgpIHN1cHBvcnQiKQ0KDQo=
