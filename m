Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA55B256F
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 20:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390056AbfIMSx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 14:53:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53402 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389162AbfIMSxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 14:53:55 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8DIrSPf004210;
        Fri, 13 Sep 2019 11:53:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6HqISgcjNNC/undJB7upiM0/LwavMzIKB0H7nFu3lJw=;
 b=Sf5Jxs/zCPTJTJu3ft6hXStu9C/O9i8RjMXi3FyKknTSi7KRSWuKUKUlqEsyAbQu4LXj
 xsJPfiE4mOi9dVj2EUgVGS6YJNHzJ7Ru/ZaLh8pnYi6gorPKbRj8SCsI6qBqF5JSlNR/
 fLwY6nq9U6cMWfBH6TMOEOcF9iXD0GoBd98= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uytcswk8r-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Sep 2019 11:53:31 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Sep 2019 11:53:21 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 11:53:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWOM4P4dM+yyL4NcFECpL9ggltHq7vtVx1MEHFzCtGCcFvjbuuQ1QPJv723ZCv7RyeQWH+NWOaZgPQWAhNXtsrWOMTxJUlEv7peN/c1qWvRekGM6whVfzo+p9XhKvc7CtlhuNkAuABum2kUAAV2jTAb1DLABe/Kg0db5juGLlnA/yGDdKgq/8MkT9mzkTQi/MFUb/Hp2hhAHqXi8/pTom/GBk/yaXYB0RK9t3Ep6PuNrYpMEblBCWhITpbU3ZnQyIsalFUCm9GQ7rf3IAl2uCVjE+lPxbqfcQJ7cULfHpzkioNWje5z4/6KlBVdWhPyO6G8DdJ/LrU42Cuk0WyKIZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6HqISgcjNNC/undJB7upiM0/LwavMzIKB0H7nFu3lJw=;
 b=f3U/McGPdtiq8HDzVzMHR2IHP6jYM/Fv1LBjpFC2C3M68NvYqoytYxU2nSujKaAtdgnJYsAJ8NKYNQ2cfkjcsMSXWhMBmAJjYXnnzBbPS5+iDw4gj7/T3SOxczgf4VdKjZxfrphvDjk4I5EEBTqfp9WeXmt6CMH/DieKPODo3mWY8u4JPkrFSunzaKeatejqKiD+7FVYtjX3jESLbjppdFNo8aFz/LxMlPvjyADDmwyf45iy5Px/GjIoEMaE6z6KR4XWPYuywn+yLw6RsvyqN2Q0MnXRJEjVEFaAlpL8mbDRVYbOax3oU/4x/cBLAj+iKLSRRLb2q8Nv3Q8wVFDzcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6HqISgcjNNC/undJB7upiM0/LwavMzIKB0H7nFu3lJw=;
 b=a98fAFqa93wWprakuT0N3NHIIf7hP5iI8lqh7rtNASAyPciVUvrDFANRrnZ1DQ3nVol58CBj44/SFAKd36m4F+wpzNz8pF2uweszZ8fFj/rh3Xdl+Kme66W/Bc63Xcavx4UZmTTsbiy3O8GjRjDHGI2p8DlrtCiUUsFSdkKqo7M=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2919.namprd15.prod.outlook.com (20.178.239.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Fri, 13 Sep 2019 18:53:20 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.021; Fri, 13 Sep 2019
 18:53:20 +0000
From:   Yonghong Song <yhs@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "maximmi@mellanox.com" <maximmi@mellanox.com>
Subject: Re: [PATCH] libbpf: Don't error out if getsockopt() fails for
 XDP_OPTIONS
Thread-Topic: [PATCH] libbpf: Don't error out if getsockopt() fails for
 XDP_OPTIONS
Thread-Index: AQHVZzaNKJS7wgKEt0+HUZnyS02oyKcjoHoAgABXZwCABgKxgA==
Date:   Fri, 13 Sep 2019 18:53:20 +0000
Message-ID: <60651b4b-c185-1e17-1664-88957537e3f1@fb.com>
References: <20190909174619.1735-1-toke@redhat.com>
 <8e909219-a225-b242-aaa5-bee1180aed48@fb.com> <87lfuxul2b.fsf@toke.dk>
In-Reply-To: <87lfuxul2b.fsf@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0060.namprd12.prod.outlook.com
 (2603:10b6:300:103::22) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::ec5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 617b978e-395a-463b-16b4-08d7387ba549
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2919;
x-ms-traffictypediagnostic: BYAPR15MB2919:
x-microsoft-antispam-prvs: <BYAPR15MB2919E1C12490FE1E97A4EB89D3B30@BYAPR15MB2919.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(376002)(366004)(39860400002)(199004)(189003)(186003)(2501003)(6116002)(316002)(14454004)(25786009)(478600001)(99286004)(46003)(102836004)(76176011)(52116002)(386003)(6506007)(53546011)(8676002)(8936002)(2906002)(110136005)(81166006)(81156014)(36756003)(6246003)(53936002)(71200400001)(71190400001)(305945005)(7736002)(229853002)(6486002)(6512007)(6436002)(66446008)(64756008)(66556008)(66476007)(66946007)(446003)(11346002)(2616005)(476003)(2201001)(86362001)(31696002)(5660300002)(486006)(31686004)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2919;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lW294qmMFXBv/7J+PdDqXmKFSYkUetLJqLzhgmCyWf89AiEtI04poA4Ag/LcdLb9/bDTRC1yPYsm7lHi+0zVDO5oqj5kFf7F5rNRrn7d6L2ZQ8wVeqtEFUJgzzXFDpuZv5G60oIfe5+ji/6HjSGMFDxssJY+MjAz2gDjyOAoj36eqh+hmUbJByahb3x9xVO1jBj1I0mpgoHaLvnmj5fMmHhQfmU2yjh06GDjdFg/7GwYKOXwiBMC8Z/Q6kzyJuTdr1cMk75O7wrw8AIEP2EvAh3T86+B8A5SNgOJjzGz6R6AlN9QD0oaZPqnW6Zn9DP8yjmrdAXPRFkA7YsxMQS+oYmxwyuQrNGBHWmkugY235vsCJ/SPabC2Y3iE0M+/SCJes3T9PpggHkrlRH0eP7dp3snNnsek0hsLyNBX/2wLs0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDA554CCBF425346B47DB81BF85B9BE0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 617b978e-395a-463b-16b4-08d7387ba549
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 18:53:20.5295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tsYAz2uCb4HvGVouPZYwUKAvx7MIImEAfHOFCT/FGyxOMI4zvREQJeAOChMMirTp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2919
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_09:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 phishscore=0 clxscore=1011
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909130192
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTAvMTkgMTI6MDYgQU0sIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiB3cm90ZToN
Cj4gWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gd3JpdGVzOg0KPiANCj4+IE9uIDkvOS8xOSAx
MDo0NiBBTSwgVG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIHdyb3RlOg0KPj4+IFRoZSB4c2tfc29j
a2V0X19jcmVhdGUoKSBmdW5jdGlvbiBmYWlscyBhbmQgcmV0dXJucyBhbiBlcnJvciBpZiBpdCBj
YW5ub3QNCj4+PiBnZXQgdGhlIFhEUF9PUFRJT05TIHRocm91Z2ggZ2V0c29ja29wdCgpLiBIb3dl
dmVyLCBzdXBwb3J0IGZvciBYRFBfT1BUSU9OUw0KPj4+IHdhcyBub3QgYWRkZWQgdW50aWwga2Vy
bmVsIDUuMywgc28gdGhpcyBtZWFucyB0aGF0IGNyZWF0aW5nIFhTSyBzb2NrZXRzDQo+Pj4gYWx3
YXlzIGZhaWxzIG9uIG9sZGVyIGtlcm5lbHMuDQo+Pj4NCj4+PiBTaW5jZSB0aGUgb3B0aW9uIGlz
IGp1c3QgdXNlZCB0byBzZXQgdGhlIHplcm8tY29weSBmbGFnIGluIHRoZSB4c2sgc3RydWN0LA0K
Pj4+IHRoZXJlIHJlYWxseSBpcyBubyBuZWVkIHRvIGVycm9yIG91dCBpZiB0aGUgZ2V0c29ja29w
dCgpIGNhbGwgZmFpbHMuDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBUb2tlIEjDuGlsYW5kLUrD
uHJnZW5zZW4gPHRva2VAcmVkaGF0LmNvbT4NCj4+PiAtLS0NCj4+PiAgICB0b29scy9saWIvYnBm
L3hzay5jIHwgOCArKy0tLS0tLQ0KPj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDYgZGVsZXRpb25zKC0pDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi94
c2suYyBiL3Rvb2xzL2xpYi9icGYveHNrLmMNCj4+PiBpbmRleCA2ODBlNjMwNjZjZjMuLjU5OGU0
ODdkOWNlOCAxMDA2NDQNCj4+PiAtLS0gYS90b29scy9saWIvYnBmL3hzay5jDQo+Pj4gKysrIGIv
dG9vbHMvbGliL2JwZi94c2suYw0KPj4+IEBAIC02MDMsMTIgKzYwMyw4IEBAIGludCB4c2tfc29j
a2V0X19jcmVhdGUoc3RydWN0IHhza19zb2NrZXQgKip4c2tfcHRyLCBjb25zdCBjaGFyICppZm5h
bWUsDQo+Pj4gICAgDQo+Pj4gICAgCW9wdGxlbiA9IHNpemVvZihvcHRzKTsNCj4+PiAgICAJZXJy
ID0gZ2V0c29ja29wdCh4c2stPmZkLCBTT0xfWERQLCBYRFBfT1BUSU9OUywgJm9wdHMsICZvcHRs
ZW4pOw0KPj4+IC0JaWYgKGVycikgew0KPj4+IC0JCWVyciA9IC1lcnJubzsNCj4+PiAtCQlnb3Rv
IG91dF9tbWFwX3R4Ow0KPj4+IC0JfQ0KPj4+IC0NCj4+PiAtCXhzay0+emMgPSBvcHRzLmZsYWdz
ICYgWERQX09QVElPTlNfWkVST0NPUFk7DQo+Pj4gKwlpZiAoIWVycikNCj4+PiArCQl4c2stPnpj
ID0gb3B0cy5mbGFncyAmIFhEUF9PUFRJT05TX1pFUk9DT1BZOw0KPj4+ICAgIA0KPj4+ICAgIAlp
ZiAoISh4c2stPmNvbmZpZy5saWJicGZfZmxhZ3MgJiBYU0tfTElCQlBGX0ZMQUdTX19JTkhJQklU
X1BST0dfTE9BRCkpIHsNCj4+PiAgICAJCWVyciA9IHhza19zZXR1cF94ZHBfcHJvZyh4c2spOw0K
Pj4NCj4+IFNpbmNlICd6YycgaXMgbm90IHVzZWQgYnkgYW55Ym9keSwgbWF5YmUgYWxsIGNvZGVz
ICd6YycgcmVsYXRlZCBjYW4gYmUNCj4+IHJlbW92ZWQ/IEl0IGNhbiBiZSBhZGRlZCBiYWNrIGJh
Y2sgb25jZSB0aGVyZSBpcyBhbiBpbnRlcmZhY2UgdG8gdXNlDQo+PiAnemMnPw0KPiANCj4gRmlu
ZSB3aXRoIG1lOyB1cCB0byB0aGUgbWFpbnRhaW5lcnMgd2hhdCB0aGV5IHByZWZlciwgSSBndWVz
cz8gOikNCg0KTWF4aW0sDQoNCllvdXIgb3JpZ2luYWxseSBpbnRyb2R1Y2VkIGAnemMnIGFuZCBn
ZXR0aW5nIFhEUF9PUFRJT05TLg0KV2hhdCBpcyB5b3VyIG9waW5pb24gb2YgaG93IHRvIGRlYWwg
d2l0aCB0aGUgdW51c2VkIHhzay0+emM/DQoNCj4gDQo+IC1Ub2tlDQo+IA0K
