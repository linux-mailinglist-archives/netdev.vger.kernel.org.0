Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B94365DD6
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbhDTQvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:51:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56372 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbhDTQvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 12:51:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13KGYwGa110556;
        Tue, 20 Apr 2021 16:50:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vizutN4qjOVBZgUbVWBMCtJcAIxkye7j89XvrdngMNI=;
 b=AGDUR5zimmUPVaeHznGvNZ7KYCOP08SsQgxckeXpEdRFedPD0/hqj3js2i3nj605vu1R
 0AQZNV1bi03WvFbyOMSjsNkgmcuwcOTz/eoZJGF5KmP8bZpgP6vdp9yaRO4BRCUN7+5H
 kIGwYxR/tyty+X7PRhyC8TnTPkiH6Pbnwsta6Y+nF7vSFj1mvNO5+jgkWosdnT1O2jiz
 tmOXB2qyoigl7pOosAuwt3mE11ivOz26h3wlL7SW3nEMbHosVFxBKdZc0sOnx8myRU9W
 nWuV/8kzG4GpC6hgSmZEk8bZ+wbe9dW1AOe80tIjYjwU9Txhz36Uc0Az7P2lizAT6ik9 Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37yqmnfuw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 16:50:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13KGa7gL084073;
        Tue, 20 Apr 2021 16:50:16 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by aserp3020.oracle.com with ESMTP id 3809k0n3gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 16:50:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfpqMCYUmxgKDfDk8ZiEYmC7h1S/5YkL7MGlTr86vW1fwBchqcQi7SecJYiHTP0+GTtvoBpbgC0UoL/E/lhpZVaoGKTCIxOO3vyWaR2BHJeXs5kzWnJPZvbg+n8QlTO62M6Z5+xEO0JwT5Gud/VGVCu7xV554goex7BLZfNfQl739V4nH/Xd616fWhcVt9xtpMMg92g/lzzvA2j2kC7DFasJ8qOz2eWePwHPckjfMYqOqP4Jy4bHtKQGgmF9UJWFGBunQY50xo/orpAmZsnnZ8V/Sf0i9QHrwJvNS6nM62ZWalRPCNBiHcka55ND1Sg13tMIL+NkSGnRNTXj/nUjHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vizutN4qjOVBZgUbVWBMCtJcAIxkye7j89XvrdngMNI=;
 b=d+zO0Pp/AlMQwaXFBrvKZuftS6sYuoVt6pgMf/2+amMkY7D3WWvg6dMJt0JOx9/UMoh2YzuMGPYQ2iNogtejKDACJsXO3Ei8YnNSvMVFWtpWE8nveTsz5F6WWLtcQLuDQpYDhTzaZyepsXU1oOb08cVPARLTbFLAND1R13pqPra+dv3nTUUWmcVT7tKLcjdG0qgO22Jh6vqc1rM/IkcmZL8/QW1meDHqWmDNaqpHndHi9hun0yyjbDQos98pSTR3jZvKtKaFdfe7O9qq8OMQWZlQy3fW4uQ3tZ2YDasH7xhWZIQFqxVspDSHNbp5mG6ce+Ufy9xlS5WsP9Wg2CrmyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vizutN4qjOVBZgUbVWBMCtJcAIxkye7j89XvrdngMNI=;
 b=OAWi4CfS9FEYc9yYcJWQesdmQ2ku0v2ra4gpI/fyQ8OWb+HpBRg7CUtDkXGOU5T/FX5dfr6Glxh1sMAer1c86+WVyzLewyRAQFVcGElq4XjEdPsWy8ovLtRspg5EX0Zud3iE5TnOZb0UwSmD0lVcs5LGTQy30quDh0CXaUOB/H0=
Received: from MWHPR10MB1582.namprd10.prod.outlook.com (2603:10b6:300:22::8)
 by MWHPR10MB1536.namprd10.prod.outlook.com (2603:10b6:300:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Tue, 20 Apr
 2021 16:50:13 +0000
Received: from MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811]) by MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811%8]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 16:50:13 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Grall <julien.grall@arm.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Liam Howlett <liam.howlett@oracle.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: [PATCH 2/3] arm64: signal: sigreturn() and rt_sigreturn() sometime
 returns the wrong signals
Thread-Topic: [PATCH 2/3] arm64: signal: sigreturn() and rt_sigreturn()
 sometime returns the wrong signals
Thread-Index: AQHXNgU7cqnWwo9uSUqkb8fv6D7LrA==
Date:   Tue, 20 Apr 2021 16:50:13 +0000
Message-ID: <20210420165001.3790670-2-Liam.Howlett@Oracle.com>
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
In-Reply-To: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.30.2
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [23.233.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0744ab1-4791-486f-fa11-08d9041c5e57
x-ms-traffictypediagnostic: MWHPR10MB1536:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR10MB1536F93EFF9692565918ED92FD489@MWHPR10MB1536.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +KaajMNyKAuGoiBXyqgLhZfqqvxfUx0WZrWCN9zsXnaqQjYKXs1nlvsDjfLzRogQG9DeX7jEXv/FRzbWBG/xzJ2q+mpI//BM0Y0d+zudrmHBqIvqdWR6XN2cpRE8c7H/+wRXVbFcGqEx8YiNasYoRNRblpJPd3XRHzdUZMKCrYRPlO2kNMUGw6VSf/bPLi5Wwerwyp3IikhXdhzMns9bMpaYBB3pkCQ/H0XhtFbfjRGgGzDctG1QHQcP0XpYUYB2CAMUbu3NRpiJeD3ZGKmBWqZ4GR5rhW33+XgWgqPi7gIod5fxgSNYHjmmVqYhqxCWSmUCi4mzgL8lGDKpyBKOpIne+tYM+7C0DZBidQnKj+MrMoFv9MKt9SFF06dIDl+pMljrh8ZOWnEVuyzQfM9LN9hB3eunbwOHmQ/l8IBrf4kNR+18fmeO/mug3k+ND+VahD9auMipOVAsPE4/SD32rlHyM2cQmDFPYS6yuC8eertWkqUVIrvelFobKRLqiZfsJ6Y9//qxmAxY7zKDmpMki6/sEIuefJ+ZqxPsu9J2psPRbuNprKibXLWeJLl5c4w0gf9YkGVI5ganmjd+p6dIleM5w86mG6bhbZAKCTnMEi0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1582.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(136003)(376002)(83380400001)(64756008)(2906002)(5660300002)(44832011)(6506007)(186003)(71200400001)(66476007)(66946007)(316002)(7416002)(66556008)(91956017)(54906003)(8936002)(1076003)(26005)(76116006)(8676002)(110136005)(36756003)(2616005)(122000001)(86362001)(6512007)(66446008)(478600001)(6486002)(4326008)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?JWO11iNKoXGZT2kEEOnHJiHjuaa5ep220k8G7xTwO+GHkYeBnmnCGoR3D/?=
 =?iso-8859-1?Q?0NGOnKfKqmr5PFBw/M6+yqkwx4Ox72l6Pt42+4Jct5p2paqxr0QHht/ax3?=
 =?iso-8859-1?Q?r5QDL0g3j6cdG0Hf0InlGlkLxdfD+HruvGEqrQKwKp4ogRRjLzBNGKkdxV?=
 =?iso-8859-1?Q?zj01dKmSRpdgrevfXVxerE9ryhhKBiUwhOt2bMY9uiIh0mnU2dxXoWOI2A?=
 =?iso-8859-1?Q?zOulCr5iieLz54cN7EFwckq5W/QcyIGXH3h1bKZRS9E9R8aR2KDDGVdjxp?=
 =?iso-8859-1?Q?0uqI9T4S7qJXE8KlaYeZXQDEnrr8e3SJEn2etUMs4CHIVvUiFGMktN8aI+?=
 =?iso-8859-1?Q?lKRIHR2KYjmi+Hi7QXlUZfrfRz5zkZidgIPVfJapP5pGbAirFNgPpgfXag?=
 =?iso-8859-1?Q?EFjEoPGXWFGj2Y78JZgQemCSCepRNzvfFFimTmtaRsPMqXtoa5j20HShiG?=
 =?iso-8859-1?Q?Ex6z3dA3LIDN6myHgypb2DtBdGEB8DoUQlhmqQ4R17CnU5A2eK3j2cNpNR?=
 =?iso-8859-1?Q?SqaEwD9b+m5sOiLCvr6Y0P+x/BrQhU0Di5ALvXTTJTekWzSuFhOMzVH7ET?=
 =?iso-8859-1?Q?FfL0LoXZBCkldIw5IFN3z46xfvL2ypeMNWzUYKbb0b/gh8W7i3rbXdrSpr?=
 =?iso-8859-1?Q?RWErahtsM2lfon6Cz8q/N3oAPOeCgDiS/1bEHu+4Sgcv/aGKfercXvLyQf?=
 =?iso-8859-1?Q?yfMv18KlAtbJ6o3tIsJXY8VQtI5P1XHTqrs9HlZFY1OEy5Jpj6kXdTioL2?=
 =?iso-8859-1?Q?0rFw3g4F5aQMcsG+TrBUgoasMRmH2O5ctPZuBpDIqfWa1wXI3ZVe3Zndvq?=
 =?iso-8859-1?Q?SaXDZC1hmNqFEpSB11PvCjMfzJ+126Ztx6svjByNavxQhxlG0KoKiBQPhT?=
 =?iso-8859-1?Q?HbTUqZ5xlya/ds/glUmn1vUBGA+79N+Zd2oY/xFB5bPWomSaI3DxQCLz8W?=
 =?iso-8859-1?Q?niFOvk1iy3XWbjsbrCSRPGkfgzjpOV7wqvn+LteSZhwJwSsXTtaddUUlag?=
 =?iso-8859-1?Q?PNmhMwOihU7qm3f/lBVTUdLFmfl5EFJO+Ms7EYGawnC4y7V1VVjbgAU2K6?=
 =?iso-8859-1?Q?DmcWxJLi48vN4adDu8wGiwb/EsMW0XiAN53txuVPuX7mBbUExFopHXZaGV?=
 =?iso-8859-1?Q?246havGKsAxW9QHR++EW8Md6FMC7E/77aMj7RsIr4rIclCkn4jhaxmumf7?=
 =?iso-8859-1?Q?7/cV+vQY6MtnGf/2RPQ6pR9XsTv0LMwbb2n9wy5wmpH0y1cqWwPLcp0pE5?=
 =?iso-8859-1?Q?Ec9hwPP/POn9L29782+KZgS3Pq8mklSDPH6i4IlMfNBlmHaDt3ixqFwoal?=
 =?iso-8859-1?Q?wyNa13wgzfFF1ZgI7E298qAN6GaN7cOOI07eAmoiE/8xXQQWnjQNDDmCPa?=
 =?iso-8859-1?Q?8YqMkOSCcI?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1582.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0744ab1-4791-486f-fa11-08d9041c5e57
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 16:50:13.3897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: laZ5VI74wb9uhFf2ZShI/3EYvuwIlpwp46iwZGb8YmG5AzcAF2u4s0t7e3wtW8C6iSnVcTlTYqv1JIlcPlnJvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1536
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9960 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200117
X-Proofpoint-ORIG-GUID: YcnjrERkwVhP-xy0laVrSODAkpWcIFea
X-Proofpoint-GUID: YcnjrERkwVhP-xy0laVrSODAkpWcIFea
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9960 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

arm64_notify_segfault() was used to force a SIGSEGV in all error cases
in sigreturn() and rt_sigreturn() to avoid writing a new sig handler.
There is now a better sig handler to use which does not search the VMA
address space and return a slightly incorrect error code.  Restore the
older and correct si_code of SI_KERNEL by using arm64_notify_die().  In
the case of !access_ok(), simply return SIGSEGV with si_code
SEGV_ACCERR.

This change requires exporting arm64_notfiy_die() to the arm64 traps.h

Fixes: f71016a8a8c5 (arm64: signal: Call arm64_notify_segfault when
failing to deliver signal)
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
---
 arch/arm64/include/asm/traps.h |  2 ++
 arch/arm64/kernel/signal.c     |  8 ++++++--
 arch/arm64/kernel/signal32.c   | 18 ++++++++++++++----
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.=
h
index 54f32a0675df..9b76144fcba6 100644
--- a/arch/arm64/include/asm/traps.h
+++ b/arch/arm64/include/asm/traps.h
@@ -29,6 +29,8 @@ void arm64_notify_segfault(unsigned long addr);
 void arm64_force_sig_fault(int signo, int code, unsigned long far, const c=
har *str);
 void arm64_force_sig_mceerr(int code, unsigned long far, short lsb, const =
char *str);
 void arm64_force_sig_ptrace_errno_trap(int errno, unsigned long far, const=
 char *str);
+void arm64_notify_die(const char *str, struct pt_regs *regs, int signo,
+		      int sicode, unsigned long far, int err);
=20
 /*
  * Move regs->pc to next instruction and do necessary setup before it
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 6237486ff6bb..9fde6dc760c3 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -544,7 +544,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	frame =3D (struct rt_sigframe __user *)regs->sp;
=20
 	if (!access_ok(frame, sizeof (*frame)))
-		goto badframe;
+		goto e_access;
=20
 	if (restore_sigframe(regs, frame))
 		goto badframe;
@@ -555,7 +555,11 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	return regs->regs[0];
=20
 badframe:
-	arm64_notify_segfault(regs->sp);
+	arm64_notify_die("Bad frame", regs, SIGSEGV, SI_KERNEL, regs->sp, 0);
+	return 0;
+
+e_access:
+	force_signal_inject(SIGSEGV, SEGV_ACCERR, regs->sp, 0);
 	return 0;
 }
=20
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index 2f507f565c48..af8b6c0eb8aa 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -248,7 +248,7 @@ COMPAT_SYSCALL_DEFINE0(sigreturn)
 	frame =3D (struct compat_sigframe __user *)regs->compat_sp;
=20
 	if (!access_ok(frame, sizeof (*frame)))
-		goto badframe;
+		goto e_access;
=20
 	if (compat_restore_sigframe(regs, frame))
 		goto badframe;
@@ -256,7 +256,12 @@ COMPAT_SYSCALL_DEFINE0(sigreturn)
 	return regs->regs[0];
=20
 badframe:
-	arm64_notify_segfault(regs->compat_sp);
+	arm64_notify_die("Bad frame", regs, SIGSEGV, SI_KERNEL,
+			 regs->compat_sp, 0);
+	return 0;
+
+e_access:
+	force_signal_inject(SIGSEGV, SEGV_ACCERR, regs->compat_sp, 0);
 	return 0;
 }
=20
@@ -279,7 +284,7 @@ COMPAT_SYSCALL_DEFINE0(rt_sigreturn)
 	frame =3D (struct compat_rt_sigframe __user *)regs->compat_sp;
=20
 	if (!access_ok(frame, sizeof (*frame)))
-		goto badframe;
+		goto e_access;
=20
 	if (compat_restore_sigframe(regs, &frame->sig))
 		goto badframe;
@@ -290,7 +295,12 @@ COMPAT_SYSCALL_DEFINE0(rt_sigreturn)
 	return regs->regs[0];
=20
 badframe:
-	arm64_notify_segfault(regs->compat_sp);
+	arm64_notify_die("Bad frame", regs, SIGSEGV, SI_KERNEL,
+			 regs->compat_sp, 0);
+	return 0;
+
+e_access:
+	force_signal_inject(SIGSEGV, SEGV_ACCERR, regs->compat_sp, 0);
 	return 0;
 }
=20
--=20
2.30.2
