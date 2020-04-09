Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E60351A370C
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgDIP06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:26:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47456 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727912AbgDIP05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:26:57 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 039FPcPG028887;
        Thu, 9 Apr 2020 08:26:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=rNda+EPHX6ACVgsvf8m7CfyfZGJ9eL6Tw+Ga6KqPb+k=;
 b=ghAZlkJYVL0LCFGBtNJodn5g0etb2klsyQLlwy1JfQuaT+8mW9lbe9CPSw5aWyZkVCTT
 eK3/OQB+FwIOWrLZyaSf0IYNRJcI7MpJuVDC7L5zxnkp9qPRYzYqhfcQGGyfFhWszgl2
 XkWf9v7tg2SYSGatwzKYWXBeiHOdMNeJzWVANxpzKiEh5Ws+wV9Ho7dmf7BgYjvHE+fO
 Dctbrl8aQS207Ueq3+V22/JRPPdsyokGrU35DubCHYtba3b3jdI0guFVh0DzzWQHew1w
 OHZxxZPx2w5O2YAfdvDxVqJgtMK3WKxe1mAeaiTK+oLwk5fCd2wW25KI84AAaiTyIriw HA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3091me90a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 08:26:31 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:26:29 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:26:28 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.56) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 9 Apr 2020 08:26:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCGPcdgldhOyfFb5Fj62eQAQYXgaNoRAEal1HFgg88wpapioyIRLlgdxaEmhi7lnd3uNeDBBo2jdti0+6QnyI8yo4xJcNtkgtcslTuQf5ZWDQTCFDi85gG17VirHzSOrXyzX5uwuWp361HZxTAmBVFGtbKoWjc6iSuJR5YVlE8n4FkYbJNpbua4ZNgSv6LctmPjz9DctxW2s2xUU5RBlvk4pxnCWql+UclvO/jqK4TeFKxfRgsHyfr7IEm/+5TCDIbjQdWsgO/xiv0QvmIx/gZrEXF72Llfe7DtQ0sEv656SRKSWotPbxc6bP8ttKEauk1blvhSAiW3ySxUjaIMd4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNda+EPHX6ACVgsvf8m7CfyfZGJ9eL6Tw+Ga6KqPb+k=;
 b=h3trT24a4hWAcuFIGAoc7mnknRloXgwxRBWNgC7N9XQj/O1shPBt06mIgG/XlQQATH7b2xF470v9KfNNf/rWSM0AWv0LLNJ0Kgg4D0XnY033h0ELNm5jFXiCA96ZUnHUBh54Y7Q4kB34Tnvi/eP0vka+g0m7CA2AaTacIQYsC0tk1zvs1htiwe4f6eq9Qtccu4SSMNefPkk2UrsE8mJfaKi8tARXsty1lVLee37bNsmSDPy5CCU3xEnBRvzEACIfwmi8TURW66pP7VXsQ4DJWtsqd4NIMIWHvOs55TXB/cREhfhP8PBYijM8uIRunjAKdZYWF/OYBZrICU38PjiHVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNda+EPHX6ACVgsvf8m7CfyfZGJ9eL6Tw+Ga6KqPb+k=;
 b=iRKZf6YLMeue274QpSfIIg5L9Yh3cfyR6YXHsEOgvwKL/nVes88ZZGH+yiHXi4M20NXlgecrnwLZsy949k/9QRS2H5gIkec+qRlswKtzh727b/LGE+jVQwRgUnfXso1DHKm5uwYnfbb5SrlsO3sLoeiZsRtCs5GxqGVjyIzHRd4=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB3749.namprd18.prod.outlook.com (2603:10b6:a03:96::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Thu, 9 Apr
 2020 15:26:26 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280%3]) with mapi id 15.20.2878.022; Thu, 9 Apr 2020
 15:26:26 +0000
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
Subject: [PATCH v3 10/13] task_isolation: net: don't flush backlog on CPUs
 running isolated tasks
Thread-Topic: [PATCH v3 10/13] task_isolation: net: don't flush backlog on
 CPUs running isolated tasks
Thread-Index: AQHWDoM8P2Up5m25JUiWl370CK4agQ==
Date:   Thu, 9 Apr 2020 15:26:26 +0000
Message-ID: <ca337ff4e82a92d2fe22ce74232730eacfc74d96.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: 3a63550c-7867-40b1-9498-08d7dc9a5e9c
x-ms-traffictypediagnostic: BYAPR18MB3749:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB374986641C2B48554EF3642EBCC10@BYAPR18MB3749.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2535.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(64756008)(316002)(186003)(26005)(66446008)(81156014)(2616005)(8936002)(66476007)(4326008)(7416002)(54906003)(478600001)(81166007)(6506007)(66946007)(71200400001)(110136005)(86362001)(6486002)(76116006)(8676002)(2906002)(36756003)(66556008)(5660300002)(6512007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MKc1zgMam84Y3wKSH2GRNo6YgvXS5BMM4Layi5lW0jQLTFBm2RINMQ3RTIsiVDLDv3RiljTB73dYZQLqn+hFyndVmvmuQoCyD8O9dJTZRcjq7zr6LwDCng/whUV5L0ZljYUFtvvkN/mVtpFs0K/COeAHe0DU6CEDfBJXEA6OioT+d0y+xM3XGFyoYqOcAtNVLF/SLt/4tVDcMZtWwCT0BjllPb8NduG0GKEl6/pFp/NqqxGoapgTw/7XAKFg9DFVs4lFCHRheISAiJdTNf/Q3b9/yF3eieAfAaXEZ+TbQIAd/SXDVztnJ0Ca2OcQNReA8UJ7hmxCknttx4VaqwbpfDJUyQNAt1HdIsPzV/x8iRxcaRmprsR3nrDmjFSfmf/Qc1M1JZO4wpFAjm+001utRe/Dh7gIkYkb6GYi4BCbnDgGpZUx1/c9Ta17R0RghVum
x-ms-exchange-antispam-messagedata: rtnqZm61VdZISohv6dTL/+UuxCj0W8hPdh9bbCqR/E96scW+L1v2Gbdr7hczDzQWuU4ZQ9feQiPs5IudVL6nt7UgSAWaHjcKqJ9GRb1qiG7xlvAnl8IVdbp9ow2V7GNG39JSlhhVeRPx8rHPONoaiA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <76EC25E45302BC4699A62EBA0CFD13EB@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a63550c-7867-40b1-9498-08d7dc9a5e9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 15:26:26.5089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lhi4Cu2H+MnuSulLF/xpbfmtVl0YodXEtDU1SS499q+CaJ4cV0pGYqCxHxkaIo8DWlT9mVb9Q433b1Jb3nEGrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB3749
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_05:2020-04-07,2020-04-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29tPg0KDQpJZiBDUFUgcnVucyBpc29s
YXRlZCB0YXNrLCB0aGVyZSdzIG5vIGFueSBiYWNrbG9nIG9uIGl0LCBhbmQNCnNvIHdlIGRvbid0
IG5lZWQgdG8gZmx1c2ggaXQuIEN1cnJlbnRseSBmbHVzaF9hbGxfYmFja2xvZ3MoKQ0KZW5xdWV1
ZXMgY29ycmVzcG9uZGluZyB3b3JrIG9uIGFsbCBDUFVzIGluY2x1ZGluZyBvbmVzIHRoYXQgcnVu
DQppc29sYXRlZCB0YXNrcy4gSXQgbGVhZHMgdG8gYnJlYWtpbmcgdGFzayBpc29sYXRpb24gZm9y
IG5vdGhpbmcuDQoNCkluIHRoaXMgcGF0Y2gsIGJhY2tsb2cgZmx1c2hpbmcgaXMgZW5xdWV1ZWQg
b25seSBvbiBub24taXNvbGF0ZWQgQ1BVcy4NCg0KU2lnbmVkLW9mZi1ieTogWXVyaSBOb3JvdiA8
eW5vcm92QG1hcnZlbGwuY29tPg0KW2FiZWxpdHNAbWFydmVsbC5jb206IHVzZSBzYWZlIHRhc2tf
aXNvbGF0aW9uX29uX2NwdSgpIGltcGxlbWVudGF0aW9uXQ0KU2lnbmVkLW9mZi1ieTogQWxleCBC
ZWxpdHMgPGFiZWxpdHNAbWFydmVsbC5jb20+DQotLS0NCiBuZXQvY29yZS9kZXYuYyB8IDcgKysr
KysrLQ0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0K
ZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Rldi5jIGIvbmV0L2NvcmUvZGV2LmMNCmluZGV4IGM2Yzk4
NWZlN2IxYi4uMzUzZDJiZTM5MjAyIDEwMDY0NA0KLS0tIGEvbmV0L2NvcmUvZGV2LmMNCisrKyBi
L25ldC9jb3JlL2Rldi5jDQpAQCAtNzQsNiArNzQsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9jcHUu
aD4NCiAjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4NCiAjaW5jbHVkZSA8bGludXgva2VybmVsLmg+
DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0KICNpbmNsdWRlIDxsaW51eC9oYXNoLmg+
DQogI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4NCiAjaW5jbHVkZSA8bGludXgvc2NoZWQuaD4NCkBA
IC01NTE4LDkgKzU1MTksMTMgQEAgc3RhdGljIHZvaWQgZmx1c2hfYWxsX2JhY2tsb2dzKHZvaWQp
DQogDQogCWdldF9vbmxpbmVfY3B1cygpOw0KIA0KLQlmb3JfZWFjaF9vbmxpbmVfY3B1KGNwdSkN
CisJc21wX3JtYigpOw0KKwlmb3JfZWFjaF9vbmxpbmVfY3B1KGNwdSkgew0KKwkJaWYgKHRhc2tf
aXNvbGF0aW9uX29uX2NwdShjcHUpKQ0KKwkJCWNvbnRpbnVlOw0KIAkJcXVldWVfd29ya19vbihj
cHUsIHN5c3RlbV9oaWdocHJpX3dxLA0KIAkJCSAgICAgIHBlcl9jcHVfcHRyKCZmbHVzaF93b3Jr
cywgY3B1KSk7DQorCX0NCiANCiAJZm9yX2VhY2hfb25saW5lX2NwdShjcHUpDQogCQlmbHVzaF93
b3JrKHBlcl9jcHVfcHRyKCZmbHVzaF93b3JrcywgY3B1KSk7DQotLSANCjIuMjAuMQ0KDQo=
