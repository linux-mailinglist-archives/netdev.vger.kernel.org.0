Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 400F8D1914
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731616AbfJITip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:38:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61788 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730708AbfJITip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:38:45 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x99JUD0R012520;
        Wed, 9 Oct 2019 12:38:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3bF7w80voCnsj60rYcOAtvIL8fuE/mOZjhQyKgkwCcI=;
 b=LzrI/d+2CC77jy6Smp+LqquVuC+vBUOv81NFRObyNXd1l/1eOahzVFl1Y1T5XuuUnHf3
 fKS2Wpj589afjgG+R1tA5HQHPVtUQrdY9cwUBsWfKmXG63qK0mVG+zTFZfUdJyq+uTFm
 l+bjX8qyocrQbZFP7K4u6Wgv3MH095GXli4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vgvbyym6c-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 09 Oct 2019 12:38:21 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 9 Oct 2019 12:38:18 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 9 Oct 2019 12:38:18 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 9 Oct 2019 12:38:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbWKv8B/NmeZ1G0jTZpjkz6H/V10lgNxBgm6c7XvfzzA1o/d6PgkqJ7mQwWLi2FO48hHzbLCcJX6VgNaX0PTNeZlJf0mgvlvHzIcTWIANoMgfQKjTVQ+27gTwEfS8DykE/FEOMNZcwnrqAgsrIeUsntazgodJvTmhwE5xffqqCQmpO5z9yzue5c/RXm/GYyxdGLDDT/MGVmKs6wQQn1Y2XfTa7CHym+orHiMQrFC4UnQfil9jq8wc2mZ7LsXojrxPi899Vg7WXo/x1hfYvBI02D1h6yYasFP5VSJ/rTIWrsO6efNbz4VSfixtsQb+g1V34Jj1T0JuuHd8R/PCJ2S3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bF7w80voCnsj60rYcOAtvIL8fuE/mOZjhQyKgkwCcI=;
 b=cVczbet+NQO5Y803GCM9e/xpl8LIxxRZMxlPQb/AxR4TAq+FiZL83D2RyOM1y3apo1bZh7AMGgSwG7HygwXz+x9iYgUAtpvoM/GMfTKfH+gBW90iBA2hRxpZ7ykWYUAPeZw+aHUyljovzhk0+tuwR+ntW0eBn6a6/paBFwPnftB3wU9GbG9njVGj0hwy358qzIVRVnWrSiSL9bAXLElFitu7/uoaDCRb24JxzrFAbPiygVsqRO7uqmb8g61tSODtYe6ASg3gSMDr7y5nZ2v0Bd5lwmAwkKJw5JImmNkF7m9YkkNa2vq/PrxmyvfxE/wBrRIshWluOcxqWUyaYAoAUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bF7w80voCnsj60rYcOAtvIL8fuE/mOZjhQyKgkwCcI=;
 b=GHiG1pPsD8PB8CBbOlS/al4xRV+0uOvvJYJM54sThHvA8d7/wg23e/g2uUGcibLJY3feKjJ7JfxVcW1ZtTe0+YosEhfj4j2cA7IGJSj/lLhN1+dU0Gyde+XoiL3yqc10TkTNZMDVs8g3loy8att+9jYg1ItdYEOA+vOHiokf8PU=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3269.namprd15.prod.outlook.com (20.179.57.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 19:38:17 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 19:38:17 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 09/10] bpf: disallow bpf_probe_read[_str] helpers
Thread-Topic: [PATCH bpf-next 09/10] bpf: disallow bpf_probe_read[_str]
 helpers
Thread-Index: AQHVezpE4/ANSHC9XU2IKatyZF/eX6dRzn0AgADtO4A=
Date:   Wed, 9 Oct 2019 19:38:17 +0000
Message-ID: <832aa9b3-8c7a-6304-ad09-e825a1c72e3a@fb.com>
References: <20191005050314.1114330-1-ast@kernel.org>
 <20191005050314.1114330-10-ast@kernel.org>
 <CAEf4Bzb2XEp2H26RonyPjvUqXB4qx6sc6KN_i74hu4bhPhhc4w@mail.gmail.com>
In-Reply-To: <CAEf4Bzb2XEp2H26RonyPjvUqXB4qx6sc6KN_i74hu4bhPhhc4w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:102:2::33) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::cfd7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90519183-1295-4d68-1ee7-08d74cf03b4f
x-ms-traffictypediagnostic: BYAPR15MB3269:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3269355401B4193D6C10E341D7950@BYAPR15MB3269.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:79;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(136003)(366004)(346002)(39860400002)(199004)(189003)(31686004)(36756003)(54906003)(110136005)(6246003)(316002)(6116002)(256004)(478600001)(14444005)(5024004)(6436002)(66556008)(4326008)(66476007)(64756008)(25786009)(66946007)(66446008)(6486002)(229853002)(14454004)(8936002)(6512007)(386003)(81156014)(53546011)(7736002)(5660300002)(305945005)(2906002)(476003)(6506007)(71200400001)(102836004)(2616005)(8676002)(71190400001)(186003)(52116002)(486006)(86362001)(76176011)(46003)(81166006)(99286004)(31696002)(446003)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3269;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6eeltJy+Vb+1nec4ubNEDrGQQdY7CwgCgwdplgg0cmyj1xEntD6Q7lxueN/NHLOLCnL9gMaBQ6we8Fi2sNu/Fvpz8YVQT8J7jVJCTn8Pt/F3CEG/RvVtgIwDyemFRvbB4PKr5XFl9m3vsPjmytwUjFPJ2TZhyYtDOUzkcrk9d4KJJHlLrpsrAGxZMiHbWGKABekdbi3R/5jXiY7tvXNmmyutKoW+a1VJCSTYRkpaWFgfwHS8F/VP+MPFIq+SUa6EKuGrKEkyckYKSMaUNemlnC3NaUy95Y5tsKs+RmVJ1FA7H+gaXdY4rAIFMo58utlWgHMFuX+K8JwB3q9PYGNs/F/2yre0xTPIjxxPyFaj4TgcIUB/4VQchf3O3Di+mI/08Gt92j9fjnErq2Q4e0h/32PIW9mYjmeMpP8OqFr3lm4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0246DBA4D018A341918DF745873510DE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 90519183-1295-4d68-1ee7-08d74cf03b4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 19:38:17.0985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wX2xsTuLBzvAD+QOTw3HWOaQ1rNBGOeoSRWexIR3x0R3NnKbMUblGyMXj0IM7mzT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3269
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-09_09:2019-10-08,2019-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 priorityscore=1501 adultscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910090155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvOC8xOSAxMDoyOSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBGcmksIE9j
dCA0LCAyMDE5IGF0IDEwOjA0IFBNIEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+
IHdyb3RlOg0KPj4NCj4+IERpc2FsbG93IGJwZl9wcm9iZV9yZWFkKCkgYW5kIGJwZl9wcm9iZV9y
ZWFkX3N0cigpIGhlbHBlcnMgaW4NCj4+IHJhd190cmFjZXBvaW50IGJwZiBwcm9ncmFtcyB0aGF0
IHVzZSBpbi1rZXJuZWwgQlRGIHRvIHRyYWNrDQo+PiB0eXBlcyBvZiBtZW1vcnkgYWNjZXNzZXMu
DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9y
Zz4NCj4+IC0tLQ0KPj4gICBrZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMgfCA0ICsrKysNCj4+ICAg
MSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9rZXJu
ZWwvdHJhY2UvYnBmX3RyYWNlLmMgYi9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4+IGluZGV4
IDUyZjdlOWQ4YzI5Yi4uN2M2MDdmNzlmMWJiIDEwMDY0NA0KPj4gLS0tIGEva2VybmVsL3RyYWNl
L2JwZl90cmFjZS5jDQo+PiArKysgYi9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4+IEBAIC03
MDAsNiArNzAwLDggQEAgdHJhY2luZ19mdW5jX3Byb3RvKGVudW0gYnBmX2Z1bmNfaWQgZnVuY19p
ZCwgY29uc3Qgc3RydWN0IGJwZl9wcm9nICpwcm9nKQ0KPj4gICAgICAgICAgY2FzZSBCUEZfRlVO
Q19tYXBfcGVla19lbGVtOg0KPj4gICAgICAgICAgICAgICAgICByZXR1cm4gJmJwZl9tYXBfcGVl
a19lbGVtX3Byb3RvOw0KPj4gICAgICAgICAgY2FzZSBCUEZfRlVOQ19wcm9iZV9yZWFkOg0KPj4g
KyAgICAgICAgICAgICAgIGlmIChwcm9nLT5leHBlY3RlZF9hdHRhY2hfdHlwZSkNCj4+ICsgICAg
ICAgICAgICAgICAgICAgICAgIHJldHVybiBOVUxMOw0KPiANCj4gVGhpcyBjYW4gdW5pbnRlbnRp
b25hbGx5IGRpc2FibGUgYnBmX3Byb2JlX3JlYWQvYnBmX3Byb2JlX3JlYWRfc3RyIGZvcg0KPiBu
b24tcmF3X3RwIHByb2dyYW1zIHRoYXQgaGFwcGVuZWQgdG8gc3BlY2lmeSBub24temVybw0KPiBl
eHBlY3RlZF9hdHRhY2hfdHlwZSwgd2hpY2ggd2UgZG9uJ3QgcmVhbGx5IHZhbGlkYXRlIGZvcg0K
PiBrcHJvYmUvdHAvcGVyZl9ldmVudC9ldGMuIFNvIGhvdyBhYm91dCBwYXNzaW5nIHByb2dyYW0g
dHlwZSBpbnRvDQo+IHRyYWNpbmdfZnVuY19wcm90bygpIHNvIHRoYXQgd2UgY2FuIGhhdmUgbW9y
ZSBncmFudWxhciBjb250cm9sPw0KDQp5ZWFoLiB0aGF0IHN1Y2tzIHRoYXQgd2UgZm9yZ290IHRv
IGNoZWNrIGV4cGVjdGVkX2F0dGFjaF90eXBlIGZvciB6ZXJvDQp3aGVuIHRoYXQgZmllbGQgd2Fz
IGludHJvZHVjZWQgZm9yIG5ldHdvcmtpbmcgcHJvZ3MuDQpJJ2xsIGFkZCBuZXcgdTMyIHRvIHBy
b2dfbG9hZCBjb21tYW5kIGluc3RlYWQuIEl0J3MgY2xlYW5lciB0b28uDQo=
