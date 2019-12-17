Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2AD91238A2
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbfLQVYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:24:40 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36706 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726731AbfLQVYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:24:40 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHLME7S017842;
        Tue, 17 Dec 2019 13:24:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rZxR/4HBehilTxUYQIN12fFi95dPww6XCBfT1VWzmek=;
 b=WG7o0YFJ82Pi5oo8tsbo9XSiw1B9G21VKt0K5CSOBIEJXK2xbmhUfVzdpUB4g7MYAZu4
 ukRBga272Mq3LXl7KsFRHB/dfKJgddomLsODcdUKIO1a3HfK4J5BOvgYh0D4pUdi9PY0
 8NrP8WK8DV5+CWNP2pnQN0G62Vlg1or6smw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxuptk9un-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Dec 2019 13:24:26 -0800
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 17 Dec 2019 13:24:23 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 13:24:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3dqM7tckC40ynPp50cc++laK5xLSJZbVJZT8ffNKE15+xumB/4dynwmSmxEK5rhkcWb9c2lGvX4GLdjW1iOQGwuSisfiNfHM/WWbnWKZMCXFqpYwU1BypPAjed0RPgwOu+ZYz3zFgSBZ/G9s1O7YVWj+5+yNzrD2TpRBksEgDyUaGokC6KU6onl4LbXcBUIAwH1Q52mocr7UJbA4eQOxxXf0DmKes5cK6ZM4qnV9aJ2xLa13mQ5F0QVlJG9NLsjNVtNuAvEZ8bjrUlklSKm/JrJALRbkvhBxME3L16iYAY3lZq0IoYg3jOuIrhk1lt5WXbMiD2H2zK7XsGZX2Kq5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZxR/4HBehilTxUYQIN12fFi95dPww6XCBfT1VWzmek=;
 b=Ubbg8Gumfr7Ql3tainZRY4f24X/aXPtH4tOH0H8Zt/ucGZ5JzRbZ6pRhiVWCCAZ4OTP+XFUu2hujcDAputnoF9NY3tE19H8YGbR9yvAu9vfoazVvTfoJiLkyx1PyDeNz+2cgKxRJVx3T6T/S5/yDKH/HOgLbBJQZERM4BffsA2ac56QVtOrETGnvv3KSmQmm2EQdps+PCyPktzfRrxdhF61+lGitCdzJsnlzRHfOA05OtN2nb0xgaIrSMm0tVLjtRk8Ai34wiWcV0SIZkndJTmlTsCLvvuzr1Ijj0tGwut0NyL4C3hBPgJmHWviJ/vLm78SB8h9rk2q5mzu24e2P9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZxR/4HBehilTxUYQIN12fFi95dPww6XCBfT1VWzmek=;
 b=NFadNz2gpy+xMsYJxNqcvjOyxRkxJ9kishVF0YjTHp13A4fpVWIxM9TQYGkalwn9LranzppYHUndXaN+XOLNEc5jH/WyBKYCkwWroR4S7yFoYnkT6DjSsL5/ILVw1Hi4FToR/v52bcZBUec28EJr1FmGRFnhJp8ssMjpcL7vvbs=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1385.namprd15.prod.outlook.com (10.173.223.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 21:24:22 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 21:24:22 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/3] libbpf: remove BPF_EMBED_OBJ macro from
 libbpf.h
Thread-Topic: [PATCH bpf-next 2/3] libbpf: remove BPF_EMBED_OBJ macro from
 libbpf.h
Thread-Index: AQHVtSBZXyoCHk3Iu0CoAOdtWmzkhQ==
Date:   Tue, 17 Dec 2019 21:24:21 +0000
Message-ID: <35ed428b-5f35-694c-1d63-636f72f5bac1@fb.com>
References: <20191217053626.2158870-1-andriin@fb.com>
 <20191217053626.2158870-3-andriin@fb.com>
In-Reply-To: <20191217053626.2158870-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:300:129::13) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:406]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00fc24a2-964d-4cb0-1e41-08d783377ba0
x-ms-traffictypediagnostic: DM5PR15MB1385:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1385A57916079D054ABD3D02D3500@DM5PR15MB1385.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(189003)(199004)(6512007)(52116002)(6486002)(36756003)(31686004)(498600001)(64756008)(66946007)(8936002)(8676002)(66446008)(81166006)(81156014)(66476007)(66556008)(110136005)(53546011)(86362001)(54906003)(31696002)(2616005)(2906002)(6506007)(71200400001)(4744005)(186003)(4326008)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1385;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R4LtMh5L6WLtNLgB1rATMM+INuRzMAgCVm5NHFiTI8NBzcs0hLAzub+U9FCtbtBN65HQmMnxaCQA0Q4r/sNNdD8uJSlIE3RKlfWlEvbhrINcENhYj46/Je+uvabwiOhYF0KE89wdJXTqzmWLmKNaOMufYxdahu38/5Zcn+XA05viHGU/5xXd92rn0rL9JHN3mh894+uhedOwJ8cq/YSFpRl6Rs3Fm/rByRqCHTygYyJt9+u2GVol19UrXIlcMnYiZ1ZNlbolGVOksF5jqFzct0DFQzOHbGG7Yuf3jZcemTob4vuWi5FjZttichm0cieuu3qgPNmIJLqNb7nIiQcNjqCjfk3u4b03zpH9tQk2+pUIFKE3jLkGMV7JHlUQK+U/fiN2LH1fTnvd0EKOtS/qbnOZ+HsDk/MNs8C7nNvkCOL4b/WeTi4Mrw/JbpnDax9G
Content-Type: text/plain; charset="utf-8"
Content-ID: <96982C7A894CD04E95181E2D8C92BE45@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 00fc24a2-964d-4cb0-1e41-08d783377ba0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 21:24:21.9114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: runV2+WwueDPdK2z4OU1BNUuLgypa/pgyCihUxUjje/KY5/2F0x73CDetSCMkWXo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1385
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0
 mlxlogscore=929 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912170171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE2LzE5IDk6MzYgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gRHJvcCBC
UEZfRU1CRURfT0JKIGFuZCBzdHJ1Y3QgYnBmX2VtYmVkX2RhdGEgbm93IHRoYXQgc2tlbGV0b24g
YXV0b21hdGljYWxseQ0KPiBlbWJlZHMgY29udGVudHMgb2YgaXRzIHNvdXJjZSBvYmplY3QgZmls
ZS4gV2hpbGUgQlBGX0VNQkVEX09CSiBpcyB1c2VmdWwNCj4gaW5kZXBlbmRlbnRseSBvZiBza2Vs
ZXRvbiwgd2UgYXJlIGN1cnJlbnRseSBkb24ndCBoYXZlIGFueSB1c2UgY2FzZXMgdXRpbGl6aW5n
DQo+IGl0LCBzbyBsZXQncyByZW1vdmUgdGhlbSB1bnRpbC9pZiB3ZSBuZWVkIGl0Lg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCg0KQWNrZWQt
Ynk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo=
