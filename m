Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BF74B8663
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiBPLET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:04:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiBPLES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:04:18 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0929316E7E3
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 03:04:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZgDcZLU53vffHyiuIFdfCUPlyKBzztUVHWJZ6JnNWj4/STSAsCLV9p1J6ylvKY//vaFFVowhdlh2HUXN+h8uPX/3uIAkK1Jpfe1cfAq5gRMQN+mKW2X0sHaDA4NlaWAkuRiFrCkoTcJfCbeMVegKxUtemTNErsuvYSrplNGaMrNzpMuIYZIvoxhmUVe0i5UOINNow3btVp7ZKvKGrf2EaXdk0UC/ybaNXwV2b0oOOPr7fqjflpLzP+TSgodxH4Zuf15ehqAIpaDJLytVYrD6A4DDhzi5UOmg1j20nl8cjjGusP8RYZFeewOuO1wTITu22iZeUnhntluWSM4YM5TsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CSd3yfTqnvKkLGXrHYrYYW66OckdAOz37o1VhBEmooc=;
 b=cDlA8BTKg8l1XFJ4aIg3uEzXqwh+593QMBGvbgpXfu/Gc/UWgMc/3yZ5+ZURAv5x1tc+PvDYdXq1cRmO5Isi0ZeB9UJbbPwz9UqkfT4f0ftDTFP4OT26Vn9yYyE0ijZTQxttk6FjLpAmXcEIzvyg5lDMOIVA3A1vhZ12su5+RaOtNIqCSe5B0lW4d3YqKlv4fO0RGQ7v1TgNfQkQuBNABLlZTsY7Y1ECYZdoSLur8DOVgXut7ccDQQg2vuLm7GYPHltIjSyk5MDy4baEStacrY9KdHsYpZEU8KOr3f7lcXl4RX2mWiJafsz3c9sB0aQEc7J/TaoKui92X6DmkqmBBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CSd3yfTqnvKkLGXrHYrYYW66OckdAOz37o1VhBEmooc=;
 b=M+MtCpFG8FT0ihRLyNwRavOPkEANym25lBFKJB+lId2sBFQHjf/1tHD2KzJomiE5GPKWXMM3H0ge2hS4S96OME0OAqQpdi2VZhYFYoDNPwVJcFfebv3vgBv9wAPJz2hwEt5Z3qNeG3OsK4X3s5u7orRuvPuSA5oEtNXoKk6AzGaVhQi6LEbuRMVS4gC8wIxSINTaGqUM180GGQpytzTENe5JKN9UjQQP63J3N0g40TPpbMjfhFCG8bzEWDBJ3HOlSGjr/aE8fp93Nu/evRjF2x9rWdRqNL7PMnxpwdss0/5m1knDnKGE33qkCspOiBekmZe2/mriM9YyZK1I/m/+Ag==
Received: from CO1PR15CA0066.namprd15.prod.outlook.com (2603:10b6:101:1f::34)
 by MN2PR12MB4111.namprd12.prod.outlook.com (2603:10b6:208:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 16 Feb
 2022 11:04:05 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:1f:cafe::ca) by CO1PR15CA0066.outlook.office365.com
 (2603:10b6:101:1f::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Wed, 16 Feb 2022 11:04:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 11:04:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 11:04:04 +0000
Received: from [172.27.13.137] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 03:03:58 -0800
Message-ID: <79237e2d-e1d2-c6cd-975d-b28f064a2c20@nvidia.com>
Date:   Wed, 16 Feb 2022 13:03:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 net-next 03/11] net: bridge: vlan: make
 __vlan_add_flags react only to PVID and UNTAGGED
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
 <20220215170218.2032432-4-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220215170218.2032432-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2f4ea80-61c5-4fda-9502-08d9f13c0bc5
X-MS-TrafficTypeDiagnostic: MN2PR12MB4111:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB411158F48A4B38F0B24D9EE7DF359@MN2PR12MB4111.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yimwZVfrphnfFzbuxumfP6wXay233Y8nT+4ui177qYRFYBJTb527deqa7xaxfQRGWnOkyzDn8yW0Ph7IpvYDSmmRmgP7Bh5kDN/QBNvN5GagTOhN0fobL0Tz33bSQ5T7D21XTFLRB7DvLz+c+MzA9iglyuC4FCMeZDkJkw2n4Cy3/rM8TTnAh2QJAwqrwHaMcBHRiP7p6xBnYQQyrbDGprFN1jXQN7SdxOkLnBziXs6D9sKDTBMDDkuVLNre1JSrD/whj5thygm25/nlb/D9czXIOKaDCp+VJ29H84n4uPtAzWly3KOWt4/muQRTV/iuNk+3PGWuwztmSHPujqW2akViYOH7pvQR6sOX9BbRKE0O1huinE30QF1pvD+i27+lxrmyJn/ZMgenBZWLzXNLtGMZfTK6cXXjsqSVO6qXAa65KumhE6/usEzok5DilFKoY6X7L6M0jrZcCW2nhg97QHW+1nxBB9gZaxNFaOK7575MtVFLLU3RH19kUAkfbalmtRfU21HqvcK1xTf5e5lKc7W1SpU8/tgArD9+LE52ovFkoxWNpgaUZwT2B+lK/lJkX8OStvJZ4YAP7L/KKjVfTaa9qOJZT++cHG0N4bmkj3QyXwahqFis1woCUjqcTrVSPaA/l0X2we6XXtMVJEoY69VYji4PrQP9UT/UoiXkoKhjz+MrasCsEtocdP2piew9bktNwsq5CcYZezdA/pleyXDWZdR4vHI7rPv4qxitfw3f3lWa8c14sDAlPo7zsPcz
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(7416002)(53546011)(2906002)(4326008)(8936002)(36860700001)(5660300002)(2616005)(16576012)(86362001)(40460700003)(508600001)(8676002)(426003)(6666004)(82310400004)(316002)(31696002)(31686004)(16526019)(81166007)(70206006)(36756003)(83380400001)(47076005)(356005)(186003)(26005)(70586007)(54906003)(336012)(110136005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 11:04:04.6215
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2f4ea80-61c5-4fda-9502-08d9f13c0bc5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4111
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
> Currently there is a very subtle aspect to the behavior of
> __vlan_add_flags(): it changes the struct net_bridge_vlan flags and
> pvid, yet it returns true ("changed") even if none of those changed,
> just a transition of br_vlan_is_brentry(v) took place from false to
> true.
> 
> This can be seen in br_vlan_add_existing(), however we do not actually
> rely on this subtle behavior, since the "if" condition that checks that
> the vlan wasn't a brentry before had a useless (until now) assignment:
> 
> 	*changed = true;
> 
> Make things more obvious by actually making __vlan_add_flags() do what's
> written on the box, and be more specific about what is actually written
> on the box. This is needed because further transformations will be done
> to __vlan_add_flags().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3: patch is new
> 
>  net/bridge/br_vlan.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 498cc297b492..89e2cfed7bdb 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -58,7 +58,9 @@ static bool __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid)
>  	return true;
>  }
>  
> -/* return true if anything changed, false otherwise */
> +/* Returns true if the BRIDGE_VLAN_INFO_PVID and BRIDGE_VLAN_INFO_UNTAGGED bits
> + * of @flags produced any change onto @v, false otherwise
> + */
>  static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
>  {
>  	struct net_bridge_vlan_group *vg;
> @@ -80,7 +82,7 @@ static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
>  	else
>  		v->flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
>  
> -	return ret || !!(old_flags ^ v->flags);
> +	return ret || !!((old_flags ^ v->flags) & BRIDGE_VLAN_INFO_UNTAGGED);
>  }
>  
>  static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,

This patch is unnecessary and can be dropped given the next one.
