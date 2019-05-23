Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E42E27583
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 07:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfEWFeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 01:34:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46920 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725786AbfEWFeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 01:34:12 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4N5WXf7025937;
        Wed, 22 May 2019 22:33:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=YTNDL9JYQFyG9rL19fZF2L1zUVgike9zAG3uJZAduKY=;
 b=JbTK75rVaoFAfV/dyEOHl6EKOPPIq9MBS+iBYkr67knfCm6ECjVueKQ6StkABiD0oFYU
 jNISXNLpKENlrd7TAX8WXLmIz7douMa6QsyGx6l2NC2oANqFi4c2GzfK+nha+d7AVCvg
 Pjf4ZJTu0UGWvUwZo3NlDTuvRZrMmeCV20Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn9bgtj9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 May 2019 22:33:49 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 22:33:47 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 22 May 2019 22:33:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTNDL9JYQFyG9rL19fZF2L1zUVgike9zAG3uJZAduKY=;
 b=H1ixN45mB8QST0QWm2Y0WLuEHEoxheunJjsC/PhPWrkhpp5vQj4Q5TVD0hnx9SMQ9tTl5/Hw+LsqDCH8R/UvJX6nuEejPBcFJAZzHBVEsiBh2F11v/52JM6p1U4BzDUvYmnAgPBF9FGswHfmk7h1QxUKVubTTeHrK72isGyS8C8=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3240.namprd15.prod.outlook.com (20.179.57.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Thu, 23 May 2019 05:33:45 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 05:33:45 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Roman Gushchin <guro@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jolsa@redhat.com" <jolsa@redhat.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: decouple the lifetime of cgroup_bpf
 from cgroup itself
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: decouple the lifetime of cgroup_bpf
 from cgroup itself
Thread-Index: AQHVEPV8fnh1KoyybESqE07m+r7jv6Z4MDwA
Date:   Thu, 23 May 2019 05:33:45 +0000
Message-ID: <530bba0f-9e13-5308-fc93-d0dab0c56fcc@fb.com>
References: <20190522232051.2938491-1-guro@fb.com>
 <20190522232051.2938491-2-guro@fb.com>
In-Reply-To: <20190522232051.2938491-2-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0059.namprd08.prod.outlook.com
 (2603:10b6:300:c0::33) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::c87a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72bbd13a-26da-44f2-f0da-08d6df403924
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB3240;
x-ms-traffictypediagnostic: BYAPR15MB3240:
x-microsoft-antispam-prvs: <BYAPR15MB324041652C3CB6BBE34AC3EAD3010@BYAPR15MB3240.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(396003)(366004)(346002)(199004)(189003)(2616005)(5024004)(256004)(66946007)(66476007)(66556008)(64756008)(66446008)(73956011)(2501003)(486006)(476003)(68736007)(4326008)(46003)(71190400001)(14444005)(25786009)(186003)(316002)(71200400001)(5660300002)(81166006)(31696002)(6512007)(11346002)(446003)(6436002)(99286004)(86362001)(8676002)(81156014)(6116002)(6486002)(8936002)(6246003)(36756003)(229853002)(54906003)(110136005)(14454004)(478600001)(76176011)(52116002)(102836004)(53546011)(6506007)(386003)(305945005)(53936002)(7736002)(2906002)(31686004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3240;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IlQejTvoaVsAVpHJH8H88OgSHon/kD4NwZcV50bX8kVl3jRn2/ysazJoUXWTQLq2yIqHShzYWUoeRLyDApw4lHAlAx3cO9r40w3dBSlU/pAAOwj6QL06yffTvbvKcYqRRujYLAKheKmG273zG2tzf8oJSHZUKFE7mLsrMy51A2Yi16EEsk8xB0Al6KVoaYXgpttj25QgMdK0cEKVCEA/EQrOa36Rio2Ph5rJ//9eCTTn42YVGOKMRalxtpe+Qp12Ezm0K7geu+SmJT0TvO+eavX9SKrAjIa8vfv+nv5wLaaUXGkOE/6htpfiyWkFnDbUe7GwJJ7DzXwFt7h/r/+ivlHVlWpeRHGrh29eJ0WeUoeUkcMxdfyenBc79diDfjStFcZH4CwbF6KTddDIvW3TTJanWkUBSAmjV7iERwnI3R4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <30619F7B64C7734CABEE2D10DE1CA489@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 72bbd13a-26da-44f2-f0da-08d6df403924
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 05:33:45.2035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3240
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=640 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230039
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjIvMTkgNDoyMCBQTSwgUm9tYW4gR3VzaGNoaW4gd3JvdGU6DQo+IEN1cnJlbnRs
eSB0aGUgbGlmZXRpbWUgb2YgYnBmIHByb2dyYW1zIGF0dGFjaGVkIHRvIGEgY2dyb3VwIGlzIGJv
dW5kDQo+IHRvIHRoZSBsaWZldGltZSBvZiB0aGUgY2dyb3VwIGl0c2VsZi4gSXQgbWVhbnMgdGhh
dCBpZiBhIHVzZXINCj4gZm9yZ2V0cyAob3IgaW50ZW50aW9uYWxseSBhdm9pZHMpIHRvIGRldGFj
aCBhIGJwZiBwcm9ncmFtIGJlZm9yZQ0KPiByZW1vdmluZyB0aGUgY2dyb3VwLCBpdCB3aWxsIHN0
YXkgYXR0YWNoZWQgdXAgdG8gdGhlIHJlbGVhc2Ugb2YgdGhlDQo+IGNncm91cC4gU2luY2UgdGhl
IGNncm91cCBjYW4gc3RheSBpbiB0aGUgZHlpbmcgc3RhdGUgKHRoZSBzdGF0ZQ0KPiBiZXR3ZWVu
IGJlaW5nIHJtZGlyKCknZWQgYW5kIGJlaW5nIHJlbGVhc2VkKSBmb3IgYSB2ZXJ5IGxvbmcgdGlt
ZSwgaXQNCj4gbGVhZHMgdG8gYSB3YXN0ZSBvZiBtZW1vcnkuIEFsc28sIGl0IGJsb2NrcyBhIHBv
c3NpYmlsaXR5IHRvIGltcGxlbWVudA0KPiB0aGUgbWVtY2ctYmFzZWQgbWVtb3J5IGFjY291bnRp
bmcgZm9yIGJwZiBvYmplY3RzLCBiZWNhdXNlIGEgY2lyY3VsYXINCj4gcmVmZXJlbmNlIGRlcGVu
ZGVuY3kgd2lsbCBvY2N1ci4gQ2hhcmdlZCBtZW1vcnkgcGFnZXMgYXJlIHBpbm5pbmcgdGhlDQo+
IGNvcnJlc3BvbmRpbmcgbWVtb3J5IGNncm91cCwgYW5kIGlmIHRoZSBtZW1vcnkgY2dyb3VwIGlz
IHBpbm5pbmcNCj4gdGhlIGF0dGFjaGVkIGJwZiBwcm9ncmFtLCBub3RoaW5nIHdpbGwgYmUgZXZl
ciByZWxlYXNlZC4NCj4gDQo+IEEgZHlpbmcgY2dyb3VwIGNhbiBub3QgY29udGFpbiBhbnkgcHJv
Y2Vzc2VzLCBzbyB0aGUgb25seSBjaGFuY2UgZm9yDQo+IGFuIGF0dGFjaGVkIGJwZiBwcm9ncmFt
IHRvIGJlIGV4ZWN1dGVkIGlzIGEgbGl2ZSBzb2NrZXQgYXNzb2NpYXRlZA0KPiB3aXRoIHRoZSBj
Z3JvdXAuIFNvIGluIG9yZGVyIHRvIHJlbGVhc2UgYWxsIGJwZiBkYXRhIGVhcmx5LCBsZXQncw0K
PiBjb3VudCBhc3NvY2lhdGVkIHNvY2tldHMgdXNpbmcgYSBuZXcgcGVyY3B1IHJlZmNvdW50ZXIu
IE9uIGNncm91cA0KPiByZW1vdmFsIHRoZSBjb3VudGVyIGlzIHRyYW5zaXRpb25lZCB0byB0aGUg
YXRvbWljIG1vZGUsIGFuZCBhcyBzb29uDQo+IGFzIGl0IHJlYWNoZXMgMCwgYWxsIGJwZiBwcm9n
cmFtcyBhcmUgZGV0YWNoZWQuDQo+IA0KPiBUaGUgcmVmZXJlbmNlIGNvdW50ZXIgaXMgbm90IHNv
Y2tldCBzcGVjaWZpYywgYW5kIGNhbiBiZSB1c2VkIGZvciBhbnkNCj4gb3RoZXIgdHlwZXMgb2Yg
cHJvZ3JhbXMsIHdoaWNoIGNhbiBiZSBleGVjdXRlZCBmcm9tIGEgY2dyb3VwLWJwZiBob29rDQo+
IG91dHNpZGUgb2YgdGhlIHByb2Nlc3MgY29udGV4dCwgaGFkIHN1Y2ggYSBuZWVkIGFyaXNlIGlu
IHRoZSBmdXR1cmUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBSb21hbiBHdXNoY2hpbiA8Z3Vyb0Bm
Yi5jb20+DQo+IENjOiBqb2xzYUByZWRoYXQuY29tDQoNClRoZSBsb2dpYyBsb29rcyBzb3VuZCB0
byBtZS4gV2l0aCBvbmUgbml0IGJlbG93LA0KQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0Bm
Yi5jb20+DQoNCj4gLS0tDQo+ICAgaW5jbHVkZS9saW51eC9icGYtY2dyb3VwLmggfCAgOCArKysr
KystLQ0KPiAgIGluY2x1ZGUvbGludXgvY2dyb3VwLmggICAgIHwgMTggKysrKysrKysrKysrKysr
KysrDQo+ICAga2VybmVsL2JwZi9jZ3JvdXAuYyAgICAgICAgfCAyNSArKysrKysrKysrKysrKysr
KysrKysrLS0tDQo+ICAga2VybmVsL2Nncm91cC9jZ3JvdXAuYyAgICAgfCAxMSArKysrKysrKy0t
LQ0KPiAgIDQgZmlsZXMgY2hhbmdlZCwgNTQgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkN
Cj4gDQpbLi4uXQ0KPiBAQCAtMTY3LDcgKzE3OCwxMiBAQCBpbnQgY2dyb3VwX2JwZl9pbmhlcml0
KHN0cnVjdCBjZ3JvdXAgKmNncnApDQo+ICAgICovDQo+ICAgI2RlZmluZQlOUiBBUlJBWV9TSVpF
KGNncnAtPmJwZi5lZmZlY3RpdmUpDQo+ICAgCXN0cnVjdCBicGZfcHJvZ19hcnJheSBfX3JjdSAq
YXJyYXlzW05SXSA9IHt9Ow0KPiAtCWludCBpOw0KPiArCWludCByZXQsIGk7DQo+ICsNCj4gKwly
ZXQgPSBwZXJjcHVfcmVmX2luaXQoJmNncnAtPmJwZi5yZWZjbnQsIGNncm91cF9icGZfcmVsZWFz
ZSwgMCwNCj4gKwkJCSAgICAgIEdGUF9LRVJORUwpOw0KPiArCWlmIChyZXQpDQo+ICsJCXJldHVy
biAtRU5PTUVNOw0KTWF5YmUgcmV0dXJuICJyZXQiIGhlcmUgaW5zdGVhZCBvZiAtRU5PTUVNLiBD
dXJyZW50bHksIHBlcmNwdV9yZWZfaW5pdA0Kb25seSByZXR1cm4gZXJyb3IgY29kZSBpcyAtRU5P
TUVNLiBCdXQgaW4gdGhlIGZ1dHVyZSwgaXQgY291bGQNCmNoYW5nZT8NCg0KPiAgIA0KPiAgIAlm
b3IgKGkgPSAwOyBpIDwgTlI7IGkrKykNCj4gICAJCUlOSVRfTElTVF9IRUFEKCZjZ3JwLT5icGYu
cHJvZ3NbaV0pOw0KPiBAQCAtMTgzLDYgKzE5OSw5IEBAIGludCBjZ3JvdXBfYnBmX2luaGVyaXQo
c3RydWN0IGNncm91cCAqY2dycCkNCj4gICBjbGVhbnVwOg0KPiAgIAlmb3IgKGkgPSAwOyBpIDwg
TlI7IGkrKykNCj4gICAJCWJwZl9wcm9nX2FycmF5X2ZyZWUoYXJyYXlzW2ldKTsNCj4gKw0KPiAr
CXBlcmNwdV9yZWZfZXhpdCgmY2dycC0+YnBmLnJlZmNudCk7DQo+ICsNCj4gICAJcmV0dXJuIC1F
Tk9NRU07DQo+ICAgfQ0KPiAgIA0KWy4uLl0NCg==
