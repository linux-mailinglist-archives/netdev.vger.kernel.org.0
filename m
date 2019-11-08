Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7ED4F57BC
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388564AbfKHTg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:36:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3586 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388157AbfKHTg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:36:28 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8Ja0lZ005607;
        Fri, 8 Nov 2019 11:36:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Ya0ZFc0ZTC2CZqPnqGCFE8RubVJK4iqP1MRJHqP5aCU=;
 b=g47pVprFQdXoafWpxB6IKTyuqvFCerm5L4WitH7XB8teiUNbUjI+zCJMB/RbQ/tPIGrJ
 Dd/MU1ZEp230NlmQofmikZM40YVUwHQH0HZyEA8d8+lhvT1SoDcI3m2SF/9XTRIGW1GK
 yQILFtGHEezt5T/nsTMlIzR0G/ytHJatKD0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41und7u7-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 11:36:12 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 8 Nov 2019 11:36:06 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 11:36:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oB170GWPxf6+iJeq8m+INERHXNxzqvUhIHS9irsCW1NHAIrCF4G0KwjBHurrUyBJ8QeU21rCJXniboCrlo19IlvhQVzx2CdA845beIa+DJNK2Yxlm8zR+LrOS69Z3jLWbf7+RAcjjIKTrlCIJSir0L+HeLl2Rl1NL4KJVLFQrUOfHkCltC2kdmxn0V0HNbSF6spolk04w7fuVFn+AQ8ZnVKQqlxcEe2e9IoR6pbwc6eQVWPZ+ZjhWAlFuVcDokq9aE4LTVyOfJJCpq00WkvpUanwm1TmFe+VEqM8kANPEsRZZfpYD0bVbhANIOx4z7RxfRxXAKGJnKeucuoA4vPmQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ya0ZFc0ZTC2CZqPnqGCFE8RubVJK4iqP1MRJHqP5aCU=;
 b=kTwRmhj11VCs3Sz3TJ+pBseZ5C+CxgIKK8UnqTUBYffS0pLQnKfN9oK65e2xUo4PtU/KqWRpCV/ZnGSnyc8qu/L635JPlNDGOaAk6Z/b2fOf4WcV8qgmWhKi8oSIuS4ZWFXjk2zPqeUdvvienEcbbMWe11IRmWgLUqE1dFK5htIOH3dOzV8fOi0hXiottVYjPuvh8liQSL6LHEMtxhz/KX3qU03aDSb8cgeC4r5V/bQap6JFfwwrNUU1Actn9zgQ4mOTEuAhMaBPbkH+gL3csVl3Gu8htU12NU6+5lnND8ddh8D0sT9PEpW9lp93bzFUJz4Vry5oJkuwNNGMCAcmCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ya0ZFc0ZTC2CZqPnqGCFE8RubVJK4iqP1MRJHqP5aCU=;
 b=Y9+y8SVjbRzl23Tt9mrq87NxU0tycSTKrkKYhAAfOQgmFRZCUd4BZ57ZNQgvBT6KNedbLWXoc/Vr55VTQa9KiKnqA5vlJzb28KiNE36Tu/K6kcup83hKnxExQMrbXnuYN4QBwum7NAF5x3+9BDzGDBZysExhFtrDSiolNMCPnKg=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1565.namprd15.prod.outlook.com (10.173.235.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 19:36:05 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 19:36:05 +0000
From:   Song Liu <songliubraving@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/6] libbpf: Propagate EPERM to caller on program
 load
Thread-Topic: [PATCH bpf-next 3/6] libbpf: Propagate EPERM to caller on
 program load
Thread-Index: AQHVlYu+PX0T6gaL2kGVtCRHNJJnmaeBrGwA
Date:   Fri, 8 Nov 2019 19:36:05 +0000
Message-ID: <68FB5A08-C8DA-4D64-949C-C725483A9999@fb.com>
References: <157314553801.693412.15522462897300280861.stgit@toke.dk>
 <157314554141.693412.14085088717794768890.stgit@toke.dk>
In-Reply-To: <157314554141.693412.14085088717794768890.stgit@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 343ffef7-ed65-44c8-9105-08d76482e55e
x-ms-traffictypediagnostic: MWHPR15MB1565:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB15653030ED181DEF1088B3B8B37B0@MWHPR15MB1565.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(396003)(376002)(346002)(199004)(189003)(2906002)(71190400001)(446003)(66476007)(53546011)(66556008)(76116006)(4744005)(186003)(102836004)(2616005)(478600001)(81166006)(81156014)(33656002)(256004)(66946007)(5660300002)(11346002)(14444005)(6506007)(66446008)(6246003)(8676002)(305945005)(8936002)(486006)(476003)(6436002)(6486002)(54906003)(50226002)(64756008)(25786009)(7736002)(66574012)(99286004)(6916009)(46003)(6116002)(76176011)(316002)(86362001)(4326008)(71200400001)(229853002)(36756003)(6512007)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1565;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hb2+D+JxtpaLzFH+ZnyEuLiPIscH8IXg1m7GUBshMPBdrrVx7LehPwhmba9H/J/2CHKl2CJglsaKRMHzwQfIzrY/bZ5nctk/GnRAkMozDlwR3eMUqf35fbcaI4s7IsHX6fsj/qJybOoCPlwxKW6W/AGTIgKgF2ZYYmMvxLhgS0w+ko9oJaI37Adb3uFxt8FKIf+fcwOZGJ+JHNtUH/36oLM0IZv4tVLEUxzL2T4HutM/ruJMm1gKMWWhFD2zMbQamuEigkWah4RQCvtCIHrsgDBSo3WQ9MDrICfhzGxlUREwzZhsQ1gcxG+cawiVrUcFxFU8IGtXhQ0sovKhFDyXzmK5TzQ7+uoUk+lLcxBArVIjLm+xbweYvssoTZgb+V8t0S0obIbOmdNbYcM5RKIYdDONKInbu1oNUh4ID0jNiQfuuJhjjRRkjCPjgNCCuAgG
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCE3E00A355E2544B1E599B2D39B072C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 343ffef7-ed65-44c8-9105-08d76482e55e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 19:36:05.1311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EyRPFLsiMbbSuRDyRHyRft80NSBZAkw/f3e7EnwhAzkj/ip4dGPn965wR6lOpB1BwQo3NBpbDVdUKudmx+qJsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1565
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_07:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 mlxscore=0 spamscore=0 suspectscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080190
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTm92IDcsIDIwMTksIGF0IDg6NTIgQU0sIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNl
biA8dG9rZUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IFRva2UgSMO4aWxhbmQtSsO4
cmdlbnNlbiA8dG9rZUByZWRoYXQuY29tPg0KPiANCj4gV2hlbiBsb2FkaW5nIGFuIGVCUEYgcHJv
Z3JhbSwgbGliYnBmIG92ZXJyaWRlcyB0aGUgcmV0dXJuIGNvZGUgZm9yIEVQRVJNDQo+IGVycm9y
cyBpbnN0ZWFkIG9mIHJldHVybmluZyBpdCB0byB0aGUgY2FsbGVyLiBUaGlzIG1ha2VzIGl0IGhh
cmQgdG8gZmlndXJlDQo+IG91dCB3aGF0IHdlbnQgd3Jvbmcgb24gbG9hZC4NCj4gDQo+IEluIHBh
cnRpY3VsYXIsIEVQRVJNIGlzIHJldHVybmVkIHdoZW4gdGhlIHN5c3RlbSBybGltaXQgaXMgdG9v
IGxvdyB0byBsb2NrDQo+IHRoZSBtZW1vcnkgcmVxdWlyZWQgZm9yIHRoZSBCUEYgcHJvZ3JhbS4g
UHJldmlvdXNseSwgdGhpcyB3YXMgc29tZXdoYXQNCj4gb2JzY3VyZWQgYmVjYXVzZSB0aGUgcmxp
bWl0IGVycm9yIHdvdWxkIGJlIGhpdCBvbiBtYXAgY3JlYXRpb24gKHdoaWNoIGRvZXMNCj4gcmV0
dXJuIGl0IGNvcnJlY3RseSkuIEhvd2V2ZXIsIHNpbmUgbWFwcyBjYW4gbm93IGJlIHJldXNlZCwg
b2JqZWN0IGxvYWQgY2FuDQoJCQkJXl4gc2luY2UNCj4gcHJvY2VlZCBhbGwgdGhlIHdheSB0byBs
b2FkaW5nIHByb2dyYW1zIHdpdGhvdXQgaGl0dGluZyB0aGUgZXJyb3I7DQo+IHByb3BhZ2F0aW5n
IGl0IGV2ZW4gaW4gdGhpcyBjYXNlIG1ha2VzIGl0IHBvc3NpYmxlIGZvciB0aGUgY2FsbGVyIHRv
IHJlYWN0DQo+IGFwcHJvcHJpYXRlbHkgKGFuZCwgZS5nLiwgYXR0ZW1wdCB0byByYWlzZSB0aGUg
cmxpbWl0IGJlZm9yZSByZXRyeWluZykuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBUb2tlIEjDuGls
YW5kLUrDuHJnZW5zZW4gPHRva2VAcmVkaGF0LmNvbT4NCg0KQWNrZWQtYnk6IFNvbmcgTGl1IDxz
b25nbGl1YnJhdmluZ0BmYi5jb20+
