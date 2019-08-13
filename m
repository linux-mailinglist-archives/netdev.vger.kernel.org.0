Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB81D8BF14
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 18:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfHMQ7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 12:59:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40994 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726298AbfHMQ7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 12:59:04 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x7DGrwXn005475;
        Tue, 13 Aug 2019 09:58:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Vfj2JftF3UckFxGkCxn0uO4tNkD2gbKThucRsmy1urM=;
 b=jeg1piRW06Y1nrL1UDY6lHV/I9bwHuPCkqbqy3q/i4UUiXGJfiQX0G4+vfNDB0CxuTSm
 uGrZb3GFy4qtVmDN5n2NKrqrPJRxYn0vSuZNQ/sfs7P4AO+BfWpOUYfpvpEYmU/Jp3c7
 jE3m0Qh0FJVWXieHHXsldibmb83LJyoib1A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2ubxm4rqfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 13 Aug 2019 09:58:38 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 13 Aug 2019 09:58:37 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 13 Aug 2019 09:58:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbVtziYPt0uN70aONF9k5KAbJ/t5agiZQQbwpoD47vn94l/SkdfLjW2uaaYrWMNGOxNw86ra275FybibMSMxJ+P9d9uBiZYMj9NYoDPZMYfXdFkwldlggqZ+zI6OdAfFs9myk+kNQ2xvEK1COqkEfUPWlIgwwiqObbO5qguBTDwdYwNWfmhiMUwHYn7I33nTeMDX7PieMEw6BEXC/dMiQWhLjjbjzmPSMk6K6Kn4a6OqgwA6zOzJQw9EmaE0yHhWV6qtcKtIzvpPn3zMlII8t71jneHaQautyQhtA4wC69UX7Ip+qGR6c1QiBguYDVPeCO0xBnuE+6WUXCm5jEOXDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vfj2JftF3UckFxGkCxn0uO4tNkD2gbKThucRsmy1urM=;
 b=NOvVwBuLE0yV45Sl8ArpQtcwCTF4QfGPFcrlPT+qpwVwxAhEfRl1Rx9hmszP32bpe95oqA34qxslQrHpLHP4TNEbp8xkfTCi6F+kAaApi8QA7fcTmV8CXeJ03Emdv0UpXtCYGwmP/6cdH5+HCfUt1k03jRJtE3eyrttEbZWoMJc7/aq4yUfD7/UKZ5jhz4IDau/YuFsjH5bSdYw706cH5ifhPAQ/mwCzh/cblytTRc1ngEbyk75u6aYgyd09q4UKw3CTW9TIBxi/WmWLYCfLRkkyuZqlxmZz6YGU6MYl72wiFOj8DUtA7FLVw1X32TKzoEVEWdhky5BDHRHEjwd20w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vfj2JftF3UckFxGkCxn0uO4tNkD2gbKThucRsmy1urM=;
 b=Shc0qRhQnBp1vD85mdLEO+JPTZL72EgK97pWTTaucMvcYlHTRPNvtjkE0RvVr+aG71A7mksKSF6uNU47gAcfHh5CemXGEUg5wb2UGNIek6+NtacdFRAlGok9OrW2IAu0EFBrPMiz4YJM8qU8BojAWT7wKMQsWXxzAkfPS3BIIo8=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2471.namprd15.prod.outlook.com (52.135.200.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Tue, 13 Aug 2019 16:58:36 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2157.020; Tue, 13 Aug 2019
 16:58:36 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v3 2/4] bpf: support cloning sk storage on
 accept()
Thread-Topic: [PATCH bpf-next v3 2/4] bpf: support cloning sk storage on
 accept()
Thread-Index: AQHVUfPq0zRe8282Q0+l8JJiUAY9XKb5TL6A
Date:   Tue, 13 Aug 2019 16:58:36 +0000
Message-ID: <173b3736-97af-cad5-9432-8e6422a89d05@fb.com>
References: <20190813162630.124544-1-sdf@google.com>
 <20190813162630.124544-3-sdf@google.com>
In-Reply-To: <20190813162630.124544-3-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0022.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::35) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:f941]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3aa5395b-c254-414b-1e3b-08d7200f7b49
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2471;
x-ms-traffictypediagnostic: BYAPR15MB2471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB247127C471AE04A7DA60857BD3D20@BYAPR15MB2471.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(136003)(346002)(39860400002)(189003)(199004)(6246003)(4326008)(53936002)(6436002)(229853002)(6512007)(64756008)(66556008)(66476007)(446003)(66446008)(486006)(66946007)(476003)(11346002)(2616005)(5660300002)(2501003)(86362001)(2201001)(36756003)(5024004)(14444005)(256004)(6486002)(25786009)(81156014)(81166006)(31696002)(305945005)(7736002)(102836004)(52116002)(386003)(6506007)(76176011)(478600001)(14454004)(71200400001)(71190400001)(53546011)(8936002)(2906002)(31686004)(46003)(8676002)(6116002)(54906003)(110136005)(99286004)(316002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2471;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2f7wC3uq8D0Mo3I1Id9kf7Re0y11SsMIpqW/jala1k5SeaLnZulW06nANCFZXgo0NaxA2d19epGx2jYMua5lAzIRbjTrUf3Ii0pQRNxhwIkB0g7/n2Dr8GrdjwINZ1BpqoJ12RGL7iF9D8a/WDXmytpMdF1M0n+GGrQz+8P5Y3ahi1xwgCjISd/bo+/gvu/pH4xicOBQ0pEkWdRiZKYBhZqaf56pdlpueRhO+6SOu5bkdJxNlDxEbCihqo4wjly/uewcukUYwndF6DDAgcPjjUMhQpYOUiaKOfXnTJtFwi9JpZh2NxXvpy4smJ0m/BKmY0ucA5n2DxX6ICVNN8zcHZ8+9sNk9d1YVwISlVf2GvxPzX/3HRvFU6E0f4YzQQjAXfWWIZ7mu3itwZfysZn7B0ieDdm4FiXJAqaJdneVPsc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E5CC78C8F83214280AFCC10C0211E05@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa5395b-c254-414b-1e3b-08d7200f7b49
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 16:58:36.2971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: croqqkl/auydzNrsvxP+bzVY3b7ttvF70Sir5ZsH3J/pkTrXAamsuGRbfjqdgvGF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2471
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMTMvMTkgOToyNiBBTSwgU3RhbmlzbGF2IEZvbWljaGV2IHdyb3RlOg0KPiBBZGQg
bmV3IGhlbHBlciBicGZfc2tfc3RvcmFnZV9jbG9uZSB3aGljaCBvcHRpb25hbGx5IGNsb25lcyBz
ayBzdG9yYWdlDQo+IGFuZCBjYWxsIGl0IGZyb20gc2tfY2xvbmVfbG9jay4NCj4gDQo+IENjOiBN
YXJ0aW4gS2FGYWkgTGF1IDxrYWZhaUBmYi5jb20+DQo+IENjOiBZb25naG9uZyBTb25nIDx5aHNA
ZmIuY29tPg0KPiBBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCj4gU2lnbmVk
LW9mZi1ieTogU3RhbmlzbGF2IEZvbWljaGV2IDxzZGZAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICAg
aW5jbHVkZS9uZXQvYnBmX3NrX3N0b3JhZ2UuaCB8ICAxMCArKysrDQo+ICAgaW5jbHVkZS91YXBp
L2xpbnV4L2JwZi5oICAgICB8ICAgMyArDQo+ICAgbmV0L2NvcmUvYnBmX3NrX3N0b3JhZ2UuYyAg
ICB8IDEwMyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPiAgIG5ldC9jb3Jl
L3NvY2suYyAgICAgICAgICAgICAgfCAgIDkgKystDQo+ICAgNCBmaWxlcyBjaGFuZ2VkLCAxMTkg
aW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRl
L25ldC9icGZfc2tfc3RvcmFnZS5oIGIvaW5jbHVkZS9uZXQvYnBmX3NrX3N0b3JhZ2UuaA0KPiBp
bmRleCBiOWRjYjAyZTc1NmIuLjhlNGY4MzFkMmU1MiAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9u
ZXQvYnBmX3NrX3N0b3JhZ2UuaA0KPiArKysgYi9pbmNsdWRlL25ldC9icGZfc2tfc3RvcmFnZS5o
DQo+IEBAIC0xMCw0ICsxMCwxNCBAQCB2b2lkIGJwZl9za19zdG9yYWdlX2ZyZWUoc3RydWN0IHNv
Y2sgKnNrKTsNCj4gICBleHRlcm4gY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9za19z
dG9yYWdlX2dldF9wcm90bzsNCj4gICBleHRlcm4gY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3Rv
IGJwZl9za19zdG9yYWdlX2RlbGV0ZV9wcm90bzsNCj4gICANCj4gKyNpZmRlZiBDT05GSUdfQlBG
X1NZU0NBTEwNCj4gK2ludCBicGZfc2tfc3RvcmFnZV9jbG9uZShjb25zdCBzdHJ1Y3Qgc29jayAq
c2ssIHN0cnVjdCBzb2NrICpuZXdzayk7DQo+ICsjZWxzZQ0KPiArc3RhdGljIGlubGluZSBpbnQg
YnBmX3NrX3N0b3JhZ2VfY2xvbmUoY29uc3Qgc3RydWN0IHNvY2sgKnNrLA0KPiArCQkJCSAgICAg
ICBzdHJ1Y3Qgc29jayAqbmV3c2spDQo+ICt7DQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsjZW5k
aWYNCj4gKw0KPiAgICNlbmRpZiAvKiBfQlBGX1NLX1NUT1JBR0VfSCAqLw0KPiBkaWZmIC0tZ2l0
IGEvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+
IGluZGV4IDQzOTNiZDRiMjQxOS4uMGVmNTk0YWMzODk5IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRl
L3VhcGkvbGludXgvYnBmLmgNCj4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+IEBA
IC0zMzcsNiArMzM3LDkgQEAgZW51bSBicGZfYXR0YWNoX3R5cGUgew0KPiAgICNkZWZpbmUgQlBG
X0ZfUkRPTkxZX1BST0cJKDFVIDw8IDcpDQo+ICAgI2RlZmluZSBCUEZfRl9XUk9OTFlfUFJPRwko
MVUgPDwgOCkNCj4gICANCj4gKy8qIENsb25lIG1hcCBmcm9tIGxpc3RlbmVyIGZvciBuZXdseSBh
Y2NlcHRlZCBzb2NrZXQgKi8NCj4gKyNkZWZpbmUgQlBGX0ZfQ0xPTkUJCSgxVSA8PCA5KQ0KPiAr
DQo+ICAgLyogZmxhZ3MgZm9yIEJQRl9QUk9HX1FVRVJZICovDQo+ICAgI2RlZmluZSBCUEZfRl9R
VUVSWV9FRkZFQ1RJVkUJKDFVIDw8IDApDQo+ICAgDQo+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9i
cGZfc2tfc3RvcmFnZS5jIGIvbmV0L2NvcmUvYnBmX3NrX3N0b3JhZ2UuYw0KPiBpbmRleCA5NGM3
Zjc3ZWNiNmIuLjFiYzdkZTdlMThiYSAxMDA2NDQNCj4gLS0tIGEvbmV0L2NvcmUvYnBmX3NrX3N0
b3JhZ2UuYw0KPiArKysgYi9uZXQvY29yZS9icGZfc2tfc3RvcmFnZS5jDQo+IEBAIC0xMiw2ICsx
Miw5IEBADQo+ICAgDQo+ICAgc3RhdGljIGF0b21pY190IGNhY2hlX2lkeDsNCj4gICANCj4gKyNk
ZWZpbmUgU0tfU1RPUkFHRV9DUkVBVEVfRkxBR19NQVNLCQkJCQlcDQo+ICsJKEJQRl9GX05PX1BS
RUFMTE9DIHwgQlBGX0ZfQ0xPTkUpDQo+ICsNCj4gICBzdHJ1Y3QgYnVja2V0IHsNCj4gICAJc3Ry
dWN0IGhsaXN0X2hlYWQgbGlzdDsNCj4gICAJcmF3X3NwaW5sb2NrX3QgbG9jazsNCj4gQEAgLTIw
OSw3ICsyMTIsNiBAQCBzdGF0aWMgdm9pZCBzZWxlbV91bmxpbmtfc2soc3RydWN0IGJwZl9za19z
dG9yYWdlX2VsZW0gKnNlbGVtKQ0KPiAgIAkJa2ZyZWVfcmN1KHNrX3N0b3JhZ2UsIHJjdSk7DQo+
ICAgfQ0KPiAgIA0KPiAtLyogc2tfc3RvcmFnZS0+bG9jayBtdXN0IGJlIGhlbGQgYW5kIHNrX3N0
b3JhZ2UtPmxpc3QgY2Fubm90IGJlIGVtcHR5ICovDQo+ICAgc3RhdGljIHZvaWQgX19zZWxlbV9s
aW5rX3NrKHN0cnVjdCBicGZfc2tfc3RvcmFnZSAqc2tfc3RvcmFnZSwNCj4gICAJCQkgICAgc3Ry
dWN0IGJwZl9za19zdG9yYWdlX2VsZW0gKnNlbGVtKQ0KPiAgIHsNCj4gQEAgLTUwOSw3ICs1MTEs
NyBAQCBzdGF0aWMgaW50IHNrX3N0b3JhZ2VfZGVsZXRlKHN0cnVjdCBzb2NrICpzaywgc3RydWN0
IGJwZl9tYXAgKm1hcCkNCj4gICAJcmV0dXJuIDA7DQo+ICAgfQ0KPiAgIA0KPiAtLyogQ2FsbGVk
IGJ5IF9fc2tfZGVzdHJ1Y3QoKSAqLw0KPiArLyogQ2FsbGVkIGJ5IF9fc2tfZGVzdHJ1Y3QoKSAm
IGJwZl9za19zdG9yYWdlX2Nsb25lKCkgKi8NCj4gICB2b2lkIGJwZl9za19zdG9yYWdlX2ZyZWUo
c3RydWN0IHNvY2sgKnNrKQ0KPiAgIHsNCj4gICAJc3RydWN0IGJwZl9za19zdG9yYWdlX2VsZW0g
KnNlbGVtOw0KPiBAQCAtNTU3LDYgKzU1OSwxMSBAQCBzdGF0aWMgdm9pZCBicGZfc2tfc3RvcmFn
ZV9tYXBfZnJlZShzdHJ1Y3QgYnBmX21hcCAqbWFwKQ0KPiAgIA0KPiAgIAlzbWFwID0gKHN0cnVj
dCBicGZfc2tfc3RvcmFnZV9tYXAgKiltYXA7DQo+ICAgDQo+ICsJLyogTm90ZSB0aGF0IHRoaXMg
bWFwIG1pZ2h0IGJlIGNvbmN1cnJlbnRseSBjbG9uZWQgZnJvbQ0KPiArCSAqIGJwZl9za19zdG9y
YWdlX2Nsb25lLiBXYWl0IGZvciBhbnkgZXhpc3RpbmcgYnBmX3NrX3N0b3JhZ2VfY2xvbmUNCj4g
KwkgKiBSQ1UgcmVhZCBzZWN0aW9uIHRvIGZpbmlzaCBiZWZvcmUgcHJvY2VlZGluZy4gTmV3IFJD
VQ0KPiArCSAqIHJlYWQgc2VjdGlvbnMgc2hvdWxkIGJlIHByZXZlbnRlZCB2aWEgYnBmX21hcF9p
bmNfbm90X3plcm8uDQo+ICsJICovDQo+ICAgCXN5bmNocm9uaXplX3JjdSgpOw0KPiAgIA0KPiAg
IAkvKiBicGYgcHJvZyBhbmQgdGhlIHVzZXJzcGFjZSBjYW4gbm8gbG9uZ2VyIGFjY2VzcyB0aGlz
IG1hcA0KPiBAQCAtNjAxLDcgKzYwOCw5IEBAIHN0YXRpYyB2b2lkIGJwZl9za19zdG9yYWdlX21h
cF9mcmVlKHN0cnVjdCBicGZfbWFwICptYXApDQo+ICAgDQo+ICAgc3RhdGljIGludCBicGZfc2tf
c3RvcmFnZV9tYXBfYWxsb2NfY2hlY2sodW5pb24gYnBmX2F0dHIgKmF0dHIpDQo+ICAgew0KPiAt
CWlmIChhdHRyLT5tYXBfZmxhZ3MgIT0gQlBGX0ZfTk9fUFJFQUxMT0MgfHwgYXR0ci0+bWF4X2Vu
dHJpZXMgfHwNCj4gKwlpZiAoYXR0ci0+bWFwX2ZsYWdzICYgflNLX1NUT1JBR0VfQ1JFQVRFX0ZM
QUdfTUFTSyB8fA0KPiArCSAgICAhKGF0dHItPm1hcF9mbGFncyAmIEJQRl9GX05PX1BSRUFMTE9D
KSB8fA0KPiArCSAgICBhdHRyLT5tYXhfZW50cmllcyB8fA0KPiAgIAkgICAgYXR0ci0+a2V5X3Np
emUgIT0gc2l6ZW9mKGludCkgfHwgIWF0dHItPnZhbHVlX3NpemUgfHwNCj4gICAJICAgIC8qIEVu
Zm9yY2UgQlRGIGZvciB1c2Vyc3BhY2Ugc2sgZHVtcGluZyAqLw0KPiAgIAkgICAgIWF0dHItPmJ0
Zl9rZXlfdHlwZV9pZCB8fCAhYXR0ci0+YnRmX3ZhbHVlX3R5cGVfaWQpDQo+IEBAIC03MzksNiAr
NzQ4LDk0IEBAIHN0YXRpYyBpbnQgYnBmX2ZkX3NrX3N0b3JhZ2VfZGVsZXRlX2VsZW0oc3RydWN0
IGJwZl9tYXAgKm1hcCwgdm9pZCAqa2V5KQ0KPiAgIAlyZXR1cm4gZXJyOw0KPiAgIH0NCj4gICAN
Cj4gK3N0YXRpYyBzdHJ1Y3QgYnBmX3NrX3N0b3JhZ2VfZWxlbSAqDQo+ICticGZfc2tfc3RvcmFn
ZV9jbG9uZV9lbGVtKHN0cnVjdCBzb2NrICpuZXdzaywNCj4gKwkJCSAgc3RydWN0IGJwZl9za19z
dG9yYWdlX21hcCAqc21hcCwNCj4gKwkJCSAgc3RydWN0IGJwZl9za19zdG9yYWdlX2VsZW0gKnNl
bGVtKQ0KPiArew0KPiArCXN0cnVjdCBicGZfc2tfc3RvcmFnZV9lbGVtICpjb3B5X3NlbGVtOw0K
PiArDQo+ICsJY29weV9zZWxlbSA9IHNlbGVtX2FsbG9jKHNtYXAsIG5ld3NrLCBOVUxMLCB0cnVl
KTsNCj4gKwlpZiAoIWNvcHlfc2VsZW0pDQo+ICsJCXJldHVybiBOVUxMOw0KPiArDQo+ICsJaWYg
KG1hcF92YWx1ZV9oYXNfc3Bpbl9sb2NrKCZzbWFwLT5tYXApKQ0KPiArCQljb3B5X21hcF92YWx1
ZV9sb2NrZWQoJnNtYXAtPm1hcCwgU0RBVEEoY29weV9zZWxlbSktPmRhdGEsDQo+ICsJCQkJICAg
ICAgU0RBVEEoc2VsZW0pLT5kYXRhLCB0cnVlKTsNCj4gKwllbHNlDQo+ICsJCWNvcHlfbWFwX3Zh
bHVlKCZzbWFwLT5tYXAsIFNEQVRBKGNvcHlfc2VsZW0pLT5kYXRhLA0KPiArCQkJICAgICAgIFNE
QVRBKHNlbGVtKS0+ZGF0YSk7DQo+ICsNCj4gKwlyZXR1cm4gY29weV9zZWxlbTsNCj4gK30NCj4g
Kw0KPiAraW50IGJwZl9za19zdG9yYWdlX2Nsb25lKGNvbnN0IHN0cnVjdCBzb2NrICpzaywgc3Ry
dWN0IHNvY2sgKm5ld3NrKQ0KPiArew0KPiArCXN0cnVjdCBicGZfc2tfc3RvcmFnZSAqbmV3X3Nr
X3N0b3JhZ2UgPSBOVUxMOw0KPiArCXN0cnVjdCBicGZfc2tfc3RvcmFnZSAqc2tfc3RvcmFnZTsN
Cj4gKwlzdHJ1Y3QgYnBmX3NrX3N0b3JhZ2VfZWxlbSAqc2VsZW07DQo+ICsJaW50IHJldDsNCj4g
Kw0KPiArCVJDVV9JTklUX1BPSU5URVIobmV3c2stPnNrX2JwZl9zdG9yYWdlLCBOVUxMKTsNCj4g
Kw0KPiArCXJjdV9yZWFkX2xvY2soKTsNCj4gKwlza19zdG9yYWdlID0gcmN1X2RlcmVmZXJlbmNl
KHNrLT5za19icGZfc3RvcmFnZSk7DQo+ICsNCj4gKwlpZiAoIXNrX3N0b3JhZ2UgfHwgaGxpc3Rf
ZW1wdHkoJnNrX3N0b3JhZ2UtPmxpc3QpKQ0KPiArCQlnb3RvIG91dDsNCj4gKw0KPiArCWhsaXN0
X2Zvcl9lYWNoX2VudHJ5X3JjdShzZWxlbSwgJnNrX3N0b3JhZ2UtPmxpc3QsIHNub2RlKSB7DQo+
ICsJCXN0cnVjdCBicGZfc2tfc3RvcmFnZV9lbGVtICpjb3B5X3NlbGVtOw0KPiArCQlzdHJ1Y3Qg
YnBmX3NrX3N0b3JhZ2VfbWFwICpzbWFwOw0KPiArCQlzdHJ1Y3QgYnBmX21hcCAqbWFwOw0KPiAr
DQo+ICsJCXNtYXAgPSByY3VfZGVyZWZlcmVuY2UoU0RBVEEoc2VsZW0pLT5zbWFwKTsNCj4gKwkJ
aWYgKCEoc21hcC0+bWFwLm1hcF9mbGFncyAmIEJQRl9GX0NMT05FKSkNCj4gKwkJCWNvbnRpbnVl
Ow0KPiArDQo+ICsJCW1hcCA9IGJwZl9tYXBfaW5jX25vdF96ZXJvKCZzbWFwLT5tYXAsIGZhbHNl
KTsNCj4gKwkJaWYgKElTX0VSUihtYXApKQ0KPiArCQkJY29udGludWU7DQo+ICsNCj4gKwkJY29w
eV9zZWxlbSA9IGJwZl9za19zdG9yYWdlX2Nsb25lX2VsZW0obmV3c2ssIHNtYXAsIHNlbGVtKTsN
Cj4gKwkJaWYgKCFjb3B5X3NlbGVtKSB7DQo+ICsJCQlyZXQgPSAtRU5PTUVNOw0KPiArCQkJYnBm
X21hcF9wdXQobWFwKTsNCj4gKwkJCWdvdG8gZXJyOw0KPiArCQl9DQo+ICsNCj4gKwkJaWYgKG5l
d19za19zdG9yYWdlKSB7DQo+ICsJCQlzZWxlbV9saW5rX21hcChzbWFwLCBjb3B5X3NlbGVtKTsN
Cj4gKwkJCV9fc2VsZW1fbGlua19zayhuZXdfc2tfc3RvcmFnZSwgY29weV9zZWxlbSk7DQo+ICsJ
CX0gZWxzZSB7DQo+ICsJCQlyZXQgPSBza19zdG9yYWdlX2FsbG9jKG5ld3NrLCBzbWFwLCBjb3B5
X3NlbGVtKTsNCj4gKwkJCWlmIChyZXQpIHsNCj4gKwkJCQlrZnJlZShjb3B5X3NlbGVtKTsNCj4g
KwkJCQlhdG9taWNfc3ViKHNtYXAtPmVsZW1fc2l6ZSwNCj4gKwkJCQkJICAgJm5ld3NrLT5za19v
bWVtX2FsbG9jKTsNCj4gKwkJCQlicGZfbWFwX3B1dChtYXApOw0KPiArCQkJCWdvdG8gZXJyOw0K
PiArCQkJfQ0KPiArDQo+ICsJCQluZXdfc2tfc3RvcmFnZSA9IHJjdV9kZXJlZmVyZW5jZShjb3B5
X3NlbGVtLT5za19zdG9yYWdlKTsNCj4gKwkJfQ0KPiArCQlicGZfbWFwX3B1dChtYXApOw0KPiAr
CX0NCj4gKw0KPiArb3V0Og0KPiArCXJjdV9yZWFkX3VubG9jaygpOw0KPiArCXJldHVybiAwOw0K
PiArDQo+ICtlcnI6DQo+ICsJcmN1X3JlYWRfdW5sb2NrKCk7DQo+ICsNCj4gKwkvKiBEb24ndCBm
cmVlIGFueXRoaW5nIGV4cGxpY2l0bHkgaGVyZSwgY2FsbGVyIGlzIHJlc3BvbnNpYmxlIHRvDQo+
ICsJICogY2FsbCBicGZfc2tfc3RvcmFnZV9mcmVlIGluIGNhc2Ugb2YgYW4gZXJyb3IuDQo+ICsJ
ICovDQo+ICsNCj4gKwlyZXR1cm4gcmV0Ow0KDQpBIG5pdC4NCklmIHlvdSBzZXQgcmV0ID0gMCBp
bml0aWFsbHksIHlvdSBkbyBub3QgbmVlZCB0aGUgYWJvdmUgdHdvIA0KcmN1X3JlYWRfdW5sb2Nr
KCkuIE9uZSAicmV0dXJuIHJldCIgc2hvdWxkIGJlIGVub3VnaC4NClRoZSBjb21tZW50IGNhbiBi
ZSBjaGFuZ2VkIHRvDQoJLyogSW4gY2FzZSBvZiBhbiBlcnJvciwgLi4uICovDQoNCg0KPiArfQ0K
PiArDQo+ICAgQlBGX0NBTExfNChicGZfc2tfc3RvcmFnZV9nZXQsIHN0cnVjdCBicGZfbWFwICos
IG1hcCwgc3RydWN0IHNvY2sgKiwgc2ssDQo+ICAgCSAgIHZvaWQgKiwgdmFsdWUsIHU2NCwgZmxh
Z3MpDQo+ICAgew0KPiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvc29jay5jIGIvbmV0L2NvcmUvc29j
ay5jDQo+IGluZGV4IGQ1N2IwY2M5OTVhMC4uZjVlODAxYTljZWE0IDEwMDY0NA0KPiAtLS0gYS9u
ZXQvY29yZS9zb2NrLmMNCj4gKysrIGIvbmV0L2NvcmUvc29jay5jDQo+IEBAIC0xODUxLDkgKzE4
NTEsMTIgQEAgc3RydWN0IHNvY2sgKnNrX2Nsb25lX2xvY2soY29uc3Qgc3RydWN0IHNvY2sgKnNr
LCBjb25zdCBnZnBfdCBwcmlvcml0eSkNCj4gICAJCQlnb3RvIG91dDsNCj4gICAJCX0NCj4gICAJ
CVJDVV9JTklUX1BPSU5URVIobmV3c2stPnNrX3JldXNlcG9ydF9jYiwgTlVMTCk7DQo+IC0jaWZk
ZWYgQ09ORklHX0JQRl9TWVNDQUxMDQo+IC0JCVJDVV9JTklUX1BPSU5URVIobmV3c2stPnNrX2Jw
Zl9zdG9yYWdlLCBOVUxMKTsNCj4gLSNlbmRpZg0KPiArDQo+ICsJCWlmIChicGZfc2tfc3RvcmFn
ZV9jbG9uZShzaywgbmV3c2spKSB7DQo+ICsJCQlza19mcmVlX3VubG9ja19jbG9uZShuZXdzayk7
DQo+ICsJCQluZXdzayA9IE5VTEw7DQo+ICsJCQlnb3RvIG91dDsNCj4gKwkJfQ0KPiAgIA0KPiAg
IAkJbmV3c2stPnNrX2VycgkgICA9IDA7DQo+ICAgCQluZXdzay0+c2tfZXJyX3NvZnQgPSAwOw0K
PiANCg==
