Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D7D24E079
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgHUTHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:07:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60048 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725801AbgHUTHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 15:07:33 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LIoMOP019373;
        Fri, 21 Aug 2020 12:07:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=B0Uxx+/1JyuDeoerl08QdW2gEDWrfAUJb/t3vSHGCLU=;
 b=TEDmbthnOQvDjbOuMMpsUrPucS8PSBN302H5VSTcBW4G9kKWMuVzk4NE9mZHja+31a4R
 c3D9ruucoYAeAChlpy3zDRda0bleWCj0i73OI0WSBRrMcRwshe/yQEAhCUz16HnY4aHS
 NUHTNHK4x4qyvvrSU0EMD7EtOFpXn2SLjpk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 332ehft1he-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Aug 2020 12:07:28 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 12:07:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b17TPkDAl5DYdzFR3OCvpaduZA/fVBY072BvkPJgxnedkGC2VyfkJs3briGys1gt92QZ7r8+ngOMugJ6xXkqU3UbbUS/NKVvPnDk1ISRH1NLZ9VoVNeB5u2h9GLbUsCLBediblk92OutVMC/gt8NHSDyNX99qYVWO6OZdk3Ae+gqC5OTrmPbrDcLRq3a5w9SczaxMK3EfW5eeSaSnPsRQFf48K1vBUXPHC/AhT9IYLlD8UZsTespHvSPVxVaqssDH4zGTdizl8TatDT0EO9i+rlHg/Rixt0pBP2b2v7TF5rfubJrjl9SpexD+0Optt6e+CwTdX5pH5VaQVwdMw/B6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0Uxx+/1JyuDeoerl08QdW2gEDWrfAUJb/t3vSHGCLU=;
 b=Wew4pUUjzN0z+4KTeaXLgSw0PfRZ0OXg1yCnhx1v3QERtGMMbbF6U/GSL7kVhoi+BLoCdL6xJdAKP27HPDBv22uZwXmeDqITtIN2znCiWhSFsP0ZoM9AJRHN8ausjS6Rw+JfkSdGhhquotgEUo3EIKcxA6WYJqo3oRVAfHKDcR9w1yLGWIOrRKEJi+Kt+oVFjqxxmFQP8Q39fJwNRElUpm5GGwBolGhA1GRG0D3p6bFFJVBN7Avtvh7vtd0145biYnzdUaLaeuR9+CHJQ2nnWUOZDXuytcbBdngrxuOXDSXfv+WpgqB47MdNNRWLYZy/27xZOKzXNdfrrzhn+B4cBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0Uxx+/1JyuDeoerl08QdW2gEDWrfAUJb/t3vSHGCLU=;
 b=JKbvn4cVMCmbnbSKK6ZxKzCQlyB+ez+eANH29QPUU7zGFQTPq8WIokyhL80k8bD9xM2Fz93rhx2YLt9omlS5zMARGtbzE3AX666PhoOgU0XQDiL7d6hkVTD6V61AlOt+BWvHOYbkhWcBBnKrcc+EW5/jjlvIoqOaJ66O7/ZbrXU=
Received: from BY5PR15MB3651.namprd15.prod.outlook.com (2603:10b6:a03:1f7::15)
 by BYAPR15MB2439.namprd15.prod.outlook.com (2603:10b6:a02:8e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.22; Fri, 21 Aug
 2020 19:07:26 +0000
Received: from BY5PR15MB3651.namprd15.prod.outlook.com
 ([fe80::1d8b:83da:9f05:311a]) by BY5PR15MB3651.namprd15.prod.outlook.com
 ([fe80::1d8b:83da:9f05:311a%7]) with mapi id 15.20.3283.028; Fri, 21 Aug 2020
 19:07:26 +0000
From:   Udip Pant <udippant@fb.com>
To:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        "Martin Lau" <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 bpf 1/2] bpf: verifier: check for packet data access
 based on target prog
Thread-Topic: [PATCH v2 bpf 1/2] bpf: verifier: check for packet data access
 based on target prog
Thread-Index: AQHWd1H520gA6D8MckCc8BJ9Efc9i6lCFZ+AgAABToCAAGGxAA==
Date:   Fri, 21 Aug 2020 19:07:26 +0000
Message-ID: <F6EEEFF4-F749-4D51-9366-1B1845EF0526@fb.com>
References: <20200821002804.546826-1-udippant@fb.com>
 <9e829756-e943-e9a8-82f2-1a27a55afeec@fb.com>
 <d9df934c-4b64-1e28-cc7e-fb03939d687d@fb.com>
In-Reply-To: <d9df934c-4b64-1e28-cc7e-fb03939d687d@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:400::5:540e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4830ee68-5191-49a5-2f20-08d846057193
x-ms-traffictypediagnostic: BYAPR15MB2439:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2439B9412CE6F9A7310D963CB25B0@BYAPR15MB2439.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lsuDma/goV6APBXLC+JJLeepCuEThzq+0plaskqbUVaI4ekoQfor+kZfX2B0WVLtShLT7I0lKZWYFW4PQ6o+BrAi5AWAbkhqrAnTGeSG6G9uaVbtKzEOvuOT4nPsUMgADUZ6T4dO5GV12iXcuCmvBFcqvDWtJ4BVuO6uXmTs2KVI8j+ZN3Cu4sbucEO9rC+4Pt3W3nmKSlnFYGb7zYLgeoxUffGeK7wA8PqqhshU9DUTGaolFtLLmhODVSdE0ZnpcyJpIHH8fRF4oMbtaY+UD6alU7LUjGJoOxxSjxSo4n6IeDptaKK5N37kQNVRAHgY6B72Dm0QLMCoHU7R6q2GCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3651.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(346002)(39860400002)(86362001)(66476007)(71200400001)(110136005)(64756008)(6512007)(66556008)(66946007)(54906003)(8936002)(66446008)(6486002)(316002)(478600001)(8676002)(2906002)(76116006)(53546011)(33656002)(36756003)(2616005)(6506007)(5660300002)(186003)(83380400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: K2Owf8JnifSho5hp/MnARcvmKzkkX0DwNTKWa4VWLWLuELCukwbVw1fLe9LJhCDWg1Wan3riXtMr2vD0pNFkvnyH9no693QeoCLEnn8okLbcG0BpK2FhnCfALGoaSL+wugIjZN4BGWAHDcSkX47lW/FzkZExSDLuz2G+HmdJ/rt0tQi+VKTiSY/QvTAnSZc2V967pbrOTWiKlHP7p1OPREDHJ35dJ/tOz34EdSfw1oHmA1e0k/jKoQm0a3Vo7qfVyvGEWfaP8h3rjCO2f5W4J+gTILIzyFqdSEgvb19wtZ7plXGKiciocRId54vhANsOuenv00irbsJn6/moflmYSpeyUfn/mGDu5jj5Ev6aEgCDKB9A5TISqRvuc6a49NFZGqCG7FQMq+zeTSOCXWoUyYmjyl7GPskxgw61znGgmX5Tecp7E/ploExROo8+5QHqQgFNz/bEKKUr3lI4HchQsQvEiULX/LwqdHqyC6gpJYSQ0J4go74Xkfkbnh+GPB75E5/lAUSLG4gOJKx9052IJJ8IBR4bIDfZwMAag5agh5GKdvOThk7G7RRa8BRU5hQyti1UnVkq0ghYosDCzHoo1sG8BRx42qtRQrWOIA5XMUOQ2RZFV3J/+cgaLRYlwSj8r1VESNmnoPfqwGZjjwbR2YJpgUL3JmWX0tyrEN1sdGNvZMo37Wsx/X1mSoBa7VHP
Content-Type: text/plain; charset="utf-8"
Content-ID: <AEE614584870D743B8834309E549F005@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3651.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4830ee68-5191-49a5-2f20-08d846057193
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2020 19:07:26.5868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XRGGY5YT7FPY7/bfUfdhl+xQCR9hPGmI2eOCAH/rJklC5rhwG22nykh3WIC9QECJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2439
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_09:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 impostorscore=0 clxscore=1015 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210178
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7vz4gT24gOC8yMC8yMCwgMTE6MTcgUE0sICJZb25naG9uZyBTb25nIiA8eWhzQGZiLmNv
bT4gd3JvdGU6DQo+DQo+DQo+DQo+IE9uIDgvMjAvMjAgMTE6MTMgUE0sIFlvbmdob25nIFNvbmcg
d3JvdGU6DQo+PiANCj4+IA0KPj4gT24gOC8yMC8yMCA1OjI4IFBNLCBVZGlwIFBhbnQgd3JvdGU6
DQo+Pj4gV2hpbGUgdXNpbmcgZHluYW1pYyBwcm9ncmFtIGV4dGVuc2lvbiAob2YgdHlwZSBCUEZf
UFJPR19UWVBFX0VYVCksIHdlDQo+Pj4gbmVlZCB0byBjaGVjayB0aGUgcHJvZ3JhbSB0eXBlIG9m
IHRoZSB0YXJnZXQgcHJvZ3JhbSB0byBncmFudCB0aGUgcmVhZCAvDQo+Pj4gd3JpdGUgYWNjZXNz
IHRvIHRoZSBwYWNrZXQgZGF0YS4NCj4+Pg0KPj4+IFRoZSBCUEZfUFJPR19UWVBFX0VYVCB0eXBl
IGNhbiBiZSB1c2VkIHRvIGV4dGVuZCB0eXBlcyBzdWNoIGFzIFhEUCwgU0tCDQo+Pj4gYW5kIG90
aGVycy4gU2luY2UgdGhlIEJQRl9QUk9HX1RZUEVfRVhUIHByb2dyYW0gdHlwZSBvbiBpdHNlbGYg
aXMganVzdCBhDQo+Pj4gcGxhY2Vob2xkZXIgZm9yIHRob3NlLCB3ZSBuZWVkIHRoaXMgZXh0ZW5k
ZWQgY2hlY2sgZm9yIHRob3NlIHRhcmdldA0KPj4+IHByb2dyYW1zIHRvIGFjdHVhbGx5IHdvcmsg
d2hpbGUgdXNpbmcgdGhpcyBvcHRpb24uDQo+Pj4NCj4+PiBUZXN0ZWQgdGhpcyB3aXRoIGEgZnJl
cGxhY2UgeGRwIHByb2dyYW0uIFdpdGhvdXQgdGhpcyBwYXRjaCwgdGhlDQo+Pj4gdmVyaWZpZXIg
ZmFpbHMgd2l0aCBlcnJvciAnY2Fubm90IHdyaXRlIGludG8gcGFja2V0Jy4NCj4+Pg0KPj4+IFNp
Z25lZC1vZmYtYnk6IFVkaXAgUGFudCA8dWRpcHBhbnRAZmIuY29tPg0KPj4+IC0tLQ0KPj4+ICAg
a2VybmVsL2JwZi92ZXJpZmllci5jIHwgNiArKysrKy0NCj4+PiAgIDEgZmlsZSBjaGFuZ2VkLCA1
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9rZXJu
ZWwvYnBmL3ZlcmlmaWVyLmMgYi9rZXJuZWwvYnBmL3ZlcmlmaWVyLmMNCj4+PiBpbmRleCBlZjkz
OGYxN2I5NDQuLjRkNzYwNDQzMDk5NCAxMDA2NDQNCj4+PiAtLS0gYS9rZXJuZWwvYnBmL3Zlcmlm
aWVyLmMNCj4+PiArKysgYi9rZXJuZWwvYnBmL3ZlcmlmaWVyLmMNCj4+PiBAQCAtMjYyOSw3ICsy
NjI5LDExIEBAIHN0YXRpYyBib29sIG1heV9hY2Nlc3NfZGlyZWN0X3BrdF9kYXRhKHN0cnVjdCAN
Cj4+PiBicGZfdmVyaWZpZXJfZW52ICplbnYsDQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICAg
IGNvbnN0IHN0cnVjdCBicGZfY2FsbF9hcmdfbWV0YSAqbWV0YSwNCj4+PiAgICAgICAgICAgICAg
ICAgICAgICAgICAgZW51bSBicGZfYWNjZXNzX3R5cGUgdCkNCj4+PiAgIHsNCj4+PiAtICAgIHN3
aXRjaCAoZW52LT5wcm9nLT50eXBlKSB7DQo+Pj4gKyAgICBzdHJ1Y3QgYnBmX3Byb2cgKnByb2cg
PSBlbnYtPnByb2c7DQo+Pj4gKyAgICBlbnVtIGJwZl9wcm9nX3R5cGUgcHJvZ190eXBlID0gcHJv
Zy0+YXV4LT5saW5rZWRfcHJvZyA/DQo+Pj4gKyAgICAgICAgICBwcm9nLT5hdXgtPmxpbmtlZF9w
cm9nLT50eXBlIDogcHJvZy0+dHlwZTsNCj4+IA0KPj4gSSBjaGVja2VkIHRoZSB2ZXJpZmllciBj
b2RlLiBUaGVyZSBhcmUgc2V2ZXJhbCBwbGFjZXMgd2hlcmUNCj4+IHByb2ctPnR5cGUgaXMgY2hl
Y2tlZCBhbmQgRVhUIHByb2dyYW0gdHlwZSB3aWxsIGJlaGF2ZSBkaWZmZXJlbnRseQ0KPj4gZnJv
bSB0aGUgbGlua2VkIHByb2dyYW0uDQo+PiANCj4+IE1heWJlIGFic3RyYWN0IHRoZSB0aGUgYWJv
dmUgbG9naWMgdG8gb25lIHN0YXRpYyBmdW5jdGlvbiBsaWtlDQo+PiANCj4+IHN0YXRpYyBlbnVt
IGJwZl9wcm9nX3R5cGUgcmVzb2x2ZWRfcHJvZ190eXBlKHN0cnVjdCBicGZfcHJvZyAqcHJvZykN
Cj4+IHsNCj4+ICAgICAgcmV0dXJuIHByb2ctPmF1eC0+bGlua2VkX3Byb2cgPyBwcm9nLT5hdXgt
PmxpbmtlZF9wcm9nLT50eXBlDQo+PiAgICAgICAgICAgICAgICAgICAgICAgIDogcHJvZy0+dHlw
ZTsNCj4+IH0NCj4+IA0KDQpTdXJlLg0KDQo+PiBUaGlzIGZ1bmN0aW9uIGNhbiB0aGVuIGJlIHVz
ZWQgaW4gZGlmZmVyZW50IHBsYWNlcyB0byBnaXZlIHRoZSByZXNvbHZlZA0KPj4gcHJvZyB0eXBl
Lg0KPj4gDQo+PiBCZXNpZGVzIGhlcmUgY2hlY2tpbmcgcGt0IGFjY2VzcyBwZXJtaXNzaW9uLA0K
Pj4gYW5vdGhlciBwb3NzaWJsZSBwbGFjZXMgdG8gY29uc2lkZXIgaXMgcmV0dXJuIHZhbHVlDQo+
PiBpbiBmdW5jdGlvbiBjaGVja19yZXR1cm5fY29kZSgpLiBDdXJyZW50bHksDQo+PiBmb3IgRVhU
IHByb2dyYW0sIHRoZSByZXN1bHQgdmFsdWUgY2FuIGJlIGFueXRoaW5nLiBUaGlzIG1heSBuZWVk
IHRvDQo+PiBiZSBlbmZvcmNlZC4gQ291bGQgeW91IHRha2UgYSBsb29rPyBJdCBjb3VsZCBiZSBv
dGhlcnMgYXMgd2VsbC4NCj4+IFlvdSBjYW4gdGFrZSBhIGxvb2sgYXQgdmVyaWZpZXIuYyBieSBz
ZWFyY2hpbmcgInByb2ctPnR5cGUiLg0KPg0KDQpZZWFoIHRoZXJlIGFyZSBmZXcgb3RoZXIgcGxh
Y2VzIGluIHRoZSB2ZXJpZmllciB3aGVyZSBpdCBkZWNpZGVzIHdpdGhvdXQgcmVzb2x2aW5nIGZv
ciB0aGUgJ2V4dGVuZGVkJyB0eXBlLiBCdXQgSSBhbSBub3QgdG9vIHN1cmUgaWYgaXQgbWFrZXMg
c2Vuc2UgdG8gZXh0ZW5kIHRoaXMgbG9naWMgYXMgcGFydCBvZiB0aGlzIGNvbW1pdC4gRm9yIGV4
YW1wbGUsIGFzIHlvdSBtZW50aW9uZWQsIGluIHRoZSBjaGVja19yZXR1cm5fY29kZSgpIGl0IGV4
cGxpY2l0bHkgaWdub3JlcyB0aGUgcmV0dXJuIHR5cGUgZm9yIHRoZSBFWFQgcHJvZyAoa2VybmVs
L2JwZi92ZXJpZmllci5jI0w3NDQ2KS4gIExpa2V3aXNlLCBJIG5vdGljZWQgc2ltaWxhciBpc3N1
ZSBpbnNpZGUgdGhlIGNoZWNrX2xkX2FicygpLCB3aGVyZSBpdCBjaGVja3MgZm9yIG1heV9hY2Nl
c3Nfc2tiKGVudi0+cHJvZy0+dHlwZSkuICAgDQoNCkknbSBoYXBweSB0byBleHRlbmQgdGhpcyBs
b2dpYyB0aGVyZSBhcyB3ZWxsIGlmIGRlZW1lZCBhcHByb3ByaWF0ZS4gDQoNCj4gTm90ZSB0aGF0
IGlmIHRoZSBFWFQgcHJvZ3JhbSB0cmllcyB0byByZXBsYWNlIGEgZ2xvYmFsIHN1YnByb2dyYW0s
DQo+IHRoZW4gcmV0dXJuIHZhbHVlIGNhbm5vdCBiZSBlbmZvcmNlZCwganVzdCBhcyB3aGF0IFBh
dGNoICMyIGV4YW1wbGUgc2hvd3MuDQo+DQo+PiANCj4+PiArDQo+Pj4gKyAgICBzd2l0Y2ggKHBy
b2dfdHlwZSkgew0KPj4+ICAgICAgIC8qIFByb2dyYW0gdHlwZXMgb25seSB3aXRoIGRpcmVjdCBy
ZWFkIGFjY2VzcyBnbyBoZXJlISAqLw0KPj4+ICAgICAgIGNhc2UgQlBGX1BST0dfVFlQRV9MV1Rf
SU46DQo+Pj4gICAgICAgY2FzZSBCUEZfUFJPR19UWVBFX0xXVF9PVVQ6DQo+Pj4NCg0K
