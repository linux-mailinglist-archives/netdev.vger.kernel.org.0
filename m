Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A60141D14
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 10:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgASJHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 04:07:16 -0500
Received: from mail-eopbgr70043.outbound.protection.outlook.com ([40.107.7.43]:65351
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726444AbgASJHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 04:07:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRYP/4UoIh7hA/wUlwABwFPPlpGc/lpoWtszW57XDOzs9I/EwXXKvte6E21c3ySs/LDW1hiWRP+74kdp1WqegVMkLgo9HMT908SMBErfgdnoGhP5Kau0B1nO5RmSbkqT9UQ7TD894Xv9HmYxyYBJ2j+HpjnzjjB7rQCF1Y63avs07oI0XleEdle2nYgmgqCftt/AHIc1vVtCFV+q0XCwt8Li67c4TPHZJ4m0K4tSwtt9epBr1I4DtoRSmtpUDUSghAyL0sXwqvMJykA7rEGo42Q8Zxtzwf2UUAFezQV20y8eiqE5ukycGnvbsdfB9WkISAr9sVIVuQfataQYR1Q2bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhTa+yyiJ8Po1xQhXyXUQ/xr1/atu55AK1SdXFLAGxg=;
 b=Kno/w15220CXJ6nODjd5Z4fB/wusYXtsIu5NnyhFdXnf8B9qXi/g+S2j0GY3Ib50I9Ya5HBqdBTAGy2hbMtlX7KVhVrHztaQVu7987eWLS/h2O/9DRKj1bJDJitlvnxktdbsT6WNE8EYQ7KKuAZ0bCLdpEVj99Z26jvAxJX5nT06Vd9Ferp3QdVuK2gDBLI3TLDKNBW2W3sVXDY66dXpnu+LmNg1oT1nK8cTkFLrySlajZTtQU/B0IGyUnV4ju7JG8C/Ng2dNvXJvGrFhADXT6E5W9ok+Xo20Tjv584I5eSrvD1mwlIQTR5TUAZU9xmCGNGnFJoMIIZwLn8AsvuvNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhTa+yyiJ8Po1xQhXyXUQ/xr1/atu55AK1SdXFLAGxg=;
 b=cC2aYa0XIYIS+ZUDuFigQFOy8KDCfgWVAMEAWOWwluKQgXSrjSIZUKsM2qDu9htYbWLjIt8rCcfW99ShjuvGn9t7EdKWwcN3D6u3/Bn3XTKqRe6tSFyBaanhmNjbI/ZdUrblveFM71DBMr0q4uLkyaIa7J6kiFJba+m9wVHf85w=
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com (52.133.45.150) by
 AM0PR0502MB3971.eurprd05.prod.outlook.com (52.133.40.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Sun, 19 Jan 2020 09:07:10 +0000
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb]) by AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb%7]) with mapi id 15.20.2644.024; Sun, 19 Jan 2020
 09:07:09 +0000
From:   Shahaf Shuler <shahafs@mellanox.com>
To:     Rob Miller <rob.miller@broadcom.com>,
        Jason Wang <jasowang@redhat.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
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
        Ariel Adam <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: RE: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Topic: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Index: AQHVzGqTFJN2iC19r0STv/0Uj4sDPafuxkEAgAAbnwCAAAWygIACyO6w
Date:   Sun, 19 Jan 2020 09:07:09 +0000
Message-ID: <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
In-Reply-To: <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shahafs@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1e7cdedf-da72-499c-7973-08d79cbef711
x-ms-traffictypediagnostic: AM0PR0502MB3971:|AM0PR0502MB3971:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB3971E6D23CE8FE4AE5D19A37C3330@AM0PR0502MB3971.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0287BBA78D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(346002)(136003)(39850400004)(199004)(189003)(66556008)(66446008)(64756008)(6506007)(5660300002)(71200400001)(66476007)(52536014)(76116006)(66946007)(7696005)(86362001)(7416002)(2906002)(110136005)(54906003)(33656002)(4326008)(9686003)(81166006)(26005)(316002)(186003)(81156014)(8676002)(8936002)(478600001)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB3971;H:AM0PR0502MB3795.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0wo896bJoeAioK2NKs92JHqTf/gfu22vtVnPGERY32fi2Yl55FTYqO9FhoS8s3KAEjvskuoVW23wc0/ZNfjiuv24ZK69fdfhuZJgZpq52QR4WhDadoU5gyzKKjBkYyK8buRnJ3swxAClFHFj2bUSpBn/ZUXaDCY7BVgNkdEHHUMu+cP1YZzMRAUKAyRUu/9L5pIOK7h1+XrHnl8ldff84RmS3SpDaafAKvAhXnrPvWrEFThEKbUDjwJJ7C3y82p6DHPSgl4pJWMrxcjmeuRs5cBKhygftO815NJAsWt42M2iyirY+oh0LlqUtHiOuZ99bMBnwHdDpPwullTsMbEMwdOZ8Gej+ZQC/Y4akX+pc82cT22eo75zwNAA7NK0SH6lBwxQuSSPexvTJ1AYV5+0ckfe0dZI/E+BphEu7YU5NVMxZq33Z2/f38QugkWRUYji
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e7cdedf-da72-499c-7973-08d79cbef711
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2020 09:07:09.6023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CHN6Oppv3xTQykWrskAzqSYvE+mayVTl457dDH6DDz4d57q0QuQK4yryWc6FGFaBQE1kpZnz/wPVmeC3ILJpOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3971
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJpZGF5LCBKYW51YXJ5IDE3LCAyMDIwIDQ6MTMgUE0sIFJvYiBNaWxsZXI6DQpTdWJqZWN0OiBS
ZTogW1BBVENIIDMvNV0gdkRQQTogaW50cm9kdWNlIHZEUEEgYnVzDQo+Pk9uIDIwMjAvMS8xNyDk
uIvljYg4OjEzLCBNaWNoYWVsIFMuIFRzaXJraW4gd3JvdGU6DQo+Pj4gT24gVGh1LCBKYW4gMTYs
IDIwMjAgYXQgMDg6NDI6MjlQTSArMDgwMCwgSmFzb24gV2FuZyB3cm90ZToNCg0KWy4uLl0NCg0K
Pj4+ICsgKiBAc2V0X21hcDrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBTZXQg
ZGV2aWNlIG1lbW9yeSBtYXBwaW5nLCBvcHRpb25hbA0KPj4+ICsgKsKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGFuZCBvbmx5IG5lZWRlZCBmb3IgZGV2aWNlIHRoYXQgdXNp
bmcNCj4+PiArICrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBkZXZpY2Ug
c3BlY2lmaWMgRE1BIHRyYW5zbGF0aW9uDQo+Pj4gKyAqwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgKG9uLWNoaXAgSU9NTVUpDQo+Pj4gKyAqwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgQHZkZXY6IHZkcGEgZGV2aWNlDQo+Pj4gKyAqwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgQGlvdGxiOiB2aG9zdCBtZW1vcnkgbWFwcGlu
ZyB0byBiZQ0KPj4+ICsgKsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHVz
ZWQgYnkgdGhlIHZEUEENCj4+PiArICrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBSZXR1cm5zIGludGVnZXI6IHN1Y2Nlc3MgKDApIG9yIGVycm9yICg8IDApDQo+PiBPSyBz
byBhbnkgY2hhbmdlIGp1c3Qgc3dhcHMgaW4gYSBjb21wbGV0ZWx5IG5ldyBtYXBwaW5nPw0KPj4g
V291bGRuJ3QgdGhpcyBtYWtlIG1pbm9yIGNoYW5nZXMgc3VjaCBhcyBtZW1vcnkgaG90cGx1Zw0K
Pj4gcXVpdGUgZXhwZW5zaXZlPw0KDQpXaGF0IGlzIHRoZSBjb25jZXJuPyBUcmF2ZXJzaW5nIHRo
ZSByYiB0cmVlIG9yIGZ1bGx5IHJlcGxhY2UgdGhlIG9uLWNoaXAgSU9NTVUgdHJhbnNsYXRpb25z
PyANCklmIHRoZSBsYXRlc3QsIHRoZW4gSSB0aGluayB3ZSBjYW4gdGFrZSBzdWNoIG9wdGltaXph
dGlvbiBvbiB0aGUgZHJpdmVyIGxldmVsIChpLmUuIHRvIHVwZGF0ZSBvbmx5IHRoZSBkaWZmIGJl
dHdlZW4gdGhlIHR3byBtYXBwaW5nKS4gDQpJZiB0aGUgZmlyc3Qgb25lLCB0aGVuIEkgdGhpbmsg
bWVtb3J5IGhvdHBsdWcgaXMgYSBoZWF2eSBmbG93IHJlZ2FyZGxlc3MuIERvIHlvdSB0aGluayB0
aGUgZXh0cmEgY3ljbGVzIGZvciB0aGUgdHJlZSB0cmF2ZXJzZSB3aWxsIGJlIHZpc2libGUgaW4g
YW55IHdheT8gDQoNCj4NCj5NeSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQgdGhlIGluY3JlbWVudGFs
IHVwZGF0aW5nIG9mIHRoZSBvbiBjaGlwIElPTU1VIA0KPm1heSBkZWdyYWRlIHRoZcKgIHBlcmZv
cm1hbmNlLiBTbyB2ZW5kb3IgdkRQQSBkcml2ZXJzIG1heSB3YW50IHRvIGtub3cgDQo+YWxsIHRo
ZSBtYXBwaW5ncyBhdCBvbmNlLiANCg0KWWVzIGV4YWN0LiBGb3IgTWVsbGFub3ggY2FzZSBmb3Ig
aW5zdGFuY2UgbWFueSBvcHRpbWl6YXRpb24gY2FuIGJlIHBlcmZvcm1lZCBvbiBhIGdpdmVuIG1l
bW9yeSBsYXlvdXQuDQoNCj5UZWNobmljYWxseSwgd2UgY2FuIGtlZXAgdGhlIGluY3JlbWVudGFs
IEFQSSANCj5oZXJlIGFuZCBsZXQgdGhlIHZlbmRvciB2RFBBIGRyaXZlcnMgdG8gcmVjb3JkIHRo
ZSBmdWxsIG1hcHBpbmcgDQo+aW50ZXJuYWxseSB3aGljaCBtYXkgc2xpZ2h0bHkgaW5jcmVhc2Ug
dGhlIGNvbXBsZXhpdHkgb2YgdmVuZG9yIGRyaXZlci4gDQoNCldoYXQgd2lsbCBiZSB0aGUgdHJp
Z2dlciBmb3IgdGhlIGRyaXZlciB0byBrbm93IGl0IHJlY2VpdmVkIHRoZSBsYXN0IG1hcHBpbmcg
b24gdGhpcyBzZXJpZXMgYW5kIGl0IGNhbiBub3cgcHVzaCBpdCB0byB0aGUgb24tY2hpcCBJT01N
VT8NCg0KPldlIG5lZWQgbW9yZSBpbnB1dHMgZnJvbSB2ZW5kb3JzIGhlcmUuDQo+DQo+VGhhbmtz
DQoNCg0K
