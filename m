Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20AB602B36
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiJRMHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiJRMGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:06:46 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2088.outbound.protection.outlook.com [40.107.100.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED3776468
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:06:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWdnSHjRbd1lJEfvqLQNEBZh50SNuO2abJ2iHl/Ncxjbdg99drqltbnQW+ONUW2q7SDmTSqPOiY1jCN+q/ZRUgXB9WWQ5QtUP+MpgapPcTS1B3vA5RMWoifQnYV3qyQxbupNLVjE0dmy97pV2mxmoXE299aGoUfPt4rB5o8tLsch9qzdxtNvAMy3ItxzA0S0BCLUsqeHMwtEUCTcw2UtbL1FTVt5eSQPuSuyO/S3Osk7KZoJFul7hNeCFjeYZRluD/x9H8mkSsuvXIUiA7Z8tVbJvR/Uprl+peiM2BbRj7TAp8VdXzPZVP/XLnXSxBSCghSvBffeEA4loV0q9D6SRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwVO3MdJewVwL++HqzQVhHQuzCLAJInR8kaZP71v4JY=;
 b=PDDGl7kyMpwecims/P2+woj5DaxyscleZ+T15tpriiFOAZOqWVw3QCzRKJ/YmQ25skTwmTWTuwXwLNeoVdl+N31tALXFobyHapqrYVi7sEn7uPO2NQhhwkcfwPCELQ/cbyXh5cDDZt7I+bsdBcvkL6s240yqYEdKSWzL2aYtvqTcJxXna6bVc9uFXtQ5Op8PV1BCTrnyyKsyqZrUDUerqrdP3sP0CPkA6B4R6TgJ5YAl7OgBXV0d7hU96V/fzNFy2KGi2kiMXmK7t2A/TxiufhsEkkEvs24tnGzkWTBgNMCqw1fmF4TwpnjBZhd1D5/cmKVjq6Xctj1oPTK8N3RVzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwVO3MdJewVwL++HqzQVhHQuzCLAJInR8kaZP71v4JY=;
 b=oJfZiRyUxIeFD6snHcPHP8ThVyuFk/Ftg3xVVNFNbh158IQXto4pYQekFKAF9tVIdajRaVp2xQ/8sSo/kxIQ6t6JfPU2Cqud6yXIIihyrBFDn+dIT4F8+astW9xI2Vwb8o/JR0yujKveJLsDGS1xRtJQKT3GM+41JD8aCaxgS7Q7v01Lu2UiJE5z89dqMZb/j/xanO0TjTq15Ci3YIb5zxZHPD1YiJOJ6xLIeJ7Tl3ChH5vqzBs8skpx7FTEUlPbQVj2gky2kzdzyHQUMQ1IBkkSUmGFbE+VBmljffjR2ikJqwo2o9StefesHxHbe7rsKSOt+1bxAo0bPSAjs3zkWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY5PR12MB6406.namprd12.prod.outlook.com (2603:10b6:930:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 12:05:25 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:05:25 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 03/19] bridge: mcast: Use MDB configuration structure where possible
Date:   Tue, 18 Oct 2022 15:04:04 +0300
Message-Id: <20221018120420.561846-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0051.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:1bb::10) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY5PR12MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: 41f10de4-f7c7-46bc-96e0-08dab1010a7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2YBSdcPKcoMgFHE9ASdkWL0R8V5Ec2NKVqGOUcBWt6G535flvFuzb97Ttk5cGUscrm4e7dyAx4TWH8Wwl7FV8+s2PeyuiXpCo6IgIhvA2oQeIieR7MguEvfsP6FNiK6jenLzFp5fY8cvCVS5RwczSKdmMilES9orDnXgwfQwVx6DzXWDosVBNWdvaxstjBqd1FlAGJ0VoD1zn+x3ndl5J5j3QBNxkk7S+UX1kg4zjNjU5Hbo4F/vPySOrefRrHExhys0rQ03HdqFUqzEDIYAzJNVs9FNXk7aaRpkagoPYh1/UhSyEsteE9onC9rYNDKKz+5wQlFLSvtwPmGNpTaZprztg6O3Qqq71fsSYsrgblsc7oeXWuWH8AE1NfrW2i9vl68F+ckUwmkHUd5nXh1L40etd0TKC207koFtG3gDQ7QIjZy7To8n/DBLDQYoSthADh8ER+sMfTnWD3lf4hgRuyweDbY4weoddg9rycAY7IKMvUXIW7H7t3R9JRG0LMomYpId2GCuPIy6bNPdFARiIimXdH1xZyDW/lwvQYoqLt6P9UbxfFC1emPXYOXk/zw2jS6Y50thDN+m3IiTwxT8nxBHApzO+npTLEKXQwu/Qun7tysj2SzRnmV81Q4kCbzM8OSdSDlKTN4S50bleAWcWeEA/5YncXqYgifPbyTCuoNrZgmR2DOO9lQpkIiVt/gu2sAsXu+DuYjyewGApckcew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199015)(36756003)(86362001)(38100700002)(1076003)(186003)(5660300002)(107886003)(2616005)(6506007)(6666004)(26005)(6512007)(478600001)(83380400001)(2906002)(6486002)(316002)(66946007)(66556008)(8676002)(66476007)(41300700001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Py39+ELJ1gx9bU5LcpHdWBEG16g7KEQriboxaV70paaiFxVU1vWrCLJskNZ?=
 =?us-ascii?Q?APiahDoH8FN00GYhLxfgjuMV9ubZtViTqh2KqRGg+UycFUyWF5rQVvMk1ZRw?=
 =?us-ascii?Q?1KPB6fUzpEGmW4P+fdZD9ROCvJsFoacKBlSZ6BsheKh1olZhJoGvvqIEt4XG?=
 =?us-ascii?Q?l7KwWrh8mtujz5zAcuv3QglWcAx1K0gdQo/hAXmn7N0FtiJAtpGYJIIYxcVh?=
 =?us-ascii?Q?cRbToYRY6czlipuizEzfST9DN0rD3H9HWbSGgK0p0pCW2gYM8528kXdHnIT/?=
 =?us-ascii?Q?iLnNTnAyhV0nZdzj6Qj3vPNlhkUURbwsr/QyiMDXwgpING7no7r2qd6nl8dF?=
 =?us-ascii?Q?gT1EB85fyCKjpEHk5sI7vlpGA6HWlg4pG/hGpavfnlOegq6xVqE+sLjTmo4U?=
 =?us-ascii?Q?wt1sxOaFtl+o6lhQmOLFWsZEhDAiMGwKRDDgK+cOfkNcoI8icpb+/s3jxefe?=
 =?us-ascii?Q?44J9Sn8SSVQ5U+4/aQmm7bnWe0PawFl65hWlh2f4/fGTpe6by1PFvTJB7nP3?=
 =?us-ascii?Q?sMqjTdBCOddeVc1+1dpTCa0vnAV33K5Y0HR3iON2YQJqPc4h/qq6P4+4RLHh?=
 =?us-ascii?Q?y5O2f5PfrEhtyGSaQyd+fRpwu0hSNSOHjd1JcMEgVoD0IIyu76J4AwEFwkqD?=
 =?us-ascii?Q?4L9T55rx8qqRlt8LezHbMNujQQzYrtGaKXvS7Xq5j1U/IZjR7yWRpZd3u3bk?=
 =?us-ascii?Q?7JmELo4q/doYrJIkq7oeZXFHY/MQ7uBvKADLoNcg9Flad8IW+2ai5CFM9l9n?=
 =?us-ascii?Q?yPAfyCyRH1AhGn4UneLCJUA3eHv1egX81M2DllzrizpeaHRIQAJSmnuGV9BN?=
 =?us-ascii?Q?ZctTgoZ+m9YLeQ/WMdoiVIj3f7XEokRIA65jmcbzMnL8ZlBwJKXHCN5UxbC5?=
 =?us-ascii?Q?D0E0a5JdsGxCHAMhd6FvpB76RN8pY0g2LHFi+tsKU+IJ0NtRA+cAmV7GH/48?=
 =?us-ascii?Q?cL7bz/x+LsiHYLdl5RbqzHUv86FMzi0gVABpVHjequmwkVUKRie2SkHlbibd?=
 =?us-ascii?Q?OQeHhly1ga6A/Gqz31djaWl4yv1wPMv6LMtHOSCpq+erLvA8M8K4nL7LFxfn?=
 =?us-ascii?Q?G1u8fHh1nEmLFcdgwycruI4Oy0sQ5QUfkcm0CMMLZbv7jmqMR6WHWWgWD7DJ?=
 =?us-ascii?Q?tWsY/VWShtTHmW8FBXUxWbFV1+tZLpRyIiy1TOKf4hJwq8UwZo6/KvORScWh?=
 =?us-ascii?Q?sQfyA8c1hjrp05MFh+OtCmWNfdFzHm2B0G3nPw5SU7r+ZuFB7YdFHTK148PK?=
 =?us-ascii?Q?9eX+XngTrdKuVSKUjpR3LQ3EbHAuww4FRqWJSvh/w4POAVtAxwnBYN1n2dO8?=
 =?us-ascii?Q?wVWLqFUo/1GYobFN3ghHs2ws27GtJXnCw8Z/hSRBQIsALjBtk7MYyD2br8Ue?=
 =?us-ascii?Q?PU5sciAKL92dpVJCTxWH6cioOhslJg+HmtFJYYiIyftnoh3helEsGwKj7JT8?=
 =?us-ascii?Q?ROmpkFA/FUbKfMv7HHhBBdkEduTw4Y8UaMydC+/2b4DpobLaR/i4oWbkZkBW?=
 =?us-ascii?Q?qraQ1Xc80FP7ZD6IQ5U7vFi3mY4KD7e0AseNkWmW1dQ1uVIYJKRCs01R5m0a?=
 =?us-ascii?Q?fpMK/4AZcQjnmDNvq9glVyAOGFdToMqgnmVaFYsN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f10de4-f7c7-46bc-96e0-08dab1010a7e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:05:25.6435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AIJ7+U08bkp4IXg/sXXVhwcHFLh9GhIy7EUYmoHog93UunR99gbzhw45aay4bjki71c++m/ESCOXZM47/Lyb1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6406
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDB configuration structure (i.e., struct br_mdb_config) now
includes all the necessary information from the parsed RTM_{NEW,DEL}MDB
netlink messages, so use it.

This will later allow us to delete the calls to br_mdb_parse() from
br_mdb_add() and br_mdb_del().

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 68fd34161a40..cdc71516a51b 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1094,7 +1094,6 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
 	struct net_device *dev;
-	struct net_bridge *br;
 	int err;
 
 	err = br_mdb_config_init(net, skb, nlh, &cfg, extack);
@@ -1105,30 +1104,30 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 
-	br = netdev_priv(dev);
-
-	if (entry->ifindex != br->dev->ifindex) {
-		if (cfg.p->state == BR_STATE_DISABLED && entry->state != MDB_PERMANENT) {
+	if (cfg.p) {
+		if (cfg.p->state == BR_STATE_DISABLED && cfg.entry->state != MDB_PERMANENT) {
 			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
 			return -EINVAL;
 		}
 		vg = nbp_vlan_group(cfg.p);
 	} else {
-		vg = br_vlan_group(br);
+		vg = br_vlan_group(cfg.br);
 	}
 
 	/* If vlan filtering is enabled and VLAN is not specified
 	 * install mdb entry on all vlans configured on the port.
 	 */
-	if (br_vlan_enabled(br->dev) && vg && entry->vid == 0) {
+	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
-			entry->vid = v->vid;
-			err = __br_mdb_add(net, br, cfg.p, entry, mdb_attrs, extack);
+			cfg.entry->vid = v->vid;
+			err = __br_mdb_add(net, cfg.br, cfg.p, cfg.entry,
+					   mdb_attrs, extack);
 			if (err)
 				break;
 		}
 	} else {
-		err = __br_mdb_add(net, br, cfg.p, entry, mdb_attrs, extack);
+		err = __br_mdb_add(net, cfg.br, cfg.p, cfg.entry, mdb_attrs,
+				   extack);
 	}
 
 	return err;
@@ -1186,7 +1185,6 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
 	struct net_device *dev;
-	struct net_bridge *br;
 	int err;
 
 	err = br_mdb_config_init(net, skb, nlh, &cfg, extack);
@@ -1197,23 +1195,21 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 
-	br = netdev_priv(dev);
-
-	if (entry->ifindex != br->dev->ifindex)
+	if (cfg.p)
 		vg = nbp_vlan_group(cfg.p);
 	else
-		vg = br_vlan_group(br);
+		vg = br_vlan_group(cfg.br);
 
 	/* If vlan filtering is enabled and VLAN is not specified
 	 * delete mdb entry on all vlans configured on the port.
 	 */
-	if (br_vlan_enabled(br->dev) && vg && entry->vid == 0) {
+	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
-			entry->vid = v->vid;
-			err = __br_mdb_del(br, entry, mdb_attrs);
+			cfg.entry->vid = v->vid;
+			err = __br_mdb_del(cfg.br, cfg.entry, mdb_attrs);
 		}
 	} else {
-		err = __br_mdb_del(br, entry, mdb_attrs);
+		err = __br_mdb_del(cfg.br, cfg.entry, mdb_attrs);
 	}
 
 	return err;
-- 
2.37.3

