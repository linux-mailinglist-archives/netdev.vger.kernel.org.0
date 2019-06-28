Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 602665A2BA
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfF1RuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:50:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14616 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726443AbfF1RuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:50:17 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SHfvD5011381;
        Fri, 28 Jun 2019 10:49:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=mwrv8g4mcHK+KeupB60OoEBRvUfpgD/kplRW8jyy/Xs=;
 b=GFDIssGef8BBVmWi82o3ODsS16yCiAOYs+1h0ye05r7dHQ4F/YMowEPaTtYzP3dwpuuG
 ujx4V+bbHBzK72sgpKpBJUFxzRAMmVOJ0SuIOb4AsQIH0W/oVhTxHbMrvQGb2trhyV8v
 2zUR8cEojMv2BkppkvyzvJeLgZEji2ZStHc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tdk48s4mu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 28 Jun 2019 10:49:56 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Jun 2019 10:49:54 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Jun 2019 10:49:54 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 28 Jun 2019 10:49:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=sDE2/9+TVV4J3Qpk/HH8qOjFfzaucGJN1sNmk23gkChZJ/2ZYouwUu39Q2nicj+JaQazcxa+BNIbVJWkDv++rSPTzkns8zyd7LQF8LuuriGfCtOwKtfsrooc07DjHdXjtuoXKMUiSqD11QCtSjevMxj/G5VANbrgEyMKyWsgWQI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwrv8g4mcHK+KeupB60OoEBRvUfpgD/kplRW8jyy/Xs=;
 b=QKFK5HzKMUvfw0a1PC1v77UBFt9k0PAV9Q4PqGsbhdn0KQuLXJrNlgCYtp5OG+/7pZcMltukisbB3AJRqQABpdMLWBCJpW7O3wRRlEytc5ISrcODmuqYagDiw3Rq1BdQg70pam4TMTrrDXkgOvPlOL3Oj7vWLQUD2+gmO6cR3bI=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwrv8g4mcHK+KeupB60OoEBRvUfpgD/kplRW8jyy/Xs=;
 b=kik2B9gKtIRVDMlENxlVw4oPnvEkaM3B8G8BVA4wkKsP7SE3P5D8wVt57evrF2v2r1l2Fu/QLwVxJtSjn5TRRjMFsQCQiJYQ8pGwN6/enLgyTEm8AWWCHDGGOIS/++qYzMnuRAISsMkgapXVaBIIH8gxn9t6p7SCQSocT2Gt5UQ=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2246.namprd15.prod.outlook.com (52.135.196.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 17:49:51 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702%7]) with mapi id 15.20.2008.018; Fri, 28 Jun 2019
 17:49:51 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 2/9] libbpf: introduce concept of bpf_link
Thread-Topic: [PATCH v3 bpf-next 2/9] libbpf: introduce concept of bpf_link
Thread-Index: AQHVLXXa8Umn5EsndE+OGGpIb08hIKaxOtsAgAALHgCAABGsgIAAATAA
Date:   Fri, 28 Jun 2019 17:49:51 +0000
Message-ID: <2cff901c-3b0b-d99d-3e58-7065d9d82ace@fb.com>
References: <20190628055303.1249758-1-andriin@fb.com>
 <20190628055303.1249758-3-andriin@fb.com> <20190628160230.GG4866@mini-arch>
 <CAEf4BzbB6G5jTvS+K0+0zPXWLFmAePHU2RtALogWrh7h7OV03A@mail.gmail.com>
 <20190628174533.GI4866@mini-arch>
In-Reply-To: <20190628174533.GI4866@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:907:1::33) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:dbf2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 259af8f6-fe51-4f41-99a8-08d6fbf1050b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2246;
x-ms-traffictypediagnostic: BYAPR15MB2246:
x-microsoft-antispam-prvs: <BYAPR15MB2246AC4F9D2E2BD20C006CE6D7FC0@BYAPR15MB2246.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:236;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(39860400002)(136003)(376002)(396003)(199004)(189003)(52116002)(305945005)(71200400001)(256004)(5024004)(478600001)(7736002)(6116002)(99286004)(2906002)(486006)(81156014)(36756003)(446003)(110136005)(71190400001)(8936002)(2616005)(11346002)(76176011)(54906003)(8676002)(81166006)(476003)(102836004)(386003)(6506007)(53546011)(186003)(6486002)(229853002)(68736007)(6436002)(86362001)(64756008)(46003)(66446008)(31696002)(6246003)(6512007)(316002)(4744005)(66946007)(25786009)(66476007)(31686004)(73956011)(5660300002)(53936002)(66556008)(14454004)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2246;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VfA14ylcEuR2NIFlWaVtFeRAmkvCaA5GdBro40d+W+yqJSj9ziindAUoRk/DCCCKi8UwyL+SPr1FuTXdh5RXt0phawRXG/7oA4l6blTASoigm8s2sSzytKK+8pjbQZlvIN3Od5xuUXWYwUkXPtm4mthaKfGrsl9eIgcCmPhnABkPgbgv6NRstf7C0dow1c4jzH4lK0Ca8TkcI14pRoOsAdsZQBhlAPvkGJk+eLX639hSnF50EkQMDKS0gVsMJCeF5rk4fO5UxcXhunUPGIb35HcQ44B/L5KwQvOUHNtCH3GraaPzEHMY/h6yNavDaPKdfctUtwVqkoGr6eZth5kNyTZtEPsHCP+Crdo49dXevopn09IQxESC1DmxVIaWybLGpXitfId/VNwiF1uiqtim37C4LSBSJMcBCNURre/8vEE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2BBA2E301D7FD54684E7CB497F137B25@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 259af8f6-fe51-4f41-99a8-08d6fbf1050b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 17:49:51.2998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=910 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280203
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8yOC8xOSAxMDo0NSBBTSwgU3RhbmlzbGF2IEZvbWljaGV2IHdyb3RlOg0KPj4+Pg0KPj4+
PiArc3RydWN0IGJwZl9saW5rIHsNCj4+PiBNYXliZSBjYWxsIGl0IGJwZl9hdHRhY2htZW50PyBZ
b3UgY2FsbCB0aGUgYnBmX3Byb2dyYW1fX2F0dGFjaF90b19ibGFoDQo+Pj4gYW5kIHlvdSBnZXQg
YW4gYXR0YWNobWVudD8NCj4+DQo+PiBJIHdhbnRlZCB0byBrZWVwIGl0IGFzIHNob3J0IGFzIHBv
c3NpYmxlLCBicGZfYXR0YWNobWVudCBpcyB3YXkgdG9vDQo+PiBsb25nIChpdCdzIGFsc28gd2h5
IGFzIGFuIGFsdGVybmF0aXZlIEkndmUgcHJvcG9zZWQgYnBmX2Fzc29jLCBub3QNCj4+IGJwZl9h
c3NvY2lhdGlvbiwgYnV0IGJwZl9hdHRhY2ggaXNuJ3QgZ3JlYXQgc2hvcnRlbmluZykuDQo+IFdo
eSBkbyB5b3Ugd2FudCB0byBrZWVwIGl0IHNob3J0PyBXZSBoYXZlIGZhciBsb25nZXIgbmFtZXMg
dGhhbg0KPiBicGZfYXR0YWNobWVudCBpbiBsaWJicGYuIFRoYXQgc2hvdWxkbid0IGJlIGEgYmln
IGNvbmNlcm4uDQoNCk5hbWluZyBpcyBoYXJkLiBJIGFsc28gcHJlZmVyIHNob3J0Lg0KaW1vIHRo
ZSB3b3JkICdsaW5rJyBkZXNjcmliZXMgdGhlIGNvbmNlcHQgYmV0dGVyIHRoYW4gJ2F0dGFjaG1l
bnQnLg0K
