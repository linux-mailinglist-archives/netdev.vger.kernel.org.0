Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBC6229A83
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732629AbgGVOrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:47:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26294 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728405AbgGVOrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:47:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MEkh8m016190;
        Wed, 22 Jul 2020 07:47:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=p6bTuXQ7WRxMymEyANQpDO/i/w9XN7WepnoSu9OWtzw=;
 b=Xp4AdyKSekCrbtf9J61nh0nsndUJ3FvUw8wtK8lJdqHtXLjgaxv19G8KJYVCSWQfXSt7
 Ic6/aF/29rEGZ1Hma/Q77okVgMbfSZ92Ppf9Lpq3Qvjj24rlcR+IpH50bCTS9CoQFHKD
 VW4J7nbBYCmmqIN9CV5V337hvnM6VsiZ/cLsxEXEPnP64lzCuH3OE3uxmFUMFrsmB7bF
 oWpzT9QGwenyhq1Sbd+l0o/UaNhgVzBzRPTWuDdobxlCNcJBEzZij+MvkmusqoIKqFaV
 +icActqyHLIQMn+o0PYsaJiN09sU5aOKt7PElNGKa4pondBG3ltrNkgrP7G/WMw1/Eo0 yA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxens6g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 07:47:14 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 07:47:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jul 2020 07:47:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=minH2iIryoKS0Dyq4fnC66xXcwHwSeDLMPnQ/7yI2EM0la+ePJAOjYxRLCQHWEKyAtNDKxUCIeCk01Klz++/pOqgj/csNvZYBE6TqK9jMJadcsc27GIOHJWlZ9ew8+0GjFkQ/FtOulpv54wbzTrr8Jm2OEiNSySNfXJ6K5CYLSVpvrQuyWvLh75SP5idzLp1hxOsYjeFmzQCMJ/4xhr+KCLEXj2tqY21weSSfTW65kWWHxMS+H9L7oP56snYsEpv05umDAz+VrWmXVdSf6z0rLn6864/Dv/hJDATQ9ob/nG8Jd3KQl839WM2EosgAlNZeb96PMWaHlRI/l34Chc26Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6bTuXQ7WRxMymEyANQpDO/i/w9XN7WepnoSu9OWtzw=;
 b=E08oxM6BDkajx410Ryg/CsfUUoV925GFDxFFeH8vnSPp4KfCPrpBP6FmhlR7I6Z7uoCYL4zFaMOm5RrmgRDFUjvcIJDLVmkbjdP4e85YaD/hSFYh8707Dl7w2/ycpZIJXjGYzXBPfj1vPkpmZA6dCQ7TXZBv+d6xJmPT4El5dh/CVw49PxCYRu1EBrWrVGkU0EX8NQK5z6ZdkyPj66z6BGAqT7L/u2bPp+/8F8N21Qf8e/geMGU9sQc5UGeLxsaGXl7asM9skXGC+nSnugVBeCHBD5lEWPqwWjVdmkjCoQ74fkph1HR6OFmXW6WwCQ9ylJWfi8F/IwBFSMOjsVcNlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6bTuXQ7WRxMymEyANQpDO/i/w9XN7WepnoSu9OWtzw=;
 b=e09a3zWa7FifCaD68AlZgDONLej14Is8RBLJT5gBo2fCC1I5eIKCUR7W2cfpbOnLdhiEfTeKd00HY3DfJueU3kFHWjaIFnJZHOCl8q92R8JeURIZrwQSqAnj9HFlj4wSbEflG3Q4ImwU1BnqmwEwXKaws729Fyd5IUgoHaXsY6A=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW2PR18MB2091.namprd18.prod.outlook.com (2603:10b6:907:2::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Wed, 22 Jul
 2020 14:47:11 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32%4]) with mapi id 15.20.3195.026; Wed, 22 Jul 2020
 14:47:11 +0000
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
Subject: [PATCH v4 01/13] task_isolation: vmstat: add quiet_vmstat_sync
 function
Thread-Topic: [PATCH v4 01/13] task_isolation: vmstat: add quiet_vmstat_sync
 function
Thread-Index: AQHWYDb7+u4pW/dIVkegDrd39Y9d0w==
Date:   Wed, 22 Jul 2020 14:47:11 +0000
Message-ID: <f98f80b3da7e0b8c2b8719c33516e034e47b1807.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: cc92bc9e-2e9f-4274-6198-08d82e4e1dfc
x-ms-traffictypediagnostic: MW2PR18MB2091:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB2091B677C83D5046BDEE249EBC790@MW2PR18MB2091.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iRCgcY9bBZrb3uXCU7/3qjjkoyJxo6NBMc+5CcH5lib8SezunaMZ/RihX3RjJU5dQ4/4xbvkJUkPFq4LLSdChoMitxZn/nb621mve7HvUwQSjX3Gk0ucr4VWv9NlhPgOpCsUhY+SpsfBlsXe8XMUHc7zRi+iWMiNQN5X5n9fXufugrqGKBWvzKf9TCG98yHpb8J01Wj8nbBUFU2j6tVU0JKs/2lV9fc4v6jKV+QDMSwKP4KAgUQseYu7ixqCOvK2KaN/zMKKOUUot564QGqElFx9voUuw37+moN8FePrPmK/JbF9kXYCTMDsum21B1GqorUT914FWbyZTAGvN/8CXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(8676002)(76116006)(91956017)(110136005)(66946007)(66446008)(64756008)(66556008)(66476007)(316002)(2906002)(6512007)(54906003)(6486002)(7416002)(478600001)(5660300002)(186003)(71200400001)(36756003)(2616005)(86362001)(4326008)(26005)(8936002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: M606+b3D8umwEBn+jJEZ/QhSWlYeZhoSO0zJjbGhs3X9vr70DpnJemjjkgscJYWv/pVj9+mXz+bzMNdmK5JP4qA2OVdQfmnoqPNUPV+zBi9jrIGJPp62wr7oelUHOF8uhe0u/8sfqH3VDanqoV42lBeTZHmG94ZreLxAdYMyjmv/xro7OOE6PG7R4qfVWrhzcjJOgY0N9lol4wNoeyAFXFgLr01xmVii1zcxJ79NizNrj1ec3Kj/ToXgRaa4wAxaN4zca1rwtwKAbCNd8snOWbU9GeH/kbgpkWHtwIVEwD+o9CvDPCYA08vSUrzfc80uma/ZKrQl7fWMUdps6ORiNT+YqNIXHVClLuJ3BiX2DjnxKhLl7O49ftWc7zh3xA6T41jjkkCYKfqH87lGgppBu3v7ok6ADd317aMgL57wasVfkb60LZcqNyZh2B/O1bh9EUFMA9HKaeescjxkdOL2FLhBhljuVg9vTKaAinoxzyI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71C0964DB92C2640A8A3A33709BD1768@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc92bc9e-2e9f-4274-6198-08d82e4e1dfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 14:47:11.6802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EvfeeOPdAM9BpPxupbER8m5ewzrOU64HzuC0EwxrUiqn40lUn9OxeuMvczerSNVaOktWvplGZCG5dHTxhJhA0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2091
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_09:2020-07-22,2020-07-22 signatures=0
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
L3Ztc3RhdC5oIGIvaW5jbHVkZS9saW51eC92bXN0YXQuaA0KaW5kZXggYWE5NjEwODhjNTUxLi5k
ZWQxNmRmZDIxZmEgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3Ztc3RhdC5oDQorKysgYi9p
bmNsdWRlL2xpbnV4L3Ztc3RhdC5oDQpAQCAtMjcyLDYgKzI3Miw3IEBAIGV4dGVybiB2b2lkIF9f
ZGVjX3pvbmVfc3RhdGUoc3RydWN0IHpvbmUgKiwgZW51bQ0Kem9uZV9zdGF0X2l0ZW0pOw0KIGV4
dGVybiB2b2lkIF9fZGVjX25vZGVfc3RhdGUoc3RydWN0IHBnbGlzdF9kYXRhICosIGVudW0NCm5v
ZGVfc3RhdF9pdGVtKTsNCiANCiB2b2lkIHF1aWV0X3Ztc3RhdCh2b2lkKTsNCit2b2lkIHF1aWV0
X3Ztc3RhdF9zeW5jKHZvaWQpOw0KIHZvaWQgY3B1X3ZtX3N0YXRzX2ZvbGQoaW50IGNwdSk7DQog
dm9pZCByZWZyZXNoX3pvbmVfc3RhdF90aHJlc2hvbGRzKHZvaWQpOw0KIA0KQEAgLTM3NCw2ICsz
NzUsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgX19kZWNfbm9kZV9wYWdlX3N0YXRlKHN0cnVjdA0K
cGFnZSAqcGFnZSwNCiBzdGF0aWMgaW5saW5lIHZvaWQgcmVmcmVzaF96b25lX3N0YXRfdGhyZXNo
b2xkcyh2b2lkKSB7IH0NCiBzdGF0aWMgaW5saW5lIHZvaWQgY3B1X3ZtX3N0YXRzX2ZvbGQoaW50
IGNwdSkgeyB9DQogc3RhdGljIGlubGluZSB2b2lkIHF1aWV0X3Ztc3RhdCh2b2lkKSB7IH0NCitz
dGF0aWMgaW5saW5lIHZvaWQgcXVpZXRfdm1zdGF0X3N5bmModm9pZCkgeyB9DQogDQogc3RhdGlj
IGlubGluZSB2b2lkIGRyYWluX3pvbmVzdGF0KHN0cnVjdCB6b25lICp6b25lLA0KIAkJCXN0cnVj
dCBwZXJfY3B1X3BhZ2VzZXQgKnBzZXQpIHsgfQ0KZGlmZiAtLWdpdCBhL21tL3Ztc3RhdC5jIGIv
bW0vdm1zdGF0LmMNCmluZGV4IDNmYjIzYTIxZjZkZC4uOTM1MzRmODUzN2NhIDEwMDY0NA0KLS0t
IGEvbW0vdm1zdGF0LmMNCisrKyBiL21tL3Ztc3RhdC5jDQpAQCAtMTg4OSw2ICsxODg5LDE1IEBA
IHZvaWQgcXVpZXRfdm1zdGF0KHZvaWQpDQogCXJlZnJlc2hfY3B1X3ZtX3N0YXRzKGZhbHNlKTsN
CiB9DQogDQorLyoNCisgKiBTeW5jaHJvbm91c2x5IHF1aWV0IHZtc3RhdCBzbyB0aGUgd29yayBp
cyBndWFyYW50ZWVkIG5vdCB0byBydW4gb24NCnJldHVybi4NCisgKi8NCit2b2lkIHF1aWV0X3Zt
c3RhdF9zeW5jKHZvaWQpDQorew0KKwljYW5jZWxfZGVsYXllZF93b3JrX3N5bmModGhpc19jcHVf
cHRyKCZ2bXN0YXRfd29yaykpOw0KKwlyZWZyZXNoX2NwdV92bV9zdGF0cyhmYWxzZSk7DQorfQ0K
Kw0KIC8qDQogICogU2hlcGhlcmQgd29ya2VyIHRocmVhZCB0aGF0IGNoZWNrcyB0aGUNCiAgKiBk
aWZmZXJlbnRpYWxzIG9mIHByb2Nlc3NvcnMgdGhhdCBoYXZlIHRoZWlyIHdvcmtlcg0KLS0gDQoy
LjI2LjINCg0K
