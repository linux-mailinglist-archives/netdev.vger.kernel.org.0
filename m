Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE7517D138
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 04:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgCHDv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 22:51:29 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31740 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726174AbgCHDv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 22:51:29 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0283kvjj010537;
        Sat, 7 Mar 2020 19:51:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=O+bhqr4/bcv5yvmoUmApccrZL//vCN8BtdiyigeXwLc=;
 b=EfPq7fObGNuDgMpWG1C/PTN+yoKKiboFj/H3V3EAlQpvbE/875uTsmYaIPijVzCOPXOK
 +gZR3YrEs9vSfjPpLVgtqXkbqhLa+Ntv0ZOwuRtT7tZE1lNPY5Iye7UWxSrmDzzkuS2h
 MEzm9OhjJjRaf54JnvB061W5BQW0wP4F+JaMkgO6IWWN1ghkikeHV5P/4tPFxfS4h0/d
 eFXVlb9UjOyfFMt67RXK1Ssv8ajix6OL/Sp5ocqyLEMsSO8WJPB+x4hNgo6+nLMZ1aAf
 pejPUljI5n7PGY30yzUZeOcGhaCj9JEY33DaUtPjsrqo23QMEQ/cERBmq/Ln9cKW2iPS yQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwav83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 19:51:01 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 19:51:00 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 19:50:59 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 19:50:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGxIzGGeFxL1lnxSIWI+WAdo2swHErC80zJ1tCmz3xyaSuF3XA62dI7UYG8JeMDTkzIMc0mQZjKs/mjvkXy1+i1sbzZj35pjVv82hs1W1p/t5mL+vyVofDBWpEBtsUYJIrv/69sPzkMZyCcbkgeiLm0sVO0e+zRFIPVTIsh8H1iX0fPiSMWOnBThBgHygvh95DXKYb2TV4A8A30Z1nxhADwL+hDvgqGDHIkjHlOCcsU0YyBIlYvx897Py7GQxkwRBrSwQlCDRHjgHvIKSjAIk6zOGYeO3wYVctCNav+XGISmk23sKkU3PA2HHhY9gpXKVM9/+RVEBAj4PxDDE7aSAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+bhqr4/bcv5yvmoUmApccrZL//vCN8BtdiyigeXwLc=;
 b=bQX3YLwRYV/lVslA7cTMjjwE8ritYtA/dCBAYagkwHxKyctGrDc8GQqgUJcRnET+hKGVVS9063jJ6uegWXuij7lzA1wH333IWd/w4a2BlYZeyWYjkDDjCZFEPB6/G5fm9xy1CF7md0/WNN71So39zIcTyWp18tB+sFuLPpUWt62ia1VguWE31I10ylTDhe0wxF1opHePRzbuR3YF4M/RQxoVp6UhRXZfEwiN/EqCZKCnJjGNMn1dyVWfjxwsPlPOj86EDaPw6Gju5iuc8HRmne0FSO3E2StzC54pneUmwcYPNKgKAuZN2s+3aI1OK4QIWh1U82363bm7D6Xw52NcXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+bhqr4/bcv5yvmoUmApccrZL//vCN8BtdiyigeXwLc=;
 b=r0NP050VazPRHLwbfAD4rZKDVGUQ7NiurSPluBYYAESBm4NZGi6t2xZOFE2tKrKekm71swtehXwbTFYbQA0CS2uuoWlqvZL2m8f3JgjXr4+qji7GWpGkXa0Rk+MGEe2lV7SupTBzsxv0XLeatRpRAezXF9qAtAzCIuKj7bno+YA=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2920.namprd18.prod.outlook.com (2603:10b6:a03:10b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14; Sun, 8 Mar
 2020 03:50:58 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 03:50:58 +0000
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
Subject: [PATCH v2 06/12] task_isolation: arch/arm64: enable task isolation
 functionality
Thread-Topic: [PATCH v2 06/12] task_isolation: arch/arm64: enable task
 isolation functionality
Thread-Index: AQHV9PzGqYwRhIb41UmglY+oy7CR8w==
Date:   Sun, 8 Mar 2020 03:50:58 +0000
Message-ID: <b559513e03dfd09f64ace29452590ddb92c3196f.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
In-Reply-To: <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 707ff5f4-e4bc-4c19-b080-08d7c313e959
x-ms-traffictypediagnostic: BYAPR18MB2920:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2920829DC3A23258C8A85F22BCE10@BYAPR18MB2920.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(39850400004)(396003)(136003)(189003)(199004)(4326008)(2616005)(110136005)(186003)(36756003)(54906003)(81156014)(81166006)(86362001)(7416002)(8676002)(26005)(2906002)(6486002)(71200400001)(8936002)(66946007)(5660300002)(6512007)(316002)(478600001)(91956017)(6506007)(66446008)(64756008)(66556008)(66476007)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2920;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fKVz9Sj1r1ln5LNarZpj69qeq/HB2JfmnhFroEhw4CtGLY1iWvsufQr47dQUqTNRdZvX0xCTuSp5vDhXQxkEe7g+sl9wHu6BG/j0Hf9flvp4LamWTpG5Sqjp78RVhA+ycv2Ac942YGRW/MGZB9mwPf1h916c2GVBBjITNrmU0nMjcPUk+Hrl9aF1gcsHR95Nk0tO4QTfH7007Mdnjrg0Ss1c3Ss4EejC3L5gq73etYj0Wa4gWf/4VivCCh679H1+MUHznd9PAQWcAcKxEVJy49w0cG88NsH7ZijCLqFnUPEmX/+GnxVvRECkqf+4aO4jICoJxwuZTRau4k0aSQJDx8G+dFLYuFsNs1OMjEyDLxQWVq8EGJFA+DE0sk0B6Gz+d9ADuBGbDHdakTJIigQRfSXEdBl6+tvCGudzP+qMFxXGShPGKtRoNCNhAXkIFB8r
x-ms-exchange-antispam-messagedata: wHcYKq3xpR8QXOC1WJtPOg946YjvsMsDSvx/9tzt2O4wo01xX4IObDJ49ZnkQ+Ldq/R/5Lqwm2jgE7HudrRYhJ9T+vOZitqCDjNBPrfOFGkW16bIeo4vyJeP3PVWgjPMlmIuCwIj4hwRXPKMFvKu2A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <5488B4749FDB154F978D946B283098A9@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 707ff5f4-e4bc-4c19-b080-08d7c313e959
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 03:50:58.1079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pM1zl+1OZoAlmP+Hv/ncqceWwhI7Z8qUCK61WE9oxuQg2rVDi9ZqXQ/V4LqlKGEHY6OPLDtbpspx6ocdHhjDyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2920
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-07_09:2020-03-06,2020-03-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXMgTWV0Y2FsZiA8Y21ldGNhbGZAbWVsbGFub3guY29tPg0KDQpJbiBkb19ub3Rp
ZnlfcmVzdW1lKCksIGNhbGwgdGFza19pc29sYXRpb25fc3RhcnQoKSBmb3INClRJRl9UQVNLX0lT
T0xBVElPTiB0YXNrcy4gQWRkIF9USUZfVEFTS19JU09MQVRJT04gdG8gX1RJRl9XT1JLX01BU0ss
DQphbmQgZGVmaW5lIGEgbG9jYWwgTk9USUZZX1JFU1VNRV9MT09QX0ZMQUdTIHRvIGNoZWNrIGlu
IHRoZSBsb29wLA0Kc2luY2Ugd2UgZG9uJ3QgY2xlYXIgX1RJRl9UQVNLX0lTT0xBVElPTiBpbiB0
aGUgbG9vcC4NCg0KV2UgaW5zdHJ1bWVudCB0aGUgc21wX3NlbmRfcmVzY2hlZHVsZSgpIHJvdXRp
bmUgc28gdGhhdCBpdCBjaGVja3MgZm9yDQppc29sYXRlZCB0YXNrcyBhbmQgZ2VuZXJhdGVzIGEg
c3VpdGFibGUgd2FybmluZyBpZiBuZWVkZWQuDQoNCkZpbmFsbHksIHJlcG9ydCBvbiBwYWdlIGZh
dWx0cyBpbiB0YXNrLWlzb2xhdGlvbiBwcm9jZXNzZXMgaW4NCmRvX3BhZ2VfZmF1bHRzKCkuDQoN
ClNpZ25lZC1vZmYtYnk6IENocmlzIE1ldGNhbGYgPGNtZXRjYWxmQG1lbGxhbm94LmNvbT4NClth
YmVsaXRzQG1hcnZlbGwuY29tOiBzaW1wbGlmaWVkIHRvIG1hdGNoIGtlcm5lbCA1LjZdDQpTaWdu
ZWQtb2ZmLWJ5OiBBbGV4IEJlbGl0cyA8YWJlbGl0c0BtYXJ2ZWxsLmNvbT4NCi0tLQ0KIGFyY2gv
YXJtNjQvS2NvbmZpZyAgICAgICAgICAgICAgICAgICB8ICAxICsNCiBhcmNoL2FybTY0L2luY2x1
ZGUvYXNtL3RocmVhZF9pbmZvLmggfCAgNSArKysrLQ0KIGFyY2gvYXJtNjQva2VybmVsL3B0cmFj
ZS5jICAgICAgICAgICB8IDEwICsrKysrKysrKysNCiBhcmNoL2FybTY0L2tlcm5lbC9zaWduYWwu
YyAgICAgICAgICAgfCAxMyArKysrKysrKysrKystDQogYXJjaC9hcm02NC9rZXJuZWwvc21wLmMg
ICAgICAgICAgICAgIHwgIDcgKysrKysrKw0KIGFyY2gvYXJtNjQvbW0vZmF1bHQuYyAgICAgICAg
ICAgICAgICB8ICA1ICsrKysrDQogNiBmaWxlcyBjaGFuZ2VkLCAzOSBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9LY29uZmlnIGIvYXJjaC9h
cm02NC9LY29uZmlnDQppbmRleCAwYjMwZTg4NGUwODguLjkzYjZhYWJjOGJlOSAxMDA2NDQNCi0t
LSBhL2FyY2gvYXJtNjQvS2NvbmZpZw0KKysrIGIvYXJjaC9hcm02NC9LY29uZmlnDQpAQCAtMTI5
LDYgKzEyOSw3IEBAIGNvbmZpZyBBUk02NA0KIAlzZWxlY3QgSEFWRV9BUkNIX1BSRUwzMl9SRUxP
Q0FUSU9OUw0KIAlzZWxlY3QgSEFWRV9BUkNIX1NFQ0NPTVBfRklMVEVSDQogCXNlbGVjdCBIQVZF
X0FSQ0hfU1RBQ0tMRUFLDQorCXNlbGVjdCBIQVZFX0FSQ0hfVEFTS19JU09MQVRJT04NCiAJc2Vs
ZWN0IEhBVkVfQVJDSF9USFJFQURfU1RSVUNUX1dISVRFTElTVA0KIAlzZWxlY3QgSEFWRV9BUkNI
X1RSQUNFSE9PSw0KIAlzZWxlY3QgSEFWRV9BUkNIX1RSQU5TUEFSRU5UX0hVR0VQQUdFDQpkaWZm
IC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS90aHJlYWRfaW5mby5oIGIvYXJjaC9hcm02
NC9pbmNsdWRlL2FzbS90aHJlYWRfaW5mby5oDQppbmRleCBmMGNlYzQxNjAxMzYuLjc1NjMwOThl
YjViMiAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vdGhyZWFkX2luZm8uaA0K
KysrIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS90aHJlYWRfaW5mby5oDQpAQCAtNjMsNiArNjMs
NyBAQCB2b2lkIGFyY2hfcmVsZWFzZV90YXNrX3N0cnVjdChzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRz
ayk7DQogI2RlZmluZSBUSUZfRk9SRUlHTl9GUFNUQVRFCTMJLyogQ1BVJ3MgRlAgc3RhdGUgaXMg
bm90IGN1cnJlbnQncyAqLw0KICNkZWZpbmUgVElGX1VQUk9CRQkJNAkvKiB1cHJvYmUgYnJlYWtw
b2ludCBvciBzaW5nbGVzdGVwICovDQogI2RlZmluZSBUSUZfRlNDSEVDSwkJNQkvKiBDaGVjayBG
UyBpcyBVU0VSX0RTIG9uIHJldHVybiAqLw0KKyNkZWZpbmUgVElGX1RBU0tfSVNPTEFUSU9OCTYN
CiAjZGVmaW5lIFRJRl9OT0haCQk3DQogI2RlZmluZSBUSUZfU1lTQ0FMTF9UUkFDRQk4CS8qIHN5
c2NhbGwgdHJhY2UgYWN0aXZlICovDQogI2RlZmluZSBUSUZfU1lTQ0FMTF9BVURJVAk5CS8qIHN5
c2NhbGwgYXVkaXRpbmcgKi8NCkBAIC04Myw2ICs4NCw3IEBAIHZvaWQgYXJjaF9yZWxlYXNlX3Rh
c2tfc3RydWN0KHN0cnVjdCB0YXNrX3N0cnVjdCAqdHNrKTsNCiAjZGVmaW5lIF9USUZfTkVFRF9S
RVNDSEVECSgxIDw8IFRJRl9ORUVEX1JFU0NIRUQpDQogI2RlZmluZSBfVElGX05PVElGWV9SRVNV
TUUJKDEgPDwgVElGX05PVElGWV9SRVNVTUUpDQogI2RlZmluZSBfVElGX0ZPUkVJR05fRlBTVEFU
RQkoMSA8PCBUSUZfRk9SRUlHTl9GUFNUQVRFKQ0KKyNkZWZpbmUgX1RJRl9UQVNLX0lTT0xBVElP
TgkoMSA8PCBUSUZfVEFTS19JU09MQVRJT04pDQogI2RlZmluZSBfVElGX05PSFoJCSgxIDw8IFRJ
Rl9OT0haKQ0KICNkZWZpbmUgX1RJRl9TWVNDQUxMX1RSQUNFCSgxIDw8IFRJRl9TWVNDQUxMX1RS
QUNFKQ0KICNkZWZpbmUgX1RJRl9TWVNDQUxMX0FVRElUCSgxIDw8IFRJRl9TWVNDQUxMX0FVRElU
KQ0KQEAgLTk2LDcgKzk4LDggQEAgdm9pZCBhcmNoX3JlbGVhc2VfdGFza19zdHJ1Y3Qoc3RydWN0
IHRhc2tfc3RydWN0ICp0c2spOw0KIA0KICNkZWZpbmUgX1RJRl9XT1JLX01BU0sJCShfVElGX05F
RURfUkVTQ0hFRCB8IF9USUZfU0lHUEVORElORyB8IFwNCiAJCQkJIF9USUZfTk9USUZZX1JFU1VN
RSB8IF9USUZfRk9SRUlHTl9GUFNUQVRFIHwgXA0KLQkJCQkgX1RJRl9VUFJPQkUgfCBfVElGX0ZT
Q0hFQ0spDQorCQkJCSBfVElGX1VQUk9CRSB8IF9USUZfRlNDSEVDSyB8IFwNCisJCQkJIF9USUZf
VEFTS19JU09MQVRJT04pDQogDQogI2RlZmluZSBfVElGX1NZU0NBTExfV09SSwkoX1RJRl9TWVND
QUxMX1RSQUNFIHwgX1RJRl9TWVNDQUxMX0FVRElUIHwgXA0KIAkJCQkgX1RJRl9TWVNDQUxMX1RS
QUNFUE9JTlQgfCBfVElGX1NFQ0NPTVAgfCBcDQpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rZXJu
ZWwvcHRyYWNlLmMgYi9hcmNoL2FybTY0L2tlcm5lbC9wdHJhY2UuYw0KaW5kZXggY2Q2ZTVmYTQ4
YjljLi5iMzViOWIwYzU5NGMgMTAwNjQ0DQotLS0gYS9hcmNoL2FybTY0L2tlcm5lbC9wdHJhY2Uu
Yw0KKysrIGIvYXJjaC9hcm02NC9rZXJuZWwvcHRyYWNlLmMNCkBAIC0yOSw2ICsyOSw3IEBADQog
I2luY2x1ZGUgPGxpbnV4L3JlZ3NldC5oPg0KICNpbmNsdWRlIDxsaW51eC90cmFjZWhvb2suaD4N
CiAjaW5jbHVkZSA8bGludXgvZWxmLmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0K
IA0KICNpbmNsdWRlIDxhc20vY29tcGF0Lmg+DQogI2luY2x1ZGUgPGFzbS9jcHVmZWF0dXJlLmg+
DQpAQCAtMTgzNiw2ICsxODM3LDE1IEBAIGludCBzeXNjYWxsX3RyYWNlX2VudGVyKHN0cnVjdCBw
dF9yZWdzICpyZWdzKQ0KIAkJCXJldHVybiAtMTsNCiAJfQ0KIA0KKwkvKg0KKwkgKiBJbiB0YXNr
IGlzb2xhdGlvbiBtb2RlLCB3ZSBtYXkgcHJldmVudCB0aGUgc3lzY2FsbCBmcm9tDQorCSAqIHJ1
bm5pbmcsIGFuZCBpZiBzbyB3ZSBhbHNvIGRlbGl2ZXIgYSBzaWduYWwgdG8gdGhlIHByb2Nlc3Mu
DQorCSAqLw0KKwlpZiAodGVzdF90aHJlYWRfZmxhZyhUSUZfVEFTS19JU09MQVRJT04pKSB7DQor
CQlpZiAodGFza19pc29sYXRpb25fc3lzY2FsbChyZWdzLT5zeXNjYWxsbm8pID09IC0xKQ0KKwkJ
CXJldHVybiAtMTsNCisJfQ0KKw0KIAkvKiBEbyB0aGUgc2VjdXJlIGNvbXB1dGluZyBhZnRlciBw
dHJhY2U7IGZhaWx1cmVzIHNob3VsZCBiZSBmYXN0LiAqLw0KIAlpZiAoc2VjdXJlX2NvbXB1dGlu
ZygpID09IC0xKQ0KIAkJcmV0dXJuIC0xOw0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva2VybmVs
L3NpZ25hbC5jIGIvYXJjaC9hcm02NC9rZXJuZWwvc2lnbmFsLmMNCmluZGV4IDMzOTg4MmRiNWE5
MS4uZDQ4OGM5MWE0ODc3IDEwMDY0NA0KLS0tIGEvYXJjaC9hcm02NC9rZXJuZWwvc2lnbmFsLmMN
CisrKyBiL2FyY2gvYXJtNjQva2VybmVsL3NpZ25hbC5jDQpAQCAtMjAsNiArMjAsNyBAQA0KICNp
bmNsdWRlIDxsaW51eC90cmFjZWhvb2suaD4NCiAjaW5jbHVkZSA8bGludXgvcmF0ZWxpbWl0Lmg+
DQogI2luY2x1ZGUgPGxpbnV4L3N5c2NhbGxzLmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlv
bi5oPg0KIA0KICNpbmNsdWRlIDxhc20vZGFpZmZsYWdzLmg+DQogI2luY2x1ZGUgPGFzbS9kZWJ1
Zy1tb25pdG9ycy5oPg0KQEAgLTg5OCw2ICs4OTksMTEgQEAgc3RhdGljIHZvaWQgZG9fc2lnbmFs
KHN0cnVjdCBwdF9yZWdzICpyZWdzKQ0KIAlyZXN0b3JlX3NhdmVkX3NpZ21hc2soKTsNCiB9DQog
DQorI2RlZmluZSBOT1RJRllfUkVTVU1FX0xPT1BfRkxBR1MgXA0KKwkoX1RJRl9ORUVEX1JFU0NI
RUQgfCBfVElGX1NJR1BFTkRJTkcgfCBcDQorCV9USUZfTk9USUZZX1JFU1VNRSB8IF9USUZfRk9S
RUlHTl9GUFNUQVRFIHwgXA0KKwlfVElGX1VQUk9CRSB8IF9USUZfRlNDSEVDSykNCisNCiBhc21s
aW5rYWdlIHZvaWQgZG9fbm90aWZ5X3Jlc3VtZShzdHJ1Y3QgcHRfcmVncyAqcmVncywNCiAJCQkJ
IHVuc2lnbmVkIGxvbmcgdGhyZWFkX2ZsYWdzKQ0KIHsNCkBAIC05MDgsNiArOTE0LDggQEAgYXNt
bGlua2FnZSB2b2lkIGRvX25vdGlmeV9yZXN1bWUoc3RydWN0IHB0X3JlZ3MgKnJlZ3MsDQogCSAq
Lw0KIAl0cmFjZV9oYXJkaXJxc19vZmYoKTsNCiANCisJdGFza19pc29sYXRpb25fY2hlY2tfcnVu
X2NsZWFudXAoKTsNCisNCiAJZG8gew0KIAkJLyogQ2hlY2sgdmFsaWQgdXNlciBGUyBpZiBuZWVk
ZWQgKi8NCiAJCWFkZHJfbGltaXRfdXNlcl9jaGVjaygpOw0KQEAgLTkzOCw3ICs5NDYsMTAgQEAg
YXNtbGlua2FnZSB2b2lkIGRvX25vdGlmeV9yZXN1bWUoc3RydWN0IHB0X3JlZ3MgKnJlZ3MsDQog
DQogCQlsb2NhbF9kYWlmX21hc2soKTsNCiAJCXRocmVhZF9mbGFncyA9IFJFQURfT05DRShjdXJy
ZW50X3RocmVhZF9pbmZvKCktPmZsYWdzKTsNCi0JfSB3aGlsZSAodGhyZWFkX2ZsYWdzICYgX1RJ
Rl9XT1JLX01BU0spOw0KKwl9IHdoaWxlICh0aHJlYWRfZmxhZ3MgJiBOT1RJRllfUkVTVU1FX0xP
T1BfRkxBR1MpOw0KKw0KKwlpZiAodGhyZWFkX2ZsYWdzICYgX1RJRl9UQVNLX0lTT0xBVElPTikN
CisJCXRhc2tfaXNvbGF0aW9uX3N0YXJ0KCk7DQogfQ0KIA0KIHVuc2lnbmVkIGxvbmcgX19yb19h
ZnRlcl9pbml0IHNpZ25hbF9taW5zaWdzdGtzejsNCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2tl
cm5lbC9zbXAuYyBiL2FyY2gvYXJtNjQva2VybmVsL3NtcC5jDQppbmRleCBkNGVkOWExOWQ4ZmUu
LjAwZjBmNzdhZGVhMCAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtNjQva2VybmVsL3NtcC5jDQorKysg
Yi9hcmNoL2FybTY0L2tlcm5lbC9zbXAuYw0KQEAgLTMyLDYgKzMyLDcgQEANCiAjaW5jbHVkZSA8
bGludXgvaXJxX3dvcmsuaD4NCiAjaW5jbHVkZSA8bGludXgva2V4ZWMuaD4NCiAjaW5jbHVkZSA8
bGludXgva3ZtX2hvc3QuaD4NCisjaW5jbHVkZSA8bGludXgvaXNvbGF0aW9uLmg+DQogDQogI2lu
Y2x1ZGUgPGFzbS9hbHRlcm5hdGl2ZS5oPg0KICNpbmNsdWRlIDxhc20vYXRvbWljLmg+DQpAQCAt
ODE4LDYgKzgxOSw3IEBAIHZvaWQgYXJjaF9zZW5kX2NhbGxfZnVuY3Rpb25fc2luZ2xlX2lwaShp
bnQgY3B1KQ0KICNpZmRlZiBDT05GSUdfQVJNNjRfQUNQSV9QQVJLSU5HX1BST1RPQ09MDQogdm9p
ZCBhcmNoX3NlbmRfd2FrZXVwX2lwaV9tYXNrKGNvbnN0IHN0cnVjdCBjcHVtYXNrICptYXNrKQ0K
IHsNCisJdGFza19pc29sYXRpb25fcmVtb3RlX2NwdW1hc2sobWFzaywgIndha2V1cCBJUEkiKTsN
CiAJc21wX2Nyb3NzX2NhbGwobWFzaywgSVBJX1dBS0VVUCk7DQogfQ0KICNlbmRpZg0KQEAgLTg4
Niw2ICs4ODgsOSBAQCB2b2lkIGhhbmRsZV9JUEkoaW50IGlwaW5yLCBzdHJ1Y3QgcHRfcmVncyAq
cmVncykNCiAJCV9faW5jX2lycV9zdGF0KGNwdSwgaXBpX2lycXNbaXBpbnJdKTsNCiAJfQ0KIA0K
Kwl0YXNrX2lzb2xhdGlvbl9pbnRlcnJ1cHQoIklQSSB0eXBlICVkICglcykiLCBpcGluciwNCisJ
CQkJIGlwaW5yIDwgTlJfSVBJID8gaXBpX3R5cGVzW2lwaW5yXSA6ICJ1bmtub3duIik7DQorDQog
CXN3aXRjaCAoaXBpbnIpIHsNCiAJY2FzZSBJUElfUkVTQ0hFRFVMRToNCiAJCXNjaGVkdWxlcl9p
cGkoKTsNCkBAIC05NDgsMTIgKzk1MywxNCBAQCB2b2lkIGhhbmRsZV9JUEkoaW50IGlwaW5yLCBz
dHJ1Y3QgcHRfcmVncyAqcmVncykNCiANCiB2b2lkIHNtcF9zZW5kX3Jlc2NoZWR1bGUoaW50IGNw
dSkNCiB7DQorCXRhc2tfaXNvbGF0aW9uX3JlbW90ZShjcHUsICJyZXNjaGVkdWxlIElQSSIpOw0K
IAlzbXBfY3Jvc3NfY2FsbChjcHVtYXNrX29mKGNwdSksIElQSV9SRVNDSEVEVUxFKTsNCiB9DQog
DQogI2lmZGVmIENPTkZJR19HRU5FUklDX0NMT0NLRVZFTlRTX0JST0FEQ0FTVA0KIHZvaWQgdGlj
a19icm9hZGNhc3QoY29uc3Qgc3RydWN0IGNwdW1hc2sgKm1hc2spDQogew0KKwl0YXNrX2lzb2xh
dGlvbl9yZW1vdGVfY3B1bWFzayhtYXNrLCAidGltZXIgSVBJIik7DQogCXNtcF9jcm9zc19jYWxs
KG1hc2ssIElQSV9USU1FUik7DQogfQ0KICNlbmRpZg0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQv
bW0vZmF1bHQuYyBiL2FyY2gvYXJtNjQvbW0vZmF1bHQuYw0KaW5kZXggODU1NjZkMzI5NThmLi5m
YzRiNDJjODFjNGYgMTAwNjQ0DQotLS0gYS9hcmNoL2FybTY0L21tL2ZhdWx0LmMNCisrKyBiL2Fy
Y2gvYXJtNjQvbW0vZmF1bHQuYw0KQEAgLTIzLDYgKzIzLDcgQEANCiAjaW5jbHVkZSA8bGludXgv
cGVyZl9ldmVudC5oPg0KICNpbmNsdWRlIDxsaW51eC9wcmVlbXB0Lmg+DQogI2luY2x1ZGUgPGxp
bnV4L2h1Z2V0bGIuaD4NCisjaW5jbHVkZSA8bGludXgvaXNvbGF0aW9uLmg+DQogDQogI2luY2x1
ZGUgPGFzbS9hY3BpLmg+DQogI2luY2x1ZGUgPGFzbS9idWcuaD4NCkBAIC01NDMsNiArNTQ0LDEw
IEBAIHN0YXRpYyBpbnQgX19rcHJvYmVzIGRvX3BhZ2VfZmF1bHQodW5zaWduZWQgbG9uZyBhZGRy
LCB1bnNpZ25lZCBpbnQgZXNyLA0KIAkgKi8NCiAJaWYgKGxpa2VseSghKGZhdWx0ICYgKFZNX0ZB
VUxUX0VSUk9SIHwgVk1fRkFVTFRfQkFETUFQIHwNCiAJCQkgICAgICBWTV9GQVVMVF9CQURBQ0NF
U1MpKSkpIHsNCisJCS8qIE5vIHNpZ25hbCB3YXMgZ2VuZXJhdGVkLCBidXQgbm90aWZ5IHRhc2st
aXNvbGF0aW9uIHRhc2tzLiAqLw0KKwkJaWYgKHVzZXJfbW9kZShyZWdzKSkNCisJCQl0YXNrX2lz
b2xhdGlvbl9pbnRlcnJ1cHQoInBhZ2UgZmF1bHQgYXQgJSNseCIsIGFkZHIpOw0KKw0KIAkJLyoN
CiAJCSAqIE1ham9yL21pbm9yIHBhZ2UgZmF1bHQgYWNjb3VudGluZyBpcyBvbmx5IGRvbmUNCiAJ
CSAqIG9uY2UuIElmIHdlIGdvIHRocm91Z2ggYSByZXRyeSwgaXQgaXMgZXh0cmVtZWx5DQotLSAN
CjIuMjAuMQ0KDQo=
