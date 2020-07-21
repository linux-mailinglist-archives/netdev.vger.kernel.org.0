Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B94C22786C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgGUGBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:01:31 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:60227
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgGUGB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 02:01:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/XRY5MfNXQupkq1EgwnBoaUqRVO4s65Iw325/XPOTZJGDvFLGnYeFov0RgGxN/sUYxcdJHnZe046m3e3XrSHVbUPRrgqFbatH1U5DJfLsYfNH0NJhH+zUVRX0NsyLjsBkMrOZpIna3pOXReWhHPSByS3o7K+XabLE9aJcbH6fsy5HAgqion6OWmYOgNQW3yrXa+GPfu0YF44QpNzQ0KjBLWxw6KJncaZl4I1JXV5M/sSzFp4gtw0GXRXHPBhZAUXOevnOPcMhDvQZ4NdDw+zhLkp5hmjxOwn4r4rXJ8Nk9sitgv+Nyp5JmVxXKyDT7wfl4i1QYWWAiDciwJPVpfcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZDmOwe5IRJkzsswat/n+zuNOBT9MnRUnSbtTRK1tFY=;
 b=K+Gcrd6MrtUg46pHBndgEH6QHp4DwWOqRZIUDG2KNk4SqK9+5nZ3p0pqPNKUs3iyga8Dkuc0TyKPiOyD9aA8Toc03htgaPwc2fz9TyQ+TzVIOYQlVNnLRvdy1Sv6uOHd4GSwDvL99ZgWYvbPIDphP9i5JoPj7IzqCfpuCReFB8RbQA665WIRzLVSIqi92F+kXUF267Oxom0Su5YKp80mf/LIEgt3GEcROTNMZFQyJ4yHlX6h9hEoqvwJ9WCCecpbmxKEcJbO7ofa4jeX4n9KFlhkZTYbttZJTC65kQwUsAEJGCtfFpOL5G6CQx+kM7sB9ImLYck/hZfIXv1p4fzb1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZDmOwe5IRJkzsswat/n+zuNOBT9MnRUnSbtTRK1tFY=;
 b=JQ0yN/AtZQYV5y9JflM3p21HRlmzU1xyY12pcwo4db1XbkedEm7+Jr/nOv9bsQGgsyFOgbs28ZqayPMSTTCYdQ1vNSNXN8tH2Yr5D9CoxCVzQ4Ah7dOZWh4F3McssWwmR/I4f0vIsmGga74aPWz0ucB8PwWeJkrmoiWAhV0rKA0=
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB5005.eurprd04.prod.outlook.com (2603:10a6:803:57::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Tue, 21 Jul
 2020 06:01:24 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7%2]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 06:01:24 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: RE: [EXT] Re: [PATCH 1/2] net: dsa: Add flag for 802.1AD when adding
 VLAN for dsa switch and port
Thread-Topic: [EXT] Re: [PATCH 1/2] net: dsa: Add flag for 802.1AD when adding
 VLAN for dsa switch and port
Thread-Index: AQHWXxtkRVEcRQlmlEijioIIeDEM6akRiAAg
Date:   Tue, 21 Jul 2020 06:01:24 +0000
Message-ID: <VI1PR04MB5103EAF6A07FA49BCED868F3E1780@VI1PR04MB5103.eurprd04.prod.outlook.com>
References: <20200720104119.19146-1-hongbo.wang@nxp.com>
 <3c41dab1-307c-51f3-9d39-a164e8ffcdee@gmail.com>
In-Reply-To: <3c41dab1-307c-51f3-9d39-a164e8ffcdee@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b71fe8bb-25b5-4473-8ad8-08d82d3b8021
x-ms-traffictypediagnostic: VI1PR04MB5005:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5005C92688933D2AD1106964E1780@VI1PR04MB5005.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4MjFj8it+orktOeJkqQhfdRZ8lxWXt6W4QJENQYT66RPvN+I9Vo2jg4iovnjUcUzGle16Zel5NywsIZddGDB/SGZSOR9VIdGFn1PWUaFvjcwEtEtKztn1oZ0jri2k/EB3GjMSYC4MC1aM54Un5fgngWANiAQ8jE1eBTRqQ+oGgebYCq5UTPEdly+k3VxSRGXWMNmZNwKTzneqWDb0/mYXTgVRC9chcQg/YwZNkKvN1uJbT5z6urkxU5gb9fnYi8RcCNv/dLE6QFItMR4DfxrOUU3aRKgq81GtjlHLGoDOpyMJM3Yb5TGf6b2zGsb1PwjUmBb8lnR+vUWBAXxywbB+5r9Mflq3JbO3V/2ejiq7ZFPDiE4q4RChTr1FNsKHJht
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(76116006)(64756008)(66446008)(66946007)(110136005)(316002)(66556008)(66476007)(44832011)(86362001)(33656002)(8676002)(8936002)(71200400001)(9686003)(55016002)(7416002)(6506007)(186003)(5660300002)(52536014)(53546011)(478600001)(83380400001)(26005)(7696005)(2906002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Q3puZ0lBOqe9PspqbdvQCorBNNWcyR/GMlyhXa3J26biL9S3WlOIDs88AMN8yWtpGy5a/xko7Owy9gVd67Ga03h/t7pFRQybleRu1sowm2/SoQR1zeL5bzfEIOrytdAlk/ybA6PBeJptw7usiFSk6QxfKsJgTowu8k+PvY8qwI9xIP+bv1ZFd9DtzfGliyGct7vzj2pDSTeWWH3tZxQQ6R+ZIJXUZRv4oXOhJjROMc/L7BB1lKJX7/AftHlKYnfy7+YqIS3mp/JsviJhsmu3f9P6hWPMFUj3a+zInRkeWXxsOiyhyNPUANzyPZT/BFRkFtUwxtPfDxvQfTWDw8v0SmgEYnfStVcy9Y2RtQsEt6YzqII3wQMrvSAwYw0i8WfVUsqVM/ypiVnVrcnBHi5Hbsz1gOM6DRl29WTzH2sW37C51x98N611Id3CCUUM2ZQ7bbLbR1qBG97tHzNDDyuRFgiQOzaLjOk4RUU06ZLTM6M=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b71fe8bb-25b5-4473-8ad8-08d82d3b8021
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 06:01:24.7198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K5Ru+tHh7sBMdBfji41/8LzTFAcBEYZrJYYOKd/RGfTBy07pKDp21xb9b/jRmsm/zsMtw1aPRb1zwPuL8V7zag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5005
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIHN1Z2dlc3Rpb24hDQpJIHdpbGwgY2hhbmdlIHRoZSBjb2RlLg0KdGhh
bmtzLg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogRmxvcmlhbiBGYWluZWxs
aSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+IA0KU2VudDogMjAyMOW5tDfmnIgyMeaXpSAxMjo1Nw0K
VG86IEhvbmdibyBXYW5nIDxob25nYm8ud2FuZ0BueHAuY29tPjsgWGlhb2xpYW5nIFlhbmcgPHhp
YW9saWFuZy55YW5nXzFAbnhwLmNvbT47IGFsbGFuLm5pZWxzZW5AbWljcm9jaGlwLmNvbTsgUG8g
TGl1IDxwby5saXVAbnhwLmNvbT47IENsYXVkaXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAu
Y29tPjsgQWxleGFuZHJ1IE1hcmdpbmVhbiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAuY29tPjsg
VmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47IExlbyBMaSA8bGVveWFu
Zy5saUBueHAuY29tPjsgTWluZ2thaSBIdSA8bWluZ2thaS5odUBueHAuY29tPjsgYW5kcmV3QGx1
bm4uY2g7IHZpdmllbi5kaWRlbG90QGdtYWlsLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgamly
aUByZXNudWxsaS51czsgaWRvc2NoQGlkb3NjaC5vcmc7IGt1YmFAa2VybmVsLm9yZzsgdmluaWNp
dXMuZ29tZXNAaW50ZWwuY29tOyBuaWtvbGF5QGN1bXVsdXNuZXR3b3Jrcy5jb207IHJvb3BhQGN1
bXVsdXNuZXR3b3Jrcy5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IGhvcmF0aXUudnVsdHVyQG1pY3JvY2hpcC5jb207IGFsZXhhbmRyZS5i
ZWxsb25pQGJvb3RsaW4uY29tOyBVTkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29tOyBsaW51eC1k
ZXZlbEBsaW51eC5ueGRpLm54cC5jb20NClN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0ggMS8yXSBu
ZXQ6IGRzYTogQWRkIGZsYWcgZm9yIDgwMi4xQUQgd2hlbiBhZGRpbmcgVkxBTiBmb3IgZHNhIHN3
aXRjaCBhbmQgcG9ydA0KDQpDYXV0aW9uOiBFWFQgRW1haWwNCg0KT24gNy8yMC8yMDIwIDM6NDEg
QU0sIGhvbmdiby53YW5nQG54cC5jb20gd3JvdGU6DQo+IEZyb206ICJob25nYm8ud2FuZyIgPGhv
bmdiby53YW5nQG54cC5jb20+DQo+DQo+IHRoZSBmb2xsb3dpbmcgY29tbWFuZCBjYW4gYmUgc3Vw
cG9ydGVkOg0KPiBpcCBsaW5rIGFkZCBsaW5rIHN3cDEgbmFtZSBzd3AxLjEwMCB0eXBlIHZsYW4g
cHJvdG9jb2wgODAyLjFhZCBpZCAxMDANCg0KWW91IHNob3VsZCBwcm9iYWJseSBpbmNsdWRlIHRo
ZSBzd2l0Y2ggZHJpdmVyIHRoYXQgaXMgZ29pbmcgdG8gYmUgYmVuZWZpdGluZyBmcm9tIGRvaW5n
IHRoZXNlIGNoYW5nZXMgaW4gdGhlIHBhdGNoIHNlcmllcywgcHJvdmlkZSBhIGNvdmVyIGxldHRl
ciB3aGVuIHNlbmRpbmcgbW9yZSB0aGFuIG9uZSBwYXRjaCwgYW5kIGFsc28gY29tYmluZSBib3Ro
IHRoZSBhZGQgYW5kIGRlbGV0ZSBwYXJ0cy4NCg0KU2luY2UgeW91IGFscmVhZHkgaGF2ZSB2aXNp
YmlsaXR5IGludG8gcHJvdG8sIGl0IG1heSBub3QgYmUgbmVjZXNzYXJ5IGF0IGFsbCBmb3Igbm93
IHRvIGRlZmluZSBhIEJSSURHRV9WTEFOX0lORk9fODAyMUFEIGJpdCBpbiBvcmRlciB0byBwYXNz
IHRoYXQgZmxhZyBkb3duIHRvIERTQSBmb3IgcHJvZ3JhbW1pbmcgdGhlIFZMQU4sIGp1c3QgcGFz
cyBwcm90byB0bw0KZHNhX3BvcnRfdmlkX2FkZCgpIG9yIGEgYm9vbGVhbiBmbGFnIHdoaWNoIGlu
ZGljYXRlcyB3aGV0aGVyIHRoaXMgaXMgdGhlIGN1c3RvbWVyIG9yIHNlcnZpY2UgdGFnIHRoYXQg
eW91IGFyZSB0cnlpbmcgdG8gcHJvZ3JhbT8NCi0tDQpGbG9yaWFuDQo=
