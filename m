Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A516A087F
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 13:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbjBWMWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 07:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBWMV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 07:21:59 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2025.outbound.protection.outlook.com [40.92.99.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58C216ADD;
        Thu, 23 Feb 2023 04:21:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZulHtvecCiWPuoUIa4UOenLnzn1YBZ0iHOB3cNYaOMdn9y+jrXBLpdIjhvVKtnpOO0hNSGhQuAMxGL1OiVoJ645uAthWmSA+Sq0RarRn39CfKIERAIb5R+qZ0hQoabrdZ7Tk3kWbIE+S4WmvCyty2xQWfJtBw7mnwPdQlj0FRRvVVGOYpRSjyjrr8m6+5yoFNBvBLXV62WbxUYnlZJA0pQcfkfglsU3ds/pk9nIoOXIpLGXUMKKzzsG9QQBneMH35EM7TOMDiSOFhXWPdvqG8fIR+BjZ0LiTNhsDKzPUkklbGmLmpZgNl8G2RGX/D28QwE3/mGeOAoAO5qulV8SeKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zfqIsdLUPcNrhfCnr5z9SOneA6iMpD1o72aa9LR7pjo=;
 b=W0nvsTprEe/0SO97XdJfyCg2cLRKO2g1JNv7oK8oSC9uoyB6AXFGPvXaxaJtW3wEguxgRYlnxGX55kXgy3fBiz22v/7Vwb7RueF2jk6Sa3ipCyVht7V7iiBwUG+SbwwuwiaE8NO/u1vAx3JXM+NbLk+jneg3G6l0Woi6Hv2VFqBVAMJdYJ2kbKFLhYZUrHEI891KNPAJB8DwZR0kpZZKi2+BCUCP5QOW1zNxEuwOkE2VEyLiVBiPFZAPi8Lz8sT6hW1dzymjJvyx7E8kiZCYKO0vkXANEEogojXqmcyHTf77In7kiggIRFROBlrn69R3oqCVTwe8IuVBUn5v09SBDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfqIsdLUPcNrhfCnr5z9SOneA6iMpD1o72aa9LR7pjo=;
 b=Q/pY0JvvyAOk6AGM6r9/vrRMDhNCuTiv4kXLiLqN8a02MKsQZab7LQlJ7S6kPNcaBsHCOXNsgr1+776SNrgzlnFVrHjkpdjGVu6zJW8v8u6V+6AY18zFNih5Ym1/DmeyHP7eGsib5l7w9DaRyZVhjUYjwSoFMx0nCyJ7n8AxxaMNYrPXb/JW70RPaIelj5EaJ7dq57aKUwIAT5yu0tGGjQpCx0hEK0Ot8ApQ40XOuFP/o3C9F1DQTp6K9QlSE/XKHxJdLi79a1HMWHJnSSoELfVkfyYhJEn7di8jOW4hdzYXF2H3jv/AjHrrOrRXDqVOMAYdQ4A1ftgb5NJ9lle6OQ==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TYCP286MB3487.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:3a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 12:21:51 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6111.018; Thu, 23 Feb 2023
 12:21:51 +0000
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
To:     netdev@vger.kernel.org
Cc:     Eddy Tao <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/1] net: openvswitch: Use on stack sw_flow_key in ovs_packet_cmd_execute
Date:   Thu, 23 Feb 2023 20:21:31 +0800
Message-ID: <OS3P286MB229572718C0B4E7229710062F5AB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [JVVSBEExtTqqZDbQBD2hKR0AekIwGIC8]
X-ClientProxiedBy: SG2PR06CA0198.apcprd06.prod.outlook.com (2603:1096:4:1::30)
 To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230223122133.495666-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|TYCP286MB3487:EE_
X-MS-Office365-Filtering-Correlation-Id: f17065d9-440a-414b-9928-08db15988ab0
X-MS-Exchange-SLBlob-MailProps: C/ir7cSdGlt58y46nZpUh6gN7novD8TGFdRbwVdZjGSq0BZLdQKhz8qMPD6uHsEvcbfZv5Vq0I0mGmYoH4Au1W/L2LHzZ1qvDwKVywcUE32dwEo/z9pxOoedzaL4b28QC7QLTdRuqqffsyqat5fNDDs2x4PghMAjDnNiO20ZpGeGpuOeSiOLZD8dxujdPzsVRAr8W3C1NsGeAzi24e+lTR1lmOsT1FKfd+k0qYq7/TyOjLmnx0Fgk84SGLe9bvmMH/WVcQf4GbKm0Y37RT4pJ0oxnd38ReZfhUswGwqj5mYPA9QTVc/8B8KQ83fBHSo+S+OMUlRxz1m8kWbLRUn5u/6VOFC5fZWfAkD29XJPMKUPIVGiy9MiNAMuWI9ohzJwdEUfUOt7usnaYE61tGNABO68/TeYp7AW+jEx6sHWrI2IAZXWU+ClkYQd3qtVsRYWABUVpUTGmC6JJktjPHsuTyLh3k/EJS+R/XKD7QWmA9GuWZgaabUU8nebjKJFg2y6Kk5tIe14PKS0+6hSazwfoHoS+eldA8ZjAc8NpKtxYQGZndq4qqvimgxeJNkrOwAt9mlFGWikaWrK/HSeg5fhasmODlRLF4freuR3f3+PEKJcyJLJryp2UqC29KXayaYO8vn7FJOmqwgPALY7fPML53j8cb7O9oojCO4Xmc0dNJvK7kT1E9ltuw8Y1f+klguN8tOGkyoqGzRXgdWhaFeMcYYJt8M8rfJ2U/wRtxEjOm0OGqgx+ZZxc8/JBwS87uzO
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C/yqc0//S4t9dX2e5rBSd8IjPsze30O9oWuS/saNV+CLI9vreb7V5P4QJHWfCai4pAr1ucGViT2PVtOvmVW4+Csdp4Pe28EIoSD5hutOYg2PZaFkr8clK/rqYceycpUAGYsXWnTLZrL8qhl5Jy9w9WwmBZ3ftFtFmIiTr0nXZ3T7hYVghWTfC/FvPbyaSc2qOvpE/xlHblQbJs4hDe1ZLHPAYTyKv0TM1HdvOzO/psSNic9gLqfbAFkxXl/6xv8lV0FXzvvQ0mBp5z5IuVr16i/nifxsLQw5lIZzAVCZUqHpnU8ZVHgpqX/oEIRY/Iqn3+Tb8U4VOgth2Nfq2Pxc7lyZqoStBnQKEOT/QYLde5flEjha8HpOwBjUoBukHMSTXaqsNkzgRe/Zw+eEaSY+AZjZnkyuT/I8JIzb2f9DWKzB/dq+FkbxcWni8OOCuXAaajezmGW9BlpagnMIIotUTIFYDJgPdWt8O/6C0OeKUx9r7LdgKoc8sXe+7IOEp0vjfBgJfw6UNKGNRungAoH8+/ssjMq6hFqLYy69ahxKeaFFU2Pw2xFi7Lstl/F2EevTyeYuI4LtOqqNLopbOLYuEnUk7Kx9bqUJ7E0wfhcdFipZm9cZFL+O5eCT6Ve3aXjelR3lNQXNbstPQ6XVfojabA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S/bTqzifzGusXFMfx+LCPscKHYX4ljrH2ODAEb4cAlVEn/k0ly2P8n5pEl1t?=
 =?us-ascii?Q?eavlcKOTk6v7PTV7wMR0b7iwk0VMNwL8fKY87LhOaQ2SwbTz1riViDf3GQfc?=
 =?us-ascii?Q?JcSbC5iV32lE/RvPtAT2r/t4za1VX6Q4ZyXxQ2MAkAuwQoRGu0IARQH/DFJb?=
 =?us-ascii?Q?Dj+6bYPC/ajG8Us8r1wGncWNTz58wHk0v9H3sNhU9simHia29v4Vni5tnPVL?=
 =?us-ascii?Q?958NRF9NyFSjTQJ1K7K8T1HTYVnOcB04c0s3paRL5vYHnDHBMg1OP8Y/0eW4?=
 =?us-ascii?Q?OFOOf2Gn6kE1asIBnm/m9s8TqO8f+ofvVk67LBuMjj6aSdPPo4x0iidxsIcl?=
 =?us-ascii?Q?cVUB4YBusDd0PiwgTo508tVbtILF4TS0pDSr3XfsDTAgH2Mige9qQZxL71ds?=
 =?us-ascii?Q?1WOu1PK+gC4Ep30Oq+HNjuIdmYR2nE/4QJHNk6eNW+jqMZoxQYNct/YqwBs9?=
 =?us-ascii?Q?rUHXzlPM874TJUudkcZR+Os9qI/QaUmJTBEy1HyP26OtwMjSqk5JheBHke04?=
 =?us-ascii?Q?Rg2fiPhvWML6mwRsNCCczw/fY/iwgSa/RPt0uclp0Q07UfrVvwhgtmmJkv9Y?=
 =?us-ascii?Q?6olUvaDTjuiFWbByOOErpbrwnu5zo63pJ8naIlq7F+JmsXu9G5JzIOnlr2Ad?=
 =?us-ascii?Q?GLudd0KYrSXCqC/rsDQL9comDiV+WYiWmXCgVe9HxJlbF9OQiRXak4grPpw8?=
 =?us-ascii?Q?TXJVYsTkxKeUE1ESqzS5BA/aCdIHvnvSiJHVoPb9VU1D4wc5iYGlfSq2yLdD?=
 =?us-ascii?Q?hensdQgHtQTpcntDLWylg31uciDdXBurYsMmyBtqHqiNdUrtubuDh7tVH7TO?=
 =?us-ascii?Q?nbQFQJwrwjjpvom2a3FyTVGFaTwlc/4KfJZtamxbfGv08baWzk7VPnQ8JN81?=
 =?us-ascii?Q?SysZuydX5uCaqKLPdfYn3PT/NuC+CPugcE8qZgip8HFfUrtoXIFqnjjFyrix?=
 =?us-ascii?Q?PwDGLSoqOiNnUXQHN7DW0hqsm4eC/3TxlAomWI9s0Em4cIaP+kg5g+X9GIvm?=
 =?us-ascii?Q?O2H/PU/MPQ/buqzCZS960s9stLBLjFJtzpO8YmDe9JP3GjYdd+8sRS3FLdP9?=
 =?us-ascii?Q?iQIPfhNOtObiSAAVTdYlD8Z6xAz2ny5NVhMjI86zJnjI8Elhp01vs4dJMDHA?=
 =?us-ascii?Q?D+/cNMuIqnK92TAOM/VVv5/6yFOWnL0EQZJ4P3kBmfDhPUlJQadC595a87gJ?=
 =?us-ascii?Q?M2k5lTGxALY0rNodDMkzqME8eZt/iU4GbTPs3PFq3l9nDiFFPfspkQWZXN9T?=
 =?us-ascii?Q?C8g6vp5vVuXTeXHjBJ0le3d+fmOXUy9LHxs5JCamRA=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: f17065d9-440a-414b-9928-08db15988ab0
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 12:21:51.3172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCP286MB3487
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use on stack sw_flow_key in ovs_packet_cmd_execute

Reason: As key function in slow-path, ovs_packet_cmd_execute and
        ovs_flow_cmd_new allocate transient memory for sw_flow
        and frees it at the end of function.
        The procedure is not efficient in 2 aspects
        1. actuall sw_flow_key is what the function need
        2. free/alloc involves kmem_cache operations
        when system under frequent slow path operation

        Existing code in ovs_flow_cmd_new/set/get use stack
        to store sw_flow_mask and sw_flow_key deliberately

Performance benefit:
        ovs_packet_cmd_execute efficiency improved
        Avoid 2 calls to kmem_cache alloc
        Avoid memzero of 200 bytes
        6% less instructions

Testing topology
            +-----+
      nic1--|     |--nic1
      nic2--|     |--nic2
VM1(16cpus) | ovs |   VM2(16 cpus)
      nic3--|4cpus|--nic3
      nic4--|     |--nic4
            +-----+
   2 threads on each vnic with affinity set on client side

netperf -H $peer -p $((port+$i)) -t UDP_RR  -l 60 -- -R 1 -r 8K,8K
netperf -H $peer -p $((port+$i)) -t TCP_RR  -l 60 -- -R 1 -r 120,240
netperf -H $peer -p $((port+$i)) -t TCP_CRR -l 60 -- -R 1 -r 120,240

Before the fix
      Mode Iterations   Variance    Average
    UDP_RR         10      %1.31      46724
    TCP_RR         10      %6.26      77188
   TCP_CRR         10      %0.10      20505
UDP_STREAM         10      %4.55      19907
TCP_STREAM         10      %9.93      28942

After the fix
      Mode Iterations   Variance    Average
    UDP_RR         10      %1.51      49097
    TCP_RR         10      %5.58      78540
   TCP_CRR         10      %0.14      20542
UDP_STREAM         10     %11.17      22532
TCP_STREAM         10     %11.14      28579

Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
---
 V1 -> V2: Further reduce memory usage by using sw_flow_key instead
           of sw_flow, revise description of change and provide data

 net/openvswitch/datapath.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index fcee6012293b..ae3146d51079 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -596,8 +596,7 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr **a = info->attrs;
 	struct sw_flow_actions *acts;
 	struct sk_buff *packet;
-	struct sw_flow *flow;
-	struct sw_flow_actions *sf_acts;
+	struct sw_flow_key key;
 	struct datapath *dp;
 	struct vport *input_vport;
 	u16 mru = 0;
@@ -636,24 +635,20 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* Build an sw_flow for sending this packet. */
-	flow = ovs_flow_alloc();
-	err = PTR_ERR(flow);
-	if (IS_ERR(flow))
-		goto err_kfree_skb;
+	memset(&key, 0, sizeof(key));
 
 	err = ovs_flow_key_extract_userspace(net, a[OVS_PACKET_ATTR_KEY],
-					     packet, &flow->key, log);
+					     packet, &key, log);
 	if (err)
-		goto err_flow_free;
+		goto err_kfree_skb;
 
 	err = ovs_nla_copy_actions(net, a[OVS_PACKET_ATTR_ACTIONS],
-				   &flow->key, &acts, log);
+				   &key, &acts, log);
 	if (err)
-		goto err_flow_free;
+		goto err_kfree_skb;
 
-	rcu_assign_pointer(flow->sf_acts, acts);
-	packet->priority = flow->key.phy.priority;
-	packet->mark = flow->key.phy.skb_mark;
+	packet->priority = key.phy.priority;
+	packet->mark = key.phy.skb_mark;
 
 	rcu_read_lock();
 	dp = get_dp_rcu(net, ovs_header->dp_ifindex);
@@ -661,7 +656,7 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
 	if (!dp)
 		goto err_unlock;
 
-	input_vport = ovs_vport_rcu(dp, flow->key.phy.in_port);
+	input_vport = ovs_vport_rcu(dp, key.phy.in_port);
 	if (!input_vport)
 		input_vport = ovs_vport_rcu(dp, OVSP_LOCAL);
 
@@ -670,20 +665,17 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
 
 	packet->dev = input_vport->dev;
 	OVS_CB(packet)->input_vport = input_vport;
-	sf_acts = rcu_dereference(flow->sf_acts);
 
 	local_bh_disable();
-	err = ovs_execute_actions(dp, packet, sf_acts, &flow->key);
+	err = ovs_execute_actions(dp, packet, acts, &key);
 	local_bh_enable();
 	rcu_read_unlock();
 
-	ovs_flow_free(flow, false);
+	ovs_nla_free_flow_actions(acts);
 	return err;
 
 err_unlock:
 	rcu_read_unlock();
-err_flow_free:
-	ovs_flow_free(flow, false);
 err_kfree_skb:
 	kfree_skb(packet);
 err:
-- 
2.27.0

