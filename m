Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159778543A
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 22:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388817AbfHGUCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 16:02:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21698 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729714AbfHGUCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 16:02:06 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x77JroRR021315;
        Wed, 7 Aug 2019 13:01:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=zrPvrICL2H5zf7lk9sWynRDkoyC9iQtSFTS/1wJkIVY=;
 b=Mj8PJJw3gkBIemDNBUiNlfzZYkvx7vDc8suFR8kvCuvTW/UZU/dI/46OOc4bHnnD9tpk
 ZrfCF3a2xPvL/+hALtbGvymiXEE1irG9joveb8qIxTaMLyjCklNeRpB2wkTVHBrpn03V
 voNTPkAD6gdfVL7XhdejzBvTE4IjmLPCrlw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u7xgchmme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 07 Aug 2019 13:01:46 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Aug 2019 13:01:44 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Aug 2019 13:01:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGMforK3ai6kuGJwBjUXBCAexwj79o12j8SikwJkORH6/ZMwG/dfaEFhPkXARIplseNYYO0bre3d65XwO79Iuq1QVrkfOahXvzNmQosADGLaHC5LLXQb9Ns/E5ZoSI0TrojULAN5lgXnni5z2htDFDIKgrc/07yB6QDqPnpY56NTmh/CYT4vZolVFbWHGI+3WTCP119xd5U9xNE4CPu1Du5dwq9UGGiDJkFwUNBTo82Qq3i52E1fsQx+5ugv2B2MvSID2at18hGU+1Uisxee9tuREtZg59WhW6yFyBB69vRzSd/VidgiJ1Gb9jkLEW1k7ABHI3zWye5TE8KHcNiPEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrPvrICL2H5zf7lk9sWynRDkoyC9iQtSFTS/1wJkIVY=;
 b=HWCJ3FwNPw7LNWrk5OGIeYVX/fdNM9FLpCCuyT+0QKE19z8b6BuORu5DT6r2N4zzK6fm8fUrZ5g+ZtpagIctXWGQ68phpTgWwGvvLDy42AkcFW58/Va+53u3W71FHa6HAxbhKWegheSA7Tn9P0MSj1FbTbg1RHcQCOmQgS6HX/TlCPFwZz2gEl6Ljbw2KMHaVh4tSFjdKmijIxjfSxVRd7lT8xmDO7iMjB5+yTFG67tExgCxeUuE0NJX2r74my5ihK/L/e0322lR/l0peddQhlH4Jn1Rcpllvtf9tn9pjiPFuS1ATW8dV8WZRl99LurhcGaxXUhFnFdJI/P9AyvhxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrPvrICL2H5zf7lk9sWynRDkoyC9iQtSFTS/1wJkIVY=;
 b=ClCCEYocPSVLB3TEddwTFcEt9dbInj3ajZeiFPYXqiqul8NG6PNTUVhyKh4jB1LgrvoaoGSnxEwSMr8MEUJ4PUAj74x2uCqzEEfqLYlyB8yUHhQC1U0kWuoZWDbggGu6Jaj5voWw5phUOHCIuFVlgyorAZYhrhE6zI3CJeCRqUA=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2214.namprd15.prod.outlook.com (52.135.196.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Wed, 7 Aug 2019 20:01:40 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c96d:9187:5a7b:288]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c96d:9187:5a7b:288%5]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 20:01:40 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Yonghong Song" <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 02/14] libbpf: convert libbpf code to use new
 btf helpers
Thread-Topic: [PATCH v4 bpf-next 02/14] libbpf: convert libbpf code to use new
 btf helpers
Thread-Index: AQHVTOJTE6ZoNobp90GzZaEJAH/tGabwE0sAgAAIS4CAAAB8gA==
Date:   Wed, 7 Aug 2019 20:01:39 +0000
Message-ID: <151d13d1-e894-56cc-4690-4661c8afc65e@fb.com>
References: <20190807053806.1534571-1-andriin@fb.com>
 <20190807053806.1534571-3-andriin@fb.com>
 <20190807193011.g2zuaapc2uvvr4h6@ast-mbp>
 <CAEf4BzahxLWRVNcNWpba7_7CbbQgN8k0RU8Ya1XCK8j4rPQ0NQ@mail.gmail.com>
In-Reply-To: <CAEf4BzahxLWRVNcNWpba7_7CbbQgN8k0RU8Ya1XCK8j4rPQ0NQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:300:16::17) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::7084]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1558cb76-5e6d-4672-3289-08d71b720f88
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2214;
x-ms-traffictypediagnostic: BYAPR15MB2214:
x-microsoft-antispam-prvs: <BYAPR15MB2214FCAA551239CE72EADEFFD7D40@BYAPR15MB2214.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(136003)(39860400002)(396003)(189003)(199004)(71200400001)(76176011)(256004)(2906002)(6506007)(110136005)(6116002)(6436002)(8936002)(14454004)(66446008)(229853002)(66946007)(316002)(6486002)(8676002)(64756008)(53936002)(71190400001)(81156014)(66556008)(66476007)(81166006)(6246003)(446003)(2616005)(11346002)(476003)(99286004)(386003)(7736002)(52116002)(102836004)(31696002)(53546011)(486006)(46003)(6512007)(86362001)(186003)(305945005)(54906003)(478600001)(31686004)(5660300002)(25786009)(4326008)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2214;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7VbSDi+JBFnB9J6fhakn2SDfkHO5C4pLFi3OAxMA1ND2Nc76ovRnyftODFmhAtwB8U4EG7Bxp2++QMbszh6rIiuNV2h1s5alWwzefdZrvbeXmClgYg8ddCZSNwPN1FbFySOhyN8BO5srS9/FOwOBEcDTRsuUq1jmdV/OdZP0si5K0k5bB2mWfLIwCwoXVOy2FFHmzFyQRZ3uLYFKpWYBUI6ijzlD+UYC+jWVKYAMFJ0oaVAGP8C1ZtAqrHRuAa3oaQzl4fGfV+74AQr1vDOM2ZZEawIrGDLNqYy6jAlJHZwJSTqXzbQPGpTVFRYfJWaR9eRRA/ZeOx16jcS2ObQR5XaMMURXVu3ykgcUkdPiCY7uGFcCIHbDzXDuUqJDYHBGdLE5FfjzH1xiWqZ0k/CIR7RygUTfUFUH++5Fpitz/6Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34E93D2B3502B544BF6B5226F2A043C2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1558cb76-5e6d-4672-3289-08d71b720f88
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 20:01:39.9249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2214
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=691 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070178
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC83LzE5IDEyOjU5IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IE9uIFdlZCwgQXVn
IDcsIDIwMTkgYXQgMTI6MzAgUE0gQWxleGVpIFN0YXJvdm9pdG92DQo+IDxhbGV4ZWkuc3Rhcm92
b2l0b3ZAZ21haWwuY29tPiB3cm90ZToNCj4+DQo+PiBPbiBUdWUsIEF1ZyAwNiwgMjAxOSBhdCAx
MDozNzo1NFBNIC0wNzAwLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+Pj4gU2ltcGxpZnkgY29k
ZSBieSByZWx5aW5nIG9uIG5ld2x5IGFkZGVkIEJURiBoZWxwZXIgZnVuY3Rpb25zLg0KPj4+DQo+
Pj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCj4+IC4u
DQo+Pj4NCj4+PiAtICAgICBmb3IgKGkgPSAwLCB2c2kgPSAoc3RydWN0IGJ0Zl92YXJfc2VjaW5m
byAqKSh0ICsgMSk7DQo+Pj4gLSAgICAgICAgICBpIDwgdmFyczsgaSsrLCB2c2krKykgew0KPj4+
ICsgICAgIGZvciAoaSA9IDAsIHZzaSA9ICh2b2lkICopYnRmX3Zhcl9zZWNpbmZvcyh0KTsgaSA8
IHZhcnM7IGkrKywgdnNpKyspIHsNCj4+DQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgIHN0cnVj
dCBidGZfbWVtYmVyICptID0gKHZvaWQgKilidGZfbWVtYmVycyh0KTsNCj4+IC4uLg0KPj4+ICAg
ICAgICAgICAgICAgIGNhc2UgQlRGX0tJTkRfRU5VTTogew0KPj4+IC0gICAgICAgICAgICAgICAg
ICAgICBzdHJ1Y3QgYnRmX2VudW0gKm0gPSAoc3RydWN0IGJ0Zl9lbnVtICopKHQgKyAxKTsNCj4+
PiAtICAgICAgICAgICAgICAgICAgICAgX191MTYgdmxlbiA9IEJURl9JTkZPX1ZMRU4odC0+aW5m
byk7DQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBidGZfZW51bSAqbSA9ICh2b2lk
ICopYnRmX2VudW0odCk7DQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgIF9fdTE2IHZsZW4gPSBi
dGZfdmxlbih0KTsNCj4+IC4uLg0KPj4+ICAgICAgICAgICAgICAgIGNhc2UgQlRGX0tJTkRfRlVO
Q19QUk9UTzogew0KPj4+IC0gICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgYnRmX3BhcmFtICpt
ID0gKHN0cnVjdCBidGZfcGFyYW0gKikodCArIDEpOw0KPj4+IC0gICAgICAgICAgICAgICAgICAg
ICBfX3UxNiB2bGVuID0gQlRGX0lORk9fVkxFTih0LT5pbmZvKTsNCj4+PiArICAgICAgICAgICAg
ICAgICAgICAgc3RydWN0IGJ0Zl9wYXJhbSAqbSA9ICh2b2lkICopYnRmX3BhcmFtcyh0KTsNCj4+
PiArICAgICAgICAgICAgICAgICAgICAgX191MTYgdmxlbiA9IGJ0Zl92bGVuKHQpOw0KPj4NCj4+
IFNvIGFsbCBvZiB0aGVzZSAndm9pZCAqJyB0eXBlIGhhY2tzIGFyZSBvbmx5IHRvIGRyb3AgY29u
c3QtbmVzcyA/DQo+IA0KPiBZZXMuDQo+IA0KPj4gTWF5IGJlIHRoZSBoZWxwZXJzIHNob3VsZG4n
dCBiZSB0YWtpbmcgY29uc3QgdGhlbj8NCj4+DQo+IA0KPiBQcm9iYWJseSBub3QsIGJlY2F1c2Ug
dGhlbiB3ZSdsbCBoYXZlIG11Y2ggd2lkZXItc3ByZWFkIHByb2JsZW0gb2YNCj4gY2FzdGluZyBj
b25zdCBwb2ludGVycyBpbnRvIG5vbi1jb25zdCB3aGVuIHBhc3NpbmcgYnRmX3R5cGUgaW50bw0K
PiBoZWxwZXJzLg0KPiBJIHRoaW5rIGNvbnN0IGFzIGEgZGVmYXVsdCBpcyB0aGUgcmlnaHQgY2hv
aWNlLCBiZWNhdXNlIG5vcm1hbGx5IEJURg0KPiBpcyBpbW11dGFibGUgYW5kIGJ0Zl9fdHlwZV9i
eV9pZCBpcyByZXR1cm5pbmcgY29uc3QgcG9pbnRlciwgZXRjLg0KPiBUaGF0J3MgdHlwaWNhbCBh
bmQgZXhwZWN0ZWQgdXNlLWNhc2UuIGJ0Zl9kZWR1cCBhbmQgQlRGIHNhbml0aXphdGlvbiArDQo+
IGRhdGFzZWMgc2l6ZSBzZXR0aW5nIHBpZWNlcyBhcmUgYW4gZXhjZXB0aW9uIHRoYXQgaGF2ZSB0
byBtb2RpZnkgQlRGDQo+IHR5cGVzIGluIHBsYWNlIGJlZm9yZSBwYXNzaW5nIGl0IHRvIHVzZXIu
DQo+IA0KPiBTbyByZWFsaXN0aWNhbGx5IEkgdGhpbmsgd2UgY2FuIGp1c3QgbGVhdmUgaXQgYXMg
KHZvaWQgKiksIG9yIEkgY2FuIGRvDQo+IGV4cGxpY2l0IG5vbi1jb25zdCB0eXBlIGNhc3RzLCBv
ciB3ZSBjYW4ganVzdCBub3QgdXNlIGhlbHBlcnMgZm9yDQo+IG11dGFibGUgY2FzZXMuIERvIHlv
dSBoYXZlIGEgcHJlZmVyZW5jZT8NCg0KSG1tLiBUYWtlIGEgY29uc3QgaW50byB0aGUgaGVscGVy
IGFuZCBkcm9wIGl0IHRoZXJlPw0KSSdkIGxpa2UgdG8gYXZvaWQgYWxsIHRoZXNlICd2b2lkICon
Lg0K
