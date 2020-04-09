Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDD11A36E3
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgDIPWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:22:11 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29590 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727978AbgDIPWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:22:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 039FFXmj014772;
        Thu, 9 Apr 2020 08:21:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=MTd/dMc3M0TGfoAmo6csx6t6wKErRI+/1qrvWpMK/To=;
 b=h85xF34Q1ThdNqX8B36c0NHLOjXuGyA/NiTGDrbGNM0nyUHcmuxo7Q97ZYIH66whqtPj
 6HJ1BAq6heHTuP7Vr+xOuI7nKqCR0/AygvtNkPCm5uLNqlKqZaGj1KcmW4tjLZXcGp+u
 6MAE1OCDCVAjO5pWsYjMcKZ8axfTwlUh9rXqrsepy061LAaHby0SlGf38+o1IFXAsqDG
 GSwzKe0eCDdxp32+Af2AFnIeLbRjLMEQlBEMJO8bKAr/oin56CEV7cEHhhhahqcFnLyL
 MkPYixoORrThD/PMlmk2DCb3zra0WPxIAiaIMpAxk3VWnG/6dz9IhujiEbfpamXenGM8 sQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3091jwh0sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 08:21:43 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:21:42 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.50) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 9 Apr 2020 08:21:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsVWlJOt9lyHRcX3OkT/iGpfaw9ShTnyvZ8DK//bl9sL0hI87aosr6u/sdTTZOv52mpHjeYiEhl2OMBuzCznHd2VN6YdEtjYLA+IQNcLlwKmdHR1R62yLx2eIs1pYXIvzybOuJmSnMbiN/+IAcVqVNM1XrPrzKxFpNT2hnftWnE+BHBFdouLDWAzatEUwNjD1dH5Dq+T3o/eDSCFxzjiK506MCpiOsJUPBdqAKi9BLk8w1g+lDvHgKVtanmREdSAsAXK9fM/wKNJ4RJ/yNPBhGc/IjKqZSsTbeifUvamAXE2eY7JM2XJ5QQQiHSidLFmpf2Fz1h9TyC5GzMsH8E5Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTd/dMc3M0TGfoAmo6csx6t6wKErRI+/1qrvWpMK/To=;
 b=WzpK/VEZ0iFqT/3uqKd6jkfiGifa6tfnAvo5dB3VBqv51mlHgQ/rRpzfIDXGaB8UTdlq/GWAxBbAHz0wEnGZyehK9KG8XqQoeuW20QhGN8+6CqBGmg74ushWlmCs1dMAoS89K2xn7fSMdJqpehz4bcTabtmwllXpQ9zMPPpe1q6jK8k923HBlGQpgntzNSrg6KUFUZpN97X3f6gTrT57xOMuns/wv8wNgmhDJ8tbLJ6RxEtxPwFO2wQp+CfdgXME1V8B2RHwRMhhhsg7485Oh3n7M7d3a0lSeKJBAcqSi8vG0KHyg2Bo5QuWjypTtJZCG9nmZweDWQy2IkRO9mUlbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTd/dMc3M0TGfoAmo6csx6t6wKErRI+/1qrvWpMK/To=;
 b=lUKNE+a7Rt5nAgSbI6ooNnfommWghvjbq4/vlnCXNnt1HFqTJam1QBhZES+IlZ+xbZn6GpT5zRyH8KeODDH0T4s8YrwWYeaZLgsdhUtAHPHecl4FOPSxB+SkVbjMWBHgj667in8GSmxVBwk+Eusu6a7Wf9HrannLB1WRRja+9lM=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB3749.namprd18.prod.outlook.com (2603:10b6:a03:96::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Thu, 9 Apr
 2020 15:21:41 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280%3]) with mapi id 15.20.2878.022; Thu, 9 Apr 2020
 15:21:41 +0000
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
Subject: [PATCH 05/13] task_isolation: Add task isolation hooks to
  arch-independent code
Thread-Topic: [PATCH 05/13] task_isolation: Add task isolation hooks to
  arch-independent code
Thread-Index: AQHWDoKSSgP/4IAd8kmBGtttI7fyjg==
Date:   Thu, 9 Apr 2020 15:21:41 +0000
Message-ID: <74b9aa603bc03fe572cc4cd51ba2f8e2829b6ed5.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: 32f65b85-03a0-434b-4a42-08d7dc99b4b3
x-ms-traffictypediagnostic: BYAPR18MB3749:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB37496809C78BC8FB2FCD69DFBCC10@BYAPR18MB3749.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:418;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2535.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(64756008)(316002)(186003)(26005)(66446008)(81156014)(2616005)(8936002)(66476007)(4326008)(7416002)(54906003)(478600001)(81166007)(6506007)(66946007)(71200400001)(110136005)(86362001)(6486002)(76116006)(8676002)(2906002)(36756003)(66556008)(5660300002)(6512007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vDsc+kzY9wpsVqgfPN3holtjZEW+QRHAZjnx677yDvNPSSbt8R5cDrOmxOWuhlk4Vgfxv4b8r8W9y41d1q1DAP3Jl1AwX+XDVsqhSjH5JjbBoquJ9ONsffQUpETZMSRefMbbELF6afK/7fZmuIEQkL99uRndqsC6O9jhGje/eAMIEED0Xq46NapJg/V9RQk/MDLuKfb7t7b+cxf/9UTKCW+ZKqCO19dBDPXswELaWF08Ho8D3ntcE3MokJKesCraVNr7UcR2nkTLWZ7exRDZgBAvh8wFUWoYtFhqd9KYES5lcsD5/WmqD0zJs7tTkciNZ8GbB7uPI7QmNKlqlVNzdI7REZnaaLaaUU1e1z+AgVjX4MQ0u0aN10jsxykGJCL/QSVzqO0i+KP6BmdV1dB+NuV4CyICGXRhTEMLw77K0DV+o/kM6zm8pU+/1hGL+9Vy
x-ms-exchange-antispam-messagedata: mjCR4yKjm6KgGmV3mzhGcG2pxewJiZOliY28zLL65KM2oHTgz4Q6o0Jip3paUy/mfUfJuU+Z+lLvkIxIbT0GzXzhPcRTJhMH4uJ6BKn+P9AUWnCjb8tUVMEvVdpwIvVKDzW6vsidnnhF28m+EiUR1A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E0295570786A34A894120F715BCC68A@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 32f65b85-03a0-434b-4a42-08d7dc99b4b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 15:21:41.3522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NcTefQ2Tbdr3Z8twXicrgblcJlbHnFQJYiyDk8eG/uhLiys6rFgAeV+RJFzG/53jR5lrVVxm80jqTHBN6Ks9nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB3749
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_05:2020-04-07,2020-04-09 signatures=0
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
