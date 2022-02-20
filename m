Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7654BCEF8
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239053AbiBTOaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:30:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiBTOaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:30:12 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F4540E41
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:29:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2HKwXEU+NUrhkU50dnE12vc0uhX7Rz1KRzxyFE3yh+C67/9nnn/t2dLnASm4tK0HgsYHzDkfe9St5TZRe5qvHn7OGa8QhHbdCRJPH8eTqKyaivdTaFQAlI/infKUuU4yDVffjjQEEudLh4Uc8ip24EVbKSvM0iTBuLm4ZEF4xwFVibHEmfR8Ct9+02eSvAxu+Y6fqTBRSifml9pinbtjRk8uxGSOnnWZ1phWv9+ywTHW4TJm0bP4gjJIxilN0oBj6xb4GF2LhuiNEuh6NJdWeV7FZnrQu95h1oo8Mg/9SRC2VjbOPyMWbb3QDfuMdIPJK9fdP/vI3JfkqxWYhRUxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lsCvc7ulUT9kEA/XdFXOov3K0c1sEFB59uYkUNOlJ78=;
 b=XM5tQnd8peMhuKmmu0KgQ4uOdzG3LSletZvSpz77JKGD3lS7lTH9pFDxIz9GARGAVr6VbRgnW7Jb91WsjmyoMH2VsoNJgaQjleed0rVwQUWqj6kQJRSaIuHar1RInmMD/vnMmwl90gmjsuc66B9GuhlM+C8riR73mcvEW7id9tO+tKo2yL+QjDSoG6zFmkSku+eQggInqSWaUXQkVKY3uw+iTI1i5TxnfDgVjppNnl8dhtT1iV4sO7dOw/irnk7+kfJvRRfephwase1PbrWweqw0N8+T0YbxiI8CtCjVEMOG+tCKAsOWYvlEEgYV3wx3TooI5+wGEjEAUxeizNH82A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsCvc7ulUT9kEA/XdFXOov3K0c1sEFB59uYkUNOlJ78=;
 b=iDqlYbNAyBEC+wOmA47UqmNV4IIVeSLWkRwuJQ0tVY6Tl279sDYA205ORzXPz3Qs+tiaKJzb8F3bqS/H9cc6+6Af+EJhMXbUjGt67SIFnRqcG2/qUujEr6L4APPfcc6CRKczuPsbxzOpJnVWbOVGN1kA27CP6FcMnZFe9TDm22C7EaMTNJSnBHrEI9JIeaeAl3I3cncz80tBaW1KpvFJp6Tf/2wbHgtm/hXcVo4AwvDvc4ZSUUuJez08+0cDZQsG7qFV2COWKh3XVB5eYleBQPhOkIXh+jzNGRae04HEStEHvLY71e/vQPSr8J6Pct95oP4isI/G4ESmA0McKJqF7g==
Received: from MWHPR04CA0028.namprd04.prod.outlook.com (2603:10b6:300:ee::14)
 by CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sun, 20 Feb
 2022 14:29:49 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ee:cafe::10) by MWHPR04CA0028.outlook.office365.com
 (2603:10b6:300:ee::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Sun, 20 Feb 2022 14:29:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 14:29:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:29:48 +0000
Received: from [10.2.163.174] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:29:44 -0800
Subject: Re: [PATCH net-next 06/12] rtnetlink: add new rtm tunnel api for
 tunnel id filtering
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
References: <20220220140405.1646839-1-roopa@nvidia.com>
 <20220220140405.1646839-7-roopa@nvidia.com>
Message-ID: <c2a8dfad-1be8-1bef-4c31-f2c45ba99e6b@nvidia.com>
Date:   Sun, 20 Feb 2022 06:29:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220220140405.1646839-7-roopa@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4be738c-8a3e-4860-64a6-08d9f47d733b
X-MS-TrafficTypeDiagnostic: CO6PR12MB5427:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB542786AA37E882CAED9D9148CB399@CO6PR12MB5427.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Um22CjC1CWFzRQglSygLSqHMLyNaCaC15ndqviEeXUJM3sYRK0gTc+5dFGGKgi+XHKWH/DOfQiValO6Io+LtbDHrWPOUi22YqFjt/4G8vV6Z4GrxB4iII2nW+bUyBQgDkRSgrbrjkKNp1bgzUBi+yvataXaF7knQdjmKQEKcG00VZgpBX4HVs7eB5tToQlmSoyjAVL2j53mwwWEmSDVefTTog9nrHoGRPXvB/6G5tQufxhCBFtukaXlduuq6it0hUDhEF1fcF2z29Wga1aapJBKvzidsqjn6SsOVpiNJn0W4C/pDD1hfFEGWIWRrAN8PVN9JhdtnU4SpLc7Zj/nZVeUUFPKiNA7Jq/OMGyQb6TFz6i16/k//77kQ9vQwI+PrassC/OipniLjlnWOiuVB8gExuSwQClLbAGj1hRJFccvjztnI0WNcEqq6oZMnMI6kuWwHV6QTTfN/DcN41P20eUe3gLXZ4LAnNYl0HLonA7TQ4BoWBbjQSC1O9JQAgKtrzIAXfvbkV8l2HFyAhu/5U2oBNhGBGPS/hW808ZGAaIflIGSpj4tv1FZM8kFms8CYMVjl0F7p+qeQWvzxuP5TkxOMur5DXWLqwtDzV/7SHSp/NVsp1QvYcj3sQLEUiV7hiK7Ca6i8FUejRDzJNwLu3Sh6B0OwTob86UkjQ+IfR9wjxDHsvmWxAj6USOWMW2crvzJ0Wog5XJAzg4PW7ClW5nxhGfu3abPUyPRdjGrSzSBXM8lwAe4rbO0W5L8XWpEI
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(8936002)(356005)(81166007)(53546011)(31686004)(5660300002)(40460700003)(6666004)(2906002)(31696002)(82310400004)(86362001)(8676002)(508600001)(4326008)(36860700001)(83380400001)(47076005)(36756003)(70206006)(16526019)(70586007)(26005)(186003)(426003)(316002)(336012)(54906003)(2616005)(16576012)(110136005)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:29:48.9903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4be738c-8a3e-4860-64a6-08d9f47d733b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5427
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


On 2/20/22 6:03 AM, Roopa Prabhu wrote:
> This patch adds new rtm tunnel msg and api for tunnel id
> filtering in dst_metadata devices. First dst_metadata
> device to use the api is vxlan driver with AF_BRIDGE
> family.
>
> This and later changes add ability in vxlan driver to do
> tunnel id filtering (or vni filtering) on dst_metadata
> devices. This is similar to vlan api in the vlan filtering bridge.
>
> Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
> ---
>   include/uapi/linux/if_link.h   | 26 ++++++++++++++++++++++++++
>   include/uapi/linux/rtnetlink.h |  9 +++++++++
>   2 files changed, 35 insertions(+)
>
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 6218f93f5c1a..eb046a82188d 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -712,6 +712,31 @@ enum ipvlan_mode {
>   #define IPVLAN_F_PRIVATE	0x01
>   #define IPVLAN_F_VEPA		0x02
>   
> +/* Tunnel RTM header */
> +struct tunnel_msg {
> +	__u8 family;
> +	__u8 reserved1;
> +	__u16 reserved2;
> +	__u32 ifindex;
> +};
> +
> +enum {
> +	VXLAN_VNIFILTER_ENTRY_UNSPEC,
> +	VXLAN_VNIFILTER_ENTRY_START,
> +	VXLAN_VNIFILTER_ENTRY_END,
> +	VXLAN_VNIFILTER_ENTRY_GROUP,
> +	VXLAN_VNIFILTER_ENTRY_GROUP6,
> +	__VXLAN_VNIFILTER_ENTRY_MAX
> +};
> +#define VXLAN_VNIFILTER_ENTRY_MAX	(__VXLAN_VNIFILTER_ENTRY_MAX - 1)
> +
> +enum {
> +	VXLAN_VNIFILTER_UNSPEC,
> +	VXLAN_VNIFILTER_ENTRY,
> +	__VXLAN_VNIFILTER_MAX
> +};
> +#define VXLAN_VNIFILTER_MAX	(__VXLAN_VNIFILTER_MAX - 1)
> +
>   /* VXLAN section */

just noticed, this comment should move up. will include in v2


