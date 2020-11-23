Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3092C12A1
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 19:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390507AbgKWR6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:58:06 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52444 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728717AbgKWR6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:58:05 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANHskg9021571;
        Mon, 23 Nov 2020 09:57:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=HNSnwq3BAnQ302ZnxuEdNJkN9rfi2avd1wcD5vME7g4=;
 b=REg4e9yY7m/V6+LX58L7Y7C/O9qP2m+xXsASAzMGZbTHIOa6IldIXv7z9+T+1Fsm+6f9
 OF77iXnM2fyYt6OQGewpFf3MbCxDqNbXyBX/5a8eVvCWdzKa24SHVIkkH3AU+ySKMkle
 Jjhq01zggIafG7l+UW3ZrlT9Apdf1whZTk1/FHCorPGMGXvx7YIC2/WimdyqjRPZ82jk
 WDtOobR5R3XPTjq2sXzB1ZbfyZoMzUk/xrwLPW9//hQnXK+3Gl/Fi76J7Z5fWSQPBLRB
 oJciCjL731eHZ4F6FdRZmAJ7i01bCIit1R+0EKvUDa1eE2nPmNsCDOyEG8lDgHnd2AgX 1w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 34y39r6dgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 09:57:23 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:57:21 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 09:57:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSS4jWIynv3ow4UseirWsqRyNxouPFXHoa7DXf3yM8PPgYE9JffeMlx0hqNxKz+4JLUNnyY7wPRgTsrh6/CvOADC0+sQk7CIFZPJaGpyUG+ar3Vy0hhEvyEUDnmNgG9wTTUNeTZmadplD/idZc/J1+FIa7YbKSpQfLLJHutGxJDAqff7FNx+EbhDtdF23h45mq6qap7mhuZ3jT35dxbBB1FfnLlzbRPNaIcXyop1Jg9VcjW+h88cveBKw6VMvema2ZJnOLHTXVZJvTwV8AnBORSH4ARA806PTfapkFDua82l14QquSl4z6/7qw8HcrtaS0yF+/MeA1xRX8cDgwyqMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNSnwq3BAnQ302ZnxuEdNJkN9rfi2avd1wcD5vME7g4=;
 b=fzD3V63KyW2P7NOPh6rUoXP7i7RU7PFCsnbDulr4Ax4UnXNTBujn9PiaMvMpu/k4qf2i2XwWyFpADQzIsmoUZADSLr5GJNAC6lTpsSPpfSWdBDDj+uZM09BW/KWbuukqiNdHn66Rt8g/XddJrDdyOn+ecmcOC04/T2PmwbR87tIpGXI4+PWQ6dLb14PGiR/hwfoAM73Myg5Z/T9FPaR51kcO77E1KOOTRJIx4uHxEkWB7+Dka5c1Imv8MBBhbsvNT6DBXVNgRvpLh2IPIXf9lB/tltZFjSgy3C52Pu+iY0OxeLMKA+i4ElBnEEIFEc60dSo96GYCaVVepdDi+jGhig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNSnwq3BAnQ302ZnxuEdNJkN9rfi2avd1wcD5vME7g4=;
 b=g/uVQalqr4vxFXRd8dMYyGA0jb7c4EjXi99MHsUwlndQtvvfIHnzgL4x6MTGRC+oeOYfFSq3gVGw2f18PIdA5IFk4bS7STB32CdZ8+EeSWlklIoYlHjq1m+0+6AQPb+7xEFa7Kj9lswBevWEJffIaRScOMPdJInetRWp7iNchc0=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW3PR18MB3530.namprd18.prod.outlook.com (2603:10b6:303:55::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Mon, 23 Nov
 2020 17:57:20 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703%4]) with mapi id 15.20.3564.039; Mon, 23 Nov 2020
 17:57:18 +0000
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
Subject: [PATCH v5 4/9] task_isolation: Add task isolation hooks to
 arch-independent code
Thread-Topic: [PATCH v5 4/9] task_isolation: Add task isolation hooks to
 arch-independent code
Thread-Index: AQHWwcIVoVPtc0KJ9ES4lz5Mtce9+Q==
Date:   Mon, 23 Nov 2020 17:57:18 +0000
Message-ID: <ec4bacce635fed4e77ab46752d41432f270edf83.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: bbf22c39-c559-4e26-479c-08d88fd93806
x-ms-traffictypediagnostic: MW3PR18MB3530:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3530D516FB2827A7465FADCBBCFC0@MW3PR18MB3530.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r5zHGgBN6rk0BYC8zo5dgzzvLoF6x6wCmgBpkLF7VKl4BDS0EvnHeY0Yjn8jXmg+R2I28oatFpz4BEPhzGjPS04dgmhECmoyWNS7zxzvBtX5tqvUv/KRqQZDOUVQxt43aRJAlfs3KYbd/FfS7nqJa2kfk9MqX6Us4FCYROFbqDt0tdh7wRvGy/JpOEaLvIdB6GG88sNJfZp2Y2yIML+28TLV0ZrDDUUyr4965XuW86ZvT1XUCHtCRZjAnc8hIxuNjLBObu7oiYMqAEzdBTQrlfy9nQGLs3139VEydqPg3ky5yAIWu5yuaJtPj0oA/c0RoZ+AjcOALx5I5IB9R8sZag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(2906002)(2616005)(71200400001)(5660300002)(6512007)(83380400001)(110136005)(26005)(54906003)(6486002)(186003)(6506007)(36756003)(66946007)(8676002)(316002)(478600001)(8936002)(86362001)(7416002)(66476007)(66556008)(64756008)(66446008)(91956017)(76116006)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: eoKw0E7BgzlSVvx+l62a0GeA2uPmmXiNpCSZEeGT+FblCpTJS61eyeUDW3eFJW6O5nVi3TL/pUu+3luz0WSh58PlNX3FTbMi2kywvLslTwS0qTlPSSWWim1Z2S2EDeQ+QSC3hx+iIiEzmwXwptf4zngmzdCuFD3UMysZ6BFWUlqyAQ1O/qt3u4otp/jpDTVdSNueli7PXo3rEDNlhfWi5WUFno0MYoM1QFih0yiXOa0e3Q0qVnDcmXsQhAzHQteYulP5djF2s2VP9XgLGipTgzZfXsAqS8JrWAqx0gTVZiISp9U2mAo0GYStMrF5uGq7WOIxtk4APs+qYEBf2O6LafRTAfXIa0lv/AtGAJk2E6iqkvtgVHnYVY5GU8MVhXIOFhWKzlgSeTRIQ61U8gLdwwjNwpnOzE9KQcqAllm3JyVbkpzxGrl4WX/MOnb65uxaEqQMn6iO+zbC8FjQtxPEEVN/CEAoY9UCjUhvyIfdBKx0vg9Vjr59tYi3Gk7+HX1FXCqgZwBOXUd6HTTJ4CCiWxttkS0oLOZq45azwj2NTpVBljNEqb9WyNPuJZRmQpMZq+uV9jsX+Q/savjTuoYf+x6AeRggTz77/nVyBveah2BRyhTQ2hmhGd0NRyz9h7e9H6r8AUtPjScl2L77zdbki80xzBs5Erbw+FbEA4v8g3vMOm5fWIXLE7pTyTSR8fUE/xIInh3oyHX3+rkKA6bTB4kuWyoLrk9GyZ1AisGsatdXABsOW5vHk20TUEagqM/CZQUs4nE7dXBof7WC1rYBPFT51QRlaL6Jx5f9xvnN3fYnQ9RAiHiHE4Po1nvEZdYhHa17qugGI8NaukchxZGJezoT373kcyC3qTx8bfYntGm03PmXdWsuN8/GHDCa68qLVsgX39OMcE12dsH38u7idQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <2303373E2A551D43B55A2519D2C99F04@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf22c39-c559-4e26-479c-08d88fd93806
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 17:57:18.1527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +tEO1zdHbjRS2TOLmUbfG8U44gAaeEPhM8mfi1Zgu5QbLk4yr8Hute1HKD1uNngjar5U7NnVPPi01K9eVWP/xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3530
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

S2VybmVsIGVudHJ5IGFuZCBleGl0IGZ1bmN0aW9ucyBmb3IgdGFzayBpc29sYXRpb24gYXJlIGFk
ZGVkIHRvIGNvbnRleHQNCnRyYWNraW5nIGFuZCBjb21tb24gZW50cnkgcG9pbnRzLiBDb21tb24g
aGFuZGxpbmcgb2YgcGVuZGluZyB3b3JrIG9uIGV4aXQNCnRvIHVzZXJzcGFjZSBub3cgcHJvY2Vz
c2VzIGlzb2xhdGlvbiBicmVha2luZywgY2xlYW51cCBhbmQgc3RhcnQuDQoNClNpZ25lZC1vZmYt
Ynk6IENocmlzIE1ldGNhbGYgPGNtZXRjYWxmQG1lbGxhbm94LmNvbT4NClthYmVsaXRzQG1hcnZl
bGwuY29tOiBhZGFwdGVkIGZvciBrZXJuZWwgNS4xMF0NClNpZ25lZC1vZmYtYnk6IEFsZXggQmVs
aXRzIDxhYmVsaXRzQG1hcnZlbGwuY29tPg0KLS0tDQogaW5jbHVkZS9saW51eC9oYXJkaXJxLmgg
ICB8ICAyICsrDQogaW5jbHVkZS9saW51eC9zY2hlZC5oICAgICB8ICAyICsrDQoga2VybmVsL2Nv
bnRleHRfdHJhY2tpbmcuYyB8ICA1ICsrKysrDQoga2VybmVsL2VudHJ5L2NvbW1vbi5jICAgICB8
IDEwICsrKysrKysrKy0NCiBrZXJuZWwvaXJxL2lycWRlc2MuYyAgICAgIHwgIDUgKysrKysNCiA1
IGZpbGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAt
LWdpdCBhL2luY2x1ZGUvbGludXgvaGFyZGlycS5oIGIvaW5jbHVkZS9saW51eC9oYXJkaXJxLmgN
CmluZGV4IDc1NGY2N2FjNDMyNi4uYjllNjA0YWU2YTBkIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9s
aW51eC9oYXJkaXJxLmgNCisrKyBiL2luY2x1ZGUvbGludXgvaGFyZGlycS5oDQpAQCAtNyw2ICs3
LDcgQEANCiAjaW5jbHVkZSA8bGludXgvbG9ja2RlcC5oPg0KICNpbmNsdWRlIDxsaW51eC9mdHJh
Y2VfaXJxLmg+DQogI2luY2x1ZGUgPGxpbnV4L3Z0aW1lLmg+DQorI2luY2x1ZGUgPGxpbnV4L2lz
b2xhdGlvbi5oPg0KICNpbmNsdWRlIDxhc20vaGFyZGlycS5oPg0KIA0KIGV4dGVybiB2b2lkIHN5
bmNocm9uaXplX2lycSh1bnNpZ25lZCBpbnQgaXJxKTsNCkBAIC0xMTUsNiArMTE2LDcgQEAgZXh0
ZXJuIHZvaWQgcmN1X25taV9leGl0KHZvaWQpOw0KIAlkbyB7CQkJCQkJCVwNCiAJCWxvY2tkZXBf
b2ZmKCk7CQkJCQlcDQogCQlhcmNoX25taV9lbnRlcigpOwkJCQlcDQorCQl0YXNrX2lzb2xhdGlv
bl9rZXJuZWxfZW50ZXIoKTsJCQlcDQogCQlwcmludGtfbm1pX2VudGVyKCk7CQkJCVwNCiAJCUJV
R19PTihpbl9ubWkoKSA9PSBOTUlfTUFTSyk7CQkJXA0KIAkJX19wcmVlbXB0X2NvdW50X2FkZChO
TUlfT0ZGU0VUICsgSEFSRElSUV9PRkZTRVQpOwlcDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51
eC9zY2hlZC5oIGIvaW5jbHVkZS9saW51eC9zY2hlZC5oDQppbmRleCA1ZDhiMTdhYTU0NGIuLjUx
YzJkNzc0MjUwYiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvc2NoZWQuaA0KKysrIGIvaW5j
bHVkZS9saW51eC9zY2hlZC5oDQpAQCAtMzQsNiArMzQsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9y
c2VxLmg+DQogI2luY2x1ZGUgPGxpbnV4L3NlcWxvY2suaD4NCiAjaW5jbHVkZSA8bGludXgva2Nz
YW4uaD4NCisjaW5jbHVkZSA8bGludXgvaXNvbGF0aW9uLmg+DQogDQogLyogdGFza19zdHJ1Y3Qg
bWVtYmVyIHByZWRlY2xhcmF0aW9ucyAoc29ydGVkIGFscGhhYmV0aWNhbGx5KTogKi8NCiBzdHJ1
Y3QgYXVkaXRfY29udGV4dDsNCkBAIC0xNzYyLDYgKzE3NjMsNyBAQCBleHRlcm4gY2hhciAqX19n
ZXRfdGFza19jb21tKGNoYXIgKnRvLCBzaXplX3QgbGVuLCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRz
ayk7DQogI2lmZGVmIENPTkZJR19TTVANCiBzdGF0aWMgX19hbHdheXNfaW5saW5lIHZvaWQgc2No
ZWR1bGVyX2lwaSh2b2lkKQ0KIHsNCisJdGFza19pc29sYXRpb25fa2VybmVsX2VudGVyKCk7DQog
CS8qDQogCSAqIEZvbGQgVElGX05FRURfUkVTQ0hFRCBpbnRvIHRoZSBwcmVlbXB0X2NvdW50OyBh
bnlib2R5IHNldHRpbmcNCiAJICogVElGX05FRURfUkVTQ0hFRCByZW1vdGVseSAoZm9yIHRoZSBm
aXJzdCB0aW1lKSB3aWxsIGFsc28gc2VuZA0KZGlmZiAtLWdpdCBhL2tlcm5lbC9jb250ZXh0X3Ry
YWNraW5nLmMgYi9rZXJuZWwvY29udGV4dF90cmFja2luZy5jDQppbmRleCAzNmE5OGM0OGFlZGMu
LjM3OWE0OGZkMGU2NSAxMDA2NDQNCi0tLSBhL2tlcm5lbC9jb250ZXh0X3RyYWNraW5nLmMNCisr
KyBiL2tlcm5lbC9jb250ZXh0X3RyYWNraW5nLmMNCkBAIC0yMSw2ICsyMSw3IEBADQogI2luY2x1
ZGUgPGxpbnV4L2hhcmRpcnEuaD4NCiAjaW5jbHVkZSA8bGludXgvZXhwb3J0Lmg+DQogI2luY2x1
ZGUgPGxpbnV4L2twcm9iZXMuaD4NCisjaW5jbHVkZSA8bGludXgvaXNvbGF0aW9uLmg+DQogDQog
I2RlZmluZSBDUkVBVEVfVFJBQ0VfUE9JTlRTDQogI2luY2x1ZGUgPHRyYWNlL2V2ZW50cy9jb250
ZXh0X3RyYWNraW5nLmg+DQpAQCAtMTAwLDYgKzEwMSw4IEBAIHZvaWQgbm9pbnN0ciBfX2NvbnRl
eHRfdHJhY2tpbmdfZW50ZXIoZW51bSBjdHhfc3RhdGUgc3RhdGUpDQogCQlfX3RoaXNfY3B1X3dy
aXRlKGNvbnRleHRfdHJhY2tpbmcuc3RhdGUsIHN0YXRlKTsNCiAJfQ0KIAljb250ZXh0X3RyYWNr
aW5nX3JlY3Vyc2lvbl9leGl0KCk7DQorDQorCXRhc2tfaXNvbGF0aW9uX2V4aXRfdG9fdXNlcl9t
b2RlKCk7DQogfQ0KIEVYUE9SVF9TWU1CT0xfR1BMKF9fY29udGV4dF90cmFja2luZ19lbnRlcik7
DQogDQpAQCAtMTQ4LDYgKzE1MSw4IEBAIHZvaWQgbm9pbnN0ciBfX2NvbnRleHRfdHJhY2tpbmdf
ZXhpdChlbnVtIGN0eF9zdGF0ZSBzdGF0ZSkNCiAJaWYgKCFjb250ZXh0X3RyYWNraW5nX3JlY3Vy
c2lvbl9lbnRlcigpKQ0KIAkJcmV0dXJuOw0KIA0KKwl0YXNrX2lzb2xhdGlvbl9rZXJuZWxfZW50
ZXIoKTsNCisNCiAJaWYgKF9fdGhpc19jcHVfcmVhZChjb250ZXh0X3RyYWNraW5nLnN0YXRlKSA9
PSBzdGF0ZSkgew0KIAkJaWYgKF9fdGhpc19jcHVfcmVhZChjb250ZXh0X3RyYWNraW5nLmFjdGl2
ZSkpIHsNCiAJCQkvKg0KZGlmZiAtLWdpdCBhL2tlcm5lbC9lbnRyeS9jb21tb24uYyBiL2tlcm5l
bC9lbnRyeS9jb21tb24uYw0KaW5kZXggZTllMmRmM2YzZjllLi4xMGE1MjA4OTQxMDUgMTAwNjQ0
DQotLS0gYS9rZXJuZWwvZW50cnkvY29tbW9uLmMNCisrKyBiL2tlcm5lbC9lbnRyeS9jb21tb24u
Yw0KQEAgLTQsNiArNCw3IEBADQogI2luY2x1ZGUgPGxpbnV4L2VudHJ5LWNvbW1vbi5oPg0KICNp
bmNsdWRlIDxsaW51eC9saXZlcGF0Y2guaD4NCiAjaW5jbHVkZSA8bGludXgvYXVkaXQuaD4NCisj
aW5jbHVkZSA8bGludXgvaXNvbGF0aW9uLmg+DQogDQogI2RlZmluZSBDUkVBVEVfVFJBQ0VfUE9J
TlRTDQogI2luY2x1ZGUgPHRyYWNlL2V2ZW50cy9zeXNjYWxscy5oPg0KQEAgLTE4MywxMyArMTg0
LDIwIEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nIGV4aXRfdG9fdXNlcl9tb2RlX2xvb3Aoc3RydWN0
IHB0X3JlZ3MgKnJlZ3MsDQogDQogc3RhdGljIHZvaWQgZXhpdF90b191c2VyX21vZGVfcHJlcGFy
ZShzdHJ1Y3QgcHRfcmVncyAqcmVncykNCiB7DQotCXVuc2lnbmVkIGxvbmcgdGlfd29yayA9IFJF
QURfT05DRShjdXJyZW50X3RocmVhZF9pbmZvKCktPmZsYWdzKTsNCisJdW5zaWduZWQgbG9uZyB0
aV93b3JrOw0KIA0KIAlsb2NrZGVwX2Fzc2VydF9pcnFzX2Rpc2FibGVkKCk7DQogDQorCXRhc2tf
aXNvbGF0aW9uX2JlZm9yZV9wZW5kaW5nX3dvcmtfY2hlY2soKTsNCisNCisJdGlfd29yayA9IFJF
QURfT05DRShjdXJyZW50X3RocmVhZF9pbmZvKCktPmZsYWdzKTsNCisNCiAJaWYgKHVubGlrZWx5
KHRpX3dvcmsgJiBFWElUX1RPX1VTRVJfTU9ERV9XT1JLKSkNCiAJCXRpX3dvcmsgPSBleGl0X3Rv
X3VzZXJfbW9kZV9sb29wKHJlZ3MsIHRpX3dvcmspOw0KIA0KKwlpZiAodW5saWtlbHkodGlfd29y
ayAmIF9USUZfVEFTS19JU09MQVRJT04pKQ0KKwkJdGFza19pc29sYXRpb25fc3RhcnQoKTsNCisN
CiAJYXJjaF9leGl0X3RvX3VzZXJfbW9kZV9wcmVwYXJlKHJlZ3MsIHRpX3dvcmspOw0KIA0KIAkv
KiBFbnN1cmUgdGhhdCB0aGUgYWRkcmVzcyBsaW1pdCBpcyBpbnRhY3QgYW5kIG5vIGxvY2tzIGFy
ZSBoZWxkICovDQpkaWZmIC0tZ2l0IGEva2VybmVsL2lycS9pcnFkZXNjLmMgYi9rZXJuZWwvaXJx
L2lycWRlc2MuYw0KaW5kZXggMWE3NzIzNjA0Mzk5Li5iOGYwYTc1NzRmNTUgMTAwNjQ0DQotLS0g
YS9rZXJuZWwvaXJxL2lycWRlc2MuYw0KKysrIGIva2VybmVsL2lycS9pcnFkZXNjLmMNCkBAIC0x
Niw2ICsxNiw3IEBADQogI2luY2x1ZGUgPGxpbnV4L2JpdG1hcC5oPg0KICNpbmNsdWRlIDxsaW51
eC9pcnFkb21haW4uaD4NCiAjaW5jbHVkZSA8bGludXgvc3lzZnMuaD4NCisjaW5jbHVkZSA8bGlu
dXgvaXNvbGF0aW9uLmg+DQogDQogI2luY2x1ZGUgImludGVybmFscy5oIg0KIA0KQEAgLTY2OSw2
ICs2NzAsOCBAQCBpbnQgX19oYW5kbGVfZG9tYWluX2lycShzdHJ1Y3QgaXJxX2RvbWFpbiAqZG9t
YWluLCB1bnNpZ25lZCBpbnQgaHdpcnEsDQogCXVuc2lnbmVkIGludCBpcnEgPSBod2lycTsNCiAJ
aW50IHJldCA9IDA7DQogDQorCXRhc2tfaXNvbGF0aW9uX2tlcm5lbF9lbnRlcigpOw0KKw0KIAlp
cnFfZW50ZXIoKTsNCiANCiAjaWZkZWYgQ09ORklHX0lSUV9ET01BSU4NCkBAIC03MTAsNiArNzEz
LDggQEAgaW50IGhhbmRsZV9kb21haW5fbm1pKHN0cnVjdCBpcnFfZG9tYWluICpkb21haW4sIHVu
c2lnbmVkIGludCBod2lycSwNCiAJdW5zaWduZWQgaW50IGlycTsNCiAJaW50IHJldCA9IDA7DQog
DQorCXRhc2tfaXNvbGF0aW9uX2tlcm5lbF9lbnRlcigpOw0KKw0KIAkvKg0KIAkgKiBOTUkgY29u
dGV4dCBuZWVkcyB0byBiZSBzZXR1cCBlYXJsaWVyIGluIG9yZGVyIHRvIGRlYWwgd2l0aCB0cmFj
aW5nLg0KIAkgKi8NCi0tIA0KMi4yMC4xDQoNCg==
