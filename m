Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3818EA3E5A
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 21:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbfH3TZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 15:25:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52246 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727883AbfH3TZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 15:25:15 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7UJNj4x022431;
        Fri, 30 Aug 2019 12:24:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=TqshAb1/YXv1lSSayk6NreG/7ncKHRKsSAveSK43NIk=;
 b=eDolhatuIvaBTQ+kHG8vfB3oazm36fR2kNUFqWCFssX2hosX33c51fLmpWTFJ6hm/nKy
 GVkOOEtLS21hs1j692DJQBWaDbNHUXfRg1HgIFI+Nk8JdHzv5vk21ll8dW4MpPIDjZMt
 urB2AplskRaA9SC+QpQhe9i8ORraEW0JbFs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2upqya4ptx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 30 Aug 2019 12:24:53 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 30 Aug 2019 12:24:52 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 30 Aug 2019 12:24:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9Ows3PxeoFSPJP0P4g2V2zgER9u6FqtgXHOCF0cI/la8VU1q23rxsLGn4GXdKEJ6ZInL5QVIhnQGnAqvYl9sp1kc54xtZb23axp9TOv8EgbqXQo7AOONaiUCOCUEKqvigaS1XuUVLZd3Ll/jmPSw3c9VtcdGNk2YPFxlzrRIqgoVk7fpigZZO2IxuzN7ZcXN4EaKo3BBYFewFPQrbOdR9CX06NIdcfuW5OzWJUBubq7g9FzLAIu1IFMIZK6mZ48kdhCjO0q6HN6ayJjICJTjUkwE5oGSJdDK48aTbZ0aOfQgi+2U3xZQoRYJfaDPOHkJq9GK8WzEU3TUlSGJvjU0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TqshAb1/YXv1lSSayk6NreG/7ncKHRKsSAveSK43NIk=;
 b=Olk3cmsl6P0Ku+UxAUKvWKwviaJOs6qG4imQ/WYQ99MTUtODsnmoDS5ria042RCr6Co8jv6o1n+GxJEIdYbS9w4l7Q83Ce25DuSXvYBe7LoK/7cTpStSO47Bm2XFxxyfZKbyfR/SmkozsQi20Lrqy3klz41Di6T04NwkKlnxTERikQZKubbFnNpJz7mja3BiEt9U5MU/Hsuf7umFiscc921Q2YRjjn5gv8jKXcnvrIBqWa2QYX8bKIT5koUEQ7rLOz+lYuOztXjUnaHqFHm+foo608J21x3Ry0Ht6xQAXM/jTL4AOU93tmnTFxbn0WBBSpsAfM7ISHD2hJtc22jMag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TqshAb1/YXv1lSSayk6NreG/7ncKHRKsSAveSK43NIk=;
 b=BWLbdPLtBu/DVdsTf3h7A7UQeVMG7CNHaGNatpE7kprQi+6rCN9FniAY1LgwrJNLu2mPp5JmlfzwOs+sih5ztoJyHPa0Mnl5G7EOK7+UWmZlhJe5d68tCe53CFQa4JtT6/fUra/QLcTUuvkB5fLLqeDtJMDmj0Bx06vEsFBoleI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1919.namprd15.prod.outlook.com (10.174.100.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Fri, 30 Aug 2019 19:24:51 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2199.021; Fri, 30 Aug 2019
 19:24:51 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Anton Protopopov <a.s.protopopov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next] tools: libbpf: update extended attributes
 version of bpf_object__open()
Thread-Topic: [PATCH bpf-next] tools: libbpf: update extended attributes
 version of bpf_object__open()
Thread-Index: AQHVUvz4yT9fypjbn0OKIVyRaBIXqqcSo2gAgAF++ACAAAjVAA==
Date:   Fri, 30 Aug 2019 19:24:50 +0000
Message-ID: <9EC54605-1911-48B0-B33A-02EC46DEF3DD@fb.com>
References: <20190815000330.12044-1-a.s.protopopov@gmail.com>
 <796E4DA8-4844-4708-866E-A8AE9477E94E@fb.com>
 <CAGn_itwS=bLf8NGVNbByNx8FmR_JtPWnuEnKO23ig8xnK_GYOw@mail.gmail.com>
In-Reply-To: <CAGn_itwS=bLf8NGVNbByNx8FmR_JtPWnuEnKO23ig8xnK_GYOw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::34a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85da3c98-b0c9-4380-95ad-08d72d7fba98
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1919;
x-ms-traffictypediagnostic: MWHPR15MB1919:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1919A4858D019041341A3894B3BD0@MWHPR15MB1919.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(366004)(376002)(396003)(136003)(189003)(199004)(256004)(5660300002)(305945005)(36756003)(71190400001)(71200400001)(86362001)(33656002)(76176011)(6246003)(8936002)(53546011)(316002)(229853002)(66446008)(66946007)(54906003)(66476007)(4326008)(64756008)(66556008)(6486002)(76116006)(99286004)(8676002)(81156014)(81166006)(25786009)(102836004)(7736002)(50226002)(186003)(6116002)(57306001)(476003)(478600001)(6506007)(2906002)(11346002)(53936002)(6436002)(6512007)(14454004)(46003)(446003)(486006)(6916009)(2616005)(101420200001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1919;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: z7KgPIs5Mc4iquZ+8PmBr6GTEn3HbiIOU3k1yom2vVjb5JkB/xOc+PMDa4NiYZz7lLShukBe24E4RZd5aYVvYP5uN4I5nvp+iwZlzYf9WzwgQjXHRk/cUkbaq2e1MbgrHwJ/L6X6UW/EsfgM5RBLtnDp22FJo+EQIuvh1hQxbjAHAiMrtXd1W15Kv40SlaelPzlkXatehFYtOzzSP2amYoU6Bqy1AS3AReUfCKUYcnQbqAEExA55e8xLg6w6r2jqW8VqYQXNIRaOkJi6whprxgRidpZqAEJ/c0641Wp22gPtk+HzmCtoP2bfcGGNiQOIcN5THJUvy8DoD9vns/o9F2NGmnTYWizHEGeCbC70at2VAvb8CNzqCy+f0mDY8A6v+cXh4/8H0uq+mObFkIPjNkInAibuDS/fNO4my7LC7yU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <82D5DFBBBD85824188CE056BB017D66A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 85da3c98-b0c9-4380-95ad-08d72d7fba98
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 19:24:50.8653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Je5OxqKHF8pVINvwJEJwj3+M7axEIpRHvQNNwoVUKZr91kYYaKWUqYaOeZ1yceAsXkUvYmhN08jqObJd5xWU+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1919
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_07:2019-08-29,2019-08-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxscore=0 impostorscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908300182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gQXVnIDMwLCAyMDE5LCBhdCAxMTo1MyBBTSwgQW50b24gUHJvdG9wb3BvdiA8YS5z
LnByb3RvcG9wb3ZAZ21haWwuY29tPiB3cm90ZToNCj4gDQo+INGH0YIsIDI5INCw0LLQsy4gMjAx
OSDQsy4g0LIgMTY6MDIsIFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+Og0KPj4gDQo+
PiANCj4+IA0KPj4+IE9uIEF1ZyAxNCwgMjAxOSwgYXQgNTowMyBQTSwgQW50b24gUHJvdG9wb3Bv
diA8YS5zLnByb3RvcG9wb3ZAZ21haWwuY29tPiB3cm90ZToNCj4+PiANCj4+IA0KPj4gWy4uLl0N
Cj4+IA0KPj4+IA0KPj4+IA0KPj4+IGludCBicGZfb2JqZWN0X191bmxvYWQoc3RydWN0IGJwZl9v
YmplY3QgKm9iaikNCj4+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9saWJicGYuaCBiL3Rv
b2xzL2xpYi9icGYvbGliYnBmLmgNCj4+PiBpbmRleCBlOGY3MDk3N2QxMzcuLjYzNGYyNzg1Nzhk
ZCAxMDA2NDQNCj4+PiAtLS0gYS90b29scy9saWIvYnBmL2xpYmJwZi5oDQo+Pj4gKysrIGIvdG9v
bHMvbGliL2JwZi9saWJicGYuaA0KPj4+IEBAIC02Myw4ICs2MywxMyBAQCBMSUJCUEZfQVBJIGxp
YmJwZl9wcmludF9mbl90IGxpYmJwZl9zZXRfcHJpbnQobGliYnBmX3ByaW50X2ZuX3QgZm4pOw0K
Pj4+IHN0cnVjdCBicGZfb2JqZWN0Ow0KPj4+IA0KPj4+IHN0cnVjdCBicGZfb2JqZWN0X29wZW5f
YXR0ciB7DQo+Pj4gLSAgICAgY29uc3QgY2hhciAqZmlsZTsNCj4+PiArICAgICB1bmlvbiB7DQo+
Pj4gKyAgICAgICAgICAgICBjb25zdCBjaGFyICpmaWxlOw0KPj4+ICsgICAgICAgICAgICAgY29u
c3QgY2hhciAqb2JqX25hbWU7DQo+Pj4gKyAgICAgfTsNCj4+PiAgICAgIGVudW0gYnBmX3Byb2df
dHlwZSBwcm9nX3R5cGU7DQo+Pj4gKyAgICAgdm9pZCAqb2JqX2J1ZjsNCj4+PiArICAgICBzaXpl
X3Qgb2JqX2J1Zl9zejsNCj4+PiB9Ow0KPj4gDQo+PiBJIHRoaW5rIHRoaXMgd291bGQgYnJlYWsg
ZHluYW1pY2FsbHkgbGlua2VkIGxpYmJwZi4gTm8/DQo+IA0KPiBBaCwgeWVzLCBzdXJlLiBXaGF0
IGlzIHRoZSByaWdodCB3YXkgdG8gbWFrZSBjaGFuZ2VzIHdoaWNoIGJyZWFrIEFCSSBpbiBsaWJi
cGY/DQoNCkkgZG9uJ3QgaGF2ZSBhIGdvb2QgaWRlYSBoZXJlIG9uIHRoZSB0b3Agb2YgbXkgaGVh
ZC4NCg0KTWF5YmUgd2UgbmVlZCBhIG5ldyBzdHJ1Y3QgYW5kL29yIGZ1bmN0aW9uIGZvciB0aGlz
LiANCiANCj4gDQo+IEJUVywgZG9lcyB0aGUgY29tbWl0IGRkYzdjMzA0MjYxNCAoImxpYmJwZjog
aW1wbGVtZW50IEJQRiBDTy1SRSBvZmZzZXQNCj4gcmVsb2NhdGlvbiBhbGdvcml0aG0iKSB3aGlj
aCBhZGRzIGEgbmV3IGZpZWxkIHRvIHRoZSBzdHJ1Y3QNCj4gYnBmX29iamVjdF9sb2FkX2F0dHIg
YWxzbyBicmVhayBBQkk/DQoNCkkgdGhpbmsgdGhpcyBjaGFuZ2Ugd2FzIGluIHRoZSBzYW1lIHJl
bGVhc2UsIHNvIGl0IGlzIE9LLiANCg0KVGhhbmtzLA0KU29uZw==
