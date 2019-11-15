Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F39E0FE8D4
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 00:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfKOXrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 18:47:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13250 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727083AbfKOXrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 18:47:25 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAFNhP7a023475;
        Fri, 15 Nov 2019 15:47:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IDh5b7vpemlp+OEptOyT1FLT46LwmzX1glSZJxsqjzU=;
 b=KxHWrkeJb5gd3eAYClREXjKB651ucVvcgIMjqnkBV19OvpID2CsOEbz9/ZLlBbFRBUOs
 tt/1CB39fwNIBEQWnBAPuUGY5KuHYXsDpQliHQNdJaen8vidkKWzwh8kfcj/CqaKnDoq
 ddpe8NPPboZ0LY9EdUXoA+cK7zKZ6iSLpNQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w9gfgaveu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 15 Nov 2019 15:47:08 -0800
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 15 Nov 2019 15:47:07 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 15 Nov 2019 15:47:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSV2013SeXNUTuQPkFBP3DmRgsMQMmTdIqN3RwmSXaKqEujNi+5w0hC+YTGAWcr4pBLFhVz3dPbITdeo0sjHQv2e+3+JiTzqZpQmXDe96WhHbo0sLYyF+pOuJZAwbdxNWdboItWLPbb9QxX46B3rNatqzMwYQXBRsUdQIDKTfUJghhPc81wz6nUCZuiTY9QtJrZYkxUucykhvR/ez8dIP4Y59i/ZqQ/mj1lHBxaZtdSTGvt2UtuStUFtH78pk0wfmTrEoXwYG64Kv69hBgxzgANYwZz5XgutR090omqJnAiDUIoRGhXHtzVF8QbQQ3yGnSyljNuhVsvyV2T62Gzysw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDh5b7vpemlp+OEptOyT1FLT46LwmzX1glSZJxsqjzU=;
 b=XG7vYlb1zzbLwe3D8u/0aO0NfW6e3nfDqHDHzso6mjxPo99u5t31zvqGU9bgyfBLzG62TMePfJFfe0pXrTQcF6KdrmiONBde+Tw5TyXfsTF5eu6211ivt7GZ40jKG8OFf/uos28f8UlfgqEmfvt3lXb+9vl6ylXzExMJM4RE+EtFGU0D2NQbu3kb1pSeZhfBGFFE5c/YDYwAGsBNjVSkvsnQGAPWOsyOWt88UzsXK92oO2HgWAZSpN9d7A4X62RhZySyRvUgIbrVGSIdsdjzqwzMXzinR8KPO6dPPygLUS//UxSNFVZbiVMRhy5flb0gZsp3jO+twVsmjE+YqzSxJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDh5b7vpemlp+OEptOyT1FLT46LwmzX1glSZJxsqjzU=;
 b=cEG/vs+0dw1XbnXG4nSXjNBA8yyFDUOK5EjrnqgM4PtYO1C1BL3kDZ4fTh0016NQMxtxI+Amtuaf2BFzZFn1IteN7o/Rl+fg5q9fx3/kBYTw4l4OWikcBSBR/DdSOD9wfQb8XchUnZUC+ZiHrE0g3CRER1ExWFrwcwS+fIUV4Fs=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2487.namprd15.prod.outlook.com (52.135.198.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Fri, 15 Nov 2019 23:47:06 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2451.027; Fri, 15 Nov 2019
 23:47:06 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Thread-Topic: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Thread-Index: AQHVm2mT23Qa9zxaoUGXDmZOssK4HKeM4soAgAABlICAAAIggIAAAKSA
Date:   Fri, 15 Nov 2019 23:47:06 +0000
Message-ID: <fe46c471-e345-b7e4-ab91-8ef044fd58ae@fb.com>
References: <20191115040225.2147245-1-andriin@fb.com>
 <20191115040225.2147245-3-andriin@fb.com>
 <888858f7-97fb-4434-4440-a5c0ec5cbac8@iogearbox.net>
 <293bb2fe-7599-3825-1bfe-d52224e5c357@fb.com>
 <3287b984-6335-cacb-da28-3d374afb7f77@iogearbox.net>
In-Reply-To: <3287b984-6335-cacb-da28-3d374afb7f77@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0018.namprd14.prod.outlook.com
 (2603:10b6:301:4b::28) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::8ac1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9821b74a-962b-4971-0fa0-08d76a261f4a
x-ms-traffictypediagnostic: BYAPR15MB2487:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2487DA276E0F022F8B246CDBD7700@BYAPR15MB2487.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(346002)(396003)(39860400002)(189003)(199004)(446003)(102836004)(53546011)(386003)(256004)(81166006)(81156014)(8676002)(66446008)(7736002)(5660300002)(2501003)(66946007)(305945005)(31686004)(2906002)(316002)(8936002)(6116002)(14444005)(186003)(6246003)(6506007)(86362001)(66476007)(25786009)(4326008)(71200400001)(476003)(478600001)(99286004)(36756003)(110136005)(54906003)(76176011)(52116002)(11346002)(229853002)(6512007)(71190400001)(6486002)(486006)(2201001)(2616005)(14454004)(66556008)(64756008)(6436002)(31696002)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2487;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GAqrTDGblfvl8tX2u68IL/zSiRZ206PXb8Vrsp7udF8GyTgU2da05I8Kfc6yFhSWNXXWWLiDso0d5QJqo3pWD+kp3rgm16kpxO2yDEkV6XhNOT8NugGuTr6hw0CpunVPPkaIhWu2AWNDJHsMEqY/fcET9eugS0qD0vdpjVMqARrhmZu2aH6Xnmkxu5vdvfcJwsSQrB1jsFtflz9bfgmsnZNL+MaQDpRO5vGkntsYobvVCkIfUWH7BtL8Wt3nWIfC4w+nbYrMVgjnKReAIDCyF32P/jk7fPpPIsxkzrIyID4tqVNqIX/m+XfhpNc3avln0Ius9M/xP1sw6ll/flIO4ysW0uVApXUq1oVMoH4w+0zTPRL6CvBlZO0weyfH3vpmU+UrtPuDCEFFUIHtZ3zy3EQ1cON9R20HQqLNQ4ZXc+XAtdezKlbV5747XZcxZqjM
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACDD223E63526E4DB8BB2CAE8146FC2B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9821b74a-962b-4971-0fa0-08d76a261f4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 23:47:06.7070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hyclPqoq3zeLk8W/Q87QA8Xi7xwhIM2vvbTpWzP/ThxMD8LtwRI/jGJVCFSuCrUG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2487
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_08:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911150206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMTUvMTkgMzo0NCBQTSwgRGFuaWVsIEJvcmttYW5uIHdyb3RlOg0KPiBPbiAxMS8xNi8x
OSAxMjozNyBBTSwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPj4gT24gMTEvMTUvMTkgMzoz
MSBQTSwgRGFuaWVsIEJvcmttYW5uIHdyb3RlOg0KPj4+IE9uIDExLzE1LzE5IDU6MDIgQU0sIEFu
ZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4+Pj4gQWRkIGFiaWxpdHkgdG8gbWVtb3J5LW1hcCBjb250
ZW50cyBvZiBCUEYgYXJyYXkgbWFwLiBUaGlzIGlzIGV4dHJlbWVseQ0KPj4+PiB1c2VmdWwNCj4+
Pj4gZm9yIHdvcmtpbmcgd2l0aCBCUEYgZ2xvYmFsIGRhdGEgZnJvbSB1c2Vyc3BhY2UgcHJvZ3Jh
bXMuIEl0IGFsbG93cyB0bw0KPj4+PiBhdm9pZA0KPj4+PiB0eXBpY2FsIGJwZl9tYXBfe2xvb2t1
cCx1cGRhdGV9X2VsZW0gb3BlcmF0aW9ucywgaW1wcm92aW5nIGJvdGgNCj4+Pj4gcGVyZm9ybWFu
Y2UNCj4+Pj4gYW5kIHVzYWJpbGl0eS4NCj4+Pj4NCj4+Pj4gVGhlcmUgaGFkIHRvIGJlIHNwZWNp
YWwgY29uc2lkZXJhdGlvbnMgZm9yIG1hcCBmcmVlemluZywgdG8gYXZvaWQgDQo+Pj4+IGhhdmlu
Zw0KPj4+PiB3cml0YWJsZSBtZW1vcnkgdmlldyBpbnRvIGEgZnJvemVuIG1hcC4gVG8gc29sdmUg
dGhpcyBpc3N1ZSwgbWFwDQo+Pj4+IGZyZWV6aW5nIGFuZA0KPj4+PiBtbWFwLWluZyBpcyBoYXBw
ZW5pbmcgdW5kZXIgbXV0ZXggbm93Og0KPj4+PiDCoMKgwqAgLSBpZiBtYXAgaXMgYWxyZWFkeSBm
cm96ZW4sIG5vIHdyaXRhYmxlIG1hcHBpbmcgaXMgYWxsb3dlZDsNCj4+Pj4gwqDCoMKgIC0gaWYg
bWFwIGhhcyB3cml0YWJsZSBtZW1vcnkgbWFwcGluZ3MgYWN0aXZlIChhY2NvdW50ZWQgaW4NCj4+
Pj4gbWFwLT53cml0ZWNudCksDQo+Pj4+IMKgwqDCoMKgwqAgbWFwIGZyZWV6aW5nIHdpbGwga2Vl
cCBmYWlsaW5nIHdpdGggLUVCVVNZOw0KPj4+PiDCoMKgwqAgLSBvbmNlIG51bWJlciBvZiB3cml0
YWJsZSBtZW1vcnkgbWFwcGluZ3MgZHJvcHMgdG8gemVybywgbWFwDQo+Pj4+IGZyZWV6aW5nIGNh
biBiZQ0KPj4+PiDCoMKgwqDCoMKgIHBlcmZvcm1lZCBhZ2Fpbi4NCj4+Pj4NCj4+Pj4gT25seSBu
b24tcGVyLUNQVSBwbGFpbiBhcnJheXMgYXJlIHN1cHBvcnRlZCByaWdodCBub3cuIE1hcHMgd2l0
aA0KPj4+PiBzcGlubG9ja3MNCj4+Pj4gY2FuJ3QgYmUgbWVtb3J5IG1hcHBlZCBlaXRoZXIuDQo+
Pj4+DQo+Pj4+IEZvciBCUEZfRl9NTUFQQUJMRSBhcnJheSwgbWVtb3J5IGFsbG9jYXRpb24gaGFz
IHRvIGJlIGRvbmUgdGhyb3VnaA0KPj4+PiB2bWFsbG9jKCkNCj4+Pj4gdG8gYmUgbW1hcCgpJ2Fi
bGUuIFdlIGFsc28gbmVlZCB0byBtYWtlIHN1cmUgdGhhdCBhcnJheSBkYXRhIG1lbW9yeSBpcw0K
Pj4+PiBwYWdlLXNpemVkIGFuZCBwYWdlLWFsaWduZWQsIHNvIHdlIG92ZXItYWxsb2NhdGUgbWVt
b3J5IGluIHN1Y2ggYSB3YXkNCj4+Pj4gdGhhdA0KPj4+PiBzdHJ1Y3QgYnBmX2FycmF5IGlzIGF0
IHRoZSBlbmQgb2YgYSBzaW5nbGUgcGFnZSBvZiBtZW1vcnkgd2l0aA0KPj4+PiBhcnJheS0+dmFs
dWUNCj4+Pj4gYmVpbmcgYWxpZ25lZCB3aXRoIHRoZSBzdGFydCBvZiB0aGUgc2Vjb25kIHBhZ2Uu
IE9uIGRlYWxsb2NhdGlvbiB3ZQ0KPj4+PiBuZWVkIHRvDQo+Pj4+IGFjY29tb2RhdGUgdGhpcyBt
ZW1vcnkgYXJyYW5nZW1lbnQgdG8gZnJlZSB2bWFsbG9jKCknZWQgbWVtb3J5IA0KPj4+PiBjb3Jy
ZWN0bHkuDQo+Pj4+DQo+Pj4+IE9uZSBpbXBvcnRhbnQgY29uc2lkZXJhdGlvbiByZWdhcmRpbmcg
aG93IG1lbW9yeS1tYXBwaW5nIHN1YnN5c3RlbQ0KPj4+PiBmdW5jdGlvbnMuDQo+Pj4+IE1lbW9y
eS1tYXBwaW5nIHN1YnN5c3RlbSBwcm92aWRlcyBmZXcgb3B0aW9uYWwgY2FsbGJhY2tzLCBhbW9u
ZyB0aGVtDQo+Pj4+IG9wZW4oKQ0KPj4+PiBhbmQgY2xvc2UoKS7CoCBjbG9zZSgpIGlzIGNhbGxl
ZCBmb3IgZWFjaCBtZW1vcnkgcmVnaW9uIHRoYXQgaXMNCj4+Pj4gdW5tYXBwZWQsIHNvDQo+Pj4+
IHRoYXQgdXNlcnMgY2FuIGRlY3JlYXNlIHRoZWlyIHJlZmVyZW5jZSBjb3VudGVycyBhbmQgZnJl
ZSB1cA0KPj4+PiByZXNvdXJjZXMsIGlmDQo+Pj4+IG5lY2Vzc2FyeS4gb3BlbigpIGlzICphbG1v
c3QqIHN5bW1ldHJpY2FsOiBpdCdzIGNhbGxlZCBmb3IgZWFjaCBtZW1vcnkNCj4+Pj4gcmVnaW9u
DQo+Pj4+IHRoYXQgaXMgYmVpbmcgbWFwcGVkLCAqKmV4Y2VwdCoqIHRoZSB2ZXJ5IGZpcnN0IG9u
ZS4gU28gYnBmX21hcF9tbWFwIA0KPj4+PiBkb2VzDQo+Pj4+IGluaXRpYWwgcmVmY250IGJ1bXAs
IHdoaWxlIG9wZW4oKSB3aWxsIGRvIGFueSBleHRyYSBvbmVzIGFmdGVyIHRoYXQuIA0KPj4+PiBU
aHVzDQo+Pj4+IG51bWJlciBvZiBjbG9zZSgpIGNhbGxzIGlzIGVxdWFsIHRvIG51bWJlciBvZiBv
cGVuKCkgY2FsbHMgcGx1cyBvbmUgDQo+Pj4+IG1vcmUuDQo+Pj4+DQo+Pj4+IENjOiBKb2hhbm5l
cyBXZWluZXIgPGhhbm5lc0BjbXB4Y2hnLm9yZz4NCj4+Pj4gQ2M6IFJpayB2YW4gUmllbCA8cmll
bEBzdXJyaWVsLmNvbT4NCj4+Pj4gQWNrZWQtYnk6IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0Bm
Yi5jb20+DQo+Pj4+IEFja2VkLWJ5OiBKb2huIEZhc3RhYmVuZCA8am9obi5mYXN0YWJlbmRAZ21h
aWwuY29tPg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIu
Y29tPg0KPj4+DQo+Pj4gWy4uLl0NCj4+Pj4gKy8qIGNhbGxlZCBmb3IgYW55IGV4dHJhIG1lbW9y
eS1tYXBwZWQgcmVnaW9ucyAoZXhjZXB0IGluaXRpYWwpICovDQo+Pj4+ICtzdGF0aWMgdm9pZCBi
cGZfbWFwX21tYXBfb3BlbihzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSkNCj4+Pj4gK3sNCj4+
Pj4gK8KgwqDCoCBzdHJ1Y3QgYnBmX21hcCAqbWFwID0gdm1hLT52bV9maWxlLT5wcml2YXRlX2Rh
dGE7DQo+Pj4+ICsNCj4+Pj4gK8KgwqDCoCBicGZfbWFwX2luYyhtYXApOw0KPj4+DQo+Pj4gVGhp
cyB3b3VsZCBhbHNvIG5lZWQgdG8gaW5jIHVyZWYgY291bnRlciBzaW5jZSBpdCdzIHRlY2huaWNh
bGx5IGEgDQo+Pj4gcmVmZXJlbmNlDQo+Pj4gb2YgdGhpcyBtYXAgaW50byB1c2VyIHNwYWNlIGFz
IG90aGVyd2lzZSBpZiBtYXAtPm9wcy0+bWFwX3JlbGVhc2VfdXJlZg0KPj4+IHdvdWxkDQo+Pj4g
YmUgdXNlZCBmb3IgbWFwcyBzdXBwb3J0aW5nIG1tYXAsIHRoZW4gdGhlIGNhbGxiYWNrIHdvdWxk
IHRyaWdnZXIgZXZlbg0KPj4+IGlmIHVzZXINCj4+PiBzcGFjZSBzdGlsbCBoYXMgYSByZWZlcmVu
Y2UgdG8gaXQuDQo+Pg0KPj4gSSB0aG91Z2h0IHdlIHVzZSB1cmVmIG9ubHkgZm9yIGFycmF5IHRo
YXQgY2FuIGhvbGQgRkRzID8NCj4+IFRoYXQncyB3aHkgSSBzdWdnZXN0ZWQgQW5kcmlpIGVhcmxp
ZXIgdG8gZHJvcCB1cmVmKysuDQo+IA0KPiBZZWFoLCBvbmx5IGZvciBmZCBhcnJheSBjdXJyZW50
bHkuIFF1ZXN0aW9uIGlzLCBpZiB3ZSBldmVyIHJldXNlIHRoYXQgDQo+IG1hcF9yZWxlYXNlX3Vy
ZWYNCj4gY2FsbGJhY2sgaW4gZnV0dXJlIGZvciBzb21ldGhpbmcgZWxzZSwgd2lsbCB3ZSByZW1l
bWJlciB0aGF0IHdlIGVhcmxpZXIgDQo+IG1pc3NlZCB0byBhZGQNCj4gaXQgaGVyZT8gOi8NCg0K
V2hhdCBkbyB5b3UgbWVhbiAnbWlzc2VkIHRvIGFkZCcgPw0KVGhpcyBpcyBtbWFwIHBhdGguIEFu
eXRoaW5nIHRoYXQgbmVlZHMgcmVsZWFzaW5nIChsaWtlIEZEcyBmb3IgDQpwcm9nX2FycmF5IG9y
IHByb2dzIGZvciBzb2NrbWFwKSBjYW5ub3QgYmUgbW1hcC1hYmxlLg0KDQoNCg==
