Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F1A1CC157
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 14:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgEIMbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 08:31:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28896 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727111AbgEIMbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 08:31:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049CQHv1030995;
        Sat, 9 May 2020 05:31:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=CgzoyqH+mLc4jGjbBtJtUA6q67Q+NNrPXdgkgBJVeNY=;
 b=ULOWTUvMlRBlgVEENdQvPIIRPk1kjN9ZDzFM3lRzxsrSsEpMpLdBgx8+DgxndZC6l1x3
 K2ScAnIwakgKw2R/DuorM4sK95l/IcLO6rYSEFEB1DoSyvytnXKQdP9Ha6REOUyHNqcv
 mBBoHVvrIw7WFOHZqwWyuU6VskBhRofmIR4yUf0ip9BOZv1UyCaP6sOgamNeFW0i7Smc
 wx0kaitlFmzsfzo7FJ3I0zLcFTQdwuULcyi3xIKJTmxQvyB8iOdCWEoLM9GbXQ5TeWku
 jPV99kVtw+L4SFkha24nzoHNYaI2Xwh7mfzdOEdJLBHm9ujKYicUeJrgdvh1f0z1Xk+k aQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 30wsvq8dnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 09 May 2020 05:31:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 9 May
 2020 05:31:23 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 9 May
 2020 05:31:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 9 May 2020 05:31:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGf5/E1nEH5DzJMHhc2p1j5ItuqRoWJN9YsVoFZTJu1Dv3Sy10iuQ9ijDVwa0UetoFAgsOfP24RM/PHGHbQygQO296/yoeH9029nIX7VH+y/Kwdvyh6Lg1L/jN1wbh73POJNH+1Fv0yjeD/HoJWtsX+fGTJqu6fAsF97dygLin+9CZgIWMxI/c2+i2zhBnvK8qYioNGDPPHSwT7xX94Suov+5MKwqCH2OLSQqLph83nHfO8DJ2DoGsz/CzmAaMgE7lOlYzHW4rNxFUiH0Dz/Zc12X4HKxdx91b+ToAi7XS2jdPxBvTsfo527tvVLMj9YEOrf1xcC+RfeDzsVIpAKRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CgzoyqH+mLc4jGjbBtJtUA6q67Q+NNrPXdgkgBJVeNY=;
 b=jciW1bIAzLQcdJtv6J2jXeHHMPxjCF07id0HzIOtZ809bPNgZM+linGeX/hbA7R9Kmm0LIX4roacARZKSzz9k/2wpWKMA3B9Fei0Z+vNRPb0Tyt56eCBpeOoPyYmfKk+L5xLPh2qFB1oyb9eoXMovFSyz+83WISCnVzaODKBHV+ZpS8eVgzCupSM3+ynRh8x/0mS1fXAvLLLenDgFueCNqtqbxwojhDNj0PsEmbiGnKF5LdJF1R+Rh5k5DWg69c1nfJ1Jw1pTJCfvU8Llvbe4h79w2mwACPl6JYqA1KJlCS3fXsD0KFRyMcjs0pgRb66K2ZJe0oANtqHZL9Z6TfX8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CgzoyqH+mLc4jGjbBtJtUA6q67Q+NNrPXdgkgBJVeNY=;
 b=IEISvQqYR9KpM6PWmtDB8lWVZg5urTRH4ASSP0xuvYrMSOahFsL1ouU0X4piLvP00VusqmGcKpHO0EWXupIBiRKHpOAVDuYfcY4E0HEH+HR+8XNrup7zjYXKowUfYCZC74pLy+eyhNYYuINguzHBFN8sDMNanY0DBEBUtLFs+n0=
Received: from DM5PR18MB1146.namprd18.prod.outlook.com (2603:10b6:3:2c::15) by
 DM5PR18MB1115.namprd18.prod.outlook.com (2603:10b6:3:31::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.26; Sat, 9 May 2020 12:31:21 +0000
Received: from DM5PR18MB1146.namprd18.prod.outlook.com
 ([fe80::51c3:5502:21c2:f515]) by DM5PR18MB1146.namprd18.prod.outlook.com
 ([fe80::51c3:5502:21c2:f515%12]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 12:31:21 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Matteo Croce <mcroce@redhat.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: RE: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts
 to handle RSS tables
Thread-Topic: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts
 to handle RSS tables
Thread-Index: AQHWGZC7cQmjD8WUCU6s0i6IN8JFgKie+g2AgAC4ufCAABFigIAAAbyQ
Date:   Sat, 9 May 2020 12:31:21 +0000
Message-ID: <DM5PR18MB11462564D691544445CA2A43B0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
 <20190524100554.8606-4-maxime.chevallier@bootlin.com>
 <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
 <20200423170003.GT25745@shell.armlinux.org.uk>
 <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
 <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
 <CAGnkfhwV4YyR9f1KC8VFx4FPRYkAoXXUURa715wb3+=23=rr6Q@mail.gmail.com>
In-Reply-To: <CAGnkfhwV4YyR9f1KC8VFx4FPRYkAoXXUURa715wb3+=23=rr6Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.83.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 870e0a22-09a4-408c-22b7-08d7f414e1a2
x-ms-traffictypediagnostic: DM5PR18MB1115:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB11159C1BF4D9760F323ABB3BB0A30@DM5PR18MB1115.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03982FDC1D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IracEIVcWtXy1P+MESoN76pcH2DACZZoaHt+PnMNqjbMUiU/DYJGPqFI9xV/YwNancCp8JYL9Hm345rN4D0n3CCHfiQhOSo6rfjwmD6d38b/bFjveYQad7wiA2bCnJMGdJ9HqTvteCE9g7aIw8kyFRpbIs7E3oKX7QbPvrSmjIAELSsguPKRTylvoh13asyUYSukoHVRFTRrZ4024mhOSu6s26TvqqenLEvkcXvGkMbkRRjs1zxK2flva73qKrw84743mJudUBovFvsSuS7tHRZA0+gfJG+zj/IwQOH42ZiFyYBB7oYpM5mn9qQpnjyUCwyOXldxrJmKxBFXT2iIfHaX9YeCgy90GlkpngKStxwsDqsCg7N1Se5R0DF3JelgOEmz9RRxlsu+g50jF/GCIXV+cJbqZp1g/BP7BnLECMWA88gPCMuhRsQjhWEArp1Ro3ME9jzXnDaNkqjhnnd7AC0h2Ziru5q0AmUPj/WZJgSva+o5Rl0gXGr1EP/+oYh5H70g0dAuoYOT3ASxTfwBkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR18MB1146.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39850400004)(396003)(136003)(346002)(366004)(33430700001)(53546011)(71200400001)(76116006)(2906002)(8936002)(316002)(66556008)(66476007)(7696005)(66946007)(186003)(26005)(33656002)(64756008)(52536014)(66446008)(8676002)(5660300002)(54906003)(6506007)(86362001)(7416002)(6916009)(55016002)(9686003)(478600001)(33440700001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: UBq5DAfFheGmdi0RaCUhbiubjMUofqBTQphZtxvjgtTMU6w+M505OHHeO6xRjbrK7iJJ6WEAap9cD9IY1xpxFn91gtVxY3dmTLcspM6trrle/dC6PA4FDxeyFhbRA14fsEH5U7UjhMA12/cS0fTrrpcMNAQe5RkUrJGza1Ff2Tdn5BWNSfdDYoDhm+Nf/kjlq4xRnV8kwyH7stIbSf2H/ipdwrPX7yYkw8tIFwvAyZl72wyM2nEBsPcStmX0/iuSkhJaoX74Yy5aNp4cRJ8zin7K8W5zOXAPeMdV9JBn/8/nkDzM18HiOg/YPoJ25JDdsFbM7c/gNhFhMbXU2TWh8kHVs1CA+bwu3+u222Dz3t6NNhGFf9Pq/CwRbWDSzQmb/nPKpPhDyWNDie2+NB3QUVXTuQuFjubeOgIOF/v0eWC+Eff7O0bifRSavyRMxHm5T/XnxU9rEP09ujo35Ouyn0MJlKF2ReUcUhmIH0i/984=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 870e0a22-09a4-408c-22b7-08d7f414e1a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2020 12:31:21.7297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: us8MPvoj9+Z5kie36QTOQ96km4VWIWcFBuY3N1jS9OHGgkM0yv0s/a8xKUtql1rE/zwob4977W+6oU7x1HwXdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1115
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_03:2020-05-08,2020-05-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWF0dGVvIENyb2NlIDxt
Y3JvY2VAcmVkaGF0LmNvbT4NCj4gU2VudDogU2F0dXJkYXksIE1heSA5LCAyMDIwIDM6MTYgUE0N
Cj4gVG86IFN0ZWZhbiBDaHVsc2tpIDxzdGVmYW5jQG1hcnZlbGwuY29tPg0KPiBDYzogRGF2aWQg
UyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IE1heGltZSBDaGV2YWxsaWVyDQo+IDxt
YXhpbWUuY2hldmFsbGllckBib290bGluLmNvbT47IG5ldGRldiA8bmV0ZGV2QHZnZXIua2VybmVs
Lm9yZz47IExLTUwNCj4gPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBBbnRvaW5lIFRl
bmFydA0KPiA8YW50b2luZS50ZW5hcnRAYm9vdGxpbi5jb20+OyBUaG9tYXMgUGV0YXp6b25pDQo+
IDx0aG9tYXMucGV0YXp6b25pQGJvb3RsaW4uY29tPjsgZ3JlZ29yeS5jbGVtZW50QGJvb3RsaW4u
Y29tOw0KPiBtaXF1ZWwucmF5bmFsQGJvb3RsaW4uY29tOyBOYWRhdiBIYWtsYWkgPG5hZGF2aEBt
YXJ2ZWxsLmNvbT47IE1hcmNpbg0KPiBXb2p0YXMgPG13QHNlbWloYWxmLmNvbT47IExpbnV4IEFS
TSA8bGludXgtYXJtLQ0KPiBrZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZz47IFJ1c3NlbGwgS2lu
ZyAtIEFSTSBMaW51eCBhZG1pbg0KPiA8bGludXhAYXJtbGludXgub3JnLnVrPg0KPiBTdWJqZWN0
OiBSZTogW0VYVF0gUmU6IFtQQVRDSCBuZXQtbmV4dCAzLzVdIG5ldDogbXZwcDI6IGNsczogVXNl
IFJTUyBjb250ZXh0cyB0bw0KPiBoYW5kbGUgUlNTIHRhYmxlcw0KPiANCj4gT24gU2F0LCBNYXkg
OSwgMjAyMCBhdCAxOjE2IFBNIFN0ZWZhbiBDaHVsc2tpIDxzdGVmYW5jQG1hcnZlbGwuY29tPiB3
cm90ZToNCj4gPiA+IEhpLA0KPiA+ID4NCj4gPiA+IFdoYXQgZG8geW91IHRoaW5rIGFib3V0IHRl
bXBvcmFyaWx5IGRpc2FibGluZyBpdCBsaWtlIHRoaXM/DQo+ID4gPg0KPiA+ID4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9tdnBwMi9tdnBwMl9tYWluLmMNCj4gPiA+ICsrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvbXZwcDIvbXZwcDJfbWFpbi5jDQo+ID4gPiBA
QCAtNTc3NSw3ICs1Nzc1LDggQEAgc3RhdGljIGludCBtdnBwMl9wb3J0X3Byb2JlKHN0cnVjdA0K
PiA+ID4gcGxhdGZvcm1fZGV2aWNlICpwZGV2LA0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIE5FVElGX0ZfSFdfVkxBTl9DVEFHX0ZJTFRFUjsNCj4gPiA+DQo+ID4gPiAgICAgICAg
IGlmIChtdnBwMjJfcnNzX2lzX3N1cHBvcnRlZCgpKSB7DQo+ID4gPiAtICAgICAgICAgICAgICAg
ZGV2LT5od19mZWF0dXJlcyB8PSBORVRJRl9GX1JYSEFTSDsNCj4gPiA+ICsgICAgICAgICAgICAg
ICBpZiAocG9ydC0+cGh5X2ludGVyZmFjZSAhPSBQSFlfSU5URVJGQUNFX01PREVfU0dNSUkpDQo+
ID4gPiArICAgICAgICAgICAgICAgICAgICAgICBkZXYtPmh3X2ZlYXR1cmVzIHw9IE5FVElGX0Zf
UlhIQVNIOw0KPiA+ID4gICAgICAgICAgICAgICAgIGRldi0+ZmVhdHVyZXMgfD0gTkVUSUZfRl9O
VFVQTEU7DQo+ID4gPiAgICAgICAgIH0NCj4gPiA+DQo+ID4gPg0KPiA+ID4gRGF2aWQsIGlzIHRo
aXMgIndvcmthcm91bmQiIHRvbyBiYWQgdG8gZ2V0IGFjY2VwdGVkPw0KPiA+DQo+ID4gTm90IHN1
cmUgdGhhdCBSU1MgcmVsYXRlZCB0byBwaHlzaWNhbCBpbnRlcmZhY2UoU0dNSUkpLCBiZXR0ZXIg
anVzdCByZW1vdmUNCj4gTkVUSUZfRl9SWEhBU0ggYXMgIndvcmthcm91bmQiLg0KPiA+DQo+ID4g
U3RlZmFuLg0KPiANCj4gSGksDQo+IA0KPiBUaGUgcG9pbnQgaXMgdGhhdCBSWEhBU0ggd29ya3Mg
ZmluZSBvbiBhbGwgaW50ZXJmYWNlcywgYnV0IG9uIHRoZSBnaWdhYml0IG9uZQ0KPiAoZXRoMiB1
c3VhbGx5KS4NCj4gQW5kIG9uIHRoZSAxMCBnYml0IGludGVyZmFjZSBpcyB2ZXJ5IHZlcnkgZWZm
ZWN0aXZlLCB0aGUgdGhyb3VnaHB1dCBnb2VzIDR4IHdoZW4NCj4gZW5hYmxlZCwgc28gaXQgd291
bGQgYmUgYSBiaWcgZHJhd2JhY2sgdG8gZGlzYWJsZSBpdCBvbiBhbGwgaW50ZXJmYWNlcy4NCj4g
DQo+IEhvbmVzdGx5IEkgZG9uJ3QgaGF2ZSBhbnkgMi41IGdiaXQgaGFyZHdhcmUgdG8gdGVzdCBp
dCBvbiBldGgzLCBzbyBJIGRvbid0IGtub3cgaWYNCj4gcnhoYXNoIGFjdHVhbGx5IG9ubHkgd29y
a3Mgb24gdGhlIGZpcnN0IGludGVyZmFjZSBvZiBhIHVuaXQgKHNvIGV0aDAgYW5kIGV0aDEpLCBv
cg0KPiBpZiBpdCBqdXN0IGRvZXNuJ3Qgd29yayBvbiB0aGUgZ2lnYWJpdCBvbmUuDQo+IA0KPiBJ
ZiBzb21lb25lIGNvdWxkIHRlc3QgaXQgb24gdGhlIDIuNSBnYml0IHBvcnQsIHRoaXMgd2lsbCBi
ZSBoZWxwZnVsLg0KDQpSU1MgdGFibGVzIGlzIHBhcnQgb2YgUGFja2V0IFByb2Nlc3NvciBJUCwg
bm90IE1BQyhzbyBpdCdzIG5vdCByZWxhdGVkIHRvIHNwZWNpZmljIHNwZWVkKS4gUHJvYmFibHkg
aXNzdWUgZXhpc3Qgb24gc3BlY2lmaWMgcGFja2V0IHByb2Nlc3NvciBwb3J0cy4NClNpbmNlIFJT
UyB3b3JrIGZpbmUgb24gZmlyc3QgcG9ydCBvZiB0aGUgQ1AsIHdlIGNhbiBkbyB0aGUgZm9sbG93
aW5nOg0KaWYgKHBvcnQtPiBpZCA9PSAwKQ0KCWRldi0+aHdfZmVhdHVyZXMgfD0gTkVUSUZfRl9S
WEhBU0g7DQoNClJlZ2FyZHMuDQo=
