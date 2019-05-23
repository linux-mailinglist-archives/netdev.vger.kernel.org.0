Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8153275D0
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 07:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbfEWFxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 01:53:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49792 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725806AbfEWFxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 01:53:22 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4N5lqdT005238;
        Wed, 22 May 2019 22:53:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kIWmlUXgYIR4OL8fxsb2MNGg4E2F/JpzYc/fAWsznH8=;
 b=FE1/KQ6Pzzew7/BQ/gBUV4QA0nQ/O9OGZXXnGafHsm26v+IdApZ7awPFmbwqXl26nVtK
 BnoWscUJwGvEWBIa+/Vdbeh/eJlAa7PaG16/9JtHYWStmby0GTShgSOuN2hTI9waV6gG
 E33xkj+yxgq5kRi+Fn6ccNNYA5veA7aR8HU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn9bgtkj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 22:53:01 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 22 May 2019 22:53:00 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 22 May 2019 22:53:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIWmlUXgYIR4OL8fxsb2MNGg4E2F/JpzYc/fAWsznH8=;
 b=CnK8JZqOkjS3MQbPWg+wLT6sDV7hW+06aSzfTmszFKBhwNkeUSumj4DnOFqjt1lcIo6ETTBoakVUG1o58zZezDuj8SVky+F0c2DNjjyz/TG4BlKvexJxydiXQbjS57yyk0MDXuLepADo2ZDISPD1lTA+BnyjbuBEK68apuTQ8bk=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2920.namprd15.prod.outlook.com (20.178.236.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Thu, 23 May 2019 05:52:58 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 05:52:58 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Roman Gushchin <guro@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Topic: [PATCH v2 bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Index: AQHVEPUtUUkH/nhO2UeBDfLyvw3JgKZ4NZuA
Date:   Thu, 23 May 2019 05:52:58 +0000
Message-ID: <5b0d892f-c2f0-a53e-045e-8364841e192a@fb.com>
References: <20190522232051.2938491-1-guro@fb.com>
 <20190522232051.2938491-5-guro@fb.com>
In-Reply-To: <20190522232051.2938491-5-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0051.namprd17.prod.outlook.com
 (2603:10b6:300:93::13) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::c87a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f8076eb-0188-4f31-a0be-08d6df42e86c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2920;
x-ms-traffictypediagnostic: BYAPR15MB2920:
x-microsoft-antispam-prvs: <BYAPR15MB29205E0510C409472B43FDACD3010@BYAPR15MB2920.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(136003)(39860400002)(346002)(396003)(199004)(189003)(31696002)(53546011)(25786009)(76176011)(102836004)(2501003)(386003)(486006)(2616005)(476003)(46003)(11346002)(446003)(86362001)(6506007)(81166006)(53936002)(81156014)(52116002)(6246003)(54906003)(110136005)(229853002)(8936002)(14454004)(478600001)(8676002)(68736007)(99286004)(4326008)(6486002)(64756008)(6436002)(7736002)(6512007)(6116002)(66446008)(2906002)(36756003)(66556008)(66946007)(73956011)(66476007)(5024004)(5660300002)(71190400001)(31686004)(71200400001)(186003)(305945005)(256004)(14444005)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2920;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LACel2GebkBUBaJHfmc5LAlRfUUFGQjw/97LfxKQOHRp4D8kFbKOUffzPrwE1dJlXyJKDIIK6suINmwgRgD7G8+CnR8eNYt7oowVdKvEMiZjtGEO24l03tGJq7J1ZQ0wZl8E5tvv2f3xmTRdEUjKX/ADiu8EN3SojyhYbJmzuQmPNdHzxJPPyikgENTsevXm4jTOgNIUvASoEp32H8J+knDS7w1aV9+RFlqwCiApX+y4J5T0kSzcfAKYNTkV1q/8PCF8XZC8L7QnvHEk9hmnAdcIordAhcA1bTFzw+1xb5dXh/5esDXt3eCrJrl7SZpqsZqNp70BfZOWhAao0Fu74gP9y3UuvmaIqP2cjxy//cRP8/t5uvCgAcoc7tmwO53p0df3KxF9IBdAAkWy8/4jokAtb/TKbKNEK244Z1d/dtg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFD91916136DD44FAE7B4029D3A450A7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f8076eb-0188-4f31-a0be-08d6df42e86c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 05:52:58.2660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2920
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=701 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjIvMTkgNDoyMCBQTSwgUm9tYW4gR3VzaGNoaW4gd3JvdGU6DQo+IEFkZCBhIGtz
ZWxmdGVzdCB0byBjb3ZlciBicGYgYXV0by1kZXRhY2htZW50IGZ1bmN0aW9uYWxpdHkuDQo+IFRo
ZSB0ZXN0IGNyZWF0ZXMgYSBjZ3JvdXAsIGFzc29jaWF0ZXMgc29tZSByZXNvdXJjZXMgd2l0aCBp
dCwNCj4gYXR0YWNoZXMgYSBjb3VwbGUgb2YgYnBmIHByb2dyYW1zIGFuZCBkZWxldGVzIHRoZSBj
Z3JvdXAuDQo+IA0KPiBUaGVuIGl0IGNoZWNrcyB0aGF0IGJwZiBwcm9ncmFtcyBhcmUgZ29pbmcg
YXdheSBpbiA1IHNlY29uZHMuDQo+IA0KPiBFeHBlY3RlZCBvdXRwdXQ6DQo+ICAgICQgLi90ZXN0
X2Nncm91cF9hdHRhY2gNCj4gICAgI292ZXJyaWRlOlBBU1MNCj4gICAgI211bHRpOlBBU1MNCj4g
ICAgI2F1dG9kZXRhY2g6UEFTUw0KPiAgICB0ZXN0X2Nncm91cF9hdHRhY2g6UEFTUw0KPiANCj4g
T24gYSBrZXJuZWwgd2l0aG91dCBhdXRvLWRldGFjaGluZzoNCj4gICAgJCAuL3Rlc3RfY2dyb3Vw
X2F0dGFjaA0KPiAgICAjb3ZlcnJpZGU6UEFTUw0KPiAgICAjbXVsdGk6UEFTUw0KPiAgICAjYXV0
b2RldGFjaDpGQUlMDQo+ICAgIHRlc3RfY2dyb3VwX2F0dGFjaDpGQUlMDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBSb21hbiBHdXNoY2hpbiA8Z3Vyb0BmYi5jb20+DQo+IC0tLQ0KPiAgIC4uLi9zZWxm
dGVzdHMvYnBmL3Rlc3RfY2dyb3VwX2F0dGFjaC5jICAgICAgICB8IDk5ICsrKysrKysrKysrKysr
KysrKy0NCj4gICAxIGZpbGUgY2hhbmdlZCwgOTggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2Nn
cm91cF9hdHRhY2guYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2Nncm91cF9h
dHRhY2guYw0KPiBpbmRleCA5M2Q0ZmUyOTVlN2QuLmJjNWJkMGYxNzI4ZSAxMDA2NDQNCj4gLS0t
IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3RfY2dyb3VwX2F0dGFjaC5jDQo+ICsr
KyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2Nncm91cF9hdHRhY2guYw0KPiBA
QCAtNDU2LDkgKzQ1NiwxMDYgQEAgc3RhdGljIGludCB0ZXN0X211bHRpcHJvZyh2b2lkKQ0KPiAg
IAlyZXR1cm4gcmM7DQo+ICAgfQ0KPiAgIA0KPiArc3RhdGljIGludCB0ZXN0X2F1dG9kZXRhY2go
dm9pZCkNCj4gK3sNCj4gKwlfX3UzMiBwcm9nX2NudCA9IDQsIGF0dGFjaF9mbGFnczsNCj4gKwlp
bnQgYWxsb3dfcHJvZ1syXSA9IHswfTsNCj4gKwlfX3UzMiBwcm9nX2lkc1syXSA9IHswfTsNCj4g
KwlpbnQgY2cgPSAwLCBpLCByYyA9IC0xOw0KPiArCXZvaWQgKnB0ciA9IE5VTEw7DQo+ICsJaW50
IGF0dGVtcHRzOw0KPiArDQo+ICsNCkFsc28gZXh0cmEgbGluZSBoZXJlLg0KDQo+ICsJZm9yIChp
ID0gMDsgaSA8IEFSUkFZX1NJWkUoYWxsb3dfcHJvZyk7IGkrKykgew0KPiArCQlhbGxvd19wcm9n
W2ldID0gcHJvZ19sb2FkX2NudCgxLCAxIDw8IGkpOw0KPiArCQlpZiAoIWFsbG93X3Byb2dbaV0p
DQo+ICsJCQlnb3RvIGVycjsNCj4gKwl9DQo+ICsNCj4gKwlpZiAoc2V0dXBfY2dyb3VwX2Vudmly
b25tZW50KCkpDQo+ICsJCWdvdG8gZXJyOw0KPiArDQo+ICsJLyogY3JlYXRlIGEgY2dyb3VwLCBh
dHRhY2ggdHdvIHByb2dyYW1zIGFuZCByZW1lbWJlciB0aGVpciBpZHMgKi8NCj4gKwljZyA9IGNy
ZWF0ZV9hbmRfZ2V0X2Nncm91cCgiL2NnX2F1dG9kZXRhY2giKTsNClsuLi5dDQo+ICsNCj4gICBp
bnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpDQo+ICAgew0KPiAtCWludCAoKnRlc3RzW10p
KHZvaWQpID0ge3Rlc3RfZm9vX2JhciwgdGVzdF9tdWx0aXByb2d9Ow0KPiArCWludCAoKnRlc3Rz
W10pKHZvaWQpID0gew0KPiArCQl0ZXN0X2Zvb19iYXIsDQo+ICsJCXRlc3RfbXVsdGlwcm9nLA0K
PiArCQl0ZXN0X2F1dG9kZXRhY2gsDQo+ICsJfTsNCj4gICAJaW50IGVycm9ycyA9IDA7DQo+ICAg
CWludCBpOw0KPiAgIA0KPiANCg==
