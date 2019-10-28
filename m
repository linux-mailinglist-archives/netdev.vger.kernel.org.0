Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F91E7532
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 16:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbfJ1Pcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 11:32:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47190 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726323AbfJ1Pcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 11:32:53 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9SFLWxx007336;
        Mon, 28 Oct 2019 08:32:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hocJIu0tlAZ+1ba2AlJ3FY+F+oaDxBfAGd5sNVxB60M=;
 b=IFbysQKd5KeHFwI3IRASfmIHBD9BNlk4pjFm4b/N8I3ZnRr3CA6G89avh03dJbV3Pwvo
 5pskV5SY9eBEuLGj48Jp0hXQukgA7FgLsUSZUIgAkOATCmNqpr7jb16EAtbl+7CBlm0P
 6vMin403mviNaJVEZFKGJSEJL5a+bkXjBsM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vw5tedn5n-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Oct 2019 08:32:37 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 28 Oct 2019 08:32:35 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 28 Oct 2019 08:32:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fn7EMAIstVF+Bi3s6ftF4I9asxhr1th34Ztfwf/MP6M5R+F4lEH/Bjwa5z2H/h2jST40g3np3ThfyL+TiL1DwNAHwHV6S7D9FfXsZQDl7P028yW3iGi+tbw+ZkLYQjkGcga+xV8fTSm3mSLZRxT+ThB+ZESF5x0/6mdsPnCyEFMmml9apUAWLW0c4Q4ktYRdhPMP8noKFMNh6k+2d685+cup4J0WebhTCH/l6fo1J6mwFGlK/cttQVQpI2RZyItoPd+7FRzDI1oXXatzs2okn1uHWGeb56rL5YJv6+9M4mzQVw6WrytihqFsFtcj1YY+1VEhxh2YJdmB689Km6VdKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hocJIu0tlAZ+1ba2AlJ3FY+F+oaDxBfAGd5sNVxB60M=;
 b=fwylyqGo/zLZ4+GJeqW9G1voAVLr9m/YCv/+jeeOOOmNe4lybq8Kx9I3vSihhSsi/T08ZNWQwH3NIm1Y/mBXROCk/QK8c6leDLU3d0PJmvUQNQJU0jCrYEE6/f79gm1lIP82wwV3ERHD3ScH+wFHF5vsgLaBSsqQWSVDbshgPpoMID8CG/+q5SLlxw8K9JA+kYObhY3/33LOjZ7bseKeUMgFdBN6LiMYEqGcSnwtvxKS3GtSH9ssSKmFjOSfuY+Gg1pS6w7raWHkCUs00IdH+l0GQinwAqzFddX6KaQGLVd+UFCv5g9sZM6Pfa8gRqjCOI22th3Oba5MBcmJC28X/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hocJIu0tlAZ+1ba2AlJ3FY+F+oaDxBfAGd5sNVxB60M=;
 b=GOEUqNQf/HhzZyVxidATeySd8RLqAY3OMxefJNvoYwjU9c/40CPCeEi0jtS5AnoFdah5BpWl3wekiFvmjdOQsdKTx3su2XBk6+c+gx9V8OuxjCMMK84cuAcsnXfQVI8c5lIBBvGKy6P1dxrtquVfFwWkalTXRR7962CNInUOTpQ=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3095.namprd15.prod.outlook.com (20.178.239.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Mon, 28 Oct 2019 15:32:27 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.021; Mon, 28 Oct 2019
 15:32:27 +0000
From:   Yonghong Song <yhs@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "David Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 4/4] selftests: Add tests for automatic map
 pinning
Thread-Topic: [PATCH bpf-next v3 4/4] selftests: Add tests for automatic map
 pinning
Thread-Index: AQHVjQia1fv19x2VTE6bg++ySY3NyadwBu4AgAACqgCAACYggA==
Date:   Mon, 28 Oct 2019 15:32:26 +0000
Message-ID: <483546c6-14b9-e1f1-b4c1-424d6b8d4ace@fb.com>
References: <157220959547.48922.6623938299823744715.stgit@toke.dk>
 <157220959980.48922.12100884213362040360.stgit@toke.dk>
 <20191028140624.584bcc1e@carbon> <87imo9roxf.fsf@toke.dk>
In-Reply-To: <87imo9roxf.fsf@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0085.namprd04.prod.outlook.com
 (2603:10b6:104:6::11) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:ec6a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03f6f8bb-046d-44ed-1f4e-08d75bbc0943
x-ms-traffictypediagnostic: BYAPR15MB3095:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB309585202BAB6E77E8C0E9E8D3660@BYAPR15MB3095.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(136003)(376002)(39860400002)(199004)(189003)(6246003)(6436002)(11346002)(478600001)(102836004)(71200400001)(386003)(6506007)(53546011)(71190400001)(86362001)(5660300002)(186003)(6512007)(76176011)(229853002)(14454004)(6116002)(36756003)(6486002)(8936002)(256004)(54906003)(4326008)(81166006)(2906002)(8676002)(81156014)(486006)(446003)(31696002)(476003)(2616005)(66574012)(7736002)(305945005)(31686004)(110136005)(25786009)(316002)(46003)(66556008)(99286004)(66476007)(66446008)(64756008)(66946007)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3095;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2bamUK6kiD17c47eKLJcT5BGJRUJPTVIhrF36es5D1Zzn4lJQ3OI5kyUJIgiG0y4pvLjD6lusEN0vH9bH52H6fwbFAoY0/WA+jmqqkac5evcidOehOr9prRMcJm9Gqj8C/gInQ+MSSvGiFe3bpvHsdvtYZX7CujzZx8HGIe16JcNU0aIcE4xP747Mzam8CLOxPOP0I4FM+OdueJHvGjXKgxZcTVdGA3TzJ2UWztT6B2GiROtgs8mpkwb1oC/STcQZ4vTLjv8fpKdDbrNSeW2eiYUS5qxoy+QoSkshwMk+akVfT4AqmVFY9GwonEa8JXFj3xbgbknCG4Jfd7SQmlVd8yGylkAw8VpDdj3Lqcfcisn7Sc2dZLTSHPj311wP6HhEEk0QFYMbBPGOLniI+pBhAdJ93iJ8niGjNAL3rTqeZv/VBa40EbGbUhm4sRe9HTc
Content-Type: text/plain; charset="utf-8"
Content-ID: <E860019A318CFE4BB91DBC95015A5665@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 03f6f8bb-046d-44ed-1f4e-08d75bbc0943
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 15:32:26.6136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qw4TltMiJJWNK1PgaL2vgdtGiJDMYsiZgTsneeoB6TuZIvYd+4UXZMyjDcAMEKYp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3095
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-28_06:2019-10-28,2019-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910280156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzI4LzE5IDY6MTUgQU0sIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiB3cm90ZToN
Cj4gSmVzcGVyIERhbmdhYXJkIEJyb3VlciA8YnJvdWVyQHJlZGhhdC5jb20+IHdyaXRlczoNCj4g
DQo+PiBPbiBTdW4sIDI3IE9jdCAyMDE5IDIxOjUzOjE5ICswMTAwDQo+PiBUb2tlIEjDuGlsYW5k
LUrDuHJnZW5zZW4gPHRva2VAcmVkaGF0LmNvbT4gd3JvdGU6DQo+Pg0KPj4+IGRpZmYgLS1naXQg
YS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9waW5uaW5nLmMgYi90b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9waW5uaW5nLmMNCj4+PiBuZXcgZmls
ZSBtb2RlIDEwMDY0NA0KPj4+IGluZGV4IDAwMDAwMDAwMDAwMC4uZmYyZDc0NDc3NzdlDQo+Pj4g
LS0tIC9kZXYvbnVsbA0KPj4+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9n
cy90ZXN0X3Bpbm5pbmcuYw0KPj4+IEBAIC0wLDAgKzEsMjkgQEANCj4+PiArLy8gU1BEWC1MaWNl
bnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4+PiArDQo+Pj4gKyNpbmNsdWRlIDxsaW51eC9icGYu
aD4NCj4+PiArI2luY2x1ZGUgImJwZl9oZWxwZXJzLmgiDQo+Pj4gKw0KPj4+ICtpbnQgX3ZlcnNp
b24gU0VDKCJ2ZXJzaW9uIikgPSAxOw0KPj4+ICsNCj4+PiArc3RydWN0IHsNCj4+PiArCV9fdWlu
dCh0eXBlLCBCUEZfTUFQX1RZUEVfQVJSQVkpOw0KPj4+ICsJX191aW50KG1heF9lbnRyaWVzLCAx
KTsNCj4+PiArCV9fdHlwZShrZXksIF9fdTMyKTsNCj4+PiArCV9fdHlwZSh2YWx1ZSwgX191NjQp
Ow0KPj4+ICsJX191aW50KHBpbm5pbmcsIExJQkJQRl9QSU5fQllfTkFNRSk7DQo+Pj4gK30gcGlu
bWFwIFNFQygiLm1hcHMiKTsNCj4+DQo+PiBTbywgdGhpcyBpcyB0aGUgbmV3IEJURi1kZWZpbmVk
IG1hcHMgc3ludGF4Lg0KPj4NCj4+IFBsZWFzZSByZW1pbmQgbWUsIHdoYXQgdmVyc2lvbiBvZiBM
TFZNIGRvIHdlIG5lZWQgdG8gY29tcGlsZSB0aGlzPw0KPiANCj4gTm8gaWRlYSB3aGF0IHRoZSBt
aW5pbXVtIHZlcnNpb24gaXMuIEknbSBydW5uaW5nIExMVk0gOS4wIDopDQoNCkxMVk0gOS4wIHN0
YXJ0cyB0byBzdXBwb3J0IC5tYXBzLg0KVGhlcmUgaXMgbm8gZGVwZW5kZW5jeSBvbiBwYWhvbGUu
DQoNCj4gDQo+PiBPciB3YXMgdGhlcmUgYSBkZXBlbmRlbmN5IG9uIHBhaG9sZT8NCj4gDQo+IERv
bid0IHRoaW5rIHNvLi4uDQo+IA0KPiAtVG9rZQ0KPiANCg==
