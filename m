Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04133F14D6
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 12:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731466AbfKFLSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 06:18:42 -0500
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:39582
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725890AbfKFLSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 06:18:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+WQV49wqDTkBCpHccgc15RrHGs2AqmFbOwfvB0nHDBYG+4wxY3uyc/W11xJ4pIUaj7a+kcmPD3oBawW/FNDvE5SF81R97/wJBfeBGeFC75Z6pYhGnQmkbVYQpOraliHwifPUf2PP/li2JITEv1omMw2NCb28eyrF0w/xkhYRRrrbIlL98B+IkC2jz1V7IkkoEDCIT9K39FPZIT9dMqTD9l0fuNAzz26/br0thmkez+Fr2BNpIo1+EeE0BdH5EpOiOTI0XImHO49ynhlpHWB5MgbUpuWO4NHwcvLm98UYp/TSLhNHfVQ1WHEYe5O6qlOIxFLuVF9A+++QcjSiJtvGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xORQp9rJxfWywzdeoxfH2dD41fhMmfUkr/fTR1zeNBw=;
 b=LNvrSr0uX28rQLdRN0mTOdWIMJ7XV3G/uAwgT54XytRd71P9mvqsvEhxUi07GS5e7ah/XVXVqJuG6bo7hRCywnRobCvUOSCbnk1yGS7IFmQ1fP9wC0UhaQScg2EPCJV3K4WG+U9D/RHN/ATHGx0aO//A5GIf15diT88drr/WJMNFVjNOjge1Laa/JHR+WLSp6J4DeE7QvenN9QDuQcMsQiktsqKM3j+8LI370Qq62yQtwdJ0aCHQ0gXY8KUguzeX7b8MiI6JvGq6BsbBKzB8MeF0p+eZV93RZ7HoAc4DIrR9TsN2p3LtuE7lZAueBhND7h7NHFJCq5G6Ouf8XkF4/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xORQp9rJxfWywzdeoxfH2dD41fhMmfUkr/fTR1zeNBw=;
 b=DI7xPu6YADDit3uE96/yPdx+Atd/gyhLy8D0+I0F8VCJPt6AJ7F1G5KVo0q8/7V2lHSKlo16XGYbARAHu+7Xm6pyoaX569tNb5jWzmCCjdlFIZ8P82SUsi6vXV+sDVHsJ50OAPSbV05WpIaYVD4BWIxMkfCkREh+BrYmIokanXY=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB5182.eurprd04.prod.outlook.com (20.177.48.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Wed, 6 Nov 2019 11:17:58 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 11:17:58 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     "hch@lst.de" <hch@lst.de>
CC:     Jonathan Lemon <jlemon@flugsvamp.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: Re: [PATCH v2 3/3] dpaa2_eth: use new unmap and sync dma api variants
Thread-Topic: [PATCH v2 3/3] dpaa2_eth: use new unmap and sync dma api
 variants
Thread-Index: AQHVimhlfWE0TvO4OUun0YFZridDXqdriR2AgAReYACAAAwSAIAOH06A
Date:   Wed, 6 Nov 2019 11:17:58 +0000
Message-ID: <ffd585c3-3808-5083-ec98-bc2fc44d34ef@nxp.com>
References: <20191024124130.16871-1-laurentiu.tudor@nxp.com>
 <20191024124130.16871-4-laurentiu.tudor@nxp.com>
 <BC2F1623-D8A5-4A6E-BAF4-5C551637E472@flugsvamp.com>
 <00a138f0-3651-5441-7241-5f02956b6c2c@nxp.com>
 <20191028113816.GB24055@lst.de>
In-Reply-To: <20191028113816.GB24055@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bb78f0bf-8f25-4168-7b1d-08d762aafabe
x-ms-traffictypediagnostic: VI1PR04MB5182:|VI1PR04MB5182:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5182B0CA2FDD91F374B3F730EC790@VI1PR04MB5182.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(199004)(189003)(305945005)(6506007)(99286004)(31696002)(229853002)(7736002)(76176011)(2351001)(26005)(36756003)(66066001)(6916009)(256004)(71200400001)(186003)(478600001)(81166006)(8676002)(86362001)(81156014)(102836004)(66556008)(66946007)(14454004)(91956017)(64756008)(66476007)(66446008)(76116006)(5660300002)(11346002)(6116002)(44832011)(53546011)(25786009)(1730700003)(316002)(8936002)(71190400001)(2906002)(6512007)(6246003)(3846002)(2501003)(31686004)(4326008)(6436002)(5640700003)(54906003)(6486002)(486006)(476003)(2616005)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5182;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SbunjZl5129XMlk7NFADg1gTI6SftWBMRyfxFSzhVoT6sNoa7sMwf/qcGAj5Dzcrnjg2HRRRc0S44oPcXLa9fxUvrVgL8OYTUglk+bf6MAf0QrR+LdBSnwkG17CArfEk7auiO8uLTvIwAaozwTZqHNQp+Dp5wuGiCpyqxw8UTQ6Z6lE+i86aS71SW0nHaH5dgINmAEywUqljodUCAqms3tUhu8vQeXGCqxZIHBjuOwPX2RSfRWY6V+kx2ZWUNnAdE0a4kEkJdK5aW3x2PxsMRDwTR4Wxfwpi2MINlhlt6l2efpBHHn2TQKtmPE8Uwa/aj58u9S6pPQTrgk35KtFY+ewn3UEpszsyRlv4SL/KZsbX7b2bLKJcpiMU0pVy9oUzmkzd7mjpGg4Pcd0lc5JvYEWkULOq3KHGVp/VSO0UUVat8U0Kt0O/5g7lyouWDZZr
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB7D6165312DE04EAFA8D8B259DDBB0E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb78f0bf-8f25-4168-7b1d-08d762aafabe
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 11:17:58.6234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KD1nTC9oY4brBCEB5rnLvqiF8X/1/iA40Z5ThfSDNnoC6oejQDL1WCIF2nWerZwUZ3bBnX+ewJakQubT1+7CtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5182
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyOC4xMC4yMDE5IDEzOjM4LCBoY2hAbHN0LmRlIHdyb3RlOg0KPiBPbiBNb24sIE9jdCAy
OCwgMjAxOSBhdCAxMDo1NTowNUFNICswMDAwLCBMYXVyZW50aXUgVHVkb3Igd3JvdGU6DQo+Pj4+
IEBAIC04NSw5ICs3NSwxMCBAQCBzdGF0aWMgdm9pZCBmcmVlX3J4X2ZkKHN0cnVjdCBkcGFhMl9l
dGhfcHJpdiAqcHJpdiwNCj4+Pj4gIMKgwqDCoMKgIHNndCA9IHZhZGRyICsgZHBhYTJfZmRfZ2V0
X29mZnNldChmZCk7DQo+Pj4+ICDCoMKgwqDCoCBmb3IgKGkgPSAxOyBpIDwgRFBBQTJfRVRIX01B
WF9TR19FTlRSSUVTOyBpKyspIHsNCj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqAgYWRkciA9IGRwYWEy
X3NnX2dldF9hZGRyKCZzZ3RbaV0pOw0KPj4+PiAtwqDCoMKgwqDCoMKgwqAgc2dfdmFkZHIgPSBk
cGFhMl9pb3ZhX3RvX3ZpcnQocHJpdi0+aW9tbXVfZG9tYWluLCBhZGRyKTsNCj4+Pj4gLcKgwqDC
oMKgwqDCoMKgIGRtYV91bm1hcF9wYWdlKGRldiwgYWRkciwgRFBBQTJfRVRIX1JYX0JVRl9TSVpF
LA0KPj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIERNQV9CSURJUkVD
VElPTkFMKTsNCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHNnX3ZhZGRyID0gcGFnZV90b192aXJ0DQo+
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKGRtYV91bm1hcF9wYWdlX2Rlc2Mo
ZGV2LCBhZGRyLA0KPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIERQQUEyX0VUSF9SWF9CVUZfU0laRSwNCj4+Pj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBETUFfQklESVJFQ1RJ
T05BTCkpOw0KPj4+DQo+Pj4gVGhpcyBpcyBkb2luZyB2aXJ0IC0+IHBhZ2UgLT4gdmlydC7CoCBX
aHkgbm90IGp1c3QgaGF2ZSB0aGUgbmV3DQo+Pj4gZnVuY3Rpb24gcmV0dXJuIHRoZSBWQSBjb3Jy
ZXNwb25kaW5nIHRvIHRoZSBhZGRyLCB3aGljaCB3b3VsZA0KPj4+IG1hdGNoIHRoZSBvdGhlciBm
dW5jdGlvbnM/DQo+Pg0KPj4gSSdkIHJlYWxseSBsaWtlIHRoYXQgYXMgaXQgd291bGQgZ2V0IHJp
ZCBvZiB0aGUgcGFnZV90b192aXJ0KCkgY2FsbHMgYnV0DQo+PiBpdCB3aWxsIGJyZWFrIHRoZSBz
eW1tZXRyeSB3aXRoIHRoZSBkbWFfbWFwX3BhZ2UoKSBBUEkuIEknbGwgbGV0IHRoZQ0KPj4gbWFp
bnRhaW5lcnMgZGVjaWRlLg0KPiANCj4gSXQgd291bGQgYmUgc3ltbWV0cmljIHdpdGggZG1hX21h
cF9zaW5nbGUsIHRob3VnaC4gIE1heWJlIHdlIG5lZWQNCj4gYm90aCB2YXJpYW50cz8NCg0KUGF0
Y2ggMS8zIGFsc28gYWRkcyBhbiBkbWFfdW5tYXBfc2luZ2xlX2Rlc2MoKS4gV291bGQgaXQgYmUg
bGVnYWwgdG8gDQpqdXN0IHVzZSBkbWFfdW5tYXBfc2luZ2xlX2Rlc2MoKSBpbiB0aGUgZHJpdmVy
IGV2ZW4gaWYgdGhlIGRyaXZlciBkb2VzIA0KaXQncyBtYXBwaW5ncyB3aXRoIGRtYV9tYXBfcGFn
ZSgpPw0KDQotLS0NCkJlc3QgUmVnYXJkcywgTGF1cmVudGl1
