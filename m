Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E396D2F75
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 19:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfJJRTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 13:19:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19168 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726131AbfJJRTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 13:19:30 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9AH7A3k018682;
        Thu, 10 Oct 2019 10:19:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=B+5Ns28EhcwoidKDx8A4nZ9NVX+e4p+KSTMlnfKiBOU=;
 b=QbFLF53mDP+2IGIqH/od/bqE3rl0tl2yA8VWDwZghOiecbnxM34tgS0W6J4aouxhEhov
 pIJnrQ3caY0oWV1RsbsZwP/1ZG54w5X28+d097rYG9VRdvVzduFqu3UoRqcvSRBV3cj/
 uIr4aK+0qwHYhzHLtCaDKOh6wp9hECBjGYA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vhyc0u2js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Oct 2019 10:19:04 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 10 Oct 2019 10:19:03 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 10 Oct 2019 10:19:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqxpdmjr7tNbUouGHuyz558CKLKVkAIP9nnYQdgni+ff+ilBaDLL+MLEHQnHn2F7rruvVGbDweX4EM7GKhz/ySIeK4UB1R7OmSvKln4vPpocQygUawkvvwj3d0UtrCespl6c9NszvV/rgewqBDxMx9vCQVpgYQDpbVGOdVtfa0Lgx5NfWs6SVzMxh2O4NezjkZXusJ6scmB5h1g9r30CG3FVcHggJ71njzlpuu4Af4zRptKAcM9x7rV9fvdRk7afskLSMiiLzbg+V53SUe41r/5wT5+MfAvrZxUhuxjx4PSqWZmHFwTG7muMlsCxyE+KQVbjO746BQMnCU0qpwI1Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+5Ns28EhcwoidKDx8A4nZ9NVX+e4p+KSTMlnfKiBOU=;
 b=T8zcRkslhLShvtlvkZoTkndhhMCJeGKUFrYeqY6tXFo/FiLB8LXy9Umt+qUR/LKy098prk4L0K5ZLEgrIORAeBgY5Yekct5rnOMFOxMjMFq6mfXW5NEAIj8cppLuw0GLiZ1e20Gu/KSjDHSiu8Z8F5djjBPAZvBftU1XUXmTpIFJNWwFXpuliFuyo6vUcgSUZN5HHdnC7q637CLEIrGxNufTlfjFU7jgSxgCTfCOHR8IDmOrsLIqkE7QbK35qETQI6Ekiea/AWhEKA+EtwVUsZlNV3HI3GsZaYHGQC1ev+iteOJtJ7/PxjMb3ISbbRUMkdgweAgUBRdhF8KBafSyJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+5Ns28EhcwoidKDx8A4nZ9NVX+e4p+KSTMlnfKiBOU=;
 b=XjBdI1HLsHJWZv2MeRPTb3+YihL6BghT0CxLY4vgso7f1ScpHcjDab7jfX4zPl+NDM1+P3YIxewuFpuV1vPlIyieFuE4ITxVVM1OEtHYcB4IjpdCVGLCzs0wBXFVIt/Zf8/PZ6J21Xeau2m+hzmqhEK/NYwrpfUzVwFb1rCsezc=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2663.namprd15.prod.outlook.com (20.179.156.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 17:19:01 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.026; Thu, 10 Oct 2019
 17:19:01 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/2] bpf/stackmap: fix A-A deadlock in
 bpf_get_stack()
Thread-Topic: [PATCH bpf-next 2/2] bpf/stackmap: fix A-A deadlock in
 bpf_get_stack()
Thread-Index: AQHVfzKswn/pkqmThEy7QwA/cvFN/adTfF0AgACi1oA=
Date:   Thu, 10 Oct 2019 17:19:01 +0000
Message-ID: <a1d30b11-2759-0293-5612-48150db92775@fb.com>
References: <20191010061916.198761-1-songliubraving@fb.com>
 <20191010061916.198761-3-songliubraving@fb.com>
 <20191010073608.GO2311@hirez.programming.kicks-ass.net>
In-Reply-To: <20191010073608.GO2311@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0001.namprd19.prod.outlook.com
 (2603:10b6:300:d4::11) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f66f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99400205-3077-480d-10db-08d74da5f101
x-ms-traffictypediagnostic: BYAPR15MB2663:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2663530AE9E4E6AD6F7AEA96D7940@BYAPR15MB2663.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:175;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(376002)(366004)(396003)(39860400002)(136003)(346002)(199004)(189003)(256004)(66556008)(66446008)(64756008)(478600001)(6512007)(8676002)(102836004)(446003)(54906003)(81156014)(11346002)(66476007)(66946007)(6486002)(486006)(81166006)(52116002)(305945005)(14444005)(2616005)(76176011)(46003)(7736002)(25786009)(476003)(6436002)(229853002)(31686004)(14454004)(186003)(6246003)(4326008)(99286004)(36756003)(2906002)(316002)(71200400001)(71190400001)(8936002)(86362001)(110136005)(5660300002)(6116002)(53546011)(31696002)(6506007)(386003)(6636002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2663;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JlOUHvbFeeg2+KRy49JZw8XQa/AWVhuCfJKMTIj6QfhcxnWnnD+kgjM0alnSJl4MZQdskhH9ke1muTcJi2uY+SIDuptoNzBRiiRLunhordFCcPrdUieQS7zpxV2AYVfQcC5mejVBuLMqJoEooUVv9sCIpZNH3cgPleF2e2DEcBhRSFfYbpruzZU/Kuy3X1YcVS96KGRCnn//GWQNnxWBz1th3Viy6IT2JKIVLBckmuuU83aHycGVKkE3rIMt+gRzVZ1MBiQYG3tb3aceAtS7IMwTAoJ4rpWyljyMJEmYBA4sXyrbpu4FzsGqvh5UBsJrdYhcucMpTrGzuZQVAEujDB9JGFsy4QF53K6csYv2Q4SkUrV/PtB0K/2fsAvH9Y/l1jiGQP8VsorOBQy/LVMKDPp61g7KT9xe4PsIjFew+Zg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <886DEB1D6DD67342989EFADF24526243@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 99400205-3077-480d-10db-08d74da5f101
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 17:19:01.6349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qdu9LS4OBj4OODOhtT/UZd8oFp5Z1dOGidoEFv/jOnWqagubIfg7bH6jhl6scPX3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2663
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_06:2019-10-10,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1011 spamscore=0 suspectscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTAvMTkgMTI6MzYgQU0sIFBldGVyIFppamxzdHJhIHdyb3RlOg0KPiBPbiBXZWQsIE9j
dCAwOSwgMjAxOSBhdCAxMToxOToxNlBNIC0wNzAwLCBTb25nIExpdSB3cm90ZToNCj4+IGJwZiBz
dGFja21hcCB3aXRoIGJ1aWxkLWlkIGxvb2t1cCAoQlBGX0ZfU1RBQ0tfQlVJTERfSUQpIGNhbiB0
cmlnZ2VyIEEtQQ0KPj4gZGVhZGxvY2sgb24gcnFfbG9jaygpOg0KPj4NCj4+IHJjdTogSU5GTzog
cmN1X3NjaGVkIGRldGVjdGVkIHN0YWxscyBvbiBDUFVzL3Rhc2tzOg0KPj4gWy4uLl0NCj4+IENh
bGwgVHJhY2U6DQo+PiAgIHRyeV90b193YWtlX3VwKzB4MWFkLzB4NTkwDQo+PiAgIHdha2VfdXBf
cSsweDU0LzB4ODANCj4+ICAgcndzZW1fd2FrZSsweDhhLzB4YjANCj4+ICAgYnBmX2dldF9zdGFj
aysweDEzYy8weDE1MA0KPj4gICBicGZfcHJvZ19mYmRhZjQyZWRlZDlmZTQ2X29uX2V2ZW50KzB4
NWUzLzB4MTAwMA0KPj4gICBicGZfb3ZlcmZsb3dfaGFuZGxlcisweDYwLzB4MTAwDQo+PiAgIF9f
cGVyZl9ldmVudF9vdmVyZmxvdysweDRmLzB4ZjANCj4+ICAgcGVyZl9zd2V2ZW50X292ZXJmbG93
KzB4OTkvMHhjMA0KPj4gICBfX19wZXJmX3N3X2V2ZW50KzB4ZTcvMHgxMjANCj4+ICAgX19zY2hl
ZHVsZSsweDQ3ZC8weDYyMA0KPj4gICBzY2hlZHVsZSsweDI5LzB4OTANCj4+ICAgZnV0ZXhfd2Fp
dF9xdWV1ZV9tZSsweGI5LzB4MTEwDQo+PiAgIGZ1dGV4X3dhaXQrMHgxMzkvMHgyMzANCj4+ICAg
ZG9fZnV0ZXgrMHgyYWMvMHhhNTANCj4+ICAgX194NjRfc3lzX2Z1dGV4KzB4MTNjLzB4MTgwDQo+
PiAgIGRvX3N5c2NhbGxfNjQrMHg0Mi8weDEwMA0KPj4gICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVy
X2h3ZnJhbWUrMHg0NC8weGE5DQo+Pg0KPiANCj4+IGRpZmYgLS1naXQgYS9rZXJuZWwvYnBmL3N0
YWNrbWFwLmMgYi9rZXJuZWwvYnBmL3N0YWNrbWFwLmMNCj4+IGluZGV4IDA1MjU4MGMzM2QyNi4u
M2IyNzhmNmIwYzNlIDEwMDY0NA0KPj4gLS0tIGEva2VybmVsL2JwZi9zdGFja21hcC5jDQo+PiAr
KysgYi9rZXJuZWwvYnBmL3N0YWNrbWFwLmMNCj4+IEBAIC0yODcsNyArMjg3LDcgQEAgc3RhdGlj
IHZvaWQgc3RhY2tfbWFwX2dldF9idWlsZF9pZF9vZmZzZXQoc3RydWN0IGJwZl9zdGFja19idWls
ZF9pZCAqaWRfb2ZmcywNCj4+ICAgCWJvb2wgaXJxX3dvcmtfYnVzeSA9IGZhbHNlOw0KPj4gICAJ
c3RydWN0IHN0YWNrX21hcF9pcnFfd29yayAqd29yayA9IE5VTEw7DQo+Pg0KPj4gLQlpZiAoaW5f
bm1pKCkpIHsNCj4+ICsJaWYgKGluX25taSgpIHx8IHRoaXNfcnFfaXNfbG9ja2VkKCkpIHsNCj4+
ICAgCQl3b3JrID0gdGhpc19jcHVfcHRyKCZ1cF9yZWFkX3dvcmspOw0KPj4gICAJCWlmICh3b3Jr
LT5pcnFfd29yay5mbGFncyAmIElSUV9XT1JLX0JVU1kpDQo+PiAgIAkJCS8qIGNhbm5vdCBxdWV1
ZSBtb3JlIHVwX3JlYWQsIGZhbGxiYWNrICovDQo+IA0KPiBUaGlzIGlzIGhvcnJpZmljIGNyYXAu
IEp1c3Qgc2F5IG5vIHRvIHRoYXQgZ2V0X2J1aWxkX2lkX29mZnNldCgpDQo+IHRyYWlud3JlY2su
DQoNCnRoaXMgaXMgbm90IGEgaGVscGZ1bCBjb21tZW50Lg0KV2hhdCBpc3N1ZXMgZG8geW91IHNl
ZSB3aXRoIHRoaXMgYXBwcm9hY2g/DQoNCg0KDQo=
