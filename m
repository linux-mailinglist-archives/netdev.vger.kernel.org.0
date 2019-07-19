Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F357F6EB2A
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 21:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbfGSTi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 15:38:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62864 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727535AbfGSTi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 15:38:59 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6JJZPUl030996;
        Fri, 19 Jul 2019 12:38:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Jmoq6hfOBPSlpy4ubgizeIcrV9l6TPWBy6H+b2ueK/M=;
 b=nJsoaLkVCwVMGYmHM2FxMcdnuzVW9Uh/ATlwxYc1NOo+Xz0AeIRzfqfNzlcu1M0Kikw3
 +FQaogBQQ2IqD+MmS4TB6ciDCVBD6GfWmhdcpqD0ygnQiunLZb9xpUhf8thePqQQlnul
 MywwJjXbbAbWRIlPGx5QdKiev9N3Lu6RfgA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tues59axh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Jul 2019 12:38:39 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 19 Jul 2019 12:38:37 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 19 Jul 2019 12:38:37 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 19 Jul 2019 12:38:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7Q6Gz34lmv32NmTnD4VsPxaKLBA4ReraaVUfkzo6/t639+i3oPT7OhG4YvHwYtyVFqbb+hPw14XvGSgYqHPd2tl897PaouUFUvZmm1Ml1xNwlGIOPFO2uzLSI9z8oTKb2WBOcsN+XB9Cyr7QtZBO8w1ETZqPXE6iN8mtK7TubG02ednH99sB2f+RtOoKMe371NoCmuRbHVyQhrSdQ/16NTNsidmKe3197CsLPuyaLLqgDvBjaRnscIo4uOqlSr9lK05wWJavB6a0ooh9kixfijavBkGZ4eRqABmXarNOnthH9797+bJNr48zlfld2tlqBnh4bnjqycPDdsfaaCb/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jmoq6hfOBPSlpy4ubgizeIcrV9l6TPWBy6H+b2ueK/M=;
 b=Rw7YPuchPUAKV2C1nsjhc+DRNaoPpGVMbNxwpS5l58IMc29pQxrLwYIMggLYbvYLu47pr9jbuT5hPaXbnSuB0zI8RzrtGuuVXphUc5RD52b3414sdCVskEr291JCJUTHSs4a3hEMjALwGe8VqLl8PDQRse27WJ2PsEeAwMn1zi3799jbJjns0J8DK+BPICo7PQCvwHHw06Z4okLJmSqpu2+FA/44tbucnZXnU4DOuUcR4qADsvqize4iVyURZ1CyQarYQfKnPRokQ0xt/DdWJ3qgR/PwEnlE303JV/64yDwNDEKd2qq8dAfL3wjiRyA6y8cFnPbHXzY9HpQQ1Nzp+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jmoq6hfOBPSlpy4ubgizeIcrV9l6TPWBy6H+b2ueK/M=;
 b=epmaZfDAcwJeEF5qn0jyzBe4gZMVu5VVX16l271ep+9oKfP/Cf1RSMNPBsJmkAnLBW3CLrnboINM2FHx8KhCABDdT6JNgmin9GNzhS5KzyAQUOSl4ZGyX5wZh+ZAgFSA1Cg4cwaifDAZkeHZdnfopkhmezaResE75gWbMDGfb54=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2472.namprd15.prod.outlook.com (52.135.200.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 19:38:34 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::b964:e4e:5b14:fa7]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::b964:e4e:5b14:fa7%6]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 19:38:34 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] libbpf: fix SIGSEGV when BTF loading fails, but
 .BTF.ext exists
Thread-Topic: [PATCH bpf] libbpf: fix SIGSEGV when BTF loading fails, but
 .BTF.ext exists
Thread-Index: AQHVPmjcg9MOlv3ew02MLD4mGIcCQqbSVkWA
Date:   Fri, 19 Jul 2019 19:38:33 +0000
Message-ID: <119053c1-5f18-3161-47c2-e39c2783d0d6@fb.com>
References: <20190719193242.2658962-1-andriin@fb.com>
In-Reply-To: <20190719193242.2658962-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0049.namprd02.prod.outlook.com
 (2603:10b6:301:73::26) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:a5f3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fcb11de-3cdb-4caa-6499-08d70c80af86
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2472;
x-ms-traffictypediagnostic: BYAPR15MB2472:
x-microsoft-antispam-prvs: <BYAPR15MB24720F497F9B2D270D9B8F09D7CB0@BYAPR15MB2472.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39860400002)(136003)(396003)(366004)(199004)(189003)(6636002)(14444005)(110136005)(53936002)(71190400001)(305945005)(71200400001)(14454004)(66446008)(64756008)(66476007)(66556008)(66946007)(256004)(6246003)(4744005)(54906003)(7736002)(446003)(11346002)(486006)(5660300002)(25786009)(2616005)(476003)(36756003)(6436002)(52116002)(2201001)(229853002)(86362001)(2906002)(6512007)(99286004)(6486002)(6116002)(316002)(8936002)(76176011)(81156014)(81166006)(186003)(53546011)(2501003)(6506007)(8676002)(4326008)(68736007)(386003)(31696002)(102836004)(31686004)(46003)(478600001)(142923001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2472;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WUAo4Fst3MYj/uJ5rvgso7SHCA/AXl9i5sbaoRxlzj6J/E7eUEdCRgvhF1qoNLSVV5PYRTXezQZUoafXYKHY/0rxpyJz4+C7ID4fEChi5gEi+nyY4UAZvTR8ORpcX+oL8Sz6pl41greHTffDJuj6OnWE5anGPgx1lVVUe1ss8abPNxr3cp1SxDAeW12QxpTjUSg99g3NlvB7QWEXKhbHyreN/AJrTqjEoHYWr0DMW2CNUOVAPoOlXTahcAk7IhDzbUtUZ/zrWGp8D9Nq3az3nePeB0s5vb7f3T/x8tYxsHxwMdFxy5qThIVgstjIGcbTu2Jbw5w8vgRJ6prrLyZtBcHTwt5HlLTtrSc354V+atuWOHueBRiEozKa9MOLk4F3znzd+otYLNqMR8d0ZGifAy/Qxwd//Un2GsxR11zo08k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2956FFD5DB4DBD45A81B87CFAA535402@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fcb11de-3cdb-4caa-6499-08d70c80af86
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 19:38:33.9040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2472
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-19_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=861 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907190210
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8xOS8xOSAxMjozMiBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBJbiBjYXNlIHdo
ZW4gQlRGIGxvYWRpbmcgZmFpbHMgZGVzcGl0ZSBzYW5pdGl6YXRpb24sIGJ1dCBCUEYgb2JqZWN0
IGhhcw0KPiAuQlRGLmV4dCBsb2FkZWQgYXMgd2VsbCwgd2UgZnJlZSBhbmQgbnVsbCBvYmotPmJ0
ZiwgYnV0IG5vdA0KPiBvYmotPmJ0Zl9leHQuIFRoaXMgbGVhZHMgdG8gYW4gYXR0ZW1wdCB0byBy
ZWxvY2F0ZSAuQlRGLmV4dCBsYXRlciBvbg0KPiBkdXJpbmcgYnBmX29iamVjdF9fbG9hZCgpLCB3
aGljaCBhc3N1bWVzIG9iai0+YnRmIGlzIHByZXNlbnQuIFRoaXMgbGVhZHMNCj4gdG8gU0lHU0VH
ViBvbiBudWxsIHBvaW50ZXIgYWNjZXNzLiBGaXggYnVnIGJ5IGZyZWVpbmcgYW5kIG51bGxpbmcN
Cj4gb2JqLT5idGZfZXh0IGFzIHdlbGwuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFr
cnlpa28gPGFuZHJpaW5AZmIuY29tPg0KDQpBcHBsaWVkLiBUaGFua3MNCg==
