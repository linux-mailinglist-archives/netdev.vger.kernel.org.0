Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3C2523243
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 13:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbiEKL6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 07:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbiEKL6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 07:58:32 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2042.outbound.protection.outlook.com [40.107.100.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEE23B287
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 04:58:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BzDZu3gQi3eBASgl7zpyRdDW8BuYM+HKGUkmhC7Z+wWEsPA1ikVe/E3hPjwUCSy6q7hFvRoAACHfOtuKHmNZ4DPvQrCGcLpVQBCYJ5PTksSN1hHqI8u1NPi/k/WKe6CRz07ZC5MzJsFUhDPLIT97g+T3dZXIwwz8f7RxkWDZWRFiN6GcUorA6osqMD81WtLtH+o2nCfG514Epc7xyuKMtW1NkY3g0EW/jXDPqoQSdeQ7Tt5cOgd43aZLs7kT63DjstQ6utIb/LDKqGG83u9h178yXvmFfmj3PYzwpcs1Uohecd/kkwvEQx1z3sM5DwCN9h7htcT95I8ObyddEAV1yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLnek4ZO5ItVtf9Zi3Znk0wrz5U5DJuHBNa9JDtWxWA=;
 b=GDaPkkKsmKcaCDadoQfV2xtSCmxc0Mma7/7KzkFPpz4mgCJ+VxrV8CA+YBaAMvibH5+G/Pe2NJkAVT2jYlNDVqca2Zwog6xVXneGMmW8x/1wSePOxRdlxaFJUt5zmoYDGw2HroKB0j4wRnxaWYvqiufPSabpp0pr455Q33xMP1zssHhEcrySgQMjfMbiPLRVfg1IVVVFr1WEz41tK4DBeVWG0PhinSXiy83n85t/Z2Ts9C5KINLUE+94S5+SEttTN5htri9jJopEingnmEew3pdjkm7YgcbgwOK4r2cqqzildFnj0/qp9CaoKSSJJPlKIXGpEyi4x1jKl1PYm9yd2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLnek4ZO5ItVtf9Zi3Znk0wrz5U5DJuHBNa9JDtWxWA=;
 b=DBLgQE7dJd+HT/2zgOvSXUNrI8nO0ChELzYvI6ig44RqgqXRfC3yV8TiQk8ZbmQK/bbZY6Z7/9mO347WitG79UBsnYJsy6982WB465oEglXz5y6UFxhdW+DNm1usgNg0vG1k44o3SkR2Eidou5mojFVdI8vGWhYE0mcHQrH6NmN5QlkE4uHgFdP4/W/QCC641a1Su4ATkYN0sD6JZ1dEB5hKXpceUw4zK3JV8GqMkMpLOGYVkPbV0heMsTR8BAX5XTZZ6mcpYuqMswCDz8Pi34e9HrLVQV6FiNpHTgTSOAac4Z1XJoYQL2njtztBf+6AwmBQWcnXSoKFK8/gWS8WDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR1201MB0251.namprd12.prod.outlook.com (2603:10b6:4:55::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Wed, 11 May
 2022 11:58:28 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099%2]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 11:58:28 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] mlxsw: Avoid warning during ip6gre device removal
Date:   Wed, 11 May 2022 14:57:47 +0300
Message-Id: <20220511115747.238602-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0121.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::19) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb5080df-4679-411e-90c1-08da33458fe1
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0251:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB02515C5271B463BE6C29D5BFB2C89@DM5PR1201MB0251.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xRgGuKY6Vqp3GelP+vcnvGMReMPOppYQMc/rKHFaOu0jBshj/jFq9+p7teQnKChY75Jtf4cySBsHrOo5tV4oSD1DjBFoYTPkjfBJDzfo+vAdvM6ustNetiaE3JNOuDO/rykYaYdnrHdqlFNvtdTt5cIUquQi0wIKb90zI1FvuQmr1bRx8gkAhYqbkqIdl99kv9kBZUlj56Y+4mQVXhAQ5FT/04TUOIJlw35yBV310a0l2fWDpW0s8Qc3K7VOn/jIo/WaiF0ynJ1J4Te1o+U/mGzujiHT5nZ/hzt1Y4W4npO2lt9k3KgH1IIET9FKZmmgQaCGxALvJdWaUtTKOA0+JV+YNq9woBXzb2lHQV/bfvQq0dvRVsAqJa2rKUPS1cj0YsEp6E8S7rPVgAakLEPHXD78gMt6P/VIKtTCtquyH86Hf7F66sWfJL58hhwbTr2iZHuKBsTIVy7F3AvHOS0z2Z8zu5v4nmBTclgSrOfq8kCe6Qg4gCExQArtCq135rY7Rv5Fdgr0bBpewVSq2qxBXpS8JhlK9b09ARt+4SxPHkAvnYlIr0wbUy5aeJySIDaxwZxTSuSPwo4aiTsxRTpIfXgip/pKWQn5BWJ9o4RvPb9CYIeAwDuKhAubzKR0kID0wbQ4MLu3/LxEXezix8XaKXGXvlajKKQqw21/zwZJlzHPVZwFXi4kHAJZ5qeQIAsvscI4lLcb580EU4jPYfuYdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2616005)(83380400001)(38100700002)(8936002)(66946007)(66556008)(8676002)(6916009)(4326008)(66476007)(26005)(6512007)(107886003)(6486002)(508600001)(2906002)(5660300002)(6666004)(186003)(6506007)(1076003)(86362001)(316002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ETZX4Oa+EspMj8R0yO93J5MfS7TazF+0KIFLo98ZjsRGcTrGG9IgX1mSlKyt?=
 =?us-ascii?Q?7zvRkipqmAOSM9+E8DXBaonxYuHPM1JF7RPOJ9rzJ1PLVnWaoWRas/pp8uNu?=
 =?us-ascii?Q?CGVnigxISb0xYF/cOXVFpeGMlbl1vuPvkBmHw2IJ0jEbD8nQLtzi7uDjnSRw?=
 =?us-ascii?Q?XTsFQVajUyVDDrwVk7rIaPrxSOZiTDoYM2a+zzKLl/XpskqRqrzLmNZDeI4W?=
 =?us-ascii?Q?eGU1CSEJHrm4uVUuXsqBH/Ek+CwM423UaJGaVLTNxvWRVXSY3x+LDFh3KFI2?=
 =?us-ascii?Q?HDKP1rV5w296jK/oAI3JoSBGEBCyP/9ZQBpdleuuhjKmft51G5ovlKbW/b+7?=
 =?us-ascii?Q?k1I7RNqPjV06wrELPTnfB4VFtlKZMUrkHkW0o67IjYq9xrFnzLHINwk5Yo9b?=
 =?us-ascii?Q?hltXjRar0DPz32RJ69lRpRCWksWR+PlF2FSKDJouy64KFoZB6I9N2wLfUwmW?=
 =?us-ascii?Q?nLXZyT8K9Jyu3vsQ7K2Xjgj4s5P+Fm6Fm5BrEv31JGp203PJkfieTC+sDPg9?=
 =?us-ascii?Q?17mQ+Z/lE6dJk+Eo8Pxlit5CX3OrQOVWFMWvNHZAbALMipykoOyFKn/HiitM?=
 =?us-ascii?Q?hBxY7Yh+WX2cuDxafqih0rKA8M0G1I9A//vnCKE7DgPFgP0UamKnhE9tAgj8?=
 =?us-ascii?Q?mnP3idSiZhbNF2gHHfWZYCNaBJlxXfnTq3xzwkQ784myw8GQ3n6OjnE2Xe9S?=
 =?us-ascii?Q?DFNwNpFUo/E4/31ISi54i6ctZsKDokxap+5yMSv6JcfnrOnRKe91kS+J9trx?=
 =?us-ascii?Q?DArOren/V+iVmhxOT1LGRDC3qhAI7uBlGyGqvoYXz71S51QlvhXxzww+6+g/?=
 =?us-ascii?Q?sBXOqpHDSXPHc8TiR65VVTcHFnSqXnYB5sDEeXu25Z66c6vLD0Np4FGY6oO6?=
 =?us-ascii?Q?/YPujj9R0v5Qp6DKwSsZr/NqIWBr9WILNpFJTVdrT2bjIw5gZWSwwDahM4aO?=
 =?us-ascii?Q?eS71C4xW6NCF1p9M0VR1rdNM3/Qq6lZTakci9cSw7hh92C720XEUs5tgR+v5?=
 =?us-ascii?Q?MhwYEP95bCz1U1Jp2FiME+anioH7gfDCW0LDLhEB5jB5hSjG2jPJGlWxN7rB?=
 =?us-ascii?Q?V4ix9aFkCPcLsshm6zQVZGGUpAzqiUAAF7HgIYEGIVLiUHuLrEIhSTcxrCqx?=
 =?us-ascii?Q?U36k5LP8I5esNArkulGAwcwE7IloWJ1tVTk3Tk0nqkY0/iT5tI8+RXQ4TNlW?=
 =?us-ascii?Q?0iZAY2I468BPPUzvDzyLfFcEkkZ6rZOP3g2NeZ0bMEmsZHG85/R2SWct9Pev?=
 =?us-ascii?Q?gsi3TXyPj+vTNJNfTAIgcAKjaqdtNSJ80n1fg/DKBj7UKsCiP7rDetlVK2rY?=
 =?us-ascii?Q?+xoBDBzAoltwfnj9Dw1f3ivCEpeGv5JEknwnN3ew/X2f4ULkU2xOM9NyFSgC?=
 =?us-ascii?Q?jgRTAp127LSECER0ZTGJaiyGtL1NMkFNYCZid0U/zH5K5+sdMYXBYv7ccjch?=
 =?us-ascii?Q?eWnLsHUKdhZcrzlwworBpHk47LcY5m3S2OL4QG1dF8keA+EqcaVtoJkAx1rO?=
 =?us-ascii?Q?jz00G26Ti+UkpHaO9h4eACmmRvlDbsr7Nnb7YTmg+q3GbDHPtroOQafGD1+e?=
 =?us-ascii?Q?ykBcya3rQCBULe8C1MqAITrwLx5hnXBa5c65k3psKceH9N3IFV+WYhP10/PB?=
 =?us-ascii?Q?1sGzwIzP4ZVT5L+FGNywnTYIEDV2bzxCXdJ2JoIilefGXleHtajjGxVnS7pc?=
 =?us-ascii?Q?xF8xoRu34kHyNFJ5nQuYVyPOIIDp6znb0EDIsstP7pk3noFN8UP58Q7Mm+2C?=
 =?us-ascii?Q?sfs3WXthow=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb5080df-4679-411e-90c1-08da33458fe1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 11:58:28.7281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cxjx7ZWYQuFslnuZypXyuLi3La2MnhY+OezNnv/ne9wb7otNKGh+Q3Vyce6+f9pdGoifGT3aoVSLaMTLu1saSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0251
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

IPv6 addresses which are used for tunnels are stored in a hash table
with reference counting. When a new GRE tunnel is configured, the driver
is notified and configures it in hardware.

Currently, any change in the tunnel is not applied in the driver. It
means that if the remote address is changed, the driver is not aware of
this change and the first address will be used.

This behavior results in a warning [1] in scenarios such as the
following:

 # ip link add name gre1 type ip6gre local 2000::3 remote 2000::fffe tos inherit ttl inherit
 # ip link set name gre1 type ip6gre local 2000::3 remote 2000::ffff ttl inherit
 # ip link delete gre1

The change of the address is not applied in the driver. Currently, the
driver uses the remote address which is stored in the 'parms' of the
overlay device. When the tunnel is removed, the new IPv6 address is
used, the driver tries to release it, but as it is not aware of the
change, this address is not configured and it warns about releasing non
existing IPv6 address.

Fix it by using the IPv6 address which is cached in the IPIP entry, this
address is the last one that the driver used, so even in cases such the
above, the first address will be released, without any warning.

[1]:

WARNING: CPU: 1 PID: 2197 at drivers/net/ethernet/mellanox/mlxsw/spectrum.c:2920 mlxsw_sp_ipv6_addr_put+0x146/0x220 [mlxsw_spectrum]
...
CPU: 1 PID: 2197 Comm: ip Not tainted 5.17.0-rc8-custom-95062-gc1e5ded51a9a #84
Hardware name: Mellanox Technologies Ltd. MSN4700/VMOD0010, BIOS 5.11 07/12/2021
RIP: 0010:mlxsw_sp_ipv6_addr_put+0x146/0x220 [mlxsw_spectrum]
...
Call Trace:
 <TASK>
 mlxsw_sp2_ipip_rem_addr_unset_gre6+0xf1/0x120 [mlxsw_spectrum]
 mlxsw_sp_netdevice_ipip_ol_event+0xdb/0x640 [mlxsw_spectrum]
 mlxsw_sp_netdevice_event+0xc4/0x850 [mlxsw_spectrum]
 raw_notifier_call_chain+0x3c/0x50
 call_netdevice_notifiers_info+0x2f/0x80
 unregister_netdevice_many+0x311/0x6d0
 rtnl_dellink+0x136/0x360
 rtnetlink_rcv_msg+0x12f/0x380
 netlink_rcv_skb+0x49/0xf0
 netlink_unicast+0x233/0x340
 netlink_sendmsg+0x202/0x440
 ____sys_sendmsg+0x1f3/0x220
 ___sys_sendmsg+0x70/0xb0
 __sys_sendmsg+0x54/0xa0
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: e846efe2737b ("mlxsw: spectrum: Add hash table for IPv6 address mapping")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 01cf5a6a26bd..a2ee695a3f17 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -568,10 +568,8 @@ static int
 mlxsw_sp2_ipip_rem_addr_set_gre6(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_ipip_entry *ipip_entry)
 {
-	struct __ip6_tnl_parm parms6;
-
-	parms6 = mlxsw_sp_ipip_netdev_parms6(ipip_entry->ol_dev);
-	return mlxsw_sp_ipv6_addr_kvdl_index_get(mlxsw_sp, &parms6.raddr,
+	return mlxsw_sp_ipv6_addr_kvdl_index_get(mlxsw_sp,
+						 &ipip_entry->parms.daddr.addr6,
 						 &ipip_entry->dip_kvdl_index);
 }
 
@@ -579,10 +577,7 @@ static void
 mlxsw_sp2_ipip_rem_addr_unset_gre6(struct mlxsw_sp *mlxsw_sp,
 				   const struct mlxsw_sp_ipip_entry *ipip_entry)
 {
-	struct __ip6_tnl_parm parms6;
-
-	parms6 = mlxsw_sp_ipip_netdev_parms6(ipip_entry->ol_dev);
-	mlxsw_sp_ipv6_addr_put(mlxsw_sp, &parms6.raddr);
+	mlxsw_sp_ipv6_addr_put(mlxsw_sp, &ipip_entry->parms.daddr.addr6);
 }
 
 static const struct mlxsw_sp_ipip_ops mlxsw_sp2_ipip_gre6_ops = {
-- 
2.35.1

