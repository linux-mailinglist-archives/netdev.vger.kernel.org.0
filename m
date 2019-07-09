Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054FB6343D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 12:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfGIK0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 06:26:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9858 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726081AbfGIK0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 06:26:49 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69APPUm007760;
        Tue, 9 Jul 2019 03:26:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=mBy8q33MZPE9dprbbtERhIKmHrQukSHjXn3BOCl0peI=;
 b=M2qwzbRiLxdDV4C+bEblBowOMie5E7xmXIBq1MM90SLZ865z2ijGLBYg/KeWS8W1SrXZ
 oQIu+m2BTaaTUVImt8y0Xt8/ivQ3qGLIubdD/l0nyyo/cvi+7SpQEiqYTwwpcL17bmBR
 EiIwOmlwI+5nQM7gwL87vRf/RptsklN6DLzdOigaSNgyJUaf0pQUW3jMx6G006mp4mfe
 FWFNh1GdhY7ffW3cE4L6arLIMCHTTphPvEkdwCnaMnJ1aVBxK7cGJ5hGYE2pQ9V8BwA4
 lq5Bexf8Ug6uX2yDn427qU4Wh89FerNmfNKkBf7xn4835Fy/Cj3uE8EOG71JCULmK5UB ow== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tmnmy8s8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 03:26:18 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 9 Jul
 2019 03:26:17 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 9 Jul 2019 03:26:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBy8q33MZPE9dprbbtERhIKmHrQukSHjXn3BOCl0peI=;
 b=T2YNzwmUNOJ0CgabhVLEgwFy+rqMtElsk3kMspSljZekETmroImzvN5nZXWmbkNLAeQaYCvoae4Lf/lmkRwi287b38Ktxmd9ZUh8mt8+tIl+0l5rVRPN/VnXEoKv6/i1G6PsGXssUFxtrsOrIVPAKDt1PkSY2msInhRVrDUTnUk=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB2605.namprd18.prod.outlook.com (20.179.83.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Tue, 9 Jul 2019 10:26:11 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e%6]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 10:26:11 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Gal Pressman <galpress@amazon.com>,
        Ariel Elior <aelior@marvell.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v5 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Thread-Topic: [PATCH v5 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Thread-Index: AQHVNW3i/26cQYUn40uIF93L69NO9qbAvGyAgAFZGmA=
Date:   Tue, 9 Jul 2019 10:26:11 +0000
Message-ID: <MN2PR18MB31821ED5BAEDFD015FE35471A1F10@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190708091503.14723-1-michal.kalderon@marvell.com>
 <20190708091503.14723-2-michal.kalderon@marvell.com>
 <da67a821-1b26-c795-ff43-af17324f07e5@amazon.com>
In-Reply-To: <da67a821-1b26-c795-ff43-af17324f07e5@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c7019e8-c31a-4656-4f49-08d70457dd55
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2605;
x-ms-traffictypediagnostic: MN2PR18MB2605:
x-microsoft-antispam-prvs: <MN2PR18MB260507E6123D0C8EB2D275F9A1F10@MN2PR18MB2605.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(54094003)(189003)(199004)(4326008)(53546011)(71190400001)(71200400001)(6246003)(68736007)(8936002)(478600001)(73956011)(81156014)(102836004)(81166006)(8676002)(66476007)(86362001)(54906003)(229853002)(66946007)(66556008)(66446008)(64756008)(9686003)(25786009)(2201001)(110136005)(76116006)(316002)(476003)(33656002)(256004)(53936002)(3846002)(6116002)(2906002)(305945005)(7736002)(6436002)(11346002)(55016002)(6506007)(7696005)(446003)(74316002)(486006)(52536014)(5660300002)(76176011)(14454004)(66066001)(99286004)(26005)(186003)(2501003)(130980200001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2605;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Faxi/T5iKqAn0EszouRncHX2itBSu9A6d6bC+gBF+Xcf0ujBvmKLpB9DYAACs+L8F9ckGdx4bJnqNWS8srcmbZwyXlmfM0W2yr5lC/nSZWu/LbnT7k5S34er6ZVC85WZeSVPgrHmeObNFqrBdy4at+TcpR+yw37awf4OCTUTrnh1qBglX78vTOn5UYKFNgnnzag2GxysjRcXyrQQExJf1AYAFZkvpkB8+uZT5BepIHTgM9STYK1YxRsQk6U5tAhO1XppuCbCJK8+Ht8JLVetutQHoR+7QlYaODNGRfoZz/5FIa41MsVSaKC/tpgGYxQKxzQX6xYgm4k6bEwkmSwu6OKlZyqgMllH6imKhXPk5uLBAe+YEc+EUztd63dP1lzvrIcj7+9OYNUa8OkJyvfQvYFMeuFpZ4TwUs2hym4NX+c=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c7019e8-c31a-4656-4f49-08d70457dd55
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 10:26:11.6526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2605
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_04:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBsaW51eC1yZG1hLW93bmVyQHZnZXIua2VybmVsLm9yZyA8bGludXgtcmRtYS0NCj4g
b3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBCZWhhbGYgT2YgR2FsIFByZXNzbWFuDQo+IA0KPiBP
biAwOC8wNy8yMDE5IDEyOjE0LCBNaWNoYWwgS2FsZGVyb24gd3JvdGU6DQo+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2RldmljZS5jDQo+ID4gYi9kcml2ZXJzL2luZmlu
aWJhbmQvY29yZS9kZXZpY2UuYw0KPiA+IGluZGV4IDhhNmNjYjkzNmRmZS4uYTgzMGMyYzVkNjkx
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2RldmljZS5jDQo+ID4g
KysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvZGV2aWNlLmMNCj4gPiBAQCAtMjUyMSw2ICsy
NTIxLDcgQEAgdm9pZCBpYl9zZXRfZGV2aWNlX29wcyhzdHJ1Y3QgaWJfZGV2aWNlICpkZXYsDQo+
IGNvbnN0IHN0cnVjdCBpYl9kZXZpY2Vfb3BzICpvcHMpDQo+ID4gIAlTRVRfREVWSUNFX09QKGRl
dl9vcHMsIG1hcF9tcl9zZ19waSk7DQo+ID4gIAlTRVRfREVWSUNFX09QKGRldl9vcHMsIG1hcF9w
aHlzX2Ztcik7DQo+ID4gIAlTRVRfREVWSUNFX09QKGRldl9vcHMsIG1tYXApOw0KPiA+ICsJU0VU
X0RFVklDRV9PUChkZXZfb3BzLCBtbWFwX2ZyZWUpOw0KPiA+ICAJU0VUX0RFVklDRV9PUChkZXZf
b3BzLCBtb2RpZnlfYWgpOw0KPiA+ICAJU0VUX0RFVklDRV9PUChkZXZfb3BzLCBtb2RpZnlfY3Ep
Ow0KPiA+ICAJU0VUX0RFVklDRV9PUChkZXZfb3BzLCBtb2RpZnlfZGV2aWNlKTsgZGlmZiAtLWdp
dA0KPiA+IGEvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvcmRtYV9jb3JlLmMNCj4gPiBiL2RyaXZl
cnMvaW5maW5pYmFuZC9jb3JlL3JkbWFfY29yZS5jDQo+ID4gaW5kZXggY2NmNGQwNjljMjVjLi43
MTY2NzQxODM0YzggMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvcmRt
YV9jb3JlLmMNCj4gPiArKysgYi9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9yZG1hX2NvcmUuYw0K
PiA+IEBAIC04MTcsNiArODE3LDcgQEAgc3RhdGljIHZvaWQgdWZpbGVfZGVzdHJveV91Y29udGV4
dChzdHJ1Y3QNCj4gaWJfdXZlcmJzX2ZpbGUgKnVmaWxlLA0KPiA+ICAJcmRtYV9yZXN0cmFja19k
ZWwoJnVjb250ZXh0LT5yZXMpOw0KPiA+DQo+ID4gIAlpYl9kZXYtPm9wcy5kZWFsbG9jX3Vjb250
ZXh0KHVjb250ZXh0KTsNCj4gPiArCXJkbWFfdXNlcl9tbWFwX2VudHJpZXNfcmVtb3ZlX2ZyZWUo
dWNvbnRleHQpOw0KPiANCj4gVGhpcyBzaG91bGQgaGFwcGVuIGJlZm9yZSBkZWFsbG9jX3Vjb250
ZXh0Lg0KUmlnaHQsIHdpbGwgZml4Lg0KPiANCj4gPiArc3RydWN0IHJkbWFfdXNlcl9tbWFwX2Vu
dHJ5ICoNCj4gPiArcmRtYV91c2VyX21tYXBfZW50cnlfZ2V0KHN0cnVjdCBpYl91Y29udGV4dCAq
dWNvbnRleHQsIHU2NCBrZXksIHU2NA0KPiA+ICtsZW4pIHsNCj4gPiArCXN0cnVjdCByZG1hX3Vz
ZXJfbW1hcF9lbnRyeSAqZW50cnk7DQo+ID4gKwl1NjQgbW1hcF9wYWdlOw0KPiA+ICsNCj4gPiAr
CW1tYXBfcGFnZSA9IGtleSA+PiBQQUdFX1NISUZUOw0KPiA+ICsJaWYgKG1tYXBfcGFnZSA+IFUz
Ml9NQVgpDQo+ID4gKwkJcmV0dXJuIE5VTEw7DQo+ID4gKw0KPiA+ICsJZW50cnkgPSB4YV9sb2Fk
KCZ1Y29udGV4dC0+bW1hcF94YSwgbW1hcF9wYWdlKTsNCj4gPiArCWlmICghZW50cnkgfHwgcmRt
YV91c2VyX21tYXBfZ2V0X2tleShlbnRyeSkgIT0ga2V5IHx8DQo+IA0KPiBJIHdvbmRlciBpZiB0
aGUgJ3JkbWFfdXNlcl9tbWFwX2dldF9rZXkoZW50cnkpICE9IGtleScgY2hlY2sgaXMgc3RpbGwN
Cj4gbmVlZGVkLg0KSSBndWVzcyBpdCdzIG5vdCBzaW5jZSB0aGUga2V5IGlzIHVzZWQgdG8gZ2V0
IHRoZSBlbnRyeS4gSSdsbCByZW1vdmUgdGhlIGNoZWNrDQoNCj4gDQo+ID4gKy8qDQo+ID4gKyAq
IFRoaXMgaXMgb25seSBjYWxsZWQgd2hlbiB0aGUgdWNvbnRleHQgaXMgZGVzdHJveWVkIGFuZCB0
aGVyZSBjYW4NCj4gPiArYmUgbm8NCj4gPiArICogY29uY3VycmVudCBxdWVyeSB2aWEgbW1hcCBv
ciBhbGxvY2F0ZSBvbiB0aGUgeGFycmF5LCB0aHVzIHdlIGNhbg0KPiA+ICtiZSBzdXJlIG5vDQo+
ID4gKyAqIG90aGVyIHRocmVhZCBpcyB1c2luZyB0aGUgZW50cnkgcG9pbnRlci4gV2UgYWxzbyBr
bm93IHRoYXQgYWxsIHRoZQ0KPiA+ICtCQVINCj4gPiArICogcGFnZXMgaGF2ZSBlaXRoZXIgYmVl
biB6YXAnZCBvciBtdW5tYXBlZCBhdCB0aGlzIHBvaW50LiAgTm9ybWFsDQo+ID4gK3BhZ2VzIGFy
ZQ0KPiA+ICsgKiByZWZjb3VudGVkIGFuZCB3aWxsIGJlIGZyZWVkIGF0IHRoZSBwcm9wZXIgdGlt
ZS4NCj4gPiArICovDQo+ID4gK3ZvaWQgcmRtYV91c2VyX21tYXBfZW50cmllc19yZW1vdmVfZnJl
ZShzdHJ1Y3QgaWJfdWNvbnRleHQNCj4gKnVjb250ZXh0KQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3Qg
cmRtYV91c2VyX21tYXBfZW50cnkgKmVudHJ5Ow0KPiA+ICsJdW5zaWduZWQgbG9uZyBtbWFwX3Bh
Z2U7DQo+ID4gKw0KPiA+ICsJeGFfZm9yX2VhY2goJnVjb250ZXh0LT5tbWFwX3hhLCBtbWFwX3Bh
Z2UsIGVudHJ5KSB7DQo+ID4gKwkJeGFfZXJhc2UoJnVjb250ZXh0LT5tbWFwX3hhLCBtbWFwX3Bh
Z2UpOw0KPiA+ICsNCj4gPiArCQlpYmRldl9kYmcodWNvbnRleHQtPmRldmljZSwNCj4gPiArCQkJ
ICAibW1hcDogb2JqWzB4JXBdIGtleVslI2xseF0gYWRkclslI2xseF0gbGVuWyUjbGx4XQ0KPiBy
ZW1vdmVkXG4iLA0KPiA+ICsJCQkgIGVudHJ5LT5vYmosIHJkbWFfdXNlcl9tbWFwX2dldF9rZXko
ZW50cnkpLA0KPiA+ICsJCQkgIGVudHJ5LT5hZGRyZXNzLCBlbnRyeS0+bGVuZ3RoKTsNCj4gPiAr
CQlpZiAodWNvbnRleHQtPmRldmljZS0+b3BzLm1tYXBfZnJlZSkNCj4gPiArCQkJdWNvbnRleHQt
PmRldmljZS0+b3BzLm1tYXBfZnJlZShlbnRyeS0+YWRkcmVzcywNCj4gPiArCQkJCQkJCWVudHJ5
LT5sZW5ndGgsDQo+ID4gKwkJCQkJCQllbnRyeS0+bW1hcF9mbGFnKTsNCj4gDQo+IFBhc3MgZW50
cnkgaW5zdGVhZD8NCj4gDQo+ID4gKwkJa2ZyZWUoZW50cnkpOw0KPiA+ICsJfQ0KPiA+ICt9DQo+
ID4gKw0KPiA+ICB2b2lkIHV2ZXJic191c2VyX21tYXBfZGlzYXNzb2NpYXRlKHN0cnVjdCBpYl91
dmVyYnNfZmlsZSAqdWZpbGUpICB7DQo+ID4gIAlzdHJ1Y3QgcmRtYV91bWFwX3ByaXYgKnByaXYs
ICpuZXh0X3ByaXY7IGRpZmYgLS1naXQNCj4gPiBhL2luY2x1ZGUvcmRtYS9pYl92ZXJicy5oIGIv
aW5jbHVkZS9yZG1hL2liX3ZlcmJzLmggaW5kZXgNCj4gPiAyNmU5YzI1OTQ5MTMuLjU0Y2UzZmRh
ZTE4MCAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL3JkbWEvaWJfdmVyYnMuaA0KPiA+ICsrKyBi
L2luY2x1ZGUvcmRtYS9pYl92ZXJicy5oDQo+ID4gQEAgLTE0MjUsNiArMTQyNSw4IEBAIHN0cnVj
dCBpYl91Y29udGV4dCB7DQo+ID4gIAkgKiBJbXBsZW1lbnRhdGlvbiBkZXRhaWxzIG9mIHRoZSBS
RE1BIGNvcmUsIGRvbid0IHVzZSBpbiBkcml2ZXJzOg0KPiA+ICAJICovDQo+ID4gIAlzdHJ1Y3Qg
cmRtYV9yZXN0cmFja19lbnRyeSByZXM7DQo+ID4gKwlzdHJ1Y3QgeGFycmF5IG1tYXBfeGE7DQo+
ID4gKwl1MzIgbW1hcF94YV9wYWdlOw0KPiA+ICB9Ow0KPiA+DQo+ID4gIHN0cnVjdCBpYl91b2Jq
ZWN0IHsNCj4gPiBAQCAtMjMxMSw2ICsyMzEzLDcgQEAgc3RydWN0IGliX2RldmljZV9vcHMgew0K
PiA+ICAJCQkgICAgICBzdHJ1Y3QgaWJfdWRhdGEgKnVkYXRhKTsNCj4gPiAgCXZvaWQgKCpkZWFs
bG9jX3Vjb250ZXh0KShzdHJ1Y3QgaWJfdWNvbnRleHQgKmNvbnRleHQpOw0KPiA+ICAJaW50ICgq
bW1hcCkoc3RydWN0IGliX3Vjb250ZXh0ICpjb250ZXh0LCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QN
Cj4gPiAqdm1hKTsNCj4gPiArCXZvaWQgKCptbWFwX2ZyZWUpKHU2NCBhZGRyZXNzLCB1NjQgbGVu
Z3RoLCB1OCBtbWFwX2ZsYWcpOw0KPiANCj4gSSBmZWVsIGxpa2UgdGhpcyBjYWxsYmFjayBuZWVk
cyBzb21lIGRvY3VtZW50YXRpb24uDQo+IA0KPiA+ICAJdm9pZCAoKmRpc2Fzc29jaWF0ZV91Y29u
dGV4dCkoc3RydWN0IGliX3Vjb250ZXh0ICppYmNvbnRleHQpOw0KPiA+ICAJaW50ICgqYWxsb2Nf
cGQpKHN0cnVjdCBpYl9wZCAqcGQsIHN0cnVjdCBpYl91ZGF0YSAqdWRhdGEpOw0KPiA+ICAJdm9p
ZCAoKmRlYWxsb2NfcGQpKHN0cnVjdCBpYl9wZCAqcGQsIHN0cnVjdCBpYl91ZGF0YSAqdWRhdGEp
OyBAQA0KPiA+IC0yNzA2LDkgKzI3MDksMjMgQEAgdm9pZCAgaWJfc2V0X2NsaWVudF9kYXRhKHN0
cnVjdCBpYl9kZXZpY2UgKmRldmljZSwNCj4gPiBzdHJ1Y3QgaWJfY2xpZW50ICpjbGllbnQsICB2
b2lkIGliX3NldF9kZXZpY2Vfb3BzKHN0cnVjdCBpYl9kZXZpY2UgKmRldmljZSwNCj4gPiAgCQkg
ICAgICAgY29uc3Qgc3RydWN0IGliX2RldmljZV9vcHMgKm9wcyk7DQo+ID4NCj4gPiArI2RlZmlu
ZSBSRE1BX1VTRVJfTU1BUF9JTlZBTElEIFU2NF9NQVggc3RydWN0DQo+IHJkbWFfdXNlcl9tbWFw
X2VudHJ5IHsNCj4gPiArCXZvaWQgICpvYmo7DQo+IA0KPiBJIGtub3cgRUZBIGlzIHRoZSBjdWxw
cml0IGhlcmUsIGJ1dCBwbGVhc2UgcmVtb3ZlIHRoZSBleHRyYSBzcGFjZSA6KS4NCj4gDQo+ID4g
Kwl1NjQgYWRkcmVzczsNCj4gPiArCXU2NCBsZW5ndGg7DQo+ID4gKwl1MzIgbW1hcF9wYWdlOw0K
PiA+ICsJdTggbW1hcF9mbGFnOw0KPiA+ICt9Ow0KPiA+ICsNCg==
