Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3F5CFD3A
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfJHPLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:11:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16138 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727635AbfJHPLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:11:02 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x98FAmrn008935;
        Tue, 8 Oct 2019 08:10:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=pey4HVVXSEn2tMg0K6ayjnLcdp+GqRCUltjrdCYIZBA=;
 b=I3mBGF851/P0SbCCfXYAnkLNPkfVFARYObBqRXFXUI0cK+ouF8v5pR0MoHQgF6EMch+p
 KPQ7psIhSpPCx5Cr+nHWR/HKDIzjUdrwerwGH8S6kFD+Pc3EbC1LibbNr9wkFwpQkstm
 qYMFwUhXzvJkk+ThE9ylYDc2z1Pxd6oA6Vs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vgvc7r5aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Oct 2019 08:10:48 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Oct 2019 08:10:10 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Oct 2019 08:10:09 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 8 Oct 2019 08:10:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZxPEU3tPRxUv/NHjt7MzcVGCWFwg2NWkjgKLNg9TWqTzz2c5n/2sprSERZWUssmmqIIKGFHiLy+76Kjem0sM/xHe6ZPcHiAWH1Ouoq8fXi+fZ4qL2n7c708ix1TTKQO8NcRZnjGgAMvR0R0PNhCq38jj9mNsgP3KpYXUHho8RIi+8KsiHc3ccHgQvY1TdOZQ/AoeZNPzsh5bXyatAuUrw8isCMw4pLumomYomI2iqNMyz07ug6pY4jAw8D5IpKq7lLgMTpzQ8XXlSgcQZNnuOZH5f89sP2+UgbM7fihZPTePkhNSJF8jOgvKwhltRKBWBBW6ZrQM/6WA0iy6GgbNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pey4HVVXSEn2tMg0K6ayjnLcdp+GqRCUltjrdCYIZBA=;
 b=hF7ZouKF+3v2IVJ4nPU4n2otzp0Eo2PbCfk/KCQjZBHBCqIXNkSzWq3rN4A4WFK65B5oMFvbdjYp6OrGAg0+D8lddm3uaUUNkYQwgakIg1j5h9r24bNa1YXQx080+6PXi00rwnYEz3I/8m07WCfrJPZhUJ7ib4WofcsFyww77q3y8GXl6RDmQnjxjHyjeGj15vsL9VkuNUnH42wtxETELUIjBH+N//bdVV+mCLcOqpN6YXGjmfcDh03aMcnNBwm8CIuXdD4auSxDOaOi+ZyDw2lnHM8XP0ZEuGsz169JSxwTQFHz1ObV+Y39MNPbcxF6M5GEpsiqiTgzidZzUuKVWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pey4HVVXSEn2tMg0K6ayjnLcdp+GqRCUltjrdCYIZBA=;
 b=MxmTXNgdBfUXGgrvDyVsSQsE8dDjIsfZ1Tf1ru2oKpuF2QT8zdYB38nuyPsjSMUKAiQSIIadHAdYnozRD3yVcIye32LkgUU/ksRTHblLALxQPb+nsHoG6kUiRkV8daI7kDkq9SKDzLkPyolhhzVj7+OMBU8g2J/F6rnW6mIwtpk=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2982.namprd15.prod.outlook.com (20.178.237.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 15:10:08 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.026; Tue, 8 Oct 2019
 15:10:08 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 6/7] libbpf: add
 BPF_CORE_READ/BPF_CORE_READ_INTO helpers
Thread-Topic: [PATCH v4 bpf-next 6/7] libbpf: add
 BPF_CORE_READ/BPF_CORE_READ_INTO helpers
Thread-Index: AQHVfWFOcTsVfqP3i0KD6451oBFXlKdQLrSAgAAWI4CAAJVTAA==
Date:   Tue, 8 Oct 2019 15:10:08 +0000
Message-ID: <5411bdae-a723-6dd3-d35a-8ec825924b4e@fb.com>
References: <20191007224712.1984401-1-andriin@fb.com>
 <20191007224712.1984401-7-andriin@fb.com>
 <035617e9-2d0d-4082-8862-45bc4bb210fe@fb.com>
 <CAEf4Bzbe8mKFfd9yAN-i=f6jG50VL5SEqjVJTBcUe8=5eStYJA@mail.gmail.com>
In-Reply-To: <CAEf4Bzbe8mKFfd9yAN-i=f6jG50VL5SEqjVJTBcUe8=5eStYJA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0071.namprd05.prod.outlook.com
 (2603:10b6:102:2::39) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::c253]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 709d0223-3ce3-4a33-5c65-08d74c019b59
x-ms-traffictypediagnostic: BYAPR15MB2982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB29822509D547C8F4AC44CC01D79A0@BYAPR15MB2982.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(396003)(39860400002)(376002)(189003)(199004)(25786009)(186003)(2906002)(52116002)(6116002)(99286004)(7736002)(305945005)(86362001)(11346002)(256004)(229853002)(64756008)(66446008)(66946007)(14444005)(66556008)(6436002)(66476007)(46003)(6486002)(486006)(446003)(316002)(476003)(2616005)(4744005)(54906003)(76176011)(4326008)(53546011)(31696002)(6512007)(102836004)(8936002)(6506007)(14454004)(386003)(6246003)(31686004)(6916009)(71190400001)(81156014)(8676002)(71200400001)(36756003)(478600001)(81166006)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2982;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PMKegaNI4Oc33oOUBCLEFdOd6GfKRxwU6KOZVGxgRQ7jRQoCR/aRQYsmpL8BixOQUCMSQqUVfP5u1qAQ5L+nlK7T4O581rJvy+joTRNL3da57fefSdTN9Ssg2cfGN5wuStTqV4vBGWH6ZktkNiD4gSM8VMffRCiERsX5TNxmlObukPR4oU4/9L6oxcOw/RAigNhazYXSKM/glWlrSn/Nt/jENpk4eEHzOS/H5nii4t8+E38l68qmhssKHMxXVd4PGQc7wdd3gI2+xt2FudeHTBocEzF8fJMEawneLm+gqGZiOiMNvXtghbsPOasRscLPVBkCz0g+ok27RM7hB3YuiHJkv8Voco8IpTjT/XlhLh3+a27SOlZG4qKbSf2jhlHUpAXsCu+rjfmr2GJi7Yq0rLSUaIvt6JwbgI2A1j6kiQk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1171DBD6DE25734BBA28C4B1038C1BB6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 709d0223-3ce3-4a33-5c65-08d74c019b59
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 15:10:08.4635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: knodDyEG6WnTVCOsCSnhrJ0p+vtTsYfXjaRX1FcIsJwp0Sd7b6ZPbTvvu9QJQYPU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2982
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-08_06:2019-10-08,2019-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 mlxlogscore=852 impostorscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910080135
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvNy8xOSAxMToxNSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPj4+ICsjZGVmaW5l
IEJQRl9DT1JFX1JFQUQoc3JjLCBhLCAuLi4pICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgXA0KPj4+ICsgICAgICh7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPj4+ICsgICAgICAgICAgICAgX19f
dHlwZShzcmMsIGEsICMjX19WQV9BUkdTX18pIF9fcjsgICAgICAgICAgICAgICAgICAgICAgICAg
XA0KPj4+ICsgICAgICAgICAgICAgQlBGX0NPUkVfUkVBRF9JTlRPKCZfX3IsIHNyYywgYSwgIyNf
X1ZBX0FSR1NfXyk7ICAgICAgICAgICAgXA0KPj4+ICsgICAgICAgICAgICAgX19yOyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPj4+ICsg
ICAgIH0pDQo+Pj4gKw0KPj4gU2luY2Ugd2UncmUgc3BsaXR0aW5nIHRoaW5ncyBpbnRvDQo+PiBi
cGZfe2hlbHBlcnMsaGVscGVyX2RlZnMsZW5kaWFuLHRyYWNpbmd9LmgNCj4+IGhvdyBhYm91dCBh
ZGRpbmcgYWxsIGNvcmUgbWFjcm9zIGludG8gYnBmX2NvcmVfcmVhZC5oID8NCj4gb2ssIGJ1dCBt
YXliZSBqdXN0IGJwZl9jb3JlLmggdGhlbj8NCg0KYnBmX2NvcmUuaCBpcyB0b28gZ2VuZXJpYy4g
SXQgZWl0aGVyIG5lZWRzIHRvIGJlIGNhcGl0YWxpemVkLA0Kd2hpY2ggaXMgdW5oZWFyZCBvZiBm
b3IgaGVhZGVyIGZpbGVzIG9yIHNvbWUgc3VmZml4IGFkZGVkLg0KSSB0aGluayBicGZfY29yZV9y
ZWFkLmggaXMgc2hvcnQgZW5vdWdoIGFuZCBkb2Vzbid0IGxvb2sgbGlrZQ0KYnBmX2NvcmVfd3Jp
dGUuaCB3aWxsIGJlIGNvbWluZyBhbnkgdGltZSBzb29uLg0KSWYgeW91J3JlIHdvcnJpZWQgYWJv
dXQgX3JlYWQgcGFydCB0aGVuIG1heSBiZQ0KYnBmX2NvcmVfYWNjZXNzLmggPw0KDQo=
