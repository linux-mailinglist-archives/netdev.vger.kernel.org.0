Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035985E710
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfGCOqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:46:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62848 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbfGCOqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 10:46:35 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x63EjAQh020649;
        Wed, 3 Jul 2019 07:45:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=h1V9q7DaahqcccHrTmqwibHb7E/QjD6twdXS2g6QPoc=;
 b=eJO3HlFPIa+2sgGE3ZslzQKE51FWx4Xq8A8pUjWu90kei26w92KJh9hSZ4L/7y4kSewq
 0QQxSWpA5Bw7+90M6Ls9/PIydLJR2khJQUa4ssQOxneAlr0IU1L4DE0UAMnyO6MYvqON
 4Q49Vp6VtpQhZKVNGtbXvHoDachhl9Q1Bhs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tgx97r15g-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 03 Jul 2019 07:45:18 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 3 Jul 2019 07:45:15 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 3 Jul 2019 07:45:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1V9q7DaahqcccHrTmqwibHb7E/QjD6twdXS2g6QPoc=;
 b=Agz0pbNtj+EYe+x2C7mbKNLfU+HkPYk/xlwA648YLtBecQFLX2P1k1E2ffF5y98kOPlh64sO+VqkTkUcZp8tpN/usOidzznjTM0hC5eHlGcyTZuOk73DL5x1n/Dh/ewER25ruIeYi6ktna8xI0G7gQYU7MtYSouLUO53L7dEi5s=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2760.namprd15.prod.outlook.com (20.179.157.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 14:45:14 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 14:45:14 +0000
From:   Yonghong Song <yhs@fb.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "sdf@google.com" <sdf@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next] bpf: cgroup: Fix build error without
 CONFIG_NET
Thread-Topic: [PATCH v2 bpf-next] bpf: cgroup: Fix build error without
 CONFIG_NET
Thread-Index: AQHVMXkXQoxgo9ALIE+aMv0k9OvhfKa4+N2A
Date:   Wed, 3 Jul 2019 14:45:14 +0000
Message-ID: <4a81ed32-1e60-dee2-eb67-df0930dbcbf6@fb.com>
References: <fd312c26-db8e-cae3-1c14-869d8e3a62ae@fb.com>
 <20190703082630.51104-1-yuehaibing@huawei.com>
In-Reply-To: <20190703082630.51104-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR10CA0008.namprd10.prod.outlook.com (2603:10b6:301::18)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:fb73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5cf30e31-ae5c-40ba-2ceb-08d6ffc50e9f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2760;
x-ms-traffictypediagnostic: BYAPR15MB2760:
x-microsoft-antispam-prvs: <BYAPR15MB27606463688C505FC0D42A7ED3FB0@BYAPR15MB2760.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:167;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(396003)(376002)(39860400002)(199004)(189003)(66446008)(73956011)(66556008)(6436002)(64756008)(476003)(2616005)(66946007)(31696002)(66476007)(36756003)(71190400001)(5024004)(386003)(2201001)(7736002)(14444005)(8936002)(446003)(486006)(256004)(31686004)(5660300002)(11346002)(2501003)(71200400001)(102836004)(2906002)(305945005)(86362001)(46003)(53936002)(68736007)(316002)(54906003)(478600001)(6116002)(99286004)(25786009)(6246003)(4326008)(52116002)(6512007)(6486002)(81166006)(81156014)(110136005)(76176011)(53546011)(229853002)(8676002)(186003)(6506007)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2760;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: o3KA3mubcUAPybgl6cQyKqGoEWamHGp1L3tA9jD6lPnGpCHGLhqcBD2xki3kQI/r9Rms9iUHddaPyenjdnY2M+yBh0VzdczEzc6BZouAjuJvzK1BB53aFrC0pwQFWR9mC+2/MDQOPToSk3fC2lFq2GiOVVWulph7ddxSoj9rgSiK6kKc1HS6SMe/jtwD/oiMwm1IgHSKVZUxOetaFgT+pAgNkoy9b0qcq3LvVHNpIeZ9vJ1GWWgk2h7UNwkDRUS6sc2u6pxXOzoASGtMuh49uEOQSS8bO1QjaH9B4e+cfVeVLF6gNcBMygIfjZnJMK7AEBkW6ia+KbygrAqhG4ZgMuN0fUPrF0QGh975RUCTzlqt1YAg4EmlnkvlIhCpYZgFJ/58AigM+f389hTUEDnlw8SF1MqH+ONWBsNSssHqtpg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A28F7E840033D541938F3BE4C6C643A9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf30e31-ae5c-40ba-2ceb-08d6ffc50e9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 14:45:14.3064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2760
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907030181
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMy8xOSAxOjI2IEFNLCBZdWVIYWliaW5nIHdyb3RlOg0KPiBJZiBDT05GSUdfTkVU
IGlzIG5vdCBzZXQgYW5kIENPTkZJR19DR1JPVVBfQlBGPXksDQo+IGdjYyBidWlsZGluZyBmYWls
czoNCj4gDQo+IGtlcm5lbC9icGYvY2dyb3VwLm86IEluIGZ1bmN0aW9uIGBjZ19zb2Nrb3B0X2Z1
bmNfcHJvdG8nOg0KPiBjZ3JvdXAuYzooLnRleHQrMHgyMzdlKTogdW5kZWZpbmVkIHJlZmVyZW5j
ZSB0byBgYnBmX3NrX3N0b3JhZ2VfZ2V0X3Byb3RvJw0KPiBjZ3JvdXAuYzooLnRleHQrMHgyMzk0
KTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgYnBmX3NrX3N0b3JhZ2VfZGVsZXRlX3Byb3RvJw0K
PiBrZXJuZWwvYnBmL2Nncm91cC5vOiBJbiBmdW5jdGlvbiBgX19jZ3JvdXBfYnBmX3J1bl9maWx0
ZXJfZ2V0c29ja29wdCc6DQo+ICgudGV4dCsweDJhMWYpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRv
IGBsb2NrX3NvY2tfbmVzdGVkJw0KPiAoLnRleHQrMHgyY2EyKTogdW5kZWZpbmVkIHJlZmVyZW5j
ZSB0byBgcmVsZWFzZV9zb2NrJw0KPiBrZXJuZWwvYnBmL2Nncm91cC5vOiBJbiBmdW5jdGlvbiBg
X19jZ3JvdXBfYnBmX3J1bl9maWx0ZXJfc2V0c29ja29wdCc6DQo+ICgudGV4dCsweDMwMDYpOiB1
bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBsb2NrX3NvY2tfbmVzdGVkJw0KPiAoLnRleHQrMHgzMmJi
KTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgcmVsZWFzZV9zb2NrJw0KPiANCj4gUmVwb3J0ZWQt
Ynk6IEh1bGsgUm9ib3QgPGh1bGtjaUBodWF3ZWkuY29tPg0KPiBTdWdnZXN0ZWQtYnk6IFN0YW5p
c2xhdiBGb21pY2hldiA8c2RmQGZvbWljaGV2Lm1lPg0KPiBGaXhlczogMGQwMWRhNmFmYzU0ICgi
YnBmOiBpbXBsZW1lbnQgZ2V0c29ja29wdCBhbmQgc2V0c29ja29wdCBob29rcyIpDQo+IFNpZ25l
ZC1vZmYtYnk6IFl1ZUhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4NCg0KQWNrZWQtYnk6
IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQoNCj4gLS0tDQo+IHYyOiB1c2UgaWZkZWYgbWFj
cm8NCj4gLS0tDQo+ICAga2VybmVsL2JwZi9jZ3JvdXAuYyB8IDQgKysrKw0KPiAgIDEgZmlsZSBj
aGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9rZXJuZWwvYnBmL2Nn
cm91cC5jIGIva2VybmVsL2JwZi9jZ3JvdXAuYw0KPiBpbmRleCA3NmZhMDA3Li4wYTAwZWFjIDEw
MDY0NA0KPiAtLS0gYS9rZXJuZWwvYnBmL2Nncm91cC5jDQo+ICsrKyBiL2tlcm5lbC9icGYvY2dy
b3VwLmMNCj4gQEAgLTkzOSw2ICs5MzksNyBAQCBpbnQgX19jZ3JvdXBfYnBmX3J1bl9maWx0ZXJf
c3lzY3RsKHN0cnVjdCBjdGxfdGFibGVfaGVhZGVyICpoZWFkLA0KPiAgIH0NCj4gICBFWFBPUlRf
U1lNQk9MKF9fY2dyb3VwX2JwZl9ydW5fZmlsdGVyX3N5c2N0bCk7DQo+ICAgDQo+ICsjaWZkZWYg
Q09ORklHX05FVA0KPiAgIHN0YXRpYyBib29sIF9fY2dyb3VwX2JwZl9wcm9nX2FycmF5X2lzX2Vt
cHR5KHN0cnVjdCBjZ3JvdXAgKmNncnAsDQo+ICAgCQkJCQkgICAgIGVudW0gYnBmX2F0dGFjaF90
eXBlIGF0dGFjaF90eXBlKQ0KPiAgIHsNCj4gQEAgLTExMjAsNiArMTEyMSw3IEBAIGludCBfX2Nn
cm91cF9icGZfcnVuX2ZpbHRlcl9nZXRzb2Nrb3B0KHN0cnVjdCBzb2NrICpzaywgaW50IGxldmVs
LA0KPiAgIAlyZXR1cm4gcmV0Ow0KPiAgIH0NCj4gICBFWFBPUlRfU1lNQk9MKF9fY2dyb3VwX2Jw
Zl9ydW5fZmlsdGVyX2dldHNvY2tvcHQpOw0KPiArI2VuZGlmDQo+ICAgDQo+ICAgc3RhdGljIHNz
aXplX3Qgc3lzY3RsX2NweV9kaXIoY29uc3Qgc3RydWN0IGN0bF9kaXIgKmRpciwgY2hhciAqKmJ1
ZnAsDQo+ICAgCQkJICAgICAgc2l6ZV90ICpsZW5wKQ0KPiBAQCAtMTM4NiwxMCArMTM4OCwxMiBA
QCBzdGF0aWMgY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvICoNCj4gICBjZ19zb2Nrb3B0X2Z1
bmNfcHJvdG8oZW51bSBicGZfZnVuY19pZCBmdW5jX2lkLCBjb25zdCBzdHJ1Y3QgYnBmX3Byb2cg
KnByb2cpDQo+ICAgew0KPiAgIAlzd2l0Y2ggKGZ1bmNfaWQpIHsNCj4gKyNpZmRlZiBDT05GSUdf
TkVUDQo+ICAgCWNhc2UgQlBGX0ZVTkNfc2tfc3RvcmFnZV9nZXQ6DQo+ICAgCQlyZXR1cm4gJmJw
Zl9za19zdG9yYWdlX2dldF9wcm90bzsNCj4gICAJY2FzZSBCUEZfRlVOQ19za19zdG9yYWdlX2Rl
bGV0ZToNCj4gICAJCXJldHVybiAmYnBmX3NrX3N0b3JhZ2VfZGVsZXRlX3Byb3RvOw0KPiArI2Vu
ZGlmDQo+ICAgI2lmZGVmIENPTkZJR19JTkVUDQo+ICAgCWNhc2UgQlBGX0ZVTkNfdGNwX3NvY2s6
DQo+ICAgCQlyZXR1cm4gJmJwZl90Y3Bfc29ja19wcm90bzsNCj4gDQo=
