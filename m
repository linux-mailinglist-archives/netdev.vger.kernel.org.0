Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADF9722D7
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 01:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfGWXJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 19:09:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58108 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbfGWXJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 19:09:56 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6NN8x9a008522;
        Tue, 23 Jul 2019 16:09:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+PNh1S0yr/JqL1XGy/DV9Z5F1kvDt+CfhWR+RHGNIFU=;
 b=BakClCjbYHTgxsX60tGUPnUEXIZpiAt6/XYWgxG+vokHy/e9ZUbFzSZtIP+JUMou0fdo
 qybSpGMddXtcxaHYURl/yXVsIaZru4d4eW0wJ2MqjfoO08f1/jMNuhJ492Kl9x6CxPAJ
 MXDILGcYdphj96XvPBESOd8RgaycGpiAfpE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2txb3u84cf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jul 2019 16:09:37 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 23 Jul 2019 16:09:35 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 23 Jul 2019 16:09:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHnP83Ke8T9XD3eaU01qelrnjDZklPt2GYr3zw2liBnJmeAy+RxiPmiUo4isPbdP/Pp7esitEyCbfOeMpkHjsqD7bPKANAFElL+r56b0tNcuaGiap0NvX9YxlazuAHGTU2ELUWiG2oDTjSUND4OsWQb2g+TuJBsu3AWJ7ZZ9L7wUVQdDeGulL4V9XOdDllLH9w+cxVcaR5mswTO5y+S+1raBXRni6Wr+T1/K5XhG7ZcQmuoiy23T4X6DRUmjbb2+EJ9SyFfU8ttvqDoiQPMpgjEMpbq77lyQtvKy6IoQLenswrkpCZLCHMDcfBEGvxmcuZ/iJqGvaM0bHWQzsS4O8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PNh1S0yr/JqL1XGy/DV9Z5F1kvDt+CfhWR+RHGNIFU=;
 b=n39Hi1njnr3IEBZHLjwNCy37X0VHGIQBM50JkbuHY9M8WYwhB2I8hjnqFVm02OVDkmehMoDj28uYmiXU75Gg9IOzMDUJNlB5QGw0T0k+A/bg6g97+3CC3qzSGGPYQe5IhUisfKXr+Ic9mpFklK49AFDaSYMNdPm6CUnG66QXmQcNdPnrLDdGu0IlRCFcu7qXtX4N6I1TgOZmTlJBS7UR0b6jHJooCSpHoKbrNOgmg0hprkHG0JBOBPxlIlTS0CBIKLmw4HTrPWo+sAhSs9VV0lF9KXDHaKUYij6B06wCpqT2Gkz4LnpO4tR2Kas4kR++XWJ3CWNULHN+buCS+66xkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PNh1S0yr/JqL1XGy/DV9Z5F1kvDt+CfhWR+RHGNIFU=;
 b=i6FOrfSh2AaYtbVaXdc35vdJrbuwNdcxFbwYl9FYMoF8+TcGJadOnY7o5JcAX2JzB+IsnsVjfKeNvBIvhdgDdU2zUN78etNS+BqBRU0QbSUlKRfrUsCjX3gTU/MX66XfIjlLQtorZqS51OGXxfoB3F4MphJ+KrkV2U61WvSrIDM=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2677.namprd15.prod.outlook.com (20.179.156.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 23 Jul 2019 23:09:35 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::b964:e4e:5b14:fa7]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::b964:e4e:5b14:fa7%6]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 23:09:34 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 0/5] switch samples and tests to libbpf perf
 buffer API
Thread-Topic: [PATCH v2 bpf-next 0/5] switch samples and tests to libbpf perf
 buffer API
Thread-Index: AQHVQZ6K3NXASlJO40q2lCaUQ0m+q6bY1CIA
Date:   Tue, 23 Jul 2019 23:09:34 +0000
Message-ID: <cd338dee-96c7-e4cb-b41a-4c1df21e05db@fb.com>
References: <20190723213445.1732339-1-andriin@fb.com>
In-Reply-To: <20190723213445.1732339-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0130.namprd04.prod.outlook.com
 (2603:10b6:104:7::32) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:46e3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 946d519a-3fff-4b04-9f3a-08d70fc2d3b5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2677;
x-ms-traffictypediagnostic: BYAPR15MB2677:
x-microsoft-antispam-prvs: <BYAPR15MB26771E50909758EE80EBB691D7C70@BYAPR15MB2677.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(346002)(39860400002)(136003)(189003)(199004)(71190400001)(53936002)(6486002)(2501003)(2906002)(6512007)(6436002)(486006)(31686004)(8936002)(68736007)(2201001)(25786009)(386003)(6506007)(53546011)(102836004)(76176011)(52116002)(478600001)(2616005)(6116002)(81166006)(186003)(46003)(81156014)(11346002)(6636002)(66476007)(64756008)(99286004)(316002)(446003)(14454004)(305945005)(4326008)(54906003)(7736002)(256004)(4744005)(86362001)(66446008)(6246003)(36756003)(5660300002)(31696002)(110136005)(66946007)(476003)(229853002)(8676002)(71200400001)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2677;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CLTN6jOjYLfzel0nA5Dm3QMYBO9uCh0vy3EndBerS0WRX7o3ZPe6yx5on2myAvYNBuOAll8aKFJ3HswCXNgVERTnEy2N7LUHbuduLvmOPSjlKINXKJxVuDmxAHE/Pdft8hR/t+bYo/0tlUEMrgHArvKdwmdpTla6kgI7IFdKFB91eFP0WA2ckiJghb/qdBidODGfezC+nt7WaFJkPDdOtQlUeVTWO7zyC2A3IfVTnuTRgkgTFVpxLcA2sEvYIw9tFWZI7IrtIZXWD5lgcW4T/d7wsyhyLtvi6c0aBqjrhdC2RiuVj8tcgw9ShbidjOfey26WfvynX7zok3cfZk3E2gz/TnkVvJVS+HLSnRjmMSclrYvlAgGA+DxgshB2Asbe7YST050NrH+8Bls0ei0o39w6DxTmcQQ0g/QN8PocHFI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4C9880F5C644E49864F1574F2118415@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 946d519a-3fff-4b04-9f3a-08d70fc2d3b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 23:09:34.8080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2677
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907230237
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8yMy8xOSAyOjM0IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IFRoZXJlIHdlcmUg
ZmV3IG1vcmUgdGVzdHMgYW5kIHNhbXBsZXMgdGhhdCB3ZXJlIHVzaW5nIGN1c3RvbSBwZXJmIGJ1
ZmZlciBzZXR1cA0KPiBjb2RlIGZyb20gdHJhY2VfaGVscGVycy5oLiBUaGlzIHBhdGNoIHNldCBn
ZXRzIHJpZCBvZiBhbGwgdGhlIHVzYWdlcyBvZiB0aG9zZQ0KPiBhbmQgcmVtb3ZlcyBoZWxwZXJz
IHRoZW1zZWx2ZXMuIExpYmJwZiBwcm92aWRlcyBuaWNlciwgYnV0IGVxdWFsbHkgcG93ZXJmdWwN
Cj4gc2V0IG9mIEFQSXMgdG8gd29yayB3aXRoIHBlcmYgcmluZyBidWZmZXJzLCBzbyBsZXQncyBo
YXZlIGFsbCB0aGUgc2FtcGxlcyB1c2UNCj4gDQo+IHYxLT52MjoNCj4gLSBtYWtlIGxvZ2dpbmcg
bWVzc2FnZSBvbmUgbG9uZyBsaW5lIGluc3RlYWQgb2YgdHdvIChTb25nKS4NCg0KQXBwbGllZC4g
VGhhbmtzDQo=
