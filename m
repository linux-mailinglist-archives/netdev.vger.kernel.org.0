Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345145BF9D7
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 10:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiIUIv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 04:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbiIUIv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 04:51:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC98857DD
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 01:51:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUUO4s15EJjXVD3Q8LtgfkuCBqSum/aEhtLvV7VAribVIERhWWSz1asmYbFVPZ+JPGpo8s6ubTdP6d6aC9ylbFWW+KETHUFjucC9MkjzerYnOl97/S/x1JH83VUN+VTq8uVcUpT7AUnXvBBB5TsOBZWASkcmvViLsU+7GXa8ItoUXKb4BXYQPsddH1Qe0urdewgc703fwkXhndl4oEWw3OIO+OVV6y09qC0Jmu2XS6J0SvvwuZgn49GwWVRbLezxlv9hBBpMLhQHHb9n6ogM+8IC9fGf5hEX8e8MughnB5QMJiBZ+qgnyxsTJ7BvTLmiPEH1BvQaCw/LMQk/kZUspA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMEkJuIPmoNfL+8QHUgnsc84k5e4tQX7vsASYUohqeM=;
 b=LAFGGj3aFHdtiW58ZnQOYGaKuVtlL/9zekEgV2iRkdR02T+4AzydTi6xK4eStjQYI8MKuxsdT6b7fwqxoeqMUs70J+xcKUUe/Ub43fUONLRymQ93QvsGtmvz/iCbloTsAIDlWxsd3A+fJtlnBkNSlQ9NDMEsCCzaq6aDcfEiSYIiUeGjKFukBx9+vtlZotMADRMvd64+Kg31ojbB7906MvZFUonLtSOdXjBl0i8DZ6u2yemMj3zaT3dQjACLxcBSxZTbcrO1YpymPup9GCl0NrZQ3s8U9hmz+ZDum6mEdasXuXL3mGezKPBCFsHadrfumdEis51jz6UGg89Rvk0hwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMEkJuIPmoNfL+8QHUgnsc84k5e4tQX7vsASYUohqeM=;
 b=CvgMMys/8MNOJL5Z4hRdpB1oYnbCNzf+Jkmmw+xRElj/N8tMRdVABTmGKzicrwG011j7duPQYPwr1hud5GmjBmh01B5P/mr80QovsyLIfBxL0ovqgkWhijO5mkNZDZ2TTo+P9MLj+kITYWE2MOOT601I+Mv0P7dbVd9fnrmJ49I7LhMK4ug7tg3xb4PoZVTDq45vjAfJqH7OnE3GGLneJRcuodidCX9spwCa5k5SQsemGnc7x/iPvWUs/IEOp7+9RY3bA6OkmMtRIzanqqS8qtBKg8/zRr2lOHLVl5+O60SbaroyEbSHhNtleMMU4l1ODZzSAOBzLpeykE4SP2K6zA==
Received: from BN0PR02CA0032.namprd02.prod.outlook.com (2603:10b6:408:e5::7)
 by BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 08:51:14 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::47) by BN0PR02CA0032.outlook.office365.com
 (2603:10b6:408:e5::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.15 via Frontend
 Transport; Wed, 21 Sep 2022 08:51:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14 via Frontend Transport; Wed, 21 Sep 2022 08:51:13 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 21 Sep
 2022 01:50:58 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 rnnvmail203.nvidia.com (10.129.68.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 21 Sep 2022 01:50:57 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 21 Sep 2022 01:50:57 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29
 via Frontend Transport; Wed, 21 Sep 2022 01:50:54 -0700
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
Subject: [PATCH net 1/1] net: Fix return value of qdisc ingress handling on success
Date:   Wed, 21 Sep 2022 11:50:48 +0300
Message-ID: <1663750248-20363-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT034:EE_|BY5PR12MB4209:EE_
X-MS-Office365-Filtering-Correlation-Id: 463abace-c811-4acb-4872-08da9bae7092
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TdwJyZ9Tvwqv6EyznKFwd2oRehQ4j5WRrd4EnnVE0QvQ1HArMyhtbt1dPsCEXWMoajb8TcgaOYEXfcZn7xpc01dt0Ew/gidxj5y8VIUnw7yqyHjpt/FOnUcJtOmGuufdNAZ7y/KugZZaorwMJ8ljeb/oGp4q4BMi8ypW1VFz158CKG9Wi6hSeD3WmaRpDI8IfcF6VDXa3VjAJqPUQL35F3CYuJ29scrUSE6UfXpcJ2QDFjBYklpkM0KEW/I94Em7T73WbCmB8My+73SnGgJBUZrigbjopXX+XLoW5imftdrtmche3+aT1jISvw+YZyRPn+Pd/RkSbE6J7z6NhA1OWg4R6gbQMRlvp6Rh26GcZzlvZiQjahFgagoNeeclr7REahKCCRYVu5a2OmiLmk8Ymj82ekQIhMukGf8au7R/fWL4z6yqntlE/ZzD23NEV4yDqlBApLAUb1dAkcZb1PoRzkzATiDcXbaJMGAKGLAAd5pd0Jj17X0So+MyUQID+n3zjG1ejyb+TP6KPtRcN5wk5AuWyBB11bxkAOz8oZyQCIVhw5Q9vrdovRGvNikYPKjYdlHmTBBt6T1bGrWrzDB2tFkMMs5FqPt/IN/k2TD/dCicQG6X7gNH+6f5S+K6f2/g+Ux4EpBRgv3J3xzwLYmaBnYU1I2mZTqvlT5gtijLLgeuspHbnmpzDVGXD62PuMlUNXeIBbWE+BQxUB8SnIpnNqUE9oChcVlTsNcg5SwrUEARKLdQe66VeFbVtt6W2n7z/RJkR59vgeBc19UdmVjW9Q==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199015)(46966006)(36840700001)(40470700004)(83380400001)(36756003)(2906002)(8676002)(54906003)(110136005)(5660300002)(316002)(40480700001)(70206006)(70586007)(4326008)(86362001)(478600001)(6636002)(6666004)(41300700001)(82310400005)(8936002)(186003)(2616005)(426003)(336012)(26005)(47076005)(356005)(40460700003)(36860700001)(7636003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 08:51:13.9409
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 463abace-c811-4acb-4872-08da9bae7092
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4209
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

Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 net/core/dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 56c8b0921c9f..c58ab657b164 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5141,6 +5141,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	case TC_ACT_QUEUED:
 	case TC_ACT_TRAP:
 		consume_skb(skb);
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	case TC_ACT_REDIRECT:
 		/* skb_mac_header check was done by cls/act_bpf, so
@@ -5153,8 +5154,10 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
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

