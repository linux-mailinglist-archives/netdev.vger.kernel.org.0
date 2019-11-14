Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B967DFC520
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 12:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKNLNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 06:13:31 -0500
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:18550
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726057AbfKNLNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 06:13:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8OaCBtaBFwzEpWwQDtVIMwjndFEWIOJ065ZmqntKJuTl4SACL9hAcfeOCmWTqYUKQlit0jivqmF1zk8pv8Eb9X8SAt0oVr89hihHPJ7fFy1CuyKAqPn6Kszmfg6lhVMUDfS1QYeh7hyecBReZRsK+TLEVru+oMlemPJ59HoO5sLqpUxnfrfgj1mLb9A2i33p4r7G6xaKT3yyrys1OWS+RppOM9/Ljlon7fj+b9SOerZQQBLnzHxSvDV6PVqlzBKkvkppWpou2hHWvp2+o7W8ca5enzbJA7CSKghw9Dt9k4pPihrL50XX+hPi34OTfADULEl4Of76bvNOjDgiKhtZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYAjsatHdLHoWo+HEJtZ5yEtn6oTV/EkAwmp9sfTxTI=;
 b=E/Pr0a6pGwMNWaqhAsD9tGuB74Yom19QsUGCOQ70SeU/ELXUiJxbRGTVe2zw6m6eIDN7OCF27CFbA4NQeqa1mX1ElkBKYNHQnNC5ff+mqmnzbW/YU+oaZzH6sPus9hsCxToCl3B+eA8110uy6B3htk4JZKnCxCji74c78go6O/n/73XHpoltA5Z84X8xpJAPhKzkL6lOx9glZcfaRAstk9yAfoi8FyL5/Y32rHXuqD8EdAmh2NZvItLwmi4NB9eCKgBqHTVmmZwVmLI4LrhrgEULdoaE+HnToxvKjkEC3X2zBzl1d8BAnybHpQDNSN1LV5oXgB5xpU+EYlYHwF5x5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYAjsatHdLHoWo+HEJtZ5yEtn6oTV/EkAwmp9sfTxTI=;
 b=PMUtKvwooBamQ1NFZXq/hE4DhfCeEp7fk7gUyVGcIBM0kqBiVjNTnI3nzNk3ZxzMfyXLHvkpjU8ERxE5s8j9LykPokivuQELDbIht6K+JrF3RQdMxVNolSyxrEjuOSW6RYgphP0DpxBlbl5PjukVGwzgs8VgOWAd9XtTAUPRsEw=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB6176.eurprd04.prod.outlook.com (20.179.25.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 11:13:28 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::71d2:55b3:810d:c75b]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::71d2:55b3:810d:c75b%7]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 11:13:28 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>
Subject: Re: [PATCH v3 0/4] dma-mapping: introduce new dma unmap and sync
 variants
Thread-Topic: [PATCH v3 0/4] dma-mapping: introduce new dma unmap and sync
 variants
Thread-Index: AQHVmh1EAM9HSxnkaEm+5zOWq0YV/qeJiNoAgAD7/oA=
Date:   Thu, 14 Nov 2019 11:13:28 +0000
Message-ID: <81b6e75b-a827-32e2-77bd-50220ddd66cc@nxp.com>
References: <20191113122407.1171-1-laurentiu.tudor@nxp.com>
 <20191113.121132.1658930697082028145.davem@davemloft.net>
In-Reply-To: <20191113.121132.1658930697082028145.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 404e478a-56bb-4132-4791-08d768f3ace7
x-ms-traffictypediagnostic: VI1PR04MB6176:|VI1PR04MB6176:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB617685810398D719E2E9141AEC710@VI1PR04MB6176.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(136003)(346002)(39860400002)(396003)(199004)(189003)(86362001)(102836004)(486006)(76116006)(305945005)(26005)(44832011)(76176011)(6506007)(186003)(446003)(11346002)(5660300002)(478600001)(66556008)(3846002)(64756008)(66476007)(6116002)(53546011)(7736002)(66946007)(66446008)(316002)(31696002)(8676002)(81156014)(81166006)(14454004)(2906002)(54906003)(6246003)(4326008)(36756003)(476003)(91956017)(25786009)(6436002)(31686004)(6512007)(2616005)(8936002)(71190400001)(71200400001)(256004)(99286004)(14444005)(66066001)(6916009)(6486002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6176;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kIeeJyVS/rjDoiaMrxeG9to0pexVVIYc8uBmpYCK1nN1TVQ1IdntSH+HPNz4gPkId74ZpF72Qw/bF9CZNqCpAaqwnmREgX8F2sSGlkOtkmmB8fTD0b1ZYlsM08BS3vMMH56aq+MlblijRDubZ2gCQnmss86z3yM5Gc4uM/3q2XMw0/mbUHskVS6VBQZaJ1vysisle1u3VKJi1AFxlHJw96jx3Ra0NRnZctBa3NWCQEm06eJVJ8YB3VeBHnH/J+aqxQmQSstets7BAgr6JSZjHxDniSvB7i5LE1XBhQjHux4oLwiODP7zXlQse/83WwJZfRzREU89lxgzIzmZOE6bynBHR2Ekh54cqaIUrpVr/dF1KkX0Qeo+GTVJrZvOhJemHwk8fggMJjioAxqnclN/E0j46JJ9NlhqAUj73Cfg5p4JVk/BEfbwW2Flmr4gq1ar
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BF3621345F8844FA6A5E2E8A59180E8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 404e478a-56bb-4132-4791-08d768f3ace7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 11:13:28.2046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kBnEN1YX8sPA+ogMn96GIe/r7YVcns/EfzObrXNCDID3sGuKlPml1h4Wi2cg6msE/fBWid4r4trIIuXsBSqcCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTMuMTEuMjAxOSAyMjoxMSwgRGF2aWQgTWlsbGVyIHdyb3RlOg0KPiBGcm9tOiBMYXVyZW50
aXUgVHVkb3IgPGxhdXJlbnRpdS50dWRvckBueHAuY29tPg0KPiBEYXRlOiBXZWQsIDEzIE5vdiAy
MDE5IDEyOjI0OjE3ICswMDAwDQo+IA0KPj4gRnJvbTogTGF1cmVudGl1IFR1ZG9yIDxsYXVyZW50
aXUudHVkb3JAbnhwLmNvbT4NCj4+DQo+PiBUaGlzIHNlcmllcyBpbnRyb2R1Y2VzIGEgZmV3IG5l
dyBkbWEgdW5tYXAgYW5kIHN5bmMgYXBpIHZhcmlhbnRzIHRoYXQsDQo+PiBvbiB0b3Agb2Ygd2hh
dCB0aGUgb3JpZ2luYWxzIGRvLCByZXR1cm4gdGhlIHZpcnR1YWwgYWRkcmVzcw0KPj4gY29ycmVz
cG9uZGluZyB0byB0aGUgaW5wdXQgZG1hIGFkZHJlc3MuIEluIG9yZGVyIHRvIGRvIHRoYXQgYSBu
ZXcgZG1hDQo+PiBtYXAgb3AgaXMgYWRkZWQsIC5nZXRfdmlydF9hZGRyIHRoYXQgdGFrZXMgdGhl
IGlucHV0IGRtYSBhZGRyZXNzIGFuZA0KPj4gcmV0dXJucyB0aGUgdmlydHVhbCBhZGRyZXNzIGJh
Y2tpbmcgaXQgdXAuDQo+PiBUaGUgc2Vjb25kIHBhdGNoIGFkZHMgYW4gaW1wbGVtZW50YXRpb24g
Zm9yIHRoaXMgbmV3IGRtYSBtYXAgb3AgaW4gdGhlDQo+PiBnZW5lcmljIGlvbW11IGRtYSBnbHVl
IGNvZGUgYW5kIHdpcmVzIGl0IGluLg0KPj4gVGhlIHRoaXJkIHBhdGNoIHVwZGF0ZXMgdGhlIGRw
YWEyLWV0aCBkcml2ZXIgdG8gdXNlIHRoZSBuZXcgYXBpcy4NCj4gDQo+IFRoZSBkcml2ZXIgc2hv
dWxkIHN0b3JlIHRoZSBtYXBwaW5nIGluIGl0J3MgcHJpdmF0ZSBzb2Z0d2FyZSBzdGF0ZSBpZg0K
PiBpdCBuZWVkcyB0aGlzIGtpbmQgb2YgY29udmVyc2lvbi4NCg0KT24gdGhpcyBoYXJkd2FyZSB0
aGVyZSdzIG5vIHdheSBvZiBjb252ZXlpbmcgYWRkaXRpb25hbCBmcmFtZSANCmluZm9ybWF0aW9u
LCBzdWNoIGFzIG9yaWdpbmFsIHZhL3BhIGJlaGluZCB0aGUgZG1hIGFkZHJlc3MuIFdlIGhhdmUg
YWxzbyANCnBvbmRlcmVkIG9uIHRoZSBpZGVhIG9mIGtlZXBpbmcgdGhpcyBpbiBzb21lIGtpbmQg
b2YgZGF0YSBzdHJ1Y3R1cmUgYnV0IA0KY291bGQgbm90IGZpbmQgYSBsb2NrLWxlc3Mgc29sdXRp
b24gd2hpY2ggb2J2aW91c2x5IHdvdWxkIGJyaW5nIA0KcGVyZm9ybWFuY2UgdG8gdGhlIGdyb3Vu
ZC4NCkknbGwgbGV0IG15IGNvbGxlYWd1ZXMgbWFpbnRhaW5pbmcgdGhlc2UgZXRoZXJuZXQgZHJp
dmVycyB0byBnZXQgaW50byANCm1vcmUgZGV0YWlscywgaWYgcmVxdWlyZWQuDQoNCi0tLQ0KQmVz
dCBSZWdhcmRzLCBMYXVyZW50aXU=
