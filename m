Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED386A08AE
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 13:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbjBWMfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 07:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbjBWMfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 07:35:16 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2026.outbound.protection.outlook.com [40.92.98.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7822A72E76;
        Thu, 23 Feb 2023 04:35:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5ezR2HKPhizQQrk0onXrrBLN7fQk1jM4eM4uAx79PugxYUYY9l0Qduzp57gOSVLn2rjNYwmLZi0KRXDHC2ptgjl/m1HKi+xUBdvKH4owmWtUXCme/s7ZRgNigVKEDY2wq/BG0ZVXiSvNLRGDJyt7CQB9Vfrt5DiQj1Oi9Nw4senxaD6YuCTvhIH3UAqlB4lSz1SFaZHqrEJewZaXWcCOZXHWmf+TA1qYvmmIkynz+lgyPMbNOd/zPi9O6PGnZZbBAbrTr5t7ahx1AjEYtrxEDGDxakPrnJqVogIc+Yd+FHYt44QLuKYaccFYmmNBE/QJI2wocpMbuDT+No4t9rhqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4yGWu9ZKcZtFln3OGUcGlPH6eAvbjm+jlDFoPLb7zY=;
 b=mpQjd8WjAYm2hk0DCPPTpPhA+0E44joS06diPLUaj3GZs/EGxhaCN/frwlnaIQjnp5kxtIv3ANO6S9ii10Lj7oYGqpScYlpR16jS0CSCSPw5ieOMmxo3bUSzT41kXnvuwM3qpBOoj7PB2WNVXAwfC9C96rJDVsYlulltZvH0MNnlqxSwXugZqgsVHuNNiAE2BsTWIYvRrRbTVv1KMDF6KYxQcGLX6TQHg7HZQZMWWfK7URzDsWsYcTPyItM3LggFLeT0WZEjkPEKjkGGBKaF9kVthnlzCP7jIGGiBcD0bjjCFqIdchq55R8Gi0xQ1Q8Mt/WhR2ELU5+e3cdIYnU4Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4yGWu9ZKcZtFln3OGUcGlPH6eAvbjm+jlDFoPLb7zY=;
 b=BiRqeIfpeG0IFx4lfkJAVwPP/8i91BP0GFTSYD2jetT9YL4XJezJmvsphz+mEfGvzu9Vi2s1fLKIPFyBPKkXdk5NEDM+FExKuvJS2T2Pk9phuwA8gJN+P85xA/+TbEcJt87qIa0BNtq44ncs38m1Ue5/IFAKI7HAS43anCkA4nUR7+PKY2qLKhJLZyeN3ArqldkawdKssu81wK4rvCSU+rBE0B8dP1EoLmBRAHpsoicdlYXCi8yJRGzgXqVe0bDo5+7GwxP6pH9637oiM0Suo3I2Pqyg81wKUzuqiIBgET1fyKBUKYs+ZEhVU337I2j7MBkaLOEYfeyogsBvyylglA==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by OSZP286MB2286.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:180::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 12:34:57 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6111.018; Thu, 23 Feb 2023
 12:34:57 +0000
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
To:     netdev@vger.kernel.org
Cc:     Eddy Tao <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/1] net: openvswitch: ovs_packet_cmd_execute put sw_flow mainbody in stack
Date:   Thu, 23 Feb 2023 20:34:28 +0800
Message-ID: <OS3P286MB229582C80EDCAE3AE1C33D14F5AB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [EERFABwK/ImbCmxENQbvPEpfAkuBthnC]
X-ClientProxiedBy: SG2PR03CA0128.apcprd03.prod.outlook.com
 (2603:1096:4:91::32) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230223123429.501593-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|OSZP286MB2286:EE_
X-MS-Office365-Filtering-Correlation-Id: 0730c07b-3f5b-4d12-8d3a-08db159a5f75
X-MS-Exchange-SLBlob-MailProps: C/ir7cSdGlt58y46nZpUh6gN7novD8TGgUR+LiBzRnHvBMSwrP8YZlh2ozwgLN9JdZT/IDPgbx69ToJuXsjCZS/3k2JjssUJxr2zQpaD0LASRIGJFqVK9yT4dUsD0mbtvQxIhD3z0l93PYAunB4V2b91pFIUn9DGMmkt3mUJut1yDVj82/2C0O7vP2S5nObPzbfQb/dajKZFGddttMZDdd+gbUheGAQl/zZiRvqekeAKVAx2ppAoj7oLbDMArNN/JYIqsWYQ+XFk9Nacttx9oCEZqN2kfKFOQWhpHCctAotK+46U8MErd4Qa55LyzHbbG58D078T/UID6sz0mEnDLHkYgEKnLnAeItua7XzwPOUR8fhKZ+GyBvqFUD7TjWTeVshvE+HBp9Ot2EWvNsvPq83Hetw8RWTgCuEUOPNZWAobYDsATdEzL6X2RR3Kha6U7G9igfI0gNdgnWKI7bGUfuNLRQaI+kj0nBXoOjFCaVjH9HbTBhz2FlJYe1eulcf2Qr/BGimPgAVl5DOAcXKqYoFqjjwIFTxJOAs7ycCAhaGOSzEuc8wLzYTMkwpLsJrIgdKPtM/EwqL1yx2o/WF5cRgb4kx0psDSQP+HkxO3/Ph1J+cPTM4m2A0amYB4kxG9Gj5dFfcWKS9tFStWk1HCwH/Gk3OovKQds6UYSjGtJkTzx7YQgD8i8J42GRlYLYpalbGwZhP8rxclJzZ3T7tlVpARNZBhdZqymdmNUutFqlRDfzbp9Enos1G44Pe8demf
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8OFUHteHLJsZLPpgR7vNjjZR/M0NR9i0yoGJAjOQIf6q9kZWggMe1m2DbpbIGJf5yjRZ6GhjdD8RyosJghZVhhQXL32TAVrEpZHm8GKxq6m43CUeKJOHY8nJ1Wov+NOBxHSqrbq2JFozjoy3nURd0pD1veDtCjmH/PsQPpoK+GzIT7wCbOmDP6MZgxtZTWtdnaxEbvSfxr+5Phogye3qNpYnq9SvYccB/I7ti3nWQ/+KALymdv/Hn6+yUDTi8jl4G22FOaEFA3RBhKcrkL9/fcmi0Lig4MKfT4tw3tuRFr6xppahzorZCfnlQbgnfYB/2p6jxC+pHKCuBMZCfcQZstaP51c0iVtaCa6Kacp0KV5UhTStkLINnhMdIX8cHuv0OlNVrG8EyzKiuyWXig8VucP+OeYmqhUUPPlwxKjn5ViERoASS4+hIAzJGFlg+CRw61tzZnvoPS4qdsIGlAMgbeu73oiVj/QpEvxlQ4nTjg3hOjP0cJX/Xxf2/9zRiY/AnqptT6ShMZNqkr4gQ5OdGF6u9SdNGKb2xTi/w5r5l66zBSNAm6yEwIQ9gb+dWfqW7LCmE8oI6ExdpyhFa5Ru00sinc0MAAlXMljdNjsjY7eGe7jhol/ARMDxE2/lk1wHR7cLKQlpLg/ZWvFDNX2Lsw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DJ3cUdSfDeZT34A9V8dTqPl9pK6k5Lj+CGSbdR9P/gIlxQknjkpjuOcVC1G4?=
 =?us-ascii?Q?NNwcgNOXB+USXdF8F2ORQzMUG1axruITzCuRMnZw45wbqFR+f5HGr1Y/nxrz?=
 =?us-ascii?Q?oUCtCX8VF7yTmc0ZyYR649dX9LXjgKFTjD0LclZJWhyk4nn32Ie5V1r9MUTh?=
 =?us-ascii?Q?uHMk40tJwQu/0Q3UOIg/bMIREH5xbmcTI/vX+qcxP2nhzPh+bLRkGmcIzx3r?=
 =?us-ascii?Q?MJqMId0vE2DIBS9Dd3LG/gCNFharZLYcA8mMLi0gfWRVxr2xx/zvRZr29UDK?=
 =?us-ascii?Q?HoT/TqeFBnYbiWCsBcrGiUtN+f/OTCkU32749NYkIuuOMQfmQVtLxYOW0za4?=
 =?us-ascii?Q?I6ugQ0ROpWccrQJDlU/OVvVVkbPpAsEOcj7uo3yFzAncIOuGLZhMrX0PPKDR?=
 =?us-ascii?Q?WoskUaUYjSj8V5JUkOpuJGIHpkabMPKTXn20TtV+68YcmOLeCsA5+ENi2vBB?=
 =?us-ascii?Q?m7/y37D1SSJ5CXUecm/Vk77sH+b8ZiJbTrFXMCyA96bin6Yr0qeB/Ou4wuMt?=
 =?us-ascii?Q?sdEUj/i97j0GXoKNiVWmJd3r9eA0BLbBDBKpxl7DNPJPOinJKA44GK+ELttU?=
 =?us-ascii?Q?8XdFdPws20uUgjvfzo3hkVa5p3gewXViRsnhwtpUopR9jYVa21XrY2DfsiGD?=
 =?us-ascii?Q?DOGydYB4tR/5RTNSQGZl1mwymNWPy2gse+SWuPnn+fLN2bRYzJXPvPHcv+T6?=
 =?us-ascii?Q?S5l3Fz3ZRDjFS1BCq3tmz16Sby4PxMnRE9T1ioSr7dSNSlR/rUbr77oPPD/C?=
 =?us-ascii?Q?Ewkk6kq7LOMlnSmyGe24f3sJ+a1hTHzZ9uWD/BUlKJ4h3z9dOTi0/cFI08F6?=
 =?us-ascii?Q?c6zG/VOAQx90yzNTUulpSIycv+3abC58n2NWIqRb3Lu+yz7iLUtG4Zwn3F+t?=
 =?us-ascii?Q?kjbjggvYG5D607Chb4ruYQnBDU9+DEwHB199GHNM3a/VuVuUAAagIQI1lCxm?=
 =?us-ascii?Q?4KTrewkbWs8vCaZWF6ZIUwURyZurFGvbRdmLLnPvx+BJI8Q4B6i0a5LjcaeZ?=
 =?us-ascii?Q?kOIJ6XnUSeiLoShckSvxIsc2sjMvzgG3iyadutBdysAPkWhK2CQLjMKLQACz?=
 =?us-ascii?Q?0LajPYVEwlwidlrqYtTa+4BH2QpHiEucNT6CaiM0+BEm8gAj1CN8+rB7bQ29?=
 =?us-ascii?Q?ouOS0JA0NMolQHgoOffjuObZC73DfFjdp7Liqbjd3QObYaGWCkoEIAa/TECZ?=
 =?us-ascii?Q?qyyv9fn3Tt6aQZeO+hUncWN9vXRuG9ENS+MvGNiYdOoppZp+UHXQFRZhyDZ8?=
 =?us-ascii?Q?x7IlUy/zQ6ofoxqd5mG5QfHEmT7U/Ie7zz4VwJ7Oxw=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 0730c07b-3f5b-4d12-8d3a-08db159a5f75
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 12:34:57.7024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZP286MB2286
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use on stack sw_flow_key in ovs_packet_cmd_execute

Reason: As key function in slow-path, ovs_packet_cmd_execute
        allocate transient memory for sw_flow
        and frees it at the end of function.
        The procedure is not efficient in 2 aspects
        1. actuall sw_flow_key is what the function need
        2. free/alloc involves kmem_cache operations
           when system under frequent slow path operation

        Existing code in ovs_flow_cmd_new/set/get use stack
        to store sw_flow_mask and sw_flow_key deliberately

Performance benefit:
        ovs_packet_cmd_execute is faster
        6% less instructions
        Avoid 2 calls to kmem_cache alloc
        Avoid memzero of 200 bytes

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
 net/openvswitch/datapath.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index fcee6012293b..2c2283e85595 100644
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

