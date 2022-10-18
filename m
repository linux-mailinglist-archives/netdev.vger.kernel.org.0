Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C64602B41
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiJRMH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiJRMHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:07:22 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2088.outbound.protection.outlook.com [40.107.212.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FFD82625
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:07:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmdYGxBhR+xTjElES83PaX6NKQC4ppGyTBXaYGpn9NFIJg2FFA9AUjEE06jbN+3zzQaM/RI3ZkjM7XCo91UpkgIQu/9+wYJ+hbLvXdbYphh9o30za8C8i3BMTXFkRG7/6X7Qe4VqVzq3YeFdSgKpWEus0msgOdw8wcfbzP7cqlXQOTG5zQ/A5P9/YYE8zwVxYzbn12LYloOIRuNXmf3QussooilHgM64NWG6HXoqQTQjbyMavjUYq9lBIS7TsJkuSp7zggcXRNuAZulqRKcaL95KodmP6LkEfsNRG4KUL4HwH/ZuWA/SJjl7tA3Lf/xQgQNUuxd4qQDULgFhznhSkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IamVcORR3O+jhnEgZr4SuPWFBLyo4aPO4o6t+GBlo8=;
 b=a1rucXA6CrXOjRguJ+4rZCmUZUk1ZYDTsOu5xM9MRF+R1X6xa1wnIeBCMOehxkOV5QTtc08cCJLNZm1jCMv2Q1vZ09GSxY/aV9AuZxGZqAg3vT6VcLdNS2SKRUbdhr8CFmuL/ROWIOKCWEsNyYB0rV+rsuZOf6JNzaikZTa7iJy/hbsfv795QlIjJLy5ssmg5Q/KhT0NkkloTrrocERcOnCYmUDMQVv2Lv2NUtbguCpCWWpyAINlVipaX1UZTJ0AZUlxbepUiCl/Fe5jCPLNrlrnpkbQ4VLEmmc0hFoydZqXVb0FlH/eXkjKfa5LSBmDWKcpd9Dlj3tXyJJ6k3ztCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IamVcORR3O+jhnEgZr4SuPWFBLyo4aPO4o6t+GBlo8=;
 b=d2tLfX0tEH20eoweZQy1vx/YWpOqUKIRU6uCeHVgY/q7WtLoov3v6UG6m5BTMCS6bnAsjK6lLJ7pYLBU3GcBQqMMEfwM3C6mJN28AUpiGQHoKl/OrRx+0Lsx4Lm93N5FSKScurug7j+7FhDURMfz8plzOy0vtqmIohdaADDgeZT31zYhNb2Fu+Qd9QVVxAOkOz6NdSksQwfG2BlmBS/uJOy+/HFXVvZliAqmnBm8FBlwH433dXFMFGtr29IJSkuIIoNJ2YGdxB8Gvh8AofCXPFq0Oz8FsSo7C8CQxzSC7l1+PEJxS+jquAL3RNuraJsJB5X0cfa5W37H7Lzx3vB4SQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB6696.namprd12.prod.outlook.com (2603:10b6:510:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 12:06:39 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:06:39 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 13/19] bridge: mcast: Expose br_multicast_new_group_src()
Date:   Tue, 18 Oct 2022 15:04:14 +0300
Message-Id: <20221018120420.561846-14-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0046.eurprd03.prod.outlook.com
 (2603:10a6:803:118::35) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cb0ccd4-b2c4-4e10-cb7a-08dab101360b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A7VyCNVyE18AhhHNJC0VMfPXCevYb3PSbhH2gTnnlasuwqn93vTcm5jQW81US+RFjJktYswa0emSBBdaSeRnrnsOLFEp1Dkfhvd3VZsfv74I49IApbKTh7MISYmMifUz/ppSblhu67zWK40Y/K/Qpuhdn1xUG3aloyyhbRAZbWLYFRdSt+jq5UPTsRslnoQU/zXtu5tXs6I7w+p12eR42bTCFgvCsHXlh6HALDvOY06+yxTHJ2ZCby0/Bgbj5z+mL8/l9N7Af9j+PtPrFpl4V9jAtoTgazjqh9wHJsQCmnUI85peWZ+ncNI5D6ehnSy2r574cgQnFa9QVh3FkVULBjlUoaMYSaCVYhzpAUtRhZP6o4bLW0HSpP7uDj3dTtiHxmH1T2bgtTZ3ywsixicWkHNiHxgyfWK2YTyqj2Gsd7WnMIUbCxHsHDmMe5S/W3Dbb79BJRrhb3iKU+H/tp5/VxDPrEOMB16dWHO/jxjJkS79+SoW4OOOlnXLZTUm7TyxRjAJidG+WC1CVsj7+0dwlorWiOD3BRMl1HEmrdKvrrrYJIp76ulAH4slZ8BINTVSCV57vAgOYNp3TQeJTFDnivQCboA5DGPoD7yo2b/DBBB4TPxQc4JKUmEdh2q+HWD5sPGUMpFEYYlsU70Xo2UnfLx6r/7/84DJ91f3X+fYFCPAYTCmNJipHkvBrTsu+MOQ9m667AT1so0k2/wXHRlf+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(6506007)(36756003)(2906002)(8936002)(86362001)(4326008)(5660300002)(107886003)(6512007)(6666004)(26005)(41300700001)(186003)(2616005)(1076003)(478600001)(8676002)(6486002)(66946007)(83380400001)(66476007)(66556008)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qYzWpNMNECdquiAM1drGmGTu1axqOWgw4MQB9q7NmQ3+EIYiCgI/d15fp79C?=
 =?us-ascii?Q?CEK9eyTlcCmM7BkmAUu1I3mjXl3YGN2IhQAnOj8GODASR/RFre1i8CrUwiAl?=
 =?us-ascii?Q?nkeDwffQqiohnvgGn2Ad/ce2H/XjauDwvmaynuAzVMzvT9E0dTOnZSU8aNrs?=
 =?us-ascii?Q?j5k58zRkPOIobWagYvm508riu4VH1BfBDhIO7xzO2Zs5stS6+H9G9csr+zyP?=
 =?us-ascii?Q?Sx3IaV8tYzZz/Dhr5GyT4fsfKvYXV44wYozlHshugpJNR1EKlk5l4JsZ+eHn?=
 =?us-ascii?Q?lDsrt36pYe9h7AVLGtWdJ2g6XuF7Glg+gS8b1cDe6gbHLbiyh8DxLUcMcYF+?=
 =?us-ascii?Q?qKo2RaClyPHic5b39ylj+hh46oMUH35+8TTZTVS+JxaEbm4ruj06762/9jmC?=
 =?us-ascii?Q?n65G03+lLMulAY6oW0dDGKSyjny818HIyq/Rm3566at1mNw4cgveVEGRsK/0?=
 =?us-ascii?Q?liQ101Mtr2WEEWaa9p5bxYc9qDA6c0W8X7bBtIhe0jOb7oDW9k/n3WtqwXAd?=
 =?us-ascii?Q?FZACIqYUBziY1gpLlSpPex9fyfcwJ/FNhIUh/QwS5CtTPOeraupuaYYVzh2W?=
 =?us-ascii?Q?Bllz4l3dUMuXFM4GBOW3aJGbj+YnfYOJOj3X9KQgyfIdvira4eOs3uiI/dAA?=
 =?us-ascii?Q?29UYq0FU9EfZevE/FfrqVfH16wiJVUN2fCYMdEFrpwaLmpIMyJHjs02ZHgJj?=
 =?us-ascii?Q?VRwW/40p+WOYQ67uCgNXzTa5BWSqnIs9uhoSDrVqkKzUZZPCyfUwAvXgmzFY?=
 =?us-ascii?Q?M3L7wMOD2ZJk1uHgEhw8Lpi+sMmCfTPKWQ4Ef9Owy4Kfo6VR65oWb+imvofL?=
 =?us-ascii?Q?MZ+453POwbfahuHD1HcgjIRZrlzqRd6D1p0Z3jqov+vPbZhxFabBeVZT0DHn?=
 =?us-ascii?Q?2e8amMmyYfn7rZ/bg4dgb83UFy/PQQXKsz6pV7QLLJXw3aQRi1yXo836EUYP?=
 =?us-ascii?Q?VBeJXbfLBo9Y+PUrps+Ov1s+KeX+LV7xm/hyuE5U9fa/kJedU3UnaJQxDAeH?=
 =?us-ascii?Q?G1IXqw6Gn14CVOMdsryIEZ7mI9ZCmigw8yk337ySelagJjr8D35SH8sHDAkd?=
 =?us-ascii?Q?Gg32MWpOQHzHKtQmGvKuMPn+E3EV06AZkomj1UcBpa5ynWhQgud8qwFefIos?=
 =?us-ascii?Q?2LwNhMB/vD01kUHNFIwfaIjxph4m61vaN478zFRKIvJYGF83yx1/24UVJJI8?=
 =?us-ascii?Q?z9C6IRfkToWsIuuru02fyKIhAFL0hBauIG/Xm70/ypWiEtEWQcmX8kr0kTEo?=
 =?us-ascii?Q?p52fTjNlsQ4ho6Ya+oNthGJXIEb0MKcMLxOXDelbMsqgcXXr7RsC9upasb4k?=
 =?us-ascii?Q?MmqNy7V/UYLYa7EcGeWwBZUUP/8iyvaMdwoVE9nO21gf8BIlWkb5PyysZ+Hn?=
 =?us-ascii?Q?cFN8jF0J33hYj0kwbQKZSKyTM/tSBl50RcJeik8nksBRIJ1/BiiS0CO5RToC?=
 =?us-ascii?Q?p4dgEUFjdGLPJMEWeNlYujfZpVpjv7TaniWJZE+1XyiffrIX+9BDS5zIly5r?=
 =?us-ascii?Q?oWQmd15o4S3OQx4uj1YTJ7WVYqNjMD13Nk9jJoflsMSBvR6B8WUXcLaNL7lt?=
 =?us-ascii?Q?BGPn3yEwdElP756lSzmOK0xHGXmWoeIPaPrH0NIb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb0ccd4-b2c4-4e10-cb7a-08dab101360b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:06:39.0715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jtTeoD6z1ZF6rDxZiYjAuZmh87XHwrgn45BQlP+b/jGt4h6DOp/HlFW4u3EbiMRSTvZW7t9VQqK1reAwn5UooA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6696
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, new group source entries are only created in response to
received Membership Reports. Subsequent patches are going to allow user
space to install (*, G) entries with a source list.

As a preparatory step, expose br_multicast_new_group_src() so that it
could later be invoked from the MDB code (i.e., br_mdb.c) that handles
RTM_NEWMDB messages.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_multicast.c | 2 +-
 net/bridge/br_private.h   | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 09140bc8c15e..14f72d11f4a2 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1232,7 +1232,7 @@ br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip)
 	return NULL;
 }
 
-static struct net_bridge_group_src *
+struct net_bridge_group_src *
 br_multicast_new_group_src(struct net_bridge_port_group *pg, struct br_ip *src_ip)
 {
 	struct net_bridge_group_src *grp_src;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 278a18e88e42..2aa453ea04f9 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -972,6 +972,9 @@ void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 				       struct net_bridge_port_group *sg);
 struct net_bridge_group_src *
 br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip);
+struct net_bridge_group_src *
+br_multicast_new_group_src(struct net_bridge_port_group *pg,
+			   struct br_ip *src_ip);
 void br_multicast_del_group_src(struct net_bridge_group_src *src,
 				bool fastleave);
 void br_multicast_ctx_init(struct net_bridge *br,
-- 
2.37.3

