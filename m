Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A608666BB
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 08:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfGLGDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 02:03:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64268 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725807AbfGLGDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 02:03:44 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6C62DjO010875;
        Thu, 11 Jul 2019 23:03:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=15gAhCCoNvFMx4Fc3AR0OjP+hRuR2Juf4ipucdBgHKE=;
 b=R5M01xMdWq7Fmnv9vuJsu/ZKfmfN4LX02cywmjgzxbrY2kLX0nwIblsgKDDbps4yPwBj
 1peVb0lwtvsrVHjm7EM3YdyxChB5VRcY5ytQVkVY5iJZKklu67pNqyghbpiJLmD8TF+Y
 DVM84w7D0w70zTDvkoU2OzVcgjNux8+iTAg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2tpk9u86nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 11 Jul 2019 23:03:22 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 11 Jul 2019 23:03:16 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 11 Jul 2019 23:03:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfnMmJevbVgZRgYOMKlurZ3Y/K+hXWRSUMA/rNXyxe9/GyHi/Bzqe90fGWlYn2BVnpjftPaELe1oBtDFoCXsEn4IKbvsqOKODcK/FrJq7zhiHSWI5CoUpVKK5CBg9q1nvuS6irjKMRA2veOtCoHb6Pb4UDMhMpc6kjYfbDpgvEbHNZYGmxQNQytSNPMhngsNoNZxLaywIlP4ThgTHv2UrXZ5i8jVZEJLfPzds4fI4BrFrJaxElhyDzsdOGPAzqEd9OoA+uybGdBc0MAK6v+RxHt9CXafI1I//yjUJPgf4gm+9KoSs2Rsyx5f6MJk73/WcQSacs4pq7CenBgM97CJFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15gAhCCoNvFMx4Fc3AR0OjP+hRuR2Juf4ipucdBgHKE=;
 b=TBb+Dof4NBVuje5VgrVlk0pITpBdaNS6xN9P/U0zLyp/UjywwRWFEj2QGrNje0jYYVvbPAGchi/jLCL6+XScUcJiRVR6oNZQH2+vS6i816aaSfHK6aGdu3rMyAik9kvvRDBIyqWJkMo2/QcitnyBX2WSotN+GVX3ZlF+/02c1dEFmfyBVUOoGRp57gdNMbOWmMJohafCksy6x2S8VM0D37v60az93vZ0U/hENg3EgTqMX5B8ha+GnO0tJcZ/dksrlwDTdjeunlABCTlWIJgizzR5HXTVsBFupq0Cxyqc5UnQzFZ5NxM9JuYVIlw3RX7IFPzpRNRDhDHESFFxH62aBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15gAhCCoNvFMx4Fc3AR0OjP+hRuR2Juf4ipucdBgHKE=;
 b=T3Bd0HQ6JPZxCrRgWrUzCYMkV13FIvsCCEKyNgV6Cl++6jFLXLJu0fTeEZD/w4t0UiBrq1LGIo76mUUv/8wN/i/L4Fk+eg3XDbTVvbaTugU3QLxSQa3/7ZpPyn1uVw4eZWS+ZI+TKcnCkTxzlIhaKgGypNsKCyqny3ME9BKdy4Q=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3045.namprd15.prod.outlook.com (20.178.238.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.11; Fri, 12 Jul 2019 06:03:15 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 06:03:15 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 0/3] fix BTF verification size resolution
Thread-Topic: [PATCH v2 bpf-next 0/3] fix BTF verification size resolution
Thread-Index: AQHVN7VqFgBTrNrCl0inh6kPvaNE/KbGf42A
Date:   Fri, 12 Jul 2019 06:03:14 +0000
Message-ID: <0143c2e9-ac0d-33de-3019-85016d771c76@fb.com>
References: <20190711065307.2425636-1-andriin@fb.com>
In-Reply-To: <20190711065307.2425636-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0035.namprd20.prod.outlook.com
 (2603:10b6:300:ed::21) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:bc57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3417fd29-c136-4906-9ca2-08d7068ea0a4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3045;
x-ms-traffictypediagnostic: BYAPR15MB3045:
x-microsoft-antispam-prvs: <BYAPR15MB30457CEA28F8364DD34D3999D3F20@BYAPR15MB3045.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(39860400002)(376002)(396003)(136003)(189003)(199004)(86362001)(99286004)(2201001)(31696002)(305945005)(66946007)(31686004)(2501003)(81166006)(4326008)(8676002)(81156014)(5660300002)(7736002)(8936002)(25786009)(71200400001)(71190400001)(76176011)(68736007)(14454004)(6116002)(486006)(102836004)(386003)(53546011)(478600001)(66446008)(2906002)(36756003)(229853002)(52116002)(316002)(6436002)(6486002)(256004)(6246003)(6506007)(476003)(46003)(53936002)(66476007)(66556008)(11346002)(186003)(446003)(2616005)(54906003)(64756008)(110136005)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3045;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XyaSgF544gc/ktVkiI1Dh7rogw0ILFfMOMxRpR8b6zb8hiewvVybx2GiYa83ZfwIBhPCF4P+hyzR4j2xzdldYMzSfTKrHVNRPLXU0OaV9TnYFiFdrXU3RwC/qAv+xy3AGqFWuTWLNDbXhcyFiAnr9HHEhW1CgkCrLme5shpyG3SMvSSQvBZA8bWvUTJTwwjRMS72x7HeN7NtVDWe6NYAORuXPGY9Dx+23JaA/THEp6POGbzGNoFaGy5xTC+OcvkoDmcqKxbyuLUp/CI+p9VheiXIgvN8YlqH5FtPgv7IrGeKckNJSpsPa9gNHTo46gmy65xGM0B+vZedzJOmm4SGB4rt6DLLZpmNWFIEvDo07170cOhjzjvtl3Oy/fYTasvvtq4/BVQLfo8U7v5GjLw3YUOqFzLZSVywEBi//01ik2k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8CDEB4ABFA54724FB14940F8432CA0DC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3417fd29-c136-4906-9ca2-08d7068ea0a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 06:03:14.8288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3045
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=998 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMTAvMTkgMTE6NTMgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gQlRGIHNp
emUgcmVzb2x1dGlvbiBsb2dpYyBpc24ndCBhbHdheXMgcmVzb2x2aW5nIHR5cGUgc2l6ZSBjb3Jy
ZWN0bHksIGxlYWRpbmcNCj4gdG8gZXJyb25lb3VzIG1hcCBjcmVhdGlvbiBmYWlsdXJlcyBkdWUg
dG8gdmFsdWUgc2l6ZSBtaXNtYXRjaC4NCj4gDQo+IFRoaXMgcGF0Y2ggc2V0Og0KPiAxLiBmaXhl
cyB0aGUgaXNzdWUgKHBhdGNoICMxKTsNCj4gMi4gYWRkcyB0ZXN0cyBmb3IgdHJpY2tpZXIgY2Fz
ZXMgKHBhdGNoICMyKTsNCj4gMy4gYW5kIGNvbnZlcnRzIGZldyB0ZXN0IGNhc2VzIHV0aWxpemlu
ZyBCVEYtZGVmaW5lZCBtYXBzLCB0aGF0IHByZXZpb3VzbHkNCj4gICAgIGNvdWxkbid0IHVzZSB0
eXBlZGVmJ2VkIGFycmF5cyBkdWUgdG8ga2VybmVsIGJ1ZyAocGF0Y2ggIzMpLg0KPiANCj4gUGF0
Y2ggIzEgY2FuIGJlIGFwcGxpZWQgYWdhaW5zdCBicGYgdHJlZSwgYnV0IHNlbGZ0ZXN0IG9uZXMg
KCMyIGFuZCAjMykgaGF2ZQ0KPiB0byBnbyBhZ2FpbnN0IGJwZi1uZXh0IGZvciBub3cuDQoNCldo
eSAjMiBhbmQgIzMgaGF2ZSB0byBnbyB0byBicGYtbmV4dD8gYnBmIHRyZWUgYWxzbyBhY2NlcHRz
IHRlc3RzLCANCkFGQUlLLiBNYXliZSBsZWF2ZSBmb3IgRGFuaWVsIGFuZCBBbGV4ZWkgdG8gZGVj
aWRlIGluIHRoaXMgcGFydGljdWxhciBjYXNlLg0KDQo+IA0KPiBBbmRyaWkgTmFrcnlpa28gKDMp
Og0KPiAgICBicGY6IGZpeCBCVEYgdmVyaWZpZXIgc2l6ZSByZXNvbHV0aW9uIGxvZ2ljDQo+ICAg
IHNlbGZ0ZXN0cy9icGY6IGFkZCB0cmlja2llciBzaXplIHJlc29sdXRpb24gdGVzdHMNCj4gICAg
c2VsZnRlc3RzL2JwZjogdXNlIHR5cGVkZWYnZWQgYXJyYXlzIGFzIG1hcCB2YWx1ZXMNCg0KTG9v
a3MgZ29vZCB0byBtZS4gRXhjZXB0IG1pbm9yIGNvbW1lbnRzIGluIHBhdGNoIDEvMywgQWNrIHRo
ZSBzZXJpZXMuDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg0KPiANCj4g
ICBrZXJuZWwvYnBmL2J0Zi5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAxNCArKy0N
Cj4gICAuLi4vYnBmL3Byb2dzL3Rlc3RfZ2V0X3N0YWNrX3Jhd3RwLmMgICAgICAgICAgfCAgMyAr
LQ0KPiAgIC4uLi9icGYvcHJvZ3MvdGVzdF9zdGFja3RyYWNlX2J1aWxkX2lkLmMgICAgICB8ICAz
ICstDQo+ICAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9zdGFja3RyYWNlX21hcC5jIHwg
IDIgKy0NCj4gICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9idGYuYyAgICAgICAg
fCA4OCArKysrKysrKysrKysrKysrKysrDQo+ICAgNSBmaWxlcyBjaGFuZ2VkLCAxMDIgaW5zZXJ0
aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4gDQo=
