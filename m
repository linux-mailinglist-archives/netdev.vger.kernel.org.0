Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35F467D0CC
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbfGaWSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:18:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727403AbfGaWR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:17:59 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6VM3Yhl020638;
        Wed, 31 Jul 2019 15:17:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kHFB838Na2dO11BhrgE5bpyq4jqfSakvcSv1lSOZpV4=;
 b=AXdE5muYIF1L/ddxCsPnwc1+E+1t3dREWMWlu6ImBOAYJlVyCll4rZy0tam67gmmppmW
 xITX6w70VFKhYDjPhSyCWDPJ+w+hqID44dN+xoKr+j3Mew/L9j3duMLj3sMYXP6N13kq
 vG0QA4y6jSnCyVDmmMlZZlj1vlSRHhTSoxI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2u3d1mhkje-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 31 Jul 2019 15:17:38 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 31 Jul 2019 15:17:38 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 31 Jul 2019 15:17:37 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 31 Jul 2019 15:17:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOLwecg2CDnafJ0U+Cw4MU3HSREmMYQCfTRA77590ZXhr34y2lKqE38n0b9XaCeD6aaCqKcaUJDVDDvhnKzusN9a4XYptFFvIjQ6JJjTmEkaTSAOehV2K33wk6oyXfx1IP1TcujpvmoD3Z/GGfSA1Hy4QTECOAsJLBPOpOCPKGm9jES75fHk3dEDba5ypEpYXDkHDPYqXuCR/ZxT9oUQDt5T7Ilkkcw7zqiyzNVXB19tzndKmMBxI82ZfKYJQvoKGQSUjdUsMBHvcLaERJdvcSGOMkO7Z+uwxKE780KSoHd0Coh2B+zLmGj73FA31Ks/8WMDcK0VDOkKRPu04L+Q5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHFB838Na2dO11BhrgE5bpyq4jqfSakvcSv1lSOZpV4=;
 b=Ltip1SFroqLbAuXkjnx+yIKV3wUpbnGpn6iVlngo1PY7jpL6pCl8T3eMwAc8J3uV3/OTbS2N0sNsI1+olFsaP86Zo6X8K4sLprTyDZcKVLNbGFzSyhUwCSB2RErwxaimG+xXTiqEJPMeVX69P4PDGEZFTICbydUkJkOeUEYTIMsb2zMqX+6MiyH+szCxsEisGYm/S82WG55zmFYW5LdreUeyhe9jXdbKyEz7hkE2RJ52E+FygKH0oN2YoJ3NN99iCaeR4k6ssM72pEH5FUATPnyaI1iQ5OrW3XJI2ZCoO7ivAYhrjPvfGX/CryskHqZ+oCa6Qv54vb/IsMXmy4mhMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHFB838Na2dO11BhrgE5bpyq4jqfSakvcSv1lSOZpV4=;
 b=CiA3MWfs7xmDjJwYiWUMTEC1Ag1YM/EmZOb1whSxd4L13IaMceH3akV2wwnyzLN2DhO/oa4nfOy4GGSw6fx7ifeQUfhUgPbamnNHVSx7/6KxeewTb7cazcOqWXJnc+Kl/aKU/kMMUv7iuejKv4iZpPBJi9bWUL303AnbbHKggfY=
Received: from CY4PR15MB1366.namprd15.prod.outlook.com (10.172.157.148) by
 CY4PR15MB1861.namprd15.prod.outlook.com (10.174.54.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.12; Wed, 31 Jul 2019 22:17:35 +0000
Received: from CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::6c5f:cfef:6a46:d2f1]) by CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::6c5f:cfef:6a46:d2f1%9]) with mapi id 15.20.2136.010; Wed, 31 Jul 2019
 22:17:35 +0000
From:   Andrey Ignatov <rdna@fb.com>
To:     Takshak Chahande <ctakshak@fb.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>, Hechao Li <hechaol@fb.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [Potential Spoof] [PATCH bpf v2] libbpf : make
 libbpf_num_possible_cpus function thread safe
Thread-Topic: [Potential Spoof] [PATCH bpf v2] libbpf : make
 libbpf_num_possible_cpus function thread safe
Thread-Index: AQHVR+zgj7H+8QxatUSl9xns8RuqyqblS6aA
Date:   Wed, 31 Jul 2019 22:17:35 +0000
Message-ID: <20190731221733.GB21873@rdna-mbp>
References: <20190731221055.1478201-1-ctakshak@fb.com>
In-Reply-To: <20190731221055.1478201-1-ctakshak@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:300:16::32) To CY4PR15MB1366.namprd15.prod.outlook.com
 (2603:10b6:903:f7::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:d011]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c09c486-de93-430c-7ddf-08d71604e398
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1861;
x-ms-traffictypediagnostic: CY4PR15MB1861:
x-microsoft-antispam-prvs: <CY4PR15MB18616E9D6B5FACB3E5C35A9CA8DF0@CY4PR15MB1861.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:208;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(376002)(366004)(39860400002)(346002)(136003)(189003)(199004)(6116002)(33656002)(33716001)(7736002)(6246003)(229853002)(305945005)(6636002)(68736007)(14444005)(478600001)(256004)(71190400001)(1076003)(14454004)(2906002)(4326008)(46003)(6506007)(486006)(476003)(11346002)(5660300002)(8936002)(446003)(186003)(66556008)(9686003)(8676002)(6436002)(6862004)(386003)(66446008)(52116002)(66946007)(64756008)(6512007)(53936002)(102836004)(25786009)(66476007)(99286004)(316002)(54906003)(6486002)(81156014)(86362001)(76176011)(81166006)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1861;H:CY4PR15MB1366.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Lg14ei2d1C8JrBSAK48L/0iAXl31ufYPWYXqRE5J5Td8/MsVcnPVAX4W+YUZJA//SAjigsjTSDNAALpu8c3+RhjAc2lWazYwwkAYfYeGcMVTB1BZamMRyNsWthKBwWOGoeK9A0bYhnRPMzmpG9WkecAMnR5bcOV9jULONQwQZhi2Hk8jOu/s8/BIoZePIV2319+me7k9nldQn0eM1CuK3zc6a9pyuu0K3R1qAR1mk/ebrUT3MbZ263AK2iXHml7HPHxrHyZG0dABZmDVKKTKxWkxxwNdhW+CHfMNFqKRwGMGpk++xz9l9iCcx/5fXXxsrvDXjVh/vGZLrzPQ0i4KKgthYKQ7L1FGrCBbMY2jUrhUmqHoShJy26ees/dL8ekMt1K2aCJym3TaSwgRm+28CA/pRwwgJI27xJlH4e7Ssv0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95279160DAADAE4EA94D295C6CE3EA21@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c09c486-de93-430c-7ddf-08d71604e398
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 22:17:35.2165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rdna@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1861
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310221
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGFrc2hhayBDaGFoYW5kZSA8Y3Rha3NoYWtAZmIuY29tPiBbV2VkLCAyMDE5LTA3LTMxIDE1OjEx
IC0wNzAwXToNCj4gSGF2aW5nIHN0YXRpYyB2YXJpYWJsZSBgY3B1c2AgaW4gbGliYnBmX251bV9w
b3NzaWJsZV9jcHVzIGZ1bmN0aW9uDQo+IHdpdGhvdXQgZ3VhcmRpbmcgaXQgd2l0aCBtdXRleCBt
YWtlcyB0aGlzIGZ1bmN0aW9uIHRocmVhZC11bnNhZmUuDQo+IA0KPiBJZiBtdWx0aXBsZSB0aHJl
YWRzIGFjY2Vzc2luZyB0aGlzIGZ1bmN0aW9uLCBpbiB0aGUgY3VycmVudCBmb3JtOyBpdA0KPiBs
ZWFkcyB0byBpbmNyZW1lbnRpbmcgdGhlIHN0YXRpYyB2YXJpYWJsZSB2YWx1ZSBgY3B1c2AgaW4g
dGhlIG11bHRpcGxlDQo+IG9mIHRvdGFsIGF2YWlsYWJsZSBDUFVzLg0KPiANCj4gVXNlZCBsb2Nh
bCBzdGFjayB2YXJpYWJsZSB0byBjYWxjdWxhdGUgdGhlIG51bWJlciBvZiBwb3NzaWJsZSBDUFVz
IGFuZA0KPiB0aGVuIHVwZGF0ZWQgdGhlIHN0YXRpYyB2YXJpYWJsZSB1c2luZyBXUklURV9PTkNF
KCkuDQo+IA0KPiBDaGFuZ2VzIHNpbmNlIHYxOg0KPiAgKiBhZGRlZCBzdGFjayB2YXJpYWJsZSB0
byBjYWxjdWxhdGUgY3B1cw0KPiAgKiBzZXJpYWxpemVkIHN0YXRpYyB2YXJpYWJsZSB1cGRhdGUg
dXNpbmcgV1JJVEVfT05DRSgpDQo+ICAqIGZpeGVkIEZpeGVzIHRhZw0KDQpUaGlzICJDaGFuZ2Vz
IiBzZWN0aW9uIHNob3VsZCBiZSBhZnRlciAiLS0tIiBsaW5lIG5vdCB0byBiZSBpbmNsdWRlZCBp
bg0KdGhlIGZpbmFsIGNvbW1pdCBtZXNzYWdlLg0KDQpOb3Qgc3VyZSBpZiByZXN1Ym1pdCBpcyBu
ZWVkZWQgYmVjYXVzZSBvZiBpdCwgYnV0IG90aGVyIHRoYW4gdGhpcyBsb29rcw0KZ29vZCB0byBt
ZS4NCg0KQWNrZWQtYnk6IEFuZHJleSBJZ25hdG92IDxyZG5hQGZiLmNvbT4NCg0KDQo+IEZpeGVz
OiA2NDQ2YjMxNTU1MjEgKCJicGY6IGFkZCBhIG5ldyBBUEkgbGliYnBmX251bV9wb3NzaWJsZV9j
cHVzKCkiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBUYWtzaGFrIENoYWhhbmRlIDxjdGFrc2hha0BmYi5j
b20+DQo+IC0tLQ0KPiAgdG9vbHMvbGliL2JwZi9saWJicGYuYyB8IDE4ICsrKysrKysrKysrLS0t
LS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9saWJicGYuYyBiL3Rvb2xzL2xpYi9i
cGYvbGliYnBmLmMNCj4gaW5kZXggNjcxOGQwYjkwMTMwLi4yZTg0ZmE1Yjg0NzkgMTAwNjQ0DQo+
IC0tLSBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJi
cGYuYw0KPiBAQCAtNDk5NSwxMyArNDk5NSwxNSBAQCBpbnQgbGliYnBmX251bV9wb3NzaWJsZV9j
cHVzKHZvaWQpDQo+ICAJc3RhdGljIGNvbnN0IGNoYXIgKmZjcHUgPSAiL3N5cy9kZXZpY2VzL3N5
c3RlbS9jcHUvcG9zc2libGUiOw0KPiAgCWludCBsZW4gPSAwLCBuID0gMCwgaWwgPSAwLCBpciA9
IDA7DQo+ICAJdW5zaWduZWQgaW50IHN0YXJ0ID0gMCwgZW5kID0gMDsNCj4gKwlpbnQgdG1wX2Nw
dXMgPSAwOw0KPiAgCXN0YXRpYyBpbnQgY3B1czsNCj4gIAljaGFyIGJ1ZlsxMjhdOw0KPiAgCWlu
dCBlcnJvciA9IDA7DQo+ICAJaW50IGZkID0gLTE7DQo+ICANCj4gLQlpZiAoY3B1cyA+IDApDQo+
IC0JCXJldHVybiBjcHVzOw0KPiArCXRtcF9jcHVzID0gUkVBRF9PTkNFKGNwdXMpOw0KPiArCWlm
ICh0bXBfY3B1cyA+IDApDQo+ICsJCXJldHVybiB0bXBfY3B1czsNCj4gIA0KPiAgCWZkID0gb3Bl
bihmY3B1LCBPX1JET05MWSk7DQo+ICAJaWYgKGZkIDwgMCkgew0KPiBAQCAtNTAyNCw3ICs1MDI2
LDcgQEAgaW50IGxpYmJwZl9udW1fcG9zc2libGVfY3B1cyh2b2lkKQ0KPiAgCX0NCj4gIAlidWZb
bGVuXSA9ICdcMCc7DQo+ICANCj4gLQlmb3IgKGlyID0gMCwgY3B1cyA9IDA7IGlyIDw9IGxlbjsg
aXIrKykgew0KPiArCWZvciAoaXIgPSAwLCB0bXBfY3B1cyA9IDA7IGlyIDw9IGxlbjsgaXIrKykg
ew0KPiAgCQkvKiBFYWNoIHN1YiBzdHJpbmcgc2VwYXJhdGVkIGJ5ICcsJyBoYXMgZm9ybWF0IFxk
Ky1cZCsgb3IgXGQrICovDQo+ICAJCWlmIChidWZbaXJdID09ICcsJyB8fCBidWZbaXJdID09ICdc
MCcpIHsNCj4gIAkJCWJ1Zltpcl0gPSAnXDAnOw0KPiBAQCAtNTAzNiwxMyArNTAzOCwxNSBAQCBp
bnQgbGliYnBmX251bV9wb3NzaWJsZV9jcHVzKHZvaWQpDQo+ICAJCQl9IGVsc2UgaWYgKG4gPT0g
MSkgew0KPiAgCQkJCWVuZCA9IHN0YXJ0Ow0KPiAgCQkJfQ0KPiAtCQkJY3B1cyArPSBlbmQgLSBz
dGFydCArIDE7DQo+ICsJCQl0bXBfY3B1cyArPSBlbmQgLSBzdGFydCArIDE7DQo+ICAJCQlpbCA9
IGlyICsgMTsNCj4gIAkJfQ0KPiAgCX0NCj4gLQlpZiAoY3B1cyA8PSAwKSB7DQo+IC0JCXByX3dh
cm5pbmcoIkludmFsaWQgI0NQVXMgJWQgZnJvbSAlc1xuIiwgY3B1cywgZmNwdSk7DQo+ICsJaWYg
KHRtcF9jcHVzIDw9IDApIHsNCj4gKwkJcHJfd2FybmluZygiSW52YWxpZCAjQ1BVcyAlZCBmcm9t
ICVzXG4iLCB0bXBfY3B1cywgZmNwdSk7DQo+ICAJCXJldHVybiAtRUlOVkFMOw0KPiAgCX0NCj4g
LQlyZXR1cm4gY3B1czsNCj4gKw0KPiArCVdSSVRFX09OQ0UoY3B1cywgdG1wX2NwdXMpOw0KPiAr
CXJldHVybiB0bXBfY3B1czsNCj4gIH0NCj4gLS0gDQo+IDIuMTcuMQ0KPiANCg0KLS0gDQpBbmRy
ZXkgSWduYXRvdg0K
