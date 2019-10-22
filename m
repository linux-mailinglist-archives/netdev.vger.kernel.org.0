Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEB1E058D
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388877AbfJVNxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 09:53:19 -0400
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:5505
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388381AbfJVNxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 09:53:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1iEa92jK11eBqyfPTKYIWi1gLy0Q905sw/XOc9HglLVtatYM28rVlcD0XIc+XoRWEzcUadDK+i2qfsFE2HTgbSZlAhzd72mG0N+GSRDWJg7olMKzce/HU4PtdKK1EbP5S11TtBrRe8VnB7dGE4kI1XI3VLIqSl7uhXRrB7O4xDAy7/lCRsHT3nfmrdb12Cbthj9EW5bt15AifBZT5E+8aLW/M+sXKJ1eSHJWxk1Lo0a8bJ0NVI9dJ4aSL0xRhXTtr5reovtu2IiqYolPxmurshbIvhblyP/2LtrKeUYj1npD2xuck5z5HDJ/eByDoTsCHLP1wZtqJgTvJrbEBmY9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XTB2jDj7bStRalMMzlBYlIlAXfKMzK9REcCMf2o7Rg=;
 b=dIHvCx5L9WV0uKO5kx5HBxgtcxzRW+NC4cZ/7Q2kDHlH88WRDVphjpcsVqXU/14vSjwaDsS8RoDQosz6ZZD4iJfWL8jAyyKE7VRttTyu8DnvtnHQ53qffqJc7NsVh6PT3ceLNKlQQt1HJsnGJbojQxo3yD7xgOneHEYtrQ+n7+JL5qpd/PbZxM+EQECMPZEEhJgo7nJdBdp86f7wpLJpMDtiLqwyJW3x12Eth/TS7zJPjmH45fyk+6rO0Yu7UjVcpTtM1s7LeiK+YOFViYd3nUuMx8quQT8/28aOZd4RgNlPm+qwR4du4D6DpXGLNipAvIOv6hb0QmokNAszQSmG4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XTB2jDj7bStRalMMzlBYlIlAXfKMzK9REcCMf2o7Rg=;
 b=MHuP48StKB9i33JI2+uwgaypCSMVrGTBWsz1OHu3CUQ29AMBDUuvd0Q5y6CD5hrh6HYdtr6uPDDbuuc3dhUWFFVxedscUqVGDZ65isTdYIuGT/+NnJ2d4bGp6rWL7wgKsjacFXuoIRBDsj8/Raqm0ME9a8iGAKRppmVTVqhB2Yg=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB5005.eurprd04.prod.outlook.com (20.177.49.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 22 Oct 2019 13:53:14 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 13:53:14 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     Robin Murphy <robin.murphy@arm.com>, "hch@lst.de" <hch@lst.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     Leo Li <leoyang.li@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>
Subject: Re: [RFC PATCH 1/3] dma-mapping: introduce a new dma api
 dma_addr_to_phys_addr()
Thread-Topic: [RFC PATCH 1/3] dma-mapping: introduce a new dma api
 dma_addr_to_phys_addr()
Thread-Index: AQHViNfyo/IzAF7o50+e1U9qS9i5xadmpruAgAAHrIA=
Date:   Tue, 22 Oct 2019 13:53:14 +0000
Message-ID: <ab195e02-e7d5-2ca2-9fe0-f2175faf0072@nxp.com>
References: <20191022125502.12495-1-laurentiu.tudor@nxp.com>
 <20191022125502.12495-2-laurentiu.tudor@nxp.com>
 <62561dca-cdd7-fe01-a0c3-7b5971c96e7e@arm.com>
In-Reply-To: <62561dca-cdd7-fe01-a0c3-7b5971c96e7e@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cd1b7fa6-dee9-4c3b-17c0-08d756f72f4f
x-ms-traffictypediagnostic: VI1PR04MB5005:|VI1PR04MB5005:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB50059A0BE0847CA834F9DE9EEC680@VI1PR04MB5005.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(189003)(199004)(8676002)(2616005)(102836004)(110136005)(11346002)(6246003)(2201001)(54906003)(6512007)(8936002)(4326008)(14454004)(6636002)(71200400001)(71190400001)(81156014)(81166006)(25786009)(486006)(561944003)(476003)(256004)(478600001)(31686004)(6486002)(186003)(26005)(446003)(66946007)(86362001)(31696002)(229853002)(5660300002)(3846002)(36756003)(7736002)(66446008)(99286004)(66476007)(91956017)(66556008)(6116002)(305945005)(2501003)(66066001)(316002)(76176011)(76116006)(53546011)(64756008)(6506007)(6436002)(44832011)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5005;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K0MTenO+MNAb+xQQiYBVB4uxNSmXG+TUiznNRfSuW7GCQ59Q+W+7GCBXLB8WSvq/xQxDuYXv7uGXCbQ8T+xJt0/khWrXDwQMDmS830RSDbOJ+bxPaWNBj6b7ZzKuHNO7bX+jvMNyKvD2TkGmQheYJyS7jzcoVxwpCgfZlvb5P4dSyIZxSFjgEYSE6isj4Mt7Pan3Wx3xUOrFHFA9pF60dEUhDo421LFfW7pHQO60l05bzqNp+JtidbSQX19o9p8NUrh8TnSdMFGWtBcTdxJCkdAo5JaoMvwS9Cf/mDvO8jrA94hq+nM7muBvay1S90b+MepRdriYS2HnaoTFDdUrFjdqqyypaqeYpUFaLJltP+X6hkj7hOjBLs+Nhy5iEj+gRXgPc0ExXzrRWdc3DnJqi9TrIylC6IAxER96ZLGIudc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <037C736D50287E4994EC930D45F1AC02@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd1b7fa6-dee9-4c3b-17c0-08d756f72f4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 13:53:14.5388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9X3QIVq3w+H9zWvcohL/uAVovplXOm7LdqbwG7JAe8pFUugXIgXDh4wpyyRP81cBIJx7c+HVrQXXW1piFP/mww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5005
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyMi4xMC4yMDE5IDE2OjI1LCBSb2JpbiBNdXJwaHkgd3JvdGU6DQo+IE9uIDIyLzEwLzIw
MTkgMTM6NTUsIExhdXJlbnRpdSBUdWRvciB3cm90ZToNCj4+IEZyb206IExhdXJlbnRpdSBUdWRv
ciA8bGF1cmVudGl1LnR1ZG9yQG54cC5jb20+DQo+Pg0KPj4gSW50cm9kdWNlIGEgbmV3IGRtYSBt
YXAgb3AgY2FsbGVkIGRtYV9hZGRyX3RvX3BoeXNfYWRkcigpIHRoYXQgY29udmVydHMNCj4+IGEg
ZG1hIGFkZHJlc3MgdG8gdGhlIHBoeXNpY2FsIGFkZHJlc3MgYmFja2luZyBpdCB1cCBhbmQgYWRk
IHdyYXBwZXIgZm9yDQo+PiBpdC4NCj4gDQo+IEknZCByZWFsbHkgbG92ZSBpdCBpZiB0aGVyZSB3
YXMgYSBuYW1lIHdoaWNoIGNvdWxkIGVuY2Fwc3VsYXRlIHRoYXQgdGhpcyANCj4gaXMgKm9ubHkq
IGZvciBleHRyZW1lIHNwZWNpYWwgY2FzZXMgb2YgY29uc3RyYWluZWQgZGVzY3JpcHRvcnMvcGFn
ZXRhYmxlIA0KPiBlbnRyaWVzL2V0Yy4gd2hlcmUgdGhlcmUncyBzaW1wbHkgbm8gcHJhY3RpY2Fs
IHdheSB0byBrZWVwIHRyYWNrIG9mIGEgDQo+IENQVSBhZGRyZXNzIGFsb25nc2lkZSB0aGUgRE1B
IGFkZHJlc3MsIGFuZCB0aGUgb25seSBvcHRpb24gaXMgdGhpcyANCj4gcG90ZW50aWFsbHktYXJi
aXRyYXJpbHktY29tcGxleCBvcGVyYXRpb24gKEkgbWVhbiwgb24gc29tZSBzeXN0ZW1zIGl0IA0K
PiBtYXkgZW5kIHVwIHRha2luZyBsb2NrcyBhbmQgcG9raW5nIGhhcmR3YXJlKS4NCj4gDQo+IEVp
dGhlciB3YXkgaXQncyB0cmlja3kgLSBtdWNoIGFzIEkgZG9uJ3QgbGlrZSBhZGRpbmcgYW4gaW50
ZXJmYWNlIHdoaWNoIA0KPiBpcyByaXBlIGZvciBkcml2ZXJzIHRvIG1pc3VzZSwgSSBhbHNvIHJl
YWxseSBkb24ndCB3YW50IGhhY2tzIGxpa2UgDQo+IGJkZjk1OTIzMDg2ZiBzaG92ZWQgaW50byBv
dGhlciBBUElzIHRvIGNvbXBlbnNhdGUsIHNvIG9uIGJhbGFuY2UgSSdkIA0KPiBwcm9iYWJseSBj
b25zaWRlciB0aGlzIHByb3Bvc2FsIGV2ZXIgc28gc2xpZ2h0bHkgdGhlIGxlc3NlciBldmlsLg0K
PiANCj4+IFNpZ25lZC1vZmYtYnk6IExhdXJlbnRpdSBUdWRvciA8bGF1cmVudGl1LnR1ZG9yQG54
cC5jb20+DQo+PiAtLS0NCj4+IMKgIGluY2x1ZGUvbGludXgvZG1hLW1hcHBpbmcuaCB8IDIxICsr
KysrKysrKysrKysrKysrKysrKw0KPj4gwqAgMSBmaWxlIGNoYW5nZWQsIDIxIGluc2VydGlvbnMo
KykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9kbWEtbWFwcGluZy5oIGIvaW5j
bHVkZS9saW51eC9kbWEtbWFwcGluZy5oDQo+PiBpbmRleCA0YTFjNGZjYTQ3NWEuLjU5NjVkMTU5
YzlhOSAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvbGludXgvZG1hLW1hcHBpbmcuaA0KPj4gKysr
IGIvaW5jbHVkZS9saW51eC9kbWEtbWFwcGluZy5oDQo+PiBAQCAtMTMyLDYgKzEzMiw4IEBAIHN0
cnVjdCBkbWFfbWFwX29wcyB7DQo+PiDCoMKgwqDCoMKgIHU2NCAoKmdldF9yZXF1aXJlZF9tYXNr
KShzdHJ1Y3QgZGV2aWNlICpkZXYpOw0KPj4gwqDCoMKgwqDCoCBzaXplX3QgKCptYXhfbWFwcGlu
Z19zaXplKShzdHJ1Y3QgZGV2aWNlICpkZXYpOw0KPj4gwqDCoMKgwqDCoCB1bnNpZ25lZCBsb25n
ICgqZ2V0X21lcmdlX2JvdW5kYXJ5KShzdHJ1Y3QgZGV2aWNlICpkZXYpOw0KPj4gK8KgwqDCoCBw
aHlzX2FkZHJfdCAoKmRtYV9hZGRyX3RvX3BoeXNfYWRkcikoc3RydWN0IGRldmljZSAqZGV2LA0K
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkbWFf
YWRkcl90IGRtYV9oYW5kbGUpOw0KPiANCj4gSSdkIGJlIGluY2xpbmVkIHRvIG5hbWUgdGhlIGlu
dGVybmFsIGNhbGxiYWNrIHNvbWV0aGluZyBhIGJpdCBzbmFwcGllciANCj4gbGlrZSAuZ2V0X3Bo
eXNfYWRkci4NCg0KQWxyaWdodC4gV2FudCBtZSB0byBhbHNvIHJlbmFtZSB0aGUgd3JhcHBlciB0
byBzb21ldGhpbmcgbGlrZSANCmRtYV9nZXRfcGh5c19hZGRyKCk/IFNvdW5kcyBhIGJpdCBuaWNl
ciB0byBtZS4NCg0KPj4gwqAgfTsNCj4+IMKgICNkZWZpbmUgRE1BX01BUFBJTkdfRVJST1LCoMKg
wqDCoMKgwqDCoCAofihkbWFfYWRkcl90KTApDQo+PiBAQCAtNDQyLDYgKzQ0NCwxOSBAQCBzdGF0
aWMgaW5saW5lIGludCBkbWFfbWFwcGluZ19lcnJvcihzdHJ1Y3QgZGV2aWNlIA0KPj4gKmRldiwg
ZG1hX2FkZHJfdCBkbWFfYWRkcikNCj4+IMKgwqDCoMKgwqAgcmV0dXJuIDA7DQo+PiDCoCB9DQo+
PiArc3RhdGljIGlubGluZSBwaHlzX2FkZHJfdCBkbWFfYWRkcl90b19waHlzX2FkZHIoc3RydWN0
IGRldmljZSAqZGV2LA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgZG1hX2FkZHJfdCBkbWFfaGFuZGxlKQ0KPj4gK3sNCj4+ICvCoMKgwqAgY29uc3Qg
c3RydWN0IGRtYV9tYXBfb3BzICpvcHMgPSBnZXRfZG1hX29wcyhkZXYpOw0KPj4gKw0KPj4gK8Kg
wqDCoCBpZiAoZG1hX2lzX2RpcmVjdChvcHMpKQ0KPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiAo
cGh5c19hZGRyX3QpZG1hX2hhbmRsZTsNCj4gDQo+IFdlbGwgdGhhdCdzIG5vdCByaWdodCwgaXMg
aXQgLSByZW1lbWJlciB3aHkgeW91IGhhZCB0aGF0IG5hbWVzcGFjZSANCj4gY29sbGlzaW9uPyA7
KQ0KPiANCg0KVWdoLCBjb3JyZWN0LiBEb24ndCBrbm93IHdoYXQgSSB3YXMgdGhpbmtpbmcuIFdp
bGwgcmV3b3JrIHRoZSBjaGVjay4NCg0KLS0tDQpUaGFua3MgJiBCZXN0IFJlZ2FyZHMsIExhdXJl
bnRpdQ==
