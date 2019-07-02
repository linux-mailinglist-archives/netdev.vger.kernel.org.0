Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E585D3DF
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfGBQGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:06:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49652 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbfGBQGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:06:19 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62G2cFo000685;
        Tue, 2 Jul 2019 09:05:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ceIs7ufevcskO0a/QJ8mUbTE1BpxpTsoEiZaH+2D1bY=;
 b=YnguqG9f9nzwJSpjd9HkNfL01A+O3tGgYdREb7IvRS5NieK8FUtmFSER6dq7FBQKEdL2
 TV9IVP6h4EkgqujwgNtBpcv9dZEbPRB5oK5aKqa/BQSahkfavQmD1sH0i+UOPDniF+wn
 DwDTB3Y1lsqjxQqnvUuQ6vzswBjgZzWITqQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tg7hv0q0k-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 09:05:09 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 2 Jul 2019 09:04:57 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 2 Jul 2019 09:04:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=ilYYvh8b8gw7ixiofes3OUrAj0Ut0fwErX1lDzuqyl+Q27JCu5oSH7Zefzxpg3H6uzsmTpOJeJJicTrEaYKlpc3funRxH8hMUlOvfr9zxRnaB185YYjnnJ0amB26fCf2XnTLJzmOWXb3rHfZV7zje9EDZeh5KQGEd0WNV7b40zQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceIs7ufevcskO0a/QJ8mUbTE1BpxpTsoEiZaH+2D1bY=;
 b=vX6a/ewBhUD2p/nxHik5GZiOhDgqqeuE6AT8oi3hQQFBFzw3L4JHvs/T2IkiwBAbHK/Am78o1icT4VmQBMCfhNCGwzSSu8RSAznIAghaf9eMgQZWuqiJYAlVl20B9zN/lipVaLQ3Tb4CnpJfk+SNrPB/AaeTG8YrKAoZ7RrDpsI=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceIs7ufevcskO0a/QJ8mUbTE1BpxpTsoEiZaH+2D1bY=;
 b=UxZ3quuyDc3tWP1P+xXDRWW/z/FXcEVnSiwHQFUjNGEIun37RxaYMWnc1USkeVfihDhtgvzyyWsDZxAS2PDI0wj4rHUjrRUgtBC2dqJsbxKcba1/fCha4cfXdgB/ebgC7txoMLoU+mlgrPCyuxtgYDjImDXGTowPg64Qz497HsI=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2438.namprd15.prod.outlook.com (52.135.198.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 2 Jul 2019 16:04:55 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 16:04:55 +0000
From:   Yonghong Song <yhs@fb.com>
To:     YueHaibing <yuehaibing@huawei.com>
CC:     Stanislav Fomichev <sdf@fomichev.me>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "sdf@google.com" <sdf@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: cgroup: Fix build error without CONFIG_NET
Thread-Topic: [PATCH bpf-next] bpf: cgroup: Fix build error without CONFIG_NET
Thread-Index: AQHVMNo5OI4ru0GJ7k2XomHdGmFYp6a3etEAgAADPgA=
Date:   Tue, 2 Jul 2019 16:04:55 +0000
Message-ID: <fd312c26-db8e-cae3-1c14-869d8e3a62ae@fb.com>
References: <20190702132913.26060-1-yuehaibing@huawei.com>
 <20190702155316.GJ6757@mini-arch>
In-Reply-To: <20190702155316.GJ6757@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0040.namprd12.prod.outlook.com
 (2603:10b6:301:2::26) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:8eae]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a1427fa-e550-46ac-7d06-08d6ff0705ff
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2438;
x-ms-traffictypediagnostic: BYAPR15MB2438:
x-microsoft-antispam-prvs: <BYAPR15MB2438423E2013F006AC319067D3F80@BYAPR15MB2438.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(396003)(39860400002)(366004)(189003)(199004)(4326008)(66476007)(64756008)(316002)(66446008)(8676002)(25786009)(73956011)(476003)(66946007)(81156014)(54906003)(8936002)(6512007)(2616005)(81166006)(486006)(11346002)(305945005)(66556008)(446003)(5660300002)(71200400001)(53936002)(46003)(6436002)(7736002)(71190400001)(229853002)(14444005)(478600001)(14454004)(186003)(86362001)(102836004)(386003)(31686004)(53546011)(76176011)(99286004)(6506007)(256004)(5024004)(36756003)(52116002)(6486002)(31696002)(6916009)(6116002)(68736007)(2906002)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2438;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HRzP11pngLoJKqFZZj2DRch991rH33wDSJgnqQxfzzCmjo4bEjpQBtSmFZfkC727DSbBCOxp6M7xSleJrRKSKpWrLUNKcSX0TzBJedKn8QsOUPWM1T6ry7mOPe2JWS6VnRLKM+Tw3C4Hbvtrn5p6dhxhixBX7U/46SyIZ6bScL2CcvHxZCLDjyDelsj9IKx9ZHOFOK9wqZJHNksjBy6ldrtRumr/gCQML2Ut0OXkZDJBcSNQ7YCglmx9y5ksyqhNy2m1zuEphW+TRvE/+QIzwTrdVNXzI+s3MMBeS8dWtd1Wj44DKrNOSHlxiQaQoCe0TceSxq0WitRmgf5NkWO29I1MLRtuyP8GzEsZvk4zFbPiYhOURHGEmsUbVm0ixr1f9EfFr0UtKP1O7qOY43DUu11SJzKkh9TKuwDtxvEp2K8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD99E8EF6AB50D4F8F56F76D98F33CB8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1427fa-e550-46ac-7d06-08d6ff0705ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 16:04:55.2486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2438
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMi8xOSA4OjUzIEFNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+IE9uIDA3
LzAyLCBZdWVIYWliaW5nIHdyb3RlOg0KPj4gSWYgQ09ORklHX05FVCBpcyBub3Qgc2V0LCBnY2Mg
YnVpbGRpbmcgZmFpbHM6DQo+Pg0KPj4ga2VybmVsL2JwZi9jZ3JvdXAubzogSW4gZnVuY3Rpb24g
YGNnX3NvY2tvcHRfZnVuY19wcm90byc6DQo+PiBjZ3JvdXAuYzooLnRleHQrMHgyMzdlKTogdW5k
ZWZpbmVkIHJlZmVyZW5jZSB0byBgYnBmX3NrX3N0b3JhZ2VfZ2V0X3Byb3RvJw0KPj4gY2dyb3Vw
LmM6KC50ZXh0KzB4MjM5NCk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8gYGJwZl9za19zdG9yYWdl
X2RlbGV0ZV9wcm90bycNCj4+IGtlcm5lbC9icGYvY2dyb3VwLm86IEluIGZ1bmN0aW9uIGBfX2Nn
cm91cF9icGZfcnVuX2ZpbHRlcl9nZXRzb2Nrb3B0JzoNCj4+ICgudGV4dCsweDJhMWYpOiB1bmRl
ZmluZWQgcmVmZXJlbmNlIHRvIGBsb2NrX3NvY2tfbmVzdGVkJw0KPj4gKC50ZXh0KzB4MmNhMik6
IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8gYHJlbGVhc2Vfc29jaycNCj4+IGtlcm5lbC9icGYvY2dy
b3VwLm86IEluIGZ1bmN0aW9uIGBfX2Nncm91cF9icGZfcnVuX2ZpbHRlcl9zZXRzb2Nrb3B0JzoN
Cj4+ICgudGV4dCsweDMwMDYpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBsb2NrX3NvY2tfbmVz
dGVkJw0KPj4gKC50ZXh0KzB4MzJiYik6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8gYHJlbGVhc2Vf
c29jaycNCj4+DQo+PiBBZGQgQ09ORklHX05FVCBkZXBlbmRlbmN5IHRvIGZpeCB0aGlzLg0KPiBD
YW4geW91IHNoYXJlIHRoZSBjb25maWc/IERvIEkgdW5kZXJzdGFuZCBjb3JyZWN0bHkgdGhhdCB5
b3UgaGF2ZQ0KPiBDT05GSUdfTkVUPW4gYW5kIENPTkZJR19CUEY9eT8gV2hhdCBwYXJ0cyBvZiBC
UEYgZG8geW91IGV4cGVjdCB0bw0KPiB3b3JrIGluIHRoaXMgY2FzZT8NCj4gDQo+IExlc3MgaW52
YXNpdmUgZml4IHdvdWxkIGJlIHNvbWV0aGluZyBhbG9uZyB0aGUgbGluZXM6DQo+IA0KPiBkaWZm
IC0tZ2l0IGEva2VybmVsL2JwZi9jZ3JvdXAuYyBiL2tlcm5lbC9icGYvY2dyb3VwLmMNCj4gaW5k
ZXggNzZmYTAwNzZmMjBkLi4wYTAwZWFjYTZmYWUgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9icGYv
Y2dyb3VwLmMNCj4gKysrIGIva2VybmVsL2JwZi9jZ3JvdXAuYw0KPiBAQCAtOTM5LDYgKzkzOSw3
IEBAIGludCBfX2Nncm91cF9icGZfcnVuX2ZpbHRlcl9zeXNjdGwoc3RydWN0IGN0bF90YWJsZV9o
ZWFkZXIgKmhlYWQsDQo+ICAgfQ0KPiAgIEVYUE9SVF9TWU1CT0woX19jZ3JvdXBfYnBmX3J1bl9m
aWx0ZXJfc3lzY3RsKTsNCj4gICANCj4gKyNpZmRlZiBDT05GSUdfTkVUDQo+ICAgc3RhdGljIGJv
b2wgX19jZ3JvdXBfYnBmX3Byb2dfYXJyYXlfaXNfZW1wdHkoc3RydWN0IGNncm91cCAqY2dycCwN
Cj4gICAJCQkJCSAgICAgZW51bSBicGZfYXR0YWNoX3R5cGUgYXR0YWNoX3R5cGUpDQo+ICAgew0K
PiBAQCAtMTEyMCw2ICsxMTIxLDcgQEAgaW50IF9fY2dyb3VwX2JwZl9ydW5fZmlsdGVyX2dldHNv
Y2tvcHQoc3RydWN0IHNvY2sgKnNrLCBpbnQgbGV2ZWwsDQo+ICAgCXJldHVybiByZXQ7DQo+ICAg
fQ0KPiAgIEVYUE9SVF9TWU1CT0woX19jZ3JvdXBfYnBmX3J1bl9maWx0ZXJfZ2V0c29ja29wdCk7
DQo+ICsjZW5kaWYNCj4gICANCj4gICBzdGF0aWMgc3NpemVfdCBzeXNjdGxfY3B5X2Rpcihjb25z
dCBzdHJ1Y3QgY3RsX2RpciAqZGlyLCBjaGFyICoqYnVmcCwNCj4gICAJCQkgICAgICBzaXplX3Qg
KmxlbnApDQo+IEBAIC0xMzg2LDEwICsxMzg4LDEyIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYnBm
X2Z1bmNfcHJvdG8gKg0KPiAgIGNnX3NvY2tvcHRfZnVuY19wcm90byhlbnVtIGJwZl9mdW5jX2lk
IGZ1bmNfaWQsIGNvbnN0IHN0cnVjdCBicGZfcHJvZyAqcHJvZykNCj4gICB7DQo+ICAgCXN3aXRj
aCAoZnVuY19pZCkgew0KPiArI2lmZGVmIENPTkZJR19ORVQNCj4gICAJY2FzZSBCUEZfRlVOQ19z
a19zdG9yYWdlX2dldDoNCj4gICAJCXJldHVybiAmYnBmX3NrX3N0b3JhZ2VfZ2V0X3Byb3RvOw0K
PiAgIAljYXNlIEJQRl9GVU5DX3NrX3N0b3JhZ2VfZGVsZXRlOg0KPiAgIAkJcmV0dXJuICZicGZf
c2tfc3RvcmFnZV9kZWxldGVfcHJvdG87DQo+ICsjZW5kaWYNCj4gICAjaWZkZWYgQ09ORklHX0lO
RVQNCj4gICAJY2FzZSBCUEZfRlVOQ190Y3Bfc29jazoNCj4gICAJCXJldHVybiAmYnBmX3RjcF9z
b2NrX3Byb3RvOw0KDQpBaC4gSnVzdCBzZW5kIGFub3RoZXIgZW1haWwgd2l0aG91dCBjaGVja2lu
ZyBpbmJveC4NCkxvb2tzIGxpa2UgdGhlIGFib3ZlIGNoYW5nZSBpcyBwcmVmZXJyZWQuDQpZdWVI
YWliaW5nLCBjb3VsZCB5b3UgbWFrZSBjaGFuZ2UgYW5kIHJlc3VibWl0IHlvdXIgcGF0Y2g/DQoN
Cj4gDQo+PiBSZXBvcnRlZC1ieTogSHVsayBSb2JvdCA8aHVsa2NpQGh1YXdlaS5jb20+DQo+PiBG
aXhlczogMGQwMWRhNmFmYzU0ICgiYnBmOiBpbXBsZW1lbnQgZ2V0c29ja29wdCBhbmQgc2V0c29j
a29wdCBob29rcyIpDQo+PiBTaWduZWQtb2ZmLWJ5OiBZdWVIYWliaW5nIDx5dWVoYWliaW5nQGh1
YXdlaS5jb20+DQo+PiAtLS0NCj4+ICAgaW5pdC9LY29uZmlnIHwgMSArDQo+PiAgIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9pbml0L0tjb25maWcg
Yi9pbml0L0tjb25maWcNCj4+IGluZGV4IGUyZTUxYjUuLjM0MWNmMmEgMTAwNjQ0DQo+PiAtLS0g
YS9pbml0L0tjb25maWcNCj4+ICsrKyBiL2luaXQvS2NvbmZpZw0KPj4gQEAgLTk5OCw2ICs5OTgs
NyBAQCBjb25maWcgQ0dST1VQX1BFUkYNCj4+ICAgY29uZmlnIENHUk9VUF9CUEYNCj4+ICAgCWJv
b2wgIlN1cHBvcnQgZm9yIGVCUEYgcHJvZ3JhbXMgYXR0YWNoZWQgdG8gY2dyb3VwcyINCj4+ICAg
CWRlcGVuZHMgb24gQlBGX1NZU0NBTEwNCj4+ICsJZGVwZW5kcyBvbiBORVQNCj4+ICAgCXNlbGVj
dCBTT0NLX0NHUk9VUF9EQVRBDQo+PiAgIAloZWxwDQo+PiAgIAkgIEFsbG93IGF0dGFjaGluZyBl
QlBGIHByb2dyYW1zIHRvIGEgY2dyb3VwIHVzaW5nIHRoZSBicGYoMikNCj4+IC0tIA0KPj4gMi43
LjQNCj4+DQo+Pg0K
