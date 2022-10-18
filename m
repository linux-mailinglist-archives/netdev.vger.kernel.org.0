Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5513B6025DC
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 09:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiJRHfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 03:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiJRHfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 03:35:06 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D612ED43
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 00:35:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BeIJ+QZzHHUACkhL6GNzRuzRmYG51VV+J0jxebBZO7DpazNLQcw3Ne3B1LvimS3/l9K3AgnSQ2YCybLqYZT8tDA6emBiUimuWFAr/xOupq5G77LfQi5mUZSM/5ok1jmTQaL11qN2pwj3Atv9XMdeFgaE/dfqPwJ9RRlNFEUAw1rjRCoH+hM34N498+nBIBQpp5aKnwKhcqErczBlFMixYHuv9+6Cff6yvIZw0KGD3lsweKtR4aAR057eup7+hWleMrWdmThoyhyEEmoXcwV2pBryaBRBhl1VXjc//q62jkn92TTwHK0TilANVXgCBddYckFIihwj/PCOGLvKt+0iBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMk6veVGM+wwLyvmRpX4GkQv5QQ4IANVfdRk/W5L41g=;
 b=CtKOBhjcNXU7j1FPbNJ/qwxqATj2Sf5+xAVsPjj4k2llTTeZnSUxP4QnFCFgq5o1P9SOMrDPiOZ93u7QQQ+rMACA5OjSmqD09uPaeCZkbsHwfi8IEDbmYz7Z5Q8SfCvpZc5oNOD4tjXoSWDysv/LVxxp+O+su853w63puwPTmS5fJGeBjy3Esm/M1MWx/3bsHfmxwvH+fuke6XcrLuHvshyTMP9KfxJoc9lXUhMHD2VL/QLdgO3sFDVrhxop1exjGArSEUmmDLmD5OLm8o3UyBspfxV2xdzs8R79Db5QO3A6ehPpTBwy56gbh7G5AhOsBhlnHSuBytvdvA7eetZJgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMk6veVGM+wwLyvmRpX4GkQv5QQ4IANVfdRk/W5L41g=;
 b=BwJsbFC9YDjHkvwMz2/UHCG3Ie6Bj//IQ3exALDfsRwg3GB1Yq9WwbKhlTNnAjbtAAy9F3xAE7IFSGGKcEErrB/O1X/xvTgmw0MjD9iE3qyo/3eT+afJNj8hDQ+PtDAAH7Jr6Op/pGvn5XVTzsr7woc2myxmfnnVK/6jKXf33F8Wq6lJaxk17Q+FoN3SUklUys1P8pPJkjVGFF3SfoYAz5iN9ywH+sviJdcUY+i9UOBk/no9+Ib2xXcMDQawpOyrRiCLFqlkKQ2RmE1ZgqSmVwAiSzoU8Dr2Sb3BPKSxixe5vugna46jPE33hQRY/KyhuUnJs8r7Way89ZmRlpemhg==
Received: from BN9PR03CA0390.namprd03.prod.outlook.com (2603:10b6:408:f7::35)
 by DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Tue, 18 Oct
 2022 07:35:02 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::d7) by BN9PR03CA0390.outlook.office365.com
 (2603:10b6:408:f7::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.31 via Frontend
 Transport; Tue, 18 Oct 2022 07:35:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.20 via Frontend Transport; Tue, 18 Oct 2022 07:35:02 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 18 Oct
 2022 00:34:48 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 18 Oct 2022 00:34:48 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29
 via Frontend Transport; Tue, 18 Oct 2022 00:34:45 -0700
From:   Paul Blakey <paulb@nvidia.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net v4 1/2] net: Fix return value of qdisc ingress handling on success
Date:   Tue, 18 Oct 2022 10:34:38 +0300
Message-ID: <1666078479-11437-2-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1666078479-11437-1-git-send-email-paulb@nvidia.com>
References: <1666078479-11437-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT007:EE_|DM6PR12MB4220:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d9fca6c-7d50-4a78-b032-08dab0db44ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hwviRcFi+hCbEz9NWn5Fp307Ki0bbP6v/8ueu4aWl/l9KzClYySALULutvLLHtiIWalM6efOciWlHTCs4IJhPxEW4NC8YbEiCLivDdCZthRd8CoaPSkFw1PGRYxs9wlLobu66UhEOaVxp4tpGd+FQAWTbDeHaBRp4MZ/LuycolKeFG+yW+hTRA5EwbnTL94NX8L87auYaW1xUJwyhB5vcsg+1DtApSLXbjbFW+UtSpa0FseoQ0F7JcPOgMslYVjb+LOTfbptkYS6GGELMpVd2EPy7dO51CLMGRArVq2pSQdQbBKvu7POzhvYm+DPUEnkkSOH2sDffbkl7NE7kL6+YaqB7Zmowxg5lu4H3VH1ERcovytoZKXvq5IsSJUiMC8fmi+L83qg8fzwCtMpWkW9Ocs5xNd/UE5Sep/+6QV5upW8SY/X1tGgfTKPWGVZI4Zt9g8VJ5Rh5OH8+kinTXvpVxURZg6uPhQF1RpNOViF57JEjsjeVMxHhtG8Vf2sPOG6W9xFKnTekpy1DANXj6hrJg7kowHBESGpnnMB1/eDo5DiAlLOskWGqWMiuhCCyCl7D0nKhgSFzAUzze7N/J3BsQGVhILW2IyxEBi9HdOfnmBBarnrK8QFtDqDJupgIHpvX8WvNDUjghya5GqZkvfwha4r13x6ySuGqYwvcXk0kMCd89iIpTAdfy0+6NZ/i/OU/6e+PWX03MMLJGlp5lWMk9CSsTxl0JXZqTUtLa2Fa9jkJqo8TKkH6+3t6wiPdA3+Voo6hSnaPzRHqJ1V5B9CgQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199015)(36840700001)(46966006)(40470700004)(478600001)(7636003)(356005)(82740400003)(82310400005)(2616005)(316002)(186003)(6636002)(4326008)(110136005)(6666004)(70206006)(8676002)(70586007)(36860700001)(54906003)(36756003)(26005)(41300700001)(8936002)(86362001)(40480700001)(5660300002)(40460700003)(426003)(47076005)(336012)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 07:35:02.0809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9fca6c-7d50-4a78-b032-08dab0db44ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4220
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently qdisc ingress handling (sch_handle_ingress()) doesn't
set a return value and it is left to the old return value of
the caller (__netif_receive_skb_core()) which is RX drop, so if
the packet is consumed, caller will stop and return this value
as if the packet was dropped.

This causes a problem in the kernel tcp stack when having a
egress tc rule forwarding to a ingress tc rule.
The tcp stack sending packets on the device having the egress rule
will see the packets as not successfully transmitted (although they
actually were), will not advance it's internal state of sent data,
and packets returning on such tcp stream will be dropped by the tcp
stack with reason ack-of-unsent-data. See reproduction in [0] below.

Fix that by setting the return value to RX success if
the packet was handled successfully.

[0] Reproduction steps:
 $ ip link add veth1 type veth peer name peer1
 $ ip link add veth2 type veth peer name peer2
 $ ifconfig peer1 5.5.5.6/24 up
 $ ip netns add ns0
 $ ip link set dev peer2 netns ns0
 $ ip netns exec ns0 ifconfig peer2 5.5.5.5/24 up
 $ ifconfig veth2 0 up
 $ ifconfig veth1 0 up

 #ingress forwarding veth1 <-> veth2
 $ tc qdisc add dev veth2 ingress
 $ tc qdisc add dev veth1 ingress
 $ tc filter add dev veth2 ingress prio 1 proto all flower \
   action mirred egress redirect dev veth1
 $ tc filter add dev veth1 ingress prio 1 proto all flower \
   action mirred egress redirect dev veth2

 #steal packet from peer1 egress to veth2 ingress, bypassing the veth pipe
 $ tc qdisc add dev peer1 clsact
 $ tc filter add dev peer1 egress prio 20 proto ip flower \
   action mirred ingress redirect dev veth1

 #run iperf and see connection not running
 $ iperf3 -s&
 $ ip netns exec ns0 iperf3 -c 5.5.5.6 -i 1

 #delete egress rule, and run again, now should work
 $ tc filter del dev peer1 egress
 $ ip netns exec ns0 iperf3 -c 5.5.5.6 -i 1

Fixes: f697c3e8b35c ("[NET]: Avoid unnecessary cloning for ingress filtering")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 net/core/dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index fa53830d0683..3be256051e99 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5136,11 +5136,13 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
 		kfree_skb_reason(skb, SKB_DROP_REASON_TC_INGRESS);
+		*ret = NET_RX_DROP;
 		return NULL;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
 	case TC_ACT_TRAP:
 		consume_skb(skb);
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	case TC_ACT_REDIRECT:
 		/* skb_mac_header check was done by cls/act_bpf, so
@@ -5153,8 +5155,10 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 			*another = true;
 			break;
 		}
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	case TC_ACT_CONSUMED:
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	default:
 		break;
-- 
2.30.1

