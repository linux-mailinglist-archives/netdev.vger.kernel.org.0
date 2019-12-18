Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CA51257C0
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfLRX2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:28:24 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21996 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbfLRX2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 18:28:24 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBINKpcU017815;
        Wed, 18 Dec 2019 15:28:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=syluhYdt+xj15FnkCJufiPjN0x6Y5Ho8UZOMKk7y2uA=;
 b=CBniRVxV00GaQGRW40OEXS7fWEz2Menw4wwwAnz/IDToMFBEs7NFUYTYrjhQt/UhDrO/
 VQCKbJUs1IzQyP/DnyLZSfufFoK0+Yq9bWJMrVQpNkYpqGjQxCvRoLltLlA/SxYPqzHY
 aymazMp/tWJvU4KDbSjVs2rtPEj4dd3jnWc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wye5f4gq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Dec 2019 15:28:11 -0800
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 18 Dec 2019 15:28:10 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 18 Dec 2019 15:28:10 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 18 Dec 2019 15:28:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4UuC5lX6BSge+YcbunujMPYwr9QVqB5pC5qm/ag8h81oQO2lZzl96RYwXjFeTDC/HI7sh6357cFLKZUG4nY79siHShfB/nflu0giLGRVQlMLCdbvBRD0onci+VlBqoke6p+U2hXnH+UeAfbVj73ay+svro3GdVYIWMxV3/nXx8a5V/LDnCUraKHe95YDRPKPXgnQNme7sPJUIne3pVkR2p9OsITOtXTGvGD17B1gcm44yRsFl8Ek3oRw+iVDUmf7hWmsfwmAQdl9PuRVsLX+4YfL1ZFs0Ix7NFhrwMaOJut6r/3Eg/ljEE9rM1ukOgn6MeZ+1fsE49NWeNg7u1uJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=syluhYdt+xj15FnkCJufiPjN0x6Y5Ho8UZOMKk7y2uA=;
 b=EmLGsRclF0UmR/Q3VmYZ7tjJTr5JtNMUGH3RPu169gxFDuMYluZMH90nBzil3r/NBFGxaWdzkv79CUhb0hGfgUYmoXndX6bhYE4B+mVwKHaRNg1T5zjdLHCW+lbovrR5aJcIUMabh8rAzJYAYBOZWEbdBaE8ApcjiLegJKrca+WHjaCJsr4DtQWmwpfqBXJfdhjP7gbRDd6cngTKL8SqlKhNyzvziPS6+m2sg0WSaaMWU9PI3LEC3IY19t5ZdboAPAnnyhDfLrlGr3OioPgWaWaWUHjjSK40ADtlOpUrX2dkgsB4YXh783kOdt0pe/luybdXb2Hf+X9yhuprBl0K2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=syluhYdt+xj15FnkCJufiPjN0x6Y5Ho8UZOMKk7y2uA=;
 b=LKpvG9tbM/WB/jEElATUNl4aNrTJ5WqF98HnyKzDPfhESBAmyQA7WynNCnD95wvKF5j9CUr2l6fZW0vWwaFpbcmTv+wHkyvdzzxWYJYyGEx52BVRCwSqa2x24WLHz28xEzmqwHLikcaSg8PK4TYytwl8TaVk5yAiNLjPTEJlnJE=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1674.namprd15.prod.outlook.com (10.175.111.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 23:27:55 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 23:27:55 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] bpftool: simplify format
 string to not use positional args
Thread-Topic: [Potential Spoof] [PATCH bpf-next] bpftool: simplify format
 string to not use positional args
Thread-Index: AQHVtexAb+5BDHD890eJoRpEh53JvafAibAA
Date:   Wed, 18 Dec 2019 23:27:55 +0000
Message-ID: <5fc9f067-019c-8cf0-6f27-fc2afecdd4ea@fb.com>
References: <20191218214314.2403729-1-andriin@fb.com>
In-Reply-To: <20191218214314.2403729-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:104:1::33) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:31e6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65bac4bb-737f-463e-d827-08d78411e8e3
x-ms-traffictypediagnostic: DM5PR15MB1674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB167496782273EAC4106C4C7CD3530@DM5PR15MB1674.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(39860400002)(136003)(396003)(189003)(199004)(316002)(31686004)(2906002)(36756003)(81166006)(86362001)(5660300002)(8676002)(66446008)(8936002)(64756008)(66556008)(66476007)(31696002)(66946007)(71200400001)(478600001)(4326008)(186003)(54906003)(110136005)(53546011)(6486002)(6512007)(52116002)(558084003)(6506007)(2616005)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1674;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vzXJHSk1QcnS5eczI24bLJ1HkQHQfUXd24/cXKrimWofZmql36fKcgoQ/E+NHxDrDcSTQr+L49RBLztYWGgEsr/4M3srfsRsa6v+o53X6zunl6LlTClKwsulaSV1xY4VZTpJQJJxK1xwKY8JWcrH1v1YFGx/8izWlSylgkXCAh5AxfmXiqLJtr4KKETW002XX72AlHbmbsoKkPRFfUP5EV5g1MA85qCiPkRDHbbW5SDGBchLuVjHiLVCkOszydDFEA1UAFYtXeV9TaLOGlgIISMuULRQ4Q2YFylYaTq4ZbD+mTgB30ZzfhxDkV0DONyYA0Od1QTBU+ThdkAbXS31xzcXD+Xa37I41fxJoSKixobClBUCySqKTuSwrOqmE52wGZICVCawPhJGPdGs0W7FX2gvKcx8wocXX5QwAb0pXUQzLc97uSqbsj0IKoKDuUjR
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB66ACA1E158FA4CACCBECE6528BCAFE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 65bac4bb-737f-463e-d827-08d78411e8e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 23:27:55.7259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MPtisKw+VundZmF2KqiBGxFWrlEEivvoq9HsC2MrOFVlHqzUN/SXFNiesaVJbu5L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1674
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 mlxlogscore=868 suspectscore=0 phishscore=0 adultscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE4LzE5IDE6NDMgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gQ2hhbmdl
IGZvcm1hdCBzdHJpbmcgcmVmZXJyaW5nIHRvIGp1c3Qgc2luZ2xlIGFyZ3VtZW50IG91dCBvZiB0
d28gYXZhaWxhYmxlLg0KPiBTb21lIHZlcnNpb25zIG9mIGxpYmMgY2FuIHJlamVjdCBzdWNoIGZv
cm1hdCBzdHJpbmcuDQo+IA0KPiBSZXBvcnRlZC1ieTogTmlraXRhIFNoaXJva292IDx0ZWhuZXJk
QHRlaG5lcmQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5A
ZmIuY29tPg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg==
