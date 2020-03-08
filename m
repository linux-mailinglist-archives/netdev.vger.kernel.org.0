Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB6217D156
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 04:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgCHD4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 22:56:55 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18590 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726252AbgCHD4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 22:56:55 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0283tEk9026867;
        Sat, 7 Mar 2020 19:56:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=k0vIAxn3AIo8QaLwrLyG1NeeznnzsFDK5s3ERyd1KbI=;
 b=aFvTt9PnrOt4CA+9grRuozihx+Edpge8qvwgkKdt7boAqF4jwXl7QFppT70mVn3KWl0w
 aI6St/VPFT3FLpCr1mdgqgF11Pm1leV9USQYwFR4FXhuP0gFywCeZIPMLHBmASpc2ZJ6
 E8Edcq1SUf5WwqyXjRVEUvkV/fTlUhZaDvp9oPSHWJYCKE4DQYL3bFXfQHng2q8vquYy
 mY2Lu6meN2bzxMIuhkdcze/5/2efZqqDt7tZUPDiSIcHpsCMdlDtKHz8mFAuZM2ROCbU
 lU/egrWBQQPpf6j9c9xLiLYSy1cURbs0BvmUdZ+P4ZfPfsLpyuXfgVqVLlVsiXdKXNMx Sg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ymc0sj26d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 19:56:17 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 19:56:15 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 19:56:15 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 19:56:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4aqvJs3k/zx959CzOLGJyWBlXOUgSzeJuZcvp0bAJKgGqsDFlx9IxXUcaATVcR9yJAcuePtTAyCxxGxVdcNV927Cve1EEXwD6KaD0pel11iGxwSxcQt1sRe1r5rR3tDMtvoKUdK/yCNajmjcn91SiOPIJJpCymoN3t7ZVCKMdACcO1StohqqxZvlo8Mb0MZ9yTQiM2DTIfBkLefcEo8I4up/pqTUOkJYpJsPW81DqN9ANINup+/2eGmxmtJXo0Kr7dkamokAzIgOT4LONzXAj99/vv3wYjYRN8j+dUIAvgjif+OWdTtpay8z72Oi5rfqvuRHdMEfWD+VvWXd0OyCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0vIAxn3AIo8QaLwrLyG1NeeznnzsFDK5s3ERyd1KbI=;
 b=HS3ObJ8ZbpNXp9EYD0JEkv7dp493rnYxxBHUZv/9dgwLERUnlkkWqoTqzpBRbEN5TMf/67DWpMESRundXKllesnpMFgjM0EDW5N7FxU2te4bYwjk/nwQiUxXDJsUgc7gaGG8fuRpg7CS6lU5InEnnf88rFVyVNVym91EwgkPJ30gd4AJ+3LyAmP/c0bBQwf0vcVnbx6XPixwKAmRkR7I0fya0lIlqOib7RyzV0gisA52i/RTB+d4GSi7br5sGqku7AM+rtRWtkQPUYM6UVeRWihb2HiAcQ4erasIu8DImDzAyl3pIOsEv43nZMJXuUZPUqjtSzLr5GWiPQK/Ys1SHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0vIAxn3AIo8QaLwrLyG1NeeznnzsFDK5s3ERyd1KbI=;
 b=pmEJI+xUk88noa5FnL40505PiOwBfKIg+eRAK15as6D7MAa1+d8ksIyqWyTV0a7c/5dPSv/B/3TvQBOATj0YvGCe3DyH2Tk0QY4fCx7EROF4EzVTH6AO83MANRgbtUknc1geZ+/Wp8JnRUcsRU5W62qvV+4e9oUMl5wysRgsUjM=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2661.namprd18.prod.outlook.com (2603:10b6:a03:136::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Sun, 8 Mar
 2020 03:56:13 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 03:56:13 +0000
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
Subject: [PATCH v2 11/12] task_isolation: kick_all_cpus_sync: don't kick
 isolated cpus
Thread-Topic: [PATCH v2 11/12] task_isolation: kick_all_cpus_sync: don't kick
 isolated cpus
Thread-Index: AQHV9P2C8Ps2pU+gnk+87Km1UNmHNA==
Date:   Sun, 8 Mar 2020 03:56:13 +0000
Message-ID: <dfe656e79c4f19d037f788748d47b2e2802988b2.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
In-Reply-To: <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e28157aa-2ca2-4fb6-7ad0-08d7c314a567
x-ms-traffictypediagnostic: BYAPR18MB2661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2661CE44537148D4F029EB9DBCE10@BYAPR18MB2661.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(39850400004)(346002)(376002)(189003)(199004)(36756003)(4744005)(71200400001)(4326008)(86362001)(2906002)(54906003)(110136005)(316002)(2616005)(8936002)(81156014)(8676002)(81166006)(26005)(186003)(66446008)(66476007)(64756008)(66556008)(66946007)(5660300002)(76116006)(478600001)(7416002)(91956017)(6486002)(6512007)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2661;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BOWGO4LhwRBTMLm5/CQrGqZJPeajT1OFva3gjwLbus+yIY7/6Uo0jBdstk0NOSdUxVZLvfGcZTEQyQEyZ9IV7FlRr9gazC3JxVZzGKiwmv5LgOflqy7eZPc/i5ecqpqvlbEC5eqFP4FfTehtDHaOqpDt4KouKq8csYldMD9oHpVGKu6MG2LzTsugsF9pvwTF/vxl1NeaM2R6igPJKLixSmpm3LBE4OPiuuYwag59YCyKkuZjsAfilEpQxDfcw1SZm6wDhCsmyXQ4vgIU0lpaq9SgcHIKngqUjchxaqLzuuriyNMZmjs/4HtSmY92WJnkMFuBde/QVXSdcO01CikxYAcQtuC+FK28TCmIoUB34HTF3IQewZBdwpdpZ7EPUneiGufMdaMqUlmUwAQwDlE35kaA/mxMzM3FGJ+uU8/Oti+tqg2K3aQMGlPmd534nD4Z
x-ms-exchange-antispam-messagedata: ANR7TG8upBWlsjUwlwjj5USQwR0UNR4FGVu+5hrvI4z/CboyKMRlQuLwMRaHKbdC7ii/28Hv02CHJMevElORSo2fnnJtIp69fkDnC+cRj+AUWD9/AKFKS310XCJMEfWHSiY9KFoo54LLU/bPwPXCrw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CF0F9A752365D499FA079925E0AB4FC@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e28157aa-2ca2-4fb6-7ad0-08d7c314a567
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 03:56:13.6429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IB/79jGHa0db6moNctxQP7N15aQ1TpSxdMtMT2QoLICroCaO8nusVbywKuGgsf3+Ffbby1eX2XhklmNF0dYGPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2661
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-07_09:2020-03-06,2020-03-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29tPg0KDQpNYWtlIHN1cmUgdGhhdCBr
aWNrX2FsbF9jcHVzX3N5bmMoKSBkb2VzIG5vdCBjYWxsIENQVXMgdGhhdCBhcmUgcnVubmluZw0K
aXNvbGF0ZWQgdGFza3MuDQoNClNpZ25lZC1vZmYtYnk6IFl1cmkgTm9yb3YgPHlub3JvdkBtYXJ2
ZWxsLmNvbT4NClthYmVsaXRzQG1hcnZlbGwuY29tOiB1c2Ugc2FmZSB0YXNrX2lzb2xhdGlvbl9j
cHVtYXNrKCkgaW1wbGVtZW50YXRpb25dDQpTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbGl0cyA8YWJl
bGl0c0BtYXJ2ZWxsLmNvbT4NCi0tLQ0KIGtlcm5lbC9zbXAuYyB8IDE0ICsrKysrKysrKysrKyst
DQogMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlm
ZiAtLWdpdCBhL2tlcm5lbC9zbXAuYyBiL2tlcm5lbC9zbXAuYw0KaW5kZXggM2E4YmNiZGQ0Y2U2
Li5kOWI0YjJmZWRmZWQgMTAwNjQ0DQotLS0gYS9rZXJuZWwvc21wLmMNCisrKyBiL2tlcm5lbC9z
bXAuYw0KQEAgLTczMSw5ICs3MzEsMjEgQEAgc3RhdGljIHZvaWQgZG9fbm90aGluZyh2b2lkICp1
bnVzZWQpDQogICovDQogdm9pZCBraWNrX2FsbF9jcHVzX3N5bmModm9pZCkNCiB7DQorCXN0cnVj
dCBjcHVtYXNrIG1hc2s7DQorDQogCS8qIE1ha2Ugc3VyZSB0aGUgY2hhbmdlIGlzIHZpc2libGUg
YmVmb3JlIHdlIGtpY2sgdGhlIGNwdXMgKi8NCiAJc21wX21iKCk7DQotCXNtcF9jYWxsX2Z1bmN0
aW9uKGRvX25vdGhpbmcsIE5VTEwsIDEpOw0KKw0KKwlwcmVlbXB0X2Rpc2FibGUoKTsNCisjaWZk
ZWYgQ09ORklHX1RBU0tfSVNPTEFUSU9ODQorCWNwdW1hc2tfY2xlYXIoJm1hc2spOw0KKwl0YXNr
X2lzb2xhdGlvbl9jcHVtYXNrKCZtYXNrKTsNCisJY3B1bWFza19jb21wbGVtZW50KCZtYXNrLCAm
bWFzayk7DQorI2Vsc2UNCisJY3B1bWFza19zZXRhbGwoJm1hc2spOw0KKyNlbmRpZg0KKwlzbXBf
Y2FsbF9mdW5jdGlvbl9tYW55KCZtYXNrLCBkb19ub3RoaW5nLCBOVUxMLCAxKTsNCisJcHJlZW1w
dF9lbmFibGUoKTsNCiB9DQogRVhQT1JUX1NZTUJPTF9HUEwoa2lja19hbGxfY3B1c19zeW5jKTsN
CiANCi0tIA0KMi4yMC4xDQoNCg==
