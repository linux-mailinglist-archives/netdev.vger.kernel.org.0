Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD6B4B9240
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 21:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiBPU0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 15:26:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbiBPU0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 15:26:10 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2048.outbound.protection.outlook.com [40.107.236.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA4B291F92;
        Wed, 16 Feb 2022 12:25:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3G/3qUAznzkO6Yq4koIh5z8BLXG/zH19CJzN0i9WzF+Q9jkTj8KECPRBaxkKeKVg5JJM6moiHIRqIwRl49xBWuhK/xMqOsGca+d6Tr8OxzIiLTMu9+hQ0lKtusHHpt4SNRZJZ7dSmmSYweo69ppvW0n9Kho+hROoZKnVT+mdIOIB7Gdmuoqa67F2CPOKKJPeUnRaCHdBij1RMsI332r+XeCY1LGozk1+hQ4xqO4jO55ySgqoJvP7P2j1TJylVw0Jj149ev/WJ1kA1G8EQa4z5n1HhfqGAquV2IdCHGJJ3VlMfTjwMJxxLlOVblJOcwdva4GXOZoxMRYPM3v7thXOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vt7n3Be+UGKcEgi/IR2CKzuszuth6cTDHnKM3+e3Dww=;
 b=l0hKRpXYrv1d4f1kFntTwo+BLdfsdFtavnzy56f+WH/0qGYqxf3wbP74FllhTisl5cZa2JJWxL80ren+FUDQT0W0EA528oeTU9x0bxYfnEP5b+tV5mhBo6YBbIHboXdcB4HIuSrvCS+UFfJsoFIypvoa/ImrVvQa9ijaNV30WBgzSwNvkedzHFlJQ2DCbV3A93H16cgHZgxRG0IvN8DHkS2soEGT3DlxV5RkZ+vXpdFFo4CXegxJ+BVymYcqgN9b6fB9uk3RbrEsX4xXs71Qb9gycQxTc5Wf5q8O3AcRhH4h+p7aTxe213hEqpwgjRZskua0ekfp3WmunRQVgEp1sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vt7n3Be+UGKcEgi/IR2CKzuszuth6cTDHnKM3+e3Dww=;
 b=nDfi4i07C3tiCR5qHP/j9v5TlAezg9w7nvk3hiQ9z5TbrQxXOgzu0OOeOf6/6msVU/zFnQQ32tzGmVMYifdBA6cre4PuqEvMn73lc8qD1HJMEX2H+/xtQ4fhos8mAZ/hgWfpYi0z6eTyKnza5X3Vhuvr8W6NSBBU0B6iaJ/ePOfe+lLxvrCpNZGnmJfSzDg8DWDR/CnHwqVG2HbrOaNpRUUOMtzCsrV6btca/qWTgOaUr5B6zivPtnaM59tcHet5wRiWG+wOgfi8TvALP83OzjHT3TAA4b0Opm+RLabnXjsBTrkIHJWDLmvGXJl0Y0lniyxW1vyBMV0TYyvQCHRAJQ==
Received: from DM5PR07CA0112.namprd07.prod.outlook.com (2603:10b6:4:ae::41) by
 BY5PR12MB4904.namprd12.prod.outlook.com (2603:10b6:a03:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 20:25:56 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::11) by DM5PR07CA0112.outlook.office365.com
 (2603:10b6:4:ae::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Wed, 16 Feb 2022 20:25:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Wed, 16 Feb 2022 20:25:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 20:25:54 +0000
Received: from [172.27.13.137] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 12:25:48 -0800
Message-ID: <0d56eb36-8b4f-ff00-da76-f4dd97bbeb5c@nvidia.com>
Date:   Wed, 16 Feb 2022 22:25:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 0/5] Remove BRENTRY checks from switchdev drivers
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        "Horatiu Vultur" <horatiu.vultur@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        "Lars Povlsen" <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        <linux-omap@vger.kernel.org>
References: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e11d386b-637f-4418-bec8-08d9f18a891a
X-MS-TrafficTypeDiagnostic: BY5PR12MB4904:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB490422CD2CE4580EE0FE2721DF359@BY5PR12MB4904.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BdtQB5agldrV1k3oItWvIwTSLPh0awiGUAXJpH+sjnndttsAXCfDQaIlMT00K9v2WKShcG7pO6g+ZYhj83i9wgWZKumO9x7edG8N0aRLDfR+wKSxv0Ep5c4tSvOZ4hWPamlClqxQmUmuZvpkSPfUKkcsJuBBERThkhpVRKQqpHx/VVui4BhY9lrUXl0SDcNCW9JqOavU0CM9jk+8XiFoaA8HiGlW3xCYQRLws+FfYmOMQnH4n7xFsYOGJRpyPHAqjaRkEv3rdGyb1qfz27ErLw0ACL5uTSb3cjopYjSxG/1a5PoQ0eLH7W8YaQTkx2OP4P67h7y/QDCmt/5UNLQwfl4eBj3c2RCvix0t1OVUCD7wUrgJAx/KxWaVGaCH5uorlPwniYVKUVHlXpELNSLydLhbuoW/DF3LaI/YGT2IG5mYoHOedNQoufIC88991ovyNYnBWNWAs1g/jXAIC6uJi/ett7Xn+mKRf7ZzPCJxOBpprqk/fyF2QfkodVDR5aPajl3fRv0A2oVt2uOgQung3twCzGtAhlXh/hT3Nq+jpxq063TKoRWHrcbJP9vOcRghDY+5tMhFmdCAo6uLLVBoSDoGkkhkyBuOXrQtw5QDTlY+MkhphBljUEA9ZfY2pp2MpF6XDI6YG5HmTCjyGlA2AGMrOHtAuVlYuNNXXAg6CjgtvcBJZ5lUWEsQ0te4tstq3p5sJgo9rYJZ/PmGVeGr3EGb2+bRHxOR5L2QLnKHcuqaFzuDqJPRwfu2dEuAoyXvaPnXkspl5YX3r7zLJWICOIaH8tSPCtHn8ol0Wdgy8QlCdbYgOunSz+78xLVYMn2pvnDj+nB5jvt7gmW1bJxm9w==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(8676002)(54906003)(4326008)(82310400004)(31696002)(316002)(110136005)(16576012)(2906002)(47076005)(6666004)(40460700003)(53546011)(5660300002)(508600001)(70586007)(36860700001)(70206006)(81166007)(86362001)(356005)(36756003)(83380400001)(2616005)(966005)(7416002)(8936002)(26005)(426003)(186003)(336012)(31686004)(16526019)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 20:25:55.6241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e11d386b-637f-4418-bec8-08d9f18a891a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4904
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

On 16/02/2022 18:47, Vladimir Oltean wrote:
> As discussed here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220214233111.1586715-2-vladimir.oltean@nxp.com/#24738869
> 
> no switchdev driver makes use of VLAN port objects that lack the
> BRIDGE_VLAN_INFO_BRENTRY flag. Notifying them in the first place rather
> seems like an omission of commit 9c86ce2c1ae3 ("net: bridge: Notify
> about bridge VLANs").
> 
> Since commit 3116ad0696dd ("net: bridge: vlan: don't notify to switchdev
> master VLANs without BRENTRY flag") that was just merged, the bridge no
> longer notifies switchdev upon creation of these VLANs, so we can remove
> the checks from drivers.
> 
> Vladimir Oltean (5):
>   mlxsw: spectrum: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
>   net: lan966x: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
>   net: sparx5: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
>   net: ti: am65-cpsw-nuss: remove guards against
>     !BRIDGE_VLAN_INFO_BRENTRY
>   net: ti: cpsw: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
> 
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c  |  4 +---
>  .../net/ethernet/mellanox/mlxsw/spectrum_switchdev.c |  3 +--
>  .../ethernet/microchip/lan966x/lan966x_switchdev.c   | 12 ------------
>  .../net/ethernet/microchip/sparx5/sparx5_switchdev.c | 10 ++++------
>  drivers/net/ethernet/ti/am65-cpsw-switchdev.c        |  4 ----
>  drivers/net/ethernet/ti/cpsw_switchdev.c             |  4 ----
>  6 files changed, 6 insertions(+), 31 deletions(-)

Notifications for placeholders shouldn't have been sent in the first place.
Noone outside the bridge should access a vlan without brentry flag.

For the set:

Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>

