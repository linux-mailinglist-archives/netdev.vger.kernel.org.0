Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 805EDD1712
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 19:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731304AbfJIRuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 13:50:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41730 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730503AbfJIRuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 13:50:15 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x99HSdwr025863;
        Wed, 9 Oct 2019 10:37:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Xci6MPND39E0iPXEDOUMknCJeegdndn79auGv2MGZ3Q=;
 b=FWBKj/rbnngToGhwuoL9FfHk5j6QdxxWDFCocDyqDHnXlAfWHCb3FKCElKV9wc+f//2N
 5EsE18TShwXzagiiR9HkuCa1SalwlPy6O9ZGU7iuWUc+XReb4ZfEMLtyn6VEq4Z3yZjn
 NWNLFVua2euWfxfvPmeXqyjwA71aFEjMVAI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vgpq9rkrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Oct 2019 10:37:53 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Oct 2019 10:37:52 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 9 Oct 2019 10:37:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+zW7I0JW9EDWK42aYFqtZvzYdfjCrSI/O520Iv+IYZdkRGVA/HALMWPzCGg96R5GkBH7mTW+ocOUdRW7DFn2mfQ78+EnNqeL9UEBMfq0HOGHEEg4EvgHFFcTMwZdlJvH0dvNUpIeRRbv53/PCXBFN8+wsjkORe1ZXdlhsK7rBQpon7h+gOpY1fr5oilibgzr+Swj0yxE47Hwx2v4Uii8oFWPpH/Wmh82UCeMbXKvNzUww2dtMhS16E0R5LCn8is2B7E9xRZ152L0DwT79l/6ejOjZXbk4huouMs2vr/p7/E0UxPF1zBBqRQh8uS6TlLoIVoK2adLHrL3KZOXYpQtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xci6MPND39E0iPXEDOUMknCJeegdndn79auGv2MGZ3Q=;
 b=XlEX3Ci72aQQVEsfxTRyTttoW+m6V29372wLgYb7bXrMZ1NGA3eXeWnpMpySE+Xvx13A8nzWpsQQojnceDl+8yhbmVE+ZJlWzF0jx7XYSfNTkG5wQOMsblOH3nnkRjt79P+dc+QXRPqmRicJ/41n0z3VLSsp8DxvwWTJlwe9bZo7qp2rDdBt1r5rg6igmBmhtsk2kVMTsynQxB6MuyPgx/wZ9IqDSFmz8QQtTd5f9DBBhJ+wBuO7+4FqCv+3sECY3z2cbeBwIcv+Bj+FMuwGxuwQpiGnL2TfVaLsHfwVpStZBhWnlsbuXgjjxrKCZGR0pjzAuIr5msyKd4dqMstTLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xci6MPND39E0iPXEDOUMknCJeegdndn79auGv2MGZ3Q=;
 b=aXIWc2iDTuLITlVdl1bQD+IdowcbZNJFvjMZXUeV3B58yUAruLfcTo29SW8IJcrjmBUCt9JBpw1m+G6ha9BY7zYKYkLOp+TQRKAKqWNZt5ZlqLCsOJRdj9kk0waQjQdooRY5AtyzH3jBPtzvTYmlquBgkMRjwS75klpexOBNi/I=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2725.namprd15.prod.outlook.com (20.179.157.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Wed, 9 Oct 2019 17:37:51 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 17:37:50 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 10/10] selftests/bpf: add kfree_skb raw_tp test
Thread-Topic: [PATCH bpf-next 10/10] selftests/bpf: add kfree_skb raw_tp test
Thread-Index: AQHVezpTyCDomJOfxUSy+jtN/vLY2qdR0K0AgADJZYA=
Date:   Wed, 9 Oct 2019 17:37:50 +0000
Message-ID: <c744b787-1f46-fc2e-d921-e2c356a9f849@fb.com>
References: <20191005050314.1114330-1-ast@kernel.org>
 <20191005050314.1114330-11-ast@kernel.org>
 <CAEf4BzZS3kvunYnPu6x674H08DZKnuc37c9+m4p_2EjdNuDGSg@mail.gmail.com>
In-Reply-To: <CAEf4BzZS3kvunYnPu6x674H08DZKnuc37c9+m4p_2EjdNuDGSg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0037.namprd22.prod.outlook.com
 (2603:10b6:300:69::23) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::cfd7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbf759c3-7eea-4f5d-3e38-08d74cdf67d4
x-ms-traffictypediagnostic: BYAPR15MB2725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2725F37D37AE836E87CE062CD7950@BYAPR15MB2725.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(81166006)(6486002)(305945005)(6246003)(25786009)(6436002)(7736002)(8936002)(31686004)(31696002)(8676002)(64756008)(66446008)(4326008)(66476007)(229853002)(66946007)(86362001)(14454004)(66556008)(81156014)(6116002)(76176011)(256004)(52116002)(5024004)(478600001)(6512007)(386003)(11346002)(446003)(6506007)(53546011)(102836004)(2906002)(99286004)(46003)(316002)(486006)(476003)(54906003)(110136005)(2616005)(186003)(36756003)(71190400001)(71200400001)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2725;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e12rUdv/EV0ekLhBSCZ4GN4bGlI80hrlxQpY0byQNTN6yAsg9KdTXdfMAeN9sfSfSG3UdLPjU4n1bThGu9V9uz0QIG5GsKd37AKtFXzmDs86LTXSa0quv+mSjszKniy5tr+CgZGgQVt3IsYUYZb5VQ46QzEJ4cFMJfIY9RdC142s4Vt1sBjgcMOnBkjSHvOMSG+5lLwE/VEMTBgdOBLgzXBqV5vmyrNfn9vuSNmcjBtHkZfV861wgWSYxEzH5KBcz3kE8yrYrBGOpIe4tpgBijwUx5NlKiiLNP9Jblxoml9rpwfPaCdUuoh9IjpNkVwovlW2dBbHuuqc9I5GKIEBLEaVCBqdS8GQ44+xGDoAXeLOG2JJNdM8RBWY0RICCY6NNgQQ7gGAE1TUhq+toDcQxR8IZFXnmbr+4UQsVkztBuQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C08B582E7A3BE74AB60EE9DB9D68AC51@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf759c3-7eea-4f5d-3e38-08d74cdf67d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 17:37:50.6591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qKSYdIxiV6AV8+mIkOtJIY+h7Mv5TGu8J+gnHM3CrBL9E0bn8ad6HWcDAJA6S+40
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2725
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-09_08:2019-10-08,2019-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910090149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvOC8xOSAxMDozNiBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBGcmksIE9j
dCA0LCAyMDE5IGF0IDEwOjA0IFBNIEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+
IHdyb3RlOg0KPj4NCj4+IExvYWQgYmFzaWMgY2xzX2JwZiBwcm9ncmFtLg0KPj4gTG9hZCByYXdf
dHJhY2Vwb2ludCBwcm9ncmFtIGFuZCBhdHRhY2ggdG8ga2ZyZWVfc2tiIHJhdyB0cmFjZXBvaW50
Lg0KPj4gVHJpZ2dlciBjbHNfYnBmIHZpYSBwcm9nX3Rlc3RfcnVuLg0KPj4gQXQgdGhlIGVuZCBv
ZiB0ZXN0X3J1biBrZXJuZWwgd2lsbCBjYWxsIGtmcmVlX3NrYg0KPj4gd2hpY2ggd2lsbCB0cmln
Z2VyIHRyYWNlX2tmcmVlX3NrYiB0cmFjZXBvaW50Lg0KPj4gV2hpY2ggd2lsbCBjYWxsIG91ciBy
YXdfdHJhY2Vwb2ludCBwcm9ncmFtLg0KPj4gV2hpY2ggd2lsbCB0YWtlIHRoYXQgc2tiIGFuZCB3
aWxsIGR1bXAgaXQgaW50byBwZXJmIHJpbmcgYnVmZmVyLg0KPj4gQ2hlY2sgdGhhdCB1c2VyIHNw
YWNlIHJlY2VpdmVkIGNvcnJlY3QgcGFja2V0Lg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEFsZXhl
aSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+DQo+PiAtLS0NCj4gDQo+IExHVE0sIGZldyBt
aW5vciBuaXRzIGJlbG93Lg0KPiANCj4gQWNrZWQtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlp
bkBmYi5jb20+DQo+IA0KPiANCj4+ICAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9rZnJl
ZV9za2IuYyAgICAgIHwgOTAgKysrKysrKysrKysrKysrKysrKw0KPj4gICB0b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9icGYvcHJvZ3Mva2ZyZWVfc2tiLmMgfCA3NiArKysrKysrKysrKysrKysrDQo+
PiAgIDIgZmlsZXMgY2hhbmdlZCwgMTY2IGluc2VydGlvbnMoKykNCj4+ICAgY3JlYXRlIG1vZGUg
MTAwNjQ0IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9nX3Rlc3RzL2tmcmVlX3NrYi5j
DQo+PiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJv
Z3Mva2ZyZWVfc2tiLmMNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMvYnBmL3Byb2dfdGVzdHMva2ZyZWVfc2tiLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9i
cGYvcHJvZ190ZXN0cy9rZnJlZV9za2IuYw0KPj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4+IGlu
ZGV4IDAwMDAwMDAwMDAwMC4uMjM4YmM3MDI0YjM2DQo+PiAtLS0gL2Rldi9udWxsDQo+PiArKysg
Yi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9rZnJlZV9za2IuYw0KPj4g
QEAgLTAsMCArMSw5MCBAQA0KPj4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4w
DQo+PiArI2luY2x1ZGUgPHRlc3RfcHJvZ3MuaD4NCj4+ICsNCj4+ICtzdGF0aWMgdm9pZCBvbl9z
YW1wbGUodm9pZCAqY3R4LCBpbnQgY3B1LCB2b2lkICpkYXRhLCBfX3UzMiBzaXplKQ0KPj4gK3sN
Cj4+ICsgICAgICAgaW50IGlmaW5kZXggPSAqKGludCAqKWRhdGEsIGR1cmF0aW9uID0gMDsNCj4+
ICsgICAgICAgc3RydWN0IGlwdjZfcGFja2V0ICogcGt0X3Y2ID0gZGF0YSArIDQ7DQo+PiArDQo+
PiArICAgICAgIGlmIChpZmluZGV4ICE9IDEpDQo+PiArICAgICAgICAgICAgICAgLyogc3B1cmlv
dXMga2ZyZWVfc2tiIG5vdCBvbiBsb29wYmFjayBkZXZpY2UgKi8NCj4+ICsgICAgICAgICAgICAg
ICByZXR1cm47DQo+PiArICAgICAgIGlmIChDSEVDSyhzaXplICE9IDc2LCAiY2hlY2tfc2l6ZSIs
ICJzaXplICVkICE9IDc2XG4iLCBzaXplKSkNCj4gDQo+IGNvbXBpbGVyIGRvZXNuJ3QgY29tcGxh
aW4gYWJvdXQgJWQgYW5kIHNpemUgYmVpbmcgdW5zaWduZWQ/DQoNCmNvbXBpbGUgZGlkbid0IGNv
bXBsYWluLiBidXQgSSBmaXhlZCBpdC4NCg0KPj4gK1NFQygicmF3X3RyYWNlcG9pbnQva2ZyZWVf
c2tiIikNCj4+ICtpbnQgdHJhY2Vfa2ZyZWVfc2tiKHN0cnVjdCB0cmFjZV9rZnJlZV9za2IqIGN0
eCkNCj4+ICt7DQo+PiArICAgICAgIHN0cnVjdCBza19idWZmICpza2IgPSBjdHgtPnNrYjsNCj4+
ICsgICAgICAgc3RydWN0IG5ldF9kZXZpY2UgKmRldjsNCj4+ICsgICAgICAgaW50IGlmaW5kZXg7
DQo+PiArICAgICAgIHN0cnVjdCBjYWxsYmFja19oZWFkICpwdHI7DQo+PiArICAgICAgIHZvaWQg
KmZ1bmM7DQo+IA0KPiBuaXQ6IHN0eWxlIGNoZWNrZXIgc2hvdWxkIGhhdmUgY29tcGxhaW5lZCBh
Ym91dCBtaXNzaW5nIGVtcHR5IGxpbmUNCg0KZ29vZCBwb2ludC4gRml4ZWQgY2hlY2twYXRjaCBl
cnJvcnMuDQo=
