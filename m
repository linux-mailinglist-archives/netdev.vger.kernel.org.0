Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B84E05AEC1
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 07:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfF3Fx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 01:53:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36532 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725976AbfF3Fx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 01:53:28 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5U5mhVL007704;
        Sat, 29 Jun 2019 22:52:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fOyNwvbLNlOpvEOXdKSPyhxW60mq4XkgXU+yvSLtgB8=;
 b=Jd4Wrk4H4gbx5ogqXmIy7qW9ZdtWWINjjodx4lATOyAAwXVzuS499BLajpITNn43qJpV
 c5TFSfq0nqTNr4Q2O2yip2Hle/FUjM6tDzihYIowft83UKhUA572qy9KFCU4z12I+iOx
 0kYW84CrmTk0w577S3aB1Cud/QS2e+k0YrI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2te3frja81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 29 Jun 2019 22:52:59 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 29 Jun 2019 22:52:57 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 29 Jun 2019 22:52:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOyNwvbLNlOpvEOXdKSPyhxW60mq4XkgXU+yvSLtgB8=;
 b=ES7yiIDAnkBy3kJim9rVJQPYfuajqPZNsn9KM/ymc/QaF2I621imL30i+WTSly1i3OnoB1XwdGR58RxIe+tANCiKwzcLhAhzSGW+G9Zo46b0hr4kNzE52+Juiz1B9BiR84mokSM4XwmDqsm3s2NqbHSMvRlWmTGIkGKy4zNNoCM=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2965.namprd15.prod.outlook.com (20.178.237.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Sun, 30 Jun 2019 05:52:42 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Sun, 30 Jun 2019
 05:52:42 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andriin@fb.com>,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: allow wide (u64) aligned stores for
 some fields of bpf_sock_addr
Thread-Topic: [PATCH bpf-next 1/2] bpf: allow wide (u64) aligned stores for
 some fields of bpf_sock_addr
Thread-Index: AQHVLgbGV/8S/5TtNEmaz9bF3+Jm0qazs/yA
Date:   Sun, 30 Jun 2019 05:52:42 +0000
Message-ID: <be223396-b181-e587-d63c-2b15eaca3721@fb.com>
References: <20190628231049.22149-1-sdf@google.com>
In-Reply-To: <20190628231049.22149-1-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0049.namprd22.prod.outlook.com
 (2603:10b6:301:16::23) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:13d0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c91d79be-4e83-46d8-fe07-08d6fd1f2aa6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2965;
x-ms-traffictypediagnostic: BYAPR15MB2965:
x-microsoft-antispam-prvs: <BYAPR15MB2965B071CFB65D050444A083D3FE0@BYAPR15MB2965.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 008421A8FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39850400004)(346002)(376002)(136003)(199004)(189003)(4326008)(256004)(14444005)(31686004)(81166006)(81156014)(68736007)(8936002)(6116002)(305945005)(46003)(7736002)(2501003)(8676002)(11346002)(446003)(486006)(110136005)(6486002)(99286004)(316002)(229853002)(476003)(2616005)(54906003)(2906002)(6246003)(102836004)(36756003)(186003)(52116002)(6436002)(6506007)(53546011)(386003)(76176011)(73956011)(66476007)(86362001)(66556008)(66946007)(53936002)(6512007)(31696002)(2201001)(64756008)(66446008)(5660300002)(71190400001)(478600001)(71200400001)(14454004)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2965;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GNmWQKnIUrPsQqGcHbq75abIjgvdBEnq6tIHCJMDim2WPbENiVD/PySdnnSr6IbgSfjfEWB8xNMgZ7rNbagnNkwa0CHhjYNNs2X0K4uVQyeoG+bhxqJAtDJidg4BrSeYZgN0jWjGHQIScvQrn6C3YV9UFbkv1XUQnFTzZWaFaIsfJyzWYc63aFBcFXCjAOsKKe4b2o7ItxsaZdSUlK5w+06gRAhBY/1bkx4vZz1VdiKD9zdrHQLd9zSWisLOFjxo5tBEnkzVu1JE2Czbd5syvkdhwqzMf1ijMKJBfV9K04k57hLP+ZGoyH8aKs0G/BU2AJyS8nNcb6rlTU2ry1opvt+N19oQx0WiZ3RGTJicfj0PnaP4KAGNuIi+IAjsIg0DV00TBm05/Rlx4wpduA5C2Uta4W3T3sviF4pl2kLQZRY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B473E53B3B1074F8A5A5FD0CB2E4BCD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c91d79be-4e83-46d8-fe07-08d6fd1f2aa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2019 05:52:42.4392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2965
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-30_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906300075
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMjgvMTkgNDoxMCBQTSwgU3RhbmlzbGF2IEZvbWljaGV2IHdyb3RlOg0KPiBTaW5j
ZSBjb21taXQgY2QxN2Q3NzcwNTc4ICgiYnBmL3Rvb2xzOiBzeW5jIGJwZi5oIikgY2xhbmcgZGVj
aWRlZA0KPiB0aGF0IGl0IGNhbiBkbyBhIHNpbmdsZSB1NjQgc3RvcmUgaW50byB1c2VyX2lwNlsy
XSBpbnN0ZWFkIG9mIHR3bw0KPiBzZXBhcmF0ZSB1MzIgb25lczoNCj4gDQo+ICAgIyAgMTc6ICgx
OCkgcjIgPSAweDEwMDAwMDAwMDAwMDAwMA0KPiAgICMgIDsgY3R4LT51c2VyX2lwNlsyXSA9IGJw
Zl9odG9ubChEU1RfUkVXUklURV9JUDZfMik7DQo+ICAgIyAgMTk6ICg3YikgKih1NjQgKikocjEg
KzE2KSA9IHIyDQo+ICAgIyAgaW52YWxpZCBicGZfY29udGV4dCBhY2Nlc3Mgb2ZmPTE2IHNpemU9
OA0KPiANCj4gIEZyb20gdGhlIGNvbXBpbGVyIHBvaW50IG9mIHZpZXcgaXQgZG9lcyBsb29rIGxp
a2UgYSBjb3JyZWN0IHRoaW5nDQo+IHRvIGRvLCBzbyBsZXQncyBzdXBwb3J0IGl0IG9uIHRoZSBr
ZXJuZWwgc2lkZS4NCj4gDQo+IENyZWRpdCB0byBBbmRyaWkgTmFrcnlpa28gZm9yIGEgcHJvcGVy
IGltcGxlbWVudGF0aW9uIG9mDQo+IGJwZl9jdHhfd2lkZV9zdG9yZV9vay4NCj4gDQo+IENjOiBB
bmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0KPiBDYzogWW9uZ2hvbmcgU29uZyA8eWhz
QGZiLmNvbT4NCj4gRml4ZXM6IGNkMTdkNzc3MDU3OCAoImJwZi90b29sczogc3luYyBicGYuaCIp
DQo+IFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8cm9uZy5hLmNoZW5AaW50ZWwuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBTdGFuaXNsYXYgRm9taWNoZXYgPHNkZkBnb29nbGUuY29tPg0K
DQpUaGUgY2hhbmdlIGxvb2tzIGdvb2QgdG8gbWUgd2l0aCB0aGUgZm9sbG93aW5nIG5pdHM6DQog
ICAxLiBjb3VsZCB5b3UgYWRkIGEgY292ZXIgbGV0dGVyIGZvciB0aGUgcGF0Y2ggc2V0Pw0KICAg
ICAgdHlwaWNhbGx5IGlmIHRoZSBudW1iZXIgb2YgcGF0Y2hlcyBpcyBtb3JlIHRoYW4gb25lLA0K
ICAgICAgaXQgd291bGQgYmUgYSBnb29kIHByYWN0aWNlIHdpdGggYSBjb3ZlciBsZXR0ZXIuDQog
ICAgICBTZWUgYnBmX2RldmVsX1FBLnJzdCAuDQogICAyLiB3aXRoIHRoaXMgY2hhbmdlLCB0aGUg
Y29tbWVudHMgaW4gdWFwaSBicGYuaA0KICAgICAgYXJlIG5vdCBhY2N1cmF0ZSBhbnkgbW9yZS4N
CiAgICAgICAgIF9fdTMyIHVzZXJfaXA2WzRdOyAgICAgIC8qIEFsbG93cyAxLDIsNC1ieXRlIHJl
YWQgYW4gNC1ieXRlIHdyaXRlLg0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICog
U3RvcmVkIGluIG5ldHdvcmsgYnl0ZSBvcmRlci4gDQoNCiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAqLw0KICAgICAgICAgX191MzIgbXNnX3NyY19pcDZbNF07ICAgLyogQWxsb3dz
IDEsMiw0LWJ5dGUgcmVhZCBhbiA0LWJ5dGUgd3JpdGUuDQogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKiBTdG9yZWQgaW4gbmV0d29yayBieXRlIG9yZGVyLg0KICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICovDQogICAgICBub3cgZm9yIHN0b3JlcywgYWxpZ25lZCA4
LWJ5dGUgd3JpdGUgaXMgcGVybWl0dGVkLg0KICAgICAgY291bGQgeW91IHVwZGF0ZSB0aGlzIGFz
IHdlbGw/DQoNCiBGcm9tIHRoZSB0eXBpY2FsIHVzYWdlIHBhdHRlcm4sIEkgZGlkIG5vdCBzZWUg
YSBuZWVkDQpmb3IgOC10eWUgcmVhZCBvZiB1c2VyX2lwNiBhbmQgbXNnX3NyY19pcDYgeWV0LiBT
byBsZXQNCnVzIGp1c3QgZGVhbCB3aXRoIHdyaXRlIGZvciBub3cuDQoNCldpdGggdGhlIGFib3Zl
IHR3byBuaXRzLA0KQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQoNCj4gLS0t
DQo+ICAgaW5jbHVkZS9saW51eC9maWx0ZXIuaCB8ICA2ICsrKysrKw0KPiAgIG5ldC9jb3JlL2Zp
bHRlci5jICAgICAgfCAyMiArKysrKysrKysrKysrKy0tLS0tLS0tDQo+ICAgMiBmaWxlcyBjaGFu
Z2VkLCAyMCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbGludXgvZmlsdGVyLmggYi9pbmNsdWRlL2xpbnV4L2ZpbHRlci5oDQo+IGluZGV4
IDM0MGY3ZDY0ODk3NC4uMzkwMTAwN2UzNmYxIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4
L2ZpbHRlci5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvZmlsdGVyLmgNCj4gQEAgLTc0Niw2ICs3
NDYsMTIgQEAgYnBmX2N0eF9uYXJyb3dfYWNjZXNzX29rKHUzMiBvZmYsIHUzMiBzaXplLCB1MzIg
c2l6ZV9kZWZhdWx0KQ0KPiAgIAlyZXR1cm4gc2l6ZSA8PSBzaXplX2RlZmF1bHQgJiYgKHNpemUg
JiAoc2l6ZSAtIDEpKSA9PSAwOw0KPiAgIH0NCj4gICANCj4gKyNkZWZpbmUgYnBmX2N0eF93aWRl
X3N0b3JlX29rKG9mZiwgc2l6ZSwgdHlwZSwgZmllbGQpCQkJXA0KPiArCShzaXplID09IHNpemVv
ZihfX3U2NCkgJiYJCQkJCVwNCj4gKwlvZmYgPj0gb2Zmc2V0b2YodHlwZSwgZmllbGQpICYmCQkJ
CQlcDQo+ICsJb2ZmICsgc2l6ZW9mKF9fdTY0KSA8PSBvZmZzZXRvZmVuZCh0eXBlLCBmaWVsZCkg
JiYJCVwNCj4gKwlvZmYgJSBzaXplb2YoX191NjQpID09IDApDQo+ICsNCj4gICAjZGVmaW5lIGJw
Zl9jbGFzc2ljX3Byb2dsZW4oZnByb2cpIChmcHJvZy0+bGVuICogc2l6ZW9mKGZwcm9nLT5maWx0
ZXJbMF0pKQ0KPiAgIA0KPiAgIHN0YXRpYyBpbmxpbmUgdm9pZCBicGZfcHJvZ19sb2NrX3JvKHN0
cnVjdCBicGZfcHJvZyAqZnApDQo+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9maWx0ZXIuYyBiL25l
dC9jb3JlL2ZpbHRlci5jDQo+IGluZGV4IGRjODUzNGJlMTJmYy4uNWQzM2YyMTQ2ZGFiIDEwMDY0
NA0KPiAtLS0gYS9uZXQvY29yZS9maWx0ZXIuYw0KPiArKysgYi9uZXQvY29yZS9maWx0ZXIuYw0K
PiBAQCAtNjg0OSw2ICs2ODQ5LDE2IEBAIHN0YXRpYyBib29sIHNvY2tfYWRkcl9pc192YWxpZF9h
Y2Nlc3MoaW50IG9mZiwgaW50IHNpemUsDQo+ICAgCQkJaWYgKCFicGZfY3R4X25hcnJvd19hY2Nl
c3Nfb2sob2ZmLCBzaXplLCBzaXplX2RlZmF1bHQpKQ0KPiAgIAkJCQlyZXR1cm4gZmFsc2U7DQo+
ICAgCQl9IGVsc2Ugew0KPiArCQkJaWYgKGJwZl9jdHhfd2lkZV9zdG9yZV9vayhvZmYsIHNpemUs
DQo+ICsJCQkJCQkgIHN0cnVjdCBicGZfc29ja19hZGRyLA0KPiArCQkJCQkJICB1c2VyX2lwNikp
DQo+ICsJCQkJcmV0dXJuIHRydWU7DQo+ICsNCj4gKwkJCWlmIChicGZfY3R4X3dpZGVfc3RvcmVf
b2sob2ZmLCBzaXplLA0KPiArCQkJCQkJICBzdHJ1Y3QgYnBmX3NvY2tfYWRkciwNCj4gKwkJCQkJ
CSAgbXNnX3NyY19pcDYpKQ0KPiArCQkJCXJldHVybiB0cnVlOw0KPiArDQo+ICAgCQkJaWYgKHNp
emUgIT0gc2l6ZV9kZWZhdWx0KQ0KPiAgIAkJCQlyZXR1cm4gZmFsc2U7DQo+ICAgCQl9DQo+IEBA
IC03Njg5LDkgKzc2OTksNiBAQCBzdGF0aWMgdTMyIHhkcF9jb252ZXJ0X2N0eF9hY2Nlc3MoZW51
bSBicGZfYWNjZXNzX3R5cGUgdHlwZSwNCj4gICAvKiBTT0NLX0FERFJfU1RPUkVfTkVTVEVEX0ZJ
RUxEX09GRigpIGhhcyBzZW1hbnRpYyBzaW1pbGFyIHRvDQo+ICAgICogU09DS19BRERSX0xPQURf
TkVTVEVEX0ZJRUxEX1NJWkVfT0ZGKCkgYnV0IGZvciBzdG9yZSBvcGVyYXRpb24uDQo+ICAgICoN
Cj4gLSAqIEl0IGRvZXNuJ3Qgc3VwcG9ydCBTSVpFIGFyZ3VtZW50IHRob3VnaCBzaW5jZSBuYXJy
b3cgc3RvcmVzIGFyZSBub3QNCj4gLSAqIHN1cHBvcnRlZCBmb3Igbm93Lg0KPiAtICoNCj4gICAg
KiBJbiBhZGRpdGlvbiBpdCB1c2VzIFRlbXBvcmFyeSBGaWVsZCBURiAobWVtYmVyIG9mIHN0cnVj
dCBTKSBhcyB0aGUgM3JkDQo+ICAgICogInJlZ2lzdGVyIiBzaW5jZSB0d28gcmVnaXN0ZXJzIGF2
YWlsYWJsZSBpbiBjb252ZXJ0X2N0eF9hY2Nlc3MgYXJlIG5vdA0KPiAgICAqIGVub3VnaDogd2Ug
Y2FuJ3Qgb3ZlcnJpZGUgbmVpdGhlciBTUkMsIHNpbmNlIGl0IGNvbnRhaW5zIHZhbHVlIHRvIHN0
b3JlLCBub3INCj4gQEAgLTc2OTksNyArNzcwNiw3IEBAIHN0YXRpYyB1MzIgeGRwX2NvbnZlcnRf
Y3R4X2FjY2VzcyhlbnVtIGJwZl9hY2Nlc3NfdHlwZSB0eXBlLA0KPiAgICAqIGluc3RydWN0aW9u
cy4gQnV0IHdlIG5lZWQgYSB0ZW1wb3JhcnkgcGxhY2UgdG8gc2F2ZSBwb2ludGVyIHRvIG5lc3Rl
ZA0KPiAgICAqIHN0cnVjdHVyZSB3aG9zZSBmaWVsZCB3ZSB3YW50IHRvIHN0b3JlIHRvLg0KPiAg
ICAqLw0KPiAtI2RlZmluZSBTT0NLX0FERFJfU1RPUkVfTkVTVEVEX0ZJRUxEX09GRihTLCBOUywg
RiwgTkYsIE9GRiwgVEYpCQkgICAgICAgXA0KPiArI2RlZmluZSBTT0NLX0FERFJfU1RPUkVfTkVT
VEVEX0ZJRUxEX09GRihTLCBOUywgRiwgTkYsIFNJWkUsIE9GRiwgVEYpCSAgICAgICBcDQo+ICAg
CWRvIHsJCQkJCQkJCSAgICAgICBcDQo+ICAgCQlpbnQgdG1wX3JlZyA9IEJQRl9SRUdfOTsJCQkJ
ICAgICAgIFwNCj4gICAJCWlmIChzaS0+c3JjX3JlZyA9PSB0bXBfcmVnIHx8IHNpLT5kc3RfcmVn
ID09IHRtcF9yZWcpCSAgICAgICBcDQo+IEBAIC03NzEwLDggKzc3MTcsNyBAQCBzdGF0aWMgdTMy
IHhkcF9jb252ZXJ0X2N0eF9hY2Nlc3MoZW51bSBicGZfYWNjZXNzX3R5cGUgdHlwZSwNCj4gICAJ
CQkJICAgICAgb2Zmc2V0b2YoUywgVEYpKTsJCQkgICAgICAgXA0KPiAgIAkJKmluc24rKyA9IEJQ
Rl9MRFhfTUVNKEJQRl9GSUVMRF9TSVpFT0YoUywgRiksIHRtcF9yZWcsCSAgICAgICBcDQo+ICAg
CQkJCSAgICAgIHNpLT5kc3RfcmVnLCBvZmZzZXRvZihTLCBGKSk7CSAgICAgICBcDQo+IC0JCSpp
bnNuKysgPSBCUEZfU1RYX01FTSgJCQkJCSAgICAgICBcDQo+IC0JCQlCUEZfRklFTERfU0laRU9G
KE5TLCBORiksIHRtcF9yZWcsIHNpLT5zcmNfcmVnLAkgICAgICAgXA0KPiArCQkqaW5zbisrID0g
QlBGX1NUWF9NRU0oU0laRSwgdG1wX3JlZywgc2ktPnNyY19yZWcsCSAgICAgICBcDQo+ICAgCQkJ
YnBmX3RhcmdldF9vZmYoTlMsIE5GLCBGSUVMRF9TSVpFT0YoTlMsIE5GKSwJICAgICAgIFwNCj4g
ICAJCQkJICAgICAgIHRhcmdldF9zaXplKQkJCSAgICAgICBcDQo+ICAgCQkJCSsgT0ZGKTsJCQkJ
CSAgICAgICBcDQo+IEBAIC03NzIzLDggKzc3MjksOCBAQCBzdGF0aWMgdTMyIHhkcF9jb252ZXJ0
X2N0eF9hY2Nlc3MoZW51bSBicGZfYWNjZXNzX3R5cGUgdHlwZSwNCj4gICAJCQkJCQkgICAgICBU
RikJCSAgICAgICBcDQo+ICAgCWRvIHsJCQkJCQkJCSAgICAgICBcDQo+ICAgCQlpZiAodHlwZSA9
PSBCUEZfV1JJVEUpIHsJCQkJICAgICAgIFwNCj4gLQkJCVNPQ0tfQUREUl9TVE9SRV9ORVNURURf
RklFTERfT0ZGKFMsIE5TLCBGLCBORiwgT0ZGLCAgICBcDQo+IC0JCQkJCQkJIFRGKTsJCSAgICAg
ICBcDQo+ICsJCQlTT0NLX0FERFJfU1RPUkVfTkVTVEVEX0ZJRUxEX09GRihTLCBOUywgRiwgTkYs
IFNJWkUsICAgXA0KPiArCQkJCQkJCSBPRkYsIFRGKTsJICAgICAgIFwNCj4gICAJCX0gZWxzZSB7
CQkJCQkJICAgICAgIFwNCj4gICAJCQlTT0NLX0FERFJfTE9BRF9ORVNURURfRklFTERfU0laRV9P
RkYoCQkgICAgICAgXA0KPiAgIAkJCQlTLCBOUywgRiwgTkYsIFNJWkUsIE9GRik7ICBcDQo+IA0K
