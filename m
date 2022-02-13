Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E789F4B3ABD
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 11:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbiBMKNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 05:13:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiBMKNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 05:13:38 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BBC5D18A;
        Sun, 13 Feb 2022 02:13:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oH7iO0wngcYdonjZe8aq1A7HOAAh1Sb2GwdHzGiYBXpQlYiubQ7IpnAC7q79z0hWwyeLnpQdlBflh1HBzePrPIFOyW11m1rcVw+zxAWpiQr53SVECUVePsY56x03MjiQXhU/3mxSRz7Z6jQWisSrxhmUu91/IbG9Xpnhfi98ATzTSePzawF0qR4qdt+z0LkWQrAcOQ7ZmalLrbniJmGqL1Wc0qGekNwb4Wj/Nf9Xt2uJspcO3kIjrm1JVMIWd2Rs88a8DXpXjD4pzN4Hkg9Fbhye0gphzdgdohs7HWLp84Kj6AFmwauiPH/12yZWE/5jgvOp+VhNA5dLm7qufyncng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QDsgPaGQAZTLjsQ3v5s2KKvlDQ1c0mF7+Owo6M92m4E=;
 b=RZYsx+LWlulf69qZ/InXdYQSGxCX834X1P7rdnQzUDa4Afw/oBW5Sz+GFDZC+4iXjLBp1UhmmmWLmJMPxuXwTECYS/4H2jEIzJebqz73jwKuXPFno/YQdHbia9rYv7U0Zgp8mO3N0DHMaopC01448QIVq7huY93Z0b5AW2ycxsTuI9UBMFA/nNeJJZ6qSWcQkcRHn3Eona+FOcbBPgwMsFsiRAph/VpLf0bQJvRUP7Z3XTEJNoy2vJPjJxGKofTJyWCXcQNlm8EtogjSkkLVibP2peo+PtF6Oz5RH3jiOIFXCjP/tgBMMBX7ySvz+39b8RBAlu0dhxZSoKu8JPExxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDsgPaGQAZTLjsQ3v5s2KKvlDQ1c0mF7+Owo6M92m4E=;
 b=SOlhjmbKRfs1zTc19LqSeOomHOg4KrbuNt/Do6kDXTFyquCZkhB+hzCcGThz4S5NvdCDdMouA2Q+l7rmuf7Agj9rJGyaau3q1ZYsXyXaEup2rRbxm8nrChjXnttucn6lbMM8gDVgBz8XGcDJlW6w2OYw96tEYdFCRc9ONOIscB3nGi/BQgQRMbe5oSzL5uPd0pX8PAF27acQ/vFl2fC57zGxR+kDJx5JkR/HrGPrzUqSOMZoVP3NdPy30OK7VgQUjAvn74NtyfaxKrG7vpP0llfxgCZsiIUVbJvnsB+CYVoN3S6EM/Jq4KOwI6nyWwq2dFR4U3R9KxAcEys4hAVobA==
Received: from BN0PR02CA0026.namprd02.prod.outlook.com (2603:10b6:408:e4::31)
 by MW3PR12MB4586.namprd12.prod.outlook.com (2603:10b6:303:53::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sun, 13 Feb
 2022 10:13:31 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::20) by BN0PR02CA0026.outlook.office365.com
 (2603:10b6:408:e4::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15 via Frontend
 Transport; Sun, 13 Feb 2022 10:13:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Sun, 13 Feb 2022 10:13:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 13 Feb
 2022 10:13:29 +0000
Received: from [172.27.1.51] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 13 Feb 2022
 02:13:25 -0800
Message-ID: <52b71034-d35a-75cd-cb7b-e7a1d355b361@nvidia.com>
Date:   Sun, 13 Feb 2022 12:13:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: bridge: Slightly optimize br_stp_change_bridge_id()
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
References: <73f674075ae5279e3d2fa07d61a0a75bc50790f3.1644659879.git.christophe.jaillet@wanadoo.fr>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <73f674075ae5279e3d2fa07d61a0a75bc50790f3.1644659879.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: deac7e73-b56a-416e-9075-08d9eed97c00
X-MS-TrafficTypeDiagnostic: MW3PR12MB4586:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4586213BFD43D6FF9A274003DF329@MW3PR12MB4586.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 49onjw2kRw9N2vQyeQGDUTl0pwjmyd69ih7Orrla/c5ngTpmWW+jh29sGKXhaPFJIAMZ9Mw4t6/jxx8/7qTocynihHz13mmUj+pO8lF8kdHUz/K2WxwH16aFwVoiqXadloTB1nh0h7uZS4AybRp81jO5GTtvD/uO/Rf+X2jYPUIu6X97dcIa/oIT+AXP2/hu0BG3wM/rULmrpRrMLFMApG23fLiqygHGVj1f2w8jdCloSe2vz/mSo59VxwIfaXgxxfRPtwdInLThFUjrQrlbvsoP7xmTnCv7EWVtQVYmeUG/5fukENf16KEib1724ik9yEbWskvfh4z/BfoQkJucO5HwuvjOZrlCmOb4M54Mal2I9MEicZ6Fbs0IoKN7xo6VvcWfnxtTnflttI5IZW4W7wnHi/31/p/YusSmW4Qk2Rk0dTgO5f5C0nctAxLBv1hFm9c3qeuA9WY7wITKx+3cptr+dm6YnclsU3nSokpfo76yIPXarnDdp9Yv8zwjEhYDuawin37erg5VScGQRnO+Xs6zqRKNlPE3YbGQe9JRPTp/YgXMG8UFH+hQsJHDHjiKG7xmodjlDMs5GzpPE5re3emPzN4P2pKnDayvH7y8C6TC+fyzWxNnyypA+5HdKsqGeJDzRGKzMSyydRnljXynrVZXkBdspBGHiMBX4ZPAV60Werl90wsyROaq6hXXN/1+MAcR1SQHiRTzYX+DppOsE3pURDkJ/cKoGq6+gwcgjGRTd9+arYG9ZTqwC4D+T33LXfM0typ05xeA+UOWar95CwMBqbQo6iNJpEkp57zSVeQ=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(2906002)(81166007)(356005)(5660300002)(6666004)(70206006)(316002)(83380400001)(336012)(31686004)(186003)(8676002)(26005)(426003)(31696002)(16526019)(16576012)(53546011)(2616005)(4326008)(70586007)(8936002)(40460700003)(47076005)(54906003)(36860700001)(86362001)(110136005)(36756003)(508600001)(82310400004)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2022 10:13:30.3486
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: deac7e73-b56a-416e-9075-08d9eed97c00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4586
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/02/2022 11:58, Christophe JAILLET wrote:
> ether_addr_equal_64bits() can easy be used in place of ether_addr_equal()
> here.
> Padding in the 'net_bridge_port' structure is already there because it is a
> huge structure and the required fields are not at the end.
> 'oldaddr' is local to the function. So add the required padding
> explicitly and simplify its definition.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch is more a POC for me.
> 
> I'm unsure that using ether_addr_equal_64bits() is really useful. The
> speedup should be mostly un-noticeable.
> 
> To make sure that we have the required padding, we either need to waste
> some space or rely on the fact that the address is embedded in a large
> enough structure. (which is the case here)
> 
> So, it looks fragile to me and not future-proof.
> 
> Feed-back highly appreciated to see if such patches are welcome and if I
> should spend some time on it.
> ---

This is slow path, more so as you've noted above the change is fragile and someone
can easily miss it, I appreciate the comments but for this case I'd prefer to
leave the code as-is to keep it obviously correct and avoid future problems.

Thanks,
 Nik

>  net/bridge/br_private.h |  5 +++++
>  net/bridge/br_stp_if.c  | 12 +++++++-----
>  2 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 2661dda1a92b..2f78090574c9 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -363,6 +363,11 @@ struct net_bridge_port {
>  	unsigned char			config_pending;
>  	port_id				port_id;
>  	port_id				designated_port;
> +	/*
> +	 * designated_root and designated_bridge must NOT be at the end of the
> +	 * structure because ether_addr_equal_64bits() requires 2 bytes of
> +	 * padding.
> +	 */
>  	bridge_id			designated_root;
>  	bridge_id			designated_bridge;
>  	u32				path_cost;
> diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
> index 75204d36d7f9..1bf0aaf29e5e 100644
> --- a/net/bridge/br_stp_if.c
> +++ b/net/bridge/br_stp_if.c
> @@ -221,9 +221,11 @@ int br_stp_set_enabled(struct net_bridge *br, unsigned long val,
>  /* called under bridge lock */
>  void br_stp_change_bridge_id(struct net_bridge *br, const unsigned char *addr)
>  {
> -	/* should be aligned on 2 bytes for ether_addr_equal() */
> -	unsigned short oldaddr_aligned[ETH_ALEN >> 1];
> -	unsigned char *oldaddr = (unsigned char *)oldaddr_aligned;
> +	/*
> +	 * should be aligned on 2 bytes and have 2 bytes of padding for
> +	 * ether_addr_equal_64bits()
> +	 */
> +	unsigned char oldaddr[ETH_ALEN + 2] __aligned(2);
>  	struct net_bridge_port *p;
>  	int wasroot;
>  
> @@ -236,10 +238,10 @@ void br_stp_change_bridge_id(struct net_bridge *br, const unsigned char *addr)
>  	eth_hw_addr_set(br->dev, addr);
>  
>  	list_for_each_entry(p, &br->port_list, list) {
> -		if (ether_addr_equal(p->designated_bridge.addr, oldaddr))
> +		if (ether_addr_equal_64bits(p->designated_bridge.addr, oldaddr))
>  			memcpy(p->designated_bridge.addr, addr, ETH_ALEN);
>  
> -		if (ether_addr_equal(p->designated_root.addr, oldaddr))
> +		if (ether_addr_equal_64bits(p->designated_root.addr, oldaddr))
>  			memcpy(p->designated_root.addr, addr, ETH_ALEN);
>  	}
>  

