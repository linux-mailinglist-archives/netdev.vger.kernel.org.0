Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4FA5C5D0
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 01:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfGAXCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 19:02:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27198 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726362AbfGAXCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 19:02:42 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61N2L0b021328;
        Mon, 1 Jul 2019 16:02:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3wZHwOJX7quaesvn03e1knly+SlTK4xedajt9ZgEftI=;
 b=nDWAiVatD2YbRXCRN32pDat8ZleS1dzVIHtEINHTzz0yUmmwJAGc6RSnSb7o75FOdJj1
 U5wy0WyIEydp9jSmtOPumAGskF2luPVnC1yRYh74vUaD+nuc1PwD6bN9l2kRLnExecUS
 joHSFEcbIz+uvVp2e/jCnE+TkmDWZbHLEjs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2tfgpm2f4f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 16:02:21 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 1 Jul 2019 16:02:18 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 16:02:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=wz0VhcxU3K9h9+mzEqgSbmujbOUKnp7fU8cuRe1tfPYS1zDzurtI8Lh36M85Em8Xq7e/5J1xF85uJeD+pUecCO+S/MflOqDHvIcUY/JqkvB829DjbKKnn3MZcsCChUwmu+iT6Ps2Eswp6tfZGJRH3C6IHRke0SS9CBCV5eKNJDU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wZHwOJX7quaesvn03e1knly+SlTK4xedajt9ZgEftI=;
 b=vVMmC5osTUI8M+fduJDkfVve319DdCqvHBsXEQCb9jiH2tKCCzwMc9KI5wq/F3J7AReKGtzVFKICwlk8klcLNwecyjeFoKTDSU5mv772xPJ9a9bqvo2O9bMlVFW2GWeVcxmrXsWNjoTL+wu0U07/tFCdniwcIZ65kWtbicW0KZk=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wZHwOJX7quaesvn03e1knly+SlTK4xedajt9ZgEftI=;
 b=pBIWQQ86lpuOYQ5hrtS6RyHbf7ZJUka64rXTOLUTgHsrWHdke2mlxwWab7zY6tZwHaYO+zAFsTNquXFoiO7oqRT4yp4Ef2tV/wcxTI0b3k0TqeORdXUZvjfppLH/ki4a5HNqulanFe602PCSgJ0ATyoR6KfERaPbdS8snSi0FYA=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2375.namprd15.prod.outlook.com (52.135.198.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 1 Jul 2019 23:02:10 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 23:02:10 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "sdf@fomichev.me" <sdf@fomichev.me>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4 bpf-next 3/9] libbpf: add ability to attach/detach BPF
 program to perf event
Thread-Topic: [PATCH v4 bpf-next 3/9] libbpf: add ability to attach/detach BPF
 program to perf event
Thread-Index: AQHVLi27vd5KKY/MU06fUnGqfnehB6a2AYKAgABSN4CAABHugA==
Date:   Mon, 1 Jul 2019 23:02:10 +0000
Message-ID: <c964a5ea-b672-368b-8aa9-e8d6afe15bc9@fb.com>
References: <20190629034906.1209916-1-andriin@fb.com>
 <20190629034906.1209916-4-andriin@fb.com>
 <964c51ff-2b83-98e8-4b20-aaa7336a5536@fb.com>
 <CAEf4Bzbz+bnM2E8aGP-eWtqDBepQ0Rc_KU-n+FQHnOrnFAWKwg@mail.gmail.com>
In-Reply-To: <CAEf4Bzbz+bnM2E8aGP-eWtqDBepQ0Rc_KU-n+FQHnOrnFAWKwg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::37) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:fe3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d84f0026-3cbc-49a9-8805-08d6fe7825a8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2375;
x-ms-traffictypediagnostic: BYAPR15MB2375:
x-microsoft-antispam-prvs: <BYAPR15MB23757EF382EB101480A12947D3F90@BYAPR15MB2375.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:50;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(366004)(396003)(376002)(346002)(52314003)(189003)(199004)(68736007)(5660300002)(14454004)(2906002)(6246003)(478600001)(486006)(6916009)(305945005)(6436002)(31686004)(31696002)(6486002)(7736002)(71190400001)(81166006)(229853002)(71200400001)(186003)(46003)(76176011)(52116002)(81156014)(8676002)(2616005)(8936002)(86362001)(6116002)(102836004)(6506007)(386003)(53546011)(4326008)(73956011)(11346002)(5024004)(446003)(256004)(476003)(14444005)(99286004)(6512007)(36756003)(66946007)(54906003)(53936002)(66446008)(64756008)(66556008)(66476007)(316002)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2375;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3+h2z7jsWQIHlkefMnxBTl5U34KeJsXUVuxMyfJNPrc86ulRVMEX6TO+am0NhwSMpLl2vDZrKrJOQ/2YpIFtcfKX62hsahjPxxKNy9c1zKlz/+4Nl/Fxh/ZLmHxsseTzKKe47NoQwmvYCTN8+8o6p2JOoQapae7ZnpyQyHbaTLCLE4Zhpf9cVynt74AlhfnFjR0+G4HNfYlAXPDGMalIWm4IywprLY2C8SROuqu2o+K3OuRQdS0B7WysJFJj0dRLk2kTCFtQUnK454UCAWYGqvNpYUQuw0OEVTJqPAlLXesWlFPmcrbF5rVN+lcHBuai8iLnhQ8rzEkRO8LyQnYMFVWOrXdFwFTG/V2oPJjTGngOfVesvgQJVtswk1J7ibZDET2vZjlg77lHLwRD2PCvIVChSIv8StaR/Xue0YPd79Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBB3B98AA2E9834D8B7D158CEDC09729@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d84f0026-3cbc-49a9-8805-08d6fe7825a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 23:02:10.4564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2375
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010267
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMS8xOSAyOjU3IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IE9uIE1vbiwg
SnVsIDEsIDIwMTkgYXQgMTA6MDMgQU0gWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gd3JvdGU6
DQo+Pg0KPj4NCj4+DQo+PiBPbiA2LzI4LzE5IDg6NDkgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90
ZToNCj4+PiBicGZfcHJvZ3JhbV9fYXR0YWNoX3BlcmZfZXZlbnQgYWxsb3dzIHRvIGF0dGFjaCBC
UEYgcHJvZ3JhbSB0byBleGlzdGluZw0KPj4+IHBlcmYgZXZlbnQgaG9vaywgcHJvdmlkaW5nIG1v
c3QgZ2VuZXJpYyBhbmQgbW9zdCBsb3ctbGV2ZWwgd2F5IHRvIGF0dGFjaCBCUEYNCj4+PiBwcm9n
cmFtcy4gSXQgcmV0dXJucyBzdHJ1Y3QgYnBmX2xpbmssIHdoaWNoIHNob3VsZCBiZSBwYXNzZWQg
dG8NCj4+PiBicGZfbGlua19fZGVzdHJveSB0byBkZXRhY2ggYW5kIGZyZWUgcmVzb3VyY2VzLCBh
c3NvY2lhdGVkIHdpdGggYSBsaW5rLg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5h
a3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCj4+PiAtLS0NCj4+PiAgICB0b29scy9saWIvYnBmL2xp
YmJwZi5jICAgfCA2MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+
Pj4gICAgdG9vbHMvbGliL2JwZi9saWJicGYuaCAgIHwgIDMgKysNCj4+PiAgICB0b29scy9saWIv
YnBmL2xpYmJwZi5tYXAgfCAgMSArDQo+Pj4gICAgMyBmaWxlcyBjaGFuZ2VkLCA2NSBpbnNlcnRp
b25zKCspDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9saWJicGYuYyBiL3Rv
b2xzL2xpYi9icGYvbGliYnBmLmMNCj4+PiBpbmRleCA0NTU3OTVlNmY4YWYuLjk4YzE1NWVjM2Jm
YSAxMDA2NDQNCj4+PiAtLS0gYS90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+Pj4gKysrIGIvdG9v
bHMvbGliL2JwZi9saWJicGYuYw0KPj4+IEBAIC0zMiw2ICszMiw3IEBADQo+Pj4gICAgI2luY2x1
ZGUgPGxpbnV4L2xpbWl0cy5oPg0KPj4+ICAgICNpbmNsdWRlIDxsaW51eC9wZXJmX2V2ZW50Lmg+
DQo+Pj4gICAgI2luY2x1ZGUgPGxpbnV4L3JpbmdfYnVmZmVyLmg+DQo+Pj4gKyNpbmNsdWRlIDxz
eXMvaW9jdGwuaD4NCj4+PiAgICAjaW5jbHVkZSA8c3lzL3N0YXQuaD4NCj4+PiAgICAjaW5jbHVk
ZSA8c3lzL3R5cGVzLmg+DQo+Pj4gICAgI2luY2x1ZGUgPHN5cy92ZnMuaD4NCj4+PiBAQCAtMzk1
OCw2ICszOTU5LDY2IEBAIGludCBicGZfbGlua19fZGVzdHJveShzdHJ1Y3QgYnBmX2xpbmsgKmxp
bmspDQo+Pj4gICAgICAgIHJldHVybiBlcnI7DQo+Pj4gICAgfQ0KPj4+DQo+Pj4gK3N0cnVjdCBi
cGZfbGlua19mZCB7DQo+Pj4gKyAgICAgc3RydWN0IGJwZl9saW5rIGxpbms7IC8qIGhhcyB0byBi
ZSBhdCB0aGUgdG9wIG9mIHN0cnVjdCAqLw0KPj4+ICsgICAgIGludCBmZDsgLyogaG9vayBGRCAq
Lw0KPj4+ICt9Ow0KPj4+ICsNCj4+PiArc3RhdGljIGludCBicGZfbGlua19fZGVzdHJveV9wZXJm
X2V2ZW50KHN0cnVjdCBicGZfbGluayAqbGluaykNCj4+PiArew0KPj4+ICsgICAgIHN0cnVjdCBi
cGZfbGlua19mZCAqbCA9ICh2b2lkICopbGluazsNCj4+PiArICAgICBpbnQgZXJyOw0KPj4+ICsN
Cj4+PiArICAgICBpZiAobC0+ZmQgPCAwKQ0KPj4+ICsgICAgICAgICAgICAgcmV0dXJuIDA7DQo+
Pj4gKw0KPj4+ICsgICAgIGVyciA9IGlvY3RsKGwtPmZkLCBQRVJGX0VWRU5UX0lPQ19ESVNBQkxF
LCAwKTsNCj4+PiArICAgICBpZiAoZXJyKQ0KPj4+ICsgICAgICAgICAgICAgZXJyID0gLWVycm5v
Ow0KPj4+ICsNCj4+PiArICAgICBjbG9zZShsLT5mZCk7DQo+Pj4gKyAgICAgcmV0dXJuIGVycjsN
Cj4+PiArfQ0KPj4+ICsNCj4+PiArc3RydWN0IGJwZl9saW5rICpicGZfcHJvZ3JhbV9fYXR0YWNo
X3BlcmZfZXZlbnQoc3RydWN0IGJwZl9wcm9ncmFtICpwcm9nLA0KPj4+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnQgcGZkKQ0KPj4+ICt7DQo+Pj4gKyAg
ICAgY2hhciBlcnJtc2dbU1RSRVJSX0JVRlNJWkVdOw0KPj4+ICsgICAgIHN0cnVjdCBicGZfbGlu
a19mZCAqbGluazsNCj4+PiArICAgICBpbnQgcHJvZ19mZCwgZXJyOw0KPj4+ICsNCj4+PiArICAg
ICBwcm9nX2ZkID0gYnBmX3Byb2dyYW1fX2ZkKHByb2cpOw0KPj4+ICsgICAgIGlmIChwcm9nX2Zk
IDwgMCkgew0KPj4+ICsgICAgICAgICAgICAgcHJfd2FybmluZygicHJvZ3JhbSAnJXMnOiBjYW4n
dCBhdHRhY2ggYmVmb3JlIGxvYWRlZFxuIiwNCj4+PiArICAgICAgICAgICAgICAgICAgICAgICAg
YnBmX3Byb2dyYW1fX3RpdGxlKHByb2csIGZhbHNlKSk7DQo+Pj4gKyAgICAgICAgICAgICByZXR1
cm4gRVJSX1BUUigtRUlOVkFMKTsNCj4+PiArICAgICB9DQo+Pg0KPj4gc2hvdWxkIHdlIGNoZWNr
IHZhbGlkaXR5IG9mIHBmZCBoZXJlPw0KPj4gSWYgcGZkIDwgMCwgd2UganVzdCByZXR1cm4gRVJS
X1BUUigtRUlOVkFMKT8NCj4gDQo+IEkgY2FuIGFkZCB0aGF0LiBJIGRpZG4ndCBkbyBpdCwgYmVj
YXVzZSBpbiBnZW5lcmFsLCB5b3UgY2FuIHByb3ZpZGUgZmQNCj4+ID0gMCB3aGljaCBpcyBzdGls
bCBub3QgYSB2YWxpZCBGRCBmb3IgUEVSRl9FVkVOVF9JT0NfU0VUX0JQRiBhbmQNCj4gUEVSRl9F
VkVOVF9JT0NfRU5BQkxFLCBzbyBpbiBnZW5lcmFsIHdlIGNhbid0IGRldGVjdCB0aGlzIHJlbGlh
Ymx5Lg0KDQpJIGp1c3Qgd2FudCBhIGNoZWNrIGZvciB2YWxpZGl0eSBvZiBpbnB1dCBwYXJhbWV0
ZXIgd2hpY2ggd2lsbCBmYWlsdXJlIA0KbGF0ZXIgd2l0aCBkZWRpY2F0ZWQgZXJyb3IgbWVzc2Fn
ZS4gQnV0IHRoZSBzYW1lIG5lZ2F0aXZlIHBmZCB3aWxsDQpiZSBwcmludGVkIGluIGlvY3RsIGVy
cm9yIG1lc3NhZ2UuIEkgYW0gb2theSB3aXRoIHRoaXMuDQoNCj4gDQo+PiBUaGlzIHdheSwgaW4g
YnBmX2xpbmtfX2Rlc3Ryb3lfcGVyZl9ldmVudCgpLCB3ZSBkbyBub3QgbmVlZCB0byBjaGVjaw0K
Pj4gbC0+ZmQgPCAwIHNpbmNlIGl0IHdpbGwgYmUgYWx3YXlzIG5vbm5lZ2F0aXZlLg0KPiANCj4g
VGhhdCBjaGVjayBpcyBub3QgbmVlZGVkIGFueXdheSwgYmVjYXVzZSBldmVuIGlmIHBmZCA8IDAs
IGlvY3RsIHNob3VsZA0KPiBmYWlsIGFuZCByZXR1cm4gZXJyb3IuIEknbGwgcmVtb3ZlIHRoYXQg
Y2hlY2suDQo+IA0KPj4NCj4+PiArDQo+Pj4gKyAgICAgbGluayA9IG1hbGxvYyhzaXplb2YoKmxp
bmspKTsNCj4+PiArICAgICBpZiAoIWxpbmspDQo+Pj4gKyAgICAgICAgICAgICByZXR1cm4gRVJS
X1BUUigtRU5PTUVNKTsNCj4+PiArICAgICBsaW5rLT5saW5rLmRlc3Ryb3kgPSAmYnBmX2xpbmtf
X2Rlc3Ryb3lfcGVyZl9ldmVudDsNCj4+PiArICAgICBsaW5rLT5mZCA9IHBmZDsNCj4+PiArDQo+
Pj4gKyAgICAgaWYgKGlvY3RsKHBmZCwgUEVSRl9FVkVOVF9JT0NfU0VUX0JQRiwgcHJvZ19mZCkg
PCAwKSB7DQo+Pj4gKyAgICAgICAgICAgICBlcnIgPSAtZXJybm87DQo+Pj4gKyAgICAgICAgICAg
ICBmcmVlKGxpbmspOw0KPj4+ICsgICAgICAgICAgICAgcHJfd2FybmluZygicHJvZ3JhbSAnJXMn
OiBmYWlsZWQgdG8gYXR0YWNoIHRvIHBmZCAlZDogJXNcbiIsDQo+Pj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgIGJwZl9wcm9ncmFtX190aXRsZShwcm9nLCBmYWxzZSksIHBmZCwNCj4+PiArICAg
ICAgICAgICAgICAgICAgICAgICAgbGliYnBmX3N0cmVycm9yX3IoZXJyLCBlcnJtc2csIHNpemVv
ZihlcnJtc2cpKSk7DQo+Pj4gKyAgICAgICAgICAgICByZXR1cm4gRVJSX1BUUihlcnIpOw0KPj4+
ICsgICAgIH0NCj4+PiArICAgICBpZiAoaW9jdGwocGZkLCBQRVJGX0VWRU5UX0lPQ19FTkFCTEUs
IDApIDwgMCkgew0KPj4+ICsgICAgICAgICAgICAgZXJyID0gLWVycm5vOw0KPj4+ICsgICAgICAg
ICAgICAgZnJlZShsaW5rKTsNCj4+PiArICAgICAgICAgICAgIHByX3dhcm5pbmcoInByb2dyYW0g
JyVzJzogZmFpbGVkIHRvIGVuYWJsZSBwZmQgJWQ6ICVzXG4iLA0KPj4+ICsgICAgICAgICAgICAg
ICAgICAgICAgICBicGZfcHJvZ3JhbV9fdGl0bGUocHJvZywgZmFsc2UpLCBwZmQsDQo+Pj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgIGxpYmJwZl9zdHJlcnJvcl9yKGVyciwgZXJybXNnLCBzaXpl
b2YoZXJybXNnKSkpOw0KPj4+ICsgICAgICAgICAgICAgcmV0dXJuIEVSUl9QVFIoZXJyKTsNCj4+
PiArICAgICB9DQo+Pj4gKyAgICAgcmV0dXJuIChzdHJ1Y3QgYnBmX2xpbmsgKilsaW5rOw0KPj4+
ICt9DQo+Pj4gKw0KPj4+ICAgIGVudW0gYnBmX3BlcmZfZXZlbnRfcmV0DQo+Pj4gICAgYnBmX3Bl
cmZfZXZlbnRfcmVhZF9zaW1wbGUodm9pZCAqbW1hcF9tZW0sIHNpemVfdCBtbWFwX3NpemUsIHNp
emVfdCBwYWdlX3NpemUsDQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICB2b2lkICoqY29w
eV9tZW0sIHNpemVfdCAqY29weV9zaXplLA0KPj4+IGRpZmYgLS1naXQgYS90b29scy9saWIvYnBm
L2xpYmJwZi5oIGIvdG9vbHMvbGliL2JwZi9saWJicGYuaA0KPj4+IGluZGV4IDUwODJhNWViYjBj
Mi4uMWJmNjZjNGE5MzMwIDEwMDY0NA0KPj4+IC0tLSBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLmgN
Cj4+PiArKysgYi90b29scy9saWIvYnBmL2xpYmJwZi5oDQo+Pj4gQEAgLTE2OSw2ICsxNjksOSBA
QCBzdHJ1Y3QgYnBmX2xpbms7DQo+Pj4NCj4+PiAgICBMSUJCUEZfQVBJIGludCBicGZfbGlua19f
ZGVzdHJveShzdHJ1Y3QgYnBmX2xpbmsgKmxpbmspOw0KPj4+DQo+Pj4gK0xJQkJQRl9BUEkgc3Ry
dWN0IGJwZl9saW5rICoNCj4+PiArYnBmX3Byb2dyYW1fX2F0dGFjaF9wZXJmX2V2ZW50KHN0cnVj
dCBicGZfcHJvZ3JhbSAqcHJvZywgaW50IHBmZCk7DQo+Pj4gKw0KPj4+ICAgIHN0cnVjdCBicGZf
aW5zbjsNCj4+Pg0KPj4+ICAgIC8qDQo+Pj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvbGli
YnBmLm1hcCBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1hcA0KPj4+IGluZGV4IDNjZGU4NTBmYzhk
YS4uNzU2ZjVhYTgwMmU5IDEwMDY0NA0KPj4+IC0tLSBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1h
cA0KPj4+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1hcA0KPj4+IEBAIC0xNjksNiArMTY5
LDcgQEAgTElCQlBGXzAuMC40IHsNCj4+PiAgICAgICAgZ2xvYmFsOg0KPj4+ICAgICAgICAgICAg
ICAgIGJwZl9saW5rX19kZXN0cm95Ow0KPj4+ICAgICAgICAgICAgICAgIGJwZl9vYmplY3RfX2xv
YWRfeGF0dHI7DQo+Pj4gKyAgICAgICAgICAgICBicGZfcHJvZ3JhbV9fYXR0YWNoX3BlcmZfZXZl
bnQ7DQo+Pj4gICAgICAgICAgICAgICAgYnRmX2R1bXBfX2R1bXBfdHlwZTsNCj4+PiAgICAgICAg
ICAgICAgICBidGZfZHVtcF9fZnJlZTsNCj4+PiAgICAgICAgICAgICAgICBidGZfZHVtcF9fbmV3
Ow0KPj4+DQo=
