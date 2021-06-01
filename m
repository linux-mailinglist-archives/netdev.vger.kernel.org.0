Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C637D397592
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbhFAOjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:39:16 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42794 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234116AbhFAOjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:39:09 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 151Ea7LE000448;
        Tue, 1 Jun 2021 14:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=E0Q0beswLXHApBo+bAd0ueumeWk6ghluo6c73cj7nWQ=;
 b=Qo+m6IkSoTrMMHP9qwE5jmu8bqYd+fVGwSaBQnM9Ot+IilcPjBUe5kf4bs15Zc+oN3co
 YY3ykMs6EFpxwmulRxrfEO1gYAqAYA8rilRgT5sNBKlTmWJ7QRX/8EnGQeHFqOnK4+1e
 +Mkspryt5MP7mO7GGe7FVDbGcYCF31PiYbhZZaPERzlb7Af2pxURK3ruTCAoBmg6fiSS
 NpAUYmfDT69Ab95UvmgvHayjVpornXYWAty2/kvRQWjWAt/rXgAMa8KhFRAmX6Mu8A0P
 /z1f4W2YYDn4rMYqgekjYMHjXJIL8iDuiKkqR7kyThXtFx9/lIvZR2nAs5mZBrosWzF+ FA== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 38vjar0nck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 14:37:10 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 151Eb9oS000854;
        Tue, 1 Jun 2021 14:37:09 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3020.oracle.com with ESMTP id 38uycrb6fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 14:37:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsChrn6DqvFUmtahVykYa6mt/KzXcvlYsoYJEO1BYucyxsRGIn7wRHlb8dUrne0nLKCmGf72nYxcQKzk81bnPdjzXhGbD1pE6vVi8x/1DefVAaQ6gRXK/UlDCfq/rI7FLHwSR9/MX1TehImvF0Z7wBxRKKlO6IR7AybOThX08US7gIykmw3m3wwQ7OIHXBbbrZAbRgd/4hMmPeVTzsBbC3LF1OrFRzNVQEXbwExqn0V/9P94rWLY+wl6esawYqpv3/awvJArcDn/Xq9RccUgBm6SDSHg2O9izP/7GdFhpiSBbyW5147k5J/X3Vo6YzS9dj6mwyuDLBc7sUFevR/M2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0Q0beswLXHApBo+bAd0ueumeWk6ghluo6c73cj7nWQ=;
 b=W15PRl9rbL5t1//WUT6Zn9A8T88nAn/3P92RynpzgZ+fJldkKybiQbTP0t6zwp8N4uKE04Y0IyWwk7VKmnGQihexTIP1wdvKyeguQ4Q4WOV28asvrp0gdu6L86dIqN3ehN+of5G2s0QUuVFl8c15785Xkug1pMRAt4aSTc3SS9DJDYAFoxnPZoeySezDLtOrrWj+fFcrmPHiRNCRAwPLjDnoGtQPxL0GL3LJkiZU1KtFtNf1FIyh2JEb45MjkAJnOFFbANK+DXHUjzOcBB7sl+9z1Zw56pOMkbxgkUJCkjMmeVPeBby1EV6wskO2PcYLuBjMVaoy+BWQixfXNYM/5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0Q0beswLXHApBo+bAd0ueumeWk6ghluo6c73cj7nWQ=;
 b=Do1cAnxtWFwOBZEX/7i15Av/fdv6UgbdaujsM1NwHWymtxLA3ldRe1E4XXgvv+We+BFjZ9e5YJqW3UluPPj8r2NNXjA9BUfojXjQIrn9VTldk37tlb6MBpah12JZm/X5T9BlnO47EVIjCYoynTFLd+D1ZTUlCWZDao1yXzcJgcQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB5283.namprd10.prod.outlook.com (2603:10b6:208:325::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Tue, 1 Jun
 2021 14:37:06 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c%4]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 14:37:06 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v4 bpf-next 0/2] libbpf: BTF dumper support for typed data
Date:   Tue,  1 Jun 2021 15:36:58 +0100
Message-Id: <1622558220-2849-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [95.45.14.174]
X-ClientProxiedBy: LO2P265CA0461.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::17) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by LO2P265CA0461.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 14:37:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbd33635-2054-4a2c-2989-08d9250abaf6
X-MS-TrafficTypeDiagnostic: BLAPR10MB5283:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB52835589854F3C438470803BEF3E9@BLAPR10MB5283.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eErCjlAqiAxGXuURYGIKJVE8XRjN8I5MiAeSLbsGBiWdkLYWst64U3QrH5M6G0V8QHHbw2pRCIbr+HjanzC9xfjdJYBTv1Sq1/ZmiJ+5le+SYcVHX3uIPlF41ENFHDLHYtHVU8bMjBPBYgpCTj9KOIHgB2TDVsxH9P0xJlg21a90VtGEPE0epzLVhPOeV4xI0R6vobdTE/8Ft1mFwxNEi8CMsYWXOo8MBJaVNvO21ZXQOiSDg/UAVaPIJqCGgj9y0wnJn9hk+87s/cSAVE5r7tljUncD6aosuQtK96qxTorb3Ex4Ewz4N36ULRl6/P7fbydNd1HbwRjm+5kklrTlhCG16NrRKT/81wb69q2jGrkeyuuWEMxJL1a8mG0G9gTfXweYCPy6fR5JlsYbuG/iQj6fy2TpkEacGkV/HENSS5+5hl7vk+djUIm+wX/pFHOVEDjit+rGsm24daOZ7/RF/DM66e36tbp2rrMzjyRo/Cxj2w4iH+ajP6F1Vk846i3SRBt8z8/3sm6pbLuwV4SAMMlYt4CNnUlCog95rO96lm4AOWdDEOV+7il/EXl2/TSNUT309WpWoPRr2cFzuu7IxKfspVxm0X9uuf2J9+zFGxOhpLJ6QwY0OzQ91tAaIpSZm2Z4KH59Lj2zHiLZkKmbmrJBTPdvvxXH7sJC+Vzfoteg4UhGMfkGTi2NwblUl4v+ndXZpDfYaaPVi7yux1UTgIvdkti7+RjocN5WAveIDDn7gt6td8QTLZRft1tgNsFlzU8CLVq95X5f1ls36TlkUKHu8nTW+LZuUC8oGw5y6B6L02l8mXaoMD7LuSKNZgSi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(396003)(366004)(376002)(6666004)(38100700002)(38350700002)(956004)(6486002)(7416002)(83380400001)(186003)(86362001)(16526019)(316002)(8936002)(2616005)(8676002)(66946007)(966005)(5660300002)(7696005)(52116002)(66556008)(4326008)(26005)(36756003)(2906002)(66476007)(478600001)(107886003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7B3Srq9WdyXvqkmvWGTfT4dZNkEivLKHXE72GhI5qNATPnsgYwaB+R/6+WaZ?=
 =?us-ascii?Q?2xnJ1IatyjBIMIq/6RS2zSU3hE8zNzXd38Mqtq4O7ByWy1TKvfQEjJLqMkrx?=
 =?us-ascii?Q?CsOvHwiDmjbP2HIaJRB1+A/P6ATnAz3qrJpn05/vS0vBxuSfDbsPP7ACJn/A?=
 =?us-ascii?Q?LOMG/hNCKiUREtEus0bGTQxOMWDtqEvu1uuR7VGEXgIU0ralblsdxoOoVUhr?=
 =?us-ascii?Q?96e0dJkKsHLqUDKh+enbUy0GZWxT3Q4h6sVR3I0daVEhTstz7w8YoD78eyjv?=
 =?us-ascii?Q?PRE+gF7cCpKeEeQP0j58BClXVucC7FTBpfiVwFyPa8tDSYeFx0o+9Bbq0nMv?=
 =?us-ascii?Q?E4f0SuDfGYoN5AQW+kKPPRkwRrABmzc4EV4Q09AdVAvgUGOE6h42G3eVBmV3?=
 =?us-ascii?Q?aWPzJrTsbeU1FaWPIAdW4Bii8M9V7Jw2mFh0m2uQauHgFagVCJjFcc1mlW5o?=
 =?us-ascii?Q?hlyUFqYfOew9kMiy7TOB/NkF9FX34sNQ+dNOvimaVgC2jlBAO6Sy9P6FhA8a?=
 =?us-ascii?Q?8AYwJNZW4fua+/A9Hel9OYWzs7Vx6KuUzY7JQ3h7xroQVVnDEUxF5iqCaezd?=
 =?us-ascii?Q?CYcqEaj1YaEh1n4fSiOGv47wO9sLtS16cq/HXUMSRl0wxL72lAA+Ikc7+TwI?=
 =?us-ascii?Q?BuAjNYr89jtFMgKooYHbotI9XqHPj27oKNymwc79+71txoxTXralLAPJTRxf?=
 =?us-ascii?Q?PDTLcadoRpeK8uE14V3lXwgYwUgh1lAXMVC7d3AC2nKVREpVQ04v4hiF0cm5?=
 =?us-ascii?Q?hgBIDaFziEclIJTgWgy86fC+s9P71pvb7wi5718jedDYGH4uu7WZSHWeSYvm?=
 =?us-ascii?Q?kmQpRawvjAyzORzv4zFjdQAdUvb6jae/VFvvIcuHfboFkytm218BSJoJVooF?=
 =?us-ascii?Q?X4SkMuVCTN4SGEwTRW5AJkGuS9rWu//tIEEqRJbperwJaUlPB5R4woYEkTw0?=
 =?us-ascii?Q?/Idk0k+ZGlMN7wb/yrF6oxng1mJy5Yl++fwtCDfNNlyiM9egbnv+MYTR+Jhv?=
 =?us-ascii?Q?RC6IxM0AMJdOx9cU7Meiygo7CeXT/8Wj0VLccBpSOKpbUTFWL9iihBkhpb9g?=
 =?us-ascii?Q?E8ZEoWllOWshdi67mvfq/jZPmGA1qv/BGGQ+6CQUdh1FtDp163DFA+7nohAC?=
 =?us-ascii?Q?6ELQ5VLkCHoF4ocwYlybc3pw8wO0SMVbMrfy0McJ+REqOWYKGTxyvZwWI74S?=
 =?us-ascii?Q?LhcjepyJy6HHWQpm98K87DdKmXRzLuGWBxKCFw4EiosMaEFZS6DkM1bDd2Ow?=
 =?us-ascii?Q?sr556X1ej6G843050PWrW/m/cD1SGom1ihDptjTsuLaeUclXkFUzRQh5EORy?=
 =?us-ascii?Q?nPLqlInkzYso6/0MDAPJUSgD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd33635-2054-4a2c-2989-08d9250abaf6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 14:37:06.7684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJF9PCTlbAq2KTJO9g0CHYHU1II0IG9+IRYZDsH+bQWTVAFMxLYaJ5o0W4iB2EJ7FZUWxknqmomSkYTaS6FgSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5283
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010099
X-Proofpoint-ORIG-GUID: 1cCy_FhKDrhvvAimVGyEEet-marZa5Q-
X-Proofpoint-GUID: 1cCy_FhKDrhvvAimVGyEEet-marZa5Q-
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

Patch 2 consists of selftests that utilize a dump printf function
to snprintf the dump output to a string for comparison with
expected output.  Tests deliberately mirror those in
snprintf_btf helper test to keep output consistent, but
also cover overflow handling, var/section display.

Changes since v3 [1]
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

Changes since v2 [2]

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

Changes since RFC [3]

- The initial approach explored was to share the kernel code
  with libbpf using #defines to paper over the different needs;
  however it makes more sense to try and fit in with libbpf
  code style for maintenance.  A comment in the code points at
  the implementation in kernel/bpf/btf.c and notes that any
  issues found in it should be fixed there or vice versa;
  mirroring the tests should help with this also
  (Andrii)

[1] https://lore.kernel.org/bpf/1622131170-8260-1-git-send-email-alan.maguire@oracle.com/
[2] https://lore.kernel.org/bpf/1610921764-7526-1-git-send-email-alan.maguire@oracle.com/
[3] https://lore.kernel.org/bpf/1610386373-24162-1-git-send-email-alan.maguire@oracle.com/

Alan Maguire (2):
  libbpf: BTF dumper support for typed data
  selftests/bpf: add dump type data tests to btf dump tests

 tools/lib/bpf/btf.h                               |   22 +
 tools/lib/bpf/btf_dump.c                          | 1008 ++++++++++++++++++++-
 tools/lib/bpf/libbpf.map                          |    1 +
 tools/testing/selftests/bpf/prog_tests/btf_dump.c |  638 +++++++++++++
 4 files changed, 1667 insertions(+), 2 deletions(-)

-- 
1.8.3.1

