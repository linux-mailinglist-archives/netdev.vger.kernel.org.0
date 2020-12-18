Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AD72DE19C
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 11:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389268AbgLRK5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 05:57:30 -0500
Received: from mail-eopbgr20092.outbound.protection.outlook.com ([40.107.2.92]:62798
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732744AbgLRK5a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 05:57:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DuwHOg47Ke64x11O0b/cIEn8illAbDOZsKMNGTOw0+wev6DEjjGq2kiEuh1iZZIQfqaag8l7k2tdNg8xq7YJHUhxiVsGqEltWS98Kr6u/HPzblx6cs5bWqnQhTgBpNbxrLLoTMClRILC4Um4kZ9PNHFsOBr5bKxi+F/h5jqZRlNZD/ArIRfbzjSNRK4C80sVre0g/QMHmr+iddD5m3dQ7PL70u5rf2Em6lSdHBzbyGrxcWe/6+YW3Fuf0DHWyWlehA9dTM9kA5tj2BGm6Y5/J1WP2nPqxTnmkvAEihTEbW3nA0NYlq1oAokAwWvsFid8Cnm2oiRHDi6tJpZU2AO8oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkCRv1cpcMBcINj2tEY21IZ9I/xHKv6lZzxZhPcmuQ8=;
 b=gE95HLQy2D5MxPozcK5Tbt+I8yj+HpjgYwJOzWy0djZ71CH+rlntHaLoH3XESnmk/O3FTbefT72O5XaQtz1vKruSNeuznMUXcdp4Ul6GknOSXUQlwnXrY/OcqtaCr2jAyhwd4NyYPMUiTtMJF8Rl+rqyvJ1mlJXypj8QCZ88dpGx2cKcO3h+6XqWMjJ6ul3Kw0ull9lKXv3TPvqtflr5wavAYaHXvDkxGXF4tQ3Cv7WnVKYTHiFtMjsYkfDRV1ScUtRRqOD42N77sz0lfJgcL/VO+4o7yNO5E2JAzRJpR4DIykKuv4yFSn1DJdYzWW+ndrZabZeAYQLAvqkRyBqDsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkCRv1cpcMBcINj2tEY21IZ9I/xHKv6lZzxZhPcmuQ8=;
 b=enYgCSAFQgXZm/rIja/d7ndYmdtH0/hXJHXlHfDxLV2WNmF3s0J9NtTmiF4Lcs88/CLsRIvyN1xRmvunGssHGYem8QX7QeAoNj8G+VRlpHdiu5WOfnalYrpOcmrNo1+Ld/iA56omBrMtGK3LFzwqcC0YrK57+sf01Pi/sNNWmpo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2675.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:12d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Fri, 18 Dec
 2020 10:56:40 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 10:56:40 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Zhao Qiang <qiang.zhao@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net v2 2/3] ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram
Date:   Fri, 18 Dec 2020 11:55:37 +0100
Message-Id: <20201218105538.30563-3-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201218105538.30563-1-rasmus.villemoes@prevas.dk>
References: <20201218105538.30563-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR10CA0100.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::41) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR10CA0100.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 10:56:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcf8bbf9-43dc-47ee-3a10-08d8a34399b2
X-MS-TrafficTypeDiagnostic: AM0PR10MB2675:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB2675F646547694DFCEB784EB93C30@AM0PR10MB2675.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d3P+TXNwEUEGfVnSo56ZmIQJvSHQJa3bDpIe7V/XyAHacadE49MjKQ6kzUd5GigAY2zsj3eAWUfMZQ0EHnxdWd5S8EgtVD/4Yc+4djlvnVMnA+QQStc4CQdZnAIxnKGIsDHZLawE+uydXhx1606BJ+XWaxdLU0sL4z6lJCuuxNnP/8aJ6I7aStYx5RaVWREBPHRj9shs4/nVp41eKBx3Z6K6U8oqIS/p7FdGohX4VhT6qAKjwlAXPmRbluKY1IPfFsvG4GfdBKK/38TVM26HKzAhpgfLKbG0ng1jSBBepzmE8ZvS+KKNdoIL3AQ+v/JAV4jM6EQsVGGGELV1RNh/vQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(136003)(396003)(1076003)(16526019)(54906003)(8976002)(6506007)(36756003)(52116002)(186003)(107886003)(8936002)(478600001)(4326008)(110136005)(26005)(66476007)(316002)(6486002)(2906002)(6512007)(5660300002)(86362001)(66556008)(83380400001)(44832011)(66946007)(2616005)(8676002)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?a7HVqVcdW77A44DT5E7SQLE7ktEtJxWDKz7Eue5Ie44Ko3mvq+aqr0fFEgaQ?=
 =?us-ascii?Q?7S3Lmf7l7LSUNoRhnOPzI6syN171MyYyoz8kiW+3/Ck7fsGwCk6pbS0p5INS?=
 =?us-ascii?Q?eNwL2lyIv7JNQReH4FEsiTBkOUQ2uM3D6IcnfBjh/9pE5adsJB+6aE9FQHlw?=
 =?us-ascii?Q?80e8tDPf6TC02UdkkKoi+VGRzgagpuYkIRCg/1yPS8EDfE0GYVNV3CCJ9Dra?=
 =?us-ascii?Q?8gLREON3+3rWPypYNGZzGoMIweXg+qoXxt1Di0o1sBSDms6Nv/FTKtSeMF1y?=
 =?us-ascii?Q?oaFA7KPCbqvifDEEg0ozMYaSiBLdcVkAXugRPMZY9N4rXPzRkPR2yYWySStQ?=
 =?us-ascii?Q?/4J/rslsxpQ7oy1PiZzOCqsg2lj+rWE4nBslTm+co3qXymCa3NnOBYPLb2Ar?=
 =?us-ascii?Q?OHUh3TywEYSBrSPm0DigopfKj8wfIdAVXkkEr0MvOhcbyg3WyNNQ5dy56Yg6?=
 =?us-ascii?Q?MIISIuNMXDnbcvYJ7VfTcRDCie28R9FoU+ZZ8r1QOgi8FuWt/s5gRvLC1/LZ?=
 =?us-ascii?Q?g0z3WEPkvj0B24S5MnWndfqD4g7iPKLUZyWTpHSXox0kA53EMLQRgOs4Jivg?=
 =?us-ascii?Q?Q2k/rDVEvemMDh16Clg8Z4cJqJaJWJq9EoFWQC28VjFeOFABwP6qgkuyIuwz?=
 =?us-ascii?Q?YX+ef+y7XxRVf41H6QuE9mMMG0qvtnjcMHArXm9EECV0IBFTEpVASw1CVG81?=
 =?us-ascii?Q?Lv8f/++xU6zmNJ/JKgLkuF3sRTa5kurcqi6NpVo7uVdLiqUreBT/2os1Rjzo?=
 =?us-ascii?Q?QfNvLjXawY3G2A+8CLfHrH86N++59g6fYx13C1DSL5tnqeHQsbM2kPMKQ1xQ?=
 =?us-ascii?Q?rgu62v4HdG8gHEmvMTkq3ebVXamkHJyjd38ceRgGSFrQN3TZEvuLBW6RXBBc?=
 =?us-ascii?Q?UXWrIhD0amfRLdC5SA/Sk5HM9/nzAqkucZkQueBXShKu6z26lz54mHSvjV0C?=
 =?us-ascii?Q?U7xl+FDq3WIbQfGzEvMVBjaFft3ZS73GLPDPyi9XbEAiTamRRqqOXCMk9KVx?=
 =?us-ascii?Q?SM06?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 10:56:39.8812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf8bbf9-43dc-47ee-3a10-08d8a34399b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OckUCGAaqB8rC7elRF1/+x4s24hzdAARagiFU0qaj+5LFfuOhTK+dCMlHVhwOfUfX4Taks0gsJDVPe/P6+yillYyKKj4OEq03ZZ/novZiLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2675
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Table 8-53 in the QUICC Engine Reference manual shows definitions of
fields up to a size of 192 bytes, not just 128. But in table 8-111,
one does find the text

  Base Address of the Global Transmitter Parameter RAM Page. [...]
  The user needs to allocate 128 bytes for this page. The address must
  be aligned to the page size.

I've checked both rev. 7 (11/2015) and rev. 9 (05/2018) of the manual;
they both have this inconsistency (and the table numbers are the
same).

Adding a bit of debug printing, on my board the struct
ucc_geth_tx_global_pram is allocated at offset 0x880, while
the (opaque) ucc_geth_thread_data_tx gets allocated immediately
afterwards, at 0x900. So whatever the engine writes into the thread
data overlaps with the tail of the global tx pram (and devmem says
that something does get written during a simple ping).

I haven't observed any failure that could be attributed to this, but
it seems to be the kind of thing that would be extremely hard to
debug. So extend the struct definition so that we do allocate 192
bytes.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.h b/drivers/net/ethernet/freescale/ucc_geth.h
index 3fe903972195..c80bed2c995c 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.h
+++ b/drivers/net/ethernet/freescale/ucc_geth.h
@@ -575,7 +575,14 @@ struct ucc_geth_tx_global_pram {
 	u32 vtagtable[0x8];	/* 8 4-byte VLAN tags */
 	u32 tqptr;		/* a base pointer to the Tx Queues Memory
 				   Region */
-	u8 res2[0x80 - 0x74];
+	u8 res2[0x78 - 0x74];
+	u64 snums_en;
+	u32 l2l3baseptr;	/* top byte consists of a few other bit fields */
+
+	u16 mtu[8];
+	u8 res3[0xa8 - 0x94];
+	u32 wrrtablebase;	/* top byte is reserved */
+	u8 res4[0xc0 - 0xac];
 } __packed;
 
 /* structure representing Extended Filtering Global Parameters in PRAM */
-- 
2.23.0

