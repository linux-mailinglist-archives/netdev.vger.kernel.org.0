Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29FC18DFFA
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 23:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfHNVeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 17:34:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40404 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726126AbfHNVeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 17:34:08 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7ELTsMW016454;
        Wed, 14 Aug 2019 14:33:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Ncsx/56qLQDGSwTWxlXYqN641WZ4gcRQ/E54ntEJR8w=;
 b=NJMeir/LswpR4drstTODFpyujQmyCCmEjShg3ENZJD8LsnfHGC1sDzGBXQAw3UF3bbEH
 CsN2QcY1jgqTwVQ3aWvtbxw2/AF2Hu1g9dAWZszCvEGKtpIZMcq9zXfk4nghxtxp7HC1
 noCafhAG6t38L7OV62pWRDTGExX59wSLATY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ucnrh97xd-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Aug 2019 14:33:46 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 14 Aug 2019 14:33:39 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 14 Aug 2019 14:33:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWDUCGKXjvRWvVA+fX6uXAKnq9JwCsbu0CiRKObKRJfi2A7xfd6+mX79NcL/ycQWshyo9D3fSEuWI6neElWiNc+TE+7vlyO3xYU2KXfU59BaOWGwvCSCpyqlW1LrtF3HAfawcHOy/0a/4i2yHoCNI3coAwTcLvT1dnQNEq3HRboMZS36Gr9vSN2ESS10wWboRO0aKy5vH+PZ9kHf5991+quGCgulhUOhBOmq2ExSFAjCzFtS/OZr6968bL/D8b85e6qNeC75eSeJ+eW8fqM+P5XV1kOEEIix+iXpj5qWnMSbj2jPTW1lvQtxuMjUslqNrZf+CtPAiGTFXpoRc7gRLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ncsx/56qLQDGSwTWxlXYqN641WZ4gcRQ/E54ntEJR8w=;
 b=arZEUIpkyzcSJXZJdVj4Tnv+aVm87TWvITu+5dFIUMG7JMadv58Nbg9L864tMcS0KfovmwI9Bk/bOc3rvibN1Zq9g4tqUhdATJbHA1b+31c4bhQTzfqJX/BiM0/bgFAjgeUKLiKccTpov2xbWtgle6Qps/Rj5CrEj5IVd7tpWsQDoi5JagmNA2AH2xK7xD1ZtaLdp78taKaXTIVsp6PyHlcd5SmwoGHQHchVo5py0f5m++StQYf5cigSIErz7kdaIvE8Li9E/DTIVXAf9Q/7YkPYLHXhnf8f4lYq6p/GdYgGpALnfSbsFgBNXJkNJ2xT4wqWsR+lsRYcGmJDpDYfEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ncsx/56qLQDGSwTWxlXYqN641WZ4gcRQ/E54ntEJR8w=;
 b=YNHoE/pS0XnGyM2zRCAPqQj8QnmmeRBp+8XH1DpvEa7jOqSxrEEbHCRN0XN7aXMIBy0CowAx7erAcV6fueu1GrzXcuqZZLvOHjE36S3CS0/s7z+zZSkkYUGagQOeK18jv+jJ1UGcK4rFTGgWcFH7nQV6jW1Owsj5wcquoCoeTkc=
Received: from CY4PR15MB1366.namprd15.prod.outlook.com (10.172.157.148) by
 CY4PR15MB1157.namprd15.prod.outlook.com (10.172.180.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Wed, 14 Aug 2019 21:33:37 +0000
Received: from CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::6c5f:cfef:6a46:d2f1]) by CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::6c5f:cfef:6a46:d2f1%9]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 21:33:37 +0000
From:   Andrey Ignatov <rdna@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next] libbpf: make libbpf.map source of truth for
 libbpf version
Thread-Topic: [PATCH v3 bpf-next] libbpf: make libbpf.map source of truth for
 libbpf version
Thread-Index: AQHVUuLfjUXQ4rgAbkuSgmKgiDiL8Kb7KhSA
Date:   Wed, 14 Aug 2019 21:33:37 +0000
Message-ID: <20190814213335.GA90959@rdna-mbp.dhcp.thefacebook.com>
References: <20190814200548.623033-1-andriin@fb.com>
In-Reply-To: <20190814200548.623033-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:300:117::22) To CY4PR15MB1366.namprd15.prod.outlook.com
 (2603:10b6:903:f7::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::c9a8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05b83037-758a-4f7f-a3a7-08d720ff112a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1157;
x-ms-traffictypediagnostic: CY4PR15MB1157:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB1157CF006BD9BD4397319407A8AD0@CY4PR15MB1157.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(39860400002)(136003)(366004)(199004)(189003)(256004)(386003)(6636002)(8936002)(102836004)(14444005)(486006)(2906002)(6506007)(46003)(476003)(33656002)(5660300002)(446003)(11346002)(64756008)(66446008)(66556008)(66946007)(66476007)(71190400001)(71200400001)(4326008)(316002)(6862004)(25786009)(1076003)(186003)(6246003)(53936002)(81156014)(76176011)(52116002)(6116002)(81166006)(8676002)(7736002)(305945005)(54906003)(478600001)(6512007)(9686003)(229853002)(14454004)(99286004)(6486002)(6436002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1157;H:CY4PR15MB1366.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MMi9US7thh20HtNgJPb4mW/b52hUa+6Zt7DTWfQCLN6zktbdmp85/0xNMNltSdbR+wWB0lnDUTvVUH7rzeq7GKlgjqkOOMowouFPy7rRbi9vkznn+30Q6ds0sj2ka93aqW7fsBicAD7X365yQxZ9wbPpepJtiUn83C3oI/rJqqNrkOczvRHI1m8i/ZRYfOtYHqubWfBjEIhkoQN2ZlTMJHn2FxEJc1VnkbIjjSCe8yaBXQyGytLg4jkxP01ynC+3EFPtQoWGdxFpX9gyU0TMyw+PUYztXqCyqJUU5aWn5WgGB8fjOV45Nwj/CZ5LUOuleaavQeOX15iADdFp0RFZdhmy8a9rE0zTN1IXAftro61VysG9F2B69Ob1kAHbgNzbSMC6hX7Loe4pxp+ZRGf96bxOh0ZXUoV5NliugG1nuPM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <566EB6A9710A3145BDBFE412FC431402@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b83037-758a-4f7f-a3a7-08d720ff112a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 21:33:37.7378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TkONYk0rjApdOFp1aPjU0zdfCKdtFayWpuYqMK1Gub8CtbFAe5YbMTkfyGlecRUH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1157
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-14_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908140194
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4gW1dlZCwgMjAxOS0wOC0xNCAxMzo1NyAt
MDcwMF06DQo+IEN1cnJlbnRseSBsaWJicGYgdmVyc2lvbiBpcyBzcGVjaWZpZWQgaW4gMiBwbGFj
ZXM6IGxpYmJwZi5tYXAgYW5kDQo+IE1ha2VmaWxlLiBUaGV5IGVhc2lseSBnZXQgb3V0IG9mIHN5
bmMgYW5kIGl0J3MgdmVyeSBlYXN5IHRvIHVwZGF0ZSBvbmUsDQo+IGJ1dCBmb3JnZXQgdG8gdXBk
YXRlIGFub3RoZXIgb25lLiBJbiBhZGRpdGlvbiwgR2l0aHViIHByb2plY3Rpb24gb2YNCj4gbGli
YnBmIGhhcyB0byBtYWludGFpbiBpdHMgb3duIHZlcnNpb24gd2hpY2ggaGFzIHRvIGJlIHJlbWVt
YmVyZWQgdG8gYmUNCj4ga2VwdCBpbiBzeW5jIG1hbnVhbGx5LCB3aGljaCBpcyB2ZXJ5IGVycm9y
LXByb25lIGFwcHJvYWNoLg0KPiANCj4gVGhpcyBwYXRjaCBtYWtlcyBsaWJicGYubWFwIGEgc291
cmNlIG9mIHRydXRoIGZvciBsaWJicGYgdmVyc2lvbiBhbmQNCj4gdXNlcyBzaGVsbCBpbnZvY2F0
aW9uIHRvIHBhcnNlIG91dCBjb3JyZWN0IGZ1bGwgYW5kIG1ham9yIGxpYmJwZiB2ZXJzaW9uDQo+
IHRvIHVzZSBkdXJpbmcgYnVpbGQuIE5vdyB3ZSBuZWVkIHRvIG1ha2Ugc3VyZSB0aGF0IG9uY2Ug
bmV3IHJlbGVhc2UNCj4gY3ljbGUgc3RhcnRzLCB3ZSBuZWVkIHRvIGFkZCAoaW5pdGlhbGx5KSBl
bXB0eSBzZWN0aW9uIHRvIGxpYmJwZi5tYXANCj4gd2l0aCBjb3JyZWN0IGxhdGVzdCB2ZXJzaW9u
Lg0KPiANCj4gVGhpcyBhbHNvIHdpbGwgbWFrZSBpdCBwb3NzaWJsZSB0byBrZWVwIEdpdGh1YiBw
cm9qZWN0aW9uIGNvbnNpc3RlbnQNCj4gd2l0aCBrZXJuZWwgc291cmNlcyB2ZXJzaW9uIG9mIGxp
YmJwZiBieSBhZG9wdGluZyBzaW1pbGFyIHBhcnNpbmcgb2YNCj4gdmVyc2lvbiBmcm9tIGxpYmJw
Zi5tYXAuDQo+IA0KPiB2Mi0+djM6DQo+IC0gZ3JlcCAtbyArIHNvcnQgLXJWIChBbmRyZXkpOw0K
PiANCj4gdjEtPnYyOg0KPiAtIGVhZ2VyIHZlcnNpb24gdmFycyBldmFsdWF0aW9uIChKYWt1Yik7
DQo+IC0gc2ltcGxpZmllZCB2ZXJzaW9uIHJlZ2V4IChBbmRyZXkpOw0KDQpBY2tlZC1ieTogQW5k
cmV5IElnbmF0b3YgPHJkbmFAZmIuY29tPg0KDQoNCj4gQ2M6IEFuZHJleSBJZ25hdG92IDxyZG5h
QGZiLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNv
bT4NCj4gLS0tDQo+ICB0b29scy9saWIvYnBmL01ha2VmaWxlICAgfCAyMCArKysrKysrKy0tLS0t
LS0tLS0tLQ0KPiAgdG9vbHMvbGliL2JwZi9saWJicGYubWFwIHwgIDMgKysrDQo+ICAyIGZpbGVz
IGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL3Rvb2xzL2xpYi9icGYvTWFrZWZpbGUgYi90b29scy9saWIvYnBmL01ha2VmaWxlDQo+
IGluZGV4IDkzMTIwNjZhMWFlMy4uMTQ4YTI3MTY0MTg5IDEwMDY0NA0KPiAtLS0gYS90b29scy9s
aWIvYnBmL01ha2VmaWxlDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvTWFrZWZpbGUNCj4gQEAgLTEs
OSArMSwxMCBAQA0KPiAgIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogKExHUEwtMi4xIE9SIEJT
RC0yLUNsYXVzZSkNCj4gICMgTW9zdCBvZiB0aGlzIGZpbGUgaXMgY29waWVkIGZyb20gdG9vbHMv
bGliL3RyYWNlZXZlbnQvTWFrZWZpbGUNCj4gIA0KPiAtQlBGX1ZFUlNJT04gPSAwDQo+IC1CUEZf
UEFUQ0hMRVZFTCA9IDANCj4gLUJQRl9FWFRSQVZFUlNJT04gPSA0DQo+ICtMSUJCUEZfVkVSU0lP
TiA6PSAkKHNoZWxsIFwNCj4gKwlncmVwIC1vRSAnXkxJQkJQRl8oWzAtOS5dKyknIGxpYmJwZi5t
YXAgfCBcDQo+ICsJc29ydCAtclYgfCBoZWFkIC1uMSB8IGN1dCAtZCdfJyAtZjIpDQo+ICtMSUJC
UEZfTUFKT1JfVkVSU0lPTiA6PSAkKGZpcnN0d29yZCAkKHN1YnN0IC4sICwkKExJQkJQRl9WRVJT
SU9OKSkpDQo+ICANCj4gIE1BS0VGTEFHUyArPSAtLW5vLXByaW50LWRpcmVjdG9yeQ0KPiAgDQo+
IEBAIC03OSwxNSArODAsOSBAQCBleHBvcnQgcHJlZml4IGxpYmRpciBzcmMgb2JqDQo+ICBsaWJk
aXJfU1EgPSAkKHN1YnN0ICcsJ1wnJywkKGxpYmRpcikpDQo+ICBsaWJkaXJfcmVsYXRpdmVfU1Eg
PSAkKHN1YnN0ICcsJ1wnJywkKGxpYmRpcl9yZWxhdGl2ZSkpDQo+ICANCj4gLVZFUlNJT04JCT0g
JChCUEZfVkVSU0lPTikNCj4gLVBBVENITEVWRUwJPSAkKEJQRl9QQVRDSExFVkVMKQ0KPiAtRVhU
UkFWRVJTSU9OCT0gJChCUEZfRVhUUkFWRVJTSU9OKQ0KPiAtDQo+ICBPQkoJCT0gJEANCj4gIE4J
CT0NCj4gIA0KPiAtTElCQlBGX1ZFUlNJT04JPSAkKEJQRl9WRVJTSU9OKS4kKEJQRl9QQVRDSExF
VkVMKS4kKEJQRl9FWFRSQVZFUlNJT04pDQo+IC0NCj4gIExJQl9UQVJHRVQJPSBsaWJicGYuYSBs
aWJicGYuc28uJChMSUJCUEZfVkVSU0lPTikNCj4gIExJQl9GSUxFCT0gbGliYnBmLmEgbGliYnBm
LnNvKg0KPiAgUENfRklMRQkJPSBsaWJicGYucGMNCj4gQEAgLTE3OCwxMCArMTczLDEwIEBAICQo
QlBGX0lOKTogZm9yY2UgZWxmZGVwIGJwZmRlcA0KPiAgJChPVVRQVVQpbGliYnBmLnNvOiAkKE9V
VFBVVClsaWJicGYuc28uJChMSUJCUEZfVkVSU0lPTikNCj4gIA0KPiAgJChPVVRQVVQpbGliYnBm
LnNvLiQoTElCQlBGX1ZFUlNJT04pOiAkKEJQRl9JTikNCj4gLQkkKFFVSUVUX0xJTkspJChDQykg
LS1zaGFyZWQgLVdsLC1zb25hbWUsbGliYnBmLnNvLiQoVkVSU0lPTikgXA0KPiArCSQoUVVJRVRf
TElOSykkKENDKSAtLXNoYXJlZCAtV2wsLXNvbmFtZSxsaWJicGYuc28uJChMSUJCUEZfTUFKT1Jf
VkVSU0lPTikgXA0KPiAgCQkJCSAgICAtV2wsLS12ZXJzaW9uLXNjcmlwdD0kKFZFUlNJT05fU0NS
SVBUKSAkXiAtbGVsZiAtbyAkQA0KPiAgCUBsbiAtc2YgJChARikgJChPVVRQVVQpbGliYnBmLnNv
DQo+IC0JQGxuIC1zZiAkKEBGKSAkKE9VVFBVVClsaWJicGYuc28uJChWRVJTSU9OKQ0KPiArCUBs
biAtc2YgJChARikgJChPVVRQVVQpbGliYnBmLnNvLiQoTElCQlBGX01BSk9SX1ZFUlNJT04pDQo+
ICANCj4gICQoT1VUUFVUKWxpYmJwZi5hOiAkKEJQRl9JTikNCj4gIAkkKFFVSUVUX0xJTkspJChS
TSkgJEA7ICQoQVIpIHJjcyAkQCAkXg0KPiBAQCAtMjU3LDcgKzI1Miw4IEBAIGNvbmZpZy1jbGVh
bjoNCj4gIA0KPiAgY2xlYW46DQo+ICAJJChjYWxsIFFVSUVUX0NMRUFOLCBsaWJicGYpICQoUk0p
ICQoVEFSR0VUUykgJChDWFhfVEVTVF9UQVJHRVQpIFwNCj4gLQkJKi5vICp+ICouYSAqLnNvICou
c28uJChWRVJTSU9OKSAuKi5kIC4qLmNtZCAqLnBjIExJQkJQRi1DRkxBR1MNCj4gKwkJKi5vICp+
ICouYSAqLnNvICouc28uJChMSUJCUEZfTUFKT1JfVkVSU0lPTikgLiouZCAuKi5jbWQgXA0KPiAr
CQkqLnBjIExJQkJQRi1DRkxBR1MNCj4gIAkkKGNhbGwgUVVJRVRfQ0xFQU4sIGNvcmUtZ2VuKSAk
KFJNKSAkKE9VVFBVVClGRUFUVVJFLURVTVAubGliYnBmDQo+ICANCj4gIA0KPiBkaWZmIC0tZ2l0
IGEvdG9vbHMvbGliL2JwZi9saWJicGYubWFwIGIvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+
IGluZGV4IGY5ZDMxNmU4NzNkOC4uNGU3MmRmOGU5OGJhIDEwMDY0NA0KPiAtLS0gYS90b29scy9s
aWIvYnBmL2xpYmJwZi5tYXANCj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+IEBA
IC0xODQsMyArMTg0LDYgQEAgTElCQlBGXzAuMC40IHsNCj4gIAkJcGVyZl9idWZmZXJfX25ld19y
YXc7DQo+ICAJCXBlcmZfYnVmZmVyX19wb2xsOw0KPiAgfSBMSUJCUEZfMC4wLjM7DQo+ICsNCj4g
K0xJQkJQRl8wLjAuNSB7DQo+ICt9IExJQkJQRl8wLjAuNDsNCj4gLS0gDQo+IDIuMTcuMQ0KPiAN
Cg0KLS0gDQpBbmRyZXkgSWduYXRvdg0K
