Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9886A365DDB
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbhDTQvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:51:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33302 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbhDTQvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 12:51:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13KGaobr173668;
        Tue, 20 Apr 2021 16:50:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=dzcqGSkZyw/D6a1e/bPszDOHvl2ObGE0tmn5ByRCFR0=;
 b=znHSlSPDmDRO0AjA+5IPFrMG4kvaA6/i9dubPJzRxkeZ8lGpOg+wme2IvoqMXyKZeadw
 6pDD/G3uys2pvl3B0yL3pf728qlbHRrMb1g5NtVKrCx874OVXUb6KQJzrptPwLSHAYR+
 f16o6ObbgETD8wQvOU4YBunUk5HJK3z99xBu7eo6O4A5hi2H/Lz7tLtWucWEnO9XkH4+
 8N6w8bmU+qSzcjQugYlEOZTDbN9YmEb4EeYbPd50C3qZNU4yakCucPeTDbAI+qun5Xgu
 HX9Fg3jTwqUtGgFtODtBUUgtbbm3v7kqS2QAJDihHsr2qSNb/1lrfjtkaHafZ1hv/tc5 Lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38022xy8qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 16:50:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13KGZtsO102703;
        Tue, 20 Apr 2021 16:50:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3020.oracle.com with ESMTP id 3809esxw95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 16:50:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbC7rsIXwEZxiWhgjdTlfNrOrYarqKvL8Oy6UkCKeO5T45ETZge0Cy+13cobVrUWR2cCm9TKUg7GCqzz8AH0Jxby2L56FrO9/a75J//elDRcobd8bIPpqFjXQeMbGKwIU8gLISaxfwfFwFAFsWTNTcrO6pkKzVYwClZIUwtd7Uwoz7zWw7vcQhVVJV7ELsIkbI/TXMPO/B/gWoSh3blUqsUnmD3KgEp3hbSGayT97arNnLwvo9Mt9t8vOPF0qKjXCSkEnL7un6Bi0DAzjlRfOZSZ4P3d9siQOuFcmapqu9ta+BW/GIpycoy3yjJcFZsP1BcBSUKq0HgWx0VWpmwmrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzcqGSkZyw/D6a1e/bPszDOHvl2ObGE0tmn5ByRCFR0=;
 b=DHhzsGNQkRgZSAYFMZ3RVB/QbtzAmnneANCTvjzcdcSOZYhC+dvdCLvd1Y3Fc1Lh7EAnhBMCU5ttkqrpi+F6zDlP7gP1vdq76UuwmRotHwyJEMHPtb8iJsCbwarZoAblChKxFilsnwstiiYawuOEib74AcmS/UkLkCifOsBovwxkosmNZoh9D3w1jEOjl5gVGY17ctFK5Zt42W9dVFkc576T2EbzEz522eufJHN8HvlakzlPMa4qRTg6Pr3CavmGPWbI/f+5XCkg6QX/UrYmHzvlGZRQif5wH2TKM8OohST7+jtyDcjAKl6a3qxLUQmd0r9tNHoJiINVdi4NmCCLwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzcqGSkZyw/D6a1e/bPszDOHvl2ObGE0tmn5ByRCFR0=;
 b=qBc1+owSFuEopiS0zuUXItO1bCCp5AvSHlk9P6eDF5z3rXjpA+iFR29YSfkIRdCfnlmVhxC18ts0Cxal0yhoa51rjJ6tVKkoWscbK69yas3DNQf1BKOJK9QwwmtXXZdyvJ5VWYpq5NXFlVziUOQqTZdUpW4OyXP+D7Oai9RSAmI=
Received: from MWHPR10MB1582.namprd10.prod.outlook.com (2603:10b6:300:22::8)
 by CO1PR10MB4772.namprd10.prod.outlook.com (2603:10b6:303:94::11) with
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
Subject: [PATCH 1/3] arm64: armv8_deprecated: Fix swp_handler() signal
 generation
Thread-Topic: [PATCH 1/3] arm64: armv8_deprecated: Fix swp_handler() signal
 generation
Thread-Index: AQHXNgU7pAWIynV4NUyh79ZCugEeMA==
Date:   Tue, 20 Apr 2021 16:50:12 +0000
Message-ID: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.30.2
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [23.233.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 667a504d-3ed2-4e5f-7c57-08d9041c5ddf
x-ms-traffictypediagnostic: CO1PR10MB4772:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR10MB47729C0C93A53CC8C0E598B7FD489@CO1PR10MB4772.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qfAoNk2aQchsMUGi/RhIfy9VOoAt853OrOrKK6PCeMskcU1/tW7kgEhpO5HcJyIz25Yh8cUYp0MuqfCTtpLrSrSTbdnD9A+PncQ441A33UNcNuv2x9CTKauBqmPumf2mhTamN9SbN589HgVJLjL3bETu/u+tYQr88i4XSKFG0ghmkpuUmR0gnxIhOfzN6fMkAY7dMIPrpYEviIPIJ9nZ+KkMvBXv80IQGhqjjaZCEENNaOGQKka/h4DfU/maePu+3xbSMk7un9TQ5waPZOwsoNwylPevbvQcqy/rzTBLaU+0Yl14htZ8y3G8i09y04p0GISQlaubpeb+0e9e1dWWvg5tsoYKiyTKVy5KHjvzNGLGSGEj5U8+09B/sSvhTjEiuIjPwJzSLx8oRXRsrsSt6u9SYR0xuO0Cdjnwx3xIu67tfaQOi/J7Meoo2q8p6+adGVOJQHsDRVCEqZc+0leorOUKIKUJMfh+jFQfcZHn94/TlfDJJ3w8Vkhzr+I8li4GCACmfsAgjBNUUR4uPtPUS1ltHK2oG94ErKFKQqYNaIyf/T5sXtpCcqSl2uxPzpQvK2oGqA35po3SwzKVIcOwG0Du6zca17kKIbDfUj/Tuvs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1582.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(39860400002)(396003)(376002)(6506007)(83380400001)(6486002)(64756008)(110136005)(5660300002)(8936002)(8676002)(54906003)(7416002)(316002)(66556008)(91956017)(1076003)(186003)(66476007)(2906002)(4326008)(71200400001)(36756003)(26005)(122000001)(2616005)(6512007)(66946007)(478600001)(38100700002)(44832011)(86362001)(76116006)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?NPBlHEnUgG85WhkzAy6ZEt++k138tubHOZrVSm3nVetXXrmkY6wm/rcVhl?=
 =?iso-8859-1?Q?yAzko/W25WALMzRW+BCT1WfRtTpor6QaQuuD3rm37rskuVBlEbiOhWH8jV?=
 =?iso-8859-1?Q?fbeVnJg3zlkxMVmLb6KvwZ9G7VHW0zKNBwnqnAroKHp4gLs7Hj6EIhsFur?=
 =?iso-8859-1?Q?Gs9mwdrsx3nfca72m8kf+/RXl5EFCeNAQUxgYJX5Mw0iW2meVXOqmT9kza?=
 =?iso-8859-1?Q?dJXL2ZMMKxZZa1Q6jTZ3unRNpfF5ZXheORq7eRBFk5wjHDkGuZbgC38I5M?=
 =?iso-8859-1?Q?E595JsPvEOz0FSL12FrOwe1bJb5YAeRk1WHxpZccTb78pX0OEDQVJoyLnF?=
 =?iso-8859-1?Q?y5+KlvYNBYuNtZfmKDuclvS9E5tnWjs12IgrFvHrb5vLKhQpOK5TL72N2b?=
 =?iso-8859-1?Q?wPuhJ+3796155ICnyaIkjWFxhyb+gA3kOFLW/vmf4Pp9yUwtl+OkjTXSwh?=
 =?iso-8859-1?Q?IBX8oB1V/rr5xduMkrXkgyD5Vp8iB0dWK4yx7FgIttgrlXl1juMZIyzSxU?=
 =?iso-8859-1?Q?aK7xvYQOj3x1a9xt0zPYdeYKBY8LN3XTbp7+3Oo01TVvR8o+4oRfAQRQ5w?=
 =?iso-8859-1?Q?Qoa03rNPV3kutX7yd3YXG8gcBigopDmQiYracdSghV++eorRYY+WWjAE7p?=
 =?iso-8859-1?Q?zhOpnHaMoVDac2/A7v4K27MkAgnTxFeFEK7yXiHWuzh0mZd+0kSKBxx2Uf?=
 =?iso-8859-1?Q?1AzMui62c4MnI/V5r76plwLZR14dTzF+bedwlnSn3fN4Ccm3AmMQxDoHpj?=
 =?iso-8859-1?Q?VnHk6CF/kbgUj1PCs9opB/MTmzNtFsFXaAKvxT6v0MRUReOEXvYb5oj7Bv?=
 =?iso-8859-1?Q?RrwNfx9IgFp/duQhSu6rzPcrhqpZp4LBGrF2Wn5V4F+5RYSKlZDabC9rbr?=
 =?iso-8859-1?Q?CHgoJCPrXNkmvbNXgsN/mYilVgOuFU7EzgXcdawdc5yIqn0KRglvVEhc4X?=
 =?iso-8859-1?Q?XFpFU8QFO7HniXAbDRJEmUm8HI2DDOYETXG38ItpQom2ef+xDYOeqIFplU?=
 =?iso-8859-1?Q?a/apxHt53XP/dTWIpV0SWM1e16eVoCPO5r3/kEevaCEFqPYmOYBvMQmAsR?=
 =?iso-8859-1?Q?xydyFrEofgGoMXqWvFQkPFP2SpAmUOzyzqxI6mMX0oKpo1fSm05qACqeQp?=
 =?iso-8859-1?Q?ucS8u7gy5JAi60Gc8O61vg3DdX93A9A4vx5rdO2PGCVa8J8XeI3JWYd688?=
 =?iso-8859-1?Q?K6PijErVMBg1Jq+8RnRpW4GVI+JvsagrcIkTCgK9SOo+9k3nBcWwRM/n7o?=
 =?iso-8859-1?Q?AfPoI8K7oQjGKAXdF+0jzHJDuHBW5Mp8LOMUoVSlDvz6mT81VuOxo7pvfn?=
 =?iso-8859-1?Q?sDR+EPmSEBMQL5mC6eUOpB1tXGQ51kNpkejXZE+qbBtGdul40zwdkwFl8g?=
 =?iso-8859-1?Q?+vXISlRS+2?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1582.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 667a504d-3ed2-4e5f-7c57-08d9041c5ddf
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 16:50:12.8429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D9qXCdvovrjf9VinGe/UJqT/H3WoMinDhk6rZjZm+12kCme2UXbkva0deohqSy2thifru51k5ObMHXwc2j+Eig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4772
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9960 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200117
X-Proofpoint-ORIG-GUID: tuDDPyW461aWiHkKAXJlI4tzj2P2zeAj
X-Proofpoint-GUID: tuDDPyW461aWiHkKAXJlI4tzj2P2zeAj
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9960 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1011 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

arm64_notify_segfault() was written to decide on the si_code from the
assembly emulation of the swp_handler(), but was also used for the
signal generation from failed access_ok() and unaligned instructions.

When access_ok() fails, there is no need to search for the offending
address in the VMA space.  Instead, simply set the error to SIGSEGV with
si_code SEGV_ACCERR.

Change the return code from emulate_swpX() when there is an unaligned
pointer so the caller can differentiate from the EFAULT.  It is
unnecessary to search the VMAs in the case of an unaligned pointer.
This change uses SIGSEGV and SEGV_ACCERR instead of SIGBUS to keep with
what was returned before.

Fixes: bd35a4adc413 (arm64: Port SWP/SWPB emulation support from arm)
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
---
 arch/arm64/kernel/armv8_deprecated.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8=
_deprecated.c
index 0e86e8b9cedd..f424082b3455 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -324,7 +324,7 @@ static int emulate_swpX(unsigned int address, unsigned =
int *data,
 	if ((type !=3D TYPE_SWPB) && (address & 0x3)) {
 		/* SWP to unaligned address not permitted */
 		pr_debug("SWP instruction on unaligned pointer!\n");
-		return -EFAULT;
+		return -ENXIO;
 	}
=20
 	while (1) {
@@ -406,15 +406,17 @@ static int swp_handler(struct pt_regs *regs, u32 inst=
r)
 	user_ptr =3D (const void __user *)(unsigned long)(address & ~3);
 	if (!access_ok(user_ptr, 4)) {
 		pr_debug("SWP{B} emulation: access to 0x%08x not allowed!\n",
-			address);
-		goto fault;
+			 address);
+		goto e_access;
 	}
=20
 	res =3D emulate_swpX(address, &data, type);
-	if (res =3D=3D -EFAULT)
-		goto fault;
-	else if (res =3D=3D 0)
+	if (!res)
 		regs->user_regs.regs[destreg] =3D data;
+	else if (res =3D=3D -EFAULT)
+		goto e_fault;
+	else if (res =3D -ENXIO) /* Unaligned pointer */
+		goto e_align;
=20
 ret:
 	if (type =3D=3D TYPE_SWPB)
@@ -428,10 +430,14 @@ static int swp_handler(struct pt_regs *regs, u32 inst=
r)
 	arm64_skip_faulting_instruction(regs, 4);
 	return 0;
=20
-fault:
+e_fault:
 	pr_debug("SWP{B} emulation: access caused memory abort!\n");
 	arm64_notify_segfault(address);
+	return 0;
=20
+e_align:
+e_access:
+	force_signal_inject(SIGSEGV, SEGV_ACCERR, address, 0);
 	return 0;
 }
=20
--=20
2.30.2
