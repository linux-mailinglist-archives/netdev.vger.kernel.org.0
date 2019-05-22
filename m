Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0878526817
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 18:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbfEVQVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 12:21:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42576 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729603AbfEVQVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 12:21:35 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MGIfQ8030532;
        Wed, 22 May 2019 09:21:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=L7W3QcE9VlGbS/EWUQOxDW1OqiWeqQ33TqEP3U1Qub4=;
 b=Oj3W/gunt54BVMhzgOLug4UgfyQVAC52eCPuPMuhQiQR4wL0e2ze9bdAcw2smhpCvpyb
 Po4IYuV1W6bf4ZQtUWdpiHz1RXsBLBB8bN4gb9EfUPRJGi+QNXF1CSLECv1tz9+PKGhF
 O+BAduJPlMSwhgda42REvdg7ypnNjMOgEiw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn8b0rd1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 09:21:16 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 22 May 2019 09:21:15 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 22 May 2019 09:21:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7W3QcE9VlGbS/EWUQOxDW1OqiWeqQ33TqEP3U1Qub4=;
 b=PmMFSahAljwHxjfzQ0NAhU+UXu/bKtHk/CDIt8QIOd1P9pNpgtKd0VdE050pGP1FkVhZhlXThStGOz5rq4irIstxzCIWEhhIenoc5jr+iYTh262qyXaHHQM3WSab6Wq2AL7ql88QSok91XMmd9aZ1UysxCtnPtiOSPiD8lxTPCw=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3064.namprd15.prod.outlook.com (20.178.238.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 22 May 2019 16:21:13 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::140e:9c62:f2d3:7f27]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::140e:9c62:f2d3:7f27%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 16:21:13 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next] libbpf: emit diff of mismatched public API, if
 any
Thread-Topic: [PATCH bpf-next] libbpf: emit diff of mismatched public API, if
 any
Thread-Index: AQHVELmfsHjD4ZU0U0K3xT5bDXZlfaZ3U0gA
Date:   Wed, 22 May 2019 16:21:13 +0000
Message-ID: <1b027a52-4ac7-daf8-ee4a-eb528f53e526@fb.com>
References: <20190522161520.3407245-1-andriin@fb.com>
In-Reply-To: <20190522161520.3407245-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0026.namprd21.prod.outlook.com
 (2603:10b6:300:129::12) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::9fb6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c393f51-7f23-4c49-6dd9-08d6ded1822d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB3064;
x-ms-traffictypediagnostic: BYAPR15MB3064:
x-microsoft-antispam-prvs: <BYAPR15MB30649F553E1D85215DB584D7D7000@BYAPR15MB3064.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:63;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(396003)(366004)(136003)(346002)(189003)(199004)(66946007)(71190400001)(71200400001)(76176011)(52116002)(99286004)(36756003)(102836004)(73956011)(7736002)(6506007)(386003)(6486002)(66556008)(66446008)(478600001)(64756008)(53546011)(229853002)(68736007)(256004)(305945005)(66476007)(31686004)(2616005)(5660300002)(11346002)(53936002)(110136005)(81156014)(81166006)(31696002)(8676002)(476003)(8936002)(446003)(6246003)(86362001)(2201001)(316002)(6116002)(14454004)(2906002)(6436002)(25786009)(486006)(2501003)(46003)(6512007)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3064;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: J0KLsR+t2tKDanUGEruMvlaMmwkX7IHtaXtgBLgfHmuxt6bU7Yu4DIy6hB6rG+Ql8g5czjJjqQ+edbYR/iatBsl3hzm1lVQj5tnaKyUmh7GWeED438nwu0cuiZuIRCxW/fdV0D6c4G+kGz1mdnpA0ZhTfGCjvrfAKHI3CStq04QszsmRJUt0P4CCJK5H8c7irZkq9Jlz5+upfkbqDmMaSW6/xPJPnmSJ617vhKMrnNV3TsC186Qph6XhUkUMfnfgjrB2MuE6CtgexMicOd3XEf1Qb5mOstyOuCd048Zu1CzSpaxzoZTHyEzhtk7V5eVLVHjhlDZSJee8P33c//vkLhlM1SuHJECuCVktEnk7j9ZIYMeyoL7MOaNWhe15T3vu8qzeFeVb+jAJ0Mn0cvjw6GDuXCvmqZSWzpkRgRsLqys=
Content-Type: text/plain; charset="utf-8"
Content-ID: <17E8621EDD53EC4F858C81B42A3E1A02@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c393f51-7f23-4c49-6dd9-08d6ded1822d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 16:21:13.6458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3064
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220115
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS8yMi8xOSA5OjE1IEFNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IEl0J3MgZWFzeSB0
byBoYXZlIGEgbWlzbWF0Y2ggb2YgImludGVuZGVkIHRvIGJlIHB1YmxpYyIgdnMgcmVhbGx5DQo+
IGV4cG9zZWQgQVBJIGZ1bmN0aW9ucy4gV2hpbGUgTWFrZWZpbGUgZG9lcyBjaGVjayBmb3IgdGhp
cyBtaXNtYXRjaCwgaWYNCj4gaXQgYWN0dWFsbHkgb2NjdXJzIGl0J3Mgbm90IHRyaXZpYWwgdG8g
ZGV0ZXJtaW5lIHdoaWNoIGZ1bmN0aW9ucyBhcmUNCj4gYWNjaWRlbnRhbGx5IGV4cG9zZWQuIFRo
aXMgcGF0Y2ggZHVtcHMgb3V0IGEgZGlmZiBzaG93aW5nIHdoYXQncyBub3QNCj4gc3VwcG9zZWQg
dG8gYmUgZXhwb3NlZCBmYWNpbGl0YXRpbmcgZWFzaWVyIGZpeGluZy4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQo+IC0tLQ0KPiAgIHRvb2xz
L2xpYi9icGYvLmdpdGlnbm9yZSB8IDIgKysNCj4gICB0b29scy9saWIvYnBmL01ha2VmaWxlICAg
fCA4ICsrKysrKysrDQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi8uZ2l0aWdub3JlIGIvdG9vbHMvbGliL2JwZi8u
Z2l0aWdub3JlDQo+IGluZGV4IGQ5ZTlkZWMwNDYwNS4uYzczMDZlODU4ZTJlIDEwMDY0NA0KPiAt
LS0gYS90b29scy9saWIvYnBmLy5naXRpZ25vcmUNCj4gKysrIGIvdG9vbHMvbGliL2JwZi8uZ2l0
aWdub3JlDQo+IEBAIC0zLDMgKzMsNSBAQCBsaWJicGYucGMNCj4gICBGRUFUVVJFLURVTVAubGli
YnBmDQo+ICAgdGVzdF9saWJicGYNCj4gICBsaWJicGYuc28uKg0KPiArbGliYnBmX2dsb2JhbF9z
eW1zLnRtcA0KPiArbGliYnBmX3ZlcnNpb25lZF9zeW1zLnRtcA0KPiBkaWZmIC0tZ2l0IGEvdG9v
bHMvbGliL2JwZi9NYWtlZmlsZSBiL3Rvb2xzL2xpYi9icGYvTWFrZWZpbGUNCj4gaW5kZXggZjkx
NjM5YmY1NjUwLi43ZTdkNmQ4NTE3MTMgMTAwNjQ0DQo+IC0tLSBhL3Rvb2xzL2xpYi9icGYvTWFr
ZWZpbGUNCj4gKysrIGIvdG9vbHMvbGliL2JwZi9NYWtlZmlsZQ0KPiBAQCAtMjA0LDYgKzIwNCwx
NCBAQCBjaGVja19hYmk6ICQoT1VUUFVUKWxpYmJwZi5zbw0KPiAgIAkJICAgICAidmVyc2lvbmVk
IHN5bWJvbHMgaW4gJF4gKCQoVkVSU0lPTkVEX1NZTV9DT1VOVCkpLiIgXA0KPiAgIAkJICAgICAi
UGxlYXNlIG1ha2Ugc3VyZSBhbGwgTElCQlBGX0FQSSBzeW1ib2xzIGFyZSIJIFwNCj4gICAJCSAg
ICAgInZlcnNpb25lZCBpbiAkKFZFUlNJT05fU0NSSVBUKS4iID4mMjsJCSBcDQo+ICsJCXJlYWRl
bGYgLXMgLS13aWRlICQoT1VUUFVUKWxpYmJwZi1pbi5vIHwJCSBcDQo+ICsJCSAgICBhd2sgJy9H
TE9CQUwvICYmIC9ERUZBVUxULyAmJiAhL1VORC8ge3ByaW50ICQkOH0nfCAgIFwNCj4gKwkJICAg
IHNvcnQgLXUgPiAkKE9VVFBVVClsaWJicGZfZ2xvYmFsX3N5bXMudG1wOwkJIFwNCj4gKwkJcmVh
ZGVsZiAtcyAtLXdpZGUgJChPVVRQVVQpbGliYnBmLnNvIHwJCQkgXA0KPiArCQkgICAgZ3JlcCAt
RW8gJ1teIF0rQExJQkJQRl8nIHwgY3V0IC1kQCAtZjEgfAkJIFwNCj4gKwkJICAgIHNvcnQgLXUg
PiAkKE9VVFBVVClsaWJicGZfdmVyc2lvbmVkX3N5bXMudG1wOyAJIFwNCj4gKwkJZGlmZiAtdSAk
KE9VVFBVVClsaWJicGZfZ2xvYmFsX3N5bXMudG1wCQkJIFwNCj4gKwkJICAgICAkKE9VVFBVVCls
aWJicGZfdmVyc2lvbmVkX3N5bXMudG1wOwkJIFwNCj4gICAJCWV4aXQgMTsJCQkJCQkJIFwNCg0K
Z29vZCBpZGVhLg0KaG93IGFib3V0IHJlbW92aW5nIHRtcCBmaWxlcyBpbnN0ZWFkIG9mIGFkZGlu
ZyB0aGVtIHRvIC5naXRpZ25vcmU/DQo=
