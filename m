Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4127EFEA08
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 02:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfKPBS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 20:18:56 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61406 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727298AbfKPBSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 20:18:54 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAG1ENux003068;
        Fri, 15 Nov 2019 17:18:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/J/nI4zHj133msHcZ2ugLqArUMTq0B+ZLa4M81X4SOM=;
 b=NrpwnZ0VPnmW6zQgZVadqiVypf69085T7uzzYc6UuS5X9B/BEuEniSh/C7g6+TdoFCDu
 +OG/tuoSHwVt3blycrl554Qy+w5LPqy30hmTRgTVjpzabszlWH3mXBe8tnlyhphZxcM1
 1Mr5/oN0LknsgB8i9Hzt1NNLfzWrFGdLl3Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2wa1junsj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 15 Nov 2019 17:18:37 -0800
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 15 Nov 2019 17:18:36 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 15 Nov 2019 17:18:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwpCL3wsNXw0kvkcBO4tPI4vJBh8fBmXS8ReMsz0MJNXETTHRW5DeSCFaTArHG5uRSbSEvww/ChZwvVASfypM3fU+N0AHo3pl0kRmiW9f0uFgXu5UXaMlA/Ruicw4AxCmjuoAcOqtuk1NkXtXjio/aFNy1OCiCmkTOOKq14IU5mDIWJV4CRJV2Tcv5DyebeRJP3w/8a2b9xsVBX7AAWiQMpWkZqGYCqfNQCbl+mVjkGCf4IrzpZ941IL4e8lR+hpOI7LGPFw/EvvWrxlX81njFwtp5wNVKgBtXGroTtGUC1UOETqjtsQcqJIq65PXKLvDdU03N/VIG3hhJtD2BcXmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/J/nI4zHj133msHcZ2ugLqArUMTq0B+ZLa4M81X4SOM=;
 b=jGDza7wvY25iy7Vbv5Zme9QshNrS3faM42DMbA2hiWomwZiAMU98Zs4kq7xu2/9wArtr9yDmmOW9WQ7gyxJvMQQaBkE+K9F0VRos2dcF8rouNNbWBlFZz4kt8nQ3TdX86157YhbJuM27hWHnOS/dllv34lDB5qOJJPlAD0OsrAQ/7dC4J3N1e4VASgk8a8kmPBOyVMcOTt2Og79SWhPb5qZHkieC3rbGdjeAlrqsWXxRWx3Quld+A8Bp6T07yQvHns3LJQNo+vBK0ApUxcRKOAY424gdnYvt4SY3XRdpcZ+Sy6KbIKwRZ8jpP5USHOC9jn4ZwBZoGMpINo8Ah5cnpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/J/nI4zHj133msHcZ2ugLqArUMTq0B+ZLa4M81X4SOM=;
 b=aRSQI2rT2QrgZ2Fs3OBfAcqe1DHZUWfs/x3MHt5wXdmx5D3YBcn64bGMFsxEfRghzt1U2gmdU3ywpUYEpGIGEdmggcAQPfJiItzjpe9750sTmYX7gB6+Ay2DwVjM6oHk0Ilak4+w4YMCFURfUqbsRWYHb0kVfG7Psw3ooO2eIvA=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3381.namprd15.prod.outlook.com (20.179.59.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Sat, 16 Nov 2019 01:18:34 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2451.027; Sat, 16 Nov 2019
 01:18:34 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Thread-Topic: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Thread-Index: AQHVm2mT23Qa9zxaoUGXDmZOssK4HKeM4soAgAABlICAAAIggP//eoiAgACNnQCAABINgA==
Date:   Sat, 16 Nov 2019 01:18:34 +0000
Message-ID: <3eca5e22-f3ec-f05f-0776-4635b14c2a4e@fb.com>
References: <20191115040225.2147245-1-andriin@fb.com>
 <20191115040225.2147245-3-andriin@fb.com>
 <888858f7-97fb-4434-4440-a5c0ec5cbac8@iogearbox.net>
 <293bb2fe-7599-3825-1bfe-d52224e5c357@fb.com>
 <3287b984-6335-cacb-da28-3d374afb7f77@iogearbox.net>
 <fe46c471-e345-b7e4-ab91-8ef044fd58ae@fb.com>
 <c79ca69f-84fd-bfc2-71fd-439bc3b94c81@iogearbox.net>
In-Reply-To: <c79ca69f-84fd-bfc2-71fd-439bc3b94c81@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0057.namprd22.prod.outlook.com
 (2603:10b6:301:16::31) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::8ac1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b369656-f00e-4061-8f24-08d76a32e681
x-ms-traffictypediagnostic: BYAPR15MB3381:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3381661C5FE4A893145C906AD7730@BYAPR15MB3381.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02234DBFF6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(39860400002)(346002)(366004)(199004)(189003)(25786009)(11346002)(36756003)(305945005)(486006)(46003)(476003)(2906002)(6506007)(66946007)(66556008)(66476007)(386003)(66446008)(64756008)(53546011)(52116002)(186003)(2616005)(99286004)(4326008)(71200400001)(71190400001)(446003)(86362001)(6512007)(8676002)(2501003)(2201001)(31696002)(478600001)(6246003)(14454004)(6486002)(229853002)(31686004)(54906003)(6116002)(102836004)(76176011)(110136005)(14444005)(256004)(8936002)(7736002)(81156014)(5660300002)(6436002)(4744005)(81166006)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3381;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bbDiqWOOfHqAPjqn5eHvj8BiqY7tNdOUAt0uPdmCV/u9F+vm9//9uLTDpvFir7vaDV6yeL6wsnj2giydTSahQXBlDksv2d/7o8vkX54+rAE6e8xhpRdKCuwqXoVWijOa1C4/OXFgnerCFSMqZR3+pmq0zVQE2fCzjxCjdwf8iiHkaBBTro5rAXwjBWkaj+4yjJv6LdMXjzORx8YMG7iLr7XvdVHm3CZKGLKvmiVSCjXQccsaUfATBLn2G/ltJqPbYTmzLdsvZarEabJ6X24gpgpThxSFzj97yK5qLa7agR5+tK4i/EUxYmE9mK/zvAddUDf30zpdLJ/kpJKoH+FSEdeVTQMs8/NomZxWpxeveWSh0wiBuvbUy32DMzhBtQ9dmgxGGnlOP2+NuepOe4MOW2Rg7MViR6rXL14uiHHmPsCjHWvEdhvZary0Q6JjeVv9
Content-Type: text/plain; charset="utf-8"
Content-ID: <68626CA51A664A47AAB88E7F4E5B8148@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b369656-f00e-4061-8f24-08d76a32e681
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2019 01:18:34.7442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rlXTcgypfG+kFPS/8tZ9elEQ/y0HSKWD1UivvzGuJAW+PtI+4SzFkA7vJRmtBVFD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3381
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_08:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911160006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMTUvMTkgNDoxMyBQTSwgRGFuaWVsIEJvcmttYW5uIHdyb3RlOg0KPj4+IFllYWgsIG9u
bHkgZm9yIGZkIGFycmF5IGN1cnJlbnRseS4gUXVlc3Rpb24gaXMsIGlmIHdlIGV2ZXIgcmV1c2Ug
dGhhdA0KPj4+IG1hcF9yZWxlYXNlX3VyZWYNCj4+PiBjYWxsYmFjayBpbiBmdXR1cmUgZm9yIHNv
bWV0aGluZyBlbHNlLCB3aWxsIHdlIHJlbWVtYmVyIHRoYXQgd2UgZWFybGllcg0KPj4+IG1pc3Nl
ZCB0byBhZGQNCj4+PiBpdCBoZXJlPyA6Lw0KPj4NCj4+IFdoYXQgZG8geW91IG1lYW4gJ21pc3Nl
ZCB0byBhZGQnID8NCj4gDQo+IFdhcyBzYXlpbmcgbWlzc2VkIHRvIGFkZCB0aGUgaW5jL3B1dCBm
b3IgdGhlIHVyZWYgY291bnRlci4NCj4gDQo+PiBUaGlzIGlzIG1tYXAgcGF0aC4gQW55dGhpbmcg
dGhhdCBuZWVkcyByZWxlYXNpbmcgKGxpa2UgRkRzIGZvcg0KPj4gcHJvZ19hcnJheSBvciBwcm9n
cyBmb3Igc29ja21hcCkgY2Fubm90IGJlIG1tYXAtYWJsZS4NCj4gDQo+IFJpZ2h0LCBJIG1lYW50
IGlmIGluIGZ1dHVyZSB3ZSBldmVyIGhhdmUgYW5vdGhlciB1c2UgY2FzZSBvdXRzaWRlIG9mIGl0
DQo+IGZvciBzb21lIHJlYXNvbiAodW5yZWxhdGVkIHRvIHRob3NlIG1hcHMgeW91IG1lbnRpb24g
YWJvdmUpLiBDYW4gd2UNCj4gZ3VhcmFudGVlIHRoaXMgaXMgbmV2ZXIgZ29pbmcgdG8gaGFwcGVu
PyBTZWVtZWQgbGVzcyBmcmFnaWxlIGF0IGxlYXN0IHRvDQo+IG1haW50YWluIHByb3BlciBjb3Vu
dCBoZXJlLg0KDQpJJ20gc3RydWdnbGluZyB0byB1bmRlcnN0YW5kIHRoZSBjb25jZXJuLg0KbWFw
LWluLW1hcCwgeHNrbWFwLCBzb2NrZXQgbG9jYWwgc3RvcmFnZSBhcmUgZG9pbmcgYnBmX21hcF9p
bmMoLCBmYWxzZSkNCndoZW4gdGhleSBuZWVkIHRvIGhvbGQgdGhlIG1hcC4gV2h5IHRoaXMgY2Fz
ZSBpcyBhbnkgZGlmZmVyZW50Pw0K
