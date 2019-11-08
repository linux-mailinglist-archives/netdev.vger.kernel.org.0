Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77896F56E3
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388183AbfKHTNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:13:22 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25008 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730481AbfKHTNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:13:21 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8J5F1m031594;
        Fri, 8 Nov 2019 11:13:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nHgY6GI/FxMjygL8ktWA9kpdd+oxm7t/2kRInsOSd9M=;
 b=mQTFeohVsefHSZWwZBYVClWpTTM3R1R/fnLiWB/6MYosncMHvFR/QfGlCF2TSJNn6iW/
 f1/So8dvg4yBSHryms0MurutdX0ZTc/Nh7DJBtkyGRo29ScGXKBHpSnDlLo4MWrghxjI
 NN4qjRsM8H6Zr+5//sbxE/NNefM0akdFZ48= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w5a4rhjax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 Nov 2019 11:13:07 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 11:13:06 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 11:13:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGLzr63wCiJpmw+oChDxjpdMoxWxqvWuVYMbAhbhMmoA+XGwN9Bi784Yobr0wleZtyLFSwIBB74KX0Cai2oKON+ziBe481JMUJx9BwVY49NLMEHIQD3dL6OKp6TaX4CkT6ZGWXXv+5xa7SzgG6KcfmGLgXHO/jiA9DJi4Xotw6k8IcBEkPNcsnyJqKkd3/+f3pMY3Ugdjc3eKsv23kzuL3019+xNU+8C1qBU8/gy396eaW8KY5yEc0Loh30SOac7psPk7Trk+1YLSANChYQKtjQYD2FCyngZCY3psiF8wshWy3MghdPE+aZLaEvgh0S8H+1M2Et5tqamzuEPNtUyCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nHgY6GI/FxMjygL8ktWA9kpdd+oxm7t/2kRInsOSd9M=;
 b=FH8ZlcxDv3XdaKFiZZ9VsLtyAe8BLDEwnVgJ7ErMrx5dbZlRRes2lzsI/tvrrk1wYtA5bZkv9xqMU6Rr1dzAOYyKVA8R6d9gKcuj8XV6JWe/koN5f30rjIjrLxlbxvneLHLm1WLv3BuW49eYpeyIp3LyAteSqxXFQsm6JGN0kclO6/jxWlV3n5XkIHGv6FGTFiQfotX1eP+rv2D5u0glzKQeT0AyZOb2VmmlfG5wnTfhG3iQrkk943nU8C2kvnruwewRYO5AnpOzLrxKHJ02BQf6GqVtY3N7kvXdAVVn9uN3S/T9laYQrdTQGMTyZE1fHnHh2jKCDyqyw8Y8P1AUUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nHgY6GI/FxMjygL8ktWA9kpdd+oxm7t/2kRInsOSd9M=;
 b=UUG8z92bgiai6IseO83K1V2nF0EUhOOpfohHZYN+vXrCB24vYr4sEWxC9zopS/ArTsPSKeU/dDQfQZBKMbhcKYmaqrv8aLGjFfeMuZzgNazxxl//JLH5SU1iO9BRJc8WPam9rXd88yGFPMZBfIphOoa5eyCkrAJ+2pwoxuZUkOI=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2277.namprd15.prod.outlook.com (52.135.201.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.23; Fri, 8 Nov 2019 19:13:05 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 19:13:04 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 16/18] libbpf: Add support for attaching BPF
 programs to other BPF programs
Thread-Topic: [PATCH v3 bpf-next 16/18] libbpf: Add support for attaching BPF
 programs to other BPF programs
Thread-Index: AQHVlf+YV9gcpqVdl0WJouUia2BSfKeBoMuAgAAESYA=
Date:   Fri, 8 Nov 2019 19:13:04 +0000
Message-ID: <624d217e-ac6f-f69b-855d-b3b533ed5104@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-17-ast@kernel.org>
 <88611E3B-DD55-4D33-AA15-73DE58F8D44D@fb.com>
In-Reply-To: <88611E3B-DD55-4D33-AA15-73DE58F8D44D@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR07CA0079.namprd07.prod.outlook.com (2603:10b6:100::47)
 To BYAPR15MB2501.namprd15.prod.outlook.com (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:f248]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8ef0097-48d5-4d52-43a6-08d7647fae5f
x-ms-traffictypediagnostic: BYAPR15MB2277:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB22776D08D98E673F81FE94B6D77B0@BYAPR15MB2277.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(366004)(136003)(39860400002)(346002)(199004)(189003)(25786009)(8936002)(86362001)(81156014)(6512007)(386003)(31696002)(6116002)(66446008)(64756008)(66556008)(46003)(110136005)(186003)(76176011)(99286004)(8676002)(54906003)(66476007)(66946007)(316002)(102836004)(486006)(81166006)(6506007)(53546011)(305945005)(11346002)(71200400001)(31686004)(6486002)(4326008)(52116002)(5660300002)(71190400001)(6246003)(2906002)(6436002)(476003)(36756003)(446003)(14454004)(5024004)(2616005)(256004)(229853002)(478600001)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2277;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yD940UYVwLb8TSVfppNYdaTBmDpwJOBWK5fYVHy3eetZca8nrOf9kvVIYyZjuSD6+TmNwRlaKNRPw9VVXgsgzFNHzDskib/TThtx8/RR9j2DhoTrhjDCRMxeWwHYgmLUIH49z3kdRHaYsdfl2Q4zZC1bIe6Pr2ia54JdemaIkLP0Z1Z/HXbXvxUYUcoX7bIuAwDUo2Ut3YzMNBT8CTFf5pU6t8z9SV/ygzDaqkClvK6iB1oKWgvvssnR3mLA6bhJceeMtIB4yueUVSaobCKhgmcSomWpJW0OnnpG7P2XUmmWSDLXmG2QXHcBe2FxCH8N+SBgYUQx9jW8fjZLM1+hN/cWzg8t8s/7RZCdTn6ZOPZBY+05zxTscKN4hY6IQqwuaRmkp1aOchtLmcfDWFtxuicFveViqPbYyDXLkDnABbTlRO8UdEHIziJksEV1nDa8
Content-Type: text/plain; charset="utf-8"
Content-ID: <00BB6E7F23CC25469C6BE6D5F32EEB9A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ef0097-48d5-4d52-43a6-08d7647fae5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 19:13:04.7246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +thH+bsmAXUdaAGtzak32moSR0znnMw2ii1nwhZAR+YYAiW0pdQshB2/jbeSdc0g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2277
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_07:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvOC8xOSAxMDo1NyBBTSwgU29uZyBMaXUgd3JvdGU6DQo+IA0KPiANCj4+IE9uIE5vdiA3
LCAyMDE5LCBhdCAxMDo0MCBQTSwgQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4g
d3JvdGU6DQo+Pg0KPj4gRXh0ZW5kIGxpYmJwZiBhcGkgdG8gcGFzcyBhdHRhY2hfcHJvZ19mZCBp
bnRvIGJwZl9vYmplY3RfX29wZW4uDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQWxleGVpIFN0YXJv
dm9pdG92IDxhc3RAa2VybmVsLm9yZz4NCj4+IC0tLQ0KPiANCj4gWy4uLl0NCj4gDQo+PiArc3Rh
dGljIGludCBsaWJicGZfZmluZF9wcm9nX2J0Zl9pZChjb25zdCBjaGFyICpuYW1lLCBfX3UzMiBh
dHRhY2hfcHJvZ19mZCkNCj4+ICt7DQo+PiArCXN0cnVjdCBicGZfcHJvZ19pbmZvX2xpbmVhciAq
aW5mb19saW5lYXI7DQo+PiArCXN0cnVjdCBicGZfcHJvZ19pbmZvICppbmZvOw0KPj4gKwlzdHJ1
Y3QgYnRmICpidGYgPSBOVUxMOw0KPj4gKwlpbnQgZXJyID0gLUVJTlZBTDsNCj4+ICsNCj4+ICsJ
aW5mb19saW5lYXIgPSBicGZfcHJvZ3JhbV9fZ2V0X3Byb2dfaW5mb19saW5lYXIoYXR0YWNoX3By
b2dfZmQsIDApOw0KPj4gKwlpZiAoSVNfRVJSX09SX05VTEwoaW5mb19saW5lYXIpKSB7DQo+PiAr
CQlwcl93YXJuKCJmYWlsZWQgZ2V0X3Byb2dfaW5mb19saW5lYXIgZm9yIEZEICVkXG4iLA0KPj4g
KwkJCWF0dGFjaF9wcm9nX2ZkKTsNCj4+ICsJCXJldHVybiAtRUlOVkFMOw0KPj4gKwl9DQo+PiAr
CWluZm8gPSAmaW5mb19saW5lYXItPmluZm87DQo+PiArCWlmICghaW5mby0+YnRmX2lkKSB7DQo+
PiArCQlwcl93YXJuKCJUaGUgdGFyZ2V0IHByb2dyYW0gZG9lc24ndCBoYXZlIEJURlxuIik7DQo+
PiArCQlnb3RvIG91dDsNCj4+ICsJfQ0KPj4gKwlpZiAoYnRmX19nZXRfZnJvbV9pZChpbmZvLT5i
dGZfaWQsICZidGYpKSB7DQo+PiArCQlwcl93YXJuKCJGYWlsZWQgdG8gZ2V0IEJURiBvZiB0aGUg
cHJvZ3JhbVxuIik7DQo+PiArCQlnb3RvIG91dDsNCj4+ICsJfQ0KPj4gKwllcnIgPSBidGZfX2Zp
bmRfYnlfbmFtZV9raW5kKGJ0ZiwgbmFtZSwgQlRGX0tJTkRfRlVOQyk7DQo+PiArCWJ0Zl9fZnJl
ZShidGYpOw0KPj4gKwlpZiAoZXJyIDw9IDApIHsNCj4+ICsJCXByX3dhcm4oIiVzIGlzIG5vdCBm
b3VuZCBpbiBwcm9nJ3MgQlRGXG4iLCBuYW1lKTsNCj4+ICsJCWdvdG8gb3V0Ow0KPiAJCV5eXiBU
aGlzIGdvdG8gZG9lc24ndCByZWFsbHkgZG8gbXVjaC4NCg0KeWVhaC4gaXQgZG9lcyBsb29rIGEg
Yml0IHdlaXJkLg0KSSB3YW50ZWQgdG8ga2VlcCB1bmlmb3JtIGVycm9yIGhhbmRsaW5nLCBidXQg
Y2FuIHJlbW92ZSBpdA0KaWYgeW91IGluc2lzdC4NCg0KPj4gKwl9DQo+PiArb3V0Og0KPj4gKwlm
cmVlKGluZm9fbGluZWFyKTsNCj4+ICsJcmV0dXJuIGVycjsNCj4+ICt9DQo+IA0KPiBPdGhlcndp
c2UNCj4gDQo+IEFja2VkLWJ5OiBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPg0KPiAN
Cg0K
