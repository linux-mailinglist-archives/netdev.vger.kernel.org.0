Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058CC5EF36
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 00:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfGCWlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 18:41:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54848 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbfGCWlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 18:41:46 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x63Mda10005444;
        Wed, 3 Jul 2019 15:41:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=nvOug3B2VuBKsN+yajfoGI+56le8iJWsEqpe6gPFziI=;
 b=TxmqUcfqA8nyiq73UVQRiEbdVEC0D7y34j+z5dp6z5TrlZX9twWUKBRkNxEJNQVZ7qmL
 L9tD34sdbFYyEkbPcTRFKPE09TJ9NpZYGvVWx+T/rmajQ7p1eSWTdzvWHBz5GdZHI87U
 OqlUtFybWfLpUj34x0W5864r1SQjtkhe+2k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tgytqs87r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 03 Jul 2019 15:41:25 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 3 Jul 2019 15:41:25 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 3 Jul 2019 15:41:24 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 3 Jul 2019 15:41:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvOug3B2VuBKsN+yajfoGI+56le8iJWsEqpe6gPFziI=;
 b=G8+kq9GLsl0jFTwRKLPSmBjcPDmtDVjaaZC5DkVbx1J4I3FyefWjff3XBLPJGSo3nFm5Zp85jT+mjwOYbYyRZDMZpD611HYbbD30T3OjvE0T1Gce19CtECCAY2ne9O6E6PFGrP2hkU0C80weS9iBtj6wQrOUh1Wuiq9zICX2NtI=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3431.namprd15.prod.outlook.com (20.179.59.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.15; Wed, 3 Jul 2019 22:41:23 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 22:41:23 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 2/4] selftests/bpf: add __int and __type macro
 for BTF-defined maps
Thread-Topic: [PATCH v3 bpf-next 2/4] selftests/bpf: add __int and __type
 macro for BTF-defined maps
Thread-Index: AQHVMdJh0NnyDPltU0CSvnF7+pEfpqa5fTeA
Date:   Wed, 3 Jul 2019 22:41:22 +0000
Message-ID: <792cf739-666a-fc3d-c012-d1a125e296b5@fb.com>
References: <20190703190604.4173641-1-andriin@fb.com>
 <20190703190604.4173641-3-andriin@fb.com>
In-Reply-To: <20190703190604.4173641-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0016.namprd19.prod.outlook.com
 (2603:10b6:300:d4::26) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:f960]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f18d45d7-c422-49b4-85ca-08d7000792a4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3431;
x-ms-traffictypediagnostic: BYAPR15MB3431:
x-microsoft-antispam-prvs: <BYAPR15MB34319BC4B0BAE83500EA482AD3FB0@BYAPR15MB3431.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(376002)(39860400002)(346002)(396003)(189003)(199004)(478600001)(6636002)(76176011)(68736007)(6116002)(186003)(73956011)(99286004)(66476007)(256004)(2201001)(86362001)(31696002)(8936002)(81156014)(81166006)(8676002)(102836004)(66446008)(25786009)(66556008)(6506007)(46003)(66946007)(53546011)(52116002)(386003)(64756008)(5660300002)(14454004)(11346002)(110136005)(71190400001)(71200400001)(6246003)(53936002)(2906002)(4744005)(316002)(2501003)(6436002)(36756003)(6512007)(31686004)(486006)(476003)(2616005)(6486002)(7736002)(446003)(305945005)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3431;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 53Ey6g9WCwl8c+wCR0LZ1nIrw65hCKcqy9GIleQCDRC4KN1ADrLcm1DU13/E4WtG713SwpuxVx0MpQWcTippDKWfIEpIiSOlcxjkCAKa40kzKEvWle7GED1PGgslDwMSl+hn36jv4qTBdJFHyismxONoDIbY3+Jvnq2rNywob38S+jYEuXMQWyZnP6R7zcBSQJaPtik7if5zl+sXgTbFmm3t0XMp8BO6CJMYHRnJsVI9O2g/NAMOJr7oESitNvplJ9PdM3Af5hF9sROAcTnrBNq19dkyjfVoRj+C7scEjjwDR8+oMCjhRgMPLZNaISqoXZfpBq80y12tiIUnCf9WtFcRaJ+uvb3lbLk3pWOtLg85bb5G4z65P1Xb9m8eSxFsLnXYyGe2pnxjIJKyTA5Q723PL0eZhBvVXyT4yswjN5g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <69608111D9264C44BAE71EB1CAB1BF70@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f18d45d7-c422-49b4-85ca-08d7000792a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 22:41:23.3914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3431
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907030277
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMy8xOSAxMjowNiBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBBZGQgc2lt
cGxlIF9faW50IGFuZCBfX3R5cGUgbWFjcm8gdGhhdCBoaWRlIGRldGFpbHMgb2YgaG93IHR5cGUg
YW5kDQoNClRoZSAiX19pbnQiIHNob3VsZCBiZSAiX191aW50Ii4NClRoZSBzdWJqZWN0IGxpbmUg
c2hvdWxkIGNoYW5nZSBmcm9tIF9faW50IHRvIF9fdWludC4NCg0KPiBpbnRlZ2VyIHZhbHVlcyBh
cmUgY2FwdHVyZWQgaW4gQlRGLWRlZmluZWQgbWFwcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFu
ZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQo+IC0tLQ0KPiAgIHRvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2JwZi9icGZfaGVscGVycy5oIHwgMyArKysNCj4gICAxIGZpbGUgY2hhbmdlZCwg
MyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMvYnBmL2JwZl9oZWxwZXJzLmggYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvYnBmX2hl
bHBlcnMuaA0KPiBpbmRleCAxYTViMWFjY2YwOTEuLjVhM2Q5MmM4YmVjOCAxMDA2NDQNCj4gLS0t
IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL2JwZl9oZWxwZXJzLmgNCj4gKysrIGIvdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL2JwZl9oZWxwZXJzLmgNCj4gQEAgLTgsNiArOCw5IEBA
DQo+ICAgICovDQo+ICAgI2RlZmluZSBTRUMoTkFNRSkgX19hdHRyaWJ1dGVfXygoc2VjdGlvbihO
QU1FKSwgdXNlZCkpDQo+ICAgDQo+ICsjZGVmaW5lIF9fdWludChuYW1lLCB2YWwpIGludCAoKm5h
bWUpW3ZhbF0NCj4gKyNkZWZpbmUgX190eXBlKG5hbWUsIHZhbCkgdmFsICpuYW1lDQo+ICsNCj4g
ICAvKiBoZWxwZXIgbWFjcm8gdG8gcHJpbnQgb3V0IGRlYnVnIG1lc3NhZ2VzICovDQo+ICAgI2Rl
ZmluZSBicGZfcHJpbnRrKGZtdCwgLi4uKQkJCQlcDQo+ICAgKHsJCQkJCQkJXA0KPiANCg==
