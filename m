Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B542017D11E
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 04:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgCHDon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 22:44:43 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40790 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726259AbgCHDom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 22:44:42 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0283fbk1011848;
        Sat, 7 Mar 2020 19:44:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=mOmcxhcHfdvs2/ffWTPRYKAh6MJbVx4NXz+n9OW7E6A=;
 b=J/pFjUIxxIZrdncw+in5uedPYv1Zy9oC9zlPa+r40DIeGWM8KZ4WTxUGEWk3FtvinapR
 aUVQeCgGgvwucKje6c5QBBP0rvil8jKdNVwMxtUlbzhBUn5iXjS1CAEbAjWr6mjtu7jO
 HY+YpTyDBHSPTaAPo9kA2uneKtPc3f4kzgvsJpGnhu0khfMGub5EvFIR6G+m5+U8/Cf7
 NemBtfDR4ezvm40vBxnOtEwqS3HR0/QyleKCMoBd6BOmaKNTTpLYSf3CRo6mOgScIqn0
 aljJgGkbqh8silJSUjcIMjb2OxGTWHvN5rr+4ui20DbxUayFAI/GtUhg5qBer+mCm9K8 Kw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ymc0sj1e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 19:44:15 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 19:44:12 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 19:44:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqw0QOMZJuRqzCIIDZt5iygL+7Jcsh1mzV+obWsZEM6fmV9Ol8wKO6EHSbwtRepb24/hKjrbrMT2W7w5DM6vngPbU+XcnDFkT2kD5SBo0fab0Lq82gbIbnLnJPlljV6BoS6C0CVm9BGAngcK9PK5PtZmCSFQh9DJWdRX9gtQI6fXC2QxTDr8p9uvtkjoJQkP2gr5K1cV2w/UYoeS04Tq4jOmheBuUrmwxrv/C2YxQPR9msDEPJKdNbUGTQkx0XmDL3ehjdEV/C83gXV9KKEQ6qp5R/6hVFF3pHIXNkYKkwL6LDwXOp8n41ZmA2vqK3ZDfe5QK3LOfQdBSHrccObiFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOmcxhcHfdvs2/ffWTPRYKAh6MJbVx4NXz+n9OW7E6A=;
 b=kYj5sUX0e4idCLBW5O6ExKsALxWDl0mZfln5k7O7Eu3CGCXQ78zJr4N0Jcd4YGNGGs+Xb2hWXmZx1it8oaCLcFoxVznWLwpko+XqZQFWapkdAfwkInMW+IpmegrUtqoXz/ijDwtz+Gh1PU8r3XP5luYv6YXBL5CQ59nNu3Z6yeKOWN9xmPF7uW+9FPd0MdOdl42IOQybACt6RlGAwDxxYDofTlyQYCyf2gTxmUe3q0r/ZtPg9qB+h0pGV0sIk0+qRgExaWN85G06UAq6nb/SxUS0heDS2rnqr+S8mbRXgRKjzMWVV98kIqcqM3a6kceQUvc2Gs1BmY3Yfj7LzaPymg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOmcxhcHfdvs2/ffWTPRYKAh6MJbVx4NXz+n9OW7E6A=;
 b=Kiz2qXZnpzsVJ1vcKIEtXnmxIN2LmAJ7SQWe6RCiNezFn7XNNaW+gPr966Aujog+pL9WDdGlJQxctco9ZpVfd6REICf5g+tDl9HUIj3grIA18PJ6J/c9OLgVHS+TvsSkK++PINhKhRcbBk0HPi09NO3Jf8EZq/2V7IY42g7lfJ0=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2920.namprd18.prod.outlook.com (2603:10b6:a03:10b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14; Sun, 8 Mar
 2020 03:44:11 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 03:44:11 +0000
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
Subject: [PATCH v2 01/12] task_isolation: vmstat: add quiet_vmstat_sync
 function
Thread-Topic: [PATCH v2 01/12] task_isolation: vmstat: add quiet_vmstat_sync
 function
Thread-Index: AQHV9PvUoI+q+Qtq5kW5lYF66zseNQ==
Date:   Sun, 8 Mar 2020 03:44:11 +0000
Message-ID: <3118206b99e862d4c163eefd086af14dd12fe305.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
In-Reply-To: <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d1224fc-89a5-442e-bda2-08d7c312f6db
x-ms-traffictypediagnostic: BYAPR18MB2920:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2920B78225119B512C0C90E5BCE10@BYAPR18MB2920.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39850400004)(376002)(346002)(366004)(199004)(189003)(316002)(66946007)(5660300002)(6512007)(478600001)(8936002)(71200400001)(2906002)(6486002)(66556008)(66476007)(76116006)(6506007)(91956017)(64756008)(66446008)(36756003)(54906003)(4326008)(2616005)(186003)(110136005)(8676002)(26005)(81166006)(81156014)(86362001)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2920;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LCevfyd3TjO59jIN9PP1YJOR99nlqERfDWpOJlXWY8oPyYugKX+jB4Bk7nBnfFdFzRm/+W8p+7rjrehCbKQATyJNz2XBhdI26ArNcnSLHvqNyGpuNRel6NBW1f5Q2Tl4r7HgdRIKRG5aGwZALhO6iwplnmS61cPpH1y8OxQwdccsX+E7lvoihxHgi+5XpxMtDrDfK3F2Uxrbte0g7VPPDBxY2QQrznkahFPMYinQVlPPO+sFv+qmPAYRY9hqFHDaKdDiq9dw5+5KW1Cygdd7Ze+3bl9c7vrVSKS/CRb5uy66yXRQepZwGrN9A4W537gOCTx0bV8C01ijSBmk+JkXXw3JVovVLvn5ENqX51+dEYRPsSMCi8EKCdUArnPFYb4HF1ux9kmz0KY25LuSn9omsTgZyiUOeseQWrFP7ZO1QYAyaAB1P8PYJw0sT+y4spTP
x-ms-exchange-antispam-messagedata: 49h2ZUw5oVc8dq9Nq1GSF3wGOCqyiaL3QCbh9CtMm0vuauL+urIaxaHwwPAjefKwAUw07f6ejnEt/mLjflzKNP7L4/Qd24HISokvazlw2bzaQdV5of4JiC66izy4kSfQM3Z/Lpcr57L+6tGlbIl92w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <34D5BF63C3F7774795D2B302FE3EC1E3@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d1224fc-89a5-442e-bda2-08d7c312f6db
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 03:44:11.3448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U8+wW6UiKHPmk+1ZkPKeDK3YiFcdKcvJYKSJ43o5xYUUK8vflOm6VrlSajQrIfb9KIVzcCmDxlKr1CdEVUDSdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2920
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-07_09:2020-03-06,2020-03-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXMgTWV0Y2FsZiA8Y21ldGNhbGZAbWVsbGFub3guY29tPg0KDQpJbiBjb21taXQg
ZjAxZjE3ZDM3MDViICgibW0sIHZtc3RhdDogbWFrZSBxdWlldF92bXN0YXQgbGlnaHRlciIpDQp0
aGUgcXVpZXRfdm1zdGF0KCkgZnVuY3Rpb24gYmVjYW1lIGFzeW5jaHJvbm91cywgaW4gdGhlIHNl
bnNlIHRoYXQNCnRoZSB2bXN0YXQgd29yayB3YXMgc3RpbGwgc2NoZWR1bGVkIHRvIHJ1biBvbiB0
aGUgY29yZSB3aGVuIHRoZQ0KZnVuY3Rpb24gcmV0dXJuZWQuICBGb3IgdGFzayBpc29sYXRpb24s
IHdlIG5lZWQgYSBzeW5jaHJvbm91cw0KdmVyc2lvbiBvZiB0aGUgZnVuY3Rpb24gdGhhdCBndWFy
YW50ZWVzIHRoYXQgdGhlIHZtc3RhdCB3b3JrZXINCndpbGwgbm90IHJ1biBvbiB0aGUgY29yZSBv
biByZXR1cm4gZnJvbSB0aGUgZnVuY3Rpb24uICBBZGQgYQ0KcXVpZXRfdm1zdGF0X3N5bmMoKSBm
dW5jdGlvbiB3aXRoIHRoYXQgc2VtYW50aWMuDQoNClNpZ25lZC1vZmYtYnk6IENocmlzIE1ldGNh
bGYgPGNtZXRjYWxmQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IEFsZXggQmVsaXRzIDxh
YmVsaXRzQG1hcnZlbGwuY29tPg0KLS0tDQogaW5jbHVkZS9saW51eC92bXN0YXQuaCB8IDIgKysN
CiBtbS92bXN0YXQuYyAgICAgICAgICAgIHwgOSArKysrKysrKysNCiAyIGZpbGVzIGNoYW5nZWQs
IDExIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvdm1zdGF0Lmgg
Yi9pbmNsdWRlL2xpbnV4L3Ztc3RhdC5oDQppbmRleCAyOTI0ODVmM2QyNGQuLjJiYzVlODVmMjUx
NCAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvdm1zdGF0LmgNCisrKyBiL2luY2x1ZGUvbGlu
dXgvdm1zdGF0LmgNCkBAIC0yNzAsNiArMjcwLDcgQEAgZXh0ZXJuIHZvaWQgX19kZWNfem9uZV9z
dGF0ZShzdHJ1Y3Qgem9uZSAqLCBlbnVtIHpvbmVfc3RhdF9pdGVtKTsNCiBleHRlcm4gdm9pZCBf
X2RlY19ub2RlX3N0YXRlKHN0cnVjdCBwZ2xpc3RfZGF0YSAqLCBlbnVtIG5vZGVfc3RhdF9pdGVt
KTsNCiANCiB2b2lkIHF1aWV0X3Ztc3RhdCh2b2lkKTsNCit2b2lkIHF1aWV0X3Ztc3RhdF9zeW5j
KHZvaWQpOw0KIHZvaWQgY3B1X3ZtX3N0YXRzX2ZvbGQoaW50IGNwdSk7DQogdm9pZCByZWZyZXNo
X3pvbmVfc3RhdF90aHJlc2hvbGRzKHZvaWQpOw0KIA0KQEAgLTM3Miw2ICszNzMsNyBAQCBzdGF0
aWMgaW5saW5lIHZvaWQgX19kZWNfbm9kZV9wYWdlX3N0YXRlKHN0cnVjdCBwYWdlICpwYWdlLA0K
IHN0YXRpYyBpbmxpbmUgdm9pZCByZWZyZXNoX3pvbmVfc3RhdF90aHJlc2hvbGRzKHZvaWQpIHsg
fQ0KIHN0YXRpYyBpbmxpbmUgdm9pZCBjcHVfdm1fc3RhdHNfZm9sZChpbnQgY3B1KSB7IH0NCiBz
dGF0aWMgaW5saW5lIHZvaWQgcXVpZXRfdm1zdGF0KHZvaWQpIHsgfQ0KK3N0YXRpYyBpbmxpbmUg
dm9pZCBxdWlldF92bXN0YXRfc3luYyh2b2lkKSB7IH0NCiANCiBzdGF0aWMgaW5saW5lIHZvaWQg
ZHJhaW5fem9uZXN0YXQoc3RydWN0IHpvbmUgKnpvbmUsDQogCQkJc3RydWN0IHBlcl9jcHVfcGFn
ZXNldCAqcHNldCkgeyB9DQpkaWZmIC0tZ2l0IGEvbW0vdm1zdGF0LmMgYi9tbS92bXN0YXQuYw0K
aW5kZXggNzhkNTMzNzhkYjk5Li4xZmEwYjJkMDRhZmEgMTAwNjQ0DQotLS0gYS9tbS92bXN0YXQu
Yw0KKysrIGIvbW0vdm1zdGF0LmMNCkBAIC0xODcwLDYgKzE4NzAsMTUgQEAgdm9pZCBxdWlldF92
bXN0YXQodm9pZCkNCiAJcmVmcmVzaF9jcHVfdm1fc3RhdHMoZmFsc2UpOw0KIH0NCiANCisvKg0K
KyAqIFN5bmNocm9ub3VzbHkgcXVpZXQgdm1zdGF0IHNvIHRoZSB3b3JrIGlzIGd1YXJhbnRlZWQg
bm90IHRvIHJ1biBvbiByZXR1cm4uDQorICovDQordm9pZCBxdWlldF92bXN0YXRfc3luYyh2b2lk
KQ0KK3sNCisJY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKHRoaXNfY3B1X3B0cigmdm1zdGF0X3dv
cmspKTsNCisJcmVmcmVzaF9jcHVfdm1fc3RhdHMoZmFsc2UpOw0KK30NCisNCiAvKg0KICAqIFNo
ZXBoZXJkIHdvcmtlciB0aHJlYWQgdGhhdCBjaGVja3MgdGhlDQogICogZGlmZmVyZW50aWFscyBv
ZiBwcm9jZXNzb3JzIHRoYXQgaGF2ZSB0aGVpciB3b3JrZXINCi0tIA0KMi4yMC4xDQoNCg==
