Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEAC1A3725
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgDIP3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:29:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8738 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728255AbgDIP3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:29:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 039FOYLa028149;
        Thu, 9 Apr 2020 08:28:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=QqX6DBmhSYAp+Ek6zwjJxp8jOQpdgd0MftEbnabeMYM=;
 b=DucDX/JAV864Kdmn9zCVlJNFdfcoP4JVFZeSUeZy6l4ZApyx5IqJvefrd65wWMtqEfSl
 7EAVGWdegh6ekDxevgVde563ryzjNJxQgx9b3Yzr+PESHjIq0r5BEO3Q2UpCb6WlGzAZ
 u/mFPMtYJzS8ujpU0/Eo0gJLnnv5n11RLFLbVgF9jRzy1+0Z/C+10D7dXZ9l7Y3Wm3UV
 aN+w0AIOUOb1XqsnwI8I3yh8K7tJeTn0jXyL/9e0ztbD9pFyU88ofplVBAr9zawy2jlH
 KYCpqgfti2PuPDipzvNvVqBAEpt0RWohiJDvwEv5VRX3g0RPZmXrIlgccRF/nZJsk3Cg 4g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3091me90jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 08:28:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:28:54 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:28:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 9 Apr 2020 08:28:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhz/7T6vcf060a0D+LfpyW/mf7MBqWD3WEbpKKbv1qn7FvL2jTWGH+x9g0j1LgOx7LOjU0SOdWBs26cbwCf2f6zx4aL6ySsFB6DbDQLMiOWmjYy02tA0lNDYMQ/syHKnC4ZWC44ai43c963vZNqV89PUmbEjji0x7WgRPFifR4PlaNuL3ljTL6oyKfnze4giUlkNgk6sFne+HhkBWe0XRkhm/5rrFTqLWgPdgA9X5Bplh+8gmgj/7CFEn1rj0NQC4Qho+L5JH9PPIi3CZGasmS8jBjkZO31iYrQhYO9YeuupEv652OFf0+OO0dnY7FO+V0Swcutu5BSalmVPOFRiRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqX6DBmhSYAp+Ek6zwjJxp8jOQpdgd0MftEbnabeMYM=;
 b=DlLdIrulPaR6+fx8sIMIVebC2SfmcjJwOKB1uzyq0s3Y0eRe/vgJs2CbWJJbVb6wPsLaCIS4VFswEdy0yZJI77JsZLomnzkzCskYaPjfOm50+66IVY6ebzIGS2FBFKs5KG4zUo0+dHEaCuHLvGPLELjE2lbHB4RI+2VzCHUEfFZUYv1ARz3ioQxWGKGHfdOcSzCOi0TRMg6ovHdUCN7VVACzbcjoilGWrjGh12URPtG/Jd6Z7SlMueVNr6tc52rCoODpchWKszC+mFgOQZpRu6o3+IrR8S6f+zfCBtx97bg2cb6WBbJMNYtsV0YNE0yhreR1yAjO5aftJ+c/K0MCpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqX6DBmhSYAp+Ek6zwjJxp8jOQpdgd0MftEbnabeMYM=;
 b=m4iP6B43sPl07Z1xTwILhDLEOVgV0zJqTNGF+ZpP+Xp5Kabrct+rw5kzi0wMVZC51WuKXLsHvbnjetI9HfUqQE+OFq2gfl2hR2lhjCdJVRlYtbpqh5wUdQ8ZXfsQ56gd0N+i9jcZ+YGmJgFPPZHyvIez2fwoU3aGdq1UDfH8znA=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Thu, 9 Apr
 2020 15:28:51 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280%3]) with mapi id 15.20.2878.022; Thu, 9 Apr 2020
 15:28:51 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH v3 13/13] task_isolation: CONFIG_TASK_ISOLATION prevents
 distribution of jobs to non-housekeeping CPUs
Thread-Topic: [PATCH v3 13/13] task_isolation: CONFIG_TASK_ISOLATION prevents
 distribution of jobs to non-housekeeping CPUs
Thread-Index: AQHWDoOSzjqvMuhweUS4YcE4nDeiww==
Date:   Thu, 9 Apr 2020 15:28:51 +0000
Message-ID: <51102eebe62336c6a4e584c7a503553b9f90e01c.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
         <07c25c246c55012981ec0296eee23e68c719333a.camel@marvell.com>
In-Reply-To: <07c25c246c55012981ec0296eee23e68c719333a.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47cd1aaa-c1da-498b-13db-08d7dc9ab537
x-ms-traffictypediagnostic: BYAPR18MB2423:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB24238EC7533F317EB364AA86BCC10@BYAPR18MB2423.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2535.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(86362001)(26005)(186003)(5660300002)(316002)(2616005)(81166007)(36756003)(7416002)(71200400001)(2906002)(76116006)(6486002)(478600001)(6506007)(6512007)(66556008)(64756008)(66446008)(8676002)(81156014)(66476007)(8936002)(66946007)(54906003)(4326008)(110136005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BxEyfSMn9UqN+T3zfq77zP0QjOLJkGWj2xihfeJw9YL0YKDhvdvJ4TXs7rlPp15c3Rx1np6dG99ztapcMGgVvds+aM+pxaaUZAtNo4mT6//7OYXoMqN2CYHxX64h/MmTkRquSIE9TTp0vuDFLdBT26VejAJI3w5UPrjkeSnS6Wlw+co6ND5kvjUiSlOsW5SFUCwU6tndpqzolp2X97llnFi4J86cdVCpXCdV9USrPWqlF1Mawc7fn6IgpHm4cTXHIRSgknk6e9NYQ6MhVCPU2Jr3BWlI8/sN2HcLUTdqilUEZqZl9jXLDU4TrnzceysMVIIQNHTxqTafB8lXbRpg+u8VUQEcUoW8/DHoZIAncYpiLlOwQf3thot6xJ6ctjeAzjEM0EpC2ne5iW2N/dXwOG+JcqGhu9Ys50Ukups7xFQJBExb9f14tnlwyaTr9Vxw
x-ms-exchange-antispam-messagedata: lXCz1oYALU5gKd/gpTrcVDVpAz5oUbHNvxpHH/gUsUgvEuh05zOZ+Krt0ht21fwf9xQ3b8znwCjIjfMU9YOWXnEldT2kxVNoOqkYrqCclByA/eEbij+vMQVzhcu88l9Ck6R+CHD+6J3kwMAcpQ36Lw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC3A918C58C360479B05693FC6205FD2@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 47cd1aaa-c1da-498b-13db-08d7dc9ab537
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 15:28:51.7925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l26CHGJFLHrhDaBHKgHgOgLpQb7Xv6oBpEtSrJ6rwFUmNtMqDg2Ht3/Nj2IGr0ZCp/MbRosUB2yWCwBW6j3ZnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2423
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_05:2020-04-07,2020-04-09 signatures=0
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
