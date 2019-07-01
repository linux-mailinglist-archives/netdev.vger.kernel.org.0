Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E17985C1E8
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbfGARXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:23:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60922 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728263AbfGARXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:23:10 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61HHqSG010521;
        Mon, 1 Jul 2019 10:22:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Au1D6SelAUfLqZ3FweKeHJYcNOiyGw/5P7a5M2HaJic=;
 b=U4L4jp4NI5I9qTuO9XuD82Z+5HOA4e8nXX4YXgOOJi340ggcImk/wHUPEfTVEBpiFy86
 qXt1twIUiqHzR9xVTMaUjVY9yO9hSs+JkW30J7JykxLgy5GQQ+pQIM+RnFTSrfUTFVk8
 zwos+OtFRE+ISdIzEO9CONiCcScD5HGjMjo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tfhjq97ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 10:22:48 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 1 Jul 2019 10:22:46 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 10:22:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Au1D6SelAUfLqZ3FweKeHJYcNOiyGw/5P7a5M2HaJic=;
 b=I+gRt2u9PoEQW0BsKvgk5GKVYno4vrXErvkv3GrN6HSZJuc1iZhB/C7TgSt+GJq0Rom6xwBrU6eQ/jO/pvQPsanjUn8vtV93jQ0UDKAa6GwWlgBag/R1gngFPJ0oTXuGdOyZKer8+PTWeOs+sO2GHU23G/YJgTvn4ssUHZ6vGCs=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3414.namprd15.prod.outlook.com (20.179.59.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Mon, 1 Jul 2019 17:22:45 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 17:22:45 +0000
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
Subject: Re: [PATCH v4 bpf-next 8/9] selftests/bpf: add kprobe/uprobe
 selftests
Thread-Topic: [PATCH v4 bpf-next 8/9] selftests/bpf: add kprobe/uprobe
 selftests
Thread-Index: AQHVLi2yIFkTLyyIUUm+JsOddB/HOKa2BtGA
Date:   Mon, 1 Jul 2019 17:22:44 +0000
Message-ID: <b9d54fdf-58f5-90a1-7e97-b27cdacbfeb9@fb.com>
References: <20190629034906.1209916-1-andriin@fb.com>
 <20190629034906.1209916-9-andriin@fb.com>
In-Reply-To: <20190629034906.1209916-9-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0044.namprd20.prod.outlook.com
 (2603:10b6:300:ed::30) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:fe3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82a44f3a-528a-47a0-b9ea-08d6fe48baf2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3414;
x-ms-traffictypediagnostic: BYAPR15MB3414:
x-microsoft-antispam-prvs: <BYAPR15MB34146DB55E772D7444C57CC0D3F90@BYAPR15MB3414.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:66;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(396003)(366004)(39860400002)(189003)(199004)(486006)(102836004)(2616005)(52116002)(6436002)(256004)(476003)(53546011)(386003)(6506007)(76176011)(99286004)(14444005)(5024004)(229853002)(8676002)(6486002)(8936002)(2906002)(68736007)(110136005)(53936002)(36756003)(6636002)(81166006)(316002)(71200400001)(71190400001)(31686004)(14454004)(6246003)(11346002)(46003)(81156014)(86362001)(6512007)(446003)(31696002)(2201001)(305945005)(7736002)(66476007)(66556008)(66946007)(5660300002)(2501003)(25786009)(73956011)(64756008)(66446008)(478600001)(186003)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3414;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 14lrRw/LjMZt7mAxT8ZpuOqjOqKj13n/cwn7KII+WCddrakwrdVz5qwQHDpf+oapS1hoYDRzimLKVxgeCaPtNMXX8CCpCWO7y0TpLZES1FYfzJ4rV/2SbwumLZ8W9/TeDvpibVmQpEZOBH64HxEiWo95Wrahbld5HVKlU8ZVaZmrZn3qN3UfKebnQh92xHztt1Xsu9OsUNL4Y6cAvOwhSVT3cOKoXnPcWTXAFSn94VuDRX3ZV3reG/8ZoVQyUjIHV28eQm9Rhxyoq/u3V3ojq3fzf95yTVhazQZbFQSebahcPgHOwWM8/mOSrLCL/EkDmQim8LXPnMSn6VMAortl0lLXdU6tD1BkdyrSHYEfbfVURQj2Cx3YG1bkxODxmhJDtAtspGajkwiivf3utgYUlQWwswDMQ8HfzWum8ocL/rQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F18EC1981EA9047B5915049B4591C0D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 82a44f3a-528a-47a0-b9ea-08d6fe48baf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 17:22:44.9622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3414
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010203
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMjgvMTkgODo0OSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBBZGQgdGVz
dHMgdmVyaWZ5aW5nIGtwcm9iZS9rcmV0cHJvYmUvdXByb2JlL3VyZXRwcm9iZSBBUElzIHdvcmsg
YXMNCj4gZXhwZWN0ZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa28gPGFu
ZHJpaW5AZmIuY29tPg0KPiBSZXZpZXdlZC1ieTogU3RhbmlzbGF2IEZvbWljaGV2IDxzZGZAZ29v
Z2xlLmNvbT4NCj4gQWNrZWQtYnk6IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+DQo+
IC0tLQ0KPiAgIC4uLi9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvYXR0YWNoX3Byb2JlLmMgICB8
IDE1NSArKysrKysrKysrKysrKysrKysNCj4gICAuLi4vc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0
X2F0dGFjaF9wcm9iZS5jICAgfCAgNTUgKysrKysrKw0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgMjEw
IGluc2VydGlvbnMoKykNCj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvYnBmL3Byb2dfdGVzdHMvYXR0YWNoX3Byb2JlLmMNCj4gICBjcmVhdGUgbW9kZSAxMDA2
NDQgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3RfYXR0YWNoX3Byb2JlLmMN
Cj4gDQo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0
cy9hdHRhY2hfcHJvYmUuYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9nX3Rlc3Rz
L2F0dGFjaF9wcm9iZS5jDQo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAw
MDAwMC4uZjIyOTI5MDYzYzU4DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvdG9vbHMvdGVzdGlu
Zy9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvYXR0YWNoX3Byb2JlLmMNCj4gQEAgLTAsMCArMSwx
NTUgQEANCj4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+ICsjaW5jbHVk
ZSA8dGVzdF9wcm9ncy5oPg0KPiArDQo+ICtzc2l6ZV90IGdldF9iYXNlX2FkZHIoKSB7DQo+ICsJ
c2l6ZV90IHN0YXJ0Ow0KPiArCWNoYXIgYnVmWzI1Nl07DQo+ICsJRklMRSAqZjsNCj4gKw0KPiAr
CWYgPSBmb3BlbigiL3Byb2Mvc2VsZi9tYXBzIiwgInIiKTsNCj4gKwlpZiAoIWYpDQo+ICsJCXJl
dHVybiAtZXJybm87DQo+ICsNCj4gKwl3aGlsZSAoZnNjYW5mKGYsICIlengtJSp4ICVzICUqc1xu
IiwgJnN0YXJ0LCBidWYpID09IDIpIHsNCj4gKwkJaWYgKHN0cmNtcChidWYsICJyLXhwIikgPT0g
MCkgew0KPiArCQkJZmNsb3NlKGYpOw0KPiArCQkJcmV0dXJuIHN0YXJ0Ow0KPiArCQl9DQo+ICsJ
fQ0KPiArDQo+ICsJZmNsb3NlKGYpOw0KPiArCXJldHVybiAtRUlOVkFMOw0KPiArfQ0KPiArDQo+
ICt2b2lkIHRlc3RfYXR0YWNoX3Byb2JlKHZvaWQpDQo+ICt7DQo+ICsJY29uc3QgY2hhciAqa3By
b2JlX25hbWUgPSAia3Byb2JlL3N5c19uYW5vc2xlZXAiOw0KPiArCWNvbnN0IGNoYXIgKmtyZXRw
cm9iZV9uYW1lID0gImtyZXRwcm9iZS9zeXNfbmFub3NsZWVwIjsNCj4gKwljb25zdCBjaGFyICp1
cHJvYmVfbmFtZSA9ICJ1cHJvYmUvdHJpZ2dlcl9mdW5jIjsNCj4gKwljb25zdCBjaGFyICp1cmV0
cHJvYmVfbmFtZSA9ICJ1cmV0cHJvYmUvdHJpZ2dlcl9mdW5jIjsNCj4gKwljb25zdCBpbnQga3By
b2JlX2lkeCA9IDAsIGtyZXRwcm9iZV9pZHggPSAxOw0KPiArCWNvbnN0IGludCB1cHJvYmVfaWR4
ID0gMiwgdXJldHByb2JlX2lkeCA9IDM7DQo+ICsJY29uc3QgY2hhciAqZmlsZSA9ICIuL3Rlc3Rf
YXR0YWNoX3Byb2JlLm8iOw0KPiArCXN0cnVjdCBicGZfcHJvZ3JhbSAqa3Byb2JlX3Byb2csICpr
cmV0cHJvYmVfcHJvZzsNCj4gKwlzdHJ1Y3QgYnBmX3Byb2dyYW0gKnVwcm9iZV9wcm9nLCAqdXJl
dHByb2JlX3Byb2c7DQo+ICsJc3RydWN0IGJwZl9vYmplY3QgKm9iajsNCj4gKwlpbnQgZXJyLCBw
cm9nX2ZkLCBkdXJhdGlvbiA9IDAsIHJlczsNCj4gKwlzdHJ1Y3QgYnBmX2xpbmsgKmtwcm9iZV9s
aW5rID0gTlVMTDsNCj4gKwlzdHJ1Y3QgYnBmX2xpbmsgKmtyZXRwcm9iZV9saW5rID0gTlVMTDsN
Cj4gKwlzdHJ1Y3QgYnBmX2xpbmsgKnVwcm9iZV9saW5rID0gTlVMTDsNCj4gKwlzdHJ1Y3QgYnBm
X2xpbmsgKnVyZXRwcm9iZV9saW5rID0gTlVMTDsNCj4gKwlpbnQgcmVzdWx0c19tYXBfZmQ7DQo+
ICsJc2l6ZV90IHVwcm9iZV9vZmZzZXQ7DQo+ICsJc3NpemVfdCBiYXNlX2FkZHI7DQo+ICsNCj4g
KwliYXNlX2FkZHIgPSBnZXRfYmFzZV9hZGRyKCk7DQo+ICsJaWYgKENIRUNLKGJhc2VfYWRkciA8
IDAsICJnZXRfYmFzZV9hZGRyIiwNCj4gKwkJICAiZmFpbGVkIHRvIGZpbmQgYmFzZSBhZGRyOiAl
emQiLCBiYXNlX2FkZHIpKQ0KPiArCQlyZXR1cm47DQo+ICsJdXByb2JlX29mZnNldCA9IChzaXpl
X3QpJmdldF9iYXNlX2FkZHIgLSBiYXNlX2FkZHI7DQo+ICsNCj4gKwkvKiBsb2FkIHByb2dyYW1z
ICovDQo+ICsJZXJyID0gYnBmX3Byb2dfbG9hZChmaWxlLCBCUEZfUFJPR19UWVBFX0tQUk9CRSwg
Jm9iaiwgJnByb2dfZmQpOw0KPiArCWlmIChDSEVDSyhlcnIsICJvYmpfbG9hZCIsICJlcnIgJWQg
ZXJybm8gJWRcbiIsIGVyciwgZXJybm8pKQ0KPiArCQlyZXR1cm47DQo+ICsNCj4gKwlrcHJvYmVf
cHJvZyA9IGJwZl9vYmplY3RfX2ZpbmRfcHJvZ3JhbV9ieV90aXRsZShvYmosIGtwcm9iZV9uYW1l
KTsNCj4gKwlpZiAoQ0hFQ0soIWtwcm9iZV9wcm9nLCAiZmluZF9wcm9iZSIsDQo+ICsJCSAgInBy
b2cgJyVzJyBub3QgZm91bmRcbiIsIGtwcm9iZV9uYW1lKSkNCj4gKwkJZ290byBjbGVhbnVwOw0K
PiArCWtyZXRwcm9iZV9wcm9nID0gYnBmX29iamVjdF9fZmluZF9wcm9ncmFtX2J5X3RpdGxlKG9i
aiwga3JldHByb2JlX25hbWUpOw0KPiArCWlmIChDSEVDSygha3JldHByb2JlX3Byb2csICJmaW5k
X3Byb2JlIiwNCj4gKwkJICAicHJvZyAnJXMnIG5vdCBmb3VuZFxuIiwga3JldHByb2JlX25hbWUp
KQ0KPiArCQlnb3RvIGNsZWFudXA7DQo+ICsJdXByb2JlX3Byb2cgPSBicGZfb2JqZWN0X19maW5k
X3Byb2dyYW1fYnlfdGl0bGUob2JqLCB1cHJvYmVfbmFtZSk7DQo+ICsJaWYgKENIRUNLKCF1cHJv
YmVfcHJvZywgImZpbmRfcHJvYmUiLA0KPiArCQkgICJwcm9nICclcycgbm90IGZvdW5kXG4iLCB1
cHJvYmVfbmFtZSkpDQo+ICsJCWdvdG8gY2xlYW51cDsNCj4gKwl1cmV0cHJvYmVfcHJvZyA9IGJw
Zl9vYmplY3RfX2ZpbmRfcHJvZ3JhbV9ieV90aXRsZShvYmosIHVyZXRwcm9iZV9uYW1lKTsNCj4g
KwlpZiAoQ0hFQ0soIXVyZXRwcm9iZV9wcm9nLCAiZmluZF9wcm9iZSIsDQo+ICsJCSAgInByb2cg
JyVzJyBub3QgZm91bmRcbiIsIHVyZXRwcm9iZV9uYW1lKSkNCj4gKwkJZ290byBjbGVhbnVwOw0K
PiArDQo+ICsJLyogbG9hZCBtYXBzICovDQo+ICsJcmVzdWx0c19tYXBfZmQgPSBicGZfZmluZF9t
YXAoX19mdW5jX18sIG9iaiwgInJlc3VsdHNfbWFwIik7DQo+ICsJaWYgKENIRUNLKHJlc3VsdHNf
bWFwX2ZkIDwgMCwgImZpbmRfcmVzdWx0c19tYXAiLA0KPiArCQkgICJlcnIgJWRcbiIsIHJlc3Vs
dHNfbWFwX2ZkKSkNCj4gKwkJZ290byBjbGVhbnVwOw0KPiArDQo+ICsJa3Byb2JlX2xpbmsgPSBi
cGZfcHJvZ3JhbV9fYXR0YWNoX2twcm9iZShrcHJvYmVfcHJvZywNCj4gKwkJCQkJCSBmYWxzZSAv
KiByZXRwcm9iZSAqLywNCj4gKwkJCQkJCSAic3lzX25hbm9zbGVlcCIpOw0KDQpBbm90aGVyIHRo
aW5nLCBpbiBjdXJyZW50IGtlcm5lbCwgYHN5c19uYW5vc2xlZXBgZG9lcyBub3QgZXhpc3QNCm9u
IHg2NC4gSXQgaXMgYF9feDY0X3N5c19uYW5vc2xlZXBgLiBTZWUgc2FtcGxlcy9icGYvYnBmX2xv
YWQuYw0KZnVuY3Rpb24gbG9hZF9hbmRfYXR0YWNoKCkuIFlvdSBjYW4gdXNlIG1hY3JvcyB0byBk
aWZmZXJlbnRpYXRlDQpkaWZmZXJlbnQgYXJjaGl0ZWN0dXJlcy4NCg0KPiArCWlmIChDSEVDSyhJ
U19FUlIoa3Byb2JlX2xpbmspLCAiYXR0YWNoX2twcm9iZSIsDQo+ICsJCSAgImVyciAlbGRcbiIs
IFBUUl9FUlIoa3Byb2JlX2xpbmspKSkNCj4gKwkJZ290byBjbGVhbnVwOw0KPiArDQo+ICsJa3Jl
dHByb2JlX2xpbmsgPSBicGZfcHJvZ3JhbV9fYXR0YWNoX2twcm9iZShrcmV0cHJvYmVfcHJvZywN
Cj4gKwkJCQkJCSAgICB0cnVlIC8qIHJldHByb2JlICovLA0KPiArCQkJCQkJICAgICJzeXNfbmFu
b3NsZWVwIik7DQo+ICsJaWYgKENIRUNLKElTX0VSUihrcmV0cHJvYmVfbGluayksICJhdHRhY2hf
a3JldHByb2JlIiwNCj4gKwkJICAiZXJyICVsZFxuIiwgUFRSX0VSUihrcmV0cHJvYmVfbGluaykp
KQ0KPiArCQlnb3RvIGNsZWFudXA7DQo+ICsNCj4gKwl1cHJvYmVfbGluayA9IGJwZl9wcm9ncmFt
X19hdHRhY2hfdXByb2JlKHVwcm9iZV9wcm9nLA0KPiArCQkJCQkJIGZhbHNlIC8qIHJldHByb2Jl
ICovLA0KPiArCQkJCQkJIDAgLyogc2VsZiBwaWQgKi8sDQo+ICsJCQkJCQkgIi9wcm9jL3NlbGYv
ZXhlIiwNCj4gKwkJCQkJCSB1cHJvYmVfb2Zmc2V0KTsNCj4gKwlpZiAoQ0hFQ0soSVNfRVJSKHVw
cm9iZV9saW5rKSwgImF0dGFjaF91cHJvYmUiLA0KPiArCQkgICJlcnIgJWxkXG4iLCBQVFJfRVJS
KHVwcm9iZV9saW5rKSkpDQo+ICsJCWdvdG8gY2xlYW51cDsNCj4gKw0KPiArCXVyZXRwcm9iZV9s
aW5rID0gYnBmX3Byb2dyYW1fX2F0dGFjaF91cHJvYmUodXJldHByb2JlX3Byb2csDQo+ICsJCQkJ
CQkgICAgdHJ1ZSAvKiByZXRwcm9iZSAqLywNCj4gKwkJCQkJCSAgICAtMSAvKiBhbnkgcGlkICov
LA0KPiArCQkJCQkJICAgICIvcHJvYy9zZWxmL2V4ZSIsDQo+ICsJCQkJCQkgICAgdXByb2JlX29m
ZnNldCk7DQo+ICsJaWYgKENIRUNLKElTX0VSUih1cmV0cHJvYmVfbGluayksICJhdHRhY2hfdXJl
dHByb2JlIiwNCj4gKwkJICAiZXJyICVsZFxuIiwgUFRSX0VSUih1cmV0cHJvYmVfbGluaykpKQ0K
PiArCQlnb3RvIGNsZWFudXA7DQo+ICsNCj4gKwkvKiB0cmlnZ2VyICYgdmFsaWRhdGUga3Byb2Jl
ICYmIGtyZXRwcm9iZSAqLw0KPiArCXVzbGVlcCgxKTsNCj4gKw0KPiArCWVyciA9IGJwZl9tYXBf
bG9va3VwX2VsZW0ocmVzdWx0c19tYXBfZmQsICZrcHJvYmVfaWR4LCAmcmVzKTsNCj4gKwlpZiAo
Q0hFQ0soZXJyLCAiZ2V0X2twcm9iZV9yZXMiLA0KPiArCQkgICJmYWlsZWQgdG8gZ2V0IGtwcm9i
ZSByZXM6ICVkXG4iLCBlcnIpKQ0KPiArCQlnb3RvIGNsZWFudXA7DQo+ICsJaWYgKENIRUNLKHJl
cyAhPSBrcHJvYmVfaWR4ICsgMSwgImNoZWNrX2twcm9iZV9yZXMiLA0KPiArCQkgICJ3cm9uZyBr
cHJvYmUgcmVzOiAlZFxuIiwgcmVzKSkNCj4gKwkJZ290byBjbGVhbnVwOw0KPiArDQo+ICsJZXJy
ID0gYnBmX21hcF9sb29rdXBfZWxlbShyZXN1bHRzX21hcF9mZCwgJmtyZXRwcm9iZV9pZHgsICZy
ZXMpOw0KPiArCWlmIChDSEVDSyhlcnIsICJnZXRfa3JldHByb2JlX3JlcyIsDQo+ICsJCSAgImZh
aWxlZCB0byBnZXQga3JldHByb2JlIHJlczogJWRcbiIsIGVycikpDQo+ICsJCWdvdG8gY2xlYW51
cDsNCj4gKwlpZiAoQ0hFQ0socmVzICE9IGtyZXRwcm9iZV9pZHggKyAxLCAiY2hlY2tfa3JldHBy
b2JlX3JlcyIsDQo+ICsJCSAgIndyb25nIGtyZXRwcm9iZSByZXM6ICVkXG4iLCByZXMpKQ0KPiAr
CQlnb3RvIGNsZWFudXA7DQo+ICsNCj4gKwkvKiB0cmlnZ2VyICYgdmFsaWRhdGUgdXByb2JlICYg
dXJldHByb2JlICovDQo+ICsJZ2V0X2Jhc2VfYWRkcigpOw0KPiArDQo+ICsJZXJyID0gYnBmX21h
cF9sb29rdXBfZWxlbShyZXN1bHRzX21hcF9mZCwgJnVwcm9iZV9pZHgsICZyZXMpOw0KPiArCWlm
IChDSEVDSyhlcnIsICJnZXRfdXByb2JlX3JlcyIsDQo+ICsJCSAgImZhaWxlZCB0byBnZXQgdXBy
b2JlIHJlczogJWRcbiIsIGVycikpDQo+ICsJCWdvdG8gY2xlYW51cDsNCj4gKwlpZiAoQ0hFQ0so
cmVzICE9IHVwcm9iZV9pZHggKyAxLCAiY2hlY2tfdXByb2JlX3JlcyIsDQo+ICsJCSAgIndyb25n
IHVwcm9iZSByZXM6ICVkXG4iLCByZXMpKQ0KPiArCQlnb3RvIGNsZWFudXA7DQo+ICsNCj4gKwll
cnIgPSBicGZfbWFwX2xvb2t1cF9lbGVtKHJlc3VsdHNfbWFwX2ZkLCAmdXJldHByb2JlX2lkeCwg
JnJlcyk7DQo+ICsJaWYgKENIRUNLKGVyciwgImdldF91cmV0cHJvYmVfcmVzIiwNCj4gKwkJICAi
ZmFpbGVkIHRvIGdldCB1cmV0cHJvYmUgcmVzOiAlZFxuIiwgZXJyKSkNCj4gKwkJZ290byBjbGVh
bnVwOw0KPiArCWlmIChDSEVDSyhyZXMgIT0gdXJldHByb2JlX2lkeCArIDEsICJjaGVja191cmV0
cHJvYmVfcmVzIiwNCj4gKwkJICAid3JvbmcgdXJldHByb2JlIHJlczogJWRcbiIsIHJlcykpDQo+
ICsJCWdvdG8gY2xlYW51cDsNCj4gKw0KPiArY2xlYW51cDoNCj4gKwlicGZfbGlua19fZGVzdHJv
eShrcHJvYmVfbGluayk7DQo+ICsJYnBmX2xpbmtfX2Rlc3Ryb3koa3JldHByb2JlX2xpbmspOw0K
PiArCWJwZl9saW5rX19kZXN0cm95KHVwcm9iZV9saW5rKTsNCj4gKwlicGZfbGlua19fZGVzdHJv
eSh1cmV0cHJvYmVfbGluayk7DQo+ICsJYnBmX29iamVjdF9fY2xvc2Uob2JqKTsNCj4gK30NClsu
Li5dDQo=
