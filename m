Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22DBC17D12D
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 04:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgCHDso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 22:48:44 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9712 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726174AbgCHDsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 22:48:43 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0283kgI4010475;
        Sat, 7 Mar 2020 19:48:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=MTd/dMc3M0TGfoAmo6csx6t6wKErRI+/1qrvWpMK/To=;
 b=YmBPyq3lkG3u4A9Wl7RSe3LsPgm/kuYeeiUEnx3lqSRSiJTLhM7edjX1KJp1CSMWKZtC
 FPeottYl70VaeBr/H6xb+Cg28foTPFbPA/46xxNk6C/+Tr9pBNNE6BnHP1YnFOwOt/qh
 eBN4hWc/aWSJKgw28ztaTFn7bYLZKTbUE9b9kVU2HtqmuErHxBYSscKVio+FdFSBAu4F
 EB+GW6NieyCmMFouZa14MVYgzWV8UiF824+P+OYBleTQR71X4ckIAGz+RP831Kf4LmCb
 v3nQAa6f/2gE6cAA6ggk3CKkp7y8n73RLxDAUoks+2WGQ5IL6sw6k7l3baR4W6ovxPvk rA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwav3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 19:48:16 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 19:48:15 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 19:48:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/gOjvsslRmZJBFfiRKGh7DjndRoqRlB+/ICRJk1aDHR2qmdg8VgneXC+RnWXdCmf0HCopzoQaqbCJHPnE8v4KUXSsBOuu1s2nArTO7OCAqTA6CVOtkxFuPjmXWdMWu6tG/Au9vPA/aiUydfR+zFOGbTJn2EFQNPTqiN6L4pC/4dBLsIx+TYlU6oyW6ALLV1856kp7z3uNntlpC5FmD3CauR4Nc8W8k5u0v+Jb9k79Jelx37jSTQHRQ3+0deXCJLA2nOk/GVLyc2d4bEXllKfMCJanNUtUjPABC7tyVoqctosUsr+p9VZooxIVgsJJ2aPYsWspAwnym9Et181RMUew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTd/dMc3M0TGfoAmo6csx6t6wKErRI+/1qrvWpMK/To=;
 b=HkIE5+jusNLl+6mijlNi6OBKEPUoJDIGU40nnHwdtsrHqdPweXyFfxymlF0azm4nNGLvSzRKg3fRhtffUqBTyBqVABgRtP/lcGh4fqAEBdoBE5LzCUhSFgtsfhfOEWdX7hU5nBxuZfeIhy1GxXzGmOhNhMMRY4M0SgRwmhpbXkhYf4sF0wYsiVs4DmPP/Of/VjBrhTojCJWllef6HicCFKFipMeKcn9XDhyISdvTbQuLfRE8iggJc8GCGZncYijlM94cvn3kVVUwsfMUimQUCeBcLT+aWs9+Tp2RBGK+5xNHwHwZdNMTHNL+q5UZcvfm2becBD+3fIPhtHAUTsgjdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTd/dMc3M0TGfoAmo6csx6t6wKErRI+/1qrvWpMK/To=;
 b=e18sUEzxzjfq+QWTFmPOtGEPJM56CcvcHxadtxW/r155rf7FmowrohVX4cDfoPGlbsu2DirEEXojju8GXq89ETSJMctRLSad7VcwhYNz/65XL16AZlV1CbH8L8X3K7NJjYKSHMe6dMAYhnYBK9+9RIJRnRSGPDLlKXJ6gVBUGFY=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2920.namprd18.prod.outlook.com (2603:10b6:a03:10b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14; Sun, 8 Mar
 2020 03:48:14 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 03:48:14 +0000
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
Subject: [PATCH v2 04/12] task_isolation: Add task isolation hooks to
 arch-independent code
Thread-Topic: [PATCH v2 04/12] task_isolation: Add task isolation hooks to
 arch-independent code
Thread-Index: AQHV9Pxl8pkDGPPGIkW3Dq3VcQpODQ==
Date:   Sun, 8 Mar 2020 03:48:14 +0000
Message-ID: <fe04f7ef54cac1ea4abb1a01963b27796261fef6.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
In-Reply-To: <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 565d896e-70f9-4fde-1f8d-08d7c31387b2
x-ms-traffictypediagnostic: BYAPR18MB2920:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB29205ECA4D462743B73B27FABCE10@BYAPR18MB2920.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:418;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39850400004)(376002)(346002)(366004)(199004)(189003)(316002)(66946007)(5660300002)(6512007)(478600001)(8936002)(71200400001)(2906002)(6486002)(66556008)(66476007)(76116006)(6506007)(91956017)(64756008)(66446008)(36756003)(54906003)(4326008)(2616005)(186003)(110136005)(8676002)(26005)(81166006)(81156014)(86362001)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2920;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OkM/3l9kPUecBiRT5oxINp6rtJUGFNZEXHa8kJYJ10ueYs2Jn7d4hzRxkhmR/vKb1pwK7eL9b4M9YX67M3hEmIRwYg8XDWUHx1IIHlLpO2+JhJl5WQIvMLUJx4ENURZ17/jdDDxKlas62AFaPU0dDTAUaQ28R1+53WXsEDy3i1Vpf5OrHJk5XVdz2kk1by8J/qyhg/s/ksT/ubSdcNXibhlhj7LCJO41S3puRceo7uvU2zd5M0UFDvaa6jjH2I3vVpQidV48+yjco1FgwWsx9Alo/cYSwz0S1S575MvLLDnBdvsbZ70teI5MKpxtIObaA/lvwv2EJmDW9C7TZolodvqFXiyOuyZuS8ltVZbmy6sEV4r6+qFdnD+TRWOXERrok09RatRPVcuYw4v8G1evcej8LSmWg31vFaIs5HQq3puCAigiFlwTOoMFQqmJeDXl
x-ms-exchange-antispam-messagedata: D/Mtrvz8zNxD/2FLhKjp2lbDImRlRFwHr5HKlls6uK1ox4GEYCHHQB5xc9RP0f4zA/AntWfdwQPmJR9KDUXZXY88uJxaIPtVwvaVEyr6JTVSdTBxKHu/dB9rthxWljw6UV9AYgJE4WW0ap09RooX6A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <E26DEC7E7D52154398780542E04450B8@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 565d896e-70f9-4fde-1f8d-08d7c31387b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 03:48:14.3297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LeF9Wx7kepNpZhtJi4NJAXZjrDgaPECbwR9g3ImxeYzwuc7uHyeKVwsom+5FoLwnX0gxTB04db5DPqx4ZHaK7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2920
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-07_09:2020-03-06,2020-03-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXMgTWV0Y2FsZiA8Y21ldGNhbGZAbWVsbGFub3guY29tPg0KDQpUaGlzIGNvbW1p
dCBhZGRzIHRhc2sgaXNvbGF0aW9uIGhvb2tzIGFzIGZvbGxvd3M6DQoNCi0gX19oYW5kbGVfZG9t
YWluX2lycSgpIGdlbmVyYXRlcyBhbiBpc29sYXRpb24gd2FybmluZyBmb3IgdGhlDQogIGxvY2Fs
IHRhc2sNCg0KLSBpcnFfd29ya19xdWV1ZV9vbigpIGdlbmVyYXRlcyBhbiBpc29sYXRpb24gd2Fy
bmluZyBmb3IgdGhlIHJlbW90ZQ0KICB0YXNrIGJlaW5nIGludGVycnVwdGVkIGZvciBpcnFfd29y
aw0KDQotIGdlbmVyaWNfZXhlY19zaW5nbGUoKSBnZW5lcmF0ZXMgYSByZW1vdGUgaXNvbGF0aW9u
IHdhcm5pbmcgZm9yDQogIHRoZSByZW1vdGUgY3B1IGJlaW5nIElQSSdkDQoNCi0gc21wX2NhbGxf
ZnVuY3Rpb25fbWFueSgpIGdlbmVyYXRlcyBhIHJlbW90ZSBpc29sYXRpb24gd2FybmluZyBmb3IN
CiAgdGhlIHNldCBvZiByZW1vdGUgY3B1cyBiZWluZyBJUEknZA0KDQpDYWxscyB0byB0YXNrX2lz
b2xhdGlvbl9yZW1vdGUoKSBvciB0YXNrX2lzb2xhdGlvbl9pbnRlcnJ1cHQoKSBjYW4NCmJlIHBs
YWNlZCBpbiB0aGUgcGxhdGZvcm0taW5kZXBlbmRlbnQgY29kZSBsaWtlIHRoaXMgd2hlbiBkb2lu
ZyBzbw0KcmVzdWx0cyBpbiBmZXdlciBsaW5lcyBvZiBjb2RlIGNoYW5nZXMsIGFzIGZvciBleGFt
cGxlIGlzIHRydWUgb2YNCnRoZSB1c2VycyBvZiB0aGUgYXJjaF9zZW5kX2NhbGxfZnVuY3Rpb25f
KigpIEFQSXMuIE9yLCB0aGV5IGNhbiBiZQ0KcGxhY2VkIGluIHRoZSBwZXItYXJjaGl0ZWN0dXJl
IGNvZGUgd2hlbiB0aGVyZSBhcmUgbWFueSBjYWxsZXJzLA0KYXMgZm9yIGV4YW1wbGUgaXMgdHJ1
ZSBvZiB0aGUgc21wX3NlbmRfcmVzY2hlZHVsZSgpIGNhbGwuDQoNCkEgZnVydGhlciBjbGVhbnVw
IG1pZ2h0IGJlIHRvIGNyZWF0ZSBhbiBpbnRlcm1lZGlhdGUgbGF5ZXIsIHNvIHRoYXQNCmZvciBl
eGFtcGxlIHNtcF9zZW5kX3Jlc2NoZWR1bGUoKSBpcyBhIHNpbmdsZSBnZW5lcmljIGZ1bmN0aW9u
IHRoYXQNCmp1c3QgY2FsbHMgYXJjaF9zbXBfc2VuZF9yZXNjaGVkdWxlKCksIGFsbG93aW5nIGdl
bmVyaWMgY29kZSB0byBiZQ0KY2FsbGVkIGV2ZXJ5IHRpbWUgc21wX3NlbmRfcmVzY2hlZHVsZSgp
IGlzIGludm9rZWQuIEJ1dCBmb3Igbm93LCB3ZQ0KanVzdCB1cGRhdGUgZWl0aGVyIGNhbGxlcnMg
b3IgY2FsbGVlcyBhcyBtYWtlcyBtb3N0IHNlbnNlLg0KDQpTaWduZWQtb2ZmLWJ5OiBDaHJpcyBN
ZXRjYWxmIDxjbWV0Y2FsZkBtZWxsYW5veC5jb20+DQpbYWJlbGl0c0BtYXJ2ZWxsLmNvbTogYWRh
cHRlZCBmb3Iga2VybmVsIDUuNl0NClNpZ25lZC1vZmYtYnk6IEFsZXggQmVsaXRzIDxhYmVsaXRz
QG1hcnZlbGwuY29tPg0KLS0tDQoga2VybmVsL2lycS9pcnFkZXNjLmMgfCA5ICsrKysrKysrKw0K
IGtlcm5lbC9pcnFfd29yay5jICAgIHwgNSArKysrLQ0KIGtlcm5lbC9zbXAuYyAgICAgICAgIHwg
NiArKysrKy0NCiAzIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pDQoNCmRpZmYgLS1naXQgYS9rZXJuZWwvaXJxL2lycWRlc2MuYyBiL2tlcm5lbC9pcnEvaXJx
ZGVzYy5jDQppbmRleCA5OGE1ZjEwZDE5MDAuLmUyYjgxZDAzNWZhMSAxMDA2NDQNCi0tLSBhL2tl
cm5lbC9pcnEvaXJxZGVzYy5jDQorKysgYi9rZXJuZWwvaXJxL2lycWRlc2MuYw0KQEAgLTE2LDYg
KzE2LDcgQEANCiAjaW5jbHVkZSA8bGludXgvYml0bWFwLmg+DQogI2luY2x1ZGUgPGxpbnV4L2ly
cWRvbWFpbi5oPg0KICNpbmNsdWRlIDxsaW51eC9zeXNmcy5oPg0KKyNpbmNsdWRlIDxsaW51eC9p
c29sYXRpb24uaD4NCiANCiAjaW5jbHVkZSAiaW50ZXJuYWxzLmgiDQogDQpAQCAtNjcwLDYgKzY3
MSwxMCBAQCBpbnQgX19oYW5kbGVfZG9tYWluX2lycShzdHJ1Y3QgaXJxX2RvbWFpbiAqZG9tYWlu
LCB1bnNpZ25lZCBpbnQgaHdpcnEsDQogCQlpcnEgPSBpcnFfZmluZF9tYXBwaW5nKGRvbWFpbiwg
aHdpcnEpOw0KICNlbmRpZg0KIA0KKwl0YXNrX2lzb2xhdGlvbl9pbnRlcnJ1cHQoKGlycSA9PSBo
d2lycSkgPw0KKwkJCQkgImlycSAlZCAoJXMpIiA6ICJpcnEgJWQgKCVzIGh3aXJxICVkKSIsDQor
CQkJCSBpcnEsIGRvbWFpbiA/IGRvbWFpbi0+bmFtZSA6ICIiLCBod2lycSk7DQorDQogCS8qDQog
CSAqIFNvbWUgaGFyZHdhcmUgZ2l2ZXMgcmFuZG9tbHkgd3JvbmcgaW50ZXJydXB0cy4gIFJhdGhl
cg0KIAkgKiB0aGFuIGNyYXNoaW5nLCBkbyBzb21ldGhpbmcgc2Vuc2libGUuDQpAQCAtNzExLDYg
KzcxNiwxMCBAQCBpbnQgaGFuZGxlX2RvbWFpbl9ubWkoc3RydWN0IGlycV9kb21haW4gKmRvbWFp
biwgdW5zaWduZWQgaW50IGh3aXJxLA0KIA0KIAlpcnEgPSBpcnFfZmluZF9tYXBwaW5nKGRvbWFp
biwgaHdpcnEpOw0KIA0KKwl0YXNrX2lzb2xhdGlvbl9pbnRlcnJ1cHQoKGlycSA9PSBod2lycSkg
Pw0KKwkJCQkgIk5NSSBpcnEgJWQgKCVzKSIgOiAiTk1JIGlycSAlZCAoJXMgaHdpcnEgJWQpIiwN
CisJCQkJIGlycSwgZG9tYWluID8gZG9tYWluLT5uYW1lIDogIiIsIGh3aXJxKTsNCisNCiAJLyoN
CiAJICogYWNrX2JhZF9pcnEgaXMgbm90IE5NSS1zYWZlLCBqdXN0IHJlcG9ydA0KIAkgKiBhbiBp
bnZhbGlkIGludGVycnVwdC4NCmRpZmYgLS1naXQgYS9rZXJuZWwvaXJxX3dvcmsuYyBiL2tlcm5l
bC9pcnFfd29yay5jDQppbmRleCA4MjhjYzMwNzc0YmMuLjhmZDRlY2U0M2RkOCAxMDA2NDQNCi0t
LSBhL2tlcm5lbC9pcnFfd29yay5jDQorKysgYi9rZXJuZWwvaXJxX3dvcmsuYw0KQEAgLTE4LDYg
KzE4LDcgQEANCiAjaW5jbHVkZSA8bGludXgvY3B1Lmg+DQogI2luY2x1ZGUgPGxpbnV4L25vdGlm
aWVyLmg+DQogI2luY2x1ZGUgPGxpbnV4L3NtcC5oPg0KKyNpbmNsdWRlIDxsaW51eC9pc29sYXRp
b24uaD4NCiAjaW5jbHVkZSA8YXNtL3Byb2Nlc3Nvci5oPg0KIA0KIA0KQEAgLTEwMiw4ICsxMDMs
MTAgQEAgYm9vbCBpcnFfd29ya19xdWV1ZV9vbihzdHJ1Y3QgaXJxX3dvcmsgKndvcmssIGludCBj
cHUpDQogCWlmIChjcHUgIT0gc21wX3Byb2Nlc3Nvcl9pZCgpKSB7DQogCQkvKiBBcmNoIHJlbW90
ZSBJUEkgc2VuZC9yZWNlaXZlIGJhY2tlbmQgYXJlbid0IE5NSSBzYWZlICovDQogCQlXQVJOX09O
X09OQ0UoaW5fbm1pKCkpOw0KLQkJaWYgKGxsaXN0X2FkZCgmd29yay0+bGxub2RlLCAmcGVyX2Nw
dShyYWlzZWRfbGlzdCwgY3B1KSkpDQorCQlpZiAobGxpc3RfYWRkKCZ3b3JrLT5sbG5vZGUsICZw
ZXJfY3B1KHJhaXNlZF9saXN0LCBjcHUpKSkgew0KKwkJCXRhc2tfaXNvbGF0aW9uX3JlbW90ZShj
cHUsICJpcnFfd29yayIpOw0KIAkJCWFyY2hfc2VuZF9jYWxsX2Z1bmN0aW9uX3NpbmdsZV9pcGko
Y3B1KTsNCisJCX0NCiAJfSBlbHNlIHsNCiAJCV9faXJxX3dvcmtfcXVldWVfbG9jYWwod29yayk7
DQogCX0NCmRpZmYgLS1naXQgYS9rZXJuZWwvc21wLmMgYi9rZXJuZWwvc21wLmMNCmluZGV4IGQw
YWRhMzllYjRkNC4uM2E4YmNiZGQ0Y2U2IDEwMDY0NA0KLS0tIGEva2VybmVsL3NtcC5jDQorKysg
Yi9rZXJuZWwvc21wLmMNCkBAIC0yMCw2ICsyMCw3IEBADQogI2luY2x1ZGUgPGxpbnV4L3NjaGVk
Lmg+DQogI2luY2x1ZGUgPGxpbnV4L3NjaGVkL2lkbGUuaD4NCiAjaW5jbHVkZSA8bGludXgvaHlw
ZXJ2aXNvci5oPg0KKyNpbmNsdWRlIDxsaW51eC9pc29sYXRpb24uaD4NCiANCiAjaW5jbHVkZSAi
c21wYm9vdC5oIg0KIA0KQEAgLTE3Niw4ICsxNzcsMTAgQEAgc3RhdGljIGludCBnZW5lcmljX2V4
ZWNfc2luZ2xlKGludCBjcHUsIGNhbGxfc2luZ2xlX2RhdGFfdCAqY3NkLA0KIAkgKiBsb2NraW5n
IGFuZCBiYXJyaWVyIHByaW1pdGl2ZXMuIEdlbmVyaWMgY29kZSBpc24ndCByZWFsbHkNCiAJICog
ZXF1aXBwZWQgdG8gZG8gdGhlIHJpZ2h0IHRoaW5nLi4uDQogCSAqLw0KLQlpZiAobGxpc3RfYWRk
KCZjc2QtPmxsaXN0LCAmcGVyX2NwdShjYWxsX3NpbmdsZV9xdWV1ZSwgY3B1KSkpDQorCWlmIChs
bGlzdF9hZGQoJmNzZC0+bGxpc3QsICZwZXJfY3B1KGNhbGxfc2luZ2xlX3F1ZXVlLCBjcHUpKSkg
ew0KKwkJdGFza19pc29sYXRpb25fcmVtb3RlKGNwdSwgIklQSSBmdW5jdGlvbiIpOw0KIAkJYXJj
aF9zZW5kX2NhbGxfZnVuY3Rpb25fc2luZ2xlX2lwaShjcHUpOw0KKwl9DQogDQogCXJldHVybiAw
Ow0KIH0NCkBAIC00NjYsNiArNDY5LDcgQEAgc3RhdGljIHZvaWQgc21wX2NhbGxfZnVuY3Rpb25f
bWFueV9jb25kKGNvbnN0IHN0cnVjdCBjcHVtYXNrICptYXNrLA0KIAl9DQogDQogCS8qIFNlbmQg
YSBtZXNzYWdlIHRvIGFsbCBDUFVzIGluIHRoZSBtYXAgKi8NCisJdGFza19pc29sYXRpb25fcmVt
b3RlX2NwdW1hc2soY2ZkLT5jcHVtYXNrX2lwaSwgIklQSSBmdW5jdGlvbiIpOw0KIAlhcmNoX3Nl
bmRfY2FsbF9mdW5jdGlvbl9pcGlfbWFzayhjZmQtPmNwdW1hc2tfaXBpKTsNCiANCiAJaWYgKHdh
aXQpIHsNCi0tIA0KMi4yMC4xDQoNCg==
