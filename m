Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03F062697
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387899AbfGHQsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:48:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24448 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730341AbfGHQsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:48:53 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x68GlmHo000524;
        Mon, 8 Jul 2019 09:47:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=aConNxTGvsGqOazsyVbu5b0NcgiwxFxoCtlfsRuOf+Q=;
 b=Y2fkF83t94erJz+jeaExbdzNdSG5nDDIQoz6dMO9Vuqx57KC9Z5teu4DVS1J9HQoAx88
 XVn2dCk/q5l/AHh1PJyamAr4EL28txAhDdwdt/EDEERBOQf3z8Ob+K5bOOKuMBapuy+X
 TNvTBf7W9PMJzabgtV293+l1BGukZI1HDG0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tm8apgc5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 08 Jul 2019 09:47:50 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 8 Jul 2019 09:47:49 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 8 Jul 2019 09:47:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aConNxTGvsGqOazsyVbu5b0NcgiwxFxoCtlfsRuOf+Q=;
 b=D2NXWdE2wzGf51MBYKoKJq0RSMHVwsonH9nGwk4fRo4gp7ToV4RqFcPESHQUgYnxZPsCp+37nSAchd/GGz5CucDJDmO7q4TpNyu+uNJipJ3eu3rirb4nEOdwquFOLvTWtxZz2m9ha5U/Erx6miy0QOleG+6OyJeCQILLbLTH4wo=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2552.namprd15.prod.outlook.com (20.179.155.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Mon, 8 Jul 2019 16:47:31 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2052.020; Mon, 8 Jul 2019
 16:47:31 +0000
From:   Yonghong Song <yhs@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCH bpf-next v3 3/6] xdp: Add devmap_hash map type for looking
 up devices by hashed index
Thread-Topic: [PATCH bpf-next v3 3/6] xdp: Add devmap_hash map type for
 looking up devices by hashed index
Thread-Index: AQHVNXu/+nE98AW+J0+zvPxU27bK/abA7qWA
Date:   Mon, 8 Jul 2019 16:47:31 +0000
Message-ID: <aa88130d-91d4-981d-04b0-b2d20c244437@fb.com>
References: <156258334704.1664.15289699152225647059.stgit@alrua-x1>
 <156258334732.1664.10214955962271992722.stgit@alrua-x1>
In-Reply-To: <156258334732.1664.10214955962271992722.stgit@alrua-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR18CA0020.namprd18.prod.outlook.com
 (2603:10b6:404:121::30) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:7bd2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9dbb6a71-56e0-466e-8758-08d703c3f7f6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2552;
x-ms-traffictypediagnostic: BYAPR15MB2552:
x-microsoft-antispam-prvs: <BYAPR15MB2552E0B9B1F79F03DD78F67FD3F60@BYAPR15MB2552.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 00922518D8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(396003)(366004)(376002)(39860400002)(136003)(346002)(199004)(189003)(68736007)(66476007)(66556008)(64756008)(6512007)(66446008)(486006)(316002)(86362001)(31696002)(71200400001)(71190400001)(5660300002)(4744005)(66946007)(73956011)(256004)(2616005)(110136005)(54906003)(81156014)(476003)(6116002)(6506007)(14454004)(81166006)(6436002)(25786009)(99286004)(8936002)(305945005)(11346002)(7736002)(446003)(478600001)(31686004)(8676002)(6486002)(386003)(46003)(52116002)(229853002)(4326008)(76176011)(53936002)(53546011)(102836004)(6246003)(36756003)(2906002)(186003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2552;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ah7mmksKKp4oTPpBp0IYmA5wDKI/Tx2fpf2l2Bq+CcOHlUHEogFpETV7anj0HAI1F5zqw08dD3iF5g8ZzH0m0Cy+8hHXMUxSEby17F27cXw+yMWMMoIA78Gy9slpJ0HjYdpwU9fyhrJ0WgIGrHh8F9rQQLw0Bdu43zYNiwEORIKfSfLJB396k+KaWRB6FkaLvJxbiOKvlkzbzRsf0Bic0bfrPJAVSlUBpO7L50BiEcvXi3F1QHj/Qj6Ds2I7d9otPVHXiVkY3V3wkB0VzTgFqH10AUzVW+Irxx8N8Oq3aG59TWFrnReXHx1HInUB3fdF5tXfNyuZgN0Q42VvA5UWZwKJ4fvQxA447UQC/Er/bCjyoWkGO+MLawnaWUNLrbaKuSzr8U/H3m5IYaW0wnDzkSjuuK2ofkV7wG25m0SqIx8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB42763FE60A3A4F8271182DBE1DCB91@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dbb6a71-56e0-466e-8758-08d703c3f7f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2019 16:47:31.2507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2552
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=952 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080207
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvOC8xOSAzOjU1IEFNLCBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4gd3JvdGU6DQo+
IEZyb206IFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiA8dG9rZUByZWRoYXQuY29tPg0KPiANCj4g
QSBjb21tb24gcGF0dGVybiB3aGVuIHVzaW5nIHhkcF9yZWRpcmVjdF9tYXAoKSBpcyB0byBjcmVh
dGUgYSBkZXZpY2UgbWFwDQo+IHdoZXJlIHRoZSBsb29rdXAga2V5IGlzIHNpbXBseSBpZmluZGV4
LiBCZWNhdXNlIGRldmljZSBtYXBzIGFyZSBhcnJheXMsDQo+IHRoaXMgbGVhdmVzIGhvbGVzIGlu
IHRoZSBtYXAsIGFuZCB0aGUgbWFwIGhhcyB0byBiZSBzaXplZCB0byBmaXQgdGhlDQo+IGxhcmdl
c3QgaWZpbmRleCwgcmVnYXJkbGVzcyBvZiBob3cgbWFueSBkZXZpY2VzIGFjdHVhbGx5IGFyZSBh
Y3R1YWxseQ0KPiBuZWVkZWQgaW4gdGhlIG1hcC4NCj4gDQo+IFRoaXMgcGF0Y2ggYWRkcyBhIHNl
Y29uZCB0eXBlIG9mIGRldmljZSBtYXAgd2hlcmUgdGhlIGtleSBpcyBsb29rZWQgdXANCj4gdXNp
bmcgYSBoYXNobWFwLCBpbnN0ZWFkIG9mIGJlaW5nIHVzZWQgYXMgYW4gYXJyYXkgaW5kZXguIFRo
aXMgYWxsb3dzIG1hcHMNCj4gdG8gYmUgZGVuc2VseSBwYWNrZWQsIHNvIHRoZXkgY2FuIGJlIHNt
YWxsZXIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4gPHRv
a2VAcmVkaGF0LmNvbT4NCg0KQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQoN
Cj4gLS0tDQo+ICAgaW5jbHVkZS9saW51eC9icGYuaCAgICAgICAgfCAgICA3ICsrDQo+ICAgaW5j
bHVkZS9saW51eC9icGZfdHlwZXMuaCAgfCAgICAxDQo+ICAgaW5jbHVkZS90cmFjZS9ldmVudHMv
eGRwLmggfCAgICAzIC0NCj4gICBpbmNsdWRlL3VhcGkvbGludXgvYnBmLmggICB8ICAgIDENCj4g
ICBrZXJuZWwvYnBmL2Rldm1hcC5jICAgICAgICB8ICAxOTQgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysNCj4gICBrZXJuZWwvYnBmL3ZlcmlmaWVyLmMgICAgICB8
ICAgIDINCj4gICBuZXQvY29yZS9maWx0ZXIuYyAgICAgICAgICB8ICAgIDkgKysNCj4gICA3IGZp
bGVzIGNoYW5nZWQsIDIxNCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0K
