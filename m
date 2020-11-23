Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183792C1298
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 19:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390484AbgKWR5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:57:07 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4366 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390464AbgKWR5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:57:07 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANHteWq032523;
        Mon, 23 Nov 2020 09:56:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=q+mezuTzgLgTkL4t+dz/4pR2SMeorDqyG2uWP3LYDUw=;
 b=McX3ZCTlxlzhcdoZkRTWVg8gNbqWQK31s8fM34jMFigGk58PoZahNP2psKPBXUTTcnuf
 bFOrrbBmHpshSRNuH71cBKBRQB8y+QdUPxefEq+W7RHOzw+G3sgeQUkdPC6kPIBiyjc+
 U+YscLg5ye+AAZ+mrhi8xKfuQE17mnFG+rzeMDJnJORng3R1ojxoJdyaNGu6tJfQeoug
 M9A7gMqq6Pquya5cVAIeCQfqc7kLT16M52shBUKTXQgfVqpK/MtZ+BcEl85ew/ShSJmW
 tDexlEsDgJXt+6A71+vjmMKFVpXfxSVoLaHLReJRgm5U3PRWlAldpIrxMaM6ALfzXhV6 lw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 34y14u6tut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 09:56:24 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:56:23 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 09:56:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Av2cxbm7/wyadtuE+JqKotc5Uz+C8Y10+ZXqQLxa/1x1AOHGz3BEwulrwKwq1ACKy80pGMssVIfWNA3j7INX+NLrqx7KtgqfuC3C+iPctz5P1ggzfxhlYn+F0J+F92FAn6MNQogg64oLeuKBig53HrHt/I3YVhf3orTaHOPrDtwaDQLxWPl6gi1vb7/QmXVVRpZQFIjYUNn7TR/1xs/6IEx8EJFvPuhf68d1H/KE83jpY4vxoVSaUTOLGQCUvG+xiZOZahf5U5lYZ2Z4g8S9yozAxSkEVRaoRXFlxkQjjUPHEI3fHOA+uWgAx34NKqeLL6MXIeBvXc6p65mjIGHYcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+mezuTzgLgTkL4t+dz/4pR2SMeorDqyG2uWP3LYDUw=;
 b=KI5IhuLt4jOrlf/v49l5cCx0eo3lW3TKN2bmA85jFO2jz+l4CNlj9ZU53DqhMxNFcAnuDPTdo+FOmKqfPN880tqD8Mu9pD/7RNfdn64dGxfciegWgxxd+3VvP+1dFxvd7XvPhbmFG2sgLjwtCUX1NeAfIWUtoO0NG+eYwTCqUBIAEyDhn+iCAWyfVe+++woX2jUqsH7PvvaaK4niL64de/tTElialzrSZY6DzQz051yBPh42DfprSzgjflCbncLI40mEydUO3nPHnVgppnPFrqpeLj9qk6VtNxMoUNj5ISuqh/sQa7zEsi8+1hX1fpbl0YCVFcQde1sJUCX8E2kACw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+mezuTzgLgTkL4t+dz/4pR2SMeorDqyG2uWP3LYDUw=;
 b=GqU8KpzX2DQuRBDK9d/fQfHt38Yw1ASW0+IXSAk0ro2SWJGQgFgQX+RmL3HhVKoZxcpuQ9VJqicRWk57lVWBOpsJcs0o/dLWgk1jULO+wvQp89kxp9rLIZbAI51hgIRKcXEBWMDpZEVJMQBe4o5NLs2WkP1aUME6JQWrrMPae74=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by CO6PR18MB3954.namprd18.prod.outlook.com (2603:10b6:5:34d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Mon, 23 Nov
 2020 17:56:22 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703%4]) with mapi id 15.20.3564.039; Mon, 23 Nov 2020
 17:56:22 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "nitesh@redhat.com" <nitesh@redhat.com>,
        "frederic@kernel.org" <frederic@kernel.org>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH v5 2/9] task_isolation: vmstat: add vmstat_idle function
Thread-Topic: [PATCH v5 2/9] task_isolation: vmstat: add vmstat_idle function
Thread-Index: AQHWwcH0WzY0i0qVVUKJ5jpW2camEQ==
Date:   Mon, 23 Nov 2020 17:56:22 +0000
Message-ID: <6ac7143e5038614e3950636456cef67b5bc0c9e4.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
In-Reply-To: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb56586a-20f3-4f14-8455-08d88fd916fa
x-ms-traffictypediagnostic: CO6PR18MB3954:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3954D542E9FA87064684163BBCFC0@CO6PR18MB3954.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iC46aZQXsW84tTGGPEAR0wY7aGRsc9zS5hS8jZCvYC2GH5EVLqFFPWuYE/hcGY9RTGDMgXBfvok6NTB0RHC6O+LRojFyoVvjeNTiCDgJiKtekJ9jJa3jZsIoXkbBMbiBRrB1VWfasgpv4YGCuBhFuXc5yjjyWEpT1KQ3KoLC11sEboDt/UrJiSV+we3zmxeW1gQkbGocL8thw/V1DQPSVkdr/ZU4RgCR5ir2uEz5KI/N4Vru0AuhpwDGc0O9JBNyf3LmwxL93AFgpSBr+CB5n4Ch056rfPuEbLNv26sWZXV5WCk/wIIJif2+mE7dm99lyBilc34r9Fr1nFJH+xYRwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(2906002)(6506007)(6512007)(64756008)(8676002)(66476007)(66446008)(66556008)(7416002)(6486002)(4326008)(8936002)(71200400001)(26005)(36756003)(2616005)(478600001)(54906003)(66946007)(86362001)(5660300002)(316002)(76116006)(83380400001)(91956017)(186003)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: fTcOVmxDyvg2KsMbgTCkSVkpAVbzlpUDLEcHZeN3Uv9oRChomFWyPtxPi6/p2KWPPMi1RTOZ+nuq8/9kKkEBWaxv/+0DIZdW7LsJQ6g2j3wpCzMmJTmyvlyMVqPrARKAh2Kq9zk4G0TCxKak03YGu0ZdgGSfdNl2eaFo8xWDpuamz4ipIbNt5XEL0rqwkY1BO+7Ix8/jAXjbe3XUYX/Fdr0F1PclSo9Ec/RKIW6k1aL5ePU9zCn4ipjza+vmUttK2URprw35kTFObuA5anGiCLlENwHUQcjPRLu4ATjRIWxu0Wcywbyq8emXk/4hovV06Mw4FWrnCdLVs/0CchH5U9Gvcfu9dtRKgjzM3r4AhhUoYAvbWYNZH3NSTVstcHlCQU21XaqtEpBw9WAi94GGgzV8ry47xKE+mSWJ8dhjogq1OsAdzhhiKEFocIAfwvTLF/Pc7ctUKBY/zoOqeEdT3b67W3m+4gSbmaBAxtosgFDywZeEKl0D8b4O54WmbJ6ZvKzxIusJdrwPLtCX9acBTGwpWWdHvIUJUXIWnJx8FL4oXAhxiYGGFVLztQNLMqwYUCaOk8ZtPMg6HC60NyR/5Vb/nyxxUgTxlemWVzymrPMLNm3X/GeS6278z8rdV0bGAvtdvKD12T4dzvLTNEaibGEmtvqOIRuwftUezfev9TKewwkMxBPi1FHetAbNNBzPZbJ399n7+DxJuS5svGFuAERKNeCXtfaASymyOpxiH8S33w3suv/GwRfPQDYV85qBg23xhK/7sB1yj/A0P7LfLxKtTy1+wuyiYhB311SPLRA2Zgrtnau+hOAs8xApU6gM7fOz62zgoHeLW6WNpbSyvn6BSiTn/2T5UdmvQfgtWCieoZ+wTeo3ilZ8a8RDKcz9NzXFMX/+w76OnRUK2dcjnA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E079E53BC0AE046828BEDFA6A41E3AA@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb56586a-20f3-4f14-8455-08d88fd916fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 17:56:22.7008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vTaf1fFIh1Wzq5+NwrpSPp83djATvtNv+yydeGSuAqletBkNda1I76fl/mCHqSdwABqny/m/YS+3d6Caypf6pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3954
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXMgTWV0Y2FsZiA8Y21ldGNhbGZAbWVsbGFub3guY29tPg0KDQpUaGlzIGZ1bmN0
aW9uIGNoZWNrcyB0byBzZWUgaWYgYSB2bXN0YXQgd29ya2VyIGlzIG5vdCBydW5uaW5nLA0KYW5k
IHRoZSB2bXN0YXQgZGlmZnMgZG9uJ3QgcmVxdWlyZSBhbiB1cGRhdGUuICBUaGUgZnVuY3Rpb24g
aXMNCmNhbGxlZCBmcm9tIHRoZSB0YXNrLWlzb2xhdGlvbiBjb2RlIHRvIHNlZSBpZiB3ZSBuZWVk
IHRvDQphY3R1YWxseSBkbyBzb21lIHdvcmsgdG8gcXVpZXQgdm1zdGF0Lg0KDQpTaWduZWQtb2Zm
LWJ5OiBDaHJpcyBNZXRjYWxmIDxjbWV0Y2FsZkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5
OiBBbGV4IEJlbGl0cyA8YWJlbGl0c0BtYXJ2ZWxsLmNvbT4NCi0tLQ0KIGluY2x1ZGUvbGludXgv
dm1zdGF0LmggfCAgMiArKw0KIG1tL3Ztc3RhdC5jICAgICAgICAgICAgfCAxMCArKysrKysrKysr
DQogMiBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L3Ztc3RhdC5oIGIvaW5jbHVkZS9saW51eC92bXN0YXQuaA0KaW5kZXggMzAwY2U2
NjQ4OTIzLi4yNDM5MmE5NTdjZmMgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3Ztc3RhdC5o
DQorKysgYi9pbmNsdWRlL2xpbnV4L3Ztc3RhdC5oDQpAQCAtMjg1LDYgKzI4NSw3IEBAIGV4dGVy
biB2b2lkIF9fZGVjX25vZGVfc3RhdGUoc3RydWN0IHBnbGlzdF9kYXRhICosIGVudW0gbm9kZV9z
dGF0X2l0ZW0pOw0KIA0KIHZvaWQgcXVpZXRfdm1zdGF0KHZvaWQpOw0KIHZvaWQgcXVpZXRfdm1z
dGF0X3N5bmModm9pZCk7DQorYm9vbCB2bXN0YXRfaWRsZSh2b2lkKTsNCiB2b2lkIGNwdV92bV9z
dGF0c19mb2xkKGludCBjcHUpOw0KIHZvaWQgcmVmcmVzaF96b25lX3N0YXRfdGhyZXNob2xkcyh2
b2lkKTsNCiANCkBAIC0zOTMsNiArMzk0LDcgQEAgc3RhdGljIGlubGluZSB2b2lkIHJlZnJlc2hf
em9uZV9zdGF0X3RocmVzaG9sZHModm9pZCkgeyB9DQogc3RhdGljIGlubGluZSB2b2lkIGNwdV92
bV9zdGF0c19mb2xkKGludCBjcHUpIHsgfQ0KIHN0YXRpYyBpbmxpbmUgdm9pZCBxdWlldF92bXN0
YXQodm9pZCkgeyB9DQogc3RhdGljIGlubGluZSB2b2lkIHF1aWV0X3Ztc3RhdF9zeW5jKHZvaWQp
IHsgfQ0KK3N0YXRpYyBpbmxpbmUgYm9vbCB2bXN0YXRfaWRsZSh2b2lkKSB7IHJldHVybiB0cnVl
OyB9DQogDQogc3RhdGljIGlubGluZSB2b2lkIGRyYWluX3pvbmVzdGF0KHN0cnVjdCB6b25lICp6
b25lLA0KIAkJCXN0cnVjdCBwZXJfY3B1X3BhZ2VzZXQgKnBzZXQpIHsgfQ0KZGlmZiAtLWdpdCBh
L21tL3Ztc3RhdC5jIGIvbW0vdm1zdGF0LmMNCmluZGV4IDQzOTk5Y2FmNDdhNC4uNWIwYWQ3ZWQ2
NWY3IDEwMDY0NA0KLS0tIGEvbW0vdm1zdGF0LmMNCisrKyBiL21tL3Ztc3RhdC5jDQpAQCAtMTk0
NSw2ICsxOTQ1LDE2IEBAIHZvaWQgcXVpZXRfdm1zdGF0X3N5bmModm9pZCkNCiAJcmVmcmVzaF9j
cHVfdm1fc3RhdHMoZmFsc2UpOw0KIH0NCiANCisvKg0KKyAqIFJlcG9ydCBvbiB3aGV0aGVyIHZt
c3RhdCBwcm9jZXNzaW5nIGlzIHF1aWVzY2VkIG9uIHRoZSBjb3JlIGN1cnJlbnRseToNCisgKiBu
byB2bXN0YXQgd29ya2VyIHJ1bm5pbmcgYW5kIG5vIHZtc3RhdCB1cGRhdGVzIHRvIHBlcmZvcm0u
DQorICovDQorYm9vbCB2bXN0YXRfaWRsZSh2b2lkKQ0KK3sNCisJcmV0dXJuICFkZWxheWVkX3dv
cmtfcGVuZGluZyh0aGlzX2NwdV9wdHIoJnZtc3RhdF93b3JrKSkgJiYNCisJCSFuZWVkX3VwZGF0
ZShzbXBfcHJvY2Vzc29yX2lkKCkpOw0KK30NCisNCiAvKg0KICAqIFNoZXBoZXJkIHdvcmtlciB0
aHJlYWQgdGhhdCBjaGVja3MgdGhlDQogICogZGlmZmVyZW50aWFscyBvZiBwcm9jZXNzb3JzIHRo
YXQgaGF2ZSB0aGVpciB3b3JrZXINCi0tIA0KMi4yMC4xDQoNCg==
