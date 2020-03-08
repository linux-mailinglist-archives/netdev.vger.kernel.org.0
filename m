Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF0D17D122
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 04:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgCHDqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 22:46:53 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24666 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726116AbgCHDqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 22:46:53 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0283fYMH006247;
        Sat, 7 Mar 2020 19:46:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=3zRBZywEQlwY12ZkVBkV2O6spn9XfENf40p27pJFgsE=;
 b=flxrLBa2lSLz3b7rVYBwYdQFXPpnIve6rQ6ycea9sTG2CX3z91Xjcbl8FxqXzxQPzzJH
 woSA6H+KmRK7Ke2lMljU0EIlED3niCNh/KHT1TvH75AwRNZxTAblQQXFkBD33/ly4eCj
 bC0D+eFWlxww/ChwY9AoGRSMut81+rsd80eLFKsoKXAPbHwgHr6zsx6iGeXMq4TwsZvF
 U/9ocFbXI6XCproDO4yOXpHwquDyBgOODDrwktV65sQsAiWtehVw0nKqR/s6/iM5vssc
 H7n7Q5hX0oUjyiv/9RNV/04u0+U3IcGPjD1+VZx70WpxmQ9BAyvUzcPoBlsFTi6KyqNh Mw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwauxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 19:46:09 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 19:46:08 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 19:46:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7SztssoDwbVn+IPYnqSV/zeBbIEgIc/8TrdhxFz3FpWY9WCwL950P6zrIYdL5mxLfeCKi9xIdBVoJuY8Qi/u1lbZiKxxBa3yXmKIOFmQkPuPSK2BGAEdMMboRs6QAsjAWcflEn/WOssnJtCfHuI7ukKV9Nau9b8qYz0YcVSzZYiBzxQti/kbxQWFcgDg5XxnDs3D3PQ0ra8bVZkmEcaDKtOuBEsc4iniY8tr3Ioie+M6RTQwc5k5rC5e7R/FlPBgrU2x4D0O/vEieVREf6//SLKZGz1ZcocASPSa3AdkCQci779It6iKbeucPLCmj+l0OzqnYzj2W5+7jwN+3JK0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zRBZywEQlwY12ZkVBkV2O6spn9XfENf40p27pJFgsE=;
 b=XZnuF4CEn/8M4p+rlJlDl3QaTj4E9IloO2VY6/taw50YY8MHM24xYvU4EELygQ5COns8kQp/qiz/cYjXZBhSR7Jf8AuKTb/20bDiUz8tKUJ5fibmb+6silrq6YMMnfxKM5nAolcuckZ6mlSNjQ4ODWtUYsQvK5O2rCmPwd4+T5nODSuutMB0VAio6EaHDx7J4CYFFXopKjblcQxgZW+k9pmFHBHBULtSO7ji0j6+OWuKI4GXJd7vv8iW1HScGSLzZffxOSBBihwcwiBMNTP2stpdczLgeTQDThfhSBcjSFGJeVxNsOEdpJi58gdi4CdXh9mDAaTVh16K7fL2FoKAQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zRBZywEQlwY12ZkVBkV2O6spn9XfENf40p27pJFgsE=;
 b=atlvKHHH5l1ITNHjhhKbaYhZnJP8/ILb7J/uJYl6NVKuSmQRMJ6fIwcpK1MYKbor3JADr9jZYyBuCRIIRXrXU+PUmh+ZyQ+rkfkzt2ZpZjEuZLrmHQ0yvxaFx1kj7zmi0q7wJKcAmJCkaYaguvRnZ3VCSmCsyLJ4Yos2CsI9JuU=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2920.namprd18.prod.outlook.com (2603:10b6:a03:10b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14; Sun, 8 Mar
 2020 03:46:07 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 03:46:07 +0000
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
Subject: [PATCH v2 02/12] task_isolation: vmstat: add vmstat_idle function
Thread-Topic: [PATCH v2 02/12] task_isolation: vmstat: add vmstat_idle
 function
Thread-Index: AQHV9PwZGuit9HuXRU+77sdJLQQteg==
Date:   Sun, 8 Mar 2020 03:46:07 +0000
Message-ID: <3443bdf4ff557331c39a99b133defee56452be48.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
In-Reply-To: <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ecca648-818e-4a2f-3bea-08d7c3133c1b
x-ms-traffictypediagnostic: BYAPR18MB2920:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2920AB09E089C111D22C839FBCE10@BYAPR18MB2920.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39850400004)(376002)(346002)(366004)(199004)(189003)(316002)(66946007)(5660300002)(6512007)(478600001)(8936002)(71200400001)(2906002)(6486002)(66556008)(66476007)(76116006)(6506007)(91956017)(64756008)(66446008)(36756003)(54906003)(4326008)(2616005)(186003)(110136005)(8676002)(26005)(81166006)(81156014)(86362001)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2920;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K1w9NNQLSIZEVeuLwjLXHmyPgxXu6iAwZEAz/weEU0znNRgUcfvjMwgEMM1+kpx3lOiMf1LLhAd1jWJ07uykEKgLagewGDDDMsajyvDwI+TiIh9Bi24tOOHju9OGOMZaRctCg8iU9MWyTdSPHY3LgqpJGRMpPO8vCCVAc6T8fUkYVs+31mk9zLRPUqiU/gSQMc8Nmdb5ItbJ3COx7PgLle36C6fpmO5UPo1AARIJtB/2WiLYaydcnulzA4QBaBE7QexjyK0BaXXVJR+mdatJMm0RdU3v8r/0HX7rrU0eE7j0r3oeXCox3GOfeFNoCwiDG1OMMqQTXOvJ2IhaQuMqLRmAA8nhGjP+MKV2jboWXNvFo96+f3KilaeM9GsSh8mWFUhvMwhzlSDNkQwCP74zslEeccB4wZeGiInA1uscJVNKQRM04RrQUN8XB6bBttbF
x-ms-exchange-antispam-messagedata: OHEcJGmt41CWcun0s7cQbSTV28EEdejWEH0FpXvuR8uy9aA5YrCbjBhyRIKACaXrb8av2QbW828CjUjoUKRzTwWo1iGXhVMcBk71xvm/30zMayitQEV9fYoZE7XxnudozjkwEDSiXjMSgw+g1BmkXg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <31B867DD531EED43ABA359B8014CD8B7@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ecca648-818e-4a2f-3bea-08d7c3133c1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 03:46:07.5137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OSE0VXI9N6Pxe2NZ3UMhSPuxeK0lKS3PND98sFxxqba3DAPTWcipf2lUr93WpfSVvIpxN+W8QFcCbMUCAtr4jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2920
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-07_09:2020-03-06,2020-03-07 signatures=0
Sender: netdev-owner@vger.kernel.org
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
dWRlL2xpbnV4L3Ztc3RhdC5oIGIvaW5jbHVkZS9saW51eC92bXN0YXQuaA0KaW5kZXggMmJjNWU4
NWYyNTE0Li42NmQ5YWUzMmNmMDcgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3Ztc3RhdC5o
DQorKysgYi9pbmNsdWRlL2xpbnV4L3Ztc3RhdC5oDQpAQCAtMjcxLDYgKzI3MSw3IEBAIGV4dGVy
biB2b2lkIF9fZGVjX25vZGVfc3RhdGUoc3RydWN0IHBnbGlzdF9kYXRhICosDQplbnVtIG5vZGVf
c3RhdF9pdGVtKTsNCiANCiB2b2lkIHF1aWV0X3Ztc3RhdCh2b2lkKTsNCiB2b2lkIHF1aWV0X3Zt
c3RhdF9zeW5jKHZvaWQpOw0KK2Jvb2wgdm1zdGF0X2lkbGUodm9pZCk7DQogdm9pZCBjcHVfdm1f
c3RhdHNfZm9sZChpbnQgY3B1KTsNCiB2b2lkIHJlZnJlc2hfem9uZV9zdGF0X3RocmVzaG9sZHMo
dm9pZCk7DQogDQpAQCAtMzc0LDYgKzM3NSw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZA0KcmVmcmVz
aF96b25lX3N0YXRfdGhyZXNob2xkcyh2b2lkKSB7IH0NCiBzdGF0aWMgaW5saW5lIHZvaWQgY3B1
X3ZtX3N0YXRzX2ZvbGQoaW50IGNwdSkgeyB9DQogc3RhdGljIGlubGluZSB2b2lkIHF1aWV0X3Zt
c3RhdCh2b2lkKSB7IH0NCiBzdGF0aWMgaW5saW5lIHZvaWQgcXVpZXRfdm1zdGF0X3N5bmModm9p
ZCkgeyB9DQorc3RhdGljIGlubGluZSBib29sIHZtc3RhdF9pZGxlKHZvaWQpIHsgcmV0dXJuIHRy
dWU7IH0NCiANCiBzdGF0aWMgaW5saW5lIHZvaWQgZHJhaW5fem9uZXN0YXQoc3RydWN0IHpvbmUg
KnpvbmUsDQogCQkJc3RydWN0IHBlcl9jcHVfcGFnZXNldCAqcHNldCkgeyB9DQpkaWZmIC0tZ2l0
IGEvbW0vdm1zdGF0LmMgYi9tbS92bXN0YXQuYw0KaW5kZXggMWZhMGIyZDA0YWZhLi41YzRhZWM2
NTEwNjIgMTAwNjQ0DQotLS0gYS9tbS92bXN0YXQuYw0KKysrIGIvbW0vdm1zdGF0LmMNCkBAIC0x
ODc5LDYgKzE4NzksMTYgQEAgdm9pZCBxdWlldF92bXN0YXRfc3luYyh2b2lkKQ0KIAlyZWZyZXNo
X2NwdV92bV9zdGF0cyhmYWxzZSk7DQogfQ0KIA0KKy8qDQorICogUmVwb3J0IG9uIHdoZXRoZXIg
dm1zdGF0IHByb2Nlc3NpbmcgaXMgcXVpZXNjZWQgb24gdGhlIGNvcmUNCmN1cnJlbnRseToNCisg
KiBubyB2bXN0YXQgd29ya2VyIHJ1bm5pbmcgYW5kIG5vIHZtc3RhdCB1cGRhdGVzIHRvIHBlcmZv
cm0uDQorICovDQorYm9vbCB2bXN0YXRfaWRsZSh2b2lkKQ0KK3sNCisJcmV0dXJuICFkZWxheWVk
X3dvcmtfcGVuZGluZyh0aGlzX2NwdV9wdHIoJnZtc3RhdF93b3JrKSkgJiYNCisJCSFuZWVkX3Vw
ZGF0ZShzbXBfcHJvY2Vzc29yX2lkKCkpOw0KK30NCisNCiAvKg0KICAqIFNoZXBoZXJkIHdvcmtl
ciB0aHJlYWQgdGhhdCBjaGVja3MgdGhlDQogICogZGlmZmVyZW50aWFscyBvZiBwcm9jZXNzb3Jz
IHRoYXQgaGF2ZSB0aGVpciB3b3JrZXINCi0tIA0KMi4yMC4xDQoNCg==
