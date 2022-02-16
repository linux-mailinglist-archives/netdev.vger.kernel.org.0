Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6750A4B865E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiBPLBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:01:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiBPLBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:01:40 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2074.outbound.protection.outlook.com [40.107.100.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC26025CE
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 03:01:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+8+l9O1hVQfKmWZfTyqXBpEOqfTqGrtvdAMrvHMrVcahRc1K95TNxVNCZlT1/EnMlWpa4LvfzU48jYVsZpERSGZ2PZJ8F4Wz0ih79VEF1fPlzJGk2jDO/oSBr5xZ8iBAia8YlkQaTVWIA3Gx9LFDfbpg1AwA43r6fQUCO470lAL0KwochkoNRgUycZlyOaAexQsPCPe2X4WvHFISZaVTlfnMfz+8E7LigJs2qW6nq1H5ly6tcAuaeVXCgQ0Kaz3yo4zgnjG4C6NGmcaBJVaqGNVkoLvSe+lvzHIuCAx0AU7xZiJb7iXtrsLX4GIgRH154/o44Aw5dgzjvmS0DB9QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JoaM7vJSnQhT35H+JdZZaBWjATpCPhtDN6EkyrMOM94=;
 b=TdKEA/EUanrdV7JouRS1IdWr3IoSEg05R3AItZVmAGZ7N3bJUrCEzmtxFlXdbdZLbwFw29K6UdT2Ru97mnH057uKQrdTrtN82KpzF5V6liwIVR/9SQReF8bWT6cegQAzcQGBVzYDUGyb6ianmsQ9Na5VD3oACPMBWU4gN0FfYXa4oyZyOJssszaGaALVjKYigbWfvjVhF0A/eirWpTY5SbLSL3KruzwMjno2dEkBw+r/xFrz/bQwlSzmLUEPzfirvWUQrUq962V8bPx9oWyzwd6XO5TKeokfZvwKw/+t2PZD4Z5EvJD+4UhLpEJ+nk3rbPMSm2tF55nh/jGeJ9l1fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JoaM7vJSnQhT35H+JdZZaBWjATpCPhtDN6EkyrMOM94=;
 b=LTmLWmowIGGZaoXPkW7MmFxLSG4x+T6J6cJR81h7DjSGRO4QZanTJ4M/Hj6ke0adzSSJYnjhcqqkE0SRMW3AQ3lb7G8LO/efJy21D85sCaOWs2oqQv0Pwg9m0kCOJ3LqgCKzIECxoPhkoTKmH5xMt8ToCO1wXlPiWmovxJYxPx9WKXM696zbNqxP1Nbi/RJjiVgKPuR+QPklqCpj/UDsmYeRDUW3ya4c686Tmdce6C5uxz/IujvaFU1TgoD3+WdqZzzltvCnqv3Zsn3GH7ONAjLoN6YYEJzrziLq91vkpRcnlNTDP3JUqCZq2HJjhofgu+68oB0fzlJ4pCEH0e3VBA==
Received: from DM5PR07CA0061.namprd07.prod.outlook.com (2603:10b6:4:ad::26) by
 BL0PR12MB5523.namprd12.prod.outlook.com (2603:10b6:208:1ce::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 11:01:24 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::71) by DM5PR07CA0061.outlook.office365.com
 (2603:10b6:4:ad::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Wed, 16 Feb 2022 11:01:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 11:01:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 11:00:38 +0000
Received: from [172.27.13.137] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 03:00:31 -0800
Message-ID: <630eb889-743c-c455-786e-ce2e58174ea9@nvidia.com>
Date:   Wed, 16 Feb 2022 13:00:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 net-next 02/11] net: bridge: vlan: don't notify to
 switchdev master VLANs without BRENTRY flag
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        "Tobias Waldekranz" <tobias@waldekranz.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
 <20220215170218.2032432-3-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220215170218.2032432-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 860eedb4-2ee3-4c87-fc3d-08d9f13bac77
X-MS-TrafficTypeDiagnostic: BL0PR12MB5523:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB5523D07D663E4F673E2AC054DF359@BL0PR12MB5523.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LdIJ8oeSHzmQC7twgwtGcoDoDFY3MgSmN3/PfAvLdG4G+91LeA1SWrVa/88DOdTuOPsRFVlCxEg4fCSWKmTRiMrYc6GPUxbX50zF6P/h/Te1ZmD1oQpNfJfmpSfZMx4biu2Xbs6H+cvHgRthd5K8qNVXp21fSKcrFCIUa0Jfo7ZnpjBC4gDHUDw56EzXS8o2/QIbKDESQSTH/Oqj0V5G85fEXAcWUQkj1t8qINQ7Xj/EdKvTv30MGcpDWWiKEN8aAiL3shKxBuTiFQ+2clmW+CTFSGrIKea2sYMD/NZ6vCtdT2yGnkWeEu8vHJq+vZ89juiQhtKEaCZaUxW1zrRZypS7I54nnSY/LgLFfFxxGuMnizpIcKvuvbaZH/M765nLuIOpSdEJ6T1JSa9H8mO9H1jy+RdTiQWVwvGvIBWg4+QtsB63jC5CsJCw3oIaEkJVq2sfheCOQeTpL7pQqDkQRXFn3rdCwtvxE8B9X2590bdMN67eB7gMZoLedyrC7bb35XwvuZk+8Sc5PKeUWW60H2Tqp3yLolm9hxmP4T0XDYyFnwCpoHwQ/Ne/QoinuB+r8drWTNmWZ19FBYxuFelYf8V+CZ1UDM5Ih0Is4JAxMOElgIgqKlcZpjGeDU9tx6P51J2KQfO6pdjqIdcDQ7kozZalRfyUxEz3lyAenQI9pd5wf8TddSUhyfDw6zhJeIWLFRwkENpXlIGZALsK37ohm4pfL5ntLeLIHu8i/vMaDFG8BRe1QE810quMkZ9Pmn4u
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(53546011)(336012)(426003)(8936002)(36860700001)(86362001)(31696002)(356005)(81166007)(7416002)(2616005)(47076005)(2906002)(26005)(186003)(16526019)(5660300002)(36756003)(83380400001)(31686004)(82310400004)(6666004)(508600001)(110136005)(54906003)(8676002)(4326008)(70586007)(70206006)(40460700003)(16576012)(316002)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 11:01:24.7138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 860eedb4-2ee3-4c87-fc3d-08d9f13bac77
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5523
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
> When a VLAN is added to a bridge port and it doesn't exist on the bridge
> device yet, it gets created for the multicast context, but it is
> 'hidden', since it doesn't have the BRENTRY flag yet:
> 
> ip link add br0 type bridge && ip link set swp0 master br0
> bridge vlan add dev swp0 vid 100 # the master VLAN 100 gets created
> bridge vlan add dev br0 vid 100 self # that VLAN becomes brentry just now
> 
> All switchdev drivers ignore switchdev notifiers for VLAN entries which
> have the BRENTRY unset, and for good reason: these are merely private
> data structures used by the bridge driver. So we might just as well not
> notify those at all.
> 
> Cleanup in the switchdev drivers that check for the BRENTRY flag is now
> possible, and will be handled separately, since those checks just became
> dead code.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3: patch is new
> 
>  net/bridge/br_vlan.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index efefeaf1a26e..498cc297b492 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -284,9 +284,12 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
>  		}
>  		br_multicast_port_ctx_init(p, v, &v->port_mcast_ctx);
>  	} else {
> -		err = br_switchdev_port_vlan_add(dev, v->vid, flags, extack);
> -		if (err && err != -EOPNOTSUPP)
> -			goto out;
> +		if (br_vlan_should_use(v)) {
> +			err = br_switchdev_port_vlan_add(dev, v->vid, flags,
> +							 extack);
> +			if (err && err != -EOPNOTSUPP)
> +				goto out;
> +		}
>  		br_multicast_ctx_init(br, v, &v->br_mcast_ctx);
>  		v->priv_flags |= BR_VLFLAG_GLOBAL_MCAST_ENABLED;
>  	}

At some point we should just pass the vlan struct to the switchdev handlers
and push all the switchdev-specific checks in there. It would require some
care w.r.t kconfig options, but it should be cleaner.
The patch looks good.

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
