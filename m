Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF961A36D0
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgDIPSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:18:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17022 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727919AbgDIPSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:18:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 039FGrOm019691;
        Thu, 9 Apr 2020 08:17:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=kZ2+j0FCzkWqNio6rCPrs7enWlq6NYbcuZo1CoUS2GQ=;
 b=Kc94aWrlfz0KrcCajAThCRyZax+qV77EhqG68kHApX4VYvxR1OH0ggcZ+PG5M7NUxIbX
 8urkkm0P4aUVxNSQe9/ZihHSL+8vGXISDj5+sd/mbtbHSPjMFCVXSTd3hJJI518Vtd7x
 OxAlZPN2zBFvaUnlZq/fcCmPp041n/W7gCN1DzZHQIBqJleVebwDr67XsWH9QaA3n0lA
 2fi7z5V5BqvTTQ1IN5OEmqmFGQh0vX+F69amx+5eRVnBDmeB/hR5cHXZlY35GhwFKI00
 Mlo5I5pgnpgTVrsYE8Hxrz5Y8lSIIJqtQi0ZnMz7V1A8TDDU1ODyudRKHXTdya+GMbdb cA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3091me8y58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 08:17:43 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:17:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 9 Apr 2020 08:17:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSuTPqzcO3FdRszOiqJFCb4/R46kRs0DMNgNyQpex3GiSEPdKhBcDVmByOO1zUsrXtdklh80sW/9fg/wEZR41a9j6s2zjMo2JNxOmrCsaOrzV6gW1sB2oGJoR53u3Mn6EwlQIz851wGIuHiIb9utVqGqMubNoTy0yK+rEj2D64Ie5qcRM5VB5IAci0pLL+rbhrNWCB4+92pyC+5stXLknJMk6uDO5H8Add7XiWnVJI1HTkDpR6Di0yVn4H0lyNSLJVdA4PDwyvPrzaj5pwm1swV4Q4c3HgYpTFxHtCtILkvnFkyhETjuSJGI1AkgtiiQgui139ackrS5wYgd317CQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ2+j0FCzkWqNio6rCPrs7enWlq6NYbcuZo1CoUS2GQ=;
 b=WvoNSrliSluATuBJ18+QokXB0i9FyBDAaa0Z8uK6hzyif/kUU1iBYoYvKZwObAz0wim/M2aMbXtTgx/pX8l6jOAxUq4LVB/Vo4FuTEmDdE8Uxvfr8gUQsj+/zWUJ2kfQ98YyChrPdLdNaWwxPagySk+cWoQaDefMricmqav2IL9ghTLwgDjZEjnWeXwNAZ9ogQ8CHR6WPkmzCvx+q9T0pMzcZrHEoyjVO85FTgnkGD7h8Y07u2PlIXAby+ojp+T917as1OfInkZ5QJl6BgNDSsJh2DO0sur201fIlQMowyDHZd7bbM2vfGEzi/KIhOq6Tf/U4Rzle3mX0kbueZ5oyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ2+j0FCzkWqNio6rCPrs7enWlq6NYbcuZo1CoUS2GQ=;
 b=sfGOb5qoCEnzYa/fCbPmRauBX/6FCvd5fpADnmDvfey0HttKvHsQSh03dspYFBiOSKj+VD4PG/b4xESCs8p9iMlsq61N/5NScabJPtb+fUw4Z9GSPh2p9+7E5SYOCqUEPr9Gacko9d1QVWbpHV+3PYdVk4Ja64C6/rochgDZ8+Q=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2758.namprd18.prod.outlook.com (2603:10b6:a03:112::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.18; Thu, 9 Apr
 2020 15:17:40 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280%3]) with mapi id 15.20.2878.022; Thu, 9 Apr 2020
 15:17:40 +0000
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
Subject: [PATCH v3 03/13] task_isolation: add instruction synchronization
 memory barrier
Thread-Topic: [PATCH v3 03/13] task_isolation: add instruction synchronization
 memory barrier
Thread-Index: AQHWDoICUCw40vC9nkuNpTFu2Vf0Xg==
Date:   Thu, 9 Apr 2020 15:17:40 +0000
Message-ID: <d995795c731d6ecceb36bdf1c1df3d72fefd023d.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: f48ac113-0493-42dc-d74a-08d7dc992507
x-ms-traffictypediagnostic: BYAPR18MB2758:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB275888C99422094A841557ADBCC10@BYAPR18MB2758.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2535.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(478600001)(36756003)(7416002)(71200400001)(2906002)(186003)(26005)(86362001)(2616005)(316002)(6506007)(110136005)(54906003)(64756008)(66556008)(6486002)(8936002)(66946007)(66476007)(4326008)(5660300002)(66446008)(6512007)(8676002)(81166007)(76116006)(81156014);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1UPrewe9j5MkY+wG/WKajqXFVDTnUiTHFMhogoclXy0Rw/5moqUaZ5jCOSkPCfSINsK3k73LcFWKobQkCbjbeA4KiB3hndNDDdwWaG7BYshR5Tz0Sv0pE/bJ5C0wAh3lfckuoQzrzwwrj2JSdSXOvYlfzYzI2InWyr8EjNsR+0unUv4EaGF33fciOSoRJ0VmxdBwBn4mOnFv3YBl8dN8cOTrsYteihDjkgQyOTFuRBYqwVA4Z+lZCkdBBiSGVxZPmUemwQ2Angf925SJZzAuDrPs5Jn8q0FPlQNC4wp/vjMIuS7aiRx6gJm2r+SDn3CF0nsw19oQ5tEL8MN/E58qHfAO2EPiuvlaXox3sY9mEhtcM1V4BEejq4uGdTwdb1POruFSZh1mUo2cZN8lD8S+MeLZIQ4YowWhuPqR60d/lA+KaxKajNivYISa61ZsdJwt
x-ms-exchange-antispam-messagedata: 0o8qkoLBk/b1R3YpNyeGdgB8rpVkEHsucY6QTU9XECOwnAeKLsjq8jDAc6JLtVm4nvujBXjDG8aq3nREQ8bzgbZne5itngwLnDTxI5ES16p+BQQyhoG1Wy+RY9fRcQtht6AgPU2eTIYUfRGYugibOg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <C879A473818C5842AE8227975E64E5F0@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f48ac113-0493-42dc-d74a-08d7dc992507
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 15:17:40.4002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W3KXvRHORmUTmHCt1fRAQvcViE7LPxCbEhHIEFOke9o+mCnnWbZxxGws1+KrZHRdhNqBTtPQy7og592j5gd6Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2758
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_05:2020-04-07,2020-04-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U29tZSBhcmNoaXRlY3R1cmVzIGltcGxlbWVudCBtZW1vcnkgc3luY2hyb25pemF0aW9uIGluc3Ry
dWN0aW9ucyBmb3IgaW5zdHJ1Y3Rpb24gY2FjaGUuIE1ha2UgYSBzZXBhcmF0ZSBraW5kIG9mIGJh
cnJpZXIgdGhhdCBjYWxscyB0aGVtLg0KDQpTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbGl0cyA8YWJl
bGl0c0BtYXJ2ZWxsLmNvbT4NCi0tLQ0KIGFyY2gvYXJtL2luY2x1ZGUvYXNtL2JhcnJpZXIuaCAg
IHwgMiArKw0KIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vYmFycmllci5oIHwgMiArKw0KIGluY2x1
ZGUvYXNtLWdlbmVyaWMvYmFycmllci5oICAgIHwgNCArKysrDQogMyBmaWxlcyBjaGFuZ2VkLCA4
IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtL2luY2x1ZGUvYXNtL2JhcnJp
ZXIuaCBiL2FyY2gvYXJtL2luY2x1ZGUvYXNtL2JhcnJpZXIuaA0KaW5kZXggODNhZTk3YzA0OWQ5
Li42ZGVmNjJjOTU5MzcgMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9pbmNsdWRlL2FzbS9iYXJyaWVy
LmgNCisrKyBiL2FyY2gvYXJtL2luY2x1ZGUvYXNtL2JhcnJpZXIuaA0KQEAgLTY0LDEyICs2NCwx
NCBAQCBleHRlcm4gdm9pZCBhcm1faGVhdnlfbWIodm9pZCk7DQogI2RlZmluZSBtYigpCQlfX2Fy
bV9oZWF2eV9tYigpDQogI2RlZmluZSBybWIoKQkJZHNiKCkNCiAjZGVmaW5lIHdtYigpCQlfX2Fy
bV9oZWF2eV9tYihzdCkNCisjZGVmaW5lIGltYigpCQlpc2IoKQ0KICNkZWZpbmUgZG1hX3JtYigp
CWRtYihvc2gpDQogI2RlZmluZSBkbWFfd21iKCkJZG1iKG9zaHN0KQ0KICNlbHNlDQogI2RlZmlu
ZSBtYigpCQliYXJyaWVyKCkNCiAjZGVmaW5lIHJtYigpCQliYXJyaWVyKCkNCiAjZGVmaW5lIHdt
YigpCQliYXJyaWVyKCkNCisjZGVmaW5lIGltYigpCQliYXJyaWVyKCkNCiAjZGVmaW5lIGRtYV9y
bWIoKQliYXJyaWVyKCkNCiAjZGVmaW5lIGRtYV93bWIoKQliYXJyaWVyKCkNCiAjZW5kaWYNCmRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2JhcnJpZXIuaCBiL2FyY2gvYXJtNjQv
aW5jbHVkZS9hc20vYmFycmllci5oDQppbmRleCA3ZDljYzVlYzQ5NzEuLjEyYTdkYmQ2OGJlZCAx
MDA2NDQNCi0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vYmFycmllci5oDQorKysgYi9hcmNo
L2FybTY0L2luY2x1ZGUvYXNtL2JhcnJpZXIuaA0KQEAgLTQ1LDYgKzQ1LDggQEANCiAjZGVmaW5l
IHJtYigpCQlkc2IobGQpDQogI2RlZmluZSB3bWIoKQkJZHNiKHN0KQ0KIA0KKyNkZWZpbmUgaW1i
KCkJCWlzYigpDQorDQogI2RlZmluZSBkbWFfcm1iKCkJZG1iKG9zaGxkKQ0KICNkZWZpbmUgZG1h
X3dtYigpCWRtYihvc2hzdCkNCiANCmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS1nZW5lcmljL2Jh
cnJpZXIuaCBiL2luY2x1ZGUvYXNtLWdlbmVyaWMvYmFycmllci5oDQppbmRleCA4NWIyOGViODBi
MTEuLmQ1YTgyMmZiM2U5MiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvYXNtLWdlbmVyaWMvYmFycmll
ci5oDQorKysgYi9pbmNsdWRlL2FzbS1nZW5lcmljL2JhcnJpZXIuaA0KQEAgLTQ2LDYgKzQ2LDEw
IEBADQogI2RlZmluZSBkbWFfd21iKCkJd21iKCkNCiAjZW5kaWYNCiANCisjaWZuZGVmIGltYg0K
KyNkZWZpbmUgaW1iCQliYXJyaWVyKCkNCisjZW5kaWYNCisNCiAjaWZuZGVmIHJlYWRfYmFycmll
cl9kZXBlbmRzDQogI2RlZmluZSByZWFkX2JhcnJpZXJfZGVwZW5kcygpCQlkbyB7IH0gd2hpbGUg
KDApDQogI2VuZGlmDQotLSANCjIuMjAuMQ0KDQo=
