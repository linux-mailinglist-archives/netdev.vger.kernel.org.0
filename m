Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DEE1A36BE
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgDIPQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:16:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17848 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727855AbgDIPQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:16:29 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 039FFXVk014764;
        Thu, 9 Apr 2020 08:15:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=QWu2M76m9hVSAXAAtmF1o1VVMW+6Oofv940UBtiP6Bs=;
 b=d7XLeGfUM1m7K618JK++g7W7UXJ+XWAvNSmd+pwohBeLpfKu+N7rnV5Fbr4vhfCK8SAz
 Zo17mHkKpWv6cuLKgK4w2Q7HJ4gkhC532bBb4mSu59OMS360vjKE/9ijNHKiep7XO0tK
 NsVjFrQsnu37+c1XBz/Kczs/4R0xglsx0YVGopfcndWPhVs2PtpCJAcmGZnPPv+GkVCG
 MIRvrATv8BrSKCIBbOz70uwVciuPMt/2O6Yh2ZzRYxJB2ohYh1X2OMT+Yd7oNjiqqkjB
 H9AdWBvhvSVtAfSSc3AbAGX1SACp6tQOss3619vUj1qRD9P4DuHNHjvaQtIQKYAC1SR6 Hg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3091jwh01r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 08:15:46 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:15:44 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:15:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 9 Apr 2020 08:15:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ek5TuMsiUSRAlc7kJhdHLHK8nGltkIeB8G1xfCHP7jiLyj0iqCSWAKDg/i+lxv4+4+Bk8g06NvHIJNF/QuJ7mgAhGE/0axsKm/GdzlgCeJnT4zntONMUj2aKxSs8HUhRQa5nnHTclXZb1UQWg+Xw2QB5ZGzfsUIdy5kQAVVwIHnPxZ8V8HRtNS8OWSAYR/rJjBJnn5BI/wwaPdSD65OMPwkHpnDPLVRX3Ds/Fm2gsJ2GPc5wZ5QDPzoBWQr2DBw73y0KptA2nLRXUtZ7OAFcrTdnU5ed9d7r85AGm4ef3923uBGGpYTsQAT5hw4H/nmk35PcTDxCg7sruwQ43VXGdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWu2M76m9hVSAXAAtmF1o1VVMW+6Oofv940UBtiP6Bs=;
 b=DBM/Sco5QhdOi1rNmPB85+rDn8IvPj3j3i8+kpiCtOhJYV3xScAlM+P1vVn3DLP55cznmAnFBTSyJkRMsBshj/15UFuvIgbrQJmoIVhjBCa/2ICwr3CUXXlG3s0SvlBC+g0K6T3iYXUlhPPAHhE+ytvVQYf4WDvCiXjcOdB0R0Vw+jvlN9MCSDOL4NtizhiM3o2/dukA6Ndqda9vRt4WDSfYpzdhcOcolJRILEInN6fEi7wwudqW451VzWw7x/i9qXbil2pq0xWGE4/w7Lhq4qC4HmZvFlZiu3fipj6S54x+xw5GPgWYW1f1VEVQ9n/9KFkR3NZzDKcDTNPt44SvDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWu2M76m9hVSAXAAtmF1o1VVMW+6Oofv940UBtiP6Bs=;
 b=GgGRiAbg69eJwWEGUBUIjzwWmizNfoJ7v3f3Oq/jHK2/ajKL8IjdfkIlwIcT8klX/41xLCYu92d+K5l5K1CZl3wT+GRlYR2qcvXF5EbJjum9GgM+6t37ZHWQqx+emeHsXehUbkwyb7E73J2bByGMW2W16ytQeVs81FkUndGNdoQ=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2758.namprd18.prod.outlook.com (2603:10b6:a03:112::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.18; Thu, 9 Apr
 2020 15:15:42 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280%3]) with mapi id 15.20.2878.022; Thu, 9 Apr 2020
 15:15:42 +0000
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
Subject: [PATCH 01/13] task_isolation: vmstat: add quiet_vmstat_sync function
Thread-Topic: [PATCH 01/13] task_isolation: vmstat: add quiet_vmstat_sync
 function
Thread-Index: AQHWDoG87dqkhBWgL0Cw8QsE6xEP5A==
Date:   Thu, 9 Apr 2020 15:15:42 +0000
Message-ID: <bc58884986ec85418dda9bf629cb6b3c389de4f0.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: 283ce317-d806-4a32-2928-08d7dc98ded4
x-ms-traffictypediagnostic: BYAPR18MB2758:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2758EBC3B5D31A6370955CE0BCC10@BYAPR18MB2758.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2535.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(478600001)(36756003)(7416002)(71200400001)(2906002)(186003)(26005)(86362001)(2616005)(316002)(6506007)(110136005)(54906003)(64756008)(66556008)(6486002)(8936002)(66946007)(66476007)(4326008)(5660300002)(66446008)(6512007)(8676002)(81166007)(76116006)(81156014);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OkwhCHAY5goLA0fQmiM6TetQYIglVy7xWFOKhXivynbLClOQ3oSc7jUexvvEVtl0BeNMUB41/+QsbfTgSYd7yshdAKeK5N85vVL5Jz4ug0e1biHvEAbwPgnhLZ8nGMS54LHBIOmnuSn3h+eVtis6MZlSAkAntYISlagyHl0OmJXmymvHIwars335/uoVvT/7zxOSaMzSSigO8Y+z6jsVbj3Ha7DEdV1YprNmsh2YvhkYqqXFlraS+szYPkLuyO0lvSc6wN31hbXYojoUyquH7AkrQpnm5Z4kXOhwAbls8Ln/eYMJbzvdFrq9QlxfI/tKS4G0LmCPivYGE8STIReWGNMzUD5i3w+ceNaRHX0CCA/p/oQQVSv5jR27eFwbMa13mRIbaf+98kYODci+3xFaeNFayiCjGSrk62QjPDbvYIhiWyPrlEaf4ri9cdcBTqa4
x-ms-exchange-antispam-messagedata: rpSTL6Qw1A2IO3ff98dfyXjfnCGP0IVkVLdkFM/N3oqbIxV/UhcW5lwVJTs0FTV+UYhH8/IIp/6Uu07rPz9L2ziIn74rXXwnghxaev4hboLMbKqmjXfalsuCrlA+XlbgQLwFl1okGvVfIQzwYSLjNw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <C996980330DF1341843865C54D056175@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 283ce317-d806-4a32-2928-08d7dc98ded4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 15:15:42.6311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8u8TVyVD7tNTSHD8Owz+u3APJ5DFMVfstqYsxbm9MB1J2iyaX7/ob1DIUJBgCwRHzy15Kow9OrQXcDuoxHmcfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2758
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_05:2020-04-07,2020-04-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SW4gY29tbWl0IGYwMWYxN2QzNzA1YiAoIm1tLCB2bXN0YXQ6IG1ha2UgcXVpZXRfdm1zdGF0IGxp
Z2h0ZXIiKQ0KdGhlIHF1aWV0X3Ztc3RhdCgpIGZ1bmN0aW9uIGJlY2FtZSBhc3luY2hyb25vdXMs
IGluIHRoZSBzZW5zZSB0aGF0DQp0aGUgdm1zdGF0IHdvcmsgd2FzIHN0aWxsIHNjaGVkdWxlZCB0
byBydW4gb24gdGhlIGNvcmUgd2hlbiB0aGUNCmZ1bmN0aW9uIHJldHVybmVkLiAgRm9yIHRhc2sg
aXNvbGF0aW9uLCB3ZSBuZWVkIGEgc3luY2hyb25vdXMNCnZlcnNpb24gb2YgdGhlIGZ1bmN0aW9u
IHRoYXQgZ3VhcmFudGVlcyB0aGF0IHRoZSB2bXN0YXQgd29ya2VyDQp3aWxsIG5vdCBydW4gb24g
dGhlIGNvcmUgb24gcmV0dXJuIGZyb20gdGhlIGZ1bmN0aW9uLiAgQWRkIGENCnF1aWV0X3Ztc3Rh
dF9zeW5jKCkgZnVuY3Rpb24gd2l0aCB0aGF0IHNlbWFudGljLg0KDQpTaWduZWQtb2ZmLWJ5OiBD
aHJpcyBNZXRjYWxmIDxjbWV0Y2FsZkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBBbGV4
IEJlbGl0cyA8YWJlbGl0c0BtYXJ2ZWxsLmNvbT4NCi0tLQ0KIGluY2x1ZGUvbGludXgvdm1zdGF0
LmggfCAyICsrDQogbW0vdm1zdGF0LmMgICAgICAgICAgICB8IDkgKysrKysrKysrDQogMiBmaWxl
cyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L3Ztc3RhdC5oIGIvaW5jbHVkZS9saW51eC92bXN0YXQuaA0KaW5kZXggMjkyNDg1ZjNkMjRkLi4y
YmM1ZTg1ZjI1MTQgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3Ztc3RhdC5oDQorKysgYi9p
bmNsdWRlL2xpbnV4L3Ztc3RhdC5oDQpAQCAtMjcwLDYgKzI3MCw3IEBAIGV4dGVybiB2b2lkIF9f
ZGVjX3pvbmVfc3RhdGUoc3RydWN0IHpvbmUgKiwgZW51bSB6b25lX3N0YXRfaXRlbSk7DQogZXh0
ZXJuIHZvaWQgX19kZWNfbm9kZV9zdGF0ZShzdHJ1Y3QgcGdsaXN0X2RhdGEgKiwgZW51bSBub2Rl
X3N0YXRfaXRlbSk7DQogDQogdm9pZCBxdWlldF92bXN0YXQodm9pZCk7DQordm9pZCBxdWlldF92
bXN0YXRfc3luYyh2b2lkKTsNCiB2b2lkIGNwdV92bV9zdGF0c19mb2xkKGludCBjcHUpOw0KIHZv
aWQgcmVmcmVzaF96b25lX3N0YXRfdGhyZXNob2xkcyh2b2lkKTsNCiANCkBAIC0zNzIsNiArMzcz
LDcgQEAgc3RhdGljIGlubGluZSB2b2lkIF9fZGVjX25vZGVfcGFnZV9zdGF0ZShzdHJ1Y3QgcGFn
ZSAqcGFnZSwNCiBzdGF0aWMgaW5saW5lIHZvaWQgcmVmcmVzaF96b25lX3N0YXRfdGhyZXNob2xk
cyh2b2lkKSB7IH0NCiBzdGF0aWMgaW5saW5lIHZvaWQgY3B1X3ZtX3N0YXRzX2ZvbGQoaW50IGNw
dSkgeyB9DQogc3RhdGljIGlubGluZSB2b2lkIHF1aWV0X3Ztc3RhdCh2b2lkKSB7IH0NCitzdGF0
aWMgaW5saW5lIHZvaWQgcXVpZXRfdm1zdGF0X3N5bmModm9pZCkgeyB9DQogDQogc3RhdGljIGlu
bGluZSB2b2lkIGRyYWluX3pvbmVzdGF0KHN0cnVjdCB6b25lICp6b25lLA0KIAkJCXN0cnVjdCBw
ZXJfY3B1X3BhZ2VzZXQgKnBzZXQpIHsgfQ0KZGlmZiAtLWdpdCBhL21tL3Ztc3RhdC5jIGIvbW0v
dm1zdGF0LmMNCmluZGV4IDc4ZDUzMzc4ZGI5OS4uMWZhMGIyZDA0YWZhIDEwMDY0NA0KLS0tIGEv
bW0vdm1zdGF0LmMNCisrKyBiL21tL3Ztc3RhdC5jDQpAQCAtMTg3MCw2ICsxODcwLDE1IEBAIHZv
aWQgcXVpZXRfdm1zdGF0KHZvaWQpDQogCXJlZnJlc2hfY3B1X3ZtX3N0YXRzKGZhbHNlKTsNCiB9
DQogDQorLyoNCisgKiBTeW5jaHJvbm91c2x5IHF1aWV0IHZtc3RhdCBzbyB0aGUgd29yayBpcyBn
dWFyYW50ZWVkIG5vdCB0byBydW4gb24gcmV0dXJuLg0KKyAqLw0KK3ZvaWQgcXVpZXRfdm1zdGF0
X3N5bmModm9pZCkNCit7DQorCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYyh0aGlzX2NwdV9wdHIo
JnZtc3RhdF93b3JrKSk7DQorCXJlZnJlc2hfY3B1X3ZtX3N0YXRzKGZhbHNlKTsNCit9DQorDQog
LyoNCiAgKiBTaGVwaGVyZCB3b3JrZXIgdGhyZWFkIHRoYXQgY2hlY2tzIHRoZQ0KICAqIGRpZmZl
cmVudGlhbHMgb2YgcHJvY2Vzc29ycyB0aGF0IGhhdmUgdGhlaXIgd29ya2VyDQotLSANCjIuMjAu
MQ0KDQo=
