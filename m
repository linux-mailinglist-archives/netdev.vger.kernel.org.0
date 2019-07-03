Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E73F5DCBA
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 05:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfGCDE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 23:04:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6958 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727049AbfGCDE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 23:04:58 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6332CNV009590;
        Tue, 2 Jul 2019 20:04:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9AYLO9ASELn0D7E5DC//s9kQbzWmpMYOstCY8UNsIFE=;
 b=SbEe8EqQygDbep9lQdDQ6X2x5WeY/R8lAbBn1fkvRQKpgxy3ZH4LgIVX72EU7AS6ZrEF
 ymnfTj8clI5ca1CYUwF95bjF7RL0G1eHtoKbXHAsyo/td31fMW7H+Hr08W1iMEqKuDGZ
 xm8fswETczeHBZojXeGs/jgMDOpjlgskHLc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2tga3r2bqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Jul 2019 20:04:33 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 2 Jul 2019 20:04:32 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 2 Jul 2019 20:04:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AYLO9ASELn0D7E5DC//s9kQbzWmpMYOstCY8UNsIFE=;
 b=WKSCOPze1/vsUm8OG3Ru44pv+Dvf9ARoi+gmpKisI58RyXJ0T6cTw8NxpcpiWvzbavOmXZCp+M1PtHzGgHxgmq0Q288NdGbIaaY47/j8CkGyq2L4klc42eDUQqhDnlfhqo0dNjSuG9jHkTQ6xl/tijHE+fYJ8CG2nX1hjrIWXEs=
Received: from BYAPR15MB2311.namprd15.prod.outlook.com (52.135.197.145) by
 BYAPR15MB2967.namprd15.prod.outlook.com (20.178.237.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Wed, 3 Jul 2019 03:04:31 +0000
Received: from BYAPR15MB2311.namprd15.prod.outlook.com
 ([fe80::849a:6325:7aee:17de]) by BYAPR15MB2311.namprd15.prod.outlook.com
 ([fe80::849a:6325:7aee:17de%6]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 03:04:31 +0000
From:   Lawrence Brakmo <brakmo@fb.com>
To:     Y Song <ys114321@gmail.com>, Stanislav Fomichev <sdf@google.com>
CC:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "Soheil Hassas Yeganeh" <soheil@google.com>
Subject: Re: [PATCH bpf-next v2 0/8] bpf: TCP RTT sock_ops bpf callback
Thread-Topic: [PATCH bpf-next v2 0/8] bpf: TCP RTT sock_ops bpf callback
Thread-Index: AQHVMPE5/cVpphylzUetGXhX7OOc+qa3nKeAgAAkLQA=
Date:   Wed, 3 Jul 2019 03:04:31 +0000
Message-ID: <0E380C87-29CC-4F4C-869B-22C1A18F9B35@fb.com>
References: <20190702161403.191066-1-sdf@google.com>
 <CAH3MdRXz-AHMuNQNWhnrxCrZhD9xKi44HiQdMh99R1FGaFYnhA@mail.gmail.com>
In-Reply-To: <CAH3MdRXz-AHMuNQNWhnrxCrZhD9xKi44HiQdMh99R1FGaFYnhA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1a.0.190609
x-originating-ip: [2620:10d:c090:180::1:20cc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5398688c-2fd8-4139-1349-08d6ff632b90
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2967;
x-ms-traffictypediagnostic: BYAPR15MB2967:
x-microsoft-antispam-prvs: <BYAPR15MB2967D564B94D22BEE845ABBDA9FB0@BYAPR15MB2967.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(396003)(366004)(39860400002)(376002)(346002)(136003)(199004)(189003)(46003)(7416002)(102836004)(2906002)(8676002)(14454004)(73956011)(2616005)(36756003)(33656002)(66476007)(66556008)(316002)(66446008)(76116006)(6506007)(8936002)(81156014)(91956017)(5660300002)(6512007)(64756008)(66946007)(53936002)(6246003)(53546011)(81166006)(305945005)(476003)(86362001)(54906003)(110136005)(11346002)(76176011)(71200400001)(4326008)(6436002)(7736002)(71190400001)(25786009)(58126008)(6116002)(99286004)(446003)(6486002)(229853002)(256004)(186003)(478600001)(68736007)(486006)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2967;H:BYAPR15MB2311.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TUIvAzq3YNxW2XkKocuLYUTGKLq6sedBxlM+SV6cBER04bjroc5B+Wg6Ks6FKVKZGs3oKyHBnGBAei7a3getoUYSWDeTlRr3cNntH+6CMTBk9IJT05rvW9D6zsVfKmTeGFjIESsGWNotKYaY0LV5zQow5sTNSTg7ICeKJlhOuXSMG4sminGUuf79fVl9NNTE6ggIrntqDbgKAb+Wrmpo4Bj5l9kohRPs93B2R7mnIFoMwrJNc/Zk6ZSfhXWd6AAc8iXdhhZPo+AslPwI7zlbLn5R+9uE3aegLydeh/JumfkrcN/729cPjLNI5cYuHPmZDD3LohIhrZWySG9MYXNrmiM/zh1JLppo7HFhz6gevFhGF/iREn/fnrBsErMugIwJIYeEJNCl+STBjuHyOgf26gJJmmFpMzbvtiQZxq1KWtE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1ACEC932C278124388E0E54E3A3C05FB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5398688c-2fd8-4139-1349-08d6ff632b90
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 03:04:31.5702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: brakmo@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2967
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907030035
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu79PbiA3LzIvMTksIDEwOjU1IEFNLCAibmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZyBv
biBiZWhhbGYgb2YgWSBTb25nIiA8bmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZyBvbiBiZWhh
bGYgb2YgeXMxMTQzMjFAZ21haWwuY29tPiB3cm90ZToNCg0KICAgIE9uIFR1ZSwgSnVsIDIsIDIw
MTkgYXQgOToxNCBBTSBTdGFuaXNsYXYgRm9taWNoZXYgPHNkZkBnb29nbGUuY29tPiB3cm90ZToN
CiAgICA+DQogICAgPiBDb25nZXN0aW9uIGNvbnRyb2wgdGVhbSB3b3VsZCBsaWtlIHRvIGhhdmUg
YSBwZXJpb2RpYyBjYWxsYmFjayB0bw0KICAgID4gdHJhY2sgc29tZSBUQ1Agc3RhdGlzdGljcy4g
TGV0J3MgYWRkIGEgc29ja19vcHMgY2FsbGJhY2sgdGhhdCBjYW4gYmUNCiAgICA+IHNlbGVjdGl2
ZWx5IGVuYWJsZWQgb24gYSBzb2NrZXQgYnkgc29ja2V0IGJhc2lzIGFuZCBpcyBleGVjdXRlZCBm
b3INCiAgICA+IGV2ZXJ5IFJUVC4gQlBGIHByb2dyYW0gZnJlcXVlbmN5IGNhbiBiZSBmdXJ0aGVy
IGNvbnRyb2xsZWQgYnkgY2FsbGluZw0KICAgID4gYnBmX2t0aW1lX2dldF9ucyBhbmQgYmFpbGlu
ZyBvdXQgZWFybHkuDQogICAgPg0KICAgID4gSSBydW4gbmVwZXIgdGNwX3N0cmVhbSBhbmQgdGNw
X3JyIHRlc3RzIHdpdGggdGhlIHNhbXBsZSBwcm9ncmFtDQogICAgPiBmcm9tIHRoZSBsYXN0IHBh
dGNoIGFuZCBkaWRuJ3Qgb2JzZXJ2ZSBhbnkgbm90aWNlYWJsZSBwZXJmb3JtYW5jZQ0KICAgID4g
ZGlmZmVyZW5jZS4NCiAgICA+DQogICAgPiB2MjoNCiAgICA+ICogYWRkIGEgY29tbWVudCBhYm91
dCBzZWNvbmQgYWNjZXB0KCkgaW4gc2VsZnRlc3QgKFlvbmdob25nIFNvbmcpDQogICAgPiAqIHJl
ZmVyIHRvIHRjcF9icGYucmVhZG1lIGluIHNhbXBsZSBwcm9ncmFtIChZb25naG9uZyBTb25nKQ0K
ICAgID4NCiAgICA+IFN1Z2dlc3RlZC1ieTogRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUu
Y29tPg0KICAgID4gQ2M6IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCiAgICA+
IENjOiBQcml5YXJhbmphbiBKaGEgPHByaXlhcmpoYUBnb29nbGUuY29tPg0KICAgID4gQ2M6IFl1
Y2h1bmcgQ2hlbmcgPHljaGVuZ0Bnb29nbGUuY29tPg0KICAgID4gQ2M6IFNvaGVpbCBIYXNzYXMg
WWVnYW5laCA8c29oZWlsQGdvb2dsZS5jb20+DQogICAgPiBBY2tlZC1ieTogU29oZWlsIEhhc3Nh
cyBZZWdhbmVoIDxzb2hlaWxAZ29vZ2xlLmNvbT4NCiAgICA+IEFja2VkLWJ5OiBZdWNodW5nIENo
ZW5nIDx5Y2hlbmdAZ29vZ2xlLmNvbT4NCiAgICANCiAgICBBY2sgZm9yIHRoZSB3aG9sZSBzZXJp
ZXMuDQogICAgQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQoNClRoYW5rcywg
dGhpcyBpcyBhIHZlcnkgbmljZSBmZWF0dXJlIQ0KICAgIA0KQWNrIGZvciB0aGUgd2hvbGUgc2Vy
aWVzLg0KQWNrZWQtYnk6IExhd3JlbmNlIEJyYWttbyA8YnJha21vQGZiLmNvbT4NCg0KICAgID4N
CiAgICA+IFN0YW5pc2xhdiBGb21pY2hldiAoOCk6DQogICAgPiAgIGJwZjogYWRkIEJQRl9DR1JP
VVBfU09DS19PUFMgY2FsbGJhY2sgdGhhdCBpcyBleGVjdXRlZCBvbiBldmVyeSBSVFQNCiAgICA+
ICAgYnBmOiBzcGxpdCBzaGFyZWQgYnBmX3RjcF9zb2NrIGFuZCBicGZfc29ja19vcHMgaW1wbGVt
ZW50YXRpb24NCiAgICA+ICAgYnBmOiBhZGQgZHNhY2tfZHVwcy9kZWxpdmVyZWR7LF9jZX0gdG8g
YnBmX3RjcF9zb2NrDQogICAgPiAgIGJwZjogYWRkIGljc2tfcmV0cmFuc21pdHMgdG8gYnBmX3Rj
cF9zb2NrDQogICAgPiAgIGJwZi90b29sczogc3luYyBicGYuaA0KICAgID4gICBzZWxmdGVzdHMv
YnBmOiB0ZXN0IEJQRl9TT0NLX09QU19SVFRfQ0INCiAgICA+ICAgc2FtcGxlcy9icGY6IGFkZCBz
YW1wbGUgcHJvZ3JhbSB0aGF0IHBlcmlvZGljYWxseSBkdW1wcyBUQ1Agc3RhdHMNCiAgICA+ICAg
c2FtcGxlcy9icGY6IGZpeCB0Y3BfYnBmLnJlYWRtZSBkZXRhY2ggY29tbWFuZA0KICAgID4NCiAg
ICA+ICBpbmNsdWRlL25ldC90Y3AuaCAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA4ICsN
CiAgICA+ICBpbmNsdWRlL3VhcGkvbGludXgvYnBmLmggICAgICAgICAgICAgICAgICAgIHwgIDEy
ICstDQogICAgPiAgbmV0L2NvcmUvZmlsdGVyLmMgICAgICAgICAgICAgICAgICAgICAgICAgICB8
IDIwNyArKysrKysrKysrKy0tLS0tDQogICAgPiAgbmV0L2lwdjQvdGNwX2lucHV0LmMgICAgICAg
ICAgICAgICAgICAgICAgICB8ICAgNCArDQogICAgPiAgc2FtcGxlcy9icGYvTWFrZWZpbGUgICAg
ICAgICAgICAgICAgICAgICAgICB8ICAgMSArDQogICAgPiAgc2FtcGxlcy9icGYvdGNwX2JwZi5y
ZWFkbWUgICAgICAgICAgICAgICAgICB8ICAgMiArLQ0KICAgID4gIHNhbXBsZXMvYnBmL3RjcF9k
dW1wc3RhdHNfa2Vybi5jICAgICAgICAgICAgfCAgNjggKysrKysrDQogICAgPiAgdG9vbHMvaW5j
bHVkZS91YXBpL2xpbnV4L2JwZi5oICAgICAgICAgICAgICB8ICAxMiArLQ0KICAgID4gIHRvb2xz
L3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9NYWtlZmlsZSAgICAgICAgfCAgIDMgKy0NCiAgICA+ICB0
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGNwX3J0dC5jIHwgIDYxICsrKysrDQog
ICAgPiAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3RfdGNwX3J0dC5jICB8IDI1NCAr
KysrKysrKysrKysrKysrKysrKw0KICAgID4gIDExIGZpbGVzIGNoYW5nZWQsIDU3NCBpbnNlcnRp
b25zKCspLCA1OCBkZWxldGlvbnMoLSkNCiAgICA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgc2FtcGxl
cy9icGYvdGNwX2R1bXBzdGF0c19rZXJuLmMNCiAgICA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3RjcF9ydHQuYw0KICAgID4gIGNyZWF0ZSBt
b2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF90Y3BfcnR0LmMNCiAg
ICA+DQogICAgPiAtLQ0KICAgID4gMi4yMi4wLjQxMC5nZDhmZGJlMjFiNS1nb29nDQogICAgDQoN
Cg==
