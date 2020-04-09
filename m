Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED671A371A
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgDIP2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:28:33 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7090 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728241AbgDIP2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:28:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 039FQBIM025351;
        Thu, 9 Apr 2020 08:27:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=k0vIAxn3AIo8QaLwrLyG1NeeznnzsFDK5s3ERyd1KbI=;
 b=qe7FCwnE8uUMo2rm/X6HGO6ytpKn5IY3cB70lW+DOuT2zx6r17u1mk2oSECaugY0oGWz
 cSz97Iw0cIC4sEgt8muegN+QtZXKXVUPkp8TjwemCUhCy8rB78wWl7fAMyaIuHqoZpy+
 O2X18GJ3KBDatYTHxfG2rz/SKiaGRjgGvrBvq7wGbZow0zWKLBD8Sl+BdSzbkCYquNON
 MoWBLcuWl5F7LkooI7d44VSpm7moOsYJIYLOd8Q++m2b87n7/WT5h7/q3iYD1P7FIMjS
 uBky3OcMiDVRu4XO+Mmh0ZCmv/RZkkL8Z1+cHOWrrI/tbP4tMzaOLpJWiKFXt3WnIYNd cw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3091jwh1gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 08:27:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:27:55 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:27:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 9 Apr 2020 08:27:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kN0q5pSX36g7DqrIeltmL16F+i4rwFiIfzBGU6fQKb1WRqE1MjrC1d8UURAjM8NcIzGk70giFWN4krTjwC9MtKKFiBUBmS4DGZEWt0pB2wws/V1v7uV4Hb8RIS16+R7MZXINQznpaNYo0LBnrf3WhhzPRxO8bVwjDqMuVeDohNh7RtJRv6jXT2lbeaozetkY4DG+8WLn8nkYc/zBwwzE0m6mCuxoCpZfyaTXGNqBvTff0SQVQugLOhRMMOEwwIcaXCsoxjpwRzmI40tqS743y5lZcaaAxCRHIiBaErBaE2J1qVP9pWBzT2qhrp2//fF8WgkzdgzuSu5rMcwg+4aOIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0vIAxn3AIo8QaLwrLyG1NeeznnzsFDK5s3ERyd1KbI=;
 b=A4PLFoJsp0tU52/qdB9BGcGAhxY/IWcT8832/pi2MBuBBb6ePe4cdIFMQ3A3Q8sZw4uTONFB8VcmGBJMAx0tk6vJeZ87BXrHO24jJYnZS16Oygy3EjgLhUPsGazPS/VxE/ds9xXOWXDtaKCwW807WHftGX7tXq/s40TS8leP3pjvFkyVRL7Sulcq7b8Av4ARoVJVEzCHQmhu3W5lZaAaL5g/cKzqbk5nNSOaDgcRa9LXzzOHy6gWNf6B0qcSibusajLrBRQSiasjqL/5ojUr9rrX0NnLJChRyx9mRrd156vJn1JOMfx3+HkxVV3EmpJGDZJuL9AMmmp6IiIyNm/m+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0vIAxn3AIo8QaLwrLyG1NeeznnzsFDK5s3ERyd1KbI=;
 b=DSmyyCVCXvgQoi+E4U9NmZuFBykMUhTnwIxJ16mBday0AjYtuPPtp27d5704SPZlcUl1/uWqnbtb8rS7t0KRh1iUfZ5prbh+xpMdkETDUMSn1O1CTio1149hacJh4PUFZT+Su8OEicvAajy3CE+aZ8PACE/xUaTKPO8MAczqqcU=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Thu, 9 Apr
 2020 15:27:53 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280%3]) with mapi id 15.20.2878.022; Thu, 9 Apr 2020
 15:27:53 +0000
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
Subject: [PATCH v3 12/13] task_isolation: kick_all_cpus_sync: don't kick
 isolated cpus
Thread-Topic: [PATCH v3 12/13] task_isolation: kick_all_cpus_sync: don't kick
 isolated cpus
Thread-Index: AQHWDoNvCsQmG23IQESmsNGJJIL4Cw==
Date:   Thu, 9 Apr 2020 15:27:53 +0000
Message-ID: <9da10e7fdfae23fe397852d40101e8db1f1faf07.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: a9af5b79-3b4b-40a8-af64-08d7dc9a922b
x-ms-traffictypediagnostic: BYAPR18MB2423:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2423833923BA75D740155F10BCC10@BYAPR18MB2423.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2535.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(86362001)(26005)(186003)(5660300002)(316002)(2616005)(81166007)(36756003)(7416002)(71200400001)(2906002)(76116006)(4744005)(6486002)(478600001)(6506007)(6512007)(66556008)(64756008)(66446008)(8676002)(81156014)(66476007)(8936002)(66946007)(54906003)(4326008)(110136005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X0fWa2SO1Qha7T7vwCLR4dH2fXuFyrKohGypdpJkuv+QQCcrIjSLLVgvA8jc4xti9/3tRMBzlfp5ZZMYYtoHcqlbRtXtY2JSHPsnydWr90FYmYNuNCvEfyc+sXC6v7zceihtlanclqUzdpYbxaYPypUeQ0nLIIA2mdAeYqLs4hfEGC9glPRyXGDz9k6P3Oi7wHVfRxSGOm6q1P45FPWTyPTScpwC/XkI1/UgIvOE5Nx68GS5Xhi89ezSr4deulxw7NR55BPK7yfkw8lHmResMc2C6DefBwVP4LYyxcD0kFGtMFfyorU74WelG8zmT0rE0XcOCb5DhreRci1hKjnpqqb6S9f3HFWC7M9xkBTeYcS6khT8CUX2EjUdzJu3qVkViC1a1h2jxeTzzDZEuPnydjc09tPaxkPJSwngF/xrLRiIahYDoPd5vAj4um0xWoAr
x-ms-exchange-antispam-messagedata: 1rE04AYJ2QJSYPKCzQRgsgGLW70JO8CIf+MJYE14EOUcc6OsPWn7OD8kyafU3DQ1qAPDJnjnmRYLOFtVom2GMgHGyebSP5/bOEDh/mLetBmAJgV6Mruxztp1MOSDoO0CznPzWivj5yI8PWMZHmkvrw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <9171AFCABF030842829F8BF831A406F6@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a9af5b79-3b4b-40a8-af64-08d7dc9a922b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 15:27:53.0066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9lK+jAPSqguK6cbxa0k9DgkDYaThVJwmwIQVbBI9GHN+PBh+ZsG4l0Q5WMbzVIHd1mePJbx6q+bHV+VWCOA02Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2423
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_05:2020-04-07,2020-04-09 signatures=0
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
