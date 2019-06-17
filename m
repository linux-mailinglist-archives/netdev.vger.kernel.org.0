Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737EA495B9
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfFQXOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:14:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5848 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726685AbfFQXOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 19:14:01 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HNCeZN023626;
        Mon, 17 Jun 2019 16:13:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kD57tCAhEL93V0zBDmeP/5lFPq4iFxwKi42Hg+SI/Gk=;
 b=NrZwJFnxkUCSc18dJcivoZXPGyzJLf0u24XyZRVSU/vlr5Ii/QGj5t5DzgShnmD4Oe/R
 moPnRlqjFx85lPJ7nLyobyA1L4ZVZkrAdbHEBBhrSnANij/0PKkz67rL63aJ8D64sJia
 zQ3PjsGo9iOgamTY9hNmH37GndYWLDwKg+4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t6e8esdna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 17 Jun 2019 16:13:06 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Jun 2019 16:13:04 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Jun 2019 16:13:04 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Jun 2019 16:13:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kD57tCAhEL93V0zBDmeP/5lFPq4iFxwKi42Hg+SI/Gk=;
 b=AAUb5EpMPnwJzVfu3tLjJlf+auzwr3HmclzDRKULjvEAmSX+Ue+UaS6XglX08QdxX8ClInSuCkSSe0IB9vM5YwWZFAo/2YHtCMfQQOcWFtmlWRqXcrLEBqrQIZaXLnAXaqOAlVgeiGE+0tJyTu0GRRsG7shI+YZmtrBT4yg+eyE=
Received: from MWHPR15MB1262.namprd15.prod.outlook.com (10.175.3.141) by
 MWHPR15MB1951.namprd15.prod.outlook.com (10.175.9.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Mon, 17 Jun 2019 23:13:03 +0000
Received: from MWHPR15MB1262.namprd15.prod.outlook.com
 ([fe80::80df:7291:9855:e8bc]) by MWHPR15MB1262.namprd15.prod.outlook.com
 ([fe80::80df:7291:9855:e8bc%8]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 23:13:03 +0000
From:   Matt Mullins <mmullins@fb.com>
To:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Song Liu <songliubraving@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "arnd@arndb.de" <arnd@arndb.de>, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH] bpf: hide do_bpf_send_signal when unused
Thread-Topic: [PATCH] bpf: hide do_bpf_send_signal when unused
Thread-Index: AQHVJQxLE8bACzewukSK6TikAan5uKaf9/mAgACBUQCAAAEIgA==
Date:   Mon, 17 Jun 2019 23:13:03 +0000
Message-ID: <75e9ff40e1002ad9c82716dfd77966a3721022b6.camel@fb.com>
References: <20190617125724.1616165-1-arnd@arndb.de>
         <CAADnVQ+LzuNHFyLae0vUAudZpOFQ4cA02OC0zu3ypis+gqnjew@mail.gmail.com>
         <20190617190920.71c21a6c@gandalf.local.home>
In-Reply-To: <20190617190920.71c21a6c@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-originating-ip: [2620:10d:c090:200::1:b232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f1b1b3d-282f-433b-9ed2-08d6f3795942
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1951;
x-ms-traffictypediagnostic: MWHPR15MB1951:
x-microsoft-antispam-prvs: <MWHPR15MB19519F98D6857F8AA6BFB3E6B0EB0@MWHPR15MB1951.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(136003)(39860400002)(396003)(366004)(189003)(199004)(68736007)(102836004)(486006)(86362001)(186003)(14454004)(6116002)(76176011)(53546011)(256004)(6506007)(71200400001)(53936002)(6512007)(14444005)(99286004)(2906002)(110136005)(446003)(7736002)(81156014)(76116006)(64756008)(8936002)(2616005)(11346002)(476003)(36756003)(6246003)(229853002)(6436002)(6486002)(71190400001)(66446008)(73956011)(54906003)(66556008)(25786009)(316002)(81166006)(118296001)(50226002)(2501003)(478600001)(8676002)(4326008)(5660300002)(46003)(66476007)(305945005)(66946007)(99106002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1951;H:MWHPR15MB1262.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KNUVxvXn1aB30hU1FfwKzUP6nQiHHmHFvvMA2J0gWiZuDlQvI2+3wm7v19sxv3f56J91eK18gcxOk3X/uIYFNiNw2C5t3PqkcBNQWwqqKZ0bIdXnV0irSyTCnpGDZowC/04sqmHGTVkfxuHqI7vWRyNZJl8gTmjOngMOPQm7e+C+OEr6JrzJThWxN/wqJKger8ISB4BYtPYYatxh+RUQirT+7OtJM0DAYxFGuUOkHRUyrh8FQIvzfrJ4OR7nexhQgReArMN82LoT/Oyz28g97O3/cciZco44e7XX0rx9hW0nNZ7gIJJfIH7dHp16ehiKpVENdavdG4uJ2ONPKj6BT+eVXhNfV/g9pOatSU5oBsQ+urhrdkJlALyZ8S7c0sD+UCAJ5a4yaCBHIlyAF9SbZLtZsZwEtZjfkvM2xwb/WDQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C79D25D67040F1448F425649F73E8E09@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1b1b3d-282f-433b-9ed2-08d6f3795942
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 23:13:03.1983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mmullins@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1951
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTE3IGF0IDE5OjA5IC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gTW9uLCAxNyBKdW4gMjAxOSAwODoyNjoyOSAtMDcwMA0KPiBBbGV4ZWkgU3Rhcm92b2l0
b3YgPGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+IHdyb3RlOg0KPiANCj4gPiBPbiBNb24s
IEp1biAxNywgMjAxOSBhdCA1OjU5IEFNIEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+IHdy
b3RlOg0KPiA+ID4gDQo+ID4gPiBXaGVuIENPTkZJR19NT0RVTEVTIGlzIGRpc2FibGVkLCB0aGlz
IGZ1bmN0aW9uIGlzIG5ldmVyIGNhbGxlZDoNCj4gPiA+IA0KPiA+ID4ga2VybmVsL3RyYWNlL2Jw
Zl90cmFjZS5jOjU4MToxMzogZXJyb3I6ICdkb19icGZfc2VuZF9zaWduYWwnIGRlZmluZWQgYnV0
IG5vdCB1c2VkIFstV2Vycm9yPXVudXNlZC1mdW5jdGlvbl0gIA0KPiA+IA0KPiA+IGhtbS4gaXQg
c2hvdWxkIHdvcmsganVzdCBmaW5lIHdpdGhvdXQgbW9kdWxlcy4NCj4gPiB0aGUgYnVnIGlzIHNv
bWV3aGVyZSBlbHNlLg0KPiANCj4gRnJvbSB3aGF0IEkgc2VlLCB0aGUgb25seSB1c2Ugb2YgZG9f
YnBmX3NlbmRfc2lnbmFsIGlzIHdpdGhpbiBhDQo+ICNpZmRlZiBDT05GSUdfTU9EVUxFUywgd2hp
Y2ggbWVhbnMgdGhhdCB5b3Ugd2lsbCBnZXQgYSB3YXJuaW5nIGFib3V0IGENCj4gc3RhdGljIHVu
dXNlZCB3aGVuIENPTkZJR19NT0RVTEVTIGlzIG5vdCBkZWZpbmVkLg0KPiANCj4gSW4ga2VybmVs
L3RyYWNlL2JwZl90cmFjZS5jIHdlIGhhdmU6DQo+IA0KPiBzdGF0aWMgdm9pZCBkb19icGZfc2Vu
ZF9zaWduYWwoc3RydWN0IGlycV93b3JrICplbnRyeSkNCj4gDQo+IFsuLl0NCj4gDQo+ICNpZmRl
ZiBDT05GSUdfTU9EVUxFUw0KPiANCj4gWy4uXQ0KPiANCj4gICAgICAgICBmb3JfZWFjaF9wb3Nz
aWJsZV9jcHUoY3B1KSB7DQo+ICAgICAgICAgICAgICAgICB3b3JrID0gcGVyX2NwdV9wdHIoJnNl
bmRfc2lnbmFsX3dvcmssIGNwdSk7DQo+ICAgICAgICAgICAgICAgICBpbml0X2lycV93b3JrKCZ3
b3JrLT5pcnFfd29yaywgZG9fYnBmX3NlbmRfc2lnbmFsKTsgIDwtLSBvbiB1c2Ugb2YgZG9fYnBm
X3NlbmRfc2lnbmFsDQo+ICAgICAgICAgfQ0KPiBbLi5dDQo+ICNlbmRpZiAvKiBDT05GSUdfTU9E
VUxFUyAqLw0KPiANCj4gVGhlIGJ1ZyAocmVhbGx5IGp1c3QgYSB3YXJuaW5nKSByZXBvcnRlZCBp
cyBleGFjdGx5IGhlcmUuDQoNCkkgZG9uJ3QgdGhpbmsgYnBmX3NlbmRfc2lnbmFsIGlzIHRpZWQg
dG8gbW9kdWxlcyBhdCBhbGw7DQpzZW5kX3NpZ25hbF9pcnFfd29ya19pbml0IGFuZCB0aGUgY29y
cmVzcG9uZGluZyBpbml0Y2FsbCBzaG91bGQgYmUNCm1vdmVkIG91dHNpZGUgdGhhdCAjaWZkZWYu
DQoNCj4gDQo+IC0tIFN0ZXZlDQo=
