Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7D326DDA
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732631AbfEVTpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:45:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41780 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730184AbfEVTo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:44:59 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MJbiV7019804;
        Wed, 22 May 2019 12:44:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rMbR0PR+GSITOgg/2e7CfM4lwGZFj13nXurErtRhh7Y=;
 b=IEF509DETBebe9TN7vUNlXq2ioyA/VskZo/llyLy7KbzNi1JQaYyeRBZD6D93wjDyyTl
 0rJ9DMkMDog7hbRRdXNn9jkswR1TH59nZQY2z3hJ+QWcPJiZ+Epr6XRZb+Q6UvUaiKBt
 qvrQsWjL9w/L/ImIq7wDE1Pim1stvfEHQXA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn9bgry31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 May 2019 12:44:35 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 12:44:33 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 22 May 2019 12:44:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMbR0PR+GSITOgg/2e7CfM4lwGZFj13nXurErtRhh7Y=;
 b=NOQI08sgLJMqEN7pbd4v0GPkaB7R80cl9DjCpZxgxQV6oVVVV2j+fVPkZbOdJ38hozrDdPXMq7YjdeEAUvkPSRC7VsIqyobknBNIwsS7LSy47cfRu2zF5E55REZ6D3qPTj9jDjBtsG3hFIXuLrFYFV/NosfBd/oZeHUOUYhriWU=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2198.namprd15.prod.outlook.com (52.135.196.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Wed, 22 May 2019 19:44:32 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 19:44:32 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH bpf-next v2 3/3] tools/bpf: add a selftest for
 bpf_send_signal() helper
Thread-Topic: [PATCH bpf-next v2 3/3] tools/bpf: add a selftest for
 bpf_send_signal() helper
Thread-Index: AQHVEGC/AXMWZ1rZ1EW14tmo8WsUfKZ3gy0AgAAJm4A=
Date:   Wed, 22 May 2019 19:44:31 +0000
Message-ID: <72d75786-1cbd-e6d0-89e7-192f39d436f5@fb.com>
References: <20190522053900.1663459-1-yhs@fb.com>
 <20190522053903.1663924-1-yhs@fb.com> <20190522191006.GN10244@mini-arch>
In-Reply-To: <20190522191006.GN10244@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0045.namprd08.prod.outlook.com
 (2603:10b6:300:c0::19) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::abfc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22f11f7b-df3f-4b76-70b2-08d6deede900
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2198;
x-ms-traffictypediagnostic: BYAPR15MB2198:
x-microsoft-antispam-prvs: <BYAPR15MB2198072B2C1FE883AC724633D3000@BYAPR15MB2198.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(396003)(39860400002)(366004)(346002)(136003)(376002)(199004)(189003)(31686004)(46003)(11346002)(86362001)(446003)(476003)(99286004)(53546011)(486006)(76176011)(31696002)(52116002)(2616005)(6246003)(8676002)(81166006)(6512007)(6486002)(14444005)(256004)(81156014)(68736007)(6436002)(53936002)(54906003)(4326008)(229853002)(14454004)(5660300002)(8936002)(25786009)(478600001)(36756003)(2906002)(305945005)(102836004)(66556008)(71200400001)(71190400001)(7736002)(6506007)(386003)(186003)(316002)(6916009)(6116002)(64756008)(66446008)(66476007)(73956011)(66946007)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2198;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KVyunSqVP1V/8XMjHxhPKDjzywqZ2xUJ+CHKQKSii47h8eJMpjgC+lFaUG81PPfe2IvzJLMO2D6ceL9IszGjmvpbw1Mp2IS1UXPOEVDaKE+aDfZH/U02FblwQM2jYrCDP/uK8NqSns/ytipJpOfSDtpTr47IvQyCJUbFAzFFzffN21AWFKAPYVK1U6LJv80LIM5EquuLq2Xm09ZGyssuCQSnX5PNu3+NvFmUrkIDG0X5qEfPa8QnsvYOEUOrSL4W7XpHXlMBWQpf1UJVMsFX8mRZGmv3BG8hriiFmA3aIZYGsgu+5Uni+tJbAi/jPItVo9G8xcjZmNBP0XQLB9plcE50S9kU1RGW4SfoN7cfOf6u36/ZnNcogd70DiqamW2pU/POYHuvwK4hOZQXvL0wVskzyXe1pB/j48/oJINkp34=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47467A154E39E142BA2B4C0D438B9753@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f11f7b-df3f-4b76-70b2-08d6deede900
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 19:44:31.9877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2198
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220137
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjIvMTkgMTI6MTAgUE0sIFN0YW5pc2xhdiBGb21pY2hldiB3cm90ZToNCj4gT24g
MDUvMjEsIFlvbmdob25nIFNvbmcgd3JvdGU6DQo+PiBUaGUgdGVzdCBjb3ZlcmVkIGJvdGggbm1p
IGFuZCB0cmFjZXBvaW50IHBlcmYgZXZlbnRzLg0KPj4gICAgJCAuL3Rlc3Rfc2VuZF9zaWduYWxf
dXNlcg0KPj4gICAgdGVzdF9zZW5kX3NpZ25hbCAodHJhY2Vwb2ludCk6IE9LDQo+PiAgICB0ZXN0
X3NlbmRfc2lnbmFsIChwZXJmX2V2ZW50KTogT0sNCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBZb25n
aG9uZyBTb25nIDx5aHNAZmIuY29tPg0KPj4gLS0tDQo+PiAgIHRvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2JwZi9NYWtlZmlsZSAgICAgICAgICB8ICAgMyArLQ0KPj4gICB0b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9icGYvYnBmX2hlbHBlcnMuaCAgICAgfCAgIDEgKw0KPj4gICAuLi4vYnBmL3Byb2dz
L3Rlc3Rfc2VuZF9zaWduYWxfa2Vybi5jICAgICAgICAgfCAgNTEgKysrKysNCj4+ICAgLi4uL3Nl
bGZ0ZXN0cy9icGYvdGVzdF9zZW5kX3NpZ25hbF91c2VyLmMgICAgIHwgMjEyICsrKysrKysrKysr
KysrKysrKw0KPj4gICA0IGZpbGVzIGNoYW5nZWQsIDI2NiBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pDQo+PiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9i
cGYvcHJvZ3MvdGVzdF9zZW5kX3NpZ25hbF9rZXJuLmMNCj4+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0
IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X3NlbmRfc2lnbmFsX3VzZXIuYw0KPj4N
Cj4+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvTWFrZWZpbGUgYi90
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvTWFrZWZpbGUNCj4+IGluZGV4IDY2ZjJkY2ExZGVl
MS4uNWViNjM2OGE5NmEyIDEwMDY0NA0KPj4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMv
YnBmL01ha2VmaWxlDQo+PiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvTWFrZWZp
bGUNCj4+IEBAIC0yMyw3ICsyMyw4IEBAIFRFU1RfR0VOX1BST0dTID0gdGVzdF92ZXJpZmllciB0
ZXN0X3RhZyB0ZXN0X21hcHMgdGVzdF9scnVfbWFwIHRlc3RfbHBtX21hcCB0ZXN0DQo+PiAgIAl0
ZXN0X2FsaWduIHRlc3RfdmVyaWZpZXJfbG9nIHRlc3RfZGV2X2Nncm91cCB0ZXN0X3RjcGJwZl91
c2VyIFwNCj4+ICAgCXRlc3Rfc29jayB0ZXN0X2J0ZiB0ZXN0X3NvY2ttYXAgdGVzdF9saXJjX21v
ZGUyX3VzZXIgZ2V0X2Nncm91cF9pZF91c2VyIFwNCj4+ICAgCXRlc3Rfc29ja2V0X2Nvb2tpZSB0
ZXN0X2Nncm91cF9zdG9yYWdlIHRlc3Rfc2VsZWN0X3JldXNlcG9ydCB0ZXN0X3NlY3Rpb25fbmFt
ZXMgXA0KPj4gLQl0ZXN0X25ldGNudCB0ZXN0X3RjcG5vdGlmeV91c2VyIHRlc3Rfc29ja19maWVs
ZHMgdGVzdF9zeXNjdGwNCj4+ICsJdGVzdF9uZXRjbnQgdGVzdF90Y3Bub3RpZnlfdXNlciB0ZXN0
X3NvY2tfZmllbGRzIHRlc3Rfc3lzY3RsIFwNCj4+ICsJdGVzdF9zZW5kX3NpZ25hbF91c2VyDQo+
PiAgIA0KPj4gICBCUEZfT0JKX0ZJTEVTID0gJChwYXRzdWJzdCAlLmMsJS5vLCAkKG5vdGRpciAk
KHdpbGRjYXJkIHByb2dzLyouYykpKQ0KPj4gICBURVNUX0dFTl9GSUxFUyA9ICQoQlBGX09CSl9G
SUxFUykNCj4+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvYnBmX2hl
bHBlcnMuaCBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9icGZfaGVscGVycy5oDQo+PiBp
bmRleCA1ZjZmOWU3YWJhMmEuLmNiMDI1MjFiOGU1OCAxMDA2NDQNCj4+IC0tLSBhL3Rvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2JwZi9icGZfaGVscGVycy5oDQo+PiArKysgYi90b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9icGYvYnBmX2hlbHBlcnMuaA0KPj4gQEAgLTIxNiw2ICsyMTYsNyBAQCBzdGF0
aWMgdm9pZCAqKCpicGZfc2tfc3RvcmFnZV9nZXQpKHZvaWQgKm1hcCwgc3RydWN0IGJwZl9zb2Nr
ICpzaywNCj4+ICAgCSh2b2lkICopIEJQRl9GVU5DX3NrX3N0b3JhZ2VfZ2V0Ow0KPj4gICBzdGF0
aWMgaW50ICgqYnBmX3NrX3N0b3JhZ2VfZGVsZXRlKSh2b2lkICptYXAsIHN0cnVjdCBicGZfc29j
ayAqc2spID0NCj4+ICAgCSh2b2lkICopQlBGX0ZVTkNfc2tfc3RvcmFnZV9kZWxldGU7DQo+PiAr
c3RhdGljIGludCAoKmJwZl9zZW5kX3NpZ25hbCkodW5zaWduZWQgc2lnKSA9ICh2b2lkICopQlBG
X0ZVTkNfc2VuZF9zaWduYWw7DQo+PiAgIA0KPj4gICAvKiBsbHZtIGJ1aWx0aW4gZnVuY3Rpb25z
IHRoYXQgZUJQRiBDIHByb2dyYW0gbWF5IHVzZSB0bw0KPj4gICAgKiBlbWl0IEJQRl9MRF9BQlMg
YW5kIEJQRl9MRF9JTkQgaW5zdHJ1Y3Rpb25zDQo+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGlu
Zy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3Rfc2VuZF9zaWduYWxfa2Vybi5jIGIvdG9vbHMvdGVz
dGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3Rfc2VuZF9zaWduYWxfa2Vybi5jDQo+PiBuZXcg
ZmlsZSBtb2RlIDEwMDY0NA0KPj4gaW5kZXggMDAwMDAwMDAwMDAwLi40NWExYTFhMmMzNDUNCj4+
IC0tLSAvZGV2L251bGwNCj4+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9n
cy90ZXN0X3NlbmRfc2lnbmFsX2tlcm4uYw0KPj4gQEAgLTAsMCArMSw1MSBAQA0KPj4gKy8vIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+PiArLy8gQ29weXJpZ2h0IChjKSAyMDE5
IEZhY2Vib29rDQo+PiArI2luY2x1ZGUgPGxpbnV4L2JwZi5oPg0KPj4gKyNpbmNsdWRlIDxsaW51
eC92ZXJzaW9uLmg+DQo+PiArI2luY2x1ZGUgImJwZl9oZWxwZXJzLmgiDQo+PiArDQo+PiArc3Ry
dWN0IGJwZl9tYXBfZGVmIFNFQygibWFwcyIpIGluZm9fbWFwID0gew0KPj4gKwkudHlwZSA9IEJQ
Rl9NQVBfVFlQRV9BUlJBWSwNCj4+ICsJLmtleV9zaXplID0gc2l6ZW9mKF9fdTMyKSwNCj4+ICsJ
LnZhbHVlX3NpemUgPSBzaXplb2YoX191NjQpLA0KPj4gKwkubWF4X2VudHJpZXMgPSAxLA0KPj4g
K307DQo+PiArDQo+PiArQlBGX0FOTk9UQVRFX0tWX1BBSVIoaW5mb19tYXAsIF9fdTMyLCBfX3U2
NCk7DQo+PiArDQo+PiArc3RydWN0IGJwZl9tYXBfZGVmIFNFQygibWFwcyIpIHN0YXR1c19tYXAg
PSB7DQo+PiArCS50eXBlID0gQlBGX01BUF9UWVBFX0FSUkFZLA0KPj4gKwkua2V5X3NpemUgPSBz
aXplb2YoX191MzIpLA0KPj4gKwkudmFsdWVfc2l6ZSA9IHNpemVvZihfX3U2NCksDQo+PiArCS5t
YXhfZW50cmllcyA9IDEsDQo+PiArfTsNCj4+ICsNCj4+ICtCUEZfQU5OT1RBVEVfS1ZfUEFJUihz
dGF0dXNfbWFwLCBfX3UzMiwgX191NjQpOw0KPj4gKw0KPj4gK1NFQygic2VuZF9zaWduYWxfZGVt
byIpDQo+PiAraW50IGJwZl9zZW5kX3NpZ25hbF90ZXN0KHZvaWQgKmN0eCkNCj4+ICt7DQo+PiAr
CV9fdTY0ICppbmZvX3ZhbCwgKnN0YXR1c192YWw7DQo+PiArCV9fdTMyIGtleSA9IDAsIHBpZCwg
c2lnOw0KPj4gKwlpbnQgcmV0Ow0KPj4gKw0KPj4gKwlzdGF0dXNfdmFsID0gYnBmX21hcF9sb29r
dXBfZWxlbSgmc3RhdHVzX21hcCwgJmtleSk7DQo+PiArCWlmICghc3RhdHVzX3ZhbCB8fCAqc3Rh
dHVzX3ZhbCAhPSAwKQ0KPj4gKwkJcmV0dXJuIDA7DQo+PiArDQo+PiArCWluZm9fdmFsID0gYnBm
X21hcF9sb29rdXBfZWxlbSgmaW5mb19tYXAsICZrZXkpOw0KPj4gKwlpZiAoIWluZm9fdmFsIHx8
ICppbmZvX3ZhbCA9PSAwKQ0KPj4gKwkJcmV0dXJuIDA7DQo+PiArDQo+PiArCXNpZyA9ICppbmZv
X3ZhbCA+PiAzMjsNCj4+ICsJcGlkID0gKmluZm9fdmFsICYgMHhmZmZmRkZGRjsNCj4+ICsNCj4+
ICsJaWYgKChicGZfZ2V0X2N1cnJlbnRfcGlkX3RnaWQoKSA+PiAzMikgPT0gcGlkKSB7DQo+PiAr
CQlyZXQgPSBicGZfc2VuZF9zaWduYWwoc2lnKTsNCj4+ICsJCWlmIChyZXQgPT0gMCkNCj4+ICsJ
CQkqc3RhdHVzX3ZhbCA9IDE7DQo+PiArCX0NCj4+ICsNCj4+ICsJcmV0dXJuIDA7DQo+PiArfQ0K
Pj4gK2NoYXIgX19saWNlbnNlW10gU0VDKCJsaWNlbnNlIikgPSAiR1BMIjsNCj4+IGRpZmYgLS1n
aXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9zZW5kX3NpZ25hbF91c2VyLmMg
Yi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9zZW5kX3NpZ25hbF91c2VyLmMNCj4+
IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+PiBpbmRleCAwMDAwMDAwMDAwMDAuLjBiZDBmNzY3NDg2
MA0KPj4gLS0tIC9kZXYvbnVsbA0KPiBbLi5dDQo+PiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9icGYvdGVzdF9zZW5kX3NpZ25hbF91c2VyLmMNCj4gQW55IHJlYXNvbiB5b3UgZGlkbid0
IHB1dCBpdCB1bmRlciBicGYvcHJvZ190ZXN0cz8NCg0KVGhlIG9ubHkgcmVhc29uIEkgcHV0IGl0
IGFzIGEgc3RhbmRhbG9uZSB0ZXN0IGlzDQp0aGF0IHRoZSBwcm9ncmFtIHJlY2VpdmVzIHNpZ25h
bHMgYW5kIHRyaWVzIHRvDQptaW5pbWl6ZSBwb3RlbnRpYWwgaW1wYWN0IG9uIG90aGVyIHRlc3Rz
Lg0KDQpCdXQgaXQgbWlnaHQgYmUgb2theSBhcyB0aGUgc2lnbmFsIGlzIHNlbnQgdG8NCmNoaWxk
IHByb2Nlc3MuDQoNCj4gVGhhdCB3YXkgeW91IGRvbid0IG5lZWQgdG8gZGVmaW5lIHlvdXIgb3du
IENIRUNLIG1hY3JvIGFuZA0KPiBjYXJlIGFib3V0IHRoZSBpbmNsdWRlcy4NCg0KUmlnaHQuIEkg
d2lsbCB0cnkgdG8gdXNlIGJwZi9wcm9nX3Rlc3RzIGluZnJhc3RydWN0dXJlDQppbiB0aGUgbmV4
dCByZXZpc2lvbi4NCg==
