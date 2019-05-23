Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD78A28D97
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 01:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388137AbfEWXGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 19:06:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56278 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387725AbfEWXGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 19:06:20 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4NN3Nxi006423;
        Thu, 23 May 2019 16:06:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=phIreuEgZGB7hQWiDfT5EjSzPgXajjPLmKUroPJW/3o=;
 b=i8PEXjCTErOrFLbO0ALMQ0L7wXcHg3OD4nWtbBXeBZdK3pZNyQcZ2V0EA7lamYXMu3v9
 3Pjgob4yxCL5qIJBb3yYinLylsDLWXYKN7avV2eXZAwkBCYC9M5OsBY3OIu00D/z0ccu
 xxIWpGg+4YYhJsxU/QwGEJ+xOzk6r7VVSzQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2sp3gm89eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 May 2019 16:06:06 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 May 2019 16:06:05 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 May 2019 16:06:05 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 23 May 2019 16:06:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phIreuEgZGB7hQWiDfT5EjSzPgXajjPLmKUroPJW/3o=;
 b=M3OmUr98ek40/t9N6LlZebmgfWE530LBmu3qBg7KiP+NIuatCTImUALCF80GgyRMR+EZFr08P871ouMbStX+VVNFBUizMIn5xfUyw/vbDZIYj8U+xrfum+DPq/+LTY8ESux4TCt+FxWjuvvdh4NKPKhjDs/A6VqejIa5RWp8MYU=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2247.namprd15.prod.outlook.com (52.135.197.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 23 May 2019 23:06:03 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 23:06:03 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Topic: [PATCH v2 bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Index: AQHVEPUtUUkH/nhO2UeBDfLyvw3JgKZ4NA4AgADMVQCAAFXeAA==
Date:   Thu, 23 May 2019 23:06:02 +0000
Message-ID: <5a44b791-899b-5638-4c75-235a31a0cb4d@fb.com>
References: <20190522232051.2938491-1-guro@fb.com>
 <20190522232051.2938491-5-guro@fb.com>
 <f7953267-8559-2f58-f39a-b2b0c3bf2e38@fb.com>
 <20190523175833.GA7107@tower.DHCP.thefacebook.com>
In-Reply-To: <20190523175833.GA7107@tower.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0067.namprd02.prod.outlook.com
 (2603:10b6:a03:54::44) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::d011]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c502961f-2783-4dcc-e7d3-08d6dfd33a31
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2247;
x-ms-traffictypediagnostic: BYAPR15MB2247:
x-microsoft-antispam-prvs: <BYAPR15MB2247192229D6313D1E8FBAE3D3010@BYAPR15MB2247.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(366004)(346002)(136003)(189003)(199004)(478600001)(6636002)(25786009)(6862004)(4326008)(102836004)(31686004)(14454004)(229853002)(6116002)(37006003)(2906002)(5660300002)(316002)(68736007)(6506007)(6512007)(66946007)(73956011)(53546011)(31696002)(86362001)(6486002)(66476007)(386003)(66446008)(66556008)(64756008)(54906003)(36756003)(6436002)(486006)(256004)(46003)(5024004)(99286004)(14444005)(446003)(71190400001)(71200400001)(186003)(53936002)(76176011)(305945005)(7736002)(52116002)(2616005)(81156014)(476003)(11346002)(8676002)(81166006)(8936002)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2247;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jBckefJ74sVsi0NXxXtCKUIXUnIoE9k6R8wKjsEnEM+SOaVAllSoUlqNdBPfyEUn5l5g2tS1Q/HUjfH3c2y6K+/mJzaHRpSPuBh4qlxgIVPl5pssiAoB5wvj8TnKZLn9qJB2SRgrV/5i1lBAJcL3ZLCWOLxX/7CkL04oAABX35Rmk44D3ivA784T0yWd9ofdqRK1hZ4wqe1n86UZCNHzE/lpOt7qzvewiDElkkZBQ0xCN7Jw7DBcEBpQkjlzE72/uMs/2HMr1Md1TO5CQoLjfV4TaO6yPBYKKyuVu5h2RYdKxUrvzXHFBCk3kFakIxBeobH+OMD8KR2U9txZtXrHLoYrw5ZYjDTeSHlOKofJAgZoM8ktwz5v0HGTqDhq+nV8PXyoS2YfX/woMDDfhiHjFUtVFtJiBJMPff3iLfvq0a0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15E0BB2E1DBFAF4DB4358347764A8F5A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c502961f-2783-4dcc-e7d3-08d6dfd33a31
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 23:06:03.0574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2247
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_17:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjMvMTkgMTA6NTggQU0sIFJvbWFuIEd1c2hjaGluIHdyb3RlOg0KPiBPbiBXZWQs
IE1heSAyMiwgMjAxOSBhdCAxMDo0NzoyNFBNIC0wNzAwLCBZb25naG9uZyBTb25nIHdyb3RlOg0K
Pj4NCj4+DQo+PiBPbiA1LzIyLzE5IDQ6MjAgUE0sIFJvbWFuIEd1c2hjaGluIHdyb3RlOg0KPj4+
IEFkZCBhIGtzZWxmdGVzdCB0byBjb3ZlciBicGYgYXV0by1kZXRhY2htZW50IGZ1bmN0aW9uYWxp
dHkuDQo+Pj4gVGhlIHRlc3QgY3JlYXRlcyBhIGNncm91cCwgYXNzb2NpYXRlcyBzb21lIHJlc291
cmNlcyB3aXRoIGl0LA0KPj4+IGF0dGFjaGVzIGEgY291cGxlIG9mIGJwZiBwcm9ncmFtcyBhbmQg
ZGVsZXRlcyB0aGUgY2dyb3VwLg0KPj4+DQo+Pj4gVGhlbiBpdCBjaGVja3MgdGhhdCBicGYgcHJv
Z3JhbXMgYXJlIGdvaW5nIGF3YXkgaW4gNSBzZWNvbmRzLg0KPj4+DQo+Pj4gRXhwZWN0ZWQgb3V0
cHV0Og0KPj4+ICAgICAkIC4vdGVzdF9jZ3JvdXBfYXR0YWNoDQo+Pj4gICAgICNvdmVycmlkZTpQ
QVNTDQo+Pj4gICAgICNtdWx0aTpQQVNTDQo+Pj4gICAgICNhdXRvZGV0YWNoOlBBU1MNCj4+PiAg
ICAgdGVzdF9jZ3JvdXBfYXR0YWNoOlBBU1MNCj4+Pg0KPj4+IE9uIGEga2VybmVsIHdpdGhvdXQg
YXV0by1kZXRhY2hpbmc6DQo+Pj4gICAgICQgLi90ZXN0X2Nncm91cF9hdHRhY2gNCj4+PiAgICAg
I292ZXJyaWRlOlBBU1MNCj4+PiAgICAgI211bHRpOlBBU1MNCj4+PiAgICAgI2F1dG9kZXRhY2g6
RkFJTA0KPj4+ICAgICB0ZXN0X2Nncm91cF9hdHRhY2g6RkFJTA0KPj4NCj4+IEkgcmFuIHRoaXMg
cHJvYmxlbSB3aXRob3V0IGJvdGggb2xkIGFuZCBuZXcga2VybmVscyBhbmQNCj4+IGJvdGggZ2V0
IGFsbCBQQVNTZXMuIE15IHRlc3RpbmcgZW52aXJvbm1lbnQgaXMgYSBWTS4NCj4+IENvdWxkIHlv
dSBzcGVjaWZ5IGhvdyB0byB0cmlnZ2VyIHRoZSBhYm92ZSBmYWlsdXJlPw0KPiANCj4gTW9zdCBs
aWtlbHkgeW91J3JlIHJ1bm5pbmcgY2dyb3VwIHYxLCBzbyB0aGUgbWVtb3J5IGNvbnRyb2xsZXIN
Cj4gaXMgbm90IGVuYWJsZWQgb24gdW5pZmllZCBoaWVyYXJjaHkuIFlvdSBuZWVkIHRvIHBhc3MN
Cj4gImNncm91cF9ub192MT1hbGwgc3lzdGVtZC51bmlmaWVkX2Nncm91cF9oaWVyYXJjaHk9MSIN
Cj4gYXMgYm9vdCB0aW1lIG9wdGlvbnMgdG8gcnVuIGZ1bGx5IG9uIGNncm91cCB2Mi4NCg0KSSB0
ZXN0ZWQgb24gYSBjZ3JvdXAgdjIgbWFjaGluZSBhbmQgaXQgaW5kZWVkIGZhaWxlZCB3aXRob3V0
DQp0aGUgY29yZSBwYXRjaC4gVGhhbmtzIQ0KDQo+IA0KPiBCdXQgZ2VuZXJhbGx5IHNwZWFraW5n
LCB0aGUgbGlmZWN5Y2xlIG9mIGEgZHlpbmcgY2dyb3VwIGlzDQo+IGNvbXBsZXRlbHkgaW1wbGVt
ZW50YXRpb24tZGVmaW5lZC4gTm8gZ3VhcmFudGVlcyBhcmUgcHJvdmlkZWQuDQo+IFNvIGZhbHNl
IHBvc2l0aXZlcyBhcmUgZmluZSBoZXJlLCBhbmQgc2hvdWxkbid0IGJlIGNvbnNpZGVyZWQgYXMN
Cj4gc29tZXRoaW5nIGJhZC4NCj4gDQo+IEF0IHRoZSBlbmQgYWxsIHdlIHdhbnQgaXQgdG8gZGV0
YWNoIHByb2dyYW1zIGluIGEgcmVhc29uYWJsZSB0aW1lDQo+IGFmdGVyIHJtZGlyLg0KPiANCj4g
QnR3LCB0aGFuayB5b3UgZm9yIHRoZSBjYXJlZnVsIHJldmlldyBvZiB0aGUgcGF0Y2hzZXQuIEkn
bGwNCj4gYWRkcmVzcyB5b3VyIGNvbW1lbnRzLCBhZGQgYWNrcyBhbmQgd2lsbCBzZW5kIG91dCB2
My4NCj4gDQo+IFRoYW5rcyENCj4gDQo=
