Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE9868AB78
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjBDRLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBDRLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:11:48 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0C73251E
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:11:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=og8kT7B7I29tdp0IdABtav7+M4ao7rekflZ2cmc4jmLZOg5nvmdYzHoEv4YOfYXj2/1kI3kPfKksOVRgHoNjm52fA2ZDGUKxg53cqVx9czotftLZ/825OnqRhUxkqUNLojVnds/ZyHVNPQOQ6gV0SQK8EAB27vZX/1hVqH7y9YVu9uo6+8yHV5wknQJov1kUy/fVGllKWYlRQFzZje/nhaWFTB8fQsni+3LeSHPgGlNJ8YfSKycAuLBGZdbPxPhPlwNqgzgXBiafzHxYJQC4KrP6IRCY6KJzQhM1sj5sqskHFJyJQJKf7YHyLf4596kYeMHRfUW8dvTASs6xzfuPQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HnJRCy5BevDcD7JznBApG4QkbYTYfBiimkz9BfO6Lzo=;
 b=RETTOCLIB8o5bbL3h+2JbSkhinF1MoNVZ7drdwjMaX7iJh6ah8z0ndCJOZ6HoddXcZ6ZHloRLnnJbJMQs20kkMWPDzaExgOWoUWoSn0lu+vew2wuvDrRaUPA/zP1eDnkyuqExKZ5LD7JKDvNbdExMpBmyM7dgJnA0OkSbbeQxGAqb3syOvVDvHr5ErSGM9RcFNsZ2tX84JcggCMLXQ8TY/Mo74oZhhTDA3P/s+yx6Lxy67SFNf9158vOa7FyF2e43Nvg8deM0AikTw2ShYHFgl7LvnRhKbk8iLTxbqhPAXoeyivwDTXKjnMArk8pBaA4JOaNwAEgC3LVfG+eVXjGuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnJRCy5BevDcD7JznBApG4QkbYTYfBiimkz9BfO6Lzo=;
 b=oe/xDwjTLe/mghUDerGfAc4S4UGc3V86XmSOdJQh4YwGoBM06JNEm9MpZlGonUitJvWKJ0hwOEMBjqukcXzRmAvgOMcsF0T18w02SEsPJGuO496O3Lmg3IWXShc9XzujKx3VelA6ElxWP+bXyucSWzWXDcGEazdSWa0aueDZChQYtPVJLlvExxMenSh2d/YH6NJT0pWQOgrN1Roj68c2J2YYL6F3n8usTw+LhCYHyH9NTf7l7AITyOK/mA7X7nVkMM5dHz7ex3fZerrNUpy1U4og+F2evlv52qdlsW1PScCUcFGavSGJjgRmwVCrBe+8RlMw1Bii15QyfQj+8N0Gcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA3PR12MB7997.namprd12.prod.outlook.com (2603:10b6:806:307::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 17:11:46 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.025; Sat, 4 Feb 2023
 17:11:46 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 01/13] bridge: mcast: Use correct define in MDB dump
Date:   Sat,  4 Feb 2023 19:07:49 +0200
Message-Id: <20230204170801.3897900-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230204170801.3897900-1-idosch@nvidia.com>
References: <20230204170801.3897900-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P191CA0008.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::6) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA3PR12MB7997:EE_
X-MS-Office365-Filtering-Correlation-Id: f864dd64-ad9e-4331-d1f4-08db06d2e539
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cMHK8PBFLWKB7SNs/2gJSVRS/irm+qQ3ZPtFme9Y2Oq5zdxXyKZhDVqBWb32doXMxTkEt5HIM38tdiI0UecOTU9sqxZZ5u/Imm6KjkGFERcabkRAM1iO8oRrE198qTvE2PWaNvUxntfyFgd4zL/YcORxJTFd38/EeBvTwd+pRNttFMdQDuJa9p9Kpw8BK6IQzGeP6y2HSYnA6q1W3P+T+aMdY1YX+iUqaKe1d7seyo6cKSE+Jqmb/IqFB/EDHS8N/Zr2IPi2R+phevfYtPOq2cjcSEUwkyiLOwT5Zqyhe3u6JJ+CASgutZSKOPSAgZreXNN8gf1LnkBA0xTSdkprz0JHstuxHX76cYojmQ5MeENldK20pV2Gb783d3ozR5Idd3G50ASC9hzte01MQVHGzW+CNpy/aDKLxgKvoMW7r13owDCWuN9SAS/LVkAnKIyXSoFNVoULGmFd/id99CX2Tzpx3KIVRmr3UPUz9DZhA7sSxToxZtejN9aLmJXsIPPaagpqxPr39g1bv9DqH5cyKSsKcOCGiMG0ZaYDnt2ZNQaYLcaCUsVw074zDOAMuH8FSKuEehKSln1U2k/z45JQQPcXUG5b4ogbVIqbT8/qNJd9ZO35BqCAWEvlILxxyGsfOtcEYjYZd3ApjykUdyKqYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199018)(8676002)(41300700001)(66556008)(316002)(66946007)(36756003)(66476007)(6486002)(1076003)(26005)(186003)(478600001)(6506007)(6512007)(4326008)(107886003)(38100700002)(4744005)(2906002)(86362001)(8936002)(5660300002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9nSxgYGNtwDp0J7Ax5RICQ2VpFxJA00uoEhVITIvyH7t0smAwEep87MCt8iQ?=
 =?us-ascii?Q?Z/IsHJ87qb6FqoinBZpSW0GmFJfsVV2HzOR8pg14WFE6JWsgMvC3qK1gskKi?=
 =?us-ascii?Q?t7HpQM8wnxFdHuBEV+9ST62oXX/6/tyau6wW5mzN+BCCauW34aT27juW98qG?=
 =?us-ascii?Q?/1uzy3iyPO9c/niKqKMlYJ6GfqMZbs2vI8mjYLNV2uyt8jhvFrlTPvBBgrdS?=
 =?us-ascii?Q?6SsPa0t5Qi6wfOE375+abJbpfIYlp6UugIZ2juOiwsVxNLVZUqGKaFVnxmMF?=
 =?us-ascii?Q?nm30qCGeZTEX1W78gceaMldfwkAvAwBkX383MEB2cGI6k10ImPX36DGylhFU?=
 =?us-ascii?Q?L+hqFA+HvgSGuJS4CziXoRmMUGafXAiddUajvlHHPhVlkWBXI49mo9wJr4RX?=
 =?us-ascii?Q?fVadL47wdnai8XpE11asDtdldxlpbTxkpIpLuldGsTNkg5NfwsSZ7JRNk+tW?=
 =?us-ascii?Q?x755xg9r5GbK1t2uYNXOss4rdwx9b7AbLNCy0PopzuJgq+Gj4xaqdsR1na5g?=
 =?us-ascii?Q?X51GfA3oAYWohQ3VZQzApDeEJq8IYxr5BWA/BMtf6ogxHNsC/S+4CwB1flpO?=
 =?us-ascii?Q?xcOo1Qnz1ist7j5H612eQJeyPxDRhBrkWKs2RAVBNeuXx+1N6aCKAJlQXK9I?=
 =?us-ascii?Q?EKJG2zx7J9NRC35OiOqL4RJU0lWwWnDFl3QOySwkh2C7AmkiQU9go+NgQSiz?=
 =?us-ascii?Q?Rvtp90pxTKOi5e39oPNBPhl6LCL19zmtDT4zbTdQJ8t5NjM/VQI33XA9Vsx7?=
 =?us-ascii?Q?HzrDa/sGeML94foHDFEia8n4vM+1eXky0FXFV8kJ47TzNneO8s4pr0EHEzYf?=
 =?us-ascii?Q?WAvCnu30t/2XloSoV65MLgb8vGiONhjr4vbJtWK7uaW/mOPDXafZBm4RlG7/?=
 =?us-ascii?Q?JGLVEwJc1/VLEtRRiEwBMPy5FFpmMXWJH7/NkcmZKASkgw/bIpJsWyChOfI+?=
 =?us-ascii?Q?sB68dQBR5ZUE3PByTVS7SYBNN6AjhHN6RFb0wdd45HTPVjmLD2roC2VzAmd/?=
 =?us-ascii?Q?iIerjhKVFNqXpGlF0C0ve2qf5537sWlAemRPLBLDuzikH0AMqV+VWyU7SxqZ?=
 =?us-ascii?Q?u6To2tJ1cvra6oyWkLUIrJN9x7UhFfBBRP1ZXqmYL9G6iBQQxWZJTKHiIxcH?=
 =?us-ascii?Q?XiYp7OvkmgnWc97AoUE6kyZhXvXCJLw7lBzfttWZmo4hF+bWCG+17L+YU/M9?=
 =?us-ascii?Q?mx4fglZ6EaSzM4ZesH1J8dkDycJMR6Xq0ZUlrnd6XixqN8yXOqOvLSylpChB?=
 =?us-ascii?Q?gZT3qUJOEmer/YtzGvutahluuacCVngIa6DhRwXEM4I9K1dU3NdTJ/1NsS1a?=
 =?us-ascii?Q?uN+E7mukPO/Fw8SCRNbAyo96bSPcRi82az3vJ8lHHK9QgoaphRpaJB3HyWEX?=
 =?us-ascii?Q?PIoS799D7avD1VI5wO1b2XZ7kfb8p+n5C9VITmgLvRdcoGqXNaui4Eyzh2BO?=
 =?us-ascii?Q?0rP58uQ7Vu524Jl8R7aMavtbvrfG6eIk/Jg7ba7lKkvWw1pYXn9x3vYgkais?=
 =?us-ascii?Q?31KJ0pRADqOH0BWSgFFZHlR0sqbHBQLuEy2Vm3NT9m3kT1GXyhlUp12g6OHq?=
 =?us-ascii?Q?4wzMfKOlWM3fBYEFvsWKmQFERKumjfFAHks2assU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f864dd64-ad9e-4331-d1f4-08db06d2e539
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:11:46.2820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kc9KDKUu9z7Yt+KuArwLWt7oBbuOKO3TwBB51tdgGUZ9WSqA3qYOxKOf1JUl4Foi9pxA81QdUvfieTO45jc9Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7997
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'MDB_PG_FLAGS_PERMANENT' and 'MDB_PERMANENT' happen to have the same
value, but the latter is uAPI and cannot change, so use it when dumping
an MDB entry.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 00e5743647b0..fc98c32e5894 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -259,7 +259,7 @@ static int __mdb_fill_info(struct sk_buff *skb,
 #endif
 	} else {
 		ether_addr_copy(e.addr.u.mac_addr, mp->addr.dst.mac_addr);
-		e.state = MDB_PG_FLAGS_PERMANENT;
+		e.state = MDB_PERMANENT;
 	}
 	e.addr.proto = mp->addr.proto;
 	nest_ent = nla_nest_start_noflag(skb,
-- 
2.37.3

