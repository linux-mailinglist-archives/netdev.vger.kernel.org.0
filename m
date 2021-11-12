Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B4A44E0CB
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 04:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbhKLDaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 22:30:13 -0500
Received: from mail-sgaapc01on2127.outbound.protection.outlook.com ([40.107.215.127]:22432
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229698AbhKLDaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 22:30:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIqZD7R5yVXIlL2fVpLoL3e4UdH7dg480ugNwWj+BzbNAZE3CGcjdFsMA96/Zf1TXng4O0Dqm9CXJgjNPvZPNIvfLzmdOqGf42wGK8i6IEsUaaiOQfARCAJFnwvIWEuzIaRKlpKQgxTYuO61e/hkn1+YZyXTn8ZGBUsakV5NLAEjle84JFVZIFqppUPH66GD0hI1VVUC4noaAK6Z6IKzcCRgxI3iS7uceunxpRuJSaThcb3LSAOT5QhPkZJymDTyqdAw2zfdM6AC60YfdGsed5FVmTweVF+TMS5aysAFpp6sIRyGM7rbyBFjYvTDLCJu44GlNBtIFLS4lZ2g9PNZkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tXv6c9U5dSYZUqH1ylUdyj62X1MxCEep1Qo9ORwrJ90=;
 b=UewZ0N/FS/AT8hvhtOJMHnCWfIXh0rKRKxId8Ms1qb3hUVW4LCf0Bjoqd2vzvUVDI23Fl/z1G+aGfFyLPyYgZKn5ujMdCu60OuuOsg3KjZvNdVjZ0CNTCDLVJxoYRsXfOxmWX848Bwgs8EKAm42XMhpbsnC6aZwTuQrAUzfSqKNPWh65R4SLZIPmQtiSlycIs442WU2W/cdGEs5ngSeP9aq+8miIK9yGPmEJA7WvvJc4i5miITJ9Ymt1Ja3F6yQCL0J88dyyRwktqgUPSc53N6c4BeMucpbP/BEtX8Q51AUt/ckZqNC0STrZlCgRfy0kuY8Prd7CqRs3T3vPMPvpAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXv6c9U5dSYZUqH1ylUdyj62X1MxCEep1Qo9ORwrJ90=;
 b=BVnFEL8pmUFUi6Dv64n+uo7U5qcQzJvBrNx36OjPp/clngrBsDXK0bLfhcA8mRvF/5L7pb7v4Rs0Be0bHcQIIWWIXAe/KEyFYDd6MA/ELQ5FOLVwQ/ePs+QpDhRd8QPEGuWEbOTF9bGp8XWyX2GLslbw3WCFu5vjLEMmjNWl984=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by TY2PR06MB3614.apcprd06.prod.outlook.com (2603:1096:404:107::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 12 Nov
 2021 03:27:18 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::5e:78e1:eba3:7d0e]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::5e:78e1:eba3:7d0e%8]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 03:27:18 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH] selftests/bpf: use swap() to make code cleaner
Date:   Thu, 11 Nov 2021 19:27:04 -0800
Message-Id: <20211112032704.4658-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0148.apcprd02.prod.outlook.com
 (2603:1096:202:16::32) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
Received: from ubuntu.localdomain (103.220.76.181) by HK2PR02CA0148.apcprd02.prod.outlook.com (2603:1096:202:16::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Fri, 12 Nov 2021 03:27:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbfba109-8c89-4bb3-a900-08d9a58c543f
X-MS-TrafficTypeDiagnostic: TY2PR06MB3614:
X-Microsoft-Antispam-PRVS: <TY2PR06MB3614D9AEDD9DF7D2F0A7010DA2959@TY2PR06MB3614.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yLZZtMsnL831i02vKwA6WmraMD++po7p88mnEhU81GFFE6gQS7MumPSoGZRQNJcm2LONDRENe7YPUSUbp5QVBlGrHJfKODOpTarGUguRG1WkzPV3FhFqCZZl2vt/no0yq3dijh/sOCx0Oby1oBWn9EQwNWgSAcgx1zuXVxDGCUbx5FL+ZtNELU07/eWYeHkgoDiMjtVLLCdquHskYLE8me/iu+BouDfGyy8EirHLkp4yDQ0uAu9tTvcf1p/bAMDB/gp6auUXz5KRAL2hnKQAheeRyMK9wuJLx93hiPFii/xfdxfl00iGBoIqkP7t+gB1KaT6SOcqRrx9A5Y2LbA3zZ8NMj3io4ctNXmVuvLycqidjtcXaVIRGBP8mPtvyb+s0NlfK0KLXQzwOR1K4+OZY0bK0uIZK2TVBfcf1xOG+/bA8bkTRDhmGxJjNMdsvAQv89uCz6bhr/ol4uPeox9VXYyCVb5gCGYFVeFLf/XDpNux3kY4WWHfNX3d4JotlveVR6pBP9TsBxhnU3VEWLCZhuX2rEeB5uDQgYcqT/p9o+SLwmQmEzV6SxlDP0Y6ebco5tPk7rbTgD1Af6mVl/KAkMRBh8+Xhu+EhNVIxBPc2xjHuj7SCWlfhUbk/WIrpyfqahBfXQBGTVRBeyn7r9h+yrLVVCvxMaYEe5J/dPIkIq+PgiCKrWUORxd422/S/YCJsEezPJfkgUpS/HXwRRsYYIjNkvvQ7abB4BrElS29vHM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(316002)(66946007)(66556008)(83380400001)(956004)(66476007)(508600001)(2616005)(921005)(36756003)(38350700002)(6486002)(38100700002)(8676002)(7416002)(4326008)(6512007)(52116002)(186003)(6506007)(26005)(107886003)(110136005)(2906002)(6666004)(1076003)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YsGT45sooI1+NkxbbY0/MEmW9tWJ2XwWJBYoX88WlTvp2FTs9yhw12hPfF2l?=
 =?us-ascii?Q?JMrFhn6IR2lp1uZzm1Spl+fz7ut521DbSfrSw+EXQj9h5bDZZQO3NACeuO4H?=
 =?us-ascii?Q?k/WNt8LLrCRZPV6im2VXcHVdEkFcFgLAQNoOgrvGcJ8J753nUemOwnuz2BH9?=
 =?us-ascii?Q?jKflA2o4WeS7URfinHsyz/OPe0eaotjLorx8LEBTtwegleBtBriVKMjAq32M?=
 =?us-ascii?Q?6X7vqUi/5j9fpCjdmJ7be1bj2Cd+8uiB47qQ4DBolXmLb5kxoRUGwOjG4kM9?=
 =?us-ascii?Q?Ht/TVzEUBziUQELX7n19lQGigtemz7ARN5katPlUm7C0/s/UE37hYrJ2rRhT?=
 =?us-ascii?Q?Lj8Fo96RCF8Iw4JtekR0aPKJ4A21eKJY2nmqcJEKvUKkxQWKiDIWRpIhVcqU?=
 =?us-ascii?Q?OFcttiaHosr+FRxkn2ZRVWTGj7HC0kG0aETw63vV8Crcz5JFZuS34HIHEZfU?=
 =?us-ascii?Q?EuBilPhHvU+8xIjsPc9BHkb4fLRZ0RSZpLnrE1lC07Mzb8X/Zk9dZpjSMSJZ?=
 =?us-ascii?Q?BkliQPC09IqoGDFNkyccOso6KzT3Yu2OtlU5XN4kCEhwW4QNr6kaBSDK2qJw?=
 =?us-ascii?Q?emIAZFSVC9qHyJHkc8P+jVUvHm9nun8ebAsX9YGaf92rt2ZaOHi25F+KkE9P?=
 =?us-ascii?Q?yak29PBIUO29OQzFXfM7GVav+IcpgAzov4CzysLQeF/oW5chpA1FLwfPRNaQ?=
 =?us-ascii?Q?MaGIidNB7WCh1eL96sfhcpiUdSmAXKlei8dMch4KlWD9NP7Foe89ZQTgspmd?=
 =?us-ascii?Q?j13X5etARHroZ+Ib54O7MNy+L31bAWMFMgkGZVXYsVUy616zl3OOSZe0eTzt?=
 =?us-ascii?Q?fONVI77yczP2A4TnwEy5XRo0ulbdDoAjE7anAFok464rinLUNubSJ/0ayYKu?=
 =?us-ascii?Q?yMnYnU+St1N1eI1xmmJav1disdUvuJ7yyubxT2FgHX/xI0iEmgbdaFGBN9Lq?=
 =?us-ascii?Q?wydATx9GXrX8/DqZT7nJSjVs5/PfS6AiJnApLeiAkLhAAeDyrOnPifJtpwWZ?=
 =?us-ascii?Q?pnlehZF43ucFfBgYsdzz553cIVuyp7jK/Ou6OV76iTVm7+vNloKHxu+e7+ed?=
 =?us-ascii?Q?xgcFIuPHMTWys3rGSDyVWa+eOjBzP5gwsgmceGEVX1VArdv0Az4NuKOf162H?=
 =?us-ascii?Q?S6SFOt9Z8fKPc039KhUwsBzlN0Px6iMDpKc+25rj2jIFSbBgsmeruSI9BL/W?=
 =?us-ascii?Q?sDfdIE7Rx8iIltm9RpqrcVSo4gN36M4l/9oD8ukeZV/oddc1IDjb++JKk9fx?=
 =?us-ascii?Q?ToTt9OuRmpKjF9QsJYnyWEQBQvNhzWq8+b1ywSeP/8dQPrKEQ7zKBkV4IBj9?=
 =?us-ascii?Q?Ed/5ohzmJJadkt6ATMJs9w+/WSZcQ4e24wEXm/zM1lYG7IbmUIi6ItjwXyVa?=
 =?us-ascii?Q?SebuzUJv60X7bCq2ClsYtRk01zmRw1yiwQ47nWWzyOE3/z8dzAy1FSBPOyg/?=
 =?us-ascii?Q?6y4xo3ZxC0UGidUD0lJRR+DIkB5J3hcV5lhXpUwoCBW9SKH1NcdhSpdwh/8j?=
 =?us-ascii?Q?8BHcMWdzms5w9Slu7Y+1jdTtE0Rn/O2ArAhjIoOwX3khgIIZxInHgpUf93yx?=
 =?us-ascii?Q?LoueCQ+BtV/l/DUh72ap7vnmE0fqcSYO11XCBVJJ+JOwmWlmZ23SC8IZwW6q?=
 =?us-ascii?Q?pr5mpJsIofVy8delUPkAw8M=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbfba109-8c89-4bb3-a900-08d9a58c543f
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 03:27:18.1220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lAJEP6HUhRxFTIDqJnk291JcVOkLEtbbHDDKHmhgImU8wo9TPW75bbSEbg5HPysPQwh3+Vh7PwPPNcRUNl74tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB3614
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 tools/testing/selftests/bpf/progs/test_xdp_noinline.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
index 596c4e71bf3a..6d9972168a7c 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
@@ -428,7 +428,6 @@ int send_icmp_reply(void *data, void *data_end)
 {
 	struct icmphdr *icmp_hdr;
 	__u16 *next_iph_u16;
-	__u32 tmp_addr = 0;
 	struct iphdr *iph;
 	__u32 csum1 = 0;
 	__u32 csum = 0;
@@ -444,9 +443,7 @@ int send_icmp_reply(void *data, void *data_end)
 	icmp_hdr->type = 0;
 	icmp_hdr->checksum += 0x0007;
 	iph->ttl = 4;
-	tmp_addr = iph->daddr;
-	iph->daddr = iph->saddr;
-	iph->saddr = tmp_addr;
+	swap(iph->daddr, iph->saddr);
 	iph->check = 0;
 	next_iph_u16 = (__u16 *) iph;
 #pragma clang loop unroll(full)
-- 
2.17.1

