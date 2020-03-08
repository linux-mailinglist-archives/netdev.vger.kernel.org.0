Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31DBD17D15A
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 04:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgCHD5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 22:57:46 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49860 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726252AbgCHD5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 22:57:46 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0283tG4F026879;
        Sat, 7 Mar 2020 19:57:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=QqX6DBmhSYAp+Ek6zwjJxp8jOQpdgd0MftEbnabeMYM=;
 b=JsaUY8b31R5i0N1Y+geKkqlDDi1bdwiHrO1ZP0DG5QsF9ihK603GNXzn0QYenhtpgNER
 fnMwiUcg9nFj36XBmBtlQ1hCsPgXllKQ/4q9w7KDh8a0/tT2hgyMhBJs2kZs5wGqYRMb
 G7ydK0MoANebQsd3fUpFM9jpw5PiZ3pV8iP7V3IKiOgb4AW8bj1IJPafG6Uyh1EX2tFm
 gZ0xgn6eNVk1/l7wNAaflT2QSdVGixbjM3KQJ7cEX3up6XxDiuXLpiAB5gKc/XETxyWu
 HMBaXNYR/66hWyRJAY4Xu07OsfEJcwvVoYAIGyv2zO/x+ExDvgL7h3ll37hxdNizoW6D HQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ymc0sj27q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 19:57:17 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 19:57:15 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 19:57:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZYAQbMFcqkdvnAxzMJyDTRbLYPvaa72/eIK02veLLWl7UMB7tQqgnYdJKr06H3PvS7HjXZBm4nA8p1BW8/RFAJoBRSRPkYsDihmnlNpIdv4ThGrTRl5YuFCJEP7KFlI85r41twqq7Zrq6nfWrv7sJ6Gsi8/BDcqv3XDSx9He0YAXGHjhDRMMOrgeYBSlUzgLGKy4g6kiF1DKzkBiIVFnkNCbL0ZTNT6BytIYbQxC44Ftx/k7Qc+a8iaPdg8mHF2dqNscAryeysBWxKrHEOPp6LoBfB5l3obu14gJeuW6YubXkgboFaOzRaOcujbafvODl4iaydnSdEgeJPxET2uRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqX6DBmhSYAp+Ek6zwjJxp8jOQpdgd0MftEbnabeMYM=;
 b=k+l5HzOcjsTf+3KXJNqUu7LTXUyrvsbQyVf/uVgFhNO+zt1331p9Z8X18MZDPafnOHMdCd4YLgjAqMcOfcquG14+3qA279U3cxIEaE60gboAXc6v7oVFhuBkZzbyWR+PTArrl+etg5TWAh8CY5tkDX3lgeT3ZbU6xsDobc421aWy54SUjgXQTsLK35aGY6Lacfozf2pjJN0J23yIkmtqEH1yUn0m795xMVYzHOqWen6//P5AtcC3wTZb+l0gZCUNh2som4ug4giyZuIxy/00Vyvu5seelYxTOv4Vya1e4z8WZe7LSeJhN+t0LugTCwGThtxlGPC+7yiNX9FeCkZZog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqX6DBmhSYAp+Ek6zwjJxp8jOQpdgd0MftEbnabeMYM=;
 b=N2SARFl4R5vCYvZD/rUsNXxrB2Vw55V8v49/1z1KTIAxjyXcfQnGDopJPWfgXGdIyNp41fmFvPPsO/11n+yzSQ5Vy9kWqlJB5t//CU+Ca77ucU/PYfAg8x3NoB/MrL1U396xc8b1oeQfNjQ6K9oOIDfL8HNIIctQbcWcW507SfQ=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2661.namprd18.prod.outlook.com (2603:10b6:a03:136::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Sun, 8 Mar
 2020 03:57:14 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 03:57:14 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>
Subject: [PATCH v2 12/12] task_isolation: CONFIG_TASK_ISOLATION prevents
 distribution of jobs to non-housekeeping CPUs
Thread-Topic: [PATCH v2 12/12] task_isolation: CONFIG_TASK_ISOLATION prevents
 distribution of jobs to non-housekeeping CPUs
Thread-Index: AQHV9P2m7r4Cq5RXm0W7iV9iTkwGPQ==
Date:   Sun, 8 Mar 2020 03:57:13 +0000
Message-ID: <c8aad5686cbea676831a9f38634820bc5f2ffb76.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
In-Reply-To: <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c65de317-9996-4ed4-0e16-08d7c314c94b
x-ms-traffictypediagnostic: BYAPR18MB2661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2661980B5CEA924B1565A7F0BCE10@BYAPR18MB2661.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(39850400004)(346002)(376002)(189003)(199004)(36756003)(71200400001)(4326008)(86362001)(2906002)(54906003)(110136005)(316002)(2616005)(8936002)(81156014)(8676002)(81166006)(26005)(186003)(66446008)(66476007)(64756008)(66556008)(66946007)(5660300002)(76116006)(478600001)(7416002)(91956017)(6486002)(6512007)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2661;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tRZx4B7zRm9z98p2OXHivqF9ZInmk414dMbNffTE/DXcuyUkQTkw+gK1zbwd0xNupoU+3q3h7wu4tL0uXszyJinoa4AdEHYhQleNyrF+ZxYowTMIrPNE0Z7+CDGvxrXeoCtylaJNTjUpKPVjIWKYWPJYYrTunJILbZNA7eZz+iyoIg2hWrxKMixxLqyR7ICImkiu4Rqol20ZimxK0/nZnyg1n15GXX3N95Xp5qdQ+c2uWRj1NQVJud37Tq2tLSgV8Z6/7+2QgFl/cVG6KxeQQJIJW7a5QI7a5gFdaKnYFuAgoFf0cXj3ratu6hGWhLyXed1vjVQQ/J9lotQBvf5EmgTimqbkY0SsM6ykjzVvcUm4Rik7Tdf5gr9ZQ5ItMquKhQ4cEyozdCR50A7tJKCogavCShDVddIOT9WHOdj6p4kO1lcevfeaWxwvcisMYJva
x-ms-exchange-antispam-messagedata: cIHdX12WV4njsZ177EM5HXuuJ5nDEYUQBQJdZBEla0Kv82ZEYekqnUJXBG1Sp7YOi0D+YTsWHoZspCAorhGeLw/jJw1+zmyrtPGf5aA/9DpmKqcoGJ9taXzYd+6oSNss3mYjTlABk0un38L02iTquQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F7A0CBA8D79BD4490A8227E3C795C60@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c65de317-9996-4ed4-0e16-08d7c314c94b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 03:57:13.8426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tX4HOFXBeJWiRn+m0XzX1SFEyk+4E3R+pri5OJCT3S+BlObkx+2obpb06WVw7z6VixS6PYWTLAAXSzLzSwE+zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2661
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-07_09:2020-03-06,2020-03-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlcmUgYXJlIHZhcmlvdXMgbWVjaGFuaXNtcyB0aGF0IHNlbGVjdCBDUFVzIGZvciBqb2JzIG90
aGVyIHRoYW4NCnJlZ3VsYXIgd29ya3F1ZXVlIHNlbGVjdGlvbi4gQ1BVIGlzb2xhdGlvbiBub3Jt
YWxseSBkb2VzIG5vdA0KcHJldmVudCB0aG9zZSBqb2JzIGZyb20gcnVubmluZyBvbiBpc29sYXRl
ZCBDUFVzLiBXaGVuIHRhc2sNCmlzb2xhdGlvbiBpcyBlbmFibGVkIHRob3NlIGpvYnMgc2hvdWxk
IGJlIGxpbWl0ZWQgdG8gaG91c2VrZWVwaW5nDQpDUFVzLg0KDQpTaWduZWQtb2ZmLWJ5OiBBbGV4
IEJlbGl0cyA8YWJlbGl0c0BtYXJ2ZWxsLmNvbT4NCi0tLQ0KIGRyaXZlcnMvcGNpL3BjaS1kcml2
ZXIuYyB8ICA5ICsrKysrKysNCiBsaWIvY3B1bWFzay5jICAgICAgICAgICAgfCA1MyArKysrKysr
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tDQogbmV0L2NvcmUvbmV0LXN5c2ZzLmMg
ICAgIHwgIDkgKysrKysrKw0KIDMgZmlsZXMgY2hhbmdlZCwgNTEgaW5zZXJ0aW9ucygrKSwgMjAg
ZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3BjaS9wY2ktZHJpdmVyLmMgYi9k
cml2ZXJzL3BjaS9wY2ktZHJpdmVyLmMNCmluZGV4IDA0NTRjYTBlNGUzZi4uY2I4NzJjZGQxNzgy
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9wY2kvcGNpLWRyaXZlci5jDQorKysgYi9kcml2ZXJzL3Bj
aS9wY2ktZHJpdmVyLmMNCkBAIC0xMiw2ICsxMiw3IEBADQogI2luY2x1ZGUgPGxpbnV4L3N0cmlu
Zy5oPg0KICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+DQogI2luY2x1ZGUgPGxpbnV4L3NjaGVkLmg+
DQorI2luY2x1ZGUgPGxpbnV4L3NjaGVkL2lzb2xhdGlvbi5oPg0KICNpbmNsdWRlIDxsaW51eC9j
cHUuaD4NCiAjaW5jbHVkZSA8bGludXgvcG1fcnVudGltZS5oPg0KICNpbmNsdWRlIDxsaW51eC9z
dXNwZW5kLmg+DQpAQCAtMzMyLDYgKzMzMyw5IEBAIHN0YXRpYyBib29sIHBjaV9waHlzZm5faXNf
cHJvYmVkKHN0cnVjdCBwY2lfZGV2ICpkZXYpDQogc3RhdGljIGludCBwY2lfY2FsbF9wcm9iZShz
dHJ1Y3QgcGNpX2RyaXZlciAqZHJ2LCBzdHJ1Y3QgcGNpX2RldiAqZGV2LA0KIAkJCSAgY29uc3Qg
c3RydWN0IHBjaV9kZXZpY2VfaWQgKmlkKQ0KIHsNCisjaWZkZWYgQ09ORklHX1RBU0tfSVNPTEFU
SU9ODQorCWludCBoa19mbGFncyA9IEhLX0ZMQUdfRE9NQUlOIHwgSEtfRkxBR19XUTsNCisjZW5k
aWYNCiAJaW50IGVycm9yLCBub2RlLCBjcHU7DQogCXN0cnVjdCBkcnZfZGV2X2FuZF9pZCBkZGkg
PSB7IGRydiwgZGV2LCBpZCB9Ow0KIA0KQEAgLTM1Myw3ICszNTcsMTIgQEAgc3RhdGljIGludCBw
Y2lfY2FsbF9wcm9iZShzdHJ1Y3QgcGNpX2RyaXZlciAqZHJ2LCBzdHJ1Y3QgcGNpX2RldiAqZGV2
LA0KIAkgICAgcGNpX3BoeXNmbl9pc19wcm9iZWQoZGV2KSkNCiAJCWNwdSA9IG5yX2NwdV9pZHM7
DQogCWVsc2UNCisjaWZkZWYgQ09ORklHX1RBU0tfSVNPTEFUSU9ODQorCQljcHUgPSBjcHVtYXNr
X2FueV9hbmQoY3B1bWFza19vZl9ub2RlKG5vZGUpLA0KKwkJCQkgICAgICBob3VzZWtlZXBpbmdf
Y3B1bWFzayhoa19mbGFncykpOw0KKyNlbHNlDQogCQljcHUgPSBjcHVtYXNrX2FueV9hbmQoY3B1
bWFza19vZl9ub2RlKG5vZGUpLCBjcHVfb25saW5lX21hc2spOw0KKyNlbmRpZg0KIA0KIAlpZiAo
Y3B1IDwgbnJfY3B1X2lkcykNCiAJCWVycm9yID0gd29ya19vbl9jcHUoY3B1LCBsb2NhbF9wY2lf
cHJvYmUsICZkZGkpOw0KZGlmZiAtLWdpdCBhL2xpYi9jcHVtYXNrLmMgYi9saWIvY3B1bWFzay5j
DQppbmRleCAwY2I2NzJlYjEwN2MuLmRjYmMzMGE0NzYwMCAxMDA2NDQNCi0tLSBhL2xpYi9jcHVt
YXNrLmMNCisrKyBiL2xpYi9jcHVtYXNrLmMNCkBAIC02LDYgKzYsNyBAQA0KICNpbmNsdWRlIDxs
aW51eC9leHBvcnQuaD4NCiAjaW5jbHVkZSA8bGludXgvbWVtYmxvY2suaD4NCiAjaW5jbHVkZSA8
bGludXgvbnVtYS5oPg0KKyNpbmNsdWRlIDxsaW51eC9zY2hlZC9pc29sYXRpb24uaD4NCiANCiAv
KioNCiAgKiBjcHVtYXNrX25leHQgLSBnZXQgdGhlIG5leHQgY3B1IGluIGEgY3B1bWFzaw0KQEAg
LTIwNSwyOCArMjA2LDQwIEBAIHZvaWQgX19pbml0IGZyZWVfYm9vdG1lbV9jcHVtYXNrX3Zhcihj
cHVtYXNrX3Zhcl90IG1hc2spDQogICovDQogdW5zaWduZWQgaW50IGNwdW1hc2tfbG9jYWxfc3By
ZWFkKHVuc2lnbmVkIGludCBpLCBpbnQgbm9kZSkNCiB7DQotCWludCBjcHU7DQorCWNvbnN0IHN0
cnVjdCBjcHVtYXNrICptYXNrOw0KKwlpbnQgY3B1LCBtLCBuOw0KKw0KKyNpZmRlZiBDT05GSUdf
VEFTS19JU09MQVRJT04NCisJbWFzayA9IGhvdXNla2VlcGluZ19jcHVtYXNrKEhLX0ZMQUdfRE9N
QUlOKTsNCisJbSA9IGNwdW1hc2tfd2VpZ2h0KG1hc2spOw0KKyNlbHNlDQorCW1hc2sgPSBjcHVf
b25saW5lX21hc2s7DQorCW0gPSBudW1fb25saW5lX2NwdXMoKTsNCisjZW5kaWYNCiANCiAJLyog
V3JhcDogd2UgYWx3YXlzIHdhbnQgYSBjcHUuICovDQotCWkgJT0gbnVtX29ubGluZV9jcHVzKCk7
DQotDQotCWlmIChub2RlID09IE5VTUFfTk9fTk9ERSkgew0KLQkJZm9yX2VhY2hfY3B1KGNwdSwg
Y3B1X29ubGluZV9tYXNrKQ0KLQkJCWlmIChpLS0gPT0gMCkNCi0JCQkJcmV0dXJuIGNwdTsNCi0J
fSBlbHNlIHsNCi0JCS8qIE5VTUEgZmlyc3QuICovDQotCQlmb3JfZWFjaF9jcHVfYW5kKGNwdSwg
Y3B1bWFza19vZl9ub2RlKG5vZGUpLCBjcHVfb25saW5lX21hc2spDQotCQkJaWYgKGktLSA9PSAw
KQ0KLQkJCQlyZXR1cm4gY3B1Ow0KLQ0KLQkJZm9yX2VhY2hfY3B1KGNwdSwgY3B1X29ubGluZV9t
YXNrKSB7DQotCQkJLyogU2tpcCBOVU1BIG5vZGVzLCBkb25lIGFib3ZlLiAqLw0KLQkJCWlmIChj
cHVtYXNrX3Rlc3RfY3B1KGNwdSwgY3B1bWFza19vZl9ub2RlKG5vZGUpKSkNCi0JCQkJY29udGlu
dWU7DQotDQotCQkJaWYgKGktLSA9PSAwKQ0KLQkJCQlyZXR1cm4gY3B1Ow0KKwluID0gaSAlIG07
DQorDQorCXdoaWxlIChtLS0gPiAwKSB7DQorCQlpZiAobm9kZSA9PSBOVU1BX05PX05PREUpIHsN
CisJCQlmb3JfZWFjaF9jcHUoY3B1LCBtYXNrKQ0KKwkJCQlpZiAobi0tID09IDApDQorCQkJCQly
ZXR1cm4gY3B1Ow0KKwkJfSBlbHNlIHsNCisJCQkvKiBOVU1BIGZpcnN0LiAqLw0KKwkJCWZvcl9l
YWNoX2NwdV9hbmQoY3B1LCBjcHVtYXNrX29mX25vZGUobm9kZSksIG1hc2spDQorCQkJCWlmIChu
LS0gPT0gMCkNCisJCQkJCXJldHVybiBjcHU7DQorDQorCQkJZm9yX2VhY2hfY3B1KGNwdSwgbWFz
aykgew0KKwkJCQkvKiBTa2lwIE5VTUEgbm9kZXMsIGRvbmUgYWJvdmUuICovDQorCQkJCWlmIChj
cHVtYXNrX3Rlc3RfY3B1KGNwdSwNCisJCQkJCQkgICAgIGNwdW1hc2tfb2Zfbm9kZShub2RlKSkp
DQorCQkJCQljb250aW51ZTsNCisNCisJCQkJaWYgKG4tLSA9PSAwKQ0KKwkJCQkJcmV0dXJuIGNw
dTsNCisJCQl9DQogCQl9DQogCX0NCiAJQlVHKCk7DQpkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvbmV0
LXN5c2ZzLmMgYi9uZXQvY29yZS9uZXQtc3lzZnMuYw0KaW5kZXggNGM4MjZiOGJmOWIxLi4yNTM3
NThmMTAyZDkgMTAwNjQ0DQotLS0gYS9uZXQvY29yZS9uZXQtc3lzZnMuYw0KKysrIGIvbmV0L2Nv
cmUvbmV0LXN5c2ZzLmMNCkBAIC0xMSw2ICsxMSw3IEBADQogI2luY2x1ZGUgPGxpbnV4L2lmX2Fy
cC5oPg0KICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+DQogI2luY2x1ZGUgPGxpbnV4L3NjaGVkL3Np
Z25hbC5oPg0KKyNpbmNsdWRlIDxsaW51eC9zY2hlZC9pc29sYXRpb24uaD4NCiAjaW5jbHVkZSA8
bGludXgvbnNwcm94eS5oPg0KICNpbmNsdWRlIDxuZXQvc29jay5oPg0KICNpbmNsdWRlIDxuZXQv
bmV0X25hbWVzcGFjZS5oPg0KQEAgLTcyNSw2ICs3MjYsMTQgQEAgc3RhdGljIHNzaXplX3Qgc3Rv
cmVfcnBzX21hcChzdHJ1Y3QgbmV0ZGV2X3J4X3F1ZXVlICpxdWV1ZSwNCiAJCXJldHVybiBlcnI7
DQogCX0NCiANCisjaWZkZWYgQ09ORklHX1RBU0tfSVNPTEFUSU9ODQorCWNwdW1hc2tfYW5kKG1h
c2ssIG1hc2ssIGhvdXNla2VlcGluZ19jcHVtYXNrKEhLX0ZMQUdfRE9NQUlOKSk7DQorCWlmIChj
cHVtYXNrX3dlaWdodChtYXNrKSA9PSAwKSB7DQorCQlmcmVlX2NwdW1hc2tfdmFyKG1hc2spOw0K
KwkJcmV0dXJuIC1FSU5WQUw7DQorCX0NCisjZW5kaWYNCisNCiAJbWFwID0ga3phbGxvYyhtYXhf
dCh1bnNpZ25lZCBpbnQsDQogCQkJICAgIFJQU19NQVBfU0laRShjcHVtYXNrX3dlaWdodChtYXNr
KSksIEwxX0NBQ0hFX0JZVEVTKSwNCiAJCSAgICAgIEdGUF9LRVJORUwpOw0KLS0gDQoyLjIwLjEN
Cg0K
