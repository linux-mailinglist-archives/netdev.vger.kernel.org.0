Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6652C12A7
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 19:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390524AbgKWR62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:58:28 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57330 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390442AbgKWR61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:58:27 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANHtsnQ032585;
        Mon, 23 Nov 2020 09:57:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=ZsVGrf96RQZC2gJ3j4omQY4A3uR1ZqJF3Li3cBFxpiA=;
 b=i6R4a19bSrjS23VdfN6af2/g2McSsGsc3qY7nC4vg5UGxoMU4GpoFqytEG042dNueq8o
 NiX3EkYiPIzUtiKrzUwH4DMD/Q4afnlrRqknzZDZ/g65gQ4Wy2cSatmkOqqJr4b8uR8t
 WUPqtQ3XMwN7CJECNbR6CNqh6ncffxdBUOzvXaO7Gh7dFXLL6a1oN9zMIWhDi74UiVYf
 Sg37NpXecW/kfWUkYWeHDXhB//LEKz3P41yy4cvZr2AevgAcp5yNfg60wLCsI/pp01/H
 IK9fj1OClJ8LAivXIyZGodH8CqRDWTSGnwvtYaxsRmeSGXmFaYQwjTeSQ7zhKNEMOXE5 LA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 34y14u6tyw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 09:57:45 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:57:44 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 09:57:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBfML/BzAdDDVOmR5W2tEL1SVOMADQUrOgAheS7eTVNm6q0TA5Szp54pdPAFb8HSad4EIB49opeYX2XO7jRVsAqT9IKZUhp19QQX6oUiTKKUMjwoZ3VeH4eBQiJd62fmDt6YEFRdjj2anQteMTUFSwKafF1Mnq0UB4FJZKOQe2HgsQzqN7Tb2DEQ2emgXOawRwsITQ6ssPAuuBDTzyY/C1JtHDIswKZrvRTr3yorVvsosA6BdpIZsTuvUgkypkkIGMC4Wye10OOwTLyHyPk39Pr56n/DLf2l1HhkdQJJKs+m/e7yhsq48HSpeJmEF0XJir21dIpLnbGPR6R/lsGuVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsVGrf96RQZC2gJ3j4omQY4A3uR1ZqJF3Li3cBFxpiA=;
 b=DL5G5XNvZHqdUwdflqrgOUwv5Xk8ymgSVZie7d1kpduQBbeAisD5si5lwONkcheYOEl+jNzSa5IaiytAZmyBYh9q2sj0Adqn2pzisXb+MzNlERTWwdR8yD8aMhtjJpwihwG0QWCRIn/gpJe89xvkWmmznSqvAlMs4y0Jbbu4Dld2lrTEZ/XjsWyHPt0XUrfV8OsI6VQYtb+aEwUZPwAL9BsxNgxQOPhpqkW1SmMKh35XUKJ+P+1ZHfAno2q9uGZW6IVX59oXZHC2gMxkEZVUjRVyrVKv4dCXVL2coIy9Oy9Z41aiEeePFoVVaiX2X1Kv6PRIx3mOEV6GwEG4DvrrXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsVGrf96RQZC2gJ3j4omQY4A3uR1ZqJF3Li3cBFxpiA=;
 b=mlLJQs0LTu88LU1d6eaIFip4Uph09Bss7YakCaz+5szVeOBHamw4GSFJbKfJhkaP99GYb9zRpYKkGEmZmbt7MWtzvfraaNFp6Cr7+IAGKPaj3SpirCoDeibdahhX+/gKairHFVEEJlZ8LiDB8a+phHGW1XMm98EN/SorsgxnBJo=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW3PR18MB3530.namprd18.prod.outlook.com (2603:10b6:303:55::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Mon, 23 Nov
 2020 17:57:43 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703%4]) with mapi id 15.20.3564.039; Mon, 23 Nov 2020
 17:57:43 +0000
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
Subject: [PATCH v5 5/9] task_isolation: Add driver-specific hooks
Thread-Topic: [PATCH v5 5/9] task_isolation: Add driver-specific hooks
Thread-Index: AQHWwcIjLJ3XhCtZ4UCn5Rp0YgDpdQ==
Date:   Mon, 23 Nov 2020 17:57:42 +0000
Message-ID: <6e15fde56203f89ebab0565dc22177f42063ae7c.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: 97615725-7978-467b-5bf9-08d88fd946b9
x-ms-traffictypediagnostic: MW3PR18MB3530:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB353014825D8C8C11224F6A67BCFC0@MW3PR18MB3530.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IqZH+V28Y+39eM63y9yPGzz58EwE1gqJMAPAihDdMV7ILV4T4+pzHmR0tS+HNiv6aqA9GwVX0wBnUD+YHAvsXN7hv/hw+SA5XxJUunvShzgI99+GYQNftOzGceodwpR6CksoCGr4zST4em4tMK/KlFYN7R/j99VxkuiCnbmzbCcDOJaWzehRZ6fSChF+55rI33+CW8vHdSC4EHcx0TYz25CkLmxDqCjOhUUhhySuM0AFbKqckcIPcV8kkArIdBkoPnSaLawPYKNqKuoOzvpVyHkia9URj1ICHcC/pcIy3zbeIjEgvmuC9pjuck1XpOXU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(2906002)(2616005)(71200400001)(5660300002)(6512007)(83380400001)(110136005)(26005)(54906003)(6486002)(186003)(6506007)(36756003)(66946007)(8676002)(316002)(478600001)(8936002)(86362001)(7416002)(66476007)(66556008)(64756008)(66446008)(91956017)(76116006)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3elDcvQibqAkHgBF6TTWWiEMZfiJIQh6SlSwvFJUJvI1GmLahDjkrPiw3MmeT/igzsrsOVfjJHSV3DZul9ixvWLuPoYJMAGlmk5OgtQVru/IxlqRajyuneW+BgVR4C2k/m2+qx4V9CUCg9eS/xwXcqMuLc4y3kLQNzeeWgtx/JrcFQzFNJRFqMySxLP2O5jV8MUB+0xSrdUOwYH9o7jHopJhJEq8v+mFpZPmlcI/SM9Kzzn5Kt6jfiGzm3yYlDfBoKjZPeMXQR/JlD1pArCKpmKgbC+VdgNFQguH5S21vn4dR/NO9ra4rhlCWz/Jqm5VQTkRhJyYuhl1ROc3vISJEKAAHKvoyo8yF479i1Jk0gMwvF1FaWDZvPJb8vHNcC52lwaDGTFnL6qkWWL0N94dwTZ2k6t4+wGJ//CClapiCpoWo3qjIixlskvoId1rMsJgxw0LFnRVOn11+YOZudxg6ti3pQ2qNIKvtToMYKfEeihGS09sUeeFGndPzbHD5i9a5IqX1oefWGzsj1F6la2OfL7qv6aT98ULKdyVGnsAeLl913qrlP9S6M9InTjsVC7aau6ox+D2GAJu6Y6WYVdvUwrvKs4gL0r2MxumNBG7vPS8/VzOP6+63yoXY3O5qtwbTdJUzdeIT1suyIS6i8jt4zERWtT3MN0FEEtwDm7aIxToRcUtwwkOP7jwS5QuHEzF+2qnlOWyICAodsDaOoFRCCP4oo8Frt+k2trzn4cE/brnxeMNi9HrLm/fdjux0ouKLdxdsPf18sr9Hcwqa3eDpDfPddQ3fLMqwbmnI0Y3Wfe9aJbE+txiB1qGP37Bw3Kdnz+DMayuhQTN+LA4hzc7stYijx2MW+54gKBFbuO6knXL8pEUi+MLwmyoXj8+VlpWMI07EU02p/TbdSkL0Lp38w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C8C0415A4BFAA41923B78D82E3BB917@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97615725-7978-467b-5bf9-08d88fd946b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 17:57:42.8194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v3ZMSJ2xPJtEQVOxFlqQA2TE/pwZdjx3y2XIbX6I5lX35cPIbrw5NDTk1/7A1q/obJS9ypZsbucQK8VGQrglQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3530
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
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
cnMvaXJxY2hpcC9pcnEtYXJtYWRhLTM3MC14cC5jDQppbmRleCBkN2ViMmU5M2RiOGYuLjRhYzdi
YWJlMWFiZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtYXJtYWRhLTM3MC14cC5j
DQorKysgYi9kcml2ZXJzL2lycWNoaXAvaXJxLWFybWFkYS0zNzAteHAuYw0KQEAgLTI5LDYgKzI5
LDcgQEANCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KICNpbmNsdWRlIDxsaW51eC9zeXNjb3Jl
X29wcy5oPg0KICNpbmNsdWRlIDxsaW51eC9tc2kuaD4NCisjaW5jbHVkZSA8bGludXgvaXNvbGF0
aW9uLmg+DQogI2luY2x1ZGUgPGFzbS9tYWNoL2FyY2guaD4NCiAjaW5jbHVkZSA8YXNtL2V4Y2Vw
dGlvbi5oPg0KICNpbmNsdWRlIDxhc20vc21wX3BsYXQuaD4NCkBAIC01NzIsNiArNTczLDcgQEAg
c3RhdGljIGNvbnN0IHN0cnVjdCBpcnFfZG9tYWluX29wcyBhcm1hZGFfMzcwX3hwX21waWNfaXJx
X29wcyA9IHsNCiBzdGF0aWMgdm9pZCBhcm1hZGFfMzcwX3hwX2hhbmRsZV9tc2lfaXJxKHN0cnVj
dCBwdF9yZWdzICpyZWdzLCBib29sIGlzX2NoYWluZWQpDQogew0KIAl1MzIgbXNpbWFzaywgbXNp
bnI7DQorCWludCBpc29sX2VudGVyZWQgPSAwOw0KIA0KIAltc2ltYXNrID0gcmVhZGxfcmVsYXhl
ZChwZXJfY3B1X2ludF9iYXNlICsNCiAJCQkJQVJNQURBXzM3MF9YUF9JTl9EUkJFTF9DQVVTRV9P
RkZTKQ0KQEAgLTU4OCw2ICs1OTAsMTAgQEAgc3RhdGljIHZvaWQgYXJtYWRhXzM3MF94cF9oYW5k
bGVfbXNpX2lycShzdHJ1Y3QgcHRfcmVncyAqcmVncywgYm9vbCBpc19jaGFpbmVkKQ0KIAkJCWNv
bnRpbnVlOw0KIA0KIAkJaWYgKGlzX2NoYWluZWQpIHsNCisJCQlpZiAoIWlzb2xfZW50ZXJlZCkg
ew0KKwkJCQl0YXNrX2lzb2xhdGlvbl9rZXJuZWxfZW50ZXIoKTsNCisJCQkJaXNvbF9lbnRlcmVk
ID0gMTsNCisJCQl9DQogCQkJaXJxID0gaXJxX2ZpbmRfbWFwcGluZyhhcm1hZGFfMzcwX3hwX21z
aV9pbm5lcl9kb21haW4sDQogCQkJCQkgICAgICAgbXNpbnIgLSBQQ0lfTVNJX0RPT1JCRUxMX1NU
QVJUKTsNCiAJCQlnZW5lcmljX2hhbmRsZV9pcnEoaXJxKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L2lycWNoaXAvaXJxLWdpYy12My5jIGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMuYw0KaW5k
ZXggMTZmZWNjMGZlYmU4Li5kZWQyNmRkNGRhMGYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2lycWNo
aXAvaXJxLWdpYy12My5jDQorKysgYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My5jDQpAQCAt
MTgsNiArMTgsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9wZXJjcHUuaD4NCiAjaW5jbHVkZSA8bGlu
dXgvcmVmY291bnQuaD4NCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KKyNpbmNsdWRlIDxsaW51
eC9pc29sYXRpb24uaD4NCiANCiAjaW5jbHVkZSA8bGludXgvaXJxY2hpcC5oPg0KICNpbmNsdWRl
IDxsaW51eC9pcnFjaGlwL2FybS1naWMtY29tbW9uLmg+DQpAQCAtNjQ2LDYgKzY0Nyw4IEBAIHN0
YXRpYyBhc21saW5rYWdlIHZvaWQgX19leGNlcHRpb25faXJxX2VudHJ5IGdpY19oYW5kbGVfaXJx
KHN0cnVjdCBwdF9yZWdzICpyZWdzDQogew0KIAl1MzIgaXJxbnI7DQogDQorCXRhc2tfaXNvbGF0
aW9uX2tlcm5lbF9lbnRlcigpOw0KKw0KIAlpcnFuciA9IGdpY19yZWFkX2lhcigpOw0KIA0KIAlp
ZiAoZ2ljX3N1cHBvcnRzX25taSgpICYmDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pcnFjaGlwL2ly
cS1naWMuYyBiL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLmMNCmluZGV4IDYwNTMyNDVhNDc1NC4u
YmI0ODJiNGFlMjE4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMuYw0KKysr
IGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMuYw0KQEAgLTM1LDYgKzM1LDcgQEANCiAjaW5jbHVk
ZSA8bGludXgvaW50ZXJydXB0Lmg+DQogI2luY2x1ZGUgPGxpbnV4L3BlcmNwdS5oPg0KICNpbmNs
dWRlIDxsaW51eC9zbGFiLmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0KICNpbmNs
dWRlIDxsaW51eC9pcnFjaGlwLmg+DQogI2luY2x1ZGUgPGxpbnV4L2lycWNoaXAvY2hhaW5lZF9p
cnEuaD4NCiAjaW5jbHVkZSA8bGludXgvaXJxY2hpcC9hcm0tZ2ljLmg+DQpAQCAtMzM3LDYgKzMz
OCw4IEBAIHN0YXRpYyB2b2lkIF9fZXhjZXB0aW9uX2lycV9lbnRyeSBnaWNfaGFuZGxlX2lycShz
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
b3JlLiAqLw0KIAlpZiAodHNjaChzY2gtPnNjaGlkLCBpcmIpICE9IDApDQotLSANCjIuMjAuMQ0K
DQo=
