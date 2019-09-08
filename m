Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A57AD107
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 00:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbfIHWUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 18:20:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22562 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726626AbfIHWUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 18:20:14 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x88MI1K2012564;
        Sun, 8 Sep 2019 15:19:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=cxn/Czh3ANQl2HIoYBpVRwWYans+n0vgYjEFWQ3TTpA=;
 b=HFDq7hNnD9ywa+9aCb9yLwyk/p2s0Iyg1sc0nZJ1I9k3jVvsEHLfX5Ugy7ggn2HvGgXa
 J6NLxa+xX4tGxwlvYYkrQuKsbo//I2V4DUOD2wTA1E3vWz7vYGhf7FoV5f/6hGoAdi4g
 nuiZgjQTJ5hmwMJ9mtHFgn8f6OPdPwP1H7g= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uvvv59ygk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 08 Sep 2019 15:19:00 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 8 Sep 2019 15:18:59 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 8 Sep 2019 15:18:59 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 8 Sep 2019 15:18:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOVb+OXuA4IgkILboYeaS2SSy1WOeWynlTi2klo0PrpUwMbfM9fSrXfeopyQAk8OEeqPvtfzyFFF5zmeowxivv3bWsVGrm2kkz2nLlgN/AUnkinW6rldvZvuaLmUviXKGjXFLoqsn/vXUbXgPm6xJF9cFtcLQWp9toVLKdG0/2XQI41mVdxXY/8/GcQShFQHzwdhX4EfDqnUem70igT7GL2igXgUkPKiRD4+bK3ToaUooP+5zb7KETPzBzhmS83/z3ZGe4eJ7HUOgOTyL8Y2r1wJrqAiidM4d72ZJPRqPLq78nq5he2muYa/l0hJ5aA8aAN/eo2Rk8oZb4nwNkFxkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxn/Czh3ANQl2HIoYBpVRwWYans+n0vgYjEFWQ3TTpA=;
 b=HXsaPEUjaG/UQzTYslh158taziLOyr7oz0lChPnSWdnyv6n/C4alGkiRAa+3Cjb8boUFdimuMXWZlx2MXGURQQTW3fX0UMVTiYGt4MBdkjr7kDYyed+ZPLJERQjWGZ62yvLCnquh8ZxPeilyId4RGVlqVvJvuJ0zaMOVJmoDe+n+mzAj81MujMlS+cEFGhEsVQm3ZfNJgOmnqc19y8h7kyDm4hHsCQx9TpMMtu1pM+6GYguMf7sPYwBKboBVp8mVCrVzM/zfsOiuritCzPb3F1DggaxTBBFx514rkLYhxYHxIXmlMqArpg07ijXeVJp2TBQES4OXWMvJNHYwChj0CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxn/Czh3ANQl2HIoYBpVRwWYans+n0vgYjEFWQ3TTpA=;
 b=hN6cg8Gm5LsdHrqRm7om2INj2g/q15I6h+qr2cOJUJQLCkt87zyrvtOH3QVbWLlvoeCn/clxkaTHjVa9/eAtW+yS0bt4Ke/0sMvhwRRxjWMNsq5Wb/NbcakApX/Pf5kodjTxBOUyTYIQdgL5X14x3reLCipqBXpPIFx89FXKYEc=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2583.namprd15.prod.outlook.com (20.179.155.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Sun, 8 Sep 2019 22:18:57 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2241.018; Sun, 8 Sep 2019
 22:18:57 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Alan Maguire <alan.maguire@oracle.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "quentin.monnet@netronome.com" <quentin.monnet@netronome.com>,
        Andrey Ignatov <rdna@fb.com>,
        "joe@wand.net.nz" <joe@wand.net.nz>,
        "acme@redhat.com" <acme@redhat.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "alexey.budankov@linux.intel.com" <alexey.budankov@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "sdf@google.com" <sdf@google.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "peter@lekensteyn.nl" <peter@lekensteyn.nl>,
        "ivan@cloudflare.com" <ivan@cloudflare.com>,
        "Andrii Nakryiko" <andriin@fb.com>,
        "bhole_prashant_q7@lab.ntt.co.jp" <bhole_prashant_q7@lab.ntt.co.jp>,
        "david.calavera@gmail.com" <david.calavera@gmail.com>,
        "danieltimlee@gmail.com" <danieltimlee@gmail.com>,
        Takshak Chahande <ctakshak@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [RFC bpf-next 2/7] bpf: extend bpf_pcap support to tracing
 programs
Thread-Topic: [RFC bpf-next 2/7] bpf: extend bpf_pcap support to tracing
 programs
Thread-Index: AQHVZcUc6/vdinG1MEa+i1XJ6GmfZ6ciWzeA
Date:   Sun, 8 Sep 2019 22:18:57 +0000
Message-ID: <89305ec8-7e03-3cd0-4e39-c3760dd3477b@fb.com>
References: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
 <1567892444-16344-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1567892444-16344-3-git-send-email-alan.maguire@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR06CA0046.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::23) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::5aa4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f7a14b0-00e7-4a4d-7825-08d734aa8a97
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2583;
x-ms-traffictypediagnostic: BYAPR15MB2583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB25832C22FD45BD27661A706DD3B40@BYAPR15MB2583.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0154C61618
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(346002)(396003)(376002)(199004)(189003)(71190400001)(256004)(478600001)(8936002)(6512007)(81166006)(81156014)(52116002)(76176011)(2501003)(53936002)(53546011)(102836004)(6506007)(31696002)(186003)(7416002)(2201001)(86362001)(305945005)(8676002)(99286004)(386003)(7736002)(31686004)(66476007)(66556008)(64756008)(66446008)(66946007)(486006)(2906002)(229853002)(6486002)(6436002)(6116002)(14454004)(6246003)(2616005)(316002)(476003)(11346002)(110136005)(446003)(46003)(25786009)(71200400001)(5660300002)(36756003)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2583;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NUWNUPB4ujIJvxuNqp7W5VADpRd8x9p9SbK6ucQbFpkdaI88nAEc2pI135eXJAzd+aqqgvfIFGHTuo909eSVONzFs7o8sC9M7re7CBCdS3XywRenn+UlfKlEN2kQGHwFSRHX+6zNvqPd79mgX8pK12SjQLLfaHw+7wwDcy0UloxXv3KiaSQdF7edkXPUbWmxUAAQheRLebc4bS9AfcxNlzCk0Ht2cVKCogxjLiMTUoyWzxppUbBxBm4KUdOwqYvJe5wyYP98JNhcYNwPcBNJrM3MKcMS/T7lhqeH1hYEeBasdmzHGhMciTjLnQRw2aqDGldiUU/kimfcTzEdIR4rKaCCNVazdU29xSmNkg8jIeDMh2ZETEpHXuLMtqYFtiaXU8ddP5s3hh8ROKIRcba2+FpfwkLGcsNpsJ9Rqq+TLjc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <626DD3EDA35D1840BC66D4B5FFD571F1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f7a14b0-00e7-4a4d-7825-08d734aa8a97
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2019 22:18:57.4029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f9fUDJ8gbtdhsi+kqqnHA3ERO+l/UwSUzfXFPYcxjGXgSnAzUeDZ5CGGBJxF1f72
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2583
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-08_15:2019-09-08,2019-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 adultscore=0 malwarescore=0 suspectscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909080246
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvNy8xOSAyOjQwIFBNLCBBbGFuIE1hZ3VpcmUgd3JvdGU6DQo+IHBhY2tldCBjYXB0
dXJlIGlzIGVzcGVjaWFsbHkgdmFsdWFibGUgaW4gdHJhY2luZyBjb250ZXh0cywgc28NCj4gZXh0
ZW5kIGJwZl9wY2FwIGhlbHBlciB0byB0YWtlIGEgdHJhY2luZy1kZXJpdmVkIHNrYiBwb2ludGVy
DQo+IGFzIGFuIGFyZ3VtZW50Lg0KPiANCj4gSW4gdGhlIGNhc2Ugb2YgdHJhY2luZyBwcm9ncmFt
cywgdGhlIHN0YXJ0aW5nIHByb3RvY29sDQo+IChjb3JyZXNwb25kaW5nIHRvIGxpYnBjYXAgRExU
XyogdmFsdWVzOyAxIGZvciBFdGhlcm5ldCwgMTIgZm9yDQo+IElQLCBldGMpIG5lZWRzIHRvIGJl
IHNwZWNpZmllZCBhbmQgc2hvdWxkIHJlZmxlY3QgdGhlIHByb3RvY29sDQo+IHR5cGUgd2hpY2gg
aXMgcG9pbnRlZCB0byBieSB0aGUgc2tiLT5kYXRhIHBvaW50ZXI7IGkuZS4gdGhlDQo+IHN0YXJ0
IG9mIHRoZSBwYWNrZXQuICBUaGlzIGNhbiBkZXJpdmVkIGluIGEgbGltaXRlZCBzZXQgb2YgY2Fz
ZXMsDQo+IGJ1dCBzaG91bGQgYmUgc3BlY2lmaWVkIHdoZXJlIHBvc3NpYmxlLiAgRm9yIHNrYiBh
bmQgeGRwIHByb2dyYW1zDQo+IHRoaXMgcHJvdG9jb2wgd2lsbCBuZWFybHkgYWx3YXlzIGJlIDEg
KEJQRl9QQ0FQX1RZUEVfRVRIKS4NCj4gDQo+IEV4YW1wbGUgdXNhZ2UgZm9yIGEgdHJhY2luZyBw
cm9ncmFtLCB3aGVyZSB3ZSB1c2UgYQ0KPiBzdHJ1Y3QgYnBmX3BjYXBfaGRyIGFycmF5IG1hcCB0
byBwYXNzIGluIHByZWZlcmVuY2VzIGZvcg0KPiBwcm90b2NvbCBhbmQgbWF4IGxlbjoNCj4gDQo+
IHN0cnVjdCBicGZfbWFwX2RlZiBTRUMoIm1hcHMiKSBwY2FwX2NvbmZfbWFwID0gew0KPiAJLnR5
cGUgPSBCUEZfTUFQX1RZUEVfQVJSQVksDQo+IAkua2V5X3NpemUgPSBzaXplb2YoaW50KSwNCj4g
CS52YWx1ZV9zaXplID0gc2l6ZW9mKHN0cnVjdCBicGZfcGNhcF9oZHIpLA0KPiAJLm1heF9lbnRy
aWVzID0gMSwNCj4gfTsNCj4gDQo+IHN0cnVjdCBicGZfbWFwX2RlZiBTRUMoIm1hcHMiKSBwY2Fw
X21hcCA9IHsNCj4gCS50eXBlID0gQlBGX01BUF9UWVBFX1BFUkZfRVZFTlRfQVJSQVksDQo+IAku
a2V5X3NpemUgPSBzaXplb2YoaW50KSwNCj4gCS52YWx1ZV9zaXplID0gc2l6ZW9mKGludCksDQo+
IAkubWF4X2VudHJpZXMgPSAxMDI0LA0KPiB9Ow0KPiANCj4gU0VDKCJrcHJvYmUva2ZyZWVfc2ti
IikNCj4gaW50IHByb2JlX2tmcmVlX3NrYihzdHJ1Y3QgcHRfcmVncyAqY3R4KQ0KPiB7DQo+IAlz
dHJ1Y3QgYnBmX3BjYXBfaGRyICpjb25mOw0KPiAJaW50IGtleSA9IDA7DQo+IA0KPiAJY29uZiA9
IGJwZl9tYXBfbG9va3VwX2VsZW0oJnBjYXBfY29uZl9tYXAsICZrZXkpOw0KPiAJaWYgKCFjb25m
KQ0KPiAJCXJldHVybiAwOw0KPiANCj4gCWJwZl9wY2FwKCh2b2lkICopUFRfUkVHU19QQVJNMShj
dHgpLCBjb25mLT5jYXBfbGVuLCAmcGNhcF9tYXAsDQo+IAkJIGNvbmYtPnByb3RvY29sLCBCUEZf
Rl9DVVJSRU5UX0NQVSk7DQo+IAlyZXR1cm4gMDsNCj4gfQ0KPiANCj4gU2lnbmVkLW9mZi1ieTog
QWxhbiBNYWd1aXJlIDxhbGFuLm1hZ3VpcmVAb3JhY2xlLmNvbT4NCj4gLS0tDQpbLi4uXQ0KPiBA
QCAtMjk3Nyw2ICsyOTkyLDggQEAgZW51bSBicGZfZnVuY19pZCB7DQo+ICAgDQo+ICAgLyogQlBG
X0ZVTkNfcGNhcCBmbGFncyAqLw0KPiAgICNkZWZpbmUJQlBGX0ZfUENBUF9JRF9NQVNLCQkweGZm
ZmZmZmZmZmZmZg0KPiArI2RlZmluZSBCUEZfRl9QQ0FQX0lEX0lJRklOREVYCQkoMVVMTCA8PCA0
OCkNCj4gKyNkZWZpbmUgQlBGX0ZfUENBUF9TVFJJQ1RfVFlQRSAgICAgICAgICgxVUxMIDw8IDU2
KQ0KPiAgIA0KPiAgIC8qIE1vZGUgZm9yIEJQRl9GVU5DX3NrYl9hZGp1c3Rfcm9vbSBoZWxwZXIu
ICovDQo+ICAgZW51bSBicGZfYWRqX3Jvb21fbW9kZSB7DQo+IGRpZmYgLS1naXQgYS9rZXJuZWwv
dHJhY2UvYnBmX3RyYWNlLmMgYi9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4gaW5kZXggY2Ex
MjU1ZC4uMzExODgzYiAxMDA2NDQNCj4gLS0tIGEva2VybmVsL3RyYWNlL2JwZl90cmFjZS5jDQo+
ICsrKyBiL2tlcm5lbC90cmFjZS9icGZfdHJhY2UuYw0KPiBAQCAtMTMsNiArMTMsOCBAQA0KPiAg
ICNpbmNsdWRlIDxsaW51eC9rcHJvYmVzLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L3N5c2NhbGxz
Lmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L2Vycm9yLWluamVjdGlvbi5oPg0KPiArI2luY2x1ZGUg
PGxpbnV4L3NrYnVmZi5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L2lwLmg+DQo+ICAgDQo+ICAgI2lu
Y2x1ZGUgPGFzbS90bGIuaD4NCj4gICANCj4gQEAgLTUzMCw2ICs1MzIsMjE2IEBAIHU2NCBicGZf
ZXZlbnRfb3V0cHV0KHN0cnVjdCBicGZfbWFwICptYXAsIHU2NCBmbGFncywgdm9pZCAqbWV0YSwg
dTY0IG1ldGFfc2l6ZSwNCj4gICAJcmV0dXJuIF9fYnBmX3BlcmZfZXZlbnRfb3V0cHV0KHJlZ3Ms
IG1hcCwgZmxhZ3MsIHNkKTsNCj4gICB9DQo+ICAgDQo+ICsvKiBFc3NlbnRpYWxseSBqdXN0IHNr
Yl9jb3B5X2JpdHMoKSB1c2luZyBwcm9iZV9rZXJuZWxfcmVhZCgpIHdoZXJlIG5lZWRlZC4gKi8N
Cj4gK3N0YXRpYyB1bnNpZ25lZCBsb25nIGJwZl90cmFjZV9za2JfY29weSh2b2lkICp0b2J1Ziwg
Y29uc3Qgdm9pZCAqZnJvbSwNCj4gKwkJCQkJdW5zaWduZWQgbG9uZyBvZmZzZXQsDQo+ICsJCQkJ
CXVuc2lnbmVkIGxvbmcgbGVuKQ0KPiArew0KPiArCWNvbnN0IHN0cnVjdCBza19idWZmICpmcmFn
X2l0ZXJwLCAqc2tiID0gZnJvbTsNCj4gKwlzdHJ1Y3Qgc2tiX3NoYXJlZF9pbmZvICpzaGluZm9w
LCBzaGluZm87DQo+ICsJc3RydWN0IHNrX2J1ZmYgZnJhZ19pdGVyOw0KPiArCXVuc2lnbmVkIGxv
bmcgY29weSwgc3RhcnQ7DQo+ICsJdm9pZCAqdG8gPSB0b2J1ZjsNCj4gKwlpbnQgaSwgcmV0Ow0K
PiArDQo+ICsJc3RhcnQgPSBza2JfaGVhZGxlbihza2IpOw0KPiArDQo+ICsJY29weSA9IHN0YXJ0
IC0gb2Zmc2V0Ow0KPiArCWlmIChjb3B5ID4gMCkgew0KPiArCQlpZiAoY29weSA+IGxlbikNCj4g
KwkJCWNvcHkgPSBsZW47DQo+ICsJCXJldCA9IHByb2JlX2tlcm5lbF9yZWFkKHRvLCBza2ItPmRh
dGEsIGNvcHkpOw0KPiArCQlpZiAodW5saWtlbHkocmV0IDwgMCkpDQo+ICsJCQlnb3RvIG91dDsN
Cj4gKwkJbGVuIC09IGNvcHk7DQo+ICsJCWlmIChsZW4gPT0gMCkNCj4gKwkJCXJldHVybiAwOw0K
PiArCQlvZmZzZXQgKz0gY29weTsNCj4gKwkJdG8gKz0gY29weTsNCj4gKwl9DQo+ICsNCj4gKwlp
ZiAoc2tiLT5kYXRhX2xlbiA9PSAwKQ0KPiArCQlnb3RvIG91dDsNCj4gKw0KPiArCXNoaW5mb3Ag
PSBza2Jfc2hpbmZvKHNrYik7DQo+ICsNCj4gKwlyZXQgPSBwcm9iZV9rZXJuZWxfcmVhZCgmc2hp
bmZvLCBzaGluZm9wLCBzaXplb2Yoc2hpbmZvKSk7DQo+ICsJaWYgKHVubGlrZWx5KHJldCA8IDAp
KQ0KPiArCQlnb3RvIG91dDsNCj4gKw0KPiArCWlmIChzaGluZm8ubnJfZnJhZ3MgPiBNQVhfU0tC
X0ZSQUdTKSB7DQo+ICsJCXJldCA9IC1FSU5WQUw7DQo+ICsJCWdvdG8gb3V0Ow0KPiArCX0NCj4g
Kwlmb3IgKGkgPSAwOyBpIDwgc2hpbmZvLm5yX2ZyYWdzOyBpKyspIHsNCj4gKwkJc2tiX2ZyYWdf
dCAqZiA9ICZzaGluZm8uZnJhZ3NbaV07DQo+ICsJCWludCBlbmQ7DQo+ICsNCj4gKwkJaWYgKHN0
YXJ0ID4gb2Zmc2V0ICsgbGVuKSB7DQo+ICsJCQlyZXQgPSAtRTJCSUc7DQo+ICsJCQlnb3RvIG91
dDsNCj4gKwkJfQ0KPiArDQo+ICsJCWVuZCA9IHN0YXJ0ICsgc2tiX2ZyYWdfc2l6ZShmKTsNCj4g
KwkJY29weSA9IGVuZCAtIG9mZnNldDsNCj4gKwkJaWYgKGNvcHkgPiAwKSB7DQo+ICsJCQl1MzIg
cG9mZiwgcF9sZW4sIGNvcGllZDsNCj4gKwkJCXN0cnVjdCBwYWdlICpwOw0KPiArCQkJdTggKnZh
ZGRyOw0KPiArDQo+ICsJCQlpZiAoY29weSA+IGxlbikNCj4gKwkJCQljb3B5ID0gbGVuOw0KPiAr
DQo+ICsJCQlza2JfZnJhZ19mb3JlYWNoX3BhZ2UoZiwNCj4gKwkJCQkJICAgICAgc2tiX2ZyYWdf
b2ZmKGYpICsgb2Zmc2V0IC0gc3RhcnQsDQo+ICsJCQkJCSAgICAgIGNvcHksIHAsIHBvZmYsIHBf
bGVuLCBjb3BpZWQpIHsNCj4gKw0KPiArCQkJCXZhZGRyID0ga21hcF9hdG9taWMocCk7DQo+ICsJ
CQkJcmV0ID0gcHJvYmVfa2VybmVsX3JlYWQodG8gKyBjb3BpZWQsDQo+ICsJCQkJCQkJdmFkZHIg
KyBwb2ZmLCBwX2xlbik7DQo+ICsJCQkJa3VubWFwX2F0b21pYyh2YWRkcik7DQo+ICsNCj4gKwkJ
CQlpZiAodW5saWtlbHkocmV0IDwgMCkpDQo+ICsJCQkJCWdvdG8gb3V0Ow0KPiArCQkJfQ0KPiAr
CQkJbGVuIC09IGNvcHk7DQo+ICsJCQlpZiAobGVuID09IDApDQo+ICsJCQkJcmV0dXJuIDA7DQo+
ICsJCQlvZmZzZXQgKz0gY29weTsNCj4gKwkJCXRvICs9IGNvcHk7DQo+ICsJCX0NCj4gKwkJc3Rh
cnQgPSBlbmQ7DQo+ICsJfQ0KPiArDQo+ICsJZm9yIChmcmFnX2l0ZXJwID0gc2hpbmZvLmZyYWdf
bGlzdDsgZnJhZ19pdGVycDsNCj4gKwkgICAgIGZyYWdfaXRlcnAgPSBmcmFnX2l0ZXIubmV4dCkg
ew0KPiArCQlpbnQgZW5kOw0KPiArDQo+ICsJCWlmIChzdGFydCA+IG9mZnNldCArIGxlbikgew0K
PiArCQkJcmV0ID0gLUUyQklHOw0KPiArCQkJZ290byBvdXQ7DQo+ICsJCX0NCj4gKwkJcmV0ID0g
cHJvYmVfa2VybmVsX3JlYWQoJmZyYWdfaXRlciwgZnJhZ19pdGVycCwNCj4gKwkJCQkJc2l6ZW9m
KGZyYWdfaXRlcikpOw0KPiArCQlpZiAocmV0KQ0KPiArCQkJZ290byBvdXQ7DQo+ICsNCj4gKwkJ
ZW5kID0gc3RhcnQgKyBmcmFnX2l0ZXIubGVuOw0KPiArCQljb3B5ID0gZW5kIC0gb2Zmc2V0Ow0K
PiArCQlpZiAoY29weSA+IDApIHsNCj4gKwkJCWlmIChjb3B5ID4gbGVuKQ0KPiArCQkJCWNvcHkg
PSBsZW47DQo+ICsJCQlyZXQgPSBicGZfdHJhY2Vfc2tiX2NvcHkodG8sICZmcmFnX2l0ZXIsDQo+
ICsJCQkJCQlvZmZzZXQgLSBzdGFydCwNCj4gKwkJCQkJCWNvcHkpOw0KPiArCQkJaWYgKHJldCkN
Cj4gKwkJCQlnb3RvIG91dDsNCj4gKw0KPiArCQkJbGVuIC09IGNvcHk7DQo+ICsJCQlpZiAobGVu
ID09IDApDQo+ICsJCQkJcmV0dXJuIDA7DQo+ICsJCQlvZmZzZXQgKz0gY29weTsNCj4gKwkJCXRv
ICs9IGNvcHk7DQo+ICsJCX0NCj4gKwkJc3RhcnQgPSBlbmQ7DQo+ICsJfQ0KPiArb3V0Og0KPiAr
CWlmIChyZXQpDQo+ICsJCW1lbXNldCh0b2J1ZiwgMCwgbGVuKTsNCj4gKw0KPiArCXJldHVybiBy
ZXQ7DQo+ICt9DQoNCkZvciBuZXQgc2lkZSBicGZfcGVyZl9ldmVudF9vdXRwdXQsIHdlIGhhdmUN
CnN0YXRpYyB1bnNpZ25lZCBsb25nIGJwZl9za2JfY29weSh2b2lkICpkc3RfYnVmZiwgY29uc3Qg
dm9pZCAqc2tiLA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBs
b25nIG9mZiwgdW5zaWduZWQgbG9uZyBsZW4pDQp7DQogICAgICAgICB2b2lkICpwdHIgPSBza2Jf
aGVhZGVyX3BvaW50ZXIoc2tiLCBvZmYsIGxlbiwgZHN0X2J1ZmYpOw0KDQogICAgICAgICBpZiAo
dW5saWtlbHkoIXB0cikpDQogICAgICAgICAgICAgICAgIHJldHVybiBsZW47DQogICAgICAgICBp
ZiAocHRyICE9IGRzdF9idWZmKQ0KICAgICAgICAgICAgICAgICBtZW1jcHkoZHN0X2J1ZmYsIHB0
ciwgbGVuKTsNCg0KICAgICAgICAgcmV0dXJuIDA7DQp9DQoNCkJQRl9DQUxMXzUoYnBmX3NrYl9l
dmVudF9vdXRwdXQsIHN0cnVjdCBza19idWZmICosIHNrYiwgc3RydWN0IGJwZl9tYXAgDQoqLCBt
YXAsDQogICAgICAgICAgICB1NjQsIGZsYWdzLCB2b2lkICosIG1ldGEsIHU2NCwgbWV0YV9zaXpl
KQ0Kew0KICAgICAgICAgdTY0IHNrYl9zaXplID0gKGZsYWdzICYgQlBGX0ZfQ1RYTEVOX01BU0sp
ID4+IDMyOw0KDQogICAgICAgICBpZiAodW5saWtlbHkoZmxhZ3MgJiB+KEJQRl9GX0NUWExFTl9N
QVNLIHwgQlBGX0ZfSU5ERVhfTUFTSykpKQ0KICAgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZB
TDsNCiAgICAgICAgIGlmICh1bmxpa2VseShza2Jfc2l6ZSA+IHNrYi0+bGVuKSkNCiAgICAgICAg
ICAgICAgICAgcmV0dXJuIC1FRkFVTFQ7DQoNCiAgICAgICAgIHJldHVybiBicGZfZXZlbnRfb3V0
cHV0KG1hcCwgZmxhZ3MsIG1ldGEsIG1ldGFfc2l6ZSwgc2tiLCBza2Jfc2l6ZSwNCiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGJwZl9za2JfY29weSk7DQp9DQoNCkl0IGRvZXMgbm90
IHJlYWxseSBjb25zaWRlciBvdXRwdXQgYWxsIHRoZSBmcmFncy4NCkkgdW5kZXJzdGFuZCB0aGF0
IHRvIGdldCB0cnVseSBhbGwgcGFja2V0IGRhdGEsIGZyYWdzIHNob3VsZCBiZQ0KY29uc2lkZXJl
ZCwgYnV0IHNlZW1zIHdlIGRpZCBub3QgZG8gaXQgYmVmb3JlPyBJIGFtIHdvbmRlcmluZw0Kd2hl
dGhlciB3ZSBuZWVkIHRvIGRvIGhlcmUuDQoNCklmIHdlIGluZGVlZCBkbyBub3QgbmVlZCB0byBo
YW5kbGUgZnJhZ3MgaGVyZSwgSSB0aGluayBtYXliZQ0KYnBmX3Byb2JlX3JlYWQoKSBpbiBleGlz
dGluZyBicGYga3Byb2JlIGZ1bmN0aW9uIHNob3VsZCBiZQ0KZW5vdWdoLCB3ZSBkbyBub3QgbmVl
ZCB0aGlzIGhlbHBlcj8NCg0KPiArDQo+ICsvKiBEZXJpdmUgcHJvdG9jb2wgZm9yIHNvbWUgb2Yg
dGhlIGVhc2llciBjYXNlcy4gIEZvciB0cmFjaW5nLCBhIHByb2JlIHBvaW50DQo+ICsgKiBtYXkg
YmUgZGVhbGluZyB3aXRoIHBhY2tldHMgaW4gdmFyaW91cyBzdGF0ZXMuIENvbW1vbiBjYXNlcyBh
cmUgSVANCj4gKyAqIHBhY2tldHMgcHJpb3IgdG8gYWRkaW5nIE1BQyBoZWFkZXIgKF9QQ0FQX1RZ
UEVfSVApIGFuZCBhIGZ1bGwgcGFja2V0DQo+ICsgKiAoX1BDQVBfVFlQRV9FVEgpLiAgRm9yIG90
aGVyIGNhc2VzIHRoZSBjYWxsZXIgbXVzdCBzcGVjaWZ5IHRoZQ0KPiArICogcHJvdG9jb2wgdGhl
eSBleHBlY3QuICBPdGhlciBoZXVyaXN0aWNzIGZvciBwYWNrZXQgaWRlbnRpZmljYXRpb24NCj4g
KyAqIHNob3VsZCBiZSBhZGRlZCBoZXJlIGFzIG5lZWRlZCwgc2luY2UgZGV0ZXJtaW5pbmcgdGhl
IHBhY2tldCB0eXBlDQo+ICsgKiBlbnN1cmVzIHdlIGRvIG5vdCBjYXB0dXJlIHBhY2tldHMgdGhh
dCBmYWlsIHRvIG1hdGNoIHRoZSBkZXNpcmVkDQo+ICsgKiBwY2FwIHR5cGUgaW4gQlBGX0ZfUENB
UF9TVFJJQ1RfVFlQRSBtb2RlLg0KPiArICovDQo+ICtzdGF0aWMgaW5saW5lIGludCBicGZfc2ti
X3Byb3RvY29sX2dldChzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPiArew0KPiArCXN3aXRjaCAoaHRv
bnMoc2tiLT5wcm90b2NvbCkpIHsNCj4gKwljYXNlIEVUSF9QX0lQOg0KPiArCWNhc2UgRVRIX1Bf
SVBWNjoNCj4gKwkJaWYgKHNrYl9uZXR3b3JrX2hlYWRlcihza2IpID09IHNrYi0+ZGF0YSkNCj4g
KwkJCXJldHVybiBCUEZfUENBUF9UWVBFX0lQOw0KPiArCQllbHNlDQo+ICsJCQlyZXR1cm4gQlBG
X1BDQVBfVFlQRV9FVEg7DQo+ICsJZGVmYXVsdDoNCj4gKwkJcmV0dXJuIEJQRl9QQ0FQX1RZUEVf
VU5TRVQ7DQo+ICsJfQ0KPiArfQ0KPiArDQo+ICtCUEZfQ0FMTF81KGJwZl90cmFjZV9wY2FwLCB2
b2lkICosIGRhdGEsIHUzMiwgc2l6ZSwgc3RydWN0IGJwZl9tYXAgKiwgbWFwLA0KPiArCSAgIGlu
dCwgcHJvdG9jb2xfd2FudGVkLCB1NjQsIGZsYWdzKQ0KDQpVcCB0byBub3csIGZvciBoZWxwZXJz
LCB2ZXJpZmllciBoYXMgYSB3YXkgdG8gdmVyaWZpZXIgaXQgaXMgdXNlZCANCnByb3Blcmx5IHJl
Z2FyZGluZyB0byB0aGUgY29udGV4dC4gRm9yIGV4YW1wbGUsIGZvciB4ZHAgdmVyc2lvbg0KcGVy
Zl9ldmVudF9vdXRwdXQsIHRoZSBoZWxwIHByb3RvdHlwZSwNCiAgIEJQRl9DQUxMXzUoYnBmX3hk
cF9ldmVudF9vdXRwdXQsIHN0cnVjdCB4ZHBfYnVmZiAqLCB4ZHAsIHN0cnVjdCANCmJwZl9tYXAg
KiwgbWFwLA0KICAgICAgICAgICAgdTY0LCBmbGFncywgdm9pZCAqLCBtZXRhLCB1NjQsIG1ldGFf
c2l6ZSkNCnRoZSB2ZXJpZmllciBpcyBhYmxlIHRvIGd1YXJhbnRlZSB0aGF0IHRoZSBmaXJzdCBw
YXJhbWV0ZXINCmhhcyBjb3JyZWN0IHR5cGUgeGRwX2J1ZmYsIG5vdCBzb21ldGhpbmcgZnJvbSB0
eXBlIGNhc3QuDQogICAuYXJnMV90eXBlICAgICAgPSBBUkdfUFRSX1RPX0NUWCwNCg0KVGhpcyBo
ZWxwZXIsIGluIHRoZSBiZWxvdyB3ZSBoYXZlDQogICAuYXJnMV90eXBlCT0gQVJHX0FOWVRISU5H
LA0KDQpTbyBpdCBpcyBub3QgcmVhbGx5IGVuZm9yY2VkLiBCcmluZ2luZyBCVEYgY2FuIGhlbHAs
IGJ1dCB0eXBlDQpuYW1lIG1hdGNoaW5nIHR5cGljYWxseSBiYWQuDQoNCg0KPiArew0KPiArCXN0
cnVjdCBicGZfcGNhcF9oZHIgcGNhcDsNCj4gKwlzdHJ1Y3Qgc2tfYnVmZiBza2I7DQo+ICsJaW50
IHByb3RvY29sOw0KPiArCWludCByZXQ7DQo+ICsNCj4gKwlpZiAodW5saWtlbHkoZmxhZ3MgJiB+
KEJQRl9GX1BDQVBfSURfSUlGSU5ERVggfCBCUEZfRl9QQ0FQX0lEX01BU0sgfA0KPiArCQkJICAg
ICAgIEJQRl9GX1BDQVBfU1RSSUNUX1RZUEUpKSkNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ICsN
Cj4gKwlyZXQgPSBwcm9iZV9rZXJuZWxfcmVhZCgmc2tiLCBkYXRhLCBzaXplb2Yoc2tiKSk7DQo+
ICsJaWYgKHVubGlrZWx5KHJldCA8IDApKQ0KPiArCQlyZXR1cm4gcmV0Ow0KPiArDQo+ICsJLyog
U2FuaXR5IGNoZWNrIHNrYiBsZW4gaW4gY2FzZSB3ZSBnZXQgYm9ndXMgZGF0YS4gKi8NCj4gKwlp
ZiAodW5saWtlbHkoIXNrYi5sZW4pKQ0KPiArCQlyZXR1cm4gLUVOT0VOVDsNCj4gKwlpZiAodW5s
aWtlbHkoc2tiLmxlbiA+IEdTT19NQVhfU0laRSB8fCBza2IuZGF0YV9sZW4gPiBza2IubGVuKSkN
Cj4gKwkJcmV0dXJuIC1FMkJJRzsNCj4gKw0KPiArCXByb3RvY29sID0gYnBmX3NrYl9wcm90b2Nv
bF9nZXQoJnNrYik7DQo+ICsNCj4gKwlpZiAocHJvdG9jb2xfd2FudGVkID09IEJQRl9QQ0FQX1RZ
UEVfVU5TRVQpIHsNCj4gKwkJLyogSWYgd2UgY2Fubm90IGRldGVybWluZSBwcm90b2NvbCB0eXBl
LCBiYWlsLiAqLw0KPiArCQlpZiAocHJvdG9jb2wgPT0gQlBGX1BDQVBfVFlQRV9VTlNFVCkNCj4g
KwkJCXJldHVybiAtRVBST1RPOw0KPiArCX0gZWxzZSB7DQo+ICsJCS8qIGlmIHdlIGRldGVybWlu
ZSBwcm90b2NvbCB0eXBlLCBhbmQgaXQncyBub3Qgd2hhdCB3ZSBhc2tlZA0KPiArCQkgKiBmb3Ig
X2FuZF8gd2UgYXJlIGluIHN0cmljdCBtb2RlLCBiYWlsLiAgT3RoZXJ3aXNlIHdlIGFzc3VtZQ0K
PiArCQkgKiB0aGUgcGFja2V0IGlzIHRoZSByZXF1ZXN0ZWQgcHJvdG9jb2wgdHlwZSBhbmQgZHJp
dmUgb24uDQo+ICsJCSAqLw0KPiArCQlpZiAoZmxhZ3MgJiBCUEZfRl9QQ0FQX1NUUklDVF9UWVBF
ICYmDQo+ICsJCSAgICBwcm90b2NvbCAhPSBCUEZfUENBUF9UWVBFX1VOU0VUICYmDQo+ICsJCSAg
ICBwcm90b2NvbCAhPSBwcm90b2NvbF93YW50ZWQpDQo+ICsJCQlyZXR1cm4gLUVQUk9UTzsNCj4g
KwkJcHJvdG9jb2wgPSBwcm90b2NvbF93YW50ZWQ7DQo+ICsJfQ0KPiArDQo+ICsJLyogSWYgd2Ug
c3BlY2lmaWVkIGEgbWF0Y2hpbmcgaW5jb21pbmcgaWZpbmRleCwgYmFpbCBpZiBub3QgYSBtYXRj
aC4gKi8NCj4gKwlpZiAoZmxhZ3MgJiBCUEZfRl9QQ0FQX0lEX0lJRklOREVYKSB7DQo+ICsJCWlu
dCBpaWYgPSBmbGFncyAmIEJQRl9GX1BDQVBfSURfTUFTSzsNCj4gKw0KPiArCQlpZiAoaWlmICYm
IHNrYi5za2JfaWlmICE9IGlpZikNCj4gKwkJCXJldHVybiAtRU5PRU5UOw0KPiArCX0NCj4gKw0K
PiArCXJldCA9IGJwZl9wY2FwX3ByZXBhcmUocHJvdG9jb2wsIHNpemUsIHNrYi5sZW4sIGZsYWdz
LCAmcGNhcCk7DQo+ICsJaWYgKHJldCkNCj4gKwkJcmV0dXJuIHJldDsNCj4gKw0KPiArCXJldHVy
biBicGZfZXZlbnRfb3V0cHV0KG1hcCwgQlBGX0ZfQ1VSUkVOVF9DUFUsICZwY2FwLCBzaXplb2Yo
cGNhcCksDQo+ICsJCQkJJnNrYiwgcGNhcC5jYXBfbGVuLCBicGZfdHJhY2Vfc2tiX2NvcHkpOw0K
PiArfQ0KPiArDQo+ICtzdGF0aWMgY29uc3Qgc3RydWN0IGJwZl9mdW5jX3Byb3RvIGJwZl90cmFj
ZV9wY2FwX3Byb3RvID0gew0KPiArCS5mdW5jCQk9IGJwZl90cmFjZV9wY2FwLA0KPiArCS5ncGxf
b25seQk9IHRydWUsDQo+ICsJLnJldF90eXBlCT0gUkVUX0lOVEVHRVIsDQo+ICsJLmFyZzFfdHlw
ZQk9IEFSR19BTllUSElORywNCj4gKwkuYXJnMl90eXBlCT0gQVJHX0FOWVRISU5HLA0KPiArCS5h
cmczX3R5cGUJPSBBUkdfQ09OU1RfTUFQX1BUUiwNCj4gKwkuYXJnNF90eXBlCT0gQVJHX0FOWVRI
SU5HLA0KPiArCS5hcmc1X3R5cGUJPSBBUkdfQU5ZVEhJTkcsDQo+ICt9Ow0KPiArDQo+ICAgQlBG
X0NBTExfMChicGZfZ2V0X2N1cnJlbnRfdGFzaykNCj4gICB7DQo+ICAgCXJldHVybiAobG9uZykg
Y3VycmVudDsNCj4gQEAgLTcwOSw2ICs5MjEsOCBAQCBzdGF0aWMgdm9pZCBkb19icGZfc2VuZF9z
aWduYWwoc3RydWN0IGlycV93b3JrICplbnRyeSkNCj4gICAjZW5kaWYNCj4gICAJY2FzZSBCUEZf
RlVOQ19zZW5kX3NpZ25hbDoNCj4gICAJCXJldHVybiAmYnBmX3NlbmRfc2lnbmFsX3Byb3RvOw0K
PiArCWNhc2UgQlBGX0ZVTkNfcGNhcDoNCj4gKwkJcmV0dXJuICZicGZfdHJhY2VfcGNhcF9wcm90
bzsNCj4gICAJZGVmYXVsdDoNCj4gICAJCXJldHVybiBOVUxMOw0KPiAgIAl9DQo+IA0K
