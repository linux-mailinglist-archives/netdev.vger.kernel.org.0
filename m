Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43612CFE1B
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgLETT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:19:28 -0500
Received: from mail-am6eur05on2119.outbound.protection.outlook.com ([40.107.22.119]:7011
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725902AbgLETTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:19:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmA+LdE07DiYu4+jLA4oAJDXT3IVqG/ItuBd1H0MjsiXeimi+eDSXgHOM4Q8sGQGGkXm9nSusRq9bWMjfLB0wtTyDFtsgBHlNlxL0x8v4qj0zDFtifqjDK/t6gEIeOZpgbx5M/W20ZgxKEWIMWegCU0DJdrclzmNtpIc/Bm9AMluR3YIkzMaG2N+K4uCk+YdqYDHDGV6Sv8vE+2eyaH7lQzRTtQyVccrXEL+p29ayJWcj7EkHDZvEN8MA3zi7zSWY+8nGxHltAKrP7o/8g1azRKYpWGQprgG1ICbceniVXon1GG1LOKDhr/7hbZBNVJLbcaWbCtIe/pRjSltlfAyYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkCRv1cpcMBcINj2tEY21IZ9I/xHKv6lZzxZhPcmuQ8=;
 b=eOPhVQE09MiFiNMoqCK0qqWWDpHhWGyFcU+gmeqJW7K8ubzhdq0IqXSEdQVxq6GNtnES2QEXtR39xh5LXza5aXw9pa4mODjpR3IxPHMv8T1MCxl3reabIMH4iJ8kL1AZ9F7ktqJ/4pLd3Kc8VrQtcoYuXrYfejoT5qS0I2iXepV40WD0NhZnZosBtyY6GbWd8W1GoU0VgIDHFuR5w75OvAp5FznvvTnoXFQ+N3lvOyW6/bd512hoRRMRu4gZ96H9y5DZZkjq/zj3lKwTqPjPu7MfLImBpG035FothsOQjj2biNK0oxlQOhblCrOKhpkfQ1keqnk5VlozVRuw9lZyBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkCRv1cpcMBcINj2tEY21IZ9I/xHKv6lZzxZhPcmuQ8=;
 b=AUjYELBVrYzDRgi08nkdrh/aYR2hxxVgVVkCaTgXb2P2FKqz2s19sU2bjM9x0kcunlu1OAxNWyHexg5mdKxdNopMx/TFprB89VxagypfU2mLePVJMcEy95hXRncRFB0bTYh1bTmXveHowRDj/TUBbgoqBFBje36E53v/BZ1Fy5k=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:19 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:19 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/20] ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram
Date:   Sat,  5 Dec 2020 20:17:25 +0100
Message-Id: <20201205191744.7847-3-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e10cf3a-404b-4257-1478-08d8995285f0
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB13634D2DDCA499A7B23564E893F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ATMaDT22gB8Ew51QMzugKcQbRAW8dGiYru8ns1Z5BiPrafWriCsaMxzz9tEeeTsrgQCCCGakaCI88PYhUN2aZY95WoxIk7dhvC3I7lBzmWZdWBy1KAzptDVpqmVVTuASj74DihtQFXddy67IpQTwzbWB/VRPHR+C/1OC6KAxntgZ7aPbRosTLkMW0j9HMYyF7GzruQmASleZGGpLcgLkqk5BKLFyTxXQdzH8zlLRRHy5ULhaogEtqPliWGqZUzjspd+bd5PCQ1uuAZaj79tSoeufLzrSXBGtQ1nLG3QMp0ls18VBmCUcwVO+qpXPZFkh70zNphKbjTktg9S5ENoRBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?It94mAI0AKYv75w+TcZI0Tm1OB+q0FFPUQITyfzdN9zkHWEXm1Nh2NU5QtkJ?=
 =?us-ascii?Q?u7ZFGUEXRf6P2lug2r4vUAvP729yoGm+1Ue/cTbec9W/it39alG93cuf8yj6?=
 =?us-ascii?Q?Mzi7YaJF+y8iKCkQ77WK3GY8GMPmLisW7+49w+2aeu+XXHq8AKqLBhF2CNMN?=
 =?us-ascii?Q?kKj9bnvLVcJju0dBHoJsuaDP5GaBrKD/2cU86vSKmOst2QwjZYmZ5vQmXapx?=
 =?us-ascii?Q?FquAg7p4/7ZozcxqHGPqzk3E+99TkgKQTMjclrBiaT16cZsJyTd3T6yhhZHp?=
 =?us-ascii?Q?bZ0/HaL1wUbbV6FqvuX0mvYdTxHxqes6IUSfpSUSnxYorNX4zti3yyLR5xYp?=
 =?us-ascii?Q?2lsX9oU/hfJX3v93izSTxeYIBexHQxnNR9dUKsX8X/zJKe2kFqordQoiCrZ5?=
 =?us-ascii?Q?Y/veD384whAd+EH25i6kNlvzCPdlgMd2oW+9wqsshhJyLQ9hG5i4HJWSsei7?=
 =?us-ascii?Q?/6ZARUn7uVeshb33k7GCTwRkH9vwjcQ/icgOZOOCbwkET1OafcYab9sx8qjE?=
 =?us-ascii?Q?DwdHaZmqxF6xhVrHB2GklpMcAuPx0MfP3K3jV+Pjcf4jdsln3SD/HQIkjw/q?=
 =?us-ascii?Q?AdUCzZ5vYlAqRYg2D/Ie3W8SyaQYVhSQvhRhapckYlS/akd4ip5F5Suu+y0u?=
 =?us-ascii?Q?vBQIr+gj4KuAfrUXDNCooCQnqPkbCqaVhEfZ/L0+Pt/TAfWtkgxLBehdgWHT?=
 =?us-ascii?Q?w8b8aoRg7sWqwyncX8M63DEbhYIBXd8fCod+RtOYEXAfDEjnS3b7o/Agj/Bi?=
 =?us-ascii?Q?NrclkjXTSLlHtJZHKbPkeDB+nOV4Cu4XM8EMVWFxtAa3fzlXgCDd3bI6pvE4?=
 =?us-ascii?Q?6h2flQIXy7OcXAd9OuQT1CL/noAfPOGbQUZfc2s8DQhFNwhs2WFuXxamJOK5?=
 =?us-ascii?Q?jB9p+GJFiqMlljAqUWeFPCGqiEha0VpGQcbPy4vS0Etg0r1zy2LiiUt9HJHd?=
 =?us-ascii?Q?IlKB8iAPt/5LSx/nRXLYLBgqQjxpe9VzexFIQgMbF4ktMRf+FOr9hlButxBy?=
 =?us-ascii?Q?GYHf?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e10cf3a-404b-4257-1478-08d8995285f0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:18.7666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RAV6oK+KwloH6S3mzDO7mac+Ml0OzKbEny5DncCFVubd//qRnwmgQHX+2RRPfX+rU1SkA8KISh/n1OLPx5ICsc5/0zFc+2hjK4OHpIzpeZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
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

