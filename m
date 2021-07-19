Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D123CF031
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377090AbhGSXAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:00:48 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:35440 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1388650AbhGSVBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 17:01:21 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JLbDTb025497;
        Mon, 19 Jul 2021 21:41:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=t5kdJMuoQWmxGAxK0coPFDTLvZT/t2901Z16TTxiewU=;
 b=EBfba2LbYUjOb52WGLJylf4SODFMlcxkrpeMtVCmyyxfB8DrIanwU+JxT08CpN12Sp5A
 mLWt06TSnhLdYUSciwGYWKNDBqn4CDq8iV0F+eEoIWFAz81uaFGZV4MthrFIyb2qJAJo
 4PbwwC7rK1sJeOfE4I01P4pVBLV7rk3fp3cJQuP6WY126pEI+BrWgkw4+iE+GQPpXkwt
 JwDDGhw2WW+C8RzqsGufOJc0bvwLnkhna20C5oQuJ+cjqv8Cf0LbLl18TIR0FH8xERDI
 Va1qGygOoM++gbBplGqDsAlGgbz3CYnAO8S07tD7HMvJ2ns/p4PGIQMN7HqCWbcQjRs5 vw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=t5kdJMuoQWmxGAxK0coPFDTLvZT/t2901Z16TTxiewU=;
 b=nKz71UkbItKdrqv6QQyu/WjmxpWbmGFjmrzrRXXBof3x7755YM0Tw92ANWlvULaYBdLN
 sTLQndTkC31BT6IZR1NPZVdf8Kr902VoTxpZh6pb1qCwscyANFmnQdkcRK5kuWIjjSkM
 9iLXrVOepJjK9dBJdWg9j8kC8+EqNty97txzaAEGwUbWMOi492tHIs97oTDIBT5LBhG3
 176h6QN4g8jzR0BaLv2xHC8/FtHk7UxiNkRCKCAGKwHozbEA1mIbwsRSNcJygGFpS/WI
 AXGjPPjxuzBpFALGledMrTJTXR+PiqOaNVvNZviBAfuoLXaNbjEvrNyIq1nVqJEbBdFQ hA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w83csa81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 21:41:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JLeFJs112838;
        Mon, 19 Jul 2021 21:41:38 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3020.oracle.com with ESMTP id 39v8yth85k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 21:41:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2BUQenjbOPvw5tyt1KgWcV3SO4Y7IxEAh0asWuIC1OEIqGLi1YwktP3t73HaASvRgj8J78Ody72a0fVxmTkdubLeLZMODNTrXbTNlIekxjx8Ba3sHeaM5s7J9vTnXy0+9AfKr37pgt+Nk5nj15/2cQ+Xlyehr+F0ERlxnhRNjlU849GC2cySq7aKJVj47U/MUKrI1ryjM2qVqs6LpftYD4FmFF9VUmS+Pbd2wIazv1L2jQoUHaYEJ0AHFrxBs7f5b2d3a5U0Zs+9/lTJtosh1t1/H8pzHb9HBk6Bh7n7fHGGho7cmz+llJMYicmb+tTm1R/pE5JRsQMFWqzalhB2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5kdJMuoQWmxGAxK0coPFDTLvZT/t2901Z16TTxiewU=;
 b=ggn6r5rpELSDvwljt5ClhZ9k/8SVCYdUL/C/HA4ivViElQ8Cfja/H3S3xqjMISGf0YfvdEdp/OIUHJyrFUgRYX0TtAvDh4pNuvG86LjMkxxUl+nxgXBhFjy+LHp2JNrJ/7HjtMoc3GN4eE/THXTwIHagmiSN45numr8JwM9rA3b3QKoAkd81Wy4yhKQYefQ1FOOR2M2eWWd5WBt/dJYyCAGt/yXraWymntl+O63YBFb8KCJG9ku1v/HXe8b6rQd5gmOioDspdCWW0Hu4Y4mlHylCSkp59O/L4QQ8uy83fXHZMgkNJSBrrTW/cT3JCYJ1v3jvYuV//5tQYsQUyYXndQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5kdJMuoQWmxGAxK0coPFDTLvZT/t2901Z16TTxiewU=;
 b=d2mRW6qs1qwr0pn6dOQrMpLkzl0/rNPzWknIUt2O3Z0mNO2b+orhf1O4axrwF2UzNndPKnmGLrRQVeL31pb7RkCO6spYanONISZ9tA7QRTus0hmPqGSv4wE2/dVDIS0QxtRfqD2eOLsc52X0Xn33KRYI58uKx3yu5sffh+1o1Fk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3614.namprd10.prod.outlook.com (2603:10b6:208:111::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Mon, 19 Jul
 2021 21:41:36 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.033; Mon, 19 Jul 2021
 21:41:36 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 1/3] libbpf: avoid use of __int128 in typed dump display
Date:   Mon, 19 Jul 2021 22:41:27 +0100
Message-Id: <1626730889-5658-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626730889-5658-1-git-send-email-alan.maguire@oracle.com>
References: <1626730889-5658-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: DU2PR04CA0278.eurprd04.prod.outlook.com
 (2603:10a6:10:28c::13) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (95.45.14.174) by DU2PR04CA0278.eurprd04.prod.outlook.com (2603:10a6:10:28c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 21:41:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44fbb958-418d-490e-488e-08d94afdfc2a
X-MS-TrafficTypeDiagnostic: MN2PR10MB3614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB36140F8B8DE0091EBF4335E6EFE19@MN2PR10MB3614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iO/dgORwQAQiqeHQrIzpPtiPqR65rIkswWRc5UnmiNv/YAA1uIy4Z7twq1He97jVd0XZjYdYMG8Jaf6yy//y+FMLYK0iLiNQWzdzJUEGyQRkwVzIQn0Tyet1r/9OIaWIp46bFron4hNkyRTCP0HAi08+rXOPwlxau4txQPJoTTcv1EDPqMcXvoqn15sO9fWHat/VQgcZb4kubIr7T6QPoW6Zmct2ih4plLFLaFSv5DWXcCbqinKIKwwL+lgTZ01j84NIdCKult+udv0N5sYAVf8AEBSaJhagDjGLmtP/h8Ba4E9kY7Gri4s/M2K6PWYJIeyOybZ314uNidxE00Zss/K0rRwA/mwmET68zGEtuoNgfGvwmvUsV7Lb8tzQC2R11maysmnD2MWmrmmT53C99t8QqHCTV/kEN6yr4Toe2udd+PGrK3tGQCopIghrKDniR+Znpucpyix4j7l7KQg2zmxG7DeB2eC7p98JUJ5Del4aMq8wHGSdpcbXRS9hDHUGQ6TsWCkIFSfSINGASC9g4/Nc4r1m9PGnFTFsI2BYD11Vv1k00hcM8tvtuErjxzrxrqUrqbmjUqKwiT2SwzMRCZjS890shT2ffYGjFJGXXOS1y4r5eD1s4p+pSWYUrOmPmNui41mfV0AhcrYnE70nWLAjQaQQ6aStw4Z+lgz4ufu4YazaDuBJFCP4ULivy10uTTeBlM330iZ2+hb+7xv68w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(6486002)(478600001)(316002)(107886003)(52116002)(4326008)(8936002)(38350700002)(38100700002)(6506007)(8676002)(44832011)(26005)(66556008)(86362001)(66476007)(7416002)(956004)(2616005)(83380400001)(36756003)(66946007)(6512007)(2906002)(186003)(5660300002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FPpJYQOR+TnuaiWWq0eez0sn6KgyE3FdfY1qfwlqoFn3ir2/1R2rduWDgjR/?=
 =?us-ascii?Q?safK+XwcyWfRFKunSpHUfHkBJepruN8gaWw+nu5d7m8ymCMZAcLn2BDJOeKq?=
 =?us-ascii?Q?ep26YhPUSCH5blAKEOEwhBFffW3BYyr9pQe6zXarXVd10/QMT9TLp79s7OfX?=
 =?us-ascii?Q?tBAc9zxFQhxeZNfdJW3m2oSsU17rWp+BLzgvnyrAlmdyjvci2bYoA7cv9rsz?=
 =?us-ascii?Q?jdAGESXCM0mNkCpPqFOV7M1KcibLix6hQxJSQXg5z0eAKsCyKPWE1LJervfc?=
 =?us-ascii?Q?W5E/7c7Xc5yTmOK24UolnDNLs1PDJB7Xj/4XrGx0uWe6ucjyoePTI5J1bJWp?=
 =?us-ascii?Q?VUu395t1M+t8RJyPelkGj8gxPYUqbr58UxE/+U7ac5UyD2K/M2QxvHde4V8h?=
 =?us-ascii?Q?Vm0rzqC8z1BvH6pw6FeUOquzxzhAHpOrFlEx41bIlkOoHEGfuvB7hvRH0JS9?=
 =?us-ascii?Q?p4GZsZunn7ukyJtTpqp9SW0oYFNW0/5jxoGaV8MMO1yfoToG/eV+QZiRQuV+?=
 =?us-ascii?Q?HCjc9Xqg67DeczJL/UJKUiyaeAJ2c9KVdaht6qkx0kzDdmePbvR1N94xJkQD?=
 =?us-ascii?Q?2XIGlNuj0c+giTbEypEicx+smZ/bfFIOOWo+L7HKre/UUesvOmoDtL7HU/x1?=
 =?us-ascii?Q?om4oqmxm/bu8xc4InYfHiD/2Jo1i0dFVIekO42vaf6p3+7QMnKJAn930RyhL?=
 =?us-ascii?Q?hVAgComG9EhRC97bJ9d29T9kwYIpVBmd1+9OLEhjlYaW/ZBtN1uFC+ARa6JQ?=
 =?us-ascii?Q?3gecl3TpYApE/PRqrWMWOC19tRyRRESHGPHop57IwYxLwd3JMYmUu9EPirJr?=
 =?us-ascii?Q?J94n4by9JNW/5RJkSC6rqKcdjdpvTd6gIAQrvZFu3LLZGAgc8Eq97549a3Ri?=
 =?us-ascii?Q?pnjaFtSQA2myG54H7ex/eWetgmzKk/De7cjjCfAOO2+sxgO6nSiKVdufSx+V?=
 =?us-ascii?Q?CcRt5j5abcE7N1bAcr2v60ArAOglkMApY/xDPu9geIA0WgL5AT0D8uuM8Zyr?=
 =?us-ascii?Q?lcwcvl2gE13qbuEZ3VAFD3FOTDnV+7Tqn1/XP/DYtHIqiRYVlCDCcMO/Nc6+?=
 =?us-ascii?Q?e8CRlojsHKwD8I/q5k8HJMrVZDCJDApDNxzbOYgOkCoM9wgnC+9fIEew6UJq?=
 =?us-ascii?Q?ta3i6KKYzm9xv1arAmfMK1c5a9U0JmKL/qAnri+cT0FMjYOr1dh2SzvGw7Sr?=
 =?us-ascii?Q?fu0unFGl++xcjt9XMCuv+M5UtQnTdBWcnSc6iYoHHuJnB5n8DBns/6azYBoR?=
 =?us-ascii?Q?doUTgvb/CjZC2Ouj6QvFX3hPmA1t1FELs3ZQ4fVkVWs8JgRvYYXO+wlwNoZ0?=
 =?us-ascii?Q?OWYi+KPkWo3E3aNkkHgFdj9+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44fbb958-418d-490e-488e-08d94afdfc2a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 21:41:36.8780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vVMAgtPxjvnEhJp+TUqmecSzSShOkzBO5VaecHiVcFxii0kC5iZ05A/5KRv2LKmGzWOOhbMeNLvivl3WhCXpqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190124
X-Proofpoint-GUID: ZT05GdfRTrIAWWH2ELVjLXKobdU4Jg_m
X-Proofpoint-ORIG-GUID: ZT05GdfRTrIAWWH2ELVjLXKobdU4Jg_m
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__int128 is not supported for some 32-bit platforms (arm and i386).
__int128 was used in carrying out computations on bitfields which
aid display, but the same calculations could be done with __u64
with the small effect of not supporting 128-bit bitfields.

With these changes, a big-endian issue with casting 128-bit integers
to 64-bit for enum bitfields is solved also, as we now use 64-bit
integers for bitfield calculations.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf_dump.c | 62 +++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index accf6fe..4a25512 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1552,28 +1552,15 @@ static int btf_dump_unsupported_data(struct btf_dump *d,
 	return -ENOTSUP;
 }
 
-static void btf_dump_int128(struct btf_dump *d,
-			    const struct btf_type *t,
-			    const void *data)
-{
-	__int128 num = *(__int128 *)data;
-
-	if ((num >> 64) == 0)
-		btf_dump_type_values(d, "0x%llx", (long long)num);
-	else
-		btf_dump_type_values(d, "0x%llx%016llx", (long long)num >> 32,
-				     (long long)num);
-}
-
-static unsigned __int128 btf_dump_bitfield_get_data(struct btf_dump *d,
-						    const struct btf_type *t,
-						    const void *data,
-						    __u8 bits_offset,
-						    __u8 bit_sz)
+static __u64 btf_dump_bitfield_get_data(struct btf_dump *d,
+					const struct btf_type *t,
+					const void *data,
+					__u8 bits_offset,
+					__u8 bit_sz)
 {
 	__u16 left_shift_bits, right_shift_bits;
 	__u8 nr_copy_bits, nr_copy_bytes;
-	unsigned __int128 num = 0, ret;
+	__u64 num = 0, ret;
 	const __u8 *bytes = data;
 	int i;
 
@@ -1591,8 +1578,8 @@ static unsigned __int128 btf_dump_bitfield_get_data(struct btf_dump *d,
 #else
 # error "Unrecognized __BYTE_ORDER__"
 #endif
-	left_shift_bits = 128 - nr_copy_bits;
-	right_shift_bits = 128 - bit_sz;
+	left_shift_bits = 64 - nr_copy_bits;
+	right_shift_bits = 64 - bit_sz;
 
 	ret = (num << left_shift_bits) >> right_shift_bits;
 
@@ -1605,7 +1592,7 @@ static int btf_dump_bitfield_check_zero(struct btf_dump *d,
 					__u8 bits_offset,
 					__u8 bit_sz)
 {
-	__int128 check_num;
+	__u64 check_num;
 
 	check_num = btf_dump_bitfield_get_data(d, t, data, bits_offset, bit_sz);
 	if (check_num == 0)
@@ -1619,10 +1606,11 @@ static int btf_dump_bitfield_data(struct btf_dump *d,
 				  __u8 bits_offset,
 				  __u8 bit_sz)
 {
-	unsigned __int128 print_num;
+	__u64 print_num;
 
 	print_num = btf_dump_bitfield_get_data(d, t, data, bits_offset, bit_sz);
-	btf_dump_int128(d, t, &print_num);
+
+	btf_dump_type_values(d, "0x%llx", (unsigned long long)print_num);
 
 	return 0;
 }
@@ -1681,9 +1669,29 @@ static int btf_dump_int_data(struct btf_dump *d,
 		return btf_dump_bitfield_data(d, t, data, 0, 0);
 
 	switch (sz) {
-	case 16:
-		btf_dump_int128(d, t, data);
+	case 16: {
+		const __u64 *ints = data;
+		__u64 lsi, msi;
+
+		/* avoid use of __int128 as some 32-bit platforms do not
+		 * support it.
+		 */
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+		lsi = ints[0];
+		msi = ints[1];
+#elif __BYTE_ORDER == __BIG_ENDIAN
+		lsi = ints[1];
+		msi = ints[0];
+#else
+# error "Unrecognized __BYTE_ORDER__"
+#endif
+		if (msi == 0)
+			btf_dump_type_values(d, "0x%llx", (unsigned long long)lsi);
+		else
+			btf_dump_type_values(d, "0x%llx%016llx", (unsigned long long)msi,
+					     (unsigned long long)lsi);
 		break;
+	}
 	case 8:
 		if (sign)
 			btf_dump_type_values(d, "%lld", *(long long *)data);
@@ -2209,7 +2217,7 @@ static int btf_dump_dump_type_data(struct btf_dump *d,
 	case BTF_KIND_ENUM:
 		/* handle bitfield and int enum values */
 		if (bit_sz) {
-			unsigned __int128 print_num;
+			__u64 print_num;
 			__s64 enum_val;
 
 			print_num = btf_dump_bitfield_get_data(d, t, data, bits_offset, bit_sz);
-- 
1.8.3.1

