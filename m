Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF1381A36C7
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgDIPRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:17:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21720 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727986AbgDIPRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:17:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 039FFWBC014747;
        Thu, 9 Apr 2020 08:16:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=P/QdfP55QYWG5XptPDCRiJ1xixBQnz+wRP0fE4vTmHY=;
 b=sUp3r0bIO5hScSiL0TcnvoiHNLaTnxqALnZPiXMQY2VU6Ia9zIVFxebwcn1i65lg3/nH
 E/2qNshFC/GQS7k7+/TY6NrveMNZ/dbF3sEN3ZQhZWmgyHKKJo5EZ8DqvE1aqkSztDXb
 OWHzyDQ9IVa6KHpqHrld/n174lQl1ZVXeJ7kRd0OlTH93QP0poYLNjbWm95QTmrHkv6E
 EZDs6ek6vN+wDSo9GP8GDGPswHAQOZ08GbaQfx8/GJLv5lEvaBnC+BmfuFRMzdVcpB/g
 bKMzZdd/UqQQkHDRYwm35fnI+aJ88MWcwSJLwq54hrsQi9p3eRCNwPMGSEt6RuQCYKkG 3A== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3091jwh05s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 08:16:45 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:16:44 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.55) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 9 Apr 2020 08:16:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsnOIk35nrprwRoCPBsZQQPqYwHKEurGuyF/3ae9CoxkOlmAu6sqB7LmTluL+EZERCaVL+0P9Rqi9Sl72/rXlpcWztx0zqGYWbKp7nDKGTAh4qZ9OGkyTQ6kIR8uMh8p8fEtt2ZQkgCjm1Ml7qtnL8F7W43bXZVZMqZh+f+n3/Ucct9oBszjLq6sR+k0FJyQ5vKgPAHLdTuuGqrK40g9V3Iho9nCy7/H9CiQOsGB26/zIzYKQYdkebWur9Vw9md99u5eJtK0pkS7WAkHMYrHqUim1FAkKIBauJWOUWhX530HPQb3R4n+39GrzI3Ha0MuRpWB/FvEQNKRZ0GRidHruQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/QdfP55QYWG5XptPDCRiJ1xixBQnz+wRP0fE4vTmHY=;
 b=QJuPQJ1U4+mBYkOiNJrxwXAI7O3AYoygCGb3K14xnvhZxv55TcONjwkmuTKOqygdMAgNAt3hKV4YVo2CG/3JpAH917Jp6pMixedpaacYQwYl4W4d6vMS6gEr381p3RNi+zz0RK5Wz/1aQKhcAC2ZOFkjPMbVF24iWLsY8GW45BPg451w91z3HrthELpNYBKvCsRDP8/sT54p25ABjYy8fuHZQYhttE5tXjyMmpyB/oud6Hc1d/WIsQHU6k+3sCQY5NilCbkJwZCEadJ/+h8d15o8Gybdj/wDtVsvVSqDTOJ0LUm/0Clh+y7LuKTUh6JWIVBUvLGbRU8yuxmCfgXLAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/QdfP55QYWG5XptPDCRiJ1xixBQnz+wRP0fE4vTmHY=;
 b=Qtb0JMnWhJPvc0ry72i7ykbiPNn9qXtIqfAC+rLbzWr0b585oXY2dRVW+mMgDA7Tqy/q8jrsuNTl8mbGvlSLfUSDksbdO2RBDbFeCA6rI6v7QCaONmGDrOulsNUyjKGHIghaSaunqQIZd1nQ+sE2zzLxKrrXKS4EtEfE+cQNIUw=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2616.namprd18.prod.outlook.com (2603:10b6:a03:13c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.19; Thu, 9 Apr
 2020 15:16:42 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280%3]) with mapi id 15.20.2878.022; Thu, 9 Apr 2020
 15:16:42 +0000
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
Subject: [PATCH 02/13] task_isolation: vmstat: add vmstat_idle function
Thread-Topic: [PATCH 02/13] task_isolation: vmstat: add vmstat_idle function
Thread-Index: AQHWDoHfkpuEbVFPn02f+uWSy0xqog==
Date:   Thu, 9 Apr 2020 15:16:42 +0000
Message-ID: <6b3631e4543e467b6261f7a4bf0792d6f86eafc7.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: a53c63b6-40b1-40c9-2b77-08d7dc990282
x-ms-traffictypediagnostic: BYAPR18MB2616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB261621C1E2CADC3B6D1D0FD0BCC10@BYAPR18MB2616.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2535.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(7416002)(8676002)(5660300002)(26005)(71200400001)(2616005)(6486002)(6506007)(86362001)(2906002)(186003)(81156014)(64756008)(4326008)(316002)(6512007)(66946007)(81166007)(76116006)(66476007)(66446008)(478600001)(8936002)(54906003)(110136005)(36756003)(66556008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QjxweUkuXp/ZshR6xy6o4DYotktxOEFmsODwQKeGHfo+rUkO1EjFxsw4A5hHfL/8mAMETU5XhdznmGFRuvPhgGWZaAjdWcK8cV43JiUP+sfgj3vy0EAjYAy56bSJ0J2vQVmE32SM4HD95bDFDVtoKJursaPG7BLD5d7wNqxAQiWTvCRNtOfIP9Dh2VDYz7J8oI7FS2jnlf4CgP32XDu3fkSj/Zx2G7eSqqo7+vY3P1Nx+xVzgvs9IVW0Kzbj8FQ8ZTQB0IhIlDxNlWjpqG+VGtUaOqcSPj5MwccUuLS0O2O4pbDtp5k5OLz8jT5PlwHZRmcCETB1IWgPoURIiohISTiA3lny8gZ45LQPXN5Cer91RHToKy0O1w7zWiOiFWRPs2zQ1+XVUl4ya9HiRVBHoIo7KcLJCdkehfLLy0AXhDlSQN99VmHXiclz7YYFwtvC
x-ms-exchange-antispam-messagedata: +fmh8wJONgk5aIB5lyoWnYAYcdby1Xnftvcgw3LGZvG64aKRZk+SbSF740SPEjgZiBahW6AKeYRMCc+NP2Hlcc1Y4V9qVdptP1qNg9X1YRnBtlZBWVMPWeOZ/CNcdOifFHc6ygYVOfMevSU/HgRPdA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <56A6499FF35C8548BB3097BDC4A1FF84@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a53c63b6-40b1-40c9-2b77-08d7dc990282
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 15:16:42.4387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HQpdoAq+oCceNbT/WvBlENAVb/q8aPTQnJOZzyrKQ4kCYguiLJ+rs85VEaKOt2qGSu0fAcCdxRX6O/stToMErg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2616
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_05:2020-04-07,2020-04-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBmdW5jdGlvbiBjaGVja3MgdG8gc2VlIGlmIGEgdm1zdGF0IHdvcmtlciBpcyBub3QgcnVu
bmluZywNCmFuZCB0aGUgdm1zdGF0IGRpZmZzIGRvbid0IHJlcXVpcmUgYW4gdXBkYXRlLiAgVGhl
IGZ1bmN0aW9uIGlzDQpjYWxsZWQgZnJvbSB0aGUgdGFzay1pc29sYXRpb24gY29kZSB0byBzZWUg
aWYgd2UgbmVlZCB0bw0KYWN0dWFsbHkgZG8gc29tZSB3b3JrIHRvIHF1aWV0IHZtc3RhdC4NCg0K
U2lnbmVkLW9mZi1ieTogQ2hyaXMgTWV0Y2FsZiA8Y21ldGNhbGZAbWVsbGFub3guY29tPg0KU2ln
bmVkLW9mZi1ieTogQWxleCBCZWxpdHMgPGFiZWxpdHNAbWFydmVsbC5jb20+DQotLS0NCiBpbmNs
dWRlL2xpbnV4L3Ztc3RhdC5oIHwgIDIgKysNCiBtbS92bXN0YXQuYyAgICAgICAgICAgIHwgMTAg
KysrKysrKysrKw0KIDIgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0t
Z2l0IGEvaW5jbHVkZS9saW51eC92bXN0YXQuaCBiL2luY2x1ZGUvbGludXgvdm1zdGF0LmgNCmlu
ZGV4IDJiYzVlODVmMjUxNC4uNjZkOWFlMzJjZjA3IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51
eC92bXN0YXQuaA0KKysrIGIvaW5jbHVkZS9saW51eC92bXN0YXQuaA0KQEAgLTI3MSw2ICsyNzEs
NyBAQCBleHRlcm4gdm9pZCBfX2RlY19ub2RlX3N0YXRlKHN0cnVjdCBwZ2xpc3RfZGF0YSAqLCBl
bnVtIG5vZGVfc3RhdF9pdGVtKTsNCiANCiB2b2lkIHF1aWV0X3Ztc3RhdCh2b2lkKTsNCiB2b2lk
IHF1aWV0X3Ztc3RhdF9zeW5jKHZvaWQpOw0KK2Jvb2wgdm1zdGF0X2lkbGUodm9pZCk7DQogdm9p
ZCBjcHVfdm1fc3RhdHNfZm9sZChpbnQgY3B1KTsNCiB2b2lkIHJlZnJlc2hfem9uZV9zdGF0X3Ro
cmVzaG9sZHModm9pZCk7DQogDQpAQCAtMzc0LDYgKzM3NSw3IEBAIHN0YXRpYyBpbmxpbmUgdm9p
ZCByZWZyZXNoX3pvbmVfc3RhdF90aHJlc2hvbGRzKHZvaWQpIHsgfQ0KIHN0YXRpYyBpbmxpbmUg
dm9pZCBjcHVfdm1fc3RhdHNfZm9sZChpbnQgY3B1KSB7IH0NCiBzdGF0aWMgaW5saW5lIHZvaWQg
cXVpZXRfdm1zdGF0KHZvaWQpIHsgfQ0KIHN0YXRpYyBpbmxpbmUgdm9pZCBxdWlldF92bXN0YXRf
c3luYyh2b2lkKSB7IH0NCitzdGF0aWMgaW5saW5lIGJvb2wgdm1zdGF0X2lkbGUodm9pZCkgeyBy
ZXR1cm4gdHJ1ZTsgfQ0KIA0KIHN0YXRpYyBpbmxpbmUgdm9pZCBkcmFpbl96b25lc3RhdChzdHJ1
Y3Qgem9uZSAqem9uZSwNCiAJCQlzdHJ1Y3QgcGVyX2NwdV9wYWdlc2V0ICpwc2V0KSB7IH0NCmRp
ZmYgLS1naXQgYS9tbS92bXN0YXQuYyBiL21tL3Ztc3RhdC5jDQppbmRleCAxZmEwYjJkMDRhZmEu
LjVjNGFlYzY1MTA2MiAxMDA2NDQNCi0tLSBhL21tL3Ztc3RhdC5jDQorKysgYi9tbS92bXN0YXQu
Yw0KQEAgLTE4NzksNiArMTg3OSwxNiBAQCB2b2lkIHF1aWV0X3Ztc3RhdF9zeW5jKHZvaWQpDQog
CXJlZnJlc2hfY3B1X3ZtX3N0YXRzKGZhbHNlKTsNCiB9DQogDQorLyoNCisgKiBSZXBvcnQgb24g
d2hldGhlciB2bXN0YXQgcHJvY2Vzc2luZyBpcyBxdWllc2NlZCBvbiB0aGUgY29yZSBjdXJyZW50
bHk6DQorICogbm8gdm1zdGF0IHdvcmtlciBydW5uaW5nIGFuZCBubyB2bXN0YXQgdXBkYXRlcyB0
byBwZXJmb3JtLg0KKyAqLw0KK2Jvb2wgdm1zdGF0X2lkbGUodm9pZCkNCit7DQorCXJldHVybiAh
ZGVsYXllZF93b3JrX3BlbmRpbmcodGhpc19jcHVfcHRyKCZ2bXN0YXRfd29yaykpICYmDQorCQkh
bmVlZF91cGRhdGUoc21wX3Byb2Nlc3Nvcl9pZCgpKTsNCit9DQorDQogLyoNCiAgKiBTaGVwaGVy
ZCB3b3JrZXIgdGhyZWFkIHRoYXQgY2hlY2tzIHRoZQ0KICAqIGRpZmZlcmVudGlhbHMgb2YgcHJv
Y2Vzc29ycyB0aGF0IGhhdmUgdGhlaXIgd29ya2VyDQotLSANCjIuMjAuMQ0KDQo=
