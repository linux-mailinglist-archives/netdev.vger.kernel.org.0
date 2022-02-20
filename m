Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2DC4BCEF9
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242209AbiBTOMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:12:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240285AbiBTOMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:12:41 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91663EAA
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:12:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTLzYL3Ud5pn1lpbmdoo3SDL0Rn0FGBBF53YXOGrcQ3n02yEcmN1mIZ6cTqyG0pGy/nCzoblGaeR8Fc0yAi+e/FVJOf2kp5JVqO+bVkMD30tMv4rJfBaFFX3vXS7pkn1q9AtNJl+nImS/azIhGgY2uonuOpoOOnydZoQvYLQwP7fRW5az0tW7b/h+Ta+j4fRXWjEyBEjrJkcaUuwpGWO/5eBCADdK/kFBQ1GGsjjXAvCF+0Jp1iWuHXYaGmUTdHkqO0rBL2UqiFLiOtgpqisWduaQaIqNQ8cWxAI3cHMuwU+tVTe74L2ViFsvnyq1S8Yh4uE7JLsyGmgZ9ZV0NK0qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HbVAeFrD5lM607ZoxtvUfskPxvEzDTP4PFVoKnB/zDw=;
 b=JylehmCvX276ogNPKBuXxEc9oVt6ArpvhHjMHx8HW3qfeQEsfK/m52kmaOOeY06dQ06NK7Lmlluo0iN13Bielc31OG18U8FRSZwW+rPnzQl4ySAr+wkdfxRXG+V26CZ4zdG3RX/sSbsaeGXf2UmF2wBzlHyjjmjUJA6brtWPFMBgAsGtG4fKm6VLzk5TXUAQmjJvXJLmUajb8636IAhrsXZpz1+UtLB8n7T4/B5mHumhqPdSuggCZ4wA/3mD4Du8eIlVBwxmSqDY+txCejGDNTYIwf3Kfhuw5h2gTRDyY8RK+IjEYx0YwAfn3LQmjXWh4bc9Qrd6j/2AaXHTc2fdGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HbVAeFrD5lM607ZoxtvUfskPxvEzDTP4PFVoKnB/zDw=;
 b=IsWBt3wlnCxr6AQX8xYLgq7EVZ9xJStdg0X0daQVp16j9T0Ja2n0eQZIyRVx3Q38KphG+pFkUyvYEX2Ub2nQ68Z7czwxkrUFqtn98ojKlFC6epQfUboEq0pm1xNAhOov7rusMiDCZQpFHA7aAnrS87J8PnUP4fJrYqVvVlawYH2tzdpasZOueB3XJn4gHfrPsFG2h4jTj+O4rwCqyRnEJRKkunSpxpYgiCNrdOPhP9FJC14oH9vX+tFQ/vwQxz/Z8MjbUypAOOmxTdG5GxOXQ/+N2w85FonZJUBSQtyd3ESDWm3NgDGHMBtWVGfIx52iGBe8CTM0Cd7Uz8PJJXpJJw==
Received: from BN9PR03CA0941.namprd03.prod.outlook.com (2603:10b6:408:108::16)
 by CH0PR12MB5372.namprd12.prod.outlook.com (2603:10b6:610:d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sun, 20 Feb
 2022 14:12:19 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::41) by BN9PR03CA0941.outlook.office365.com
 (2603:10b6:408:108::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Sun, 20 Feb 2022 14:12:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 14:12:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:12:17 +0000
Received: from [172.27.11.128] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:12:12 -0800
Message-ID: <60a36c9a-a989-1e6a-c2fe-d996b1e8b3ae@nvidia.com>
Date:   Sun, 20 Feb 2022 16:12:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 12/12] drivers: vxlan: vnifilter: add support for
 stats dumping
Content-Language: en-US
To:     Roopa Prabhu <roopa@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
References: <20220220140405.1646839-1-roopa@nvidia.com>
 <20220220140405.1646839-13-roopa@nvidia.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220220140405.1646839-13-roopa@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29db6098-f5ee-4702-6daa-08d9f47b0124
X-MS-TrafficTypeDiagnostic: CH0PR12MB5372:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB53725A759F5EC68B2F350C2ADF399@CH0PR12MB5372.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lFMFdYWtWfn/JITB2BxfqQB2JrGiiNoWH2FQpoOodV8EGD3TW766KQWHEbst0guUc2dCWIcELWLXEzWK7r+rN7B1LMGPMSNtxozqGDOvQRsbUkeCE4qCIrkQBj98IBuAatB3yGsu8vkrT+trQs7vavbew9V1qEAq+SXFCLzPjGuMxKc5yUbazs6NJE3mIEeLmS67oF5jeUXJ9psva2tRsjyRvBfCkTvkjSw8Fj4SRj8GgxJb2KsWZg+9cR5joe1V/jrwGVRM28tWQ2NFr777/yWQHczh17h+/roeMskPjl7q4vgnJNSNwZQpSJDMxRylFHsnEo3G0RxpxgaTj9r6Ak+ko4qY/Jo/IAzWok2slWrkbTFvnPHU9KnHwuVCwfLit9Pa6CaxKwh3lx+78CGD+eq9gIqenTlXWSTo3ZHY+QOaszkv1Ktl7r29CjRXbRYRNBgNyjGgyH20g8ItssmRDVWD6zvDJi5IaAodIIV37jlNaF2B9Ih9j3bCjaxV3MAt0AmYHUP3F5R6p7+tezs7aOOxozOTKtoHt/CYycp3ep9O+qgf5q6hmXlPhCUAlYHsAFKaffo5koibXYLpO6aYVUCnorAe5Z2182A577oWFO2zaF6m1t6/kizydvkHHVOeADie5c/A3MeubU8qvnIUQkg3r9UgVw04nDDphtJdTAmNtE76VkBPXLnfhWy9XOPXRpPNMta6lIjExluwdZNlDvKzVND5f/tN4zBUM0QeIpCh2hgNFpaQFCoKjjwl3v07
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8936002)(36860700001)(2906002)(36756003)(5660300002)(4744005)(4326008)(31696002)(8676002)(86362001)(70206006)(47076005)(83380400001)(40460700003)(26005)(186003)(16576012)(426003)(2616005)(82310400004)(16526019)(336012)(508600001)(6666004)(81166007)(54906003)(356005)(31686004)(70586007)(110136005)(316002)(53546011)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:12:18.5236
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29db6098-f5ee-4702-6daa-08d9f47b0124
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5372
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/02/2022 16:04, Roopa Prabhu wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Add support for VXLAN vni filter entries' stats dumping.
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
>  drivers/net/vxlan/vxlan_vnifilter.c | 55 ++++++++++++++++++++++++++---
>  include/uapi/linux/if_link.h        | 30 +++++++++++++++-
>  2 files changed, 79 insertions(+), 6 deletions(-)
> 
[snip]
> +/* Embedded inside LINK_XSTATS_TYPE_VXLAN */
> +enum {
> +	VXLAN_XSTATS_UNSPEC,
> +	VXLAN_XSTATS_VNIFILTER,
> +	__VXLAN_XSTATS_MAX
> +};
> +#define VXLAN_XSTATS_MAX (__VXLAN_XSTATS_MAX - 1)
> +
>  /* VXLAN section */
>  enum {
>  	IFLA_VXLAN_UNSPEC,

xstats leftover should be removed
