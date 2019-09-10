Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61545AF304
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 00:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfIJWrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 18:47:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35038 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725937AbfIJWrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 18:47:14 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8AMi45s005321;
        Tue, 10 Sep 2019 15:47:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BfkJJhuF9wCwFZXwYqrcbmHR+CR1V+7Ik8jx3Bq9fBk=;
 b=Z0gTCYbgpuJKcVKjsTA1vr9Gz68h84YqBrzwOUdUuihtU6nJQ9AGdqxicWCU6kM71JGR
 n2dxQNx0B8uu+CkuGdOJTdPesD5yZzKJe0fhTLUd6TvxCN9sCW/GF/SQTulo3wFdYsfs
 BV72RbvaZsaoLPqk4ft4K6DhXwS36v1LhJs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uxaj2um3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Sep 2019 15:47:08 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 10 Sep 2019 15:47:07 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Sep 2019 15:47:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gauIVBBIdg9FG20L2zl7VZqoHIDYZzKpfp9IDmj/yHmwBdvrxjGLq/FReWMOz2LoXrxfcYBkWMHqhtUpF2+aqePTsytRIQxC1XnG1DZmW9KVrba4j4BMQdZuqMLfmnndGI6XvTeEnriXzH1uVV5PkNGK38eEBvTe7SovZ+x+dElDzCSpz2yqbdCU+oIxOmvAY2NIs6F/9Bg2wjq8hG7DSDSs2xtwqRc3QW1Wz9zsyiRNwhZOOfesZFuIM/EmZWctST62B61wD5mEYHM+qzpWiRuAysw3oCCm6V7C1jQmMgopz7JxcnVVx7G3Un4iCdNo7Vtvv7lf8VN/VRHQ/AU6DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfkJJhuF9wCwFZXwYqrcbmHR+CR1V+7Ik8jx3Bq9fBk=;
 b=LvL/ljNGTL8+YSHPOEoBVe5jhr0s7pGQYP5O7NcqQ+yRF6+lYsC/qeCbGPY/izWngDQln3Kdz8UMe7deJjhBankP9f9JIN65zgL5q8zQpxLgIjckx20xzU+68OUo7TH3VCSdoTHdFjAImDnNM/U+FoUmPNJuRVw4LLBKShMt4Jn8FXXRuIVN6qYyy9Vosbou+/YLSikUVbGdoOA/Zsd9gD7Z977SPMtThFRrkbGYR2h+FIskpbVRz6pCCVJjf78EVhRnWq/vxCfBJIavQKTyBABxpDKdzuN5hxoUpZ1Hz+piQXRTnq+3+SfJDyUwOTXGrftvGDJI0lyt2nvzR+NL4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfkJJhuF9wCwFZXwYqrcbmHR+CR1V+7Ik8jx3Bq9fBk=;
 b=R0+vs93oy9pucACnRKoDc/OZhy+DhM2BlfUJB5sL35FJJTtFE8x+hbpfMPFGu22w2YN/lgvRTgYf8KY8OmJwVIBWiVWCXzoG/68EQraGAX3+uSwKwJKoxksU1Ojn0JAQfCvqyWJTzXHek6WdriKE6nzffr6i+t69f7bC69Z8Zn4=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2344.namprd15.prod.outlook.com (52.135.200.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.17; Tue, 10 Sep 2019 22:46:46 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 22:46:46 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace data
 from current task New bpf helper bpf_get_current_pidns_info.
Thread-Topic: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from current task New bpf helper bpf_get_current_pidns_info.
Thread-Index: AQHVaCmfbQtShUgPA0KP+q7iQiS8CQ==
Date:   Tue, 10 Sep 2019 22:46:45 +0000
Message-ID: <c5ecd602-8b45-94bd-96e8-2264a88a3c09@fb.com>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
 <20190906150952.23066-3-cneirabustos@gmail.com>
In-Reply-To: <20190906150952.23066-3-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0023.namprd14.prod.outlook.com
 (2603:10b6:301:4b::33) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::6b76]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e82ccee-d67c-47b2-3a86-08d73640c20b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2344;
x-ms-traffictypediagnostic: BYAPR15MB2344:
x-microsoft-antispam-prvs: <BYAPR15MB23446448B50012AEE7786A61D3B60@BYAPR15MB2344.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(476003)(2616005)(256004)(14444005)(11346002)(229853002)(76176011)(71200400001)(386003)(53546011)(6506007)(71190400001)(14454004)(31696002)(25786009)(6486002)(102836004)(110136005)(54906003)(6512007)(86362001)(2501003)(316002)(81156014)(81166006)(36756003)(478600001)(8936002)(186003)(446003)(7736002)(486006)(6246003)(2906002)(53936002)(305945005)(99286004)(6116002)(52116002)(6436002)(31686004)(4326008)(66946007)(66476007)(66446008)(64756008)(66556008)(46003)(5660300002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2344;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wRHE6Cx/ogjshvfV1nRKVBWuudhKzdNUEmYB4CuNHdx+XtKYW0xQhabl5IfJuYKVwXDrDL0GcGZZY/ZpdLVqGhNeCIWDng3vRgLVCajoT+uw62E9YRDiuUtJqbff23iS+F+cJ7PcqNwkrAxr2u3tPw1O7Cn3ZMvDXPH67+XnkpCpOCZOhm8Ro3VVxKj6dtjhnRHrHxY/iMfACuQ7ZI8gHJJ1Ao7xQiOnqWV2IoBO2osEj1oWOCdAMauLRyxXypZYJ3vXxwyJJcHF6lqr5fRRvb/ccVVgOE/30vOo/J6RpdoETTI8ia5o8uQ3YxC3a4apzsc86FW20jaYbZdytWQDY8d9ebg/SWW8yM+4fWQfS3rSyM4jA4kwciM3+Bk8YvpojXljCB0XIDyTH4wMG4gi/1UGnQxakPxArfIFyzWsMX8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D9727CF3171294883E552E4B4F916E9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e82ccee-d67c-47b2-3a86-08d73640c20b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 22:46:45.9016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7FMMb9oGdjMIfi3d/FOmAbn7x99weuBu+PoHceU47vJMrVr4EVMKPE+18pdIszJf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2344
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-10_12:2019-09-10,2019-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 phishscore=0 clxscore=1015 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909100211
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvNi8xOSA0OjA5IFBNLCBDYXJsb3MgTmVpcmEgd3JvdGU6DQo+IFRoaXMgaGVscGVy
KGJwZl9nZXRfY3VycmVudF9waWRuc19pbmZvKSBvYnRhaW5zIHRoZSBhY3RpdmUgbmFtZXNwYWNl
IGZyb20NCj4gY3VycmVudCBhbmQgcmV0dXJucyBwaWQsIHRnaWQsIGRldmljZSBhbmQgbmFtZXNw
YWNlIGlkIGFzIHNlZW4gZnJvbSB0aGF0DQo+IG5hbWVzcGFjZSwgYWxsb3dpbmcgdG8gaW5zdHJ1
bWVudCBhIHByb2Nlc3MgaW5zaWRlIGEgY29udGFpbmVyLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
Q2FybG9zIE5laXJhIDxjbmVpcmFidXN0b3NAZ21haWwuY29tPg0KPiAtLS0NCj4gICBpbmNsdWRl
L2xpbnV4L2JwZi5oICAgICAgfCAgMSArDQo+ICAgaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIHwg
MzUgKysrKysrKysrKysrKysrKysrKy0NCj4gICBrZXJuZWwvYnBmL2NvcmUuYyAgICAgICAgfCAg
MSArDQo+ICAga2VybmVsL2JwZi9oZWxwZXJzLmMgICAgIHwgODYgKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAga2VybmVsL3RyYWNlL2JwZl90cmFj
ZS5jIHwgIDIgKysNCj4gICA1IGZpbGVzIGNoYW5nZWQsIDEyNCBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9icGYuaCBiL2luY2x1
ZGUvbGludXgvYnBmLmgNCj4gaW5kZXggNWI5ZDIyMzM4NjA2Li44MTljYjFjODRiZTAgMTAwNjQ0
DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvYnBmLmgNCj4gKysrIGIvaW5jbHVkZS9saW51eC9icGYu
aA0KPiBAQCAtMTA1NSw2ICsxMDU1LDcgQEAgZXh0ZXJuIGNvbnN0IHN0cnVjdCBicGZfZnVuY19w
cm90byBicGZfZ2V0X2xvY2FsX3N0b3JhZ2VfcHJvdG87DQo+ICAgZXh0ZXJuIGNvbnN0IHN0cnVj
dCBicGZfZnVuY19wcm90byBicGZfc3RydG9sX3Byb3RvOw0KPiAgIGV4dGVybiBjb25zdCBzdHJ1
Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX3N0cnRvdWxfcHJvdG87DQo+ICAgZXh0ZXJuIGNvbnN0IHN0
cnVjdCBicGZfZnVuY19wcm90byBicGZfdGNwX3NvY2tfcHJvdG87DQo+ICtleHRlcm4gY29uc3Qg
c3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9nZXRfY3VycmVudF9waWRuc19pbmZvX3Byb3RvOw0K
PiAgIA0KPiAgIC8qIFNoYXJlZCBoZWxwZXJzIGFtb25nIGNCUEYgYW5kIGVCUEYuICovDQo+ICAg
dm9pZCBicGZfdXNlcl9ybmRfaW5pdF9vbmNlKHZvaWQpOw0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS91YXBpL2xpbnV4L2JwZi5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+IGluZGV4IGI1
ODg5MjU3Y2MzMy4uM2VjOWFhMTQzOGI3IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3VhcGkvbGlu
dXgvYnBmLmgNCj4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+IEBAIC0yNzQ3LDYg
KzI3NDcsMzIgQEAgdW5pb24gYnBmX2F0dHIgew0KPiAgICAqCQkqKi1FT1BOT1RTVVBQKioga2Vy
bmVsIGNvbmZpZ3VyYXRpb24gZG9lcyBub3QgZW5hYmxlIFNZTiBjb29raWVzDQo+ICAgICoNCj4g
ICAgKgkJKiotRVBST1RPTk9TVVBQT1JUKiogSVAgcGFja2V0IHZlcnNpb24gaXMgbm90IDQgb3Ig
Ng0KPiArICoNCj4gKyAqIGludCBicGZfZ2V0X2N1cnJlbnRfcGlkbnNfaW5mbyhzdHJ1Y3QgYnBm
X3BpZG5zX2luZm8gKnBpZG5zLCB1MzIgc2l6ZV9vZl9waWRucykNCj4gKyAqCURlc2NyaXB0aW9u
DQo+ICsgKgkJR2V0IHRnaWQsIHBpZCBhbmQgbmFtZXNwYWNlIGlkIGFzIHNlZW4gYnkgdGhlIGN1
cnJlbnQgbmFtZXNwYWNlLA0KPiArICoJCWFuZCBkZXZpY2UgbWFqb3IvbWlub3IgbnVtYmVycyBm
cm9tIC9wcm9jL3NlbGYvbnMvcGlkLiBTdWNoDQo+ICsgKgkJaW5mb3JtYXRpb24gaXMgc3RvcmVk
IGluICpwaWRucyogb2Ygc2l6ZSAqc2l6ZSouDQo+ICsgKg0KPiArICoJCVRoaXMgaGVscGVyIGlz
IHVzZWQgd2hlbiBwaWQgZmlsdGVyaW5nIGlzIG5lZWRlZCBpbnNpZGUgYQ0KPiArICoJCWNvbnRh
aW5lciBhcyBicGZfZ2V0X2N1cnJlbnRfdGdpZCgpIGhlbHBlciBhbHdheXMgcmV0dXJucyB0aGUN
Cj4gKyAqCQlwaWQgaWQgYXMgc2VlbiBieSB0aGUgcm9vdCBuYW1lc3BhY2UuDQo+ICsgKglSZXR1
cm4NCj4gKyAqCQkwIG9uIHN1Y2Nlc3MNCj4gKyAqDQo+ICsgKgkJT24gZmFpbHVyZSwgdGhlIHJl
dHVybmVkIHZhbHVlIGlzIG9uZSBvZiB0aGUgZm9sbG93aW5nOg0KPiArICoNCj4gKyAqCQkqKi1F
SU5WQUwqKiBpZiAqc2l6ZV9vZl9waWRucyogaXMgbm90IHZhbGlkIG9yIHVuYWJsZSB0byBnZXQg
bnMsIHBpZA0KPiArICoJCW9yIHRnaWQgb2YgdGhlIGN1cnJlbnQgdGFzay4NCj4gKyAqDQo+ICsg
KgkJKiotRU5PRU5UKiogaWYgL3Byb2Mvc2VsZi9ucy9waWQgZG9lcyBub3QgZXhpc3RzLg0KPiAr
ICoNCj4gKyAqCQkqKi1FTk9FTlQqKiBpZiAvcHJvYy9zZWxmL25zIGRvZXMgbm90IGV4aXN0cy4N
Cj4gKyAqDQo+ICsgKgkJKiotRU5PTUVNKiogaWYgaGVscGVyIGludGVybmFsIGFsbG9jYXRpb24g
ZmFpbHMuDQoNCi1FTk9NRU0gY2FuIGJlIHJlbW92ZWQuDQoNCj4gKyAqDQo+ICsgKgkJKiotRVBF
Uk0qKiBpZiBub3QgYWJsZSB0byBjYWxsIGhlbHBlci4NCj4gKyAqDQo+ICAgICovDQo+ICAgI2Rl
ZmluZSBfX0JQRl9GVU5DX01BUFBFUihGTikJCVwNCj4gICAJRk4odW5zcGVjKSwJCQlcDQo+IEBA
IC0yODU5LDcgKzI4ODUsOCBAQCB1bmlvbiBicGZfYXR0ciB7DQo+ICAgCUZOKHNrX3N0b3JhZ2Vf
Z2V0KSwJCVwNCj4gICAJRk4oc2tfc3RvcmFnZV9kZWxldGUpLAkJXA0KPiAgIAlGTihzZW5kX3Np
Z25hbCksCQlcDQo+IC0JRk4odGNwX2dlbl9zeW5jb29raWUpLA0KPiArCUZOKHRjcF9nZW5fc3lu
Y29va2llKSwJCVwNCj4gKwlGTihnZXRfY3VycmVudF9waWRuc19pbmZvKSwNCj4gICANCj4gICAv
KiBpbnRlZ2VyIHZhbHVlIGluICdpbW0nIGZpZWxkIG9mIEJQRl9DQUxMIGluc3RydWN0aW9uIHNl
bGVjdHMgd2hpY2ggaGVscGVyDQo+ICAgICogZnVuY3Rpb24gZUJQRiBwcm9ncmFtIGludGVuZHMg
dG8gY2FsbA0KPiBAQCAtMzYxMCw0ICszNjM3LDEwIEBAIHN0cnVjdCBicGZfc29ja29wdCB7DQo+
ICAgCV9fczMyCXJldHZhbDsNCj4gICB9Ow0KPiAgIA0KPiArc3RydWN0IGJwZl9waWRuc19pbmZv
IHsNCj4gKwlfX3UzMiBkZXY7CS8qIGRldl90IGZyb20gL3Byb2Mvc2VsZi9ucy9waWQgaW5vZGUg
Ki8NCg0KICAgIC8qIGRldl90IG9mIHBpZCBuYW1lc3BhY2UgcHNldWRvIGZpbGUgKHR5cGljYWxs
eSAvcHJvYy9zZWVsZi9ucy9waWQpIA0KYWZ0ZXIgZm9sbG93aW5nIHN5bWJvbGljIGxpbmsgKi8N
Cg0KPiArCV9fdTMyIG5zaWQ7DQo+ICsJX191MzIgdGdpZDsNCj4gKwlfX3UzMiBwaWQ7DQo+ICt9
Ow0KPiAgICNlbmRpZiAvKiBfVUFQSV9fTElOVVhfQlBGX0hfXyAqLw0KPiBkaWZmIC0tZ2l0IGEv
a2VybmVsL2JwZi9jb3JlLmMgYi9rZXJuZWwvYnBmL2NvcmUuYw0KPiBpbmRleCA4MTkxYTdkYjI3
NzcuLjMxNTlmMmEwMTg4YyAxMDA2NDQNCj4gLS0tIGEva2VybmVsL2JwZi9jb3JlLmMNCj4gKysr
IGIva2VybmVsL2JwZi9jb3JlLmMNCj4gQEAgLTIwMzgsNiArMjAzOCw3IEBAIGNvbnN0IHN0cnVj
dCBicGZfZnVuY19wcm90byBicGZfZ2V0X2N1cnJlbnRfdWlkX2dpZF9wcm90byBfX3dlYWs7DQo+
ICAgY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl9nZXRfY3VycmVudF9jb21tX3Byb3Rv
IF9fd2VhazsNCj4gICBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX2dldF9jdXJyZW50
X2Nncm91cF9pZF9wcm90byBfX3dlYWs7DQo+ICAgY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3Rv
IGJwZl9nZXRfbG9jYWxfc3RvcmFnZV9wcm90byBfX3dlYWs7DQo+ICtjb25zdCBzdHJ1Y3QgYnBm
X2Z1bmNfcHJvdG8gYnBmX2dldF9jdXJyZW50X3BpZG5zX2luZm8gX193ZWFrOw0KPiAgIA0KPiAg
IGNvbnN0IHN0cnVjdCBicGZfZnVuY19wcm90byAqIF9fd2VhayBicGZfZ2V0X3RyYWNlX3ByaW50
a19wcm90byh2b2lkKQ0KPiAgIHsNCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYvaGVscGVycy5j
IGIva2VybmVsL2JwZi9oZWxwZXJzLmMNCj4gaW5kZXggNWUyODcxODkyOGNhLi44ZGJlNjM0Nzg5
M2MgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9icGYvaGVscGVycy5jDQo+ICsrKyBiL2tlcm5lbC9i
cGYvaGVscGVycy5jDQo+IEBAIC0xMSw2ICsxMSwxMSBAQA0KPiAgICNpbmNsdWRlIDxsaW51eC91
aWRnaWQuaD4NCj4gICAjaW5jbHVkZSA8bGludXgvZmlsdGVyLmg+DQo+ICAgI2luY2x1ZGUgPGxp
bnV4L2N0eXBlLmg+DQo+ICsjaW5jbHVkZSA8bGludXgvcGlkX25hbWVzcGFjZS5oPg0KPiArI2lu
Y2x1ZGUgPGxpbnV4L2tkZXZfdC5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L3N0YXQuaD4NCj4gKyNp
bmNsdWRlIDxsaW51eC9uYW1laS5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L3ZlcnNpb24uaD4NCj4g
ICANCj4gICAjaW5jbHVkZSAiLi4vLi4vbGliL2tzdHJ0b3guaCINCj4gICANCj4gQEAgLTMxMiw2
ICszMTcsODcgQEAgdm9pZCBjb3B5X21hcF92YWx1ZV9sb2NrZWQoc3RydWN0IGJwZl9tYXAgKm1h
cCwgdm9pZCAqZHN0LCB2b2lkICpzcmMsDQo+ICAgCXByZWVtcHRfZW5hYmxlKCk7DQo+ICAgfQ0K
PiAgIA0KPiArQlBGX0NBTExfMihicGZfZ2V0X2N1cnJlbnRfcGlkbnNfaW5mbywgc3RydWN0IGJw
Zl9waWRuc19pbmZvICosIHBpZG5zX2luZm8sIHUzMiwNCj4gKwkgc2l6ZSkNCj4gK3sNCj4gKwlj
b25zdCBjaGFyICpwaWRuc19wYXRoID0gIi9wcm9jL3NlbGYvbnMvcGlkIjsNCj4gKwlzdHJ1Y3Qg
cGlkX25hbWVzcGFjZSAqcGlkbnMgPSBOVUxMOw0KPiArCXN0cnVjdCBmaWxlbmFtZSAqZm5hbWUg
PSBOVUxMOw0KPiArCXN0cnVjdCBpbm9kZSAqaW5vZGU7DQo+ICsJc3RydWN0IHBhdGgga3A7DQo+
ICsJcGlkX3QgdGdpZCA9IDA7DQo+ICsJcGlkX3QgcGlkID0gMDsNCj4gKwlpbnQgcmV0ID0gLUVJ
TlZBTDsNCj4gKwlpbnQgbGVuOw0KPiArDQo+ICsJaWYgKHVubGlrZWx5KGluX2ludGVycnVwdCgp
IHx8DQo+ICsJCQljdXJyZW50LT5mbGFncyAmIChQRl9LVEhSRUFEIHwgUEZfRVhJVElORykpKQ0K
PiArCQlyZXR1cm4gLUVQRVJNOw0KPiArDQo+ICsJaWYgKHVubGlrZWx5KHNpemUgIT0gc2l6ZW9m
KHN0cnVjdCBicGZfcGlkbnNfaW5mbykpKQ0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gKw0KPiAr
CXBpZG5zID0gdGFza19hY3RpdmVfcGlkX25zKGN1cnJlbnQpOw0KPiArCWlmICh1bmxpa2VseSgh
cGlkbnMpKQ0KPiArCQlyZXR1cm4gLUVOT0VOVDsNCj4gKw0KPiArCXBpZG5zX2luZm8tPm5zaWQg
PSAgcGlkbnMtPm5zLmludW07DQo+ICsJcGlkID0gdGFza19waWRfbnJfbnMoY3VycmVudCwgcGlk
bnMpOw0KPiArCWlmICh1bmxpa2VseSghcGlkKSkNCj4gKwkJZ290byBjbGVhcjsNCj4gKw0KPiAr
CXRnaWQgPSB0YXNrX3RnaWRfbnJfbnMoY3VycmVudCwgcGlkbnMpOw0KPiArCWlmICh1bmxpa2Vs
eSghdGdpZCkpDQo+ICsJCWdvdG8gY2xlYXI7DQo+ICsNCj4gKwlwaWRuc19pbmZvLT50Z2lkID0g
KHUzMikgdGdpZDsNCj4gKwlwaWRuc19pbmZvLT5waWQgPSAodTMyKSBwaWQ7DQo+ICsNClsuLi5d
DQo+ICsJZm5hbWUgPSBrbWVtX2NhY2hlX2FsbG9jKG5hbWVzX2NhY2hlcCwgR0ZQX0FUT01JQyk7
DQo+ICsJaWYgKHVubGlrZWx5KCFmbmFtZSkpIHsNCj4gKwkJcmV0ID0gLUVOT01FTTsNCj4gKwkJ
Z290byBjbGVhcjsNCj4gKwl9DQo+ICsJY29uc3Qgc2l6ZV90IGZuYW1lc2l6ZSA9IG9mZnNldG9m
KHN0cnVjdCBmaWxlbmFtZSwgaW5hbWVbMV0pOw0KPiArCXN0cnVjdCBmaWxlbmFtZSAqdG1wOw0K
PiArDQo+ICsJdG1wID0ga21hbGxvYyhmbmFtZXNpemUsIEdGUF9BVE9NSUMpOw0KPiArCWlmICh1
bmxpa2VseSghdG1wKSkgew0KPiArCQlfX3B1dG5hbWUoZm5hbWUpOw0KPiArCQlyZXQgPSAtRU5P
TUVNOw0KPiArCQlnb3RvIGNsZWFyOw0KPiArCX0NCj4gKw0KPiArCXRtcC0+bmFtZSA9IChjaGFy
ICopZm5hbWU7DQo+ICsJZm5hbWUgPSB0bXA7DQo+ICsJbGVuID0gc3RybGVuKHBpZG5zX3BhdGgp
ICsgMTsNCj4gKwltZW1jcHkoKGNoYXIgKilmbmFtZS0+bmFtZSwgcGlkbnNfcGF0aCwgbGVuKTsN
Cj4gKwlmbmFtZS0+dXB0ciA9IE5VTEw7DQo+ICsJZm5hbWUtPmFuYW1lID0gTlVMTDsNCj4gKwlm
bmFtZS0+cmVmY250ID0gMTsNCj4gKw0KPiArCXJldCA9IGZpbGVuYW1lX2xvb2t1cChBVF9GRENX
RCwgZm5hbWUsIDAsICZrcCwgTlVMTCk7DQo+ICsJaWYgKHJldCkNCj4gKwkJZ290byBjbGVhcjsN
Cj4gKw0KPiArCWlub2RlID0gZF9iYWNraW5nX2lub2RlKGtwLmRlbnRyeSk7DQo+ICsJcGlkbnNf
aW5mby0+ZGV2ID0gKHUzMilpbm9kZS0+aV9yZGV2Ow0KVGhlIGFib3ZlIGNhbiBiZWUgcmVwbGFj
ZWQgd2l0aCBuZXcgbnNmcyBpbnRlcmZhY2UgZnVuY3Rpb24NCm5zX2dldF9pbnVtX2RldigpLg0K
PiArDQo+ICsJcmV0dXJuIDA7DQo+ICsNCj4gK2NsZWFyOg0KPiArCW1lbXNldCgodm9pZCAqKXBp
ZG5zX2luZm8sIDAsIChzaXplX3QpIHNpemUpOw0KPiArCXJldHVybiByZXQ7DQo+ICt9DQo+ICsN
Cj4gK2NvbnN0IHN0cnVjdCBicGZfZnVuY19wcm90byBicGZfZ2V0X2N1cnJlbnRfcGlkbnNfaW5m
b19wcm90byA9IHsNCj4gKwkuZnVuYwkJPSBicGZfZ2V0X2N1cnJlbnRfcGlkbnNfaW5mbywNCj4g
KwkuZ3BsX29ubHkJPSBmYWxzZSwNCj4gKwkucmV0X3R5cGUJPSBSRVRfSU5URUdFUiwNCj4gKwku
YXJnMV90eXBlCT0gQVJHX1BUUl9UT19VTklOSVRfTUVNLA0KPiArCS5hcmcyX3R5cGUJPSBBUkdf
Q09OU1RfU0laRSwNCj4gK307DQo+ICsNCj4gICAjaWZkZWYgQ09ORklHX0NHUk9VUFMNCj4gICBC
UEZfQ0FMTF8wKGJwZl9nZXRfY3VycmVudF9jZ3JvdXBfaWQpDQo+ICAgew0KPiBkaWZmIC0tZ2l0
IGEva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jIGIva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQo+
IGluZGV4IGNhMTI1NWQxNDU3Ni4uNWUxZGMyMjc2NWE1IDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwv
dHJhY2UvYnBmX3RyYWNlLmMNCj4gKysrIGIva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQo+IEBA
IC03MDksNiArNzA5LDggQEAgdHJhY2luZ19mdW5jX3Byb3RvKGVudW0gYnBmX2Z1bmNfaWQgZnVu
Y19pZCwgY29uc3Qgc3RydWN0IGJwZl9wcm9nICpwcm9nKQ0KPiAgICNlbmRpZg0KPiAgIAljYXNl
IEJQRl9GVU5DX3NlbmRfc2lnbmFsOg0KPiAgIAkJcmV0dXJuICZicGZfc2VuZF9zaWduYWxfcHJv
dG87DQo+ICsJY2FzZSBCUEZfRlVOQ19nZXRfY3VycmVudF9waWRuc19pbmZvOg0KPiArCQlyZXR1
cm4gJmJwZl9nZXRfY3VycmVudF9waWRuc19pbmZvX3Byb3RvOw0KPiAgIAlkZWZhdWx0Og0KPiAg
IAkJcmV0dXJuIE5VTEw7DQo+ICAgCX0NCj4gDQo=
