Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F424EFA2
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 21:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfFUTuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 15:50:18 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60978 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbfFUTuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 15:50:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5LJkxF7020069;
        Fri, 21 Jun 2019 12:49:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=+TJBII/D8ARsx67+78TKxIHCLx0ecmTBOfssQbznH8I=;
 b=aBbrKLl7PZAx/vsmemStGQQ0OigqqhRi0eDluF29AaYfap1ryC1Z8eFI0op7ROdJbvX6
 dhcYI3zFOVMk8D/jT6DG6NXOUMkj7f+Nd/5A4cwAOA6kX1EB4o0qD292w3tPU5RhQnwR
 32DgD8k77ZGRVYI3G0nYJk7PP4v+xUSVWBqRiS3jHS05+LIhkwkSL8NwNgYg41uUe405
 W2ycWGOGJJm4zq1BtNFuzbzfL8J6GaQP0voSHIEQ82qYkveCBdlSoJyBn6fYcULMd/oQ
 cK4LxDli+JYpkln+fPx1Rx09JZHbVv765H1IUAxpsxb3sCxUA7BOsWdkloporb5JJ2CE BQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t8yp21cxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 21 Jun 2019 12:49:45 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 21 Jun
 2019 12:49:43 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.58) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 21 Jun 2019 12:49:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TJBII/D8ARsx67+78TKxIHCLx0ecmTBOfssQbznH8I=;
 b=gUBGHqokhktOgB/umDnLKDR+QzsmCnD+xUyQEl9STjgM4Z6Q8oyCsIVLiVD3QIuMxF+yjeQmLtGqj+ze7QqoUpwtkSjGebJmdM5zNjxZIrbd3YvF6yGyo3hnEOPQoOahkiIIE+4CMSHbE+WbeKUEdc8O9/1dbkB7dPp7KgQEmaY=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB2813.namprd18.prod.outlook.com (20.179.21.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 21 Jun 2019 19:49:40 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::9880:2b8b:52e5:b413]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::9880:2b8b:52e5:b413%3]) with mapi id 15.20.1987.014; Fri, 21 Jun 2019
 19:49:39 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Doug Ledford <dledford@redhat.com>,
        Ariel Elior <aelior@marvell.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 rdma-next 0/3] RDMA/qedr: Use the doorbell overflow
 recovery mechanism for RDMA
Thread-Topic: [PATCH v3 rdma-next 0/3] RDMA/qedr: Use the doorbell overflow
 recovery mechanism for RDMA
Thread-Index: AQHVIcOPS8dQZZiCAk+T2CNQdiy87KamTmsAgABA6RA=
Date:   Fri, 21 Jun 2019 19:49:39 +0000
Message-ID: <MN2PR18MB3182498CA8C9C7EB3259F62FA1E70@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190613083819.6998-1-michal.kalderon@marvell.com>
 <bda0321cb362bc93f5428b1df7daf69fed083656.camel@redhat.com>
In-Reply-To: <bda0321cb362bc93f5428b1df7daf69fed083656.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [79.181.29.27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b79f0393-1901-43c2-4da2-08d6f68198f7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2813;
x-ms-traffictypediagnostic: MN2PR18MB2813:
x-microsoft-antispam-prvs: <MN2PR18MB28131B7AC35612E3CC50D537A1E70@MN2PR18MB2813.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0075CB064E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(396003)(346002)(376002)(136003)(189003)(51914003)(199004)(66476007)(14444005)(64756008)(256004)(73956011)(66556008)(66446008)(476003)(6246003)(66946007)(11346002)(6506007)(7696005)(8936002)(66066001)(33656002)(99286004)(305945005)(5660300002)(7736002)(74316002)(86362001)(76116006)(2906002)(446003)(486006)(52536014)(53936002)(229853002)(71200400001)(71190400001)(186003)(478600001)(2501003)(8676002)(316002)(102836004)(26005)(4326008)(6116002)(3846002)(68736007)(9686003)(54906003)(110136005)(76176011)(6436002)(14454004)(81166006)(81156014)(55016002)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2813;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FpjBa99kAfK9jXOr+u3bwF/pKBSpVj73QpQHvgHnGmkhILmIrwqZMLuDZ8EH25utfOTwTtunZe25e3Ur/vgoXsIy8nM3BEFjfUYvb3vsOd30WndNt9/pDQwEkt0EkV6eEutRsflzRWdeFYSswHrU3u2eNufV4SC7plnIz44lyd/xdZlFda8FyFiXxQEQMqh4gRWnOIi/dXhCD8SYJSaqX3d4U3qm6LFh0SOe8efAC3A7+ltC9jC5h/aJ5AZZYN/6KxLydH3fx5rG2flbpc6AcB/vxLk+pc0hxlgoM1gXZZklfbf8cBWmqamXmHbMd/83CRK/Z67XPayB5SYd3IMnoswslN6H994/VAlzvzqPoRsfOvKJ3USOYBoW6rfs8ugMwjdX6PEup/AVuMC5tryBJpq9djwKE93A7Nu7Xg5b/ng=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b79f0393-1901-43c2-4da2-08d6f68198f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2019 19:49:39.4803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2813
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_14:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBsaW51eC1yZG1hLW93bmVyQHZnZXIua2VybmVsLm9yZyA8bGludXgtcmRtYS0NCj4g
b3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBCZWhhbGYgT2YgRG91ZyBMZWRmb3JkDQo+IA0KPiBP
biBUaHUsIDIwMTktMDYtMTMgYXQgMTE6MzggKzAzMDAsIE1pY2hhbCBLYWxkZXJvbiB3cm90ZToN
Cj4gPiBUaGlzIHBhdGNoIHNlcmllcyB1c2VkIHRoZSBkb29yYmVsbCBvdmVyZmxvdyByZWNvdmVy
eSBtZWNoYW5pc20NCj4gPiBpbnRyb2R1Y2VkIGluIGNvbW1pdCAzNjkwN2NkNWNkNzIgKCJxZWQ6
IEFkZCBkb29yYmVsbCBvdmVyZmxvdw0KPiA+IHJlY292ZXJ5IG1lY2hhbmlzbSIpIGZvciByZG1h
ICggUm9DRSBhbmQgaVdBUlAgKQ0KPiA+DQo+ID4gcmRtYS1jb3JlIHB1bGwgcmVxdWVzdCAjNDkz
DQo+ID4NCj4gPiBDaGFuZ2VzIGZyb20gVjI6DQo+ID4gLSBEb24ndCB1c2UgbG9uZy1saXZlZCBr
bWFwLiBJbnN0ZWFkIHVzZSB1c2VyLXRyaWdnZXIgbW1hcCBmb3IgdGhlDQo+ID4gICBkb29yYmVs
bCByZWNvdmVyeSBlbnRyaWVzLg0KPiA+IC0gTW9kaWZ5IGRwaV9hZGRyIHRvIGJlIGRlbm90ZWQg
d2l0aCBfX2lvbWVtIGFuZCBhdm9pZCByZWR1bmRhbnQNCj4gPiAgIGNhc3RzDQo+ID4NCj4gPiBD
aGFuZ2VzIGZyb20gVjE6DQo+ID4gLSBjYWxsIGttYXAgdG8gbWFwIHZpcnR1YWwgYWRkcmVzcyBp
bnRvIGtlcm5lbCBzcGFjZQ0KPiA+IC0gbW9kaWZ5IGRiX3JlY19kZWxldGUgdG8gYmUgdm9pZA0K
PiA+IC0gcmVtb3ZlIHNvbWUgY3B1X3RvX2xlMTYgdGhhdCB3ZXJlIGFkZGVkIHRvIHByZXZpb3Vz
IHBhdGNoIHdoaWNoIGFyZQ0KPiA+ICAgY29ycmVjdCBidXQgbm90IHJlbGF0ZWQgdG8gdGhlIG92
ZXJmbG93IHJlY292ZXJ5IG1lY2hhbmlzbS4gV2lsbCBiZQ0KPiA+ICAgc3VibWl0dGVkIGFzIHBh
cnQgb2YgYSBkaWZmZXJlbnQgcGF0Y2gNCj4gPg0KPiA+DQo+ID4gTWljaGFsIEthbGRlcm9uICgz
KToNCj4gPiAgIHFlZCo6IENoYW5nZSBkcGlfYWRkciB0byBiZSBkZW5vdGVkIHdpdGggX19pb21l
bQ0KPiA+ICAgUkRNQS9xZWRyOiBBZGQgZG9vcmJlbGwgb3ZlcmZsb3cgcmVjb3Zlcnkgc3VwcG9y
dA0KPiA+ICAgUkRNQS9xZWRyOiBBZGQgaVdBUlAgZG9vcmJlbGwgcmVjb3Zlcnkgc3VwcG9ydA0K
PiA+DQo+ID4gIGRyaXZlcnMvaW5maW5pYmFuZC9ody9xZWRyL21haW4uYyAgICAgICAgICB8ICAg
MiArLQ0KPiA+ICBkcml2ZXJzL2luZmluaWJhbmQvaHcvcWVkci9xZWRyLmggICAgICAgICAgfCAg
MjcgKy0NCj4gPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L3FlZHIvdmVyYnMuYyAgICAgICAgIHwg
Mzg3DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0NCj4gPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcWxvZ2ljL3FlZC9xZWRfcmRtYS5jIHwgICA2ICstDQo+ID4gIGluY2x1ZGUvbGlu
dXgvcWVkL3FlZF9yZG1hX2lmLmggICAgICAgICAgICB8ICAgMiArLQ0KPiA+ICBpbmNsdWRlL3Vh
cGkvcmRtYS9xZWRyLWFiaS5oICAgICAgICAgICAgICAgfCAgMjUgKysNCj4gPiAgNiBmaWxlcyBj
aGFuZ2VkLCAzNzggaW5zZXJ0aW9ucygrKSwgNzEgZGVsZXRpb25zKC0pDQo+ID4NCj4gDQo+IEhp
IE1pY2hhbCwNCj4gDQo+IEluIHBhdGNoIDIgYW5kIDMgYm90aCwgeW91IHN0aWxsIGhhdmUgcXVp
dGUgYSBmZXcgY2FzdHMgdG8gKHU4IF9faW9tZW0gKikuDQo+IFdoeSBub3QganVzdCBkZWZpbmUg
dGhlIHN0cnVjdCBlbGVtZW50cyBhcyB1OCBfX2lvbWVtICogaW5zdGVhZCBvZiB2b2lkDQo+IF9f
aW9tZW0gKiBhbmQgYXZvaWQgYWxsIHRoZSBjYXN0cz8NCj4gDQpIaSBEb3VnLCANCg0KVGhhbmtz
IGZvciB0aGUgcmV2aWV3LiBUaGUgcmVtYWluaW5nIGNhc3RzIGFyZSBkdWUgdG8gcG9pbnRlciBh
cml0aG1ldGljIGFuZCBub3QgdmFyaWFibGUgYXNzaWdubWVudHMNCmFzIGJlZm9yZS4gUmVtb3Zp
bmcgdGhlIGNhc3QgZW50aXJlbHkgd2lsbCByZXF1aXJlIHF1aXRlIGEgbG90IG9mIGNoYW5nZXMg
aW4gcWVkIGFuZCBpbiByZG1hLWNvcmUNCndoaWNoIEkgd291bGQgYmUgaGFwcHkgdG8gYXZvaWQg
YXQgdGhpcyB0aW1lLiANClBsZWFzZSByZWNvbnNpZGVyLCANClRoYW5rcyBhZ2FpbiANCk1pY2hh
bA0KDQoNCj4gLS0NCj4gRG91ZyBMZWRmb3JkIDxkbGVkZm9yZEByZWRoYXQuY29tPg0KPiAgICAg
R1BHIEtleUlEOiBCODI2QTMzMzBFNTcyRkREDQo+ICAgICBGaW5nZXJwcmludCA9IEFFNkIgMUJE
QSAxMjJCIDIzQjQgMjY1QiAgMTI3NCBCODI2IEEzMzMgMEU1NyAyRkREDQo=
