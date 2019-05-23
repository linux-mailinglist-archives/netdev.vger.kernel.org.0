Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22365275A1
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 07:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfEWFjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 01:39:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45770 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725786AbfEWFjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 01:39:39 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4N5Ya3J020798;
        Wed, 22 May 2019 22:39:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6XW1jGW+FRgoFVj/DOCpLr5C/042hdrU0LzGx0Oppyg=;
 b=V8nR8BLzevPCe+/bK0jlrvB4fgSNQgGiliQF/xiZ9NcBqo4U57ns477K/Tw68x9U+ipq
 JXJWYvwyeMh6soO0n8G8JknKcd+nj7OPdPDguU4mkaYL0lpEEziArpw0cBVsx32ug3Ga
 MJ9JXp30lCxwcrHu7wEOmrDOBXE8EyAk5w0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn81p2uu0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 May 2019 22:39:17 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 22:39:16 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 22:39:16 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 22 May 2019 22:39:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XW1jGW+FRgoFVj/DOCpLr5C/042hdrU0LzGx0Oppyg=;
 b=HXBzRWw6byFVM54gqNcLI4gocahSeVAHHks4y4B2CcCiymrFwxA8k1OC5zKkPPoqEAwQJvSYGz3njGBu8dMbMnaoMFCC8GXTKTGz2BZfggBq0OgdNv9hXb4bVLZ9H6A7fCzJDPOtA+ay7du4l+e21Wlnw784u8sUFpAX6ZZMiWk=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2549.namprd15.prod.outlook.com (20.179.155.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 05:39:14 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 05:39:14 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Roman Gushchin <guro@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 2/4] selftests/bpf: convert test_cgrp2_attach2
 example into kselftest
Thread-Topic: [PATCH v2 bpf-next 2/4] selftests/bpf: convert
 test_cgrp2_attach2 example into kselftest
Thread-Index: AQHVEPUmhI6LefAR402If1tRYLUqp6Z4McWA
Date:   Thu, 23 May 2019 05:39:13 +0000
Message-ID: <f9f4843c-8f52-b373-1e85-4bccd3311a55@fb.com>
References: <20190522232051.2938491-1-guro@fb.com>
 <20190522232051.2938491-3-guro@fb.com>
In-Reply-To: <20190522232051.2938491-3-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0080.namprd17.prod.outlook.com
 (2603:10b6:300:c2::18) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::c87a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66c7ebd8-9198-4446-47b5-08d6df40fd07
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2549;
x-ms-traffictypediagnostic: BYAPR15MB2549:
x-microsoft-antispam-prvs: <BYAPR15MB25494AB3E03AE5475265B291D3010@BYAPR15MB2549.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(346002)(376002)(39860400002)(199004)(189003)(6512007)(305945005)(99286004)(53546011)(36756003)(102836004)(7736002)(486006)(2906002)(478600001)(46003)(71190400001)(8676002)(71200400001)(81166006)(8936002)(53936002)(14454004)(2616005)(476003)(2501003)(81156014)(6506007)(386003)(52116002)(54906003)(14444005)(256004)(76176011)(86362001)(66946007)(66476007)(73956011)(4326008)(6486002)(110136005)(68736007)(6246003)(25786009)(186003)(5024004)(229853002)(5660300002)(6116002)(66446008)(446003)(31696002)(66556008)(316002)(11346002)(64756008)(31686004)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2549;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BewBgkivF4fNz/KSllesQ+/ZLlSNGtadmnBT0rYJsdHZqtWZMRpdzcEUnbXQSbP3yhT1egO9H7s6IJvlogANv/L3fzB0Qtc3rqbzJEz/R0nXgLsIh4ssf2jpjN3u4puaa3zNv8svzv3qmmhiZMWHqA9bd2VaAb21No/jUpi1xVAc9b/8WNYfd18AWobOJTVgArvo4ofgY901wFY/qJv6/pM2PQvGswqFdJVW1/XYZYvzFRSoCdhd/bcguaV3SNE7RE5WVpsmg4M68xmbBjd9+S1S2Wm5RS9jtFYQmt3V7CIjxJGsqC6Zo+zPJi0je8KotlAhiR8Yen1x/gACPu9vlSpzxonN31GBdN6VcW10ZeSDgEZFwmrZ4tF/x2oNW5jBN+HlImuMGCHR+lfDCck3XGWaC+/wY6rqVCy4Ax8qDXY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B02AA06137F9F9489136CF92F9C93E5C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c7ebd8-9198-4446-47b5-08d6df40fd07
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 05:39:14.0075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2549
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230040
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjIvMTkgNDoyMCBQTSwgUm9tYW4gR3VzaGNoaW4gd3JvdGU6DQo+IENvbnZlcnQg
dGVzdF9jZ3JwMl9hdHRhY2gyIGV4YW1wbGUgaW50byBhIHByb3BlciB0ZXN0X2Nncm91cF9hdHRh
Y2gNCj4ga3NlbGZ0ZXN0LiBJdCdzIGJldHRlciBiZWNhdXNlIHdlIGRvIHJ1biBrc2VsZnRlc3Qg
b24gYSBjb25zdGFudA0KPiBiYXNpcywgc28gdGhlcmUgYXJlIGJldHRlciBjaGFuY2VzIHRvIHNw
b3QgYSBwb3RlbnRpYWwgcmVncmVzc2lvbi4NCj4gDQo+IEFsc28gbWFrZSBpdCBzbGlnaHRseSBs
ZXNzIHZlcmJvc2UgdG8gY29uZm9ybSBrc2VsZnRlc3RzIG91dHB1dCBzdHlsZS4NCj4gDQo+IE91
dHB1dCBleGFtcGxlOg0KPiAgICAkIC4vdGVzdF9jZ3JvdXBfYXR0YWNoDQo+ICAgICNvdmVycmlk
ZTpQQVNTDQo+ICAgICNtdWx0aTpQQVNTDQo+ICAgIHRlc3RfY2dyb3VwX2F0dGFjaDpQQVNTDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBSb21hbiBHdXNoY2hpbiA8Z3Vyb0BmYi5jb20+DQpBY2sgZXhj
ZXB0IHRoZSBuaXQgYmVsb3cuDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4N
Cj4gLS0tDQo+ICAgc2FtcGxlcy9icGYvTWFrZWZpbGUgICAgICAgICAgICAgICAgICAgICAgICAg
IHwgIDIgLQ0KPiAgIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9NYWtlZmlsZSAgICAgICAg
ICB8ICA0ICstDQo+ICAgLi4uL3NlbGZ0ZXN0cy9icGYvdGVzdF9jZ3JvdXBfYXR0YWNoLmMgICAg
ICAgIHwgNDggKysrKysrKysrKysrLS0tLS0tLQ0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgMzUgaW5z
ZXJ0aW9ucygrKSwgMTkgZGVsZXRpb25zKC0pDQo+ICAgcmVuYW1lIHNhbXBsZXMvYnBmL3Rlc3Rf
Y2dycDJfYXR0YWNoMi5jID0+IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2Nncm91
cF9hdHRhY2guYyAoOTIlKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3NhbXBsZXMvYnBmL01ha2VmaWxl
IGIvc2FtcGxlcy9icGYvTWFrZWZpbGUNCj4gaW5kZXggNGYwYTFjZGJmZTdjLi4yNTNlNWEyODU2
YmUgMTAwNjQ0DQo+IC0tLSBhL3NhbXBsZXMvYnBmL01ha2VmaWxlDQo+ICsrKyBiL3NhbXBsZXMv
YnBmL01ha2VmaWxlDQo+IEBAIC0yNiw3ICsyNiw2IEBAIGhvc3Rwcm9ncy15ICs9IG1hcF9wZXJm
X3Rlc3QNCj4gICBob3N0cHJvZ3MteSArPSB0ZXN0X292ZXJoZWFkDQo+ICAgaG9zdHByb2dzLXkg
Kz0gdGVzdF9jZ3JwMl9hcnJheV9waW4NCj4gICBob3N0cHJvZ3MteSArPSB0ZXN0X2NncnAyX2F0
dGFjaA0KPiAtaG9zdHByb2dzLXkgKz0gdGVzdF9jZ3JwMl9hdHRhY2gyDQo+ICAgaG9zdHByb2dz
LXkgKz0gdGVzdF9jZ3JwMl9zb2NrDQo+ICAgaG9zdHByb2dzLXkgKz0gdGVzdF9jZ3JwMl9zb2Nr
Mg0KPiAgIGhvc3Rwcm9ncy15ICs9IHhkcDENCj4gQEAgLTgxLDcgKzgwLDYgQEAgbWFwX3BlcmZf
dGVzdC1vYmpzIDo9IGJwZl9sb2FkLm8gbWFwX3BlcmZfdGVzdF91c2VyLm8NCj4gICB0ZXN0X292
ZXJoZWFkLW9ianMgOj0gYnBmX2xvYWQubyB0ZXN0X292ZXJoZWFkX3VzZXIubw0KPiAgIHRlc3Rf
Y2dycDJfYXJyYXlfcGluLW9ianMgOj0gdGVzdF9jZ3JwMl9hcnJheV9waW4ubw0KPiAgIHRlc3Rf
Y2dycDJfYXR0YWNoLW9ianMgOj0gdGVzdF9jZ3JwMl9hdHRhY2gubw0KPiAtdGVzdF9jZ3JwMl9h
dHRhY2gyLW9ianMgOj0gdGVzdF9jZ3JwMl9hdHRhY2gyLm8gJChDR1JPVVBfSEVMUEVSUykNCj4g
ICB0ZXN0X2NncnAyX3NvY2stb2JqcyA6PSB0ZXN0X2NncnAyX3NvY2subw0KPiAgIHRlc3RfY2dy
cDJfc29jazItb2JqcyA6PSBicGZfbG9hZC5vIHRlc3RfY2dycDJfc29jazIubw0KPiAgIHhkcDEt
b2JqcyA6PSB4ZHAxX3VzZXIubw0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMvYnBmL01ha2VmaWxlIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL01ha2VmaWxlDQo+
IGluZGV4IDY2ZjJkY2ExZGVlMS4uZTA5ZjQxOWY0ZDdlIDEwMDY0NA0KPiAtLS0gYS90b29scy90
ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvTWFrZWZpbGUNCj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvYnBmL01ha2VmaWxlDQo+IEBAIC0yMyw3ICsyMyw4IEBAIFRFU1RfR0VOX1BST0dTID0g
dGVzdF92ZXJpZmllciB0ZXN0X3RhZyB0ZXN0X21hcHMgdGVzdF9scnVfbWFwIHRlc3RfbHBtX21h
cCB0ZXN0DQo+ICAgCXRlc3RfYWxpZ24gdGVzdF92ZXJpZmllcl9sb2cgdGVzdF9kZXZfY2dyb3Vw
IHRlc3RfdGNwYnBmX3VzZXIgXA0KPiAgIAl0ZXN0X3NvY2sgdGVzdF9idGYgdGVzdF9zb2NrbWFw
IHRlc3RfbGlyY19tb2RlMl91c2VyIGdldF9jZ3JvdXBfaWRfdXNlciBcDQo+ICAgCXRlc3Rfc29j
a2V0X2Nvb2tpZSB0ZXN0X2Nncm91cF9zdG9yYWdlIHRlc3Rfc2VsZWN0X3JldXNlcG9ydCB0ZXN0
X3NlY3Rpb25fbmFtZXMgXA0KPiAtCXRlc3RfbmV0Y250IHRlc3RfdGNwbm90aWZ5X3VzZXIgdGVz
dF9zb2NrX2ZpZWxkcyB0ZXN0X3N5c2N0bA0KPiArCXRlc3RfbmV0Y250IHRlc3RfdGNwbm90aWZ5
X3VzZXIgdGVzdF9zb2NrX2ZpZWxkcyB0ZXN0X3N5c2N0bCBcDQo+ICsJdGVzdF9jZ3JvdXBfYXR0
YWNoDQo+ICAgDQo+ICAgQlBGX09CSl9GSUxFUyA9ICQocGF0c3Vic3QgJS5jLCUubywgJChub3Rk
aXIgJCh3aWxkY2FyZCBwcm9ncy8qLmMpKSkNCj4gICBURVNUX0dFTl9GSUxFUyA9ICQoQlBGX09C
Sl9GSUxFUykNCj4gQEAgLTk2LDYgKzk3LDcgQEAgJChPVVRQVVQpL3Rlc3RfY2dyb3VwX3N0b3Jh
Z2U6IGNncm91cF9oZWxwZXJzLmMNCj4gICAkKE9VVFBVVCkvdGVzdF9uZXRjbnQ6IGNncm91cF9o
ZWxwZXJzLmMNCj4gICAkKE9VVFBVVCkvdGVzdF9zb2NrX2ZpZWxkczogY2dyb3VwX2hlbHBlcnMu
Yw0KPiAgICQoT1VUUFVUKS90ZXN0X3N5c2N0bDogY2dyb3VwX2hlbHBlcnMuYw0KPiArJChPVVRQ
VVQpL3Rlc3RfY2dyb3VwX2F0dGFjaDogY2dyb3VwX2hlbHBlcnMuYw0KPiAgIA0KPiAgIC5QSE9O
WTogZm9yY2UNCj4gICANCj4gZGlmZiAtLWdpdCBhL3NhbXBsZXMvYnBmL3Rlc3RfY2dycDJfYXR0
YWNoMi5jIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3RfY2dyb3VwX2F0dGFjaC5j
DQo+IHNpbWlsYXJpdHkgaW5kZXggOTIlDQo+IHJlbmFtZSBmcm9tIHNhbXBsZXMvYnBmL3Rlc3Rf
Y2dycDJfYXR0YWNoMi5jDQo+IHJlbmFtZSB0byB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYv
dGVzdF9jZ3JvdXBfYXR0YWNoLmMNCj4gaW5kZXggMGJiNjUwNzI1NmI3Li45M2Q0ZmUyOTVlN2Qg
MTAwNjQ0DQo+IC0tLSBhL3NhbXBsZXMvYnBmL3Rlc3RfY2dycDJfYXR0YWNoMi5jDQo+ICsrKyBi
L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2Nncm91cF9hdHRhY2guYw0KPiBAQCAt
MSwzICsxLDUgQEANCj4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+ICsN
Cj4gICAvKiBlQlBGIGV4YW1wbGUgcHJvZ3JhbToNCj4gICAgKg0KPiAgICAqIC0gQ3JlYXRlcyBh
cnJheW1hcCBpbiBrZXJuZWwgd2l0aCA0IGJ5dGVzIGtleXMgYW5kIDggYnl0ZSB2YWx1ZXMNCj4g
QEAgLTI1LDIwICsyNywyNyBAQA0KPiAgICNpbmNsdWRlIDxzeXMvcmVzb3VyY2UuaD4NCj4gICAj
aW5jbHVkZSA8c3lzL3RpbWUuaD4NCj4gICAjaW5jbHVkZSA8dW5pc3RkLmg+DQo+ICsjaW5jbHVk
ZSA8bGludXgvZmlsdGVyLmg+DQo+ICAgDQo+ICAgI2luY2x1ZGUgPGxpbnV4L2JwZi5oPg0KPiAg
ICNpbmNsdWRlIDxicGYvYnBmLmg+DQo+ICAgDQo+IC0jaW5jbHVkZSAiYnBmX2luc24uaCINCj4g
KyNpbmNsdWRlICJicGZfdXRpbC5oIg0KPiAgICNpbmNsdWRlICJicGZfcmxpbWl0LmgiDQo+ICAg
I2luY2x1ZGUgImNncm91cF9oZWxwZXJzLmgiDQo+ICAgDQo+ICAgI2RlZmluZSBGT08JCSIvZm9v
Ig0KPiAgICNkZWZpbmUgQkFSCQkiL2Zvby9iYXIvIg0KPiAtI2RlZmluZSBQSU5HX0NNRAkicGlu
ZyAtYzEgLXcxIDEyNy4wLjAuMSA+IC9kZXYvbnVsbCINCj4gKyNkZWZpbmUgUElOR19DTUQJInBp
bmcgLXEgLWMxIC13MSAxMjcuMC4wLjEgPiAvZGV2L251bGwiDQo+ICAgDQo+ICAgY2hhciBicGZf
bG9nX2J1ZltCUEZfTE9HX0JVRl9TSVpFXTsNCj4gICANCj4gKyNpZmRlZiBERUJVRw0KPiArI2Rl
ZmluZSBkZWJ1ZyhhcmdzLi4uKSBwcmludGYoYXJncykNCj4gKyNlbHNlDQo+ICsjZGVmaW5lIGRl
YnVnKGFyZ3MuLi4pDQo+ICsjZW5kaWYNCj4gKw0KPiAgIHN0YXRpYyBpbnQgcHJvZ19sb2FkKGlu
dCB2ZXJkaWN0KQ0KPiAgIHsNCj4gICAJaW50IHJldDsNCj4gQEAgLTg5LDcgKzk4LDcgQEAgc3Rh
dGljIGludCB0ZXN0X2Zvb19iYXIodm9pZCkNCj4gICAJCWdvdG8gZXJyOw0KPiAgIAl9DQo+ICAg
DQo+IC0JcHJpbnRmKCJBdHRhY2hlZCBEUk9QIHByb2cuIFRoaXMgcGluZyBpbiBjZ3JvdXAgL2Zv
byBzaG91bGQgZmFpbC4uLlxuIik7DQo+ICsJZGVidWcoIkF0dGFjaGVkIERST1AgcHJvZy4gVGhp
cyBwaW5nIGluIGNncm91cCAvZm9vIHNob3VsZCBmYWlsLi4uXG4iKTsNCj4gICAJYXNzZXJ0KHN5
c3RlbShQSU5HX0NNRCkgIT0gMCk7DQo+ICAgDQo+ICAgCS8qIENyZWF0ZSBjZ3JvdXAgL2Zvby9i
YXIsIGdldCBmZCwgYW5kIGpvaW4gaXQgKi8NCj4gQEAgLTEwMCw3ICsxMDksNyBAQCBzdGF0aWMg
aW50IHRlc3RfZm9vX2Jhcih2b2lkKQ0KPiAgIAlpZiAoam9pbl9jZ3JvdXAoQkFSKSkNCj4gICAJ
CWdvdG8gZXJyOw0KPiAgIA0KPiAtCXByaW50ZigiQXR0YWNoZWQgRFJPUCBwcm9nLiBUaGlzIHBp
bmcgaW4gY2dyb3VwIC9mb28vYmFyIHNob3VsZCBmYWlsLi4uXG4iKTsNCj4gKwlkZWJ1ZygiQXR0
YWNoZWQgRFJPUCBwcm9nLiBUaGlzIHBpbmcgaW4gY2dyb3VwIC9mb28vYmFyIHNob3VsZCBmYWls
Li4uXG4iKTsNCj4gICAJYXNzZXJ0KHN5c3RlbShQSU5HX0NNRCkgIT0gMCk7DQo+ICAgDQo+ICAg
CWlmIChicGZfcHJvZ19hdHRhY2goYWxsb3dfcHJvZywgYmFyLCBCUEZfQ0dST1VQX0lORVRfRUdS
RVNTLA0KPiBAQCAtMTA5LDcgKzExOCw3IEBAIHN0YXRpYyBpbnQgdGVzdF9mb29fYmFyKHZvaWQp
DQo+ICAgCQlnb3RvIGVycjsNCj4gICAJfQ0KPiAgIA0KPiAtCXByaW50ZigiQXR0YWNoZWQgUEFT
UyBwcm9nLiBUaGlzIHBpbmcgaW4gY2dyb3VwIC9mb28vYmFyIHNob3VsZCBwYXNzLi4uXG4iKTsN
Cj4gKwlkZWJ1ZygiQXR0YWNoZWQgUEFTUyBwcm9nLiBUaGlzIHBpbmcgaW4gY2dyb3VwIC9mb28v
YmFyIHNob3VsZCBwYXNzLi4uXG4iKTsNCj4gICAJYXNzZXJ0KHN5c3RlbShQSU5HX0NNRCkgPT0g
MCk7DQo+ICAgDQo+ICAgCWlmIChicGZfcHJvZ19kZXRhY2goYmFyLCBCUEZfQ0dST1VQX0lORVRf
RUdSRVNTKSkgew0KPiBAQCAtMTE3LDcgKzEyNiw3IEBAIHN0YXRpYyBpbnQgdGVzdF9mb29fYmFy
KHZvaWQpDQo+ICAgCQlnb3RvIGVycjsNCj4gICAJfQ0KPiAgIA0KPiAtCXByaW50ZigiRGV0YWNo
ZWQgUEFTUyBmcm9tIC9mb28vYmFyIHdoaWxlIERST1AgaXMgYXR0YWNoZWQgdG8gL2Zvby5cbiIN
Cj4gKwlkZWJ1ZygiRGV0YWNoZWQgUEFTUyBmcm9tIC9mb28vYmFyIHdoaWxlIERST1AgaXMgYXR0
YWNoZWQgdG8gL2Zvby5cbiINCj4gICAJICAgICAgICJUaGlzIHBpbmcgaW4gY2dyb3VwIC9mb28v
YmFyIHNob3VsZCBmYWlsLi4uXG4iKTsNCj4gICAJYXNzZXJ0KHN5c3RlbShQSU5HX0NNRCkgIT0g
MCk7DQo+ICAgDQo+IEBAIC0xMzIsNyArMTQxLDcgQEAgc3RhdGljIGludCB0ZXN0X2Zvb19iYXIo
dm9pZCkNCj4gICAJCWdvdG8gZXJyOw0KPiAgIAl9DQo+ICAgDQo+IC0JcHJpbnRmKCJBdHRhY2hl
ZCBQQVNTIGZyb20gL2Zvby9iYXIgYW5kIGRldGFjaGVkIERST1AgZnJvbSAvZm9vLlxuIg0KPiAr
CWRlYnVnKCJBdHRhY2hlZCBQQVNTIGZyb20gL2Zvby9iYXIgYW5kIGRldGFjaGVkIERST1AgZnJv
bSAvZm9vLlxuIg0KPiAgIAkgICAgICAgIlRoaXMgcGluZyBpbiBjZ3JvdXAgL2Zvby9iYXIgc2hv
dWxkIHBhc3MuLi5cbiIpOw0KPiAgIAlhc3NlcnQoc3lzdGVtKFBJTkdfQ01EKSA9PSAwKTsNCj4g
ICANCj4gQEAgLTE5OSw5ICsyMDgsOSBAQCBzdGF0aWMgaW50IHRlc3RfZm9vX2Jhcih2b2lkKQ0K
PiAgIAljbG9zZShiYXIpOw0KPiAgIAljbGVhbnVwX2Nncm91cF9lbnZpcm9ubWVudCgpOw0KPiAg
IAlpZiAoIXJjKQ0KPiAtCQlwcmludGYoIiMjIyBvdmVycmlkZTpQQVNTXG4iKTsNCj4gKwkJcHJp
bnRmKCIjb3ZlcnJpZGU6UEFTU1xuIik7DQo+ICAgCWVsc2UNCj4gLQkJcHJpbnRmKCIjIyMgb3Zl
cnJpZGU6RkFJTFxuIik7DQo+ICsJCXByaW50ZigiI292ZXJyaWRlOkZBSUxcbiIpOw0KPiAgIAly
ZXR1cm4gcmM7DQo+ICAgfQ0KPiAgIA0KPiBAQCAtNDQxLDE5ICs0NTAsMjYgQEAgc3RhdGljIGlu
dCB0ZXN0X211bHRpcHJvZyh2b2lkKQ0KPiAgIAljbG9zZShjZzUpOw0KPiAgIAljbGVhbnVwX2Nn
cm91cF9lbnZpcm9ubWVudCgpOw0KPiAgIAlpZiAoIXJjKQ0KPiAtCQlwcmludGYoIiMjIyBtdWx0
aTpQQVNTXG4iKTsNCj4gKwkJcHJpbnRmKCIjbXVsdGk6UEFTU1xuIik7DQo+ICAgCWVsc2UNCj4g
LQkJcHJpbnRmKCIjIyMgbXVsdGk6RkFJTFxuIik7DQo+ICsJCXByaW50ZigiI211bHRpOkZBSUxc
biIpOw0KPiAgIAlyZXR1cm4gcmM7DQo+ICAgfQ0KPiAgIA0KPiAgIGludCBtYWluKGludCBhcmdj
LCBjaGFyICoqYXJndikNCg0KYXJnYyBhbmQgYXJndiBhcmUgbm90IHVzZWQuDQoNCmN1cnJlbnRs
eSwgdGhlIGRlYnVnIG91dHB1dCBpcyBjb250cm9sbGVkIGJ5IG1hY3JvIERFQlVHLg0KeW91IGNv
dWxkIGVuYWJsZSBkZWJ1ZyBvdXRwdXQgd2l0aCBjb21tYW5kIGxpbmUgb3B0aW9uLg0KQnV0IEkg
YW0gb2theSB3aXRoIHRoZSBjdXJyZW50IG1lY2hhbmlzbSBhcyB3ZWxsLg0KDQo+ICAgew0KPiAt
CWludCByYyA9IDA7DQo+ICsJaW50ICgqdGVzdHNbXSkodm9pZCkgPSB7dGVzdF9mb29fYmFyLCB0
ZXN0X211bHRpcHJvZ307DQo+ICsJaW50IGVycm9ycyA9IDA7DQo+ICsJaW50IGk7DQo+ICAgDQo+
IC0JcmMgPSB0ZXN0X2Zvb19iYXIoKTsNCj4gLQlpZiAocmMpDQo+IC0JCXJldHVybiByYzsNCj4g
Kwlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRSh0ZXN0cyk7IGkrKykNCj4gKwkJaWYgKHRlc3Rz
W2ldKCkpDQo+ICsJCQllcnJvcnMrKzsNCj4gKw0KPiArCWlmIChlcnJvcnMpDQo+ICsJCXByaW50
ZigidGVzdF9jZ3JvdXBfYXR0YWNoOkZBSUxcbiIpOw0KPiArCWVsc2UNCj4gKwkJcHJpbnRmKCJ0
ZXN0X2Nncm91cF9hdHRhY2g6UEFTU1xuIik7DQo+ICAgDQo+IC0JcmV0dXJuIHRlc3RfbXVsdGlw
cm9nKCk7DQo+ICsJcmV0dXJuIGVycm9ycyA/IEVYSVRfRkFJTFVSRSA6IEVYSVRfU1VDQ0VTUzsN
Cj4gICB9DQo+IA0K
