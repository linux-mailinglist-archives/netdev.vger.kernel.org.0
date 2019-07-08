Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F8762699
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389713AbfGHQtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:49:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8596 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728973AbfGHQtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:49:02 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x68GeOQ0028398;
        Mon, 8 Jul 2019 09:48:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WKdp+07t86SOmJ3AiTfwh1azCfTXS+2lijIgVGWqhHU=;
 b=kxDsibpjPHalbsLpn+vaSSErj8UH60uCVDvlU6PHXhQd8IS7cnvRqJWOkeLy6l2Z0yOF
 UgUP58P7COkRsUIM8NLCbzVnYHcq1qmJXFJAnpoquLHDI6n+UXWNOiahLI4bra0CoXsv
 x5eTRpOLdYgF+TltVUPU3nNZbKwtqN3D+Bw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tm4tph56n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 09:48:18 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 8 Jul 2019 09:48:18 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 8 Jul 2019 09:48:17 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 8 Jul 2019 09:48:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKdp+07t86SOmJ3AiTfwh1azCfTXS+2lijIgVGWqhHU=;
 b=ElkdhHimGxFLC7J/jKk0df2P8ldBJsj4mIYXIjLTHtNzO0KIJAWspMmcblG3vS+g5D0owLtaKpy1y/6xMXAhSwmt2zFJHxt539vaZEKeEADYlOFTFSypJ6QtSW2PRgYvoaI6fzDAhy0cuNaEngeE/B+41RAn6z5OdNJosknmhLM=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3509.namprd15.prod.outlook.com (20.179.60.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Mon, 8 Jul 2019 16:48:16 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2052.020; Mon, 8 Jul 2019
 16:48:16 +0000
From:   Yonghong Song <yhs@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCH bpf-next v3 5/6] tools/libbpf_probes: Add new devmap_hash
 type
Thread-Topic: [PATCH bpf-next v3 5/6] tools/libbpf_probes: Add new devmap_hash
 type
Thread-Index: AQHVNXu+LwsuyEUGZ0W5+fRnEgeAZabA7uOA
Date:   Mon, 8 Jul 2019 16:48:16 +0000
Message-ID: <3e448637-682e-825a-a8a2-108de7b8e4ed@fb.com>
References: <156258334704.1664.15289699152225647059.stgit@alrua-x1>
 <156258334745.1664.1686759894096070590.stgit@alrua-x1>
In-Reply-To: <156258334745.1664.1686759894096070590.stgit@alrua-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR18CA0021.namprd18.prod.outlook.com
 (2603:10b6:404:121::31) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:7bd2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41129969-c277-476a-240c-08d703c412df
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3509;
x-ms-traffictypediagnostic: BYAPR15MB3509:
x-microsoft-antispam-prvs: <BYAPR15MB3509ED2D7C1EAC79879E08E0D3F60@BYAPR15MB3509.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:421;
x-forefront-prvs: 00922518D8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(346002)(376002)(366004)(199004)(189003)(68736007)(486006)(66476007)(4744005)(66446008)(66556008)(66946007)(7736002)(6116002)(64756008)(73956011)(25786009)(8676002)(2616005)(476003)(446003)(99286004)(14454004)(86362001)(2906002)(31696002)(71200400001)(71190400001)(46003)(305945005)(186003)(11346002)(81156014)(8936002)(256004)(54906003)(6486002)(81166006)(386003)(6506007)(53546011)(52116002)(478600001)(110136005)(76176011)(4326008)(102836004)(5660300002)(36756003)(229853002)(53936002)(316002)(6436002)(6512007)(31686004)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3509;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7Nj/gOTKHN4aQyGkV9nfzoyTkR3SR+jWEjdZRX2GItQylTKBlzqA1Chda4FeGRiQktfYPb/JezaJdCj5ysI3ej8p8V9SQ8FB5pSW2VhZ05ovf88ayuhXExAvBLjQM5PJimGYtfsmOTLz5JbB5EHu5dXUFTEneihp5z44P11n2Cvi1Vzldo/D4Iy01XDwqxOcDjC62UhREDFyHYiDUmUV7N647C/cUxfX1tHuj7Xn43fyvUMHVkzmsP8Bf7jfCvBIx9arCP5xnFclNvo6ks5tpfCK29UMN9pUmWxiHbAoQQ00cXWwyeAE3t3JHx3JsNxhdbsSuZtwvj3paq8L1usZo/Gl2KVm/45pqGpaz8kSW6KPCcwgTm/qPI33vD8YD5OmBvnYeT4u4Y5vmdHjO2ZDy4O2MYvPbu16XzaHBJ8pkJw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04E8E9CF774D824E9B626B75D6ECB147@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 41129969-c277-476a-240c-08d703c412df
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2019 16:48:16.3300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3509
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=938 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvOC8xOSAzOjU1IEFNLCBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4gd3JvdGU6DQo+
IEZyb206IFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiA8dG9rZUByZWRoYXQuY29tPg0KPiANCj4g
VGhpcyBhZGRzIHRoZSBkZWZpbml0aW9uIGZvciBCUEZfTUFQX1RZUEVfREVWTUFQX0hBU0ggdG8g
bGliYnBmX3Byb2Jlcy5jIGluDQo+IHRvb2xzL2xpYi9icGYuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4gPHRva2VAcmVkaGF0LmNvbT4NCg0KQWNrZWQtYnk6
IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQoNCj4gLS0tDQo+ICAgdG9vbHMvbGliL2JwZi9s
aWJicGZfcHJvYmVzLmMgfCAgICAxICsNCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KykNCj4gDQo+IGRpZmYgLS1naXQgYS90b29scy9saWIvYnBmL2xpYmJwZl9wcm9iZXMuYyBiL3Rv
b2xzL2xpYi9icGYvbGliYnBmX3Byb2Jlcy5jDQo+IGluZGV4IGFjZTFhMDcwOGQ5OS4uNGIwYjAz
NjRmNWZjIDEwMDY0NA0KPiAtLS0gYS90b29scy9saWIvYnBmL2xpYmJwZl9wcm9iZXMuYw0KPiAr
KysgYi90b29scy9saWIvYnBmL2xpYmJwZl9wcm9iZXMuYw0KPiBAQCAtMjQ0LDYgKzI0NCw3IEBA
IGJvb2wgYnBmX3Byb2JlX21hcF90eXBlKGVudW0gYnBmX21hcF90eXBlIG1hcF90eXBlLCBfX3Uz
MiBpZmluZGV4KQ0KPiAgIAljYXNlIEJQRl9NQVBfVFlQRV9BUlJBWV9PRl9NQVBTOg0KPiAgIAlj
YXNlIEJQRl9NQVBfVFlQRV9IQVNIX09GX01BUFM6DQo+ICAgCWNhc2UgQlBGX01BUF9UWVBFX0RF
Vk1BUDoNCj4gKwljYXNlIEJQRl9NQVBfVFlQRV9ERVZNQVBfSEFTSDoNCj4gICAJY2FzZSBCUEZf
TUFQX1RZUEVfU09DS01BUDoNCj4gICAJY2FzZSBCUEZfTUFQX1RZUEVfQ1BVTUFQOg0KPiAgIAlj
YXNlIEJQRl9NQVBfVFlQRV9YU0tNQVA6DQo+IA0K
