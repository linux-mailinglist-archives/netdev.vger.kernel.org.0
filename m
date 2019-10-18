Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E947DCDA8
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501866AbfJRSMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:12:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25576 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbfJRSMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 14:12:42 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9II5Yfn029873;
        Fri, 18 Oct 2019 11:11:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OuJEf/Kdrpy+drj0OASDzsUBikIKeeeLgsqYVUboVvE=;
 b=EkRnUCZg//COOzPJmHMUs4Yx1znEhkLfFGN1y7ayUMQnB2Z6Mj3G5HeM4bDWOPHDfuiV
 Y7/KzdjDsDwDVrnODzNtIkppPw33eWLq7UYGd1Ar2BTcSVFdEBYOXGQB7cmR+A+EP0Z/
 tkdMjXZO4L+FN0SJ+3iWwFr7ZYo9GARZVmE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vqgss8h3y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Oct 2019 11:11:09 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 18 Oct 2019 11:11:09 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 11:11:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V897sQHdTovn20wr1xMKt21fKowQOr1+JLS8J2Mp5tivafQntV+obhJGAor4hHJuWjrSsHg12EaGds34Tn8K9GrCZPPBsybZdoxMm1caYYx9F2XbkWRb6FXAZVDj+USUhAK4D66C5o2G23oW1p6mUB+NKbJUdRyG8ap51eSjwnUYhaKbHxss1xqC8kiJ/QdfNJrBZNUueaL49231zM2FhkOCpwZnq/Ets3gbIHDsRd4mbkt1Bf/JMtk2/Kvf61EH9aXWq16fNO21n2MAqO0lZwK4Dd9k3f0tpRlxP8AtHBd5JyEkVDY9jzhORKyOJT0TszypjsXApBH11l28X9ZThw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuJEf/Kdrpy+drj0OASDzsUBikIKeeeLgsqYVUboVvE=;
 b=TZlo2QP31Fxepf2onsqLF80uZhpuRtUaiWSPUrAIIuLHzzhjO64SvYNxaNBS+e94N5YZrAfj+cZ9pNpemUpCvBS+sCkp1HXf1/xb09IOG11WqFhPv8niCo+oZ9dSzzx0dsgF8A4DpESXjdCICN4/huRRWAQc+iTvyroKEoXl+g9X4FRVxj9FiKHj9cuaNREW1YsyX//VF6JHOuk1RmVzdlwQ/cV1N74PGWcOec2Z8Mk5C40MRkUyxfVUYoI2p24DZd0ymLc2dYdUF6BbDx9NDaG4Ya2OGHuDGDqclYlBmkJLU/nj/1Aiz4wzzH12zTOu4do62T1coW+4WopxW0/0Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuJEf/Kdrpy+drj0OASDzsUBikIKeeeLgsqYVUboVvE=;
 b=RAoCaZc5YJNLKZTMHwqS17OjJUmCoSMWmvHrNUZlAzlcYnHsUxlzNcS9p13cfBWjGv/CBc2WBwS9oSRuoQL2LC4hbenBi/tBqizsegj+RjTHQHQPvzC89od7Gp1Taaqfy0QCJ6UOGj9vBXnrCdtliLHv9gGJ5MmKbptJnEwq1+Y=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2358.namprd15.prod.outlook.com (52.135.198.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 18:11:08 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 18:11:07 +0000
From:   Yonghong Song <yhs@fb.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Fix build error without CONFIG_NET
Thread-Topic: [PATCH bpf-next] bpf: Fix build error without CONFIG_NET
Thread-Index: AQHVhZNJsykV/X9sw02Jid8GrOHS3adgs6eA
Date:   Fri, 18 Oct 2019 18:11:07 +0000
Message-ID: <ee9a06ec-33a0-3b39-92d8-21bd86261cc2@fb.com>
References: <20191018090344.26936-1-yuehaibing@huawei.com>
In-Reply-To: <20191018090344.26936-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR2101CA0007.namprd21.prod.outlook.com
 (2603:10b6:302:1::20) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3455]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab123800-1ee3-47d6-8cb4-08d753f68c24
x-ms-traffictypediagnostic: BYAPR15MB2358:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB235899FE6290E0A8E2BC547FD36C0@BYAPR15MB2358.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:321;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(376002)(39860400002)(366004)(189003)(199004)(66476007)(66446008)(66556008)(6512007)(6636002)(66946007)(64756008)(6246003)(4326008)(31696002)(86362001)(2906002)(2501003)(6116002)(6486002)(6436002)(305945005)(2201001)(7736002)(102836004)(53546011)(6506007)(386003)(229853002)(256004)(36756003)(186003)(54906003)(478600001)(110136005)(52116002)(14454004)(76176011)(99286004)(71190400001)(316002)(71200400001)(46003)(11346002)(31686004)(486006)(476003)(446003)(2616005)(8936002)(81166006)(81156014)(5660300002)(25786009)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2358;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 74dTmG0aAS/tSWEcLv9g1jCLztzHUSkWAwWFgO1OScCuNMBhWZeQBZ8KGORs9z27wrVbkqOQlxVAQpgS2NXiUQ7+ZHYWjGzb6j2RAVYhN5n6p11zMNHVyffMlVhbHazjGxDieQ6MmvdfV3QJUm7cSFmxoO9ZDInNNnaZo012w8eGwA//uI9sjjkIic0z+dhDh8nHk1w5t3bGR1gOCjiqNulK2qSxAa3plh1axwlu/qfLb2LzhnZdBAjUGQAgazec47L4qHVl3pWg91TFEMwQDVJrnibzO3WjE5Ml/Dq6xxx8t9yhoYKYjYHchdlK3DE6/B61ljIVWSdxQOA416te+Zf84/IWF+oC1otlZfa6RuCFNOiyve4BFlP65bsH7Hu5Lweb0qmnfP20HxTXekcwBGgDWbQ0C0pVhUcf03K1w8t/RhV4jCJbGF1vDp+c1JR+
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3DA4722A3443A48A37EC823670766CE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ab123800-1ee3-47d6-8cb4-08d753f68c24
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 18:11:07.8138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x1IJon7//U0P6o+j2uZwfKU6i641In1mgxtSjgqG7Z4WObdURiabkUGQbp9Z40fW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2358
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 impostorscore=0 adultscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzE4LzE5IDI6MDMgQU0sIFl1ZUhhaWJpbmcgd3JvdGU6DQo+IElmIENPTkZJR19O
RVQgaXMgbiwgYnVpbGRpbmcgZmFpbHM6DQo+IA0KPiBrZXJuZWwvdHJhY2UvYnBmX3RyYWNlLm86
IEluIGZ1bmN0aW9uIGByYXdfdHBfcHJvZ19mdW5jX3Byb3RvJzoNCj4gYnBmX3RyYWNlLmM6KC50
ZXh0KzB4MWEzNCk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8gYGJwZl9za2Jfb3V0cHV0X3Byb3Rv
Jw0KPiANCj4gV3JhcCBpdCBpbnRvIGEgI2lmZGVmIHRvIGZpeCB0aGlzLg0KPiANCj4gUmVwb3J0
ZWQtYnk6IEh1bGsgUm9ib3QgPGh1bGtjaUBodWF3ZWkuY29tPg0KPiBGaXhlczogYTc2NThlMWE0
MTY0ICgiYnBmOiBDaGVjayB0eXBlcyBvZiBhcmd1bWVudHMgcGFzc2VkIGludG8gaGVscGVycyIp
DQo+IFNpZ25lZC1vZmYtYnk6IFl1ZUhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4NCg0K
QWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQoNCj4gLS0tDQo+ICAga2VybmVs
L3RyYWNlL2JwZl90cmFjZS5jIHwgMiArKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMgYi9rZXJu
ZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4gaW5kZXggNTJmN2U5ZC4uYzMyNDA4OSAxMDA2NDQNCj4g
LS0tIGEva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQo+ICsrKyBiL2tlcm5lbC90cmFjZS9icGZf
dHJhY2UuYw0KPiBAQCAtMTA1NSw4ICsxMDU1LDEwIEBAIHJhd190cF9wcm9nX2Z1bmNfcHJvdG8o
ZW51bSBicGZfZnVuY19pZCBmdW5jX2lkLCBjb25zdCBzdHJ1Y3QgYnBmX3Byb2cgKnByb2cpDQo+
ICAgCXN3aXRjaCAoZnVuY19pZCkgew0KPiAgIAljYXNlIEJQRl9GVU5DX3BlcmZfZXZlbnRfb3V0
cHV0Og0KPiAgIAkJcmV0dXJuICZicGZfcGVyZl9ldmVudF9vdXRwdXRfcHJvdG9fcmF3X3RwOw0K
PiArI2lmZGVmIENPTkZJR19ORVQNCj4gICAJY2FzZSBCUEZfRlVOQ19za2Jfb3V0cHV0Og0KPiAg
IAkJcmV0dXJuICZicGZfc2tiX291dHB1dF9wcm90bzsNCj4gKyNlbmRpZg0KPiAgIAljYXNlIEJQ
Rl9GVU5DX2dldF9zdGFja2lkOg0KPiAgIAkJcmV0dXJuICZicGZfZ2V0X3N0YWNraWRfcHJvdG9f
cmF3X3RwOw0KPiAgIAljYXNlIEJQRl9GVU5DX2dldF9zdGFjazoNCj4gDQo=
