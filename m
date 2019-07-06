Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBB361251
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 19:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfGFRTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 13:19:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61250 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726698AbfGFRTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 13:19:10 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x66HIgRJ005830;
        Sat, 6 Jul 2019 10:18:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dGY9qOTTJCx3FgLUkvjDjW75bVk64ZPCVJcxFKYDP64=;
 b=kdyiKaOZFww4g8B+TZone8q5nCy7RqzdN2SQzJArFq9X5LsCiwt5U9maXaWiT5y/BaXd
 Ci/p1VUMgyOPt2IzsE0Gxm+iQ8qlWFo5oS277+ivEqnK1r78m+4ZWLnn/UD0izCA07zK
 4sutwdKIhXaw/W51YyCZd7HcxEch4BzjtJQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2tjq4r993w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 06 Jul 2019 10:18:50 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 6 Jul 2019 10:18:49 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 6 Jul 2019 10:18:49 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 6 Jul 2019 10:18:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGY9qOTTJCx3FgLUkvjDjW75bVk64ZPCVJcxFKYDP64=;
 b=dfo1BWhvfYCcZf7SlFkIC3yzTCupWd7NcJ296GKeDk1t2RH+Jm06V9TLscaxq/pPIT2KNrTAw8wDFfVnPkJLPmD4tVqNg0ca7CZv6oC10204+WqYgyv9ViBNrd/JabbBwuxDs5i6pTgu70EbQFqN64qyqgjQRYIgrHnoh+Bq1MU=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2392.namprd15.prod.outlook.com (52.135.198.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Sat, 6 Jul 2019 17:18:47 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2052.019; Sat, 6 Jul 2019
 17:18:47 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v6 bpf-next 3/5] selftests/bpf: test perf buffer API
Thread-Topic: [PATCH v6 bpf-next 3/5] selftests/bpf: test perf buffer API
Thread-Index: AQHVM8B3C138QsIsL0eUJbVJ5Lyl/Ka91jkA
Date:   Sat, 6 Jul 2019 17:18:47 +0000
Message-ID: <a04cc2f1-a107-221e-4ea3-a4650826f325@fb.com>
References: <20190706060220.1801632-1-andriin@fb.com>
 <20190706060220.1801632-4-andriin@fb.com>
In-Reply-To: <20190706060220.1801632-4-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::46) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:c7d4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97cca445-4187-4b84-e2d4-08d702360163
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2392;
x-ms-traffictypediagnostic: BYAPR15MB2392:
x-microsoft-antispam-prvs: <BYAPR15MB2392EA8377C32C684371F2A1D3F40@BYAPR15MB2392.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:277;
x-forefront-prvs: 00909363D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(366004)(136003)(396003)(346002)(199004)(189003)(2501003)(7736002)(31686004)(2201001)(86362001)(256004)(14444005)(6246003)(25786009)(31696002)(68736007)(305945005)(8676002)(6486002)(5024004)(8936002)(81166006)(53936002)(229853002)(6512007)(6636002)(71200400001)(71190400001)(6436002)(2906002)(102836004)(36756003)(6506007)(5660300002)(66476007)(486006)(446003)(11346002)(46003)(476003)(316002)(186003)(52116002)(386003)(2616005)(14454004)(53546011)(76176011)(66446008)(81156014)(66556008)(64756008)(73956011)(99286004)(478600001)(66946007)(6116002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2392;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LqiupG5lyoFG5DlgFRrnG8xiBvm+R2f+p/HfSM8eyFPYDySKR3d4qGRXrDtl/l2v33GQlc8Wn1mJ4grPq1mANvbox4d0v0rtBYdGE74oFYXQC/++YJBcAkqY4jOGHgLI5XIENLGajr2WhX6l1EsvUfMKKQIJVYfmrxYsKGx7A8WQa6VjiS6hU4xJICvGTZBdW9PdRejZGH5Ie50rAGWmpru42HuK9msU6eSEwMgtc0c1mWZo4+UBRjZKDq3xPxQ3ojK113v76C3Jfgeu4SLMOIGawaxHBVuVarmvDSWj35/Ggbjli4YvQpit23w8kC2JshyATWgf/kJXtKCmGfnKqBVRfxCLiWbH19Qpy5QJDqA+7RCYDyHm1XdOPuy/ZV1myk2sSVPL03FqaicoezWWCzNRPZjbaM7S4H86mNS5Ln4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE81E8E775245749B19BD58D7B9F7326@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 97cca445-4187-4b84-e2d4-08d702360163
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2019 17:18:47.3965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2392
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-06_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907060229
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvNS8xOSAxMTowMiBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBBZGQgdGVz
dCB2ZXJpZnlpbmcgcGVyZiBidWZmZXIgQVBJIGZ1bmN0aW9uYWxpdHkuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0KPiBBY2tlZC1ieTogU29u
ZyBMaXUgPHNvbmdsaXVicmF2aW5nQGZiLmNvbT4NCj4gLS0tDQo+ICAgLi4uL3NlbGZ0ZXN0cy9i
cGYvcHJvZ190ZXN0cy9wZXJmX2J1ZmZlci5jICAgIHwgOTQgKysrKysrKysrKysrKysrKysrKw0K
PiAgIC4uLi9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3RfcGVyZl9idWZmZXIuYyAgICB8IDI1ICsr
KysrDQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCAxMTkgaW5zZXJ0aW9ucygrKQ0KPiAgIGNyZWF0ZSBt
b2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9wZXJmX2J1
ZmZlci5jDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2Jw
Zi9wcm9ncy90ZXN0X3BlcmZfYnVmZmVyLmMNCj4gDQo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0
aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9wZXJmX2J1ZmZlci5jIGIvdG9vbHMvdGVzdGlu
Zy9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvcGVyZl9idWZmZXIuYw0KPiBuZXcgZmlsZSBtb2Rl
IDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwMDAuLjY0NTU2YWIwZDFhOQ0KPiAtLS0gL2Rldi9u
dWxsDQo+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9nX3Rlc3RzL3BlcmZf
YnVmZmVyLmMNCj4gQEAgLTAsMCArMSw5NCBAQA0KPiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZp
ZXI6IEdQTC0yLjANCj4gKyNkZWZpbmUgX0dOVV9TT1VSQ0UNCj4gKyNpbmNsdWRlIDxwdGhyZWFk
Lmg+DQo+ICsjaW5jbHVkZSA8c2NoZWQuaD4NCj4gKyNpbmNsdWRlIDxzeXMvc29ja2V0Lmg+DQo+
ICsjaW5jbHVkZSA8dGVzdF9wcm9ncy5oPg0KPiArDQo+ICtzdGF0aWMgdm9pZCBvbl9zYW1wbGUo
dm9pZCAqY3R4LCBpbnQgY3B1LCB2b2lkICpkYXRhLCBfX3UzMiBzaXplKQ0KPiArew0KPiArCWlu
dCBjcHVfZGF0YSA9ICooaW50ICopZGF0YSwgZHVyYXRpb24gPSAwOw0KPiArCWNwdV9zZXRfdCAq
Y3B1X3NlZW4gPSBjdHg7DQo+ICsNCj4gKwlpZiAoY3B1X2RhdGEgIT0gY3B1KQ0KPiArCQlDSEVD
SyhjcHVfZGF0YSAhPSBjcHUsICJjaGVja19jcHVfZGF0YSIsDQo+ICsJCSAgICAgICJjcHVfZGF0
YSAlZCAhPSBjcHUgJWRcbiIsIGNwdV9kYXRhLCBjcHUpOw0KPiArDQo+ICsJQ1BVX1NFVChjcHUs
IGNwdV9zZWVuKTsNCj4gK30NCj4gKw0KPiArdm9pZCB0ZXN0X3BlcmZfYnVmZmVyKHZvaWQpDQo+
ICt7DQo+ICsJaW50IGVyciwgcHJvZ19mZCwgbnJfY3B1cywgaSwgZHVyYXRpb24gPSAwOw0KPiAr
CWNvbnN0IGNoYXIgKnByb2dfbmFtZSA9ICJrcHJvYmUvc3lzX25hbm9zbGVlcCI7DQo+ICsJY29u
c3QgY2hhciAqZmlsZSA9ICIuL3Rlc3RfcGVyZl9idWZmZXIubyI7DQo+ICsJc3RydWN0IHBlcmZf
YnVmZmVyX29wdHMgcGJfb3B0cyA9IHt9Ow0KPiArCXN0cnVjdCBicGZfbWFwICpwZXJmX2J1Zl9t
YXA7DQo+ICsJY3B1X3NldF90IGNwdV9zZXQsIGNwdV9zZWVuOw0KPiArCXN0cnVjdCBicGZfcHJv
Z3JhbSAqcHJvZzsNCj4gKwlzdHJ1Y3QgYnBmX29iamVjdCAqb2JqOw0KPiArCXN0cnVjdCBwZXJm
X2J1ZmZlciAqcGI7DQo+ICsJc3RydWN0IGJwZl9saW5rICpsaW5rOw0KPiArDQo+ICsJbnJfY3B1
cyA9IGxpYmJwZl9udW1fcG9zc2libGVfY3B1cygpOw0KPiArCWlmIChDSEVDSyhucl9jcHVzIDwg
MCwgIm5yX2NwdXMiLCAiZXJyICVkXG4iLCBucl9jcHVzKSkNCj4gKwkJcmV0dXJuOw0KPiArDQo+
ICsJLyogbG9hZCBwcm9ncmFtICovDQo+ICsJZXJyID0gYnBmX3Byb2dfbG9hZChmaWxlLCBCUEZf
UFJPR19UWVBFX0tQUk9CRSwgJm9iaiwgJnByb2dfZmQpOw0KPiArCWlmIChDSEVDSyhlcnIsICJv
YmpfbG9hZCIsICJlcnIgJWQgZXJybm8gJWRcbiIsIGVyciwgZXJybm8pKQ0KPiArCQlyZXR1cm47
DQo+ICsNCj4gKwlwcm9nID0gYnBmX29iamVjdF9fZmluZF9wcm9ncmFtX2J5X3RpdGxlKG9iaiwg
cHJvZ19uYW1lKTsNCj4gKwlpZiAoQ0hFQ0soIXByb2csICJmaW5kX3Byb2JlIiwgInByb2cgJyVz
JyBub3QgZm91bmRcbiIsIHByb2dfbmFtZSkpDQo+ICsJCWdvdG8gb3V0X2Nsb3NlOw0KPiArDQo+
ICsJLyogbG9hZCBtYXAgKi8NCj4gKwlwZXJmX2J1Zl9tYXAgPSBicGZfb2JqZWN0X19maW5kX21h
cF9ieV9uYW1lKG9iaiwgInBlcmZfYnVmX21hcCIpOw0KPiArCWlmIChDSEVDSyghcGVyZl9idWZf
bWFwLCAiZmluZF9wZXJmX2J1Zl9tYXAiLCAibm90IGZvdW5kXG4iKSkNCj4gKwkJZ290byBvdXRf
Y2xvc2U7DQo+ICsNCj4gKwkvKiBhdHRhY2gga3Byb2JlICovDQo+ICsJbGluayA9IGJwZl9wcm9n
cmFtX19hdHRhY2hfa3Byb2JlKHByb2csIGZhbHNlIC8qIHJldHByb2JlICovLA0KPiArCQkJCQkg
ICAgICAic3lzX25hbm9zbGVlcCIpOw0KDQpUaGUgYXR0YWNoIGZ1bmN0aW9uICJzeXNfbmFub3Ns
ZWVwIiB3b24ndCB3b3JrLiBZb3UgY2FuIGhhdmUgc29tZXRoaW5nDQpzaW1pbGFyIHRvIGF0dGFj
aF9wcm9iZS5jLg0KDQojaWZkZWYgX194ODZfNjRfXw0KI2RlZmluZSBTWVNfS1BST0JFX05BTUUg
Il9feDY0X3N5c19uYW5vc2xlZXAiDQojZWxzZQ0KI2RlZmluZSBTWVNfS1BST0JFX05BTUUgInN5
c19uYW5vc2xlZXAiDQojZW5kaWYNCg0KDQo+ICsJaWYgKENIRUNLKElTX0VSUihsaW5rKSwgImF0
dGFjaF9rcHJvYmUiLCAiZXJyICVsZFxuIiwgUFRSX0VSUihsaW5rKSkpDQo+ICsJCWdvdG8gb3V0
X2Nsb3NlOw0KPiArDQo+ICsJLyogc2V0IHVwIHBlcmYgYnVmZmVyICovDQo+ICsJcGJfb3B0cy5z
YW1wbGVfY2IgPSBvbl9zYW1wbGU7DQo+ICsJcGJfb3B0cy5jdHggPSAmY3B1X3NlZW47DQo+ICsJ
cGIgPSBwZXJmX2J1ZmZlcl9fbmV3KGJwZl9tYXBfX2ZkKHBlcmZfYnVmX21hcCksIDEsICZwYl9v
cHRzKTsNCj4gKwlpZiAoQ0hFQ0soSVNfRVJSKHBiKSwgInBlcmZfYnVmX19uZXciLCAiZXJyICVs
ZFxuIiwgUFRSX0VSUihwYikpKQ0KPiArCQlnb3RvIG91dF9kZXRhY2g7DQo+ICsNCj4gKwkvKiB0
cmlnZ2VyIGtwcm9iZSBvbiBldmVyeSBDUFUgKi8NCj4gKwlDUFVfWkVSTygmY3B1X3NlZW4pOw0K
PiArCWZvciAoaSA9IDA7IGkgPCBucl9jcHVzOyBpKyspIHsNCj4gKwkJQ1BVX1pFUk8oJmNwdV9z
ZXQpOw0KPiArCQlDUFVfU0VUKGksICZjcHVfc2V0KTsNCj4gKw0KPiArCQllcnIgPSBwdGhyZWFk
X3NldGFmZmluaXR5X25wKHB0aHJlYWRfc2VsZigpLCBzaXplb2YoY3B1X3NldCksDQo+ICsJCQkJ
CSAgICAgJmNwdV9zZXQpOw0KPiArCQlpZiAoZXJyICYmIENIRUNLKGVyciwgInNldF9hZmZpbml0
eSIsICJjcHUgIyVkLCBlcnIgJWRcbiIsDQo+ICsJCQkJIGksIGVycikpDQo+ICsJCQlnb3RvIG91
dF9kZXRhY2g7DQo+ICsNCj4gKwkJdXNsZWVwKDEpOw0KPiArCX0NCj4gKw0KPiArCS8qIHJlYWQg
cGVyZiBidWZmZXIgKi8NCj4gKwllcnIgPSBwZXJmX2J1ZmZlcl9fcG9sbChwYiwgMTAwKTsNCj4g
KwlpZiAoQ0hFQ0soZXJyIDwgMCwgInBlcmZfYnVmZmVyX19wb2xsIiwgImVyciAlZFxuIiwgZXJy
KSkNCj4gKwkJZ290byBvdXRfZnJlZV9wYjsNCj4gKw0KPiArCWlmIChDSEVDSyhDUFVfQ09VTlQo
JmNwdV9zZWVuKSAhPSBucl9jcHVzLCAic2Vlbl9jcHVfY250IiwNCj4gKwkJICAiZXhwZWN0ICVk
LCBzZWVuICVkXG4iLCBucl9jcHVzLCBDUFVfQ09VTlQoJmNwdV9zZWVuKSkpDQo+ICsJCWdvdG8g
b3V0X2ZyZWVfcGI7DQo+ICsNCj4gK291dF9mcmVlX3BiOg0KPiArCXBlcmZfYnVmZmVyX19mcmVl
KHBiKTsNCj4gK291dF9kZXRhY2g6DQo+ICsJYnBmX2xpbmtfX2Rlc3Ryb3kobGluayk7DQo+ICtv
dXRfY2xvc2U6DQo+ICsJYnBmX29iamVjdF9fY2xvc2Uob2JqKTsNCj4gK30NCj4gZGlmZiAtLWdp
dCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X3BlcmZfYnVmZmVyLmMg
Yi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9wZXJmX2J1ZmZlci5jDQo+
IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAwMC4uODc2YzI3ZGViNjVh
DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3By
b2dzL3Rlc3RfcGVyZl9idWZmZXIuYw0KPiBAQCAtMCwwICsxLDI1IEBADQo+ICsvLyBTUERYLUxp
Y2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiArLy8gQ29weXJpZ2h0IChjKSAyMDE5IEZhY2Vi
b29rDQo+ICsNCj4gKyNpbmNsdWRlIDxsaW51eC9wdHJhY2UuaD4NCj4gKyNpbmNsdWRlIDxsaW51
eC9icGYuaD4NCj4gKyNpbmNsdWRlICJicGZfaGVscGVycy5oIg0KPiArDQo+ICtzdHJ1Y3Qgew0K
PiArCV9fdWludCh0eXBlLCBCUEZfTUFQX1RZUEVfUEVSRl9FVkVOVF9BUlJBWSk7DQo+ICsJX191
aW50KGtleV9zaXplLCBzaXplb2YoaW50KSk7DQo+ICsJX191aW50KHZhbHVlX3NpemUsIHNpemVv
ZihpbnQpKTsNCj4gK30gcGVyZl9idWZfbWFwIFNFQygiLm1hcHMiKTsNCj4gKw0KPiArU0VDKCJr
cHJvYmUvc3lzX25hbm9zbGVlcCIpDQo+ICtpbnQgaGFuZGxlX3N5c19uYW5vc2xlZXBfZW50cnko
c3RydWN0IHB0X3JlZ3MgKmN0eCkNCj4gK3sNCj4gKwlpbnQgY3B1ID0gYnBmX2dldF9zbXBfcHJv
Y2Vzc29yX2lkKCk7DQo+ICsNCj4gKwlicGZfcGVyZl9ldmVudF9vdXRwdXQoY3R4LCAmcGVyZl9i
dWZfbWFwLCBCUEZfRl9DVVJSRU5UX0NQVSwNCj4gKwkJCSAgICAgICZjcHUsIHNpemVvZihjcHUp
KTsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKw0KPiArY2hhciBfbGljZW5zZVtdIFNFQygibGlj
ZW5zZSIpID0gIkdQTCI7DQo+ICtfX3UzMiBfdmVyc2lvbiBTRUMoInZlcnNpb24iKSA9IDE7DQo+
IA0K
