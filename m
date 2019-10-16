Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62B44D87CC
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 07:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbfJPFL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 01:11:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63498 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726752AbfJPFL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 01:11:56 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9G59UAq006101;
        Tue, 15 Oct 2019 22:11:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=iwAhy+BvlxKiNSXCEfdC4aqRd7PzykejMlFLZ1T2cq0=;
 b=m2nm8+Pmaqn0/8n+fI+KSuuqvxIZgGRO4E2wONsmcLsu5BSpcbe3/Mx4V+js3UPE+3jv
 j567u2Ls09/09Z3ezayAVuHV865BDILOVL6Z9Z1LWJLWzJVukDMOIcyk/HaKGS70ozhd
 Cr8ZoaJ2B1T9EwZg5l4KPtHfqN418TEocsA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vnccacfn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 22:11:44 -0700
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 15 Oct 2019 22:11:43 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 15 Oct 2019 22:11:43 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 15 Oct 2019 22:11:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzR0DXEAA8LD+A9v8DXIhJYG69oruU96YKvRtsBu1qv5dCWvA/07tWgJkQqofZ3OxpaltYflMKGpQDe79fQKMMZPvdIj8yL/T/KcnSWKIqRKss0D3j0ZRzEUzAqY9c+PnGtbUBC+6XwVUkk58dKJVoD78jE8TWP2CAF/Nm4zFnwvbk1vJGUSAqfTjbVirhpZy179J74fOcPijf04tM122bQ6Rg5T3PYZ5MzO9z3XhiRZdAlBVL6Zq9Rj/6jw8U3czIThae+oGEKTE36LPxLgTFk9M9+BfIFsUT4h3L6EAKq8y6kBu9b70NdmipWTYtFMrsL8c667N0Nj4noK7PyxSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwAhy+BvlxKiNSXCEfdC4aqRd7PzykejMlFLZ1T2cq0=;
 b=hh/3AmO9Nh+bD5N5upopkxG7OGCUsewrQUM6sr2BFfeAV1MJcmk5GozwKcRIoA4yweclw5izvcT3v8TzIKHd/5mwwBXMF0vnTtkiF7ettvYzkRpvFSuy0Rgn3+c109fXoCnw6NiBx7x96n8x7tq4nS4pDqMgXG7jKOda80CkAcO7A/BlvLcqA2I/J+HpBK8ZPAwUf9UZEBvMLjep6W9h3l2O8SxvLpp5FGhYfLtrFZvbClPFjB77G/dSWYoUu1pBmjVsU4pgUSq9wjDo0X76FatdyhQeYi++P1H3TKDzMKRvY8I6Cg+b3nyi/Nlig65xK0Y/24/ijgoCFQzyx6Uuxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwAhy+BvlxKiNSXCEfdC4aqRd7PzykejMlFLZ1T2cq0=;
 b=h22Ge+9tg1G4uwyv5fIA8iDYYjxKSOt+vg/UOmaxyBhTno1PM2Vn0hxrgNIbv3NSwxcCb20c+H+gi4FMRhOZK0lXqYcSn3HEjPsYvq1xdtFCsyO9Qkg3url7pkqfblgaR3s4I/I//vKegOKzO3YftMbMEL0TSjC44xFPGiBlb8w=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2389.namprd15.prod.outlook.com (52.135.195.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Wed, 16 Oct 2019 05:11:42 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 05:11:40 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 5/6] selftests/bpf: replace test_progs and
 test_maps w/ general rule
Thread-Topic: [PATCH v2 bpf-next 5/6] selftests/bpf: replace test_progs and
 test_maps w/ general rule
Thread-Index: AQHVg9IIq/IT1I2qoUu/XxmwFL2CIqdcuLwA
Date:   Wed, 16 Oct 2019 05:11:40 +0000
Message-ID: <112cd221-7403-efe2-3375-bb9cc8140744@fb.com>
References: <20191016032949.1445888-1-andriin@fb.com>
 <20191016032949.1445888-6-andriin@fb.com>
In-Reply-To: <20191016032949.1445888-6-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR21CA0024.namprd21.prod.outlook.com
 (2603:10b6:a03:114::34) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::8bc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0428341e-02aa-4fc9-3061-08d751f753fe
x-ms-traffictypediagnostic: BYAPR15MB2389:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2389C3A1EA55A452907EC2E1D7920@BYAPR15MB2389.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(136003)(39860400002)(346002)(396003)(189003)(199004)(36756003)(52116002)(53546011)(14454004)(31686004)(110136005)(186003)(14444005)(99286004)(76176011)(256004)(6116002)(86362001)(316002)(2201001)(31696002)(2906002)(71200400001)(71190400001)(229853002)(66946007)(66446008)(64756008)(66476007)(66556008)(7736002)(305945005)(2501003)(54906003)(8676002)(102836004)(386003)(81156014)(8936002)(6436002)(6486002)(81166006)(2616005)(25786009)(6506007)(4326008)(6246003)(6512007)(478600001)(476003)(46003)(486006)(4744005)(11346002)(5660300002)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2389;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M9euAgxrbuM52wprwIsVh5ySArR9VajULH8VqGqdV/c3jqc2AB/hsS1jE9mO+ZcWjswLT9uTjvbfafyT/oyDj0UoggjpjPcxxUlAyyQ+kBW8EPe3sH1NlfocxVCOio12sjlgLHZJqjtkAZqLjeyjcrvm4oZmSN3HONXh8SQauM3IvqXv7EmSSzIEdXjjI5fJesMYQ/DA3S1ie0vXPuHVerUfTqiAiV4cWxImXHNONvPjLCRgG97Jh3QbpZjB/Ddzu716AjgnNjxnaSA5YTeTTqTHxhmR96xqKVCzlivLRKuX/QsRtKzxMDgGIdR+D1CT9ARQ0fkskRVHe6RujAYA+aWYh96RQaGUGV0EKHOtvtbRWotaTlsRsRyR//Av+5VaYjx66huT73S7dOC582SG6fheaCuYRWSz3AaJCIIwu9o=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7F2C3A0AE98594D9A52751B4BF519F0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0428341e-02aa-4fc9-3061-08d751f753fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 05:11:40.6122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rWfXTfkDgEFjbUcMIvOdNqhUPp+/RAGH7Ip9+nEDtGk4TYWSnAjZoy/fQTYnmeZs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2389
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_02:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 mlxlogscore=777
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTUvMTkgODoyOSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBNYWtlZmlsZToy
ODI6IHdhcm5pbmc6IG92ZXJyaWRpbmcgcmVjaXBlIGZvciB0YXJnZXQNCj4gYC9kYXRhL3VzZXJz
L2FuZHJpaW4vbGludXgvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3RfeGRwLm8nDQo+
IE1ha2VmaWxlOjI3Nzogd2FybmluZzogaWdub3Jpbmcgb2xkIHJlY2lwZSBmb3IgdGFyZ2V0DQo+
IGAvZGF0YS91c2Vycy9hbmRyaWluL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90
ZXN0X3hkcC5vJw0KDQpJIHRob3VnaHQgSSBjYW4gbGl2ZSB3aXRoIGl0LCBidXQgbm8uIEl0J3Mg
dG9vIGFubm95aW5nLg0KQW55IG1ha2UgY2xlYW4gb3IgbWFrZSBwcmludHMgaXQuDQoNCkFsc28g
bG9va2luZyBhdCBjb21taXQgZjk2YWZhNzY3YmFmICgic2VsZnRlc3RzL2JwZjogZW5hYmxlICh1
bmNvbW1lbnQpIA0KYWxsIHRlc3RzIGluIHRlc3RfbGliYnBmLnNoIikgdGhhdCBpbnRyb2R1Y2Vk
IHRoaXMgc3R1ZmYuLi4NCkkgdGhpbmsgaXQncyBhbGwgb2Jzb2xldGUgbm93Lg0KdGVzdF9saWJi
cGYqIGNhbiBiZSByZW1vdmVkLiB0ZXN0X3Byb2dzIG5vd2FkYXlzIGRvIGEgbG90IG1vcmUNCnRo
YW4gdGhpcyBtaW5pLXRlc3QuDQpEb2luZyBhIHRlc3Qgd2l0aCBjbGFuZyBuYXRpdmUgfCBsbGMg
LW1hcmNoPWJwZiBpcyBzdGlsbCB1c2VmdWwsDQpidXQgYXQgdGhpcyBzaGFwZSBvZiB0ZXN0X2xp
YmJwZiBpdCdzIHBvaW50bGVzcyB0byBjb250aW51ZSBkb2luZyBzby4NClN1Y2ggY2xhbmcgbmF0
aXZlIHRlc3Qgc2hvdWxkIGJlIHByb3Blcmx5IGludGVncmF0ZWQgaW50byB0ZXN0X3Byb2dzLg0K
Rm9yIG5vdyBJIHN1Z2dlc3QgdG8gcmVtb3ZlIHRoaXMgZXh0cmEgdGVzdF94ZHAubyByZWNvbXBp
bGF0aW9uDQphbmQgcmVtb3ZlIHRlc3RfbGliYnBmKg0K
