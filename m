Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C9C6899AA
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbjBCN2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbjBCN2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:28:03 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3028B7FC
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:27:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cv7p1LPoWSxxy48lvy4ibWOSNIATJTUm6nPbLmG6QLUysJG4ktEZ4v7T1Xxfr0MQlC0TOxMfj7kDEQDS6+yVEBbxzDQN3Cs1TQMSkIU/AEPKWkc7q4mbIB0gmbJTtBUC1IZ9kBjVCIanT9ZT3nM75FcNu2bI6bPG3Ryh3Y4JkLdHHHRuYNoCiBZ1ndIQqBQYTcNfHT+Rewb6kK9uI884IcqCYGFuGf850EkRmuj5wPrNgDFIMZ0Xea5SJiF9TZpuxv0mUyJ3X2PmwuEpApQhGmTt6YOqXvJCcSrvnW1qHVhnbSqxXriSBKYa3zpLUIksupkf9i8mGuHl8Zq6FkqTLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0J4LimSn8ZUbTM5j1NedghnIFosV0mMEZMKi+xnnuo=;
 b=BfGbUCzHcCkiTXvQL1JgnQrs7z9eJXcM5HEz8mVrgT+X4LTYkZIw4h2DI6vF05tc4/iFqpn6D6olowF0HhEHpEXJo+ftOI0WO31mZ0ykbkSPconC5xzAXihML8uHrMN7HUpMkzwKKAY2sSf+Y/z1LCy7YMzQqCvWpOwIgZ4fb4rnb61ZdRvzuSJGmYWUhPmmCDsK1RKNfmFxsgRkc0uipJotsKZGIftNsbGQK5C1LRyLQvYyDyOs893B5AkyRewJ4nYXS4W88Bi+hfUmy6vrZiqfbbAx4Q0tINMulWUgY50JMRfTLF+k5rQr1YPOU1POAp3smZ0qjcE+A21n0xJjSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0J4LimSn8ZUbTM5j1NedghnIFosV0mMEZMKi+xnnuo=;
 b=hn0A2jeARREAfSCFIjnds26mGYVUpiBIPo/hxae9WBuVdKt7sMGUg1RUmY/jDGbl70WfUpzXF5LV8reRq91i9kIbSTOCixBAqm9tchgHm9uEnx6+VQvrMeZ2cNwlyF7Rmc788E9XwYUPosI/14U333R6GjFzCKW1JgVM/aMI4QTk+2o+eMXa4yzUOtrcyZwxtoY96mjMB0JnL0mtFMbQTonJDaVDfcB5BkLm7HPBC145EcD/s0aIT0RDguJ0XqQAQFUmAIGOBirpYYj8P4JTCyOr8cJef64msixl9MHXzWe+JykYJwZsJfrKCmPqU6a3QkUDkb4fLWL+7Er12LO5OA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 13:27:50 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:27:50 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 05/25] iov_iter: skip copy if src == dst for direct data placement
Date:   Fri,  3 Feb 2023 15:26:45 +0200
Message-Id: <20230203132705.627232-6-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0021.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::11) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e6d30ed-3983-4fdf-149d-08db05ea7267
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JN3I/AfLboTAXlFa2nKPUNETg56GqSBs+asg0ZJG5wIR2bHyEMsVrTbfVINybM7hYLOJEEyohIxc0aDGC6Gm0BMhxpA2UmxU8KS5e+FWHmCmt3Bx9tcbVXZyxzXh0ZCUX8tFtiHGPOiuzFFrUrEnSfFgrU/y0B/OlKXF6jixBQQnU0F+871ypEKB2umDMMtH5GkIr7LdElZtBhDAK4+M14Y4WI+grrDwKcchlBcwgJ1+kkNejEeQdY/J2CuhkIhI5T7Nj0gq0n+zzFDq9k1qjsgrHpgMVdZ73XpLhzbIhyaNPYWaMLJ74aBnCGD/unH9m6m64jR/RorzUHvQ2wPLDjxcA+jNE8KeS7q2pLQ55BbdXXPG37LqdU0KUlorF/6RXR78rTn/wM0SNzfPFPn9IIWDbuFvXECoSOtJBze2ixunL8abvl9NfqhHhQbYn91vif70GdD15PYkAmTuOIbQMovESKkrSlSPLtbUduXb5w41TcQ+9pyNCN55Mm/cUcop1CEyLj2hu4PbpnZE43ogdJtH+S6JRq1RVePu1abFm0yTnSxo5AjdoN2RThoK/07J3FvXOFIimpfR3T0cf+txDE/JYxA2PF9otS7VnDgJebbOziZtBjJsxblDygV8Dw6DkRnJ6HReZCBi+89hHxIKsMgNYrkmlYGpUa8XARzJrx0JH1usuVPNR2uTpZcQ+mr8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199018)(2906002)(36756003)(83380400001)(2616005)(316002)(6666004)(107886003)(6486002)(186003)(478600001)(8936002)(8676002)(66556008)(66946007)(6506007)(66476007)(6512007)(6916009)(26005)(5660300002)(41300700001)(7416002)(1076003)(86362001)(4326008)(921005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bCKsyOB5dvSTmvU1vg1FXPIFjUTB3fISFj6p/YecRhjwFb/wR2e2U5o1aeKe?=
 =?us-ascii?Q?c7OoOT4gDZoNewZSexpFo3UHfDAojBwK0nnGXjUx/Zvnfmk/SbziagLu30Hd?=
 =?us-ascii?Q?KhE6XYyNrHHBndMXnC15HhhGabFb2qlihGBld/b8YK21hLh/ktGdpwonxpCv?=
 =?us-ascii?Q?S0RU/eN7PJUlchsouh8waCZh31acakucWWI3yWTQY3mRRyDLZV3HUFUL75BN?=
 =?us-ascii?Q?4Sqcfg4pWemZg0A8waRimFH8B2Qwod77OCOXcg5qlO0TVUmhqVrHUxPkN/az?=
 =?us-ascii?Q?sCAPSyLcXi1wTeNXm66Q679Tmfzf8CuKj13PSDatBSqV7eXCEXLl/Y8dEJM5?=
 =?us-ascii?Q?NmfiHzS+gu2yNecPSjeOaFjYUDDaowOPNaRerBH+VJEqRtQcLpvEeoWcYQH0?=
 =?us-ascii?Q?lyxJGl5ocB6/jirmsMWdWnXjxy9KqixCxGdrBqF35cSsX7mBtEYEaqJ/DDhI?=
 =?us-ascii?Q?mvYuTYak84UWiMAQiTxmGtYkdlGWSJsEAKZfYTwGnuDfe0kJTZS8S303jYgZ?=
 =?us-ascii?Q?JTPezZ8dcLEEC3w8cDoMV0H3LBB5NL5lBnbCCkh2nvywwNyOQwC+Xqu1Z42v?=
 =?us-ascii?Q?zX3cGQpJg1sODnUym4o44WzuuB/poWcAIsOzAVQerkpCt6gBKV9kxb011xHt?=
 =?us-ascii?Q?1nTfzbWoXV3Mlx0hLOCfOTdqSULohvXf+QE+sLhDo5Dvj1wWAkBra+ie0/yN?=
 =?us-ascii?Q?5LvyXz4RIi6uotvS0mQegGp0qXIZvM16XSL4qp9WuBn+74AuN+CM0CqF+dqE?=
 =?us-ascii?Q?5qp6Lh8OPK2QOHO7I0wMm4y8zXQHerNBe7reiYtLo42jtQYyZsIs0Xh7ezjh?=
 =?us-ascii?Q?IjTZoOiUHuqE45Z9TzapXgomEUugesXXIXPeRQXjFGcABPOxHpYevrF19MvU?=
 =?us-ascii?Q?gQdqNhs7BhACg5MNZJHNhsdlHdCODogpPe1n5FKHH2ztL+etWW+Me3NUN4Ps?=
 =?us-ascii?Q?7dQEQrjaaY02AK39TOlfA0JmLF5hb0Z3d+4McY/OcyBk4y/NcBhIY3jebp5y?=
 =?us-ascii?Q?p4AOfzQ91KZP+YLuPjL+XmajpkA+eWIKeJAPPlAmVUqkx3qFcMonyb8mRDiQ?=
 =?us-ascii?Q?TXaeQXF69tlEF/2KQiIi2c2bvW/Jzw78GiUavYZYVTuq+ivUA7gQAWF6paWm?=
 =?us-ascii?Q?l3vJW5HLVlJ+sB08BWDOszH431u4xulCkIhRRh8DTvITbLX8Y5vSkC3SkqLo?=
 =?us-ascii?Q?lQCYp+SXVF7KMzoHTcwg9wR9GwCbrk2142RaAdDwu9mYjIDXpbfHTFP9zeUd?=
 =?us-ascii?Q?XKbiiCnC8TjhuZ3q1qFZWdPmWyEMtzvTkrmEo4jcJG9en/P+KCbMDMlJmEsn?=
 =?us-ascii?Q?yQ6MUA3Isar/8dMyip7NDLF/SCxtISIdF0Y/ZFJSVG/GV1e7w01GOYYUevDl?=
 =?us-ascii?Q?ShDJ3lWcf1jo+ux1m6xqVKAJ6jNvvYXvA6EA7keC0wQW1PlWO2e5to2I7ch+?=
 =?us-ascii?Q?NRztPfQdnp/TAH6EJKdZdJljbw1Y5HL9J0nRMZN0UPznI4Mekwn7s4UQce5p?=
 =?us-ascii?Q?fmC3FIxOytILyJetoMek9KC4MB3x0pYXGEeLa+Mk8Q6a88mABXrkjwx2ojSS?=
 =?us-ascii?Q?5KI+ZUoTHNCLxNR+tPjEc56KBLiNMr8yLPBy53fI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e6d30ed-3983-4fdf-149d-08db05ea7267
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:27:50.4151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G1fiY2Wq/s18lcsUlp6Rmk/Dk5b2yemQ/AE4c+usyFoGM5stCN+44pp3BBrqwEsjODJn2HBGoKizzDE4DB0s2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

When using direct data placement (DDP) the NIC could write the payload
directly into the destination buffer and constructs SKBs such that
they point to this data. To skip copies when SKB data already resides
in the destination buffer we check if (src == dst), and skip the copy
when it's true.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 lib/iov_iter.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index f9a3ff37ecd1..2df634bb6d27 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -526,9 +526,15 @@ size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 		return copy_pipe_to_iter(addr, bytes, i);
 	if (user_backed_iter(i))
 		might_fault();
+	/*
+	 * When using direct data placement (DDP) the hardware writes
+	 * data directly to the destination buffer, and constructs
+	 * IOVs such that they point to this data.
+	 * Thus, when the src == dst we skip the memcpy.
+	 */
 	iterate_and_advance(i, bytes, base, len, off,
 		copyout(base, addr + off, len),
-		memcpy(base, addr + off, len)
+		(base != addr + off) && memcpy(base, addr + off, len)
 	)
 
 	return bytes;
-- 
2.31.1

