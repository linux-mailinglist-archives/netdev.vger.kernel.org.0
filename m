Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C39A356FDF
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353361AbhDGPL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:11:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52434 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbhDGPLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 11:11:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 137Ex1Bv086989;
        Wed, 7 Apr 2021 15:11:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=iKxAAXmIAdM+XcEbu/EfiWn7LDEZ0lLiktlmTPgvr7M=;
 b=eA2fFxipP9XRjwe93JkWxEGeHfActDPrWEfKo+6SuY5mPMRqJm9MmEFDuQq0dpbSQ2E+
 bxemzHdIcwmt4tspF5Nwf/TTibw+q6E139PnHzq1+WAnOeOFVd70nXlva9xABEhhD2st
 kjLZDV2BdC9eiuhESyI8IwT1jTiDtb0O+fhCR7jMrwkrsyUKydAzMmAPAi00LxyEWKXC
 kbcb9eX1vaXsfwQ6z7pFe1I7f+CTxDoI2pVIdxe/eWTovvmn4k656LeX5hMTK6TSZaM6
 M17QBjzySv2bl4YinLNleeihatiE/pLqd31qfn1WuFkyE2Phuxij+bkgDamspOHRk4Ik 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37rvas2vhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Apr 2021 15:11:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 137F1LnJ019942;
        Wed, 7 Apr 2021 15:11:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 37rvb44gb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Apr 2021 15:11:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtvM4wzTSBhJAEkMFNKd4CUUDYzEqa26Q+jfSgIjUNEbmvOEl597eqxGpfc3eIO9WxV19GR6fPbU6Eo6uQfch2/h7FrKYBH24TYHy3B9plbOC80Ne3X6dgm5oWzxSeB3BkU/8GQ4WRzc5nfmXb38vGrtUHILRg+1nRX08lcmOt8rgOHVIXIA5enAsHiTUA/nHBJI+ckokEOpYXiqBanRxopvXSyYvOE9nRQ14qZoUaVMfqWv8jnJPqu3+UAZErYp2TuUL6cm2vEdfitpnxEWS4FmUsj/Cj8Id9loGo3WPZhJqCp9MPBBKbE9xwI7vHIDLf0d6WiuBNXYne4+apndmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKxAAXmIAdM+XcEbu/EfiWn7LDEZ0lLiktlmTPgvr7M=;
 b=e1sQS4nCa3cdT8JO3WLoFWJ1SI9vI3MKNym34mJIS8fuSYzzg35tq8euAftRwGFMu4/z/2DhmcYrWfwxyGQO32OyIXP1WMNDEIP8oARi7MVcjT1UBlr2TGxVjdSqI2Krxp4G5iFAnyv1CCIv3OX60hHMLDTDXdz/85B5y/K1Rk9YXzAF4z1Fgyp/jrVu2PaPhmyK71gcpRahFlEjb4P/fzByin+Rv8jNhH5qkZcXJo/AyPGHbCviNU+KoOKwotIfFib+aGqUZ3xcCtJpNIWLneZNHIhVcT4STeTJxpLCoaUMbYBfb75Js9ncLSjWLmXdjOHLUoiwz61o9BsnRBMB9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKxAAXmIAdM+XcEbu/EfiWn7LDEZ0lLiktlmTPgvr7M=;
 b=I86vhspd+p3XTtBX8lzDBt+61owBrkR4y6OaI1BBMmXED+PBLvsrS5ilrCKLRO6LkZhquLlca5SIVX/8Z/DZMiGZufDHpoJ1bwa6ew6wcN8epRa5xokRpBqwx3i/jyrAhVRQ7rN408OPY0ttiY0yj5CUJVfRD1/e3oGVAQafik0=
Received: from MWHPR10MB1582.namprd10.prod.outlook.com (2603:10b6:300:22::8)
 by MWHPR10MB1839.namprd10.prod.outlook.com (2603:10b6:300:10c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Wed, 7 Apr
 2021 15:11:06 +0000
Received: from MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::1ce7:260b:b004:c82c]) by MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::1ce7:260b:b004:c82c%11]) with mapi id 15.20.3999.033; Wed, 7 Apr 2021
 15:11:06 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH] arch/arm64/kernel/traps: Use find_vma_intersection() in traps
 for setting si_code
Thread-Topic: [PATCH] arch/arm64/kernel/traps: Use find_vma_intersection() in
 traps for setting si_code
Thread-Index: AQHXK8A77pSb5Vt+VUCCce95n7TITQ==
Date:   Wed, 7 Apr 2021 15:11:06 +0000
Message-ID: <20210407150940.542103-1-Liam.Howlett@Oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.30.0
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [23.233.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50b4537f-d9aa-4316-c803-08d8f9d75e47
x-ms-traffictypediagnostic: MWHPR10MB1839:
x-microsoft-antispam-prvs: <MWHPR10MB183911767865C8E492100E39FD759@MWHPR10MB1839.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2yLNZeXb36xoNknR6whoZG8+OtbrbnbF4URbJh3eLyCAti2YrVbxjjwtu4JSFcN1qZMPVnJaGmEBmADKHfnYEofiGukVe7xea6jVgD2AxlVV370D+uJ8wQEZi6cQv80ZB4JZeTbXBiC+0I4B8vTrlL+VJ0hOosnQrWs/3v8k0A7vrIfeTenfNS8yRmjt9rfVtLDQQwflugdpHnh2UZ5Ko7aFzba+bvCVBU+3IuRDPeF9glfcoB/y7tl5bSpiU3VOdgs5uy9zJ/gO2XT9ig4Tf3hOxnBUsZzav0JkWd+AI1UP5VkYM7W2uMtNhYJCq5UGtM9+h0zet7RaKXSMzpO0yxSsduvE075aoOIZ2zLa1seK1RCmS3FxlY0+R14o7IimIcNR+YJfsjRLU82KSDFkG44RUqlmbnO0dA67ykoD7GhjmIljym/baxUCGmMS8pTJWd+0ID2kEE/GakHrDILR1Z73M5VPrb5KzPdwoywspgASxCmnDQoICKDaa5Ttb6AJTATrWX736uZKxDe/OWDksc5dV2htB7JXqcWqJAVp7i20xNOrveO8W6BgcRhSysGy2L5hTgFWpeu4QPJGECdKZOEAOkxTbnxcxiqPotUdBs0Q9hzgegkMbskWpimmztqU78qR+0JzRmK8ORkcbm/fdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1582.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(366004)(396003)(376002)(91956017)(66446008)(316002)(6506007)(38100700001)(6512007)(66946007)(76116006)(4326008)(8936002)(8676002)(86362001)(7416002)(66476007)(66556008)(26005)(71200400001)(6486002)(110136005)(478600001)(2616005)(186003)(54906003)(1076003)(2906002)(44832011)(5660300002)(64756008)(36756003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?UMHs7Vj1kFnQQvCiDiThFz+83U148QZXgJC3aIHPXj4hVrkR7S+AKYQp/U?=
 =?iso-8859-1?Q?n3rchlgtYkRACBRhuPjV4OgO1IgQDT3+lbld4+tj/PpYSDsEVX0W5Apwv6?=
 =?iso-8859-1?Q?afcFJT8je13zVOthx7Gvyoaa5hn3PIzsnuhDCxSkwF/gZnEQ+JE0DjPnxn?=
 =?iso-8859-1?Q?yuZCbr/FSQ1PPKtGQOqReTrILsF/R5veQqvP5Wm8eVFW9pKbXyQk4eD9xp?=
 =?iso-8859-1?Q?WlHYbTaeMQsrMdt8sFk/Tnp7R9rvskvO3xSWldUf5YN61in3I2oaJd1ita?=
 =?iso-8859-1?Q?KThpOEiqUjbvncqM3dJy9GjsWnvg+27A8Y6LbWa3gm1NVqC4SfFp1b245o?=
 =?iso-8859-1?Q?S9yam43Z2Vt7BFGJ8GK7PYDqQusyMom9Vt0enBAFBSuwLmfUK+WzhF8XbH?=
 =?iso-8859-1?Q?+teRvcH080W8vGow/3v9qX4lEW9qvRnqq441cljKmV1gSA57OaPupF7BO4?=
 =?iso-8859-1?Q?ezfFWoXXt3z/B0aJU0fDRP3AeXdxRcVbPotKA2JWrn51a/5oz6re9G4DqL?=
 =?iso-8859-1?Q?bROBkgwtGiJs1/QEwsMnXdtsfH6mIk1AkH5j1a7+dXl5Gn0SIPWUca9Syg?=
 =?iso-8859-1?Q?ZwXRYDJRSPYb9hrZzufMxGWZCVegN/PjxieMiyxH8JGMu8aKVOuTjvfIRa?=
 =?iso-8859-1?Q?3yEF9s3zhCuSlbC3XR9q1zdB2JDtGSGPvj9mstGguG8Gzt829VNPimaEKH?=
 =?iso-8859-1?Q?L6eLS+J9bdnrQGXI7DXIfvRB3wo4KRWoNuvKee3OHA8edLHZmIRy4nwjEk?=
 =?iso-8859-1?Q?oavDyXjuQsn4BMwHF+lJaZ2JgQGIUhp/jFJSH3izuOdTbQVFwCpVl6BDVE?=
 =?iso-8859-1?Q?1hBeHyozYWYCAtEtQwIiKtF8Hz5KMRhLscU/aGZM1foJ3EAHNRRFteJeps?=
 =?iso-8859-1?Q?7M13qfs3L3uS4mmP8g7/8+y3GEPEoVbZsTZednrpD29k07ocw0FHiB4qrF?=
 =?iso-8859-1?Q?LU27LkNhsmut+7INHhNuVlp8NIco2N+REkrscnM7AH7U/4Kg+PRe1Ir4Cj?=
 =?iso-8859-1?Q?vWIGlCuWNvdXpGnDWep792d+EROpBC5jimc3iNK2vwu1fCi/W4zjbka1gE?=
 =?iso-8859-1?Q?eem66zYDyxkk/vlIZ5b0Ymw3CKzbSfJbBpx8sH4Gqn+Vx53GVSy4SsAraK?=
 =?iso-8859-1?Q?O6BmagJDbUldPxZS2sFajjFrC57FyW1ldJ7Pm0PUbEQnyQeAnOsg4mzpWM?=
 =?iso-8859-1?Q?u2y+4/7is15F96iKRfAaMlV2CB/mp8gNvIIcim0q/KQSrJMMTnlVUZIuC/?=
 =?iso-8859-1?Q?ckSF5x63u8ncIDcsVqpDoFnGfg2QVDmS3SvdgabtvUIberdIPkVXhTlEKd?=
 =?iso-8859-1?Q?3CWlgOFAGtc0GOlLVtRX+oplZ0ZATo2hVYRXYCVoZ8HhzFE8M1nwLb8V1S?=
 =?iso-8859-1?Q?Uf1u/hQxpZ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1582.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b4537f-d9aa-4316-c803-08d8f9d75e47
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 15:11:06.7063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gXLJHbI0Geza2MgCAZz+L1vzgm5aVs6DN64Xw88bnKiR+vKNlvGjSAo75vOTczb8OxpOiYo34J2GsO6GNDx9KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1839
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9947 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070107
X-Proofpoint-GUID: AXym3bGJRvHNsjJvy7Uv4JgzmEhiU1x2
X-Proofpoint-ORIG-GUID: AXym3bGJRvHNsjJvy7Uv4JgzmEhiU1x2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9947 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 clxscore=1011
 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

find_vma() will continue to search upwards until the end of the virtual
memory space.  This means the si_code would almost never be set to
SEGV_MAPERR even when the address falls outside of any VMA.  The result
is that the si_code is not reliable as it may or may not be set to the
correct result, depending on where the address falls in the address
space.

Using find_vma_intersection() allows for what is intended by only
returning a VMA if it falls within the range provided, in this case a
window of 1.

Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
---
 arch/arm64/kernel/traps.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index a05d34f0e82a..a44007904a64 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -383,9 +383,10 @@ void force_signal_inject(int signal, int code, unsigne=
d long address, unsigned i
 void arm64_notify_segfault(unsigned long addr)
 {
 	int code;
+	unsigned long ut_addr =3D untagged_addr(addr);
=20
 	mmap_read_lock(current->mm);
-	if (find_vma(current->mm, untagged_addr(addr)) =3D=3D NULL)
+	if (find_vma_intersection(current->mm, ut_addr, ut_addr + 1) =3D=3D NULL)
 		code =3D SEGV_MAPERR;
 	else
 		code =3D SEGV_ACCERR;
--=20
2.30.0
