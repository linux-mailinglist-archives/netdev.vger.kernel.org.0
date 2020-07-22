Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6F5229A89
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732647AbgGVOt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:49:27 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40066 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729642AbgGVOtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:49:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MEkokH016196;
        Wed, 22 Jul 2020 07:48:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=3912sffFv0bNrTJYcPGQ2ATrVX945IvVFvT3Ia9ps+E=;
 b=IPdkZVJyq/QglTCXxrSXlab/gOO/LQEX/aBZDDeRJvtK1JfoIzt3MADWrbnQ9jz52EQp
 CVHv8KXSXhIVfdVEKpB5R+DGcqtZh02R6BavoCOq63CseIUNCgqDh23Cd+f4cdlCdVuJ
 ErYqfv+l710G6OLcQB5AqAMZOPoRTBDKiwJAx6yPB1q5DQG1EfPR3wcnHDeQmkbSSqq6
 ZmpkdE832+CvQWgqnxHLTA0lOGEFC/BsquWmeJj+v9rO1RfC5UlH7CwrcizJDkyzSnAt
 eZ0mXg54okBkx5IgDnLziYa99iwN2uitj5P/QKqhLH6N+FEt6sBewpdzCxPqvYiZLei1 yw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxens6p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 07:48:58 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 07:48:57 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jul 2020 07:48:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m32i5eko/qQNOM2jMgw/lmOUqOWptazGsqxjoGl2YoY/knfkztcdpQvjf/FQCdPGcKhc4Mnk383G2/2A+m6Ar0S15NNhDVyLuHPs1LlkkQ5DWIr8ScoXEuCIZmRxR3+lauYEC271Puk531RSM51bhQ07AOQC+Odpql8MD5Z66Zgn3T+ou47mgzOTfblx6uiMGOW5UCjXIlmxmIexnjiNUSsphCkmQ3UnZrAZWvtkTBpuHId1rT4A5K1SSqk2mJ9sl2Ic+yf8Qk5xGbX23+WyY5SEE+TLB4XCzk/EZd7hWkc5kpx7lDYYRQDIAHoOxeYXHjxmnwzAqcsXVQAStJKhbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3912sffFv0bNrTJYcPGQ2ATrVX945IvVFvT3Ia9ps+E=;
 b=Oa8i1dQru+QP92krqKwO9Jx0OCOxiIReSXXMInYmJ7WwQ4t9+dyENnPWLPduS/b+k4UdJ6dt9ZFEvFNzzb7HLH7IVcfp0h4dAATq/PZ+KZGKOJECYoOEY99h+XSfC8j9wAx0S3ueI5rxuc5FQC6caKxq/Aq78I+oAQUfoSteCUdL040lRGsOdm2I+cdEb/oaprVh+XzT3WAwXwFP05ocgThFaxq6e4UPJ4Mp/F01pnC+gwxjB+aM7I1x3yX5M1+EH/tbwxv42GsD1oN1pit+I1JaJeEOStztLrwU8fHYohyME8K6/KfXs+BS1RNdHisVxJb880mb6adWfpsSDkM2eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3912sffFv0bNrTJYcPGQ2ATrVX945IvVFvT3Ia9ps+E=;
 b=T7rvewSMUFpv8PWT5fpb5Bmz6xRM1QPUGVrjgfKZEz4UtT3zvSlAqWTf85FG9yt7spfVZxlWnMR9lSzgFjprNQ5sl83TRT74kp3kzU6inXHHlLzERkl44WXs0EdQ/FY0BMLkTRz3/23hxpVGGm9z555fcKkZZqEANecjAia4/+M=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR18MB1279.namprd18.prod.outlook.com (2603:10b6:320:2c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Wed, 22 Jul
 2020 14:48:55 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32%4]) with mapi id 15.20.3195.026; Wed, 22 Jul 2020
 14:48:55 +0000
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
Subject: [PATCH v4 02/13] task_isolation: vmstat: add vmstat_idle function
Thread-Topic: [PATCH v4 02/13] task_isolation: vmstat: add vmstat_idle
 function
Thread-Index: AQHWYDc5m+yfBf+oREWWYu7pQOOLOw==
Date:   Wed, 22 Jul 2020 14:48:55 +0000
Message-ID: <072c0cd559c6ad91898e4982bc32cc8918a3dde0.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
In-Reply-To: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f637b885-826a-4f4c-9d97-08d82e4e5c0d
x-ms-traffictypediagnostic: MWHPR18MB1279:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB127916BF39578CB87C186CD5BC790@MWHPR18MB1279.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b2zwlKk8oDGdaHMxPtptWq4U3rh1iQKJz/x3mTWUQTC6dM7UEZpcxYHNpdEVwL94Jk0ObYxFcX7oPSp2gLeO2Y0WeubSiXebmTFRcpF75caC95IzTVDrHx84YxFNhdYVAlDWhDeC92dMciRiOynN6P456qtnJ+Kxa3NNR0GEn+FebC7StATxevCeAWmtvH1NQgfK8k+Y2gDW4WLK5LfI/KVSWX/Jvn9gmrf/L6IrAztdXAh4Y+W4NMqSzyhqIdnqe2xdl6sE0Zj9onIWUTEH9i+NaVRBeIiDw0bYIGUG/R9H5DB41S3CHpiHBxwhymWj2VWhPZ39MBv6mScW1X0CDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39850400004)(376002)(346002)(136003)(54906003)(26005)(316002)(110136005)(2616005)(71200400001)(8936002)(7416002)(86362001)(2906002)(5660300002)(4326008)(64756008)(66556008)(66446008)(6486002)(478600001)(36756003)(6512007)(8676002)(186003)(76116006)(91956017)(66946007)(83380400001)(66476007)(6506007)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ExTWt12KICcHsm166pas+6cBDToHgWWgywTkyiHLCT2RrS3MSdv2uiMQAMSpjgqBZrcUh1Z6UhEk8FLfL5qoATZiomrZf0k15g+ySdxqthkB2zFY8okVbxkoJ6mgNwBLk54PX0caRXNfOUexfrInfEKqM5okmoitSGOwhgdiA4iiFEtJIrCxvgAmgDRsRNT6GpAoI3QOkgmqF5CERcOIg0janbQ3onhPnidC2Hu5Op4LBul3p60GBn6KBRfNwTxmsINZOkcVPtJTfAIm7JVFdH7InxpMPAGhoWP5Esqh/svBl1BDrvHmRCugNfdrRfd/vvqTHeULTiDm2TZfeTvjlyAUDoc3M6hneyAMBnBboGXhLHZYyVLX706aImsELOSk8qGTvWgIrxq8e6FopybdH8nWtyIc5+C4lNq5wTgCtKyK0P4swH9SNEHzAyspv6yje4yjWecb3ZzqKexzlCXCKKegLzmlDtULdvDicf/AdUg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36C0BDF44ACEAB4DBB21BDD43F5569D5@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f637b885-826a-4f4c-9d97-08d82e4e5c0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 14:48:55.8398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S7Uny6mj+I16UOe4oDlhzaCgE714qQ7hpIobKp6b+nbxQFiOD57n+6NvCKHi17zR/Gc92m3WV0uPKg2K10sRng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1279
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_09:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbSA3ODIzYmU4Y2QzYmEyZTY2MzA4ZjMzNGEyZTQ3ZjYwYmE3ODI5ZTBiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogQ2hyaXMgTWV0Y2FsZiA8Y21ldGNhbGZAbWVsbGFub3guY29t
Pg0KRGF0ZTogU2F0LCAxIEZlYiAyMDIwIDA4OjA1OjQ1ICswMDAwDQpTdWJqZWN0OiBbUEFUQ0gg
MDIvMTNdIHRhc2tfaXNvbGF0aW9uOiB2bXN0YXQ6IGFkZCB2bXN0YXRfaWRsZSBmdW5jdGlvbg0K
DQpUaGlzIGZ1bmN0aW9uIGNoZWNrcyB0byBzZWUgaWYgYSB2bXN0YXQgd29ya2VyIGlzIG5vdCBy
dW5uaW5nLA0KYW5kIHRoZSB2bXN0YXQgZGlmZnMgZG9uJ3QgcmVxdWlyZSBhbiB1cGRhdGUuICBU
aGUgZnVuY3Rpb24gaXMNCmNhbGxlZCBmcm9tIHRoZSB0YXNrLWlzb2xhdGlvbiBjb2RlIHRvIHNl
ZSBpZiB3ZSBuZWVkIHRvDQphY3R1YWxseSBkbyBzb21lIHdvcmsgdG8gcXVpZXQgdm1zdGF0Lg0K
DQpTaWduZWQtb2ZmLWJ5OiBDaHJpcyBNZXRjYWxmIDxjbWV0Y2FsZkBtZWxsYW5veC5jb20+DQpT
aWduZWQtb2ZmLWJ5OiBBbGV4IEJlbGl0cyA8YWJlbGl0c0BtYXJ2ZWxsLmNvbT4NCi0tLQ0KIGlu
Y2x1ZGUvbGludXgvdm1zdGF0LmggfCAgMiArKw0KIG1tL3Ztc3RhdC5jICAgICAgICAgICAgfCAx
MCArKysrKysrKysrDQogMiBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspDQoNCmRpZmYg
LS1naXQgYS9pbmNsdWRlL2xpbnV4L3Ztc3RhdC5oIGIvaW5jbHVkZS9saW51eC92bXN0YXQuaA0K
aW5kZXggZGVkMTZkZmQyMWZhLi45N2JjOWVkOTIwMzYgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xp
bnV4L3Ztc3RhdC5oDQorKysgYi9pbmNsdWRlL2xpbnV4L3Ztc3RhdC5oDQpAQCAtMjczLDYgKzI3
Myw3IEBAIGV4dGVybiB2b2lkIF9fZGVjX25vZGVfc3RhdGUoc3RydWN0IHBnbGlzdF9kYXRhICos
IGVudW0gbm9kZV9zdGF0X2l0ZW0pOw0KIA0KIHZvaWQgcXVpZXRfdm1zdGF0KHZvaWQpOw0KIHZv
aWQgcXVpZXRfdm1zdGF0X3N5bmModm9pZCk7DQorYm9vbCB2bXN0YXRfaWRsZSh2b2lkKTsNCiB2
b2lkIGNwdV92bV9zdGF0c19mb2xkKGludCBjcHUpOw0KIHZvaWQgcmVmcmVzaF96b25lX3N0YXRf
dGhyZXNob2xkcyh2b2lkKTsNCiANCkBAIC0zNzYsNiArMzc3LDcgQEAgc3RhdGljIGlubGluZSB2
b2lkIHJlZnJlc2hfem9uZV9zdGF0X3RocmVzaG9sZHModm9pZCkgeyB9DQogc3RhdGljIGlubGlu
ZSB2b2lkIGNwdV92bV9zdGF0c19mb2xkKGludCBjcHUpIHsgfQ0KIHN0YXRpYyBpbmxpbmUgdm9p
ZCBxdWlldF92bXN0YXQodm9pZCkgeyB9DQogc3RhdGljIGlubGluZSB2b2lkIHF1aWV0X3Ztc3Rh
dF9zeW5jKHZvaWQpIHsgfQ0KK3N0YXRpYyBpbmxpbmUgYm9vbCB2bXN0YXRfaWRsZSh2b2lkKSB7
IHJldHVybiB0cnVlOyB9DQogDQogc3RhdGljIGlubGluZSB2b2lkIGRyYWluX3pvbmVzdGF0KHN0
cnVjdCB6b25lICp6b25lLA0KIAkJCXN0cnVjdCBwZXJfY3B1X3BhZ2VzZXQgKnBzZXQpIHsgfQ0K
ZGlmZiAtLWdpdCBhL21tL3Ztc3RhdC5jIGIvbW0vdm1zdGF0LmMNCmluZGV4IDkzNTM0Zjg1Mzdj
YS4uZjM2OTNlZjBhOTU4IDEwMDY0NA0KLS0tIGEvbW0vdm1zdGF0LmMNCisrKyBiL21tL3Ztc3Rh
dC5jDQpAQCAtMTg5OCw2ICsxODk4LDE2IEBAIHZvaWQgcXVpZXRfdm1zdGF0X3N5bmModm9pZCkN
CiAJcmVmcmVzaF9jcHVfdm1fc3RhdHMoZmFsc2UpOw0KIH0NCiANCisvKg0KKyAqIFJlcG9ydCBv
biB3aGV0aGVyIHZtc3RhdCBwcm9jZXNzaW5nIGlzIHF1aWVzY2VkIG9uIHRoZSBjb3JlIGN1cnJl
bnRseToNCisgKiBubyB2bXN0YXQgd29ya2VyIHJ1bm5pbmcgYW5kIG5vIHZtc3RhdCB1cGRhdGVz
IHRvIHBlcmZvcm0uDQorICovDQorYm9vbCB2bXN0YXRfaWRsZSh2b2lkKQ0KK3sNCisJcmV0dXJu
ICFkZWxheWVkX3dvcmtfcGVuZGluZyh0aGlzX2NwdV9wdHIoJnZtc3RhdF93b3JrKSkgJiYNCisJ
CSFuZWVkX3VwZGF0ZShzbXBfcHJvY2Vzc29yX2lkKCkpOw0KK30NCisNCiAvKg0KICAqIFNoZXBo
ZXJkIHdvcmtlciB0aHJlYWQgdGhhdCBjaGVja3MgdGhlDQogICogZGlmZmVyZW50aWFscyBvZiBw
cm9jZXNzb3JzIHRoYXQgaGF2ZSB0aGVpciB3b3JrZXINCi0tIA0KMi4yNi4yDQoNCg==
