Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA692849E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731206AbfEWROB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:14:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56550 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731138AbfEWROB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:14:01 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NGjY12015831;
        Thu, 23 May 2019 09:51:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tO72be5dkTfIBrFIHCx5/fmWZPSTEXtAW1gzuX1OJGs=;
 b=oLgS+NZywjwV4vhTdT51r3BqrISrhV97fitW/wGiJtBiG6HJE+uT07kUc37jKIK0ur1f
 JcR7ywJOyyaNBJMn1hKiAPcwNQQac1A26LImZoZUKJqQdCuVJODzvXXCmW0OJpr/rBnQ
 UUpktTzu9Gd0qxwTgOsOwfEFEQsNRp7JVwI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2snxsv0538-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 May 2019 09:51:41 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 May 2019 09:51:38 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 23 May 2019 09:51:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tO72be5dkTfIBrFIHCx5/fmWZPSTEXtAW1gzuX1OJGs=;
 b=hQ+PeJ7Jfii6AcTCTYN8CwUN/pGgkmq2kA4SlipuUb+oMKDKGBbCQzEgn3+tYtS9ssJyGKAANMNmHn/lOZaSXmLg9r1po1HNkv03nOAWRTp+iWu34SgEawlgaANrhQ14oxyn3CUQikuJ6kNZzbd1f3oR3An7aL3XRu/pVUTkFnY=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2629.namprd15.prod.outlook.com (20.179.156.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Thu, 23 May 2019 16:51:20 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 16:51:20 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Michal Rostecki <mrostecki@opensuse.org>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <xdp-newbies@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 RESEND 0/2] Move bpf_printk to bpf_helpers.h
Thread-Topic: [PATCH bpf-next v2 RESEND 0/2] Move bpf_printk to bpf_helpers.h
Thread-Index: AQHVEWZ9tKZLQB45uky5/KKE/VBBiKZ47KwA
Date:   Thu, 23 May 2019 16:51:20 +0000
Message-ID: <4642ca96-22ab-ad61-a6a1-1d2ef7239cb8@fb.com>
References: <20190523125355.18437-1-mrostecki@opensuse.org>
In-Reply-To: <20190523125355.18437-1-mrostecki@opensuse.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0021.namprd22.prod.outlook.com
 (2603:10b6:300:ef::31) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::d011]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05c4d72b-7041-4e4a-59d5-08d6df9ee15c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2629;
x-ms-traffictypediagnostic: BYAPR15MB2629:
x-microsoft-antispam-prvs: <BYAPR15MB26290CAF1D766E076074FC31D3010@BYAPR15MB2629.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(136003)(346002)(366004)(39860400002)(199004)(189003)(81156014)(81166006)(52116002)(86362001)(102836004)(36756003)(8676002)(386003)(6506007)(14454004)(99286004)(25786009)(71190400001)(71200400001)(478600001)(2906002)(229853002)(305945005)(46003)(7736002)(5660300002)(54906003)(31696002)(76176011)(53546011)(186003)(316002)(68736007)(446003)(11346002)(2616005)(476003)(486006)(53936002)(7416002)(256004)(8936002)(66556008)(64756008)(66446008)(6916009)(6512007)(6246003)(66946007)(66476007)(31686004)(73956011)(6116002)(6436002)(6486002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2629;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +Zq4turRfNZQX0W7axyVBgUhzhxgdXftvnYCC/4EHawTCPQOBxx4Qx227Ml4hMjFXC3iyT1yvn4WHVO/Oc6U1ZKNvsPkdbg2Ex1vJjfzg2Mr/XMo5ZH3iJLyq7/B+/sR1lGMx+87zQwyoNhyLcCV1UHuIlr5tDAuQqAFtklKIDgDVnXBpH9lXF0v7L+pfmhHZ4l8EFxqGZ2Mes9l/HqF5I4x65MEewWnqamGWp+PuFOVapoAPdNx42pYsHMI2XSZibmrchNwclAR6jNhWYJbqOvFtH1/M6/252gvpfAcOleyIzufhF6vBw/mqZfYaLm0aQ7Z5XO8ZdNX9eSfnDqgLvbNeYdDQynrRZlvy8fyelaoOmhU5BY3x4yiqHI6ePau6/La7TZQBjJ2TEQ9odPSOyRcdg3FXpjCKjUajAQz9gA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD6A272AAD7B7F488C08810609D42B8E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c4d72b-7041-4e4a-59d5-08d6df9ee15c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 16:51:20.1274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2629
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230114
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjMvMTkgNTo1MyBBTSwgTWljaGFsIFJvc3RlY2tpIHdyb3RlOg0KPiBUaGlzIHNl
cmllcyBvZiBwYXRjaGVzIG1vdmUgdGhlIGNvbW1vbmx5IHVzZWQgYnBmX3ByaW50ayBtYWNybyB0
bw0KPiBicGZfaGVscGVycy5oIHdoaWNoIGlzIGFscmVhZHkgaW5jbHVkZWQgaW4gYWxsIEJQRiBw
cm9ncmFtcyB3aGljaA0KPiBkZWZpbmVkIHRoYXQgbWFjcm8gb24gdGhlaXIgb3duLg0KPiANCj4g
djEtPnYyOg0KPiAtIElmIEhCTV9ERUJVRyBpcyBub3QgZGVmaW5lZCBpbiBoYm0gc2FtcGxlLCB1
bmRlZmluZSBicGZfcHJpbnRrIGFuZCBzZXQNCj4gICAgYW4gZW1wdHkgbWFjcm8gZm9yIGl0Lg0K
PiANCj4gTWljaGFsIFJvc3RlY2tpICgyKToNCj4gICAgc2VsZnRlc3RzOiBicGY6IE1vdmUgYnBm
X3ByaW50ayB0byBicGZfaGVscGVycy5oDQo+ICAgIHNhbXBsZXM6IGJwZjogRG8gbm90IGRlZmlu
ZSBicGZfcHJpbnRrIG1hY3JvDQo+IA0KPiAgIHNhbXBsZXMvYnBmL2hibV9rZXJuLmggICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgMTEgKystLS0tLS0tLS0NCj4gICBzYW1wbGVzL2Jw
Zi90Y3BfYmFzZXJ0dF9rZXJuLmMgICAgICAgICAgICAgICAgICAgICAgICB8ICA3IC0tLS0tLS0N
Cj4gICBzYW1wbGVzL2JwZi90Y3BfYnVmc19rZXJuLmMgICAgICAgICAgICAgICAgICAgICAgICAg
ICB8ICA3IC0tLS0tLS0NCj4gICBzYW1wbGVzL2JwZi90Y3BfY2xhbXBfa2Vybi5jICAgICAgICAg
ICAgICAgICAgICAgICAgICB8ICA3IC0tLS0tLS0NCj4gICBzYW1wbGVzL2JwZi90Y3BfY29uZ19r
ZXJuLmMgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICA3IC0tLS0tLS0NCj4gICBzYW1wbGVz
L2JwZi90Y3BfaXdfa2Vybi5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICA3IC0tLS0t
LS0NCj4gICBzYW1wbGVzL2JwZi90Y3BfcnduZF9rZXJuLmMgICAgICAgICAgICAgICAgICAgICAg
ICAgICB8ICA3IC0tLS0tLS0NCj4gICBzYW1wbGVzL2JwZi90Y3Bfc3lucnRvX2tlcm4uYyAgICAg
ICAgICAgICAgICAgICAgICAgICB8ICA3IC0tLS0tLS0NCj4gICBzYW1wbGVzL2JwZi90Y3BfdG9z
X3JlZmxlY3Rfa2Vybi5jICAgICAgICAgICAgICAgICAgICB8ICA3IC0tLS0tLS0NCj4gICBzYW1w
bGVzL2JwZi94ZHBfc2FtcGxlX3BrdHNfa2Vybi5jICAgICAgICAgICAgICAgICAgICB8ICA3IC0t
LS0tLS0NCj4gICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvYnBmX2hlbHBlcnMuaCAgICAg
ICAgICAgICB8ICA4ICsrKysrKysrDQo+ICAgLi4uL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9n
cy9zb2NrbWFwX3BhcnNlX3Byb2cuYyAgfCAgNyAtLS0tLS0tDQo+ICAgLi4uL3NlbGZ0ZXN0cy9i
cGYvcHJvZ3Mvc29ja21hcF90Y3BfbXNnX3Byb2cuYyAgICAgICAgfCAgNyAtLS0tLS0tDQo+ICAg
Li4uL3NlbGZ0ZXN0cy9icGYvcHJvZ3Mvc29ja21hcF92ZXJkaWN0X3Byb2cuYyAgICAgICAgfCAg
NyAtLS0tLS0tDQo+ICAgLi4uL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X2x3dF9z
ZWc2bG9jYWwuYyAgfCAgNyAtLS0tLS0tDQo+ICAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBm
L3Byb2dzL3Rlc3RfeGRwX25vaW5saW5lLmMgfCAgNyAtLS0tLS0tDQo+ICAgdG9vbHMvdGVzdGlu
Zy9zZWxmdGVzdHMvYnBmL3Rlc3Rfc29ja21hcF9rZXJuLmggICAgICAgfCAgNyAtLS0tLS0tDQo+
ICAgMTcgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMTE0IGRlbGV0aW9ucygtKQ0K
DQpBY2sgZm9yIHRoZSB3aG9sZSBzZXJpZXMuDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhz
QGZiLmNvbT4NCg==
