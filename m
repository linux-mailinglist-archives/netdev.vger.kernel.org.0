Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A94CADE47
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 19:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391492AbfIIRxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 13:53:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64552 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728768AbfIIRxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 13:53:47 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x89HrMWM004273;
        Mon, 9 Sep 2019 10:53:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=mgLPQx1kvTqEtHhsnaI67kqLDkKXQLCdFKit0/GIfgM=;
 b=kkRkw3Z2zjPBmjQAKSRScnZfHp+BkFWXPtk8tGHwiu6xyyP1/qyq6J5ckuMIdJWJh77T
 0WgSEYJ5K5SE9R1HXYtYxYKNjG4a4VDVFEn8911lQzFx0SyBYUY4J8JTo/RaruYOS7rd
 TlC8bGiuRYzMtqS0/Nmevev7jxHbu9z1Bao= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uvv8s5uar-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 09 Sep 2019 10:53:25 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 9 Sep 2019 10:53:22 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 9 Sep 2019 10:53:22 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 9 Sep 2019 10:53:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TB828mRQfbpBKr8FjQshWEShGOxmfxYUqb+QT2fijketwTI3yve4VeJl6lc74wKGdc+FTnCmtzpH/vmNHs8kDdNc5aDkE+PsinIyPzpzNvUx3bbX0VDYA58rQtfZjXAIzUJ1TZjCKNSgzB3yQ8cneRkcsLTjMyFuLJj9BGm9sdN4nGKmMKLaUKp3m0Lh5URNt1c57h09qzWIjhlzpaWDSjmCYwMwC7rNIxagh/aZZ3KpVjGQutrV3xs4py1CH3oaDuRiB3uY/z8u5tItjVq3pCAaptbHw3t8g0w/BMCBajkdDMiSq1VD86+w9ZquddQzGi2znYyjpWxI7aRIUm7zQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgLPQx1kvTqEtHhsnaI67kqLDkKXQLCdFKit0/GIfgM=;
 b=kL00DVTEuUjaG43acpPBiZjkMUkI5DMIszte+XaBEAs/7Fe+32CE4EPxf18c/9/VoziiTd2COPKW/mL57/i2vNZ8vsh+ge0papfqzFc+iUsLL7WTQF0nO594Bov2NkLgMYEUilMNe4aONQbEqN9S4AYsokLxfR0hjKXU9sFh8b/pCEk9r26svWY4hstPNWC63T5rstBz30Qq23zqP7UiKe6v9ww1AamYDdOEO7y8AiDrcyXTAzi+hLupufJZMB5KWH3NIIOeKcgUWwwIay+rgVPcCM49toIyiFj5osCWSXNKifCLJkeJ4mNCewXujGhvNKL6vgIWS3igZGDpG+orWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgLPQx1kvTqEtHhsnaI67kqLDkKXQLCdFKit0/GIfgM=;
 b=Xen39Lg1kA04GR9e9sNCP2/ZjM0w6VJUvADjcvgzLwp0QNBJtEKr2Y3w4yMCXhwYLH2JWkrtx6FqXDfro4OAUjgLPVJICp0EA5abBa6rSf3pE21/dHo0RfhBI1a2kbpfWJEU2THgxco3VqOADXCAJZN/fuY0++hEJUGXlppwc7E=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2630.namprd15.prod.outlook.com (20.179.156.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Mon, 9 Sep 2019 17:53:21 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 17:53:21 +0000
From:   Yonghong Song <yhs@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH] libbpf: Don't error out if getsockopt() fails for
 XDP_OPTIONS
Thread-Topic: [PATCH] libbpf: Don't error out if getsockopt() fails for
 XDP_OPTIONS
Thread-Index: AQHVZzaNKJS7wgKEt0+HUZnyS02oyKcjoHoA
Date:   Mon, 9 Sep 2019 17:53:21 +0000
Message-ID: <8e909219-a225-b242-aaa5-bee1180aed48@fb.com>
References: <20190909174619.1735-1-toke@redhat.com>
In-Reply-To: <20190909174619.1735-1-toke@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1201CA0007.namprd12.prod.outlook.com
 (2603:10b6:301:4a::17) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::97ba]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a86213c2-4895-4fcc-a58e-08d7354e9a75
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2630;
x-ms-traffictypediagnostic: BYAPR15MB2630:
x-microsoft-antispam-prvs: <BYAPR15MB263090ECE4C54ADB79E316A2D3B70@BYAPR15MB2630.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(396003)(366004)(346002)(199004)(189003)(31696002)(6512007)(6246003)(53936002)(71200400001)(2501003)(71190400001)(2906002)(8936002)(66946007)(36756003)(478600001)(64756008)(66476007)(66556008)(229853002)(6486002)(256004)(66446008)(86362001)(2201001)(31686004)(6436002)(6116002)(305945005)(2616005)(46003)(476003)(81166006)(186003)(81156014)(8676002)(110136005)(25786009)(11346002)(14454004)(52116002)(76176011)(99286004)(5660300002)(386003)(316002)(53546011)(6506007)(102836004)(486006)(7736002)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2630;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SgOgfLJQ6iJOPm7rFk+udvQ/DJz6Hc2F8gLGEms/HxBJD67FARP00w/nnrEt5pvJg69QjwJTYIq7x/6f/3lO6YAD2RiylpI5Ew4+CkqYCLJXHjhRu4EQKqinovjD5Ihk9I0P/Q5+uALyFodYMLEL8xt7CycnsPkXxsbJwWD0MeMe0BA3BHzG/b98g+qbpDaxUC6CyfsKKc7QkihITlSrSDO1vb6KoM+8zbODheMnXJxYVM1GOQ0bGNH6PBK/1DPoXs6pblWnTCpE+FQPKZoxT0xClP5kACf6rw0tUI5wbMMN/TdKoYuVnPFykFt+0NOf5pI7+x2FsCe3pZ2mj1BmVdj20z6gsigiYU8FQc8ZU11jRsewBDm9e0lc9woXn5qJIe6L/vlH8GEZzJrzZ/K3gxMGvaoCnAo2/wga1Bi+8Y4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D412E3A72E42E54C98CFAF4F49A07BE8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a86213c2-4895-4fcc-a58e-08d7354e9a75
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 17:53:21.3795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9UDxR+8kia+5SVkc4oddS0eUCuMmtIoiwmB0itYmD85zFi33k+JjRQ0SGtXkXBDe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2630
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-09_07:2019-09-09,2019-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909090182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvOS8xOSAxMDo0NiBBTSwgVG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIHdyb3RlOg0K
PiBUaGUgeHNrX3NvY2tldF9fY3JlYXRlKCkgZnVuY3Rpb24gZmFpbHMgYW5kIHJldHVybnMgYW4g
ZXJyb3IgaWYgaXQgY2Fubm90DQo+IGdldCB0aGUgWERQX09QVElPTlMgdGhyb3VnaCBnZXRzb2Nr
b3B0KCkuIEhvd2V2ZXIsIHN1cHBvcnQgZm9yIFhEUF9PUFRJT05TDQo+IHdhcyBub3QgYWRkZWQg
dW50aWwga2VybmVsIDUuMywgc28gdGhpcyBtZWFucyB0aGF0IGNyZWF0aW5nIFhTSyBzb2NrZXRz
DQo+IGFsd2F5cyBmYWlscyBvbiBvbGRlciBrZXJuZWxzLg0KPiANCj4gU2luY2UgdGhlIG9wdGlv
biBpcyBqdXN0IHVzZWQgdG8gc2V0IHRoZSB6ZXJvLWNvcHkgZmxhZyBpbiB0aGUgeHNrIHN0cnVj
dCwNCj4gdGhlcmUgcmVhbGx5IGlzIG5vIG5lZWQgdG8gZXJyb3Igb3V0IGlmIHRoZSBnZXRzb2Nr
b3B0KCkgY2FsbCBmYWlscy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFRva2UgSMO4aWxhbmQtSsO4
cmdlbnNlbiA8dG9rZUByZWRoYXQuY29tPg0KPiAtLS0NCj4gICB0b29scy9saWIvYnBmL3hzay5j
IHwgOCArKy0tLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDYgZGVs
ZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi94c2suYyBiL3Rvb2xz
L2xpYi9icGYveHNrLmMNCj4gaW5kZXggNjgwZTYzMDY2Y2YzLi41OThlNDg3ZDljZTggMTAwNjQ0
DQo+IC0tLSBhL3Rvb2xzL2xpYi9icGYveHNrLmMNCj4gKysrIGIvdG9vbHMvbGliL2JwZi94c2su
Yw0KPiBAQCAtNjAzLDEyICs2MDMsOCBAQCBpbnQgeHNrX3NvY2tldF9fY3JlYXRlKHN0cnVjdCB4
c2tfc29ja2V0ICoqeHNrX3B0ciwgY29uc3QgY2hhciAqaWZuYW1lLA0KPiAgIA0KPiAgIAlvcHRs
ZW4gPSBzaXplb2Yob3B0cyk7DQo+ICAgCWVyciA9IGdldHNvY2tvcHQoeHNrLT5mZCwgU09MX1hE
UCwgWERQX09QVElPTlMsICZvcHRzLCAmb3B0bGVuKTsNCj4gLQlpZiAoZXJyKSB7DQo+IC0JCWVy
ciA9IC1lcnJubzsNCj4gLQkJZ290byBvdXRfbW1hcF90eDsNCj4gLQl9DQo+IC0NCj4gLQl4c2st
PnpjID0gb3B0cy5mbGFncyAmIFhEUF9PUFRJT05TX1pFUk9DT1BZOw0KPiArCWlmICghZXJyKQ0K
PiArCQl4c2stPnpjID0gb3B0cy5mbGFncyAmIFhEUF9PUFRJT05TX1pFUk9DT1BZOw0KPiAgIA0K
PiAgIAlpZiAoISh4c2stPmNvbmZpZy5saWJicGZfZmxhZ3MgJiBYU0tfTElCQlBGX0ZMQUdTX19J
TkhJQklUX1BST0dfTE9BRCkpIHsNCj4gICAJCWVyciA9IHhza19zZXR1cF94ZHBfcHJvZyh4c2sp
Ow0KDQpTaW5jZSAnemMnIGlzIG5vdCB1c2VkIGJ5IGFueWJvZHksIG1heWJlIGFsbCBjb2RlcyAn
emMnIHJlbGF0ZWQgY2FuIGJlIA0KcmVtb3ZlZD8gSXQgY2FuIGJlIGFkZGVkIGJhY2sgYmFjayBv
bmNlIHRoZXJlIGlzIGFuIGludGVyZmFjZSB0byB1c2UgJ3pjJz8NCg0KZGlmZiAtLWdpdCBhL3Rv
b2xzL2xpYi9icGYveHNrLmMgYi90b29scy9saWIvYnBmL3hzay5jDQppbmRleCA4NDJjNGZkNTU4
NTkuLjI0ZmEzMTM1MjRmYiAxMDA2NDQNCi0tLSBhL3Rvb2xzL2xpYi9icGYveHNrLmMNCisrKyBi
L3Rvb2xzL2xpYi9icGYveHNrLmMNCkBAIC02NSw3ICs2NSw2IEBAIHN0cnVjdCB4c2tfc29ja2V0
IHsNCiAgICAgICAgIGludCB4c2tzX21hcF9mZDsNCiAgICAgICAgIF9fdTMyIHF1ZXVlX2lkOw0K
ICAgICAgICAgY2hhciBpZm5hbWVbSUZOQU1TSVpdOw0KLSAgICAgICBib29sIHpjOw0KICB9Ow0K
DQogIHN0cnVjdCB4c2tfbmxfaW5mbyB7DQpAQCAtNDkxLDcgKzQ5MCw2IEBAIGludCB4c2tfc29j
a2V0X19jcmVhdGUoc3RydWN0IHhza19zb2NrZXQgKip4c2tfcHRyLCANCmNvbnN0IGNoYXIgKmlm
bmFtZSwNCiAgICAgICAgIHZvaWQgKnJ4X21hcCA9IE5VTEwsICp0eF9tYXAgPSBOVUxMOw0KICAg
ICAgICAgc3RydWN0IHNvY2thZGRyX3hkcCBzeGRwID0ge307DQogICAgICAgICBzdHJ1Y3QgeGRw
X21tYXBfb2Zmc2V0cyBvZmY7DQotICAgICAgIHN0cnVjdCB4ZHBfb3B0aW9ucyBvcHRzOw0KICAg
ICAgICAgc3RydWN0IHhza19zb2NrZXQgKnhzazsNCiAgICAgICAgIHNvY2tsZW5fdCBvcHRsZW47
DQogICAgICAgICBpbnQgZXJyOw0KQEAgLTYxMSwxNSArNjA5LDYgQEAgaW50IHhza19zb2NrZXRf
X2NyZWF0ZShzdHJ1Y3QgeHNrX3NvY2tldCAqKnhza19wdHIsIA0KY29uc3QgY2hhciAqaWZuYW1l
LA0KDQogICAgICAgICB4c2stPnByb2dfZmQgPSAtMTsNCg0KLSAgICAgICBvcHRsZW4gPSBzaXpl
b2Yob3B0cyk7DQotICAgICAgIGVyciA9IGdldHNvY2tvcHQoeHNrLT5mZCwgU09MX1hEUCwgWERQ
X09QVElPTlMsICZvcHRzLCAmb3B0bGVuKTsNCi0gICAgICAgaWYgKGVycikgew0KLSAgICAgICAg
ICAgICAgIGVyciA9IC1lcnJubzsNCi0gICAgICAgICAgICAgICBnb3RvIG91dF9tbWFwX3R4Ow0K
LSAgICAgICB9DQotDQotICAgICAgIHhzay0+emMgPSBvcHRzLmZsYWdzICYgWERQX09QVElPTlNf
WkVST0NPUFk7DQotDQogICAgICAgICBpZiAoISh4c2stPmNvbmZpZy5saWJicGZfZmxhZ3MgJiAN
ClhTS19MSUJCUEZfRkxBR1NfX0lOSElCSVRfUFJPR19MT0FEKSkgew0KICAgICAgICAgICAgICAg
ICBlcnIgPSB4c2tfc2V0dXBfeGRwX3Byb2coeHNrKTsNCiAgICAgICAgICAgICAgICAgaWYgKGVy
cikNCg==
