Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B11310B74A
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfK0UQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:16:19 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57106 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727404AbfK0UQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:16:19 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xARKCniZ029676;
        Wed, 27 Nov 2019 12:16:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=GEqdWQAaenJxixUr1xs/S0mfrj+qKl9z+qqi1rr3kX8=;
 b=B2R67O2R10gPsMf8lx6imb6C42QTf6/r6dwxBtLocSGD6LZKVxggzM1//ufR1cLCVUH7
 FKBbUreYKZTn0yd2ysLNMpnroSfDhRtIletp0GwtHQQKSSHlayj69orymwH315ge7h3J
 LscRlxPEiqkdeZ6vRbTG8LxRdGweiqSiXtc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2whcxppf5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 27 Nov 2019 12:16:06 -0800
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 27 Nov 2019 12:16:06 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 27 Nov 2019 12:16:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kemxVZsawdmrQA0ecC4qKs18Qdr9h2IHuKRw7TtM0Nm6gZs3nUuI2EX2z3lZEaNgcS4PBBBbG3KKq1P+3tFn0ILWCUpDtuealwFFb7gAsWNCKYmhPpSngPTL/ViBcgRAR6jhyo7EUOg6e1lMmegrqih51f280imbRHQe0JPamcayQ+uREiNzqCZfJobSeaSrgItEjJRBMHwRpJGMGFm6iwR5fEvNNuDC3HqndycXumAXOJkbEDDvJAfRoKkpuMJcbT6jZWjy84iG0icFmLkf7uJzi6IXxbiLIpw/6+mPaEjWmjIrN1o4iC51G98fiMJJpBSYv8YUc+zs1YprtzmGpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEqdWQAaenJxixUr1xs/S0mfrj+qKl9z+qqi1rr3kX8=;
 b=ZeIsGE1v2Bo6DtehAPhsfA0X1Ru4faGh5+vvpftBsrKctNHXPl8vMOOU4R4vBtdF+l5ClfWKevSRsEaX50nhcdrxE39avquRFN989axsfL4DQcruuauTNAgRSpmMSdZYK4QwyoOcPokuBWumin6ZaVtBk3BrnLaDO5uKPeE4FI9+gvABOHGw22Gu0+CYpv0FPN58uKHPv6sK1VUBjPYs3qkfHRhePlw5QvyBI3F5myDT6IOI69hNdx1FP4B7sSt3NFN3I9p/ic3VdHaJ84PApczqvMYND9xlu6rR/4cI9StGnnpcleh77t4X38v1m31sHZyldTvj4D8ZaMDLX0cQEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEqdWQAaenJxixUr1xs/S0mfrj+qKl9z+qqi1rr3kX8=;
 b=gpwx/D5Q6S21cEMkNv1u42CbSRXHZvvt99fIc/4L+bNDBeYzEymnb4/3kREmQ9Ua8RdfIG0W/ovqhxVgxrRO8xUJ8BRsmekRB05PTyBoyvXi1ECog5huG5iTwU/80t3AtCUYImgzLzNm9g2erYwsgLYQzvGkg2YXxaiF0xtBlt0=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3173.namprd15.prod.outlook.com (20.179.56.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Wed, 27 Nov 2019 20:16:05 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 20:16:04 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] libbpf: fix Makefile' libbpf symbol mismatch
 diagnostic
Thread-Topic: [PATCH bpf] libbpf: fix Makefile' libbpf symbol mismatch
 diagnostic
Thread-Index: AQHVpV1+hsRdLpqL30e0jDMG+OwkG6efdD6A
Date:   Wed, 27 Nov 2019 20:16:04 +0000
Message-ID: <5f51a36d-5689-0cd1-6955-8c43c44cef0a@fb.com>
References: <20191127200134.1360660-1-andriin@fb.com>
In-Reply-To: <20191127200134.1360660-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0113.namprd04.prod.outlook.com
 (2603:10b6:104:7::15) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:dd8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60a3702e-f5e2-40e5-14f4-08d77376a130
x-ms-traffictypediagnostic: BYAPR15MB3173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB317344EDD9BF2C6FC96871B7D3440@BYAPR15MB3173.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(346002)(39860400002)(136003)(376002)(51914003)(199004)(189003)(4326008)(256004)(46003)(186003)(11346002)(2616005)(478600001)(446003)(71200400001)(71190400001)(36756003)(31686004)(2906002)(25786009)(64756008)(66946007)(66556008)(8676002)(66446008)(81156014)(7736002)(66476007)(5660300002)(305945005)(8936002)(229853002)(86362001)(558084003)(316002)(81166006)(6512007)(53546011)(6506007)(386003)(6246003)(31696002)(102836004)(6436002)(14454004)(54906003)(52116002)(6116002)(2501003)(6486002)(76176011)(2201001)(99286004)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3173;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: se90JyenazoznwZ3yNMEdCacmLtqtEKE4Tdty8V55hIU/KNLJeGG4xSuL3S121Bog5HSN2ujqs5EJ+AWmFftE8MeBvPD5UkpgQkMyLuhkLs6cVNy1Pyap98rVcNWAhS+7UQ2wWL8dz88BleOKUQiBCDkmCrSe439/PTbhhWRxvUVnL/KBgUYBQRkDnneFM9mVYdVNmxPOy9excUzmxSGva26ZW5kFCL110hbP5DJuGl/Uf+cxaqMhShTab1uaKXYEafVKTsTT/pCYQepwjbg8CBeM2zMa/s1BlC03N6+vceFLy36OtJC+fqA9PdX7danyohqJcN4H+Vm+S9hZHSY1/wnfcSd4+I5hLHK14PsziYxT+AK+3E9dHAvO7zyp2j7QvKKutXlc5Sz3rM4V7B+jj6Xcu5jFIReVTCUwnH+4dYIBaQ6S8Wkpl0mtZEDxHiu
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DCBFAA53FAAF241A4C64DC403CB05CC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a3702e-f5e2-40e5-14f4-08d77376a130
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 20:16:04.6700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4AwvGwMXfifYvR99KIuWjUNgddeMFijT8wddI1axThmPhQOoJR9TAn0yPMuSa8c2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3173
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-27_04:2019-11-27,2019-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 spamscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=795 impostorscore=0 priorityscore=1501 clxscore=1015
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911270162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzI3LzE5IDEyOjAxIFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IEZpeCBN
YWtlZmlsZSdzIGRpYWdub3N0aWMgZGlmZiBvdXRwdXQgd2hlbiB0aGVyZSBpcyBMSUJCUEZfQVBJ
LXZlcnNpb25lZA0KPiBzeW1ib2xzIG1pc21hdGNoLg0KPiANCj4gRml4ZXM6IDFiZDYzNTI0NTkz
YiAoImxpYmJwZjogaGFuZGxlIHN5bWJvbCB2ZXJzaW9uaW5nIHByb3Blcmx5IGZvciBsaWJicGYu
YSIpDQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQoN
ClRoYW5rcyBmb3IgdGhlIGZpeCENCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29t
Pg0K
