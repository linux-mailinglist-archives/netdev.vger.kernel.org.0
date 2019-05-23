Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464BD2755A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 07:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfEWFRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 01:17:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbfEWFRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 01:17:32 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4N54xwS030557;
        Wed, 22 May 2019 22:17:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=LbF2DUFZnjFuRWy9XC3ULdnqPz+cnRQPlgZncdo+klM=;
 b=K4ZLG+KsqJQ7Vrea7WkgyAh9WifNnacUX8NShIJKQtTWPjOIYpobxMacZ/k1tXH0SNC1
 yu/o+mARXrz3VzCj2s63jiESilxas9lxUNMUowoA5Pwx87cX0/GI/93cwVnb3t0SdpOw
 LvaiBAENBZAvzw5kOzH9XzGETUKV+jGc43g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn81p2td6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 May 2019 22:17:09 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 22:17:07 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 22:17:07 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 22 May 2019 22:17:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbF2DUFZnjFuRWy9XC3ULdnqPz+cnRQPlgZncdo+klM=;
 b=AYAP4Chxjx2BiqRxqXtmKZOnnKHjpER92tlp/svZyzjatu6+cG/+ivFOrRJ01pZaVYSjiIw0O8M3XqW7zdYYrAsNwfSNGeEFUyEUcIZNMEIci8PMCc1sRTvv1ajonjZ2hWuULV5seMQq4km3gy9uQwu6H5/etNeWGFXnCCEFDq0=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3318.namprd15.prod.outlook.com (20.179.58.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Thu, 23 May 2019 05:17:05 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 05:17:05 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Roman Gushchin <guro@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 0/4] cgroup bpf auto-detachment
Thread-Topic: [PATCH v2 bpf-next 0/4] cgroup bpf auto-detachment
Thread-Index: AQHVEPUtUHwbqLqfcECGSpOX+mWtuKZ4K5UA
Date:   Thu, 23 May 2019 05:17:05 +0000
Message-ID: <0403d453-c003-c823-cf57-28d200a6e40a@fb.com>
References: <20190522232051.2938491-1-guro@fb.com>
In-Reply-To: <20190522232051.2938491-1-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR07CA0054.namprd07.prod.outlook.com (2603:10b6:100::22)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::c87a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66b7fc8e-2b0d-464c-6a81-08d6df3de513
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB3318;
x-ms-traffictypediagnostic: BYAPR15MB3318:
x-microsoft-antispam-prvs: <BYAPR15MB3318D4563FDDCB4039975145D3010@BYAPR15MB3318.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(396003)(376002)(366004)(189003)(199004)(53936002)(81166006)(81156014)(2616005)(476003)(486006)(446003)(11346002)(186003)(8936002)(46003)(6116002)(8676002)(25786009)(305945005)(6246003)(2906002)(5024004)(7736002)(68736007)(256004)(4326008)(73956011)(66946007)(64756008)(66446008)(66476007)(66556008)(316002)(5660300002)(76176011)(102836004)(53546011)(54906003)(110136005)(99286004)(6486002)(386003)(6506007)(52116002)(86362001)(36756003)(31696002)(71200400001)(71190400001)(14454004)(478600001)(6436002)(6512007)(2501003)(229853002)(31686004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3318;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IPDyYxWoVJLsSndpYAVSqCH4BZEeK6uFM2n9fzFbnh8HAprVjYy2tdYsFzivQjz6BFhOMKHwhOkdadH3B6+QWru+GDpFJlbqGpTpbJlBz1yVdw/2FZ7ICO3QX5IV+em9Ehyd0jofMCh1sxeiTNgqhtXFkLRJHeDQi2Ln7SOhgUOLr8H+r8MKG4qUezJAFOnHbThKy7h/qEd3jfyNz5qJ5pE73GzQtHBZOblTxvdmyH0Unj1ebEh/KMS8EGtbYIGZDCg0JviU7wUKsbbRyi6Z0J+TQqb1x1jcoklJolv2Bvf25uTqYF7Uhi3jDzXPh0P3kNwD6ns2aGxwG5lbSZGFeEUroAv7gQl3Dgq5/UkyvteLi+t0EncugvPofKSoY5T/b5CU6EfmK8DoXvjKoUpM7Up7QJj6eA3roNgMe1CM+Mo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <373C19A206E4ED41BCA7E8BFFF211415@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b7fc8e-2b0d-464c-6a81-08d6df3de513
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 05:17:05.2965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3318
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=905 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230036
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjIvMTkgNDoyMCBQTSwgUm9tYW4gR3VzaGNoaW4gd3JvdGU6DQo+IFRoaXMgcGF0
Y2hzZXQgaW1wbGVtZW50cyBhIGNncm91cCBicGYgYXV0by1kZXRhY2htZW50IGZ1bmN0aW9uYWxp
dHk6DQo+IGJwZiBwcm9ncmFtcyBhcmUgYXR0YWNoZWQgYXMgc29vbiBhcyBwb3NzaWJsZSBhZnRl
ciByZW1vdmFsIG9mIHRoZQ0KdHlwbyBoZXJlICJhdHRhY2hlZCIgPT4gImRldGFjaGVkIj8NCg0K
PiBjZ3JvdXAsIHdpdGhvdXQgd2FpdGluZyBmb3IgdGhlIHJlbGVhc2Ugb2YgYWxsIGFzc29jaWF0
ZWQgcmVzb3VyY2VzLg0KPiANCj4gUGF0Y2hlcyAyIGFuZCAzIGFyZSByZXF1aXJlZCB0byBpbXBs
ZW1lbnQgYSBjb3JyZXNwb25kaW5nIGtzZWxmdGVzdA0KPiBpbiBwYXRjaCA0Lg0KPiANCj4gdjI6
DQo+ICAgIDEpIHJlbW92ZWQgYSBib2d1cyBjaGVjayBpbiBwYXRjaCA0DQo+ICAgIDIpIG1vdmVk
IGJ1ZltsZW5dID0gMCBpbiBwYXRjaCAyDQo+IA0KPiANCj4gUm9tYW4gR3VzaGNoaW4gKDQpOg0K
PiAgICBicGY6IGRlY291cGxlIHRoZSBsaWZldGltZSBvZiBjZ3JvdXBfYnBmIGZyb20gY2dyb3Vw
IGl0c2VsZg0KPiAgICBzZWxmdGVzdHMvYnBmOiBjb252ZXJ0IHRlc3RfY2dycDJfYXR0YWNoMiBl
eGFtcGxlIGludG8ga3NlbGZ0ZXN0DQo+ICAgIHNlbGZ0ZXN0cy9icGY6IGVuYWJsZSBhbGwgYXZh
aWxhYmxlIGNncm91cCB2MiBjb250cm9sbGVycw0KPiAgICBzZWxmdGVzdHMvYnBmOiBhZGQgYXV0
by1kZXRhY2ggdGVzdA0KPiANCj4gICBpbmNsdWRlL2xpbnV4L2JwZi1jZ3JvdXAuaCAgICAgICAg
ICAgICAgICAgICAgfCAgIDggKy0NCj4gICBpbmNsdWRlL2xpbnV4L2Nncm91cC5oICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgMTggKysrDQo+ICAga2VybmVsL2JwZi9jZ3JvdXAuYyAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgIDI1ICsrLQ0KPiAgIGtlcm5lbC9jZ3JvdXAvY2dyb3VwLmMg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAxMSArLQ0KPiAgIHNhbXBsZXMvYnBmL01ha2VmaWxl
ICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMiAtDQo+ICAgdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvYnBmL01ha2VmaWxlICAgICAgICAgIHwgICA0ICstDQo+ICAgdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvYnBmL2Nncm91cF9oZWxwZXJzLmMgIHwgIDU3ICsrKysrKysNCj4gICAuLi4vc2Vs
ZnRlc3RzL2JwZi90ZXN0X2Nncm91cF9hdHRhY2guYyAgICAgICAgfCAxNDUgKysrKysrKysrKysr
KysrKy0tDQo+ICAgOCBmaWxlcyBjaGFuZ2VkLCAyNDMgaW5zZXJ0aW9ucygrKSwgMjcgZGVsZXRp
b25zKC0pDQo+ICAgcmVuYW1lIHNhbXBsZXMvYnBmL3Rlc3RfY2dycDJfYXR0YWNoMi5jID0+IHRv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2Nncm91cF9hdHRhY2guYyAoNzklKQ0KPiAN
Cg==
