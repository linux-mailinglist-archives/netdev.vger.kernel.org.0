Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D87D229AAF
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732699AbgGVOxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:53:40 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33912 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731856AbgGVOxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:53:39 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MEnMNS012667;
        Wed, 22 Jul 2020 07:53:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=rlCXkoep0UYBt/xn1VMY0GqZr1LqNLBz/I0H/s5wz4E=;
 b=MjhfU9Nt2ufW+1bfPMrlXZJGKuncVotU/GzcLWmzZ7Uv4uM6yU+QmPeQcXcYKW5UGGyQ
 nugjHB+qlZ8ldo2nDj6ej+m2FiLdwhW3JGN1TscRDzTBrvMz/evpyP/0NvglaBgOSUhV
 HhNe3u3yUPdNnBE81Gl00gfltG4pZmwKhb7wi6rf49LsNTDPpoXtvDeLkR0xDLC9eILT
 Y6qaO667jdpuU5Paj2wiysbjFYxbOpjtzJwugfVHYHB9e0FndUgYWvdJbZxRsmyeKMXQ
 77QiCSl862lNwop8qne9viVEc6j41dotFdDf4JkRU7X4DfziYvGusQfJPdkGuOSfrFO8 YQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkrb3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 07:53:03 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 07:53:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jul 2020 07:53:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fk5un9GZrx5RJVEdctPysT0WIHSlBjlHLuVrMrX/ukc3oAq0UyBRXANFYlmTcK7ut+eBk4235J35gEcbV5jg+ElNH4HIZcnqeSbGVSCCYYjyWIA3ell7iBVpfd66fX7ZbmkKdHTtV4yk/YrmFCntw9txhLlAko84Ds2x1AfMaVS2OSvLWJqLr9F2kPlzubPs9ceouU8vPpR7xfkt/vl0jugTjfmvn2Nnf/BgW1OpJBHgBZpq4nn8wxnFLXrbVmV9PmAAYzv4VpdCptB2CBJzdzJhyxMsE0gmim4SQsrHeMCXcbG5DDQjbw4iQJdN7vcelBeYaCeQ2/4iSN1Vl7Rrpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlCXkoep0UYBt/xn1VMY0GqZr1LqNLBz/I0H/s5wz4E=;
 b=S/vjIW3Wy4zB00bS7ScmOrd92/94o8VnBYP0w4bxIGntKrDuPCfs+ZcgZVlH8XmzULBRsMc2mvT5OxmigSHuAA9AYqqZuK+zcXOFRKl0ZTfSCbafkBiFq1LGTHifkg6oI5CITJojOwKGZKwGxxZpWpcJwC6ac6fYcjB+o8q7U4a4GWkChjJObUvYzfT8XGNKh+X82fGVtRrR1PK9Pa3+w3cCBaBiKCFth+1UC7xNPHrlUYYCUN4djvd9+8ENF5Ku5Y55rAaOvgBpZVqA4jFQGp1/h0cH+iaXdjll98tvYzj8cgabwrMeYQWaC3fXtj4px88/i8O42ysfB+4bNlwzXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlCXkoep0UYBt/xn1VMY0GqZr1LqNLBz/I0H/s5wz4E=;
 b=t12xrwfTxsDqP45/4k5EgaU0k3ATC3mqRoEVR5qNqn/AxqdwS5ZmcCaU94jiqKxzEiImfp6b+UrWrZA2mB59DGAK/C2/hUiP67EC45Bc6SaDkqo3JYKxO63Vng6a061x233Sf+fjHRZZ9AK0KSX/uoVIbjE3/TwX/Z4hiHRyG2M=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW2PR18MB2156.namprd18.prod.outlook.com (2603:10b6:907:a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Wed, 22 Jul
 2020 14:53:00 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32%4]) with mapi id 15.20.3195.026; Wed, 22 Jul 2020
 14:53:00 +0000
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
Subject: [PATCH 06/13] task_isolation: Add driver-specific hooks
Thread-Topic: [PATCH 06/13] task_isolation: Add driver-specific hooks
Thread-Index: AQHWYDfLEWm/FvU9QkyARg4LLZWHYw==
Date:   Wed, 22 Jul 2020 14:53:00 +0000
Message-ID: <d5302ef35a20976f360f619884bfcd087eab77fb.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: 941caea6-85ae-48c4-c967-08d82e4eedac
x-ms-traffictypediagnostic: MW2PR18MB2156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB215665BBEDAE86DD83AB0F93BC790@MW2PR18MB2156.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e+/lkENi//xP0xCnYw/iMnLdYw/4LHjp/pHNBdvRUrZIfi4Eu8cPrGkcN0MZd3c6ho0KeZHeHveR7V9Z6/WMydBP/teOVeS4Swh+x4XgqNiu+MuSH3ksEfKJ3M7vIIPtZkvjhTQtVRjIOj5PSpYGeEar+awDwVXOc85ytuwb4tPIF6/0wv7vMpf+CdB2N+8tTb3yQGtparWOe0cZeQrSB0Utomq3+Rrg7cq+MrxkXPLI/yENZGSmJDVxUOw/ILDV2zQuAH5X+WH0XL1WcCBCnhYkOVlyWxPMqMnFTIG2yHLGA/psvVK5e3N9PK4SgdcG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(110136005)(6486002)(2906002)(6506007)(54906003)(66476007)(478600001)(6512007)(8936002)(2616005)(8676002)(316002)(4326008)(66946007)(186003)(64756008)(86362001)(83380400001)(76116006)(91956017)(5660300002)(66446008)(36756003)(66556008)(26005)(71200400001)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ierTVGVynEljc2zjIfdxUxy1AnLyVWKAspNPOj6U+tUY+NtiNXpGkBQNen/J02bZPvjDT/7PkL6B3mFmN85pXPNGg/G3LH88VA/ecEksHEOS6t7VCto0M+Bq5Wt5Ke5eiUquQWy/X4dm/LeTGrqO2XNqfT09a9CcDg7nsEsNtIXiusd3XzlwfmEwtriT+LPBoSuVBybD+puZS/M31en1FXlr1uerCXmPN0e6TEE1v6vfcAknMpdIP2ZRNEsgdMaHqiHS/6XKMcWW3KqsO8iKCvZ9ydOT578yiTQcEwGR9g95NEV2qurdgO9Wa5WMIWIAvGjRckqVu4qAbGuMOAMbhUiFbFzz9flHA9znmYe4VtdbOVVvqGmwIpQrDs/TehbksfeJ57wKqsHjxJ7V8+0MilrK6/woLQKPL27MDwbUKxNMS5RtkzqcH7fFxJo3rUZO+r0kH6DKLYwK/ocy1cw/7Ea56d7ev8wNbmGV/vHdgkI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29DE6F6283742246B93D47862FFA4D3C@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 941caea6-85ae-48c4-c967-08d82e4eedac
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 14:53:00.1246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i6spHPWJA0C7NEFTOGUFpdp3ix0iQwF+RWr2Ma5BSII6XObz4fXOkBST2aIuddXSgebnWAvBPHsoTJ8ZBT2BYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2156
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_08:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U29tZSBkcml2ZXJzIGRvbid0IGNhbGwgZnVuY3Rpb25zIHRoYXQgY2FsbA0KdGFza19pc29sYXRp
b25fa2VybmVsX2VudGVyKCkgaW4gaW50ZXJydXB0IGhhbmRsZXJzLiBDYWxsIGl0DQpkaXJlY3Rs
eS4NCg0KU2lnbmVkLW9mZi1ieTogQWxleCBCZWxpdHMgPGFiZWxpdHNAbWFydmVsbC5jb20+DQot
LS0NCiBkcml2ZXJzL2lycWNoaXAvaXJxLWFybWFkYS0zNzAteHAuYyB8IDYgKysrKysrDQogZHJp
dmVycy9pcnFjaGlwL2lycS1naWMtdjMuYyAgICAgICAgfCAzICsrKw0KIGRyaXZlcnMvaXJxY2hp
cC9pcnEtZ2ljLmMgICAgICAgICAgIHwgMyArKysNCiBkcml2ZXJzL3MzOTAvY2lvL2Npby5jICAg
ICAgICAgICAgICB8IDMgKysrDQogNCBmaWxlcyBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspDQoN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJxLWFybWFkYS0zNzAteHAuYyBiL2RyaXZl
cnMvaXJxY2hpcC9pcnEtYXJtYWRhLTM3MC14cC5jDQppbmRleCBjOWJkYzUyMjFiODIuLmRmN2Yy
Y2NlM2E1NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtYXJtYWRhLTM3MC14cC5j
DQorKysgYi9kcml2ZXJzL2lycWNoaXAvaXJxLWFybWFkYS0zNzAteHAuYw0KQEAgLTI5LDYgKzI5
LDcgQEANCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KICNpbmNsdWRlIDxsaW51eC9zeXNjb3Jl
X29wcy5oPg0KICNpbmNsdWRlIDxsaW51eC9tc2kuaD4NCisjaW5jbHVkZSA8bGludXgvaXNvbGF0
aW9uLmg+DQogI2luY2x1ZGUgPGFzbS9tYWNoL2FyY2guaD4NCiAjaW5jbHVkZSA8YXNtL2V4Y2Vw
dGlvbi5oPg0KICNpbmNsdWRlIDxhc20vc21wX3BsYXQuaD4NCkBAIC00NzMsNiArNDc0LDcgQEAg
c3RhdGljIGNvbnN0IHN0cnVjdCBpcnFfZG9tYWluX29wcyBhcm1hZGFfMzcwX3hwX21waWNfaXJx
X29wcyA9IHsNCiBzdGF0aWMgdm9pZCBhcm1hZGFfMzcwX3hwX2hhbmRsZV9tc2lfaXJxKHN0cnVj
dCBwdF9yZWdzICpyZWdzLCBib29sIGlzX2NoYWluZWQpDQogew0KIAl1MzIgbXNpbWFzaywgbXNp
bnI7DQorCWludCBpc29sX2VudGVyZWQgPSAwOw0KIA0KIAltc2ltYXNrID0gcmVhZGxfcmVsYXhl
ZChwZXJfY3B1X2ludF9iYXNlICsNCiAJCQkJQVJNQURBXzM3MF9YUF9JTl9EUkJFTF9DQVVTRV9P
RkZTKQ0KQEAgLTQ4OSw2ICs0OTEsMTAgQEAgc3RhdGljIHZvaWQgYXJtYWRhXzM3MF94cF9oYW5k
bGVfbXNpX2lycShzdHJ1Y3QgcHRfcmVncyAqcmVncywgYm9vbCBpc19jaGFpbmVkKQ0KIAkJCWNv
bnRpbnVlOw0KIA0KIAkJaWYgKGlzX2NoYWluZWQpIHsNCisJCQlpZiAoIWlzb2xfZW50ZXJlZCkg
ew0KKwkJCQl0YXNrX2lzb2xhdGlvbl9rZXJuZWxfZW50ZXIoKTsNCisJCQkJaXNvbF9lbnRlcmVk
ID0gMTsNCisJCQl9DQogCQkJaXJxID0gaXJxX2ZpbmRfbWFwcGluZyhhcm1hZGFfMzcwX3hwX21z
aV9pbm5lcl9kb21haW4sDQogCQkJCQkgICAgICAgbXNpbnIgLSBQQ0lfTVNJX0RPT1JCRUxMX1NU
QVJUKTsNCiAJCQlnZW5lcmljX2hhbmRsZV9pcnEoaXJxKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L2lycWNoaXAvaXJxLWdpYy12My5jIGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMuYw0KaW5k
ZXggY2M0NmJjMmQ2MzRiLi5iZTBlMGZmYTBmYjcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2lycWNo
aXAvaXJxLWdpYy12My5jDQorKysgYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My5jDQpAQCAt
MTgsNiArMTgsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9wZXJjcHUuaD4NCiAjaW5jbHVkZSA8bGlu
dXgvcmVmY291bnQuaD4NCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KKyNpbmNsdWRlIDxsaW51
eC9pc29sYXRpb24uaD4NCiANCiAjaW5jbHVkZSA8bGludXgvaXJxY2hpcC5oPg0KICNpbmNsdWRl
IDxsaW51eC9pcnFjaGlwL2FybS1naWMtY29tbW9uLmg+DQpAQCAtNjI5LDYgKzYzMCw4IEBAIHN0
YXRpYyBhc21saW5rYWdlIHZvaWQgX19leGNlcHRpb25faXJxX2VudHJ5IGdpY19oYW5kbGVfaXJx
KHN0cnVjdCBwdF9yZWdzICpyZWdzDQogew0KIAl1MzIgaXJxbnI7DQogDQorCXRhc2tfaXNvbGF0
aW9uX2tlcm5lbF9lbnRlcigpOw0KKw0KIAlpcnFuciA9IGdpY19yZWFkX2lhcigpOw0KIA0KIAlp
ZiAoZ2ljX3N1cHBvcnRzX25taSgpICYmDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pcnFjaGlwL2ly
cS1naWMuYyBiL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLmMNCmluZGV4IGMxN2ZhYmQ2NzQxZS4u
ZmRlNTQ3YTMxNTY2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMuYw0KKysr
IGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMuYw0KQEAgLTM1LDYgKzM1LDcgQEANCiAjaW5jbHVk
ZSA8bGludXgvaW50ZXJydXB0Lmg+DQogI2luY2x1ZGUgPGxpbnV4L3BlcmNwdS5oPg0KICNpbmNs
dWRlIDxsaW51eC9zbGFiLmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0KICNpbmNs
dWRlIDxsaW51eC9pcnFjaGlwLmg+DQogI2luY2x1ZGUgPGxpbnV4L2lycWNoaXAvY2hhaW5lZF9p
cnEuaD4NCiAjaW5jbHVkZSA8bGludXgvaXJxY2hpcC9hcm0tZ2ljLmg+DQpAQCAtMzUzLDYgKzM1
NCw4IEBAIHN0YXRpYyB2b2lkIF9fZXhjZXB0aW9uX2lycV9lbnRyeSBnaWNfaGFuZGxlX2lycShz
dHJ1Y3QgcHRfcmVncyAqcmVncykNCiAJc3RydWN0IGdpY19jaGlwX2RhdGEgKmdpYyA9ICZnaWNf
ZGF0YVswXTsNCiAJdm9pZCBfX2lvbWVtICpjcHVfYmFzZSA9IGdpY19kYXRhX2NwdV9iYXNlKGdp
Yyk7DQogDQorCXRhc2tfaXNvbGF0aW9uX2tlcm5lbF9lbnRlcigpOw0KKw0KIAlkbyB7DQogCQlp
cnFzdGF0ID0gcmVhZGxfcmVsYXhlZChjcHVfYmFzZSArIEdJQ19DUFVfSU5UQUNLKTsNCiAJCWly
cW5yID0gaXJxc3RhdCAmIEdJQ0NfSUFSX0lOVF9JRF9NQVNLOw0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvczM5MC9jaW8vY2lvLmMgYi9kcml2ZXJzL3MzOTAvY2lvL2Npby5jDQppbmRleCA2ZDcxNmRi
MmE0NmEuLmJlYWI4ODg4MWI2ZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvczM5MC9jaW8vY2lvLmMN
CisrKyBiL2RyaXZlcnMvczM5MC9jaW8vY2lvLmMNCkBAIC0yMCw2ICsyMCw3IEBADQogI2luY2x1
ZGUgPGxpbnV4L2tlcm5lbF9zdGF0Lmg+DQogI2luY2x1ZGUgPGxpbnV4L2ludGVycnVwdC5oPg0K
ICNpbmNsdWRlIDxsaW51eC9pcnEuaD4NCisjaW5jbHVkZSA8bGludXgvaXNvbGF0aW9uLmg+DQog
I2luY2x1ZGUgPGFzbS9jaW8uaD4NCiAjaW5jbHVkZSA8YXNtL2RlbGF5Lmg+DQogI2luY2x1ZGUg
PGFzbS9pcnEuaD4NCkBAIC01ODQsNiArNTg1LDggQEAgdm9pZCBjaW9fdHNjaChzdHJ1Y3Qgc3Vi
Y2hhbm5lbCAqc2NoKQ0KIAlzdHJ1Y3QgaXJiICppcmI7DQogCWludCBpcnFfY29udGV4dDsNCiAN
CisJdGFza19pc29sYXRpb25fa2VybmVsX2VudGVyKCk7DQorDQogCWlyYiA9IHRoaXNfY3B1X3B0
cigmY2lvX2lyYik7DQogCS8qIFN0b3JlIGludGVycnVwdCByZXNwb25zZSBibG9jayB0byBsb3dj
b3JlLiAqLw0KIAlpZiAodHNjaChzY2gtPnNjaGlkLCBpcmIpICE9IDApDQotLSANCjIuMjYuMg0K
DQo=
