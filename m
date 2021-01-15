Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB08F2F87AB
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 22:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbhAOV2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 16:28:20 -0500
Received: from mail.eaton.com ([192.104.67.6]:10400 "EHLO mail.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbhAOV2S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 16:28:18 -0500
Received: from mail.eaton.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98FA1A40F4;
        Fri, 15 Jan 2021 16:27:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1610746057;
        bh=S3trLsskeEwavwIOOg4uzqGerzJ+HCVvLoCzwSADwOI=; h=From:To:Date;
        b=ovyW9cR4TkSus4rzmMQ5ehfL0VZUqVJBRqGBIltW2CAGFIt9TXb/wlzaNjwwj+gFv
         a+Tf6Nz1OXhZYeoygxjZd/kmPRLz8s5wgw6hhc+nt37wGR0wLYKjE9BB4Cv65zNET0
         6KOzb0+vuhJ8M7seWVvYccByOB+1O987EhUtSp0CQi25c8ARmU/AUM1TwVnEr5FtBy
         5cReYuq/ztlMOgqhPWuo02tJNzToWS4eq/sFcFeJYIYLrPetxzyYrj3ZWzS4z32DOD
         TC3o7RIiAbq93VNJAjFmGpYDLQ+P6w5DyvN+dnQBNmy4ouRe5SY/dqShS0HTdFIWYi
         XMe5YKSIn5KdA==
Received: from mail.eaton.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88C5DA40D9;
        Fri, 15 Jan 2021 16:27:37 -0500 (EST)
Received: from SIMTCSGWY04.napa.ad.etn.com (simtcsgwy04.napa.ad.etn.com [151.110.126.121])
        by mail.eaton.com (Postfix) with ESMTPS;
        Fri, 15 Jan 2021 16:27:37 -0500 (EST)
Received: from LOUTCSHUB05.napa.ad.etn.com (151.110.40.78) by
 SIMTCSGWY04.napa.ad.etn.com (151.110.126.121) with Microsoft SMTP Server
 (TLS) id 14.3.487.0; Fri, 15 Jan 2021 16:27:36 -0500
Received: from USSTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.154) by
 LOUTCSHUB05.napa.ad.etn.com (151.110.40.78) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 15 Jan 2021 16:27:36 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by hybridmail.eaton.com (151.110.240.154) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Fri, 15 Jan 2021 16:27:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nifF1Eww8Txyl/BRAoxwkx6ivc57cl4Yh+JG0+2hwPk1C4Ds1Jl9Un93uvmPOc71oLqQDCqQdqKPNM9FDiLIyzijKUr6Q0jExwOdYCiMUpaV4b/X40+JavsqHK4JEVkCYKhixvvvaCcvu/za4amjAeZDOcNWEK0ox/9U+JtJZQMe0KVaDDNVDj5qiI2bIgnBqdfbkC9SaduBG4ikXbprd8Oz8vZuLvY0R80nyMjhfYmm52SbhmvR7/XtRQ+9uukDmRnKB+fLjnLGvwnXLMT73Y13YahFd0PXSpPQrxrLTs/TzxKcUTBozt3udExvgnS93glwntpOKamXwkWbbvjqRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnCJPN7qC9qDEzSPcxrrkVJHiUZeqSZDspzgS2cExIM=;
 b=dv83tkeCn+G3EYt5eyE/u2IcuBwXNhrLT6DnwEPhz05PlK9x+7yYQvSVgOH2UyehAeo4XDgJ5P88FPJAHAgEcCcHZtQw32aS0+QXvs6+EJ7HeHEs3S6TEr6pOCXAH7DSsM6wp5+XdfDbDWi24f4fCTpghgxhks1lW/RObRTaG3VGdF/9vyF5UK5j239j9HzIV0MK159s2l524+08/fRQ7ZndO6qULWX8D7EPiFfQLix6mTfmuWYweaO9cStUODOa+SdqpFPtct8NWcgV/ggu5sX5mPIHs/KiOUOSfWlGakRNJ6w1CmhzdRmSWrg93t8mX2XytGHS7xfp3oNlR/klZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnCJPN7qC9qDEzSPcxrrkVJHiUZeqSZDspzgS2cExIM=;
 b=IQWlYLuAupf+P1keA4GiDiSA7w4wujuo07Dh/1+6dmVnNH0n2wki/tZcQ34tDWMbD0faIxDUCVRM3p/rc5baXih4ogOEHYyv2tGpGIi6JE2AL/heZcyPrEJvDloKvwWUX3TPF2M7b7dI1FRaEgcIArpzh/zIic17MVLa9qYvcXc=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MWHPR17MB1293.namprd17.prod.outlook.com (2603:10b6:300:8a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 15 Jan
 2021 21:27:35 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.012; Fri, 15 Jan 2021
 21:27:34 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "marex@denx.de" <marex@denx.de>
Subject: RE: [EXTERNAL]  Re: Subject: [PATCH v3 net-next 0/4] net:phy: Fix
 LAN87xx external reset
Thread-Topic: [EXTERNAL]  Re: Subject: [PATCH v3 net-next 0/4] net:phy: Fix
 LAN87xx external reset
Thread-Index: AdbrYlJ9lIFRoNXFQCGzpMmC2Op2PgAAqvWAAAfdUDA=
Date:   Fri, 15 Jan 2021 21:27:34 +0000
Message-ID: <MW4PR17MB42432F1FFA793BDE7286F376DFA70@MW4PR17MB4243.namprd17.prod.outlook.com>
References: <MW4PR17MB4243A17EE8C434AE3DCAEAF4DFA70@MW4PR17MB4243.namprd17.prod.outlook.com>
 <a54ae202-fed9-1fff-5e71-b7a93f09c411@gmail.com>
In-Reply-To: <a54ae202-fed9-1fff-5e71-b7a93f09c411@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1806bb19-cf3d-4437-b7cd-08d8b99c5fe5
x-ms-traffictypediagnostic: MWHPR17MB1293:
x-microsoft-antispam-prvs: <MWHPR17MB129347F9038ABA539A587F2FDFA70@MWHPR17MB1293.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sv7GGFRsCsC8k1/6Ar9uLBHfNiAHNP5rHKbRq89QAcqMUtSOIXCQmivtrqeSbSsvXWWZ8b3oNGB2ipevT+n0MjzpURfhcokQ9lthgs+46u1rQPydov2Z249hzG+6h/prc1knckTwtjfEbE0iRJbCsenjnxOsJoHBc/VYhtonrC+pXxeihA5HEisXhAnT27W1NHcf0lwaeRJWnpV8a3emuN01BoGn2P4TiVffp6sbOx/qbspBNV+JHqpS/04KvxhUUx3oixT9dF/6V+QkVjaageYfyylSgtYwHjEdVtoZ9jG26IPqQoasfdQvIlBJ3jCOftyuE/F5/I2K2dGlUVYnb9T9ZrNYQh4wtENlEk1Kki/FC1j0Lvtu2Zf6Ei2yGQekRN5C74zYJ0sO6AZpRAGzUYB5BApMfJfB+xtOAUN6PAXbpQjkuf7gGTCi39/8vBQ0XBzV9WBSAHa3Zr2NNvyEJe6pF5VcGq651oLYr8irK38YVz9gia0rAIdDzvVMNdz7xP5iw23wxqtUsIA6AaIRw5o7oP+Y+yI/7F7Z/feVOtd3VpNU5Fpzh6E3JdWWPz6x
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(366004)(396003)(316002)(478600001)(8676002)(921005)(110136005)(186003)(7416002)(52536014)(71200400001)(66556008)(6506007)(66946007)(8936002)(66446008)(4744005)(76116006)(64756008)(5660300002)(33656002)(66476007)(86362001)(2906002)(7696005)(55016002)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?blZ4VGxMQVl3R0dFbURwTERYTDgwQUZ5WGh3UjZEUVMyRGN5emI1dnVEQ245?=
 =?utf-8?B?bHQyOWI4a2wxaUtVQ2VDWnRXaUtITE9IbngxRnJUZVFpR3lhWGpnazVGRnRS?=
 =?utf-8?B?SEJlcVNYcGNVMk5nQm1qNkZheUdzL3FTOXNNck5GZFJGZXVLK3FWeHE0VGFv?=
 =?utf-8?B?TW9Fem9UN29iampwdTBqMkpWZ2RnbkJ1Zm5GVVFvejZQWEtPalhqdFYrR3U0?=
 =?utf-8?B?UGhJNTlmVHowOWNGcS9VbVB5RzZDMW9ZL25YL1NrL2JvZk1XUFJSOHAzdkJp?=
 =?utf-8?B?RXV3TU5qTERPRmhpaTNEWmNjVDFnWGZnQ0YvYWcweWx1L3hOdWpvZlZBaFpJ?=
 =?utf-8?B?MG1mVnlObm9ZaGdSVGxjam1jUjZFQWJ3N0R2WkhQSEtISFhaSlpxRmkxU3lX?=
 =?utf-8?B?L0FCa3Q4YUw1RUlGOHJZQXpyS1d1YmRUQzFQMGZVYWtUZ1NhTGlBd0VWWlRz?=
 =?utf-8?B?N0pmU3ZJWU1Yc1JmV21vK2pEa0VQZ0NTQlo3Y2tCM1NMLzQ4dzdSeGNxak1Z?=
 =?utf-8?B?SWhyK0VkTHBQd3drUk9ySS9ZaXEwVWNoMkdacnk2TmNkYy96UWNxa2FibzZr?=
 =?utf-8?B?SzRJa0xicTFBNTRrQVFSMFRJVDVuaFFTeVUyemRuZ2VWdjBSdHFaSFUyZWxu?=
 =?utf-8?B?QXIyWWtWelk3bHpsKzFweUlHZjk0MHJhZnRvZmNkczBRak9XMWY4dUF4S0xF?=
 =?utf-8?B?UVpOL2FFekFQaUJRd3BBZXlRQSt3b2FWRzBOZjIvcndJZ1h3UzdwdjI5cGI4?=
 =?utf-8?B?OW1rYUVEZXhtcThnUG8xOU1uSTY2eEM3UjRQZDRBbG9xWGpVMmFvRVkwcFdB?=
 =?utf-8?B?VW96Tm11eWtISTVZSk56ZmNnNjk2dTlQanY0d01jQzBzcDRiY1ZmVEh0dm9n?=
 =?utf-8?B?UGhQUFp0Qjl5enNNcitjMFpncWV5V3B0RVR6TnU5MGttZmZ2R2F4WlNzUS9B?=
 =?utf-8?B?VkZFRS9rc01EbVNHMEhiKytINFppUXpRR3NOcUJlRk9mVmJNWTAreS9rV1Rw?=
 =?utf-8?B?YWpGVEJuUVdwbTRsWjBaRVdZVys1ZEFJVEd1SmdBTDhOanB4QTZUUXpMQTQ5?=
 =?utf-8?B?cVY0dEU0bVNzWVgwYVRKMmoyZmNEUWJCOTVIQWJXWEY0UkZ0Q1lnKzNURnRQ?=
 =?utf-8?B?ZnRSREg5Qnd6QW5iSGRzMFlmTHdtNERSQlBKeGdtQ1FmSjRPYnkvUktSRWRL?=
 =?utf-8?B?QUtobC9QOWxlWGVRWVFLL3VKeEJqS0xJMTFlUXBjaWl2RkpoaTJGdkVhRTQz?=
 =?utf-8?B?elRyRzNLbnBXNUdNbnVobTE4TnkweU5jRm0vcGZ2SUxWb1ZEK3BSSXdpUjU4?=
 =?utf-8?Q?b4ZyM0OlVFCjA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1806bb19-cf3d-4437-b7cd-08d8b99c5fe5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 21:27:34.5920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t4uYxfHHEWSW4dJFul+GA49QvRUvrLkiiNMAYqcKLefSNfVHzY3cde4HP2LFq5IeUP7WwX4t040tO/0Wh9Ukbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR17MB1293
X-TM-SNTS-SMTP: 6A06B6EA470961AFDA1628492B45544A2ACD3B0CC2E2676073B2F876665EEA742002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25914.003
X-TM-AS-Result: No--1.955-7.0-31-10
X-imss-scan-details: No--1.955-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25914.003
X-TMASE-Result: 10--1.955300-10.000000
X-TMASE-MatchedRID: wwSHOPa+JnopwNTiG5IsEldOi7IJyXyIPbO0S2sWaK0INpIFnbd6mgJL
        geCuSVwTmSEjNM/fT229Dds2u7nt3/uWOZ0/dCAgbqAAJ/GZaERnXBVFJwvSMLV5fSMRD1zq3b5
        klkiTGS7srX/9aYvFF7jB34/4+w7smuFF+57DxF4AjRSlC8RgmToSfZud5+Gg5OkG4vvYug8dq6
        xnvK2Wy81UDkA2+TEzy4K9X54gr34A7bU4vrpHXKubsOtSWY2QkZOl7WKIImp8nn9tnqel2MprJ
        P8FBOIadkP4uJM/o+P25kCPYjrV7/ubiYj3IT/tGYTtAjdf6xBUuTmOJY8M8nZX2ynyuGLB0XUn
        +7smc5HLgBTE/JyuFoeAegcTDbDo3hqbc6QRizHb0LncCWtVBG4ljHS6azP5m4z+eW1nbUHIsQo
        zxkIbzkMMprcbiest
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

77u/ID4gVy9vIGtub3dpbmcgdGhlIGV4YWN0IGlzc3VlIGluIGRldGFpbDogRm9yIHRoZSBzYWtl
IG9mIGJpc2VjdGFiaWxpdHksDQo+IHNob3VsZG4ndCBwYXRjaGVzIDQgYW5kIGEgbW9kaWZpZWQg
cGF0Y2ggMyBiZSBmaXJzdD8gQWZ0ZXIgcGF0Y2hlcyAxDQo+IGFuZCAyIHdlIG1heSBiZSBpbiB0
cm91YmxlLCByaWdodD8NCg0KVGhhbmsgeW91IHZlcnkgbXVjaCBmb3IgdGhlIHF1aWNrIHJlcGx5
LiBZb3UgYXJlIHJpZ2h0LCB0aGlzIHdvdWxkIGJlIGEgYmV0dGVyIHdheSB0byBzcGxpdCB0aGUg
Y2hhbmdlcy4gDQpJIHdpbGwgZG8gYXMgeW91IHN1Z2dlc3QgYW5kIHJlc3VibWl0IG9uIE1vbmRh
eS4gIA0KDQoNCj4gDQo+IEFuZCBpdCBzZWVtcyB5b3UgY29tcG9zZWQgdGhlIG1haWxzIG1hbnVh
bGx5Og0KPiAtIHN1YmplY3QgaXMgcHJlZml4ZWQgd2l0aCAiU3ViamVjdDoiDQo+IC0gcGF0Y2gg
c3ViamVjdHMgaW4gdGhlIGNvdmVyIGxldHRlciBkb24ndCBtYXRjaCB0aGUgb25lcyBvZiB0aGUN
Cj4gICByZXNwZWN0aXZlIHBhdGNoZXMNCj4gDQpNeSBiYWQsIEkgZGlkIGNvcHktcGFzdGUgdGhl
IG91dHB1dCBvZiBnaXQgaW50byB0aGUgZW1haWwgY2xpZW50IGFuZCB0aGlzIHNsaXBwZWQgdGhy
b3VnaCAtIEkgd2lsbCBiZSBtb3JlIGNhcmVmdWwgaW4gdGhlIGZ1dHVyZS4gU29ycnkgYWJvdXQg
dGhpcy4gDQoNCj4gRm9yIHRoZSBwYXRjaCBwcmVmaXhlczogUGxlYXNlIGFkZCBhIHNwYWNlIGJl
dHdlZW4gbmV0OiBhbmQgcGh5Og0KV2lsbCBkbywgdGhhbmsgeW91IGZvciBwb2ludGluZyB0aGlz
IG91dC4gDQoNCkJlc3QgcmVnYXJkcw0KTGF1cmVudA0KDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQpFYXRvbiBJbmR1c3RyaWVzIE1hbnVmYWN0dXJpbmcgR21iSCB+IFJlZ2lzdGVy
ZWQgcGxhY2Ugb2YgYnVzaW5lc3M6IFJvdXRlIGRlIGxhIExvbmdlcmFpZSA3LCAxMTEwLCBNb3Jn
ZXMsIFN3aXR6ZXJsYW5kIA0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KDQo=
