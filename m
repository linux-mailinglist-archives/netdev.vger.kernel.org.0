Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B19E217A
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 19:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfJWRMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 13:12:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48822 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727154AbfJWRMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 13:12:00 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9NHAjU2002528;
        Wed, 23 Oct 2019 10:11:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=i73jafUwadDHJEBZWrw1NGSGxQ1ms9yLDbKHz64CELc=;
 b=KECIyXruURKKG+EJt0mG9X9MChJP3P0d4/AydqVlB4ZM1kdwQ+taOXjWl+EYVkkUCxL0
 PKzM6jfi93hKpDIojZeMM52PTzaFip2E7Imunc7JfvTv2c3AfszOg5Zh01lu82xEIatj
 YK564x17P2fvsxtaZdSL4pOWuQhJeuxsjpc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vt9tt4fcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Oct 2019 10:11:46 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 23 Oct 2019 10:11:45 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 23 Oct 2019 10:11:45 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 23 Oct 2019 10:11:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOkT87fR8Vm86IH79J3FF2Lenx1cFOHL+TLEDNgTfV68OvnhehtTPKJSfNWEJac7lXSsAV+a6Y8ynbbvg5xDzLbIGLQ226iL2Q7c9Blm5ByyD1fmouncp7sba2oKN/Cp8D97jSYInrvJA6GrvFyd8wtQPSmUU3EFDP7P5w5oFRVI6lC0n6UC2L5fUSzx0uUkTXa2dG8zrNJS9ybt16m2PHfcGA0T9yqevkgLjqt2qPX5v+tyz7Nq4eHVDcw1GhxZAHR6t1ffMH2U3lPsCmi2yszfyv8Q1MDMQ/PugC8mqGC3ZFuKi01EApAXMnkKFLRVjOevqMVSqdtkF9JdugMfEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i73jafUwadDHJEBZWrw1NGSGxQ1ms9yLDbKHz64CELc=;
 b=VfNlhfFDwZ6OYeHjrry8tqC8fNnrHz62r8eN8bceLnyq2J0PmY/cghcTd5S6GvCnvd1kCHHzdMGKe5M6x9piWvIVu4//p6vk6bNkofMDn5h5fEieDjaup1UZNAnuhUWwORPj0fQb0eAsXRG6g8QA/qwUFcWtdHfQjaEn82uDNVWXx6upFMCeSaYrY9RtiNLo0juefstoEFRpsymd/TMVVyAjnwzit2za2urCUxpjBt1WlInEPWREIzYs+m6OgUGLTmBGC/9Y/Il511KDsIPG47HazWNjN3Bd5L1Q9z9K/tWt+mHoMAsdZsisBZz1Zj5iCgM+qsr9/5MCnCsb7LFzGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i73jafUwadDHJEBZWrw1NGSGxQ1ms9yLDbKHz64CELc=;
 b=gpH8UBQe3Ly8BYKuX3uri8uqCT+IXrN60w8fox2NmMSDnBU00zrmYhBa0jqvmqlHLwSiZKkwlMsIfgHYXpFyZyQPcG32WWebqwlys9+XavdV3pSRqXrwxl88DVxDB9Qd1iv28MOpmu/i0kHNj4p9N+/mdR0SPaV6JrvrQ+bC0q4=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3432.namprd15.prod.outlook.com (20.179.59.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Wed, 23 Oct 2019 17:11:42 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2367.025; Wed, 23 Oct 2019
 17:11:42 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix LDLIBS order
Thread-Topic: [PATCH bpf-next] selftests/bpf: fix LDLIBS order
Thread-Index: AQHVibb8qHeBBc1cYUqs2bSNljZvPKdodm+A
Date:   Wed, 23 Oct 2019 17:11:42 +0000
Message-ID: <6013d833-bec6-fb9f-f356-2d6e159bc582@fb.com>
References: <20191023153128.3486140-1-andriin@fb.com>
In-Reply-To: <20191023153128.3486140-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR01CA0039.prod.exchangelabs.com (2603:10b6:300:101::25)
 To BYAPR15MB2501.namprd15.prod.outlook.com (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::741a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7ab3bde-a413-4712-b23b-08d757dc1317
x-ms-traffictypediagnostic: BYAPR15MB3432:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB34327C09B62A7D5A6C0BF358D76B0@BYAPR15MB3432.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:529;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39860400002)(396003)(136003)(366004)(189003)(199004)(71200400001)(14454004)(86362001)(6486002)(6512007)(31696002)(71190400001)(6436002)(31686004)(54906003)(186003)(99286004)(110136005)(478600001)(76176011)(53546011)(386003)(6506007)(6246003)(52116002)(446003)(102836004)(476003)(2616005)(11346002)(46003)(486006)(316002)(4326008)(36756003)(64756008)(7736002)(6116002)(8936002)(66446008)(81156014)(558084003)(305945005)(81166006)(5660300002)(8676002)(66556008)(66946007)(66476007)(2201001)(14444005)(25786009)(256004)(2906002)(229853002)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3432;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:3;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BE7xL8NuGZrWVVawV3S8Z3/lZwIaRvC3RrkvgnZQ6AaW2RN5m7m20h6miYW2xc8AYV6OKluH3MRIbkwc10oibud/UqaDhqAMhHUouyibajLuLcmrQD6ORdQeOz/SUqHTtQ9pFF+6102h2u0GUliTenkWEDhrP/ew0SjkrDapMy3KEo5cJOMEg8ZSmmm0gDQytD0mEcE3k9r3j1YBCeCfw05h2cB6Ejan13/eZVOpDrBVFn1hkX/wJF8CTBc7mrVoC8ryip3yEArcPscuaT12v8QkCap9WjoxublVgcWiABT+GkosFKAbqR2ksJ/CHgFcPzLyDrXVj5PF5bHSxF4KCeFlU7NvXUZII7qulDX6/U8AMmyF24m8Lu+2fIvYDsoKT5gJ8aEyIqmVDEFbcJsaZYCTSBdrgijunCt+q+p53FQw/uTAlqPI5WoOEnru/3Hl
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF8D1BD05D263549B28E8B991B13B7D5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e7ab3bde-a413-4712-b23b-08d757dc1317
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 17:11:42.4564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fJOGywGp4FfYWbnNkRVN2fWVIq9Be89XlnEI1vhvN4Zkk09qL9tNrEY/sdyi0utZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3432
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-23_04:2019-10-23,2019-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=955 adultscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910230164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMjMvMTkgODozMSBBTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPcmRlciBvZiAk
KExETElCUykgbWF0dGVycyB0byBsaW5rZXIsIHNvIHB1dCBpdCBhZnRlciBhbGwgdGhlIC5vIGFu
ZCAuYQ0KPiBmaWxlcy4NCj4gDQo+IEZpeGVzOiA3NGI1YTU5NjhmZTggKCJzZWxmdGVzdHMvYnBm
OiBSZXBsYWNlIHRlc3RfcHJvZ3MgYW5kIHRlc3RfbWFwcyB3LyBnZW5lcmFsIHJ1bGUiKQ0KPiBS
ZXBvcnRlZC1ieTogRGFuaWVsIEJvcmttYW5uPGRhbmllbEBpb2dlYXJib3gubmV0Pg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa288YW5kcmlpbkBmYi5jb20+DQoNCkFwcGxpZWQuIFRo
YW5rcw0KDQo=
