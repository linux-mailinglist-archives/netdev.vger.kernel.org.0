Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B15E45C192
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbfGARBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:01:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29062 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728453AbfGARBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:01:48 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x61Go7kR018410;
        Mon, 1 Jul 2019 10:01:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=o2gYKKm2XfmruC+0wB4Uk8b0SedBwlIcgCa2DW2VpiM=;
 b=bxNIcyT4N8eXWNDwUtlxj0CRjimCArhFHpNOXrFh08rZt6p3CicEfOJGkgJDz9asiwEm
 jzw8rUJCS67X168Hv+VFk30PtaBdM5w30zTkN1aS7w7rqj+fUREM4ciWFF7TUUQrJJlT
 MxiS94ZynX3IyVyGf9mB8HtVVydTKHjJTFY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2tfg1s1ctx-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 10:01:27 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 1 Jul 2019 10:01:24 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 1 Jul 2019 10:01:24 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 10:01:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o2gYKKm2XfmruC+0wB4Uk8b0SedBwlIcgCa2DW2VpiM=;
 b=ZGWHz5eM2Je1XFbl/8WeL2T7QyLwLygfrvGqcb9UCeM8zJCW7Ke4pvj+r1dHPxRoQjnydQ1ANXw3vPEGz37zuzcBm4upz2pi97OoQnMMbd9nTglXITKqJq35YHV6EYZrVwuLWjPsRjID/OpNuLx1LDNOOXNkttMMSPaL9bhB+XY=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2902.namprd15.prod.outlook.com (20.178.206.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Mon, 1 Jul 2019 17:01:22 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 17:01:22 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "sdf@fomichev.me" <sdf@fomichev.me>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4 bpf-next 2/9] libbpf: introduce concept of bpf_link
Thread-Topic: [PATCH v4 bpf-next 2/9] libbpf: introduce concept of bpf_link
Thread-Index: AQHVLi2fUZ2FnDhD6EuKGT8H/6OprKa2ANmA
Date:   Mon, 1 Jul 2019 17:01:22 +0000
Message-ID: <7cc5dfb3-b22f-cc48-668b-72f4e4ed3946@fb.com>
References: <20190629034906.1209916-1-andriin@fb.com>
 <20190629034906.1209916-3-andriin@fb.com>
In-Reply-To: <20190629034906.1209916-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0069.namprd14.prod.outlook.com
 (2603:10b6:300:81::31) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:fe3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f63fbb9-9467-4570-f136-08d6fe45be67
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2902;
x-ms-traffictypediagnostic: BYAPR15MB2902:
x-microsoft-antispam-prvs: <BYAPR15MB290207A5D71E9A6D04AE259DD3F90@BYAPR15MB2902.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39860400002)(346002)(376002)(136003)(199004)(189003)(53936002)(6512007)(6436002)(52116002)(68736007)(386003)(53546011)(102836004)(229853002)(316002)(14454004)(31686004)(5660300002)(305945005)(7736002)(2501003)(76176011)(81156014)(81166006)(8936002)(8676002)(6486002)(476003)(99286004)(446003)(486006)(36756003)(2616005)(2906002)(256004)(11346002)(66446008)(6246003)(86362001)(66556008)(2201001)(14444005)(186003)(6506007)(71190400001)(478600001)(25786009)(46003)(6636002)(5024004)(71200400001)(6116002)(73956011)(110136005)(64756008)(66946007)(66476007)(31696002)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2902;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nLrV4xljX452lJeq/E6cyEJ7NlERNigEscwAg8pShCDK+kgr6cHaYw+/zYaI3/C49AGtT/+biaqSvyiisdMK0v6wTobH/WrLsgbsh7cZGFapEdch4NSKIfi45VllKdVYzpQbVg5rlVykNFrD+IDOZnE/q3a57zed5Ghmpr4ZL0f30vtdvJ3VkkhzlrF/Wa5SHYKBeVg6/Lhxhk+XbQE3rUnZ0CSKUBSfhcVy0o/4rwsHVHz5G8Xe+AFMLd3sklsDwuyqLOVKC+tFw/FH4FYxEuPuRa0wdgJG0s8fcUvDzwnCJayaFNIXf9TBHNzdaTDPe0hvmKLyV7RJ8hJR6jff+IU0Ibwj3Uvu0WUX/HMcTS/4ZkDKMm0ZnZQO/F9qDToh/vWw7jnakMmfpal57E4E3lcENo4zMpMRFJJIjSC5kUk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5C2602AF9F2B24CBFD984ECFC6184A5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f63fbb9-9467-4570-f136-08d6fe45be67
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 17:01:22.4472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2902
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMjgvMTkgODo0OCBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBicGZfbGlu
ayBpcyBhbmQgYWJzdHJhY3Rpb24gb2YgYW4gYXNzb2NpYXRpb24gb2YgYSBCUEYgcHJvZ3JhbSBh
bmQgb25lDQoNCiJpcyBhbmQiID0+ICJpcyBhbiIuDQoNCj4gb2YgbWFueSBwb3NzaWJsZSBCUEYg
YXR0YWNobWVudCBwb2ludHMgKGhvb2tzKS4gVGhpcyBhbGxvd3MgdG8gaGF2ZQ0KPiB1bmlmb3Jt
IGludGVyZmFjZSBmb3IgZGV0YWNoaW5nIEJQRiBwcm9ncmFtcyByZWdhcmRsZXNzIG9mIHRoZSBu
YXR1cmUgb2YNCj4gbGluayBhbmQgaG93IGl0IHdhcyBjcmVhdGVkLiBEZXRhaWxzIG9mIGNyZWF0
aW9uIGFuZCBzZXR0aW5nIHVwIG9mDQo+IGEgc3BlY2lmaWMgYnBmX2xpbmsgaXMgaGFuZGxlZCBi
eSBjb3JyZXNwb25kaW5nIGF0dGFjaG1lbnQgbWV0aG9kcw0KPiAoYnBmX3Byb2dyYW1fX2F0dGFj
aF94eHgpIGFkZGVkIGluIHN1YnNlcXVlbnQgY29tbWl0cy4gT25jZSBzdWNjZXNzZnVsbHkNCj4g
Y3JlYXRlZCwgYnBmX2xpbmsgaGFzIHRvIGJlIGV2ZW50dWFsbHkgZGVzdHJveWVkIHdpdGgNCj4g
YnBmX2xpbmtfX2Rlc3Ryb3koKSwgYXQgd2hpY2ggcG9pbnQgQlBGIHByb2dyYW0gaXMgZGlzYXNz
b2NpYXRlZCBmcm9tDQo+IGEgaG9vayBhbmQgYWxsIHRoZSByZWxldmFudCByZXNvdXJjZXMgYXJl
IGZyZWVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZi
LmNvbT4NCj4gQWNrZWQtYnk6IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+DQo+IC0t
LQ0KPiAgIHRvb2xzL2xpYi9icGYvbGliYnBmLmMgICB8IDE3ICsrKysrKysrKysrKysrKysrDQo+
ICAgdG9vbHMvbGliL2JwZi9saWJicGYuaCAgIHwgIDQgKysrKw0KPiAgIHRvb2xzL2xpYi9icGYv
bGliYnBmLm1hcCB8ICAzICsrLQ0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvbGliYnBm
LmMgYi90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+IGluZGV4IDZlNmViZWYxMWJhMy4uNDU1Nzk1
ZTZmOGFmIDEwMDY0NA0KPiAtLS0gYS90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+ICsrKyBiL3Rv
b2xzL2xpYi9icGYvbGliYnBmLmMNCj4gQEAgLTM5NDEsNiArMzk0MSwyMyBAQCBpbnQgYnBmX3By
b2dfbG9hZF94YXR0cihjb25zdCBzdHJ1Y3QgYnBmX3Byb2dfbG9hZF9hdHRyICphdHRyLA0KPiAg
IAlyZXR1cm4gMDsNCj4gICB9DQo+ICAgDQo+ICtzdHJ1Y3QgYnBmX2xpbmsgew0KPiArCWludCAo
KmRlc3Ryb3kpKHN0cnVjdCBicGZfbGluayAqbGluayk7DQo+ICt9Ow0KPiArDQo+ICtpbnQgYnBm
X2xpbmtfX2Rlc3Ryb3koc3RydWN0IGJwZl9saW5rICpsaW5rKQ0KPiArew0KPiArCWludCBlcnI7
DQo+ICsNCj4gKwlpZiAoIWxpbmspDQo+ICsJCXJldHVybiAwOw0KPiArDQo+ICsJZXJyID0gbGlu
ay0+ZGVzdHJveShsaW5rKTsNCj4gKwlmcmVlKGxpbmspOw0KPiArDQo+ICsJcmV0dXJuIGVycjsN
Cj4gK30NCj4gKw0KPiAgIGVudW0gYnBmX3BlcmZfZXZlbnRfcmV0DQo+ICAgYnBmX3BlcmZfZXZl
bnRfcmVhZF9zaW1wbGUodm9pZCAqbW1hcF9tZW0sIHNpemVfdCBtbWFwX3NpemUsIHNpemVfdCBw
YWdlX3NpemUsDQo+ICAgCQkJICAgdm9pZCAqKmNvcHlfbWVtLCBzaXplX3QgKmNvcHlfc2l6ZSwN
Cj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLmggYi90b29scy9saWIvYnBmL2xp
YmJwZi5oDQo+IGluZGV4IGQ2MzlmNDdlMzExMC4uNTA4MmE1ZWJiMGMyIDEwMDY0NA0KPiAtLS0g
YS90b29scy9saWIvYnBmL2xpYmJwZi5oDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmgN
Cj4gQEAgLTE2NSw2ICsxNjUsMTAgQEAgTElCQlBGX0FQSSBpbnQgYnBmX3Byb2dyYW1fX3Bpbihz
dHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2csIGNvbnN0IGNoYXIgKnBhdGgpOw0KPiAgIExJQkJQRl9B
UEkgaW50IGJwZl9wcm9ncmFtX191bnBpbihzdHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2csIGNvbnN0
IGNoYXIgKnBhdGgpOw0KPiAgIExJQkJQRl9BUEkgdm9pZCBicGZfcHJvZ3JhbV9fdW5sb2FkKHN0
cnVjdCBicGZfcHJvZ3JhbSAqcHJvZyk7DQo+ICAgDQo+ICtzdHJ1Y3QgYnBmX2xpbms7DQo+ICsN
Cj4gK0xJQkJQRl9BUEkgaW50IGJwZl9saW5rX19kZXN0cm95KHN0cnVjdCBicGZfbGluayAqbGlu
ayk7DQo+ICsNCj4gICBzdHJ1Y3QgYnBmX2luc247DQo+ICAgDQo+ICAgLyoNCj4gZGlmZiAtLWdp
dCBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1hcCBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1hcA0K
PiBpbmRleCAyYzZkODM1NjIwZDIuLjNjZGU4NTBmYzhkYSAxMDA2NDQNCj4gLS0tIGEvdG9vbHMv
bGliL2JwZi9saWJicGYubWFwDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1hcA0KPiBA
QCAtMTY3LDEwICsxNjcsMTEgQEAgTElCQlBGXzAuMC4zIHsNCj4gICANCj4gICBMSUJCUEZfMC4w
LjQgew0KPiAgIAlnbG9iYWw6DQo+ICsJCWJwZl9saW5rX19kZXN0cm95Ow0KPiArCQlicGZfb2Jq
ZWN0X19sb2FkX3hhdHRyOw0KPiAgIAkJYnRmX2R1bXBfX2R1bXBfdHlwZTsNCj4gICAJCWJ0Zl9k
dW1wX19mcmVlOw0KPiAgIAkJYnRmX2R1bXBfX25ldzsNCj4gICAJCWJ0Zl9fcGFyc2VfZWxmOw0K
PiAtCQlicGZfb2JqZWN0X19sb2FkX3hhdHRyOw0KPiAgIAkJbGliYnBmX251bV9wb3NzaWJsZV9j
cHVzOw0KPiAgIH0gTElCQlBGXzAuMC4zOw0KPiANCg==
