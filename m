Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B419143BB2
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 12:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgAULJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 06:09:44 -0500
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:9486
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728682AbgAULJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 06:09:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRK2YYheXLHyiMZc4fbBiotvxyRgjdCPOGrGXrLhka5XPGVRIeULqIs1EjyJLmpuV3SFr/jt1kLZ3H5+QmhIFELurr+Smn9QZpGhd+RNbVxF29lSO2w5jjeDnKzUpTkmd17/MCadq7AXOR/sYZLwWx2owO3w2Q5WSEDrWCUX9wU/QA5XNWnIAZ4+HzFON1yv1JLvuh39314TLvSvVMzFsTVRM9n+uHCp3510+TbODl7KjbYbKgIhFjWF5s2Qbun6WhUlZAxoUcVj1tIXYURrP02iAnHr91dVp8dnf2tu1MlUHa5AWvk16S6l6g+yATDOhFg+IDggvO24l7C0VrERQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=neth5gLM83BZv/fNkBNYM4JVn29F2kOnzF5Ddr4vBbU=;
 b=V+5MlPefQ/wOt9CaAtNasBrZ+HCU6pgVTpapzL89z+dVqy0bw/S+L2vIdIfU3oJe1kndimLsh+LNQCnP3WTOnBuyWOhd6XaE/xMCEExwhSN/HfsPPtZ4Tzte0QPFds6p83sNDDpddmVLQRJ8vbKv+i5RmuProW9yTNxf0bnF1v/iWIWepIKhPkTy5Nekf2PMsIQn7opXpKp4rE7BncVRWrlDpU2Q9quneOIH+ptbNo5prl+061FiwxiNVDE/UKJ+ljnujUBF3kPKOvMf0eG66IJBcQmelYH1TZi+kZop8vXg93ysbaZ9KTG+40WnwoVHKotocp+p85NfQmcGiocfag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=neth5gLM83BZv/fNkBNYM4JVn29F2kOnzF5Ddr4vBbU=;
 b=V3JfRHvY7TI0uBnxBZ4gg7imM5RCquY4lrp5/Iws2llcrfSnEeVFeLGxdOi9vLaqvzGRGFz5+OQZ2wlggZjONdC85xa5QR/PVHVSY4Gma/zEXIDVe0lG5PITmydsp/iggEzcEGvGK2eiAbrfYz9udf8EQcGnxeEn1r/MESal9Es=
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com (52.133.45.150) by
 AM0PR0502MB3858.eurprd05.prod.outlook.com (52.133.48.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Tue, 21 Jan 2020 11:09:38 +0000
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb]) by AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb%7]) with mapi id 15.20.2644.026; Tue, 21 Jan 2020
 11:09:38 +0000
From:   Shahaf Shuler <shahafs@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        Rob Miller <rob.miller@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>, Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: RE: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Topic: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Index: AQHVzGqTFJN2iC19r0STv/0Uj4sDPafuxkEAgAAbnwCAAAWygIACyO6wgAGSJ4CAAJh8gIAAqsyAgAAds4CAACVEAIAABDeAgAAFhICAACp/MA==
Date:   Tue, 21 Jan 2020 11:09:38 +0000
Message-ID: <AM0PR0502MB37956A8D6690B190EEA713A5C30D0@AM0PR0502MB3795.eurprd05.prod.outlook.com>
References: <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
 <2a324cec-2863-58f4-c58a-2414ee32c930@redhat.com>
 <20200121004047-mutt-send-email-mst@kernel.org>
 <b9ad744e-c4cd-82f9-f56a-1ecc185e9cd7@redhat.com>
 <20200121031506-mutt-send-email-mst@kernel.org>
 <028ed448-a948-79d9-f224-c325029b17ab@redhat.com>
In-Reply-To: <028ed448-a948-79d9-f224-c325029b17ab@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shahafs@mellanox.com; 
x-originating-ip: [31.154.10.105]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f1bcbfc4-ac8e-4113-cd06-08d79e626811
x-ms-traffictypediagnostic: AM0PR0502MB3858:|AM0PR0502MB3858:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB38583E2177221B0D32C070D0C30D0@AM0PR0502MB3858.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(189003)(199004)(186003)(8676002)(26005)(33656002)(9686003)(8936002)(478600001)(81156014)(76116006)(81166006)(6506007)(55016002)(2906002)(86362001)(4326008)(54906003)(7696005)(71200400001)(5660300002)(52536014)(7416002)(316002)(110136005)(64756008)(66556008)(66946007)(66476007)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB3858;H:AM0PR0502MB3795.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wxk2lC8hsqJRGoiMqMyPF1xMvF4gopGBaMw0/fqJIyb0EwJ+bHUvKF1NawwZaYcsKwoMIGKGdLiXdeDEmup2kThm8xEShEL9E9sg4qa/RFK2mhaIwRQFgVtfgAxlk2al9ACnUXvX8VP8hIZsj9hAG0Kz9G+JrlFXee4m7tIPK9Ce5muYWN3APDUe/MQMF4o2t1WEwmk03L78+7JEC0SOWvU9lNufwwcIOVA0MBdmh/4QEd+O+dG/amw8G7F76YPzGdG1v8VUofLpUSpWqt/4JnrCZ/IRDh+LABfs6bs2PvpXqfWBMlH7H4qHEtIcQIfhb5bGtWEvTxfC5f2XXCEni+MwiFSaGraPoFIzV12AyPPc+lGMlFMf7fBBSyX4N8HGp+uBlsb0konZGHm+WTF7dku8Ld3ecj1HE+p4Px2q3FBEuWgqfb3qyvFyeCwA/Jp/
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1bcbfc4-ac8e-4113-cd06-08d79e626811
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 11:09:38.4336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j2yqRWFF3Ez2kS6W4Pq2wujJ2IdrgvILR6g/ccL808eAcd46L+7cdJEzyRU7XoRvQOCNbvdKLPNksj0vIjoQHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3858
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VHVlc2RheSwgSmFudWFyeSAyMSwgMjAyMCAxMDozNSBBTSwgSmFzb24gV2FuZzoNCj4gU3ViamVj
dDogUmU6IFtQQVRDSCAzLzVdIHZEUEE6IGludHJvZHVjZSB2RFBBIGJ1cw0KPiANCj4gDQo+IE9u
IDIwMjAvMS8yMSDkuIvljYg0OjE1LCBNaWNoYWVsIFMuIFRzaXJraW4gd3JvdGU6DQo+ID4gT24g
VHVlLCBKYW4gMjEsIDIwMjAgYXQgMDQ6MDA6MzhQTSArMDgwMCwgSmFzb24gV2FuZyB3cm90ZToN
Cj4gPj4gT24gMjAyMC8xLzIxIOS4i+WNiDE6NDcsIE1pY2hhZWwgUy4gVHNpcmtpbiB3cm90ZToN
Cj4gPj4+IE9uIFR1ZSwgSmFuIDIxLCAyMDIwIGF0IDEyOjAwOjU3UE0gKzA4MDAsIEphc29uIFdh
bmcgd3JvdGU6DQo+ID4+Pj4gT24gMjAyMC8xLzIxIOS4iuWNiDE6NDksIEphc29uIEd1bnRob3Jw
ZSB3cm90ZToNCj4gPj4+Pj4gT24gTW9uLCBKYW4gMjAsIDIwMjAgYXQgMDQ6NDM6NTNQTSArMDgw
MCwgSmFzb24gV2FuZyB3cm90ZToNCj4gPj4+Pj4+IFRoaXMgaXMgc2ltaWxhciB0byB0aGUgZGVz
aWduIG9mIHBsYXRmb3JtIElPTU1VIHBhcnQgb2YNCj4gPj4+Pj4+IHZob3N0LXZkcGEuIFdlIGRl
Y2lkZSB0byBzZW5kIGRpZmZzIHRvIHBsYXRmb3JtIElPTU1VIHRoZXJlLiBJZg0KPiA+Pj4+Pj4g
aXQncyBvayB0byBkbyB0aGF0IGluIGRyaXZlciwgd2UgY2FuIHJlcGxhY2Ugc2V0X21hcCB3aXRo
IGluY3JlbWVudGFsDQo+IEFQSSBsaWtlIG1hcCgpL3VubWFwKCkuDQo+ID4+Pj4+Pg0KPiA+Pj4+
Pj4gVGhlbiBkcml2ZXIgbmVlZCB0byBtYWludGFpbiByYnRyZWUgaXRzZWxmLg0KPiA+Pj4+PiBJ
IHRoaW5rIHdlIHJlYWxseSBuZWVkIHRvIHNlZSB0d28gbW9kZXMsIG9uZSB3aGVyZSB0aGVyZSBp
cyBhDQo+ID4+Pj4+IGZpeGVkIHRyYW5zbGF0aW9uIHdpdGhvdXQgZHluYW1pYyB2SU9NTVUgZHJp
dmVuIGNoYW5nZXMgYW5kIG9uZQ0KPiA+Pj4+PiB0aGF0IHN1cHBvcnRzIHZJT01NVS4NCj4gPj4+
PiBJIHRoaW5rIGluIHRoaXMgY2FzZSwgeW91IG1lYW50IHRoZSBtZXRob2QgcHJvcG9zZWQgYnkg
U2hhaGFmIHRoYXQNCj4gPj4+PiBzZW5kcyBkaWZmcyBvZiAiZml4ZWQgdHJhbnNsYXRpb24iIHRv
IGRldmljZT8NCj4gPj4+Pg0KPiA+Pj4+IEl0IHdvdWxkIGJlIGtpbmQgb2YgdHJpY2t5IHRvIGRl
YWwgd2l0aCB0aGUgZm9sbG93aW5nIGNhc2UgZm9yIGV4YW1wbGU6DQo+ID4+Pj4NCj4gPj4+PiBv
bGQgbWFwIFs0RywgMTZHKSBuZXcgbWFwIFs0RywgOEcpDQo+ID4+Pj4NCj4gPj4+PiBJZiB3ZSBk
bw0KPiA+Pj4+DQo+ID4+Pj4gMSkgZmx1c2ggWzRHLCAxNkcpDQo+ID4+Pj4gMikgYWRkIFs0Rywg
OEcpDQo+ID4+Pj4NCj4gPj4+PiBUaGVyZSBjb3VsZCBiZSBhIHdpbmRvdyBiZXR3ZWVuIDEpIGFu
ZCAyKS4NCj4gPj4+Pg0KPiA+Pj4+IEl0IHJlcXVpcmVzIHRoZSBJT01NVSB0aGF0IGNhbiBkbw0K
PiA+Pj4+DQo+ID4+Pj4gMSkgcmVtb3ZlIFs4RywgMTZHKQ0KPiA+Pj4+IDIpIGZsdXNoIFs4Rywg
MTZHKQ0KPiA+Pj4+IDMpIGNoYW5nZSBbNEcsIDhHKQ0KPiA+Pj4+DQo+ID4+Pj4gLi4uLg0KPiA+
Pj4gQmFzaWNhbGx5IHdoYXQgSSBoYWQgaW4gbWluZCBpcyBzb21ldGhpbmcgbGlrZSBxZW11IG1l
bW9yeSBhcGkNCj4gPj4+DQo+ID4+PiAwLiBiZWdpbg0KPiA+Pj4gMS4gcmVtb3ZlIFs4RywgMTZH
KQ0KPiA+Pj4gMi4gYWRkIFs0RywgOEcpDQo+ID4+PiAzLiBjb21taXQNCj4gPj4NCj4gPj4gVGhp
cyBzb3VuZHMgbW9yZSBmbGV4aWJsZSBlLmcgZHJpdmVyIG1heSBjaG9vc2UgdG8gaW1wbGVtZW50
IHN0YXRpYw0KPiA+PiBtYXBwaW5nIG9uZSB0aHJvdWdoIGNvbW1pdC4gQnV0IGEgcXVlc3Rpb24g
aGVyZSwgaXQgbG9va3MgdG8gbWUgdGhpcw0KPiA+PiBzdGlsbCByZXF1aXJlcyB0aGUgRE1BIHRv
IGJlIHN5bmNlZCB3aXRoIGF0IGxlYXN0IGNvbW1pdCBoZXJlLg0KPiA+PiBPdGhlcndpc2UgZGV2
aWNlIG1heSBnZXQgRE1BIGZhdWx0PyBPciBkZXZpY2UgaXMgZXhwZWN0ZWQgdG8gYmUgcGF1c2Vk
DQo+IERNQSBkdXJpbmcgYmVnaW4/DQo+ID4+DQo+ID4+IFRoYW5rcw0KPiA+IEZvciBleGFtcGxl
LCBjb21taXQgbWlnaHQgc3dpdGNoIG9uZSBzZXQgb2YgdGFibGVzIGZvciBhbm90aGVyLA0KPiA+
IHdpdGhvdXQgbmVlZCB0byBwYXVzZSBETUEuDQo+IA0KPiANCj4gWWVzLCBJIHRoaW5rIHRoYXQg
d29ya3MgYnV0IG5lZWQgY29uZmlybWF0aW9uIGZyb20gU2hhaGFmIG9yIEphc29uLg0KDQpGcm9t
IG15IHNpZGUsIGFzIEkgd3JvdGUsIEkgd291bGQgbGlrZSB0byBzZWUgdGhlIHN1Z2dlc3RlZCBm
dW5jdGlvbiBwcm90b3R5cGUgYWxvbmcgdy8gdGhlIGRlZmluaXRpb24gb2YgdGhlIGV4cGVjdGF0
aW9uIGZyb20gZHJpdmVyIHVwb24gY2FsbGluZyB0aG9zZS4gDQpJdCBpcyBub3QgMTAwJSBjbGVh
ciB0byBtZSB3aGF0IHNob3VsZCBiZSB0aGUgb3V0Y29tZSBvZiByZW1vdmUvZmx1c2gvY2hhbmdl
L2NvbW1pdA0KDQo+IA0KPiBUaGFua3MNCj4gDQo+IA0KPiANCj4gPg0KPiA+Pj4gQW55d2F5LCBJ
J20gZmluZSB3aXRoIGEgb25lLXNob3QgQVBJIGZvciBub3csIHdlIGNhbiBpbXByb3ZlIGl0DQo+
ID4+PiBsYXRlci4NCj4gPj4+DQo+ID4+Pj4+IFRoZXJlIGFyZSBkaWZmZXJlbnQgb3B0aW1pemF0
aW9uIGdvYWxzIGluIHRoZSBkcml2ZXJzIGZvciB0aGVzZQ0KPiA+Pj4+PiB0d28gY29uZmlndXJh
dGlvbnMuDQo+ID4+Pj4+DQo+ID4+Pj4+Pj4gSWYgdGhlIGZpcnN0IG9uZSwgdGhlbiBJIHRoaW5r
IG1lbW9yeSBob3RwbHVnIGlzIGEgaGVhdnkgZmxvdw0KPiA+Pj4+Pj4+IHJlZ2FyZGxlc3MuIERv
IHlvdSB0aGluayB0aGUgZXh0cmEgY3ljbGVzIGZvciB0aGUgdHJlZSB0cmF2ZXJzZQ0KPiA+Pj4+
Pj4+IHdpbGwgYmUgdmlzaWJsZSBpbiBhbnkgd2F5Pw0KPiA+Pj4+Pj4gSSB0aGluayBpZiB0aGUg
ZHJpdmVyIGNhbiBwYXVzZSB0aGUgRE1BIGR1cmluZyB0aGUgdGltZSBmb3INCj4gPj4+Pj4+IHNl
dHRpbmcgdXAgbmV3IG1hcHBpbmcsIGl0IHNob3VsZCBiZSBmaW5lLg0KPiA+Pj4+PiBUaGlzIGlz
IHZlcnkgdHJpY2t5IGZvciBhbnkgZHJpdmVyIGlmIHRoZSBtYXBwaW5nIGNoYW5nZSBoaXRzIHRo
ZQ0KPiA+Pj4+PiB2aXJ0aW8gcmluZ3MuIDooDQo+ID4+Pj4+DQo+ID4+Pj4+IEV2ZW4gYSBJT01N
VSB1c2luZyBkcml2ZXIgaXMgZ29pbmcgdG8gaGF2ZSBwcm9ibGVtcyB3aXRoIHRoYXQuLg0KPiA+
Pj4+Pg0KPiA+Pj4+PiBKYXNvbg0KPiA+Pj4+IE9yIEkgd29uZGVyIHdoZXRoZXIgQVRTL1BSSSBj
YW4gaGVscCBoZXJlLiBFLmcgZHVyaW5nIEkvTyBwYWdlDQo+ID4+Pj4gZmF1bHQsIGRyaXZlci9k
ZXZpY2UgY2FuIHdhaXQgZm9yIHRoZSBuZXcgbWFwcGluZyB0byBiZSBzZXQgYW5kDQo+ID4+Pj4g
dGhlbiByZXBsYXkgdGhlIERNQS4NCj4gPj4+Pg0KPiA+Pj4+IFRoYW5rcw0KPiA+Pj4+DQoNCg==
