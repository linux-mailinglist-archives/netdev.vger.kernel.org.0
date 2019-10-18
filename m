Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0713DCD34
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409399AbfJRSAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:00:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47440 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405272AbfJRSAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 14:00:13 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9IHxNAO011335;
        Fri, 18 Oct 2019 10:59:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dl97YEStcDgeM9RdHBEJ3CBOOA5W7sfeSC6YwPcNwE0=;
 b=Z7IMDS0RS2Cq0Nwo5vhjOqWVorpuJm5ksjIpC9n3xi0fcJOU5Por0QhYWMwAIJJHLxed
 GPmgZRzR0PhxR4lcUvykTEgjCL3ZMj7AQKqCnPAohzyYUG2xCSfSW/KYwXc/BKAEXZjz
 KoFCBmbkf3EGGoktVPA5pUWp0ZLpt9UneAU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vqc4esrmq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 10:59:57 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 10:59:56 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 10:59:56 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 10:59:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WyAvyLxIXbByIgMuzfuAx1/sJykGJGHbFGbHo9IF4BiLk027cV5GEw+qJwmyLYB/gDJ717TIaXDwU9VirN+CX7SKsQ9lFgwMfBekP6O7gtKFA/P2GRHQqQoEGQitqDijr7PAJV0y2CvgHULVibh8SkQnnbTP77Zklf4YJRjv2zHspwW11tst3TLrRjudxl0MSH/VKfV91XQJ7SJqcn15AqOcUs3Cg5k0jQ2Y5h/R8t85Q4zV+ddmKCFVC3zpgB+ofdPj5Vzj9jyRO7Ltb0UXB4hNKREB0NcTpxoprMapSFByUYnSZt9RNswQc21dMJrR3cKKQep/dWkmpB+JGQQPXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dl97YEStcDgeM9RdHBEJ3CBOOA5W7sfeSC6YwPcNwE0=;
 b=XyczOFAUdfHW5cPFoob6dZRJAAMsecyrn0WsS5kqytXiHSCaCxYd/Td54YKaIj8NzM1LxiNNcsQeCctROWzxigycQiZKyaMTC/rLuToQwjwcEz7a5exQGVPeJ9j00Mk8jmolcE24n7peORRP1bnBywhYm3knZGKyGeg2SH4f+2Y6GOgweF68OikSFft5942j3zg0+ueWj5dm7cXDj17f4hmz2MeJ/zSPpJNxqEC9u1RJiZ6CVti9McON7D1Nj03XsrKfiv5EaK3JPWEUfbktyv7VHxOsowb1FNYk29J8uLYW3ltTBWuu6o4/AyV5blYEeBil+5XCJa/81x+b4zf7Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dl97YEStcDgeM9RdHBEJ3CBOOA5W7sfeSC6YwPcNwE0=;
 b=a92dvs9QVGPPBQqchf2d9Z2KgF+SCu5R+443Uff5b/5yAbPoDdi9m67nuDKndCnh+8Ad353jTrZI1ExARriWVF3uAIe1qVZV3/NZyR/f4gJqMkhAsVncEfVzr/LmvLu9+ktc7DWBPuTjQMXIasVBlTX2STOwEwcFkXQ7SuhdBZU=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2424.namprd15.prod.outlook.com (52.135.194.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 18 Oct 2019 17:59:53 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 17:59:53 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpf: fix bpf_attr.attach_btf_id check
Thread-Topic: [PATCH bpf-next] bpf: fix bpf_attr.attach_btf_id check
Thread-Index: AQHVhXqj8WHqTlfn8kKC1v97g9+2MadgsLYA
Date:   Fri, 18 Oct 2019 17:59:53 +0000
Message-ID: <8a75a0e4-2202-7a3f-dfd2-45b25f8c5147@fb.com>
References: <20191018060933.2950231-1-ast@kernel.org>
In-Reply-To: <20191018060933.2950231-1-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0071.namprd12.prod.outlook.com
 (2603:10b6:300:103::33) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3455]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4bc6509-d700-4472-5568-08d753f4fa15
x-ms-traffictypediagnostic: BYAPR15MB2424:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2424B3D5B8C89BD3ED8A697CD36C0@BYAPR15MB2424.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(366004)(396003)(189003)(199004)(53546011)(36756003)(102836004)(2501003)(186003)(486006)(446003)(2616005)(99286004)(476003)(52116002)(76176011)(46003)(386003)(6506007)(64756008)(6246003)(6436002)(31696002)(66446008)(11346002)(5660300002)(66476007)(25786009)(31686004)(86362001)(66946007)(229853002)(66556008)(6486002)(4326008)(6512007)(305945005)(14454004)(71200400001)(478600001)(110136005)(6116002)(71190400001)(5024004)(7736002)(2906002)(54906003)(316002)(8936002)(81166006)(8676002)(256004)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2424;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RQhfwlw/iv7Cm0RBg5IxkzXUMzeB1JGuj6qxE8U0C+zSaLTDL5ZNOlC5PAJhoa111hggpkqc6CYYUsJ9fCloPBEcM3wa7Zwx36/YBf+UMVFThK4xlztaaFPw6tpSn366eai1i7g0fTzzp2SQN5zfeTNcNSzRmEmrbgWKlgHZaqP5xxkWw31H0C+fIU/phqUayUjJTnNHQ+0ahvdV1kwz0DkQeiXwCkGT1SpNqflb+s8SF6SNkof8amHuSdn96b9fFzAJ5eKOLL7P88C9rMNXpCSB3cM/Y+ap8EoyWJKoFltstD1PpcUF2wMODJn+FqpJdURag7RmVwYZc2VP5dsnpP8gebq9BIdC1k/rlkCh0n52m/8KYukLszUTzMqdVrzRo9QT69BHmPp/aZZFbpRHyjAQebqLy3PFEzI4vOmUgQ8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E972270C53F514593A1CAA17A4934CD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e4bc6509-d700-4472-5568-08d753f4fa15
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 17:59:53.1960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZbizyhNqwXc2Ictf+VBO7FW2/sbMrX0lvoMf681A0CGCOyDDbkrCeIOlossIrEoh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2424
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910180163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzE3LzE5IDExOjA5IFBNLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+IE9u
bHkgcmF3X3RyYWNlcG9pbnQgcHJvZ3JhbSB0eXBlIGNhbiBoYXZlIGJwZl9hdHRyLmF0dGFjaF9i
dGZfaWQgPj0gMC4NCj4gTWFrZSBzdXJlIHRvIHJlamVjdCBvdGhlciBwcm9ncmFtIHR5cGVzIHRo
YXQgYWNjaWRlbnRhbGx5IHNldCBpdCB0byBub24temVyby4NCj4gDQo+IEZpeGVzOiBjY2ZlMjll
YjI5YzIgKCJicGY6IEFkZCBhdHRhY2hfYnRmX2lkIGF0dHJpYnV0ZSB0byBwcm9ncmFtIGxvYWQi
KQ0KPiBSZXBvcnRlZC1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4NCg0KQWNrZWQt
Ynk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQoNCj4gLS0tDQo+ICAga2VybmVsL2JwZi9z
eXNjYWxsLmMgfCAxNyArKysrKysrKysrKy0tLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxMSBp
bnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9i
cGYvc3lzY2FsbC5jIGIva2VybmVsL2JwZi9zeXNjYWxsLmMNCj4gaW5kZXggNTIzZTNhYzE1YTA4
Li4xNmVhM2MwZGI0ZjYgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9icGYvc3lzY2FsbC5jDQo+ICsr
KyBiL2tlcm5lbC9icGYvc3lzY2FsbC5jDQo+IEBAIC0xNTcwLDYgKzE1NzAsMTcgQEAgYnBmX3By
b2dfbG9hZF9jaGVja19hdHRhY2goZW51bSBicGZfcHJvZ190eXBlIHByb2dfdHlwZSwNCj4gICAJ
CQkgICBlbnVtIGJwZl9hdHRhY2hfdHlwZSBleHBlY3RlZF9hdHRhY2hfdHlwZSwNCj4gICAJCQkg
ICB1MzIgYnRmX2lkKQ0KPiAgIHsNCj4gKwlzd2l0Y2ggKHByb2dfdHlwZSkgew0KPiArCWNhc2Ug
QlBGX1BST0dfVFlQRV9SQVdfVFJBQ0VQT0lOVDoNCj4gKwkJaWYgKGJ0Zl9pZCA+IEJURl9NQVhf
VFlQRSkNCj4gKwkJCXJldHVybiAtRUlOVkFMOw0KPiArCQlicmVhazsNCj4gKwlkZWZhdWx0Og0K
PiArCQlpZiAoYnRmX2lkKQ0KPiArCQkJcmV0dXJuIC1FSU5WQUw7DQo+ICsJCWJyZWFrOw0KPiAr
CX0NCj4gKw0KPiAgIAlzd2l0Y2ggKHByb2dfdHlwZSkgew0KPiAgIAljYXNlIEJQRl9QUk9HX1RZ
UEVfQ0dST1VQX1NPQ0s6DQo+ICAgCQlzd2l0Y2ggKGV4cGVjdGVkX2F0dGFjaF90eXBlKSB7DQo+
IEBAIC0xNjEwLDEzICsxNjIxLDcgQEAgYnBmX3Byb2dfbG9hZF9jaGVja19hdHRhY2goZW51bSBi
cGZfcHJvZ190eXBlIHByb2dfdHlwZSwNCj4gICAJCWRlZmF1bHQ6DQo+ICAgCQkJcmV0dXJuIC1F
SU5WQUw7DQo+ICAgCQl9DQo+IC0JY2FzZSBCUEZfUFJPR19UWVBFX1JBV19UUkFDRVBPSU5UOg0K
PiAtCQlpZiAoYnRmX2lkID4gQlRGX01BWF9UWVBFKQ0KPiAtCQkJcmV0dXJuIC1FSU5WQUw7DQo+
IC0JCXJldHVybiAwOw0KPiAgIAlkZWZhdWx0Og0KPiAtCQlpZiAoYnRmX2lkKQ0KPiAtCQkJcmV0
dXJuIC1FSU5WQUw7DQo+ICAgCQlyZXR1cm4gMDsNCj4gICAJfQ0KPiAgIH0NCj4gDQo=
