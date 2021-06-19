Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391643AD8BC
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 10:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbhFSI6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 04:58:54 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6614 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230032AbhFSI6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 04:58:54 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J8p0aB002228;
        Sat, 19 Jun 2021 08:56:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=vZeCr5uaiS+/x3XdybWecTuSEB7ZC4mIVigwdW/fQvU=;
 b=uUxLhJJsFnzF+lo38ZogCfj2Fu8fN1lx/VbjGBvTgRoIW9CnBEb03y6R00bKhavHjbRo
 jZhZBHg38CS3NyjM7wFiqciZMb/pM6gHLCwqgYxbl5id3JyNrvV9wLIowGtongENdDKb
 mqo6pbTf7jE8pkWn3rl5N7QAsMNGLCtPQQ1Pj0I7RsbCqOKBrDrWXDCPU/TyQhb7LVOs
 1THqiM2l5b65eZ8a+aD9JoD+T3G4EsJhq4tZUiOEKEPTXABPz0SMWlhAusqdUe0aMHGy
 TTwHkHqTQia1acaS/ACU9+QAEWlbhO+bcFuULww2VhXpG3Yu/ESA5QP1BajzELYO6Igg ZA== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39994r06v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 08:56:25 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15J8uOZV138968;
        Sat, 19 Jun 2021 08:56:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by aserp3020.oracle.com with ESMTP id 3998d2jqqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 08:56:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abIoeYi6p/qD+Iu0uAvCWqxT1Xb8/EftAlARunOEqRNMDeCLzeIwU7SAgh57xP1A89b3+nR5dULe0VbfVeUFJQPpywJF0iq0qZEyF5Kxm35ICRtELTFMeE2gtV07LUgjHC1xCr4ENUsZy2XsNeq0Uvyt7CvnGAUxwMqacrF/5ecnmMrA/ejZvaHuOsiOlpZ7ntLp6W2fZvmOqBxdr1MDm1+U6xG2/VTSfoZ+OWLBMKyJ7uD/bcuQGIpyQl8SryPQ/CI2ADvrPinVjPD2sDGIBtwEN0kTyH5kq+Jb+R22z06ZdN8H9RIFy9aGYkmoZTsEWr7oimBMSYgjdud/kTbctA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZeCr5uaiS+/x3XdybWecTuSEB7ZC4mIVigwdW/fQvU=;
 b=Gh3ifj0R7gJfwF2TxKFCNV0J06Gh9NVR6DuGOjyccJw8wKnN1diAyUSHigOLDsPxqQvZud3FP946BaUxb40ow9uGhj+5t4aOFMRtF+5hjhoirh3GqCGUbVo8ykyp4JruQJZt5B4BX+lCcWB8mMpxvdF9P+tXmZGpU/wYdhQfDPPJ3qqUytlR6MNNOpJ9MYqmtI8/pkpoQnfP+KQYAl/UHeaMyYvRnhN2EdpPWXFuRENqO7kCCVXVUIeP/JX9rqFX/hqL2U7blz0qCCvCbNj3T01z2bnhJolMw682Ebo7zN2v/e0Js+HAEvRxxLj84RwcM/Zb6lVgGCY7jzBluCx6LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZeCr5uaiS+/x3XdybWecTuSEB7ZC4mIVigwdW/fQvU=;
 b=oXGPcJ+K1zG/E5iX7ZBRwZe0zHXTCyQ1uwP+SYbgGRhNWVf9fkAfh9JQJJvsS92577rnRMW6LVKnggMQRuqua3+gxz0S8tGZVIUHr8BRksFvRjgSNRXs9BYylhrD53As477OEcSIJ3T6NFKGA1TH5oJD50TMr/ey+C9cRGHM+60=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3357.namprd10.prod.outlook.com (2603:10b6:208:12e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Sat, 19 Jun
 2021 08:56:22 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c%4]) with mapi id 15.20.4242.023; Sat, 19 Jun 2021
 08:56:22 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v5 bpf-next 0/3] libbpf: BTF dumper support for typed data
Date:   Sat, 19 Jun 2021 09:56:05 +0100
Message-Id: <1624092968-5598-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [95.45.14.174]
X-ClientProxiedBy: DU2PR04CA0245.eurprd04.prod.outlook.com
 (2603:10a6:10:28e::10) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (95.45.14.174) by DU2PR04CA0245.eurprd04.prod.outlook.com (2603:10a6:10:28e::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Sat, 19 Jun 2021 08:56:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5799d76f-4463-40d7-bf4c-08d933001c95
X-MS-TrafficTypeDiagnostic: MN2PR10MB3357:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB33571C31AF33429BB809CCD9EF0C9@MN2PR10MB3357.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VaRCwe8mmlD+DqO5lrL0xbXs9Xqdh+yeKAbu+RG1VXWhPBV/KKphSJIt8Gm7XgnMkYcPlib/bErpPdSlIKYaUOWpwvF1+KfVChliRjK5AVLOKDxoaOOAaf4vGghD1WLu/+Ad0V5gf6xWGaF5GdQm0yUj1olkAMxHzkYENQlFa4bzF+rYriLfGCOGd+qwhfmadYZ5CLVNp0KX6n54qvUgTryip7siIfelSyZe8YJ7pUxutRxc+wbSyvyuAXivXzdS7k6HGjdo0ND7S/2HW8nbZEpyqqSfK8IwIxxwfOaEMoYRvWnh0SYQf2zb2030yree3sRJpGShXWKpanSLP5dnQfg2tp1N/yq3Wj7YYsE/dsm2Wr27KSYXGvbkxYr0AzVss4myXgGRCuGoOmZDk0j3Jqb/d37mjXfuyc7WIaCFRCGtdklVzvwHPg7pTUMRSN7eRFAQi3K7UUZO7/3ZAJp7GST+WRQP0oNoE4DOoTOz1x51jhbRJjJCbVlhBq1qsxSK6a9AD71QHIXoOKgQd7jBvAGE45dI0n6gDPjIz3A4ndXdN5BMQU5sWrRdZUW5kKPzhBGUL9gTjZY04Y8ttN5eHYxVe7bqx0DAUEA1JY7IEhsirtHgGjPBI6KfRjAeI+jlbe8QNA4im1OJ0KJbCxHDlKqtfY61SklaNFuOXA9u1dOshUJD7hJ0JUY5vPAca5PFOs6EEh6nF4JDuOlJzk/4cEpbTDdP4gYpofCkJ6fztZh+dm78+vlneNd3f+z4iddiL8KmxFgdNx3B8MsDqsBxJdFeGSQhfl/tDnQFE3TOH5P6lNUpZIHqo9RsShcWBAkzQRSJtY+WNSDpTuxFb5AELBqhNqwzW67Q2HwvJFe6vvU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(478600001)(5660300002)(4326008)(26005)(52116002)(44832011)(86362001)(66946007)(83380400001)(6486002)(966005)(16526019)(186003)(66476007)(66556008)(6506007)(2616005)(956004)(107886003)(316002)(36756003)(7416002)(6512007)(8676002)(2906002)(38350700002)(6666004)(8936002)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KcLCbioTdH3sPiu7umMmq5SrL37zEFLFZCUZAqkOMs/VsUq9vjwhg4RSW3d7?=
 =?us-ascii?Q?dlDCT1vLAgfpfNumgkarwWtiB0jx3GKv407luAavqlqk3bQ5c70x7rww35lV?=
 =?us-ascii?Q?xZvpaUsPkvjIGKkkvAFXPrae8k/UPECye9cgPVBPwcugzmnd+YCbSlnFp1ih?=
 =?us-ascii?Q?t1OlJm08LOmcyV8FKqVtEHy+1v2ee9tsVxTJyRc/yxMKbQujaWBSqOZhc47K?=
 =?us-ascii?Q?JHnVJMpsI+GzsjiAIIqU6Q7/00BnuNAj5ap/C7kPZ+i20UnZuGUTTEx6n+O2?=
 =?us-ascii?Q?RRM8GFHsEWZtQsPVxAcHcIZTuK4iGfIDdEHcOl8Qkn4KCQQ+7i/RZ30W4hpH?=
 =?us-ascii?Q?C9V7gTAnaUhwkzFUuznI2V4DSP27DBFGBkn6IFguFJQcGIySkUrkJDMc+GxO?=
 =?us-ascii?Q?D13HsSZ+/fp3yktnby5YtZqVl/PTOY6aBGwvBAF6Gpmlh+/CRPy87sY7opJJ?=
 =?us-ascii?Q?BVahaISwVBKv90BQpUDQNMCiYzMlIf6RmHunzz+5cqts8CLVE5XCxgmIdiau?=
 =?us-ascii?Q?WQMsOvAHwpNynqQ9wKVzDWEBuHJ3L+KrFKbEFPLSqj9yipF8bOoNtthZjOuw?=
 =?us-ascii?Q?ITU5RK1j90bk20wccucPEW9VBUy/UQ5jz+gq2eAGIyyhwPMtnApA5DurOxQT?=
 =?us-ascii?Q?T9LlBmQQvZL4+jYRXdzmDVCoN0OJO8LZT0kh0tarcoxrjewA80DXYZrgwc7r?=
 =?us-ascii?Q?32zNf8WRoTqzoqzZC1T24M+VBJ5icIT0uMtTWn13nCm4ckr/jxhbQVBsOQEV?=
 =?us-ascii?Q?IlY3GcX2HCNgGLzBRO/rFE7ma9jkZfcX6Z6Z84aJ5/vkgwUfKXlvh9c1urMd?=
 =?us-ascii?Q?rxOhmyhmHmJCXfXer7EPOR+lqhld5zvBG09/uAiJXniuK4ZDHw6eD6Re+k2y?=
 =?us-ascii?Q?KCvONOSn6A8jhMqmfG5PD/KBWzGLE8aSweoYvZROf5zrkQz4wYb0WV1B5ZFq?=
 =?us-ascii?Q?qjc501PIiR5MNEuHVJxGOMhIVUb+pJ7P3AImFT7AWWuBYBgQFXi6NiRDEFg8?=
 =?us-ascii?Q?pbNS83QsgSBmzfrBs1HDuOAqvrhfYRfVVsSjpbpOKD5te7g8DuUu/4gA5ttC?=
 =?us-ascii?Q?cL690I+d7D0k0gMVcCsfHX+h2QUOMDCB6aHoKAYVGKIMailQODTTz6TYlhjm?=
 =?us-ascii?Q?zIbGVIKX+1+AUyQQd5vV0fGb/rHw7X0kHZhOxPKixblSux58TlQfpL1vjdEo?=
 =?us-ascii?Q?QMaoJpQnt/SlUfOTVqbvV9r7Je5cBZs44Azf7Jx9QdpStIlqT2HoOzCLZmZF?=
 =?us-ascii?Q?L19eAb5OXeg0uUlDKz8XMkfwd2glTPnSPjbWTVBJTCadrxTpkTW+UZrdUb4T?=
 =?us-ascii?Q?NKhooOGsRB1GrS2r2spBLD3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5799d76f-4463-40d7-bf4c-08d933001c95
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 08:56:22.3154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3s2pKnQLUucWBLWUN7COqIKfRy9TV2n2+buEnz87i2Ey8PlcJBHO7MbQAJ4zMFQilsZVi3D+JjCHtIArzb3ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3357
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106190058
X-Proofpoint-ORIG-GUID: YWMC-D4i_VgsXGN94Rlcd65FLn_A4_3m
X-Proofpoint-GUID: YWMC-D4i_VgsXGN94Rlcd65FLn_A4_3m
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a libbpf dumper function that supports dumping a representation
of data passed in using the BTF id associated with the data in a
manner similar to the bpf_snprintf_btf helper.

Default output format is identical to that dumped by bpf_snprintf_btf()
(bar using tabs instead of spaces for indentation, but the indent string
can be customized also); for example, a "struct sk_buff" representation
would look like this:

(struct sk_buff){
        (union){
                (struct){
                        .next = (struct sk_buff *)0xffffffffffffffff,
                        .prev = (struct sk_buff *)0xffffffffffffffff,
                        (union){
                                .dev = (struct net_device *)0xffffffffffffffff,
                                .dev_scratch = (long unsigned int)18446744073709551615,
                        },
        },
...

Patch 1 implements the dump functionality in a manner similar
to that in kernel/bpf/btf.c, but with a view to fitting into
libbpf more naturally.  For example, rather than using flags,
boolean dump options are used to control output.  In addition,
rather than combining checks for display (such as is this
field zero?) and actual display - as is done for the kernel
code - the code is organized to separate zero and overflow
checks from type display.

Patch 2 adds ASSERT_STRNEQ() for use in the following BTF dumper
tests.

Patch 3 consists of selftests that utilize a dump printf function
to snprintf the dump output to a string for comparison with
expected output.  Tests deliberately mirror those in
snprintf_btf helper test to keep output consistent, but
also cover overflow handling, var/section display.

Changes since v4 [1]
- Andrii kindly provided code to unify emitting a prepended cast
  (for example "(int)") with existing code, and this had the nice
  benefit of adding array indices in type specifications (Andrii,
  patches 1, 3)
- Fixed indent_str option to make it a const char *, stored in a
  fixed-length buffer internally (Andrii, patch 1)
- Reworked bit shift logic to minimize endian-specific interactions,
  and use same macros as found elsewhere in libbpf to determine endianness
  (Andrii, patch 1)
- Fixed type emitting to ensure that a trailing '\n' is not displayed;
  newlines are added during struct/array display, but for a single type
  the last character is no longer a newline (Andrii, patches 1, 3)
- Added support for ASSERT_STRNEQ() macro (Andrii, patch 2)
- Split tests into subtests for int, char, enum etc rather than one
  "dump type data" subtest (Andrii, patch 3)
- Made better use of ASSERT* macros (Andrii, patch 3)
- Got rid of some other TEST_* macros that were unneeded (Andrii, patch 3)
- Switched to using "struct fs_context" to verify enum bitfield values
  (Andrii, patch 3)

Changes since v3 [2]
- Retained separation of emitting of type name cast prefixing
  type values from existing functionality such as btf_dump_emit_type_chain()
  since initial code-shared version had so many exceptions it became
  hard to read.  For example, we don't emit a type name if the type
  to be displayed is an array member, we also always emit "forward"
  definitions for structs/unions that aren't really forward definitions
  (we just want a "struct foo" output for "(struct foo){.bar = ...".
  We also always ignore modifiers const/volatile/restrict as they
  clutter output when emitting large types.
- Added configurable 4-char indent string option; defaults to tab
  (Andrii)
- Added support for BTF_KIND_FLOAT and associated tests (Andrii)
- Added support for BTF_KIND_FUNC_PROTO function pointers to
  improve output of "ops" structures; for example:

(struct file_operations){
        .owner = (struct module *)0xffffffffffffffff,
        .llseek = (loff_t(*)(struct file *, loff_t, int))0xffffffffffffffff,
        ...
  Added associated test also (Andrii)
- Added handling for enum bitfields and associated test (Andrii)
- Allocation of "struct btf_dump_data" done on-demand (Andrii)
- Removed ".field = " output from function emitting type name and
  into caller (Andrii)
- Removed BTF_INT_OFFSET() support (Andrii)
- Use libbpf_err() to set errno for error cases (Andrii)
- btf_dump_dump_type_data() returns size written, which is used
  when returning successfully from btf_dump__dump_type_data()
  (Andrii)

Changes since v2 [3]

- Renamed function to btf_dump__dump_type_data, reorganized
  arguments such that opts are last (Andrii)
- Modified code to separate questions about display such
  as have we overflowed?/is this field zero? from actual
  display of typed data, such that we ask those questions
  separately from the code that actually displays typed data
  (Andrii)
- Reworked code to handle overflow - where we do not provide
  enough data for the type we wish to display - by returning
  -E2BIG and attempting to present as much data as possible.
  Such a mode of operation allows for tracers which retrieve
  partial data (such as first 1024 bytes of a
  "struct task_struct" say), and want to display that partial
  data, while also knowing that it is not the full type.
 Such tracers can then denote this (perhaps via "..." or
  similar).
- Explored reusing existing type emit functions, such as
  passing in a type id stack with a single type id to
  btf_dump_emit_type_chain() to support the display of
  typed data where a "cast" is prepended to the data to
  denote its type; "(int)1", "(struct foo){", etc.
  However the task of emitting a
  ".field_name = (typecast)" did not match well with model
  of walking the stack to display innermost types first
  and made the resultant code harder to read.  Added a
  dedicated btf_dump_emit_type_name() function instead which
  is only ~70 lines (Andrii)
- Various cleanups around bitfield macros, unneeded member
  iteration macros, avoiding compiler complaints when
  displaying int da ta by casting to long long, etc (Andrii)
- Use DECLARE_LIBBPF_OPTS() in defining opts for tests (Andrii)
- Added more type tests, overflow tests, var tests and
  section tests.

Changes since RFC [4]

- The initial approach explored was to share the kernel code
  with libbpf using #defines to paper over the different needs;
  however it makes more sense to try and fit in with libbpf
  code style for maintenance.  A comment in the code points at
  the implementation in kernel/bpf/btf.c and notes that any
  issues found in it should be fixed there or vice versa;
  mirroring the tests should help with this also
  (Andrii)

[1] https://lore.kernel.org/bpf/CAEf4BzYtbnphCkhz0epMKE4zWfvSOiMpu+-SXp9hadsrRApuZw@mail.gmail.com/T/
[2] https://lore.kernel.org/bpf/1622131170-8260-1-git-send-email-alan.maguire@oracle.com/
[3] https://lore.kernel.org/bpf/1610921764-7526-1-git-send-email-alan.maguire@oracle.com/
[4] https://lore.kernel.org/bpf/1610386373-24162-1-git-send-email-alan.maguire@oracle.com/

Alan Maguire (3):
  libbpf: BTF dumper support for typed data
  selftests/bpf: add ASSERT_STRNEQ() variant for test_progs
  selftests/bpf: add dump type data tests to btf dump tests

 tools/lib/bpf/btf.h                               |  19 +
 tools/lib/bpf/btf_dump.c                          | 833 +++++++++++++++++++++-
 tools/lib/bpf/libbpf.map                          |   1 +
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 644 +++++++++++++++++
 tools/testing/selftests/bpf/test_progs.h          |  12 +
 5 files changed, 1504 insertions(+), 5 deletions(-)

-- 
1.8.3.1

