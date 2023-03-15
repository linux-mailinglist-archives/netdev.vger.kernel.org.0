Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890556BB41F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjCONNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjCONNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:13:49 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2803A0F05
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:13:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+Yc3JvfFOre8Qr7XukpUrGo6BecW6IUoPjTyqoIVJcSG4UYenxHZ9fRVEpxbmhAkg59NdcE7uoIgZYvnF3IPcUh162iOtEwu29cgB0x8KK950IlPZGHPP7YYsOGneglhhchbfK3XnpEBL/zI6s7rHwm8WiQA1KfpoERh5Yjsy8ljJasWohdcSGK+S42XorG+haDhEiZvNP4m55wDXG99nPM3aJGObILdULDCZcHpVLPC+J338kI06SMJ8mXiaxq/Aiqa0ZsHUO9wfQ63fdm6jRxqfE6zSO3Yt4bOodSNWT4yP08wvpvjZNFcnbE8XhrDaCiTxvq5H5lZ5ZSYepZHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M8xQD6wIXI7G9nlFvyc28CRTCwLnUV1tYLqhNK96CV4=;
 b=RZa4wmmSmzmHMwRgpIVz7K5qYFrXnR9GDa25JAhbvhpnlQRwqtbRsmp/y3BdnySegLHuQoHInyeXtqF5Z5RsK8b/gKDP+TUz3W2XeA8eep2vZf6V9YgjB2Z3vc4/7pPcH+3ziWUVJA+Y97eOmROJLpMpEwK3+NBSBy1iSWt77vU7dTIFwDdAOBGRDujRaFjDhvKJR4UXpJQPIbuS+XYRuUKqcPWvIuRBwFg2Gd7rhHRUFyPBvi7aD7fsP6Sy91TLoiJKIfKvO9q4JS/iGbVkYu9pZNaISvyIEyNvnHs70oIoHet4AaPzfFstymjhRaznnKk4dTqKr0j3z3KE6o6n1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8xQD6wIXI7G9nlFvyc28CRTCwLnUV1tYLqhNK96CV4=;
 b=hz72DzRHHtHoVbX72g42rVRYpa1bhI9/vztycAm/n7I0tOvA0TTRpaS7KlnCk0O0+ytYWX0w3kMDzQGHPoeob6mvKqTT2QHK5fYuEV/qbLFosJsrCrgf2BSd1mYV/V51gs5F6yeLDGxc9WXyc4l6SJYj9ns97DCo0hSB8tESeyoJfAlHgsdJE1+uRirBoHiJ0r9SvzleOvg/XNDZKrIJ5vQX/B9MMvnb+dyHwobU6M0+Z9ZwgNyrHmarUhNyIDcFZxWcswO2j45HrRd/B9V5caXQ0OvEZlAfvRFtxFekQ5F5LymFD9khYnzL3Z7nVAl7zhC/aDlvtSet7GKAj5yaDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB6216.namprd12.prod.outlook.com (2603:10b6:8:94::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Wed, 15 Mar 2023 13:13:39 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:13:39 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 06/11] vxlan: Expose vxlan_xmit_one()
Date:   Wed, 15 Mar 2023 15:11:50 +0200
Message-Id: <20230315131155.4071175-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230315131155.4071175-1-idosch@nvidia.com>
References: <20230315131155.4071175-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0197.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS7PR12MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: f6060c9e-b651-4539-180e-08db25571763
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9zcWY69FTo98TLmBMNNkw3nVD5qW7jj1Yv8LrYj3L1Ys8VUJVP0iDrTbe5hAv20P1aQMyUgxIq22sqFEEMSUGF5w2Qza3/qqeoQ61pLcunq4ChSWOxrhMtUHk3N0VqBct5QFv/SqLrJeyMVD3/3Tu/aWo9QLxWZ2cC6z+lKMp/iot4y80W1CnxdC3RHMy1oxYzomg8Rvfu9vWPVJeOZBFJe+IkaRQWudTcBiEFVxihHXj056ZjQz9LDRKWfwsOk2oBFKHJyEA5Z1f7cSAmm6Szerc+RaRL7Wo4yGoRrlhOPcU2w4GQJcnWhbWCsyuFeqySf37caA+3OHCNfKOqHFRnYyAb8u47o2zBZ40UDXb1Jf4phtp5JbVHTX8T1vs9ktZBCIm9nNgAGaTjzq8vlA0dezl/zGUDzhTqi/P63aHC/LJCFN5mqjZ5GV59EDVOw1nIyeoxwr1ODo7P5pPX75vM4MTJaMq97sE4zHCfu0FOTTlFBTWhVnieEIBWWSSnlbYqAlc3D/xu3LqHkPhoXJifhkA8hSidb1bPiN0woduoTKH+ZtkfVtDI+5HLGHRPBsiGSLSvwMlQ7kyfidKoxpUCOPoH2mQKhENGJCB9nvw4gQ1fGoDzHFHiVuX+A+B1qXlMlkBb5+5BEKy28LIh8y2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199018)(86362001)(36756003)(38100700002)(2906002)(8936002)(5660300002)(41300700001)(4326008)(2616005)(1076003)(6512007)(186003)(6506007)(83380400001)(26005)(316002)(66476007)(8676002)(66946007)(66556008)(107886003)(6666004)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WgGm6ML3QUHBD56yLKBKx7jBvFZJph6FrYo657PNZvhMtc7w+ACAmhmCWSa/?=
 =?us-ascii?Q?COc1ux8hCzitW1HcTYUDL2x362CFoeITUTovqT4hcma4bIxsHSju2DZFswOA?=
 =?us-ascii?Q?mDNx5d9WnIX652hBLMve1Nh7MHFrbIAUKxqlt+a9xWaNJ4Jmxcu2iNizyceJ?=
 =?us-ascii?Q?7XxHCZQqvq+UUqsCpK35FHZ0dCw/AyXdA298S7DBDHqS1BzZ1pD3Zz4xOO3g?=
 =?us-ascii?Q?nO+ZZ0DfbM/iVIyf0jz5tZC6QXl9Z9QVUTXjGqS9Fx0HusDvgy75/GIK6Rvt?=
 =?us-ascii?Q?oELFrwXPJIyNzP3WU0qI1NYJ5WT87kTVqs8wmp+Siy9QJJ3KMLPkcCvcutst?=
 =?us-ascii?Q?HyeVewVacUTMe4lszehzkoeXHOPpIw8DNY3Dfoadu1ZCsVKXTk2gcMV3LuXQ?=
 =?us-ascii?Q?O1AmHCjN+HBHrtBxPtFOplNs/JDXB8YLmXkyKQWWy21bpgW0+AnX5rlHaS2O?=
 =?us-ascii?Q?5H2OpBcZzFpiEagPpFwDexOzB5IucJpazKqueF8wlXKQA/tkXCrrVy1BBnfD?=
 =?us-ascii?Q?hW8a0GtK59+GpSc2QEVUcQ9cGLjiCN+cbe3osK1gzdupqzvFd66DrAxAMG0o?=
 =?us-ascii?Q?dPTLZYj3pgqLBRdUhOvmxJh1NIdJXGLXpMJ7gN/EcGJ3TQta/8mYQdKm5dIA?=
 =?us-ascii?Q?UT6RIaCGkKurP5FoWrxo5ZPN9/Q3LKgk4ePWkY/MENz5w/xCnQ/glR+dOVvK?=
 =?us-ascii?Q?NzXbCf9ThVbEolgefnYwmhVPFsBTsxyqtil1UzQ9dtu+V7DfdT5YAqFCkDqT?=
 =?us-ascii?Q?dKVRn8VqAYPwxzMIoWhnm33RmEj5gyh/uCPE0lI5AXOU96l6ZQeJMK3luI+5?=
 =?us-ascii?Q?7d/pMf9pI3ieeX66Lb0zs+08WY7TZ7pn04A91wnwV02ktkoI043MN0XgGkwo?=
 =?us-ascii?Q?LkMl//vBQfHsiRN1ib3GfYKs4mhZCSBCnMQsRkA0fwVz83FLb2wxBbds+jmw?=
 =?us-ascii?Q?J4ndW9CoMkdb5MR7tEcd92AL+nfPatBZg7YX1AjHHNXSRgXBPN3VBPaoStZG?=
 =?us-ascii?Q?/DsDQkaf2YsFUOWH8o5+av5T8CYg700h4ta9rG5bYp5GHVB2BbybDSG5gRMh?=
 =?us-ascii?Q?G39kEOr4g21wDp6MKe0QD37IX+ofcyE/EU1qN/ajZu2ZNXYdwjg4ECBYsiwo?=
 =?us-ascii?Q?1MrrZOEfxVbOBzTPuvFReTbbt6+RzqSS5wGNZy+y/mteugzYsX9x582RePlA?=
 =?us-ascii?Q?WllDPBx/JbGjQQRPz5hEiKF2u22AYQz+1u266vWL4BLy/G3K3PYPGGo13n19?=
 =?us-ascii?Q?/irWHcQUDCyqbsaS6bcllxoGIti6GIJRvcKCvdhChRQM2nwgcofEwMSGEsqy?=
 =?us-ascii?Q?U8pGuHNG8HOyL2sNIQu+V3kYG3+r6bG64UPtedbVjg+tIr7NB2f/p5sljyyC?=
 =?us-ascii?Q?k/itdCIeegbLD9KMnBMkAQQC6dQpQRRj3c2t4NZVWUSQl4OahnA4zUPQQQbm?=
 =?us-ascii?Q?QwnuuyyS0MU0KTLln4pWXLwQ1cxh7Sxqs9ipMFuONrETNj3Bvv32aApzrxKG?=
 =?us-ascii?Q?yhMpIs1I8vHsAlEgSN4pj+6urY1FwAwOr/FpmjhGJIfajfAffFpFYkbIaVXr?=
 =?us-ascii?Q?drJMwFX21XR36OrpVIhvWglrJvUL+ZM6JZtwATEP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6060c9e-b651-4539-180e-08db25571763
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 13:13:38.9215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 56ltV577rrZiBjF8FMD7jxK9ZIgs9jmRTfbqgJU/XVoRhLt/2psStb62bEnk2QxzFwSNZF+o1prmMKnIf+LWPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6216
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 drivers/net/vxlan/vxlan_core.c    | 5 ++---
 drivers/net/vxlan/vxlan_private.h | 2 ++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 2c65cc5dd55d..5de1a20497a6 100644
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

