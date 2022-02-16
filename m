Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EFC4B869E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiBPL17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:27:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiBPL15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:27:57 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6DEBCA9
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 03:27:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOALOYXijTRGjlKeFUyj6jHYaDF5SURmAF3FXWDyC9KnuvaKa00/tnuQcKemtLZzKWlz229wP0SbYa8zmwc1Lzd2T9l0/Mrh2pY523jQFwPVI8wv/XtDiDnERU8p+cYNEh/JryjamCcUZ8UbxUGfQNz5UqHPbTG/nMVBk1oaU7xupH8sxp2d2wUiU6VKmBe3iYSAkm2DsSJeQBGedZn3+Me0WWOq2DufusJA4TWSSJEQex64jtxU9No73F25fO+GGGjjRHw0rhSeKraQcabZWvFp14GYdoVNg8y1nSeo8qkmZJ9XR3vb7JFYw3A7x/4V5T774QTFqKzg4V06Y2gGiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Am7R8kTHu8/HAIkVznF3sRp9XAqjhGUm1acr1M7Wl+4=;
 b=f97VnWVZqYxA9WuKmbCYeaCaEFekJh/6EB4V4UrhsTIJJRzyntR7I3cJk64P1slomt/6TM2zCgirmi3C1yDpXQOn2KflM1XmuFWG96LWl1104z05kukt8DR8SY4XqdFC0dnMfBUG7KEqnpGPySEtLS4PNLBbXfeAS7urA/jlFO8p4ett2LOjYpTXKtymBlpBp/+ADDUQC8WOV2KAGMLU14oRzIYCVLrNzNcfOY4Z4jyWpAMhf13szPC5llcsaU/jOOJDAC2wbmqEaVyIe/8Ej12BTQgu7yLuqmEQtXqh2733ju7UN+8Nr5T0skwzWPKVIEwGds5Mg13NpA7+TMClEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Am7R8kTHu8/HAIkVznF3sRp9XAqjhGUm1acr1M7Wl+4=;
 b=NTcsX9PD3md0ResG8B9d8e03EoSnHyh4OpfwD3G6uH6ZhBvZMcQY4PJpzlU1sMTvqUpHKKR1XbqlJmh5rNxB8OqqOmHrohATiNkdHa6pa0boOOFNGSTc1MNi9jjO0ZJYxrwISBg4jajNdB/vLe8jD2eWL/8q0LttyvyKPDcYeVl/osxxIuEEcRU4iPEdrrDxCgs1buIDVhQI5BUBKsN/Jq3EiXdMULjoarDPQULDbwpIEk8luur0aXac9NdG4O/edrdlwwtaULpXcw8QXqiPKy79Upz8sc4sAgmDH3mxUfh5gS3JppIyPDY/nV98JIsfAy8wsAvSen7nvEN4VpTOcQ==
Received: from DM3PR12CA0116.namprd12.prod.outlook.com (2603:10b6:0:51::12) by
 BN6PR12MB1697.namprd12.prod.outlook.com (2603:10b6:404:105::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Wed, 16 Feb
 2022 11:27:44 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:51:cafe::17) by DM3PR12CA0116.outlook.office365.com
 (2603:10b6:0:51::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15 via Frontend
 Transport; Wed, 16 Feb 2022 11:27:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 11:27:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 11:27:43 +0000
Received: from [172.27.13.137] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 03:27:37 -0800
Message-ID: <36f19500-63d8-861f-9624-c3874cea460f@nvidia.com>
Date:   Wed, 16 Feb 2022 13:27:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 net-next 05/11] net: bridge: switchdev: differentiate
 new VLANs from changed ones
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
 <20220215170218.2032432-6-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220215170218.2032432-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffede229-d7bb-40e2-c10e-08d9f13f59db
X-MS-TrafficTypeDiagnostic: BN6PR12MB1697:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1697D7714789EE8E9A053D66DF359@BN6PR12MB1697.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uhiPE7xccjbcbb1sRlhnY0U9eqQd139yuszSSIKJ7Z26h/WqO7Hf40ugAiCc4Pmr1aRaltyftgrERaiP848eLxiJJTK4OdxZMbziiLTrBoUmfvfE4EtgQuUg5rzfs69uZP4/Oocwq9NMih+uxBiivD1tCOL411sSJ9jqee/B4r+X6dtQE89Ar0BP0vL6v+qCVliixIbi4aV0IIlAFFRfd/u4Uhe2Yujr27RtFYeGChSIM+MFwRC456l0zLanOa9x6ymwtB713z+3eoVLEynHjVQF5rUVXBkk3TO9npnG0DxclScdlphNK8XxlSqHisvWrAAGoo3FFNhmkMq5W++WHKfBz8ihpNM+L4xz7IfMINI524BDuZ4lKQr4xmieq3H/NRjsw5faDK9kCvyHpukNEWlqgZc0zcqCtfhDIoyhAIDAjZEFn57giCCAr8nd62xjNwWB0Z4qnJSBBMwOR93okWnP88JW5pa95f37LSnMDjnT7p1LPe/QwId9yfpEZ5ES32YHOZvTn03J3prBJKdilngJP2nlgIpQOXTxdP7FYj2Ph1cATrnXiyzBpADFlNNz+zbcoiXOqMCC0JrTODxxttnyMSGvoZAGUgFQVEy5HS3SHwVq9m1JcxoI0lkWC9QhH+R5UBv7SBU7C66cBj4+M/Q4Gm2dIywi7XJdlR1+xriY/6N9d6BHG8QxJUBd0shTJNQ4rU3jN4WHyKBd0tOGNOOuBx6eCMcLPhIQbUD0mqRvADGjuEpuYvZqr+Sa7zkT
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(82310400004)(2906002)(83380400001)(5660300002)(426003)(508600001)(7416002)(356005)(26005)(81166007)(316002)(16576012)(186003)(16526019)(70586007)(336012)(40460700003)(8676002)(4326008)(47076005)(53546011)(70206006)(31686004)(54906003)(31696002)(36860700001)(6666004)(36756003)(8936002)(110136005)(86362001)(2616005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 11:27:44.1193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ffede229-d7bb-40e2-c10e-08d9f13f59db
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1697
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

On 15/02/2022 19:02, Vladimir Oltean wrote:
> br_switchdev_port_vlan_add() currently emits a SWITCHDEV_PORT_OBJ_ADD
> event with a SWITCHDEV_OBJ_ID_PORT_VLAN for 2 distinct cases:
> 
> - a struct net_bridge_vlan got created
> - an existing struct net_bridge_vlan was modified
> 
> This makes it impossible for switchdev drivers to properly balance
> PORT_OBJ_ADD with PORT_OBJ_DEL events, so if we want to allow that to
> happen, we must provide a way for drivers to distinguish between a
> VLAN with changed flags and a new one.
> 
> Annotate struct switchdev_obj_port_vlan with a "bool changed" that
> distinguishes the 2 cases above.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3:
> - drop "old_flags" from struct switchdev_obj_port_vlan, nobody needs it
>   now, in v2 only DSA needed it to filter out BRENTRY transitions, that
>   is now solved cleaner.
> v1->v2:
> - patch is new, logically replaces the need for "net: bridge: vlan:
>   notify a switchdev deletion when modifying flags of existing VLAN"
> 
>  include/net/switchdev.h   |  7 +++++++
>  net/bridge/br_private.h   |  6 +++---
>  net/bridge/br_switchdev.c |  3 ++-
>  net/bridge/br_vlan.c      | 10 +++++-----
>  4 files changed, 17 insertions(+), 9 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

