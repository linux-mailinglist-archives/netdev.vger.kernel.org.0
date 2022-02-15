Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665864B73B8
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241045AbiBOPrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:47:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241030AbiBOPqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:46:55 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56E1DB873
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 07:45:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EABnUCxRtjvq+OHvfXTa4MjO4WtvjlX8Gji65sZzCyspyOOW/ujzFVOd0H9pctxKqW2UW/tlsv+IxK0pummByZozAeGBemjBZtVkyiGRQZw3GnQez2gApK9HpyjG5rklf1POnYC3gMt6V5r6aHP/YNo88LLeQLVQS3uNZoGr8x64VIWCxw3II8E5V2xkHdsuSYdtj2DbLckjDR+PDRC2Ibe1EiUEx6Gyo52szMlRcUBLtxOhB8cqwohhk3tckUozKCJDQd2RRsYPJXQbX4w3zc+QPM2qaZxFN0xYCruPH2wvzHGf7HePDFfF+w/zex7Ygk0xWAB7Rw5NDlku/Lo9wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pgk/VV+O23oUENAZXR7O3DHejxA4WbFktk2kMZgiHK4=;
 b=e2m3xjlFwiaodukG+D/hZ0VKJs6VPv0DjtLFPjnFihS81SVyNrOkix35qjsYRinsX0PG4AiPMFAcgj49myuL4cU8sg7U/PuXxw0TidjmJl5Gla88MjyH3Hgp8s1EhrgVdiCTffgf6tGJqSWXSckcOH3OiHcdq19vL3+++RADFngj9kAGViZBehp/83ojUPQysn3SD8Le0vKUmC0uEMeUwUYo8DvDSsS76qM7HNF9QahKbyWU4Q+8Ji3+R26sxRwMwcQqJ0YGcPqkW7/X1zJBsF0O2sda4bfQtnfXRMy8KE2Gpv5M9SxfY28uWDM38+DV930IB5etT/ovT38vn0hcWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pgk/VV+O23oUENAZXR7O3DHejxA4WbFktk2kMZgiHK4=;
 b=b2bn1HTfuVTUWyJ9cNIn/e0f/yv65Z7FmGBOrjOPtwaPIls0P7eTdgMG1AvXz+omhAMAjGysU/LpGp4BLwI+Ln+BXez0A/CBaC/QmJ/ut7tYt9mYRO6lxBZ3kNqIOEKGSnVc2Na+5gZIL6bJ/uzFGFBqnkNg5zfTKigufVWUfKMN6PkFqnSCLVynzGiRwHCozzfbn7pDiR70tBQITL50Ha9UipE4I4h6KZnjES+eUvhx15UJBwqpAI5I+7q2W/gUriFl+gNB6RTfTSJ+6Sv0bVc5cyLINwcPa1rXD/fOK3nkwd3UXjEVxzjGwkEA7qiMMZd7bhdZ0B9fC1f4eupkzg==
Received: from MW4PR04CA0380.namprd04.prod.outlook.com (2603:10b6:303:81::25)
 by CH0PR12MB5369.namprd12.prod.outlook.com (2603:10b6:610:d4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 15:45:03 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::be) by MW4PR04CA0380.outlook.office365.com
 (2603:10b6:303:81::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15 via Frontend
 Transport; Tue, 15 Feb 2022 15:45:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Tue, 15 Feb 2022 15:45:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 15 Feb
 2022 15:45:02 +0000
Received: from [172.27.13.89] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 15 Feb 2022
 07:44:56 -0800
Message-ID: <49709ba6-7f4f-493d-88c9-553d7c300397@nvidia.com>
Date:   Tue, 15 Feb 2022 17:44:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
 <20220214233111.1586715-2-vladimir.oltean@nxp.com>
 <bcb8c699-4abc-d458-a694-d975398f1c57@nvidia.com>
 <20220215095405.d2cy6rjd2faj3az2@skbuf>
 <a38ac2a6-d9b9-190a-f144-496be1768b98@nvidia.com>
 <20220215103009.fcw4wjnpbxx5tybj@skbuf>
 <5db82bf1-844d-0709-c85e-cbe62445e7dc@nvidia.com>
 <20220215153803.hlibqjxa4b5x2kup@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220215153803.hlibqjxa4b5x2kup@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6f6896e-d674-4334-db9d-08d9f09a2180
X-MS-TrafficTypeDiagnostic: CH0PR12MB5369:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB53690C7D453F0441701B3F12DF349@CH0PR12MB5369.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bYxGWlh9CJBnOyYkoZJNX/dZrNGa+ay5O6mB95MPWZ6NNs21BTnsNco5eg5+imOUPQyWVJFnZ/mv3kfiN5RwdeDr3rlv3UtCGD9z/PQ/xx3qFXEm3uaX2PzUKj10nV9Uzt5bAwn7a9bD2Ua+ADEy47ZuZJ6XEBVW0PPKjgMelf5m4rL/aNbqCJJ178xEQj0fYYwbVFFuxSjVU5D0E30bB82ZhODhjDc4+v0uvTpoRJwUaWOyVX5pdnJ9bxH+PSxxQTUYItkhuapBZprO7fPvQxTuFl1CKjPSVJL80K3iD7pwJe8VCTbW/mCz/xAXt4I8Y4FsL4qv6ILkgSf5CRGDVIyYl5C121tGCMYzhokhigidKdq5mA/7d4teIhUBJXnxkZhbVWbpxSidccV3rNTG1hbFVzsoLuuc5Dqjavstj3LRwkmf3hjoILqL6d2dw5WGuMOIq28i8rl9P1nLa+i4THe/6/QADuNesWz2cFGfDbvCp1ACLkrSLXP6zH4U/al8J4Kl5eJgT4DC0pECbcThxeSqNP2n17amu6QmQMOC1VHmIF/ZzNBY6REpl0e18aOm0mcLc8ZEb1SVQPeYg3cvA5IbL1zKPrK2goV6SKsz73heolKU7WML+mFfVQQnONvFJpO/XxtI3H7jrfJAQOaC/Wum50e3O/+N//z4zHohkEUU84MUpaDr+at/nSYVSLtVwK3YIv34gltTeAy2N0OmIjpi9v4SnqZBZ/JilTtzp7oO16gavYJVqMjEGX+Yub9l
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(2906002)(86362001)(5660300002)(36860700001)(2616005)(40460700003)(31686004)(8936002)(6666004)(53546011)(36756003)(16576012)(70206006)(316002)(336012)(4326008)(186003)(26005)(6916009)(83380400001)(508600001)(47076005)(81166007)(31696002)(356005)(7416002)(16526019)(54906003)(82310400004)(70586007)(426003)(8676002)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 15:45:02.6108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6f6896e-d674-4334-db9d-08d9f09a2180
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5369
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

On 15/02/2022 17:38, Vladimir Oltean wrote:
> Hi Nikolay,
> 
> On Tue, Feb 15, 2022 at 01:08:13PM +0200, Nikolay Aleksandrov wrote:
>> +static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags, bool commit)
>>  {
>>         struct net_bridge_vlan_group *vg;
>> -       u16 old_flags = v->flags;
>> -       bool ret;
>> +       bool change;
>>  
>>         if (br_vlan_is_master(v))
>>                 vg = br_vlan_group(v->br);
>>         else
>>                 vg = nbp_vlan_group(v->port);
>>  
>> +       /* check if anything would be changed on commit */
>> +       change = (!!(flags & BRIDGE_VLAN_INFO_PVID) == !!(vg->pvid != v->vid) ||
>> +                 ((flags ^ v->flags) & BRIDGE_VLAN_INFO_UNTAGGED));
>> +
>> +       if (!commit)
>> +               goto out;
>> +
>>         if (flags & BRIDGE_VLAN_INFO_PVID)
>> -               ret = __vlan_add_pvid(vg, v);
>> +               __vlan_add_pvid(vg, v);
>>         else
>> -               ret = __vlan_delete_pvid(vg, v->vid);
>> +               __vlan_delete_pvid(vg, v->vid);
>>  
>>         if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
>>                 v->flags |= BRIDGE_VLAN_INFO_UNTAGGED;
>>         else
>>                 v->flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
>>  
>> -       return ret || !!(old_flags ^ v->flags);
>> +out:
>> +       return change;
>> +}
> 
> I'm really sorry that I keep insisting, but could you please clarify
> something for me.
> 
> Here you change the behavior of __vlan_add_flags(): yes, it only changes
> BRIDGE_VLAN_INFO_UNTAGGED and BRIDGE_VLAN_INFO_PVID, but it used to
> return true if other flags changed as well, like BRIDGE_VLAN_INFO_BRENTRY.
> Now it does not, since you've explicitly made it so, and for good
> reason: make the function do what it says on the box.
> 
> However, this forces me to add extra logic in br_vlan_add_existing()
> such that a transition of master vlan flags from !BRENTRY -> BRENTRY is
> still notified to switchdev.
> 
> Which begs the question, why exactly do we even bother to notify to
> switchdev master VLANs that aren't brentries?! All drivers that I could
> find just ignore VLANs that aren't brentries.
> 
> I can suppress the switchdev notification of these private bridge data
> structures like this, and nothing else seems to be affected:
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 6fc2e366f13a..4607689c4e6a 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -300,10 +300,12 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
>  		}
>  		br_multicast_port_ctx_init(p, v, &v->port_mcast_ctx);
>  	} else {
> -		err = br_switchdev_port_vlan_add(dev, v->vid, flags, false, 0,
> -						 extack);
> -		if (err && err != -EOPNOTSUPP)
> -			goto out;
> +		if (br_vlan_should_use(v)) {
> +			err = br_switchdev_port_vlan_add(dev, v->vid, flags,
> +							 false, 0, extack);
> +			if (err && err != -EOPNOTSUPP)
> +				goto out;
> +		}
>  		br_multicast_ctx_init(br, v, &v->br_mcast_ctx);
>  		v->priv_flags |= BR_VLFLAG_GLOBAL_MCAST_ENABLED;
>  	}
> 
> Would you mind if I added an extra patch that also does this (it would
> also remove the need for this check in drivers, plus it would change the
> definition of "changed" to something IMO more reasonable, i.e. a master
> VLAN that isn't brentry doesn't really exist, so even though the
> !BRENTRY->BRENTRY is a flag change, it isn't a change of a switchdev
> VLAN object that anybody offloads), or is there some reason I'm missing?

I agree, patch looks good to me. I see that everyone already filters the
!BRENTRY case anyway.

Thanks,
 Nik



