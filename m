Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449A56B7B44
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjCMO5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjCMO5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:57:42 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842CC19127
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:57:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJk95bmlLW1qf9cqzkjSHNfw1p37JOXIDRSTwPRWdorVMSsxmWVUoTTyn1SRHsB/F6V33NWlMaoIV+B4BcHGC9pOYvP1Iq8U4qJqE1TFM9aTx5yLTCUkv26tEWtm7k7gJXRdYCdKvRbv0EV52MHixV9Y24zzyC1kB6XTguLDCWmrZmrqIfa16p/1WYjpvDA2Il0kD4yMETarlyc94493Yz8yk+qGTw5ZWaobPVhR9gp0Ay5xJ6eiTegsl/v1Ch4iNhAf+Oov6kJjIC4N13krQlHBAcDCcu3euIaXWnD+2zEM9S3JWvpqEDM8lDj25+dAOBjOXkgJZ3zEFrLe4h0PFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wZRvEiTCl/aBueUPQj+epY02aK1I0070LJ8c5Z/BAg=;
 b=f0dKGrZcW/+nLPa2o1PFzdbZ7GAn1wCxjtZ/vtQB5cwwUgcBVAAWWUhtNs+H78PBUw7EijzFG8WQNZZi3O0PYuAWizYMoUtbfc+OTnhwDxGeIBt0qSMIDbYbrfnb4/eppxc5YDz2Zk3IdzowHYsueeibf7us8pS0+EIGUTlB6YXkmnBgK/vpnzN4IoZNXlMAT95kbVai6foQlO0Cq24iDw9wvt+1YajXhOu1L0AgCgkQFHLTCEhhXzH0SoqmsVJlRMIqClYulb1l95Xn1iTpxAAyMwISgqZdrem0ura62rkG8cxDrqj+GhSR03E4ljnU13MUSLV4ZiKULf1qyOiGNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wZRvEiTCl/aBueUPQj+epY02aK1I0070LJ8c5Z/BAg=;
 b=RNflcAYBGhnd5hyE71gIFwbggQsUWggZCzlUfAXkQiacCtE4ZqhahtFqJ3CTvJfDQwZeClclM49SHSAPeM87qTNi5gXPxVO3ghXbcAa5+rHkd0aH6t3332x423AVwGdCOOOMdyAJxJG6A8yvDa1VU2Itu5WzcwQ7xHfJJVMSbYLYUH+GJCVqdHM3mHp9PJkFgdhz0VUmXTBrcsPCCwmTLpdPQX+Oct2z37FDgHgfDKGYEoXeSH7ChJZ0ZuwW4bGy7j9QCRscJSYQmUHfP4KdCyBMNy+U9ut0ZcW1PJdDpuVIRB7dVsjTJsIQGvUPIXlh8zSnFFLedmpf1R3ojrmMGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB7493.namprd12.prod.outlook.com (2603:10b6:208:41b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:55:49 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%6]) with mapi id 15.20.6178.022; Mon, 13 Mar 2023
 14:55:48 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/11] vxlan: Expose vxlan_xmit_one()
Date:   Mon, 13 Mar 2023 16:53:44 +0200
Message-Id: <20230313145349.3557231-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230313145349.3557231-1-idosch@nvidia.com>
References: <20230313145349.3557231-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0016.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::28) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: a399e6bd-0e50-45fe-1c0d-08db23d3084c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yGsNP9VspaodSE3mMc7Hu1vjXZYa+PUnRCuuxX2PgvOX+INM7JTWgEinXXk5/unA4aCJH+M0AkgY6GzqDOK4qcmPZ1LPi6AEisDQ0AAiCV90/oicPYwPJYJD2RurGO7DQo7YaSMd8t/9ErwTG+mgp3GMYSIQQM6PXhVH6vJJn6aK2QdXLNT4Fi3rmbc9z/bTQVy3KEosE7swQi6qEN3HjC9l1lLqanYbuNsLp5ZO+5gNvf4Sas+unf+yUZVdpbYC3TDKFF7G7N/hzWlIIweyNhPQqt79W0poLYnzFSeexHGX/hPW6lPO66E/K/+etfTJobxql7Pc8clkbLHVHSwZEUxbydxYz3MjGt/5W1bxL4c7314O+/PaA+zMEUEAkkwPMyZUp12J3Q+sb9t3Bg2wMbA2pS/EBwJ8rovnSUwoYd7HPUYNcyKmtARJtDfhwhrBQJEBrGk6XTqJK8sbA/zlk/m4gz+z0ko7iSFbZvZTB+MMlfU/en/RsTapOiglPeP3C+nUAvYkFgihpN34T0HwpMRMbqGSAFkgf1nUmpzfhHFyUtJC783o99zoQt9U5Q9EUmY6Aub2rBOwo6BFQE9Gh+H7OXy5PdGjXHxy8GMzwze+USByjrvJEY7qmdWcnBjv1mqry1Nh/bJjpS+xlC39og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199018)(2906002)(41300700001)(83380400001)(36756003)(5660300002)(66946007)(8676002)(8936002)(66556008)(4326008)(66476007)(38100700002)(316002)(86362001)(478600001)(186003)(2616005)(26005)(6506007)(6666004)(107886003)(6512007)(1076003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3ELi5njnFCJjk4iaDfIjeLGnJEpk56RVF95Jb4Qxql7/dboooxKkieh+q7mm?=
 =?us-ascii?Q?lh2Tprf8pEGl4pmy4wjs056KsNKCYKNOX4m5cWFmHmTIf+nn428aCK0PN+Bd?=
 =?us-ascii?Q?Ya43u/l/13tC3fAR9EwRDlVXU2VFovluAf/G3j17oz0JwAuqXit28PDkY+E5?=
 =?us-ascii?Q?BRIVwc76hEw0l9n0Lc+c4Bhv46kJ+MVX5QaBgNXqO2IUPIgLxjQm9WPNHSVn?=
 =?us-ascii?Q?uLyOmjb8hTPd2AP3Tn00BTZrAzeyjUFr8O56U00YwL/0Pod6e4BBYhXJBFUd?=
 =?us-ascii?Q?OcnkzK8ElkoIV57Iql+6Ml41FB3PBSWkJVjn+z1rcCb2g0GB1urAsLommPGu?=
 =?us-ascii?Q?B4zscrZEkPEkXytJ20KlcnbdThlCUj7qq0UAJSvL4Vye7G+IFXheG6LZyBHe?=
 =?us-ascii?Q?bynYn15R700nfviq6yPiicaCpcVwwINSgr2kfpaTlvFikSovda1yOuwuAYyC?=
 =?us-ascii?Q?nNYDtktiD3ePP9RceKFuh6otGH0JEPGwpvdz/2tLsAUd0ab405VwhnCyBrGk?=
 =?us-ascii?Q?zoDDlzvy55r562bzooc+JrRxIlOKTWWsG2prm97jziMfz4Jx48xAddap85ZJ?=
 =?us-ascii?Q?ddtY89CafMVJXloCLPl9Z3w2JikUKLAVj7l8ujrO0d+XJ/FUyHR+/o+99Zex?=
 =?us-ascii?Q?BnsbQ0/cvkSB49XXL5JN5oPXGIitFgw5f3jIvtcQsko+izope9opQwALRZ+9?=
 =?us-ascii?Q?dkEp9ZIsm0TCtc8wl+vK0NMA3OqS9eKYasZcvM8k3zp8jds4ehhkEIKNSu/T?=
 =?us-ascii?Q?pz3bXML5ZCCF5W6Cj681/QPfGD2Fivs6Ox9X78dsr536iWgvUkDIvKej0h39?=
 =?us-ascii?Q?Fw7sn9r8h/5SeI88V3SC83YPTeEzMKZ7jA8A3GzpAQSjj+2OzQ8RCQKKfGLH?=
 =?us-ascii?Q?7pn0uii1xLwwB5SLUD5iVk7oUG/BAlr9tdbXWw+a+63R6xlkDrNyZWhSU+Xq?=
 =?us-ascii?Q?EnJVlW4E38rpoGIWsjmQSapHiFaOD1VisVYiQ8Or/DORRPE1MZM3EE7BL357?=
 =?us-ascii?Q?lE7OY5nuau0zPyQk4nGFvFQTaV3T/UF679DGkL6PyG3Wr0VqUDM7K5lhvTyU?=
 =?us-ascii?Q?WEqzbRc+WPDFF9guNxgO8xvIlc4PJg4osZ8hsy0O5jXQesc+9SWGFW1Eowvj?=
 =?us-ascii?Q?LkbjlUbPf/ap1vwcdqSBcXZtO+bS9dnnEui40nkyJqhPuLsx8dNX9817axd7?=
 =?us-ascii?Q?bFfoU117S+P3FPy2HsZYJYzA7CzZ+THIRnot92XwNWn6+MrLS9jsDhnjbzL4?=
 =?us-ascii?Q?0Lu5v+ISZo2FVSxuehHaq3ntC6f0eObNHMsbYuBCEWI67nj3s7vS8nFthPk6?=
 =?us-ascii?Q?n9ikocosgQMlLCeRHvEHkwUd9NPQkJu51aFWL2mWOqjGhYUMRZBgbvzwQ3RM?=
 =?us-ascii?Q?HgFoys71lSvrF/6ry/i7mTzgT5K8sQkPd+wqwgcD9ykqKzE4sEH290E6hqhf?=
 =?us-ascii?Q?Hs5MpXaBKIpK33mp05pH5owFes4ChQTDPl3ns6sTwtyOPHX0P2it9nElHFhW?=
 =?us-ascii?Q?6leFPadlVmwlsBCcSibOq7oNylByHI4XEE0uiYADCvrhS85JYUKVGr4HFakL?=
 =?us-ascii?Q?7pgdmsmlKfbMmMF0jSpXKe5P8Vydr6A+cFiyXGaO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a399e6bd-0e50-45fe-1c0d-08db23d3084c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:55:48.8897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4x2A7aKDij+gu9BkUongaVk0VD/CBPsa+VaIUzG+jFrApEY7U8m3I+/4bEess/dXAnDF9DKw6R6jtA4riOm5WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given a packet and a remote destination, the function will take care of
encapsulating the packet and transmitting it to the destination.

Expose it so that it could be used in subsequent patches by the MDB code
to transmit a packet to the remote destination(s) stored in the MDB
entry.

It will allow us to keep the MDB code self-contained, not exposing its
data structures to the rest of the VXLAN driver.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c    | 5 ++---
 drivers/net/vxlan/vxlan_private.h | 2 ++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index a3106abc2b52..f8165e40c247 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2395,9 +2395,8 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 }
 
-static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
-			   __be32 default_vni, struct vxlan_rdst *rdst,
-			   bool did_rsc)
+void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
+		    __be32 default_vni, struct vxlan_rdst *rdst, bool did_rsc)
 {
 	struct dst_cache *dst_cache;
 	struct ip_tunnel_info *info;
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index 038528f9684a..f4977925cb8a 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -172,6 +172,8 @@ int vxlan_fdb_update(struct vxlan_dev *vxlan,
 		     __be16 port, __be32 src_vni, __be32 vni,
 		     __u32 ifindex, __u16 ndm_flags, u32 nhid,
 		     bool swdev_notify, struct netlink_ext_ack *extack);
+void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
+		    __be32 default_vni, struct vxlan_rdst *rdst, bool did_rsc);
 int vxlan_vni_in_use(struct net *src_net, struct vxlan_dev *vxlan,
 		     struct vxlan_config *conf, __be32 vni);
 
-- 
2.37.3

