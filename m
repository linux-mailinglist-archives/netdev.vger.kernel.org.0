Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BF54B76F1
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbiBOQ5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 11:57:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240164AbiBOQ47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 11:56:59 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2077.outbound.protection.outlook.com [40.107.212.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A857D64D1;
        Tue, 15 Feb 2022 08:56:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jvqf5oMHL8pcbmyemUy15VAb0NV2S718+XQcAWt56IMKvaM4VW/lYVo3jU+knBm1iyXAoG9DIUy6U4z3mHJahpztY/PgQ5GVsqtyUeNb++7iLv1Os5Do/HcBVurvjyTX9geJ+f9b7HeVQM2G3jhUotT38wE3djQpOMu7F5qzSy7ONk2g+rJH9gixyErE8VXYJSmKAVUmIs1l+6O1J+YY8/3P0MIaE9J8tABnIlNRhrlbLeOFYtyhjpkBZC5kDqC7zUi6HdfZtgD2DXQofmrqotDNFpjDSGzxd0m+QUsZtS3/3O50DRglzYv9SMH9cxN+VWrL6XXeuQQqjcvOcQuMPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=son9GE6MNPo/omZeWV9C14oF3rNQ7vb3sPP1hI/9TbA=;
 b=Z8MFs055Kg7RFoJeO5SW8akn30iktuOjCsn47VNn3k0YHYQxpkaPNKO9k8GNOKi17ZLu3ZIhHET66nTp9CQSUp3BMo9CtzHLC6SfMmx25FJ9GndPOc3aHu1gP7ovZtDgT1TwmyEEkxpoNbE4RHKDN6BScRyVLT3oSs+6Dg/ueyseDMxKQFWa4+ad1JY3zXc59LtZeOUzl94MvWLdj811VIpzjh1Bvul0gNycsVpiCJ/+7RtCt0csxXthfIbrnOyLVVAQoQzoDSchO/jEaFMueu4lHgFXFUrhM+OQJrpR7SrY2pnxSCXFnfEyxrtAESQSg9k2cgfj7jmv+KQLRgkayw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=son9GE6MNPo/omZeWV9C14oF3rNQ7vb3sPP1hI/9TbA=;
 b=nurn70IUDOZRn0l2zr3yo/dPd9jmowbEwXvRIfnOJwxNTSTLvC5XTxkah8YQuyIZLanb2hspBaFqFp25qmwkafln61p/qkbttuEIXE+/Hvqc5zMNdt0zyiiyi++hjvw5j1BHgsv9QLyfTOHF9TCmlN/TSv57NeOYnGtnhLhallFvmjPsjCJIJkS6oxaMKDjROBST+42KBj8l5xVqlgmrR7sKVy5S7SIlT4553+ROSl2+vVm74PfJLXGnMkP8xiIN8cd0p85oWUpjK6/k/MC6zOsWPgY6Uurztq3eUrtEAnhu9LawPeL3nL3OWNSUwk07GeI5fPE1mkKQcpVVjGUWIw==
Received: from BN0PR03CA0004.namprd03.prod.outlook.com (2603:10b6:408:e6::9)
 by SJ0PR12MB5422.namprd12.prod.outlook.com (2603:10b6:a03:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 16:56:46 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::70) by BN0PR03CA0004.outlook.office365.com
 (2603:10b6:408:e6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Tue, 15 Feb 2022 16:56:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Tue, 15 Feb 2022 16:56:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 15 Feb
 2022 16:56:43 +0000
Received: from [172.27.13.89] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 15 Feb 2022
 08:56:35 -0800
Message-ID: <8a3b1ec5-f43c-03ba-f51c-5d1ba809657e@nvidia.com>
Date:   Tue, 15 Feb 2022 18:56:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net v2] net: bridge: multicast: notify switchdev driver
 whenever MC processing gets disabled
Content-Language: en-US
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Yotam Gigi <yotamg@mellanox.com>,
        Nogah Frankel <nogahf@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
CC:     <taras.chornyi@plvision.eu>, <volodymyr.mytnyk@plvision.eu>,
        <mickeyr@marvell.com>, <bridge@lists.linux-foundation.org>,
        <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220215165303.31908-1-oleksandr.mazur@plvision.eu>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220215165303.31908-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76925c7b-d4e1-446d-2e80-08d9f0a4254b
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5422:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5422914B8D7BA4F0E431015FDF349@SJ0PR12MB5422.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o7TwWFZDRfWuYDMEqyVNL0kJoYeX4Qb0Ktm9R/nfSKGEMJj/gtKTsYusgeJXrxe+VsptBKZTBzKGVCxvYD5r74ur1p6gxVvVQxdjRqBFsMxHo5hEYNi3zEkjqBTCK6DYs0JEuewpvxZy6jKMbyaccWEskcEYK7+56PiimnxtRnhcC7Doh1Q5ZxR0dMksQvGmvfMkdLlZLd1efijpWPO+lqJp0NUyKChwlWhwe62qaIc/iKOsQvN3u84S+92JGojei5MyRaVSd4Z+CaKt3L+uxuKejtqsXRIb0/3Q1Wp+3bjckE5NUDHvx/pjUT3sw/79tQCEfxQJzxd7bAG51e9x3pSb20Uzz1ky59A6k36AA/vehjMQumwn1JJooxIYK5UpnpMd/p5T816wny62c8YOIBMTn/cj3JA9/FIf3YFBUyiMT+fNlN6vvJNocvS4kj6rfKicdYGQ84YrIZ5VQrBKGwE53hWq4zdSJKlDeOVdclbsyiEO4feVUOkmYzqSQgnBrBmjWg/33CDAddX4eux7fXhroi9f24a7N9A1qeDV21B4qsYcIw+bBMamvYR1y7ZrtAf7tCfcRzrvVGpJA8AR/L92dLs8DEehpV2Og7o24HIKLY0PMwtct8pLWLcScEWEXZRfpZWm0Ukyjtz28jzaX/nG9bH47Q5lpMxZ8lQNlKfKgAqHnDUWveiSThRbugiwkOIG4xFt2+UETb/n1gVhJT1Dg+UkPCosCTdHrFNDlPIjacYq1kDx9f879YDRpSAc
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8676002)(426003)(70206006)(336012)(83380400001)(70586007)(2616005)(86362001)(53546011)(6666004)(31696002)(4326008)(508600001)(16526019)(26005)(82310400004)(16576012)(54906003)(110136005)(316002)(2906002)(186003)(356005)(31686004)(81166007)(40460700003)(7416002)(47076005)(5660300002)(8936002)(36756003)(36860700001)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 16:56:43.8904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76925c7b-d4e1-446d-2e80-08d9f0a4254b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5422
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/02/2022 18:53, Oleksandr Mazur wrote:
> Whenever bridge driver hits the max capacity of MDBs, it disables
> the MC processing (by setting corresponding bridge option), but never
> notifies switchdev about such change (the notifiers are called only upon
> explicit setting of this option, through the registered netlink interface).
> 
> This could lead to situation when Software MDB processing gets disabled,
> but this event never gets offloaded to the underlying Hardware.
> 
> Fix this by adding a notify message in such case.
> 
> Fixes: 147c1e9b902c ("switchdev: bridge: Offload multicast disabled")
> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> ---
> V2:
>   - target 'net' tree;
>   - add missed 'Fixes' tag;
>   - remove mc_disabled retcode check, as well as WARN_ON in case of err;
> ---
>  net/bridge/br_multicast.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index de2409889489..db4f2641d1cd 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -82,6 +82,9 @@ static void br_multicast_find_del_pg(struct net_bridge *br,
>  				     struct net_bridge_port_group *pg);
>  static void __br_multicast_stop(struct net_bridge_mcast *brmctx);
>  
> +static int br_mc_disabled_update(struct net_device *dev, bool value,
> +				 struct netlink_ext_ack *extack);
> +
>  static struct net_bridge_port_group *
>  br_sg_port_find(struct net_bridge *br,
>  		struct net_bridge_port_group_sg_key *sg_p)
> @@ -1156,6 +1159,7 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
>  		return mp;
>  
>  	if (atomic_read(&br->mdb_hash_tbl.nelems) >= br->hash_max) {
> +		br_mc_disabled_update(br->dev, false, NULL);
>  		br_opt_toggle(br, BROPT_MULTICAST_ENABLED, false);
>  		return ERR_PTR(-E2BIG);
>  	}

nit: you don't have to leave empty new line between Fixes and Signed-off-by.
Patch looks good to me.

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

