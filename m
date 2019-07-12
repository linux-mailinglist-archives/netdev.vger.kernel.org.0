Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA18667534
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 20:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfGLSsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 14:48:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26194 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727028AbfGLSsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 14:48:22 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CIlnQo022154;
        Fri, 12 Jul 2019 11:48:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=k8GvEDWlZi8NIeLVDMwTWojQSByEsrE6AAuWV+kKjGQ=;
 b=pq46gdpWRwLm6FuQ+LA0LWDrymCLe69J0JNKsUEdpYAVXikZpVFAtai2Bji/rOPA1KFl
 XOkFKAr8V/X5Fj1T5bd9zbLB9TeSjSlMW8pJqNB/i1AJQK0XMfqi4UIaXN2K9MMH1FCd
 b3vXJFMvgfDymiUeBR1W3Iz1iRpNsUeONyg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tpvsg8qxg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 12 Jul 2019 11:48:01 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 12 Jul 2019 11:47:59 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 12 Jul 2019 11:47:59 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 12 Jul 2019 11:47:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBcKI3rKAFKjfyaWc/2mRyeCZDRSFHHtifECXsrwxIT4TwIUPyamYi1R4XiDBgLLbIZMO67k+Oj+THlenIPgpiT7xhxRkhPSUocx3Hvx+4Q7035Qo62puZctjrwYvviDzcYEuIhns8Qj2cLXiJNA+zEorHot3dkiXj1W7PkPdHiGW4S0+/eZ8Kmr+49C3EE/xEF1H86InBz2qhG+f5q2b2N07qpc5zosUghOBUSQlyYEg9BEe8iOQP9NU9oirdRkzSVX+HYWVO/0RF/7EawpsuagLvbS0A3k/Z4YhAKkiHPx5HK7XDy7COnFTDn81GFML2fV6BVQipYVf28ZCjhI9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8GvEDWlZi8NIeLVDMwTWojQSByEsrE6AAuWV+kKjGQ=;
 b=M8HiVtltaVDeG6iyeR6be68zqdZgT1nMr0tzKbAgmyuDAt7BVnbcHfho8hsMEypP0meXy3mV+52Vsgbj5mFKeaSe00YMVq8XOjTJEOqaDAPZjJIrXkhTERi5JBpVIktlb9fS4XWckWjrXRc+H3W6fYVdCFIdOEMPUoBn3k35u2ZljVxFMwKHV7duNh4iAeIDGOIM4lMZVHfg1pBCF5D+hO/O5rGsEgAj2DbYEZ61iCIYFHJOMy1K9o1/c3lL8CMQqAJi42g7s7RjCKwkZu5ftlnYYertS5OY2CpUwKbi53zgC+YyEN5MjBlBpW+RtK2dGipI3r0ILq1oicChFsZx9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8GvEDWlZi8NIeLVDMwTWojQSByEsrE6AAuWV+kKjGQ=;
 b=ce6ZLM8risFb5mERPsn2tpVFtLMHxF68EGLxSBrYCOfhgYUqQo2xCQvGlpfeGDhtiZPHhRistNTlQm4NKP5CY8H1pkciDcKN/0wwwJaj6D+UrF3iyXmP3ykeaJs5d4LJVN2Rm21SMyFdE/w07zEHG2kEhnuRtW10xt8dmBq7If4=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2550.namprd15.prod.outlook.com (20.179.155.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.13; Fri, 12 Jul 2019 18:47:58 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 18:47:58 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf 0/3] fix BTF verification size resolution
Thread-Topic: [PATCH v3 bpf 0/3] fix BTF verification size resolution
Thread-Index: AQHVONb1pObguWE3KUKAMhctrHBJgabHUuqA
Date:   Fri, 12 Jul 2019 18:47:58 +0000
Message-ID: <f8cca66f-805e-ce64-5f74-6a382837611b@fb.com>
References: <20190712172557.4039121-1-andriin@fb.com>
In-Reply-To: <20190712172557.4039121-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::26) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:9d19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87c78784-2a3f-4648-89ee-08d706f9755d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2550;
x-ms-traffictypediagnostic: BYAPR15MB2550:
x-microsoft-antispam-prvs: <BYAPR15MB25507620060549FFDB35920AD3F20@BYAPR15MB2550.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(366004)(376002)(346002)(199004)(189003)(6486002)(99286004)(86362001)(31696002)(7736002)(36756003)(25786009)(8676002)(53546011)(6506007)(386003)(102836004)(186003)(446003)(6246003)(6116002)(476003)(6512007)(11346002)(305945005)(478600001)(52116002)(46003)(2906002)(53936002)(229853002)(2616005)(71190400001)(71200400001)(6436002)(2501003)(76176011)(54906003)(31686004)(4326008)(110136005)(316002)(256004)(486006)(4744005)(2201001)(66556008)(64756008)(66446008)(66476007)(8936002)(14454004)(81156014)(5660300002)(66946007)(68736007)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2550;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Caoq9C1wijxuf3h281SyrohhawnYkeovwRyhDcneBJKgXnNuq3aZ9wXhPPdNZBnzntHMytzwtl/dPSCkXLkVKzpJO+ZRHgGhq+UjFA7GbOypJvTuklCQHrgUZwH2+OrJ7MpFaU5JrLRvlQS/72U1AGd8r5PcPufl+0Bj0Q68EYIatUz6satEoF6vHTHGkhpYsUdS/oZyhUn7ia/Nk3XKVEHrKOsN/VmwiFEgiy0GOdtWHOFRcdhld/MX2o9n5zY7YWFoX8uIgE/QM4Twd1yd9ex5Gex/H6gIMmyRehzGSVJItzcpHCN7vIAWd9U2paEmVn6FJq8LH63VxaEtL35wUSlWHrCoCwfqYH5WjWhYwtP6u5QEs/20TfcNxklqVgpAhKcUgGjwL+qktfJZH7MSmNqNJ29SEBjKxucDyE93tGk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8E6FB7FB3FC4E4BA2E2B3723C6420F2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c78784-2a3f-4648-89ee-08d706f9755d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 18:47:58.4590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2550
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=927 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMTIvMTkgMTA6MjUgQU0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gQlRGIHNp
emUgcmVzb2x1dGlvbiBsb2dpYyBpc24ndCBhbHdheXMgcmVzb2x2aW5nIHR5cGUgc2l6ZSBjb3Jy
ZWN0bHksIGxlYWRpbmcNCj4gdG8gZXJyb25lb3VzIG1hcCBjcmVhdGlvbiBmYWlsdXJlcyBkdWUg
dG8gdmFsdWUgc2l6ZSBtaXNtYXRjaC4NCj4gDQo+IFRoaXMgcGF0Y2ggc2V0Og0KPiAxLiBmaXhl
cyB0aGUgaXNzdWUgKHBhdGNoICMxKTsNCj4gMi4gYWRkcyB0ZXN0cyBmb3IgdHJpY2tpZXIgY2Fz
ZXMgKHBhdGNoICMyKTsNCj4gMy4gYW5kIGNvbnZlcnRzIGZldyB0ZXN0IGNhc2VzIHV0aWxpemlu
ZyBCVEYtZGVmaW5lZCBtYXBzLCB0aGF0IHByZXZpb3VzbHkNCj4gICAgIGNvdWxkbid0IHVzZSB0
eXBlZGVmJ2VkIGFycmF5cyBkdWUgdG8ga2VybmVsIGJ1ZyAocGF0Y2ggIzMpLg0KPiANCj4gQW5k
cmlpIE5ha3J5aWtvICgzKToNCj4gICAgYnBmOiBmaXggQlRGIHZlcmlmaWVyIHNpemUgcmVzb2x1
dGlvbiBsb2dpYw0KPiAgICBzZWxmdGVzdHMvYnBmOiBhZGQgdHJpY2tpZXIgc2l6ZSByZXNvbHV0
aW9uIHRlc3RzDQo+ICAgIHNlbGZ0ZXN0cy9icGY6IHVzZSB0eXBlZGVmJ2VkIGFycmF5cyBhcyBt
YXAgdmFsdWVzDQoNCkxvb2tzIGdvb2QgdG8gbWUuIEFjayBmb3IgdGhlIHdob2xlIHNlcmllcy4N
CkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KDQo+IA0KPiAgIGtlcm5lbC9i
cGYvYnRmLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IDE5ICsrLS0NCj4gICAuLi4v
YnBmL3Byb2dzL3Rlc3RfZ2V0X3N0YWNrX3Jhd3RwLmMgICAgICAgICAgfCAgMyArLQ0KPiAgIC4u
Li9icGYvcHJvZ3MvdGVzdF9zdGFja3RyYWNlX2J1aWxkX2lkLmMgICAgICB8ICAzICstDQo+ICAg
Li4uL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9zdGFja3RyYWNlX21hcC5jIHwgIDIgKy0NCj4g
ICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9idGYuYyAgICAgICAgfCA4OCArKysr
KysrKysrKysrKysrKysrDQo+ICAgNSBmaWxlcyBjaGFuZ2VkLCAxMDQgaW5zZXJ0aW9ucygrKSwg
MTEgZGVsZXRpb25zKC0pDQo+IA0K
