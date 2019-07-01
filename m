Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF6D5C1D9
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfGARSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:18:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13014 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726840AbfGARSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:18:43 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61HHQ4G019430;
        Mon, 1 Jul 2019 10:18:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=YywT44JbXJU6jnv2DQyNOiFUqTlOhneHRCt9YG9jkh0=;
 b=WpdEjNPU6jOsF1JxW5M4VBco0yzPx25ccD+MlkRgwdaD3PD/+936Xs1xv/zEt0SmYwOA
 j9OgKL/UJtW2vaTYInea9TOSbmmhAAP88vdOrDLya44BG1eCX28gVE04IjX1lj2ZATgI
 Id36hYvUoPF0KHCnzWYfw7Kv5Uk5QB/qaKs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tfkpsrqu2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 10:18:20 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 1 Jul 2019 10:18:18 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 10:18:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=GFj7HzRV4/X+Xt4xjOSpYHNw/Vw4aN66xCaApc/+KgLR4N0AH/JpTPQO0LiVUfbJr8NQP+v2aUIKY8Am/A/1wSzbIFFCpoTRbcLidNBWcODJcQiJ35K9+Nvi+rcmbrT0qwMw1m4c8DpGIEYip1DsAkphUv9dR94iq1Wk70btusY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YywT44JbXJU6jnv2DQyNOiFUqTlOhneHRCt9YG9jkh0=;
 b=PFED40x1JQDngAAK5zCooCNARvPr9ZDg60c5cc4UZZTfUJ1ZHTOTz4djuZlAUaCIEUgSnXalYtvW6AvFXSE0B0BSqOAIa4DgyRsZoD7dvt6rEZgH146SMEwYjLoSWqPsztw8rmwuRSiTg4WEAij/pD1PHl83w9mXjCOMdrS/BNU=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YywT44JbXJU6jnv2DQyNOiFUqTlOhneHRCt9YG9jkh0=;
 b=Eh7WR882Io5muATPPHsro76DSVVhEMl3vMFD56QtoBHtxvwbLI/XLm9JXpDKSuLHcoWO6CppEk4ugql0QMP2EQccnCGfJR85RkXqkmRQ6Sj2Aznqi+Rx29kgLIRUrudDyajUvcFADXfKCE5NJUGgdL2Oi8wsmNS3uPiYZZ3/PjI=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2438.namprd15.prod.outlook.com (52.135.198.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 1 Jul 2019 17:18:15 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 17:18:15 +0000
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
Thread-Index: AQHVLi2yIFkTLyyIUUm+JsOddB/HOKa2BY4A
Date:   Mon, 1 Jul 2019 17:18:14 +0000
Message-ID: <8c79e0b2-1194-ab60-fda9-62ba4bbe019f@fb.com>
References: <20190629034906.1209916-1-andriin@fb.com>
 <20190629034906.1209916-9-andriin@fb.com>
In-Reply-To: <20190629034906.1209916-9-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0009.namprd16.prod.outlook.com (2603:10b6:907::22)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:fe3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86374cc2-112a-410b-91be-08d6fe4818dc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2438;
x-ms-traffictypediagnostic: BYAPR15MB2438:
x-microsoft-antispam-prvs: <BYAPR15MB2438406F91D50017C5E0305AD3F90@BYAPR15MB2438.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:255;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(136003)(39860400002)(366004)(189003)(199004)(31686004)(53546011)(99286004)(76176011)(256004)(6506007)(36756003)(52116002)(14454004)(14444005)(5024004)(386003)(478600001)(31696002)(102836004)(86362001)(6486002)(2201001)(186003)(6116002)(2501003)(2906002)(6636002)(68736007)(6246003)(6512007)(8936002)(8676002)(110136005)(64756008)(66446008)(316002)(66476007)(81156014)(25786009)(486006)(81166006)(2616005)(11346002)(476003)(73956011)(66946007)(5660300002)(7736002)(71200400001)(6436002)(46003)(53936002)(229853002)(71190400001)(446003)(305945005)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2438;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: x3AVvR/FI/yb4FBWqEyfMN7waVljjSvqvTHZtqWOwycOz1p+mdfehz7NhFMsG5S2ciPTf9S+8Zp9oKCBQYnSJBm7K5P9LPw5jjBBcgjakEbpC4IIsLFXbO5ZAQXudrs8pQR1JXIfxEpI3qgD4QqY4GL29NtSjX95g03GCciUVT2YNnkTC5+MqB0sFEa6Db3PaUhZDdk+wpnhVQMSKd1PlVhaaE7EroHxohkIX+hrJJBaege1q+tszNohmKWbgIZm73FVsA40sjf+U9meul2Me9hDuGCX9k0iLbO8UxGjYX/nY5q6sKDs8895JdxTz+DLD8lJf90BdPdM9ZpmmCEEdNwCbz49kE4xRP/fXx5AS+6O2MI+w+YNTZ/vUhmzRzyL/7E++fZbRjrJSMKIs1ouq4siP2inLoGgBqV09bcIBqI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A92E525E63EFB408456FD9B8C848029@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 86374cc2-112a-410b-91be-08d6fe4818dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 17:18:14.3683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2438
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
KiByZXRwcm9iZSAqLywNCj4gKwkJCQkJCSAic3lzX25hbm9zbGVlcCIpOw0KPiArCWlmIChDSEVD
SyhJU19FUlIoa3Byb2JlX2xpbmspLCAiYXR0YWNoX2twcm9iZSIsDQo+ICsJCSAgImVyciAlbGRc
biIsIFBUUl9FUlIoa3Byb2JlX2xpbmspKSkNCj4gKwkJZ290byBjbGVhbnVwOw0KPiArDQo+ICsJ
a3JldHByb2JlX2xpbmsgPSBicGZfcHJvZ3JhbV9fYXR0YWNoX2twcm9iZShrcmV0cHJvYmVfcHJv
ZywNCj4gKwkJCQkJCSAgICB0cnVlIC8qIHJldHByb2JlICovLA0KPiArCQkJCQkJICAgICJzeXNf
bmFub3NsZWVwIik7DQo+ICsJaWYgKENIRUNLKElTX0VSUihrcmV0cHJvYmVfbGluayksICJhdHRh
Y2hfa3JldHByb2JlIiwNCj4gKwkJICAiZXJyICVsZFxuIiwgUFRSX0VSUihrcmV0cHJvYmVfbGlu
aykpKQ0KPiArCQlnb3RvIGNsZWFudXA7DQo+ICsNCj4gKwl1cHJvYmVfbGluayA9IGJwZl9wcm9n
cmFtX19hdHRhY2hfdXByb2JlKHVwcm9iZV9wcm9nLA0KPiArCQkJCQkJIGZhbHNlIC8qIHJldHBy
b2JlICovLA0KPiArCQkJCQkJIDAgLyogc2VsZiBwaWQgKi8sDQo+ICsJCQkJCQkgIi9wcm9jL3Nl
bGYvZXhlIiwNCj4gKwkJCQkJCSB1cHJvYmVfb2Zmc2V0KTsNCj4gKwlpZiAoQ0hFQ0soSVNfRVJS
KHVwcm9iZV9saW5rKSwgImF0dGFjaF91cHJvYmUiLA0KPiArCQkgICJlcnIgJWxkXG4iLCBQVFJf
RVJSKHVwcm9iZV9saW5rKSkpDQo+ICsJCWdvdG8gY2xlYW51cDsNCj4gKw0KPiArCXVyZXRwcm9i
ZV9saW5rID0gYnBmX3Byb2dyYW1fX2F0dGFjaF91cHJvYmUodXJldHByb2JlX3Byb2csDQo+ICsJ
CQkJCQkgICAgdHJ1ZSAvKiByZXRwcm9iZSAqLywNCj4gKwkJCQkJCSAgICAtMSAvKiBhbnkgcGlk
ICovLA0KPiArCQkJCQkJICAgICIvcHJvYy9zZWxmL2V4ZSIsDQo+ICsJCQkJCQkgICAgdXByb2Jl
X29mZnNldCk7DQo+ICsJaWYgKENIRUNLKElTX0VSUih1cmV0cHJvYmVfbGluayksICJhdHRhY2hf
dXJldHByb2JlIiwNCj4gKwkJICAiZXJyICVsZFxuIiwgUFRSX0VSUih1cmV0cHJvYmVfbGluaykp
KQ0KPiArCQlnb3RvIGNsZWFudXA7DQo+ICsNCj4gKwkvKiB0cmlnZ2VyICYgdmFsaWRhdGUga3By
b2JlICYmIGtyZXRwcm9iZSAqLw0KPiArCXVzbGVlcCgxKTsNCj4gKw0KPiArCWVyciA9IGJwZl9t
YXBfbG9va3VwX2VsZW0ocmVzdWx0c19tYXBfZmQsICZrcHJvYmVfaWR4LCAmcmVzKTsNCj4gKwlp
ZiAoQ0hFQ0soZXJyLCAiZ2V0X2twcm9iZV9yZXMiLA0KPiArCQkgICJmYWlsZWQgdG8gZ2V0IGtw
cm9iZSByZXM6ICVkXG4iLCBlcnIpKQ0KPiArCQlnb3RvIGNsZWFudXA7DQo+ICsJaWYgKENIRUNL
KHJlcyAhPSBrcHJvYmVfaWR4ICsgMSwgImNoZWNrX2twcm9iZV9yZXMiLA0KPiArCQkgICJ3cm9u
ZyBrcHJvYmUgcmVzOiAlZFxuIiwgcmVzKSkNCj4gKwkJZ290byBjbGVhbnVwOw0KPiArDQo+ICsJ
ZXJyID0gYnBmX21hcF9sb29rdXBfZWxlbShyZXN1bHRzX21hcF9mZCwgJmtyZXRwcm9iZV9pZHgs
ICZyZXMpOw0KPiArCWlmIChDSEVDSyhlcnIsICJnZXRfa3JldHByb2JlX3JlcyIsDQo+ICsJCSAg
ImZhaWxlZCB0byBnZXQga3JldHByb2JlIHJlczogJWRcbiIsIGVycikpDQo+ICsJCWdvdG8gY2xl
YW51cDsNCj4gKwlpZiAoQ0hFQ0socmVzICE9IGtyZXRwcm9iZV9pZHggKyAxLCAiY2hlY2tfa3Jl
dHByb2JlX3JlcyIsDQo+ICsJCSAgIndyb25nIGtyZXRwcm9iZSByZXM6ICVkXG4iLCByZXMpKQ0K
PiArCQlnb3RvIGNsZWFudXA7DQo+ICsNCj4gKwkvKiB0cmlnZ2VyICYgdmFsaWRhdGUgdXByb2Jl
ICYgdXJldHByb2JlICovDQo+ICsJZ2V0X2Jhc2VfYWRkcigpOw0KPiArDQo+ICsJZXJyID0gYnBm
X21hcF9sb29rdXBfZWxlbShyZXN1bHRzX21hcF9mZCwgJnVwcm9iZV9pZHgsICZyZXMpOw0KPiAr
CWlmIChDSEVDSyhlcnIsICJnZXRfdXByb2JlX3JlcyIsDQo+ICsJCSAgImZhaWxlZCB0byBnZXQg
dXByb2JlIHJlczogJWRcbiIsIGVycikpDQo+ICsJCWdvdG8gY2xlYW51cDsNCj4gKwlpZiAoQ0hF
Q0socmVzICE9IHVwcm9iZV9pZHggKyAxLCAiY2hlY2tfdXByb2JlX3JlcyIsDQo+ICsJCSAgIndy
b25nIHVwcm9iZSByZXM6ICVkXG4iLCByZXMpKQ0KPiArCQlnb3RvIGNsZWFudXA7DQo+ICsNCj4g
KwllcnIgPSBicGZfbWFwX2xvb2t1cF9lbGVtKHJlc3VsdHNfbWFwX2ZkLCAmdXJldHByb2JlX2lk
eCwgJnJlcyk7DQo+ICsJaWYgKENIRUNLKGVyciwgImdldF91cmV0cHJvYmVfcmVzIiwNCj4gKwkJ
ICAiZmFpbGVkIHRvIGdldCB1cmV0cHJvYmUgcmVzOiAlZFxuIiwgZXJyKSkNCj4gKwkJZ290byBj
bGVhbnVwOw0KPiArCWlmIChDSEVDSyhyZXMgIT0gdXJldHByb2JlX2lkeCArIDEsICJjaGVja191
cmV0cHJvYmVfcmVzIiwNCj4gKwkJICAid3JvbmcgdXJldHByb2JlIHJlczogJWRcbiIsIHJlcykp
DQo+ICsJCWdvdG8gY2xlYW51cDsNCj4gKw0KPiArY2xlYW51cDoNCj4gKwlicGZfbGlua19fZGVz
dHJveShrcHJvYmVfbGluayk7DQo+ICsJYnBmX2xpbmtfX2Rlc3Ryb3koa3JldHByb2JlX2xpbmsp
Ow0KPiArCWJwZl9saW5rX19kZXN0cm95KHVwcm9iZV9saW5rKTsNCj4gKwlicGZfbGlua19fZGVz
dHJveSh1cmV0cHJvYmVfbGluayk7DQoNCmlmIGFueSBlcnJvciBoYXBwZW5zLCBrcHJvYmVfbGlu
ayBldGMuIHdpbGwgYmUgYSBub24tTlVMTCBwb2ludGVyDQppbmRpY2F0aW5nIGFuIGVycm9yLiB0
aGUgYWJvdmUgYnBmX2xpbmtfX2Rlc3Ryb3koKSB3b24ndCB3b3JrDQpwcm9wZXJseS4gVGhlIHNh
bWUgZm9yIHBhdGNoICM5Lg0KDQo+ICsJYnBmX29iamVjdF9fY2xvc2Uob2JqKTsNCj4gK30NCj4g
ZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X2F0dGFj
aF9wcm9iZS5jIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3RfYXR0YWNo
X3Byb2JlLmMNCj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gaW5kZXggMDAwMDAwMDAwMDAwLi43
YTdjNWNkNzI4YzgNCj4gLS0tIC9kZXYvbnVsbA0KPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9icGYvcHJvZ3MvdGVzdF9hdHRhY2hfcHJvYmUuYw0KPiBAQCAtMCwwICsxLDU1IEBADQo+
ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiArLy8gQ29weXJpZ2h0IChj
KSAyMDE3IEZhY2Vib29rDQo+ICsNCj4gKyNpbmNsdWRlIDxsaW51eC9wdHJhY2UuaD4NCj4gKyNp
bmNsdWRlIDxsaW51eC9icGYuaD4NCj4gKyNpbmNsdWRlICJicGZfaGVscGVycy5oIg0KPiArDQo+
ICtzdHJ1Y3Qgew0KPiArCWludCB0eXBlOw0KPiArCWludCBtYXhfZW50cmllczsNCj4gKwlpbnQg
KmtleTsNCj4gKwlpbnQgKnZhbHVlOw0KPiArfSByZXN1bHRzX21hcCBTRUMoIi5tYXBzIikgPSB7
DQo+ICsJLnR5cGUgPSBCUEZfTUFQX1RZUEVfQVJSQVksDQo+ICsJLm1heF9lbnRyaWVzID0gNCwN
Cj4gK307DQo+ICsNCj4gK1NFQygia3Byb2JlL3N5c19uYW5vc2xlZXAiKQ0KPiAraW50IGhhbmRs
ZV9zeXNfbmFub3NsZWVwX2VudHJ5KHN0cnVjdCBwdF9yZWdzICpjdHgpDQo+ICt7DQo+ICsJY29u
c3QgaW50IGtleSA9IDAsIHZhbHVlID0gMTsNCj4gKw0KPiArCWJwZl9tYXBfdXBkYXRlX2VsZW0o
JnJlc3VsdHNfbWFwLCAma2V5LCAmdmFsdWUsIDApOw0KPiArCXJldHVybiAwOw0KPiArfQ0KPiAr
DQo+ICtTRUMoImtyZXRwcm9iZS9zeXNfbmFub3NsZWVwIikNCj4gK2ludCBoYW5kbGVfc3lzX2dl
dHBpZF9yZXR1cm4oc3RydWN0IHB0X3JlZ3MgKmN0eCkNCj4gK3sNCj4gKwljb25zdCBpbnQga2V5
ID0gMSwgdmFsdWUgPSAyOw0KPiArDQo+ICsJYnBmX21hcF91cGRhdGVfZWxlbSgmcmVzdWx0c19t
YXAsICZrZXksICZ2YWx1ZSwgMCk7DQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4gK1NFQygi
dXByb2JlL3RyaWdnZXJfZnVuYyIpDQo+ICtpbnQgaGFuZGxlX3Vwcm9iZV9lbnRyeShzdHJ1Y3Qg
cHRfcmVncyAqY3R4KQ0KPiArew0KPiArCWNvbnN0IGludCBrZXkgPSAyLCB2YWx1ZSA9IDM7DQo+
ICsNCj4gKwlicGZfbWFwX3VwZGF0ZV9lbGVtKCZyZXN1bHRzX21hcCwgJmtleSwgJnZhbHVlLCAw
KTsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKw0KPiArU0VDKCJ1cmV0cHJvYmUvdHJpZ2dlcl9m
dW5jIikNCj4gK2ludCBoYW5kbGVfdXByb2JlX3JldHVybihzdHJ1Y3QgcHRfcmVncyAqY3R4KQ0K
PiArew0KPiArCWNvbnN0IGludCBrZXkgPSAzLCB2YWx1ZSA9IDQ7DQo+ICsNCj4gKwlicGZfbWFw
X3VwZGF0ZV9lbGVtKCZyZXN1bHRzX21hcCwgJmtleSwgJnZhbHVlLCAwKTsNCj4gKwlyZXR1cm4g
MDsNCj4gK30NCj4gKw0KPiArY2hhciBfbGljZW5zZVtdIFNFQygibGljZW5zZSIpID0gIkdQTCI7
DQo+ICtfX3UzMiBfdmVyc2lvbiBTRUMoInZlcnNpb24iKSA9IDE7DQo+IA0K
