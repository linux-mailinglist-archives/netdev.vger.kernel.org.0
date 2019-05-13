Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 061F81BEC9
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 22:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfEMUn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 16:43:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36714 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbfEMUn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 16:43:56 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4DKgUnl027032;
        Mon, 13 May 2019 13:43:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vbg7lFa8ARjm8csktDk+gWzLho5UKVLv3dE+gQbfOOk=;
 b=jerdOu3gXexA/9fOzQ7IMQ2qEe/gwUchg5NCRjlHWA63xMynRV5an+3iDEq06BJTQwK0
 yayH5c4St5LrV9L2aThjdx/qxMc+XTF4WHPlHBBBYxjmzfg16llnnGrZWffy3KCDjDyd
 tucull1POx/M9x09mhL5KkWg4vVF2V+dsSQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sffuu8035-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 May 2019 13:43:34 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 May 2019 13:42:23 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 13 May 2019 13:42:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbg7lFa8ARjm8csktDk+gWzLho5UKVLv3dE+gQbfOOk=;
 b=Kc1nqSIih5xbKN7DZrDbRctnm9b4w6I9ysw0jy1JEbb1ak0hLlfNFnsKsKJXUc3oUGDmgKQ6P4UISiPCMIo36CGV2t9nsWSfVEspiuZ/3L0Z9uJcuritkYUsqsB0qPfX1nEePWLPtez9yHKuJXe1m+YaVJutGasF7cRYEx8qjm8=
Received: from MWHPR15MB1696.namprd15.prod.outlook.com (10.175.142.17) by
 MWHPR15MB1952.namprd15.prod.outlook.com (10.175.8.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Mon, 13 May 2019 20:42:21 +0000
Received: from MWHPR15MB1696.namprd15.prod.outlook.com
 ([fe80::6899:6936:a6f6:d7ed]) by MWHPR15MB1696.namprd15.prod.outlook.com
 ([fe80::6899:6936:a6f6:d7ed%6]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 20:42:21 +0000
From:   Jonathan Lemon <bsd@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [RFC bpf-next 0/7] busy poll support for AF_XDP sockets
Thread-Topic: [RFC bpf-next 0/7] busy poll support for AF_XDP sockets
Thread-Index: AQHVBCk31IiqaKlwZ0+7ECAWo2hg3aZfjiqAgABtxICACZR1AA==
Date:   Mon, 13 May 2019 20:42:21 +0000
Message-ID: <D40B5C89-53F8-4EC1-AB35-FB7C395864DE@fb.com>
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
 <20190506163135.blyqrxitmk5yrw7c@ast-mbp>
 <CAJ8uoz2MFtoXwuhAp5A0teMmwU2v623pHf2k0WSFi0kovJYjtw@mail.gmail.com>
 <20190507182435.6f2toprk7jus6jid@ast-mbp>
In-Reply-To: <20190507182435.6f2toprk7jus6jid@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0047.namprd12.prod.outlook.com
 (2603:10b6:301:2::33) To MWHPR15MB1696.namprd15.prod.outlook.com
 (2603:10b6:300:128::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: MailMate (1.12.4r5594)
x-originating-ip: [2620:10d:c090:200::2:e5c9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3155ac69-b13d-49fa-3c90-08d6d7e37f07
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1952;
x-ms-traffictypediagnostic: MWHPR15MB1952:
x-microsoft-antispam-prvs: <MWHPR15MB1952371D7A82796DF75FCBAAC40F0@MWHPR15MB1952.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(8936002)(11346002)(446003)(6436002)(476003)(486006)(2616005)(68736007)(8676002)(81156014)(81166006)(7736002)(316002)(186003)(50226002)(46003)(6512007)(4326008)(33656002)(561944003)(25786009)(53936002)(6246003)(305945005)(5660300002)(52116002)(76176011)(66446008)(66556008)(64756008)(99286004)(73956011)(66476007)(66946007)(82746002)(53546011)(14454004)(386003)(6506007)(478600001)(102836004)(36756003)(6916009)(54906003)(229853002)(2906002)(6116002)(256004)(6486002)(71190400001)(71200400001)(86362001)(14444005)(83716004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1952;H:MWHPR15MB1696.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: scjV3a14rhpy9HuxBmaFrHYmDYds3PpIEiiJ1njYmqRfPxI4i37+ovBb1obVqW57nl5Ho6RbjOtlUtkT4q1627neErFvhEY1Qgiz0YHTqONl5VWV0vs3UJwINlDsRmmjPvnc4/NYmhmwLkaiWEpbXg2vJozX9ikYjxCUKF7NzZJV5tAS6fjXn8VSt6z3O6VUBjQfbQYgDem+LhHPWOxBYLF5ZFRDZl0s0ct6rpQG2wCl53Qh78vAoGTY6lqDUWyrdPDED8yvxgXBpx2InN3ozSrlmePeCGTwRR+pzkGMyNzDs3s+NjPuBUgz3l7JDCxEiBVUP3Gu4zg0lZ/srNOB2eLT0rHGA2/YpKlhJRsnVeLpruyC4Z5vPCXem+Rv1IgK5WY9WRzKxtO6orjyOyEuRwwJBXA3onDDQe9u9+ctBSM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3155ac69-b13d-49fa-3c90-08d6d7e37f07
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 20:42:21.0994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1952
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-13_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905130138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VG9zc2luZyBpbiBteSAuMDIgY2VudHM6DQoNCg0KSSBhbnRpY2lwYXRlIHRoYXQgbW9zdCB1c2Vy
cyBvZiBBRl9YRFAgd2lsbCB3YW50IHBhY2tldCBwcm9jZXNzaW5nDQpmb3IgYSBnaXZlbiBSWCBx
dWV1ZSBvY2N1cnJpbmcgb24gYSBzaW5nbGUgY29yZSAtIG90aGVyd2lzZSB3ZSBlbmQNCnVwIHdp
dGggY2FjaGUgZGVsYXlzLiAgVGhlIHVzdWFsIG1vZGVsIGlzIG9uZSB0aHJlYWQsIG9uZSBzb2Nr
ZXQsDQpvbmUgY29yZSwgYnV0IHRoaXMgaXNuJ3QgZW5mb3JjZWQgYW55d2hlcmUgaW4gdGhlIEFG
X1hEUCBjb2RlIGFuZCBpcw0KdXAgdG8gdGhlIHVzZXIgdG8gc2V0IHRoaXMgdXAuDQoNCk9uIDcg
TWF5IDIwMTksIGF0IDExOjI0LCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+IEknbSBub3Qg
c2F5aW5nIHRoYXQgd2Ugc2hvdWxkbid0IGRvIGJ1c3ktcG9sbC4gSSdtIHNheWluZyBpdCdzDQo+
IGNvbXBsaW1lbnRhcnksIGJ1dCBpbiBhbGwgY2FzZXMgc2luZ2xlIGNvcmUgcGVyIGFmX3hkcCBy
cSBxdWV1ZQ0KPiB3aXRoIHVzZXIgdGhyZWFkIHBpbm5pbmcgaXMgcHJlZmVycmVkLg0KDQpTbyBJ
IHRoaW5rIHdlJ3JlIG9uIHRoZSBzYW1lIHBhZ2UgaGVyZS4NCg0KPiBTdGFjayByeCBxdWV1ZXMg
YW5kIGFmX3hkcCByeCBxdWV1ZXMgc2hvdWxkIGxvb2sgYWxtb3N0IHRoZSBzYW1lIGZyb20NCj4g
bmFwaSBwb2ludCBvZiB2aWV3LiBTdGFjayAtPiBub3JtYWwgbmFwaSBpbiBzb2Z0aXJxLiBhZl94
ZHAgLT4gbmV3IA0KPiBrdGhyZWFkDQo+IHRvIHdvcmsgd2l0aCBib3RoIHBvbGwgYW5kIGJ1c3kt
cG9sbC4gVGhlIG9ubHkgZGlmZmVyZW5jZSBiZXR3ZWVuDQo+IHBvbGwgYW5kIGJ1c3ktcG9sbCB3
aWxsIGJlIHRoZSBydW5uaW5nIGNvbnRleHQ6IG5ldyBrdGhyZWFkIHZzIHVzZXIgDQo+IHRhc2su
DQouLi4NCj4gQSBidXJzdCBvZiA2NCBwYWNrZXRzIG9uIHN0YWNrIHF1ZXVlcyBvciBzb21lIG90
aGVyIHdvcmsgaW4gc29mdGlycWQNCj4gd2lsbCBzcGlrZSB0aGUgbGF0ZW5jeSBmb3IgYWZfeGRw
IHF1ZXVlcyBpZiBzb2Z0aXJxIGlzIHNoYXJlZC4NCg0KVHJ1ZSwgYnV0IHdvdWxkIGl0IGJlIHNo
YXJlZD8gIFRoaXMgZ29lcyBiYWNrIHRvIHRoZSBjdXJyZW50IG1vZGVsLCANCndoaWNoDQphcyB1
c2VkIGJ5IEludGVsIGlzOg0KDQogICAgKGNoYW5uZWwgPT0gUlgsIFRYLCBzb2Z0aXJxKQ0KDQpN
TFgsIG9uIHRoZSBvdGhlciBoYW5kLCB3YW50czoNCg0KICAgIChjaGFubmVsID09IFJYLnN0YWNr
LCBSWC5BRl9YRFAsIFRYLnN0YWNrLCBUWC5BRl9YRFAsIHNvZnRpcnEpDQoNCldoaWNoIHdvdWxk
IGluZGVlZCBsZWFkIHRvIHNoYXJpbmcuICBUaGUgbW9yZSBJIGxvb2sgYXQgdGhlIGFib3ZlLCB0
aGUNCnN0cm9uZ2VyIEkgc3RhcnQgdG8gZGlzbGlrZSBpdC4gIFBlcmhhcHMgdGhpcyBzaG91bGQg
YmUgZGlzYWxsb3dlZD8NCg0KSSBiZWxpZXZlIHRoZXJlIHdhcyBzb21lIG1lbnRpb24gYXQgTFNG
L01NIHRoYXQgdGhlICdjaGFubmVsJyBjb25jZXB0DQp3YXMgc29tZXRoaW5nIHNwZWNpZmljIHRv
IEhXIGFuZCByZWFsbHkgc2hvdWxkbid0IGJlIHBhcnQgb2YgdGhlIFNXIEFQSS4NCg0KPiBIZW5j
ZSB0aGUgcHJvcG9zYWwgZm9yIG5ldyBuYXBpX2t0aHJlYWRzOg0KPiAtIHVzZXIgY3JlYXRlcyBh
Zl94ZHAgc29ja2V0IGFuZCBiaW5kcyB0byBfQ1BVXyBYIHRoZW4NCj4gLSBkcml2ZXIgYWxsb2Nh
dGVzIHNpbmdsZSBhZl94ZHAgcnEgcXVldWUgKHF1ZXVlIElEIGRvZXNuJ3QgbmVlZCB0byBiZSAN
Cj4gZXhwb3NlZCkNCj4gLSBzcGF3bnMga3RocmVhZCBwaW5uZWQgdG8gY3B1IFgNCj4gLSBjb25m
aWd1cmVzIGlycSBmb3IgdGhhdCBhZl94ZHAgcXVldWUgdG8gZmlyZSBvbiBjcHUgWA0KPiAtIHVz
ZXIgc3BhY2Ugd2l0aCB0aGUgaGVscCBvZiBsaWJicGYgcGlucyBpdHMgcHJvY2Vzc2luZyB0aHJl
YWQgdG8gDQo+IHRoYXQgY3B1IFgNCj4gLSByZXBlYXQgYWJvdmUgZm9yIGFzIG1hbnkgYWZfeGRw
IHNvY2tldHMgYXMgdGhlcmUgYXMgY3B1cw0KPiAgIChpdHMgYWxzbyBvayB0byBwaWNrIHRoZSBz
YW1lIGNwdSBYIGZvciBkaWZmZXJlbnQgYWZfeGRwIHNvY2tldA0KPiAgIHRoZW4gbmV3IGt0aHJl
YWQgaXMgc2hhcmVkKQ0KPiAtIHVzZXIgc3BhY2UgY29uZmlndXJlcyBodyB0byBSU1MgdG8gdGhl
c2Ugc2V0IG9mIGFmX3hkcCBzb2NrZXRzLg0KPiAgIHNpbmNlIGV0aHRvb2wgYXBpIGlzIGEgbWVz
cyBJIHByb3Bvc2UgdG8gdXNlIGFmX3hkcCBhcGkgdG8gZG8gdGhpcyANCj4gcnNzIGNvbmZpZw0K
DQoNCiBGcm9tIGEgaGlnaCBsZXZlbCBwb2ludCBvZiB2aWV3LCB0aGlzIHNvdW5kcyBxdWl0ZSBz
ZW5zaWJsZSwgYnV0IGRvZXMgDQpuZWVkDQpzb21lIGRldGFpbHMgaXJvbmVkIG91dC4gIFRoZSBt
b2RlbCBhYm92ZSBlc3NlbnRpYWxseSBlbmZvcmNlcyBhIG1vZGVsIA0Kb2Y6DQoNCiAgICAoYWZf
eGRwID0gUlguYWZfeGRwICsgYm91bmRfY3B1KQ0KICAgICAgKGJvdW5kX2NwdSA9IGh3LmNwdSAr
IGFmX3hkcC5rdGhyZWFkICsgaHcuaXJxKQ0KDQoodGVtcG9yYXJpbHkgaWdub3JpbmcgVFggZm9y
IHJpZ2h0IG5vdykNCg0KDQpJIGZvcnNlZSB0d28gaXNzdWVzIHdpdGggdGhlIGFib3ZlIGFwcHJv
YWNoOg0KICAgMS4gaGFyZHdhcmUgbGltaXRhdGlvbnMgaW4gdGhlIG51bWJlciBvZiBxdWV1ZXMv
cmluZ3MNCiAgIDIuIFJTUy9zdGVlcmluZyBydWxlcw0KDQo+IC0gdXNlciBjcmVhdGVzIGFmX3hk
cCBzb2NrZXQgYW5kIGJpbmRzIHRvIF9DUFVfIFggdGhlbg0KPiAtIGRyaXZlciBhbGxvY2F0ZXMg
c2luZ2xlIGFmX3hkcCBycSBxdWV1ZSAocXVldWUgSUQgZG9lc24ndCBuZWVkIHRvIGJlIA0KPiBl
eHBvc2VkKQ0KDQpIZXJlLCB0aGUgZHJpdmVyIG1heSBub3QgYmUgYWJsZSB0byBjcmVhdGUgYW4g
YXJiaXRyYXJ5IFJRLCBidXQgbWF5IG5lZWQgDQp0bw0KdGVhciBkb3duL3JldXNlIGFuIGV4aXN0
aW5nIG9uZSB1c2VkIGJ5IHRoZSBzdGFjay4gIFRoaXMgbWF5IG5vdCBiZSBhbiANCmlzc3VlDQpm
b3IgbW9kZXJuIGhhcmR3YXJlLg0KDQo+IC0gdXNlciBzcGFjZSBjb25maWd1cmVzIGh3IHRvIFJT
UyB0byB0aGVzZSBzZXQgb2YgYWZfeGRwIHNvY2tldHMuDQo+ICAgc2luY2UgZXRodG9vbCBhcGkg
aXMgYSBtZXNzIEkgcHJvcG9zZSB0byB1c2UgYWZfeGRwIGFwaSB0byBkbyB0aGlzIA0KPiByc3Mg
Y29uZmlnDQoNCkN1cnJlbnRseSwgUlNTIG9ubHkgc3RlZXJzIGRlZmF1bHQgdHJhZmZpYy4gIE9u
IGEgc3lzdGVtIHdpdGggc2hhcmVkDQpzdGFjay9hZl94ZHAgcXVldWVzLCB0aGVyZSBzaG91bGQg
YmUgYSB3YXkgdG8gc3BsaXQgdGhlIHRyYWZmaWMgdHlwZXMsDQp1bmxlc3Mgd2UncmUgdGFsa2lu
ZyBhYm91dCBhIG1vZGVsIHdoZXJlIGFsbCB0cmFmZmljIGdvZXMgdG8gQUZfWERQLg0KDQpUaGlz
IGNsYXNzaWZpY2F0aW9uIGhhcyB0byBiZSBkb25lIGJ5IHRoZSBOSUMsIHNpbmNlIGl0IGNvbWVz
IGJlZm9yZSBSU1MNCnN0ZWVyaW5nIC0gd2hpY2ggY3VycmVudGx5IG1lYW5zIHNlbmRpbmcgZmxv
dyBtYXRjaCBydWxlcyB0byB0aGUgTklDLCANCndoaWNoDQppcyBsZXNzIHRoYW4gaWRlYWwuICBJ
IGFncmVlIHRoYXQgdGhlIGV0aHRvb2wgaW50ZXJmYWNlIGlzIG5vbiBvcHRpbWFsLCANCmJ1dA0K
aXQgZG9lcyBtYWtlIHRoaW5ncyBjbGVhciB0byB0aGUgdXNlciB3aGF0J3MgZ29pbmcgb24uDQoN
ClBlcmhhcHMgYW4gYWZfeGRwIGxpYnJhcnkgdGhhdCBkb2VzIHNvbWUgYm9va2tlZXBpbmc6DQog
ICAtIG9wZW4gYWZfeGRwIHNvY2tldA0KICAgLSBkZWZpbmUgYWZfeGRwX3NldCBhcyAoY2xhc3Np
ZmljYXRpb24sIHN0ZWVyaW5nIHJ1bGVzLCBvdGhlcj8pDQogICAtIGJpbmQgc29ja2V0IHRvIChj
cHUsIGFmX3hkcF9zZXQpDQogICAtIGtlcm5lbDoNCiAgICAgLSBwaW5zIGNhbGxpbmcgdGhyZWFk
IHRvIGNwdQ0KICAgICAtIGNyZWF0ZXMga3RocmVhZCBpZiBvbmUgZG9lc24ndCBleGlzdCwgYmlu
ZHMgdG8gaXJxIGFuZCBjcHUNCiAgICAgLSBoYXMgZHJpdmVyIGNyZWF0ZSBSUS5hZl94ZHAsIHBv
c3NpYmx5IHJlcGxhY2luZyBSUS5zdGFjaw0KICAgICAtIGFwcGxpZXMgKGFmX3hkcF9zZXQpIHRv
IE5JQy4NCg0KU2VlbXMgd29ya2FibGUsIGJ1dCBhIGxpdHRsZSBjb21wbGljYXRlZD8gIFRoZSBj
b21wbGV4aXR5IGNvdWxkIGJlIG1vdmVkDQppbnRvIGEgc2VwYXJhdGUgbGlicmFyeS4NCg0KDQo+
IGltbyB0aGF0IHdvdWxkIGJlIHRoZSBzaW1wbGVzdCBhbmQgcGVyZm9ybWFudCB3YXkgb2YgdXNp
bmcgYWZfeGRwLg0KPiBBbGwgY29uZmlndXJhdGlvbiBhcGlzIGFyZSB1bmRlciBsaWJicGYgKG9y
IGxpYnhkcCBpZiB3ZSBjaG9vc2UgdG8gDQo+IGZvcmsgaXQpDQo+IEVuZCByZXN1bHQgaXMgb25l
IGFmX3hkcCByeCBxdWV1ZSAtIG9uZSBuYXBpIC0gb25lIGt0aHJlYWQgLSBvbmUgdXNlciANCj4g
dGhyZWFkLg0KPiBBbGwgcGlubmVkIHRvIHRoZSBzYW1lIGNwdSB3aXRoIGlycSBvbiB0aGF0IGNw
dS4NCj4gQm90aCBwb2xsIGFuZCBidXN5LXBvbGwgYXBwcm9hY2hlcyB3aWxsIG5vdCBib3VuY2Ug
ZGF0YSBiZXR3ZWVuIGNwdXMuDQo+IE5vICdzaGFkb3cnIHF1ZXVlcyB0byBzcGVhayBvZiBhbmQg
c2hvdWxkIHNvbHZlIHRoZSBpc3N1ZXMgdGhhdA0KPiBmb2xrcyB3ZXJlIGJyaW5naW5nIHVwIGlu
IGRpZmZlcmVudCB0aHJlYWRzLg0KDQpTb3VuZHMgbGlrZSBhIHNlbnNpYmxlIG1vZGVsIGZyb20g
bXkgUE9WLg0KLS0gDQpKb25hdGhhbg0K
