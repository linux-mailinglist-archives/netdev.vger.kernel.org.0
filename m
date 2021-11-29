Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8856A4611B4
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244604AbhK2KG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:06:28 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42600 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245486AbhK2KE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 05:04:27 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AT9gkeg029596;
        Mon, 29 Nov 2021 10:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=ri006ikFIJiTYyHzJ98z8QTLkwg6GopmYzxEgUvsJ8w=;
 b=GuJto5s2PFaZnDhgGWb2LTlCXi2ceAjU5OFnuEQ+s+vyHTgc7dsM7kE0v74mMIUFOw6d
 9Ju+kCqcpOCGHTFU9Ja6PX3HTDeb0kmq1IhSogWjlVY7Z9Udp4+sqaWaRnYPCU/OTJto
 Xyd09GYSG+Ra9vgHvT7kyuRYQfjj5d42+VIs+D9geOV30xe4tiHds1Zd1ZgWsDr/JlcB
 rcL0uBD8aSlTHR7Zfo7id+aTlrrP/ko18gJ6/uHkU9NumPX3U//AibKwJzHe0xBlQ4t0
 R+LPyoy7dpP/m1rNnK4mo7UDk8Liyz6V7Ktpsbs71E2wVEbs0HlH4PMBx3JGQ89s81WF HQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmu1w8hpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 10:00:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AT9pgL6051081;
        Mon, 29 Nov 2021 10:00:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3ck9sw0218-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 10:00:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gz8e+moVT+3lNLJ1KjSx46Zh9J5Ph0zv1ldaXIi7pnQarEx/3bRNuhVj918UU9frM3BzCSTfcfWPkrY6GXwB1EWXy65hdnw4nFM+w8vfozu/vhqACkVLMapKYx5wNVHrYQxKmToX//7whU8DOkHno7kR8oCrT6As4rMSzxsyD3qj/JkbMj9aSpsfliWf4PghCQe1MKcPcdsyI1t586oFjDWfoRy1suEHFwcMJHQiLtOB0SNlDjeOcEcPYDzNRe9CCqx0qeezq3oeuKQePMuxg3wJeJGQBDa2ZEdXK3m1RxGBZ0eCCf73s/DVnj4nG4KJoTOSoD+mVRjN7WRjmJSZwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ri006ikFIJiTYyHzJ98z8QTLkwg6GopmYzxEgUvsJ8w=;
 b=bkxwWR0RFuwj6Jqlp+pQVfC/IyB/ZgEEU9WpYRw62BTn90iAu41JjE0HcRnDST7VdQ9+rDO3zvZbe96HnCnSIDH4PwjjwgNCy18TGHP9Zk1vNfhRvzvTBK0BTMp9XQoCLz1CR2zf94zkwvvh0p3ntgKINIHuYg6CndPUAj6bV9f/he0/pj0RHD4QkmHNRkU8V52BnP7RRXtDyxvvO3VnkgMeoCIv+nvOz8+nNOb+eh3Qri4VafStoFrX32dDNMiMl3eAvJlUTlwvVEnxmQWeGFKFIvQSub4HTYnKx9qZw9ZJd3520gxs7VxiU8pl1ivZBgFKiNqCcKmrGQibAbZ2Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ri006ikFIJiTYyHzJ98z8QTLkwg6GopmYzxEgUvsJ8w=;
 b=F94rE7VmFxmhpE4hB4vt/o3OeJO4yLpebsJFRSN5PnMBXiikzBmjh4z7ewnJn4GZMYpHzKDtaO6shpX5+VLaI9OsABk7/8PVM58Km1yUGjtduK7c7upQfh2+MIBi+3ybTGSBqvU4uLRrN+zjI1L53BFkkqslyWqXTKys9rKyEXY=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB5091.namprd10.prod.outlook.com (2603:10b6:208:30e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Mon, 29 Nov
 2021 10:00:44 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::998f:e9eb:ec26:1334]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::998f:e9eb:ec26:1334%9]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 10:00:44 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf] libbpf: silence uninitialized warning/error in btf_dump_dump_type_data
Date:   Mon, 29 Nov 2021 10:00:40 +0000
Message-Id: <1638180040-8037-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0125.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::22) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
Received: from localhost.uk.oracle.com (138.3.204.63) by LO4P123CA0125.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:192::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Mon, 29 Nov 2021 10:00:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da369a30-fb0f-433b-ee63-08d9b31f1c00
X-MS-TrafficTypeDiagnostic: BLAPR10MB5091:
X-Microsoft-Antispam-PRVS: <BLAPR10MB5091A64C0C136F36FDE433B8EF669@BLAPR10MB5091.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0xB0838xQUyco6+qOIAILhdwQgm8oVSKSmuItYFtxAigskbzXT8pLu2hvwXiT8J1bThAClhfDypFk7tmT53gi7+noUjHBSl0Fur+RcGg8M7hYtUGbgpk0HYsyjuRLQJiX/G/hAq+QcAAhoGM4tL5/w+ZdBnadah4302XKDDHijf/hwxkiHu/BRjYB8eb0Gvdt9TNRxpxa3uwMWNx36sI4y8UbWVZBCJl1gwGpriPECMA4KV5Ca1jkHlk6nt7Od1gWyDZsD+o58SqK6fOImt2k5mYBL6KGq75kf2woknOp2NScErZU8obIOKOyapakmmdT3mZDyiuQtl06WFAPEQNy2JVlcNo1w1PVl/dosh/MNF6Z+UQeoOP0k21Qb+b8EalRraiTYZeZC2CL/FsFKnS2TRpUAJ5pNRYvL9AeB/dqOxv2pc255EkltAYIjWSYAnSXCDALyMEOjxUIhhZ5vmItul+mq069h8vfhyqzf5DYd4+9cEsqpPkzvdHu5Yl8WC3dVey9ZMLUzNCjmMsAqVLs8OZFjGRw52XzjKdU0EeSlfyVJ0hJM2rhvM5VmW56Y8q92y4bF4phhiM6QRvP9JOVIECe80NvdJpuJyHGGtCyF2hD4D02WJT1+sgv4aEouQ7dB3tHuicowPtKJF1SXcE8HQZsDYY/TX29g8KgQB9G6Xz1zQd/fFrAeL8HD+QKFToZC/8BYiVjPz74s9A5XTVVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(7696005)(107886003)(316002)(86362001)(8936002)(66946007)(508600001)(8676002)(2616005)(44832011)(36756003)(66556008)(66476007)(4326008)(38350700002)(7416002)(38100700002)(956004)(6486002)(83380400001)(26005)(186003)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SThreFQ5K3czT0p5aXZRYmtXbnhrei9CM0xGazlDNE53Y1Y2akxzWVFibXdw?=
 =?utf-8?B?T04xL005emtranZUaHZhMTZxMnowVk9McGdqQ2gyMlRseXI0SVo4UXZJNjFS?=
 =?utf-8?B?Tk9EbEJqa3BmRTNpdmlCYkp1dlJQS1ZuVVFNcVBHL0t1eVd2bGYwbTExYkNv?=
 =?utf-8?B?NmNuSTRIOXBXeDI4eFkwSHA2UTlvNGxIN3RxbFo0cmg3bkZGQzB3V0lQOTRP?=
 =?utf-8?B?b01xVHpKYWJUOGJSS1Y2NnJBTTRRd3hHcTlqaUhwUE4yNmNUTHl6RzJuYmdT?=
 =?utf-8?B?QnkyMUczTTF2K3dtRy9sa2xYaktieTZMY0M3cVQyWTlvZGpYUVRjSzlROVNM?=
 =?utf-8?B?RWVSai93YjlaNENkNk9DOG5qWi9uUmk1RlEralhSaHhUN1NuSGxTZjdsU1gv?=
 =?utf-8?B?c2t5RVF1eEMxVjBOb0tDVFkrRFNGNlRNYVhzd2ZwcEVRak9Kemcrai9zQkhZ?=
 =?utf-8?B?TTBXVGtwdWNCVXlmdlp1TTc1ZThhclYrYW1WSmhOaHROTmljcEZSUTRmRkJw?=
 =?utf-8?B?VGFKUXRObnhHdTdFazFpK1JCKzdOd0N3UTYwajJXUm90akpHVVJUQ1hxOVd2?=
 =?utf-8?B?c09qRkdld2NzeGNYcmlDZWpHMDRQdnptRG1jTzM2aHdhQUhtMVNEY0U5YlFI?=
 =?utf-8?B?MWFFcDNaME5hdzlObjViY1ZzdmJobkpOTXRLdTVIZHZFU1hTUmUxbENNVmNT?=
 =?utf-8?B?SWZnNnFwTGdOS1BkTUoyc1hjczNSL2hiWFNqT2d4Q1lnRGhIU0tab3liblZ2?=
 =?utf-8?B?TFVWVlpOSTdtd3FCOHdqMmxUUk5wNVlhSm11Z0g5eXBHUEhUaVRIMWlOcnNU?=
 =?utf-8?B?NEJ2bG5WRzRwdjViYWY4cW53QXJzZDc4SmJPTTFKT29qRm5ZZURpUnBBOXhk?=
 =?utf-8?B?bkJIZkVvTTNNOWMzWTF6TDRQV1lvM0lzOWphQ0R3UzA0SEhBbGxpdUR2cVJW?=
 =?utf-8?B?N0dHbU9HVzljcEhsWWJIb25pNDQ3SXJHQkRXMjY5SWJ5M0Exc1NibmZjL3gr?=
 =?utf-8?B?S3AvRTlFY3Z2MExDY3BOb056d1F6ZkwwVlU5QjJBdzMybnZkUWQ2aVBMbkUv?=
 =?utf-8?B?Y0JNbDhpeFlKRGgvZDlIMVNXWlM2ai9FcTd4TlI4bXZpbEh2QStPNkRIQzM2?=
 =?utf-8?B?SVFGcnB3MHZOaGdKRTljckQweHFnZmJSZDUvemV6RHFoQ2ltdWs1RXZWUGxM?=
 =?utf-8?B?blRtTGdCRVAyY0dTWlcxUUY1SitlYjd1VTN5Mm5JRVY5V0poZFFFeTM1U21r?=
 =?utf-8?B?dzM5dXJ0K0tjU1dYS3FnSEpGSDFUNllRYm1qT245ZlhwMlVnZFpDcUZ4Y2tr?=
 =?utf-8?B?R2c4SHgzN3l2bkVSRmhxb0tNYmVXYXZBMFowdW9lNk5ncDhxcHV2Sm9YVFZS?=
 =?utf-8?B?ME9EM2xnK01wZUVUVFZOTUxIOTY2emVhS2Ryc1daU2JHSE1ZRjkycW9UNWRJ?=
 =?utf-8?B?cXpTTlY0STVJYTVBbjRQWnkzRVBGaEVMTVlXTTlYRjhSZkNjM3NJVm9lNzVq?=
 =?utf-8?B?OTBhY3VhM0hHTWVYalFaamVQWTZFakxPbTZDSHF2amY1eWFaL0cyQ0phOXRp?=
 =?utf-8?B?bWI4NHQveVFhYU9ZVVJnR0I1MmEyUXZENkpKc0NXZ2ROQWJLUEszUDBpUndi?=
 =?utf-8?B?M25wYnNMcjJzWEdQWUZ0Q1FWUGJVRzBXRDduc2RMV0NOU3M1ZURzOE9uR0dN?=
 =?utf-8?B?ZWdSckZEUVROUDFrY1BYcisrTmtuYXZzZFpQVldQYzRKS01kMTQ5T0pIMFhm?=
 =?utf-8?B?Z0pvWHFRL0QvdDBEMWdONGRjM2R5RkVaMUhoeVpweHI1Vm1pNXkzdXVhcVRI?=
 =?utf-8?B?b3pLQ1dVTmRjR2Jnbm9KVnQ3V09HejBpZmViUDdxenM1N1BtdG1Lay9iblhG?=
 =?utf-8?B?NHRDVmdPSUpsbEUvVloxU1I1ZTlFYVNYN0x4QjlqS1NwQkZxVmZCck5mamw1?=
 =?utf-8?B?ZENSM3FMbnVWYU1ZL1hwUk9FeTd4azhBR29FMXYyeUF3Wi8vcnNpcXkyTDIv?=
 =?utf-8?B?STRJcS9YcTRQVHJoblNsSEROakY2Q2RUczVWVkVnQmt3RzUvL2FuVG4wSXNr?=
 =?utf-8?B?aW53NG5tcElzVnBrZFVUc1NHSHhtRHJXSXVFNk5DV2Z1cVpHQ1p6T2pQNi85?=
 =?utf-8?B?bWI3YVRyaGExM3JlWllDcTFlOG85S1pDL0ErNjdWOFVUY1NERGlHMUNYMTE0?=
 =?utf-8?Q?PZT3X4JhD1T+hYUU000YUJs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da369a30-fb0f-433b-ee63-08d9b31f1c00
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 10:00:44.6629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vQrNToABeni33/LipEpGdM6+hWWpgK9iJOAfQO8+c8MYtaxuRZLPu6J+K8UAvSWkd7mG5mt0G8fXQR5+aexB3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5091
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10182 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111290048
X-Proofpoint-GUID: NZbBdeMt6E6pRQckiFav5fxtFeifn9T2
X-Proofpoint-ORIG-GUID: NZbBdeMt6E6pRQckiFav5fxtFeifn9T2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compiling libbpf with gcc 4.8.5, we see:

  CC       staticobjs/btf_dump.o
btf_dump.c: In function ‘btf_dump_dump_type_data.isra.24’:
btf_dump.c:2296:5: error: ‘err’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
  if (err < 0)
     ^
cc1: all warnings being treated as errors
make: *** [staticobjs/btf_dump.o] Error 1

While gcc 4.8.5 is too old to build the upstream kernel, it's possible it
could be used to build standalone libbpf which suffers from the same problem.
Silence the error by initializing 'err' to 0.  The warning/error seems to be
a false positive since err is set early in the function.  Regardless we
shouldn't prevent libbpf from building for this.

Fixes: 920d16af9b42 ("libbpf: BTF dumper support for typed data")

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 17db62b..5cae716 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -2194,7 +2194,7 @@ static int btf_dump_dump_type_data(struct btf_dump *d,
 				   __u8 bits_offset,
 				   __u8 bit_sz)
 {
-	int size, err;
+	int size, err = 0;
 
 	size = btf_dump_type_data_check_overflow(d, t, id, data, bits_offset);
 	if (size < 0)
-- 
1.8.3.1

