Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 956C55C1B4
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbfGAREK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:04:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1116 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727578AbfGAREK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:04:10 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61GmiK2025694;
        Mon, 1 Jul 2019 10:03:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=l3KulhhBXpYAzHz32Pno0t0llGYeqCT5N7p7SoUo7Z4=;
 b=JvbFb1BBPUbT73QLCeOrtluMNky5hHjlIiyFw5N1p0vWrweQqQuuod4GN76wJXffpIQM
 fWrm4Lb5pgxU82g2KzPmLukyKSJpXO3meoDKs9H1Mu3sh4m4pUHkb4wdu+H6FpUJuKD4
 vFaUFtbyfmq9CsdV4cuO8ovP1V1m8O3P1+4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tfhqvs3av-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 10:03:47 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 1 Jul 2019 10:03:45 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 1 Jul 2019 10:03:45 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 10:03:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3KulhhBXpYAzHz32Pno0t0llGYeqCT5N7p7SoUo7Z4=;
 b=ClDga9k4lHxzd17C75sU6e2KCe9eBG8KlT/TvnjArjC0DcKwKhIHBj5ZGLFcFzYISzL7IVZphbeOVTqzFi8F+nDD/DoBt4MyO6evOr83goT5EE4b3fv0xWsnKZzXYu7RVse9Fg8gIwPEcltkqwds8Kqgl4rGMBZy10KOlOWo/RM=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2902.namprd15.prod.outlook.com (20.178.206.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Mon, 1 Jul 2019 17:03:43 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 17:03:43 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
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
Thread-Index: AQHVLi27vd5KKY/MU06fUnGqfnehB6a2AYKA
Date:   Mon, 1 Jul 2019 17:03:43 +0000
Message-ID: <964c51ff-2b83-98e8-4b20-aaa7336a5536@fb.com>
References: <20190629034906.1209916-1-andriin@fb.com>
 <20190629034906.1209916-4-andriin@fb.com>
In-Reply-To: <20190629034906.1209916-4-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::40) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:fe3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae538a1f-0304-4f50-b36a-08d6fe4612ae
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2902;
x-ms-traffictypediagnostic: BYAPR15MB2902:
x-microsoft-antispam-prvs: <BYAPR15MB290206BA675F729CF234ADEFD3F90@BYAPR15MB2902.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:64;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39860400002)(346002)(376002)(136003)(199004)(189003)(53936002)(6512007)(6436002)(52116002)(68736007)(386003)(53546011)(102836004)(229853002)(316002)(14454004)(31686004)(5660300002)(305945005)(7736002)(2501003)(76176011)(81156014)(81166006)(8936002)(8676002)(6486002)(476003)(99286004)(446003)(486006)(36756003)(2616005)(2906002)(256004)(11346002)(66446008)(6246003)(86362001)(66556008)(2201001)(14444005)(186003)(6506007)(71190400001)(478600001)(25786009)(46003)(6636002)(5024004)(71200400001)(6116002)(73956011)(110136005)(64756008)(66946007)(66476007)(31696002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2902;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: o7NmOunG4S7fN0YS7ckYd/MLi7EZ1bA80mnbjBDa6uPz4fq9o5KErwiwG/oXqrcEWOyXhmE1jCjkVAcaCSHQvURyAv1fAlC9bn7/U1cHGr/efq++j2IcT17uz+5YXR7mOutPbtzSei7G7qAPPxdGziPJAKOS/4jF09WUZuBDFK4JgLZjHTKY5fLsWOEkIu2I592rtJza5haZm0di7X3n9qJHrFcnkbqpmE1x6zohlGi+aX3LgSz4eHXEDpUIf4G44ezuq173Il4VYJ/9yh2p0l0WEyUGkFdRgzci6Ju+WLWJEdO2ucs4txQ3kgTzf8zb4TTgOdp7YeIpYP6/YXoJBZ6VJ6JbClkSHXtxqGfericZhJCMIjtyqpWZCF22v33EdEvXEa5wOkZgyrVkqa8GcGJnBQer/eVebmZ38eK7ZZ8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <46ED37C56DAE1344846AF3582D41DFA6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ae538a1f-0304-4f50-b36a-08d6fe4612ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 17:03:43.6887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2902
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMjgvMTkgODo0OSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBicGZfcHJv
Z3JhbV9fYXR0YWNoX3BlcmZfZXZlbnQgYWxsb3dzIHRvIGF0dGFjaCBCUEYgcHJvZ3JhbSB0byBl
eGlzdGluZw0KPiBwZXJmIGV2ZW50IGhvb2ssIHByb3ZpZGluZyBtb3N0IGdlbmVyaWMgYW5kIG1v
c3QgbG93LWxldmVsIHdheSB0byBhdHRhY2ggQlBGDQo+IHByb2dyYW1zLiBJdCByZXR1cm5zIHN0
cnVjdCBicGZfbGluaywgd2hpY2ggc2hvdWxkIGJlIHBhc3NlZCB0bw0KPiBicGZfbGlua19fZGVz
dHJveSB0byBkZXRhY2ggYW5kIGZyZWUgcmVzb3VyY2VzLCBhc3NvY2lhdGVkIHdpdGggYSBsaW5r
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4N
Cj4gLS0tDQo+ICAgdG9vbHMvbGliL2JwZi9saWJicGYuYyAgIHwgNjEgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgIHRvb2xzL2xpYi9icGYvbGliYnBmLmggICB8
ICAzICsrDQo+ICAgdG9vbHMvbGliL2JwZi9saWJicGYubWFwIHwgIDEgKw0KPiAgIDMgZmlsZXMg
Y2hhbmdlZCwgNjUgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9i
cGYvbGliYnBmLmMgYi90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+IGluZGV4IDQ1NTc5NWU2Zjhh
Zi4uOThjMTU1ZWMzYmZhIDEwMDY0NA0KPiAtLS0gYS90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+
ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4gQEAgLTMyLDYgKzMyLDcgQEANCj4gICAj
aW5jbHVkZSA8bGludXgvbGltaXRzLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L3BlcmZfZXZlbnQu
aD4NCj4gICAjaW5jbHVkZSA8bGludXgvcmluZ19idWZmZXIuaD4NCj4gKyNpbmNsdWRlIDxzeXMv
aW9jdGwuaD4NCj4gICAjaW5jbHVkZSA8c3lzL3N0YXQuaD4NCj4gICAjaW5jbHVkZSA8c3lzL3R5
cGVzLmg+DQo+ICAgI2luY2x1ZGUgPHN5cy92ZnMuaD4NCj4gQEAgLTM5NTgsNiArMzk1OSw2NiBA
QCBpbnQgYnBmX2xpbmtfX2Rlc3Ryb3koc3RydWN0IGJwZl9saW5rICpsaW5rKQ0KPiAgIAlyZXR1
cm4gZXJyOw0KPiAgIH0NCj4gICANCj4gK3N0cnVjdCBicGZfbGlua19mZCB7DQo+ICsJc3RydWN0
IGJwZl9saW5rIGxpbms7IC8qIGhhcyB0byBiZSBhdCB0aGUgdG9wIG9mIHN0cnVjdCAqLw0KPiAr
CWludCBmZDsgLyogaG9vayBGRCAqLw0KPiArfTsNCj4gKw0KPiArc3RhdGljIGludCBicGZfbGlu
a19fZGVzdHJveV9wZXJmX2V2ZW50KHN0cnVjdCBicGZfbGluayAqbGluaykNCj4gK3sNCj4gKwlz
dHJ1Y3QgYnBmX2xpbmtfZmQgKmwgPSAodm9pZCAqKWxpbms7DQo+ICsJaW50IGVycjsNCj4gKw0K
PiArCWlmIChsLT5mZCA8IDApDQo+ICsJCXJldHVybiAwOw0KPiArDQo+ICsJZXJyID0gaW9jdGwo
bC0+ZmQsIFBFUkZfRVZFTlRfSU9DX0RJU0FCTEUsIDApOw0KPiArCWlmIChlcnIpDQo+ICsJCWVy
ciA9IC1lcnJubzsNCj4gKw0KPiArCWNsb3NlKGwtPmZkKTsNCj4gKwlyZXR1cm4gZXJyOw0KPiAr
fQ0KPiArDQo+ICtzdHJ1Y3QgYnBmX2xpbmsgKmJwZl9wcm9ncmFtX19hdHRhY2hfcGVyZl9ldmVu
dChzdHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2csDQo+ICsJCQkJCQlpbnQgcGZkKQ0KPiArew0KPiAr
CWNoYXIgZXJybXNnW1NUUkVSUl9CVUZTSVpFXTsNCj4gKwlzdHJ1Y3QgYnBmX2xpbmtfZmQgKmxp
bms7DQo+ICsJaW50IHByb2dfZmQsIGVycjsNCj4gKw0KPiArCXByb2dfZmQgPSBicGZfcHJvZ3Jh
bV9fZmQocHJvZyk7DQo+ICsJaWYgKHByb2dfZmQgPCAwKSB7DQo+ICsJCXByX3dhcm5pbmcoInBy
b2dyYW0gJyVzJzogY2FuJ3QgYXR0YWNoIGJlZm9yZSBsb2FkZWRcbiIsDQo+ICsJCQkgICBicGZf
cHJvZ3JhbV9fdGl0bGUocHJvZywgZmFsc2UpKTsNCj4gKwkJcmV0dXJuIEVSUl9QVFIoLUVJTlZB
TCk7DQo+ICsJfQ0KDQpzaG91bGQgd2UgY2hlY2sgdmFsaWRpdHkgb2YgcGZkIGhlcmU/DQpJZiBw
ZmQgPCAwLCB3ZSBqdXN0IHJldHVybiBFUlJfUFRSKC1FSU5WQUwpPw0KVGhpcyB3YXksIGluIGJw
Zl9saW5rX19kZXN0cm95X3BlcmZfZXZlbnQoKSwgd2UgZG8gbm90IG5lZWQgdG8gY2hlY2sNCmwt
PmZkIDwgMCBzaW5jZSBpdCB3aWxsIGJlIGFsd2F5cyBub25uZWdhdGl2ZS4NCg0KPiArDQo+ICsJ
bGluayA9IG1hbGxvYyhzaXplb2YoKmxpbmspKTsNCj4gKwlpZiAoIWxpbmspDQo+ICsJCXJldHVy
biBFUlJfUFRSKC1FTk9NRU0pOw0KPiArCWxpbmstPmxpbmsuZGVzdHJveSA9ICZicGZfbGlua19f
ZGVzdHJveV9wZXJmX2V2ZW50Ow0KPiArCWxpbmstPmZkID0gcGZkOw0KPiArDQo+ICsJaWYgKGlv
Y3RsKHBmZCwgUEVSRl9FVkVOVF9JT0NfU0VUX0JQRiwgcHJvZ19mZCkgPCAwKSB7DQo+ICsJCWVy
ciA9IC1lcnJubzsNCj4gKwkJZnJlZShsaW5rKTsNCj4gKwkJcHJfd2FybmluZygicHJvZ3JhbSAn
JXMnOiBmYWlsZWQgdG8gYXR0YWNoIHRvIHBmZCAlZDogJXNcbiIsDQo+ICsJCQkgICBicGZfcHJv
Z3JhbV9fdGl0bGUocHJvZywgZmFsc2UpLCBwZmQsDQo+ICsJCQkgICBsaWJicGZfc3RyZXJyb3Jf
cihlcnIsIGVycm1zZywgc2l6ZW9mKGVycm1zZykpKTsNCj4gKwkJcmV0dXJuIEVSUl9QVFIoZXJy
KTsNCj4gKwl9DQo+ICsJaWYgKGlvY3RsKHBmZCwgUEVSRl9FVkVOVF9JT0NfRU5BQkxFLCAwKSA8
IDApIHsNCj4gKwkJZXJyID0gLWVycm5vOw0KPiArCQlmcmVlKGxpbmspOw0KPiArCQlwcl93YXJu
aW5nKCJwcm9ncmFtICclcyc6IGZhaWxlZCB0byBlbmFibGUgcGZkICVkOiAlc1xuIiwNCj4gKwkJ
CSAgIGJwZl9wcm9ncmFtX190aXRsZShwcm9nLCBmYWxzZSksIHBmZCwNCj4gKwkJCSAgIGxpYmJw
Zl9zdHJlcnJvcl9yKGVyciwgZXJybXNnLCBzaXplb2YoZXJybXNnKSkpOw0KPiArCQlyZXR1cm4g
RVJSX1BUUihlcnIpOw0KPiArCX0NCj4gKwlyZXR1cm4gKHN0cnVjdCBicGZfbGluayAqKWxpbms7
DQo+ICt9DQo+ICsNCj4gICBlbnVtIGJwZl9wZXJmX2V2ZW50X3JldA0KPiAgIGJwZl9wZXJmX2V2
ZW50X3JlYWRfc2ltcGxlKHZvaWQgKm1tYXBfbWVtLCBzaXplX3QgbW1hcF9zaXplLCBzaXplX3Qg
cGFnZV9zaXplLA0KPiAgIAkJCSAgIHZvaWQgKipjb3B5X21lbSwgc2l6ZV90ICpjb3B5X3NpemUs
DQo+IGRpZmYgLS1naXQgYS90b29scy9saWIvYnBmL2xpYmJwZi5oIGIvdG9vbHMvbGliL2JwZi9s
aWJicGYuaA0KPiBpbmRleCA1MDgyYTVlYmIwYzIuLjFiZjY2YzRhOTMzMCAxMDA2NDQNCj4gLS0t
IGEvdG9vbHMvbGliL2JwZi9saWJicGYuaA0KPiArKysgYi90b29scy9saWIvYnBmL2xpYmJwZi5o
DQo+IEBAIC0xNjksNiArMTY5LDkgQEAgc3RydWN0IGJwZl9saW5rOw0KPiAgIA0KPiAgIExJQkJQ
Rl9BUEkgaW50IGJwZl9saW5rX19kZXN0cm95KHN0cnVjdCBicGZfbGluayAqbGluayk7DQo+ICAg
DQo+ICtMSUJCUEZfQVBJIHN0cnVjdCBicGZfbGluayAqDQo+ICticGZfcHJvZ3JhbV9fYXR0YWNo
X3BlcmZfZXZlbnQoc3RydWN0IGJwZl9wcm9ncmFtICpwcm9nLCBpbnQgcGZkKTsNCj4gKw0KPiAg
IHN0cnVjdCBicGZfaW5zbjsNCj4gICANCj4gICAvKg0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGli
L2JwZi9saWJicGYubWFwIGIvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+IGluZGV4IDNjZGU4
NTBmYzhkYS4uNzU2ZjVhYTgwMmU5IDEwMDY0NA0KPiAtLS0gYS90b29scy9saWIvYnBmL2xpYmJw
Zi5tYXANCj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+IEBAIC0xNjksNiArMTY5
LDcgQEAgTElCQlBGXzAuMC40IHsNCj4gICAJZ2xvYmFsOg0KPiAgIAkJYnBmX2xpbmtfX2Rlc3Ry
b3k7DQo+ICAgCQlicGZfb2JqZWN0X19sb2FkX3hhdHRyOw0KPiArCQlicGZfcHJvZ3JhbV9fYXR0
YWNoX3BlcmZfZXZlbnQ7DQo+ICAgCQlidGZfZHVtcF9fZHVtcF90eXBlOw0KPiAgIAkJYnRmX2R1
bXBfX2ZyZWU7DQo+ICAgCQlidGZfZHVtcF9fbmV3Ow0KPiANCg==
