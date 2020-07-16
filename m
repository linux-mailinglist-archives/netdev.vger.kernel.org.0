Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E952220E5
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgGPKs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 06:48:27 -0400
Received: from mail-db8eur05on2081.outbound.protection.outlook.com ([40.107.20.81]:6113
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726239AbgGPKs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 06:48:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZsdIj20aaWWzAw3D2e4N9//5fpO2Hex3x/vCXJNfdzocUJMpOCDq6J5tVLuGgg4qbZ8meM6ZVaLn79wXC8vHhmzozELNp9DXPB8halu1lKHvNMdogM/NXLAg/GT0O6SVvOcmnFLZ8LAG/MLv+2GKm+I4u97buVbgSjJz1hBpsv0oggQKOb+xSbNJV/ibMIOOtn16HlB29Sb9yQeM85Ya1BLdNXXwpMdoMxxr0+IUX0uXjIYLe/KkrpQw9M7JxeK8N9YAjrJ9ibU5XFWvCyEY6YIBRvmEKbn7YZmenTAr3Zv+i8p2A1XqX1vDkuOwf89nM7uAGcLy9PTln6ju3IMofg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2vVPte39keBoH/VEHYa3VihcPj/mbDyxV5G3Yeqp38=;
 b=Sd/Bm32CXsXq+U39UUSctF+jAykgl4PgodL6xMAhK40YMaIxCSgH6df4zoxL8eMmtEEo+eS9ZLX7z0h1Eo9fh4dHcfAkWhC9OAkvAannSuwSo89OywAi2Z4x+xmLly7C+zrXsmoq8foA+cI+eJI9sX+z4Dr/OQOMDyIO+rJcEx27qb6Db7RLnQtBvn9H2OLavYg8n5ZmvXSDZaNtbd4rOtPzY0XrcfeplwtyzPDQvRTIz2LKphNxCOqjSU839JyaejBoGNYwUjevpjvATcNWDK64YHwLb/cNv4OmguSTAWZ07cEH4PUOOcAi4K9sFyhWEp4Fd+U77mhvkrhM25QpIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2vVPte39keBoH/VEHYa3VihcPj/mbDyxV5G3Yeqp38=;
 b=Z7veLzdmxRpYS4GRS+pk+eOCejc7ZM9KcVT9VgkXdP6N2AL5ZZxwST2CT9YHWkTnE0EnguMns14PYHzlHW+oZeUMddFKwRZJE4VL8K6q3Ata67ShNA4Nr0r+Ucu7VkvzX8Yn8+BNGZh8MfXs/gvOQmAZmo0MhI9dgAaEFd2EPRs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB2940.eurprd05.prod.outlook.com (2603:10a6:3:e0::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.22; Thu, 16 Jul 2020 10:48:23 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 10:48:23 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next 0/2] Support showing a block bound by qevent
Date:   Thu, 16 Jul 2020 13:47:58 +0300
Message-Id: <cover.1594896187.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0046.eurprd03.prod.outlook.com (2603:10a6:208::23)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR03CA0046.eurprd03.prod.outlook.com (2603:10a6:208::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Thu, 16 Jul 2020 10:48:21 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8ca90d9f-d604-42e7-6faa-08d82975c28e
X-MS-TrafficTypeDiagnostic: HE1PR0502MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB29407E9119C8093D3CB5538EDB7F0@HE1PR0502MB2940.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1qGZ5LmV/Qjc7s660If0cr7PZzq1asPHqkYzqMyBayKmEi6MEW7Irh/RwON9t1nwdAQIQDDSD48OA+4KrQcQE+hdP7CexhsT/hQArYbgwjuvS38uLSe0GGo19jK/CGVUu9iLnpO9Nm60HaUgtIPBMbRKI4F/TkxQIwSmE/UyVLzUIXU71clb+AtGhEc7rrleQK8mywKgqnxNIewSTxg5u4O+aqsfp0ey2fw6rMRWdGOx7L9VVvyxhd9/CqMWxTb9W398n3Kfp0yGZRgiGpKMPJcEgbVzOiwYId8iqJnynhl85PN4UGr9orCRq2tN0cAV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(83380400001)(6916009)(4326008)(5660300002)(8936002)(478600001)(66556008)(6486002)(16526019)(52116002)(6666004)(36756003)(66946007)(86362001)(8676002)(6506007)(107886003)(186003)(2616005)(66476007)(26005)(2906002)(6512007)(54906003)(956004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oQHriR4S5P6NgJRP1X7xPr0GF0wYRzojUfJkpSVeEYkLh6GbAwLH6EjeVnw/kDQYvBeDp9K/kszyraYlNRmyLOre9OlG5ierJQSKW+nA6PZ9rYqn8YWcs+S8E6Z1VW4gMDm8nEBv3jc8o4Uhgjq601HrnsFqTgxVEDQ/141/oawnTXAywjzHLNT5Ay7lcr19RxzK8Mw6ajWt17iWaTMzOtYoImuzCFEl7yW6+EN6bMclKEKmwFG5ew1P7KuFVN/XAdxMfN3A6moWDcaSY8m3jfMvZpH3O1VHpySjTJPeYwkEYL+vgnsubYRC2/U/tNew1pgNnv0FEvB6duBXUgXXLepVbHzymhkPIYEeB6kAWh2g+oGiesXWsb8h/LF6sQZDF/PjXOYg8tDknJNLDtum8lvYxhOIg9L3LkeDl1TeufEaaI4dXcAs2XQEQS6aC9XF1wY+t7afZWAchi/NXN1q7ZkjVBU/9CfRxbQlQ2x5/38=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca90d9f-d604-42e7-6faa-08d82975c28e
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 10:48:22.9759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d1P/4G3k4PROUNZa2BWD0R6Mc/2utTAGQuGg0l2sEbasXReOVJCrbgra/ll3vCuiYDPiM0NlM0Zc9qEJg0NCbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB2940
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a list of filters at a given block is requested, tc first validates
that the block exists before doing the filter query. Currently the
validation routine checks ingress and egress blocks. But now that blocks
can be bound to qevents as well, qevent blocks should be looked for as
well:

    # ip link add up type dummy
    # tc qdisc add dev dummy1 root handle 1: \
         red min 30000 max 60000 avpkt 1000 qevent early_drop block 100
    # tc filter add block 100 pref 1234 handle 102 matchall action drop
    # tc filter show block 100
    Cannot find block "100"

This patchset fixes this issue:

    # tc filter show block 100
    filter protocol all pref 1234 matchall chain 0 
    filter protocol all pref 1234 matchall chain 0 handle 0x66 
      not_in_hw
            action order 1: gact action drop
             random type none pass val 0
             index 2 ref 1 bind 1

In patch #1, the helpers and necessary infrastructure is introduced,
including a new qdisc_util callback that implements sniffing out bound
blocks in a given qdisc.

In patch #2, RED implements the new callback.

Petr Machata (2):
  tc: Look for blocks in qevents
  tc: q_red: Implement has_block for RED

 tc/q_red.c     | 17 +++++++++++++++++
 tc/tc_qdisc.c  | 10 ++++++++++
 tc/tc_qevent.c | 15 +++++++++++++++
 tc/tc_qevent.h |  2 ++
 tc/tc_util.h   |  2 ++
 5 files changed, 46 insertions(+)

-- 
2.20.1

