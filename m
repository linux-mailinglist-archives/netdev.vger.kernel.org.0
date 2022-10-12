Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B017A5FC1F0
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 10:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiJLIYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 04:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiJLIYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 04:24:45 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2041.outbound.protection.outlook.com [40.107.212.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB026614C
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 01:24:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gz/zUoaW40vO/mV9GOd8SBQjhUsR2suiGRk42/35qV9S196uwPn4a4dhyQNcr0ksK5mdtnwrXxTCIFQsbwrbl0Q79iQcO/JfFFVMCjNC/tpZh8feLpEhpD08uGUTuVdOgoKi3CdCOQyN66/Im2GTKmZ5LMfeHbHbTIBmy3RuBNwgvw0RkYFp5p1L8oEx0+3OnTwPZd8/1Kxmuk91jqN1f4QD2w/JhOjBj8PPYbesfwjxqN3IoSEjvbmG2Rn+gQVmvvk++kT7OQWFarTPtpaZ4+SMDr8Sv0u5gQv+JY4rWEby3FvuAwf2bAh3qCHUJG8rEgOM7L3i7MX/tRc/yHckBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+E48PMH0VOlTPzfJ0inDbNZyHLetCbC/YRvwbBonuA=;
 b=fhmPDHERlk2m+HPr3jVqoba9pHdnFMN1YGdMGPsIHP6oohfjye97kucQHh9gmSP35qsGzBR4x5x2FJqkFt5XHmhfcNtpzi+1FyHIozkWyidsXjopTHUOHq48AlXL7ZkTRleKHUB4bk4lOxeMNemsDBOlGdgnAaO+YDWOHYtdawq6dxElsAyLT4CqQgNvq0sq+qqJe5HcMJ+w9IkFeYSbqXHtkkUG6npXtN0ntSWsqjJ0VTpvjBqGYR84GywlSLy8P5/sxcGTn6aqJ4yP+SMEVvI9hQLXLZDQhHujlOKwvFUTj8UOH9okSRh5tunRxyqnc2CedxQzKu0MGCWQ3rlW3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+E48PMH0VOlTPzfJ0inDbNZyHLetCbC/YRvwbBonuA=;
 b=HYPQDKkbiafof/qvRN6o7wGvehw3dGtbG3pu0BSFlCeda6GSmQdCyIGgAL7JBz3pkfszUFNACOAcJHyuFpWOB3uLi/iBDQNzr12aIyV5n+Xh2hqPPpZiXOLokM/cMD/teRO+3j9pWZdanW2YiKKZDym9IC+LylXplum7woT/LQtK7XQZYqzMsbtA+l1AYNbwkcO4OEqkMF62qeOV2BvTWm9RlwRlDL6m8M4qt6+yYUHQgKYMLUC63hhGZtTTQ04H4wUKnqgAa4GEUY0feQApDo27CddMaS9xyyn2gOC686zkanJh2w9zR8+T4IV52pwPMT5FcvgcoG+0DRPMCi0tZg==
Received: from BN9PR03CA0776.namprd03.prod.outlook.com (2603:10b6:408:13a::31)
 by DM6PR12MB4863.namprd12.prod.outlook.com (2603:10b6:5:1b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Wed, 12 Oct
 2022 08:24:39 +0000
Received: from BL02EPF0000C408.namprd05.prod.outlook.com
 (2603:10b6:408:13a:cafe::54) by BN9PR03CA0776.outlook.office365.com
 (2603:10b6:408:13a::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.22 via Frontend
 Transport; Wed, 12 Oct 2022 08:24:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0000C408.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Wed, 12 Oct 2022 08:24:39 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 12 Oct
 2022 01:24:24 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 12 Oct
 2022 01:24:23 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Wed, 12 Oct 2022 01:24:20 -0700
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
Date:   Wed, 12 Oct 2022 11:24:12 +0300
Message-ID: <1665563053-29263-2-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1665563053-29263-1-git-send-email-paulb@nvidia.com>
References: <1665563053-29263-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000C408:EE_|DM6PR12MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: 59ce89ee-0345-46b2-2649-08daac2b34b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xKzN3E4AO1U7Wri2ZmK5NVTw8jidgo4q0xoZZHk9RhExQWLuaSXyCIZR95gAn4zL2L9EcFjYsi2VoxY0Hu0hbfZZ+yFGHiQRYJf1U7FSLrquRTxnTU/7Ko4XdVsCJm29n63NmWd5YDDVOgHizbLI4830kR0FkQRBAvk0UUfXd/1+fWRXYfGdUu+pnQ/sxI8uIFJ+s/kqUUEZe9/5UUBfOWfzd+EMMbrt9RcndQFBcJssa4WB7wgs1zjVVOeMzcMeCv4dlTNr/eY1wrv3e1bz3g5S1oPASKpx7JHespm15SMqfgqXtwuXdnGgMhM2S9bO/u+nhyFqeOoIiFR6wUBhpl56/aOIDJUAFmB6H7x5c55mcP8JMZh940Acm/J27RAFDCtcLlB6LceoTd9URchrXw8AJ03ATdzvSCGWoqZZQ/C/0tO3706CGIXt9f6pZslT+ZcFRqOzb/qMHt1jtb3H8nAe0pWQWlmfnsdSNF7PgxTkFTuR9SpeIdeifydd7h549OYHaE43Jmb5a/7AFvvYNWaQyshCn6/Wq9ClJxCkesDUfOqp7B1oD4N9KzlXJUNYLTMS4i0o8y9ySRNGo401KZZlbMNDtmuRbx39EcbwDDt3MOCtb0cuGjx4KsiEiWbQAKp2HPGgpNVAMVoUNxUODOXuLnsiiyngsfz+cwhsX4+D5RjxAzLUqF1NPJfUenfovresd2Zz8aucqwbJ5ZJ1dieFnTYeWP3H9EMhMrJwulkUqFbyX2lMlDYWMCyjTEmqqldFIbpaU6Si65yCeedFnw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(47076005)(426003)(54906003)(6636002)(83380400001)(356005)(36860700001)(26005)(478600001)(5660300002)(8676002)(4326008)(40480700001)(82310400005)(70206006)(336012)(70586007)(6666004)(86362001)(8936002)(36756003)(41300700001)(316002)(110136005)(2906002)(186003)(7636003)(2616005)(40460700003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 08:24:39.2082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59ce89ee-0345-46b2-2649-08daac2b34b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000C408.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4863
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 56c8b0921c9f..2c14f48d2457 100644
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

