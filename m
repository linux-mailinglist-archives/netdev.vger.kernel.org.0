Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1973CA13E
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 17:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238380AbhGOPSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 11:18:46 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:15080 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231970AbhGOPSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 11:18:45 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FF6IQY017710;
        Thu, 15 Jul 2021 15:15:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=jR2d/NIUZDWqKGLv0kVviYnSsXlY8+3hSDGj2Rb9z6U=;
 b=pbD8yyHvpYEuw4vIESV5uzT2GjjTCh5q9t1+VasHWLa088rzn2Hq2uCMjdlKRTZ7AeUu
 5D2xWg9frdzjdzaCVT/uvR8koPnljNn6KmNJExpP4ifH/qQQjvcmAwBKknOW65eAHWfu
 2sjQ3jU3FTnQ2qXdH0XgJttkiFdwMe0y+KoWdc5SAsDW4fOYa2/SjWY99hmmCLIkyhEG
 N98yA4nYV3V8PLNnMDN9HlTIC74HqiR6XvY5GYTnarRzMoMhdOqtIagZ42n+ctQQNcr1
 NOqNknIz9SnsloZeF4z1TxWKyZoYhaZxUjnTWSXOk8G7pDgqGQJ6nuYiYWXSCWdPC2SR vQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=jR2d/NIUZDWqKGLv0kVviYnSsXlY8+3hSDGj2Rb9z6U=;
 b=wSytX0IiZPvpMjksqmUIYs8MHfn3b7P4amh2g5yqrAjk3352GzdMaYJ5+X1MIz+LENxa
 IU65ezhlOGVRAv7qf9qzJK3K7otWyMH7OAKxDvFQtew2aFojKFT/lNI68Dvxxy+5EQo9
 hjDwx2kNE07Lqj/yE68pG39dt1OD7S1xrv5uy+eLKOUpzOei9jtO83KPh6nFQaNR8y5c
 vvmU3bxzgMzYGIi5WWBSwJFRyV/HHDhjuDm6d9LcNLDp+yauo1L0hoy0QNwhS6A7UVjc
 CaE3+jrHwfU2M9FCODNOQO6SrVxMAAmd6L8hX+FK96vhzrs6LkY13i+czBUK81FTfZdH iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39t2fcjc7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 15:15:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FF6pHU092409;
        Thu, 15 Jul 2021 15:15:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by aserp3020.oracle.com with ESMTP id 39q3chuham-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 15:15:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8hgGydaSyDNxMS5XYxDxEROLGpJYTKBqzI7c89g9yTgDWOP9x+BKv8K9+lLmD81KbnDoldW479mUAw3FYYpiIbbCAya9Gjq2oane9Mjd8NtWP7u//GkN0EldBUpD+zmWBftCo4olUV7HDeeTiUP9j8e9DuMQjbEMEYjdgIYGwwQk6qgg4TNC0RAHhmhYNN77UtK/gOmRxBm+S0hlP4L1w3Q/ah8DZoKQVtbfACXSc6P4MQtgYE673UvnbwPGYFxHTprEC97lwcbvlBq+tS7Hck1e3hS7kSqpcgR5A+Deherpol2zDYI3h4jw0I3cp17/nVzZsm58xv9TEGByjJJVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jR2d/NIUZDWqKGLv0kVviYnSsXlY8+3hSDGj2Rb9z6U=;
 b=eehC7Y4mrjGw+ogRihGoVKZwOi0wEC7uP+0fDhXH/2pw3MeaSjN5yU5OcmsmnfSOQqWJ203sS/ujRAbdZKbTV5BtHJa3aUolr4bI+jeavucWQ+nPJ/L6PyK9lvCtZZNFEp7jdly4KkNBbG6rTMLMUZoPtDPCkUYo6ZwTd3DkedXDBFpBn0huvi1E+flvgg8ERSB9qNVCB2MNf4RIRxyDZG1K+euHC/4dyOtlZX66CokAoz4Cxn2gtclzHgI552lycrIcXm4qfEzPDuJCSrwslLWvoHI7+QnT3bchN4350ErL0epHNCgz0W8mtsVno0QtUpVy/s6XhW6dTnPfU2QQVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jR2d/NIUZDWqKGLv0kVviYnSsXlY8+3hSDGj2Rb9z6U=;
 b=gSgK1/X9WlvneMH9AC1fBjQ1crb2IEc3Cj6n4R3LoxR2FfAHwqv1mUaSwZ85QH2CXlbtW2klzqVt2I7rLnd17DYD9TpRlm+Sp6gk8x0nCQTHMYkDsham+beHpPaKJi53h18aQt7CbnIuTyQcF2f3rrGxX/kwX94SB5DwoJ1VlRc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB5123.namprd10.prod.outlook.com (2603:10b6:208:333::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 15:15:32 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 15:15:32 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v6 bpf-next 0/3] libbpf: BTF dumper support for typed data
Date:   Thu, 15 Jul 2021 16:15:23 +0100
Message-Id: <1626362126-27775-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0357.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::20) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by LO4P123CA0357.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 15:15:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba1a2e32-495a-4c1e-1ad9-08d947a3636d
X-MS-TrafficTypeDiagnostic: BLAPR10MB5123:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB5123A6909EB6843FF7AA2709EF129@BLAPR10MB5123.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L2neigxDS3tSBHJQV65gf7cKcXsDkNcp5Ja+girrMinwq+ELqzu42lrhsoHBPV71eJuXlDO8MItIYburaDSk2KOSzfZdT4vYQgzxtuApQKSrvvvU9jN7jILBCBLRxdbXYl5n1vvfHhMfVEgeSPKbLSndFlPyCP+GdP0yr2ONPPXJzegRFZgD7kGgyDorAWqXQWtZrCU6pR9U6BC1QDlHxyrFFn3A+eTEYS9GaDZQ91xGbVG2CAEycXBgdtsKyYzbWj1AACOuwWA22G6grjPOPgKnMPVlE0/z71tljWBSN60AmRPhPaqk+mVAK0uUyoAnHSt5L9e1/GU03qFClcVektWBH9wlaulh4dC8DhSRJBGhpmgDkrxO83SxNNycjZ+qLdG8/dS0AEq8M12vZ0iMLi78NlqRSSfyu7raIGTe8t3ArTLacHNUZG8ycaJTchDIOc6yzsABz9137XzjE1jZLU4m1A8kYw+xaiXDavn6q/qU58BsHFp+dOI0/dcOx8ID7jiQ+zfLcPe/D93i9eMIPgYdr0Ho19+RQCmLcG7XJah054/B0NspeoLDMSge78c53aANwIi+GBGLsR+fcsWYgBY6x6fbGgVn3Tr7c83OIRgL4YgRrjAmrjIqeAhErbBV63vmc/nxD5jEPsy0KuJxDkQh6++D2vU08ZJ+OjGMZI+eyRLrD8tqnlmOrwtADWvtWrY2wvGIVB/phDMoCueh7ryjo6y9RMzdynVKeLHn91kSkbdOp6chDHrYqmZSfwiT1cqxg0flVAVkk1FCqJ7XUhu3DgMcjdSyZXDGv46J9BRtV38PjaTk2YoLlQ+8pDYmVitDrqDnpW90TQmNzpLUWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(44832011)(83380400001)(316002)(8676002)(478600001)(966005)(2906002)(66476007)(4326008)(66556008)(86362001)(66946007)(8936002)(6486002)(52116002)(7696005)(186003)(5660300002)(36756003)(956004)(7416002)(6666004)(26005)(38100700002)(107886003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eO83t6EMVLpM8E7xLkocd+KXSZL6HNw5LdonJdpEGFTTCtjEEXv9XraeG3Z7?=
 =?us-ascii?Q?rCitdBEbG2NelvTY5HmkNqgE0NE1L8pAR/au8rg17iCGbYMsVVvkD3p4IGIw?=
 =?us-ascii?Q?IlhRxE7jZ8MigRi+miHYJ3M+5bagiLh4Amb6m3ANsbViCg6Jex7NSP373p6g?=
 =?us-ascii?Q?KFmBaoiXaeUQrmbNnfDeOIa7y7jFXtL0vZuOHDrZs8srx+9HUtcZMmowhmL/?=
 =?us-ascii?Q?+jVHDvWUZ64Q0lTJw3CH0YlK0emQyFouvnTaBKPar8lWKGhegB+G90XSQjyf?=
 =?us-ascii?Q?7pyBrqflr9quFc7hUblUrBb4d+lwnmTI5A4/5paf3PXjBN4L1BHTjAsFoOiy?=
 =?us-ascii?Q?M8ftDwoiumEl0Xamesrbr6FduGY8mkZ9Vju9umRbSpTp3CIv0l0UzW/OQsse?=
 =?us-ascii?Q?+ilMefkOtj9pebYsAw/pbHu1tBaz9FlbndwYOZkODe4WHFfRPpZ9WtX4kzZz?=
 =?us-ascii?Q?gjxCz5TGKGJrCXTokJbftAuGzzFpnHR+yqxorE1F6xBTomXZrpDnhA8qAmHm?=
 =?us-ascii?Q?QJd2dJXaUzNhoNg4RXORVRkaBfhr7J2PJROqu1oWmZcuX5Slw9nuFDp1/NSr?=
 =?us-ascii?Q?5xedQpZJBUfjCYPF80CEtLLCERoAcsr8Hh12qrk8BD7BSReuRjR6s0R8ArqF?=
 =?us-ascii?Q?Gtr/KTHNOffCI1nCw49IZNbnMK6r9iwkCNNHaJmCJZFK7f88un4SR7+H3Imm?=
 =?us-ascii?Q?JTDS7Tl0vIQcpJ6YpYURsSi0ZYYMz3wFCSF9zcowvBmvERuZBL3cOIobKGMQ?=
 =?us-ascii?Q?ay08wnfeVFX87/OjXlFCSZ3C/ZjMTOI9W3/3+ldEfYHHtKVbqlgA22LqOCww?=
 =?us-ascii?Q?Y0tiROMuvIvx5CTJk/c0bCx+atybi1fWk722+JFxO4EUrSvm8tSLQyO+7cOZ?=
 =?us-ascii?Q?MC6P4JzIyi2bXRTiNDp02NRCKlGhW1UtG9jTCHiCh+U1RIulu5UAON5sNmvK?=
 =?us-ascii?Q?q8TC+V9uqEotnVedD8aVYayKFpGNUsL2tUN9RLk11ZR9w58pGOw4AXSjIO3H?=
 =?us-ascii?Q?g63SrGSF3GRjv4jWNhso11P47tBksIJV6QQobniMyeInGUFThNhZAEUv4bGd?=
 =?us-ascii?Q?Prf78idnKqs4YNGp1eGThg062iKLRL+cMIZsZsv/BuNWt5P8Jjb2r9P1KAVF?=
 =?us-ascii?Q?4yWdJgG+n/Ua+f+j7t2R3iPrNT1pTbyaTxP9ptYwgAGYVXItZS7IwRpV9Ti8?=
 =?us-ascii?Q?Hsa0RHnJLU0qRlX+Z+EAJxf3odK7UHUNjbf4kL/GDwbn19SMsm1S5PREUlQe?=
 =?us-ascii?Q?5kPExtyjIDNjISZLyGa1K9Qd0ZTrbRzj6TBidTA6kVovkzUJ8efNMl2SGRXW?=
 =?us-ascii?Q?xuCauUKqQ70A3gb46LohMZ5i?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba1a2e32-495a-4c1e-1ad9-08d947a3636d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 15:15:32.4355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VC6QOxStqz1ae9bNnQx8Hh2z/fq5+mpzNWVfoK4h/kdJ7+gsomLfoUh239mzl1NdVjJZ7TsE2gClI51FOEuHIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5123
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107150107
X-Proofpoint-GUID: PoxCcQ_vsjyafmdULkQKJ75yazG5_1ng
X-Proofpoint-ORIG-GUID: PoxCcQ_vsjyafmdULkQKJ75yazG5_1ng
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

Changes since v5 [1]
 - readjust dump options to avoid unnecessary padding (Andrii, patch 1).
 - tidied up bitfield data checking/retrieval using Andrii's suggestions.
   Removed code where we adjust data pointer prior to calling bitfield
   functions as this adjustment is not needed, provided we use the type
   size as the number of bytes to iterate over when retrieving the
   full value we apply bit shifting operations to retrieve the bitfield
   value.  With these chances, the *_int_bits() functions were no longer needed
   (Andrii, patch 1).
 - coalesced the "is zero" checking for ints, floats and pointers
   into btf_dump_base_type_check_zero(), using a memcmp() of the
   size of the data.  This can be derived from t->size for ints
   and floats, and pointer size is retrieved from dump's ptr_sz
   field (Andrii, patch 1).
 - Added alignment-aware handling for int, enum, float retrieval.
   Packed data structures can force ints, enums and floats to be
   aligned on different boundaries; for example, the 

struct p {
        char f1;
        int f2;
} __attribute__((packed));

   ...will have the int f2 field offset at byte 1, rather than at
   byte 4 for an unpacked structure.  The problem is directly
   dereferencing that as an int is problematic on some platforms.
   For ints and enums, we can reuse bitfield retrieval to get the 
   value for display, while for floats we use a local union of the
   floating-point types and memcpy into it, ensuring we can then 
   dereference pointers into that union which will have safe alignment
   (Andrii, patch 1).
 - added comments to explain why we increment depth prior to displaying
   opening parens, and decrement it prior to displaying closing parens
   for structs, unions and arrays.  The reason is that we don't want
   to have a trailing newline when displaying a type.  The logic that
   handles this says "don't show a newline when the depth we're at is 0".
   For this to work for opening parens then we need to bump depth before
   showing opening parens + newline, and when we close out structure
   we need to show closing parens after reducing depth so that we don't
   append a newline to a top-level structure. So as a result we have

struct foo {\n
 struct bar {\n
 }\n
}

 - silently truncate provided indent string with strncat() if > 31 bytes
   (Andrii, patch 1).
 - fixed ASSERT_STRNEQ() macro to show only n bytes of string
   (Andrii, patch 2).
 - fixed strncat() of type data string to avoid stack corruption
   (Andrii, patch 3).
 - removed early returns from dump type tests (Andrii, patch 3).
 - have tests explicitly specify prefix (enum, struct, union)
   (Andrii, patch 3).
 - switch from CHECK() to ASSERT_* where possible (Andrii, patch 3).

Changes since v4 [2]
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

Changes since v3 [3]
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

Changes since v2 [4]
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

Changes since RFC [5]
- The initial approach explored was to share the kernel code
  with libbpf using #defines to paper over the different needs;
  however it makes more sense to try and fit in with libbpf
  code style for maintenance.  A comment in the code points at
  the implementation in kernel/bpf/btf.c and notes that any
  issues found in it should be fixed there or vice versa;
  mirroring the tests should help with this also
  (Andrii)

[1] https://lore.kernel.org/bpf/1624092968-5598-1-git-send-email-alan.maguire@oracle.com/
[2] https://lore.kernel.org/bpf/CAEf4BzYtbnphCkhz0epMKE4zWfvSOiMpu+-SXp9hadsrRApuZw@mail.gmail.com/T/
[3] https://lore.kernel.org/bpf/1622131170-8260-1-git-send-email-alan.maguire@oracle.com/
[4] https://lore.kernel.org/bpf/1610921764-7526-1-git-send-email-alan.maguire@oracle.com/
[5] https://lore.kernel.org/bpf/1610386373-24162-1-git-send-email-alan.maguire@oracle.com/

Alan Maguire (3):
  libbpf: BTF dumper support for typed data
  selftests/bpf: add ASSERT_STRNEQ() variant for test_progs
  selftests/bpf: add dump type data tests to btf dump tests

 tools/lib/bpf/btf.h                               |  19 +
 tools/lib/bpf/btf_dump.c                          | 819 +++++++++++++++++++++-
 tools/lib/bpf/libbpf.map                          |   1 +
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 600 ++++++++++++++++
 tools/testing/selftests/bpf/test_progs.h          |  12 +
 5 files changed, 1446 insertions(+), 5 deletions(-)

-- 
1.8.3.1

