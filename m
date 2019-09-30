Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80ADBC279D
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732026AbfI3U7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:59:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24364 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727702AbfI3U7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:59:39 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8UICJdr023657;
        Mon, 30 Sep 2019 11:18:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Vh1b4oqkpnQMN50XgwdH2KKU8JY8k6nRM48bdddUhcw=;
 b=LEpFhMIqtGsEWL9bn3ZRi2pkvn5J6bQrReqzEXpMIQBA3iuLFt9sJGNztx889w/R4j3l
 aifhrIAgHladDYm4wHfn01OpkJwUUwaPdSrmHfgP93/AkyFuOfl8bBv8Oi4BQg2q5tqu
 iG0IGZk506XQ6NiYiEwrJJhvRvnos7hdZF4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vbm2ugvea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Sep 2019 11:18:38 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 30 Sep 2019 11:18:37 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 30 Sep 2019 11:18:36 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Sep 2019 11:18:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZs+Yl9Kt6oEjJLwr+n2keSp8zfAl9aUEMgbBJmET7HiXI0tqzfhFtkJefNVHPlovV01z7vXIb0xZgfVxK1txCz7I5AGkmp2X50raFZxONnZ1rOBw1bifYF2QKOxF2gCkp9/7TTVOrAAIF0KbM1fAneMqXxtEUckrMQb/fK2SF0Gedny6w9K61YElUZtgwvlpDXXbZacP/QEYu2Ts9QHBN5+5PWudgDQ2kethSo2AaHiMK6xs8M3/9o1bmotoOZasK4uy5YC7ONbgKurfaiXzh3t4RXjJ691nQY5edGtoDP+DmOrEK9SKWj4fct8Wn0gmiuwqQVZm/djQtc1soliSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vh1b4oqkpnQMN50XgwdH2KKU8JY8k6nRM48bdddUhcw=;
 b=C09QxGCQDDKOmgJEpD3FH80Zy3xDXhKndvHEBCXJwWS9EXRQdSZ8ohK3aJK9NK4V1ioONpnVvhOkV1+wFUUMoa3+E2JAtsk/BKFlGtl7IMQjaLEbtROsQEJ/mVejw6BCHDogqKjfwB3+gHdeNc3hJfYFSgvVmNEpjjDz2z0bi9ew1Su2+UaVy9H2yg0ohF6J658LfQ34sZzX7Li3KxRUzvMAU2KZCpWxcLHvtCqYR4NQXDa2aQ1PYHNa+QtSOTdIvscSutjoV/Ju4NJXV10KHpmGCITM4AcvFP2/bwoK7r1qsXHX4plGajolCwQYaw5/zJpL8RgOG5MpZwTq3kg+dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vh1b4oqkpnQMN50XgwdH2KKU8JY8k6nRM48bdddUhcw=;
 b=OrF2HLVzZJXEGL/tNFCaC6lMc+yl+Txowj49jlq4NT/HtmkHOEloox7R521XJTQDAYpsVUvVxENkh2S/zHw0dyJcn02W/IltCIqVyWOLpeKk+2sYrIrQAkgbodlqG4+NNvHAfEOD9tDA/imwxTNjVwKocDuAbksWwC/d0th3qjA=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3192.namprd15.prod.outlook.com (20.179.56.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Mon, 30 Sep 2019 18:18:35 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 18:18:35 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Yonghong Song <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Kevin Laatz <kevin.laatz@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf v3] libbpf: handle symbol versioning properly for
 libbpf.a
Thread-Topic: [PATCH bpf v3] libbpf: handle symbol versioning properly for
 libbpf.a
Thread-Index: AQHVd6xB7FHrP/dEpUWrsxPulh60AKdEbNQAgAADuICAABcIgA==
Date:   Mon, 30 Sep 2019 18:18:35 +0000
Message-ID: <30ee93ab-a3f7-e92d-a33e-477e74f1849a@fb.com>
References: <20190930162922.2169975-1-yhs@fb.com>
 <b23d1e1f-6912-33eb-e7d7-c1e47015cb4c@fb.com>
 <a508b199-d6b9-26ee-a3f6-2012c9fdde37@fb.com>
In-Reply-To: <a508b199-d6b9-26ee-a3f6-2012c9fdde37@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR07CA0057.namprd07.prod.outlook.com (2603:10b6:100::25)
 To BYAPR15MB2501.namprd15.prod.outlook.com (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::c799]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8aef89a1-c984-4cc5-8c99-08d745d29b15
x-ms-traffictypediagnostic: BYAPR15MB3192:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3192A174A133BDC81810AAD2D7820@BYAPR15MB3192.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(366004)(396003)(346002)(189003)(199004)(54906003)(66446008)(110136005)(11346002)(8936002)(316002)(6486002)(14454004)(81166006)(229853002)(6116002)(446003)(8676002)(81156014)(6512007)(6436002)(7736002)(66476007)(66556008)(4326008)(2201001)(305945005)(2501003)(66946007)(476003)(486006)(478600001)(64756008)(2906002)(2616005)(52116002)(46003)(186003)(256004)(25786009)(6506007)(76176011)(6246003)(36756003)(31686004)(31696002)(86362001)(102836004)(5660300002)(71200400001)(386003)(71190400001)(53546011)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3192;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gb3WprVomw+OuW+D5uXI5KHU/yIJwbUrYSgDp+oTNGsyCkxMMllugQ+F/j2W+XCqsZMCp+wepmVS8Zm3ArysoBsudmO7b2/DO78fNhu3CF8L8DMrkYWVJJKZxMmACrC8xYJRmu1w2dLUnaWxU5KSVvoNXweBxPMlMYT78fH6xGgGcEAzXmsSkNTjORf7FhunOj9G6/FOk23TUnsI0S5Zg3lI8cU/KM+d27qio0/vR3FUMrYCD/GeW9RuhQRtqgowxHCwFNrSAvGCBPtB45id6EzmCXO2s/TZhmCaKuPuzV9eghyyt3qUErR2ILQfGu+D2+m3RHuKn357igATrXT3QzQmMyRrfhsBeBFVaD9jdoOcZWBsweWSHbDcoqnPohMIOT8yRENthtmlYgRA8NmuznslLKt5nO42Un5e+WY1oLk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BE48BE109EBCC4F887670C713EAC165@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aef89a1-c984-4cc5-8c99-08d745d29b15
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 18:18:35.0819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cRfrZhAU7tLbOKPPC3UbYCVSp+fEd9PoaP4aVX1Dnn5kTDHy02VLXl9d9cFNFNEd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3192
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_10:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 mlxlogscore=992 clxscore=1015 impostorscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS8zMC8xOSA5OjU2IEFNLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPiANCj4gDQo+IE9uIDkv
MzAvMTkgOTo0MiBBTSwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPj4gT24gOS8zMC8xOSA5
OjI5IEFNLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPj4+ICtPTERfVkVSU0lPTih4c2tfdW1lbV9f
Y3JlYXRlX3YwXzBfMiwgeHNrX3VtZW1fX2NyZWF0ZSwgTElCQlBGXzAuMC4yKQ0KPj4+ICtORVdf
VkVSU0lPTih4c2tfdW1lbV9fY3JlYXRlX3YwXzBfNCwgeHNrX3VtZW1fX2NyZWF0ZSwgTElCQlBG
XzAuMC40KQ0KPj4NCj4+IGhvdyB0aGlzIHdpbGwgbG9vayB3aGVuIHlldCBhbm90aGVyIHZlcnNp
b24gb2YgdGhpcyBmdW5jdGlvbiBpcw0KPj4gaW50cm9kdWNlZCwgc2F5IGluIDAuMC42ID8NCj4+
DQo+PiBPTERfVkVSU0lPTih4c2tfdW1lbV9fY3JlYXRlX3YwXzBfMiwgeHNrX3VtZW1fX2NyZWF0
ZSwgTElCQlBGXzAuMC4yKQ0KPj4gT0xEX1ZFUlNJT04oeHNrX3VtZW1fX2NyZWF0ZV92MF8wXzQs
IHhza191bWVtX19jcmVhdGUsIExJQkJQRl8wLjAuNCkNCj4+IE5FV19WRVJTSU9OKHhza191bWVt
X19jcmVhdGVfdjBfMF82LCB4c2tfdW1lbV9fY3JlYXRlLCBMSUJCUEZfMC4wLjYpDQo+IA0KPiBZ
ZXMuDQo+IA0KPj4NCj4+IDAuMC40IHdpbGwgYmUgcmVuYW1lZCB0byBPTERfIGFuZCB0aGUgbGF0
ZXN0IGFkZGl0aW9uIE5FV18gPw0KPiANCj4gUmlnaHQuDQo+IA0KPj4gVGhlIG1hY3JvIG5hbWUg
ZmVlbHMgYSBiaXQgY29uZnVzaW5nLiBNYXkgYmUgaW5zdGVhZCBvZiBORVdfDQo+PiBjYWxsIGl0
IENVUlJFTlRfID8gb3IgREVGQVVMVF8gPw0KPj4gTkVXXyB3aWxsIGJlY29tZSBub3Qgc28gJ25l
dycgZmV3IG1vbnRocyBmcm9tIG5vdy4NCj4gDQo+IFJpZ2h0LiBBZnRlciBhIGZldyBtb250aHMs
IHRoZSB2ZXJzaW9uIG51bWJlciBtYXkgaW5kZWVkIGJlDQo+IGJlaGluZCB0aGUgbGliYnBmIHZl
cnNpb25zLi4uLiAiY3VycmVudCIgbWF5IG5vdCBiZSBjdXJyZW50IC4uLi4NCj4gTGV0IG1lIHVz
ZSBERUZBVUxUIHRoZW4uIEhvdyBhYm91dCB1c2luZw0KPiAgICAgIENPTVBBVF9WRVJTSU9OKC4u
LikNCj4gZm9yIG9sZCB2ZXJzaW9ucywgYW5kIHVzaW5nDQoNCkNPTVBBVF9WRVJTSU9OIHNvdW5k
cyBmaW5lLiBJIHRoaW5rIE9MRF9WRVJTSU9OIHdhcyBvayB0b28uDQoNCj4gICAgICBERUZBVUxU
X1ZFUlNJT04oLi4uKQ0KPiBmb3IgdGhlIG5ldyB2ZXJzaW9uPw0KDQpzb3VuZHMgZ29vZC4NCg0K
VGhhbmtzIQ0KDQo=
