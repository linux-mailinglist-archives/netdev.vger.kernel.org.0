Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9540CE2B63
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 09:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437975AbfJXHtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 03:49:08 -0400
Received: from mail-eopbgr140080.outbound.protection.outlook.com ([40.107.14.80]:28229
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437969AbfJXHtH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 03:49:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUXpUnKvbfC+wZqBAVh5yFP84zLRapg8t5PsFUqDI3PrhdYIiY4P5W/EGhhuYId83/Jl4lNiYp2KKNzPgqvTLFblizTzKf02sFm/3X1HxfC7g1rntpN6Ys5fXzcsWBW0OxE10IE+zNvw+aNl6LPuSON9OJZ7GH3OGkBIMcVN3UzuEqI6yCkfSkHKIZyOe3zTih5JoEWXpu2idSOZWZ997MW8wcHA+dEIhpsZ0gU3ZdUnRnfQh3OuwLQZNm/VrxJPF6w9fAcSYuKnz5CGlF0+r9GhTW50X3NPq9lEze1mi/eTbSeJENMXxRkSaYGlwipwNwqY1C0Gc7nKddWHVC6Nvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQ5MH9mEysUW4bL432qsECcRaRrIC0mqKe8cZSnzaf0=;
 b=GgOHdxHs25kztN4DE/KA+qJFNXeISLfqNliFi8g/xN1C7SHw+b5eqSgIVs5U4tRK1gx1Ukl1SJtw4SvKcJGx273rTy0XK3fTIyxRX2jbQiu3O9xEC4SeZb/ECe4Qjb7eQCgTQyIvmko7tiV+HveTf51ix8YxvvoYylM27oDAxIW4/BkjLqdKyApcAEtDzcnbf42rQjuh2y0lcHjTUwhgKOdUj0MgLWb7ZmjDERdBXqz0yIeslsOr6z2vd9moCmecoHWAcsXP/pi/48r2dxJr4cx3ESURyNkYLz3y9kc5MYqTo1j3cUydzEdTa33Qo9ZCFFeQui+P8d7UpEGT41NhKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQ5MH9mEysUW4bL432qsECcRaRrIC0mqKe8cZSnzaf0=;
 b=hucKS8iuMJbMIpEML8XcuAln7JcM8dQeaAVWJQj1H8u5XaGy+YXGti9s6lNfKQVT/Gs9PboWxtaO7W1NkN2snaSHVXsIIzwctcaa6ZFy61CKHER3qW4dJbLeNNpunQxqhRRijGCyZnEpoJPyMvosbkZ3r3OOVoyk1N7IuJUdJYU=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB4912.eurprd04.prod.outlook.com (20.177.50.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Thu, 24 Oct 2019 07:49:03 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 07:49:03 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     "hch@lst.de" <hch@lst.de>
CC:     Robin Murphy <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: Re: [RFC PATCH 1/3] dma-mapping: introduce a new dma api
 dma_addr_to_phys_addr()
Thread-Topic: [RFC PATCH 1/3] dma-mapping: introduce a new dma api
 dma_addr_to_phys_addr()
Thread-Index: AQHVig771lgo9fKx8UCeiOjKFT5WdadpauGA
Date:   Thu, 24 Oct 2019 07:49:03 +0000
Message-ID: <ebbf742e-4d1f-ba90-0ed8-93ea445d0200@nxp.com>
References: <20191022125502.12495-1-laurentiu.tudor@nxp.com>
 <20191022125502.12495-2-laurentiu.tudor@nxp.com>
 <62561dca-cdd7-fe01-a0c3-7b5971c96e7e@arm.com>
 <50a42575-02b2-c558-0609-90e2ad3f515b@nxp.com> <20191024020140.GA6057@lst.de>
In-Reply-To: <20191024020140.GA6057@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 566b47aa-28e5-43f4-a5d4-08d75856a3c1
x-ms-traffictypediagnostic: VI1PR04MB4912:|VI1PR04MB4912:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB49125CA14F9CC1B4326A0F68EC6A0@VI1PR04MB4912.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(39860400002)(346002)(366004)(52314003)(199004)(189003)(14454004)(6916009)(31696002)(71200400001)(6246003)(8936002)(71190400001)(76116006)(91956017)(4326008)(561944003)(229853002)(6512007)(1730700003)(81156014)(81166006)(66066001)(8676002)(6486002)(66556008)(5640700003)(64756008)(66446008)(478600001)(66476007)(66946007)(6436002)(316002)(6506007)(53546011)(2351001)(2906002)(54906003)(6116002)(186003)(3846002)(305945005)(7736002)(26005)(31686004)(25786009)(86362001)(76176011)(102836004)(99286004)(2616005)(2501003)(11346002)(446003)(44832011)(486006)(476003)(36756003)(5660300002)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4912;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fFvD6/irDk36MlUmhZiGirNVQX+1Fw8ol8y9qJ6zFLcYLW0ToTca3ATXxjtOJx+tXMqqrjrCAgnX6qMI1ynze0Zi2/BNFOr2TeEtRNTogUyx0qPInUn1aw5mdZ2lixCf5BA1fx1V2rD+BOh2dwlZXhmrv4/fG3YMPbHGKTBBuBOg2bnIxybi8EVhu13jEtVujd/iStieVagQstld4twNzB8rG/c8XALEqkbDSJhQM4fxBem7FUrqnwvlPhJZcRGQv6VCblMw+k7SFf8J1mOjyq2K8rFSqIUc+PMzTY0SjP1RH1nOn4Rb1/TSAUz4MK5KQcBwDpgKB8B3qXgTAPST+F1HY3g/HIGZf2Sc4EWvdB9ULsdVqvSvX527xbZQA4+dt4iGuK5Or/kP/ibCPDrvJdB1L7i91d8zEvImdS8G07yTfOV9oRxqebPcHrpk2T1J
Content-Type: text/plain; charset="utf-8"
Content-ID: <975444B2A0E5ED48B1C92BF5D9BCD6C0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 566b47aa-28e5-43f4-a5d4-08d75856a3c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 07:49:03.2174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RJWJQ0W9lCl3zNMbuy+H80YzerbvQfd2U/uTC6I1gFdTF2N672LMrr1SFLEaMfty3LfCzgCyGBGU/bvetBMIUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDI0LjEwLjIwMTkgMDU6MDEsIGhjaEBsc3QuZGUgd3JvdGU6DQo+IE9uIFdlZCwgT2N0
IDIzLCAyMDE5IGF0IDExOjUzOjQxQU0gKzAwMDAsIExhdXJlbnRpdSBUdWRvciB3cm90ZToNCj4+
IFdlIGhhZCBhbiBpbnRlcm5hbCBkaXNjdXNzaW9uIG92ZXIgdGhlc2UgcG9pbnRzIHlvdSBhcmUg
cmFpc2luZyBhbmQNCj4+IE1hZGFsaW4gKGNjLWVkKSBjYW1lIHVwIHdpdGggYW5vdGhlciBpZGVh
OiBpbnN0ZWFkIG9mIGFkZGluZyB0aGlzIHByb25lDQo+PiB0byBtaXN1c2UgYXBpIGhvdyBhYm91
dCBleHBlcmltZW50aW5nIHdpdGggYSBuZXcgZG1hIHVubWFwIGFuZCBkbWEgc3luYw0KPj4gdmFy
aWFudHMgdGhhdCB3b3VsZCByZXR1cm4gdGhlIHBoeXNpY2FsIGFkZHJlc3MgYnkgY2FsbGluZyB0
aGUgbmV3bHkNCj4+IGludHJvZHVjZWQgZG1hIG1hcCBvcC4gU29tZXRoaW5nIGFsb25nIHRoZXNl
IGxpbmVzOg0KPj4gICAgKiBwaHlzX2FkZHJfdCBkbWFfdW5tYXBfcGFnZV9yZXRfcGh5cyguLi4p
DQo+PiAgICAqIHBoeXNfYWRkcl90IGRtYV91bm1hcF9zaW5nbGVfcmV0X3BoeXMoLi4uKQ0KPj4g
ICAgKiBwaHlzX2FkZHJfdCBkbWFfc3luY19zaW5nbGVfZm9yX2NwdV9yZXRfcGh5cyguLi4pDQo+
PiBJJ20gdGhpbmtpbmcgdGhhdCB0aGlzIHByb3Bvc2FsIHNob3VsZCByZWR1Y2UgdGhlIHJpc2tz
IG9wZW5lZCBieSB0aGUNCj4+IGluaXRpYWwgdmFyaWFudC4NCj4+IFBsZWFzZSBsZXQgbWUga25v
dyB3aGF0IHlvdSB0aGluay4NCj4gDQo+IEknbSBub3Qgc3VyZSB3aGF0IHRoZSByZXQgaXMgc3Vw
cG9zZWQgdG8gbWVhbiwgYnV0IEkgZ2VuZXJhbGx5IGxpa2UNCj4gdGhhdCBpZGVhIGJldHRlci4g
IA0KDQpJdCB3YXMgc3VwcG9zZWQgdG8gYmUgc2hvcnQgZm9yICJyZXR1cm4iIGJ1dCBnaXZlbiB0
aGF0IEknbSBub3QgZ29vZCBhdCANCm5hbWluZyBzdHVmZiBJJ2xsIGp1c3QgZHJvcCBpdC4NCg0K
PiBXZSBhbHNvIG5lZWQgdG8gbWFrZSBzdXJlIHRoZXJlIGlzIGFuIGVhc3kgd2F5DQo+IHRvIGZp
Z3VyZSBvdXQgaWYgdGhlc2UgQVBJcyBhcmUgYXZhaWxhYmxlLCBhcyB0aGV5IGdlbmVyYWxseSBh
cmVuJ3QNCj4gZm9yIGFueSBub24tSU9NTVUgQVBJIElPTU1VIGRyaXZlcnMuDQoNCkkgd2FzIHJl
YWxseSBob3BpbmcgdG8gbWFuYWdlIG1ha2luZyB0aGVtIGFzIGdlbmVyaWMgYXMgcG9zc2libGUg
YnV0IA0KYW55d2F5LCBJJ2xsIHN0YXJ0IHdvcmtpbmcgb24gYSBQb0MgYW5kIHNlZSBob3cgaXQg
dHVybnMgb3V0LiBUaGlzIHdpbGwgDQpwcm9iYWJseSBoYXBwZW4gc29tZXRpbWUgbmV4dCBuZXh0
IHdlZWsgYXMgdGhlIGZvbGxvd2luZyB3ZWVrIEknbGwgYmUgDQp0cmF2ZWxpbmcgdG8gYSBjb25m
ZXJlbmNlLg0KDQotLS0NCkJlc3QgUmVnYXJkcywgTGF1cmVudGl1
